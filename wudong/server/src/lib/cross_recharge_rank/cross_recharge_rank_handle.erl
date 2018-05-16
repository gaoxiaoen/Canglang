%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(cross_recharge_rank_handle).
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
    LogList = cross_recharge_rank_load:init(),
    case cross_recharge_rank:get_act() of
        [] ->
            RankList = State#st_cross_recharge_rank.rank_list;
        Base ->
            RankList = cross_recharge_rank_load:rank_list(LogList, Base)
    end,
    {noreply, State#st_cross_recharge_rank{log_list = LogList, rank_list = RankList}};

%%刷新排行榜
handle_info(refresh_rank_nodb, State) ->
    LogList = cross_recharge_rank_load:init(),
    case cross_recharge_rank:get_act() of
        [] ->
            RankList = State#st_cross_recharge_rank.rank_list;
        Base ->
            RankList = cross_recharge_rank_load:rank_list(LogList, Base)
    end,
    {noreply, State#st_cross_recharge_rank{rank_list = RankList}};

handle_info({end_reward, Base}, _State) ->
    if
        Base == [] -> skip;
        true ->
            LogList = cross_recharge_rank_load:init(),
            RankList = cross_recharge_rank_load:rank_list(LogList, Base),
            %% cross_flower_load:clean(),
            cross_recharge_rank:end_reward(RankList, Base),
            cross_recharge_rank_load:clean()
    end,
    {noreply, #st_cross_recharge_rank{}};

handle_info(test, State) ->
    ?DEBUG("State State ~p~n", [State]),
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

%% 充值更新
handle_cast({update_cross_recharge_rank, _Node, Sn, Pkey, PName, Value, Lv}, State) ->
    Now = util:unixtime(),
    LogList1 = update(State#st_cross_recharge_rank.log_list, Sn, Pkey, PName, Value, Now, Lv),
    %%刷新分组排行
    %% Group = cross_recharge_rank_load:get_sn_group(Sn),
    %% RankGiveList = cross_recharge_rank_load:rank_list_by_group(LogList1, State#st_cross_recharge_rank.rank_list, Group),
    {noreply, State#st_cross_recharge_rank{log_list = LogList1}};

%% 查看充值榜
handle_cast({check_info, Node, _Sn, Pkey, Sid}, State) ->
    #st_cross_recharge_rank{
        rank_list = RankList
    } = State,
    Group = 0,
    {Recharge, Rank, List1} = get_info(Group, Pkey, RankList),
    LeaveTime = cross_recharge_rank:get_leave_time(),
    Reward = cross_recharge_rank:get_reward_list(),
    {ok, Bin} = pt_432:write(43286, {LeaveTime, Recharge, Rank, List1, Reward}),
    server_send:send_to_sid(Node, Sid, Bin),
    {noreply, State};

handle_cast(_Msg, State) ->
    ?DEBUG("udef msg ~p~n", [_Msg]),
    {noreply, State}.

make_list(List) ->
    F = fun(Base) ->
        [
            Base#cross_recharge_rank_log.rank,
            Base#cross_recharge_rank_log.pkey,
            Base#cross_recharge_rank_log.sn,
            Base#cross_recharge_rank_log.nickname,
            Base#cross_recharge_rank_log.recharge_gold]
    end,
    lists:map(F, List).

update(LogList, Sn, Pkey, PName, Value, Now, Lv) ->
    case lists:keytake(Pkey, #cross_recharge_rank_log.pkey, LogList) of
        false ->
            NewLog = #cross_recharge_rank_log{
                sn = Sn,
                pkey = Pkey,
                recharge_gold = Value,
                nickname = PName,
                lv = Lv,
                change_time = Now
            },
            cross_recharge_rank_load:replace(NewLog),
            [NewLog | LogList];
        {value, Log, T} ->
            NewLog = Log#cross_recharge_rank_log{sn = Sn, recharge_gold = Log#cross_recharge_rank_log.recharge_gold + Value, change_time = Now, lv = Lv},
            cross_recharge_rank_load:replace(NewLog),
            [NewLog | T]
    end.

get_info(Group, Pkey, List) ->
    List0 =
        case lists:keyfind(Group, 1, List) of
            false -> [];
            {_, L} -> L
        end,
    {Recharge, Rank} =
        case lists:keyfind(Pkey, #cross_recharge_rank_log.pkey, List0) of
            false ->
                {0, 0};
            GetLog ->
                {GetLog#cross_recharge_rank_log.recharge_gold, ?IF_ELSE(GetLog#cross_recharge_rank_log.recharge_gold =< 0, 0, GetLog#cross_recharge_rank_log.rank)}
        end,
    List1 = lists:sublist(make_list(List0), ?CROSS_RECHARGE_RANK_LIMIT),
    {Recharge, Rank, List1}.


