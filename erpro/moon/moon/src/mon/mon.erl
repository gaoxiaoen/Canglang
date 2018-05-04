%%----------------------------------------------------
%% 监控服务器命令 
%%
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(mon).
-behaviour(gen_server).
-export([
        t/0
        ,m/0
        ,connect/2
        ,rpc/2
        ,start_link/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("mon.hrl").
-record(state, {}).

t() ->
    connect("local.dev", 8000).

m() ->
    sys_code:make([{d, debug}]),
    FunStr = "fun(_Conn) ->
            sys_code:up()
    end.",
    rpc("local.dev", FunStr).

%% 在受监控的服务器上执行一个RPC调用
rpc(Host, FunStr) when is_list(FunStr) ->
    case ets:lookup(ets_mon, Host) of
        [M] ->
            M#mon.pid ! {cmd, mon_rpc, rpc, {list_to_binary(FunStr)}};
        _ ->
            {error, not_connect}
    end.

connect(Host, Port) ->
    mon_proc:create("monitor", Host, Port),
    ok.

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------

init([]) ->
    ets:new(ets_mon, [set, public, named_table, {keypos, #mon.host}]),
    State = #state{},
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------
