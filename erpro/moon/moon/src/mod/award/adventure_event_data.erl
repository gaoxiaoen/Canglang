%% -----------------------
%% 奇遇事件配置表
%% @autor wangweibiao
%% ------------------------
-module(adventure_event_data).
-export([
		get/1,
		get_hole/1
		]).

-include("award.hrl").


get(10012) ->	
		#adventure_dungeon{
			dungeon_id 		= 10012, 
			max 			= 1,
			must 			= 1,
			hole_weight 	= 0,
			clear_weight 	= 0,
			hole_id	 		= 10000			
	};
get(10061) ->	
		#adventure_dungeon{
			dungeon_id 		= 10061, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10001			
	};
get(10032) ->	
		#adventure_dungeon{
			dungeon_id 		= 10032, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10002			
	};
get(10042) ->	
		#adventure_dungeon{
			dungeon_id 		= 10042, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10002			
	};
get(10052) ->	
		#adventure_dungeon{
			dungeon_id 		= 10052, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10002			
	};
get(10062) ->	
		#adventure_dungeon{
			dungeon_id 		= 10062, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10002			
	};
get(11011) ->	
		#adventure_dungeon{
			dungeon_id 		= 11011, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10003			
	};
get(11021) ->	
		#adventure_dungeon{
			dungeon_id 		= 11021, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10003			
	};
get(11031) ->	
		#adventure_dungeon{
			dungeon_id 		= 11031, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10003			
	};
get(11041) ->	
		#adventure_dungeon{
			dungeon_id 		= 11041, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10003			
	};
get(11051) ->	
		#adventure_dungeon{
			dungeon_id 		= 11051, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10003			
	};
get(11012) ->	
		#adventure_dungeon{
			dungeon_id 		= 11012, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10004			
	};
get(11022) ->	
		#adventure_dungeon{
			dungeon_id 		= 11022, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10004			
	};
get(11032) ->	
		#adventure_dungeon{
			dungeon_id 		= 11032, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10004			
	};
get(11042) ->	
		#adventure_dungeon{
			dungeon_id 		= 11042, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10004			
	};
get(11052) ->	
		#adventure_dungeon{
			dungeon_id 		= 11052, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10004			
	};
get(12011) ->	
		#adventure_dungeon{
			dungeon_id 		= 12011, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12021) ->	
		#adventure_dungeon{
			dungeon_id 		= 12021, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12031) ->	
		#adventure_dungeon{
			dungeon_id 		= 12031, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12041) ->	
		#adventure_dungeon{
			dungeon_id 		= 12041, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12051) ->	
		#adventure_dungeon{
			dungeon_id 		= 12051, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12061) ->	
		#adventure_dungeon{
			dungeon_id 		= 12061, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10005			
	};
get(12012) ->	
		#adventure_dungeon{
			dungeon_id 		= 12012, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(12022) ->	
		#adventure_dungeon{
			dungeon_id 		= 12022, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(12032) ->	
		#adventure_dungeon{
			dungeon_id 		= 12032, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(12042) ->	
		#adventure_dungeon{
			dungeon_id 		= 12042, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(12052) ->	
		#adventure_dungeon{
			dungeon_id 		= 12052, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(12062) ->	
		#adventure_dungeon{
			dungeon_id 		= 12062, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10006			
	};
get(13011) ->	
		#adventure_dungeon{
			dungeon_id 		= 13011, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10007			
	};
get(13021) ->	
		#adventure_dungeon{
			dungeon_id 		= 13021, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10007			
	};
get(13031) ->	
		#adventure_dungeon{
			dungeon_id 		= 13031, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10007			
	};
get(13041) ->	
		#adventure_dungeon{
			dungeon_id 		= 13041, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10007			
	};
get(13051) ->	
		#adventure_dungeon{
			dungeon_id 		= 13051, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10007			
	};
get(13012) ->	
		#adventure_dungeon{
			dungeon_id 		= 13012, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10008			
	};
get(13022) ->	
		#adventure_dungeon{
			dungeon_id 		= 13022, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10008			
	};
get(13032) ->	
		#adventure_dungeon{
			dungeon_id 		= 13032, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10008			
	};
get(13042) ->	
		#adventure_dungeon{
			dungeon_id 		= 13042, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10008			
	};
get(13052) ->	
		#adventure_dungeon{
			dungeon_id 		= 13052, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10008			
	};
get(13111) ->	
		#adventure_dungeon{
			dungeon_id 		= 13111, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10009			
	};
get(13121) ->	
		#adventure_dungeon{
			dungeon_id 		= 13121, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10009			
	};
get(13131) ->	
		#adventure_dungeon{
			dungeon_id 		= 13131, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10009			
	};
get(13141) ->	
		#adventure_dungeon{
			dungeon_id 		= 13141, 
			max 			= 5,
			must 			= 1,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10009			
	};
get(13151) ->	
		#adventure_dungeon{
			dungeon_id 		= 13151, 
			max 			= 5,
			must 			= 0,
			hole_weight 	= 15,
			clear_weight 	= 15,
			hole_id	 		= 10009			
	};
get(13112) ->	
		#adventure_dungeon{
			dungeon_id 		= 13112, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10010			
	};
get(13122) ->	
		#adventure_dungeon{
			dungeon_id 		= 13122, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10010			
	};
get(13132) ->	
		#adventure_dungeon{
			dungeon_id 		= 13132, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10010			
	};
get(13142) ->	
		#adventure_dungeon{
			dungeon_id 		= 13142, 
			max 			= 3,
			must 			= 0,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10010			
	};
get(13152) ->	
		#adventure_dungeon{
			dungeon_id 		= 13152, 
			max 			= 3,
			must 			= 1,
			hole_weight 	= 35,
			clear_weight 	= 35,
			hole_id	 		= 10010			
	};

get(_) ->
    {false, <<"数据不存在">>}.
	

get_hole(10000) ->	
		#adventure_hole{
			hole_id 		= 10000, 
			account_num 	= {6,8},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3000},{25,2,coin,0,4500},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,8},{35,2,coin,0,4500},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 15,
			item_awd 		= [{20,1,gold_bind,0,8},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 35,
			box_awd 		= [{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10001) ->	
		#adventure_hole{
			hole_id 		= 10001, 
			account_num 	= {6,8},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3000},{25,2,coin,0,4500},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,8},{35,2,coin,0,4500},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,8},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10002) ->	
		#adventure_hole{
			hole_id 		= 10002, 
			account_num 	= {6,8},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3000},{25,2,coin,0,4500},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,8},{35,2,coin,0,4500},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,8},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10003) ->	
		#adventure_hole{
			hole_id 		= 10003, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3500},{25,2,coin,0,5000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,9},{35,2,coin,0,5000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,9},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10004) ->	
		#adventure_hole{
			hole_id 		= 10004, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3500},{25,2,coin,0,5000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,9},{35,2,coin,0,5000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,9},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10005) ->	
		#adventure_hole{
			hole_id 		= 10005, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3500},{25,2,coin,0,5000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,9},{35,2,coin,0,5000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,9},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10006) ->	
		#adventure_hole{
			hole_id 		= 10006, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,3500},{25,2,coin,0,5000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,9},{35,2,coin,0,5000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,9},{20,2,coin,0,3000},{20,3,stone,0,600},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1}],
			box_max 		= 3			
	};
get_hole(10007) ->	
		#adventure_hole{
			hole_id 		= 10007, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,5000},{25,2,coin,0,6000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,12},{35,2,coin,0,6000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,12},{20,2,coin,0,5000},{20,3,stone,0,950},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1},{3,3,item,611101,1}],
			box_max 		= 3			
	};
get_hole(10008) ->	
		#adventure_hole{
			hole_id 		= 10008, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,5000},{25,2,coin,0,6000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,12},{35,2,coin,0,6000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,12},{20,2,coin,0,5000},{20,3,stone,0,950},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1},{3,3,item,611101,1}],
			box_max 		= 3			
	};
get_hole(10009) ->	
		#adventure_hole{
			hole_id 		= 10009, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,5500},{25,2,coin,0,7000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,15},{35,2,coin,0,7000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,15},{20,2,coin,0,5500},{20,3,stone,0,1050},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1},{3,3,item,611101,1}],
			box_max 		= 3			
	};
get_hole(10010) ->	
		#adventure_hole{
			hole_id 		= 10010, 
			account_num 	= {6,10},
			barrier_wei 	= 25,
			barrier_awd 	= [{25,1,coin,0,5500},{25,2,coin,0,7000},{25,1,empty,0,0},{25,2,empty,0,0}],
			npc_wei 		= 25,
			npc_awd 		= [{35,1,gold_bind,0,15},{35,2,coin,0,7000},{15,1,empty,0,0},{15,2,empty,0,0}],
			item_wei 		= 25,
			item_awd 		= [{20,1,gold_bind,0,15},{20,2,coin,0,5500},{20,3,stone,0,1050},{20,1,empty,0,0},{10,2,empty,0,0},{10,3,empty,0,0}],
			box_wei 		= 25,
			box_awd 		= [{18,1,item,221101,1},{16,1,item,111001,1},{16,1,item,111011,1},{16,1,item,111301,1},{10,2,item,221103,1},{12,2,item,221102,1},{10,2,item,131001,1},{10,2,item,221104,1},{8,3,item,621501,1},{5,3,item,111002,1},{5,3,item,111012,1},{3,3,item,611101,1}],
			box_max 		= 3			
	};

get_hole(_) ->
    {false, <<"数据不存在">>}.

	
	
	
	
