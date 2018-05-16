%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_arena_robot
	%%% @Created : 2017-11-13 15:25:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_arena_robot).
-export([get/1]).
-include("common.hrl").
-include("arena.hrl").
get(Rank) when Rank >= 1 andalso Rank =< 1 ->
	#base_arena_robot{rank_max = 1 ,rank_min = 1 ,name = ?T("巅峰的冒险家") ,power = 37000 ,mon_id = 33001 };
get(Rank) when Rank >= 2 andalso Rank =< 3 ->
	#base_arena_robot{rank_max = 2 ,rank_min = 3 ,name = ?T("独行的冒险家") ,power = 35150 ,mon_id = 33002 };
get(Rank) when Rank >= 4 andalso Rank =< 5 ->
	#base_arena_robot{rank_max = 4 ,rank_min = 5 ,name = ?T("聪明的冒险家") ,power = 33300 ,mon_id = 33003 };
get(Rank) when Rank >= 6 andalso Rank =< 10 ->
	#base_arena_robot{rank_max = 6 ,rank_min = 10 ,name = ?T("执着的冒险家") ,power = 31450 ,mon_id = 33004 };
get(Rank) when Rank >= 11 andalso Rank =< 20 ->
	#base_arena_robot{rank_max = 11 ,rank_min = 20 ,name = ?T("勇敢的冒险家") ,power = 29600 ,mon_id = 33005 };
get(Rank) when Rank >= 21 andalso Rank =< 40 ->
	#base_arena_robot{rank_max = 21 ,rank_min = 40 ,name = ?T("醒目的冒险家") ,power = 27750 ,mon_id = 33006 };
get(Rank) when Rank >= 41 andalso Rank =< 79 ->
	#base_arena_robot{rank_max = 41 ,rank_min = 79 ,name = ?T("敦厚的冒险家") ,power = 25900 ,mon_id = 33007 };
get(Rank) when Rank >= 80 andalso Rank =< 157 ->
	#base_arena_robot{rank_max = 80 ,rank_min = 157 ,name = ?T("机智的冒险家") ,power = 25900 ,mon_id = 33008 };
get(Rank) when Rank >= 158 andalso Rank =< 313 ->
	#base_arena_robot{rank_max = 158 ,rank_min = 313 ,name = ?T("老鸟冒险家") ,power = 24050 ,mon_id = 33009 };
get(Rank) when Rank >= 314 andalso Rank =< 625 ->
	#base_arena_robot{rank_max = 314 ,rank_min = 625 ,name = ?T("进阶冒险家") ,power = 22200 ,mon_id = 33010 };
get(Rank) when Rank >= 626 andalso Rank =< 1250 ->
	#base_arena_robot{rank_max = 626 ,rank_min = 1250 ,name = ?T("耿直冒险家") ,power = 20350 ,mon_id = 33011 };
get(Rank) when Rank >= 1251 andalso Rank =< 2500 ->
	#base_arena_robot{rank_max = 1251 ,rank_min = 2500 ,name = ?T("新手冒险家") ,power = 18500 ,mon_id = 33012 };
get(Rank) when Rank >= 2501 andalso Rank =< 5000 ->
	#base_arena_robot{rank_max = 2501 ,rank_min = 5000 ,name = ?T("彩笔冒险家") ,power = 14800 ,mon_id = 33013 };
get(_) -> [].