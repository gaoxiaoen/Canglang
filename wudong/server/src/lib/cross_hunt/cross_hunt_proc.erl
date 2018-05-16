%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 六月 2016 17:31
%%%-------------------------------------------------------------------
-module(cross_hunt_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("cross_hunt.hrl").
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
    [Start, End] = hd(time_list()),
    get_server_pid() ! {ready, 5, End - Start},
    ok.
cmd_close() ->
    get_server_pid() ! close,
    ok.
cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()},
    ok.

init([]) ->
    process_flag(trap_exit, true),
    ets:new(?ETS_CROSS_HUNT_MON, [{keypos, #base_hunt_target.goods_id} | ?ETS_OPTIONS]),
%%    State = set_timer(#st_cross_hunt{}, util:unixtime()),
    {ok, #st_cross_hunt{}}.



handle_call(Request, From, State) ->
    case catch cross_hunt_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross hunt handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_hunt_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross hunt handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_hunt_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross hunt handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
set_timer(StHunt, Now) ->
    case center:is_center_area() of
        false -> StHunt#st_cross_hunt{open_state = ?CROSS_HUNT_STATE_CLOSE};
        true ->
            NowSec = util:get_seconds_from_midnight(Now),
            case time_list() of
                [] ->
                    #st_cross_hunt{open_state = ?CROSS_HUNT_STATE_CLOSE};
                TimeList ->
                    case [{S, E - S} || [S, E] <- TimeList, S > NowSec] of
                        [] ->
                            Time = hd(hd(TimeList)),
                            StHunt#st_cross_hunt{open_state = ?CROSS_HUNT_STATE_CLOSE, time = Now + ?ONE_DAY_SECONDS - NowSec + Time};
                        NewTimeList ->
                            {StartTime, LastTime} = hd(NewTimeList),
                            ReadyTime = StartTime - ?CROSS_HUNT_READY_TIME,
                            if NowSec < ReadyTime ->
                                Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?CROSS_HUNT_READY_TIME, LastTime}),
                                StHunt#st_cross_hunt{open_state = ?CROSS_HUNT_STATE_CLOSE, time = Now + ReadyTime - NowSec, ref = Ref};
                                true ->
                                    Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                                    StHunt#st_cross_hunt{open_state = ?CROSS_HUNT_STATE_READY, ref = Ref, time = Now + StartTime - NowSec}
                            end
                    end
            end
    end.

time_list() ->
    F = fun(Id) ->
        [H * 3600 + M * 60 || {H, M} <- data_cross_hunt_time:get(Id)]
        end,
    lists:map(F, data_cross_hunt_time:ids()).
