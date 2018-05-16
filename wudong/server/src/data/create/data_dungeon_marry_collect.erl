%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_marry_collect
	%%% @Created : 2017-11-16 16:43:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_marry_collect).
-export([get/1]).
-export([get_all/0]).
-include("server.hrl").

get_all() -> [1,2,3].


get(1) -> {45118, [{30,71},{36,81},{26,85},{21,29}]};
get(2) -> {45118, [{9,86},{22,75},{22,55},{8,46}]};
get(3) -> {45118, [{14,33},{25,31},{11,71},{15,20}]};
get(_mon_id) -> [].

