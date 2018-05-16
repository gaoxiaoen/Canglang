%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_team_recruit
	%%% @Created : 2016-01-16 17:52:52
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_team_recruit).
-export([get/1]).
-include("common.hrl").
get(1)->?T("刷野怪升级队，符合等级的速来。");
get(2)->?T("世界Boss扫荡队，只收高级玩家。");
get(3)->?T("组队副本速通队，只收高级玩家。");
get(_) -> [].
