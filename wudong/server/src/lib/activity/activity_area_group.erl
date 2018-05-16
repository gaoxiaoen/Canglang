%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 六月 2017 13:58
%%%-------------------------------------------------------------------
-module(activity_area_group).
-author("luobq").
-include("server.hrl").
-include("common.hrl").
%% API
-export([
    get_sort_group_list/2
    , get_group_list/2
    , get_sn_group/2
    , init_area_group/2
    , midnight_refresh_area_list/0
    , midnight_refresh_area_list/2
    , init_area_group_all/0
    , get_id_list/2
]).

get_sort_group_list(_Mod, ActName) ->
    case ets:lookup(?ETS_AREA_GROUP, ActName) of
        [] -> [];
        [#ets_area_group{
            id_list = IdList
        }] ->
            IdList
    end.

get_group_list(_Mod, ActName) ->
    case ets:lookup(?ETS_AREA_GROUP, ActName) of
        [] -> [];
        [#ets_area_group{
            group_list = GroupLsit
        }] ->
            GroupLsit
    end.

get_id_list(_Mod, ActName) ->
    case ets:lookup(?ETS_AREA_GROUP, ActName) of
        [] -> [];
        [#ets_area_group{
            id_list = IdList
        }] ->
            IdList
    end.

%% 获取分组
get_sn_group(Sn, GroupLsit) ->
    case lists:keyfind(Sn, 1, GroupLsit) of
        false -> 0;
        {Sn, Group} ->
            Group
    end.


init_area_group_all() ->
    activity_area_group:init_area_group(data_area_consume_rank, area_consume_rank),
    activity_area_group:init_area_group(data_area_recharge_rank, area_recharge_rank),
    activity_area_group:init_area_group(data_cross_consume_rank, cross_consume_rank),
    activity_area_group:init_area_group(data_cross_recharge_rank, cross_recharge_rank),
    activity_area_group:init_area_group(data_cross_flower, cross_flower),
    activity_area_group:init_area_group(data_cross_act_wishing_well, cross_act_wishing_well),
    spawn(fun() -> util:sleep(8000), area_consume_rank_proc:cmd_refresh() end),
    spawn(fun() -> util:sleep(8000), area_recharge_rank_proc:cmd_refresh() end),
    spawn(fun() -> util:sleep(8000), cross_consume_rank_proc:cmd_refresh() end),
    spawn(fun() -> util:sleep(8000), cross_recharge_rank_proc:cmd_refresh() end),
    spawn(fun() -> util:sleep(8000), cross_flower_proc:cmd_refresh() end),
    ok.

%% 初始化分区
init_area_group(_Mod, ActName) ->
    IsCenterAll = center:is_center_all(),
    if
        IsCenterAll -> {IdList, GroupLsit} = activity_load:dbget_activity_area_group(ActName),
            if
                IdList == [] orelse IdList == [0] ->
                    midnight_refresh_area_list(ActName);
                true ->
                    Ets = #ets_area_group{
                        activity_name = ActName,
                        id_list = IdList,
                        group_list = GroupLsit
                    },
                    ets:insert(?ETS_AREA_GROUP, Ets)
            end;
        true -> skip
    end.

midnight_refresh_area_list() ->
    activity_area_group:midnight_refresh_area_list(data_area_consume_rank, area_consume_rank),
    activity_area_group:midnight_refresh_area_list(data_area_recharge_rank, area_recharge_rank),
    activity_area_group:midnight_refresh_area_list(data_cross_consume_rank, cross_consume_rank),
    activity_area_group:midnight_refresh_area_list(data_cross_recharge_rank, cross_recharge_rank),
    activity_area_group:midnight_refresh_area_list(data_cross_flower, cross_flower),
    ok.

%% 刷新区域分组
midnight_refresh_area_list(Mod, ActName) ->
    case activity:get_work_list(Mod) of
        [] -> midnight_refresh_area_list(ActName);
        _ ->
            Day = activity:get_start_day(Mod),
            if
                Day == 1 -> %% 新活动重置跨服区域
                    midnight_refresh_area_list(ActName);
                true -> skip
            end
    end.

midnight_refresh_area_list(ActName) ->
    AreaList = center:get_cross_area_group_list(),
    ?DEBUG("AreaList ~p~n", [AreaList]),
    F = fun({_Node, ServerList0}, {Num, List, NumList0}) ->
        F0 = fun(ServerNum, List0) ->
            [{ServerNum, Num} | List0]
        end,
        ServerList = lists:foldl(F0, [], ServerList0),
        {Num + 1, ServerList ++ List, [Num | NumList0]}
    end,
    {_, GroupLsit, IdList} = lists:foldl(F, {1, [], []}, AreaList),
    NewIdList = util:list_filter_repeat([0 | IdList]), %% 添加默认 0 分组
    Ets = #ets_area_group{
        activity_name = ActName,
        id_list = NewIdList,
        group_list = GroupLsit
    },
    ets:delete(?ETS_AREA_GROUP, ActName),
    ets:insert(?ETS_AREA_GROUP, Ets),
    activity_load:dbreplace_activity_area_group(ActName, NewIdList, GroupLsit).

%% 刷新区域分组
%% 防止活动配置错误
%% refresh_area_list(Mod, ActName) ->
%%     case activity:get_work_list(Mod) of
%%         [] -> -1;
%%         _ ->
%%             midnight_refresh_area_list(ActName),
%%             AreaList = center:get_cross_area_group_list(),
%%             F = fun({_Node, ServerList0}, {Num, List, NumList0}) ->
%%                 F0 = fun(ServerNum, List0) ->
%%                     [{ServerNum, Num} | List0]
%%                 end,
%%                 ServerList = lists:foldl(F0, [], ServerList0),
%%                 {Num, ServerList ++ List, [Num | NumList0]}
%%             end,
%%             {_, GroupLsit, IdList} = lists:foldl(F, {1, [], []}, AreaList),
%%             NewIdList = util:list_filter_repeat([0 | IdList]), %% 添加默认 0 分组
%%             Ets = #ets_area_group{
%%                 activity_name = ActName,
%%                 id_list = NewIdList,
%%                 group_list = GroupLsit
%%             },
%%             ets:delete(?ETS_AREA_GROUP, ActName),
%%             ets:insert(?ETS_AREA_GROUP, Ets),
%%             activity_load:dbreplace_activity_area_group(ActName, NewIdList, GroupLsit)
%%     end.
