%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_act_exp_dungeon
	%%% @Created : 2018-01-12 14:32:24
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_act_exp_dungeon).
-export([get/1,get_all/0]).
-include("activity.hrl").
  get(1) -> #base_act_exp_dungeon{ id=1,floor=50 ,reward=[{8001054,20},{10106, 588}] };
  get(2) -> #base_act_exp_dungeon{ id=2,floor=58 ,reward=[{8001054,10},{10106, 388}] };
  get(3) -> #base_act_exp_dungeon{ id=3,floor=66 ,reward=[{8001054,10},{10106, 388}] };
  get(4) -> #base_act_exp_dungeon{ id=4,floor=74 ,reward=[{8001054,10},{10106, 388}] };
  get(5) -> #base_act_exp_dungeon{ id=5,floor=82 ,reward=[{8001054,10},{10106, 388}] };
  get(6) -> #base_act_exp_dungeon{ id=6,floor=90 ,reward=[{8001054,10},{10106, 388}] };
  get(7) -> #base_act_exp_dungeon{ id=7,floor=98 ,reward=[{8001054,10},{10106, 388}] };
  get(8) -> #base_act_exp_dungeon{ id=8,floor=106 ,reward=[{8001054,10},{10106, 388}] };
  get(9) -> #base_act_exp_dungeon{ id=9,floor=114 ,reward=[{8001054,20},{10106, 588}] };
  get(10) -> #base_act_exp_dungeon{ id=10,floor=130 ,reward=[{8001054,20},{10106, 688}] };
get(_) -> [].

    get_all() ->
    [1,2,3,4,5,6,7,8,9,10].
