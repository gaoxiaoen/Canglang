%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_scene_copy
	%%% @Created : 2018-04-23 16:45:50
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_scene_copy).
-export([get/1]).
-include("common.hrl").
-include("invade.hrl").
get(10001)->30;
get(10002)->30;
get(10003)->50;
get(10004)->30;
get(10005)->30;
get(15001)->15;
get(15003)->40;
get(12007)->15;
get(41001)->8;
get(41003)->15;
get(_) -> 50.
