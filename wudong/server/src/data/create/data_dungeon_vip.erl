%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_vip
	%%% @Created : 2017-11-13 17:30:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_vip).
-export([get/1]).
-export([ids/0]).
-include("dungeon.hrl").

    ids() ->
    [56001,56002,56003,56004,56005,56006].
get(56001) ->
	#base_dun_vip{dun_id = 56001 ,pass_goods = {{8001101,1}} ,drop_goods = {{}} ,show_goods = {{1501000,1},{2003000,1},{3105000,1}} ,vip_lv = 1 ,count = 1 };
get(56002) ->
	#base_dun_vip{dun_id = 56002 ,pass_goods = {{8001102,1}} ,drop_goods = {{}} ,show_goods = {{3104000,1},{1502000,1},{1503000,1}} ,vip_lv = 3 ,count = 1 };
get(56003) ->
	#base_dun_vip{dun_id = 56003 ,pass_goods = {{8001103,1}} ,drop_goods = {{}} ,show_goods = {{3106000,1},{3204000,1},{1504000,1}} ,vip_lv = 6 ,count = 1 };
get(56004) ->
	#base_dun_vip{dun_id = 56004 ,pass_goods = {{8001104,1}} ,drop_goods = {{}} ,show_goods = {{3205000,1},{1505000,1},{1506000,1}} ,vip_lv = 9 ,count = 1 };
get(56005) ->
	#base_dun_vip{dun_id = 56005 ,pass_goods = {{8001105,1}} ,drop_goods = {{}} ,show_goods = {{3304000,1},{3305000,1},{1507000,1}} ,vip_lv = 12 ,count = 1 };
get(56006) ->
	#base_dun_vip{dun_id = 56006 ,pass_goods = {{8001105,1}} ,drop_goods = {{}} ,show_goods = {{3304000,1},{3305000,1},{1507000,1}} ,vip_lv = 15 ,count = 1 };
get(_) -> [].
