%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_monopoly_task
	%%% @Created : 2016-07-27 11:41:33
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_monopoly_task).
-export([get/1]).
-export([get_all/0]).
-include("monopoly.hrl").
-include("common.hrl").
  get(1) -> #base_monopoly_task{id=1,times=3,get_num=1,msg=?T("竞技场胜利") };
  get(3) -> #base_monopoly_task{id=3,times=1,get_num=1,msg=?T("护送橙色水晶") };
  get(4) -> #base_monopoly_task{id=4,times=30,get_num=1,msg=?T("完成跑环任务") };
  get(5) -> #base_monopoly_task{id=5,times=200,get_num=1,msg=?T("消耗强化石") };
  get(6) -> #base_monopoly_task{id=6,times=200,get_num=2,msg=?T("消耗宠物进阶水晶") };
  get(7) -> #base_monopoly_task{id=7,times=200,get_num=2,msg=?T("消耗光翼进阶水晶") };
  get(8) -> #base_monopoly_task{id=8,times=200,get_num=2,msg=?T("消耗坐骑经验水晶") };
  get(9) -> #base_monopoly_task{id=9,times=200,get_num=2,msg=?T("消耗精灵经验水晶") };
  get(10) -> #base_monopoly_task{id=10,times=1,get_num=3,msg=?T("装备升级") };
  get(11) -> #base_monopoly_task{id=11,times=1,get_num=3,msg=?T("装备进阶橙装") };
  get(12) -> #base_monopoly_task{id=12,times=1,get_num=3,msg=?T("宠物升星") };
  get(13) -> #base_monopoly_task{id=13,times=2000000,get_num=1,msg=?T("消耗金币(含绑和非绑)") };
  get(14) -> #base_monopoly_task{id=14,times=980,get_num=3,msg=?T("消耗钻石(含绑和非绑)") };
  get(15) -> #base_monopoly_task{id=15,times=980,get_num=3,msg=?T("充值钻石") };
get(_) -> [].
get_all()->[1,3,4,5,6,7,8,9,10,11,12,13,14,15].

