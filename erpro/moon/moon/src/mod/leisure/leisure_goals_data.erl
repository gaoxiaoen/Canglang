%% -----------------------
%% 勋章配置表
%% @autor wangweibiao
%% ------------------------
-module(leisure_goals_data).
-export([
		get/1,
		get_reward/2,
		get_stars/1,
		dungeon_list/0
		]).

-include("attr.hrl").
-include("leisure.hrl").
-include("common.hrl").

dungeon_list() ->
	[11091,11092,12131,12132,14121,14122,16131,16132,18131,18132].

get(11091) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 0, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 3, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 2, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(11092) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(12131) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(12132) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(14121) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(14122) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(16131) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(16132) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(18131) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];
get(18132) ->
	[
			#leisure_goal{id= 5, npc_hp_left = 0, role_hp_left = 80, kill_npc = 1},
			#leisure_goal{id= 4, npc_hp_left = 0, role_hp_left = 50, kill_npc = 1},
			#leisure_goal{id= 3, npc_hp_left = 0, role_hp_left = 20, kill_npc = 1},
			#leisure_goal{id= 2, npc_hp_left = 50, role_hp_left = 0, kill_npc = 0},
			#leisure_goal{id= 1, npc_hp_left = 100, role_hp_left = 0, kill_npc = 0}	
	];

get(_DungeonId) ->
	[].

get_reward(11091, 5) ->
	{3000, 1000, 0, 408, [[221105,1,2]]};
get_reward(11091, 4) ->
	{2000, 1000, 0, 272, [[221105,1,2]]};
get_reward(11091, 3) ->
	{2000, 1000, 0, 272, [[221105,1,2]]};
get_reward(11091, 2) ->
	{1500, 1000, 0, 204, [[221105,1,2]]};
get_reward(11091, 1) ->
	{1000, 1000, 0, 136, [[221105,1,2]]};
get_reward(11092, 5) ->
	{0, 2000, 300, 816, [[131001,1,2]]};
get_reward(11092, 4) ->
	{0, 2000, 200, 544, [[131001,1,2]]};
get_reward(11092, 3) ->
	{0, 2000, 200, 544, [[131001,1,1]]};
get_reward(11092, 2) ->
	{0, 2000, 150, 408, [[131001,1,1]]};
get_reward(11092, 1) ->
	{0, 2000, 100, 272, [[131001,1,1]]};
get_reward(12131, 5) ->
	{3969, 1000, 0, 714, [[221105,1,3]]};
get_reward(12131, 4) ->
	{2646, 1000, 0, 476, [[221105,1,2]]};
get_reward(12131, 3) ->
	{2646, 1000, 0, 476, [[221105,1,2]]};
get_reward(12131, 2) ->
	{1984, 1000, 0, 357, [[221105,1,1]]};
get_reward(12131, 1) ->
	{1323, 1000, 0, 238, [[221105,1,1]]};
get_reward(12132, 5) ->
	{0, 2000, 381, 1428, [[131001,1,2]]};
get_reward(12132, 4) ->
	{0, 2000, 254, 952, [[131001,1,2]]};
get_reward(12132, 3) ->
	{0, 2000, 254, 952, [[131001,1,1]]};
get_reward(12132, 2) ->
	{0, 2000, 190, 714, [[131001,1,1]]};
get_reward(12132, 1) ->
	{0, 2000, 127, 476, [[131001,1,1]]};
get_reward(14121, 5) ->
	{2371, 1000, 0, 1020, [[221105,1,4]]};
get_reward(14121, 4) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(14121, 3) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(14121, 2) ->
	{1185, 1000, 0, 510, [[221105,1,2]]};
get_reward(14121, 1) ->
	{790, 1000, 0, 340, [[221105,1,2]]};
get_reward(14122, 5) ->
	{0, 2000, 474, 2040, [[131001,1,2]]};
get_reward(14122, 4) ->
	{0, 2000, 316, 1360, [[131001,1,2]]};
get_reward(14122, 3) ->
	{0, 2000, 316, 1360, [[131001,1,1]]};
get_reward(14122, 2) ->
	{0, 2000, 237, 1020, [[131001,1,1]]};
get_reward(14122, 1) ->
	{0, 2000, 158, 680, [[131001,1,1]]};
get_reward(16131, 5) ->
	{2371, 1000, 0, 1020, [[221105,1,4]]};
get_reward(16131, 4) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(16131, 3) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(16131, 2) ->
	{1185, 1000, 0, 510, [[221105,1,2]]};
get_reward(16131, 1) ->
	{790, 1000, 0, 340, [[221105,1,2]]};
get_reward(16132, 5) ->
	{0, 2000, 474, 2040, [[131001,1,2]]};
get_reward(16132, 4) ->
	{0, 2000, 316, 1360, [[131001,1,2]]};
get_reward(16132, 3) ->
	{0, 2000, 316, 1360, [[131001,1,1]]};
get_reward(16132, 2) ->
	{0, 2000, 237, 1020, [[131001,1,1]]};
get_reward(16132, 1) ->
	{0, 2000, 158, 680, [[131001,1,1]]};
get_reward(18131, 5) ->
	{2371, 1000, 0, 1020, [[221105,1,4]]};
get_reward(18131, 4) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(18131, 3) ->
	{1581, 1000, 0, 680, [[221105,1,3]]};
get_reward(18131, 2) ->
	{1185, 1000, 0, 510, [[221105,1,2]]};
get_reward(18131, 1) ->
	{790, 1000, 0, 340, [[221105,1,2]]};
get_reward(18132, 5) ->
	{0, 2000, 474, 2040, [[131001,1,2]]};
get_reward(18132, 4) ->
	{0, 2000, 316, 1360, [[131001,1,2]]};
get_reward(18132, 3) ->
	{0, 2000, 316, 1360, [[131001,1,1]]};
get_reward(18132, 2) ->
	{0, 2000, 237, 1020, [[131001,1,1]]};
get_reward(18132, 1) ->
	{0, 2000, 158, 680, [[131001,1,1]]};

get_reward(_DungeonId, _Goal) ->
	?DEBUG("DungeonId:~p _Goal:~p~n~n~n", [_DungeonId, _Goal]),
	[].
	
	
get_stars(11091) ->
	[{4, 1},{3, 1},{1, 1}];
get_stars(11092) ->
	[{5, 1},{3, 1},{1, 1}];
get_stars(12131) ->
	[{4, 1},{3, 1},{1, 1}];
get_stars(12132) ->
	[{5, 1},{3, 1},{1, 1}];
get_stars(14121) ->
	[{4, 1},{3, 1},{1, 1}];
get_stars(14122) ->
	[{5, 1},{3, 1},{1, 1}];
get_stars(16131) ->
	[{4, 1},{3, 1},{1, 1}];
get_stars(16132) ->
	[{5, 1},{3, 1},{1, 1}];
get_stars(18131) ->
	[{4, 1},{3, 1},{1, 1}];
get_stars(18132) ->
	[{5, 1},{3, 1},{1, 1}];

get_stars(_DungeonId) ->
	[].
	
	
