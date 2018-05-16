%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_marry_gift
	%%% @Created : 2017-07-11 15:24:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_marry_gift).
-export([get/1]).
-include("marry.hrl").
-include("common.hrl").

get(1) -> #base_marry_gift{type=1,time=7,cost=20,first_goods=[{10106,100}],daily_goods=[{10106,50},{7206001,2}] };
get(2) -> #base_marry_gift{type=2,time=7,cost=50,first_goods=[{10106,150}],daily_goods=[{10106,80},{7206001,3}] };
get(3) -> #base_marry_gift{type=3,time=7,cost=100,first_goods=[{10106,200}],daily_goods=[{10106,100},{7206001,5}] };
get(_) -> [].
