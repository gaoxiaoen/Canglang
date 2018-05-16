%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_scuffle_elite_party
	%%% @Created : 2017-11-15 16:07:51
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_scuffle_elite_party).
-export([get/1,rounds/0]).
-include("cross_scuffle_elite.hrl").
get(1)  -> #base_desk{ round = 1,desk_list = [{50201, 12, 20}, {50201, 24, 20}, {50201, 12, 36}, {50201, 24,36}], count = 1}; 
get(2)  -> #base_desk{ round = 2,desk_list = [{50201, 12, 20}, {50201, 24, 20}, {50201, 12, 36}, {50201, 24,36}], count = 2}; 
get(3)  -> #base_desk{ round = 3,desk_list = [{50201, 12, 20}, {50201, 24, 20}, {50201, 12, 36}, {50201, 24,36}], count = 3}; 
get(4)  -> #base_desk{ round = 4,desk_list = [{50201, 12, 20}, {50201, 24, 20}, {50201, 12, 36}, {50201, 24,36}], count = 4}; 
get(_) -> []. 

    rounds() ->
    [1,2,3,4].
