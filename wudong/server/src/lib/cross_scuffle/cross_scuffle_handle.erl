%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2017 13:45
%%%-------------------------------------------------------------------
-module(cross_scuffle_handle).
-author("hxming").

-include("common.hrl").
-include("scene.hrl").
-include("cross_scuffle.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

-export([cmd_match/0]).

handle_call(_Msg, _from, State) ->
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Node, Sid}, State) ->
    if State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_584:write(58401, {State#st_cross_scuffle.open_state, max(0, State#st_cross_scuffle.time - util:unixtime())}),
            server_send:send_to_sid(Node,Sid,Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%查询匹配状态,0无,1个人,2小队
handle_cast({check_match_state, Node, Pkey, Sid, Times}, State) ->
    MatchState =
        if State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_CLOSE -> 0;
            true ->
                case lists:keyfind(Pkey, #scuffle_mb.pkey, State#st_cross_scuffle.mb_list) of
                    false ->
                        0;
                    Mb ->
                        ?IF_ELSE(Pkey == Mb#scuffle_mb.team_key, 1, 2)
                end
        end,
    {ok, Bin} = pt_584:write(58402, {MatchState, Times, ?DAILY_CROSS_SCUFFLE_TIMES_LIM}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%取消匹配
handle_cast({cancel_match, Pkey}, State) ->
    NewState =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#st_cross_scuffle.mb_list) of
            false ->
                State;
            {value, Mb, T} ->
                MatchList = lists:keydelete(Mb#scuffle_mb.team_key, 1, State#st_cross_scuffle.match_list),
                if Mb#scuffle_mb.team_key == Pkey ->
                    State#st_cross_scuffle{mb_list = T, match_list = MatchList};
                    true ->
                        {ok, Bin} = pt_584:write(58404, {16, Mb#scuffle_mb.nickname}),
                        F = fun(M, L) ->
                            if M#scuffle_mb.team_key /= Mb#scuffle_mb.team_key ->
                                [M | L];
                                true ->
                                    server_send:send_node_pid(M#scuffle_mb.node, M#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
                                    center:apply(M#scuffle_mb.node, server_send, send_to_pid, [M#scuffle_mb.pid, Bin]),
                                    L
                            end
                        end,
                        MbList = lists:foldl(F, [], T),
                        State#st_cross_scuffle{mb_list = MbList, match_list = MatchList}
                end
        end,
    {noreply, NewState};

%%个人匹配
handle_cast({match_single, Mb}, State) ->
    {Ret, NewState} =
        if State#st_cross_scuffle.open_state =/= ?CROSS_SCUFFLE_STATE_START ->
            {5, State};
            true ->
                case lists:keytake(Mb#scuffle_mb.pkey, #scuffle_mb.pkey, State#st_cross_scuffle.mb_list) of
                    false ->
                        MbList = [Mb | State#st_cross_scuffle.mb_list],
                        MatchList = lists:keydelete(Mb#scuffle_mb.team_key, 1, State#st_cross_scuffle.match_list) ++ [{Mb#scuffle_mb.team_key, 1}],
                        server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_CROSS_SCUFFLE}),
                        {1, State#st_cross_scuffle{mb_list = MbList, match_list = MatchList}};
                    {value, OldMb, T} ->
                        if OldMb#scuffle_mb.team_key == OldMb#scuffle_mb.pkey ->
                            MbList = [Mb | T],
                            MatchList = lists:keydelete(Mb#scuffle_mb.team_key, 1, State#st_cross_scuffle.match_list) ++ [{Mb#scuffle_mb.team_key, 1}],
                            server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_CROSS_SCUFFLE}),
                            {1, State#st_cross_scuffle{mb_list = MbList, match_list = MatchList}};
                            true -> {7, State}
                        end
                end
        end,
    {ok, Bin} = pt_584:write(58403, {Ret}),
    center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin]),
    {noreply, NewState};

handle_cast({match_team, Node, Pkey, Sid, TeamKey, MbList}, State) ->
    {Ret, Name, NewState} =
        if State#st_cross_scuffle.open_state =/= ?CROSS_SCUFFLE_STATE_START ->
            {5, <<>>, State};
            true ->
                case check_team_match(MbList, State#st_cross_scuffle.mb_list) of
                    {false, Nickname} ->
                        {12, Nickname, State};
                    ok ->
                        case is_all_agree(MbList) of
                            false ->
                                Team = #scuffle_team{team_key = TeamKey, time = util:unixtime(), mb_list = MbList},
                                TeamList = [Team | lists:keydelete(TeamKey, #scuffle_team.team_key, State#st_cross_scuffle.team_list)],
                                %%通知其他成员
                                {ok, Bin} = pt_584:write(58405, {1}),
                                F1 = fun(Mb) ->
                                    ?DO_IF(Mb#scuffle_mb.pkey /= Pkey, center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin]))
                                end,
                                lists:foreach(F1, MbList),
                                {15, <<>>, State#st_cross_scuffle{team_list = TeamList}};
                            true ->
                                NewMbList = MbList ++ State#st_cross_scuffle.mb_list,
                                MatchList = [{TeamKey, length(MbList)} | lists:keydelete(TeamKey, 1, State#st_cross_scuffle.match_list)],
                                F = fun(Mb) ->
                                    server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_CROSS_SCUFFLE})
                                end,
                                lists:foreach(F, MbList),
                                {1, <<>>, State#st_cross_scuffle{mb_list = NewMbList, match_list = MatchList}}
                        end
                end
        end,
    {ok, BinRet} = pt_584:write(58404, {Ret, Name}),
    server_send:send_to_sid(Node,Sid,BinRet),
%%    center:apply(Node, server_send, send_to_sid, [Sid, BinRet]),
    {noreply, NewState};

%%队伍确认
handle_cast({team_agree, Pkey, TeamKey}, State) ->
    NewState =
        case lists:keytake(TeamKey, #scuffle_team.team_key, State#st_cross_scuffle.team_list) of
            false -> State;
            {value, Team, T} ->
                case lists:keytake(Pkey, #scuffle_mb.pkey, Team#scuffle_team.mb_list) of
                    false ->
                        State;
                    {value, TeamMb, L} ->
                        TeamMbList = [TeamMb#scuffle_mb{is_agree = 1} | L],
                        case is_all_agree(TeamMbList) of
                            true ->
                                NewMbList = TeamMbList ++ State#st_cross_scuffle.mb_list,
                                MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle.match_list) ++ [{TeamKey, length(TeamMbList)}],
                                F = fun(Mb) ->
                                    server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_CROSS_SCUFFLE})
                                end,
                                lists:foreach(F, TeamMbList),
                                %%通知其他成员
                                {ok, Bin} = pt_584:write(58404, {1, <<>>}),
                                F1 = fun(Mb) ->
                                    center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin])
                                end,
                                lists:foreach(F1, TeamMbList),
                                State#st_cross_scuffle{team_list = T, match_list = MatchList, mb_list = NewMbList};
                            false ->
                                NewTeam = Team#scuffle_team{mb_list = TeamMbList},
                                State#st_cross_scuffle{team_list = [NewTeam | T]}
                        end
                end
        end,
    {noreply, NewState};

%%拒绝匹配
handle_cast({team_refuse, Pkey, TeamKey}, State) ->
    NewState =
        case lists:keytake(TeamKey, #scuffle_team.team_key, State#st_cross_scuffle.team_list) of
            false -> State;
            {value, Team, T} ->
                case lists:keytake(Pkey, #scuffle_mb.pkey, Team#scuffle_team.mb_list) of
                    false -> State;
                    {value, Mb, L} ->
                        %%通知其他成员
                        {ok, Bin} = pt_584:write(58404, {17, Mb#scuffle_mb.nickname}),
                        F1 = fun(Mb1) ->
                            server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
                            center:apply(Mb1#scuffle_mb.node, server_send, send_to_pid, [Mb1#scuffle_mb.pid, Bin])
                        end,
                        lists:foreach(F1, L),
                        State#st_cross_scuffle{team_list = T}
                end
        end,
    {noreply, NewState};

handle_cast({del_play, Pid}, State) ->
    PlayList = lists:delete(Pid, State#st_cross_scuffle.play_list),
    {noreply, State#st_cross_scuffle{play_list = PlayList}};

%%离线
handle_cast({logout, Pkey, TeamKey, Copy}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#st_cross_scuffle.mb_list) of
            false ->
                State#st_cross_scuffle.mb_list;
            {value, Mb, T} ->
                if Mb#scuffle_mb.team_key == Pkey -> T;
                    true ->
                        {ok, Bin} = pt_584:write(58404, {18, Mb#scuffle_mb.nickname}),
                        F = fun(M) ->
                            if M#scuffle_mb.team_key == Mb#scuffle_mb.team_key ->
                                server_send:send_node_pid(M#scuffle_mb.node, M#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
                                center:apply(M#scuffle_mb.node, server_send, send_to_pid, [M#scuffle_mb.pid, Bin]),
                                [];
                                true -> [M]
                            end
                        end,
                        lists:flatmap(F, T)
                end
        end,
    MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle.match_list),

    TeamList =
        case lists:keytake(TeamKey, #scuffle_team.team_key, State#st_cross_scuffle.team_list) of
            false -> State#st_cross_scuffle.team_list;
            {value, Team, T1} ->
                case lists:keytake(Pkey, #scuffle_mb.pkey, Team#scuffle_team.mb_list) of
                    false -> State#st_cross_scuffle.team_list;
                    {value, Mb1, L1} ->
                        {ok, Bin1} = pt_584:write(58404, {18, Mb1#scuffle_mb.nickname}),
                        F1 = fun(M1) ->
                            center:apply(M1#scuffle_mb.node, server_send, send_to_pid, [M1#scuffle_mb.pid, Bin1])
                        end,
                        lists:foreach(F1, L1),
                        T1
                end
        end,
    case lists:member(Copy, State#st_cross_scuffle.play_list) of
        false -> ok;
        true ->
            Copy ! {logout, Pkey}
    end,
    {noreply, State#st_cross_scuffle{mb_list = MbList, match_list = MatchList, team_list = TeamList}};

%%退出队伍
handle_cast({quit_team, Pkey, TeamKey}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_mb.pkey, State#st_cross_scuffle.mb_list) of
            false ->
                State#st_cross_scuffle.mb_list;
            {value, Mb, T} ->
                if Mb#scuffle_mb.team_key == Pkey -> T;
                    true ->
                        {ok, Bin} = pt_584:write(58404, {19, Mb#scuffle_mb.nickname}),
                        F = fun(M) ->
                            if M#scuffle_mb.team_key == Mb#scuffle_mb.team_key ->
                                server_send:send_node_pid(M#scuffle_mb.node, M#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
                                center:apply(M#scuffle_mb.node, server_send, send_to_pid, [M#scuffle_mb.pid, Bin]),
                                [];
                                true -> [M]
                            end
                        end,
                        lists:flatmap(F, T)
                end
        end,
    MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle.match_list),

    TeamList =
        case lists:keytake(TeamKey, #scuffle_team.team_key, State#st_cross_scuffle.team_list) of
            false -> State#st_cross_scuffle.team_list;
            {value, Team, T1} ->
                case lists:keytake(Pkey, #scuffle_mb.pkey, Team#scuffle_team.mb_list) of
                    false -> State#st_cross_scuffle.team_list;
                    {value, Mb1, L1} ->
                        {ok, Bin1} = pt_584:write(58404, {19, Mb1#scuffle_mb.nickname}),
                        F1 = fun(M1) ->
                            center:apply(M1#scuffle_mb.node, server_send, send_to_pid, [M1#scuffle_mb.pid, Bin1])
                        end,
                        lists:foreach(F1, L1),
                        T1
                end
        end,
    {noreply, State#st_cross_scuffle{mb_list = MbList, match_list = MatchList, team_list = TeamList}};

%%队伍解散
handle_cast({team_dissolve, TeamKey}, State) when State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_START ->
    TeamList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle.team_list),
    MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle.match_list),
%%    server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
    F = fun(Mb) ->
        if Mb#scuffle_mb.team_key /= TeamKey -> [Mb];
            true ->
                server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
                []
        end
    end,
    MbList = lists:flatmap(F, State#st_cross_scuffle.mb_list),
    {noreply, State#st_cross_scuffle{team_list = TeamList, match_list = MatchList, mb_list = MbList}};

handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_cross_scuffle.ref]),
    NewState = cross_scuffle_proc:set_timer(State, Now),
    {noreply, NewState};


%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_CLOSE ->
    ?DEBUG("cross scuffle ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_cross_scuffle.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_584:write(58401, {?CROSS_SCUFFLE_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_ready, []])
    end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_cross_scuffle{open_state = ?CROSS_SCUFFLE_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_cross_scuffle.open_state /= ?CROSS_SCUFFLE_STATE_START ->
    util:cancel_ref([State#st_cross_scuffle.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_584:write(58401, {?CROSS_SCUFFLE_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_start, []])
    end,
    lists:foreach(F, center:get_nodes()),
    MatchRef = erlang:send_after(3000, self(), match),
    put(match, MatchRef),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    NewState = State#st_cross_scuffle{
        open_state = ?CROSS_SCUFFLE_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        match_list = [],
        mb_list = [],
        play_list = []
    },
    ?DEBUG("cross scuffle start ~n"),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("cross scuffle close ~n"),
    util:cancel_ref([State#st_cross_scuffle.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_584:write(58401, {?CROSS_SCUFFLE_STATE_CLOSE, 0}),

    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [cross_scuffle_close, []]),
    end,
    lists:foreach(F, center:get_nodes()),
    NewState = cross_scuffle_proc:set_timer(State, Now),
    [catch Pid ! close || Pid <- State#st_cross_scuffle.play_list],
    %%取消匹配
    {ok, BinCancel} = pt_584:write(58411, {1}),
    F1 = fun(Mb) ->
        server_send:send_node_pid(Mb#scuffle_mb.node, Mb#scuffle_mb.pid, {match_state, ?MATCH_STATE_NO}),
        center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, BinCancel])
    end,
    lists:foreach(F1, State#st_cross_scuffle.mb_list),
    {noreply, NewState};

%%数据匹配
handle_info(match, State) when State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_START ->
%%    ?DEBUG("cross scuffle match ~p~n", [State#st_cross_scuffle.match_list]),
    misc:cancel_timer(match),
    MatchRef = erlang:send_after(3000, self(), match),
    put(match, MatchRef),
    {MatchList, MbList, PlayList} = match(State#st_cross_scuffle.match_list, State#st_cross_scuffle.mb_list, State#st_cross_scuffle.play_list),
    NewState = State#st_cross_scuffle{match_list = MatchList, mb_list = MbList, play_list = PlayList},
    {noreply, NewState};

%%小队超时检查
handle_info(team_timeout, State) when State#st_cross_scuffle.open_state == ?CROSS_SCUFFLE_STATE_START ->
    misc:cancel_timer(team_timeout),
    MatchRef = erlang:send_after(5000, self(), team_timeout),
    put(team_timeout, MatchRef),
    Now = util:unixtime(),
    {ok, Bin} = pt_584:write(58404, {13, <<>>}),
    F = fun(Team) ->
        if Team#scuffle_team.time + ?CROSS_SCUFFLE_TEAM_TIMEOUT < Now ->
            F = fun(Mb) ->
                center:apply(Mb#scuffle_mb.node, server_send, send_to_pid, [Mb#scuffle_mb.pid, Bin])
            end,
            lists:foreach(F, Team#scuffle_team.mb_list),
            [];
            true ->
                [Team]
        end
    end,
    TeamList = lists:flatmap(F, State#st_cross_scuffle.team_list),
    {noreply, State#st_cross_scuffle{team_list = TeamList}};


handle_info(_Msg, State) ->
    {noreply, State}.


check_team_match([], _MbList) -> ok;
check_team_match([Mb | T], MbList) ->
    case lists:keymember(Mb#scuffle_mb.pkey, #scuffle_mb.pkey, MbList) of
        false ->
            check_team_match(T, MbList);
        true ->
            {false, Mb#scuffle_mb.nickname}
    end.

%%匹配计算
match(MatchList, MbList, PlayList) ->
%%    ?DEBUG("MatchList ~p~n",[MatchList]),
    MbLim = match_member_lim(),
    case match_group(MatchList, MbLim) of
        false ->
            {MatchList, MbList, PlayList};
        {true, RedGroupList} ->
            MatchList1 = filter_match_list(MatchList, RedGroupList),
            case match_group(MatchList1, MbLim) of
                false ->
                    {MatchList, MbList, PlayList};
                {true, BlueGroupList} ->
                    NewMatchList = filter_match_list(MatchList1, BlueGroupList),
                    %%匹配成功
                    {MbList1, RedMbList} = filter_mb_list(MbList, RedGroupList),
                    {NewMbList, BlueMbList} = filter_mb_list(MbList1, BlueGroupList),
                    {ok, Pid} = cross_scuffle_play:start(RedMbList, BlueMbList),
                    {NewMatchList, NewMbList, [Pid | PlayList]}
            end
    end.

filter_match_list(MatchList, GroupList) ->
    F = fun(Key, L) -> lists:keydelete(Key, 1, L) end,
    lists:foldl(F, MatchList, GroupList).

filter_mb_list(MbList, GroupList) ->
    F = fun(Mb, {L1, L2}) ->
        case lists:member(Mb#scuffle_mb.team_key, GroupList) of
            false -> {[Mb | L1], L2};
            true -> {L1, [Mb | L2]}
        end
    end,
    lists:foldl(F, {[], []}, MbList).


match_group([], _MbLim) -> false;
match_group(MatchList, MbLim) ->
    case do_match_group(MatchList, 0, MbLim, []) of
        false ->
            [_ | T] = MatchList,
            match_group(T, MbLim);
        {true, GroupList} ->
            {true, GroupList}
    end.

do_match_group([], _CorCount, _MbLim, _GroupList) -> false;
do_match_group([{TeamKey, Count} | T], CurCount, MbLim, GroupList) ->
    NewCount = CurCount + Count,
    if NewCount == MbLim ->
        {true, [TeamKey | GroupList]};
        NewCount > MbLim ->
            do_match_group(T, CurCount, MbLim, GroupList);
        true ->
            do_match_group(T, NewCount, MbLim, [TeamKey | GroupList])
    end.

match_member_lim() ->
    case config:get_config_ip() of
        "127.0.0.1" -> 1;
        "120.92.144.246" -> 4;
        "123.207.118.228" -> 4;
        _ -> 4
    end.

is_all_agree(MbList) ->
    F = fun(MbCheck) -> MbCheck#scuffle_mb.is_agree == 1 end,
    lists:all(F, MbList).

cmd_match() ->
    F = fun(Id) -> {Id, util:rand(1, 3)} end,
    MatchList = lists:map(F, lists:seq(1, 15)),
    ?DEBUG("matchlist ~p~n", [MatchList]),
    Ret = match_group(MatchList, 4),
    Ret.