%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_play_point
	%%% @Created : 2016-08-04 23:35:38
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_play_point).
-export([get_all/0]).
-include("common.hrl").
-include("server.hrl").
get_all()->[
	#play_point{type = 1,sub_id = 1,sub_name = ?T("经验、强化石")},
	#play_point{type = 1,sub_id = 2,sub_name = ?T("装备升级材料")},
	#play_point{type = 1,sub_id = 3,sub_name = ?T("经验、洗练石")},
	#play_point{type = 1,sub_id = 4,sub_name = ?T("经验、宝石")},
	#play_point{type = 1,sub_id = 5,sub_name = ?T("经验、坐骑水晶")},
	#play_point{type = 1,sub_id = 6,sub_name = ?T("经验、天堂之羽")},
	#play_point{type = 1,sub_id = 7,sub_name = ?T("经验、宠物水晶")},
	#play_point{type = 2,sub_id = 1,sub_name = ?T("海量经验金币")},
	#play_point{type = 2,sub_id = 2,sub_name = ?T("海量经验金币")},
	#play_point{type = 2,sub_id = 3,sub_name = ?T("金币、珍稀道具")},
	#play_point{type = 2,sub_id = 4,sub_name = ?T("精灵装备")},
	#play_point{type = 3,sub_id = 1,sub_name = ?T("大量经验")},
	#play_point{type = 3,sub_id = 2,sub_name = ?T("海量经验金币")},
	#play_point{type = 3,sub_id = 3,sub_name = ?T("大量经验星魂")},
	#play_point{type = 3,sub_id = 4,sub_name = ?T("经验、坐骑装备")},
	#play_point{type = 3,sub_id = 5,sub_name = ?T("挂机拿经验")},
	#play_point{type = 4,sub_id = 1,sub_name = ?T("钻石、竞技积分")},
	#play_point{type = 4,sub_id = 2,sub_name = ?T("金币、宠物")},
	#play_point{type = 4,sub_id = 3,sub_name = ?T("金币、装备材料")},
	#play_point{type = 5,sub_id = 1,sub_name = ?T("神秘好礼")},
	#play_point{type = 5,sub_id = 2,sub_name = ?T("钻石、经验")},
	#play_point{type = 5,sub_id = 3,sub_name = ?T("装备升级材料")},
	#play_point{type = 5,sub_id = 4,sub_name = ?T("装备升星材料")},
	#play_point{type = 5,sub_id = 5,sub_name = ?T("公会功勋")},
	#play_point{type = 5,sub_id = 6,sub_name = ?T("高级宝石")},
	#play_point{type = 5,sub_id = 7,sub_name = ?T("装备升星材料")},
	#play_point{type = 5,sub_id = 8,sub_name = ?T("装备升星材料")},
	#play_point{type = 6,sub_id = 1,sub_name = ?T("宠物碎片")},
	#play_point{type = 6,sub_id = 2,sub_name = ?T("橙装水晶")},
	#play_point{type = 6,sub_id = 3,sub_name = ?T("装备升级材料")},
	#play_point{type = 6,sub_id = 4,sub_name = ?T("金币经验材料")}
].
