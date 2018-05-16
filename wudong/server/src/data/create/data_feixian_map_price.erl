%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_map_price
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_map_price).
-export([get_price/2]).
-export([get_reward_list/2]).
-include("xian.hrl").
get_price(1,1) -> 288;
get_price(1,10) -> 2600;
get_price(2,1) -> 388;
get_price(2,10) -> 3500;
get_price(_type, _num) -> [].

get_reward_list(1,1) -> [{7405001,1}];
get_reward_list(1,10) -> [{7405001,10}];
get_reward_list(2,1) -> [{7405001,1}];
get_reward_list(2,10) -> [{7405001,10}];
get_reward_list(_type, _num) -> [].

