%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 记录玩家每日充值数据
%%% @end
%%% Created : 09. 十月 2017 11:47
%%%-------------------------------------------------------------------
-module(act_charge).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    update_act_charge/0,
    midnight_refresh/1,
    add_charge/1,
    get_charge_list/0,
    get_charge_gold/0
]).

get_charge_list() ->
    StActCharge = lib_dict:get(?PROC_STATUS_ACT_CHARGE),
    StActCharge#st_act_charge.charge_list.

get_charge_gold() ->
    StActCharge = lib_dict:get(?PROC_STATUS_ACT_CHARGE),
    lists:sum(StActCharge#st_act_charge.charge_list).

init(#player{key = Pkey} = Player) ->
    StActCharge =
        case player_util:is_new_role(Player) of
            true -> #st_act_charge{pkey = Pkey};
            false -> activity_load:dbget_act_charge(Pkey)
        end,
%%     Sql = io_lib:format("select base_gold from recharge where app_role_id=~p and state=0 and time>=~p", [Pkey, util:unixdate()]),
%%     NewStActCharge =
%%         case db:get_all(Sql) of
%%             Rows when is_list(Rows) ->
%%                 F = fun([ChargeGold]) ->
%%                     ChargeGold
%%                 end,
%%                 ChargeList = lists:map(F, Rows),
%%                 StActCharge#st_act_charge{charge_list = ChargeList, op_time = util:unixtime()};
%%             _ ->
%%                 StActCharge
%%         end,
    lib_dict:put(?PROC_STATUS_ACT_CHARGE, StActCharge),
    update_act_charge(),
    Player.

update_act_charge() ->
    StActCharge = lib_dict:get(?PROC_STATUS_ACT_CHARGE),
    #st_act_charge{
        pkey = Pkey,
        op_time = OpTime
    } = StActCharge,
    Now = util:unixtime(),
    Flag = util:is_same_date(Now, OpTime),
    if
        Flag == false ->
            NewStActCharge = #st_act_charge{pkey = Pkey, op_time = Now};
        true ->
            NewStActCharge = StActCharge
    end,
    lib_dict:put(?PROC_STATUS_ACT_CHARGE, NewStActCharge).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_act_charge().

add_charge(ChargeGold) ->
    StActCharge = lib_dict:get(?PROC_STATUS_ACT_CHARGE),
    #st_act_charge{charge_list = ChargeList} = StActCharge,
    NewStActCharge =
        StActCharge#st_act_charge{
            op_time = util:unixtime(),
            charge_list = [ChargeGold | ChargeList]
        },
    lib_dict:put(?PROC_STATUS_ACT_CHARGE, NewStActCharge),
    activity_load:dbup_act_charge(NewStActCharge).
