%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_retinue_state
	%%% @Created : 2017-06-12 19:44:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_retinue_state).
-export([state_list/0]).
-export([get/1]).
-include("common.hrl").
-include("guild_manor.hrl").

    state_list() ->[0,1,2,3].
get(0) ->
	#base_manor_retinue_state{id = 0 ,desc = ?T("正常"), repeat = 1 ,cd = 600 ,contrib = 0 ,goods = [] ,ratio = 100 };
get(1) ->
	#base_manor_retinue_state{id = 1 ,desc = ?T("偷懒中"), repeat = 1 ,cd = 600 ,contrib = [{1025000,5}] ,goods = [{11119,10}] ,ratio = 100 };
get(2) ->
	#base_manor_retinue_state{id = 2 ,desc = ?T("疲惫中"), repeat = 1 ,cd = 600 ,contrib = [{1025000,5}] ,goods = [{11119,10}] ,ratio = 100 };
get(3) ->
	#base_manor_retinue_state{id = 3 ,desc = ?T("兴奋中"), repeat = 1 ,cd = 600 ,contrib = [{1025000,5}] ,goods = [{11119,10}] ,ratio = 100 };
get(_) -> [].