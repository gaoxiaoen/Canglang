%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 17:59
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_handle).
-author("Administrator").
-include("cross_scuffle_elite.hrl").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

-define(WIN_DESIGNATION, 6603082). %% 冠军称号id
-define(PAGE_NUM, 10).
-define(PAGE_NUM1, 9).

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

-export([stage_notice/2, random_final_list/1]).

%%获取活动状态
handle_call(get_scfflie_elite_state, _from, State) ->
    {reply, {State#st_cross_scuffle_elite.open_state, State#st_cross_scuffle_elite.next_fight_num}, State};

%%获取决赛战队key
handle_call(get_final_key_list, _from, State) ->
    F = fun(FinalWar) ->
        FinalWar#final_war.wtkey
    end,
    List = lists:map(F, State#st_cross_scuffle_elite.final_list),
    {reply, List, State};

%%获取决赛战队列表
handle_call(get_final_list, _from, State) ->
    {reply, State#st_cross_scuffle_elite.final_list, State};

%%赛程下注
handle_call({bet_war_team, Node, _Sid, Pkey, FightNum, WtKey, Id}, _from, State) ->
    {Ret1, NewState} =
        if State#st_cross_scuffle_elite.open_state == ?CROSS_SCUFFLE_ELITE_STATE_CLOSE -> State;
            true ->
                case lists:keytake(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
                    false ->
                        {38, State};
                    {value, FightRecord, List} ->
                        Now = util:unixtime(),
                        LeaveTime =
                            if
                                State#st_cross_scuffle_elite.next_fight_time - Now >= 4.5 * 60 %% 比赛中
                                    andalso State#st_cross_scuffle_elite.next_fight_time - Now =< 8 * 60 -> 0;
                                true -> State#st_cross_scuffle_elite.next_fight_time - Now
                            end,
                        ?DEBUG("State#st_cross_scuffle_elite.next_fight_time ~p~n", [State#st_cross_scuffle_elite.next_fight_time]),
                        ?DEBUG("Now ~p~n", [Now]),
                        ?DEBUG("LeaveTime ~p~n", [LeaveTime]),
                        {Ret, NewFightRecord} =
                            if
                                FightRecord#fight_record.final_war1#final_war.wtkey == 0 orelse FightRecord#fight_record.final_war2#final_war.wtkey == 0 ->
                                    {34, FightRecord};
                                LeaveTime =< 0 -> {38, FightRecord};
                                FightRecord#fight_record.win_key /= 0 -> {38, FightRecord};
                                true ->
                                    case lists:keyfind(Pkey, 1, FightRecord#fight_record.bet_list) of
                                        false ->
                                            {1,
                                                FightRecord#fight_record{
                                                    bet_list = [{Pkey, WtKey, Id, Node} | FightRecord#fight_record.bet_list]
                                                }};
                                        _ -> {35, FightRecord}
                                    end
                            end,
                        {Ret, State#st_cross_scuffle_elite{fight_record = [NewFightRecord | List]}}
                end
        end,
    ?DEBUG("Ret1 ~p~n", [Ret1]),
    {reply, Ret1, NewState};

handle_call(_Msg, _from, State) ->
    ?DEBUG("11111 ~n"),
    {reply, ok, State}.

%%查询活动状态
handle_cast({check_state, Node, Sid}, State) ->
    if State#st_cross_scuffle_elite.open_state == ?CROSS_SCUFFLE_ELITE_STATE_CLOSE -> skip;
        true ->
            ?DEBUG("State#st_cross_scuffle_elite.time ~p~n", [State#st_cross_scuffle_elite.time]),
            {ok, Bin} = pt_585:write(58501, {State#st_cross_scuffle_elite.open_state, max(0, State#st_cross_scuffle_elite.time - util:unixtime())}),
            server_send:send_to_sid(Node, Sid, Bin)
    end,
    {noreply, State};

%%查看投注信息
handle_cast({get_bet_info, Node, Sid, FightNum, Pkey}, State) ->
    ?DEBUG("FightNum ~p~n", [FightNum]),
    if State#st_cross_scuffle_elite.open_state == ?CROSS_SCUFFLE_ELITE_STATE_CLOSE ->
        {ok, Bin} = pt_585:write(58535, {38, 0, 0, <<>>, 0, 0, 0, [], []}),
        server_send:send_to_sid(Node, Sid, Bin),
        skip;
        true ->
            case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
                false ->
                    {ok, Bin} = pt_585:write(58535, {38, 0, 0, <<>>, 0, 0, 0, [], []}),
                    server_send:send_to_sid(Node, Sid, Bin),
                    skip;
                FightRecord ->
                    F = fun(FinalWar) ->
                        case cross_scuffle_elite_war_team_ets:get_war_team(FinalWar#final_war.wtkey) of
                            false -> [0, <<>>, <<>>, 0, 0, 0, 0];
                            WarTeam ->
                                [WarTeam#war_team.wtkey,
                                    WarTeam#war_team.name,
                                    WarTeam#war_team.pname,
                                    WarTeam#war_team.sn,
                                    WarTeam#war_team.win,
                                    WarTeam#war_team.lose,
                                    WarTeam#war_team.score]
                        end
                    end,
                    WtInfoList = lists:map(F, [FightRecord#fight_record.final_war1, FightRecord#fight_record.final_war2]),
                    F0 = fun(Base) ->
                        [Base#base_cross_scuffle_elite_bet.id,
                            Base#base_cross_scuffle_elite_bet.goods_id,
                            Base#base_cross_scuffle_elite_bet.num]
                    end,
                    BaseList =
                        if State#st_cross_scuffle_elite.next_fight_num == 15 ->
                            data_cross_scuffle_elite_bet:get(1);
                            true -> data_cross_scuffle_elite_bet:get(2)
                        end,
                    BetList = lists:map(F0, BaseList),
                    ?DEBUG("******************** ~p~n", [BetList]),
                    {BetWtKey, BetName, BetId, BetGoodsId, BetNum} =
                        case lists:keyfind(Pkey, 1, FightRecord#fight_record.bet_list) of
                            false -> {0, <<>>, 0, 0, 0};
                            {Pkey, Wtkey0, Id, Node} ->
                                Base0 = cross_scuffle_elite:get_bet_base(State#st_cross_scuffle_elite.next_fight_num, Id),
                                WarTeam0 = cross_scuffle_elite_war_team_ets:get_war_team(Wtkey0),
                                {Wtkey0, WarTeam0#war_team.name, Id, Base0#base_cross_scuffle_elite_bet.goods_id, Base0#base_cross_scuffle_elite_bet.num}
                        end,
                    Now = util:unixtime(),
                    {ok, Bin} = pt_585:write(58535, {1, State#st_cross_scuffle_elite.next_fight_time - Now, BetWtKey, BetName, BetId, BetGoodsId, BetNum, WtInfoList, BetList}),
                    server_send:send_to_sid(Node, Sid, Bin)
            end
    end,
    {noreply, State};


%%获取战队列表
handle_cast({get_war_team_list, Player, Page, Type, Node}, State) ->
    OpenState = State#st_cross_scuffle_elite.open_state,
    if
        OpenState == ?CROSS_SCUFFLE_ELITE_STATE_START ->
            WarTeamList = cross_scuffle_elite_war_team_ets:get_all_war_team(),
            F0 = fun(WarTeam1, WarTeam2) ->
                ?IF_ELSE(WarTeam1#war_team.score > WarTeam2#war_team.score, true, false)
            end,
            List = lists:sort(F0, WarTeamList),
            F = fun(WarTeam, {Rank, List1}) ->
                if
                    Type == 1 andalso WarTeam#war_team.sn /= Player#player.sn_cur -> {Rank + 1, List1};
                    true ->
                        {Rank + 1, [[WarTeam#war_team.name,
                            WarTeam#war_team.sn,
                            WarTeam#war_team.wtkey,
                            WarTeam#war_team.pname,
                            WarTeam#war_team.win,
                            WarTeam#war_team.lose,
                            WarTeam#war_team.num,
                            WarTeam#war_team.score,
                            Rank]] ++ List1}
                end
            end,
            {_, List0} = lists:foldl(F, {1, []}, List),
            List1 = lists:reverse(List0),
            MaxPage = length(List1) div ?PAGE_NUM + 1,
            NowPage = if Page =< 0 orelse Page > MaxPage -> 1;true -> Page end,
            NewList = lists:sublist(List1, NowPage * ?PAGE_NUM - ?PAGE_NUM1, ?PAGE_NUM),
            Data = {0, Page, MaxPage, NewList},
            {ok, Bin} = pt_585:write(58518, Data),
            server_send:send_to_sid(Node, Player#player.sid, Bin);
        true ->
            TeamKeyList = sort_fight_record(State#st_cross_scuffle_elite.fight_record),
            WarTeamList0 = cross_scuffle_elite_war_team_ets:get_all_war_team(),
            F0 = fun(WarTeamKey, WarTeamList1) ->
                lists:keydelete(WarTeamKey, #war_team.wtkey, WarTeamList1)
            end,
            OtherWarTeamList = lists:foldl(F0, WarTeamList0, TeamKeyList),
            F1 = fun(WarTeamKey) ->
                case cross_scuffle_elite_war_team_ets:get_war_team(WarTeamKey) of
                    false -> [];
                    WarTeam0 ->
                        [WarTeam0]
                end
            end,
            HeadWarTeamList = lists:flatmap(F1, TeamKeyList),
            F2 = fun(WarTeam1, WarTeam2) ->
                ?IF_ELSE(WarTeam1#war_team.score > WarTeam2#war_team.score, true, false)
            end,
            List = lists:sort(F2, OtherWarTeamList),
            F3 = fun(WarTeam, {Rank, List1}) ->
                if
                    Type == 1 andalso WarTeam#war_team.sn /= Player#player.sn_cur -> {Rank + 1, List1};
                    true ->
                        {Rank + 1, [[WarTeam#war_team.name,
                            WarTeam#war_team.sn,
                            WarTeam#war_team.wtkey,
                            WarTeam#war_team.pname,
                            WarTeam#war_team.win,
                            WarTeam#war_team.lose,
                            WarTeam#war_team.num,
                            WarTeam#war_team.score,
                            Rank]] ++ List1}
                end
            end,
            {_, List0} = lists:foldl(F3, {1, []}, HeadWarTeamList ++ List),
            List1 = lists:reverse(List0),
            MaxPage = length(List1) div ?PAGE_NUM + 1,
            NowPage = if Page =< 0 orelse Page > MaxPage -> 1;true -> Page end,
            NewList = lists:sublist(List1, NowPage * ?PAGE_NUM - ?PAGE_NUM1, ?PAGE_NUM),
            Index = ?IF_ELSE(State#st_cross_scuffle_elite.fight_record == [], 0, get_round(State#st_cross_scuffle_elite.next_fight_num)),
            Data = {Index, Page, MaxPage, NewList},
            {ok, Bin} = pt_585:write(58518, Data),
            server_send:send_to_sid(Node, Player#player.sid, Bin)
    end,
    {noreply, State};

handle_cast({update_fight_record, FightNum, WinTeamKey, LoseTeamKey}, State) ->
    NewFightRecordList =
        case lists:keytake(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            {value, FightRecord, List} ->
                NewFightRecord = FightRecord#fight_record{win_key = WinTeamKey, is_finish = 1},
                [NewFightRecord | List];
            false ->
                NewFightRecord = #fight_record{
                    id = FightNum,
                    final_war1 = #final_war{wtkey = WinTeamKey},
                    final_war2 = #final_war{wtkey = LoseTeamKey},
                    win_key = WinTeamKey,
                    is_finish = 1
                },
                [NewFightRecord | State#st_cross_scuffle_elite.fight_record]
        end,
    NewState = State#st_cross_scuffle_elite{fight_record = NewFightRecordList},
    %% 每一轮公告
    spawn(fun() -> stage_notice(WinTeamKey, FightNum) end),
    %% 发送投注奖励邮件
    spawn(fun() -> bet_back(FightNum, NewFightRecord) end),
    cross_scuffle_elite:final_war_reward(WinTeamKey, LoseTeamKey, WinTeamKey, FightNum),
    {noreply, NewState};

handle_cast({update_join_team, TeamKey}, State) ->
    JoinTeamList =
        case lists:member(TeamKey, State#st_cross_scuffle_elite.join_team_list) of
            true -> State#st_cross_scuffle_elite.join_team_list;
            false -> [TeamKey | State#st_cross_scuffle_elite.join_team_list];
            _ -> State#st_cross_scuffle_elite.join_team_list
        end,
    {noreply, State#st_cross_scuffle_elite{join_team_list = JoinTeamList}};

%%查询准备场景信息
handle_cast({get_ready_info, Node, Sid}, State) ->
    Round = get_index_circle(State#st_cross_scuffle_elite.next_fight_num),
    {ok, Bin} = pt_585:write(58531, {Round, max(0, State#st_cross_scuffle_elite.next_fight_time - util:unixtime()), max(0, State#st_cross_scuffle_elite.total_time - util:unixtime())}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

%%查询对阵图
handle_cast({get_war_map, Node, Sid}, State) ->
    F = fun(FightRecord) ->
        [FightRecord#fight_record.id,
            FightRecord#fight_record.win_key,
            FightRecord#fight_record.final_war1#final_war.wtkey,
            FightRecord#fight_record.final_war1#final_war.wtname,
            FightRecord#fight_record.final_war1#final_war.sn,
            FightRecord#fight_record.final_war2#final_war.wtkey,
            FightRecord#fight_record.final_war2#final_war.wtname,
            FightRecord#fight_record.final_war2#final_war.sn]
    end,
    Data = lists:map(F, State#st_cross_scuffle_elite.fight_record),
    Round = get_round(State#st_cross_scuffle_elite.next_fight_num),
    Now = util:unixtime(),
    BetState =
        if State#st_cross_scuffle_elite.fight_record == [] -> 1; %% 赛程为空
            true ->
                if
                    State#st_cross_scuffle_elite.next_fight_time - Now >= 4.5 * 60 %% 比赛中
                        andalso State#st_cross_scuffle_elite.next_fight_time - Now =< 8 * 60 -> 0;
                    true -> Round
                end
        end,
    {ok, Bin} = pt_585:write(58530, {?WIN_DESIGNATION, BetState, Data}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

handle_cast({match_team, Node, _Pkey, Sid, TeamKey, MbList}, State) ->
    {Ret, Name, NewState} =
        if State#st_cross_scuffle_elite.open_state =/= ?CROSS_SCUFFLE_ELITE_STATE_START ->
            {28, <<>>, State};
            true ->
                case check_team_match(MbList, State#st_cross_scuffle_elite.mb_list) of
                    {false, Nickname} ->
                        {12, Nickname, State};
                    ok ->
                        NewMbList = MbList ++ State#st_cross_scuffle_elite.mb_list,
                        MatchList = [{TeamKey, length(MbList)} | lists:keydelete(TeamKey, 1, State#st_cross_scuffle_elite.match_list)],
                        F = fun(Mb) ->
                            {ok, BinCancel} = pt_585:write(58517, {1, <<>>}),
                            center:apply(Mb#scuffle_elite_mb.node, server_send, send_to_pid, [Mb#scuffle_elite_mb.pid, BinCancel]),
                            server_send:send_node_pid(Mb#scuffle_elite_mb.node, Mb#scuffle_elite_mb.pid, {match_state, ?MATCH_STATE_CROSS_SCUFFLE_ELITE})
                        end,
                        lists:foreach(F, MbList),
                        {1, <<>>, State#st_cross_scuffle_elite{mb_list = NewMbList, match_list = MatchList}}
                end
        end,
    {ok, BinRet} = pt_585:write(58517, {Ret, Name}),
    server_send:send_to_sid(Node, Sid, BinRet),
    {noreply, NewState};

%%离线
handle_cast({logout, Pkey, TeamKey, Copy}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_elite_mb.pkey, State#st_cross_scuffle_elite.mb_list) of
            false ->
                State#st_cross_scuffle_elite.mb_list;
            {value, Mb, T} ->
                if Mb#scuffle_elite_mb.team_key == Pkey -> T;
                    true ->
                        {ok, Bin} = pt_585:write(58517, {27, Mb#scuffle_elite_mb.nickname}),
                        F = fun(M) ->
                            if M#scuffle_elite_mb.team_key == Mb#scuffle_elite_mb.team_key ->
                                server_send:send_node_pid(M#scuffle_elite_mb.node, M#scuffle_elite_mb.pid, {match_state, ?MATCH_STATE_NO}),
%%                                 {ok, BinCancel} = pt_585:write(58517, {1, <<>>}),
%%                                 center:apply(Mb#scuffle_elite_mb.node, server_send, send_to_pid, [Mb#scuffle_elite_mb.pid, BinCancel]),
                                center:apply(M#scuffle_elite_mb.node, server_send, send_to_pid, [M#scuffle_elite_mb.pid, Bin]),
                                [];
                                true -> [M]
                            end
                        end,
                        lists:flatmap(F, T)
                end
        end,
    MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle_elite.match_list),

    TeamList =
        case lists:keytake(TeamKey, #scuffle_elite_team.team_key, State#st_cross_scuffle_elite.team_list) of
            false -> State#st_cross_scuffle_elite.team_list;
            {value, Team, T1} ->
                case lists:keytake(Pkey, #scuffle_elite_mb.pkey, Team#scuffle_elite_team.mb_list) of
                    false -> State#st_cross_scuffle_elite.team_list;
                    {value, Mb1, L1} ->
                        {ok, Bin1} = pt_585:write(58517, {18, Mb1#scuffle_elite_mb.nickname}),
                        F1 = fun(M1) ->
                            center:apply(M1#scuffle_elite_mb.node, server_send, send_to_pid, [M1#scuffle_elite_mb.pid, Bin1])
                        end,
                        lists:foreach(F1, L1),
                        T1
                end
        end,
    case lists:member(Copy, State#st_cross_scuffle_elite.play_list) of
        false -> ok;
        true ->
            Copy ! {logout, Pkey}
    end,
    {noreply, State#st_cross_scuffle_elite{mb_list = MbList, match_list = MatchList, team_list = TeamList}};

%%退出战队
handle_cast({quit_team, Pkey, TeamKey}, State) ->
    MbList =
        case lists:keytake(Pkey, #scuffle_elite_mb.pkey, State#st_cross_scuffle_elite.mb_list) of
            false ->
                State#st_cross_scuffle_elite.mb_list;
            {value, Mb, T} ->
                if Mb#scuffle_elite_mb.team_key == Pkey -> T;
                    true ->
                        {ok, Bin} = pt_584:write(58517, {19, Mb#scuffle_elite_mb.nickname}),
                        F = fun(M) ->
                            if M#scuffle_elite_mb.team_key == Mb#scuffle_elite_mb.team_key ->
                                server_send:send_node_pid(M#scuffle_elite_mb.node, M#scuffle_elite_mb.pid, {match_state, ?MATCH_STATE_NO}),
                                center:apply(M#scuffle_elite_mb.node, server_send, send_to_pid, [M#scuffle_elite_mb.pid, Bin]),
                                [];
                                true -> [M]
                            end
                        end,
                        lists:flatmap(F, T)
                end
        end,
    MatchList = lists:keydelete(TeamKey, 1, State#st_cross_scuffle_elite.match_list),

    TeamList =
        case lists:keytake(TeamKey, #scuffle_elite_team.team_key, State#st_cross_scuffle_elite.team_list) of
            false -> State#st_cross_scuffle_elite.team_list;
            {value, Team, T1} ->
                case lists:keytake(Pkey, #scuffle_elite_mb.pkey, Team#scuffle_elite_team.mb_list) of
                    false -> State#st_cross_scuffle_elite.team_list;
                    {value, Mb1, L1} ->
                        {ok, Bin1} = pt_585:write(58517, {19, Mb1#scuffle_elite_mb.nickname}),
                        F1 = fun(M1) ->
                            center:apply(M1#scuffle_elite_mb.node, server_send, send_to_pid, [M1#scuffle_elite_mb.pid, Bin1])
                        end,
                        lists:foreach(F1, L1),
                        T1
                end
        end,
    {noreply, State#st_cross_scuffle_elite{mb_list = MbList, match_list = MatchList, team_list = TeamList}};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    NewState = cross_scuffle_elite_proc:set_timer(State, Now),
    {noreply, NewState};


handle_info(re_update_fight_record, State) ->
    F = fun(FightNum0, State0) ->
        final_match2(State0, FightNum0)
    end,
    NewState1 = lists:foldl(F, State, lists:seq(9, 14)),
    {noreply, NewState1};

%%刷新怪物
handle_info(refresh, State) ->
    misc:cancel_timer(refresh),
    F = fun(FightNum0, State0) ->
        final_match2(State0, FightNum0)
    end,
    NewState1 = lists:foldl(F, State, lists:seq(9, 15)),
    ?DEBUG("State#st_cross_scuffle_elite.next_fight_num ~p~n", [State#st_cross_scuffle_elite.next_fight_num]),
    F1 = fun(Node) ->
        if
            State#st_cross_scuffle_elite.next_fight_num == 16 ->
                center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_party_final, [get_desk_notice_id(State#st_cross_scuffle_elite.next_fight_num)]]);
            true ->
                Next =
                    if
                        State#st_cross_scuffle_elite.next_fight_num =< 9 -> 10;
                        State#st_cross_scuffle_elite.next_fight_num =< 13 -> 15;
                        State#st_cross_scuffle_elite.next_fight_num =< 15 -> 16;
                        true -> 0
                    end,
                center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_party, [get_desk_notice_id(State#st_cross_scuffle_elite.next_fight_num), get_desk_notice_id(Next)]])
        end
    end,
    lists:foreach(F1, center:get_nodes()),
    Round = get_round_id(State#st_cross_scuffle_elite.next_fight_num),
    case data_cross_scuffle_elite_party:get(Round) of
        [] -> skip;
        Base ->
            refresh_desk(Base, State#st_cross_scuffle_elite.next_fight_num)
    end,
    {noreply, NewState1};

%%准备
handle_info({ready, ReadyTime, LastTime}, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_ready, []])
    end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),

    NewState = State#st_cross_scuffle_elite{
        open_state = ?CROSS_SCUFFLE_ELITE_STATE_READY,
        time = Now + ReadyTime,
        ref = Ref,
        team_list = [],
        match_list = [],
        final_list = [],
        next_fight_num = 1,
        next_fight_time = 0,
        fight_record = [],
        join_team_list = [],
        mb_list = [],
        play_list = []
    },
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_start, []])
    end,
    lists:foreach(F, center:get_nodes()),
    MatchRef = erlang:send_after(3000, self(), match),
    put(match, MatchRef),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    NewState = State#st_cross_scuffle_elite{
        open_state = ?CROSS_SCUFFLE_ELITE_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        match_list = [],
        team_list = [],
        fight_record = [],
        mb_list = [],
        play_list = [],
        join_team_list = [],
        final_list = []
    },
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    misc:cancel_timer(final_match),
    [catch Pid ! close || Pid <- State#st_cross_scuffle_elite.play_list],
    %%取消匹配
    {ok, BinCancel} = pt_585:write(58532, {1}),
    F1 = fun(Mb) ->
        server_send:send_node_pid(Mb#scuffle_elite_mb.node, Mb#scuffle_elite_mb.pid, {match_state, ?MATCH_STATE_NO}),
        center:apply(Mb#scuffle_elite_mb.node, server_send, send_to_pid, [Mb#scuffle_elite_mb.pid, BinCancel])
    end,
    lists:foreach(F1, State#st_cross_scuffle_elite.mb_list),
    Now = util:unixtime(),
    Ref = erlang:send_after(3 * 1000, self(), {ready_final, 30 * 60, ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL * 5}),
    {noreply, State#st_cross_scuffle_elite{ref = Ref, total_time = Now + ?CROSS_SCUFFLE_ELITE_STATE_ALL_TIME}};


%%  精英赛准备
handle_info({ready_final, ReadyTime, LastTime}, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    Now = util:unixtime(),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start_final_1, LastTime}),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_FAINAL_READY, ReadyTime}),
    F1 = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_final_ready, []])
    end,
    lists:foreach(F1, center:get_nodes()),

    %% 选出决赛战队
    AllWarTeam = cross_scuffle_elite_war_team_ets:get_all_war_team(),
    F2 = fun(WarTeam1, WarTeam2) ->
        if
            WarTeam1#war_team.score > WarTeam2#war_team.score -> true;
            WarTeam1#war_team.score < WarTeam2#war_team.score -> false;
            WarTeam1#war_team.score_change_time < WarTeam2#war_team.score_change_time -> true;
            WarTeam1#war_team.score_change_time > WarTeam2#war_team.score_change_time -> false;
            true -> true
        end
    end,
    WarTeamList0 = lists:sort(F2, AllWarTeam),
    Len = length(WarTeamList0),
    if
        Len >= 16 ->
            WarTeamList = lists:sublist(WarTeamList0, 16);
        true ->
            WarTeamList = WarTeamList0 ++ lists:duplicate(16 - Len, #war_team{name = <<>>})
    end,
    FinalList1 = make_final_info(WarTeamList),
    FinalList = random_final_list(FinalList1),
    NewState1 = final_team(State#st_cross_scuffle_elite{final_list = FinalList}),
    %% 发送参与奖
    F3 = fun(JoinWarTeamKey) ->
        JoinWarTeam = cross_scuffle_elite_war_team_ets:get_war_team(JoinWarTeamKey),
        JoinKeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(JoinWarTeamKey),
        Reward = data_cross_scuffle_elite_final_reward:get(7),
        {Title, Content} = t_mail:mail_content(136),
        center:apply_sn(JoinWarTeam#war_team.sn, mail, sys_send_mail, [JoinKeyList, Title, Content, lists:reverse(Reward)])
    end,
    lists:foreach(F3, State#st_cross_scuffle_elite.join_team_list),

    %% 发送入围奖
    F4 = fun(WarTeam0) ->
        FinalKeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(WarTeam0#war_team.wtkey),
        Reward = data_cross_scuffle_elite_final_reward:get(6),
        {Title, Content} = t_mail:mail_content(137),
        Msg = io_lib:format(Content, [WarTeam0#war_team.score]),
        center:apply_sn(WarTeam0#war_team.sn, mail, sys_send_mail, [FinalKeyList, Title, Msg, lists:reverse(Reward)])
    end,
    lists:foreach(F4, WarTeamList),

    NewState2 = NewState1#st_cross_scuffle_elite{
        open_state = ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_READY,
        time = Now + ReadyTime,
        match_list = [],
        mb_list = [],
        play_list = [],
        next_fight_num = 1,
        final_list = FinalList,
        next_fight_time = Now + ReadyTime + 5 * 60,
        ref = Ref
    },
    {noreply, NewState2};


handle_info({start_final_1, LastTime}, State) ->
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_FAINAL_START, LastTime}),
    F1 = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_final_ready, []])
    end,
    lists:foreach(F1, center:get_nodes()),
%%     Ref = erlang:send_after(10 * 1000, self(), {start_final, LastTime}),
    Ref = erlang:send_after(5 * 60 * 1000, self(), {start_final, LastTime - 5 * 60}),
    Now = util:unixtime(),
    {noreply, State#st_cross_scuffle_elite{ref = Ref, open_state = ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_START, time = Now + LastTime}};


%%精英赛开始
handle_info({start_final, LastTime}, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_FAINAL_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_final_start, []])
    end,
    lists:foreach(F, center:get_nodes()),
    MatchRef = erlang:send_after(1000, self(), final_match),
    put(final_match, MatchRef),
    Ref = erlang:send_after(LastTime * 1000, self(), final_close),
    NewState1 = State#st_cross_scuffle_elite{
        open_state = ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_START,
        time = Now + LastTime,
        ref = Ref,
        next_fight_num = 1
    },
    {noreply, NewState1};

%%精英赛匹配
handle_info(final_match, State) ->
    misc:cancel_timer(final_match),
    if
        State#st_cross_scuffle_elite.next_fight_num >= 16 ->
            %%  决赛结束
            NewState1 = State#st_cross_scuffle_elite{next_fight_num = 17};
        true ->
            NewState = make_next_fight_record(State),
            Now = util:unixtime(),
            if
                State#st_cross_scuffle_elite.next_fight_num == 15 ->
                    NewState1 = final_match(NewState#st_cross_scuffle_elite{next_fight_time = Now + ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL + 3 * 60});
                true ->
                    NewState1 = final_match(NewState#st_cross_scuffle_elite{next_fight_time = Now + ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL})
            end,
            IsMember = lists:member(State#st_cross_scuffle_elite.next_fight_num, [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 13]),
            if
                IsMember ->
                    MatchRef = erlang:send_after(200, self(), final_match);
                true ->
                    RefreshRef = erlang:send_after(?WELFARE_DESK_TIME * 1000, self(), refresh),
                    put(refresh, RefreshRef),
                    MatchRef = erlang:send_after(?CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL * 1000, self(), final_match)
            end,
            put(final_match, MatchRef)
    end,
    {noreply, NewState1};

%%决赛关闭
handle_info(final_close, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58501, {?CROSS_SCUFFLE_ELITE_STATE_CLOSE, 0}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin])
%%         center:apply(Node, notice_sys, add_notice, [cross_scuffle_close, []]),
    end,
    lists:foreach(F, center:get_nodes()),
    NewState = cross_scuffle_elite_proc:set_timer(State, Now),
    [catch Pid ! close || Pid <- State#st_cross_scuffle_elite.play_list],
    %%取消匹配
    {ok, BinCancel} = pt_585:write(58532, {1}),
    F1 = fun(Mb) ->
        server_send:send_node_pid(Mb#scuffle_elite_mb.node, Mb#scuffle_elite_mb.pid, {match_state, ?MATCH_STATE_NO}),
        center:apply(Mb#scuffle_elite_mb.node, server_send, send_to_pid, [Mb#scuffle_elite_mb.pid, BinCancel])
    end,
    lists:foreach(F1, State#st_cross_scuffle_elite.mb_list),
    {noreply, NewState};

%%数据匹配
handle_info(match, State) when State#st_cross_scuffle_elite.open_state == ?CROSS_SCUFFLE_ELITE_STATE_START ->
    misc:cancel_timer(cross_scuffle_elite_match),
    MatchRef = erlang:send_after(3000, self(), match),
    put(cross_scuffle_elite_match, MatchRef),
    {MatchList, MbList, PlayList} = match(State#st_cross_scuffle_elite.match_list, State#st_cross_scuffle_elite.mb_list, State#st_cross_scuffle_elite.play_list),
    NewState = State#st_cross_scuffle_elite{match_list = MatchList, mb_list = MbList, play_list = PlayList},
    {noreply, NewState};

handle_info(timer_update, State) ->
    util:cancel_ref([State#st_cross_scuffle_elite.timer_update_ref]),
    Ref = erlang:send_after(?WAR_TEAM_TIMER_UPDATE * 1000, self(), timer_update),
    cross_scuffle_elite_war_team_init:timer_update(),
    {noreply, State#st_cross_scuffle_elite{timer_update_ref = Ref}};


%%小队超时检查
handle_info(team_timeout, State) when State#st_cross_scuffle_elite.open_state == ?CROSS_SCUFFLE_ELITE_STATE_START ->
    misc:cancel_timer(team_timeout),
    MatchRef = erlang:send_after(5000, self(), team_timeout),
    put(team_timeout, MatchRef),
    Now = util:unixtime(),
    {ok, Bin} = pt_585:write(58517, {13, <<>>}),
    F = fun(Team) ->
        if Team#scuffle_elite_team.time + ?CROSS_SCUFFLE_ELITE_TEAM_TIMEOUT < Now ->
            F = fun(Mb) ->
                center:apply(Mb#scuffle_elite_mb.node, server_send, send_to_pid, [Mb#scuffle_elite_mb.pid, Bin])
            end,
            lists:foreach(F, Team#scuffle_elite_team.mb_list),
            [];
            true ->
                [Team]
        end
    end,
    TeamList = lists:flatmap(F, State#st_cross_scuffle_elite.team_list),
    {noreply, State#st_cross_scuffle_elite{team_list = TeamList}};

handle_info(_Msg, State) ->
    {noreply, State}.

check_team_match([], _MbList) -> ok;
check_team_match([Mb | T], MbList) ->
    case lists:keymember(Mb#scuffle_elite_mb.pkey, #scuffle_elite_mb.pkey, MbList) of
        false ->
            check_team_match(T, MbList);
        true ->
            {false, Mb#scuffle_elite_mb.nickname}
    end.

%%匹配计算
match(MatchList, MbList, PlayList) ->
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
                    {ok, Pid} = cross_scuffle_elite_play:start(RedMbList, BlueMbList, 0),
                    {NewMatchList, NewMbList, [Pid | PlayList]}
            end
    end.

filter_match_list(MatchList, GroupList) ->
    F = fun(Key, L) -> lists:keydelete(Key, 1, L) end,
    lists:foldl(F, MatchList, GroupList).

filter_mb_list(MbList, GroupList) ->
    F = fun(Mb, {L1, L2}) ->
        case lists:member(Mb#scuffle_elite_mb.team_key, GroupList) of
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
        "127.0.0.1" -> 4;
        "120.92.144.246" -> 4;
        "123.207.118.228" -> 4;
        _ -> 4
    end.


cmd_match() ->
    F = fun(Id) -> {Id, util:rand(1, 3)} end,
    MatchList = lists:map(F, lists:seq(1, 15)),
    ?DEBUG("matchlist ~p~n", [MatchList]),
    Ret = match_group(MatchList, 4),
    Ret.

make_final_info(WarTeamList) ->
    F = fun(WarTeam, {Rank, List}) ->
        Info = #final_war{
            wtkey = WarTeam#war_team.wtkey,
            wtname = WarTeam#war_team.name,
            sn = WarTeam#war_team.sn,
            rank = Rank
        },
        {Rank + 1, [Info | List]}
    end,
    {_, List0} = lists:foldl(F, {1, []}, WarTeamList),
    List0.

final_match(State) ->
    FightNum = State#st_cross_scuffle_elite.next_fight_num,
    Cof0 =
        case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            false -> #fight_record{
                id = FightNum
            };
            FightRecord -> FightRecord
        end,
    Cof =
        case get_fight_player_by_fightnum(FightNum, State) of
            [] -> Cof0;
            [FinamWar1] -> Cof0#fight_record{final_war1 = FinamWar1};
            [FinamWar1, FinamWar2] ->
                Cof0#fight_record{
                    final_war1 = FinamWar1,
                    final_war2 = FinamWar2
                };
            _ -> Cof0
        end,
    FinalWar1 = Cof#fight_record.final_war1,
    FinalWar2 = Cof#fight_record.final_war2,
    PlayerList = scene_agent:get_scene_player(?SCENE_ID_CROSS_SCUFFLE_ELITE_READY),
    MbList1 = final_match_help(PlayerList, FinalWar1),
    MbList2 = final_match_help(PlayerList, FinalWar2),
    if
        MbList1 == [] andalso MbList2 == [] ->
            if
                FinalWar1#final_war.wtkey == 0 -> Pid = [],
                    Cof1 = [Cof#fight_record{win_key = FinalWar2#final_war.wtkey}],
                    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {update_fight_record, FightNum, FinalWar2#final_war.wtkey, FinalWar1#final_war.wtkey});
                FinalWar2#final_war.wtkey == 0 -> Pid = [],
                    Cof1 = [Cof#fight_record{win_key = FinalWar1#final_war.wtkey}],
                    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {update_fight_record, FightNum, FinalWar1#final_war.wtkey, FinalWar2#final_war.wtkey});
                true ->
                    %% 根据初赛排名
                    case lists:keyfind(FinalWar1#final_war.wtkey, #final_war.wtkey, State#st_cross_scuffle_elite.final_list) of
                        false ->
                            Cof1 = [Cof#fight_record{win_key = FinalWar2#final_war.wtkey}];
                        Final1 ->
                            case lists:keyfind(FinalWar2#final_war.wtkey, #final_war.wtkey, State#st_cross_scuffle_elite.final_list) of
                                false ->
                                    Cof1 = [Cof#fight_record{win_key = FinalWar1#final_war.wtkey}];
                                Final2 ->
                                    if
                                        Final1#final_war.rank < Final2#final_war.rank ->
                                            Cof1 = [Cof#fight_record{win_key = FinalWar1#final_war.wtkey}];
                                        true ->
                                            Cof1 = [Cof#fight_record{win_key = FinalWar2#final_war.wtkey}]
                                    end
                            end
                    end,
                    Pid = [],
                    ?CAST(cross_scuffle_elite_proc:get_server_pid(), {update_fight_record, FightNum, FinalWar1#final_war.wtkey, FinalWar2#final_war.wtkey})
            end;
        MbList1 == [] ->
            Cof1 = [Cof#fight_record{win_key = FinalWar2#final_war.wtkey}], Pid = [],
            ?CAST(cross_scuffle_elite_proc:get_server_pid(), {update_fight_record, FightNum, FinalWar2#final_war.wtkey, FinalWar1#final_war.wtkey});
        MbList2 == [] -> Cof1 = [Cof#fight_record{win_key = FinalWar1#final_war.wtkey}], Pid = [],
            ?CAST(cross_scuffle_elite_proc:get_server_pid(), {update_fight_record, FightNum, FinalWar1#final_war.wtkey, FinalWar2#final_war.wtkey});
        true ->
            {ok, Pid0} = cross_scuffle_elite_play:start(MbList1, MbList2, FightNum),
            Cof1 = [Cof],
            Pid = [Pid0]
    end,
%%     ?DEBUG("fight_record ~p~n", [State#st_cross_scuffle_elite.fight_record]),
    NewFightRecord =
        case lists:keytake(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            {value, _, List} ->
                Cof1 ++ List;
            false ->
                Cof1 ++ State#st_cross_scuffle_elite.fight_record
        end,
%%     ?DEBUG("NewFightRecord ~p~n", [NewFightRecord]),
    State#st_cross_scuffle_elite{next_fight_num = FightNum + 1,
        fight_record = NewFightRecord,
        play_list = Pid ++ State#st_cross_scuffle_elite.play_list}.

final_match1(State, FightNum) ->
    Cof0 =
        case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            false -> #fight_record{
                id = FightNum
            };
            FightRecord -> FightRecord
        end,
    Cof =
        case get_fight_player_by_fightnum(FightNum, State) of
            [] -> Cof0;
            [FinamWar1] -> Cof0#fight_record{final_war1 = FinamWar1};
            [FinamWar1, FinamWar2] ->
                Cof0#fight_record{
                    final_war1 = FinamWar1,
                    final_war2 = FinamWar2
                };
            _ -> Cof0
        end,
    NewFightRecord =
        case lists:keytake(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            {value, _, List} -> [Cof] ++ List;
            false -> [Cof] ++ State#st_cross_scuffle_elite.fight_record
        end,
    State#st_cross_scuffle_elite{
        fight_record = NewFightRecord
    }.

final_match2(State, FightNum) ->
    Cof0 =
        case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
            false ->
                #fight_record{
                    id = FightNum
                };
            FightRecord ->
                FightRecord
        end,
    case get_fight_player_by_fightnum(FightNum, State) of
        [] ->
            State;
        [_FinamWar1] -> State;
        [FinamWar1, FinamWar2] ->
            Cof = Cof0#fight_record{
                final_war1 = FinamWar1,
                final_war2 = FinamWar2
            },
            NewFightRecord =
                case lists:keytake(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
                    {value, _, List} -> [Cof] ++ List;
                    false -> [Cof] ++ State#st_cross_scuffle_elite.fight_record
                end,
            State#st_cross_scuffle_elite{
                fight_record = NewFightRecord
            };
        _ -> State
    end.


final_team(State) ->
    F = fun(FightNum, State0) ->
        final_match1(State0, FightNum)
    end,
    lists:foldl(F, State, lists:seq(1, 8)).

final_match_help(PlayerList, FinalWar) ->
    IsRecord = is_record(FinalWar, final_war),
    if
        IsRecord == false -> [];
        FinalWar#final_war.wtkey == 0 -> [];
        true ->
            KeyList = cross_scuffle_elite_war_team_ets:get_war_team_member_key_list(FinalWar#final_war.wtkey),
            F = fun(ScenePlayer) ->
                case lists:member(ScenePlayer#scene_player.key, KeyList) of
                    false -> [];
                    _ -> [make_mb(ScenePlayer, FinalWar#final_war.wtkey)]
                end
            end,
            lists:flatmap(F, PlayerList)
    end.


make_mb(ScenePlayer, TeamKey) ->
    #scuffle_elite_mb{
        node = ScenePlayer#scene_player.node,
        sn = config:get_server_num(),
        pkey = ScenePlayer#scene_player.key,
        nickname = ScenePlayer#scene_player.nickname,
        pid = ScenePlayer#scene_player.pid,
        career = ScenePlayer#scene_player.career,
        sex = ScenePlayer#scene_player.sex,
        avatar = ScenePlayer#scene_player.avatar,
%%         time = ScenePlayer#scene_player.cross_scuffle_elite#cross_scuffle_elite_info.count,
        team_key = TeamKey,
        team_name = ScenePlayer#scene_player.war_team_name,
        position = ScenePlayer#scene_player.war_team_position
    }.

%%构造下一场战斗结构数据
make_next_fight_record(State) ->
    #st_cross_scuffle_elite{
        next_fight_num = FightNum,
        fight_record = FightRecord
    } = State,
    FightNumList =
        case lists:keyfind(FightNum, #fight_record.id, FightRecord) of
            false -> [FightNum];
            _ -> []
        end,
    F = fun(FNum) ->
        Cof = #fight_record{
            id = FNum
        },
        catch case get_fight_player_by_fightnum(FNum, State) of
                  [] -> Cof;
                  [FinalWar1] -> Cof#fight_record{final_war1 = FinalWar1};
                  [FinalWar1, FinalWar2] ->
                      Cof#fight_record{
                          final_war1 = FinalWar1,
                          final_war2 = FinalWar2
                      };
                  _ -> Cof
              end
    end,
    CofList = lists:map(F, FightNumList),
    State#st_cross_scuffle_elite{
        fight_record = FightRecord ++ CofList
    }.

get_fight_player_by_fightnum(FightNum, State) ->
    case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
        false ->
            case FightNum of
                FightNum when FightNum >= 1 andalso FightNum =< 8 ->
                    lists:sublist(State#st_cross_scuffle_elite.final_list, 2 * FightNum - 1, 2);
                FightNum when FightNum >= 9 andalso FightNum =< 15 ->
                    case get_fight_player_by_fight_result((FightNum - 8) * 2 - 1, State) of
                        [] -> [];
                        Team1 ->
                            case get_fight_player_by_fight_result((FightNum - 8) * 2, State) of
                                [] -> [Team1];
                                Team2 -> [Team1, Team2]
                            end
                    end;
                _ -> []
            end;
        Cof ->
            #fight_record{
                final_war1 = FinamWar1,
                final_war2 = FinamWar2
            } = Cof,
            [FinamWar1, FinamWar2]
    end.

get_fight_player_by_fight_result(FightNum, State) ->
    case lists:keyfind(FightNum, #fight_record.id, State#st_cross_scuffle_elite.fight_record) of
        false -> [];
        Cof ->
            #fight_record{
                final_war1 = FinalWar1,
                final_war2 = FinalWar2,
                win_key = Win
            } = Cof,
            if
                Win == FinalWar1#final_war.wtkey ->
                    FinalWar1;
                Win == FinalWar2#final_war.wtkey ->
                    FinalWar2;
                true -> []
            end
    end.

get_index_circle(Num0) ->
    case Num0 of
        Num when Num >= 1 andalso Num =< 8 -> 16;
        Num when Num >= 9 andalso Num =< 12 -> 8;
        Num when Num >= 13 andalso Num =< 14 -> 4;
        15 -> 2;
        16 -> 1;
        _ -> 1
    end.

random_final_list(FinalList) ->
    H = lists:sublist(FinalList, 8),
    T = lists:sublist(FinalList, 9, 16),
    NewList = lists:zip(H, lists:reverse(T)),
    F = fun({Id1, Id2}) ->
        [Id1, Id2]
    end,
    lists:flatmap(F, util:list_shuffle(NewList)).

stage_notice(WinTeamKey, FightNum) ->
    case cross_scuffle_elite_war_team_ets:get_war_team(WinTeamKey) of
        false -> skip;
        WarTeam ->
            if
                FightNum == 15 -> skip;
                true ->
                    F = fun(Node) ->
                        center:apply(Node, notice_sys, add_notice, [cross_scuffle_elite_stage_notice, [WarTeam#war_team.sn, WarTeam#war_team.name, get_notice_id(FightNum)]])
                    end,
                    lists:foreach(F, center:get_nodes())
            end
    end,
    ok.

get_notice_id(FightNum) when FightNum =< 8 andalso FightNum >= 1 -> ?T("八强");
get_notice_id(FightNum) when FightNum =< 12 andalso FightNum >= 9 -> ?T("四强");
get_notice_id(FightNum) when FightNum =< 14 andalso FightNum >= 13 -> ?T("决赛");
get_notice_id(_) -> ?T("").


get_bet_id(FightNum) when FightNum =< 8 andalso FightNum >= 1 -> ?T("十六强");
get_bet_id(FightNum) when FightNum =< 12 andalso FightNum >= 9 -> ?T("八强");
get_bet_id(FightNum) when FightNum =< 14 andalso FightNum >= 13 -> ?T("四强");
get_bet_id(FightNum) when FightNum =< 15 andalso FightNum >= 13 -> ?T("决赛");
get_bet_id(_) -> ?T("").

get_desk_notice_id(FightNum) when FightNum =< 9 -> ?T("十六强");
get_desk_notice_id(FightNum) when FightNum =< 13 -> ?T("八强");
get_desk_notice_id(FightNum) when FightNum =< 15 -> ?T("四强");
get_desk_notice_id(FightNum) when FightNum =< 16 -> ?T("决赛");
get_desk_notice_id(_) -> ?T("").

sort_fight_record(FightRecordList) ->
    List = lists:reverse(lists:keysort(#fight_record.id, FightRecordList)),
    F = fun(FightRecord) ->
        if
            FightRecord#fight_record.win_key == FightRecord#fight_record.final_war1#final_war.wtkey ->
                [FightRecord#fight_record.final_war1#final_war.wtkey,
                    FightRecord#fight_record.final_war2#final_war.wtkey];
            true ->
                [FightRecord#fight_record.final_war2#final_war.wtkey,
                    FightRecord#fight_record.final_war1#final_war.wtkey]
        end
    end,
    List0 = lists:flatmap(F, List),
    util:list_filter_repeat(List0).

get_round(NextFightNum) when NextFightNum >= 1 andalso NextFightNum =< 8 -> 16;
get_round(NextFightNum) when NextFightNum >= 9 andalso NextFightNum =< 12 -> 8;
get_round(NextFightNum) when NextFightNum >= 13 andalso NextFightNum =< 14 -> 4;
get_round(NextFightNum) when NextFightNum == 15 -> 2;
get_round(NextFightNum) when NextFightNum >= 16 -> 1;
get_round(_) -> 0.

%% 发送投注奖励邮件
bet_back(FightNum, FightRecord) ->
    F = fun({Pkey, Wtkey, Id, Node}) ->
        if
            FightRecord#fight_record.win_key == 0 -> skip;
            Wtkey == FightRecord#fight_record.win_key ->
                Base = cross_scuffle_elite:get_bet_base(FightNum, Id),
                {Title0, Content0} = t_mail:mail_content(149),
                Round = get_bet_id(FightRecord#fight_record.id),
                WtName =
                    if
                        FightRecord#fight_record.final_war1#final_war.wtkey == Wtkey ->
                            FightRecord#fight_record.final_war1#final_war.wtname;
                        true -> FightRecord#fight_record.final_war2#final_war.wtname
                    end,
                Title = io_lib:format(Title0, [Round]),
                Content = io_lib:format(Content0, [Round, WtName]),
                center:apply(Node, mail, sys_send_mail, [[Pkey], Title, Content, [{Base#base_cross_scuffle_elite_bet.goods_id, util:floor(Base#base_cross_scuffle_elite_bet.num * 1.2)}]]);
            true ->
                skip
        end
    end,
    lists:foreach(F, FightRecord#fight_record.bet_list),
    ok.


refresh_desk(BaseData, FightNum) ->
    CopyList = scene_copy_proc:get_scene_copy_ids(?SCENE_ID_CROSS_SCUFFLE_ELITE_READY),
    Now = util:unixtime(),
    refresh_loop(BaseData#base_desk.desk_list, CopyList, Now, get_round_id(FightNum)).

refresh_loop([], _CopyList, _Now, _FightNum) ->
    ok;
refresh_loop([{Mid, X, Y} | T], CopyList, Now, FightNum) ->
    if
        FightNum == 4 ->%% 最后一轮时间增加5.5分钟
            [mon_agent:create_mon_cast([Mid, ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, X, Y, Copy, 1, [{life, ?WELFARE_DESK_LIFE_TIME + 330}, {show_time, Now + ?WELFARE_DESK_LIFE_TIME + 330}, {cross_scuff_elite_fight_num, FightNum}]]) || Copy <- CopyList];
        true ->
            [mon_agent:create_mon_cast([Mid, ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, X, Y, Copy, 1, [{life, ?WELFARE_DESK_LIFE_TIME}, {show_time, Now + ?WELFARE_DESK_LIFE_TIME}, {cross_scuff_elite_fight_num, FightNum}]]) || Copy <- CopyList]
    end,
%%     if
%%         FightNum == 4 ->%% 最后一轮时间增加5.5分钟
%%             [mon_agent:create_mon_cast([Mid, ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, X, Y, Copy, 1, [{life, 60 + 60}, {show_time, Now + 60 + 60}, {cross_scuff_elite_fight_num, FightNum}]]) || Copy <- CopyList];
%%         true ->
%%             [mon_agent:create_mon_cast([Mid, ?SCENE_ID_CROSS_SCUFFLE_ELITE_READY, X, Y, Copy, 1, [{life, 60}, {show_time, Now + 60}, {cross_scuff_elite_fight_num, FightNum}]]) || Copy <- CopyList]
%%     end,
    refresh_loop(T, CopyList, Now, FightNum).

get_round_id(NextFightNum) when NextFightNum =< 9 -> 1;
get_round_id(NextFightNum) when NextFightNum =< 13 -> 2;
get_round_id(NextFightNum) when NextFightNum =< 15 -> 3;
get_round_id(NextFightNum) when NextFightNum =< 16 -> 4;
get_round_id(_) -> 0.
