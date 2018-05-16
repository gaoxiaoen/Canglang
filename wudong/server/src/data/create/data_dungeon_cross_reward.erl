%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_cross_reward
	%%% @Created : 2017-12-25 10:51:59
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_cross_reward).
-export([get/1]).
-export([times_list/0]).
-include("common.hrl").
-include("cross_dungeon.hrl").

    times_list() ->
    [20,40].
get(20) ->
	#base_dun_cross_reward{times = 20 ,dixian = {{7405002,1}} ,tianxian = {{7405003,1}} ,jinxian = {{7405004,1}} ,xingjun = {{7405005,1}} ,xiandi = {{7405006,1}} ,shenzi = {{7405007,1}} ,tianshen = {{8002515,1}} ,manjie = {{8002515,1}} };
get(40) ->
	#base_dun_cross_reward{times = 40 ,dixian = {{7405002,1}} ,tianxian = {{7405003,1}} ,jinxian = {{7405004,1}} ,xingjun = {{7405005,1}} ,xiandi = {{7405006,1}} ,shenzi = {{7405007,1}} ,tianshen = {{8002515,1}} ,manjie = {{8002515,1}} };
get(_) -> [].