%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_ring_material
	%%% @Created : 2018-04-27 14:20:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_ring_material).
-export([get/1]).
-export([get_all/0]).
-include("marry.hrl").
get(7206001) -> 1;
get(7206002) -> 10;
get(7206003) -> 100;
get(_) -> [].
    get_all() ->
    [{ 7206001,1  },{ 7206002,10  },{ 7206003,100  }].
