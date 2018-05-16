%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2017 下午8:06
%%%-------------------------------------------------------------------
-module(hot_well_handle).
-author("fengzhenlin").
-include("common.hrl").
-include("hot_well.hrl").
-include("scene.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(get_state, _From, State) ->
    {reply, State#hot_well_st.state, State};

handle_call(_Info, _From, State) ->
    {reply, ok, State}.

handle_cast({get_state, _Pkey, Sid, Node}, State) ->
    Now = util:unixtime(),
    {S, T} =
        if
            State#hot_well_st.state == 0 -> {0, 0};
            State#hot_well_st.state == 1 ->
                {1, State#hot_well_st.end_time - Now};
            State#hot_well_st.state == 2 ->
                {2, State#hot_well_st.end_time - Now};
            true ->
                {0, 0}
        end,
    {ok, Bin} = pt_583:write(58301, {S, T}),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({enter_hot_well, Mb}, State) ->
    case ets:lookup(?ETS_HOT_WELL, Mb#hot_well.pkey) of
        [] ->
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_HOT_WELL, 0),
            HotWell = Mb#hot_well{copy = Copy, is_leave = 0},
            ets:insert(?ETS_HOT_WELL, HotWell);
        [HotWell | _] ->
            Copy = scene_copy_proc:get_scene_copy(?SCENE_ID_HOT_WELL, 0),
            NewHotWell = HotWell#hot_well{
                copy = Copy,
                is_leave = 0,
                sid = Mb#hot_well.sid,
                sex = Mb#hot_well.sex,
                vip_lv = Mb#hot_well.vip_lv,
                pid = Mb#hot_well.pid,
                node = Mb#hot_well.node
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell)
    end,
    server_send:send_node_pid(Mb#hot_well.node, Mb#hot_well.pid, {enter_hot_well, Copy}),
    {noreply, State};

handle_cast({exit_hot_well, Pkey, Sid}, State) ->
    case ets:lookup(?ETS_HOT_WELL, Pkey) of
        [] -> skip;
        [HotWell | _] ->
            NewHotWell = HotWell#hot_well{
                is_leave = 1,
                sx_apply_time = 0,
                copy = 0
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell)
    end,
    handle_cast({stop_sx, Pkey, Sid}, State);

handle_cast({get_info, Node, Pkey, Sid}, State) ->
    case ets:lookup(?ETS_HOT_WELL, Pkey) of
        [] ->
            skip;
        [HotWell | _] ->
            Now = util:unixtime(),
            LeaveTime = max(0, State#hot_well_st.end_time - Now),
            #hot_well{
                sum_exp = SumExp,
                vip_lv = VipLv,
                sx_state = SxState,
                sx_pkey = SxPkey,
                joke_times = JokeTimes,
                joke_cd_time = JokeCdTime,
                joke_exp = JokeExp
            } = HotWell,
            JokeLeaveTimes = max(0, ?MAX_JOKE_TIMES - JokeTimes),
            JokeCd = max(0, JokeCdTime - Now),
            VipX = max(0, round(data_vip_args:get(57, VipLv) * 100)),
            Data = {LeaveTime, SumExp, VipLv, VipX, SxState, SxPkey, JokeLeaveTimes, ?MAX_JOKE_TIMES, JokeCd, JokeExp},
            {ok, Bin} = pt_583:write(58304, Data),
            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

handle_cast({apply_sx, Node, Pkey, Sid}, State) ->
    Res =
        case ets:lookup(?ETS_HOT_WELL, Pkey) of
            [] -> 0;
            [HotWell | _] ->
                case HotWell#hot_well.sx_state == 1 of
                    true -> 5;
                    false ->
                        Now = util:unixtime(),
                        NewHotWell = HotWell#hot_well{
                            sx_apply_time = Now
                        },
                        ets:insert(?ETS_HOT_WELL, NewHotWell),
                        1
                end
        end,
    ?DEBUG("time ~p~n",[util:unixtime()]),
    {ok, Bin} = pt_583:write(58305, {Res}),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({stop_sx, Pkey, Sid}, State) ->
    case ets:lookup(?ETS_HOT_WELL, Pkey) of
        [] -> skip;
        [HotWell | _] when HotWell#hot_well.sx_state == 0 -> skip;
        [HotWell | _] ->
            #hot_well{
                sx_pkey = SxPkey
            } = HotWell,
            NewHotWell = HotWell#hot_well{
                sx_state = 0,
                sx_pkey = 0
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell),
            {ok, Bin} = pt_583:write(58307, {1, 0}),
            server_send:send_to_sid(Sid, Bin),
            center:apply(HotWell#hot_well.node, server_send, send_to_sid, [Sid, Bin]),
            ?CAST(hot_well_proc:get_server_pid(), {get_info, HotWell#hot_well.node, HotWell#hot_well.pkey, HotWell#hot_well.sid}),
            server_send:send_node_pid(HotWell#hot_well.node, HotWell#hot_well.pid, {hot_well, 0, 0}),

            case ets:lookup(?ETS_HOT_WELL, SxPkey) of
                [] ->
                    skip;
                [SxHotWell | _] ->
                    NewSxHotWell = SxHotWell#hot_well{
                        sx_state = 0,
                        sx_pkey = 0
                    },
                    ets:insert(?ETS_HOT_WELL, NewSxHotWell),
                    {ok, Bin2} = pt_583:write(58307, {1, 1}),
                    center:apply(SxHotWell#hot_well.node, server_send, send_to_key, [SxPkey, Bin2]),
                    ?CAST(hot_well_proc:get_server_pid(), {get_info, SxHotWell#hot_well.node, SxHotWell#hot_well.pkey, SxHotWell#hot_well.sid}),
                    server_send:send_node_pid(SxHotWell#hot_well.node, SxHotWell#hot_well.pid, {hot_well, 0, 0})
            end
    end,
    {noreply, State};

%%开始双修
handle_cast({start_sx, Node, Pkey, _Sid}, State) ->
    case ets:lookup(?ETS_HOT_WELL, Pkey) of
        [] -> skip;
        [HotWell | _] ->
            #hot_well{
                sx_pkey = SxPkey
            } = HotWell,
            case ets:lookup(?ETS_HOT_WELL, SxPkey) of
                [] -> skip;
                [SxHotWell | _] ->
                    server_send:send_node_pid(Node, HotWell#hot_well.pid, {hot_well, 1, SxHotWell#hot_well.pkey}),
                    case center:get_node_by_sn(SxHotWell#hot_well.sn) of
                        false ->
                            skip;
                        SxNode ->
                            server_send:send_node_pid(SxNode, SxHotWell#hot_well.pid, {hot_well, 1, HotWell#hot_well.pkey})
                    end
            end
    end,
    {noreply, State};

%%发起整蛊
handle_cast({start_joke, Node, MyPkey, Sid, Pkey}, State) ->
    Res =
        case ets:lookup(?ETS_HOT_WELL, MyPkey) of
            [] -> {false, 0};
            [MyHotWell | _] ->
                case ets:lookup(?ETS_HOT_WELL, Pkey) of
                    [] -> {false, 0};
                    [HotWell | _] ->
                        #hot_well{
                            joke_times = JokeTimes,
                            joke_cd_time = JokeCdTime,
                            sum_exp = SumExp,
                            joke_exp = JokeExp,
                            copy = Copy
                        } = MyHotWell,
                        Now = util:unixtime(),
                        ScenePlayer = scene_agent:get_scene_player(?SCENE_ID_HOT_WELL, Copy, MyPkey),
                        if
                            ScenePlayer == [] -> {false, 0};
                            JokeTimes >= ?MAX_JOKE_TIMES -> {false, 6};
                            JokeCdTime > Now -> {false, 7};
                            true ->
                                %%加经验
                                BaseExp = data_hot_well:get(ScenePlayer#scene_player.lv),
                                SxX = ?IF_ELSE(MyHotWell#hot_well.sx_state == 1, 1.2, 1),
                                VipX = max(0, data_vip_args:get(57, ScenePlayer#scene_player.vip)),
                                AddExp = util:ceil(BaseExp * SxX * VipX) * 24,
                                HotWell#hot_well.pid ! {apply_state, {hot_well, reward_exp, [AddExp, []]}},

                                NewMyHotWell = MyHotWell#hot_well{
                                    joke_times = JokeTimes + 1,
                                    joke_cd_time = Now + ?JOKE_CD_TIME,
                                    sum_exp = AddExp + SumExp,
                                    joke_exp = AddExp + JokeExp
                                },
                                ets:insert(?ETS_HOT_WELL, NewMyHotWell),

                                {ok, Bin0} = pt_583:write(58310, {1, Pkey}),
                                server_send:send_to_sid(Sid, Bin0),
                                center:apply(Node, server_send, send_to_sid, [Sid, Bin0]),

                                case center:get_node_by_sn(HotWell#hot_well.sn) of
                                    false ->
                                        skip;
                                    Node1 ->
                                        {ok, Bin} = pt_583:write(58311, {MyPkey}),
                                        center:apply(Node1, server_send, send_to_sid, [HotWell#hot_well.sid, Bin]),
                                        ok
                                end
                        end
                end
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin1} = pt_583:write(58310, {Reason, Pkey}),
            center:apply(Node, server_send, send_to_sid, [Sid, Bin1]);
        _ ->
            ok
    end,
    {noreply, State};

handle_cast({invite_sx, Node, Pkey, Sid, ElsePkey}, State) ->
    Res =
        case ets:lookup(?ETS_HOT_WELL, Pkey) of
            [] -> {false, 0};
            [MyHotWell | _] ->
                case ets:lookup(?ETS_HOT_WELL, ElsePkey) of
                    [] -> {false, 9};
                    [HotWell | _] ->
                        if
                            MyHotWell#hot_well.sx_state == 1 -> {false, 5};
                            HotWell#hot_well.sx_state == 1 -> {false, 5};
                            true ->
                                do_sx_match([MyHotWell], [HotWell]),
                                ok
                        end
                end
        end,
    case Res of
        {false, Reason} ->
            {ok, Bin} = pt_583:write(58309, {Reason}),
            center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
            ok;
        _ ->
            {ok, Bin} = pt_583:write(58309, {1}),
            center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
            ok
    end,
    {noreply, State};

handle_cast(_Info, State) ->
    {noreply, State}.


handle_info({ready_hot_well, Time}, State) ->
    Now = util:unixtime(),
    NewState = State#hot_well_st{
        state = 2,
        end_time = Now + Time
    },
    {ok, Bin} = pt_583:write(58301, {2, Time}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
    end,
    lists:foreach(F, center:get_nodes()),
    {noreply, NewState};

handle_info({open_hot_well, OpenTime}, State) ->
    util:cancel_ref([State#hot_well_st.end_ref]),
    Now = util:unixtime(),
    Ref = erlang:send_after(OpenTime * 1000, self(), end_hot_well),
    ExpRef = erlang:send_after(?EXP_TIME * 1000, self(), time_to_exp),
    MatchRef = erlang:send_after(?SX_TIME * 1000, self(), time_match_sx),
    NewState = State#hot_well_st{
        state = 1,
        open_time = Now,
        end_time = Now + OpenTime,
        end_ref = Ref,
        exp_ref = ExpRef,
        sx_ref = MatchRef
    },
    {ok, Bin} = pt_583:write(58301, {1, OpenTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
    end,
    lists:foreach(F, center:get_nodes()),
    %%玩法找回
    findback_src:update_act_time(37, Now),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_HOT_WELL),
    {noreply, NewState};

handle_info(end_hot_well, State) ->
    util:cancel_ref([State#hot_well_st.end_ref, State#hot_well_st.exp_ref, State#hot_well_st.sx_ref]),
    NewState = State#hot_well_st{
        state = 0,
        open_time = 0,
        end_time = 0,
        end_ref = 0
    },
    ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_HOT_WELL),
    F = fun(ScenePlayer) ->
        ScenePlayer#scene_player.pid ! {apply_state, {hot_well, send_out, []}}
    end,
    lists:foreach(F, ScenePlayerList),

    {ok, Bin} = pt_583:write(58301, {0, 0}),
    F0 = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
    end,
    lists:foreach(F0, center:get_nodes()),
    ets:delete_all_objects(?ETS_HOT_WELL),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_HOT_WELL),
    {noreply, NewState};

handle_info(time_to_exp, State) ->
    util:cancel_ref([State#hot_well_st.exp_ref]),
    case State#hot_well_st.state == 1 of
        true ->
            Ref = erlang:send_after(?EXP_TIME * 1000, self(), time_to_exp),
            NewState = State#hot_well_st{
                exp_ref = Ref
            },
            do_exp_reward(),
            {noreply, NewState};
        false ->
            {noreply, State}
    end;

%%双修匹配
handle_info(time_match_sx, State) ->
    util:cancel_ref([State#hot_well_st.sx_ref]),
    Ref = erlang:send_after(?SX_TIME * 1000, self(), time_match_sx),
    MS = ets:fun2ms(fun(Hw) when Hw#hot_well.sx_apply_time > 0 andalso Hw#hot_well.sex == 1 andalso Hw#hot_well.is_leave == 0 ->
        Hw end),
    MS2 = ets:fun2ms(fun(Hw) when Hw#hot_well.sx_apply_time > 0 andalso Hw#hot_well.sex == 2 andalso Hw#hot_well.is_leave == 0 ->
        Hw end),
    All1 = ets:select(?ETS_HOT_WELL, MS),
    All2 = ets:select(?ETS_HOT_WELL, MS2),
    SortList1 = lists:keysort(#hot_well.sx_apply_time, All1),
    SortList2 = lists:keysort(#hot_well.sx_apply_time, All2),

    %%根据房间匹配
    F = fun(Hw, AccList) ->
        case lists:keyfind(Hw#hot_well.copy, 1, AccList) of
            false -> [{Hw#hot_well.copy, [Hw]} | AccList];
            {_, List} -> lists:keyreplace(Hw#hot_well.copy, 1, AccList, {Hw#hot_well.copy, [Hw | List]})
        end
    end,
    CopyList1 = lists:foldl(F, [], SortList1),
    CopyList2 = lists:foldl(F, [], SortList2),
    Fc = fun({Copy, _}, CopyList) ->
        case lists:member(Copy, CopyList) of
            true -> CopyList;
            false -> [Copy | CopyList]
        end
    end,
    AllCopy = lists:foldl(Fc, [], CopyList1 ++ CopyList2),
    F1 = fun(Copy) ->
        MatchList1 =
            case lists:keyfind(Copy, 1, CopyList1) of
                false -> [];
                {_, List1} -> List1
            end,
        MatchList2 =
            case lists:keyfind(Copy, 1, CopyList2) of
                false -> [];
                {_, List2} -> List2
            end,
        %%没有匹配上的，随机找一个双修
        case do_sx_match(MatchList1, MatchList2) of
            {[Hd], []} ->
                MS3 = ets:fun2ms(fun(Hw) when Hw#hot_well.sx_state == 0
                    andalso Hw#hot_well.sx_apply_time == 0
                    andalso Hw#hot_well.is_leave == 0
                    andalso Hw#hot_well.copy == Copy -> Hw end),
                All3 = ets:select(?ETS_HOT_WELL, MS3),
                All30 = util:list_shuffle(All3),
                SortList3 = lists:keysort(#hot_well.sex, All30),
                case SortList3 of
                    [] -> skip;
                    _ -> do_sx_match([Hd], [lists:last(SortList3)])
                end;
            {[], [Hd]} ->
                MS3 = ets:fun2ms(fun(Hw) when Hw#hot_well.sx_state == 0
                    andalso Hw#hot_well.sx_apply_time == 0
                    andalso Hw#hot_well.is_leave == 0
                    andalso Hw#hot_well.copy == Copy -> Hw end),
                All3 = ets:select(?ETS_HOT_WELL, MS3),
                All30 = util:list_shuffle(All3),
                SortList3 = lists:keysort(#hot_well.sex, All30),
                case SortList3 of
                    [] -> skip;
                    _ -> do_sx_match([Hd], [hd(SortList3)])
                end;
            _ ->
                skip
        end
    end,
    lists:foreach(F1, AllCopy),
    {noreply, State#hot_well_st{sx_ref = Ref}};

handle_info(_Info, State) ->
    {noreply, State}.


%%定时给经验
do_exp_reward() ->
    ScenePlayerList = scene_agent:get_scene_player(?SCENE_ID_HOT_WELL),
    do_exp_reward_1(ScenePlayerList),
    ok.
do_exp_reward_1([]) ->
    skip;
do_exp_reward_1([ScenePlayer | Tail]) ->
    #scene_player{
        key = Pkey,
        vip = VipLv
    } = ScenePlayer,
    case ets:lookup(?ETS_HOT_WELL, Pkey) of
        [] ->
            ok;
%%            ?ERR("can not find hot well player ~p~n", [Pkey]);
        [HotWell | _] ->
            BaseExp = data_hot_well:get(ScenePlayer#scene_player.lv),
            SxX = ?IF_ELSE(HotWell#hot_well.sx_state == 1, 1.2, 1),
            VipX = max(0, data_vip_args:get(57, ScenePlayer#scene_player.vip)),
            AddExp = util:ceil(BaseExp * SxX * VipX),
            ElseExp = round(AddExp - BaseExp),
            NewHotWell = HotWell#hot_well{
                sum_exp = HotWell#hot_well.sum_exp + AddExp,
                vip_lv = VipLv
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell),

            HotWell#hot_well.pid ! {apply_state, {hot_well, reward_exp, [AddExp, [[5, ElseExp]]]}},

            ?CAST(hot_well_proc:get_server_pid(), {get_info, HotWell#hot_well.node, Pkey, HotWell#hot_well.sid})
    end,
    do_exp_reward_1(Tail).

%%进行双修匹配
do_sx_match([], []) -> {[], []};
do_sx_match([HotWell1], []) -> {[HotWell1], []};
do_sx_match([HotWell1, HotWell2 | Tail], []) ->
    start_sx(HotWell1, HotWell2),
    do_sx_match(Tail, []);
do_sx_match([], [HotWell1]) -> {[], [HotWell1]};
do_sx_match([], [HotWell1, HotWell2 | Tail]) ->
    start_sx(HotWell1, HotWell2),
    do_sx_match([], Tail);
do_sx_match([HotWell1 | Tail1], [HotWell2 | Tail2]) ->
    start_sx(HotWell1, HotWell2),
    do_sx_match(Tail1, Tail2).
%%开始双修
start_sx(HotWell1, HotWell2) ->
    ScenePlayer1 = scene_agent:get_scene_player(?SCENE_ID_HOT_WELL, HotWell1#hot_well.copy, HotWell1#hot_well.pkey),
    ScenePlayer2 = scene_agent:get_scene_player(?SCENE_ID_HOT_WELL, HotWell2#hot_well.copy, HotWell2#hot_well.pkey),
    if
        ScenePlayer1 == [] orelse ScenePlayer2 == [] ->
%%            ?ERR("can not find scene player in hot_well ~p~n", [{HotWell1#hot_well.pkey, HotWell2#hot_well.pkey}]),
            ok;
        true ->
            NewHotWell1 = HotWell1#hot_well{
                sx_apply_time = 0,
                sx_state = 1,
                sx_pkey = HotWell2#hot_well.pkey
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell1),

            NewHotWell2 = HotWell2#hot_well{
                sx_apply_time = 0,
                sx_state = 1,
                sx_pkey = HotWell1#hot_well.pkey
            },
            ets:insert(?ETS_HOT_WELL, NewHotWell2),


            Data1 = {1, HotWell2#hot_well.pkey, ScenePlayer2#scene_player.x, ScenePlayer2#scene_player.y},
            Data2 = {0, HotWell1#hot_well.pkey, ScenePlayer1#scene_player.x, ScenePlayer1#scene_player.y},
            {ok, Bin1} = pt_583:write(58306, Data1),
            {ok, Bin2} = pt_583:write(58306, Data2),
            server_send:send_to_sid(HotWell1#hot_well.sid, Bin1),
            server_send:send_to_sid(HotWell2#hot_well.sid, Bin2),
            ok
    end.

