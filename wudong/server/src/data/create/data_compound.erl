%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_compound
	%%% @Created : 2017-02-17 16:15:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_compound).
-export([get/1]).
-include("equip.hrl").
get(10001) -> 
	#base_compound{id = 10001 ,type = 1 ,material = [{3104000,2}],goods = [{3105000,1}],need_coin = 5000 ,open_level = 20};
get(_) -> [].
