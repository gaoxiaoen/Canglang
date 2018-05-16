%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2018 15:25
%%%-------------------------------------------------------------------
-module(guild_answer_proc).
-author("hxming").

%% API
-behaviour(gen_server).

-include("guild.hrl").
-include("guild_answer.hrl").
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
-export([start_link/0, get_server_pid/0, reset/0]).

-export([set_timer/2, cmd_start/0, cmd_close/0]).

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

reset() ->
    get_server_pid() ! {reset, util:unixtime()}.

cmd_start() ->
    get_server_pid() ! {ready, 10, 600}.


cmd_close() ->
    get_server_pid() ! close.

init([]) ->
    Now = util:unixtime(),
    State = set_timer(#st_guild_answer{}, Now),
    {ok, State}.


handle_call(Request, From, State) ->
    case catch guild_answer_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("guild answer  handle_call ~p~n", [Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch guild_answer_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild answer handle_cast ~p~n", [Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch guild_answer_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("guild answer handle_info ~p~n", [Reason]),
            {noreply, State}
    end.

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
    case fetch_time(NowSec, Now) of
        false ->
            State#st_guild_answer{state = ?GUILD_ANSWER_STATE_CLOSE};
        {St, Et} ->
            Ready = St - ?GUILD_ANSWER_READY_TIME,
            if
                NowSec < Ready ->
                    Ref = erlang:send_after((Ready - NowSec) * 1000, self(), {ready, ?GUILD_ANSWER_READY_TIME, Et - St}),
                    State#st_guild_answer{ref = Ref, state = ?GUILD_ANSWER_STATE_CLOSE};
                NowSec < St ->
                    Ref = erlang:send_after((St - NowSec) * 1000, self(), {start, Et - St}),
                    State#st_guild_answer{ref = Ref, time = Date + St, state = ?GUILD_ANSWER_STATE_READY};
                true ->
                    State#st_guild_answer{state = ?GUILD_ANSWER_STATE_CLOSE}
            end
    end.



fetch_time(NowSec, Now) ->
    case [{S, E} || [S, E] <- time_list(Now), E > NowSec] of
        [] -> false;
        [{St, Et} | _] ->
            {St, Et}
    end.

time_list(Now) ->
    Week = util:get_day_of_week(Now),
    F = fun(Id) ->
        case lists:member(Week, data_guild_answer_time:get_week(Id)) of
            false -> [];
            true ->
                [[H * 3600 + M * 60 || {H, M} <- data_guild_answer_time:get_time(Id)]]
        end
        end,
    lists:flatmap(F, data_guild_answer_time:ids()).
%%    F = fun(Time) ->
%%        [H * 3600 + M * 60 || {H, M} <- Time]
%%        end,
%%    lists:map(F, ?GUILD_ANSWER_TIME_LIST).