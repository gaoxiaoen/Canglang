-module(manor_train_data).
-export(
			[
				get_npc_conf/1
			]
		).
		
-include("item.hrl").



get_npc_conf(1018) -> {8000,60,67};
get_npc_conf(1019) -> {42000,180,167};
get_npc_conf(1020) -> {240000,720,333};
get_npc_conf(_Id) -> false.

