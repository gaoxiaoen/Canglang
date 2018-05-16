%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_cross_reward_lv
	%%% @Created : 2017-12-25 10:51:59
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_cross_reward_lv).
-export([get/2]).
-export([times_list/0]).
-include("common.hrl").
-include("cross_dungeon.hrl").
get(5,Lv) when Lv =< 80 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 80 ,reward = {{8001301, 3}} ,first_reward = {} };
get(5,Lv) when Lv =< 120 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 120 ,reward = {{8001301, 5}} ,first_reward = {} };
get(5,Lv) when Lv =< 150 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 150 ,reward = {{8001301, 8}} ,first_reward = {} };
get(5,Lv) when Lv =< 180 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 180 ,reward = {{8001301, 10}} ,first_reward = {} };
get(5,Lv) when Lv =< 200 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 200 ,reward = {{8001301, 12}} ,first_reward = {} };
get(5,Lv) when Lv =< 250 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 250 ,reward = {{8001301, 15}} ,first_reward = {} };
get(5,Lv) when Lv =< 300 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 300 ,reward = {{8001301, 15}} ,first_reward = {} };
get(5,Lv) when Lv =< 999 ->
	#base_dun_cross_reward_lv{times = 5 ,lv = 999 ,reward = {{8001301, 15}} ,first_reward = {} };
get(10,Lv) when Lv =< 80 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 80 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 120 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 120 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 150 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 150 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 180 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 180 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 200 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 200 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 250 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 250 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 300 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 300 ,reward = {{8001058,1}} ,first_reward = {} };
get(10,Lv) when Lv =< 999 ->
	#base_dun_cross_reward_lv{times = 10 ,lv = 999 ,reward = {{8001058,1}} ,first_reward = {} };
get(30,Lv) when Lv =< 80 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 80 ,reward = {{8001002,5}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 120 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 120 ,reward = {{8001002,8}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 150 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 150 ,reward = {{8001002,10}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 180 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 180 ,reward = {{8001002,12}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 200 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 200 ,reward = {{8001002,15}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 250 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 250 ,reward = {{8001002,18}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 300 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 300 ,reward = {{8001002,20}} ,first_reward = {{6603088,1}} };
get(30,Lv) when Lv =< 999 ->
	#base_dun_cross_reward_lv{times = 30 ,lv = 999 ,reward = {{8001002,20}} ,first_reward = {{6603088,1}} };
get(_,_) -> [].
    times_list() ->
    [5,10,30].
