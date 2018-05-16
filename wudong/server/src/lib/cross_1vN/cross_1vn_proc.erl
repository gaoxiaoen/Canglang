%%%-----------------------0--------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2017 15:05
%%%-------------------------------------------------------------------
-module(cross_1vn_proc).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
-include("cross_1vN.hrl").
-behaviour(gen_server).

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
    cmd_show/0,
    cmd_show1/0,
    cmd_start/0,
    cmd_choose_luck_winner/0,
    cmd_fstart/0,
    cmd_reset/0,
    cmd_match/0,
    cmd_fmatch/0,
    cmd_close/0,
    cmd_final_ready/0,
    cmd_setfloor/0,
    set_timer/2,
    get_server_pid/0
]).
-define(SERVER, ?MODULE).

%%-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================
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

init([]) ->
%%     spawn(fun() -> cross_1vn_init:init_data() end),
    erlang:send_after(5000, self(), init_data),
    State = set_timer(#st_1vn{}, util:unixtime()),
    {ok, State}.

handle_call(Request, From, State) ->
    case catch cross_1vn_handle:handle_call(Request, From, State) of
        {reply, Reply, NewState} ->
            {reply, Reply, NewState};
        Reason ->
            ?ERR("cross 1vn handle_call ~p/~p~n", [Request, Reason]),
            {reply, error, State}
    end.


handle_cast(Request, State) ->
    case catch cross_1vn_handle:handle_cast(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross 1vn handle_cast ~p/ ~p~n", [Request, Reason]),
            {noreply, State}
    end.

handle_info(Request, State) ->
    case catch cross_1vn_handle:handle_info(Request, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        Reason ->
            ?ERR("cross 1vn handle_info ~p/~p~n", [Request, Reason]),
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
    NowWeek = util:get_day_of_week(Now),
    if
        NowWeek == 1 ->
            db:execute("truncate player_cross_1vn_mb "),
            db:execute("truncate player_cross_1vn_shop "),
            #st_1vn{open_state = ?CROSS_1VN_STATE_CLOSE};
        NowWeek /= 2 ->
            StBF#st_1vn{open_state = ?CROSS_1VN_STATE_CLOSE, orz_count = 0};
        true ->
            case center:is_center_area() of
                true ->
                    Ref1 = erlang:send_after(5 * 1000, self(), timer_update),
                    NowSec = util:get_seconds_from_midnight(Now),
                    [StartTime, _EndTime] = open_time(),
                    ReadyTime = StartTime - ?CROSS_1VN_READY_TIME,
                    if
                        NowSec =< ReadyTime -> %% 报名阶段
                            spawn(fun() ->
                                util:sleep(20 * 1000),
                                {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_SIGN, ReadyTime - NowSec}),
                                F = fun(Node) ->
                                    center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_SIGN, Now + ReadyTime - NowSec]),
                                    center:apply(Node, server_send, send_to_all, [Bin])
                                end,
                                lists:foreach(F, center:get_nodes())
                            end),
                            Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?CROSS_1VN_READY_TIME, 980}),
                            StBF#st_1vn{open_state = ?CROSS_1VN_STATE_SIGN, time = Now + ReadyTime - NowSec, ref = Ref, timer_update_ref = Ref1, orz_count = 0};
                        NowSec >= ReadyTime andalso NowSec =< StartTime -> %% 准备阶段
                            spawn(fun() ->
                                util:sleep(20 * 1000),
                                {ok, Bin} = pt_642:write(64200, {?CROSS_1VN_STATE_READY, StartTime - NowSec}),
                                F = fun(Node) ->
                                    center:apply(Node, cross_1vn_util, set_act_state, [?CROSS_1VN_STATE_READY, Now + StartTime - NowSec]),
                                    center:apply(Node, server_send, send_to_all, [Bin])
                                end,
                                lists:foreach(F, center:get_nodes())
                            end),
                            Ref = erlang:send_after((StartTime - NowSec) * 1000, self(), {start, 980}),
                            StBF#st_1vn{open_state = ?CROSS_1VN_STATE_READY, time = Now + StartTime - NowSec, ref = Ref, timer_update_ref = Ref1, orz_count = 0};
                        true ->
                            StBF#st_1vn{open_state = ?CROSS_1VN_STATE_CLOSE, orz_count = 0}
                    end;
                _ -> StBF#st_1vn{open_state = ?CROSS_1VN_STATE_CLOSE, orz_count = 0}
            end
    end.

open_time() ->
%%     TimeList = [{22, 53}, {23, 38}, {21, 30}, {22, 35}],
    TimeList = data_cross_1vn_time:open_time(),
    [H * 3600 + M * 60 || {H, M} <- TimeList].


%%-------------cmd-------------

cmd_show() ->
    get_server_pid() ! show,
    ok.
cmd_show1() ->
    get_server_pid() ! show1,
    ok.


cmd_start() ->
    get_server_pid() ! {ready, 5, 980},
    ok.
cmd_reset() ->
    get_server_pid() ! reset,
    ok.
cmd_close() ->
    get_server_pid() ! close,
    ok.
cmd_choose_luck_winner() ->
    get_server_pid() ! choose_luck_winner,
    ok.
cmd_final_ready() ->
    get_server_pid() ! final_ready,
    ok.
cmd_match() ->
    get_server_pid() ! cross_1vn_match,
    ok.
cmd_fmatch() ->
    get_server_pid() ! cross_1vn_final_match,
    ok.
cmd_setfloor() ->
    get_server_pid() ! cross_1vn_set_floor,
    ok.
cmd_fstart() ->
    get_server_pid() ! {final_start, 30 * 60},
    ok.

%%-------------cmd-------------
