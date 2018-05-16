%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 二月 2017 下午4:47
%%%-------------------------------------------------------------------
-module(red_bag_handle).
-author("fengzhenlin").
-include("common.hrl").
-include("red_bag.hrl").
-include("server.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).

handle_call(_Info, _From, State) ->
    ?ERR("red_bag_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

%%增加普通红包
handle_cast({add_red_bag, RedBag, NoticeMsg}, State) ->
    ets:insert(?RED_BAG_ETS, RedBag),
    RedbagNotice = #redbag_notice{
        key = RedBag#red_bag.key,
        msg = NoticeMsg
    },
    case State#red_bag_st.notice_list of
        [] -> %%队列没有红包，马上广播
            util:cancel_ref([State#red_bag_st.ref]),
            self() ! red_bag_notice_time;
        _ ->
            skip
    end,
    {noreply, State#red_bag_st{notice_list = State#red_bag_st.notice_list ++ [RedbagNotice]}};

%%打开普通红包
handle_cast({open_red_bag, RedBagKey, [Pkey, PSid, PName, Pid, Career, Sex, Avatar]}, State) ->
    case check_open_red_bag(RedBagKey, Pkey) of
        {false, Res} ->
            {ok, Bin} = pt_382:write(38201, {Res, 0}),
            server_send:send_to_sid(PSid, Bin);
        {ok, RegBag, GetGold, Base} ->
            GPinfo = #red_bag_g_p{
                pkey = Pkey,
                name = PName,
                career = Career,
                sex = Sex,
                avatar = Avatar,
                get_gold = GetGold
            },
            NewRegBag = RegBag#red_bag{
                get_gold = RegBag#red_bag.get_gold + GetGold,
                get_num = RegBag#red_bag.get_num + 1,
                get_list = RegBag#red_bag.get_list ++ [Pkey],
                guild_get_list = RegBag#red_bag.guild_get_list ++ [GPinfo]
            },
            ets:insert(?RED_BAG_ETS, NewRegBag),
            case Base#base_red_bag.max_num =< NewRegBag#red_bag.get_num of
                true ->
                    Now = util:unixtime(),
                    UseTime = max(0, Now - RegBag#red_bag.time),
                    {ok, BinE} = pt_382:write(38214, {RedBagKey, UseTime}),
                    server_send:send_to_key(RegBag#red_bag.pkey, BinE),
                    spawn(fun() -> timer:sleep(1800 * 1000), ets:delete(?RED_BAG_ETS, RedBagKey) end);
                false -> skip
            end,
            {ok, Bin} = pt_382:write(38201, {1, GetGold}),
            %%统计发红包玩家
            case Pkey == RegBag#red_bag.pkey of
                true -> skip;
                false ->
                    Msg = io_lib:format(?T("~s成功抢到你的红包，获得~p元宝"), [PName, GetGold]),
                    {ok, Bin1} = pt_382:write(38202, {Msg}),
                    server_send:send_to_key(RegBag#red_bag.pkey, Bin1),
                    server_send:send_to_sid(PSid, Bin)
            end,
            %%成功反馈
            Pid ! {apply_state, {red_bag, open_result, [1, GetGold]}},
            ?CAST(self(), {get_guild_red_bag_info, RedBagKey, Pkey, PSid})
    end,
    {noreply, State};

%%打开帮派红包
handle_cast({open_red_bag_guild, RedBagKey, {Pkey, PName, Career, Sex, Avatar, PSid, Pid, Gkey}}, State) ->
    case check_open_red_bag_guild(RedBagKey, Pkey, Gkey) of
        {false, Res} ->
            {ok, Bin} = pt_382:write(38211, {Res, 0}),
            server_send:send_to_sid(PSid, Bin);
        {ok, Dwgold, RegBag, GetGold, _Base} ->
            NewGoldList =
                case lists:keyfind(Dwgold, 1, RegBag#red_bag.gold_list) of
                    false -> [{Dwgold, 1} | RegBag#red_bag.gold_list];
                    {_, OldNum} -> [{Dwgold, OldNum + 1} | lists:keydelete(Dwgold, 1, RegBag#red_bag.gold_list)]
                end,
            GPinfo = #red_bag_g_p{
                pkey = Pkey,
                name = PName,
                career = Career,
                sex = Sex,
                avatar = Avatar,
                get_gold = GetGold
            },
            NewRegBag = RegBag#red_bag{
                get_gold = RegBag#red_bag.get_gold + GetGold,
                get_num = RegBag#red_bag.get_num + 1,
                guild_get_list = RegBag#red_bag.guild_get_list ++ [GPinfo],
                gold_list = NewGoldList
            },
            ets:insert(?RED_BAG_ETS, NewRegBag),
            {ok, Bin} = pt_382:write(38211, {1, GetGold}),
            %%统计发红包玩家
            case Pkey == RegBag#red_bag.pkey of
                true -> skip;
                false ->
                    server_send:send_to_sid(PSid, Bin),
                    Msg = io_lib:format(?T("~s成功抢到你的红包，获得~p元宝"), [PName, GetGold]),
                    {ok, Bin1} = pt_382:write(38202, {Msg}),
                    server_send:send_to_key(RegBag#red_bag.pkey, Bin1)
            end,
            %%成功反馈
            Pid ! {apply_state, {red_bag, open_result, [1, GetGold]}},
            ?CAST(self(), {get_guild_red_bag_info, RedBagKey, Pkey, PSid}),
            ok
    end,
    {noreply, State};

%%查看帮派红包
handle_cast({get_guild_red_bag_info, RedbagKey, Pkey, Sid}, State) ->
    case ets:lookup(?RED_BAG_ETS, RedbagKey) of
        [] -> skip;
        [RedBag | _] ->
            #red_bag{
                pkey = MainPkey,
                name = MainName,
                guild_get_list = GetList,
%%                avatar = Avatar,
                guild_red_type = GuildRedType
            } = RedBag,
            PlayerSd = shadow_proc:get_shadow(MainPkey),
            SortList = lists:reverse(lists:keysort(#red_bag_g_p.get_gold, GetList)),
            {MyGetGold, MyRank} =
                case lists:keyfind(Pkey, #red_bag_g_p.pkey, GetList) of
                    false -> {0, 0};
                    Rbp ->
                        #red_bag_g_p{
                            get_gold = MyGet
                        } = Rbp,
                        Nth = util:get_list_elem_index(Rbp, SortList),
                        {MyGet, Nth}
                end,
            F = fun(Rp, Order) ->
                #red_bag_g_p{
                    pkey = RPkey,
                    name = RName,
                    career = RCareer,
                    sex = RSex,
                    avatar = RAvatar,
                    get_gold = RGetGold
                } = Rp,
                {[Order, RPkey, RName, RCareer, RSex, RAvatar, RGetGold], Order + 1}
                end,
            {L, _} = lists:mapfoldl(F, 1, SortList),
            MainName1 =
                case GuildRedType of
                    2 -> io_lib:format(?T("~s伤害第一带你飞"), [MainName]);
                    _ -> MainName
                end,
            {ok, Bin} = pt_382:write(38212, {MainPkey, MainName1, PlayerSd#player.career, PlayerSd#player.sex,PlayerSd#player.avatar , MyGetGold, MyRank, L}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end,
    {noreply, State};

%%打开结婚红包
handle_cast({open_red_bag_marry, RedBagKey, {Pkey, PName, Career, Sex, Avatar, PSid, Pid}}, State) ->
    case check_open_red_bag_marry(RedBagKey, Pkey) of
        {false, Res} ->
            {ok, Bin} = pt_382:write(38215, {Res, 0}),
            server_send:send_to_sid(PSid, Bin);
        {ok, Dwgold, RegBag, GetGold, _Base} ->
            NewGoldList =
                case lists:keyfind(Dwgold, 1, RegBag#red_bag.gold_list) of
                    false -> [{Dwgold, 1} | RegBag#red_bag.gold_list];
                    {_, OldNum} -> [{Dwgold, OldNum + 1} | lists:keydelete(Dwgold, 1, RegBag#red_bag.gold_list)]
                end,
            GPinfo = #red_bag_g_p{
                pkey = Pkey,
                name = PName,
                career = Career,
                sex = Sex,
                avatar = Avatar,
                get_gold = GetGold
            },
            NewRegBag = RegBag#red_bag{
                get_gold = RegBag#red_bag.get_gold + GetGold,
                get_num = RegBag#red_bag.get_num + 1,
                guild_get_list = RegBag#red_bag.guild_get_list ++ [GPinfo],
                gold_list = NewGoldList
            },
            ets:insert(?RED_BAG_ETS, NewRegBag),
            {ok, Bin} = pt_382:write(38215, {1, GetGold}),
            %%统计发红包玩家
            case Pkey == RegBag#red_bag.pkey of
                true -> skip;
                false ->
                    server_send:send_to_sid(PSid, Bin),
                    Msg = io_lib:format(?T("~s成功抢到你的红包，获得~p元宝"), [PName, GetGold]),
                    {ok, Bin1} = pt_382:write(38202, {Msg}),
                    server_send:send_to_key(RegBag#red_bag.pkey, Bin1)
            end,
            %%成功反馈
            Pid ! {apply_state, {red_bag, open_result, [1, GetGold]}},
            ?CAST(self(), {get_marry_red_bag_info, RedBagKey, Pkey, PSid}),
            ok
    end,
    {noreply, State};

%%查看结婚红包
handle_cast({get_marry_red_bag_info, RedbagKey, Pkey, Sid}, State) ->
    case ets:lookup(?RED_BAG_ETS, RedbagKey) of
        [] -> skip;
        [RedBag | _] ->
            #red_bag{
                pkey = MainPkey,
                name = MainName,
                career = Career,
                sex = Sex,
                avatar = Avatar,
                couple_key = CoupleKey,
                couple_name = CoupleName,
                couple_career = CoupleCareer,
                couple_sex = CoupleSex,
                couple_avatar = CoupleAvatar,
                guild_get_list = GetList
            } = RedBag,
            SortList = lists:reverse(lists:keysort(#red_bag_g_p.get_gold, GetList)),
            {MyGetGold, MyRank} =
                case lists:keyfind(Pkey, #red_bag_g_p.pkey, GetList) of
                    false -> {0, 0};
                    Rbp ->
                        #red_bag_g_p{
                            get_gold = MyGet
                        } = Rbp,
                        Nth = util:get_list_elem_index(Rbp, SortList),
                        {MyGet, Nth}
                end,
            F = fun(Rp, Order) ->
                #red_bag_g_p{
                    pkey = RPkey,
                    name = RName,
                    career = RCareer,
                    sex = RSex,
                    avatar = RAvatar,
                    get_gold = RGetGold
                } = Rp,
                {[Order, RPkey, RName, RCareer, RSex, RAvatar, RGetGold], Order + 1}
                end,
            {L, _} = lists:mapfoldl(F, 1, SortList),
            {ok, Bin} = pt_382:write(38216, {MainPkey, MainName, Career, Sex, Avatar, CoupleKey, CoupleName, CoupleCareer, CoupleSex, CoupleAvatar, MyGetGold, MyRank, L}),
            server_send:send_to_sid(Sid, Bin),
            ok
    end,
    {noreply, State};


handle_cast(_Info, State) ->
    ?ERR("red_bag_handle cast info ~p~n", [_Info]),
    {noreply, State}.

%%红包公告
handle_info(red_bag_notice_time, State) ->
    util:cancel_ref([State#red_bag_st.ref]),
    Ref = erlang:send_after(?RED_BAG_NOTICE_TIME, self(), red_bag_notice_time),
    case State#red_bag_st.notice_list of
        [] -> {noreply, State#red_bag_st{ref = Ref}};
        [Notice | Tail] ->
            #redbag_notice{
                key = Key,
                msg = Msg
            } = Notice,
            case ets:lookup(?RED_BAG_ETS, Key) of
                [] ->
                    skip;
                [Redbag | _] ->
                    #red_bag{
                        type = Type,
                        gkey = Gkey,
                        scene = SceneId,
                        key = Key,
                        pkey = Pkey,
                        name = Name,
                        career = Career,
                        sex = Sex,
                        avatar = Avatar,
                        couple_key = C_Key,
                        couple_name = C_Name,
                        couple_career = C_Career,
                        couple_sex = C_Sex,
                        couple_avatar = C_Avatar,
                        guild_red_type = GuildRedType
                    } = Redbag,
                    ?DEBUG("redbag type ~p~n", [Type]),
                    case Type of
                        1 ->
                            {ok, Bin} = pt_382:write(38203, {Key, Msg}),
                            server_send:send_to_all(Bin);
                        2 ->
                            {ok, Bin} = pt_382:write(38213, {[[Key, Gkey, Name, Msg, GuildRedType]]}),
                            server_send:send_to_guild(Gkey, Bin);
                        3 ->
                            {ok, Bin} = pt_382:write(38217, {Key, Pkey, Name, Career, Sex, Avatar, C_Key, C_Name, C_Career, C_Sex, C_Avatar}),
                            server_send:send_to_scene(SceneId, Bin);
                        _ ->
                            if Gkey == 0 ->
                                {ok, Bin} = pt_382:write(38203, {Key, Msg}),
                                server_send:send_to_all(Bin);
                                true ->
                                    {ok, Bin} = pt_382:write(38213, {[[Key, Gkey, Name, Msg, GuildRedType]]}),
                                    server_send:send_to_guild(Gkey, Bin)
                            end
                    end
            end,
            {noreply, State#red_bag_st{notice_list = Tail, ref = Ref}}
    end;

%%检查红包过期
handle_info(check_red_bag_expire_time, State) ->
    util:cancel_ref([State#red_bag_st.expire_ref]),
    Ref = erlang:send_after(?RED_BAG_EXPIRE_CHECT_TIME * 1000, self(), check_red_bag_expire_time),
    Now = util:unixtime(),
    %%删除过期红包
    MS = ets:fun2ms(fun(Rb) when Now - Rb#red_bag.time >= ?RED_BAG_EXPIRE_TIME -> Rb end),
    ExpireList = ets:select(?RED_BAG_ETS, MS),
    [ets:delete(?RED_BAG_ETS, R#red_bag.key) || R <- ExpireList],
    {noreply, State#red_bag_st{expire_ref = Ref}};

handle_info(_Info, State) ->
    ?ERR("red_bag_handle info ~p~n", [_Info]),
    {noreply, State}.

check_open_red_bag(RedBagKey, Pkey) ->
    case ets:lookup(?RED_BAG_ETS, RedBagKey) of
        [] -> {false, 2};
        [RedBag | _] ->
            #red_bag{
                gkey = Gkey,
                goods_id = GoodsId,
                get_num = GetNum,
                get_list = GetList
            } = RedBag,
            Base = data_red_bag:get(GoodsId),
            #base_red_bag{
                max_num = MaxNum,
                random_id = RandomId
            } = Base,
            RandList = data_red_bag_random:get(RandomId),
            if
                Gkey =/= 0 -> {false, 2};
                GetNum >= MaxNum -> {false, 2};
                RandList == [] -> {false, 2};
                true ->
                    case lists:member(Pkey, GetList) of
                        true -> {false, 5};
                        false ->
                            MyGetGold = util:list_rand_ratio(RandList),
                            {ok, RedBag, MyGetGold, Base}
                    end
            end
    end.

check_open_red_bag_guild(RedBagKey, Pkey, MyGkey) ->
    case ets:lookup(?RED_BAG_ETS, RedBagKey) of
        [] -> {false, 2};
        [RedBag | _] ->
            #red_bag{
                gkey = Gkey,
                goods_id = GoodsId,
                get_num = GetNum,
                guild_get_list = GetPlayerList,
                guild_get_count_list = GetCountList
            } = RedBag,
            Base = data_red_bag_guild:get(GoodsId),
            #base_red_bag_guild{
                max_num = MaxNum,
                gold_list = DwgoldList %%档位列表
            } = Base,
            if
                Gkey == 0 -> {false, 2};
                GetNum >= MaxNum -> {false, 2};
                MyGkey =/= Gkey -> {false, 6};
                true ->
                    case lists:keyfind(Pkey, #red_bag_g_p.pkey, GetPlayerList) of
                        false ->
                            %%档位 Dwgold
                            F = fun({BagNum, Dwgold}) ->
                                case lists:keyfind(Dwgold, 1, GetCountList) of
                                    false -> [{Dwgold, BagNum}];
                                    {_, GetNum} ->
                                        case GetNum >= BagNum of
                                            true -> %%该档位领取个数已达上限
                                                [];
                                            false ->
                                                [{Dwgold, BagNum}]
                                        end
                                end
                                end,
                            CanGetList = lists:flatmap(F, DwgoldList),
                            {Min, Max} = util:list_rand_ratio(CanGetList),
                            MyGetGold = util:rand(Min, Max),
                            Dw = {Min, Max},
                            {ok, Dw, RedBag, MyGetGold, Base};
                        _ ->
                            {false, 5}
                    end
            end
    end.
check_open_red_bag_marry(RedBagKey, Pkey) ->
    case ets:lookup(?RED_BAG_ETS, RedBagKey) of
        [] -> {false, 2};
        [RedBag | _] ->
            #red_bag{
                goods_id = GoodsId,
                get_num = GetNum,
                guild_get_list = GetPlayerList,
                guild_get_count_list = GetCountList
            } = RedBag,
            Base = data_red_bag_guild:get(GoodsId),
            #base_red_bag_guild{
                max_num = MaxNum,
                gold_list = DwgoldList %%档位列表
            } = Base,
            if
                GetNum >= MaxNum -> {false, 2};
                true ->
                    case lists:keyfind(Pkey, #red_bag_g_p.pkey, GetPlayerList) of
                        false ->
                            %%档位 Dwgold
                            F = fun({BagNum, Dwgold}) ->
                                case lists:keyfind(Dwgold, 1, GetCountList) of
                                    false -> [{Dwgold, BagNum}];
                                    {_, GetNum} ->
                                        case GetNum >= BagNum of
                                            true -> %%该档位领取个数已达上限
                                                [];
                                            false ->
                                                [{Dwgold, BagNum}]
                                        end
                                end
                                end,
                            CanGetList = lists:flatmap(F, DwgoldList),
                            {Min, Max} = util:list_rand_ratio(CanGetList),
                            MyGetGold = util:rand(Min, Max),
                            Dw = {Min, Max},
                            {ok, Dw, RedBag, MyGetGold, Base};
                        _ ->
                            {false, 5}
                    end
            end
    end.