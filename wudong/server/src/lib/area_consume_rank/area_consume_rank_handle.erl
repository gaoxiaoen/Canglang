%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(area_consume_rank_handle).
-author("Administrator").
-include("activity.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    handle_call/3,
    handle_cast/2,
    handle_info/2
]).

handle_call(_Request, _From, State) ->
    ?DEBUG("udef msg ~p~n", [_Request]),
    {reply, ok, State}.

%%刷新排行榜
handle_info(refresh_rank, State) ->
    LogList = area_consume_rank_load:init(),
    case area_consume_rank:get_act() of
        [] ->
            RankList = State#st_area_consume_rank.rank_list;
        Base ->
            RankList = area_consume_rank_load:rank_list(LogList, Base)
    end,
    {noreply, State#st_area_consume_rank{log_list = LogList, rank_list = RankList}};

%%刷新排行榜
handle_info(refresh_rank_nodb, State) ->
    LogList = area_consume_rank_load:init(),
    case area_consume_rank:get_act() of
        [] ->
            RankList = State#st_area_consume_rank.rank_list;
        Base ->
            RankList = area_consume_rank_load:rank_list(LogList, Base)
    end,
    {noreply, State#st_area_consume_rank{rank_list = RankList}};

handle_info({end_reward, Base}, _State) ->
    if
        Base == [] -> skip;
        true ->
            LogList = area_consume_rank_load:init(),
            RankList = area_consume_rank_load:rank_list(LogList, Base),
            area_consume_rank:end_reward(RankList, Base),
            area_consume_rank_load:clean()
    end,
    {noreply, #st_area_consume_rank{}};

handle_info(test, State) ->
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

%% 消费更新
handle_cast({update_area_consume_rank, _Node, Sn, Pkey, PName, Value, Lv}, State) ->
    Now = util:unixtime(),
    LogList1 = update(State#st_area_consume_rank.log_list, Sn, Pkey, PName, Value, Now, Lv),
    GroupList = activity_area_group:get_group_list(data_area_consume_rank, area_consume_rank),
    Group = activity_area_group:get_sn_group(Sn, GroupList),
    case area_consume_rank:get_act() of
        [] -> RankList = State#st_area_consume_rank.rank_list;
        Base ->
            RankList = area_consume_rank_load:rank_list_by_group(LogList1, State#st_area_consume_rank.rank_list, Group, Base)
    end,
    {noreply, State#st_area_consume_rank{log_list = LogList1, rank_list = RankList}};


%% 服号更新
handle_cast({update_sn, Sn, Pkey}, State) ->
    #st_area_consume_rank{
        log_list = LogList
    } = State,
    case lists:keytake(Pkey, #area_consume_rank_log.pkey, LogList) of
        false -> NewLogList = LogList;
        {value, Log, T} ->
            NewLogList =
                if
                    Log#area_consume_rank_log.sn == Sn -> LogList;
                    true ->
                        area_consume_rank_load:replace(Log#area_consume_rank_log{sn = Sn}),
                        [Log#area_consume_rank_log{sn = Sn} | T]
                end
    end,
    {noreply, State#st_area_consume_rank{log_list = NewLogList}};

%% 查看消费榜
handle_cast({check_info, Node, Sn, Pkey, Sid}, State) ->
    #st_area_consume_rank{
        rank_list = RankList
    } = State,
    GroupList = activity_area_group:get_group_list(data_area_consume_rank, area_consume_rank),
    Group = activity_area_group:get_sn_group(Sn, GroupList),
    {Consume, Rank, List1} = get_info(Group, Pkey, RankList),
    LeaveTime = area_consume_rank:get_leave_time(),
    Reward = area_consume_rank:get_reward_list(),
    {ok, Bin} = pt_439:write(43931, {LeaveTime, Consume, Rank, List1, Reward}),
    server_send:send_to_sid(Node, Sid, Bin),
%%    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

make_list(List) ->
    F = fun(Base) ->
        [
            Base#area_consume_rank_log.rank,
            Base#area_consume_rank_log.pkey,
            Base#area_consume_rank_log.sn,
            Base#area_consume_rank_log.nickname,
            Base#area_consume_rank_log.consume_gold]
    end,
    lists:map(F, List).

update(LogList, Sn, Pkey, PName, Value, Now, Lv) ->
    case lists:keytake(Pkey, #area_consume_rank_log.pkey, LogList) of
        false ->
            NewLog = #area_consume_rank_log{
                sn = Sn,
                pkey = Pkey,
                consume_gold = Value,
                nickname = PName,
                change_time = Now,
                lv = Lv
            },
            area_consume_rank_load:replace(NewLog),
            [NewLog | LogList];
        {value, Log, T} ->
            NewLog = Log#area_consume_rank_log{sn = Sn, consume_gold = Log#area_consume_rank_log.consume_gold + Value, change_time = Now, lv = Lv},
            area_consume_rank_load:replace(NewLog),
            [NewLog | T]
    end.

get_info(Group, Pkey, List) ->
    List0 =
        case lists:keyfind(Group, 1, List) of
            false -> [];
            {_, L} -> L
        end,
    {Consume, Rank} =
        case lists:keyfind(Pkey, #area_consume_rank_log.pkey, List0) of
            false ->
                {0, 0};
            GetLog ->
                {GetLog#area_consume_rank_log.consume_gold, ?IF_ELSE(GetLog#area_consume_rank_log.consume_gold =< 0, 0, GetLog#area_consume_rank_log.rank)}
        end,
    List1 = lists:sublist(make_list(List0), ?AREA_CONSUME_RANK_LIMIT),
    {Consume, Rank, List1}.


