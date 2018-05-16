%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_war_target
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_war_target).
-export([target_list/0]).
-export([target_stage_lim/1]).
-export([get/2]).
-include("common.hrl").
-include("manor_war.hrl").

    target_list() ->
    [1,2,3].
target_stage_lim(1) -> 3;
target_stage_lim(2) -> 3;
target_stage_lim(3) -> 3;
target_stage_lim(_) -> 0.
get(1,1) ->
	#base_manor_war_target{target_id = 1 ,stage = 1 ,times = 5 ,reward = [{10106,10},{8001057,3},{2003000,3},{2005000,3}] };
get(1,2) ->
	#base_manor_war_target{target_id = 1 ,stage = 2 ,times = 10 ,reward = [{10106,20},{8001057,6},{2003000,5},{2005000,5}] };
get(1,3) ->
	#base_manor_war_target{target_id = 1 ,stage = 3 ,times = 15 ,reward = [{10106,30},{8001057,9},{2003000,10},{2005000,10}] };
get(2,1) ->
	#base_manor_war_target{target_id = 2 ,stage = 1 ,times = 3 ,reward = [{10106,10},{8001085,3},{2003000,3},{2005000,3}] };
get(2,2) ->
	#base_manor_war_target{target_id = 2 ,stage = 2 ,times = 6 ,reward = [{10106,20},{8001085,6},{2003000,5},{2005000,5}] };
get(2,3) ->
	#base_manor_war_target{target_id = 2 ,stage = 3 ,times = 10 ,reward = [{10106,30},{8001085,9},{2003000,10},{2005000,10}] };
get(3,1) ->
	#base_manor_war_target{target_id = 3 ,stage = 1 ,times = 3 ,reward = [{10106,10},{8001054,3},{2003000,3},{2005000,3}] };
get(3,2) ->
	#base_manor_war_target{target_id = 3 ,stage = 2 ,times = 6 ,reward = [{10106,20},{8001054,6},{2003000,5},{2005000,5}] };
get(3,3) ->
	#base_manor_war_target{target_id = 3 ,stage = 3 ,times = 10 ,reward = [{10106,30},{8001054,9},{2003000,10},{2005000,10}] };
get(_,_) -> [].