%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_boss_feed
	%%% @Created : 2018-03-05 23:13:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_boss_feed).
-export([get/0]).
-include("guild.hrl").
get()-> #guild_boss_feeding{goods_exp = 10 ,goods_lim = 10 ,gold_cost = 50 ,gold_exp = 50 ,gold_lim = 10}.
