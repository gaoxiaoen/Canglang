%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 15:36
%%%-------------------------------------------------------------------
-module(convoy_proc).
-author("hxming").
%% API
-behaviour(gen_server).

-include("task.hrl").
-include("common.hrl").

%%准备时间
-define(READY_TIME, 1800).

-define(CONVOY_STATE_CLOSE, 0).
-define(CONVOY_STATE_READY, 1).
-define(CONVOY_STATE_START, 2).

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    ref = undefined,
    start_time = 0,
    end_time = 0,
    act_state = 0
}).
-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0
    , convoy_reward/0
    , reset/1
    , cmd_start/0
    , cmd_close/0
    , cmd_reset/0
    , check_convoy_state/1
]).


%%创建
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%%获取进程PID
get_server_pid() ->
    case get(?MODULE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    put(?MODULE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.

%%获取奖励倍数可
convoy_reward() ->
    case ?CALL(get_server_pid(), convoy_reward) of
        [] -> 1;
        0 -> 1;
        Ret -> Ret
    end.


check_convoy_state(Sid) ->
    ?CAST(get_server_pid(), {check_convoy_state, Sid}).



reset(NowTime) ->
    get_server_pid() ! {reset, NowTime}.

cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()}.

cmd_start() ->
    get_server_pid() ! {ready, 10, round(?ONE_HOUR_SECONDS / 2)}.

cmd_close() ->
    get_server_pid() ! close.


init([]) ->
    Now = util:unixtime(),
    {ok, set_timer(#state{}, Now)}.

handle_call(convoy_reward, _from, State) ->
    Ret = ?IF_ELSE(State#state.act_state == ?CONVOY_STATE_START, 2, 1),
    {reply, Ret, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast({check_convoy_state, Sid}, State) when State#state.act_state > 0 ->
    Time = max(0, State#state.end_time - util:unixtime()),
    {ok, Bin} = pt_300:write(30020, {State#state.act_state, Time}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({reset, NowTime}, State) ->
    util:cancel_ref([State#state.ref]),
    NewState = set_timer(State, NowTime),
    {noreply, NewState};

handle_info({ready, ReadyTime, ActTime}, State) ->
    util:cancel_ref([State#state.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_300:write(30020, {?CONVOY_STATE_READY, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, ActTime}),
    NewState = State#state{ref = Ref, start_time = Now, end_time = Now + ReadyTime, act_state = ?CONVOY_STATE_READY},
    {noreply, NewState};

handle_info({start, ActTime}, State) ->
    util:cancel_ref([State#state.ref]),
    Now = util:unixtime(),
    {ok, Bin} = pt_300:write(30020, {?CONVOY_STATE_START, ActTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ActTime * 1000, self(), close),
    notice_sys:add_notice(convoy_start, []),
    NewState = State#state{ref = Ref, start_time = Now, end_time = Now + ActTime, act_state = ?CONVOY_STATE_START},
    {noreply, NewState};

%%多倍活动结束
handle_info(close, State) ->
    util:cancel_ref([State#state.ref]),
    {ok, Bin} = pt_300:write(30020, {?CONVOY_STATE_CLOSE, 0}),
    server_send:send_to_all(Bin),
    NewState = set_timer(State#state{start_time = 0, end_time = 0, act_state = ?CONVOY_STATE_CLOSE}, util:unixtime()),
    notice_sys:add_notice(convoy_close, []),
    {noreply, NewState};



handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
set_timer(State, Now) ->
    NowSec = util:get_seconds_from_midnight(Now),
    Date = util:unixdate(Now),
    case [{S, E} || [S, E] <- time_list(), E > NowSec] of
        [] ->
            State#state{act_state = ?CONVOY_STATE_CLOSE};
        [{Start, End} | _] ->
            Ready = Start - ?READY_TIME,
            if
                NowSec < Ready ->
                    Ref = erlang:send_after((Ready - NowSec) * 1000, self(), {ready, ?READY_TIME, End - Start}),
                    State#state{ref = Ref, act_state = ?CONVOY_STATE_CLOSE};
                NowSec < Start ->
                    Ref = erlang:send_after((Start - NowSec) * 1000, self(), {start, End - Start}),
                    State#state{ref = Ref, end_time = Date + Start, act_state = ?CONVOY_STATE_READY};
                true ->
                    Ref = erlang:send_after((End - NowSec) * 1000, self(), close),
                    State#state{ref = Ref, start_time = Now, end_time = Date + End, act_state = ?CONVOY_STATE_START}
            end
    end.

time_list() ->
    F = fun(Id) ->
        Base = data_convoy_time:get(Id),
        [H * 3600 + M * 60 || {H, M} <- Base#base_convoy_time.time]
        end,
    lists:map(F, data_convoy_time:ids()).

