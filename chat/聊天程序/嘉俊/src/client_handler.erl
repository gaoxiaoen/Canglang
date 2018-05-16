-module(client_handler).
-behavior(gen_server).

%% API
-export([init/1, start_link/1, handle_info/2, handle_call/3, terminate/2, handle_cast/2, code_change/3]).

-include("clientinfo.hrl").
-include("proto.hrl").

-define(Timeout, 120 * 1000).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Id) ->
    gen_server:start_link(?MODULE, Id, []).

init(Id) ->
    Client = #clientinfo{id = Id},
    {ok, Client}.


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% 处理客户端消息
handle_info({tcp, Socket, Data}, Client = #clientinfo{id = Id}) ->
    inet:setopts(Socket, [{active, once}]),

    RequestData = binary_to_term(Data),
    io:format("handler info ~p got message ~p~n", [self(), RequestData]),
    [Cmd | Param] = RequestData,
    Proto = #proto{id = Id, pid = self(), data = Param},

    case Client#clientinfo.login == 1 of
        true ->
%%            Name = Client#clientinfo.name,
%%            NewProto = Proto#proto{name = Name},
            Reply = gen_server:call(chat_room, {Cmd, Proto}),

            Binary = term_to_binary(Reply),
            gen_tcp:send(Socket, Binary),

            io:format("handler info success, request: ~p~n", [RequestData]),
            {noreply, Client, ?Timeout};
        false ->
            case Cmd of
                login ->
                    [Name, _PassWord] = Param,
                    Reply = gen_server:call(chat_room, {Cmd, #proto{id = Id, pid = self(), data = Param}}),
                    case Reply of
                        ok ->
                            NewClient = Client#clientinfo{name = Name, login = 1},
                            Ret = ok,
                            gen_tcp:send(Socket, term_to_binary(Ret)),
                            {noreply, NewClient, ?Timeout};
                        _Other ->
                            Ret = "login failed, username or passwd error",
                            gen_tcp:send(Socket, term_to_binary(Ret)),
                            {noreply, Client, ?Timeout}
                        end;
                register ->
                    [Name, _PassWord] = Param,
                    Reply = gen_server:call(chat_room, {Cmd, #proto{id = Id, pid = self(), data = Param}}),
                    case Reply of
                        ok ->
                            NewClient = Client#clientinfo{name = Name, login = 1},
                            Ret = ok,
                            gen_tcp:send(Socket, term_to_binary(Ret)),
                            {noreply, NewClient, ?Timeout};
                        _Other ->
                            Ret = "register failed",
                            gen_tcp:send(Socket, term_to_binary(Ret)),
                            {noreply, Client, ?Timeout}
                    end;

                _Other ->
                    Ret = "login first",
                    gen_tcp:send(Socket, term_to_binary(Ret)),
                    {noreply, Client, ?Timeout}
            end
    end;

%% 处理客户端断开连接
handle_info({tcp_closed, Socket}, Client = #clientinfo{id = Id}) ->
    io:format("handle info ~p client ~p disconnected~n", [self(), Socket]),
    gen_server:cast(chat_room, {offline, #proto{id = Id}}),
    {stop, normal, Client};

%% 处理客户端超时
handle_info(timeout,  Client = #clientinfo{id = Id}) ->
    io:format("handle info ~p client connection timeout~n", [self()]),
    gen_server:cast(chat_room, {offline, #proto{id = Id}}),
    {stop, normal, Client};

%% 处理聊天广播消息
handle_info({chat, Content}, Client = #clientinfo{socket = Socket}) ->
    gen_tcp:send(Socket, term_to_binary(Content)),
    {noreply, Client};


%% 绑定Socket
handle_info({bind, Socket}, Client) ->
    NewClient = Client#clientinfo{socket = Socket},
    io:format("client_handler bind socket ~n"),
    {noreply, NewClient};

handle_info(_Info, Client) ->
    io:format("handler info ingore ~p~n", [_Info]),
    {noreply, Client}.


%% 以下几个函数没用到
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
