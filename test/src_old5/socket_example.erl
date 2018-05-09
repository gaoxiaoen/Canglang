%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 16:02
%%%-------------------------------------------------------------------
-module(socket_example).
-author("Administrator").

%% API
-export([nano_get_url/0]).

nano_get_url() ->
    nano_get_url("www.baidu.com").

nano_get_url(Host) ->
    {ok,Socket} = gen_tcp:connect(Host,80,[binary,{packet,0}]),
    ok = gen_tcp:send(Socket,"Get / HTTP/1.0\r\n\r\n"),
    receive_data(Socket,[]).
receive_data(Socket,SoFar) ->
    receive
        {tcp,Socket,Bin} ->
            receive_data(Socket,[Bin|SoFar])
%%        {tcp_close,Socket} ->
%%            list_to_binary(reverse(SoFar))
    end.

