%% -----------------------
%% 勋章配置表
%% @autor wangweibiao
%% ------------------------
-module(medal_data).
-export([
		get_medal_base/1,
		get_medal_special/1
		]).

-include("achievement.hrl").


get_medal_base(10001) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10001,
			next_id = 10002,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 10, rep = 100, stone = 10, need_value = 10},
						#medal_cond{id = 2, label = skill, target = 1, target_value = 4, rep = 100, stone = 10, need_value = 4},
						#medal_cond{id = 3, label = suit_arms, target = 1, target_value = 1, rep = 100, stone = 10, need_value = 1},
						#medal_cond{id = 4, label = suit_armor2, target = 1, target_value = 6, rep = 100, stone = 10, need_value = 6},
						#medal_cond{id = 5, label = c_suit, target = 1, target_value = 7, rep = 100, stone = 10, need_value = 7},
						#medal_cond{id = 6, label = qh_suit, target = 1, target_value = 2, rep = 100, stone = 10, need_value = 1},
						#medal_cond{id = 7, label = fight_capacity, target = 0, target_value = 500, rep = 100, stone = 10, need_value = 500},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 3, rep = 100, stone = 10, need_value = 3},
						#medal_cond{id = 9, label = dragon_bone, target = 0, target_value = 1, rep = 100, stone = 10, need_value = 1},
						#medal_cond{id = 10, label = kill_npc, target = 10308, target_value = 1, rep = 100, stone = 10, need_value = 1},
						#medal_cond{id = 11, label = dungeon_star, target = 0, target_value = 18, rep = 100, stone = 10, need_value = 18},
						#medal_cond{id = 12, label = trial, target = 10000, target_value = 0, rep = 100, stone = 10, need_value = 1}]
		}
	};
get_medal_base(10002) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10002,
			next_id = 10003,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 20, rep = 100, stone = 20, need_value = 20},
						#medal_cond{id = 2, label = skill, target = 2, target_value = 6, rep = 100, stone = 20, need_value = 6},
						#medal_cond{id = 3, label = suit_arms, target = 20, target_value = 1, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = suit_armor2, target = 20, target_value = 1, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = qh_suit, target = 7, target_value = 2, rep = 100, stone = 20, need_value = 7},
						#medal_cond{id = 6, label = bslv_suit, target = 1, target_value = 6, rep = 100, stone = 20, need_value = 6},
						#medal_cond{id = 7, label = kill_npc, target = 10335, target_value = 1, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 10, rep = 100, stone = 20, need_value = 10},
						#medal_cond{id = 9, label = dragon_bone, target = 0, target_value = 45, rep = 100, stone = 20, need_value = 45},
						#medal_cond{id = 10, label = dungeon_star, target = 0, target_value = 33, rep = 100, stone = 20, need_value = 33},
						#medal_cond{id = 11, label = dungeon_hardstar, target = 0, target_value = 30, rep = 100, stone = 20, need_value = 30},
						#medal_cond{id = 12, label = trial, target = 10001, target_value = 0, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10003) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10003,
			next_id = 10004,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 25, rep = 100, stone = 25, need_value = 25},
						#medal_cond{id = 2, label = skill, target = 3, target_value = 6, rep = 100, stone = 25, need_value = 6},
						#medal_cond{id = 3, label = suit_armor2, target = 20, target_value = 3, rep = 100, stone = 25, need_value = 3},
						#medal_cond{id = 4, label = suit_jewelry2, target = 20, target_value = 1, rep = 100, stone = 25, need_value = 1},
						#medal_cond{id = 5, label = qh_suit, target = 8, target_value = 3, rep = 100, stone = 25, need_value = 8},
						#medal_cond{id = 6, label = bslv_suit, target = 2, target_value = 7, rep = 100, stone = 25, need_value = 7},
						#medal_cond{id = 7, label = drug, target = 1, target_value = 10, rep = 100, stone = 25, need_value = 10},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 18, rep = 100, stone = 25, need_value = 18},
						#medal_cond{id = 9, label = dragon_bone, target = 0, target_value = 75, rep = 100, stone = 25, need_value = 75},
						#medal_cond{id = 10, label = dragon_skill_low2, target = 1, target_value = 2, rep = 100, stone = 25, need_value = 2},
						#medal_cond{id = 11, label = dungeon_hardstar, target = 0, target_value = 40, rep = 100, stone = 25, need_value = 40},
						#medal_cond{id = 12, label = trial, target = 10002, target_value = 0, rep = 100, stone = 25, need_value = 1}]
		}
	};
get_medal_base(10004) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10004,
			next_id = 10005,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 30, rep = 100, stone = 30, need_value = 30},
						#medal_cond{id = 2, label = skill, target = 3, target_value = 8, rep = 100, stone = 30, need_value = 8},
						#medal_cond{id = 3, label = suit_arms, target = 30, target_value = 1, rep = 100, stone = 30, need_value = 1},
						#medal_cond{id = 4, label = suit_armor2, target = 30, target_value = 2, rep = 100, stone = 30, need_value = 2},
						#medal_cond{id = 5, label = c_suit, target = 2, target_value = 1, rep = 100, stone = 30, need_value = 1},
						#medal_cond{id = 6, label = qh_suit, target = 10, target_value = 3, rep = 100, stone = 30, need_value = 10},
						#medal_cond{id = 7, label = bslv_suit, target = 3, target_value = 3, rep = 100, stone = 30, need_value = 3},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 25, rep = 100, stone = 30, need_value = 25},
						#medal_cond{id = 9, label = dragon_bone, target = 0, target_value = 100, rep = 100, stone = 30, need_value = 100},
						#medal_cond{id = 10, label = monster_lv, target = 10, target_value = 1, rep = 100, stone = 30, need_value = 1},
						#medal_cond{id = 11, label = monsters_contract, target = 0, target_value = 1, rep = 100, stone = 30, need_value = 1},
						#medal_cond{id = 12, label = trial, target = 10003, target_value = 0, rep = 100, stone = 30, need_value = 1}]
		}
	};
get_medal_base(10005) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10005,
			next_id = 10006,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 35, rep = 100, stone = 35, need_value = 35},
						#medal_cond{id = 2, label = skill, target = 4, target_value = 9, rep = 100, stone = 35, need_value = 9},
						#medal_cond{id = 3, label = suit_jewelry2, target = 30, target_value = 2, rep = 100, stone = 35, need_value = 2},
						#medal_cond{id = 4, label = c_suit, target = 2, target_value = 3, rep = 100, stone = 35, need_value = 3},
						#medal_cond{id = 5, label = jd_suit, target = 200, target_value = 3, rep = 100, stone = 35, need_value = 3},
						#medal_cond{id = 6, label = bslv_suit, target = 4, target_value = 2, rep = 100, stone = 35, need_value = 2},
						#medal_cond{id = 7, label = divine_2, target = 8, target_value = 5, rep = 100, stone = 35, need_value = 5},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 33, rep = 100, stone = 35, need_value = 33},
						#medal_cond{id = 9, label = dragon_skill_low2, target = 2, target_value = 3, rep = 100, stone = 35, need_value = 3},
						#medal_cond{id = 10, label = monster_lv, target = 20, target_value = 1, rep = 100, stone = 35, need_value = 1},
						#medal_cond{id = 11, label = tree_climb, target = 0, target_value = 30, rep = 100, stone = 35, need_value = 30},
						#medal_cond{id = 12, label = trial, target = 10004, target_value = 0, rep = 100, stone = 35, need_value = 1}]
		}
	};
get_medal_base(10006) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10006,
			next_id = 10007,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 40, rep = 100, stone = 40, need_value = 40},
						#medal_cond{id = 2, label = skill, target = 5, target_value = 10, rep = 100, stone = 40, need_value = 10},
						#medal_cond{id = 3, label = suit_arms, target = 40, target_value = 1, rep = 100, stone = 40, need_value = 1},
						#medal_cond{id = 4, label = suit_armor2, target = 40, target_value = 2, rep = 100, stone = 40, need_value = 2},
						#medal_cond{id = 5, label = c_suit, target = 3, target_value = 3, rep = 100, stone = 40, need_value = 3},
						#medal_cond{id = 6, label = qh_suit, target = 10, target_value = 5, rep = 100, stone = 40, need_value = 10},
						#medal_cond{id = 7, label = drug, target = 2, target_value = 35, rep = 100, stone = 40, need_value = 35},
						#medal_cond{id = 8, label = dragon_bone, target = 0, target_value = 140, rep = 100, stone = 40, need_value = 140},
						#medal_cond{id = 9, label = monster_lv, target = 30, target_value = 1, rep = 100, stone = 40, need_value = 1},
						#medal_cond{id = 10, label = monsters_contract, target = 0, target_value = 5, rep = 100, stone = 40, need_value = 5},
						#medal_cond{id = 11, label = tree_climb, target = 0, target_value = 50, rep = 100, stone = 40, need_value = 50},
						#medal_cond{id = 12, label = trial, target = 10005, target_value = 0, rep = 100, stone = 40, need_value = 1}]
		}
	};
get_medal_base(10007) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10007,
			next_id = 10008,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 45, rep = 100, stone = 45, need_value = 45},
						#medal_cond{id = 2, label = suit_jewelry2, target = 40, target_value = 2, rep = 100, stone = 45, need_value = 2},
						#medal_cond{id = 3, label = c_suit, target = 3, target_value = 7, rep = 100, stone = 45, need_value = 7},
						#medal_cond{id = 4, label = jd_suit, target = 800, target_value = 5, rep = 100, stone = 45, need_value = 5},
						#medal_cond{id = 5, label = bslv_suit, target = 3, target_value = 24, rep = 100, stone = 45, need_value = 24},
						#medal_cond{id = 6, label = divine_2, target = 25, target_value = 8, rep = 100, stone = 45, need_value = 8},
						#medal_cond{id = 7, label = divine_3, target = 20, target_value = 8, rep = 100, stone = 45, need_value = 8},
						#medal_cond{id = 8, label = drug, target = 2, target_value = 75, rep = 100, stone = 45, need_value = 75},
						#medal_cond{id = 9, label = dragon_skill_mid2, target = 3, target_value = 4, rep = 100, stone = 45, need_value = 4},
						#medal_cond{id = 10, label = monsters_contract, target = 0, target_value = 10, rep = 100, stone = 45, need_value = 10},
						#medal_cond{id = 11, label = tree_climb, target = 0, target_value = 70, rep = 100, stone = 45, need_value = 70},
						#medal_cond{id = 12, label = trial, target = 10006, target_value = 0, rep = 100, stone = 45, need_value = 1}]
		}
	};
get_medal_base(10008) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10008,
			next_id = 10009,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 50, rep = 100, stone = 50, need_value = 50},
						#medal_cond{id = 2, label = skill, target = 7, target_value = 11, rep = 100, stone = 50, need_value = 11},
						#medal_cond{id = 3, label = suit_arms, target = 50, target_value = 1, rep = 100, stone = 50, need_value = 1},
						#medal_cond{id = 4, label = suit_armor2, target = 50, target_value = 3, rep = 100, stone = 50, need_value = 3},
						#medal_cond{id = 5, label = c_suit, target = 4, target_value = 5, rep = 100, stone = 50, need_value = 5},
						#medal_cond{id = 6, label = qh_suit, target = 10, target_value = 8, rep = 100, stone = 50, need_value = 10},
						#medal_cond{id = 7, label = bslv_suit, target = 4, target_value = 30, rep = 100, stone = 50, need_value = 30},
						#medal_cond{id = 8, label = dragon_level, target = 0, target_value = 48, rep = 100, stone = 50, need_value = 48},
						#medal_cond{id = 9, label = dragon_bone, target = 0, target_value = 180, rep = 100, stone = 50, need_value = 180},
						#medal_cond{id = 10, label = monster_lv, target = 46, target_value = 1, rep = 100, stone = 50, need_value = 1},
						#medal_cond{id = 11, label = tree_climb, target = 0, target_value = 90, rep = 100, stone = 50, need_value = 90},
						#medal_cond{id = 12, label = trial, target = 10007, target_value = 0, rep = 100, stone = 50, need_value = 1}]
		}
	};
get_medal_base(10009) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10009,
			next_id = 10010,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10010) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10010,
			next_id = 10011,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10011) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10011,
			next_id = 10012,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10012) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10012,
			next_id = 10013,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10013) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 10013,
			next_id = 10014,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};
get_medal_base(10014) ->
	{ok,	
		#medal_base{
			need_rep = 1200, 
			dungeon = 0,
			next_id = 0,
			condition = [#medal_cond{id = 1, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 2, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 3, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 4, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 5, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 6, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 7, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 8, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 9, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 10, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 11, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1},
						#medal_cond{id = 12, label = level, target = 0, target_value = 100, rep = 100, stone = 20, need_value = 1}]
		}
	};

get_medal_base(_Id) ->
    {false, <<"数据不存在">>}.


%%get_medal_special(1000) ->
%%	{ok,
%%		#medal_special{
%%			attr = [{mp, 100},{hp, 200},{dmg, 150},{attck,300}],
%%			npc = [10010, 10020],
%%			map = [10010, 10020],
%%			func = [10010, 10020]
%%	}
%%};

	

get_medal_special(10001) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,126},{defence, 63},{dmg,31}]			
		}
	};
get_medal_special(10002) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,270},{dmg,67},{resist_all,54},{aspd,1}]			
		}
	};
get_medal_special(10003) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,345},{dmg,86},{critrate,34},{tenacity,34}]			
		}
	};
get_medal_special(10004) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,422},{aspd,2},{hitrate,17},{evasion,17}]			
		}
	};
get_medal_special(10005) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,499},{dmg,125},{evasion,20},{hitrate,20}]			
		}
	};
get_medal_special(10006) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,578},{evasion,23},{tenacity,58},{aspd,3}]			
		}
	};
get_medal_special(10007) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,658},{hitrate,26},{evasion,26},{critrate,66}]			
		}
	};
get_medal_special(10008) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,739},{dmg,185},{tenacity,74},{aspd,4}]			
		}
	};
get_medal_special(10009) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,821},{defence, 411},{dmg,205},{dmg_magic,103}]			
		}
	};
get_medal_special(10010) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,904},{defence, 452},{resist_all,181},{aspd,5}]			
		}
	};
get_medal_special(10011) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,987},{dmg,247},{tenacity,99},{dmg_magic,123}]			
		}
	};
get_medal_special(10012) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,1071},{hitrate,43},{evasion,43},{aspd,5}]			
		}
	};
get_medal_special(10013) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,1155},{hitrate,46},{tenacity,115},{resist_all,231}]			
		}
	};
get_medal_special(10014) ->
	{ok,	
		#medal_special{
			attr = [{hp_max,1240},{hitrate,50},{dmg,310},{aspd,6}]			
		}
	};

get_medal_special(_Id) ->
    {false, <<"数据不存在">>}.

	
	
	
	
