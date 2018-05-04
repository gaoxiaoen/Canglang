%%----------------------------------------------------
%% 竞技场荣誉排名管理进程
%%
%% @author mobin
%%----------------------------------------------------
-module(compete_rank).
-behaviour(gen_server).

%% api funs
-export([
        start_link/0
        ,start_activity/0
        ,stop_activity/0
        ,update_honor/2
        ,get_ranks/1
        ,add_test_data/0
    ]).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("compete.hrl").

%% record
-record(state, {
        started,
        is_send_reward = false
    }).

-define(update_rank_timer, 10 * 1000).
-define(rank_num, 30).

-define(seconds_of_day, 86400). 

-define(dets_file, "../var/compete_rank.dets").

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_activity() ->
    gen_server:cast(?MODULE, start_activity).

stop_activity() ->
    gen_server:cast(?MODULE, stop_activity).

update_honor(SignupRole, Honor) ->
    gen_server:cast(?MODULE, {update_honor, SignupRole, Honor}).

get_ranks(ConnPid) ->
    gen_server:cast(?MODULE, {get_ranks, ConnPid}).

add_test_data() ->
    List = lists:seq(1, 30),
    lists:foreach(fun(Rank) ->
                ets:insert(compete_rank, #compete_rank{id = {Rank, <<"xysj_10042">>}, name = <<"大毛毛">>, total_power = Rank, honor = Rank})
        end, List).
    
%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true), 

    ets:new(compete_rank, [set, named_table, public, {keypos, #compete_rank.id}]),
    put(rank_list, []),

    Today = util:unixtime(today),
    Tomorrow = Today + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), clean_up),

    %%固定时间发放奖励，要比最后一次活动结束迟一点
    RewardTime = Today + 20 * 3600 + 1800 + 1,
    LeftTime = RewardTime - Now,
    LeftTime2 = case LeftTime =< 0 of
        true ->
            LeftTime + ?seconds_of_day;
        false ->
            LeftTime
    end,
    erlang:send_after(LeftTime2 * 1000, self(), send_reward),

    case filelib:last_modified(?dets_file) of
        0 ->
            ignore;
        LastModified ->
            dets:open_file(?MODULE, [{file, ?dets_file}, {keypos, #compete_rank.id}]), 
            dets:to_ets(?MODULE, compete_rank),
            dets:close(?MODULE),
            file:delete(?dets_file),
            
            Size = ets:info(compete_rank, size),
            ?INFO("导入竞技场排名数据~w条", [Size]),

            ModifiedTime = util:datetime_to_seconds(LastModified),
            if
                ModifiedTime < Today  -> 
                    %%昨天的数据，立即发奖励
                    resend_reward(LastModified),
                    clean_up();
                LeftTime =< 0 ->
                    %%错过今天发放时间，立即发
                    resend_reward(LastModified);
                true -> 
                    ignore
            end
    end,
    
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    {reply, ok, State}.


%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(start_activity, State) ->
    erlang:send_after(?update_rank_timer, self(), update_rank),
    {noreply, State#state{started = true}};

handle_cast(stop_activity, State) ->
    {noreply, State#state{started = false}};

handle_cast({update_honor, #sign_up_role{id = Rid, name = Name, total_power = TotalPower}, Honor}, State) ->
    %%记录荣誉值到ets
    case ets:lookup(compete_rank, Rid) of
        [CompeteRank = #compete_rank{honor = OldHonor}] ->
            ets:insert(compete_rank, CompeteRank#compete_rank{honor = OldHonor + Honor});
        _ -> %% 今天还没打过
            ets:insert(compete_rank, #compete_rank{id = Rid, name = Name, total_power = TotalPower, honor = Honor})
    end,
    {noreply, State};

handle_cast({get_ranks, ConnPid}, State) ->
    case get(rank_list) of
        Ranks when is_list(Ranks) ->
            sys_conn:pack_send(ConnPid, 16225, {Ranks});
        _ ->
            ignore
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
handle_info(update_rank, State = #state{started = true}) ->
    update_rank(), 
    erlang:send_after(?update_rank_timer, self(), update_rank),
    {noreply, State};

handle_info(send_reward, State) ->
    Size = ets:info(compete_rank, size),
    ?INFO("竞技场的参与人数:~w", [Size]),
    send_reward(),
    {noreply, State#state{is_send_reward = true}};

handle_info(clean_up, State = #state{}) ->
    clean_up(), 
    Tomorrow = util:unixtime(today) + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), clean_up),
    {noreply, State#state{is_send_reward = false}}; 

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State = #state{is_send_reward = IsSendReward}) ->
    ?DEBUG("compete_rank close[~w]", [_Reason]),
    case IsSendReward of
        true ->
            ignore;
        _ ->
            dets:open_file(?MODULE, [{file, ?dets_file}, {keypos, #compete_rank.id}]), 
            ets:to_dets(compete_rank, ?MODULE),
            dets:close(?MODULE)
    end,
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
resend_reward(ModifiedTime) ->
    ?INFO("补发竞技场排名奖励，上次停服时间[~w]", [ModifiedTime]),
    update_rank(),
    send_reward().

update_rank() ->
    CompeteRanks = ets:tab2list(compete_rank),
    %%排序
    SortFun = fun(#compete_rank{total_power = TotalPower1, honor = Honor1}, #compete_rank{total_power = TotalPower2, honor = Honor2}) ->
            if
                Honor1 > Honor2 ->
                    true;
                Honor1 =:= Honor2 ->
                    TotalPower1 < TotalPower2;
                true ->
                    false
            end
    end,
    CompeteRanks2 = lists:sort(SortFun, CompeteRanks),
    CompeteRanks3 = lists:sublist(CompeteRanks2, ?rank_num),
    {CompeteRanks4, _} = lists:mapfoldl(fun(CompeteRank = #compete_rank{last_rank = LastRank}, Rank) ->
                Trend = if
                    Rank < LastRank ->
                        ?compete_rank_up;
                    Rank =:= LastRank ->
                        ?compete_rank_normal;
                    true ->
                        ?compete_rank_down
                end,
                %%回写上次排名
                ets:insert(compete_rank, CompeteRank#compete_rank{last_rank = Rank}),

                {CompeteRank#compete_rank{rank = Rank, trend = Trend}, Rank + 1}
        end, 1, CompeteRanks3),
    put(rank_list, CompeteRanks4).

send_reward() ->
    %%发放排名奖励
    case get(rank_list) of
        Ranks when is_list(Ranks) ->
            lists:foreach(fun(#compete_rank{id = Rid, rank = Rank}) ->
                        AwardId = if
                            Rank =:= 1 ->
                                109001;
                            Rank =:= 2 ->
                                109002;
                            Rank =:= 3 ->
                                109003;
                            Rank =< 10 ->
                                109004;
                            Rank =< 20 ->
                                109005;
                            true ->
                                109006
                        end,
                        award:send(Rid, AwardId)
                end, Ranks);
        _ ->
            ignore
    end.

clean_up() ->
    %%清除排名和compete_rank
    ets:delete_all_objects(compete_rank),
    put(rank_list, []).

