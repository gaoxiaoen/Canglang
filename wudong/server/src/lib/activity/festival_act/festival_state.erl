%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 九月 2017 15:28
%%%-------------------------------------------------------------------
-module(festival_state).
-author("Administrator").
-include("common.hrl").
-include("server.hrl").
%% API
-export([
    send_all/1,
    get_state/2,
    get_notice/2]).

-define(ALL_LIST, lists:seq(1, 13)).

%% 1 双倍充值
%% 2 道具兑换
%% 3 每日任务
%% 4 累充有礼
%% 5 水果大战
%% 6 在线有礼
%% 7 登陆有礼
%% 8 充值有礼
%% 9 疯狂抢购
%% 10 幸运翻牌
%% 11 红包雨
%% 12 财神挑战
%% 13 节日boss


get_state(Player, Ids) ->
    F = fun(ActId) ->
        StateRes =
            case ActId of
                1 -> catch double_gold:get_state();
                2 -> catch festival_exchange:get_state(Player);
                3 -> catch act_daily_task:get_state(Player);
                4 -> catch festival_acc_charge:get_state(Player);
                5 -> catch act_throw_fruit:get_state(Player);
                6 -> catch online_reward:get_state(Player);
                7 -> catch festival_login_gift:get_state();
                8 -> catch recharge_inf:get_state(Player);
                9 -> catch festival_back_buy:get_state(Player);
                10 -> catch act_flip_card:get_state(Player);
                11 -> catch festival_red_gift:get_state();
                12 -> catch festival_challenge_cs:get_state(Player);
                13 -> catch act_festive_boss:get_state(Player)
            end,
        [[ActId, StateRes]]
    end,
    lists:flatmap(F, Ids).

get_notice(Player, IdList) ->
    Data = festival_state:get_state(Player, IdList),
    ?DEBUG("data ~p~n", [Data]),
    {ok, Bin} = pt_438:write(43899, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin).

send_all(Player) ->
    festival_state:get_notice(Player, ?ALL_LIST).





