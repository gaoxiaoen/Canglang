%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_question_point
	%%% @Created : 2017-12-12 18:12:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_question_point).
-export([get/1]).
get(Time) when Time >= 0 andalso Time =<3 -> 10;
get(Time) when Time >= 3 andalso Time =<6 -> 8;
get(Time) when Time >= 6 andalso Time =<10 -> 6;
get(Time) when Time >= 10 andalso Time =<15 -> 4;
get(Time) when Time >= 15 andalso Time =<1000 -> 2;
get(_)->0.