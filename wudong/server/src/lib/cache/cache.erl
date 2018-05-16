%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 一月 2015 下午4:27
%%%-------------------------------------------------------------------
-module(cache).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0]).

-export([
    set/2,
    set/3,
    get/1,
    erase/1,
    cmd_find/1
]).
-include("common.hrl").

-define(CACHE_EXPIRE_TIME, 3600). %%1小时
-define(TICK_TIME, 2000). %%2秒
-define(CACHE_KEY_LIST, cache_key_list).

set(Key, Value) ->
    set(Key, Value, ?CACHE_EXPIRE_TIME).

set(Key, Value, ExpireTime) ->
    ?CAST(get_cache_pid(), {priv_put, [Key, Value, ExpireTime]}).

get(Key) ->
    ?CALL(get_cache_pid(), {priv_get, [Key]}).

erase(Key) ->
    ?CAST(get_cache_pid(), {priv_erase, [Key]}).

cmd_find(Key) ->
    get_cache_pid() ! {cmd_find, Key}.

get_cache_pid() ->
    case erlang:get(?PROC_GLOBAL_CACHE) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            case misc:whereis_name(local, ?MODULE) of
                Pid when is_pid(Pid) ->
                    erlang:put(?PROC_GLOBAL_CACHE, Pid),
                    Pid;
                _ ->
                    undefined
            end
    end.


start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ====================================================================
%% Behavioural functions
%% ====================================================================
-record(state, {pid = none}).

%% ====================================================================
init([]) ->
    Pid = self(),
    erlang:send_after(?TICK_TIME, Pid, 'TICK'),
    {ok, #state{pid = Pid}}.

%% ====================================================================
handle_call({priv_get, [Key]}, _from, State) ->
    Reply = priv_get(Key),
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% ====================================================================
handle_cast({priv_put, [Key, Value, ExpireTime]}, State) ->
    priv_put(Key, Value, ExpireTime),
    {noreply, State};

handle_cast({priv_erase, [Key]}, State) ->
    priv_erase(Key),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.


%% ====================================================================
handle_info('TICK', State) ->
    tick(util:unixtime()),
    erlang:send_after(?TICK_TIME, State#state.pid, 'TICK'),
    {noreply, State};


handle_info({cmd_find, Key}, State) ->
    KeyList = erlang:get(?CACHE_KEY_LIST),
    io:format("KeyList ~p~n", [length(KeyList)]),
    case lists:keyfind(Key, 1, KeyList) of
        false ->
            io:format("no find");
        {_, Time} ->
            io:format("Time ~p~n", [Time])
    end,
    {noreply, State};


handle_info(_Info, State) ->
    {noreply, State}.


%% ====================================================================
terminate(_Reason, _State) ->
    ok.


%% ====================================================================
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%% ====================================================================
%% Internal functions
%% ====================================================================

get_cache_key_list() ->
    case erlang:get(?CACHE_KEY_LIST) of
        undefined -> [];
        List when is_list(List) ->
            List;
        _ -> []
    end.

priv_put(Key, Value, StoreTime) ->
    Now = util:unixtime(),
    ExpireTime = if StoreTime > 86400 -> Now + 86400;true -> Now + StoreTime end,
    Keys = get_cache_key_list(),
    case lists:keytake(Key, 1, Keys) of
        false ->
            erlang:put(?CACHE_KEY_LIST, [{Key, ExpireTime} | Keys]);
        {value, _, T} ->
            erlang:put(?CACHE_KEY_LIST, [{Key, ExpireTime} | T])
    end,
    erlang:put(Key, Value).

priv_get(Key) ->
    Keys = get_cache_key_list(),
    case lists:keymember(Key, 1, Keys) of
        false ->
            erlang:erase(Key),
            [];
        true ->
            case erlang:get(Key) of
                undefined ->
                    [];
                V -> V
            end
    end.

priv_erase(Key) ->
    Keys = get_cache_key_list(),
    case lists:keytake(Key, 1, Keys) of
        false ->
            ok;
        {value, _, T} ->
            erlang:put(?CACHE_KEY_LIST, T)
    end,
    erlang:erase(Key).



tick(Now) ->
    Keys = get_cache_key_list(),
    [ExpireList, Available] = tick_t(Keys, Now, [], []),
    tick_del(ExpireList),
    erlang:put(?CACHE_KEY_LIST, Available).

tick_t([], _time, ExpireList, Available) -> [ExpireList, Available];
tick_t([{K, Ex} | L], Time, ExpireList, Available) when Time < Ex ->
    tick_t(L, Time, ExpireList, [{K, Ex} | Available]);
tick_t([{K, Ex} | L], Time, ExpireList, Available) ->
    tick_t(L, Time, [{K, Ex} | ExpireList], Available).


tick_del([]) -> ok;
tick_del([{Key, _V} | Tail]) ->
    erlang:erase(Key),
    tick_del(Tail).





