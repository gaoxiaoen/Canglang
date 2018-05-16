%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_feixian_lian_cost
	%%% @Created : 2018-05-03 16:44:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_feixian_lian_cost).
-export([get/1]).
-include("xian.hrl").

%% 替换属性元宝消耗 
get(0) -> 20;
get(1) -> 100;
get(2) -> 200;
get(3) -> 400;
get(4) -> 800;
get(5) -> 1200;
get(6) -> 2200;
get(7) -> 3000;
get(_attr_color) -> [].

