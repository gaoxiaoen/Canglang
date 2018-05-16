%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild).
-export([max_lv/0]).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").

    max_lv() ->
    10.
get(1) ->
	#base_guild{lv = 1 ,dedicate = 10000 ,max_num = 25 };
get(2) ->
	#base_guild{lv = 2 ,dedicate = 24000 ,max_num = 26 };
get(3) ->
	#base_guild{lv = 3 ,dedicate = 45000 ,max_num = 27 };
get(4) ->
	#base_guild{lv = 4 ,dedicate = 72000 ,max_num = 28 };
get(5) ->
	#base_guild{lv = 5 ,dedicate = 160000 ,max_num = 29 };
get(6) ->
	#base_guild{lv = 6 ,dedicate = 220000 ,max_num = 30 };
get(7) ->
	#base_guild{lv = 7 ,dedicate = 375000 ,max_num = 31 };
get(8) ->
	#base_guild{lv = 8 ,dedicate = 560000 ,max_num = 32 };
get(9) ->
	#base_guild{lv = 9 ,dedicate = 750000 ,max_num = 33 };
get(10) ->
	#base_guild{lv = 10 ,dedicate = 900000 ,max_num = 35 };
get(_) -> [].