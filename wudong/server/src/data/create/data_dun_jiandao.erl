%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dun_jiandao
	%%% @Created : 2018-03-28 15:41:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dun_jiandao).
-export([get/1]).
-export([get_all/0]).
-include("dungeon.hrl").
get(61101) -> #base_dun_jiandao{dun_id = 61101, type=1, score = 1, lv_limit=80 };
get(61102) -> #base_dun_jiandao{dun_id = 61102, type=2, score = 10, lv_limit=100 };
get(61103) -> #base_dun_jiandao{dun_id = 61103, type=3, score = 30, lv_limit=120 };
get(_dun_id) -> [].

get_all()->[61101,61102,61103].

