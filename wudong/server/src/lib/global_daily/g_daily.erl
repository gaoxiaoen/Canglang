%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 10. 三月 2015 14:53
%%%-------------------------------------------------------------------
-module(g_daily).
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
    night_clear/0,
    cmd_test/0
]).

%%获取类型计数
get_count(Type) ->
    case ets:lookup(?G_DAILY_ETS,Type) of
        [] -> 0;
        [GDaily|_] -> GDaily#g_daily.count
    end.

%%设置计数
%%返回旧计数
set_count(Type,Count) ->
    OldCount = get_count(Type),
    Date = util:unixdate(),
    ets:insert(?G_DAILY_ETS,#g_daily{type=Type,count=Count,time = Date}),
    g_daily_load:replace(Type,Count,Date),
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

%%零点更新
night_clear() ->
    ets:delete_all_objects(?G_DAILY_ETS),
    g_daily_load:del_all(),
    ok.

cmd_test()->
    ets:insert(?G_DAILY_ETS,#g_daily{type=1,count=1}),
    g_daily_load:replace(1,1,util:unixdate()),
    ok.