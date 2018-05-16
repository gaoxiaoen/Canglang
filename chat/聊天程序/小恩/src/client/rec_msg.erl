%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 五月 2018 19:45
%%%-------------------------------------------------------------------
-module(rec_msg).
-author("Administrator").

%% API
-export([recive/0]).

recive() ->
    {ok,Socket} = gen_tcp:connect("localhost",3321,[binary,{packet,0}]),
    receive_chat(Socket).

receive_chat(Socket) ->
    receive
        {tcp,Socket,Bin} ->
            Bin2 = binary_to_term(Bin),
            Bin3 = binary_to_list(list_to_binary(Bin2)),
            io:format(" ~p ~n",[Bin3])
    end.
