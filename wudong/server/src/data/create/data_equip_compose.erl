%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_compose
	%%% @Created : 2017-07-03 20:56:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_compose).
-export([get/1]).
-include("equip.hrl").
get(2601003) -> #base_equip_compose{id=2601003,  subtype=521, consume=[2602003,2603003,2604003,2605003,2606003,2607003,2608003], cost_num=3};
get(2602003) -> #base_equip_compose{id=2602003,  subtype=522, consume=[2601003,2603003,2604003,2605003,2606003,2607003,2608003], cost_num=2};
get(2603003) -> #base_equip_compose{id=2603003,  subtype=523, consume=[2601003,2602003,2604003,2605003,2606003,2607003,2608003], cost_num=2};
get(2604003) -> #base_equip_compose{id=2604003,  subtype=524, consume=[2601003,2602003,2603003,2605003,2606003,2607003,2608003], cost_num=2};
get(2605003) -> #base_equip_compose{id=2605003,  subtype=525, consume=[2601003,2602003,2603003,2604003,2606003,2607003,2608003], cost_num=2};
get(2606003) -> #base_equip_compose{id=2606003,  subtype=526, consume=[2601003,2602003,2603003,2604003,2605003,2607003,2608003], cost_num=2};
get(2607003) -> #base_equip_compose{id=2607003,  subtype=527, consume=[2601003,2602003,2603003,2604003,2605003,2606003,2608003], cost_num=2};
get(2608003) -> #base_equip_compose{id=2608003,  subtype=528, consume=[2601003,2602003,2603003,2604003,2605003,2606003,2607003], cost_num=2};
get(_id) -> [].

