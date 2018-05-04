%%----------------------------------------------------
%% 上次登录IP缓存
%% @author 
%% @end
%%----------------------------------------------------
-module(last_ip_cache).
-behaviour(gen_server).
-export([
        start_link/0,
        is_last_ip/2,
        set_ip/2,
        clear/0,
        stop/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {}).
-include("common.hrl").

%% is_blocked(Account, Ip) -> true | false
%% @doc 是否被封禁的IP
is_last_ip(Account, Ip) ->
     case catch ets:lookup(?MODULE, Account) of
        [{_, Ip}|_] -> true;
        [_|_] -> false;
        [] -> false;
        _Err -> ?ERR("查询是否上次登录ip时发生错误:~w", [_Err]), false
    end.

%% -> any()
set_ip(Account, Ip) ->
    case catch ets:insert(?MODULE, {Account, Ip}) of
        true -> ok;
        _Err -> ?ERR("写入上次登录ip时发生错误:~w", [_Err]), error
    end.

%% -> any()
clear() ->
    catch ets:delete_all_objects(?MODULE).

%% stop() -> stop
%% @doc 停止
stop() ->
    ?MODULE ! stop.

% --------------------------------------------

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ets:new(?MODULE, [set, named_table, public, {keypos, 1}]),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(stop, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

