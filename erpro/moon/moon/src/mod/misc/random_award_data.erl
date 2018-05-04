%% -----------------------
%% 勋章配置表
%% @autor wangweibiao
%% ------------------------
-module(random_award_data).
-export([
		get_random_cond/0,
		get_said_info/1
		]).

-include("random_award.hrl").

get_random_cond() ->
[
	#random_award{id = 100000, label = level, target = 0, value = 5, award_id = 400001},

	#random_award{id = 100002, label = dungeon_star, target = 0, value = 17, award_id = 400003},

	#random_award{id = 100003, label = dragon_level, target = 0, value = 3, award_id = 400004},

	#random_award{id = 100004, label = dragon_bone, target = 0, value = 100, award_id = 400005},

	#random_award{id = 100005, label = c_suit, target = 1, value = 7, award_id = 400006},

	#random_award{id = 100006, label = dungeon_hardstar, target = 0, value = 1, award_id = 400007},

	#random_award{id = 100007, label = skill, target = 2, value = 5, award_id = 400008},

	#random_award{id = 100008, label = dragon_skill, target = 2301, value = 0, award_id = 400009},

	#random_award{id = 100009, label = level, target = 0, value = 10, award_id = 400010},

	#random_award{id = 100010, label = trial, target = 10000, value = 0, award_id = 400011},

	#random_award{id = 100011, label = level, target = 0, value = 15, award_id = 400012},

	#random_award{id = 100012, label = skill, target = 3, value = 5, award_id = 400013},

	#random_award{id = 100013, label = trade, target = 0, value = 1, award_id = 400014},

	#random_award{id = 100014, label = dragon_train, target = 0, value = 1, award_id = 400015},

	#random_award{id = 100015, label = jd_suit, target = 0, value = 1, award_id = 400016},

	#random_award{id = 100016, label = qh_suit, target = 2, value = 1, award_id = 400017},

	#random_award{id = 100017, label = qh_suit, target = 6, value = 2, award_id = 400018},

	#random_award{id = 100018, label = c_suit, target = 1, value = 10, award_id = 400019},

	#random_award{id = 100019, label = gemstone, target = 0, value = 1, award_id = 400020},

	#random_award{id = 100020, label = divine, target = 0, value = 1, award_id = 400021},

	#random_award{id = 100021, label = level, target = 0, value = 20, award_id = 400022},

	#random_award{id = 100022, label = monsters_contract, target = 0, value = 1, award_id = 400023},

	#random_award{id = 100023, label = task, target = 10051, value = 0, award_id = 400024},

	#random_award{id = 100024, label = task, target = 10021, value = 0, award_id = 400025},

	#random_award{id = 100025, label = task, target = 10117, value = 0, award_id = 400026},

	#random_award{id = 100026, label = task, target = 10059, value = 0, award_id = 400027},

	#random_award{id = 100027, label = legion, target = 0, value = 0, award_id = 400028},

	#random_award{id = 100028, label = task, target = 10113, value = 0, award_id = 400029},

	#random_award{id = 100029, label = task, target = 10090, value = 0, award_id = 400030},

	#random_award{id = 100030, label = kingdomfight, target = 0, value = 1, award_id = 400031},

	#random_award{id = 100031, label = tree_climb_times, target = 0, value = 1, award_id = 400032},

	#random_award{id = 100032, label = pirate, target = 0, value = 1, award_id = 400033},

	#random_award{id = 100033, label = dragon_boss, target = 0, value = 1, award_id = 400034},

	#random_award{id = 100034, label = friend, target = 0, value = 1, award_id = 400035},

	#random_award{id = 100035, label = tree_climb, target = 0, value = 30, award_id = 0},

	#random_award{id = 100036, label = tree_climb, target = 0, value = 60, award_id = 0},

	#random_award{id = 100037, label = tree_climb, target = 0, value = 90, award_id = 0},

	#random_award{id = 100038, label = tree_climb, target = 0, value = 120, award_id = 0},

	#random_award{id = 100039, label = tree_climb, target = 0, value = 150, award_id = 0},

	#random_award{id = 100040, label = tree_climb, target = 0, value = 180, award_id = 0}

].	

get_said_info(100035) ->
	<<"令人敬佩！~s第一次在世界树达到了30千庭米！">>;
get_said_info(100036) ->
	<<"出类拔萃！~s第一次在世界树达到了60千庭米！">>;
get_said_info(100037) ->
	<<"攻无不克！~s第一次在世界树达到了90千庭米！">>;
get_said_info(100038) ->
	<<"惊天动地！~s第一次在世界树达到了120千庭米！">>;
get_said_info(100039) ->
	<<"所向披靡！~s第一次在世界树达到了150千庭米！">>;
get_said_info(100040) ->
	<<"威震四方！~s第一次在世界树达到了180千庭米！">>;
	
get_said_info(_) ->
	<<>>.

