%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2018 19:45
%%%-------------------------------------------------------------------
-module(send_msg).
-author("Administrator").

%% API
-export([send/0]).
send() ->
    {ok,Socket} = gen_tcp:connect("localhost",3321,[binary,{packet,0}]),
    send_chat(Socket).

send_chat(Socket) ->
    Account = io:get_line('Input you account:'),
    ok = gen_tcp:send(Socket,term_to_binary(Account)),
    send_chat(Socket).
