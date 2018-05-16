%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 上午10:16
%%%-------------------------------------------------------------------
-module(cross_six_dragon_handle).
-author("fengzhenlin").
-include("common.hrl").
-include("cross_six_dragon.hrl").
-include("dungeon.hrl").

-include_lib("stdlib/include/ms_transform.hrl").

%% API
-export([
    handle_call/3, handle_cast/2, handle_info/2
]).


handle_call(_Info, _From, State) ->
    ?ERR("cross_six_dragon_handle call info ~p~n", [_Info]),
    {reply, ok, State}.

handle_cast({get_state, Node, Sid}, State) ->
    #six_dargon_st{
        state = OpenSt,
        start_time = StartTime,
        ent_time = EndTime
    } = State,
    Now = util:unixtime(),
    Data =
        if
            OpenSt == 1 ->
                %%开启中
                {2, max(0, EndTime - Now)};
            OpenSt == 2 ->
                %%准备中
                {1, max(0, StartTime - Now)};
            true ->
                {0, 0}
        end,
    {ok, Bin} = pt_581:write(58101, Data),
    case Node of
        0 ->
            AllNode = center:get_nodes(),
            [center:apply(N, server_send, send_to_all, [Bin]) || N <- AllNode];
        _ ->
            server_send:send_to_sid(Node, Sid, Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%申请匹配
handle_cast({apply_match, SdPlayer}, State) ->
    Res =
        case State#six_dargon_st.state == 1 of
            true ->
                Now = util:unixtime(),
                NewSdPlayer =
                    case cross_six_dragon:get_ets_kf_player(SdPlayer#sd_player.pkey) of
                        [] -> SdPlayer#sd_player{
                            apply_state = 1,
                            apply_time = Now
                        };
                        KfPlayer ->
                            case KfPlayer#sd_player.copy > 0 of
                                true -> %%已在房间
                                    KfPlayer;
                                false ->
                                    KfPlayer#sd_player{
                                        sid = SdPlayer#sd_player.sid
                                        , node = SdPlayer#sd_player.node
                                        , cbp = SdPlayer#sd_player.cbp
                                        , apply_state = 1
                                        , apply_time = Now
                                    }
                            end
                    end,
                cross_six_dragon:update_ets_kf_player(NewSdPlayer),
                1;
            false ->
                2
        end,
    {ok, Bin} = pt_581:write(58103, {Res}),
    server_send:send_to_sid(SdPlayer#sd_player.node, SdPlayer#sd_player.sid, Bin),
%%    center:apply(SdPlayer#sd_player.node, server_send, send_to_sid, [SdPlayer#sd_player.sid, Bin]),
    {noreply, State};

%%取消匹配
handle_cast({cancel_match, Pkey, Sid, Node}, State) ->
    case cross_six_dragon:get_ets_kf_player(Pkey) of
        [] -> skip;
        SdPlayer ->
            NewSdPlayer = SdPlayer#sd_player{
                apply_time = 0,
                apply_state = 0
            },
            cross_six_dragon:update_ets_kf_player(NewSdPlayer)
    end,
    {ok, Bin} = pt_581:write(58104, {1}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%获取个人比赛信息
handle_cast({get_fight_info, Pkey, Sid, Node}, State) ->
    {MyPoint, FTimes, PkState} =
        case cross_six_dragon:get_ets_kf_player(Pkey) of
            [] -> {0, 0, 0};
            SdPlayer ->
                #sd_player{
                    point = Point,
                    fight_times = FightTimes,
                    apply_state = ApplyState
                } = SdPlayer,
                {Point, FightTimes, ApplyState}
        end,
    SucceedGoods = util:list_tuple_to_list(data_six_dragon_reward:get_succeed_reward()),
    FailGoods = util:list_tuple_to_list(data_six_dragon_reward:get_fail_reward()),

    NextFTimes = FTimes + 1,
    Top10Goods =
        case NextFTimes > 10 of
            true -> [];
            false -> util:list_tuple_to_list(data_top10fight_gift:get(NextFTimes))
        end,

    Data = {MyPoint, FTimes, PkState, SucceedGoods, FailGoods, Top10Goods},
    {ok, Bin} = pt_581:write(58102, Data),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),

    {noreply, State};

%%获取当前比赛信息
handle_cast({get_fight_target, Pkey, Sid, Node}, State) ->
    case cross_six_dragon:get_ets_kf_player(Pkey) of
        [] -> skip;
        SdPlayer ->
            #sd_player{
                copy = Copy
            } = SdPlayer,
            case cross_six_dragon:get_ets_team(Copy) of
                [] -> skip;
                Team ->
                    Now = util:unixtime(),
                    #sd_team{
                        player_list = PlayerList,
                        life1 = Life1,
                        life2 = Life2,
                        end_time = EndTime
                    } = Team,
                    LeaveTime = max(0, EndTime - Now),
                    F = fun(SdTeamMd) ->
                        #sd_team_md{
                            pkey = SdPkey,
                            kill = Kill,
                            die = Die,
                            team = STeam
                        } = SdTeamMd,
                        case cross_six_dragon:get_ets_kf_player(SdPkey) of
                            [] -> [];
                            SdP ->
                                #sd_player{
                                    pkey = Pk
                                    , sn = Sn
                                    , pf = Pf
                                    , name = Name
                                    , lv = Lv
                                    , cbp = Cbp
                                    , sex = Sex
                                    , career = Career
                                    , avatar = Avatar
                                } = SdP,
                                [[Pk, Sn, Pf, Name, Lv, Sex, Career, Avatar, Cbp, Kill, Die, STeam]]
                        end
                        end,
                    PlayerInfoList = lists:flatmap(F, PlayerList),
                    Data = {Life1, Life2, LeaveTime, PlayerInfoList},
                    {ok, Bin} = pt_581:write(58105, Data),
                    server_send:send_to_sid(Node, Sid, Bin)
%%                    center:apply(Node, server_send, send_to_sid, [Sid, Bin])
            end
    end,
    {noreply, State};

%%玩家被杀
handle_cast({role_die, Copy, Pkey, KillerKey}, State) ->
    case cross_six_dragon:get_ets_team(Copy) of
        [] -> skip;
        Team when Team#sd_team.life1 =< 0 -> skip;
        Team when Team#sd_team.life2 =< 0 -> skip;
        Team ->
            SdTeamMb = lists:keyfind(Pkey, #sd_team_md.pkey, Team#sd_team.player_list),
            SdPlayer = cross_six_dragon:get_ets_kf_player(Pkey),
            %%被杀
            case SdTeamMb == false orelse SdPlayer == [] of
                true -> skip;
                false ->
                    %%扣除生命
                    #sd_team{
                        life1 = Life1,
                        life2 = Life2
                    } = Team,
                    {NewLife1, NewLife2} =
                        case SdTeamMb#sd_team_md.team == 1 of
                            true -> {max(0, Life1 - 1), Life2};
                            false -> {Life1, max(0, Life2 - 1)}
                        end,
                    case NewLife1 == 0 orelse NewLife2 == 0 of
                        true ->
                            %%共享生命为0，结束
                            erlang:send_after(300, self(), {copy_end, Copy});
                        false ->
                            skip
                    end,
                    NewSdTeamMb = SdTeamMb#sd_team_md{
                        die = SdTeamMb#sd_team_md.die + 1
                    },
                    NewTeam = Team#sd_team{
                        life1 = NewLife1,
                        life2 = NewLife2,
                        player_list = lists:keyreplace(Pkey, #sd_team_md.pkey, Team#sd_team.player_list, NewSdTeamMb)
                    },
                    cross_six_dragon:update_ets_team(NewTeam)
            end,
            %%击杀
            KillerSdTeamMb = lists:keyfind(KillerKey, #sd_team_md.pkey, Team#sd_team.player_list),
            KSdPlayer = cross_six_dragon:get_ets_kf_player(KillerKey),
            case KillerSdTeamMb == false orelse KSdPlayer == [] of
                true -> skip;
                false ->
                    NewKillerSdTeamMb = KillerSdTeamMb#sd_team_md{
                        kill = KillerSdTeamMb#sd_team_md.kill + 1,
                        last_kill_time = util:unixtime()
                    },
                    Team1 = cross_six_dragon:get_ets_team(Copy),
                    NewTeam1 = Team1#sd_team{
                        player_list = lists:keyreplace(KillerKey, #sd_team_md.pkey, Team1#sd_team.player_list, NewKillerSdTeamMb)
                    },
                    cross_six_dragon:update_ets_team(NewTeam1)
            end,
            Ft = fun(STMd) ->
                case cross_six_dragon:get_ets_kf_player(STMd#sd_team_md.pkey) of
                    [] -> ?ERR("can not find kf_player where role_die ~p ~n", [STMd#sd_team_md.pkey]), skip;
                    SdP ->
                        ?CAST(self(), {get_fight_target, Pkey, SdP#sd_player.sid, SdP#sd_player.node})
                end
                 end,
            lists:foreach(Ft, Team#sd_team.player_list)
    end,
    {noreply, State};

%%退出战斗
handle_cast({exit_six_dragon_battle, Pkey}, State) ->
    case cross_six_dragon:get_ets_kf_player(Pkey) of
        [] -> skip;
        SdPlayer ->
            case cross_six_dragon:get_ets_team(SdPlayer#sd_player.copy) of
                [] -> skip;
                Team ->
                    NewSdPlayer = SdPlayer#sd_player{
                        copy = 0
                    },
                    case lists:keytake(Pkey, #sd_team_md.pkey, Team#sd_team.player_list) of
                        false -> cross_six_dragon:update_ets_kf_player(NewSdPlayer);
                        {value, SdTeamMd, NewPlayerList} ->
                            cross_six_dragon:update_ets_kf_player(NewSdPlayer),
                            List = [X || X <- NewPlayerList, X#sd_team_md.team == SdTeamMd#sd_team_md.team], %% 判断是否还有同组成员
                            if
                                List == [] ->
                                    {Life1, Life2} =
                                        case SdTeamMd#sd_team_md.team == 1 of
                                            true -> {0, 1};
                                            false -> {1, 0}
                                        end,
                                    cross_six_dragon:update_ets_team(Team#sd_team{player_list = NewPlayerList, life1 = Life1, life2 = Life2}),
                                    self() ! {copy_end, Team#sd_team.copy};
                                true -> cross_six_dragon:update_ets_team(Team#sd_team{player_list = NewPlayerList})
                            end
                    end
            end
    end,
    {noreply, State};

%%获取积分排行
handle_cast({get_point_rank, Pkey, Sid, Sn, Node}, State) ->
    List = get_point_rank(Sn),
    {MyRank, MyFightTimes, MyPoint} =
        case cross_six_dragon:get_ets_kf_player(Pkey) of
            [] -> {0, 0, 0};
            SdPlayer ->
                R =
                    case lists:keyfind(Pkey, 2, List) of
                        false -> 0;
                        Item -> util:get_list_elem_index(Item, List)
                    end,
                {R, SdPlayer#sd_player.fight_times, SdPlayer#sd_player.point}
        end,
    RankList = util:list_tuple_to_list(List),
    Data = {MyRank, MyFightTimes, MyPoint, RankList},
    {ok, Bin} = pt_581:write(58108, Data),
    server_send:send_to_sid(Node, Sid, Bin),
    ?DO_IF(MyPoint > 0 andalso List == [], ?ERR("sn ~p get_point_rank list [] ~p~n", [Sn])),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast(_Info, State) ->
    ?ERR("cross_six_dragon_handle cast info ~p~n", [_Info]),
    {noreply, State}.

%%即将开启
handle_info({ready, StartTime}, State) ->
    NewSt = State#six_dargon_st{
        state = 2,
        start_time = StartTime
    },
    ?CAST(self(), {get_state, 0, 0}),
    AllNode = center:get_nodes(),
    [center:apply(N, notice_sys, add_notice, [six_dragon_ready, []]) || N <- AllNode],
    {noreply, NewSt};

%%开启
handle_info({start, Long}, State) ->
    scene_copy_proc:reset_scene_copy(?SCENE_ID_SIX_DRAGON),
    ets:delete_all_objects(?ETS_SIX_DRAGON_TEAM),
    ets:delete_all_objects(?ETS_SIX_DRAGON_PLAYER),
    MatchRef = erlang:send_after(?MATCH_TIMER * 1000, self(), time_to_match),
    Now = util:unixtime(),
    EndRef = erlang:send_after(Long * 1000, self(), time_to_end),
    EndNoticeRef = erlang:send_after(max(1, Long - 10) * 1000, self(), time_to_end_notice),
    NewSt = State#six_dargon_st{
        state = 1,
        start_time = Now,
        ent_time = Now + Long,
        end_ref = EndRef,
        end_notice_ref = EndNoticeRef,
        match_ref = MatchRef
    },
    ?CAST(self(), {get_state, 0, 0}),
    %%玩法找回
    findback_src:update_act_time(32, Now),
    AllNode = center:get_nodes(),
    [center:apply(N, notice_sys, add_notice, [six_dragon_open, []]) || N <- AllNode],
    {noreply, NewSt};

%%活动时间到
handle_info(time_to_end_notice, State) ->
    util:cancel_ref([State#six_dargon_st.end_notice_ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_581:write(58111, {max(1, State#six_dargon_st.ent_time - Now)}),
    server_send:send_to_scene(?SCENE_ID_SIX_DRAGON, Bin),
    server_send:send_to_scene(?SCENE_ID_SIX_DRAGON_FIGHT, Bin),
    scene_copy_proc:reset_scene_copy(?SCENE_ID_SIX_DRAGON),
    {noreply, State};

%%活动时间到
handle_info(time_to_end, State) ->
    util:cancel_ref([State#six_dargon_st.end_ref, State#six_dargon_st.match_ref, State#six_dargon_st.end_notice_ref]),
    Self = self(),
    spawn(fun() -> sendout_player(Self) end),
    %%排名奖励
    point_rank_reward(),
    NewSt = State#six_dargon_st{
        start_time = 0,
        ent_time = 0,
        state = 0
    },
    %%清掉计时器
    All = ets:tab2list(?ETS_SIX_DRAGON_TEAM),
    Ft = fun(Team) ->
        util:cancel_ref([Team#sd_team.end_ref])
         end,
    lists:foreach(Ft, All),
    ets:delete_all_objects(?ETS_SIX_DRAGON_TEAM),
    ?CAST(self(), {get_state, 0, 0}),
    {noreply, NewSt};

%%匹配
handle_info(time_to_match, State) ->
    util:cancel_ref([State#six_dargon_st.match_ref]),
    case State#six_dargon_st.state == 1 of
        true ->
            MatchRef = erlang:send_after(?MATCH_TIMER * 1000, self(), time_to_match),
            do_match(),
            {noreply, State#six_dargon_st{match_ref = MatchRef}};
        false ->
            {noreply, State}
    end;

%%战斗结束
handle_info({copy_end, Copy}, State) ->
    case State#six_dargon_st.state == 1 of
        true ->
            case cross_six_dragon:get_ets_team(Copy) of
                [] -> ?ERR("copy_end can not find team ~p~n", [Copy]), skip;
                Team ->
                    util:cancel_ref([Team#sd_team.end_ref]),
                    do_copy_end(Team)
            end;
        false ->
            cross_six_dragon:del_ets_team(Copy),
            skip
    end,
    {noreply, State};

%%请出玩家
handle_info({exit_copy, Pkey, _OldCopy}, State) ->
    case cross_six_dragon:get_ets_kf_player(Pkey) of
        [] -> skip;
        SdPlayer ->
            #sd_player{
                copy = Copy,
                node = Node
            } = SdPlayer,
            case Copy == 0 of
                true ->
                    center:apply(Node, cross_six_dragon, sendout_scene, [Pkey]);
                false ->
                    skip
            end
    end,
    {noreply, State};

handle_info(_Info, State) ->
    ?ERR("cross_six_dragon_handle info ~p~n", [_Info]),
    {noreply, State}.

%%系统匹配
do_match() ->
    MS = ets:fun2ms(fun(Sdp) when Sdp#sd_player.apply_state == 1 -> Sdp end),
    All = ets:select(?ETS_SIX_DRAGON_PLAYER, MS),
    L = lists:reverse(lists:keysort(#sd_player.point, All)),
    %%先进行积分匹配
    {L1, TeamList1} = do_same_point_match(L, 1, []),
    %%进行胜率、战力匹配
    {L2, TeamList2} = do_win_match(L1, 1, [], 0),
    %%进行第一层超时匹配
    Now = util:unixtime(),
    TimeoutList1 = [Sd || Sd <- L2, Now - Sd#sd_player.apply_time >= ?MATCH_TIME_OUT],
    {L3, TeamList3} = do_win_match(TimeoutList1, 1, [], 1),
    %%进行第二层超时匹配
    TimeoutList2 = [Sd || Sd <- L3, Now - Sd#sd_player.apply_time >= ?MATCH_TIME_OUT_2],
    {_L4, TeamList4} = do_win_match(TimeoutList2, 1, [], 2),
    AllTeamList = TeamList1 ++ TeamList2 ++ TeamList3 ++ TeamList4,
    AllTeamList.
do_same_point_match(L, St, AccMatch) ->
    SubL = lists:sublist(L, St, ?MATCH_NUM),
    case length(SubL) < ?MATCH_NUM of
        true -> {L, AccMatch};
        false ->
            Hd = hd(SubL),
            Len = length([H || H <- SubL, H#sd_player.point == Hd#sd_player.point]),
            case Len == ?MATCH_NUM of
                false -> do_same_point_match(L, St + 1, AccMatch);
                true ->
                    Team = rand_make_team(SubL),
                    F = fun(Apply, AccL) ->
                        lists:keydelete(Apply#sd_player.pkey, #sd_player.pkey, AccL)
                        end,
                    NewL = lists:foldl(F, L, SubL),
                    do_same_point_match(NewL, St, [Team | AccMatch])
            end
    end.

do_win_match(L, St, AccMatch, TimeoutType) ->
    SubL = lists:sublist(L, St, ?MATCH_NUM),
    case length(SubL) < ?MATCH_NUM of
        true -> {L, AccMatch};
        false ->
            MatchL = [
                {1, 6}, {1, 5}, {1, 4}, {1, 3}, {1, 2},
                {2, 6}, {2, 5}, {2, 4}, {2, 3},
                {3, 6}, {3, 5}, {3, 4},
                {4, 6}, {4, 5},
                {5, 6}
            ],
            case TimeoutType of
                2 -> %%已超时1分钟 随机匹配
                    Team = rand_make_team(SubL),
                    F = fun(Apply, AccL) ->
                        lists:keydelete(Apply#sd_player.pkey, #sd_player.pkey, AccL)
                        end,
                    NewL = lists:foldl(F, L, SubL),
                    do_win_match(NewL, St, [Team | AccMatch], TimeoutType);
                _ ->
                    AllSumWinRatio = lists:sum([A#sd_player.win_times / A#sd_player.fight_times || A <- SubL, A#sd_player.fight_times =/= 0]),
                    F = fun({N1, N2}) ->
                        A1 = lists:nth(N1, SubL),
                        A2 = lists:nth(N2, SubL),
                        %%先检查胜率
                        Ratio1 = ?IF_ELSE(A1#sd_player.fight_times == 0, 1, A1#sd_player.win_times / A1#sd_player.fight_times),
                        Ratio2 = ?IF_ELSE(A2#sd_player.fight_times == 0, 1, A2#sd_player.win_times / A2#sd_player.fight_times),
                        SumWinRatio = Ratio1 + Ratio2,
                        case SumWinRatio / 2 > 0.475 andalso SumWinRatio / 2 < 0.525 of
                            true ->
                                SumWinRatio2 = AllSumWinRatio - SumWinRatio,
                                case SumWinRatio2 / 4 > 0.475 andalso SumWinRatio2 / 4 < 0.525 of
                                    true ->
                                        case TimeoutType of
                                            1 ->  %%已超时30秒 可以不检查战力
                                                [{N1, N2}];
                                            _ ->
                                                %%检查战力
                                                AllSumCbp = lists:sum([A#sd_player.cbp || A <- SubL]),
                                                SumCbp = A1#sd_player.cbp + A2#sd_player.cbp,
                                                SumCbp2 = AllSumCbp - SumCbp,
                                                case SumCbp / SumCbp2 > 0.475 andalso SumCbp / SumCbp2 < 0.525 of
                                                    true ->
                                                        [{N1, N2}];
                                                    false ->
                                                        []
                                                end
                                        end;
                                    false ->
                                        []
                                end;
                            false ->
                                []
                        end
                        end,
                    case lists:flatmap(F, MatchL) of
                        [] ->
                            do_win_match(L, St + 1, AccMatch, TimeoutType);
                        MatchList ->
                            {Num1, Num2} = util:list_rand(MatchList),
                            Team = make_team(SubL, Num1, Num2),
                            F2 = fun(Apply, AccL) ->
                                lists:keydelete(Apply#sd_player.pkey, #sd_player.pkey, AccL)
                                 end,
                            NewL = lists:foldl(F2, L, SubL),
                            do_win_match(NewL, St, [Team | AccMatch], TimeoutType)
                    end
            end
    end.

rand_make_team(SubL) ->
    L = [1, 2, 3, 4, 5, 6],
    Nth1 = util:list_rand(L),
    Nth2 = util:list_rand(lists:delete(Nth1, L)),
    make_team(SubL, Nth1, Nth2).

make_team(ApplyList, Nth1, Nth2) ->
    Copy = misc:unique_key_auto(),
    F = fun(Nth) ->
        A = lists:nth(Nth, ApplyList),
        Team =
            case Nth == Nth1 orelse Nth == Nth2 of
                true -> 1;
                false -> 2
            end,
        NewA = A#sd_player{
            copy = Copy,
            apply_state = 0,
            apply_time = 0
        },
        cross_six_dragon:update_ets_kf_player(NewA),
        #sd_team_md{
            pkey = A#sd_player.pkey,
            team = Team
        }
        end,
    PlayerList = lists:map(F, lists:seq(1, ?MATCH_NUM)),

    Now = util:unixtime(),
    Ref = erlang:send_after(?DUNGEON_TIME * 1000, self(), {copy_end, Copy}),
    SdTeam = #sd_team{
        copy = Copy,
        player_list = PlayerList,
        start_time = Now,
        end_time = Now + ?DUNGEON_TIME,
        end_ref = Ref
    },
    cross_six_dragon:update_ets_team(SdTeam),
    %%创建场景
    scene_init:create_scene(?SCENE_ID_SIX_DRAGON_FIGHT, Copy),
    %%传送玩家进去
    F1 = fun(SdTeamMd) ->
        A = cross_six_dragon:get_ets_kf_player(SdTeamMd#sd_team_md.pkey),
        center:apply(A#sd_player.node, cross_six_dragon, send_player_to_scene,
            [A#sd_player.pkey, Copy, SdTeamMd#sd_team_md.team])
         end,
    spawn(fun() -> timer:sleep(500), lists:foreach(F1, PlayerList) end),
%%     {ok, Bin} = pt_581:write(58110, {ReadyTime}),
%%     F3 = fun(SdTeamMd) ->
%%         A = cross_six_dragon:get_ets_kf_player(SdTeamMd#sd_team_md.pkey),
%%         center:apply(A#sd_player.node, server_send, send_to_sid, [A#sd_player.sid, Bin])
%%          end,
%%     lists:foreach(F3, PlayerList),
    SdTeam.

%%战斗结束
do_copy_end(Team) ->
    %%判断胜负
    #sd_team{
        copy = Copy,
        life1 = Life1,
        life2 = Life2,
        player_list = PlayerList
    } = Team,
    Win =
        if
            Life1 == 0 -> 2;
            Life2 == 0 -> 1;
            true ->
                case Life1 > Life2 of
                    true -> 1;
                    false ->
                        case Life2 > Life1 of
                            true -> 2;
                            false -> 1
                        end
                end
        end,
    F = fun(SdTeamMd) ->
        case cross_six_dragon:get_ets_kf_player(SdTeamMd#sd_team_md.pkey) of
            [] -> [];
            SdPlayer when SdPlayer#sd_player.copy == Copy -> [SdPlayer];
            _ -> []
        end
        end,
    SdPlayerList = lists:flatmap(F, PlayerList),
    %%mvp
    M1 = [{SM#sd_team_md.kill, SM#sd_team_md.last_kill_time, SM#sd_team_md.pkey} || SM <- PlayerList, SM#sd_team_md.team == Win],
    MvpKey =
        case M1 =/= [] of
            true ->
                {K, _T, _P} = hd(lists:reverse(lists:sort(M1))),
                M2 = [{K1, T1, P1} || {K1, T1, P1} <- M1, K1 == K],
                {_MK, _MT, MP} = hd(lists:sort(M2)),
                MP;
            false ->
                []
        end,
    F1 = fun(SdTeamMd) ->
        SdPlayer =
            case cross_six_dragon:get_ets_kf_player(SdTeamMd#sd_team_md.pkey) of
                [] -> #sd_player{};
                SdPlayer0 -> SdPlayer0
            end,
        #sd_team_md{
            team = MyTeam,
            pkey = Pkey,
            kill = Kill
        } = SdTeamMd,
        #sd_player{
            sn = Sn,
            pf = Pf,
            name = Name
        } = SdPlayer,
        IsWin =
            case MyTeam == Win of
                true -> 1;
                false -> 0
            end,
        IsMvp = ?IF_ELSE(MvpKey == Pkey, 1, 0),
        AddPoint =
            case IsWin == 1 andalso IsMvp == 1 of
                true -> ?WIN_POINT + ?MVP_POINT;
                false -> ?IF_ELSE(IsWin == 1, ?WIN_POINT, ?FAIL_POINT)
            end,
        [IsWin, IsMvp, Pkey, Sn, Pf, Name, Kill, AddPoint]
         end,
    PlayerInfoList = lists:map(F1, PlayerList),
    F2 = fun(SdPlayer) ->
        MB = lists:keyfind(SdPlayer#sd_player.pkey, #sd_team_md.pkey, PlayerList),
        #sd_team_md{
            team = MyTeam
        } = MB,
        #sd_player{
            fight_times = FightTimes,
            node = Node,
            pkey = SPkey,
            sid = Sid
        } = SdPlayer,
        Top10GoodsList =
            case data_top10fight_gift:get(FightTimes + 1) of
                [] -> [];
                G1 -> G1
            end,
        IsMyWin = MyTeam == Win,
        WinGoodsList =
            case IsMyWin of
                true -> data_six_dragon_reward:get_succeed_reward();
                false -> data_six_dragon_reward:get_fail_reward()
            end,
        GetGoodsList = Top10GoodsList ++ WinGoodsList,
        GetGoodsList1 = util:list_tuple_to_list(GetGoodsList),
        center:apply(Node, cross_six_dragon, copy_reward, [SPkey, IsMyWin, GetGoodsList]),
        {ok, Bin} = pt_581:write(58106, {PlayerInfoList, GetGoodsList1}),
        server_send:send_to_sid(Node, Sid, Bin),
%%        center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
        AddPoint =
            case IsMyWin andalso SPkey == MvpKey of
                true -> ?WIN_POINT + ?MVP_POINT;
                false -> ?IF_ELSE(IsMyWin, ?WIN_POINT, ?FAIL_POINT)
            end,
        NewSdPlayer = SdPlayer#sd_player{
            point = SdPlayer#sd_player.point + AddPoint,
            fight_times = FightTimes + 1,
            win_times = ?IF_ELSE(IsMyWin, SdPlayer#sd_player.win_times + 1, SdPlayer#sd_player.win_times),
            copy = 0
        },
        erlang:send_after(15000, self(), {exit_copy, SdPlayer#sd_player.pkey, SdPlayer#sd_player.copy}),
        cross_six_dragon:update_ets_kf_player(NewSdPlayer),
        log_proc:log(io_lib:format("insert into log_cross_six_dragon_one_fight set pkey=~p,sn=~p,goods='~s',fight_times=~p,point=~p,time=~p",
            [SPkey, NewSdPlayer#sd_player.sn, util:term_to_bitstring(GetGoodsList), NewSdPlayer#sd_player.fight_times,
                NewSdPlayer#sd_player.point, util:unixtime()])),
        ok
         end,
    lists:foreach(F2, SdPlayerList),
    %%日记-----------------
    cross_six_dragon:del_ets_team(Copy),
    scene_init:stop_scene(?SCENE_ID_SIX_DRAGON_FIGHT, Copy),
    ok.

get_point_rank(Sn) ->
    Key = lists:concat(["point_rank_", Sn]),
    case get(Key) of
        undefined ->
            refresh_point_rank(Sn),
            get_point_rank(Sn);
        {RankList, Time} ->
            Now = util:unixtime(),
            case Now - Time > 20 of
                true ->
                    refresh_point_rank(Sn),
                    get_point_rank(Sn);
                false ->
                    RankList
            end
    end.
refresh_point_rank(Sn) ->
    center:get_nodes(),
    MS = ets:fun2ms(fun(Sdp) when Sdp#sd_player.point > 0 andalso Sdp#sd_player.sn == Sn ->
        {
            Sdp#sd_player.pkey,
            Sdp#sd_player.name,
            Sdp#sd_player.sn,
            Sdp#sd_player.fight_times,
            Sdp#sd_player.point
        } end),
    All = ets:select(?ETS_SIX_DRAGON_PLAYER, MS),
    SortList = lists:sublist(lists:reverse(lists:keysort(5, All)), 30),
    F = fun({Pkey, Name, Sn1, Ftimes, Point}, Order) ->
        {{Order, Pkey, Name, Sn1, Ftimes, Point}, Order + 1}
        end,
    {List, _} = lists:mapfoldl(F, 1, SortList),
    Key = lists:concat(["point_rank_", Sn]),
    put(Key, {List, util:unixtime()}).


%%发送积分排名奖励
point_rank_reward() ->
    AllSnNode = center:get_sn_node_list(),
    point_rank_reward_1(AllSnNode),
    ok.
point_rank_reward_1([]) -> skip;
point_rank_reward_1([{Sn, Node} | Tail]) ->
    refresh_point_rank(Sn),
    RankList = get_point_rank(Sn),
    center:apply(Node, cross_six_dragon, point_rank_reward, [RankList]),
    spawn(fun() -> log_rank_reward(RankList) end),
    point_rank_reward_1(Tail).

%%积分排名日记
log_rank_reward([]) -> skip;
log_rank_reward([{Order, Pkey, _Name, Sn1, _Ftimes, Point} | Tail]) ->
    case Order > 20 of
        true -> skip;
        false ->
            log_proc:log(io_lib:format("insert into log_cross_six_dragon set pkey=~p,sn=~p,goods='~s',rank=~p,point=~p,time=~p",
                [Pkey, Sn1, util:term_to_bitstring([]), Order, Point, util:unixtime()]))
    end,
    log_rank_reward(Tail).

sendout_player(Self) ->
%%传送玩家出去
    ScenePlayerList1 = scene_agent:get_scene_player(?SCENE_ID_SIX_DRAGON),
    ScenePlayerList2 = scene_agent:get_scene_player(?SCENE_ID_SIX_DRAGON_FIGHT),
    Fs = fun(ScenePlayer) ->
        center:apply(ScenePlayer#scene_player.node, cross_six_dragon, sendout_scene_to_main, [ScenePlayer#scene_player.key]),
        ?CAST(Self, {get_point_rank, ScenePlayer#scene_player.key, ScenePlayer#scene_player.sid, ScenePlayer#scene_player.sn, ScenePlayer#scene_player.node})
         end,
    lists:foreach(Fs, ScenePlayerList1 ++ ScenePlayerList2),
    ok.