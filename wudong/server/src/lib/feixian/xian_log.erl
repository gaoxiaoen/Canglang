%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十月 2017 16:56
%%%-------------------------------------------------------------------
-module(xian_log).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("xian.hrl").

%% API
-export([
    put_on_log/3,
    resolved_log/3,
    upgrade_log/5,
    go_map/1
]).

put_on_log(Pkey, Goods, OldGoods) ->
    #goods{
        goods_id = GoodsId,
        key = GoodsKey,
        goods_lv = GoodsLv,
        color = Color,
        star = Star,
        cell = Pos
    } = Goods,
    #goods{
        goods_id = OldGoodsId,
        key = OldGoodsKey0,
        goods_lv = OldGoodsLv,
        color = OldColor,
        star = OldStar
    } = OldGoods,
    OldGoodsKey = ?IF_ELSE(is_integer(OldGoodsKey0), OldGoodsKey0, 0),
    Sql = io_lib:format("insert into log_xianzhuang_put_on set pkey=~p,goods_id=~p,goods_key=~p,goods_lv=~p,color=~p,star=~p,pos=~p,old_goods_id=~p,old_goods_key=~p,old_goods_lv=~p,old_color=~p,old_star=~p,time=~p",
        [Pkey, GoodsId, GoodsKey, GoodsLv, Color, Star, Pos, OldGoodsId, OldGoodsKey, OldGoodsLv, OldColor, OldStar, util:unixtime()]),
    log_proc:log(Sql),
    ok.

resolved_log(Pkey, Goods, AddXianYu) ->
    #goods{
        goods_id = GoodsId,
        key = GoodsKey,
        goods_lv = GoodsLv,
        color = Color,
        star = Star
    } = Goods,
    Sql = io_lib:format("insert into log_xianzhuang_resolved set pkey=~p,goods_id=~p,goods_key=~p,goods_lv=~p,color=~p,star=~p,xianyu=~p,time=~p",
        [Pkey, GoodsId, GoodsKey, GoodsLv, Color, Star, AddXianYu, util:unixtime()]),
    log_proc:log(Sql),
    ok.

upgrade_log(Pkey, Goods, OldGoods, Cost, CostGold) ->
    #goods{
        goods_id = GoodsId,
        key = GoodsKey,
        goods_lv = AfterLv,
        exp = AfterExp,
        color = Color,
        star = Star
    } = Goods,
    #goods{
        goods_lv = BeforLv,
        exp = BeforExp
    } = OldGoods,
    Sql = io_lib:format("insert into log_xianzhuang_upgrade set pkey=~p,goods_key=~p,goods_id=~p,color=~p,star=~p,befor_lv=~p,befor_exp=~p,cost=~p,cost_gold=~p,after_lv=~p,after_exp=~p,time=~p",
        [Pkey, GoodsKey, GoodsId, Color, Star, BeforLv, BeforExp, Cost, CostGold, AfterLv, AfterExp, util:unixtime()]),
    log_proc:log(Sql),
    ok.

go_map([Pkey, Type, Cost, List, Reward]) ->
    Sql = io_lib:format("insert into  log_xian_map set pkey=~p,type=~p,cost=~p,list='~s',reward='~s',time=~p",
        [Pkey, Type, Cost, util:term_to_bitstring(List), util:term_to_bitstring(Reward), util:unixtime()]),
    log_proc:log(Sql),
    ok.