%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_drop_vitality
	%%% @Created : 2017-04-13 15:02:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_drop_vitality).
-export([get/1]).
-export([get_all/0]).
-export([get_type/1]).
-include("drop_vitality.hrl").
-include("common.hrl").
  get(10001) -> #base_d_v{id=10001,args={1},type=1,point=100,refresh_type=1 };
  get(10002) -> #base_d_v{id=10002,args={100},type=2,point=40,refresh_type=1 };
  get(10003) -> #base_d_v{id=10003,args={80},type=2,point=30,refresh_type=1 };
  get(10004) -> #base_d_v{id=10004,args={70},type=2,point=20,refresh_type=1 };
  get(10005) -> #base_d_v{id=10005,args={60},type=2,point=10,refresh_type=1 };
  get(10006) -> #base_d_v{id=10006,args={200},type=14,point=100,refresh_type=2 };
  get(10007) -> #base_d_v{id=10007,args={150},type=14,point=80,refresh_type=2 };
  get(10008) -> #base_d_v{id=10008,args={100},type=14,point=50,refresh_type=2 };
  get(10009) -> #base_d_v{id=10009,args={60},type=14,point=30,refresh_type=2 };
  get(10010) -> #base_d_v{id=10010,args={50},type=14,point=10,refresh_type=2 };
get(_) -> [].
get_all()->[10001,10002,10003,10004,10005,10006,10007,10008,10009,10010].

get_type(1) -> [10001];
get_type(2) -> [10002,10003,10004,10005];
get_type(14) -> [10006,10007,10008,10009,10010];
get_type(_) -> [].
