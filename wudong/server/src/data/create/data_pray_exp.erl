%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pray_exp
	%%% @Created : 2016-01-16 17:52:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pray_exp).
-export([get/1]).
-include("common.hrl").
-include("pray.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 10  -> 
   #base_pray_exp{min_lv = 1 ,max_lv = 10 ,exp = 100 ,max_exp = 10000 };
get(Lv) when Lv >= 11 andalso Lv =< 20  -> 
   #base_pray_exp{min_lv = 11 ,max_lv = 20 ,exp = 100 ,max_exp = 10000 };
get(Lv) when Lv >= 21 andalso Lv =< 30  -> 
   #base_pray_exp{min_lv = 21 ,max_lv = 30 ,exp = 100 ,max_exp = 10000 };
get(Lv) when Lv >= 31 andalso Lv =< 40  -> 
   #base_pray_exp{min_lv = 31 ,max_lv = 40 ,exp = 100 ,max_exp = 10000 };
get(Lv) when Lv >= 41 andalso Lv =< 50  -> 
   #base_pray_exp{min_lv = 41 ,max_lv = 50 ,exp = 100 ,max_exp = 10000 };
get(Lv) when Lv >= 51 andalso Lv =< 60  -> 
   #base_pray_exp{min_lv = 51 ,max_lv = 60 ,exp = 100 ,max_exp = 10000 };
get(_) -> [].