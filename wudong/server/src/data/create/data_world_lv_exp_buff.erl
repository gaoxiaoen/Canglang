%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_world_lv_exp_buff
	%%% @Created : 2017-10-23 10:57:21
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_world_lv_exp_buff).
-export([get/1]).
-include("server.hrl").
get(Lv)when Lv>=0 andalso Lv=<3->0;
get(Lv)when Lv>=4 andalso Lv=<6->0.1;
get(Lv)when Lv>=7 andalso Lv=<10->0.3;
get(Lv)when Lv>=11 andalso Lv=<15->0.5;
get(Lv)when Lv>=16 andalso Lv=<20->1;
get(Lv)when Lv>=21 andalso Lv=<25->2;
get(Lv)when Lv>=26 andalso Lv=<30->3;
get(Lv)when Lv>=31 andalso Lv=<35->4;
get(Lv)when Lv>=36 andalso Lv=<40->5;
get(Lv)when Lv>=41 andalso Lv=<999->5;
get(_) -> 0.
