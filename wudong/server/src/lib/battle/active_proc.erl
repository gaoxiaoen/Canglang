%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 九月 2017 15:09
%%%-------------------------------------------------------------------
-module(active_proc).
-author("hxming").

-include("common.hrl").

%% gen_server callbacks
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3,
    cmd_set/2
]).

-record(state, {
    open_day = 0,
    merge_day = 0,
    active_list = []
}).
-define(SERVER, ?MODULE).

%% API
-export([
    start_link/0,
    get_server_pid/0,
    login/0,
    get_active/1
]).

cmd_set(Sec, Last) ->
    get_server_pid() ! {cmd_set, Sec, Last}.

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

login() ->
    get_server_pid() ! login.

get_active(Default) ->
    case config:is_center_node() of
        true -> Default;
        false ->
            ?CALL(get_server_pid(), {active, Default})
    end.
init([]) ->
    self() ! init,
    erlang:send_after(300 * 1000, self(), timer),
    {ok, #state{}}.


handle_call({active, Default}, _From, State) ->
    Ret =
        if State#state.open_day =< 2 -> Default;
            State#state.merge_day > 0 andalso State#state.merge_day =< 2 -> Default;
            true ->
                SecondDay =
                    case lists:keyfind(2, 1, State#state.active_list) of
                        false -> 0;
                        {_, V} -> V
                    end,
                NDay =
                    case lists:keyfind(State#state.open_day - 1, 1, State#state.active_list) of
                        false -> 1;
                        {_, V1} -> V1
                    end,
                min(Default, round(Default / (SecondDay + 1) * NDay))
        end,
    {reply, Ret, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.


handle_info(init, State) ->
    OpenDay = config:get_open_days(),
    MergeDay = get_merge_day(),
    ActiveList = active_list(OpenDay),
    {noreply, State#state{open_day = OpenDay, merge_day = MergeDay, active_list = ActiveList}};

handle_info({reset, _NowTime}, State) ->
    OpenDay = config:get_open_days(),
    MergeDay = get_merge_day(),
    ActiveList = [{OpenDay, ets:info(ets_online, size)} | lists:keydelete(OpenDay, 1, State#state.active_list)],
    {noreply, State#state{open_day = OpenDay, merge_day = MergeDay, active_list = ActiveList}};

handle_info(timer, State) ->
    erlang:send_after(300 * 1000, self(), timer),
    case lists:keyfind(State#state.open_day, 1, State#state.active_list) of
        false -> skip;
        {_, Login} ->
            Sql = io_lib:format("replace into active set open_day=~p,login=~p", [State#state.open_day, Login]),
            db:execute(Sql)
    end,
    {noreply, State};

handle_info(login, State) ->
    ActiveList =
        case lists:keytake(State#state.open_day, 1, State#state.active_list) of
            false -> [{State#state.open_day, 1} | State#state.active_list];
            {value, {_, Count}, T} ->
                [{State#state.open_day, Count + 1} | T]
        end,
    {noreply, State#state{active_list = ActiveList}};

handle_info({cmd_set, Sec, Last}, State) ->
    L1 =
        case lists:keytake(2, 1, State#state.active_list) of
            false -> [{2, Sec} | State#state.active_list];
            {value, _, T} ->
                [{2, Sec} | T]
        end,
    L2 =
        case lists:keytake(State#state.open_day - 1, 1, L1) of
            false -> [{State#state.open_day - 1, Last} | L1];
            {value, _, T2} ->
                [{State#state.open_day - 1, Last} | T2]
        end,
    {noreply, State#state{active_list = L2}};

handle_info(_Request, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
get_merge_day() ->
    case db:get_all("select time from merge_info ") of
        [] -> 0;
        TimeList ->
            MaxTime = lists:max([Time || [Time] <- TimeList]),
            util:diff_day(MaxTime) + 1
    end.


active_list(OpenDay) ->
    case db:get_all("select open_day ,login from active ") of
        [] ->
            Midnight = util:get_today_midnight(),
            F = fun(Day) ->
                Time = Midnight - (OpenDay - Day) * ?ONE_DAY_SECONDS,
                Sql = io_lib:format("select count(*) from log_login where time = ~p", [Time]),
                case db:get_one(Sql) of
                    null -> [];
                    Count ->
                        replace(Day, Count),
                        [{Day, Count}]
                end
                end,
            lists:flatmap(F, lists:seq(1, OpenDay));
        L ->
            [list_to_tuple(Item) || Item <- L]
    end.

replace(Day, Login) ->
    Sql = io_lib:format("replace into active set open_day=~p,login=~p", [Day, Login]),
    db:execute(Sql).