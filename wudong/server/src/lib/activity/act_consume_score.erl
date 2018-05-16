%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 消费积分活动
%%% @end
%%% Created : 13. 十一月 2017 18:18
%%%-------------------------------------------------------------------
-module(act_consume_score).
-author("Administrator").
-include("activity.hrl").
-include("daily.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    get_info/1,
    get_reward/2,
    add_consume_val/3,
    get_notice_state/1
]).

add_consume_val(_AddReason, _Player, Val) ->
    daily:increment(?DAILY_PLAYER_CONSUME, Val),
%%    daily:get_count(?DAILY_PLAYER_CONSUME),
    ok.

get_notice_state(Player) ->
    case get_act() of
        [] -> -1;
        Base ->
            F = fun({Id, _GoodsId, _GoodsNum, _LimitCount, _Score}) ->
                case check_reward(Player, Id) of
                    {false, _Res} ->
                        false;
                    _ -> true
                end
            end,
            Args = activity:get_base_state(Base#base_act_consume_score.act_info),
            case lists:any(F, Base#base_act_consume_score.list) of
                true -> {1, Args};
                _ -> {0, Args}
            end
    end.

get_info(_Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0, []};
        Base ->
            F = fun({Id, GoodsId, GoodsNum, LimitCount, Score}) ->
                [Id, max(0, LimitCount - daily:get_count(?DAILY_ACT_CONSUME_SCORE(Id))), Score, GoodsId, GoodsNum]
            end,
            Data = lists:map(F, Base#base_act_consume_score.list),
            LeaveTime = activity:get_leave_time(data_act_consume_score),
            UseCount = daily:get_count(?DAILY_ACT_CONSUME_SCORE_USE),
            AllScore = daily:get_count(?DAILY_PLAYER_CONSUME),
            NowScore = AllScore - UseCount,
            {NowScore, LeaveTime, 1, 1, Base#base_act_consume_score.skip_str, Data}
    end.

get_reward(Player, Id) ->
    case check_reward(Player, Id) of
        {false, Res} -> {false, Res};
        {Id, GoodsId, GoodsNum, _LimitCount, Score} ->
            daily:increment(?DAILY_ACT_CONSUME_SCORE_USE, Score),
            daily:increment(?DAILY_ACT_CONSUME_SCORE(Id), 1),
            log_act_consume_score(Player#player.key, Player#player.nickname, Score, [{GoodsId, GoodsNum}]),
            goods:give_goods(Player, goods:make_give_goods_list(317, [{GoodsId, GoodsNum}]))
    end.

get_act() ->
    case activity:get_work_list(data_act_consume_score) of
        [] -> [];
        [Base | _] -> Base
    end.

check_reward(_Player, Id) ->
    case get_act() of
        [] -> {false, 0};
        Base ->
            case lists:keyfind(Id, 1, Base#base_act_consume_score.list) of
                {Id, _GoodsId, _GoodsNum, LimitCount, Score} ->
                    UseCount = daily:get_count(?DAILY_ACT_CONSUME_SCORE_USE),
                    AllScore = daily:get_count(?DAILY_PLAYER_CONSUME),
                    NowScore = AllScore - UseCount,
                    if
                        NowScore < Score -> {false, 19};
                        true ->
                            Count = max(0, LimitCount - daily:get_count(?DAILY_ACT_CONSUME_SCORE(Id))),
                            if
                                Count =< 0 -> {false, 16};
                                true ->
                                    {Id, _GoodsId, _GoodsNum, LimitCount, Score}
                            end
                    end
            end
    end.


log_act_consume_score(Pkey, Nickname, Score, GoodsList) ->
    Sql = io_lib:format("insert into  log_act_consume_score (pkey, nickname,score,goods_list,time) VALUES(~p,'~s',~p,'~s',~p)",
        [Pkey, Nickname, Score, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql),
    ok.
