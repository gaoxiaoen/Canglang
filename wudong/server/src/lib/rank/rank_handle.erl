%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 三月 2017 下午8:10
%%%-------------------------------------------------------------------
-module(rank_handle).
-author("fengzhenlin").
-include("rank.hrl").
-include("common.hrl").
-include("server.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([
    handle_cast/2, handle_call/3, handle_info/2
]).

-export([
    update_rank_db_by_type/2,
    get_rank_data/1,
    wp_update/0,
    rank_timer_update/0,
    rank_designation/1,
    reload_rank/1
]).

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%获取排行榜
handle_cast({get_rank, Type, Page, MyKey, Sid}, State) ->
    RankList =
        case erlang:get(Type) of
            [] ->
                R = rank:get_rank(Type),
                erlang:put(Type, R),
                R;

            CacheReply ->
                CacheReply
        end,
    RankList1 = get_page_list(RankList, Page),
    WpPlayerList =
        case ets:lookup(?ETS_RANK_WORSHIP, MyKey) of
            [] -> [];
            [MyWp | _] -> MyWp#rank_wp.wp_player_list
        end,
    F = fun(Rank, L) ->
        #a_rank{
            rank = Order,
            rp = RP
        } = Rank,
        #rp{
            pkey = Pkey, sn = Sn, pf = Pf,
            nickname = Name, lv = Lv, career = Career,
            vip = Vip, realm = Realm, guild_name = GuildName, guild_key = GuildKey,
            cbp = Cbp, dvip = Dvip
        } = RP,
        {BeWpTimes1, IsWp} =
            case ets:lookup(?ETS_RANK_WORSHIP, Pkey) of
                [] -> {0, 0};
                [RankWp | _] ->
                    #rank_wp{
                        worship_list = WorshipList
                    } = RankWp,
                    case lists:keyfind(Type, 1, WorshipList) of
                        false -> {0, 0};
                        {_, BeWpTimes} ->
                            case lists:member({Pkey, Type}, WpPlayerList) of
                                false -> {BeWpTimes, 0};
                                true -> {BeWpTimes, 1}
                            end
                    end
            end,
        RPInfo = [Pkey, Sn, Pf, Name, Lv, Career, Vip, Realm, GuildName, GuildKey, Cbp, Dvip, BeWpTimes1, IsWp],
        {RankData1, RankData2, RankData3} = get_rank_data(Rank),
        [[
            Order, RankData1, RankData2, RankData3, RPInfo
        ] | L]
        end,
    RankList2 = lists:foldl(F, [], RankList1),
    RankList3 = lists:reverse(RankList2),
    Len = length(RankList),
    MyWpTimes =
        case ets:lookup(?ETS_RANK_WORSHIP, MyKey) of
            [] -> 0;
            [MyRankWp | _] -> MyRankWp#rank_wp.worship_times
        end,
    MyRank = rank:get_my_rank(MyKey, Type),
    {ok, Bin} = pt_480:write(48001, {Type, Page, MyRank, MyWpTimes, Len, RankList3}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%膜拜
handle_cast({rank_wp, Type, Pkey, MyKey, Sid, Pid}, State) ->
    MyWp =
        case ets:lookup(?ETS_RANK_WORSHIP, MyKey) of
            [] ->
                #rank_wp{
                    pkey = MyKey
                };
            [Wp | _] -> Wp
        end,
    BeWp =
        case ets:lookup(?ETS_RANK_WORSHIP, Pkey) of
            [] ->
                #rank_wp{
                    pkey = Pkey
                };
            [Wp1 | _] -> Wp1
        end,
    HaveWp = lists:member({Pkey, Type}, MyWp#rank_wp.wp_player_list),
    Res =
        if
            MyWp#rank_wp.worship_times >= ?MAX_WORSHIP_TIMES -> {false, 2};
            HaveWp -> {false, 3};
            MyKey == Pkey -> {false, 4};
            true ->
                NewMyWp = MyWp#rank_wp{
                    worship_times = MyWp#rank_wp.worship_times + 1,
                    wp_player_list = MyWp#rank_wp.wp_player_list ++ [{Pkey, Type}],
                    is_db_update = 1
                },
                ets:insert(?ETS_RANK_WORSHIP, NewMyWp),
                {NewWpList, BeWpTimes} =
                    case lists:keyfind(Type, 1, BeWp#rank_wp.worship_list) of
                        false -> {[{Type, 1} | BeWp#rank_wp.worship_list], 1};
                        {_, OldTimes} ->
                            {[{Type, OldTimes + 1} | lists:keydelete(Type, 1, BeWp#rank_wp.worship_list)], OldTimes + 1}
                    end,
                NewBeWp = BeWp#rank_wp{
                    is_db_update = 1,
                    worship_list = NewWpList
                },
                ets:insert(?ETS_RANK_WORSHIP, NewBeWp),
                {ok, NewMyWp#rank_wp.worship_times, BeWpTimes}
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_480:write(48002, {Reason, 0, 0}),
            server_send:send_to_sid(Sid, Bin),
            ok;
        {ok, MyT, BeT} ->
            {ok, Bin} = pt_480:write(48002, {1, BeT, MyT}),
            server_send:send_to_sid(Sid, Bin),
            Pid ! {add_coin, 2000, 512},
            ok
    end,
    {noreply, State};

handle_cast(_Info, State) ->
    {noreply, State}.

handle_info({init}, State) ->
    Sql = io_lib:format("select pkey,worship_times,update_time,worship_list from rank_wp", []),
    L = db:get_all(Sql),
    F = fun([Pkey, Wt, Ut, Wl]) ->
        Wp = #rank_wp{
            pkey = Pkey,
            worship_times = Wt,
            update_time = Ut,
            worship_list = util:bitstring_to_term(Wl)
        },
        ets:insert(?ETS_RANK_WORSHIP, Wp)
        end,
    lists:foreach(F, L),
    wp_update(),
    {noreply, State};

%%重新排行
handle_info({refresh_rank}, State) ->
    util:cancel_ref([State#rank_st.refresh_ref, State#rank_st.defore_refresh_ref]),
    reload_rank_data(),
    {Ref, Ref1} = send_refresh(),
    {noreply, State#rank_st{refresh_ref = Ref, defore_refresh_ref = Ref1}};

%%重排前15秒
handle_info({defore_refresh_rank}, State) ->
    F = fun(Rank, Type) ->
        case player_util:get_player_online(Rank#a_rank.rp#rp.pkey) of
            [] -> skip;
            Online -> Online#ets_online.pid ! {apply_state, {rank_handle, update_rank_db_by_type, Type}}
        end,
        Type
        end,
    F1 = fun(Type) ->
        L = rank:get_rank_top_N(Type, 10),
        lists:foldl(F, Type, L)
         end,
    lists:foreach(F1, ?ALL_RANK_TYPE),
    {noreply, State};

%%清除字典缓存
handle_info({clear_dict}, State) ->
    F = fun(Type) ->
        erlang:put(Type, [])
        end,
    lists:foreach(F, ?ALL_RANK_TYPE),
    {noreply, State};

%%定时更新
handle_info({timer_update}, State) ->
    util:cancel_ref([State#rank_st.timer_update_ref]),
    rank_timer_update(),
    Ref1 = erlang:send_after(?TIMER_UPDATE_DB * 1000, self(), {timer_update}),
    {noreply, State#rank_st{timer_update_ref = Ref1}};

handle_info(_Info, State) ->
    ?ERR("unknow rank info ~p~n", [_Info]),
    {noreply, State}.

%%重新排行
reload_rank_data() ->
    F = fun(Type) ->
        timer:sleep(1000),
        ets:match_delete(?ETS_RANK, #a_rank{type = Type, _ = '_'}),
        reload_rank(Type),
        rank_log:log_rank(Type),
        %%排行榜称号
        rank_designation(Type)
        end,
    spawn(fun() -> lists:foreach(F, ?ALL_RANK_TYPE), rank_proc:get_rank_pid() ! {clear_dict} end),
    ok.
reload_rank(Type) when Type == ?RANK_TYPE_CBP -> %%战力排行
    SQL = io_lib:format("select p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from player_state p left join player_login l on p.pkey = l.pkey where l.status = 0 order by combat_power desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Key, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Combatpower, Dvip], Order) ->
                spawn(fun() -> sync_cross_shadow(Key) end),
                RP = make_rp_record([Key, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Combatpower, Dvip]),
                R = #a_rank{
                    key = {Type, Key},
                    type = Type,
                    pkey = Key,
                    rp = RP,
                    rank = Order
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_LV -> %%等级排行
    cache:erase(world_lv),
    SQL =
        case version:get_lan_config() of
            korea ->
                io_lib:format("select p.pkey,p.sn,p.pf,p.lv,p.nickname,p.career,p.sex,p.realm,p.vip_lv,p.combat_power,p.vip_type from player_state p left join player_login l on p.pkey = l.pkey where l.status = 0 order by lv desc,p.exp desc limit ~p", [?RANK_NUM]);
            _ ->
                io_lib:format("select p.pkey,p.sn,p.pf,p.lv,p.nickname,p.career,p.sex,p.realm,p.vip_lv,p.combat_power,p.vip_type from player_state p left join player_login l on p.pkey = l.pkey where l.status = 0 order by lv desc,p.combat_power asc limit ~p", [?RANK_NUM])
        end,
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Pkey, Sn, Pf, Lv, Nickname, Career, Sex, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rank = Order,
                    rp = RP
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ ->
            err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_FLOWER -> %%鲜花排行
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_MOUNT -> %%坐骑排行
    SQL = io_lib:format("select m.stage,m.exp,m.current_image_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from mount m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CurrentImageId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_m = #r_m{
                        stage = Stage,
                        id = CurrentImageId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_WING -> %%翅膀排行
    SQL = io_lib:format("select m.stage,m.exp,m.current_image_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from wing m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CurrentImageId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_w = #r_w{
                        stage = Stage,
                        id = CurrentImageId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_BABY_WING -> %%灵羽排行
    SQL = io_lib:format("select m.stage,m.exp,m.current_image_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from baby_wing m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CurrentImageId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_baby_wing = #r_baby_wing{
                        stage = Stage,
                        id = CurrentImageId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_FABAO -> %%法宝排行
    SQL = io_lib:format("select m.stage,m.exp,m.weapon_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from magic_weapon m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, WeaponId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_fb = #r_fb{
                        stage = Stage,
                        id = WeaponId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_SB -> %%神兵排行
    SQL = io_lib:format("select m.stage,m.exp,m.weapon_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from light_weapon m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, WeaponId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_s = #r_s{
                        stage = Stage,
                        id = WeaponId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_YL -> %%妖灵排行
    SQL = io_lib:format("select m.stage,m.exp,m.weapon_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from pet_weapon m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, WeaponId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_yl = #r_yl{
                        stage = Stage,
                        id = WeaponId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_PET_STAGE -> %%宠物阶级排行
    SQL = io_lib:format("select m.stage,m.stage_lv,m.stage_exp,m.figure,mp.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from pet_info m left join pet mp on mp.pkey=m.pkey left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where mp.state = 2 and mp.cbp > 0 group by m.pkey order by m.stage desc, m.stage_lv desc,mp.cbp desc limit  ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _SubLv, _Exp, FigureId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_p_stage = #r_p_stage{
                        stage = Stage,
                        type_id = FigureId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_GOLDEN_BABY_STAGE -> %%子女阶级排行
    SQL = io_lib:format("select m.step,m.lv,m.step_exp,m.type_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from baby m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 group by m.pkey order by m.step desc, m.lv desc,m.cbp desc limit  ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _SubLv, _Exp, FigureId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_baby_stage = #r_baby_stage{
                        stage = Stage,
                        type_id = FigureId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_PET_STAR -> %%宠物星级排行
    SQL = io_lib:format("select m.star,m.star_exp,m.figure,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from (select pkey,max(star) as star,star_exp,figure,cbp from pet group by pkey order by max(star)  desc,star_exp desc limit ~p ) m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 group by m.pkey order by m.star desc,m.star_exp desc,m.cbp desc ", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Star, _Exp, FigureId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_p_star = #r_p_star{
                        star = Star,
                        type_id = FigureId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_GOLDEN_BABY_STAR -> %%子女等级排行
    SQL = io_lib:format("select m.lv ,m.lv_exp,m.figure,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from (select pkey, lv,lv_exp,figure,cbp from baby where cbp >0 group by pkey order by lv desc,lv_exp desc limit ~p) m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0  order by m.lv desc,m.cbp desc", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Star, _Exp, FigureId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_baby_star = #r_baby_star{
                        star = Star,
                        type_id = FigureId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_FOOT -> %%足迹排行
    SQL = io_lib:format("select m.stage,m.exp,m.footprint_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from footprint m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, Footid, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_foot = #r_foot{
                        stage = Stage,
                        id = Footid,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_CAT -> %%灵猫排行
    SQL = io_lib:format("select m.stage,m.exp,m.cat_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from cat m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CatId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_cat = #r_cat{
                        stage = Stage,
                        id = CatId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_GOLDEN_BODY -> %%金身排行
    SQL = io_lib:format("select m.stage,m.exp,m.golden_body_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from golden_body m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CatId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_golden_body = #r_golden_body{
                        stage = Stage,
                        id = CatId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;

reload_rank(Type) when Type == ?RANK_TYPE_JADE -> %%灵佩排行
    SQL = io_lib:format("select m.stage,m.exp,m.jade_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from jade m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CatId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_jade = #r_jade{
                        stage = Stage,
                        id = CatId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;

reload_rank(Type) when Type == ?RANK_TYPE_GOD_TREASURE -> %%仙宝排行
    SQL = io_lib:format("select m.stage,m.exp,m.god_treasure_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from god_treasure m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, CatId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    god_treasure = #god_treasure{
                        stage = Stage,
                        id = CatId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_BABY_MOUNT -> %%子女坐骑
    SQL = io_lib:format("select m.stage,m.exp,m.baby_mount_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from baby_mount m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, MountId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_baby_mount = #r_baby_mount{
                        stage = Stage,
                        id = MountId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(Type) when Type == ?RANK_TYPE_BABY_WEAPON -> %%子女武器
    SQL = io_lib:format("select m.stage,m.exp,m.baby_weapon_id,m.cbp,p.pkey,p.sn,p.pf,p.lv,p.career,p.sex,p.nickname,p.realm,p.vip_lv,p.combat_power,p.vip_type from baby_weapon m left join player_state p on m.pkey=p.pkey left join player_login l on p.pkey = l.pkey where l.status = 0 and m.cbp > 0 order by m.stage desc,m.cbp desc limit ~p", [?RANK_NUM]),
    case db:get_all(SQL) of
        [] -> ok;
        Rows when is_list(Rows) ->
            F = fun([Stage, _Exp, WeaponId, MCbp, Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip], Order) ->
                RP = make_rp_record([Pkey, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]),
                R = #a_rank{
                    key = {Type, Pkey},
                    type = Type,
                    pkey = Pkey,
                    rp = RP,
                    rank = Order,
                    r_baby_weapon = #r_baby_weapon{
                        stage = Stage,
                        id = WeaponId,
                        cbp = MCbp
                    }
                },
                ets:insert(?ETS_RANK, R),
                Order + 1
                end,
            lists:foldl(F, 1, Rows),
            ok;
        _ -> err
    end,
    ok;
reload_rank(_) -> ok.

%%同步到跨服中心
sync_cross_shadow(Key) ->
    case config:is_center_node() of
        false ->
            case config:is_debug() of
                true ->
                    case config:get_server_num() of
                        30001 ->
                            Shadow = shadow_proc:get_shadow(Key),
                            shadow_proc:syc_cross(Shadow);
                        _ -> ok
                    end;
                false ->
                    Shadow = shadow_proc:get_shadow(Key),
                    shadow_proc:syc_cross(Shadow)
            end;
        true -> ok
    end,
    ok.

%%构造排行榜人物信息record
make_rp_record([Key, Sn, Pf, Lv, Career, Sex, Nickname, Realm, VipLv, Cbp, Dvip]) ->
    {GuildKey, GuildName} = rank_get_guild_name(Key),
    #rp{
        pkey = Key,
        sn = Sn,
        pf = Pf,
        lv = Lv,
        career = Career,
        sex = Sex,
        nickname = util:to_list(Nickname),
        realm = Realm,
        vip = VipLv,
        guild_name = util:to_list(GuildName),
        guild_key = GuildKey,
        cbp = Cbp,
        dvip = Dvip
    }.

%%获取帮派名字
rank_get_guild_name(Key) ->
    guild_util:get_guild_name_key_by_pkey(Key).

%%发送下次排行计时器
send_refresh() ->
    %%获取到下一个整点的时间 增加5秒，避免计时器过快
    Rtime = (3600 - util:unixtime() rem 3600 + 5) * 1000,
    Ref = erlang:send_after(Rtime, self(), {refresh_rank}),
    Rand = util:rand(5000, 10000),
    Ref1 = erlang:send_after(max(Rtime - Rand, 5000), self(), {defore_refresh_rank}),
    {Ref, Ref1}.

%%获取分页
get_page_list(List, Page) ->
    PageNum = 15,
    Start = PageNum * (Page - 1) + 1,
    Len = length(List),
    case Start > Len of
        true -> [];
        false ->
            lists:sublist(List, Start, PageNum)
    end.

%%更新相应榜玩家db数据
update_rank_db_by_type(Type, Player) ->
    case Type of
        ?RANK_TYPE_CBP -> player_load:dbup_player_cbp(Player);
        ?RANK_TYPE_LV -> player_load:dbup_player_lvexp(Player);
        ?RANK_TYPE_FLOWER -> ok;
        ?RANK_TYPE_MOUNT -> mount_util:timer_update();
        ?RANK_TYPE_WING -> wing_init:timer_update();
        ?RANK_TYPE_BABY_WING -> baby_wing_init:timer_update();
        ?RANK_TYPE_BABY_MOUNT -> baby_mount_init:timer_update();
        ?RANK_TYPE_BABY_WEAPON -> baby_weapon_init:timer_update();
        ?RANK_TYPE_FABAO -> magic_weapon_init:timer_update();
        ?RANK_TYPE_SB -> light_weapon_init:timer_update();
        ?RANK_TYPE_YL -> pet_weapon_init:timer_update();
        ?RANK_TYPE_PET_STAGE -> pet_init:timer_update();
        ?RANK_TYPE_PET_STAR -> pet_init:timer_update();
        ?RANK_TYPE_GOLDEN_BABY_STAGE -> baby_init:timer_update();
        ?RANK_TYPE_GOLDEN_BABY_STAR -> baby_init:timer_update();
        ?RANK_TYPE_FOOT -> footprint_init:timer_update();
        ?RANK_TYPE_CAT -> cat_init:timer_update();
        ?RANK_TYPE_GOLDEN_BODY -> golden_body_init:timer_update();
        ?RANK_TYPE_JADE -> jade_init:timer_update();
        ?RANK_TYPE_GOD_TREASURE -> god_treasure_init:timer_update()
    end,
    ok.

%%获取排行数值
get_rank_data(Rank) ->
    case Rank#a_rank.type of
        ?RANK_TYPE_CBP -> {Rank#a_rank.rp#rp.cbp, 0, Rank#a_rank.rp#rp.cbp};
        ?RANK_TYPE_LV -> {Rank#a_rank.rp#rp.lv, 0, Rank#a_rank.rp#rp.cbp};
        ?RANK_TYPE_FLOWER -> {Rank#a_rank.r_f#r_f.flower_num, 0, 0};
        ?RANK_TYPE_MOUNT -> {Rank#a_rank.r_m#r_m.stage, Rank#a_rank.r_m#r_m.id, Rank#a_rank.r_m#r_m.cbp};
        ?RANK_TYPE_WING -> {Rank#a_rank.r_w#r_w.stage, Rank#a_rank.r_w#r_w.id, Rank#a_rank.r_w#r_w.cbp};
        ?RANK_TYPE_FABAO -> {Rank#a_rank.r_fb#r_fb.stage, Rank#a_rank.r_fb#r_fb.id, Rank#a_rank.r_fb#r_fb.cbp};
        ?RANK_TYPE_SB -> {Rank#a_rank.r_s#r_s.stage, Rank#a_rank.r_s#r_s.id, Rank#a_rank.r_s#r_s.cbp};
        ?RANK_TYPE_YL -> {Rank#a_rank.r_yl#r_yl.stage, Rank#a_rank.r_yl#r_yl.id, Rank#a_rank.r_yl#r_yl.cbp};
        ?RANK_TYPE_PET_STAGE ->
            {Rank#a_rank.r_p_stage#r_p_stage.stage, Rank#a_rank.r_p_stage#r_p_stage.type_id, Rank#a_rank.r_p_stage#r_p_stage.cbp};
        ?RANK_TYPE_PET_STAR ->
            {Rank#a_rank.r_p_star#r_p_star.star, Rank#a_rank.r_p_star#r_p_star.type_id, Rank#a_rank.r_p_star#r_p_star.cbp};
        ?RANK_TYPE_FOOT ->
            {Rank#a_rank.r_foot#r_foot.stage, Rank#a_rank.r_foot#r_foot.id, Rank#a_rank.r_foot#r_foot.cbp};
        ?RANK_TYPE_CAT -> {Rank#a_rank.r_cat#r_cat.stage, Rank#a_rank.r_cat#r_cat.id, Rank#a_rank.r_cat#r_cat.cbp};
        ?RANK_TYPE_GOLDEN_BODY ->
            {Rank#a_rank.r_golden_body#r_golden_body.stage, Rank#a_rank.r_golden_body#r_golden_body.id, Rank#a_rank.r_golden_body#r_golden_body.cbp};
        ?RANK_TYPE_JADE ->
            {Rank#a_rank.r_jade#r_jade.stage, Rank#a_rank.r_jade#r_jade.id, Rank#a_rank.r_jade#r_jade.cbp};
        ?RANK_TYPE_GOD_TREASURE ->
            {Rank#a_rank.god_treasure#god_treasure.stage, Rank#a_rank.god_treasure#god_treasure.id, Rank#a_rank.god_treasure#god_treasure.cbp};
        ?RANK_TYPE_GOLDEN_BABY_STAGE ->
            {Rank#a_rank.r_baby_stage#r_baby_stage.stage, Rank#a_rank.r_baby_stage#r_baby_stage.type_id, Rank#a_rank.r_baby_stage#r_baby_stage.cbp};
        ?RANK_TYPE_GOLDEN_BABY_STAR ->
            {Rank#a_rank.r_baby_star#r_baby_star.star, Rank#a_rank.r_baby_star#r_baby_star.type_id, Rank#a_rank.r_baby_star#r_baby_star.cbp};
        ?RANK_TYPE_BABY_WING ->
            {Rank#a_rank.r_baby_wing#r_baby_wing.stage, Rank#a_rank.r_baby_wing#r_baby_wing.id, Rank#a_rank.r_baby_wing#r_baby_wing.cbp};
        ?RANK_TYPE_BABY_MOUNT ->
            {Rank#a_rank.r_baby_mount#r_baby_mount.stage, Rank#a_rank.r_baby_mount#r_baby_mount.id, Rank#a_rank.r_baby_mount#r_baby_mount.cbp};
        ?RANK_TYPE_BABY_WEAPON ->
            {Rank#a_rank.r_baby_weapon#r_baby_weapon.stage, Rank#a_rank.r_baby_weapon#r_baby_weapon.id, Rank#a_rank.r_baby_weapon#r_baby_weapon.cbp}
    end.

%%定时更新
rank_timer_update() ->
    List = ets:match_object(?ETS_RANK_WORSHIP, #rank_wp{is_db_update = 1, _ = '_'}),
    F = fun(RankWp) ->
        #rank_wp{
            pkey = Pkey,
            worship_times = WorshipTimes,
            update_time = UpdateTime,
            worship_list = WorshipList
        } = RankWp,
        Sql = io_lib:format("replace into rank_wp set pkey=~p,worship_times=~p,update_time=~p,worship_list='~s'",
            [Pkey, WorshipTimes, UpdateTime, util:term_to_bitstring(WorshipList)]),
        db:execute(Sql),
        ets:insert(?ETS_RANK_WORSHIP, RankWp#rank_wp{is_db_update = 0})
        end,
    lists:foreach(F, List),
    ok.

%%膜拜更新
wp_update() ->
    Date = util:unixdate(),
    MS = ets:fun2ms(fun(RankWp) when RankWp#rank_wp.update_time < Date -> RankWp end),
    List = ets:select(?ETS_RANK_WORSHIP, MS),
    Now = util:unixtime(),
    F = fun(RankWp) ->
        NewRankWp = RankWp#rank_wp{
            worship_times = 0,
            update_time = Now,
            worship_list = [],
            wp_player_list = [],
            is_db_update = 1
        },
        ets:insert(?ETS_RANK_WORSHIP, NewRankWp)
        end,
    lists:foreach(F, List),
    ok.

%%排行榜称号
rank_designation(Type) ->
    Now = util:unixtime(),
    {_, {Hour, _, _}} = util:seconds_to_localtime(Now),
    Title = ?T("系统邮件"),
    case Hour of
        0 ->
            case Type of
                ?RANK_TYPE_CBP ->
                    case rank:get_rank_top_N(?RANK_TYPE_CBP, 1) of
                        [] -> skip;
                        [R | _] ->
                            #a_rank{
                                pkey = Pkey
                            } = R,
                            designation_proc:add_des(10011, [Pkey]),
                            Content = ?T("恭喜您获得战力排名第一，称号奖励已发放，请在称号界面查看"),
                            mail:sys_send_mail([Pkey], Title, Content)
                    end,
                    ok;
                ?RANK_TYPE_LV ->
                    case rank:get_rank_top_N(?RANK_TYPE_LV, 1) of
                        [] -> skip;
                        [R | _] ->
                            #a_rank{
                                pkey = Pkey
                            } = R,
                            designation_proc:add_des(10012, [Pkey]),
                            Content = ?T("恭喜您获得等级排名第一，称号奖励已发放，请在称号界面查看"),
                            mail:sys_send_mail([Pkey], Title, Content)
                    end,
                    ok;
                _ ->
                    skip
            end;
        _ ->
            skip
    end.



