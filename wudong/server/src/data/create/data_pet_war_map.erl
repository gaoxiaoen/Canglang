%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_war_map
	%%% @Created : 2017-12-27 22:51:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_war_map).
-export([get/1]).
-export([ids/0]).
-include("pet_war.hrl").

get(1) -> #base_pet_map{id = 1 ,map = [1,2,3,4,5]};

get(2) -> #base_pet_map{id = 2 ,map = [1,3,5,7,9]};

get(3) -> #base_pet_map{id = 3 ,map = [1,2,3,7,9]};

get(4) -> #base_pet_map{id = 4 ,map = [1,2,3,5,8]};

get(5) -> #base_pet_map{id = 5 ,map = [2,4,5,6,8]};

get(6) -> #base_pet_map{id = 6 ,map = [2]};

get(7) -> #base_pet_map{id = 7 ,map = [1,3]};

get(8) -> #base_pet_map{id = 8 ,map = [1,2,3]};

get(9) -> #base_pet_map{id = 9 ,map = [1,2,3,5]};

get(_) ->  [].

ids() ->  [1,2,3,4,5,6,7,8,9].
