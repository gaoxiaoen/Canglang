%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2018 17:03
%%%-------------------------------------------------------------------
-module(name_server).
-author("Administrator").
-import(server1,[rpc/2]).
%% API
-export([add/2,init/0,find/1,handle/2]).

add(Name,Place) ->
    io:format("[name] add ~n"),
    rpc(name_server,{add,Name,Place}).

find(Name) ->
    io:format("[name] find ~n"),
    rpc(name_server,{find,Name}),
    receive
        {Name,Response} ->
            io:format("[svr] response = ~p,Name=-~p ~n",[Response,Name]),
            Response
    end.

init() ->dict:new().

handle({add,Name,Place},Dict) ->
    io:format("[name] handle add ,name=~p,place=~p,dict=~p ~n",[Name,Place,Dict]),
    {ok,dict:store(Name,Place,Dict)};
handle({find,Name},Dict) ->
    io:format("[name] handle find ,name=~p,dict=~p ~n",[Name,Dict]),
    {dict:find(Name,Dict),Dict}.

