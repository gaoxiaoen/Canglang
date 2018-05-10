%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 登录客户端端，发送昵称，请求登录到服务器
%%% @end
%%% Created : 09. 五月 2018 16:51
%%%-------------------------------------------------------------------
-module(login_client).
-author("Administrator").

%% API
%%-export([login/2,start/2,rpc/2]).
-export([login/0]).

login() ->
    {ok,Socket} = gen_tcp:connect("localhost",3377,[binary,{packet,0}]),
    send_chat(Socket).

send_chat(Socket) ->
    Account = io:get_line('Input you account:'),
%%    if Chat =:= 'Q' ->
%%        gen_tcp:close(Socket),
%% 将这些方法，设置成一个list形式，在server哪里进行解析问题，然后，通过其他的服务方法，调用，执行相应的功能模块，包括账号检测等
    ok = gen_tcp:send(Socket,term_to_binary(Account)),
    receive
        {tcp,Socket,Bin} ->
            Bin2 = binary_to_term(Bin),
            io:format("Client received binary = ~p ~n",[Bin2])
    end,
    send_chat(Socket).


%%start(Server,Name) ->
%%    login(Server,Name).
%%
%%rpc(Server,Q) ->
%%    Server ! {self(),Q},
%%    receive
%%        {Server,{ret_login,Msg}} ->
%%            Msg,
%%            Server ! {self(),{c2s,"客户端确认收到消息"}};
%%        {Server,{ack_ret,Msg}} ->
%%            Msg
%%    end.
%%
%%login(Server,Name) ->
%%    io:format("client login is beign"),
%%    Server ! {self(),{login,Name}},
%%    receive
%%        {Server,{ret_login,Msg}} ->
%%            Msg,
%%            Server ! {self(),{c2s,"client is send"}};
%%        {Server,{ack_ret,Msg}} ->
%%            Msg
%%    end.
%%    login(Server,Name).
