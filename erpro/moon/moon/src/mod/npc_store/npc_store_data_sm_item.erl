%% -----------------------
%% npc神秘商店物品配置表
%% @autor wangweibiao
%% ------------------------
-module(npc_store_data_sm_item).
-export([
		get_all_item_length/0,
		get_all_item/0,
		get/1]).
	
-include("npc_store.hrl").
-include("common.hrl").

get_all_item_length() ->
	37.

get_all_item() ->
	[	
		#npc_store_base_item{
		item_id =601001, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 1		
		},
	#npc_store_base_item{
		item_id =111001, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 2		
		},
	#npc_store_base_item{
		item_id =621100, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 3		
		},
	#npc_store_base_item{
		item_id =111301, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 4		
		},
	#npc_store_base_item{
		item_id =641201, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 5		
		},
	#npc_store_base_item{
		item_id =231001, 
		weight = 520,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 6		
		},
	#npc_store_base_item{
		item_id =111701, 
		weight = 80,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 7		
		},
	#npc_store_base_item{
		item_id =231002, 
		weight = 80,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 8		
		},
	#npc_store_base_item{
		item_id =221103, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 9		
		},
	#npc_store_base_item{
		item_id =131001, 
		weight = 600,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 10		
		},
	#npc_store_base_item{
		item_id =621501, 
		weight = 500,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 11		
		},
	#npc_store_base_item{
		item_id =621502, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 12		
		},
	#npc_store_base_item{
		item_id =111101, 
		weight = 300,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 13		
		},
	#npc_store_base_item{
		item_id =111102, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 14		
		},
	#npc_store_base_item{
		item_id =111103, 
		weight = 80,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 15		
		},
	#npc_store_base_item{
		item_id =111202, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 16		
		},
	#npc_store_base_item{
		item_id =111212, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 17		
		},
	#npc_store_base_item{
		item_id =111222, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 18		
		},
	#npc_store_base_item{
		item_id =111232, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 19		
		},
	#npc_store_base_item{
		item_id =111242, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 20		
		},
	#npc_store_base_item{
		item_id =111252, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 21		
		},
	#npc_store_base_item{
		item_id =111262, 
		weight = 250,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 22		
		},
	#npc_store_base_item{
		item_id =111272, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 23		
		},
	#npc_store_base_item{
		item_id =111203, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 24		
		},
	#npc_store_base_item{
		item_id =111213, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 25		
		},
	#npc_store_base_item{
		item_id =111223, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 26		
		},
	#npc_store_base_item{
		item_id =111233, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 27		
		},
	#npc_store_base_item{
		item_id =111243, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 28		
		},
	#npc_store_base_item{
		item_id =111253, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 29		
		},
	#npc_store_base_item{
		item_id =111263, 
		weight = 100,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 30		
		},
	#npc_store_base_item{
		item_id =111273, 
		weight = 50,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 31		
		},
	#npc_store_base_item{
		item_id =535644, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 32		
		},
	#npc_store_base_item{
		item_id =535608, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 33		
		},
	#npc_store_base_item{
		item_id =535643, 
		weight = 400,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 34		
		},
	#npc_store_base_item{
		item_id =535632, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 35		
		},
	#npc_store_base_item{
		item_id =535609, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 36		
		},
	#npc_store_base_item{
		item_id =535606, 
		weight = 200,
		weight_temp = 0,
		times_max = 0,
		times_max_undisplay = 0,
		times_limit_display = 0,
		times_limit = 1,
		times_terminate = 0,
		count = 0,
		order = 37		
		}].

get(1) ->
	{ok, #npc_store_item2{
		item_id = 601001,
		item_name = <<"背包拓展器">>,
		price = 1000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(2) ->
	{ok, #npc_store_item2{
		item_id = 111001,
		item_name = <<"强化石">>,
		price = 2000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(3) ->
	{ok, #npc_store_item2{
		item_id = 621100,
		item_name = <<"潜能石">>,
		price = 3000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(4) ->
	{ok, #npc_store_item2{
		item_id = 111301,
		item_name = <<"鉴定石">>,
		price = 8000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(5) ->
	{ok, #npc_store_item2{
		item_id = 641201,
		item_name = <<"妖精饼干">>,
		price = 10000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(6) ->
	{ok, #npc_store_item2{
		item_id = 231001,
		item_name = <<"强化神源">>,
		price = 10000,
		price_type = 0,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(7) ->
	{ok, #npc_store_item2{
		item_id = 111701,
		item_name = <<"4级宝石合成卷轴">>,
		price = 120000,
		price_type = 0,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(8) ->
	{ok, #npc_store_item2{
		item_id = 231002,
		item_name = <<"神觉强化护纹">>,
		price = 150000,
		price_type = 0,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(9) ->
	{ok, #npc_store_item2{
		item_id = 221103,
		item_name = <<"符石砂罐">>,
		price = 10,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(10) ->
	{ok, #npc_store_item2{
		item_id = 131001,
		item_name = <<"技能残卷">>,
		price = 10,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(11) ->
	{ok, #npc_store_item2{
		item_id = 621501,
		item_name = <<"小瓶魔法气息">>,
		price = 40,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(12) ->
	{ok, #npc_store_item2{
		item_id = 621502,
		item_name = <<"中瓶魔法气息">>,
		price = 75,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(13) ->
	{ok, #npc_store_item2{
		item_id = 111101,
		item_name = <<"蓝色棱晶">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(14) ->
	{ok, #npc_store_item2{
		item_id = 111102,
		item_name = <<"紫色棱晶">>,
		price = 50,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(15) ->
	{ok, #npc_store_item2{
		item_id = 111103,
		item_name = <<"粉色棱晶">>,
		price = 100,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(16) ->
	{ok, #npc_store_item2{
		item_id = 111202,
		item_name = <<"二级生命宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(17) ->
	{ok, #npc_store_item2{
		item_id = 111212,
		item_name = <<"二级攻击宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(18) ->
	{ok, #npc_store_item2{
		item_id = 111222,
		item_name = <<"二级防御宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(19) ->
	{ok, #npc_store_item2{
		item_id = 111232,
		item_name = <<"二级暴怒宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(20) ->
	{ok, #npc_store_item2{
		item_id = 111242,
		item_name = <<"二级精准宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(21) ->
	{ok, #npc_store_item2{
		item_id = 111252,
		item_name = <<"二级格挡宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(22) ->
	{ok, #npc_store_item2{
		item_id = 111262,
		item_name = <<"二级坚韧宝石">>,
		price = 20,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(23) ->
	{ok, #npc_store_item2{
		item_id = 111272,
		item_name = <<"二级敏捷宝石">>,
		price = 30,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(24) ->
	{ok, #npc_store_item2{
		item_id = 111203,
		item_name = <<"三级生命宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(25) ->
	{ok, #npc_store_item2{
		item_id = 111213,
		item_name = <<"三级攻击宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(26) ->
	{ok, #npc_store_item2{
		item_id = 111223,
		item_name = <<"三级防御宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(27) ->
	{ok, #npc_store_item2{
		item_id = 111233,
		item_name = <<"三级暴怒宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(28) ->
	{ok, #npc_store_item2{
		item_id = 111243,
		item_name = <<"三级精准宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(29) ->
	{ok, #npc_store_item2{
		item_id = 111253,
		item_name = <<"三级格挡宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(30) ->
	{ok, #npc_store_item2{
		item_id = 111263,
		item_name = <<"三级坚韧宝石">>,
		price = 60,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(31) ->
	{ok, #npc_store_item2{
		item_id = 111273,
		item_name = <<"三级敏捷宝石">>,
		price = 100,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(32) ->
	{ok, #npc_store_item2{
		item_id = 535644,
		item_name = <<"种子怪碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(33) ->
	{ok, #npc_store_item2{
		item_id = 535608,
		item_name = <<"狂暴野猪碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(34) ->
	{ok, #npc_store_item2{
		item_id = 535643,
		item_name = <<"永罚怨灵碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 2,
		is_music = 0,
		is_recommend = 0
		}
	};
get(35) ->
	{ok, #npc_store_item2{
		item_id = 535632,
		item_name = <<"拳王碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(36) ->
	{ok, #npc_store_item2{
		item_id = 535609,
		item_name = <<"咆哮棕熊碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(37) ->
	{ok, #npc_store_item2{
		item_id = 535606,
		item_name = <<"牛头恶魔碎片匣">>,
		price = 25,
		price_type = 3,
		is_notice = 1,
		is_music = 0,
		is_recommend = 0
		}
	};
get(_) ->
	{false, ?L(<<"物品不存在">>)}.

