%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2018 14:23
%%%-------------------------------------------------------------------
-module(tcp_link).
-author("Administrator").

%% API
-export([start/1]).
%% 开启服务器监听
start(Port) ->
    case(do_init(Port)) of
        {ok,ListenSocket} ->
            io:format("server start ok000!~n"),
            loop(ListenSocket);
        _Els ->
            error
    end.

do_init(Port) when is_integer(Port) ->
    Options=[binary,
        {packet, 0},
        {reuseaddr, true},
        {backlog, 1024},
        {active, true}],   %% 采用非阻塞的方式
    case gen_tcp:listen(Port, Options) of
        {ok,ListenSocket}->
            {ok,ListenSocket};
        {error,Reason} ->
            {error,Reason}
    end.

%% 循环处理客户端连接消息
loop(ListenSocket) ->
    case (gen_tcp:accept(ListenSocket,3000)) of
        {ok,Socket} ->
            pro_clientsocket(Socket),
            loop(ListenSocket);
        {error,Reason} ->
            loop(ListenSocket);
        {exit,Reason} ->
            loop(ListenSocket)

    end.

%%处理客户端连过来的连接
pro_clientsocket(Socket) ->
    io:format("client socket .. ~p ~n",[Socket]),
    role_manage:bindsocket(Socket),
    ok.



















