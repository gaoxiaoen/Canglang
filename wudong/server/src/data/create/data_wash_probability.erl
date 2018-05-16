%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_probability
	%%% @Created : 2016-09-13 15:34:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_probability).
-export([get/1]).
-include("error_code.hrl").
get(1) ->[8500,500,500,500];
get(2) ->[1000,8000,500,500];
get(3) ->[2500,2500,5000,1000];
get(4) ->[1000,3000,3000,3000];
get(_Data) -> throw({false,0}).