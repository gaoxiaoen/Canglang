%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_six_dragon_reward
	%%% @Created : 2017-12-27 15:50:09
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_six_dragon_reward).
-export([get_succeed_reward/0]).
-export([get_fail_reward/0]).
-include("cross_six_dragon.hrl").
get_succeed_reward() -> [{1022000,20}].
get_fail_reward() -> [{1022000,10}].