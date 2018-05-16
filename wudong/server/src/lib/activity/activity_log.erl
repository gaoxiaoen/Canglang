%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 活动日记，记录各活动的操作
%%% @end
%%% Created : 14. 一月 2016 下午2:28
%%%-------------------------------------------------------------------
-module(activity_log).
-author("fengzhenlin").
-include("goods.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    log_get_gift/5,  %%记录礼包领取
    log_get_goods/4  %%记录物品领取

    ,log_sell_equip/4 %% 特权炫装
    ,log_one_gold_buy/6 %% 一元抢购
    ,log_one_gold_buy_back/4 %% 一元抢购返还
    ,log_one_gold_buy_goods/4 %% 一元抢购中奖日志
    ,log_get_invest/6 %%投资计划领取
    ,log_hqg_daily_charge/3
]).

log_get_gift(Pkey,Name,GiftId,Num,From) ->
    Base = data_goods:get(GiftId),
    Sql = io_lib:format("insert into log_gift set pkey = ~p,nickname='~s',gift_id=~p,gift_num=~p,gift_name='~s',`from`=~p,`time`=~p",
        [Pkey,Name,GiftId,Num,Base#goods_type.goods_name,From,util:unixtime()]),
    log_proc:log(Sql),
    ok.

log_get_goods([], _Pkey, _Name, _From) ->
    ok;
log_get_goods([{GoodsId,Num}|Tail], Pkey,Name,From) ->
    Base = data_goods:get(GoodsId),
    Sql = io_lib:format("insert into log_gift set pkey = ~p,nickname='~s',gift_id=~p,gift_num=~p,gift_name='~s',`from`=~p,`time`=~p",
        [Pkey,Name,GoodsId,Num,Base#goods_type.goods_name,From,util:unixtime()]),
    log_proc:log(Sql),
    log_get_goods(Tail, Pkey,Name,From);
log_get_goods([GiveGoods|Tail], Pkey,Name,From) ->
    #give_goods{
        goods_id = GoodsId,
        num  = Num
    } = GiveGoods,
    Base = data_goods:get(GoodsId),
    Sql = io_lib:format("insert into log_gift set pkey = ~p,nickname='~s',gift_id=~p,gift_num=~p,gift_name='~s',`from`=~p,`time`=~p",
        [Pkey,Name,GoodsId,Num,Base#goods_type.goods_name,From,util:unixtime()]),
    log_proc:log(Sql),
    log_get_goods(Tail, Pkey,Name,From).

%% 特权炫装产出
log_sell_equip(Pkey,Name,GoodsId,Cost) ->
    Base = data_goods:get(GoodsId),
    Sql = io_lib:format("insert into log_sell_equip set pkey = ~p, nickname='~s',goods_id=~p,goods_desc='~s',cost=~p,`time`=~p",
        [Pkey,Name,GoodsId,Base#goods_type.goods_name,Cost,util:unixtime()]),
    log_proc:log(Sql),
    ok.
%% 一元抢购购买
log_one_gold_buy(Pkey, ActNum, GoodsId, BuyNum, Cost, Time) ->
    Sql = io_lib:format("insert into log_one_gold_buy set pkey = ~p, act_num=~p,goods_id=~p,buy_num=~p,cost=~p, `time`=~p",
        [Pkey,ActNum,GoodsId,BuyNum,Cost, Time]),
    log_proc:log(Sql),
    ok.
%% 一元抢购返还
log_one_gold_buy_back(Pkey, ActNum, GoodsId, BackGoldNum) ->
    Sql = io_lib:format("insert into log_one_gold_buy_back set pkey = ~p, act_num=~p,goods_id=~p,back_gold=~p,`time`=~p",
        [Pkey,ActNum,GoodsId,BackGoldNum,util:unixtime()]),
    log_proc:log(Sql),
    ok.
%% 一元抢购中奖日志
log_one_gold_buy_goods(Pkey, ActNum, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into log_one_gold_buy_goods set pkey = ~p, act_num=~p,goods_id=~p,goods_num=~p,`time`=~p",
        [Pkey,ActNum,GoodsId,GoodsNum,util:unixtime()]),
    log_proc:log(Sql),
    ok.
%% 投资计划领取奖励
log_get_invest(Pkey, ActNum, InvestGold, RecvDay, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into log_act_invest set pkey=~p, act_num=~p, recv_day=~p, invest_gold=~p, goods_id=~p, goods_num=~p, `time`=~p",
        [Pkey, ActNum, RecvDay, InvestGold, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.

%% 每日充值
log_hqg_daily_charge(Pkey, GoodsId, GoodsNum) ->
    Sql = io_lib:format("insert into log_hqg_daily_charge set pkey=~p, goods_id=~p, goods_num=~p, time=~p",
        [Pkey, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.