%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_uplv_box_time
	%%% @Created : 2017-10-25 17:49:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_uplv_box_time).
-export([get/1]).
-include("activity.hrl").
get(Days) when Days >= 0 andalso Days =< 0 ->[1,2,3,4,5,6,7];
get(_Days) -> [].

