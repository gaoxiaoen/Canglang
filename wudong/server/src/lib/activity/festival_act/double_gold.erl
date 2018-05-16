%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 双倍充值(活动)
%%% @end
%%% Created : 25. 九月 2017 17:07
%%%-------------------------------------------------------------------
-module(double_gold).
-author("Administrator").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").
-include("activity.hrl").
%% API
-export([
    get_state/0,
    add_recharge/2,
    get_state_all/0,
    get_mul/0
]).

add_recharge(Player, Val) ->
    case get_act() of
        [] -> skip;
        Base ->
            Count = daily:get_count(?DAILY_DOUBLE_GOLD),
            if
                Count > 0 -> skip;
                true ->
                    daily:set_count(?DAILY_DOUBLE_GOLD, 1),
                    Content = io_lib:format(?T("上仙，这是您多倍充值活动奖励，不要忘了查收附件哦"), []),
                    mail:sys_send_mail([Player#player.key], ?T("多倍充值奖励发送"), Content, [{10199, max(0,util:floor(Val * (Base#base_double_gold.mul - 1)))}]),
                    festival_state:send_all(Player)
            end
    end.
get_state_all() ->
    case get_act() of
        [] -> -1;
        #base_double_gold{act_info = ActInfo} ->
            Count = daily:get_count(?DAILY_DOUBLE_GOLD),
            LeaveTime = activity:get_leave_time(data_double_gold),
            Args = activity:get_base_state(ActInfo),
            ?IF_ELSE(Count =< 0, {1, [{time, LeaveTime}] ++ Args}, {0, [{time, LeaveTime}] ++ Args})
    end.
get_state() ->
    case get_act() of
        [] -> -1;
        _ ->
            Count = daily:get_count(?DAILY_DOUBLE_GOLD),
            ?DEBUG("double Count ~p~n", [Count]),
            ?IF_ELSE(Count =< 0, 1, 0)
    end.

get_act() ->
    case activity:get_work_list(data_double_gold) of
        [] -> [];
        [Base | _] -> Base
    end.

get_mul() ->
    case get_act() of
        [] -> [2, 0, 0];
        Base ->
            [2,1, util:floor(Base#base_double_gold.mul *10)]
    end.
