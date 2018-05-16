%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 五月 2018 9:47
%%%-------------------------------------------------------------------
-module(merge_act_acc_consume).
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
    StMergeActAccConsume =
        case player_util:is_new_role(Player) of
            true -> #st_merge_act_acc_consume{pkey = Pkey, is_change = 1};
            false -> activity_load:dbget_merge_act_acc_consume(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_CONSUME, StMergeActAccConsume),
    update_merge_act_acc_consume(),
    Player.

logout() ->
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    if StMergeActAccConsume#st_merge_act_acc_consume.is_change /= 1 -> skip;
        true ->
            activity_load:dbup_merge_act_acc_consume(StMergeActAccConsume)
    end.

timer_update() ->
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    if StMergeActAccConsume#st_merge_act_acc_consume.is_change /= 1 -> skip;
        true ->
            activity_load:dbup_merge_act_acc_consume(StMergeActAccConsume),
            lib_dict:put(?PROC_STATUS_MERGE_ACT_CONSUME, StMergeActAccConsume#st_merge_act_acc_consume{is_change = 0})
    end.

update_merge_act_acc_consume() ->
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    #st_merge_act_acc_consume{
        pkey = Pkey,
        act_id = ActId
    } = StMergeActAccConsume,
    case get_act() of
        [] ->
            NewStMergeActAccConsume = #st_merge_act_acc_consume{pkey = Pkey, is_change = 1};
        #base_merge_acc_consume{act_id = BaseActId} ->
            Now = util:unixtime(),
            if
                BaseActId =/= ActId ->
                    NewStMergeActAccConsume = #st_merge_act_acc_consume{pkey = Pkey, act_id = BaseActId, op_time = Now, is_change = 1};
                true ->
                    NewStMergeActAccConsume = StMergeActAccConsume
            end
    end,
    lib_dict:put(?PROC_STATUS_MERGE_ACT_CONSUME, NewStMergeActAccConsume).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_merge_act_acc_consume().

get_act_info(_Player) ->
    update_merge_act_acc_consume(),
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    #st_merge_act_acc_consume{
        recv_list = RecvList,
        acc_consume = AccConsumeGold
    } = StMergeActAccConsume,
    case get_act() of
        [] ->
            {0, 0, []};
        #base_merge_acc_consume{
            consume_list = BaseConsumeList,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            F = fun({BaseAccConsumeGold, GiftId}) ->
                case lists:member(BaseAccConsumeGold, RecvList) of
                    false ->
                        Status = ?IF_ELSE(AccConsumeGold >= BaseAccConsumeGold, 1, 0),
                        [BaseAccConsumeGold, GiftId, Status];
                    _ ->
                        [BaseAccConsumeGold, GiftId, 2]
                end
                end,
            List = lists:map(F, BaseConsumeList),
            {LTime, AccConsumeGold, List}
    end.

recv(Player, BaseConsumeGold) ->
    update_merge_act_acc_consume(),
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    #st_merge_act_acc_consume{
        recv_list = RecvList,
        acc_consume = AccConsumeGold
    } = StMergeActAccConsume,
    case get_act() of
        [] ->
            {4, Player};
        #base_merge_acc_consume{consume_list = BaseConsumeList} ->
            Flag = lists:member(BaseConsumeGold, RecvList),
            case lists:keyfind(BaseConsumeGold, 1, BaseConsumeList) of
                false ->
                    {0, Player};
                {_BaseConsumeGold, GiftId} ->
                    if
                        Flag == true -> {10, Player}; %% 已经领取
                        AccConsumeGold < BaseConsumeGold -> {11, Player}; %% 累充金额不达标，还不能领取
                        true ->
                            GiveGoodsList = goods:make_give_goods_list(782, [{GiftId, 1}]),
                            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
                            NewStMergeActAccConsume =
                                StMergeActAccConsume#st_merge_act_acc_consume{
                                    recv_list = [BaseConsumeGold | RecvList],
                                    op_time = util:unixtime(),
                                    is_change = 1
                                },
                            lib_dict:put(?PROC_STATUS_MERGE_ACT_CONSUME, NewStMergeActAccConsume),
                            activity:get_notice(Player, [46], true),
                            {1, NewPlayer}
                    end
            end
    end.

get_state(_Player) ->
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    #st_merge_act_acc_consume{
        recv_list = RecvList,
        acc_consume = AccConsumeGold
    } = StMergeActAccConsume,
    case get_act() of
        [] ->
            -1;
        #base_merge_acc_consume{
            consume_list = BaseConsumeList
        } ->
            F = fun({BaseAccConsumeGold, _GiftId}) ->
                case lists:member(BaseAccConsumeGold, RecvList) of
                    false ->
                        ?IF_ELSE(AccConsumeGold >= BaseAccConsumeGold, [1], []);
                    _ ->
                        []
                end
                end,
            List = lists:flatmap(F, BaseConsumeList),
            ?IF_ELSE(List == [], 0, 1)
    end.

add_consume(_Player, ConsumeGold) ->
    StMergeActAccConsume = lib_dict:get(?PROC_STATUS_MERGE_ACT_CONSUME),
    #st_merge_act_acc_consume{acc_consume = AccConsumeGold} = StMergeActAccConsume,
    case get_act() of
        [] ->
            skip;
        _ ->
            NewStMergeActAccConsume = StMergeActAccConsume#st_merge_act_acc_consume{acc_consume = AccConsumeGold + ConsumeGold, is_change = 1},
            lib_dict:put(?PROC_STATUS_MERGE_ACT_CONSUME, NewStMergeActAccConsume)
    end.

get_act() ->
    case activity:get_work_list(data_merge_acc_consume) of
        [] -> [];
        [Base | _] -> Base
    end.