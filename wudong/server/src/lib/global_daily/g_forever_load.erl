%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 十二月 2015 17:55
%%%-------------------------------------------------------------------
-module(g_forever_load).
-author("hxming").

%% API
-compile(export_all).


get_all()->
    Sql = "select type,count,time from global_forever_count",
    db:get_all(Sql).

replace(Type,Count,Time)->
    Sql = io_lib:format(<<"replace into global_forever_count set type =~p,count=~p,time=~p">>,[Type,Count,Time]),
    db:execute(Sql).