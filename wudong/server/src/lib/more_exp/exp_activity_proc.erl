%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 15:36
%%%-------------------------------------------------------------------
-module(exp_activity_proc).
-author("luobq").
%% API
-behaviour(gen_server).

-include("more_exp.hrl").
-include("common.hrl").
-include("server.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    time_list/0
]).

-record(state, {
    ref = undefined
}).
-define(SERVER, ?MODULE).
-define(MORE_EXP_READY_TIME, 300).

%% API
-export([
    start_link/0
    , more_exp_reward/0
    , reset/1
    , cmd_start/0
    , cmd_close/0
    , cmd_reset/0
    , more_exp_info/0
    , check_more_exp_state/1
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


reset(NowTime) ->
    get_server_pid() ! {reset, NowTime}.

cmd_reset() ->
    get_server_pid() ! {reset, util:unixtime()}.

cmd_start() ->
    Now = util:unixtime(),
    Data = #base_more_exp_time{start_time = Now, end_time = Now + 3600, reward = 5},
    notice_sys:add_notice(more_exp_activity_open, []),
    get_server_pid() ! {start, Data}.

cmd_close() ->
    get_server_pid() ! {close}.

init([]) ->
    Now = util:unixtime(),
    {ok, set_timer(#state{}, Now)}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info({reset, NowTime}, State) ->
    util:cancel_ref([State#state.ref]),
    NewState = set_timer(State, NowTime),
    {noreply, NewState};

%%准备
handle_info({ready, ReadyTime, Data}, State) ->
    ets:delete(?ETS_MORE_EXP, 0),
    util:cancel_ref([State#state.ref]),
    ets:insert(?ETS_MORE_EXP, Data#base_more_exp_time{id = 0}),
    {ok, Bin} = pt_432:write(43267, {1, ReadyTime}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(ReadyTime * 1000, self(), {start, Data}),
    TimerHandle = erlang:send_after(600 * 1000, self(), {notice}),
    put(notice, TimerHandle),
    notice_sys:add_notice(more_exp_activity_open_before, []),
    {noreply, State#state{ref = Ref}};

handle_info({start, Data}, State) ->
    ets:delete(?ETS_MORE_EXP, 0),
    util:cancel_ref([State#state.ref]),
    ets:insert(?ETS_MORE_EXP, Data#base_more_exp_time{id = 0}),
    Time = Data#base_more_exp_time.end_time - Data#base_more_exp_time.start_time,
    {ok, Bin} = pt_432:write(43267, {2, Time}),
    server_send:send_to_all(Bin),
    Ref = erlang:send_after(Time * 1000, self(), {close}),
    TimerHandle = erlang:send_after(600 * 1000, self(), {notice}),
    put(notice, TimerHandle),
    update_more_exp_info(2, Data#base_more_exp_time.reward, Data#base_more_exp_time.end_time),
    notice_sys:add_notice(more_exp_activity_open, []),
    {noreply, State#state{ref = Ref}};

%%多倍活动结束
handle_info({close}, State) ->
    misc:cancel_timer(notice),
    util:cancel_ref([State#state.ref]),
    ets:delete(?ETS_MORE_EXP, 0),
    {ok, Bin} = pt_432:write(43267, {0, 0}),
    server_send:send_to_all(Bin),
    NewState = set_timer(State, util:unixtime()),
    update_more_exp_info(0, 1, 0),
    {noreply, NewState};

handle_info({notice}, State) ->
    misc:cancel_timer(notice),
    TimerHandle = erlang:send_after(600 * 1000, self(), {notice}),
    put(notice, TimerHandle),
    {noreply, State};

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
    case [{Id, S, E} || {Id, [S, E]} <- time_list(), E > NowSec] of
        [] ->
            State;
        TimeList ->
            {Id, Star, End} = hd(TimeList),
            Base = data_more_exp_time:get(Id),
            NewBase = Base#base_more_exp_time{id = 0, start_time = Date + Star, end_time = Date + End},
            ReadyTime = Star - ?MORE_EXP_READY_TIME,
            if NowSec < Star ->
                if
                    NowSec < ReadyTime ->
                        Ref = erlang:send_after((ReadyTime - NowSec) * 1000, self(), {ready, ?MORE_EXP_READY_TIME, NewBase}),
                        State#state{ref = Ref};
                    true ->
                        Ref = erlang:send_after((Star - NowSec) * 1000, self(), {start, NewBase}),
                        State#state{ref = Ref}
                end;
                true ->
                    ets:insert(?ETS_MORE_EXP, NewBase),
                    Ref = erlang:send_after((End - NowSec) * 1000, self(), {close}),
                    State#state{ref = Ref}
            end
    end.

time_list() ->
    F = fun(Id) ->
        Base = data_more_exp_time:get(Id),
        {Id, [H * 3600 + M * 60 || {H, M} <- Base#base_more_exp_time.time]}
    end,
    lists:map(F, data_more_exp_time:ids()).

%%获取奖励倍数
more_exp_reward() ->
    case ets:lookup(?ETS_MORE_EXP, 0) of
        [] -> 1;
        [MoreExp] ->
            MoreExp#base_more_exp_time.reward
    end.

more_exp_info() ->
    case ets:lookup(?ETS_MORE_EXP, 0) of
        [] ->
            {0, 0};
        [MoreExp] ->
            StartTime = MoreExp#base_more_exp_time.start_time,
            Now = util:unixtime(),
            if
                StartTime =< Now ->
                    {2, MoreExp#base_more_exp_time.end_time - util:unixtime()};
                true ->
                    {1, MoreExp#base_more_exp_time.start_time - util:unixtime()}
            end
    end.

check_more_exp_state(Sid) ->
    case ets:lookup(?ETS_MORE_EXP, 0) of
        [] ->
            skip;
        [MoreExp] ->
            Time = MoreExp#base_more_exp_time.end_time - util:unixtime(),
            {ok, Bin} = pt_432:write(43267, {1, Time}),
            server_send:send_to_sid(Sid, Bin)
    end.

update_more_exp_info(State, Award, EndTime) ->
    Pids = ets:match(?ETS_ONLINE, #ets_online{pid = '$1', _ = '_'}),
    F = fun([Pid]) ->
         Pid ! {update_more_exp_info,State, Award, EndTime}
    end,
    [F(Pid) || Pid <- Pids].

