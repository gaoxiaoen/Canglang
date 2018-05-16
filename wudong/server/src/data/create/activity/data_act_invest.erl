%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_act_invest
	%%% @Created : 2017-10-30 09:57:25
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_act_invest).
-export([get/1]).
-export([get_max_actNum/0]).
-export([get_cost_by_actNum/1]).
-include("invest.hrl").
get(1) -> #base_act_invest{id = 1, gift_id = 8300491};
get(2) -> #base_act_invest{id = 2, gift_id = 8300492};
get(3) -> #base_act_invest{id = 3, gift_id = 8300493};
get(4) -> #base_act_invest{id = 4, gift_id = 8300494};
get(5) -> #base_act_invest{id = 5, gift_id = 8300495};
get(6) -> #base_act_invest{id = 6, gift_id = 8300496};
get(7) -> #base_act_invest{id = 7, gift_id = 8300497};
get(8) -> #base_act_invest{id = 8, gift_id = 8301491};
get(9) -> #base_act_invest{id = 9, gift_id = 8301492};
get(10) -> #base_act_invest{id = 10, gift_id = 8301493};
get(11) -> #base_act_invest{id = 11, gift_id = 8301494};
get(12) -> #base_act_invest{id = 12, gift_id = 8301495};
get(13) -> #base_act_invest{id = 13, gift_id = 8301496};
get(14) -> #base_act_invest{id = 14, gift_id = 8301497};
get(_Data) -> [].

get_cost_by_actNum(1) -> 888;
get_cost_by_actNum(2) -> 1988;
get_cost_by_actNum(_) -> 1988.
get_max_actNum() -> 2.
