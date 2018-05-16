%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_convoy
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_convoy).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[500001].

get(500001) ->
   #task{taskid = 500001 ,name = ?T("护送美女") ,type = 5 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,45}] ,finish = [{npc,20002}] ,remote = 0 ,npcid = 20003 ,endnpcid = 20002 ,talkid = 0 ,endtalkid = 1001 ,goods = [{0,10108,4600},{0,10199,100},{0,3201000,5}] };
get(_) -> [].