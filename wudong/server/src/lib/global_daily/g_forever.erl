%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 10. 三月 2015 14:53
%%%-------------------------------------------------------------------
-module(g_forever).
-author("fzl").

-include("g_daily.hrl").

%% API
-export([
    get_count/1,
    set_count/2,
    increment/1,
    decrement/1
]).

-export([
	cmd_test/2
]).

%%获取类型计数
get_count(Type) ->
    case ets:lookup(?G_FOREVER_ETS,Type) of
        [] -> 0;
        [GForever|_] -> GForever#g_forever.count
    end.

%%设置计数
%%返回旧计数
set_count(Type,Count) ->
    OldCount = get_count(Type),
    Date = util:unixdate(),
    ets:insert(?G_FOREVER_ETS,#g_forever{type=Type,count=Count,time = Date}),
	g_forever_load:replace(Type,Count,Date),
    OldCount.

%%计数加1
%%返回旧计数
increment(Type) ->
    Count = get_count(Type),
    set_count(Type,Count+1),
    Count.

%%计数减1
%%返回旧计数
decrement(Type) ->
    Count = get_count(Type),
    set_count(Type,Count-1),
    Count.

cmd_test(Type,Num)->
    ets:insert(?G_FOREVER_ETS,#g_forever{type=Type,count=Num,time = util:unixdate()}),
    g_forever_load:replace(Type,Num,util:unixdate()),
    ok.