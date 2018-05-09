%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 五月 2018 9:50
%%%-------------------------------------------------------------------
-module(ets_test).
-author("Administrator").

%% API
-export([start/0]).

start() ->
    lists:foreach(fun test_ets/1,
        [set,ordered_set,bag,duplicate_bag]).

test_ets(Mode) ->
    TableId = ets:new(test,[Mode]),
    ets:insert(TableId,{a,1}),
    ets:insert(TableId,{b,2}),
    ets:insert(TableId,{a,1}),
    ets:insert(TableId,{b,3}),
    List = ets:tab2list(TableId),
    io:format("~-13w => ~p~n",[Mode,List]),
    ets:delete(TableId).


