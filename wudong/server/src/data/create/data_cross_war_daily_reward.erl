%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_daily_reward
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_daily_reward).
-export([get_king_reward/0, get_member_reward/0, get_orz_reward/0]).
-include("common.hrl").

get_king_reward()->[{8001054,3},{1015001,2},{8001163,2}].

get_member_reward()->[{10106,20},{8001054,1},{8001057,2},{1008000,1}].

get_orz_reward()->[{10101, 10000}].
