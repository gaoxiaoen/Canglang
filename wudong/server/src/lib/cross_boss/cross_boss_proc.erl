%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 五月 2016 22:50
%%%-------------------------------------------------------------------
-module(cross_boss_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("cross_boss.hrl").
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
    , clean_cross_player/1
    , cmd_start/0
    , cmd_close/0
    , cmd_reset/0
    , cmd_force_close/0
    , cmd_reward/0
    , cmd_default/0
    , gm_start/0
    , gm_stop/0
    , gm_box_mon/0
    , time_list/0
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

gm_start() ->
    get_server_pid() ! gm_start,
    ok.

gm_stop() ->
    get_server_pid() ! close,
    drop_scene:gm_clean_scene_drop(60301),
    ok.

gm_box_mon() ->
    get_server_pid() ! gm_box_mon,
    ok.

cmd_start() ->
    get_server_pid() ! {ready, 5, 20 * 60},
    ok.
cmd_close() ->
    get_server_pid() ! close,
    ok.
cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()},
    ok.

cmd_default() ->
    get_server_pid() ! cmd_default,
    ok.

cmd_force_close() ->
    get_server_pid() ! cmd_force_close,
    ok.

cmd_reward() ->
    get_server_pid() ! cmd_reward.

clean_cross_player(Pkey) ->
    get_server_pid() ! {clean_cross_player, Pkey}.

init([]) ->
    BossIdList = cross_boss_init:init_boss(),
    State = set_timer(#st_cross_boss{boss_ids = BossIdList}, util:unixtime()),
    {ok, State}.



handle_call(Request, From, State) ->
    case catch cross_boss_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross boss handle_call ~p/~p~n", [Reason, Request]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_boss_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross boss handle_cast ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_boss_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross boss handle_info ~p/~p~n", [Reason, Request]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
set_timer(StBF, Now) ->
    case center:is_center_area() of
        false -> StBF#st_cross_boss{open_state = ?CROSS_BOSS_STATE_CLOSE};
        true ->
            NowSec = util:get_seconds_from_midnight(Now),
            case time_list(Now) of
                [] ->
                    #st_cross_boss{open_state = ?CROSS_BOSS_STATE_CLOSE, damage_list = StBF#st_cross_boss.damage_list, damage_guild_list = StBF#st_cross_boss.damage_guild_list};
                TimeList ->
                    case [{S, E - S} || [S, E] <- TimeList, S > NowSec] of
                        [] ->
                            Time = hd(hd(TimeList)),
                            StBF#st_cross_boss{open_state = ?CROSS_BOSS_STATE_CLOSE, time = Now + ?ONE_DAY_SECONDS - NowSec + Time - ?CROSS_BOSS_READY_TIME};
                        NewTimeList ->
                            {StartTime, LastTime} = hd(NewTimeList),
                            ReadyTime = StartTime - ?CROSS_BOSS_READY_TIME,
                            if
                                NowSec < ReadyTime -> %% 提前5min准备
                                    Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?CROSS_BOSS_READY_TIME, LastTime}),
                                    StBF#st_cross_boss{open_state = ?CROSS_BOSS_STATE_CLOSE, time = Now + ReadyTime - NowSec, ref = Ref};
                                true ->
                                    Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                                    StBF#st_cross_boss{open_state = ?CROSS_BOSS_STATE_READY, ref = Ref, time = Now + StartTime - NowSec}
                            end
                    end
            end
    end.

time_list() ->
    time_list(util:unixtime()).

time_list(Now) ->
   Week = util:get_day_of_week(Now),
   F = fun(Id) ->
       {WeekList, TimeList} = data_cross_boss_time:get(Id),
       case lists:member(Week, WeekList) of
           false -> [];
           true ->
               [[SH*3600+SM*60, EH*3600+EM*60] || {{SH, SM}, {EH, EM}} <- TimeList]
       end
       end,
   lists:flatmap(F, data_cross_boss_time:ids()).

