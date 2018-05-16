%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_party_reward
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_party_reward).
-export([get/2]).
-include("common.hrl").
-include("manor_war.hrl").
get(13003,1) ->
	#base_manor_party_reward{scene_id = 13003 ,lv = 1 ,collect_reward = [{8001090,1}] ,extra_reward = [{10108,10000},{10101,2500}] };
get(13003,2) ->
	#base_manor_party_reward{scene_id = 13003 ,lv = 2 ,collect_reward = [{8001090,1}] ,extra_reward = [{10108,15000},{10101,3750}] };
get(13003,3) ->
	#base_manor_party_reward{scene_id = 13003 ,lv = 3 ,collect_reward = [{8001090,1}] ,extra_reward = [{10108,20000},{10101,5000}] };
get(10002,1) ->
	#base_manor_party_reward{scene_id = 10002 ,lv = 1 ,collect_reward = [{8001091,1}] ,extra_reward = [{10108,10000},{10101,2500}] };
get(10002,2) ->
	#base_manor_party_reward{scene_id = 10002 ,lv = 2 ,collect_reward = [{8001091,1}] ,extra_reward = [{10108,15000},{10101,3750}] };
get(10002,3) ->
	#base_manor_party_reward{scene_id = 10002 ,lv = 3 ,collect_reward = [{8001091,1}] ,extra_reward = [{10108,20000},{10101,5000}] };
get(10003,1) ->
	#base_manor_party_reward{scene_id = 10003 ,lv = 1 ,collect_reward = [{8001092,1}] ,extra_reward = [{10108,10000},{10101,2500}] };
get(10003,2) ->
	#base_manor_party_reward{scene_id = 10003 ,lv = 2 ,collect_reward = [{8001092,1}] ,extra_reward = [{10108,15000},{10101,3750}] };
get(10003,3) ->
	#base_manor_party_reward{scene_id = 10003 ,lv = 3 ,collect_reward = [{8001092,1}] ,extra_reward = [{10108,20000},{10101,5000}] };
get(10004,1) ->
	#base_manor_party_reward{scene_id = 10004 ,lv = 1 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,10000},{10101,2500}] };
get(10004,2) ->
	#base_manor_party_reward{scene_id = 10004 ,lv = 2 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,15000},{10101,3750}] };
get(10004,3) ->
	#base_manor_party_reward{scene_id = 10004 ,lv = 3 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,20000},{10101,5000}] };
get(10006,1) ->
	#base_manor_party_reward{scene_id = 10006 ,lv = 1 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,10000},{10101,2500}] };
get(10006,2) ->
	#base_manor_party_reward{scene_id = 10006 ,lv = 2 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,15000},{10101,3750}] };
get(10006,3) ->
	#base_manor_party_reward{scene_id = 10006 ,lv = 3 ,collect_reward = [{8001093,1}] ,extra_reward = [{10108,20000},{10101,5000}] };
get(_,_) -> [].