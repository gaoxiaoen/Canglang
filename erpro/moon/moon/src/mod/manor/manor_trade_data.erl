-module(manor_trade_data).
-export(
			[
				get_npc_conf/1
			]
		).
		
-include("item.hrl").



get_npc_conf(1012) -> {600,1200,75};
get_npc_conf(1013) -> {1600,3600,75};
get_npc_conf(1014) -> {4200,10800,75};
get_npc_conf(1015) -> {6500,18000,75};
get_npc_conf(1016) -> {12000,36000,75};
get_npc_conf(1017) -> {22500,72000,75};
get_npc_conf(_Id) -> false.

