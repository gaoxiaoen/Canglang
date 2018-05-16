%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_godness_condition
	%%% @Created : 2018-04-16 11:17:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_godness_condition).
-export([get_cost/3]).
-export([get_pass_num/3]).
-export([get_buy_num/3]).
-include("dungeon.hrl").
get_cost(1, 1, 1) -> 0;
get_cost(1, 1, 2) -> 0;
get_cost(1, 2, 1) -> 30;
get_cost(1, 2, 2) -> 0;
get_cost(2, 1, 1) -> 0;
get_cost(2, 1, 2) -> 0;
get_cost(2, 2, 1) -> 30;
get_cost(2, 2, 2) -> 0;
get_cost(3, 1, 1) -> 0;
get_cost(3, 1, 2) -> 0;
get_cost(3, 2, 1) -> 40;
get_cost(3, 2, 2) -> 0;
get_cost(_layer, _type, _subtype) -> [].

get_pass_num(1, 1, 1) -> 6;
get_pass_num(1, 1, 2) -> 3;
get_pass_num(1, 2, 1) -> 6;
get_pass_num(1, 2, 2) -> 3;
get_pass_num(2, 1, 1) -> 6;
get_pass_num(2, 1, 2) -> 3;
get_pass_num(2, 2, 1) -> 6;
get_pass_num(2, 2, 2) -> 3;
get_pass_num(3, 1, 1) -> 6;
get_pass_num(3, 1, 2) -> 3;
get_pass_num(3, 2, 1) -> 6;
get_pass_num(3, 2, 2) -> 3;
get_pass_num(_layer, _type, _subtype) -> [].

get_buy_num(1, 1, 1) -> 3;
get_buy_num(1, 1, 2) -> 3;
get_buy_num(1, 2, 1) -> 3;
get_buy_num(1, 2, 2) -> 3;
get_buy_num(2, 1, 1) -> 3;
get_buy_num(2, 1, 2) -> 3;
get_buy_num(2, 2, 1) -> 3;
get_buy_num(2, 2, 2) -> 3;
get_buy_num(3, 1, 1) -> 3;
get_buy_num(3, 1, 2) -> 3;
get_buy_num(3, 2, 1) -> 3;
get_buy_num(3, 2, 2) -> 3;
get_buy_num(_layer, _type, _subtype) -> [].

