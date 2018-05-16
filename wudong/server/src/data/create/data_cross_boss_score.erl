%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_boss_score
	%%% @Created : 2018-04-23 11:03:37
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_boss_score).
-export([get/0]).
-include("common.hrl").
-include("cross_boss.hrl").

get() -> 
    #base_cross_boss_score{
    max_online = 500
    ,max_kill_mon = 1000
    ,max_kill_boss = 80000
    ,max_kill_guild_main = 20000
    ,max_kill_guild_player = 20000
    ,online = 20
    ,kill_guild_main = 50
    ,kill_guild_player = 50
    ,kill_mon = 50
    ,kill_boss = 200
}.