%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%  登录服的设置，验证玩家登录
%%% @end
%%% Created : 09. 五月 2018 17:10
%%%-------------------------------------------------------------------
-module(login_server).
-author("Administrator").

%% API
-export([start_parrallel/0,loop/1]).

%% 使用tcp设置服务器连接
start_parrallel() ->
    {ok,Listen} = gen_tcp:listen(1234,[binary,{packet,4},
        {reuseaddr,true},
        {active,true}]),
    spawn(fun()->par_connect(Listen) end).

par_connect(Listen) ->
    {ok,Socket} = gen_tcp:accept(Listen),
    spawn(fun() -> par_connect(Listen) end),
    loop(Socket).

loop(Socket) ->
    receive
        {tcp,Socket,{account,Bin}} ->
            Str = binary_to_term(Bin),
            io:format("Server receive ~p ~n",[Str]),
            CStr = io_lib:format("welcome ~p",[Str]),
            gen_tcp:send(Socket,{login_ack,term_to_binary(CStr)});

        {tcp_closed,Socket} ->
            io:format("Server socket closed ~n")
    end,
    loop(Socket).


%%close()->
%%    gen_tcp:close(Listen).

%%start() ->
%%    spawn(login_server,loop,["loginserver"]).


%%
%%loop(AppName) ->
%%    receive
%%        {Client,{login,Name}} ->
%%            io:format("~p: ~p login success ~n",[AppName,Name]),
%%            Client ! {self(),{ret_login,io:format(" ~p login success ~n",[Name])}};
%%        {Client,{c2s,CMsg}} ->
%%            Str = binary_to_term(CMsg),
%%            io:format("~p:client say:~p ~n",[AppName,Str]),
%%            Client ! {self(),{ack_ret,"Svr have get ~n"}};
%%        {Client,Other} ->
%%            io:format("not legal input"),
%%            Client ! {self(),error,Other}
%%    end,
%%    loop(AppName).



