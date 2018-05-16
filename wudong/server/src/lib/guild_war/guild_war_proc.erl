%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 十二月 2015 17:25
%%%-------------------------------------------------------------------
-module(guild_war_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("guild_war.hrl").
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
    get_server_pid() ! {ready, 5, 20 * 60},
    ok.
cmd_close() ->
    get_server_pid() ! {close},
    ok.
cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()},
    ok.

init([]) ->
%%    Now = util:unixtime(),
%%    guild_war_init:init_figure(),
%%    GDict = guild_war_init:init(),
%%    StGuildWar = set_timer(Now, #st_guild_war{g_dict = GDict}),
    {ok, #st_guild_war{}}.



handle_call(Request, From, State) ->
    case catch guild_war_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("guild_war handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch guild_war_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild_war handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch guild_war_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild_war handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

set_timer(Now, StGuildWar) ->
    NowSec = util:get_seconds_from_midnight(Now),
    case time_list(Now) of
        [] ->
            StGuildWar#st_guild_war{war_state = ?GUILD_WAR_STATE_APPLY, end_time = next_time(Now)};
        TimeList ->
            case [{S, E - S} || [S, E] <- TimeList, S > NowSec] of
                [] ->
                    StGuildWar#st_guild_war{war_state = ?GUILD_WAR_STATE_APPLY, end_time = next_time(Now)};
                NewTimeList ->
                    {StartTime, LastTime} = hd(NewTimeList),
                    ReadyTime = StartTime - ?GUILD_WAR_READY_TIME,
                    if NowSec < ReadyTime ->
                        Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?GUILD_WAR_READY_TIME, LastTime}),
                        StGuildWar#st_guild_war{war_state = ?GUILD_WAR_STATE_APPLY, end_time = Now + ReadyTime - NowSec, ref = Ref};
                        true ->
                            Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, LastTime}),
                            StGuildWar#st_guild_war{war_state = ?GUILD_WAR_STATE_READY, ref = Ref, end_time = Now + StartTime - NowSec}
                    end
            end
    end.

time_list(Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_guild_war_time:get(Id),
        case lists:member(Week, WeekList) of
            false -> [];
            true ->
                [[H * 3600 + M * 60 || {H, M} <- TimeList]]
        end
        end,
    lists:flatmap(F, data_guild_war_time:ids()).


next_time(Now) ->
    Week = util:get_day_of_week(Now),
    NowSec = util:get_seconds_from_midnight(Now),
    F = fun(Id) ->
        {WeekList, TimeList} = data_guild_war_time:get(Id),
        case lists:member(Week, WeekList) of
            false ->
                NextWeekTime = filter_week(Week, WeekList),
                StartTime = hd([H * 3600 + M * 60 || {H, M} <- TimeList]),
                [NextWeekTime - NowSec + StartTime];
            true -> []
        end
        end,
    case lists:flatmap(F, data_guild_war_time:ids()) of
        [] -> Now;
        [NextTime | _] -> NextTime + Now
    end.

filter_week(Week, WeekList) ->
    case [Val || Val <- lists:reverse(lists:sort(WeekList)), Val >= Week] of
        [] ->
            (7 - Week - 1 + hd(WeekList)) * ?ONE_DAY_SECONDS;
        [T | _] -> (T - Week) * ?ONE_DAY_SECONDS
    end.

