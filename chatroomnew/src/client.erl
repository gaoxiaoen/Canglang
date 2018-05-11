%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 登录客户端端，发送昵称，请求登录到服务器
%%% @end
%%% Created : 09. 五月 2018 16:51
%%%-------------------------------------------------------------------
-module(client).
-author("Administrator").

%% API
%%-export([login/2,start/2,rpc/2]).
-export([login/0]).


login() ->
    {ok,Socket} = gen_tcp:connect("localhost",3321,[binary,{packet,0}]),
    Pid = spawn(fun()->receive_chat() end),
    gen_tcp:controlling_process(Socket,Pid),
    send_chat(Socket).

send_chat(Socket) ->
    Type = io:get_line("type:"),
    Ntype =string:tokens(Type,"\n"),
    [CType|_] = Ntype,
    io:format("type=~p~n",[CType]),
    if CType == "login" ->   %% 登录
            Arg = io:get_line("Account:"),
            send_socket(Socket,CType,Arg);
        CType == "msg" ->     %% 发消息
            Arg = io:get_line("Say:"),
            send_socket(Socket,CType,Arg);
        CType == "room" ->     %% 进入房间（如果不存在，则创建一个房间）
            Arg = io:get_line("Id:"),
            send_socket(Socket,CType,Arg);
        CType == "adm" ->   %% 转让管理员
            Arg = io:get_line("Name:"),
            send_socket(Socket,CType,Arg);
        true ->
            io:format("input..."),
            send_chat(Socket)
    end.


send_socket(Socket,Type,Arg) ->
    NArg =string:tokens(Arg,"\n"),
    [CArg|_] = NArg,
    if
        Type== "room" ->
            io:format("arg=~p~n",[CArg]),
            IArg = list_to_integer(CArg),
            if
                is_integer(IArg) ->
                    ok = gen_tcp:send(Socket,term_to_binary([Type,IArg])),
                    send_chat(Socket);
                true ->
                    io:format("input int..."),
                    send_chat(Socket)
            end;
        Type== "adm" ->
            io:format("arg=~p~n",[CArg]),
            IArg = list_to_integer(CArg),
            if
                is_integer(IArg) ->
                    ok = gen_tcp:send(Socket,term_to_binary([Type,IArg])),
                    send_chat(Socket);
                true ->
                    io:format("input int..."),
                    send_chat(Socket)
            end;
        true ->
            ok = gen_tcp:send(Socket,term_to_binary([Type,CArg])),
            send_chat(Socket)
    end.



receive_chat() ->
    receive
        {tcp,Socket,Bin} ->
            Bin2 = binary_to_term(Bin),
            Bin3 = binary_to_list(list_to_binary(Bin2)),
            io:format(" ~p ~n",[Bin3]);
        {tcp_closed, Socket} ->
            io:format("server is closed! ~n")
    end,
    receive_chat().



