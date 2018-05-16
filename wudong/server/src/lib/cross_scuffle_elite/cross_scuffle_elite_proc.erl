%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2017 18:06
%%%-------------------------------------------------------------------
-module(cross_scuffle_elite_proc).
-author("Administrator").

%% API
-behaviour(gen_server).

-include("cross_scuffle_elite.hrl").
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
    , cmd_start/0
    , cmd_close/0
    , cmd_reset/0
    , cmd_final_start/0
    , cmd_final_close/0
    , cmd_next_final_start/0
    , cmd_update_fight_record/0
    , cmd_refresh/0
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

cmd_start() ->
    get_server_pid() ! {ready, 5, 30 * 60},
    ok.

cmd_final_start() ->
    get_server_pid() ! {start_final, ?CROSS_SCUFFLE_ELITE_STATE_FAINAL_INTERVAL * 5},
    ok.

cmd_next_final_start() ->
    get_server_pid() ! final_match,
    ok.

cmd_update_fight_record() ->
    get_server_pid() ! re_update_fight_record,
    ok.

cmd_refresh() ->
    get_server_pid() ! refresh,
    ok.



cmd_final_close() ->
    get_server_pid() ! final_close,
    ok.

cmd_close() ->
    get_server_pid() ! close,
    ok.
cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()},
    ok.

init([]) ->
    spawn(fun() -> cross_scuffle_elite_war_team_init:init_war_team_data() end),
    State = set_timer(#st_cross_scuffle_elite{}, util:unixtime()),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch cross_scuffle_elite_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross scuffle elite handle_call ~p/~p~n", [Reason, Request]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_scuffle_elite_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross scuffle elite handle_cast ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_scuffle_elite_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross scuffle elite handle_info ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

set_timer(StBF, Now) ->
    case center:is_center_all() of
        false ->
            StBF#st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_CLOSE};
        true ->
            Ref1 = erlang:send_after(5 * 1000, self(), timer_update),
            WeekList = data_cross_scuffle_elite_time:open_weeks(),
            NowWeek = util:get_day_of_week(Now),
            case lists:member(NowWeek, WeekList) of
                false ->
                    if
                        NowWeek == 2 ->
                            cross_scuffle_elite_war_team_ets:re_set(),
                            #st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_CLOSE};
                        true ->
                            StBF#st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_CLOSE}
                    end;
                true ->
                    NowSec = util:get_seconds_from_midnight(Now),
                    [StartTime, EndTime, _FinalStartTime, _FinalEndTime] = open_time(),
                    LastTime = EndTime - StartTime,
                    ReadyTime = StartTime - ?CROSS_SCUFFLE_ELITE_READY_TIME,
                    if
                    %% 预赛时间
                        NowSec >= StartTime ->
                            StBF#st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_CLOSE, timer_update_ref = Ref1};
                        NowSec < ReadyTime ->
                            Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?CROSS_SCUFFLE_ELITE_READY_TIME, LastTime}),
                            StBF#st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_CLOSE, time = Now + ReadyTime - NowSec, ref = Ref, timer_update_ref = Ref1};
                        true ->
                            Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                            StBF#st_cross_scuffle_elite{open_state = ?CROSS_SCUFFLE_ELITE_STATE_READY, ref = Ref, time = Now + StartTime - NowSec, timer_update_ref = Ref1}
                    end
            end
    end.

open_time() ->
    TimeList = data_cross_scuffle_elite_time:open_time(),
    [H * 3600 + M * 60 || {H, M} <- TimeList].
