%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_war_crystal
%%% @Created : 2016-06-12 15:50:03
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_war_crystal).
-export([ids/0,get/1]).
-include("common.hrl").
-include("guild_war.hrl").

    ids() ->
    [40072,51093,64093,76071,68056,49054,58023,51024,66025,24098,22088,28105,91098,87105,93090,58068].
get(40072) ->
	#base_guild_war_crystal{x = 40 ,y = 72 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,330,790,1130] ,notice = ?T("中级水晶还有30秒在[40,72]点刷新啦") };
get(51093) ->
	#base_guild_war_crystal{x = 51 ,y = 93 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(64093) ->
	#base_guild_war_crystal{x = 64 ,y = 93 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,210,670,1130] ,notice = ?T("中级水晶还有30秒在[64,93]点刷新啦") };
get(76071) ->
	#base_guild_war_crystal{x = 76 ,y = 71 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(68056) ->
	#base_guild_war_crystal{x = 68 ,y = 56 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,330,790,1130] ,notice = ?T("中级水晶还有30秒在[68,56]点刷新啦") };
get(49054) ->
	#base_guild_war_crystal{x = 49 ,y = 54 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(58023) ->
	#base_guild_war_crystal{x = 58 ,y = 23 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,210,670,1130] ,notice = ?T("中级水晶还有30秒在[58,23]黄云点刷新啦") };
get(51024) ->
	#base_guild_war_crystal{x = 51 ,y = 24 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(66025) ->
	#base_guild_war_crystal{x = 66 ,y = 25 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(24098) ->
	#base_guild_war_crystal{x = 24 ,y = 98 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,330,790,1130] ,notice = ?T("中级水晶还有30秒在[24,98]蓝电点刷新啦") };
get(22088) ->
	#base_guild_war_crystal{x = 22 ,y = 88 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(28105) ->
	#base_guild_war_crystal{x = 28 ,y = 105 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(91098) ->
	#base_guild_war_crystal{x = 91 ,y = 98 ,mon_id = 11406 ,type = 2 ,refresh_time = [30,550,910,1130] ,notice = ?T("中级水晶还有30秒在[91,98]红火点刷新啦") };
get(87105) ->
	#base_guild_war_crystal{x = 87 ,y = 105 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(93090) ->
	#base_guild_war_crystal{x = 93 ,y = 90 ,mon_id = 11405 ,type = 3 ,refresh_time = [10,70,130,190,250,310,370,430,490,550,610,670,730,790,850,910,970,1030,1090,1150] ,notice = ?T("") };
get(58068) ->
	#base_guild_war_crystal{x = 58 ,y = 68 ,mon_id = 11407 ,type = 1 ,refresh_time = [280,580,880,1180] ,notice = ?T("顶级水晶还有30秒在中央[58,68]点刷新啦") };
get(_) -> [].