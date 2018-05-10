%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 登录客户端端，发送昵称，请求登录到服务器
%%% @end
%%% Created : 09. 五月 2018 16:51
%%%-------------------------------------------------------------------
-module(login_start).
-author("Administrator").

%% API
%%-export([login/2,start/2,rpc/2]).
-export([login/0]).

login() ->
    {ok,Socket} = gen_tcp:connect("localhost",3321,[binary,{packet,0}]),
    send_chat(Socket).

send_chat(Socket) ->
    Account = io:get_line('Input you account:'),
    ok = gen_tcp:send(Socket,term_to_binary(Account)),
    receive
        {tcp,Socket,Bin} ->
            Bin2 = binary_to_term(Bin),
            io:format("Client received binary = ~p ~n",[Bin2])
    end,
    send_chat(Socket).


