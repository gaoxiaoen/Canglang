%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_figure
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_figure).
-export([ids/0,get/1]).
-include("common.hrl").
-include("guild_war.hrl").

    ids() ->
    [42001,42002].
get(42001) ->
	#base_guild_war_figure{figure = 42001 ,contrib = 500 ,extra_contrib = [{1,0,0},{2,0,0}] ,att_per = 1 ,hp_per = 50000 ,collect_time = 1 ,collect_per = 1 ,kill_per = 0.5 ,assists_per = 0.5 };
get(42002) ->
	#base_guild_war_figure{figure = 42002 ,contrib = 500 ,extra_contrib = [{1,0,0},{2,0,0}] ,att_per = 1 ,hp_per = 0 ,collect_time = 2 ,collect_per = 0.5 ,kill_per = 1 ,assists_per = 1 };
get(_) -> [].