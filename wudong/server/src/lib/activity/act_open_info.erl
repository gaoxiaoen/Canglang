%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 七月 2017 11:26
%%%-------------------------------------------------------------------
-module(act_open_info).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init_ets/0,
    sys_midnight_refresh/0,
    logout/0,

    gm_refresh/0,
    time/0
]).

time() ->
    OpenDay = config:get_open_days(),
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] ->
            sys_midnight_refresh();
        _ ->
            ok
    end.

logout() ->
    OpenDay = config:get_open_days(),
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] -> skip;
        [Ets] ->
            activity_load:dbup_act_info(Ets)
    end.

init_ets() ->
    ets:new(?ETS_ACT_OPEN_INFO, [{keypos, #ets_act_info.open_day} | ?ETS_OPTIONS]),
    spawn(fun() -> timer:sleep(2000), init_data() end),
    ok.

init_data() ->
    OpenDay = config:get_open_days(),
    case activity_load:dbget_act_info(OpenDay) of
        [] ->
            sys_midnight_refresh();
        ActInfo ->
            ActList = lists:map(fun({Id, _ActType}) -> Id end, ActInfo),
            NewAddList = ?ACT_INFO_LIST -- ActList,
            F = fun(Act) ->
                case get_act_info(OpenDay, Act) of
                    [] -> [];
                    ActType ->
                        ?IF_ELSE(ActType == 0, [], [{Act, ActType}])
                end
                end,
            AddActInfo = lists:flatmap(F, NewAddList),
            ets:insert(?ETS_ACT_OPEN_INFO, #ets_act_info{open_day = OpenDay, act_info = ActInfo ++ AddActInfo})
    end.

gm_refresh() ->
    sys_midnight_refresh(),
    ok.

sys_midnight_refresh() ->
    OpenDay = config:get_open_days(),
    F = fun(Act) ->
        case get_act_info(OpenDay, Act) of
            [] -> [];
            ActType ->
                ?IF_ELSE(ActType == 0, [], [{Act, ActType}])
        end
        end,
    ActInfo = lists:flatmap(F, ?ACT_INFO_LIST),
    ets:insert(?ETS_ACT_OPEN_INFO, #ets_act_info{open_day = OpenDay, act_info = ActInfo}).

get_act_info(OpenDay, ?ACT_UP_TARGET_ONE) ->
    case data_up_target_time:get(OpenDay) of
        #base_up_target_time{act_type_list1 = ActTypeList} when ActTypeList /= [] ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList);
        _ -> []
    end;
get_act_info(OpenDay, ?ACT_UP_TARGET_TWO) ->
    case data_up_target_time:get(OpenDay) of
        #base_up_target_time{act_type_list2 = ActTypeList} when ActTypeList /= [] ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList);
        _ -> []
    end;
get_act_info(OpenDay, ?ACT_UP_TARGET_THREE) ->
    case data_up_target_time:get(OpenDay) of
        #base_up_target_time{act_type_list3 = ActTypeList} when ActTypeList /= [] ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList);
        _ -> []
    end;

get_act_info(OpenDay, ?ACT_BACK_BUY) ->
    case data_act_back_buy_time:get(OpenDay) of
        [] -> [];
        ActTypeList ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList)
    end;

get_act_info(OpenDay, ?ACT_UPLV_BOX) ->
    case data_uplv_box_time:get(OpenDay) of
        [] -> [];
        ActTypeList ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList)
    end;

get_act_info(OpenDay, ?ACT_ACC_CHARGE) ->
    case data_act_acc_charge_time:get(OpenDay) of
        [] -> [];
        ActTypeList ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList)
    end;

get_act_info(OpenDay, ?ACT_ACC_CONSUME) ->
    case data_act_consume_rebate_time:get(OpenDay) of
        [] -> [];
        ActTypeList ->
            Index0 = OpenDay rem (length(ActTypeList)),
            ?IF_ELSE(Index0 == 0, Index = length(ActTypeList), Index = OpenDay rem (length(ActTypeList))),
            lists:nth(Index, ActTypeList)
    end;
get_act_info(_, _) -> [].