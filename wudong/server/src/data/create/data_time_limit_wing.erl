%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_time_limit_wing
	%%% @Created : 2017-10-27 12:12:50
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_time_limit_wing).
-export([get/0]).
-include("wing.hrl").
get() -> #base_time_limit_wing{open_lv = 20, close_lv = 40, cost = 300, time = 3600, charge=300}.