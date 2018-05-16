%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_time
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_time).
-export([ids/0]).
-export([get/1]).
-export([get_limit_open_day/0]).
-include("common.hrl").

    
ids() -> [7].
    
get(7)->{[7],[{20,30},{21,00}]};
get(_) -> [].
get_limit_open_day() -> 3.
