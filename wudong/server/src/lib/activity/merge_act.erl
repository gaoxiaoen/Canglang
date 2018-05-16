%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 合服活动列表
%%% @end
%%% Created : 05. 七月 2016 下午7:52
%%%-------------------------------------------------------------------
-module(merge_act).
-author("fengzhenlin").
-include("common.hrl").
-include("activity.hrl").
-include("server.hrl").

%% API
-export([
    get_merge_act/2
]).

get_merge_act(Player, ActId) ->
    TypeList = act_rank:get_type_list(),
    TypeList1 = lists:reverse([Type+90||Type<-TypeList]),
    case TypeList1 of
        [] -> L1 = [],L2 = [];
        [Type1|L2] -> L1 = [Type1]
    end,
    case ActId of
        0 -> get_act(Player, [23, 24, 11] ++ L1 ++ [25, 26] ++ L2);
        _ -> get_act(Player, [ActId])
    end.

get_act(Player, ActIdList) ->
    F = fun(ActId) ->
            Res =
            case ActId of
                11 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_buy_state(),-1);
                14 -> ?IF_ELSE(activity:is_merge_act(data_lim_shop),lim_shop:get_state(),-1);
                23 -> ?IF_ELSE(activity:is_merge_act(data_merge_sign_in),merge_sign_in:get_state(Player),-1);
                24 -> ?IF_ELSE(activity:is_merge_act(data_charge_mul),charge_mul:get_state(Player),-1);
                25 -> guild_rank:get_state(Player);
                26 -> ?IF_ELSE(activity:is_merge_act(data_target_act),target_act:get_state(Player),-1);
                91 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                92 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                93 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                94 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                95 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                96 -> ?IF_ELSE(activity:is_merge_act(data_act_rank),act_rank:get_rank_state(ActId-90),-1);
                _ -> -1
            end,
            case Res of
                [State, LeaveTime] -> [ActId, State, LeaveTime];
                State -> [ActId, State, 1]
            end
        end,
    ActList = lists:map(F, ActIdList),
    {ok, Bin} = pt_432:write(43299, {ActList}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.