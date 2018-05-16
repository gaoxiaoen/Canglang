%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_battlefield_box
	%%% @Created : 2016-06-23 17:48:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_battlefield_box).
-export([ids/0,get/1]).
-include("common.hrl").
-include("battlefield.hrl").

    ids() ->
    [61075].
get(61075) ->
	#base_battlefield_box{x = 61 ,y = 75 ,mon_id = 11408 ,refresh_time = [30,330,790,1130] ,notice = ?T("杀戮大宝箱还有30秒就要刷新啦") };
get(_) -> [].