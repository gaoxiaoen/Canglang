%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 11:19
%%%-------------------------------------------------------------------
-module(cross_war_proc).
-author("li").

-behaviour(gen_server).

-include("common.hrl").
-include("server.hrl").
-include("cross_war.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-export([
    get_server_pid/0,
    set_timer/2,
    time_list/0,

    gm_start/0,
    gm_stop/0
]).

-define(SERVER, ?MODULE).

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

gm_start() ->
    get_server_pid() ! gm_start,
    ok.

gm_stop() ->
    get_server_pid() ! close,
    ok.

-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    CleanRef = erlang:send_after(?CROSS_WAR_CLEAN_TIME*1000, self(), clean_node_data),
    cross_war_init:init_ets(),
    UpdateScoreRef = erlang:send_after(?CROSS_WAR_UPDATE_SCORE*1000, self(), update_score_data),
    AddExpRef = erlang:send_after(?CROSS_WAR_ADDEXP_TIME*1000, self(), add_exp_data),
    St = cross_war_init:init(#sys_cross_war{clean_ref = CleanRef, update_score_ref = UpdateScoreRef, add_exp_ref = AddExpRef}),
    NewSt = set_timer(St, util:unixtime()),
    {ok, NewSt}.

handle_call(Request, From, State) ->
    case catch cross_war_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross war handle_call ~p/~p~n", [Reason, Request]),
            {reply, error, State}
    end.

handle_cast(Request, State) ->
    case catch cross_war_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross war handle_cast ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_war_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross war handle_info ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

terminate(_Reason, State) ->
    case config:is_center_node() of
        true -> cross_war_repair:update_king(State);
        false -> skip
    end,
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

set_timer(StBF, Now) ->
    case center:is_center_area() of
        false -> StBF#sys_cross_war{open_state = ?CROSS_WAR_STATE_CLOSE};
        true ->
            NowSec = util:get_seconds_from_midnight(Now),
            case time_list(Now) of
                [] -> %% 当天没有活动，设置准备时间段
                    ?DEBUG("CROSS_WAR_STATE_APPLY", []),
                    StBF#sys_cross_war{open_state = ?CROSS_WAR_STATE_APPLY, time = get_act_start_time()};
                TimeList ->
                    case [{S, E - S} || [S, E] <- TimeList, S > NowSec] of
                        [] -> %% 当天有活动，但是过期了，关闭状态
                            ?DEBUG("CROSS_WAR_STATE_CLOSE", []),
                            StBF#sys_cross_war{open_state = ?CROSS_WAR_STATE_CLOSE, time = 0};
                        NewTimeList -> %% 当天有活动
                            {StartTime, LastTime} = hd(NewTimeList),
                            ReadyTime = StartTime - ?CROSS_WAR_READY_TIME,
                            if
                                NowSec < ReadyTime -> %% 提前30min准备
                                    ?DEBUG("CROSS_WAR_READY_TIME", []),
                                    Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?CROSS_WAR_READY_TIME, LastTime}),
                                    StBF#sys_cross_war{open_state = ?CROSS_WAR_STATE_APPLY, time = Now + ReadyTime - NowSec, ref = Ref};
                                true ->
                                    ?DEBUG("CROSS_WAR_STATE_READY", []),
                                    Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                                    StBF#sys_cross_war{open_state = ?CROSS_WAR_STATE_READY, ref = Ref, time = Now + StartTime - NowSec}
                            end
                    end
            end
    end.

time_list() ->
    time_list(util:unixtime()).

time_list(Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_cross_war_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                [{SH, SM}, {EH, EM}] = TimeList,
                [[SH*3600 + SM*60, EH*3600+EM*60]]
        end
    end,
    lists:flatmap(F, data_cross_war_time:ids()).

get_act_start_time() ->
    get_week_start_time()+get_sec_week().

%% 获取一周开启时间
get_week_start_time() ->
    Week = util:get_day_of_week(util:unixtime()),
    util:unixdate() - (Week - 1)*?ONE_DAY_SECONDS.

%% 活动一周段开启时间
get_sec_week() ->
    Ids = data_cross_war_time:ids(),
    {WeekList, TimeList} = data_cross_war_time:get(hd(Ids)),
    Week = hd(WeekList),
    {SH, SM} = hd(TimeList),
    (Week-1)*?ONE_DAY_SECONDS + SH*3600 + SM*60.