%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 服务器回调函数
%%% @end
%%% Created : 07. 五月 2018 17:04
%%%-------------------------------------------------------------------
-module(name_server).
-author("Administrator").

-import(server3,[rpc/2]).
%% API
-export([init/0,add/2,find/1,handle/2]).


all_names() ->rpc(name_server,allNames).

add(Name,Place) ->
    rpc(name_server,{add,Name,Place}).
find(Name) ->
    rpc(name_server,{find,Name}).

%% 回调方法
init() ->
    dict:new().
handle({add,Name,Place},Dict) ->
    {ok,dict:store(Name,Place,Dict)};
handle({find,Name},Dict) ->
    {dict:find(Name,Dict),Dict}.



