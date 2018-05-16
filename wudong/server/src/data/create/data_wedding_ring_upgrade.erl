%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wedding_ring_upgrade
	%%% @Created : 2016-08-22 14:20:24
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wedding_ring_upgrade).
-export([get/1]).
-include("equip.hrl").
  get(37171) -> #wedding_ring_upgrade{get_goods_id = 371175,need_coin = 371175,need_goods = [{371174,50}],exchange_goods = [{371174,10}]};
  get(37172) -> #wedding_ring_upgrade{get_goods_id = 371176,need_coin = 371176,need_goods = [{371174,50}],exchange_goods = [{371174,10}]};
  get(371173) -> #wedding_ring_upgrade{get_goods_id = 371178,need_coin = 371178,need_goods = [{371174,50}],exchange_goods = [{371174,10}]};
get(_) -> [].
