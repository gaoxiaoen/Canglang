%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_collection_hero
	%%% @Created : 2018-04-02 10:08:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_collection_hero).
-export([get/1,get_all/0]).
-include("activity.hrl").
  get(1) -> #base_collection_hero{ id=1,gold=50000000,goods_list=[{10106, 10000},{2001000, 100},{2002000, 50},{2003000, 50},{2011000, 5}] };
  get(2) -> #base_collection_hero{ id=2,gold=500000,goods_list=[{10106, 2000},{2001000, 10},{2002000, 5},{2003000, 10}] };
  get(3) -> #base_collection_hero{ id=3,gold=0,goods_list=[{10106, 500},{2003000, 5}] };
get(_) -> [].

    get_all() ->
    [1,2,3].
