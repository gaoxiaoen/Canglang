%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 九月 2017 14:16
%%%-------------------------------------------------------------------
-module(festival_challenge_cs).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    get_act/0,
    get_state/1,
    get_act_info/1,
    challenge/2
]).

challenge(Player, Type) ->
    case get_act() of
        [] ->
            {Player, Type, 0, 0, 0, 0};
        #base_festival_challenge_cs{
            consume_goods_id = ConsumeGoodsId,
            consume_goods_num = ConsumeGoodsNum,
            bgold = Bgold,
            gold = Gold
        } = Base ->
            case check_challenge(Type, Player, Base) of
                {fail, Code} ->
                    {Player, Type, Code, 0, 0, 0};
                true ->
                    {ok, _} = goods:subtract_good(Player, [{ConsumeGoodsId, ConsumeGoodsNum}], 626),
                    MyNum = util:rand(2,12),
                    CsNum = util:rand(2,12),
                    if
                        MyNum == CsNum -> %% 双方猜平
                            act_daily_task:trigger_finish(Player,?CHALLENGE_CS,1),
                            if
                                Type == 1 ->
                                    NewPlayer = money:add_bind_gold(Player, -Bgold, 702, 0, 0),
                                    log(Player#player.key,0,ConsumeGoodsId, ConsumeGoodsNum,0,0),
                                    erlang:send_after(2000, self(), {festival_challenge_cs, bgold, Bgold}),
                                    {NewPlayer, Type, 1, MyNum, CsNum, Bgold};
                                true ->
                                    NewPlayer = money:add_no_bind_gold(Player, -Gold, 703, 0, 0),
                                    erlang:send_after(2000, self(), {festival_challenge_cs, gold, Gold}),
                                    log(Player#player.key,0,ConsumeGoodsId, ConsumeGoodsNum,0,0),
                                    {NewPlayer, Type, 1, MyNum, CsNum, Gold}
                            end;
                        MyNum < CsNum -> %% 财神大于我
                            NewPlayer =
                                if
                                    Type == 1 ->
                                        log(Player#player.key,-1,ConsumeGoodsId, ConsumeGoodsNum,-Bgold,0),
                                        money:add_bind_gold(Player, -Bgold, 700, 0, 0);
                                    true ->
                                        log(Player#player.key,-1,ConsumeGoodsId, ConsumeGoodsNum,0,-Gold),
                                        money:add_no_bind_gold(Player, -Gold, 701, 0, 0)
                                end,
                            act_daily_task:trigger_finish(Player,?CHALLENGE_CS,1),
                            {NewPlayer, Type, 1, MyNum, CsNum, 0};
                        true -> %% 我赢了财神
                            if
                                Type == 1 ->
                                    NewPlayer = money:add_bind_gold(Player, -Bgold, 702, 0, 0),
                                    act_daily_task:trigger_finish(Player,?CHALLENGE_CS,1),
                                    log(Player#player.key,1,ConsumeGoodsId, ConsumeGoodsNum,Bgold,0),
                                    erlang:send_after(2000, self(), {festival_challenge_cs, bgold, Bgold*2}),
                                    {NewPlayer, Type, 1, MyNum, CsNum, Bgold*2};
                                true ->
                                    NewPlayer = money:add_no_bind_gold(Player, -Gold, 703, 0, 0),
                                    act_daily_task:trigger_finish(Player,?CHALLENGE_CS,1),
                                    erlang:send_after(2000, self(), {festival_challenge_cs, gold, Gold*2}),
                                    log(Player#player.key,1,ConsumeGoodsId, ConsumeGoodsNum,0,Gold),
                                    {NewPlayer, Type, 1, MyNum, CsNum, Gold*2}
                            end
                    end
            end
    end.

log(Pkey, Result, CostGoodsId, CostGoodsNum, AddBgold, AddGold) ->
    Sql = io_lib:format("insert into log_festival_challenge_cs set pkey=~p, cost_goods_id=~p, cost_goods_num=~p,bgold=~p,gold=~p,result=~p,time=~p",
        [Pkey, CostGoodsId, CostGoodsNum, AddBgold, AddGold, Result, util:unixtime()]),
    log_proc:log(Sql).

%% type 1绑元2元宝
check_challenge(Type, Player, Base) ->
    #base_festival_challenge_cs{
        consume_goods_id = ConsumeGoodsId,
        consume_goods_num = ConsumeGoodsNum,
        bgold = Bgold,
        gold = Gold
    } = Base,
    ConsumeNum = goods_util:get_goods_count(ConsumeGoodsId),
    if
        ConsumeNum < ConsumeGoodsNum -> {fail, 15}; %% 材料不足
        true ->
            if
                Type == 1 ->
                    case money:is_enough(Player, Bgold, bgold) of
                        true ->
                            true;
                        false ->
                            {fail, 2} %% 元宝不足
                    end;
                true ->
                    case money:is_enough(Player, Gold, gold) of
                        true ->
                            true;
                        false ->
                            {fail, 2} %% 元宝不足
                    end
            end
    end.

get_act_info(_Player) ->
    case get_act() of
        [] -> {0, 0, 0, 0, 0};
        #base_festival_challenge_cs{
            consume_goods_id = ConsumeGoodsId,
            consume_goods_num = ConsumeGoodsNum,
            bgold = Bgold,
            gold = Gold,
            open_info = OpenInfo
        } ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            {LTime, ConsumeGoodsId, ConsumeGoodsNum, Bgold, Gold}
    end.

get_state(_Player) ->
    case get_act() of
        [] -> -1;
        _ -> 0
    end.

get_act() ->
    case activity:get_work_list(data_festival_act_challenge_cs) of
        [] -> [];
        [Base | _] -> Base
    end.

