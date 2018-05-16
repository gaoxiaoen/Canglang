%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 六月 2016 19:02
%%%-------------------------------------------------------------------
-module(cross_elite_handle).
-author("hxming").

-include("common.hrl").
-include("cross_elite.hrl").
-include("scene.hrl").
-include("battle.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).



handle_call(_msg, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {reply, ok, State}.

%%查询活动图标状态
handle_cast({check_state, Node, Sid, Now}, State) ->
    if State#st_cross_elite.open_state == ?CROSS_ELITE_STATE_CLOSE -> skip;
        true ->
            {ok, Bin} = pt_580:write(58001, {State#st_cross_elite.open_state, max(0, State#st_cross_elite.time - Now)}),
            server_send:send_to_sid(Node, Sid, Bin)
%%            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%匹配玩家
handle_cast({check_match, Mb}, State) ->
    if State#st_cross_elite.open_state =/= ?CROSS_ELITE_STATE_START ->
        {ok, Bin} = pt_580:write(58003, {5}),
        server_send:send_to_sid(Mb#ce_mb.node, Mb#ce_mb.sid, Bin),
%%        center:apply(Mb#ce_mb.node, server_send, send_to_sid, [Mb#ce_mb.sid, Bin]),
        {noreply, State};
        true ->
            MbList =
                case lists:keytake(Mb#ce_mb.key, #ce_mb.key, State#st_cross_elite.mb_list) of
                    false ->
                        [Mb | State#st_cross_elite.mb_list];
                    {value, OldMb, T} ->
                        [Mb#ce_mb{old_lv = OldMb#ce_mb.old_lv, fight_times = OldMb#ce_mb.fight_times, win_times = OldMb#ce_mb.win_times} | T]
                end,
            Match = cross_elite:make_gamer(Mb),
            MatchList = [Match | lists:keydelete(Match#ce_vs.key, #ce_vs.key, State#st_cross_elite.match_list)],
            {ok, Bin} = pt_580:write(58003, {1}),
            server_send:send_to_sid(Mb#ce_mb.node, Mb#ce_mb.sid, Bin),
%%            center:apply(Mb#ce_mb.node, server_send, send_to_sid, [Mb#ce_mb.sid, Bin]),
            server_send:send_node_pid(Mb#ce_mb.node, Mb#ce_mb.pid, {match_state, ?MATCH_STATE_1V1}),
            {noreply, State#st_cross_elite{mb_list = MbList, match_list = MatchList}}
    end;

%%取消匹配
handle_cast({check_cancel, Node, Pkey, Sid}, State) ->
    {Ret, NewState} =
        case lists:keytake(Pkey, #ce_vs.key, State#st_cross_elite.match_list) of
            false ->
                {7, State};
            {value, _, L} ->
                {1, State#st_cross_elite{match_list = L}}
        end,
    {ok, Bin} = pt_580:write(58004, {Ret}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, NewState};

handle_cast({check_cancel_only, Pkey}, State) ->
    NewState =
        case lists:keytake(Pkey, #ce_vs.key, State#st_cross_elite.match_list) of
            false ->
                State;
            {value, _, L} ->
                State#st_cross_elite{match_list = L}
        end,
    {noreply, NewState};

%%玩家离线
handle_cast({check_quit, Pkey}, State) ->
    MbList =
        case lists:keytake(Pkey, #ce_mb.key, State#st_cross_elite.mb_list) of
            false ->
                State#st_cross_elite.mb_list;
            {value, Mb, L} ->
                [Mb#ce_mb{pid = none} | L]
        end,
    MatchList = lists:keydelete(Pkey, #ce_vs.key, State#st_cross_elite.match_list),
    case lists:keyfind(Pkey, 1, State#st_cross_elite.vs_list) of
        false -> skip;
        {_, Copy} ->
            Copy ! {logout, Pkey}
    end,
    {noreply, State#st_cross_elite{mb_list = MbList, match_list = MatchList}};

%%更新积分
handle_cast({upgrade_score, Pkey, Lv, Score, Ret}, State) ->
    MbList =
        case lists:keytake(Pkey, #ce_mb.key, State#st_cross_elite.mb_list) of
            false -> State#st_cross_elite.mb_list;
            {value, Mb, T} ->
                WinTimes = ?IF_ELSE(Ret == 1, Mb#ce_mb.win_times + 1, Mb#ce_mb.win_times),
                [Mb#ce_mb{lv = Lv, score = Score, fight_times = Mb#ce_mb.fight_times + 1, win_times = WinTimes} | T]
        end,
    VsList = lists:keydelete(Pkey, 1, State#st_cross_elite.vs_list),
    {noreply, State#st_cross_elite{mb_list = MbList, vs_list = VsList}};

%%排行榜信息
handle_cast({check_rank, Node, Pkey, Sid, Page}, State) ->
    F1 = fun(Mb, {Rank, L}) ->
        {Rank + 1, L ++ [Mb#ce_mb{rank = Rank}]}
         end,
    {_, MbList} = lists:foldl(F1, {1, []}, cross_elite:sort_mb_list(State#st_cross_elite.mb_list)),
    Len = length(MbList),
    MaxPage = ?IF_ELSE(Len >= 100, 10, util:ceil(Len / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    F = fun(Mb) ->
        [Mb#ce_mb.rank, Mb#ce_mb.sn, Mb#ce_mb.name, Mb#ce_mb.lv, Mb#ce_mb.score]
        end,
    Data = lists:map(F, lists:sublist(MbList, NowPage * 10 - 9, 10)),
    {MyRank, MyLv, MyScore} =
        case lists:keyfind(Pkey, #ce_mb.key, MbList) of
            false -> {0, 0, 0};
            Mb1 ->
                {Mb1#ce_mb.rank, Mb1#ce_mb.lv, Mb1#ce_mb.score}
        end,
    {ok, Bin} = pt_580:write(58005, {NowPage, MaxPage, MyRank, MyLv, MyScore, Data}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast(_msg, State) ->
    ?DEBUG("udef state ~p msg ~p~n", [State#st_cross_elite.open_state, _msg]),
    {noreply, State}.


handle_info({reset, Now}, State) ->
    util:cancel_ref([State#st_cross_elite.ref]),
    NewState = cross_elite_proc:set_timer(State, Now),
    {noreply, NewState};


%%准备
handle_info({ready, ReadyTime, LastTime}, State) when State#st_cross_elite.open_state == ?CROSS_ELITE_STATE_CLOSE ->
    ?DEBUG("cross elite ready ~p~n", [ReadyTime]),
    util:cancel_ref([State#st_cross_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_580:write(58001, {?CROSS_ELITE_STATE_READY, ReadyTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_elite_ready, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, LastTime}),
    NewState = State#st_cross_elite{open_state = ?CROSS_ELITE_STATE_READY, time = Now + ReadyTime, ref = Ref},
    {noreply, NewState};

%%开始
handle_info({start, LastTime}, State) when State#st_cross_elite.open_state /= ?CROSS_ELITE_STATE_START ->
    util:cancel_ref([State#st_cross_elite.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_580:write(58001, {?CROSS_ELITE_STATE_START, LastTime}),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
        center:apply(Node, notice_sys, add_notice, [cross_elite_start, []])
        end,
    lists:foreach(F, center:get_nodes()),
    Ref = erlang:send_after(LastTime * 1000, self(), close),
    Ref1 = erlang:send_after(3 * 1000, self(), match_timer),
    NewState = State#st_cross_elite{
        open_state = ?CROSS_ELITE_STATE_START,
        time = Now + LastTime,
        ref = Ref,
        vs_ref = Ref1,
        is_finish = 0,
        mb_list = [],
        vs_list = [],
        match_list = [],
        log = []
    },
    ?DEBUG("cross elite start ~n"),
    %%玩法找回
    findback_src:update_act_time(33, Now),
    {noreply, NewState};

%%关闭
handle_info(close, State) ->
    ?DEBUG("cross elite close ~n"),
    util:cancel_ref([State#st_cross_elite.ref, State#st_cross_elite.vs_ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_580:write(58001, {?CROSS_ELITE_STATE_CLOSE, 0}),
    %%取消匹配
    cancel_match(State#st_cross_elite.match_list),
    %%关闭正在挑战的场次
    stop_vs(State#st_cross_elite.vs_list),
    F = fun(Node) ->
        center:apply(Node, server_send, send_to_all, [Bin]),
%%         center:apply(Node, notice_sys, add_notice, [cross_elite_close, []]),
        center:apply(Node, cross_elite, clean_vs_data, [])
        end,
    lists:foreach(F, center:get_nodes()),
    State1 = cross_elite_proc:set_timer(State, Now),
    NewState = State1#st_cross_elite{is_finish = 1, vs_list = [], match_list = [], log = []},
    Ref = erlang:send_after(3000, self(), finish_reward),
    put(finish_reward, Ref),
    {noreply, NewState};

%%结算
handle_info(finish_reward, State) ->
    misc:cancel_timer(finish_reward),
    case catch finish_reward(State#st_cross_elite.mb_list) of
        ok ->
            {noreply, State};
        _Err ->
            ?ERR("finish_reward err ~p~n", [_Err]),
            {noreply, State}
    end;

%%循环匹配挑战玩家
handle_info(match_timer, State) when State#st_cross_elite.open_state == ?CROSS_ELITE_STATE_START ->
    util:cancel_ref([State#st_cross_elite.vs_ref]),
    {MatchList, VsList, Log} = match(State#st_cross_elite.match_list, State#st_cross_elite.log),
    Ref = erlang:send_after(3 * 1000, self(), match_timer),
    NewVsList = State#st_cross_elite.vs_list ++ VsList,
    {noreply, State#st_cross_elite{vs_ref = Ref, match_list = MatchList, vs_list = NewVsList, log = Log}};

%%清除数据--譬如踢人
handle_info(clean, State) ->
    scene_cross:send_out_cross(?SCENE_TYPE_CROSS_ELITE),
    {noreply, State};


%%初始化竞技场机器人
handle_info(init_robot, State) ->
    cross_elite:init_robot(),
    {noreply, State};

handle_info(cmd_read_timer, State) ->
    io:format("state ~p ref ~p time ~p~n", [State#st_cross_elite.open_state, State#st_cross_elite.ref, erlang:read_timer(State#st_cross_elite.ref)]),
    {noreply, State};

handle_info(_msg, State) ->
    ?DEBUG("udef msg ~p~n", [_msg]),
    {noreply, State}.

%%循环匹配玩家
match(MatchList, Log) ->
    Now = util:unixtime(),
    SortList = lists:keysort(#ce_vs.time, MatchList),
    %%超时处理
    {MatchList1, VsList2} = match_for_timeout(SortList, [], Now),
    ScorePer = 10,
    F = fun(Match, L) ->
        %%按匹配次数排序,扩大积分匹配范围
        Loop = Match#ce_vs.loop + 1,
        MinScore = Match#ce_vs.score - ScorePer * Loop,
        MaxScore = Match#ce_vs.score + ScorePer * Loop,
        L ++ [Match#ce_vs{loop = Loop, score_min = MinScore, score_max = MaxScore}]
        end,
    MatchList3 = lists:foldr(F, [], lists:keysort(#ce_vs.loop, MatchList1)),
    UseLog = ?IF_ELSE(length(MatchList3) > 20, 1, 0),
    {MatchList4, VsList4, NewLog} = match_for_score(MatchList3, VsList2, Log, UseLog, []),
    {MatchList4, VsList4, NewLog}.

%%匹配超时
match_for_timeout([], VsList, _Now) -> {[], VsList};
match_for_timeout([Match | T], VsList, Now) ->
    if Now - Match#ce_vs.time >= ?CROSS_ELITE_MATCH_TIMEOUT ->
        case T of
            [] ->
                case match_robot(Match#ce_vs.key, Match#ce_vs.cbp) of
                    false ->
                        {[Match | T], VsList};
                    Match1 ->
                        NewVsList = start_vs([Match, Match1]),
                        match_for_timeout(T, VsList ++ NewVsList, Now)
                end;
            _ ->
                Match1 = lists:last(lists:keysort(#ce_vs.score, T)),
                T3 = lists:keydelete(Match1#ce_vs.key, #ce_vs.key, T),
                NewVsList = start_vs([Match, Match1]),
                match_for_timeout(T3, VsList ++ NewVsList, Now)
        end;
        true ->
            {[Match | T], VsList}
    end.


%%战力匹配
match_for_score([], VsList, Log, _UseLog, NoMatchList) -> {NoMatchList, VsList, Log};
match_for_score([Match | T], VsList, Log, UseLog, NoMatchList) ->
    case match_score(T, Match#ce_vs.key, Log, UseLog, Match#ce_vs.score_min, Match#ce_vs.score_max) of
        [] ->
            match_for_score(T, VsList, Log, UseLog, [Match | NoMatchList]);
        Match1 ->
            T2 = lists:keydelete(Match1#ce_vs.key, #ce_vs.key, T),
            NewVsList = start_vs([Match, Match1]),
            NewLog = refresh_log(Log, Match, Match1),
            match_for_score(T2, VsList ++ NewVsList, NewLog, UseLog, NoMatchList)
    end.

refresh_log(Log, Match, Match1) ->
    Log1 = [{Match#ce_vs.key, Match1#ce_vs.key} | lists:keydelete(Match#ce_vs.key, 1, Log)],
    [{Match1#ce_vs.key, Match#ce_vs.key} | lists:keydelete(Match1#ce_vs.key, 1, Log1)].

match_score([], _, _Log, _UseLog, _MinScore, _MaxScore) -> [];
match_score([Match | T], Pkey, Log, UseLog, MinScore, MaxScore) ->
    case (Match#ce_vs.score_min >= MinScore andalso Match#ce_vs.score_min =< MaxScore)
        orelse (Match#ce_vs.score_max >= MinScore andalso Match#ce_vs.score_max =< MaxScore) of
        true ->
            case check_back_to_back(Log, Pkey, Match, UseLog) of
                false ->
                    Match;
                true ->
                    match_score(T, Pkey, Log, UseLog, MinScore, MaxScore)
            end;
        false ->
            match_score(T, Pkey, Log, UseLog, MinScore, MaxScore)
    end.

%%检查是否背靠背挑战
check_back_to_back(_Log, _Pkey, _Match, UseLog) when UseLog == 0 -> true;
check_back_to_back(Log, Pkey, Match, _UseLog) ->
    case lists:keytake(Pkey, 1, Log) of
        false -> false;
        {value, {_, Key}, _} ->
            Match#ce_vs.key == Key
    end.

match_robot(Pkey, Cbp) ->
    CbpMin = Cbp / 2,
    Dict = case get(robot) of
               undefined -> dict:new();
               RobotDict -> RobotDict
           end,
    F = fun(Key, Val) -> Key /= Pkey andalso CbpMin =< Val andalso Val =< Cbp
        end,
    DictFilter = dict:filter(F, Dict),
    case dict:to_list(DictFilter) of
        [] -> false;
        List ->
            {Key, _} = util:list_rand(List),
            case cache:get({shadow, Key}) of
                [] ->
                    case cross_arena_init:init_arena_shadow(Key) of
                        false -> false;
                        Robot ->
                            cache:set({shadow, Key}, Robot, ?ONE_HOUR_SECONDS),
                            cross_elite:make_gamer_sys(Robot)
                    end;
                Robot ->
                    cross_elite:make_gamer_sys(Robot)
            end
    end.


%%开启比赛进程
start_vs(MatchList) ->
    {ok, Pid} = cross_elite_vs:start(MatchList),
    [{Match#ce_vs.key, Pid} || Match <- MatchList].

%%活动结束,通知关闭
stop_vs(VsList) ->
    PidList = util:list_filter_repeat([Pid || {_, Pid} <- VsList]),
    lists:foreach(fun(Pid) -> cross_elite_vs:stop(Pid) end, PidList).

%%通知关闭匹配
cancel_match(MatchList) ->
    {ok, Bin} = pt_580:write(58004, {1}),
    F = fun(Match) ->
        server_send:send_to_sid(Match#ce_vs.node, Match#ce_vs.sid, Bin)
%%        center:apply(Match#ce_vs.node, server_send, send_to_sid, [Match#ce_vs.sid, Bin])
        end,
    lists:foreach(F, MatchList),
    ok.

%%结算
finish_reward(MbList) ->
    F1 = fun(Mb, Rank) ->
        center:apply(Mb#ce_mb.node, cross_elite, reward_msg, [Mb#ce_mb.key, Rank, Mb#ce_mb.lv, Mb#ce_mb.old_lv, Mb#ce_mb.fight_times, Mb#ce_mb.win_times, Mb#ce_mb.score]),
        Rank + 1
         end,
    lists:foldl(F1, 1, cross_elite:sort_mb_list(MbList)),
    ok.
