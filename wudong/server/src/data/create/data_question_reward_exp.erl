%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_question_reward_exp
	%%% @Created : 2017-12-12 18:12:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_question_reward_exp).
-export([get/1]).
get(Lv) when Lv >= 1 andalso Lv =< 55 -> 6200;
get(Lv) when Lv >= 56 andalso Lv =< 60 -> 7400;
get(Lv) when Lv >= 61 andalso Lv =< 63 -> 8200;
get(Lv) when Lv >= 64 andalso Lv =< 66 -> 9100;
get(Lv) when Lv >= 67 andalso Lv =< 68 -> 10100;
get(Lv) when Lv >= 69 andalso Lv =< 70 -> 11200;
get(Lv) when Lv >= 71 andalso Lv =< 71 -> 12000;
get(Lv) when Lv >= 72 andalso Lv =< 80 -> 17500;
get(Lv) when Lv >= 81 andalso Lv =< 95 -> 30600;
get(Lv) when Lv >= 96 andalso Lv =< 107 -> 42700;
get(Lv) when Lv >= 108 andalso Lv =< 122 -> 57000;
get(Lv) when Lv >= 123 andalso Lv =< 137 -> 73600;
get(Lv) when Lv >= 138 andalso Lv =< 152 -> 92400;
get(Lv) when Lv >= 153 andalso Lv =< 172 -> 121000;
get(Lv) when Lv >= 173 andalso Lv =< 192 -> 153600;
get(Lv) when Lv >= 193 andalso Lv =< 222 -> 210000;
get(Lv) when Lv >= 223 andalso Lv =< 252 -> 275400;
get(Lv) when Lv >= 253 andalso Lv =< 282 -> 349800;
get(Lv) when Lv >= 283 andalso Lv =< 312 -> 433200;
get(Lv) when Lv >= 313 andalso Lv =< 342 -> 525600;
get(Lv) when Lv >= 343 andalso Lv =< 999 -> 592200;
get(_) -> 0.