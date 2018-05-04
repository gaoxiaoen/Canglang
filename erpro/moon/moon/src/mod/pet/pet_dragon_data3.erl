%% -----------------------
%% 宠物龙族遗迹探寻数据
%% @autor wangweibiao
%% ------------------------
-module(pet_dragon_data3).
-export([get_all_item/0,
		get/1]).
	
-include("pet.hrl").

get_all_item() ->
	[
		#pet_dragon_item{
		item_id =132001, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132002, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132003, 
		weight = 50,
		lucky = 4000
		},
	#pet_dragon_item{
		item_id =132006, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132007, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132008, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132011, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132012, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132013, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132016, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132017, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132018, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132021, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132022, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132023, 
		weight = 200,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132026, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132027, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132028, 
		weight = 50,
		lucky = 4000
		},
	#pet_dragon_item{
		item_id =132031, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132032, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132033, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132036, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132037, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132038, 
		weight = 200,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132041, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132042, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132043, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132046, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132047, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132048, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132051, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132052, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132053, 
		weight = 50,
		lucky = 4000
		},
	#pet_dragon_item{
		item_id =132056, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132057, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132058, 
		weight = 150,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132061, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132062, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132063, 
		weight = 100,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132066, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132067, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132068, 
		weight = 250,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132071, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132072, 
		weight = 0,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =132073, 
		weight = 250,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =621501, 
		weight = 300,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =621502, 
		weight = 200,
		lucky = 2500
		},
	#pet_dragon_item{
		item_id =621503, 
		weight = 200,
		lucky = 2500
		}
].


get(132001) ->
	{ok, #pet_dragon_item{
		item_id = 132001,
		item_name = <<"低阶连击符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132002) ->
	{ok, #pet_dragon_item{
		item_id = 132002,
		item_name = <<"中阶连击符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132003) ->
	{ok, #pet_dragon_item{
		item_id = 132003,
		item_name = <<"高阶连击符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132006) ->
	{ok, #pet_dragon_item{
		item_id = 132006,
		item_name = <<"低阶暴怒符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132007) ->
	{ok, #pet_dragon_item{
		item_id = 132007,
		item_name = <<"中阶暴怒符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132008) ->
	{ok, #pet_dragon_item{
		item_id = 132008,
		item_name = <<"高阶暴怒符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132011) ->
	{ok, #pet_dragon_item{
		item_id = 132011,
		item_name = <<"低阶精准符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132012) ->
	{ok, #pet_dragon_item{
		item_id = 132012,
		item_name = <<"中阶精准符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132013) ->
	{ok, #pet_dragon_item{
		item_id = 132013,
		item_name = <<"高阶精准符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132016) ->
	{ok, #pet_dragon_item{
		item_id = 132016,
		item_name = <<"低阶格挡符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132017) ->
	{ok, #pet_dragon_item{
		item_id = 132017,
		item_name = <<"中阶格挡符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132018) ->
	{ok, #pet_dragon_item{
		item_id = 132018,
		item_name = <<"高阶格挡符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132021) ->
	{ok, #pet_dragon_item{
		item_id = 132021,
		item_name = <<"低阶坚韧符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132022) ->
	{ok, #pet_dragon_item{
		item_id = 132022,
		item_name = <<"中阶坚韧符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132023) ->
	{ok, #pet_dragon_item{
		item_id = 132023,
		item_name = <<"高阶坚韧符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132026) ->
	{ok, #pet_dragon_item{
		item_id = 132026,
		item_name = <<"低阶重生符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132027) ->
	{ok, #pet_dragon_item{
		item_id = 132027,
		item_name = <<"中阶重生符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132028) ->
	{ok, #pet_dragon_item{
		item_id = 132028,
		item_name = <<"高阶重生符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132031) ->
	{ok, #pet_dragon_item{
		item_id = 132031,
		item_name = <<"低阶抗性符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132032) ->
	{ok, #pet_dragon_item{
		item_id = 132032,
		item_name = <<"中阶抗性符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132033) ->
	{ok, #pet_dragon_item{
		item_id = 132033,
		item_name = <<"高阶抗性符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132036) ->
	{ok, #pet_dragon_item{
		item_id = 132036,
		item_name = <<"低阶防御符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132037) ->
	{ok, #pet_dragon_item{
		item_id = 132037,
		item_name = <<"中阶防御符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132038) ->
	{ok, #pet_dragon_item{
		item_id = 132038,
		item_name = <<"高阶防御符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132041) ->
	{ok, #pet_dragon_item{
		item_id = 132041,
		item_name = <<"低阶毒焰符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132042) ->
	{ok, #pet_dragon_item{
		item_id = 132042,
		item_name = <<"中阶毒焰符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132043) ->
	{ok, #pet_dragon_item{
		item_id = 132043,
		item_name = <<"高阶毒焰符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132046) ->
	{ok, #pet_dragon_item{
		item_id = 132046,
		item_name = <<"低阶攻击符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132047) ->
	{ok, #pet_dragon_item{
		item_id = 132047,
		item_name = <<"中阶攻击符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132048) ->
	{ok, #pet_dragon_item{
		item_id = 132048,
		item_name = <<"高阶攻击符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132051) ->
	{ok, #pet_dragon_item{
		item_id = 132051,
		item_name = <<"低阶破甲符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132052) ->
	{ok, #pet_dragon_item{
		item_id = 132052,
		item_name = <<"中阶破甲符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132053) ->
	{ok, #pet_dragon_item{
		item_id = 132053,
		item_name = <<"高阶破甲符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132056) ->
	{ok, #pet_dragon_item{
		item_id = 132056,
		item_name = <<"低阶破魔符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132057) ->
	{ok, #pet_dragon_item{
		item_id = 132057,
		item_name = <<"中阶破魔符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132058) ->
	{ok, #pet_dragon_item{
		item_id = 132058,
		item_name = <<"高阶破魔符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132061) ->
	{ok, #pet_dragon_item{
		item_id = 132061,
		item_name = <<"低阶守护符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132062) ->
	{ok, #pet_dragon_item{
		item_id = 132062,
		item_name = <<"中阶守护符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132063) ->
	{ok, #pet_dragon_item{
		item_id = 132063,
		item_name = <<"高阶守护符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132066) ->
	{ok, #pet_dragon_item{
		item_id = 132066,
		item_name = <<"低阶治愈符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132067) ->
	{ok, #pet_dragon_item{
		item_id = 132067,
		item_name = <<"中阶治愈符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132068) ->
	{ok, #pet_dragon_item{
		item_id = 132068,
		item_name = <<"高阶治愈符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(132071) ->
	{ok, #pet_dragon_item{
		item_id = 132071,
		item_name = <<"低阶回魔符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132072) ->
	{ok, #pet_dragon_item{
		item_id = 132072,
		item_name = <<"中阶回魔符文">>,
		price = 10,
		high_lev = 0
		}
	};
get(132073) ->
	{ok, #pet_dragon_item{
		item_id = 132073,
		item_name = <<"高阶回魔符文">>,
		price = 10,
		high_lev = 1
		}
	};
get(621501) ->
	{ok, #pet_dragon_item{
		item_id = 621501,
		item_name = <<"小瓶魔法气息">>,
		price = 10,
		high_lev = 0
		}
	};
get(621502) ->
	{ok, #pet_dragon_item{
		item_id = 621502,
		item_name = <<"中瓶魔法气息">>,
		price = 10,
		high_lev = 0
		}
	};
get(621503) ->
	{ok, #pet_dragon_item{
		item_id = 621503,
		item_name = <<"大瓶魔法气息">>,
		price = 10,
		high_lev = 1
		}
	}.


