%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_bet
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_bet).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[600001].

get(600001) ->
   #task{taskid = 600001 ,name = ?T("以小搏大") ,type = 6 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,998},{lv_down,999},{open_day,[1,2,3,4,5,6,7]}] ,finish = [{bet,10,1}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 1001 ,goods = [{0,10108,4600},{0,10199,100},{0,3201000,5}] };
get(_) -> [].