%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_refine
	%%% @Created : 2017-07-10 11:07:54
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_refine).
-export([get_all/0]).
-export([get/1]).
-include("error_code.hrl").
-include("equip.hrl").
get(1) -> #base_equip_refine{type = 1, goods_id = 2011000, attrs = [{att,10}]};
get(2) -> #base_equip_refine{type = 2, goods_id = 2012000, attrs = [{def,10}]};
get(3) -> #base_equip_refine{type = 3, goods_id = 2013000, attrs = [{hp_lim,100}]};
get(_) -> #base_equip_refine{}.

    get_all() ->
    [1,2,3].
