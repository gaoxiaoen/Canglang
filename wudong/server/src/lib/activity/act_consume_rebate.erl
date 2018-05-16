%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 9:46
%%%-------------------------------------------------------------------
-module(act_consume_rebate).
-author("hxming").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    logout/0,
    timer_update/0,
    midnight_refresh/1,
    add_consume/2,

    get_act_info/1,
    recv/2,
    get_state/1,
    get_act/0
]).

init(#player{key = Pkey} = Player) ->
    StConsumeRebate =
        case player_util:is_new_role(Player) of
            true -> #st_act_consume_rebate{pkey = Pkey};
            false -> activity_load:dbget_act_consume_rebate(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_CONSUME_REBATE, StConsumeRebate),
    update_act(),
    Player.

logout() ->
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    if StConsumeRebate#st_act_consume_rebate.is_change /= 1 -> skip;
        true ->
            activity_load:dbup_act_consume_rebate(StConsumeRebate)
    end.

timer_update() ->
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    if StConsumeRebate#st_act_consume_rebate.is_change /= 1 -> skip;
        true ->
            activity_load:dbup_act_consume_rebate(StConsumeRebate),
            lib_dict:put(?PROC_STATUS_ACT_CONSUME_REBATE, StConsumeRebate#st_act_consume_rebate{is_change = 0})
    end.


%%@TODO 统计累计消费值 DAILY_PLAYER_CONSUME
update_act() ->
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    #st_act_consume_rebate{
        pkey = Pkey,
        op_time = OpTime
    } = StConsumeRebate,
    case get_act() of
        [] ->
            NewStConsumeRebate = #st_act_consume_rebate{pkey = Pkey, is_change = 1};
        ActType ->
            Now = util:unixtime(),
            Flag = util:is_same_date(OpTime, Now),
            if
                Flag == true ->
                    NewStConsumeRebate =
                        StConsumeRebate#st_act_consume_rebate{
                            act_id = ActType, is_change = 1
                        };
                true ->
                    NewStConsumeRebate =
                        #st_act_consume_rebate{
                            pkey = Pkey,
                            act_id = ActType,
                            op_time = Now,
                            is_change = 1
                        }
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_CONSUME_REBATE, NewStConsumeRebate).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_act().

get_act_info(_Player) ->
    update_act(),
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    #st_act_consume_rebate{
        recv_list = RecvList,
        acc_consume = AccConsume
    } = StConsumeRebate,
    case get_act() of
        [] ->
            {0, 0, []};
        ActType ->
            Ids = data_act_consume_rebate:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_act_consume_rebate:get(Id)
                 end,
            BaseConsumeList = lists:map(F0, Ids),
            LTime = max(0, ?ONE_DAY_SECONDS - util:get_seconds_from_midnight()),
            F = fun({BaseConsume, RewardList}) ->
                case lists:member(BaseConsume, RecvList) of
                    false ->
                        Status = ?IF_ELSE(AccConsume >= BaseConsume, 1, 0),
                        [BaseConsume, Status, util:list_tuple_to_list(RewardList)];
                    _ ->
                        [BaseConsume, 2, util:list_tuple_to_list(RewardList)]
                end
                end,
            List = lists:map(F, BaseConsumeList),
            {LTime, AccConsume, List}
    end.

recv(Player, BaseConsume) ->
    update_act(),
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    #st_act_consume_rebate{
        recv_list = RecvList,
        acc_consume = AccConsume
    } = StConsumeRebate,
    case get_act() of
        [] ->
            {4, Player};
        ActType ->
            Ids = data_act_consume_rebate:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_act_consume_rebate:get(Id)
                 end,
            BaseConsumeList = lists:map(F0, Ids),
            Flag = lists:member(BaseConsume, RecvList),
            case lists:keyfind(BaseConsume, 1, BaseConsumeList) of
                false ->
                    {0, Player};
                {_, RewardList} ->
                    if
                        Flag == true -> {10, Player}; %% 已经领取
                        AccConsume < BaseConsume -> {11, Player}; %% 金额不达标，还不能领取
                        true ->
                            GiveGoodsList = goods:make_give_goods_list(781, RewardList),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStConsumeRebate =
                                StConsumeRebate#st_act_consume_rebate{
                                    recv_list = [BaseConsume | RecvList],
                                    op_time = util:unixtime(),
                                    is_change = 1
                                },
                            lib_dict:put(?PROC_STATUS_ACT_CONSUME_REBATE, NewStConsumeRebate),
                            activity:get_notice(Player, [33], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    #st_act_consume_rebate{
        recv_list = RecvList,
        acc_consume = AccConsume
    } = StConsumeRebate,
    case get_act() of
        [] ->
            -1;
        ActType ->
            Ids = data_act_consume_rebate:get_ids_by_actType(ActType),
            F0 = fun(Id) ->
                data_act_consume_rebate:get(Id)
                 end,
            BaseList = lists:map(F0, Ids),
            F = fun({BaseConsume, _RewardList}) ->
                case lists:member(BaseConsume, RecvList) of
                    false ->
                        ?IF_ELSE(AccConsume >= BaseConsume, [1], []);
                    _ ->
                        []
                end
                end,
            List = lists:flatmap(F, BaseList),
            ?IF_ELSE(List == [], 0, 1)
    end.

add_consume(_Player, Gold) ->
    StConsumeRebate = lib_dict:get(?PROC_STATUS_ACT_CONSUME_REBATE),
    NewStConsumeRebate =
        StConsumeRebate#st_act_consume_rebate{
            acc_consume = StConsumeRebate#st_act_consume_rebate.acc_consume + Gold,
            is_change = 1
        },
    lib_dict:put(?PROC_STATUS_ACT_CONSUME_REBATE, NewStConsumeRebate).

get_act() ->
    OpenDay = config:get_open_days(),
    get_act(OpenDay).
get_act(OpenDay) ->
    case ets:lookup(?ETS_ACT_OPEN_INFO, OpenDay) of
        [] -> [];
        [#ets_act_info{act_info = ActInfo}] ->
            case lists:keyfind(?ACT_ACC_CONSUME, 1, ActInfo) of
                false -> [];
                {_Act, ActType} -> ActType
            end
    end.