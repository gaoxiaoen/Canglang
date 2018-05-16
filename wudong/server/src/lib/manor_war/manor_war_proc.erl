%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十二月 2016 10:04
%%%-------------------------------------------------------------------
-module(manor_war_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("manor_war.hrl").
-include("common.hrl").


%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0
    , get_server_pid/0
    , set_timer/2
%%    , cmd_apply/0
    , cmd_start/0
    , cmd_close/0
    , cmd_reset/0
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


%%cmd_apply() ->
%%    get_server_pid() ! cmd_apply.

cmd_start() ->
    get_server_pid() ! {ready, 5, 20 * 60},
    ok.
cmd_close() ->
    get_server_pid() ! close,
    ok.
cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()},
    ok.

init([]) ->
    process_flag(trap_exit, true),
    Now = util:unixtime(),
    erlang:send_after(1000, self(), init),
    State = set_timer(Now, #st_manor_war{}),
    {ok, State}.



handle_call(Request, From, State) ->
    case catch manor_war_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("manor_war handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch manor_war_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("maonr_war handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch manor_war_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("manor_war handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    manor_war_init:logout(),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

set_timer(Now, State) ->
    NowSec = util:get_seconds_from_midnight(Now),
    case check_time(Now) of
        false ->
            State#st_manor_war{war_state = ?MANOR_WAR_STATE_CLOSE};
        TimeList ->
            case [{S, E - S} || [S, E] <- TimeList, S > NowSec] of
                [] ->
                    State#st_manor_war{war_state = ?MANOR_WAR_STATE_CLOSE};
                NewTimeList ->
                    {StartTime, LastTime} = hd(NewTimeList),
                    ReadyTime = StartTime - ?MANOR_WAR_READY_TIME,
                    if NowSec < ReadyTime ->
                        Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?MANOR_WAR_READY_TIME, LastTime}),
                        State#st_manor_war{war_state = ?MANOR_WAR_STATE_CLOSE, ref = Ref};
                        true ->
                            Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                            State#st_manor_war{war_state = ?MANOR_WAR_STATE_READY, ref = Ref, end_time = Now + StartTime - NowSec}
                    end
            end
    end.

%%检查时间
check_time(Now) ->
    Week = util:get_day_of_week(Now),
    case data_manor_war_time:open_days() of
        [] ->
            get_time(Week);
        DayList ->
            OpenDay = config:get_open_days(),
            MaxDay = lists:max(DayList),
            if OpenDay > MaxDay ->
                get_time(Week);
                true ->
                    case lists:member(OpenDay, DayList) of
                        true ->
                            [[H * 3600 + M * 60 || {H, M} <- data_manor_war_time:get_time()]];
                        false -> false
                    end
            end
    end.

get_time(Week) ->
    case lists:member(Week, data_manor_war_time:get_week()) of
        false ->
            false;
        true ->
            [[H * 3600 + M * 60 || {H, M} <- data_manor_war_time:get_time()]]
    end.



