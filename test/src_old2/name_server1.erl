%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 五月 2018 18:10
%%%-------------------------------------------------------------------
-module(name_server1).
-author("Administrator").
-import(server3,[rpc/2]).
%% API
-export([init/0,add/2,find/1,handle/2]).

add(Name,Place) ->
    rpc(name_server,{add,Name,Place}).
find(Name) ->
    rpc(name_server,{find,Name}).

init() ->dict:new().

handle({add,Name,Place},Dict) ->{ok,dict:store(Name,Place,Dict)};
handle({find,Name,Dict},Dict) ->{dict:find(Name,Dict),Dict}.