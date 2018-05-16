%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dun_jiandao_goods
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dun_jiandao_goods).
-export([get_price_by_goodsId_buyNum/2]).
-include("dungeon.hrl").
get_price_by_goodsId_buyNum(40003, 1) -> 200;
get_price_by_goodsId_buyNum(40003, 2) -> 200;
get_price_by_goodsId_buyNum(40003, 3) -> 200;
get_price_by_goodsId_buyNum(40003, 4) -> 400;
get_price_by_goodsId_buyNum(40003, 5) -> 400;
get_price_by_goodsId_buyNum(40003, 6) -> 600;
get_price_by_goodsId_buyNum(40003, 7) -> 600;
get_price_by_goodsId_buyNum(40003, 8) -> 800;
get_price_by_goodsId_buyNum(40003, 9) -> 1000;
get_price_by_goodsId_buyNum(40003, 10) -> 2000;
get_price_by_goodsId_buyNum(_GoodsId, _BuyNum) -> [].
