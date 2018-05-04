%% -------------------------------------------------------------------
%% Description : 
%% @author  : abu
%% @end
%% -------------------------------------------------------------------
-module(lottery_camp).

-behaviour(gen_server).

%% export functions
-export([start_link/0
        ,luck/1
        ,reward/1
        ,get_panel_info/0
        ,reload/0
        ,debug/0
    ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
        terminate/2, code_change/3]).

%% include
-include("lottery_camp.hrl").
%%
-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("gain.hrl").

-define(use_item, 33116).
-define(luck_time, {util:datetime_to_seconds({{2012, 9, 3}, {0, 0, 1}}), 
        util:datetime_to_seconds({{2012, 9, 10}, {23, 59, 59}})}).

%-define(luck_time, {util:datetime_to_seconds({{2012, 9, 3}, {0, 0, 1}}), 
%        util:datetime_to_seconds({{2012, 9, 5}, {23, 59, 59}})}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------

%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec luck(Role) -> {ok, Reply, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Reply = term()
%% Reason = bitstring()
%% 抽奖
luck(Role = #role{lottery_camp = #lottery_role{count = Lcount}}) ->
    case in_luck_time() of
        true ->
            case storage_api:get_free_num(bag, Role) of
                Pos when Pos > 0 ->
                    BaseId = ?use_item,
                    ItemName = case item_data:get(BaseId) of
                        {ok, #item_base{name = N}} ->
                            N;
                        _ ->
                            <<"">>
                    end,
                    case role_gain:do([#loss{label = item, val = [BaseId, 0, 1]}], Role) of
                        {ok, NewRole} ->
                            case call({luck, to_luck_role(Role)}) of
                                {ok, Reward = #lottery_camp_item{base_id = RewardId, is_notice = IsNotice}} ->
                                    case IsNotice of
                                        1 ->
                                            {ok, RewardId, NewRole#role{lottery_camp = #lottery_role{last_award = [Reward], count = 0}}};
                                        _ ->
                                            {ok, RewardId, NewRole#role{lottery_camp = #lottery_role{last_award = [Reward], count = Lcount + 1}}}
                                    end;
                                {false, Reason} ->
                                    {false, Reason}
                            end;
                        _ ->
                            {false, util:fbin(?L(<<"没有找到可消耗的物品: ~s">>), [ItemName])}
                    end;
                _ ->
                    {false, ?L(<<"背包已满，请先整理背包">>)}
            end;
        false ->
            {false, ?L(<<"不在奇宝转盘时间">>)}
    end.

%% @spec reward(Role) -> {ok, NewRole} | {false, Reason}
%% Role = NewRole = #role{}
%% Reason = bitstring()
%% 获取奖励
reward(Role = #role{lottery_camp = Lottery = #lottery_role{last_award = [Reward]}}) ->
    case Reward of
        #lottery_camp_item{base_id = BaseId} ->
            case role_gain:do([#gain{label = item, val = [BaseId, 1, 1]}], Role) of
                {ok, NewRole} ->
                    cast_notice(Role, Reward),
                    log_reward(Role, Reward),
                    {ok, NewRole#role{lottery_camp = Lottery#lottery_role{last_award = []}}, Reward};
                _ ->
                    {false, ?L(<<"背包已满，请先整理背包">>)}
            end;
        _Other ->
            ?ERR("错误的lottery_camp_item数据: ~w", [_Other]),
            {ok, Role#role{lottery_camp = #lottery_role{last_award = []}}}
    end;
reward(_) ->
    {false, <<>>}.

%% @spec get_panel_info() 
%% 获取转盘面板信息
get_panel_info() ->
    case call({get_logs}) of
        {ok, Logs} ->
            {ok, ?use_item, lottery_camp_data:all(), Logs};
        _ ->
            {false, not_found}
    end.

%% @spec reload() ->
%% 重新初始化奖励数据
reload() ->
    info({reload}).

%% 打印调试信息
debug() ->
    info({debug}).

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
    self() ! {reload},
    Logs = db_init(20),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #lottery_camp{log = Logs}}.

%% @spec: handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages

handle_call({luck, {_Rid, _Name, Count}}, _From, State = #lottery_camp{rands = Rands, rewards = Rewards}) ->
    R = util:rand(1, 100000),
    {_, BaseId} = do_rand(R, Rands),
    ?DEBUG("lottery_camp luck: rand = ~w, base_id = ~w", [R, BaseId]),
    case lists:keyfind(BaseId, #lottery_camp_item.base_id, Rewards) of
        Litem = #lottery_camp_item{is_notice = 1, limit_count = Lcount} when Count >= Lcount  ->
            {reply, {ok, Litem}, State};
        Litem = #lottery_camp_item{is_notice = 0} ->
            {reply, {ok, Litem}, State};
        _ ->
            {reply, get_default(), State}
    end;

handle_call({get_logs}, _From, State = #lottery_camp{log = Logs}) ->
    {reply, {ok, Logs}, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages

%%
handle_info({log, Log = #lottery_camp_log{}}, State = #lottery_camp{log = Logs}) ->
    NewLogs = lists:sublist([Log | Logs], 1, 20),
    {noreply, State#lottery_camp{log = NewLogs}};

%% reload
handle_info({reload}, State) ->
    ?INFO("reloading"),
    NewState = reload(State),
    {noreply, NewState};

%% debug
handle_info({debug}, State) ->
    ?DEBUG("lottery_camp state: ~w", [State]),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------

%% 异步调用
info(Msg) ->
    ?MODULE ! Msg.

%% 同步调用
call(Msg) ->
    ?CALL(?MODULE, Msg).

%% 重新初始化奖励
reload(State = #lottery_camp{}) ->
    {Rands, Rewards} = do_reload(lottery_camp_data:all()),
    UseItem = ?use_item,
    ?INFO("lottery_camp reload: use_item = ~w, rands = ~w, rewards = ~w", [UseItem, Rands, Rewards]),
    State#lottery_camp{use_item = UseItem, rands = Rands, rewards = Rewards}.

do_reload(All) ->
    do_reload(All, {[], []}).

do_reload([], {Rands, Rewards}) ->
    {lists:reverse(Rands), Rewards};
do_reload([H | T], {Rands, Rewards}) ->
    case lottery_camp_data:get(H) of
        {false, _} ->
            do_reload(T, {Rands, Rewards});
        {ok, Litem = #lottery_camp_item{base_id = BaseId, rand = Rand}} ->
            do_reload(T, {[{Rand, BaseId} | Rands], [Litem | Rewards]})
    end.

%% 随机抽取物品
do_rand(R, []) ->
    BaseId = util:rand_list(lottery_camp_data:get_default()),
    {R, BaseId};
do_rand(R, [{Rand, BaseId} | T]) ->
    case R =< Rand of
        true ->
            {Rand, BaseId};
        false ->
            do_rand(R - Rand, T)
    end.

to_luck_role(#role{id = Rid, name = Name, lottery_camp = #lottery_role{count = Lcount}}) ->
    {Rid, Name, Lcount}.

%% 获取默认
get_default() ->
    ?DEBUG("get default"),
    BaseId = util:rand_list(lottery_camp_data:get_default()),
    lottery_camp_data:get(BaseId).

cast_notice(Role, #lottery_camp_item{base_id = BaseId, is_notice = 1}) ->
    Rmsg = notice:role_to_msg(Role),
    Imsg = notice:item_to_msg({BaseId, 1, 1}),
    notice:send(52, util:fbin(?L(<<"神了...~s在{open, 39, 奇宝转盘, #00ff24}中转动幸运转盘，获得珍稀物品: ~s！">>), [Rmsg, Imsg])),
    ok;
cast_notice(_, _) ->
    ok.

%% 日志记录
log_reward(#role{id = {RoleId, SrvId}, name = Name}, #lottery_camp_item{base_id = BaseId, is_notice = IsNotice}) ->
    Log = #lottery_camp_log{rid = RoleId, srv_id = SrvId, name = Name, award_id = BaseId, is_notice = IsNotice, ctime = util:unixtime()},
    db_save(Log),
    case IsNotice =:= 1 of
        true ->
            info({log, Log});
        _ ->
            ok
    end.

db_save(#lottery_camp_log{rid = RoleId, srv_id = SrvId, name = Name, award_id = AwardId, is_notice = IsNotice, ctime = Ctime}) ->
    Sql = "insert into log_lottery_camp(rid, srv_id, name, award_id, is_notice, ctime) values (~s, ~s, ~s, ~s, ~s, ~s)",
    db:execute(Sql, [RoleId, SrvId, Name, AwardId, IsNotice, Ctime]).

db_init(Count) ->
    Sql = "select rid, srv_id, name, award_id, is_notice, ctime from log_lottery_camp where is_notice = 1 order by ctime desc limit ~s",
    case db:get_all(Sql, [Count]) of
        {ok, Rows} ->
            to_log(Rows);
        _ ->
            []
    end.

to_log(Rows) ->
    lists:map(fun([Rid, SrvId, Name, AwardId, IsNotice, Ctime]) -> #lottery_camp_log{rid = Rid, srv_id = SrvId, name = Name, award_id = AwardId, is_notice = IsNotice, ctime = Ctime} end, Rows).

%%
in_luck_time() ->
    {Begin, End} = ?luck_time,
    Now = util:unixtime(),
    case Now >= Begin andalso Now =< End of
        true ->
            true;
        _ ->
            campaign_adm:is_camp_time(lottery_camp) %% 通过后台活动开启
    end.


