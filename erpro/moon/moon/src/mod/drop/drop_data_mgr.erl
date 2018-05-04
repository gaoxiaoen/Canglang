%%----------------------------------------------------
%% Author yankai@jieyou.cn
%% Create: 2012-08-15
%% Description: 掉落系统数据管理器
%%----------------------------------------------------
-module(drop_data_mgr).
-export([
        get_prob/1
        ,get_superb/2
        ,get_normal/2
        ,get_fragile/2
        ,get_superb_items/1
        ,get_normal_items/1
        ,get_fragile_items/1
        ,career_item/2
        ,set_drop_time/6
        ,clear_drop_time/0
    ]
).

-include("common.hrl").
-include("drop.hrl").

%% 设置掉落时间（测试用）
set_drop_time(Year, Month, Day, Hour, Minute, Second) ->
    sys_env:set(drop_time, util:datetime_to_seconds({{Year, Month, Day}, {Hour, Minute, Second}})).

%% 清除掉落时间（测试用）
clear_drop_time() ->
    sys_env:set(drop_time, undefined).

get_prob(NpcId) ->
    case do_get_prob(NpcId) of
        undefined -> drop_data:get_prob(NpcId);
        Result -> Result
    end.
do_get_prob(NpcId) ->
    case use_drop_data_open(NpcId) of
        true -> drop_data:get_prob_open(NpcId);
        false ->
            case use_drop_data_act(NpcId) of
                true -> drop_data:get_prob_act(NpcId);
                false -> undefined
            end
    end.

get_superb(NpcId, ItemId) ->
    case do_get_superb(NpcId, ItemId) of
        undefined -> drop_data:get_superb(NpcId, ItemId);
        Result -> Result
    end.
do_get_superb(NpcId, ItemId) ->
    case use_drop_data_open(NpcId) of
        true -> drop_data:get_superb_open(NpcId, ItemId);
        false ->
            case use_drop_data_act(NpcId) of
                true -> drop_data:get_superb_act(NpcId, ItemId);
                false -> undefined
            end
    end.

get_normal(NpcId, ItemId) ->
    case do_get_normal(NpcId, ItemId) of
        undefined -> drop_data:get_normal(NpcId, ItemId);
        Result -> Result
    end.
do_get_normal(NpcId, ItemId) ->
    case use_drop_data_open(NpcId) of
        true -> drop_data:get_normal_open(NpcId, ItemId);
        false ->
            case use_drop_data_act(NpcId) of
                true -> drop_data:get_normal_act(NpcId, ItemId);
                false -> undefined
            end
    end.

get_fragile(NpcId, ItemId) ->
    case drop_data:get_fragile(NpcId, ItemId) of
        {false, _} -> undefined;
        Result -> Result
    end.


get_superb_items(NpcId) ->
    case do_get_superb_items(NpcId) of
        undefined -> drop_data:get_superb_items(NpcId);
        Result -> Result
    end.
do_get_superb_items(NpcId) ->
    case use_drop_data_open(NpcId) of
        true -> drop_data:get_superb_items_open(NpcId);
        false ->
            case use_drop_data_act(NpcId) of
                true -> drop_data:get_superb_items_act(NpcId);
                false -> undefined
            end
    end.

get_normal_items(NpcId) ->
    case do_get_normal_items(NpcId) of
        undefined -> drop_data:get_normal_items(NpcId);
        Result -> Result
    end.
do_get_normal_items(NpcId) ->
    case use_drop_data_open(NpcId) of
        true -> drop_data:get_normal_items_open(NpcId);
        false ->
            case use_drop_data_act(NpcId) of
                true -> drop_data:get_normal_items_act(NpcId);
                false -> undefined
            end
    end.

get_fragile_items(NpcId) ->
    case drop_data:get_fragile_items(NpcId) of
        [] -> []; %% undefined;
        Result -> Result
    end.

career_item(PresentId, Career) ->
    drop_data:career_item(PresentId, Career).

%%----------------------------------------------------------------

%% 是否使用开服掉落配置
use_drop_data_open(NpcId) ->
    case drop_data:get_time(NpcId) of
        undefined -> false;
        Time -> is_before_time(Time)
    end.

%% 是否在开服后的某个时间之内
%% Day = 开服后第几天
%% Hour,Minute,Second = 那一天的某个时刻
is_before_time({Day, Hour, Minute, Second}) ->
    case sys_env:get(srv_open_time) of
        undefined -> false;
        OpenTime ->
            %% 取开服当天的0点时间
            OpenTime0 = util:unixtime({today, OpenTime}),
            %% 计算到期时间
            LastTime = OpenTime0 + Day * 86400 + Hour * 3600 + Minute * 60 + Second,
            Now = case sys_env:get(drop_time) of
                undefined -> util:unixtime();
                Time -> Time
            end,
            case OpenTime =< Now andalso Now =< LastTime of
                true -> true;
                false -> false
            end
    end.

%% 是否使用活动掉落配置
use_drop_data_act(NpcId) ->
    case drop_data:get_period(NpcId) of
        undefined -> false;
        L -> is_in_period(L)
    end.

%% 是否在活动时间内
is_in_period(L) ->
    Now = case sys_env:get(drop_time) of
        undefined -> util:unixtime();
        Time -> Time
    end,
    do_is_in_period(L, Now).
do_is_in_period([], _) -> false;
do_is_in_period([{Time1, Time2}|T], Now) ->
    Time11 = util:datetime_to_seconds(Time1),
    Time22 = util:datetime_to_seconds(Time2),
    case Time11 =< Now andalso Now =< Time22 of
        true -> true;
        false -> do_is_in_period(T, Now)
    end.


