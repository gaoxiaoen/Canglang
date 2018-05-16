%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 六月 2016 10:36
%%%-------------------------------------------------------------------
-module(cross_eliminate_handle).
-author("hxming").
-include("common.hrl").
-include("cross_eliminate.hrl").
-include("server.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%排行榜
handle_cast({check_rank, Node, Pkey, Sid, Page}, State) ->
    RankList = State#st_eliminate.rank_list,
    Len = length(RankList),
    MaxPage = ?IF_ELSE(Len >= ?CROSS_ELIMINATE_MAX_RANK, 5, util:ceil(Len / 10)),
    NowPage = ?IF_ELSE(Page =< 0 orelse Page > MaxPage, 1, Page),
    RankList1 =
        lists:sublist(RankList, NowPage * 10 - 9, 10),
    F = fun(Log) ->
        [Log#eliminate_log.sn, Log#eliminate_log.nickname, Log#eliminate_log.wins, Log#eliminate_log.rank] end,
    Data = lists:map(F, RankList1),
    {MyRank, MyWins} =
        case lists:keyfind(Pkey, #eliminate_log.pkey, RankList) of
            false -> {0, 0};
            MyLog -> {MyLog#eliminate_log.rank, MyLog#eliminate_log.wins}
        end,
    LastRank =
        case lists:keyfind(Pkey, #elimination_reward.pkey, State#st_eliminate.reward_list) of
            false -> 0;
            Reward -> Reward#elimination_reward.rank
        end,
    {ok, Bin} = pt_590:write(59001, {NowPage, MaxPage, MyRank, MyWins, LastRank, Data}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({get_last_week_reward, Node, Key, Pid}, State) ->
    RewardList =
        case lists:keytake(Key, #elimination_reward.pkey, State#st_eliminate.reward_list) of
            false ->
                {ok, Bin} = pt_590:write(59016, {8, []}),
                center:apply(Node, server_send, send_to_pid, [Pid, Bin]),
                State#st_eliminate.reward_list;
            {value, Reward, T} ->
                cross_eliminate_load:del_reward(Key),
                case data_cross_eliminate_reward:get(Reward#elimination_reward.rank) of
                    [] ->
                        {ok, Bin} = pt_590:write(59016, {8, []}),
                        center:apply(Node, server_send, send_to_pid, [Pid, Bin]);
                    GoodsList ->
                        server_send:send_node_pid(Node, Pid, {eliminate_week_reward, tuple_to_list(GoodsList)}),
                        T
                end
        end,
    {noreply, State#st_eliminate{reward_list = RewardList}};


%%匹配玩家
handle_cast({check_match, Mb}, State) ->
    MatchList =
        case lists:keytake(Mb#eliminate_mb.pkey, #eliminate_mb.pkey, State#st_eliminate.match_list) of
            false ->
                [Mb | State#st_eliminate.match_list];
            {value, _, T} ->
                [Mb | T]
        end,
    {ok, Bin} = pt_590:write(59002, {1}),
    server_send:send_to_sid(Mb#eliminate_mb.node,Mb#eliminate_mb.sid,Bin),
%%    center:apply(Mb#eliminate_mb.node, server_send, send_to_sid, [Mb#eliminate_mb.sid, Bin]),
    server_send:send_node_pid(Mb#eliminate_mb.node, Mb#eliminate_mb.pid, {match_state, ?MATCH_STATE_ELIMINATE}),
    %%匹配开始
    {NewMatchList, PidList} = match_eliminate(MatchList, State#st_eliminate.log_list),
    {noreply, State#st_eliminate{match_list = NewMatchList, pid_list = PidList}};

%%取消匹配
handle_cast({check_cancel, Node, Pkey, Sid}, State) ->
    MatchList = lists:keydelete(Pkey, #eliminate_mb.pkey, State#st_eliminate.match_list),
    {ok, Bin} = pt_590:write(59003, {1}),
    server_send:send_to_sid(Node,Sid,Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State#st_eliminate{match_list = MatchList}};

handle_cast({check_cancel_only, Pkey}, State) ->
    MatchList = lists:keydelete(Pkey, #eliminate_mb.pkey, State#st_eliminate.match_list),
    {noreply, State#st_eliminate{match_list = MatchList}};

%%玩家掉线
handle_cast({check_logout, Key}, State) ->
    MatchList = lists:keydelete(Key, #eliminate_mb.pkey, State#st_eliminate.match_list),
    PidList =
        case lists:keytake(Key, 1, State#st_eliminate.pid_list) of
            false -> State#st_eliminate.pid_list;
            {value, {_, Pid}, T} ->
                Pid ! {logout, Key},
                T
        end,
    {noreply, State#st_eliminate{match_list = MatchList, pid_list = PidList}};

%%回应邀请
handle_cast({check_respond, Mb, Key}, State) ->
    {Ret, NewState} =
        case lists:keytake(Key, #eliminate_mb.pkey, State#st_eliminate.match_list) of
            false ->
                {4, State};
            {value, Friend, T} ->
                MatchList = lists:keydelete(Mb#eliminate_mb.pkey, #eliminate_mb.pkey, T),
                PidList = start_eliminate([Mb, Friend], State#st_eliminate.pid_list),
                {1, State#st_eliminate{match_list = MatchList, pid_list = PidList}}
        end,
    {ok, Bin} = pt_590:write(59006, {Ret}),
    server_send:send_to_sid(Mb#eliminate_mb.node,Mb#eliminate_mb.sid,Bin),
%%    center:apply(Mb#eliminate_mb.node, server_send, send_to_sid, [Mb#eliminate_mb.sid, Bin]),
    {noreply, NewState};

handle_cast(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

handle_info(check_timeout, State) ->
    util:cancel_ref([State#st_eliminate.ref]),
    Ref = erlang:send_after(?CROSS_ELIMINATE_MATCH_TIMEOUT * 1000, self(), check_timeout),
    Now = util:unixtime(),
    F = fun(Mb, {L, L1}) ->
        if Now >= Mb#eliminate_mb.time ->
            Mb1 = cross_eliminate:make_sys_mb(Mb#eliminate_mb.cbp),
            {L, start_eliminate([Mb, Mb1], L1)};
            true ->
                {[Mb | L], L1}
        end
        end,
    {MatchList, PidList} = lists:foldl(F, {[], State#st_eliminate.pid_list}, State#st_eliminate.match_list),
    {noreply, State#st_eliminate{ref = Ref, match_list = MatchList, pid_list = PidList}};

%%匹配计算
handle_info(match, State) ->
    {MatchList, PidList} = match_eliminate(State#st_eliminate.match_list, State#st_eliminate.log_list),
    {noreply, State#st_eliminate{match_list = MatchList, pid_list = PidList}};


%%play结果
handle_info({play_ret, Data}, State) ->
    F = fun(Log, {PidList, LogList}) ->
        {lists:keydelete(Log#eliminate_log.pkey, 1, PidList), cross_eliminate_load:update(Log, LogList)}
        end,
    {NewPidList, NewLogList} = lists:foldl(F, {State#st_eliminate.pid_list, State#st_eliminate.log_list}, Data),

    {noreply, State#st_eliminate{pid_list = NewPidList, log_list = NewLogList}};

%%周结算
handle_info(week_reward, State) ->
    LogList = cross_eliminate_load:init(),
    RankList = cross_eliminate_load:rank_list(LogList),
    cross_eliminate_load:clean(),
    RewardList = cross_eliminate:week_reward(RankList),
    {noreply, State#st_eliminate{log_list = [], rank_list = [], reward_list = RewardList}};

%%刷新排行榜
handle_info(refresh_rank, State) ->
    LogList = cross_eliminate_load:init(),
    RankList = cross_eliminate_load:rank_list(LogList),
    {noreply, State#st_eliminate{log_list = LogList, rank_list = RankList}};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

%%匹配消消乐
match_eliminate(MatchList, PidList) ->
    Now = util:unixtime(),
    FilterList = [Mb || Mb <- MatchList, Mb#eliminate_mb.rela_time =< Now],
    case length(FilterList) >= 2 of
        false -> {MatchList, PidList};
        true ->
            [Mb1, Mb2 | _T] = FilterList,
            NewPidList = start_eliminate([Mb1, Mb2], PidList),
            MatchList1 = lists:delete(Mb1, MatchList),
            MatchList2 = lists:delete(Mb2, MatchList1),
            match_eliminate(MatchList2, NewPidList)
    end.


%%开启消消乐
start_eliminate([Mb1, Mb2], PidList) ->
    {ok, Pid} = cross_eliminate_play:start([Mb1, Mb2]),
    F = fun(Mb) ->
        ?IF_ELSE(Mb#eliminate_mb.type == ?CROSS_ELIMINATE_MB_TYPE_PLAYER, [{Mb#eliminate_mb.pkey, Pid}], [])
        end,
    lists:flatmap(F, [Mb1, Mb2]) ++ PidList.