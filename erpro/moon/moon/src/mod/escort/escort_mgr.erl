%%----------------------------------------------------
%% @doc 运镖全局进程
%%
%% <pre>
%% 运镖全局进程
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(escort_mgr).

-behaviour(gen_fsm).

-export([
        start_link/0
        ,next/1
        ,time_leave/0
        ,is_double_award/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,notice/2
        ,escorting/2
    ]
).

-include("common.hrl").
-include("escort.hrl").
%%

-record(state, {
        ts = 0              %% 进入某状态时刻
        ,timeout_val = 0    %% 空间时间(不是固定的)
    }
).

%%----------------------------------------------------
%% 对外接口 
%%----------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%% 获取时间
time_leave() ->
    gen_fsm:sync_send_all_state_event(?MODULE, {time_leave}).

%% 获取时间
is_double_award(AcceptTime) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {is_double_award, AcceptTime}).

%%----------------------------------------------------
%% 全局进程处理 
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    IdelTime = get_idel_time(),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, idel, #state{ts = erlang:now(), timeout_val = IdelTime}, IdelTime}.

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event({time_leave}, _From, notice, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    TimeLeave = round(util:time_left(TimeVal, Ts)/ 1000),
    continue(notice, {ok, 1, TimeLeave}, State);
handle_sync_event({time_leave}, _From, escorting, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    TimeLeave = round(util:time_left(TimeVal, Ts)/ 1000),
    continue(escorting, {ok, 2, TimeLeave}, State);

handle_sync_event({is_double_award, AcceptTime}, _From, escorting, State = #state{ts = Ts}) ->
    {M, S, _} = Ts,
    Begin = M * 1000000 + S,
    Reply = case AcceptTime > Begin of
        true -> {ok, true};
        false -> {ok, false}
    end,
    continue(escorting, Reply, State);

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info({msg_noice}, notice, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {_, M, S} = calendar:seconds_to_time(round(util:time_left(TimeVal, Ts)/ 1000)),
    case M > 0 of
        true ->
            notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动将在~w分~w秒后开始，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [M, S]));
        false ->
            notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动将在~w秒后开始，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [S]))
    end,
    erlang:send_after(180 * 1000, self(), {msg_noice}),
    continue(notice, State);

handle_info({msg_escorting}, escorting, State) ->
    notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动进行中，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [])),
    erlang:send_after(180 * 1000, self(), {msg_escorting}),
    continue(escorting, State);

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
idel(timeout, State) ->
    ?INFO("[护送美女]开始发通知"),
    {_, M, S} = calendar:seconds_to_time(round(?escort_timeout_notice/ 1000)),
    case M > 0 of
        true ->
            notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动将在~w分~w秒后开始，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [M, S]));
        false ->
            notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动将在~w秒后开始，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [S]))
    end,
    erlang:send_after(180 * 1000, self(), {msg_noice}),
    role_group:pack_cast(world, 13106, {1, round(?escort_timeout_notice/ 1000)}),
    {next_state, notice, State#state{ts = erlang:now(), timeout_val = ?escort_timeout_notice}, ?escort_timeout_notice};
idel(_Any, State) ->
    continue(idel, State).

%% 通知状态结束
notice(timeout, State) ->
    ?INFO("[护送美女]正式开始双倍奖励护送美女活动"),
    notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动正式开始，大量金币等你来拿。{open, 5, 我要护送, #00ff00}">>), [])),
    erlang:send_after(180 * 1000, self(), {msg_escorting}),
    role_group:pack_cast(world, 13106, {2, round(?escort_timeout_escorting/ 1000)}),
    {next_state, escorting, State#state{ts = erlang:now(), timeout_val = ?escort_timeout_escorting}, ?escort_timeout_escorting};
notice(_Any, State) ->
    continue(notice, State).

%% 运镖结束 
escorting(timeout, State) ->
    ?INFO("[护送美女]双倍奖励护送美女活动结束"),
    notice:send(54, util:fbin(?L(<<"双倍奖励护送美女活动结束, 谢谢大家参与!">>), [])),
    IdelTime = get_idel_time(),
    {next_state, idel, State#state{ts = erlang:now(), timeout_val = IdelTime}, IdelTime};
escorting(_Any, State) ->
    continue(escorting, State).

%%----------------------------------------------------
%% 内部处理函数 
%%----------------------------------------------------
%% 获取空闲时间
get_idel_time() ->
    Now = util:unixtime(),
    BeginTime = util:unixtime({today, Now}) + ?escort_double_award,
    Rtn = case BeginTime > Now of
        true -> BeginTime - Now;
        false ->
            util:unixtime({tomorrow, Now}) - Now + ?escort_double_award
    end,
    Rtn * 1000.

continue(StateName, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {next_state, StateName, State, util:time_left(TimeVal, Ts)}.

continue(StateName, Reply, State = #state{ts = Ts, timeout_val = TimeVal}) ->
    {reply, Reply, StateName, State, util:time_left(TimeVal, Ts)}.
