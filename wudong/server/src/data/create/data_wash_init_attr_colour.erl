%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_init_attr_colour
	%%% @Created : 2016-09-13 15:34:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_init_attr_colour).
-export([get/1]).
-include("error_code.hrl").
get(1) ->[100,0,0,0];
get(2) ->[90,10,0,0];
get(3) ->[85,15,0,0];
get(4) ->[81,15,3,1];
get(_Data) -> throw({false,0}).