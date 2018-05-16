%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wybq
	%%% @Created : 2018-02-08 15:54:15
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wybq).
-export([get/1, get_all/0]).
-include("wybq.hrl").
get(1) -> #base_wybq{type = 1, percent = 22, desc = "等级"};
get(2) -> #base_wybq{type = 2, percent = 2216, desc = "装备"};
get(3) -> #base_wybq{type = 3, percent = 865, desc = "宠物"};
get(4) -> #base_wybq{type = 4, percent = 449, desc = "坐骑"};
get(5) -> #base_wybq{type = 5, percent = 383, desc = "仙羽"};
get(6) -> #base_wybq{type = 6, percent = 377, desc = "神兵"};
get(7) -> #base_wybq{type = 7, percent = 375, desc = "法器"};
get(8) -> #base_wybq{type = 8, percent = 162, desc = "十荒神器"};
get(9) -> #base_wybq{type = 9, percent = 392, desc = "经脉"};
get(10) -> #base_wybq{type = 10, percent = 43, desc = "剑池"};
get(11) -> #base_wybq{type = 11, percent = 57, desc = "图鉴"};
get(12) -> #base_wybq{type = 12, percent = 42, desc = "仙盟技能"};
get(13) -> #base_wybq{type = 13, percent = 84, desc = "个人技能"};
get(14) -> #base_wybq{type = 14, percent = 380, desc = "妖灵"};
get(15) -> #base_wybq{type = 15, percent = 383, desc = "足迹"};
get(16) -> #base_wybq{type = 16, percent = 377, desc = "灵猫"};
get(17) -> #base_wybq{type = 17, percent = 379, desc = "法身"};
get(18) -> #base_wybq{type = 18, percent = 684, desc = "符文"};
get(19) -> #base_wybq{type = 19, percent = 293, desc = "姻缘"};
get(20) -> #base_wybq{type = 20, percent = 1266, desc = "宝宝"};
get(21) -> #base_wybq{type = 21, percent = 377, desc = "灵羽"};
get(22) -> #base_wybq{type = 22, percent = 377, desc = "灵骑"};
get(23) -> #base_wybq{type = 23, percent = 377, desc = "灵弓"};
get(_Type) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23].

