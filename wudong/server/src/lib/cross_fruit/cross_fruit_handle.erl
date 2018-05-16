%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 上午10:23
%%%-------------------------------------------------------------------
-module(cross_fruit_handle).
-author("fengzhenlin").
-include("common.hrl").
-include("cross_fruit.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2]).

-export([
    pack_player/1,
    refresh_week_rank/0
]).

handle_call(_Info, _From, State) ->
    ?DEBUG("cross_fruit_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

%%取消匹配
handle_cast({apply_match, FruitPlayer, 0, _IsInvite}, State) ->
    Res =
        case get_fruit_player(FruitPlayer#cross_fruit_player.pkey) of
            [] -> 1;
            OldFruitPlayer ->
                case OldFruitPlayer#cross_fruit_player.state == 1 of
                    true -> 2;
                    false ->
                        NewFruitPlayer = OldFruitPlayer#cross_fruit_player{
                            apply_time = 0
                        },
                        update_fruit_player(NewFruitPlayer),
                        1
                end
        end,
    {ok, Bin} = pt_582:write(58202, {Res}),
    server_send:send_to_sid(FruitPlayer#cross_fruit_player.node, FruitPlayer#cross_fruit_player.sid, Bin),
%%    center:apply(FruitPlayer#cross_fruit_player.node, server_send, send_to_sid, [FruitPlayer#cross_fruit_player.sid, Bin]),
    {noreply, State};

%%申请匹配
handle_cast({apply_match, FruitPlayer, 1, IsInvite}, State) ->
    Now = util:unixtime(),
    InviteTime = ?IF_ELSE(IsInvite == 1, Now, 0),
    Res =
        case get_fruit_player(FruitPlayer#cross_fruit_player.pkey) of
            [] ->
                NewFP = FruitPlayer#cross_fruit_player{
                    apply_time = Now,
                    invite_time = InviteTime
                },
                update_fruit_player(NewFP),
                1;
            OldFruitPlayer ->
                OldFruitPlayer1 = OldFruitPlayer#cross_fruit_player{
                    node = FruitPlayer#cross_fruit_player.node,
                    sid = FruitPlayer#cross_fruit_player.sid,
                    vatar = FruitPlayer#cross_fruit_player.vatar,
                    sn = FruitPlayer#cross_fruit_player.sn,
                    name = FruitPlayer#cross_fruit_player.name
                },
                case OldFruitPlayer#cross_fruit_player.apply_time > 0 of
                    true ->
                        NewFP = OldFruitPlayer1#cross_fruit_player{
                            invite_time = InviteTime
                        },
                        update_fruit_player(NewFP),
                        1;
                    false ->
                        case OldFruitPlayer#cross_fruit_player.state == 1 of
                            true -> 2;
                            false ->
                                NewFP = OldFruitPlayer1#cross_fruit_player{
                                    apply_time = Now,
                                    invite_time = InviteTime
                                },
                                update_fruit_player(NewFP),
                                1
                        end

                end
        end,
    {ok, Bin} = pt_582:write(58202, {Res}),
    server_send:send_to_sid(FruitPlayer#cross_fruit_player.node, FruitPlayer#cross_fruit_player.sid, Bin),
%%    center:apply(FruitPlayer#cross_fruit_player.node, server_send, send_to_sid, [FruitPlayer#cross_fruit_player.sid, Bin]),
    {noreply, State};

%%邀请匹配
handle_cast({apply_match_invite, MyPkey, Pkey}, State) ->
    case get_fruit_player(MyPkey) of
        [] -> skip;
        FP ->
            Res =
                case get_fruit_player(Pkey) of
                    [] ->
                        cross_fruit_proc:apply_match(FP, 0, 0),
                        ?T("对方已不在匹配队列");
                    FP2 ->
                        if
                            FP#cross_fruit_player.state == 1 ->
                                ?T("你已在大作战中");
                            FP2#cross_fruit_player.apply_time == 0 ->
                                cross_fruit_proc:apply_match(FP, 0, 0),
                                ?T("对方已不在匹配队列");
                            FP2#cross_fruit_player.state == 1 ->
                                cross_fruit_proc:apply_match(FP, 0, 0),
                                ?T("对方已不在匹配队列");
                            true ->
                                Now = util:unixtime(),
                                do_match_1([FP, FP2], Now),
                                ?T("成功")
                        end
                end,
            {ok, Bin} = pt_582:write(58222, {Res}),
            server_send:send_to_sid(FP#cross_fruit_player.node, FP#cross_fruit_player.sid, Bin),
%%            center:apply(FP#cross_fruit_player.node, server_send, send_to_sid, [FP#cross_fruit_player.sid, Bin]),
            ok
    end,
    {noreply, State};

%%继续
handle_cast({continue, MyPkey, Pkey}, State) ->
    case get_fruit_player(MyPkey) of
        [] -> skip;
        FP ->
            Res =
                case get_fruit_player(Pkey) of
                    [] ->
                        ?T("成功");
                    FP2 ->
                        if
                            FP#cross_fruit_player.state == 1 ->
                                ?T("你已在大作战中");
                            FP2#cross_fruit_player.apply_time == 0 ->
                                erlang:send_after(5000, self(), {continue_check, MyPkey, Pkey}),
                                ?T("对方已不在匹配队列");
                            FP2#cross_fruit_player.state == 1 ->
                                ?T("对方已经开始了大作战");
                            true ->
                                Now = util:unixtime(),
                                do_match_1([FP, FP2], Now),
                                ?T("成功")
                        end
                end,
            {ok, Bin} = pt_582:write(58222, {Res}),
            server_send:send_to_sid(FP#cross_fruit_player.node, FP#cross_fruit_player.sid, Bin),
%%            center:apply(FP#cross_fruit_player.node, server_send, send_to_sid, [FP#cross_fruit_player.sid, Bin]),
            ok
    end,
    {noreply, State};

%%获取当前比赛信息
handle_cast({get_fight_info, Pkey}, State) ->
    get_fight_info(Pkey),
    {noreply, State};

%%玩家操作
handle_cast({operate, Pkey, Type, Pos}, State) ->
    Now = util:unixtime(),
    case get_fruit_player(Pkey) of
        [] ->
            ?DEBUG("can not find fruit_player when operate ~p~n", [Pkey]),
            skip;
        FP when Now =< FP#cross_fruit_player.next_round_time -> skip;
        FP ->
            #cross_fruit_player{
                fkey = FKey,
                target = MyTarget
            } = FP,
            case get_fruit_fight(FKey) of
                [] ->
                    ?DEBUG("can not find fruit fight info when operate ~p~n", [FKey]),
                    skip;
                CF ->
                    #cross_fruit{
                        pkey1 = Pkey1,
                        pkey2 = Pkey2
                    } = CF,
                    ElesPkey = ?IF_ELSE(Pkey == Pkey1, Pkey2, Pkey1),
                    case Type of
                        0 -> %%点水箱
                            F = fun(#tg{type = FType} = Tg, AccTgList) ->
                                case FType of
                                    0 ->
                                        NewType = create_new_fruit_type(CF#cross_fruit.cur_target, AccTgList, FP#cross_fruit_player.click_times, Tg#tg.pos),
                                        NewTg =
                                            case NewType of
                                                ?FRUIT_TYPE_BOOM -> %%炸弹
                                                    Ref = erlang:send_after(3000, self(), {boom, FP#cross_fruit_player.pkey, FP#cross_fruit_player.fkey, Tg#tg.pos}),
                                                    Tg#tg{type = NewType, boom_ref = Ref, boom_time = util:unixtime(), change_type = 2};
                                                _ ->
                                                    Tg#tg{type = NewType, change_type = 2}
                                            end,
                                        lists:keyreplace(Tg#tg.pos, #tg.pos, AccTgList, NewTg);
                                    _ ->
                                        NewTg = Tg#tg{change_type = 0},
                                        lists:keyreplace(Tg#tg.pos, #tg.pos, AccTgList, NewTg)
                                end
                                end,
                            NewMyTarget = lists:foldl(F, MyTarget, MyTarget),
                            NewFP = FP#cross_fruit_player{
                                target = NewMyTarget,
                                click_times = FP#cross_fruit_player.click_times + 1
                            },
                            update_fruit_player(NewFP);
                        _ -> %%消除
                            Pos1 = ?IF_ELSE(Pos > 3 orelse Pos < 1, 1, Pos),
                            Tg0 = lists:keyfind(Pos1, #tg.pos, MyTarget),
                            Tg = Tg0#tg{change_type = 0},
                            case Tg#tg.type of
                                ?FRUIT_TYPE_DCR_TH -> %%替换稻草人替换对方水果
                                    FP2 = get_fruit_player(ElesPkey),
                                    Tg2 = util:list_rand(FP2#cross_fruit_player.target),
                                    util:cancel_ref([Tg2#tg.boom_ref]),
                                    NewTg2 = Tg2#tg{type = ?FRUIT_TYPE_DCR, click_times = 0, boom_ref = 0, boom_time = 0, change_type = 4},
                                    NewFP2 = FP2#cross_fruit_player{
                                        target = lists:keyreplace(Tg2#tg.pos, #tg.pos, FP2#cross_fruit_player.target, NewTg2)
                                    },
                                    update_fruit_player(NewFP2),
                                    Tg1 =
                                        case Tg2#tg.type of
                                            ?FRUIT_TYPE_BOOM ->
                                                NextTime = max(1, 3 - (Now - Tg2#tg.boom_time)),
                                                Ref = erlang:send_after(NextTime * 1000, self(), {boom, Pkey, CF#cross_fruit.fkey, Tg#tg.pos}),
                                                Tg#tg{
                                                    type = Tg2#tg.type,
                                                    click_times = 0,
                                                    boom_ref = Ref,
                                                    boom_time = Now - NextTime,
                                                    change_type = 3
                                                };
                                            _ ->
                                                Tg#tg{
                                                    type = Tg2#tg.type,
                                                    click_times = 0,
                                                    change_type = 3
                                                }
                                        end,
                                    NewFP = FP#cross_fruit_player{
                                        target = lists:keyreplace(Tg#tg.pos, #tg.pos, MyTarget, Tg1)
                                    },
                                    update_fruit_player(NewFP);
                                ?FRUIT_TYPE_DCR -> %%点击稻草人
                                    NewTg =
                                        case Tg#tg.click_times + 1 >= 3 of
                                            true ->
                                                Tg#tg{
                                                    type = 0,
                                                    click_times = 0
                                                };
                                            false ->
                                                Tg#tg{
                                                    click_times = Tg#tg.click_times + 1
                                                }
                                        end,
                                    NewFP = FP#cross_fruit_player{
                                        target = lists:keyreplace(Tg#tg.pos, #tg.pos, MyTarget, NewTg)
                                    },
                                    update_fruit_player(NewFP);
                                ?FRUIT_TYPE_STONE -> %%岩石
                                    NewTg =
                                        case Tg#tg.click_times + 1 >= 5 of
                                            true ->
                                                Tg#tg{
                                                    type = 0,
                                                    click_times = 0
                                                };
                                            false ->
                                                Tg#tg{
                                                    click_times = Tg#tg.click_times + 1
                                                }
                                        end,
                                    NewFP = FP#cross_fruit_player{
                                        target = lists:keyreplace(Tg#tg.pos, #tg.pos, MyTarget, NewTg)
                                    },
                                    update_fruit_player(NewFP);
                                ?FRUIT_TYPE_BOOM -> %%炸弹
                                    skip;
                                ClickType when ClickType >= 1 andalso ClickType =< 3 ->
                                    NewTg = Tg#tg{
                                        type = 0,
                                        click_times = 0,
                                        change_type = 0
                                    },
                                    NewFP = FP#cross_fruit_player{
                                        target = lists:keyreplace(Tg#tg.pos, #tg.pos, MyTarget, NewTg)
                                    },
                                    update_fruit_player(NewFP);
                                _ ->
                                    skip
                            end
                    end,
                    %%通知客户端
                    get_fight_info(Pkey1),
                    get_fight_info(Pkey2),
                    reset_change_type(Pkey1),
                    reset_change_type(Pkey2),

                    %%检查是否完成目标
                    check_finish_target(Pkey),
                    ok
            end
    end,
    {noreply, State};

handle_cast({exit, Pkey}, State) ->
    case get_fruit_player(Pkey) of
        [] -> skip;
        FP ->
            case FP#cross_fruit_player.fkey > 0 of
                true ->
                    case get_fruit_fight(FP#cross_fruit_player.fkey) of
                        [] ->
                            skip;
                        CF ->
                            WinPlayer =
                                case CF#cross_fruit.pkey1 == Pkey of
                                    true -> 2;
                                    false -> 1
                                end,
                            fight_win(WinPlayer, CF#cross_fruit.fkey),
                            ok
                    end;
                false ->
                    skip
            end
    end,
    {noreply, State};

handle_cast({get_week_gift_res, Pkey}, State) ->
    case lists:keyfind(Pkey, 2, State#cf_state.rank_list) of
        false ->
            ?DEBUG("can not find rank_player when after player get week rank gift ~p", [Pkey]),
            {noreply, State};
        {Rank, Pkey, _OldState} ->
            NewList = lists:keyreplace(Pkey, 2, State#cf_state.rank_list, {Rank, Pkey, 1}),
            NewState = State#cf_state{
                rank_list = NewList
            },
            {noreply, NewState}
    end;

handle_cast({get_week_rank_gift_info, Pkey, Node, Sid}, State) ->
    List = data_fruit_rank_reward:get_all(),
    F = fun(Rank) ->
        Base = data_fruit_rank_reward:get(Rank),
        #base_week_rank{
            min_rank = MinRank,
            max_rank = MaxRank,
            goods_list = GoodsList
        } = Base,
        GetS =
            case lists:keyfind(Pkey, 2, State#cf_state.rank_list) of
                false -> 0;
                {_Order, _Pkey, GetState} ->
                    case GetState of
                        0 -> 1;
                        _ -> 2
                    end
            end,
        [MinRank, MaxRank, GetS, util:list_tuple_to_list(GoodsList)]
        end,
    RankList = lists:map(F, List),
    {ok, Bin} = pt_582:write(58210, {RankList}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({get_week_rank, Pkey, Node, Sid}, State) ->
    List = get_week_rank(),
    {MyWinTimes, MyRank} =
        case lists:keyfind(Pkey, #cross_fruit_player.pkey, List) of
            false -> {0, 0};
            FP ->
                Index = util:get_list_elem_index(FP, List),
                {FP#cross_fruit_player.win_times, Index}

        end,
    F = fun(P, Order) ->
        #cross_fruit_player{
            pkey = Playerkey,
            name = Name,
            sn = Sn,
            win_times = PlayerWinTimes
        } = P,
        {[Order, Playerkey, Name, Sn, PlayerWinTimes], Order + 1}
        end,
    {L, _Order} = lists:mapfoldl(F, 1, List),
    {ok, Bin} = pt_582:write(58211, {MyWinTimes, MyRank, L}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({get_week_rank_gift, Pkey, Node, Sid}, State) ->
    {Res, State1} =
        case lists:keyfind(Pkey, 2, State#cf_state.rank_list) of
            false -> {3, State};
            {Order, Pkey, GetState} ->
                case GetState == 0 of
                    false -> {4, State};
                    true ->
                        %%通知单服发奖励
                        center:apply(Node, cross_fruit, week_rank_reward, [Pkey, "", Order]),
                        NewList = lists:keyreplace(Pkey, 2, State#cf_state.rank_list, {Order, Pkey, 1}),
                        NewState = State#cf_state{rank_list = NewList},
                        {1, NewState}
                end
        end,
    {ok, Bin} = pt_582:write(58212, {Res}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State1};

handle_cast(_Info, State) ->
    ?DEBUG("cross_fruit_handle cast info ~p~n", [_Info]),
    {noreply, State}.

handle_info(init, State) ->
    refresh_week_rank(),
    {noreply, State};

handle_info(time_to_match, State) ->
    util:cancel_ref([State#cf_state.match_ref]),
    Ref = erlang:send_after(?MATCH_TIME * 1000, self(), time_to_match),
    spawn(fun() -> do_match() end),
    {noreply, State#cf_state{match_ref = Ref}};

handle_info({robot_next_step, Pkey}, State) ->
    case get_fruit_player(Pkey) of
        [] -> skip;
        FP ->
            #cross_fruit_player{
                fkey = FKey,
                target = Target
            } = FP,
            case get_fruit_fight(FKey) of
                [] -> skip;
                CF ->
                    #cross_fruit{
                        cur_target = CurTarget,
                        start_time = StartTime
                    } = CF,
                    L = length([T || T <- Target, T#tg.type == 0]),
                    Self = self(),
                    Now = util:unixtime(),
                    case Now - StartTime > 300 of
                        true -> skip;
                        false ->
                            case L > 0 of %%浇水
                                true ->
                                    ?CAST(Self, {operate, Pkey, 0, 0}),
                                    erlang:send_after(?ROBOT_SHOT_TIME, Self, {robot_next_step, Pkey}),
                                    ok;
                                false -> %%消除
                                    F = fun(N, DoTimes) ->
                                        MyTg = lists:nth(N, Target),
                                        TarType = lists:nth(N, CurTarget),
                                        case MyTg#tg.type == TarType of
                                            true ->
                                                DoTimes;
                                            false ->
                                                case DoTimes > 0 of
                                                    true ->
                                                        skip;
                                                    false ->
                                                        ?CAST(Self, {operate, Pkey, 1, N}),
                                                        DoTimes + 1
                                                end
                                        end
                                        end,
                                    lists:foldl(F, 0, lists:seq(1, 3)),
                                    erlang:send_after(?ROBOT_SHOT_TIME_1, Self, {robot_next_step, Pkey}),
                                    ok
                            end
                    end
            end
    end,
    {noreply, State};

handle_info({operate, Pkey, Type, Pos}, State) ->
    handle_cast({operate, Pkey, Type, Pos}, State);

handle_info(week_reward, State) ->
    Now = util:unixtime(),
    {_, {H, _, _}} = util:seconds_to_localtime(Now),
    Week = util:get_day_of_week(),
    if
        Week == 7 andalso H == 23 -> %%发排行奖励
            refresh_week_rank(),
            FPList = get_week_rank(),
            F = fun(Fp, Order) ->
                %%通知单服发奖励
                FPNode = center:get_node_by_sn(Fp#cross_fruit_player.sn),
                case FPNode of
                    false -> ?DEBUG("can not find cross_fruit_player node ~p~n", [FPNode]), skip;
                    _ ->
                        center:apply(FPNode, cross_fruit, week_rank_reward, [Fp#cross_fruit_player.pkey, Fp#cross_fruit_player.name, Order])
                end,
                log_week_rank(Fp, Order),
                {{Order, Fp#cross_fruit_player.pkey, 0}, Order + 1}
                end,
            {List, _Order} = lists:mapfoldl(F, 1, FPList),
            spawn(fun() -> week_rank_handle() end),
            {noreply, State#cf_state{rank_list = List}};
        true ->
            %%刷新排行
            refresh_week_rank(),
            {noreply, State}
    end;

handle_info(week_reward_test, State) ->
    refresh_week_rank(),
    FPList = get_week_rank(),
    F = fun(Fp, Order) ->
        %%通知单服发奖励
        FPNode = center:get_node_by_sn(Fp#cross_fruit_player.sn),
        case FPNode of
            false -> ?DEBUG("can not find cross_fruit_player node ~p~n", [FPNode]), skip;
            _ ->
                center:apply(FPNode, cross_fruit, week_rank_reward, [Fp#cross_fruit_player.pkey, Fp#cross_fruit_player.name, Order])
        end,
        log_week_rank(Fp, Order),
        {{Order, Fp#cross_fruit_player.pkey, 0}, Order + 1}
        end,
    {List, _Order} = lists:mapfoldl(F, 1, FPList),
    {noreply, State#cf_state{rank_list = List}};

%%继续到时处理
handle_info({continue_check, MyPkey, Pkey}, State) ->
    case get_fruit_player(MyPkey) of
        [] -> skip;
        FP ->
            case get_fruit_player(Pkey) of
                [] -> skip;
                FP2 ->
                    if
                        FP#cross_fruit_player.state == 1 ->
                            skip;
                        FP2#cross_fruit_player.apply_time == 0 ->
                            NewFP = FP#cross_fruit_player{
                                invite_time = 0
                            },
                            update_fruit_player(NewFP);
                        FP2#cross_fruit_player.state == 1 ->
                            NewFP = FP#cross_fruit_player{
                                invite_time = 0
                            },
                            update_fruit_player(NewFP);
                        skip;
                        true ->
                            Now = util:unixtime(),
                            do_match_1([FP, FP2], Now),
                            ok
                    end
            end
    end,
    {noreply, State};

handle_info({boom, Pkey, Fkey, Pos}, State) ->
    case get_fruit_player(Pkey) of
        [] -> skip;
        FP ->
            case get_fruit_fight(Fkey) of
                [] -> skip;
                CF ->
                    case lists:keyfind(Pos, #tg.pos, FP#cross_fruit_player.target) of
                        false -> skip;
                        Tg ->
                            case Tg#tg.type == ?FRUIT_TYPE_BOOM of
                                true ->
                                    F = fun(Tg0) ->
                                        case Tg0#tg.type == ?FRUIT_TYPE_BOOM of
                                            true ->
                                                util:cancel_ref([Tg0#tg.boom_ref]);
                                            false ->
                                                skip
                                        end
                                        end,
                                    lists:foreach(F, FP#cross_fruit_player.target),
                                    InitTg = init_target(),
                                    InitTg1 = [Tg0#tg{change_type = 1} || Tg0 <- InitTg],
                                    NewFP = FP#cross_fruit_player{
                                        target = InitTg1
                                    },
                                    update_fruit_player(NewFP),
                                    %%通知客户端
                                    get_fight_info(CF#cross_fruit.pkey1),
                                    get_fight_info(CF#cross_fruit.pkey2),
                                    reset_change_type(Pkey),
                                    ok;
                                false ->
                                    skip
                            end
                    end
            end
    end,
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("cross_fruit_handle info ~p~n", [_Info]),
    {noreply, State}.

get_fruit_player(Pkey) ->
    case ets:lookup(?ETS_CROSS_FRUIT_PLAYER, Pkey) of
        [] -> [];
        [Hd | _] -> Hd
    end.

update_fruit_player(P) ->
    ets:insert(?ETS_CROSS_FRUIT_PLAYER, P).

get_fruit_fight(Key) ->
    case ets:lookup(?ETS_CROSS_FRUIT, Key) of
        [] -> [];
        [Hd | _] -> Hd
    end.

update_fruit_fight(P) ->
    ets:insert(?ETS_CROSS_FRUIT, P).

%%匹配
do_match() ->
    Now = util:unixtime(),
    MS = ets:fun2ms(fun(FP) when FP#cross_fruit_player.apply_time > 0 andalso
        Now - FP#cross_fruit_player.invite_time >= ?INVITE_ITME -> FP end),
    All = ets:select(?ETS_CROSS_FRUIT_PLAYER, MS),
    SortList = lists:keysort(#cross_fruit_player.apply_time, All),
    do_match_1(SortList, Now),
    ok.
do_match_1([], _Now) -> ok;
do_match_1([FP], Now) ->
    case Now - FP#cross_fruit_player.apply_time >= ?MATCH_TIMEOUT of
        true -> %%匹配超时  机器人
            Nodes = center:get_nodes(),
            Node = util:list_rand(Nodes),
            case center:apply_call(Node, cross_fruit, get_robot, [FP#cross_fruit_player.pkey]) of
                [] -> ok;
                RobotFP0 ->
                    RobotFP = RobotFP0#cross_fruit_player{
                        pkey = misc:unique_key(),
                        sid = none,
                        is_robot = 1,
                        node = node()
                    },
                    do_match_1([FP, RobotFP], Now)
            end;
        false ->
            ok
    end;
do_match_1([FP1, FP2 | Tail], Now) ->
    Key = misc:unique_key(),
    CF = #cross_fruit{
        fkey = Key,
        pkey1 = FP1#cross_fruit_player.pkey,
        pkey2 = FP2#cross_fruit_player.pkey,
        start_time = Now,
        win = [],
        cur_round = 0,
        cur_target = []
    },
    update_fruit_fight(CF),
    InitTg = init_target(),
    NewFP1 = FP1#cross_fruit_player{
        fkey = Key,
        target = InitTg,
        apply_time = 0,
        invite_time = 0,
        state = 1
    },
    NewFP2 = FP2#cross_fruit_player{
        fkey = Key,
        target = InitTg,
        apply_time = 0,
        invite_time = 0,
        state = 1
    },
    update_fruit_player(NewFP1),
    update_fruit_player(NewFP2),
    spawn(fun() -> start_one(Key) end), %%开始一场比赛
    do_match_1(Tail, Now).

%%开始比赛
start_one(Key) ->
    CF = get_fruit_fight(Key),
    #cross_fruit{
        pkey1 = Pkey1,
        pkey2 = Pkey2
    } = CF,
    FP1 = get_fruit_player(Pkey1),
    FP2 = get_fruit_player(Pkey2),
    Data1 = pack_player(FP1),
    Data2 = pack_player(FP2),
    {ok, Bin1} = pt_582:write(58203, {Data1}),
    {ok, Bin2} = pt_582:write(58203, {Data2}),
    server_send:send_to_sid(FP1#cross_fruit_player.node, FP1#cross_fruit_player.sid, Bin2),
%%    center:apply(FP1#cross_fruit_player.node, server_send, send_to_sid, [FP1#cross_fruit_player.sid, Bin2]),
    server_send:send_to_sid(FP2#cross_fruit_player.node, FP2#cross_fruit_player.sid, Bin1),
%%    center:apply(FP2#cross_fruit_player.node, server_send, send_to_sid, [FP2#cross_fruit_player.sid, Bin1]),

    Target = create_target(),
    NewCF = CF#cross_fruit{
        cur_round = CF#cross_fruit.cur_round + 1,
        cur_target = Target
    },
    update_fruit_fight(NewCF),

    %%通知客户端
    get_fight_info(Pkey1),
    get_fight_info(Pkey2),

    Pid = cross_fruit_proc:get_server_pid(),
    ?DO_IF(FP2#cross_fruit_player.is_robot == 1, erlang:send_after(3000, Pid, {robot_next_step, FP2#cross_fruit_player.pkey})),

    ok.

pack_player(FP1) ->
    #cross_fruit_player{
        pkey = Pkey,
        name = Name,
        sn = Sn,
        career = Career,
        sex = Sex,
        vatar = Avatar
    } = FP1,
    [Pkey, Name, Sn, Career, Sex, Avatar].

%%检查是否完成目标
check_finish_target(Pkey) ->
    FP = get_fruit_player(Pkey),
    CF = get_fruit_fight(FP#cross_fruit_player.fkey),
    TargetLits = [Tg#tg.type || Tg <- lists:keysort(#tg.pos, FP#cross_fruit_player.target)],
    case TargetLits == CF#cross_fruit.cur_target of
        true -> %%完成当前目标
            Target = create_target(),
            Win = ?IF_ELSE(CF#cross_fruit.pkey1 == Pkey, 1, 2),
            NewCF = CF#cross_fruit{
                cur_target = Target,
                cur_round = CF#cross_fruit.cur_round + 1,
                win = CF#cross_fruit.win ++ [Win]
            },
            update_fruit_fight(NewCF),

            Win1 = length([W || W <- NewCF#cross_fruit.win, W == 1]),
            Win2 = length(NewCF#cross_fruit.win) - Win1,
            WinPlayer =
                case Win1 >= ?MAX_WIN_ROUND of
                    true -> %%玩家1赢
                        1;
                    false ->
                        case Win2 >= ?MAX_WIN_ROUND of
                            true -> %%玩家2赢
                                2;
                            false ->
                                0
                        end
                end,
            FP1 = get_fruit_player(CF#cross_fruit.pkey1),
            FP2 = get_fruit_player(CF#cross_fruit.pkey2),
            Now = util:unixtime(),
            update_fruit_player(FP1#cross_fruit_player{next_round_time = Now + ?NEXT_ROUND_WAIT_TIME}),
            update_fruit_player(FP2#cross_fruit_player{next_round_time = Now + ?NEXT_ROUND_WAIT_TIME}),

            spawn(fun() -> timer:sleep(?NEXT_ROUND_WAIT_TIME * 1000), fight_win(WinPlayer, CF#cross_fruit.fkey) end),
            ok;
        false ->
            skip
    end.

fight_win(WinPlayer, Fkey) ->
    case get_fruit_fight(Fkey) of
        [] -> skip;
        CF ->
            FP = get_fruit_player(CF#cross_fruit.pkey1),
            FP2 = get_fruit_player(CF#cross_fruit.pkey2),
            case FP == [] orelse FP2 == [] of
                true ->
                    skip;
                false ->
                    fight_win_1(WinPlayer, CF, FP, FP2)
            end
    end.
fight_win_1(WinPlayer, CF, FP, FP2) ->
    InitTg = init_target(),
    case WinPlayer == 0 of
        true -> %%单回合结束，还没分胜负
            NewFP1 = FP#cross_fruit_player{
                target = InitTg,
                click_times = 0
            },
            update_fruit_player(NewFP1),
            NewFP2 = FP2#cross_fruit_player{
                target = InitTg,
                click_times = 0
            },
            update_fruit_player(NewFP2),

            %%通知客户端
            get_fight_info(CF#cross_fruit.pkey1),
            get_fight_info(CF#cross_fruit.pkey2),

            ok;
        false -> %%当前局已结束 进行结算

            %%先通知客户端
            get_fight_info(CF#cross_fruit.pkey1),
            get_fight_info(CF#cross_fruit.pkey2),

            ets:delete(?ETS_CROSS_FRUIT, CF#cross_fruit.fkey),
            NewFP1 = FP#cross_fruit_player{
                fkey = 0,
                target = InitTg,
                state = 0,
                win_times = ?IF_ELSE(WinPlayer == 1, FP#cross_fruit_player.win_times + 1, FP#cross_fruit_player.win_times),
                click_times = 0
            },
            update_fruit_player(NewFP1),

            NewFP2 = FP2#cross_fruit_player{
                fkey = 0,
                target = InitTg,
                state = 0,
                win_times = ?IF_ELSE(WinPlayer == 2, FP2#cross_fruit_player.win_times + 1, FP2#cross_fruit_player.win_times),
                click_times = 0
            },
            update_fruit_player(NewFP2),

            center:apply(FP#cross_fruit_player.node, cross_fruit, reward, [FP#cross_fruit_player.pkey, ?IF_ELSE(WinPlayer == 1, 1, 0), NewFP1#cross_fruit_player.win_times]),
            center:apply(FP2#cross_fruit_player.node, cross_fruit, reward, [FP2#cross_fruit_player.pkey, ?IF_ELSE(WinPlayer == 2, 1, 0), NewFP2#cross_fruit_player.win_times]),

            %%进入前50的进行中心服写库处理
            LastRankWinTimes = get_last_rank_win_times(),
            case NewFP1#cross_fruit_player.win_times >= LastRankWinTimes of
                true ->
                    cross_fruit_load:dbup_cross_fruit_player(NewFP1);
                false ->
                    skip
            end,
            case NewFP2#cross_fruit_player.win_times >= LastRankWinTimes andalso FP2#cross_fruit_player.is_robot =/= 1 of
                true ->
                    cross_fruit_load:dbup_cross_fruit_player(NewFP2);
                false ->
                    skip
            end,
            case FP2#cross_fruit_player.is_robot == 1 of
                true -> ets:delete(?ETS_CROSS_FRUIT_PLAYER, FP2#cross_fruit_player.pkey);
                false -> skip
            end,

            %%避免ets过大，清除不必要数据
            case NewFP1#cross_fruit_player.win_times == 0 of
                true ->
                    ets:delete(?ETS_CROSS_FRUIT_PLAYER, NewFP1#cross_fruit_player.pkey);
                false ->
                    skip
            end,
            case FP2#cross_fruit_player.win_times == 0 andalso WinPlayer =/= 2 of
                true ->
                    ets:delete(?ETS_CROSS_FRUIT_PLAYER, FP2#cross_fruit_player.pkey);
                false ->
                    skip
            end
    end.

%%创建目标
create_target() ->
    %%目标
    Type1 = util:rand(1, 3),
    Type2 = util:rand(1, 3),
    Type3 = util:rand(1, 3),
    [Type1, Type2, Type3].

%%获取当场比赛信息
get_fight_info(Pkey) ->
    case get_fruit_player(Pkey) of
        [] -> ?DEBUG("can not find fruit_player ~p~n", [Pkey]), skip;
        FP ->
            Now = util:unixtime(),
            F = fun(Tg) ->
                LeaveTime =
                    case Tg#tg.type of
                        ?FRUIT_TYPE_BOOM -> max(0, Tg#tg.boom_time + 3 - Now);
                        _ -> 0
                    end,
                [Tg#tg.type, Tg#tg.click_times, LeaveTime, Tg#tg.change_type]
                end,
            #cross_fruit_player{
                fkey = FKey,
                target = MyTarget
            } = FP,
            MyTarget1 = lists:map(F, lists:keysort(#tg.pos, MyTarget)),
            case get_fruit_fight(FKey) of
                [] -> ?DEBUG("can not find fruit fight info ~p~n", [FKey]), skip;
                CF ->
                    #cross_fruit{
                        pkey1 = Pkey1,
                        pkey2 = Pkey2,
                        cur_round = CurRound,
                        cur_target = CurTarget,
                        win = WinList
                    } = CF,
                    ElsePkey = ?IF_ELSE(Pkey1 == Pkey, Pkey2, Pkey1),
                    case get_fruit_player(ElsePkey) of
                        [] -> ?DEBUG("can not find else_fruit_player ~p~n", [Pkey2]), skip;
                        FP2 ->
                            #cross_fruit_player{
                                target = ElseTarget
                            } = FP2,
                            PlayerData2 = pack_player(FP2),
                            Win1 = length([W || W <- WinList, W == 1]),
                            Win2 = length([W || W <- WinList, W == 2]),
                            {MyWin, ElseWin} =
                                case Pkey1 == Pkey of
                                    true -> {Win1, Win2};
                                    false -> {Win2, Win1}
                                end,
                            ElseTarget1 = lists:map(F, lists:keysort(#tg.pos, ElseTarget)),
                            Data = {CurRound, CurTarget, MyWin, MyTarget1, ElseWin, ElseTarget1, PlayerData2},
                            {ok, Bin} = pt_582:write(58204, Data),
                            server_send:send_to_sid(FP#cross_fruit_player.node, FP#cross_fruit_player.sid, Bin)
%%                            center:apply(FP#cross_fruit_player.node, server_send, send_to_sid, [FP#cross_fruit_player.sid, Bin])
                    end
            end
    end.

%%周日23点周排名奖励处理
week_rank_handle() ->
    Now = util:unixtime(),
    %%更新胜利信息
    FirstG = ets:first(?ETS_CROSS_FRUIT_PLAYER),
    do_one(FirstG, Now),
    Sql = io_lib:format("TRUNCATE TABLE cross_fruit_player", []),
    db:execute(Sql),
    ok.

%%帮派更新
do_one('$end_of_table', _Now) -> ok;
do_one(Key, Now) ->
    FP = get_fruit_player(Key),
    NewFP = FP#cross_fruit_player{
        win_times = 0
    },
    update_fruit_player(NewFP),
    NextKey = ets:next(?ETS_CROSS_FRUIT_PLAYER, Key),
    do_one(NextKey, Now).

%%获取周排行
get_week_rank() ->
    case get(cross_fruit_week_rank) of
        undefined ->
            L = refresh_week_rank(),
            L;
        L ->
            L
    end.

%%刷新周排行
refresh_week_rank() ->
    MS = ets:fun2ms(fun(FP) when FP#cross_fruit_player.win_times > 0 ->
        {FP#cross_fruit_player.node, FP#cross_fruit_player.pkey, FP#cross_fruit_player.name, FP#cross_fruit_player.win_times} end),
    All = ets:select(?ETS_CROSS_FRUIT_PLAYER, MS),
    SortList = lists:sublist(lists:reverse(lists:keysort(4, All)), 50),
    F = fun({_Node, Pkey, _Name, WinTimes}) ->
        case get_fruit_player(Pkey) of
            [] -> [];
            FP ->
                put(last_rank_win_times, WinTimes),
                [FP]
        end
        end,
    List = lists:flatmap(F, SortList),
    put(cross_fruit_week_rank, List),
    List.

%%获取第50名的胜利次数
get_last_rank_win_times() ->
    case get(last_rank_win_times) of
        undefined -> 0;
        Times -> Times
    end.

%%初始化玩家目标
init_target() ->
    [
        #tg{pos = 1, type = 0, click_times = 0},
        #tg{pos = 2, type = 0, click_times = 0},
        #tg{pos = 3, type = 0, click_times = 0}
    ].

%%创建一个水果类型
create_new_fruit_type(FinalTarget, MyTgList, ClickTimes, Pos) ->
    create_new_fruit_type_1(FinalTarget, MyTgList, ClickTimes, Pos, 0).
create_new_fruit_type_1(_FinalTarget, _MyTgList, _ClickTimes, _Pos, 200) -> 0;
create_new_fruit_type_1(FinalTarget, MyTgList, ClickTimes, Pos, Times) ->
    FruitRatioList = data_fruit_ratio:get(),
    FruitRatioList1 = lists:keydelete(5, 1, FruitRatioList),
    Type = util:list_rand_ratio(FruitRatioList1),
    MyTgList1 = lists:keyreplace(Pos, #tg.pos, MyTgList, #tg{pos = Pos, type = Type}),
    TypeList = [Tg#tg.type || Tg <- lists:keysort(#tg.pos, MyTgList1)],
    if
        ClickTimes == 0 andalso Type >= 4 -> %%首次不需要出现特殊道具
            create_new_fruit_type_1(FinalTarget, MyTgList, ClickTimes, Pos, Times + 1);
        ClickTimes == 0 andalso TypeList == FinalTarget -> %%首次 不可以和目标相同
            create_new_fruit_type_1(FinalTarget, MyTgList, ClickTimes, Pos, Times + 1);
        Type >= 4 -> %%特殊水果类型不能重复出现
            case lists:keyfind(Type, #tg.type, MyTgList) of
                false -> Type;
                _ -> create_new_fruit_type_1(FinalTarget, MyTgList, ClickTimes, Pos, Times + 1)
            end;
        true ->
            Type
    end.

%%周排名日志
log_week_rank(Fp, Order) ->
    #cross_fruit_player{
        pkey = Pkey,
        sn = Sn,
        name = Name,
        win_times = WinTimes
    } = Fp,
    Sql = io_lib:format("insert into log_cross_fruit set pkey=~p,nickname='~s',sn=~p,rank=~p,win_times=~p,time=~p",
        [Pkey, Name, Sn, Order, WinTimes, util:unixtime()]),
    log_proc:log(Sql),
    ok.

%%重置修改类型
reset_change_type(Pkey) ->
    case get_fruit_player(Pkey) of
        [] -> skip;
        FP ->
            F = fun(Tg) ->
                Tg#tg{change_type = 0}
                end,
            NewTarget = lists:map(F, FP#cross_fruit_player.target),
            NewFP = FP#cross_fruit_player{
                target = NewTarget
            },
            update_fruit_player(NewFP),
            ok
    end.