%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 18:26
%%%-------------------------------------------------------------------
-module(broadcast).
-author("Administrator").

%% API
-export([send/1,listen/0]).

send(IoList) ->
    case inet:ifget("eth0",[broadaddr]) of
        {ok,[{broadaddr,Ip}]} ->
            {ok,S} = gen_udp:open(5010,[{broadcast,true}]),
            gen_udp:send(S,Ip,6000,IoList),
            gen_udp:close(S);
        _ ->
            io:format("Bad interface name,or \n"
                    "broadcasting not supported\n")
    end.

listen()->
    {ok,_} = gen_udp:open(6000),
    loop().

loop() ->
    receive
        Any ->
            io:format("received:~p~n",[Any]),
            loop()
    end.