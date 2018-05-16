%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_monopoly
	%%% @Created : 2016-07-28 14:44:21
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_monopoly).
-export([get/1]).
-export([get_all/0]).
-include("monopoly.hrl").
-include("common.hrl").
  get(1) -> #base_monopoly{id=1,type=1,args=20000,times=4,msg=?T("获得绑金") };
  get(2) -> #base_monopoly{id=2,type=2,args=0,times=4,msg=?T("再抛一次") };
  get(3) -> #base_monopoly{id=3,type=3,args=10000,times=4,msg=?T("损失金币") };
  get(4) -> #base_monopoly{id=4,type=4,args=20,times=4,msg=?T("获得绑钻") };
  get(5) -> #base_monopoly{id=5,type=5,args=0,times=2,msg=?T("黑洞") };
  get(6) -> #base_monopoly{id=6,type=6,args={50000,10000,20000},times=2,msg=?T("猜拳") };
  get(7) -> #base_monopoly{id=7,type=7,args=24616,times=1,msg=?T("招宠蛋") };
  get(8) -> #base_monopoly{id=8,type=8,args=0,times=1,msg=?T("起点") };
get(_) -> [].
get_all()->[1,2,3,4,5,6,7,8].

