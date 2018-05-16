%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 日常计数，每天晚上12点清除所有数据
%%% @end
%%% Created : 16. 一月 2015 17:10
%%%-------------------------------------------------------------------
-module(daily).
-include("server.hrl").
-include("common.hrl").
-include("daily.hrl").
%% API
-export([
    get_count/1,
    get_count/2,
    increment/2,
    decrement/2,
    set_count/2,

    get_count_outline/2,
    get_count_outline/3,
    set_count_outline/3,
    increment_count_outline/3
]).

%%内部处理接口
-export([
    daily_refresh/1
]).

%%获取计数
%%可调用进程：玩家进程
%%返回值 integer 注意：没有找到相应类型数据时，返回0
get_count(Type) ->
    get_count(Type,0).

get_count(Type,Default) ->
    Daily = lib_dict:get(?PROC_STATUS_DAILY),
    case dict:is_key(Type, Daily#st_daily_count.daily_count) of
        false -> Default;
        true ->
            dict:fetch(Type, Daily#st_daily_count.daily_count)
    end.

%%增加计数1
%%可调用进程：玩家进程
%%返回值:新计数 integer 注意：如果是新增的类型，直接计数为1
increment(Type, Count) ->
    Daily = lib_dict:get(?PROC_STATUS_DAILY),
    Dict = dict:update_counter(Type, Count, Daily#st_daily_count.daily_count),
    NewDaily = Daily#st_daily_count{daily_count = Dict, is_change = 1},
    lib_dict:put(?PROC_STATUS_DAILY, NewDaily),
    dict:fetch(Type, Dict).

%%减少计数1
%%可调用进程：玩家进程
%%返回值: 新计数 integer 注意：没有找到相应类型数据时，返回0
decrement(Type, Count) ->
    Daily = lib_dict:get(?PROC_STATUS_DAILY),
    case dict:is_key(Type, Daily#st_daily_count.daily_count) of
        false ->
            0;
        true ->
            OldCount = dict:fetch(Type, Daily#st_daily_count.daily_count),
            NewCount = if OldCount >= Count -> OldCount - Count;
                           true -> 0
                       end,
            Dict = dict:store(Type, NewCount, Daily#st_daily_count.daily_count),
            NewDaily = Daily#st_daily_count{daily_count = Dict, is_change = 1},
            lib_dict:put(?PROC_STATUS_DAILY, NewDaily),
            NewCount
    end.

%%设置计数
%%可调用进程：玩家进程
%%返回值: 旧计数 integer 注意：没有找到相应类型数据时，返回0
set_count(Type, Count) ->
    Daily = lib_dict:get(?PROC_STATUS_DAILY),
    Dict = dict:store(Type, Count, Daily#st_daily_count.daily_count),
    NewDaily = Daily#st_daily_count{daily_count = Dict, is_change = 1},
    lib_dict:put(?PROC_STATUS_DAILY, NewDaily),
    case dict:is_key(Type, Daily#st_daily_count.daily_count) of
        false -> 0;
        true ->
            dict:fetch(Type, Daily#st_daily_count.daily_count)
    end.

%%零点刷新
daily_refresh(NowTime) ->
    Date = util:unixdate(NowTime),
    Daily = lib_dict:get(?PROC_STATUS_DAILY),
    lib_dict:put(?PROC_STATUS_DAILY, Daily#st_daily_count{daily_count = dict:new(), time = Date, is_change = 1}),
    ok.

%%离线 获取类型计数
get_count_outline(Pkey, Type) ->
    case outline_get_db(Pkey) of
        [] -> 0;
        CountList ->
            case lists:keyfind(Type, 1, CountList) of
                false -> [];
                {_, Count} -> Count
            end
    end.

get_count_outline(Pkey, Type,Default) ->
    case outline_get_db(Pkey) of
        [] -> Default;
        CountList ->
            case lists:keyfind(Type, 1, CountList) of
                false -> Default;
                {_, Count} -> Count
            end
    end.


%%离线 设置计数
set_count_outline(Pkey, Type, Count) ->
    NewCountList =
        case outline_get_db(Pkey) of
            [] ->
                [{Type, Count}];
            CountList ->
                [{Type, Count}|lists:keydelete(Type, 1, CountList)]
        end,
    Sql = io_lib:format("replace into player_daily_count set pkey=~p,daily_count='~s',time=~p",
        [Pkey, util:term_to_bitstring(NewCountList), util:unixtime()]),
    db:execute(Sql),
    ok.

%%离线 增加/减少计数
increment_count_outline(Pkey, Type, Add) ->
    CountList = outline_get_db(Pkey),
    NewCountList =
        case lists:keyfind(Type, 1, CountList) of
            false ->
                [{Type, Add}|CountList];
            {_, OldCount} ->
                [{Type, Add+OldCount}|lists:keydelete(Type, 1, CountList)]
        end,
    Sql = io_lib:format("replace into player_daily_count set pkey=~p,daily_count='~s',time=~p",
        [Pkey, util:term_to_bitstring(NewCountList), util:unixtime()]),
    db:execute(Sql),
    ok.

%%获取db
outline_get_db(Pkey) ->
    Sql = io_lib:format("select daily_count,time from player_daily_count where pkey = ~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> [];
        [DailyCountBin, Time] ->
            Now = util:unixtime(),
            case util:is_same_date(Now, Time) of
                false -> [];
                true -> util:bitstring_to_term(DailyCountBin)
            end
    end.
