%%----------------------------------------------------
%% @doc 运镖全局进程
%%
%% <pre>
%% 运镖全局进程
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort_child_mgr).

-behaviour(gen_fsm).

-export([
        start_link/0
        ,restart/0
        ,restart/2
        ,stop/0
        ,next/1
        ,is_escorting/0
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,escorting/2
    ]
).

-include("common.hrl").
-include("escort.hrl").
%%
-include("npc.hrl").

-record(state, {
        begin_time = 0      %% 开始时间
        ,end_time = 0       %% 结束时间
        ,ts = 0             %% 进入某状态时刻
        ,timeout_val = 0    %% 空间时间(不是固定的)
    }
).

-define(escort_child_begin, util:datetime_to_seconds({{2012, 7, 18}, {23, 0, 10}})).
-define(escort_child_end, util:datetime_to_seconds({{2012, 7, 27}, {23, 59, 55}})).

%%----------------------------------------------------
%% 对外接口 
%%----------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 重启
restart(S, E)->
    gen_fsm:send_all_state_event(?MODULE, {restart, S, E}).
restart()->
    gen_fsm:send_all_state_event(?MODULE, {restart, ?escort_child_begin, ?escort_child_end}).

%% 停止
stop() ->
    gen_fsm:send_all_state_event(?MODULE, {stop}).


%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%% 获取时间
is_escorting() ->
    gen_fsm:sync_send_all_state_event(?MODULE, is_escorting).

%%----------------------------------------------------
%% 全局进程处理 
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    Now = util:unixtime(),
    BeginTime = ?escort_child_begin, %% 活动结束时间
    case BeginTime =< Now of
        true -> {ok, idel, #state{ts = erlang:now(), timeout_val = 1 * 1000}, 1 * 1000};
        false -> {ok, idel, #state{ts = erlang:now(), timeout_val = (BeginTime - Now) * 1000}, (BeginTime - Now) * 1000}
    end.

handle_event({restart, 0, _E}, StateName, State) ->
    continue(StateName, State);
handle_event({restart, _S, 0}, StateName, State) ->
    continue(StateName, State);
handle_event({restart, S, E}, StateName, State) when S >= E ->
    ?INFO("开始时间大于结束时间不予处理"),
    continue(StateName, State);
handle_event({restart, S, E}, _StateName, State) ->
    Now = util:unixtime(),
    IdelTime = case Now > S of
        true -> 1 * 1000;
        false -> (S - Now) * 1000
    end,
    {next_state, idel, State#state{begin_time = S, end_time = E, ts = erlang:now(), timeout_val = IdelTime}, IdelTime};

handle_event({stop}, _StateName, State) ->
    Now = util:unixtime(),
    {next_state, idel, State#state{begin_time = Now - 2, end_time = Now - 1, ts = erlang:now(), timeout_val = ?escort_max_time}, ?escort_max_time};

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event(is_escorting, _From, escorting, State) ->
    continue(escorting, true, State);
handle_sync_event(is_escorting, _From, StateName, State) ->
    continue(StateName, false, State);

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.
%%----------------------------------------------------
%% 状态函数 
%%----------------------------------------------------
%% 空闲状态结束
idel(timeout, State = #state{begin_time = _BTime, end_time = ETime}) ->
    ?INFO("[护送小孩]开始"),
    %% role_group:pack_cast(world, 13106, {1, round(?escort_timeout_notice/ 1000)}),
    Now = util:unixtime(),
    EndTime = case ETime =:= 0 of
        true -> ?escort_child_end;
        false -> ETime
    end,
    case EndTime > Now of
        true -> 
            Timeout = (EndTime - Now) * 1000,
            {next_state, escorting, State#state{ts = erlang:now(), timeout_val = Timeout}, Timeout};
        false ->
            ?INFO("[护送小孩]已经超时"),
            {next_state, idel, State#state{ts = erlang:now(), timeout_val = ?escort_max_time}, ?escort_max_time}
    end;
idel(_Any, State) ->
    continue(idel, State).

%% 运镖结束 
escorting(timeout, State) ->
    ?INFO("[护送小孩]活动结束"),
    role_group:pack_cast(world, 10204, {71009}), %% 删除可接任务
    {next_state, idel, State#state{ts = erlang:now(), timeout_val = ?escort_max_time}, ?escort_max_time};
escorting(_Any, State) ->
    continue(escorting, State).

%%----------------------------------------------------
%% 内部处理函数 
%%----------------------------------------------------
continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, util:time_left(TimeVal, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {reply, Reply, StateName, State, util:time_left(TimeVal, Ts)}.
