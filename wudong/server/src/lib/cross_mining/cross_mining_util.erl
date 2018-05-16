%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 四月 2018 下午2:59
%%%-------------------------------------------------------------------
-module(cross_mining_util).
-author("luobaqun").
-include("server.hrl").
-include("common.hrl").
-include("cross_mining.hrl").

-compile(export_all).

make_mine_info_60401(MineList) ->
    Now = util:unixtime(),
    F = fun(MineralInfo) ->
        [
            MineralInfo#mineral_info.mtype,
            MineralInfo#mineral_info.id,
            MineralInfo#mineral_info.hold_key,
            MineralInfo#mineral_info.hold_name,
            MineralInfo#mineral_info.hold_guild_name,
            MineralInfo#mineral_info.hp,
            max(0, MineralInfo#mineral_info.meet_end_time - Now),
            max(0, MineralInfo#mineral_info.thief_end_time - Now),
            ?IF_ELSE(MineralInfo#mineral_info.ripe_time < Now andalso MineralInfo#mineral_info.ripe_time =/= 0, 1, 0),
            max(0, MineralInfo#mineral_info.ripe_time - Now),
            max(0, MineralInfo#mineral_info.end_time - Now),
            ?IF_ELSE(MineralInfo#mineral_info.help_list ==[],0,1)
        ]
        end,
    lists:map(F, MineList).

make_mine_info_60409(MineralInfo) ->
    Now = util:unixtime(),
    {
        MineralInfo#mineral_info.type,
        MineralInfo#mineral_info.page,
        MineralInfo#mineral_info.mtype,
        MineralInfo#mineral_info.id,
        MineralInfo#mineral_info.hold_key,
        MineralInfo#mineral_info.hold_name,
        MineralInfo#mineral_info.hold_guild_name,
        MineralInfo#mineral_info.hp,
        max(0, MineralInfo#mineral_info.meet_end_time - Now),
        max(0, MineralInfo#mineral_info.thief_end_time - Now),
        ?IF_ELSE(MineralInfo#mineral_info.ripe_time < Now andalso MineralInfo#mineral_info.ripe_time =/= 0, 1, 0),
        max(0, MineralInfo#mineral_info.ripe_time - Now),
        max(0, MineralInfo#mineral_info.end_time - Now),
        ?IF_ELSE(MineralInfo#mineral_info.help_list ==[],0,1)
    }.


make_mine_info_60417(MbList) ->
    F = fun(Mb) ->
        [
            Mb#mining_info_rank.pkey,
            Mb#mining_info_rank.sn,
            Mb#mining_info_rank.nickname,
            Mb#mining_info_rank.cbp,
            Mb#mining_info_rank.score,
            Mb#mining_info_rank.vip,
            Mb#mining_info_rank.dvip

        ]
        end,
    lists:map(F, MbList).


%% 初始化矿洞数据

init_mining_list(MiningList) ->
    MineralInfoList = mining_list_to_record(MiningList),
    Pages = [X#mineral_info.page || X <- MineralInfoList],
    MaxPage = ?IF_ELSE(Pages == [], 1, lists:max(Pages)),

    MineList = [{Type0, Page0} || Type0 <- ?MINERAL_TYPE_LIST, Page0 <- lists:seq(1, MaxPage)],

    F1 = fun(MineralInfo, List0) ->
        case lists:keytake({MineralInfo#mineral_info.type, MineralInfo#mineral_info.page}, 1, List0) of
            false ->
                [{{MineralInfo#mineral_info.type, MineralInfo#mineral_info.page}, [MineralInfo]} | List0];
            {value, {{Type0, Page0}, List1}, T} ->
                [{{Type0, Page0}, [MineralInfo | List1]} | T]
        end
         end,
    MiningList1 = lists:foldl(F1, [], MineralInfoList),

    F2 = fun({Type, Page}) ->
        case lists:keyfind({Type, Page}, 1, MiningList1) of
            false ->
                {ok, Mid} = cross_mining_paging:start(Type, Page, []),
                #mining_info{
                    key = {Type, Page},
                    type = Type,
                    page = Page,
                    mid = Mid
                };
            {{Type, Page}, List} ->
                {ok, Mid} = cross_mining_paging:start(Type, Page, List),
                #mining_info{
                    key = {Type, Page},
                    type = Type,
                    page = Page,
                    mid = Mid
                }
        end
         end,
    MiningList2 = lists:map(F2, MineList),
    {MiningList2, MaxPage}.

init_rank_list(List) ->
    F = fun([Pkey, Sn, Nickname, Cbp, Vip, Dvip, Score, Time, Rank]) ->
        #mining_info_rank{
            pkey = Pkey,
            sn = Sn,
            nickname = Nickname,
            cbp = Cbp,
            vip = Vip,
            score = Score,
            dvip = Dvip,
            time = Time,
            rank = Rank
        }
        end,
    PlayList = lists:map(F, List),
    RankList = sort_rank_list(PlayList),
    {RankList, PlayList}.

mining_list_to_record(MiningList) ->

    F = fun([Type, Page, Id, MType, StartTime, FirstHoldTime, LastHoldTime, RipeTime, EndTime, IsNotice, Hp, HpLim, IsHit, HoldSn, HoldKey, HoldSex, HoldAvatar, HoldName, HoldGuildName, HoldCbp, HoldVip, HoldDvip, MeetType, MeetStartTime, MeetEndTime, ThiefStartTime, ThiefEndTime, ThiefCbp, HelpList]) ->
        #mineral_info{
            key = {Type, Page, Id},
            type = Type,
            page = Page,
            id = Id,
            mtype = MType,
            start_time = StartTime,
            first_hold_time = FirstHoldTime,
            last_hold_time = LastHoldTime,
            ripe_time = RipeTime,
            end_time = EndTime,
            is_notice = IsNotice,
            hp = Hp,
            hp_lim = HpLim,
            is_hit = IsHit,
            hold_sn = HoldSn,
            hold_key = HoldKey,
            hold_sex = HoldSex,
            hold_avatar = HoldAvatar,
            hold_name = HoldName,
            hold_guild_name = HoldGuildName,
            hold_cbp = HoldCbp,
            hold_vip = HoldVip,
            hold_dvip = HoldDvip,
            meet_type = MeetType,
            meet_start_time = MeetStartTime,
            meet_end_time = MeetEndTime,

            thief_start_time = ThiefStartTime,
            thief_end_time = ThiefEndTime,
            thief_cbp = ThiefCbp,
            help_list = cross_mining_util:help_list2recore(util:bitstring_to_term(HelpList))
        }
        end,
    lists:map(F, MiningList).


%% 定时刷新矿洞
sys_update() ->
    case center:is_center_all() of
        false -> skip;
        true ->
            {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),

            Ids = data_mining_retime:get_all(),
            TimeList = lists:map(fun(Id) -> data_mining_retime:get(Id) end, Ids),
            case lists:member({H, M}, TimeList) of
                false -> skip;
                _ ->
                    %%  刷新矿洞
                    ?CAST(cross_mining_proc:get_server_pid(), time_reset_mining)
            end,
            case data_mining_event:get(?EVENT_TYPE_1) of
                [] -> skip;
                #base_mining_event{re_time = ReTime1} ->
                    case lists:member({H, M}, ReTime1) of
                        false -> skip;
                        _ ->
                            %% 灵宝出世
                            spawn(fun() ->
                                util:sleep(3000),
                                cross_mining_notice:notice_meet_start(),
                                ?CAST(cross_mining_proc:get_server_pid(), time_mining_meet) end)
                    end
            end,
            case data_mining_event:get(?EVENT_TYPE_2) of
                [] -> skip;
                #base_mining_event{re_time = ReTime2} ->
                    case lists:member({H, M}, ReTime2) of
                        false -> skip;
                        _ ->
                            %% 小偷
                            spawn(fun() ->
                                util:sleep(6000),
                                cross_mining_notice:notice_thief_start(),
                                ?CAST(cross_mining_proc:get_server_pid(), time_mining_thief) end)
                    end
            end
    end.

%% 获取矿洞分页数据
get_ets_by_type_page(Type, Page) ->
    ets:match_object(?ETS_CROSS_MINERAL_INFO, #mineral_info{type = Type, page = Page, _ = '_'}).

%% 获取玩家奇遇数据
get_meet_ets_by_pkey(Pkey) ->
    case ets:lookup(?ETS_CROSS_MINERAL_DAILY_MEET, Pkey) of
        [] -> [];
        [Ets | _] -> Ets
    end.


%% 获取玩家矿点数据
get_ets_by_pkey(Pkey) ->
    if
        Pkey == 0 -> [];
        true ->
            ets:match_object(?ETS_CROSS_MINERAL_INFO, #mineral_info{hold_key = Pkey, _ = '_'})
    end.

%% 获取矿洞数据
get_ets_by_key(Key) ->
    case ets:lookup(?ETS_CROSS_MINERAL_INFO, Key) of
        [] -> [];
        [Ets | _] -> Ets
    end.

%% 获取玩家日志
get_log_ets_by_key(Key) ->
    case ets:lookup(?ETS_CROSS_MINERAL_LOG, Key) of
        [] -> [];
        [Ets | _] -> Ets
    end.

%% 删除矿点数据
delete_mine(Ets) ->
    ets:delete_object(?ETS_CROSS_MINERAL_INFO, Ets),
    ?DO_IF(Ets#mineral_info.hold_key =/= 0, cross_mining_load:dbdelete_cross_mining(Ets)).

%% 添加矿点数据
insert_ets(Ets) ->
    ets:insert(?ETS_CROSS_MINERAL_INFO, Ets),
    ?DO_IF(Ets#mineral_info.hold_key =/= 0, cross_mining_load:dbup_cross_mining(Ets)).

%% 获取占领奖励
get_hold_time_reward(HoldTime, {Time, GoodsList}) ->
    Num = HoldTime div Time,
    if
        Num =< 0 -> [];
        true -> goods:pack_goods([{GoodsId, GoodsNum * Num} || {GoodsId, GoodsNum} <- GoodsList])
    end.


%%打包攻击信息
make_att_info(MineralInfo, Cbp) ->
    Now = util:unixtime(),
    Base = data_mineral_info:get(MineralInfo#mineral_info.mtype),
    HoldTime = Now - MineralInfo#mineral_info.last_hold_time,
    F = fun({Down, Top, Att}, Hp0) ->
        ?IF_ELSE(HoldTime >= Down andalso HoldTime =< Top, Att, Hp0)
        end,
    AttHp0 = lists:foldl(F, 0, Base#base_mineral_info.att_hp),
    NextList = [Down || {Down, _Top, _Hp} <- Base#base_mineral_info.att_hp, HoldTime < Down],
    NextHp0 = ?IF_ELSE(NextList == [], 0, hd(NextList)),
    NextHpTime =
        if
            MineralInfo#mineral_info.last_hold_time == 0 -> 0;
            true ->
                max(0, NextHp0 - (Now - MineralInfo#mineral_info.last_hold_time))
        end,
    ?DEBUG("11111  ~p~n", [Base#base_mineral_info.cbp_limit]),
    {Time, Reward} = Base#base_mineral_info.reward,
    AttReward0 = cross_mining_util:get_hold_time_reward(Now - MineralInfo#mineral_info.last_hold_time, Base#base_mineral_info.reward),
    AttReward = [{GoodsId, GoodsNum div ?ATT_MINE_VAL} || [GoodsId, GoodsNum] <- AttReward0],
    HelpCbp = lists:sum([X#help_info.cbp||X<- MineralInfo#mineral_info.help_list]),
    Att0 = data_mineral_att:get(max(0, Cbp - MineralInfo#mineral_info.hold_cbp- HelpCbp)),
    Att = ?IF_ELSE(Att0 == [], 1, Att0),
    AttHp = round(AttHp0 * Att),

    Att20 = data_mineral_att:get(max(0, Cbp - MineralInfo#mineral_info.hold_cbp)),
    Att2 = ?IF_ELSE(Att20 == [], 1, Att20),
    AttHp2 = round(AttHp0 * Att2),

    ?DEBUG("AttHp ~p~n",[AttHp]),
    ?DEBUG("AttHp2 ~p~n",[AttHp2]),

    CbpLimit = ?IF_ELSE(MineralInfo#mineral_info.hold_key == 0, Base#base_mineral_info.cbp_limit, MineralInfo#mineral_info.hold_cbp),
    F1 = fun(HelpInfo) ->
        [
            HelpInfo#help_info.pkey,
            HelpInfo#help_info.nickname,
            HelpInfo#help_info.sex,
            HelpInfo#help_info.avatar,
            HelpInfo#help_info.cbp
        ]
         end,
    HelpList = lists:map(F1, MineralInfo#mineral_info.help_list),
    {
        MineralInfo#mineral_info.hold_key,
        MineralInfo#mineral_info.hold_name,
        MineralInfo#mineral_info.hold_sex,
        MineralInfo#mineral_info.hold_sn,
        MineralInfo#mineral_info.hold_avatar,
        CbpLimit,
        MineralInfo#mineral_info.hold_guild_name,
        MineralInfo#mineral_info.hp,
        MineralInfo#mineral_info.hp_lim,
        MineralInfo#mineral_info.hp_lim - Base#base_mineral_info.hp_lim,
        ?IF_ELSE(MineralInfo#mineral_info.ripe_time == 0, Base#base_mineral_info.life_time, max(0, MineralInfo#mineral_info.ripe_time - Now)),
        AttHp,
        max(0, round(AttHp0 * (Att - 1))),
        max(0,AttHp2-AttHp),
        NextHpTime,
        Time,
        goods:pack_goods(Reward),
        goods:pack_goods(AttReward),
        HelpList
    }.

%% 进攻日志
insert_att_log(AttKey, AttName, DefKey, DefSn, DefName, Type, Page, Id, Res, AttReward) ->
    State =
        if
            Res == 1 -> 1; %% 攻占成功
            Res == 5 orelse Res == 6 -> 2;%% 进攻成功未占领
            true -> 0
        end,

    Now = util:unixtime(),
    AttLog = #cross_att_log{
        pkey = DefKey,
        pname = DefName,
        location_type = Type,
        location_page = Page,
        location_id = Id,
        time = Now,
        reward = AttReward,
        state = State
    },
    if AttKey == 0 -> skip;
        true ->
            case ets:lookup(?ETS_CROSS_MINERAL_LOG, AttKey) of
                [] ->
                    ets:insert(?ETS_CROSS_MINERAL_LOG, #ets_cross_mineral_log{pkey = AttKey, att_log = [AttLog]});
                [Log0 | _] ->
                    ets:insert(?ETS_CROSS_MINERAL_LOG, Log0#ets_cross_mineral_log{att_log = [AttLog | [X || X <- Log0#ets_cross_mineral_log.att_log, Now - X#cross_att_log.time < ?ONE_DAY_SECONDS]]})
            end
    end,

    DefLog = #cross_att_log{
        pkey = AttKey,
        pname = AttName,
        location_type = Type,
        location_page = Page,
        location_id = Id,
        time = Now,
        reward = AttReward,
        state = State
    },
    if DefKey == 0 -> skip;
        true ->
            case ets:lookup(?ETS_CROSS_MINERAL_LOG, DefKey) of
                [] ->
                    ets:insert(?ETS_CROSS_MINERAL_LOG, #ets_cross_mineral_log{pkey = DefKey, def_log = [DefLog]});
                [Log1 | _] ->
                    ets:insert(?ETS_CROSS_MINERAL_LOG, Log1#ets_cross_mineral_log{def_log = [DefLog | [X || X <- Log1#ets_cross_mineral_log.def_log, Now - X#cross_att_log.time < ?ONE_DAY_SECONDS]]}),

                    spawn(fun() ->
                        {ok, Bin} = pt_604:write(60416, {
                            DefLog#cross_att_log.pkey,
                            DefLog#cross_att_log.pname,
                            DefLog#cross_att_log.location_type,
                            DefLog#cross_att_log.location_page,
                            DefLog#cross_att_log.location_id,
                            DefLog#cross_att_log.state,
                            Now,
                            goods:pack_goods(DefLog#cross_att_log.reward)
                        }),
                        ?DO_IF(DefSn =/= 0, center:apply_sn(DefSn, server_send, send_to_key, [DefKey, Bin]))
                          end),
                    ok
            end
    end,
    ok.

%% 事件日志
insert_event_log(EventType, Pkey, Pname, _LogPkey, Type, Page, Id, Reward, Mtype) ->
%%     if
%%         LogPkey == 0 -> skip;
%%         true ->
    Now = util:unixtime(),
    NewLog = #cross_event_log{
        type = EventType,
        name = Pname,
        location_type = Type,
        location_page = Page,
        location_id = Id,
        reward = Reward,
        pkey = Pkey,
        location_mtype = Mtype,
        time = Now
    },
    %%个人日志
    case ets:lookup(?ETS_CROSS_MINERAL_LOG, Pkey) of
        [] ->
            ets:insert(?ETS_CROSS_MINERAL_LOG, #ets_cross_mineral_log{pkey = Pkey, event_log = [NewLog]});
        [Log0 | _] ->
            ets:insert(?ETS_CROSS_MINERAL_LOG, Log0#ets_cross_mineral_log{event_log = [NewLog | [X || X <- Log0#ets_cross_mineral_log.event_log, Now - X#cross_event_log.time < ?ONE_DAY_SECONDS]]})
    end,

    %% 全服日志
    case ets:lookup(?ETS_CROSS_MINERAL_ALL_LOG, ets_cross_mineral_all_log) of
        [] ->
            ets:insert(?ETS_CROSS_MINERAL_ALL_LOG, #ets_cross_mineral_all_log{event_log = [NewLog]});
        [Log1 | _] ->
            List = lists:sublist(Log1#ets_cross_mineral_all_log.event_log, 10),
            ets:insert(?ETS_CROSS_MINERAL_ALL_LOG, Log1#ets_cross_mineral_all_log{event_log = [NewLog | List]})
    end,
    ?DEBUG(" NewLog#cross_event_log.type ~p~n", [NewLog#cross_event_log.type]),
    %%  发送刷新推送协议
    spawn(fun() ->
        util:sleep(util:rand(1000, 5000)),
        {ok, Bin} = pt_604:write(60415, {
            NewLog#cross_event_log.type,
            NewLog#cross_event_log.pkey,
            NewLog#cross_event_log.name,
            NewLog#cross_event_log.location_type,
            NewLog#cross_event_log.location_page,
            NewLog#cross_event_log.location_id,
            NewLog#cross_event_log.location_mtype,
            NewLog#cross_event_log.time,
            goods:pack_goods(NewLog#cross_event_log.reward)}),
        F1 = fun(Node) ->
            center:apply(Node, server_send, send_to_all, [Bin])
             end,
        lists:foreach(F1, center:get_nodes())
          end),
%%     end,
    ok.

%% 获取敌人key列表
get_att_list(Pkey) ->
    case cross_mining_util:get_log_ets_by_key(Pkey) of
        [] ->
            [];
        Log ->
            util:list_unique([X#cross_att_log.pkey || X <- Log#ets_cross_mineral_log.def_log])
    end.

%% 推送红点
get_state(Player) ->
    cross_all:apply(cross_mining_util, get_state_cast, [node(), Player#player.sid, Player#player.key]),
    0.

get_state_cast(Node, Sid, Pkey) ->
    ?DEBUG("196 ~n"),
    List = cross_mining_util:get_ets_by_pkey(Pkey),
    Now = util:unixtime(),
    F = fun(Info) ->
        Info#mineral_info.ripe_time < Now andalso Info#mineral_info.end_time > Now
        end,
    Ret =
        case lists:any(F, List) of
            true -> 1;
            _ -> 0
        end,

    {ok, Bin} = pt_430:write(43099, {[[196, Ret] ++ activity:pack_act_state([])]}),
    server_send:send_to_sid(Node, Sid, Bin),
    ok.



gm_reset() ->
    ?CAST(cross_mining_proc:get_server_pid(), time_reset_mining),
    ok.
gm_reset1() ->
    ?CAST(cross_mining_proc:get_server_pid(), time_mining_meet),
    ok.
gm_reset2() ->
    ?CAST(cross_mining_proc:get_server_pid(), time_mining_thief),
    ok.

test() ->
    St1 = dyc_cross_platform:system_time() div 1000000,
    ?DEBUG("st1 ~p~n", [dyc_cross_platform:system_time() div 1000000]),

    F = fun(Id) ->
        spawn(fun() -> test2(Id, Id + 5000000, St1) end)
%%        test2(Id , Id+ 5000000,St1)
        end,
    lists:foreach(F, lists:seq(1, 10)),
    ok.

test2(Id, Id0, St1) ->
    ?DEBUG("st2 ~p/Id ~p~n", [dyc_cross_platform:system_time() div 1000000 - St1, Id]),
    F = fun(_Id1) ->
        ets:insert(?ETS_CROSS_MINERAL_LOG, #ets_cross_mineral_log{pkey = Id})
        end,
    lists:foreach(F, lists:seq(Id, Id0)),
    ?DEBUG("et1 ~p/Id ~p~n", [dyc_cross_platform:system_time() div 1000000 - St1, Id]),
    ok.


add_sore(Pkey, Nickname, Vip, Cbp, Dvip, Sn, ScoreType) ->
    case data_cross_mining_rank_score:get(ScoreType) of
        [] -> skip;
        Score ->
            {{_Y, _Mon, _D}, {H, _M, _S}} = erlang:localtime(),
            if
                H >= 23 -> skip;
                true ->
                    ?CAST(cross_mining_proc:get_server_pid(), {add_score, Pkey, Nickname, Sn, Vip, Dvip, Cbp, Score})
            end
    end,
    ok.


sys_update_rank() ->
    case center:is_center_all() of
        false -> skip;
        true ->
            {{_Y, _Mon, _D}, {H, M, _S}} = erlang:localtime(),

            if
                H == 23 andalso M == 0 ->
                    ?CAST(cross_mining_proc:get_server_pid(), end_reward);
                H == 23 andalso M == 59 ->
                    ?CAST(cross_mining_proc:get_server_pid(), delete_rank);
                H < 23 andalso (M == 0 orelse M == 30) ->
                    ?CAST(cross_mining_proc:get_server_pid(), time_reset_mining_rank);
                true ->
                    skip
            end
    end.


sort_rank_list(PlayList) ->
    F = fun(A, B) ->
        if
            A#mining_info_rank.score > B#mining_info_rank.score -> true;
            A#mining_info_rank.score < B#mining_info_rank.score -> false;
            A#mining_info_rank.time < B#mining_info_rank.time -> true;
            A#mining_info_rank.time > B#mining_info_rank.time -> false;
            true -> true
        end
        end,
    RankList0 = lists:sort(F, PlayList),

    F1 = fun(RankInfo0,{Rank0,List0})->
        {Rank0+1,[RankInfo0#mining_info_rank{rank= Rank0}|List0]}
        end,
    {_,RankList} =  lists:foldl(F1,{1,[]},RankList0),
    RankList.

clean_rank() ->
    db:execute("truncate cross_mining_rank ").

help_recore2list(List) ->
    F = fun(HelpInfo) ->
        [
            HelpInfo#help_info.id,
            HelpInfo#help_info.pkey,
            HelpInfo#help_info.nickname,
            HelpInfo#help_info.cbp,
            HelpInfo#help_info.sex,
            HelpInfo#help_info.vip,
            HelpInfo#help_info.dvip,
            HelpInfo#help_info.avatar,
            HelpInfo#help_info.time
        ]
        end,
    lists:map(F, List).

help_list2recore(List) ->
    F = fun([Id, Pkey, Nickname, Cbp, Sex, Vip,Dvip, Avatar,Time]) ->
        #help_info{
            id = Id,
            pkey = Pkey,
            nickname = Nickname,
            cbp = Cbp,
            sex = Sex,
            vip = Vip,
            dvip = Dvip,
            avatar = Avatar,
            time = Time
        }
        end,
    lists:map(F, List).

make_help_info(Player) ->
    #help_info{
        pkey = Player#player.key,
        nickname = Player#player.nickname,
        cbp = Player#player.cbp,
        sex = Player#player.sex,
        vip = Player#player.vip_lv,
        avatar = Player#player.avatar
    }.

timer_update(_Player)->
    St = lib_dict:get(?PROC_STATUS_CROSS_MINE_HELP),
    St#st_cross_mine_help.my_help_list,
    Now = util:unixtime(),
    F = fun(MyHelp,{Flag0,List})->
        if
            Now - MyHelp#help_info.time > ?ONE_DAY_SECONDS -> {true,List};
            true -> {Flag0,[MyHelp|List]}
        end

    end,
    {Flag,NewMyHelpList}=lists:foldl(F,{false,[]},St#st_cross_mine_help.my_help_list),

    if
        Flag ==true ->
            NewSt =  St#st_cross_mine_help{my_help_list = NewMyHelpList},
            lib_dict:put(?PROC_STATUS_CROSS_MINE_HELP,NewSt),
            cross_mining_load:dbup_player_cross_mining_help(NewSt);
        true -> skip
    end,
    ok.
