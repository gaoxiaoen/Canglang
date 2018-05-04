%% --------------------------------------------------------------------
%% 帮战流程管理 <br />
%% 帮战流程状态：
%% <ul>
%% <li>idel: 闲置状态：不处理帮战的请求</li>
%% <li>sign: 报名状态：接受帮会的报名</li>
%% <li>prepare: 准备阶段：玩家进入帮战的预备区域</li>
%% <li>war1: 第一阶段战斗</li>
%% <li>war2: 第二阶段战斗</li>
%% <li>round_over: 夺旗成功，攻守方对调</li>
%% <li>over: 帮战结束</li>
%% </ul>
%% @author abu@jieyou.cn
%% @end
%% --------------------------------------------------------------------
-module(guild_war_flow).
-behaviour(gen_fsm).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("role.hrl").
-include("guild.hrl").
-include("guild_war.hrl").
%%

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([
        start_link/0
        ,start_war/0
        ,f_start_war/0
        ,prepare/0
        ,war1/0
        ,end_war/0
        ,idel/2
        ,sign/2
        ,prepare/2
        ,round_over/2
        ,end_war1/0
        ,end_war2/0
        ,get_flow_time/1
        ,get_state_time/1
        ,get_timeout/0
        ,set_force/1
    ]).

%% gen_fsm callbacks
-export([init/1, state_name/2, state_name/3, handle_event/3,
	 handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

%% record
-record(state, {time_stamp = util:unixtime(), war_pid = 0, sign_time = 0, prepare_time = 0, war_time = 0, is_force_open = false}).

%% 帮战各个阶段的时间 0表示没有时间限制
-define(guild_war_state_interval(State), 
    case State of
        idel -> get_latest_start_time();
        sign -> 60 * 20;
        prepare -> 60 * 5;
        round_over -> 15;
        all -> 60 * 30;  %% 帮战持续时间
        _ -> 0
    end
).

%% 帮战开启的时间 {周, 时, 分, 秒}
-define(guild_war_start_time, {19, 40, 0}).
-define(date_second, 86400).

%% --------------------------------------------------------------------
%% External functions
%% --------------------------------------------------------------------
start_link() ->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 开启帮战
start_war() ->
    send_info({start_war}).
%% 强制开启帮战
f_start_war() ->
    set_force(true),
    send_info({start_war}).

%% 跳过报名时间，直接开战
prepare() ->
    send_info({prepare}).

%% 跳过准备区
war1() ->
    send_info({war1}).

%% 结束帮战
end_war() ->
    send_info({end_war}).

%% 结束war1 
end_war1() ->
    send_info({end_war1}).

%% 结束war2
end_war2() ->
    send_info({end_war2}).

%% 设置是否强制开启，用于非合服
set_force(IsForceOpen) ->
    send_info({set_force, IsForceOpen}).

%% 调试timeout
get_timeout() ->
    send_info({get_timeout}).

%% 获取每个状态的时间
get_state_time(State) ->
    case State of
        ?guild_war_status_sign ->
            ?guild_war_state_interval(sign);
        ?guild_war_status_prepare ->
            ?guild_war_state_interval(prepare);
        _ ->    
            ?guild_war_state_interval(all)
    end.

%% 取帮战各流程的倒计时
get_flow_time(#role{event = Event, pid = Pid}) ->
    IsInWar = case Event of
        ?event_guild_war ->
            true;
        _ ->
            false
    end,
    send_info({get_flow_time, IsInWar, Pid}).

%% 空闲状态 
idel(timeout, State = #state{is_force_open = IsForceOpen}) ->
    ?debug_log([timeout, idel]),
    OpenTime = sys_env:get(srv_open_time),
    case guild_war_util:day_diff(OpenTime, util:unixtime()) of
        Day when Day < 2 -> %% 开服前二天不开帮战
            ?debug_log([idel, open_time_less_than_2]),
            {next_state, idel, State, ?date_second * 1000};
        _ ->
            case util:is_merge() of
                true -> %% 合服后才开启
                    ?debug_log([idel, open]),
                    do_open(State);
                _ ->
                    case IsForceOpen of
                        true ->
                            ?debug_log([idel, force_open]),
                            do_open(State);
                        _ ->
                            ?debug_log([idel, not_merge_srv]),
                            {next_state, idel, State, ?date_second * 1000}
                    end
            end
    end.

do_open(State) ->
    role_group:pack_cast(world, 14631, {1, guild_war_flow:get_state_time(?guild_war_status_sign)}),
    guild_war_mgr:status_changed(?guild_war_status_sign),
    Now = util:unixtime(),
    {next_state, sign, State#state{time_stamp = Now, sign_time = Now, is_force_open = false}, timeout(sign, Now)}.

%% 报名
sign(timeout, State) ->
    ?debug_log([timeout, sign]),
    Now = util:unixtime(),
    case guild_war_mgr:start_war() of
        {ok, Pid} ->
            role_group:pack_cast(world, 14631, {2, guild_war_flow:get_state_time(?guild_war_status_prepare)}),
            guild_war:set_war_status(Pid, ?guild_war_status_prepare),
            {next_state, prepare, State#state{time_stamp = Now, war_pid = Pid, prepare_time = Now}, timeout(prepare, Now)};
        _ ->
            {next_state, idel, State#state{time_stamp = Now}, timeout(idel, Now)}
    end.

%% 准备状态
prepare(timeout, State = #state{war_pid = WarPid}) ->
    ?debug_log([timeout, prepare]),
    role_group:pack_cast(world, 14631, {3, guild_war_flow:get_state_time(?guild_war_status_war1)}),
    guild_war:set_war_status(WarPid, ?guild_war_status_war1),
    erlang:send_after(?guild_war_state_interval(all) * 1000, self(), {war_timeout, WarPid}),
    Now = util:unixtime(),
    {next_state, war1, State#state{time_stamp = Now, war_time = Now}, timeout(war1, Now)}.

%% 回合结束
round_over(timeout, State = #state{war_pid = WarPid}) ->
    ?debug_log([timeout, round_over]),
    guild_war:set_war_status(WarPid, ?guild_war_status_war1),
    Now = util:unixtime(),
    {next_state, war1, State#state{time_stamp = Now}, timeout(war1, Now)}.

%% --------------------------------------------------------------------
%% gen_fsm callback functions
%% --------------------------------------------------------------------

%% Func: init/1
%% Returns: {ok, StateName, StateData}          |
%%          {ok, StateName, StateData, Timeout} |
%%          ignore                              |
%%          {stop, StopReason}
init([]) ->
    ?debug_log([init, {}]),
    Now = util:unixtime(),
    {ok, idel, #state{time_stamp = Now, war_pid = 0}, timeout(idel, Now)}.

%% Func: StateName/2
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}
state_name(_Event, StateData) ->
    {next_state, state_name, StateData}.

%% Func: StateName/3
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}
state_name(_Event, _From, StateData) ->
    Reply = ok,
    {reply, Reply, state_name, StateData}.

%% Func: handle_event/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}
handle_event(_Event, StateName, StateData) ->
    {next_state, StateName, StateData}.

%% Func: handle_sync_event/4
%% Returns: {next_state, NextStateName, NextStateData}            |
%%          {next_state, NextStateName, NextStateData, Timeout}   |
%%          {reply, Reply, NextStateName, NextStateData}          |
%%          {reply, Reply, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}                          |
%%          {stop, Reason, Reply, NewStateData}

handle_sync_event(_Event, _From, StateName, StateData) ->
    Reply = ok,
    {reply, Reply, StateName, StateData}.

%% Func: handle_info/3
%% Returns: {next_state, NextStateName, NextStateData}          |
%%          {next_state, NextStateName, NextStateData, Timeout} |
%%          {stop, Reason, NewStateData}

%% 帮战结束
handle_info({war_timeout, Wpid}, StateName, State = #state{war_pid = WarPid, time_stamp = T}) when Wpid =/= WarPid ->
    {next_state, StateName, State, timeout(StateName, T)};
handle_info({war_timeout, _Wpid}, _StateName, State = #state{war_pid = WarPid}) ->
    ?debug_log([war_timeout, {}]),
    role_group:pack_cast(world, 14631, {0, 0}),
    guild_war:set_war_status(WarPid, ?guild_war_status_over),
    guild_war_mgr:status_changed(?guild_war_status_over),
    Now = util:unixtime(),
    {next_state, idel, State#state{time_stamp = Now}, timeout(idel, Now)};
handle_info({war_timeout}, _StateName, State = #state{war_pid = WarPid}) ->
    ?debug_log([war_timeout, {}]),
    role_group:pack_cast(world, 14631, {0, 0}),
    guild_war:set_war_status(WarPid, ?guild_war_status_over),
    guild_war_mgr:status_changed(?guild_war_status_over),
    Now = util:unixtime(),
    {next_state, idel, State#state{time_stamp = Now}, timeout(idel, Now)};
%% 开始帮战
handle_info({start_war}, idel, State) ->
    ?debug_log([start_war, {}]),
    {next_state, idel, State, 1};
%% 到准备阶段
handle_info({prepare}, sign, State) ->
    {next_state, sign, State, 1};
handle_info({war1}, prepare, State) ->
    {next_state, prepare, State, 1};
%% 结束第一阶段战斗
handle_info({end_war1}, war1, State = #state{war_pid = WarPid}) ->
    ?debug_log([end_war1, war1]),
    guild_war:set_war_status(WarPid, ?guild_war_status_war2),
    {next_state, war2, State#state{time_stamp = util:unixtime()}, timeout(war2, util:unixtime())};
%% 结束第二阶段战斗
handle_info({end_war2}, war2, State = #state{war_pid = WarPid}) ->
    ?debug_log([end_war2, war2]),
    guild_war:set_war_status(WarPid, ?guild_war_status_round_over),
    Now = util:unixtime(),
    {next_state, round_over, State#state{time_stamp = Now}, timeout(round_over, Now)};
%% 设置是否强制开启，用于非合服
handle_info({set_force, IsForceOpen}, StateName, State) ->
    ?debug_log([set_force, StateName]),
    Now = util:unixtime(),
    {next_state, StateName, State#state{time_stamp = Now, is_force_open = IsForceOpen}, timeout(StateName, Now)};
%% 结束帮战
handle_info({end_war}, _StateName, State) ->
    self() ! {war_timeout},
    {next_state, idel, State};
%% 取帮战流程倒计时
handle_info({get_flow_time, _IsInWar, Pid}, StateName, State = #state{time_stamp = TimeStamp, sign_time = Stime, prepare_time = Ptime, war_time = Wtime}) ->
    Now = util:unixtime(),
    Result = case StateName of
        sign ->
            {1, ?guild_war_state_interval(sign) - (Now - Stime)};
        prepare ->
            {2, ?guild_war_state_interval(prepare) - (Now - Ptime)};
        war1 ->
            {3, ?guild_war_state_interval(all) - (Now - Wtime)};
        war2 ->
            {3, ?guild_war_state_interval(all) - (Now - Wtime)};
        round_over ->
            {3, ?guild_war_state_interval(all) - (Now - Wtime)};
        _ ->
            {0, 0}
    end,
    guild_war_rpc:push(Pid, get_flow_time, Result),
    {next_state, StateName, State, timeout(StateName, TimeStamp)};
%% 计算timeout
handle_info({get_timeout}, StateName, State = #state{time_stamp = TimeStamp}) ->
    TimeOut = timeout(StateName, TimeStamp),
    ?INFO("time out: ~w, ~w, ~w, ~w", [StateName, TimeOut, TimeStamp, util:unixtime()]),
    {next_state, StateName, State, TimeOut};

handle_info(_Info, StateName, State = #state{time_stamp = TimeStamp}) ->
    ?DEBUG("收到无效消息: state_name = ~w, msg = ~w", [StateName, _Info]),
    {next_state, StateName, State, timeout(StateName, TimeStamp)}.

%% Func: terminate/3
%% Purpose: Shutdown the fsm
%% Returns: any
terminate(_Reason, _StateName, _StatData) ->
    ok.

%% Func: code_change/4
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState, NewStateData}
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%% 计算每个状态的timeout
timeout(StateName, TimeStamp) ->
    Timeout = case ?guild_war_state_interval(StateName) of
        0 ->
            infinity;
        {fix, 0} ->
            1;
        {fix, Idel} ->
            Idel * 1000;
        Interval ->
            case Interval * 1000 - (util:unixtime() - TimeStamp) * 1000 of
                TimeLeft when TimeLeft > 0 ->
                    TimeLeft;
                _ ->
                    1
            end
    end,
    ?debug_log([timeout, {StateName, Timeout}]),
    Timeout.

%% 取得最近一场帮战的开启时间, 每天开启
%get_latest_start_time() ->
%    _Day = calendar:day_of_the_week(date()),
%    Time = util:datetime_to_seconds({date(), ?guild_war_start_time}) - util:unixtime(),
%    case Time >= 0 of
%        true ->
%            {fix, Time};
%        false ->
%            {fix, ?date_second + Time}
%    end.

get_latest_start_time() ->
    Day = calendar:day_of_the_week(date()),
    Time = util:datetime_to_seconds({date(), ?guild_war_start_time}) - util:unixtime(),
    TimeLeft = case {Day, Time >= 0} of 
        {1, _} ->
            6 * ?date_second + Time;
        {2, _} ->
            5 * ?date_second + Time;
        {3, _} ->
            4 * ?date_second + Time;
        {4, _} ->
            3 * ?date_second + Time;
        {5, _} ->
            2 * ?date_second + Time;
        {6, _} ->
            1 * ?date_second + Time;
        {7, true} ->
            Time;
        {7, false} ->
            7 * ?date_second + Time;
        _ ->
            Time
    end,
    {fix, TimeLeft}.
            
%% 向本进程发消息
send_info(Info) ->
    Pid = global:whereis_name(?MODULE),
    case guild_war_util:check([{is_pid_alive, Pid}]) of 
        ok ->
            Pid ! Info;
        {false, _} ->
            ?ERR("guild_war_flow 进程不存在")
    end.

