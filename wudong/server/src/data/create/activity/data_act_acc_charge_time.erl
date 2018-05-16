%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_act_acc_charge_time
	%%% @Created : 2017-10-25 17:47:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_act_acc_charge_time).
-export([get/1]).
-include("activity.hrl").
get(Days) when Days >= 1 andalso Days =< 14 ->[1,2,3,4,5,6,7];
get(Days) when Days >= 15 andalso Days =< 999 ->[8,9,10,11,12,13,14];
get(_Days) -> [].

