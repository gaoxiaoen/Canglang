%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_act_invitation
	%%% @Created : 2018-04-02 10:07:35
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_act_invitation).
-export([get/1,get_all/0]).
-include("activity.hrl").
  get(1) -> #base_act_invitation{ id=1,num=3,gold=0,type=1 ,ratio=20 };
  get(2) -> #base_act_invitation{ id=2,num=5,gold=0,type=1 ,ratio=100 };
  get(3) -> #base_act_invitation{ id=3,num=10,gold=0,type=1 ,ratio=150 };
  get(4) -> #base_act_invitation{ id=4,num=25,gold=0,type=1 ,ratio=200 };
  get(5) -> #base_act_invitation{ id=5,num=50,gold=500,type=2 ,ratio=10 };
  get(6) -> #base_act_invitation{ id=6,num=100,gold=500,type=2 ,ratio=20 };
get(_) -> [].

    get_all() ->
    [1,2,3,4,5,6].
