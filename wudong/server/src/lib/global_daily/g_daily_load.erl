%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 十二月 2015 17:55
%%%-------------------------------------------------------------------
-module(g_daily_load).
-author("hxming").

%% API
-compile(export_all).

del_all()->
    Sql = "truncate global_daily_count",
    db:execute(Sql).

get_all()->
    Sql = "select type,count,time from global_daily_count",
    db:get_all(Sql).

replace(Type,Count,Time)->
    Sql = io_lib:format(<<"replace into global_daily_count set type =~p,count=~p,time=~p">>,[Type,Count,Time]),
    db:execute(Sql).