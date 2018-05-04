%% -----------------------
%% 酒桶节配置表
%% @autor wangweibiao
%% ------------------------
-module(beer_data).
-export([
		get_all_times/0,
		get_award/1,
		get_activity/1,
		get_title_count/0,
		check_if_celebrity/1,
		get_all_npc/0,
		get_celebrity_id/1
		]).

-include("beer.hrl").
-include("gain.hrl").


get_title_count() -> 
	146.

get_all_times() ->
	[{10,30,0},{12,30,0},{14,30,0},{16,30,0},{18,30,0},{20,30,0},{22,30,0}].

get_all_npc() ->
	[{10109,10110},{10111,10112}].

get_activity(1) ->
	#beer_data{
		special = 0, 
		title_num = 20
	};
get_activity(2) ->
	#beer_data{
		special = 1, 
		title_num = 20
	};
get_activity(3) ->
	#beer_data{
		special = 0, 
		title_num = 20
	};
get_activity(4) ->
	#beer_data{
		special = 0, 
		title_num = 20
	};
get_activity(5) ->
	#beer_data{
		special = 1, 
		title_num = 20
	};
get_activity(6) ->
	#beer_data{
		special = 0, 
		title_num = 20
	};
get_activity(7) ->
	#beer_data{
		special = 0, 
		title_num = 20
	};
get_activity(_) ->
	#beer_data{}.
	
get_award(20) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(21) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(22) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(23) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(24) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 1500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(25) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(26) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(27) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(28) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(29) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(30) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(31) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(32) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 3000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(33) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 12000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 12000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(34) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 12300},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 12300},
				#gain{label = coin, val = 1000}
			]
	};
get_award(35) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 12700},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 12700},
				#gain{label = coin, val = 1000}
			]
	};
get_award(36) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 13100},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 13100},
				#gain{label = coin, val = 1000}
			]
	};
get_award(37) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 13400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 13400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(38) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 13800},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 13800},
				#gain{label = coin, val = 1000}
			]
	};
get_award(39) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 14100},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 14100},
				#gain{label = coin, val = 1000}
			]
	};
get_award(40) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 14500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 14500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(41) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 20800},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 20800},
				#gain{label = coin, val = 1000}
			]
	};
get_award(42) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 21400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 21400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(43) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 21900},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 21900},
				#gain{label = coin, val = 1000}
			]
	};
get_award(44) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 22400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 22400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(45) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 22900},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 22900},
				#gain{label = coin, val = 1000}
			]
	};
get_award(46) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 23400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 23400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(47) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 22200},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 22200},
				#gain{label = coin, val = 1000}
			]
	};
get_award(48) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 22700},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 22700},
				#gain{label = coin, val = 1000}
			]
	};
get_award(49) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 24400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 24400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(50) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 30400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 30400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(51) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 31000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 31000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(52) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 30400},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 30400},
				#gain{label = coin, val = 1000}
			]
	};
get_award(53) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 31000},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 31000},
				#gain{label = coin, val = 1000}
			]
	};
get_award(54) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 31600},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 31600},
				#gain{label = coin, val = 1000}
			]
	};
get_award(55) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 34900},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 34900},
				#gain{label = coin, val = 1000}
			]
	};
get_award(56) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 35600},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 35600},
				#gain{label = coin, val = 1000}
			]
	};
get_award(57) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 36200},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 36200},
				#gain{label = coin, val = 1000}
			]
	};
get_award(58) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 36800},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 36800},
				#gain{label = coin, val = 1000}
			]
	};
get_award(59) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 37500},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 37500},
				#gain{label = coin, val = 1000}
			]
	};
get_award(60) ->
	#beer_award{
		award1 = [
				#gain{label = exp, val = 43300},
				#gain{label = coin, val = 2000}
			],
		award2 = [
				#gain{label = exp, val = 43300},
				#gain{label = coin, val = 1000}
			]
	};
get_award(_) ->
	#beer_award{}.

check_if_celebrity(1) ->
	1;
check_if_celebrity(2) ->
	1;
check_if_celebrity(3) ->
	1;
check_if_celebrity(4) ->
	1;
check_if_celebrity(5) ->
	1;
check_if_celebrity(6) ->
	1;
check_if_celebrity(7) ->
	1;
check_if_celebrity(8) ->
	1;
check_if_celebrity(9) ->
	1;
check_if_celebrity(10) ->
	1;
check_if_celebrity(11) ->
	1;
check_if_celebrity(12) ->
	1;
check_if_celebrity(13) ->
	1;
check_if_celebrity(14) ->
	1;
check_if_celebrity(15) ->
	1;
check_if_celebrity(16) ->
	1;
check_if_celebrity(17) ->
	1;
check_if_celebrity(18) ->
	1;
check_if_celebrity(19) ->
	1;
check_if_celebrity(20) ->
	1;
check_if_celebrity(21) ->
	1;
check_if_celebrity(22) ->
	1;
check_if_celebrity(23) ->
	1;
check_if_celebrity(24) ->
	1;
check_if_celebrity(25) ->
	1;
check_if_celebrity(26) ->
	1;
check_if_celebrity(27) ->
	1;
check_if_celebrity(28) ->
	1;
check_if_celebrity(29) ->
	1;
check_if_celebrity(30) ->
	1;
check_if_celebrity(31) ->
	1;
check_if_celebrity(32) ->
	1;
check_if_celebrity(_) -> 
	0. 

get_celebrity_id(1) ->
	11101;
get_celebrity_id(2) ->
	11102;
get_celebrity_id(3) ->
	11103;
get_celebrity_id(4) ->
	11104;
get_celebrity_id(5) ->
	11105;
get_celebrity_id(6) ->
	11106;
get_celebrity_id(7) ->
	11107;
get_celebrity_id(8) ->
	11108;
get_celebrity_id(9) ->
	11201;
get_celebrity_id(10) ->
	11202;
get_celebrity_id(11) ->
	11203;
get_celebrity_id(12) ->
	11204;
get_celebrity_id(13) ->
	11205;
get_celebrity_id(14) ->
	11206;
get_celebrity_id(15) ->
	11207;
get_celebrity_id(16) ->
	11208;
get_celebrity_id(17) ->
	12101;
get_celebrity_id(18) ->
	12102;
get_celebrity_id(19) ->
	12103;
get_celebrity_id(20) ->
	12104;
get_celebrity_id(21) ->
	12201;
get_celebrity_id(22) ->
	12202;
get_celebrity_id(23) ->
	12203;
get_celebrity_id(24) ->
	12204;
get_celebrity_id(25) ->
	13101;
get_celebrity_id(26) ->
	13102;
get_celebrity_id(27) ->
	13103;
get_celebrity_id(28) ->
	13104;
get_celebrity_id(29) ->
	13201;
get_celebrity_id(30) ->
	13202;
get_celebrity_id(31) ->
	13203;
get_celebrity_id(32) ->
	13204;
get_celebrity_id(_) -> 
	0. 
	
	
