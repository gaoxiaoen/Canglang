%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_scene_cross
	%%% @Created : 2016-06-15 16:12:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_scene_cross).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").

    ids() ->
    [60201,60202,60203].
get(Lv) when Lv >= 50 andalso Lv =< 999 ->[60201,10003,103,26];
get(Lv) when Lv >= 990 andalso Lv =< 999 ->[60202,10003,99,21];
get(Lv) when Lv >= 990 andalso Lv =< 999 ->[60203,10003,107,30];
get(_) -> [].
