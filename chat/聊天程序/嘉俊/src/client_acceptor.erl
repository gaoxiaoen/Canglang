-module(client_acceptor).

-behaviour(gen_server).

%% API
-export([start_link/1,accept_loop/1]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).
-define(Timeout, 120 * 1000).

-define(TCP_OPTIONS, [binary, {packet, 0}, {reuseaddr, true},
    {keepalive, true}, {backlog, 1024}, {active, false}]).

-record(state, {lsock = none}).

start_link(Port) ->
    gen_server:start_link({local,?MODULE}, ?MODULE, Port, []).

%% ===================================================================
%% API functions
%% ===================================================================

%% 开始进行监听
init(Port)->
    process_flag(trap_exit, true),
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {ok, ListenSocket} ->
            State = #state{lsock = ListenSocket},
            io:format("listen success~n"),
            gen_server:cast(self(), {start_accept}),
            {ok, State};
        {error, Reason} ->
            io:format("listen failed ~p~n", [Reason]),
            {stop, Reason}
    end.

%% 循环accept客户端连接
handle_cast({start_accept}, #state{lsock = ListenSocket}) ->
    accept_loop(ListenSocket).

%%accept client connection
accept_loop(ListenSocket)->
    case (gen_tcp:accept(ListenSocket))of
        {ok,Socket} ->
            inet:setopts(Socket, [{active, once}]),
            process_clientSocket(Socket),
            accept_loop(ListenSocket);
        {error,_Reason} ->
            accept_loop(ListenSocket);
        {exit,_Reason}->
            accept_loop(ListenSocket)
    end.

%% 新建一个客户端进行处理客户端的请求信息
process_clientSocket(Socket)->
    Record = chat_room:newClient(),
    chat_room:bindPid(Record, Socket).


%% 以下几个函数没用到
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_info(_Info, State) ->
    {noreply, State}.