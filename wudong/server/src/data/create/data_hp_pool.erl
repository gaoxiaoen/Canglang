%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_hp_pool
	%%% @Created : 2017-11-22 14:10:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_hp_pool).
-export([recover_cd/0]).
-export([scene_type/0]).
-export([scene_lim/0]).
-export([hp_percent/0]).
-include("common.hrl").
recover_cd() ->3.
scene_type() ->{0,1,2,3,5,6,7,9,10,12,14,15,21,28,99,19,31}.
hp_percent() ->{20,40,60,80,100}.
scene_lim() ->[].
