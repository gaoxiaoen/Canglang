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
    Account = io:get_line('Input you account:'),
    ok = gen_tcp:send(Socket,term_to_binary(Account)),
    send_chat(Socket).

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



