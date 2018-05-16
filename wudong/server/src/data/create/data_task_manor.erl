%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_manor
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_manor).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[800001,800002,800003,800005,800006].

get(800001) ->
   #task{taskid = 800001 ,name = ?T("领地俸禄") ,type = 8 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,1}] ,finish = [{npc,16001}] ,remote = 0 ,npcid = 0 ,endnpcid = 16001 ,talkid = 0 ,endtalkid = 800001 ,goods = [{0,8001090,1}] };
get(800002) ->
   #task{taskid = 800002 ,name = ?T("领地俸禄") ,type = 8 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,1}] ,finish = [{npc,14031}] ,remote = 0 ,npcid = 0 ,endnpcid = 14031 ,talkid = 0 ,endtalkid = 800001 ,goods = [{0,8001091,1}] };
get(800003) ->
   #task{taskid = 800003 ,name = ?T("领地俸禄") ,type = 8 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,1}] ,finish = [{npc,12013}] ,remote = 0 ,npcid = 0 ,endnpcid = 12013 ,talkid = 0 ,endtalkid = 800001 ,goods = [{0,8001092,1}] };
get(800005) ->
   #task{taskid = 800005 ,name = ?T("领地俸禄") ,type = 8 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,1}] ,finish = [{npc,13019}] ,remote = 0 ,npcid = 0 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 800001 ,goods = [{0,8001093,1}] };
get(800006) ->
   #task{taskid = 800006 ,name = ?T("领地俸禄") ,type = 8 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,1}] ,finish = [{npc,15010}] ,remote = 0 ,npcid = 0 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 800001 ,goods = [{0,8001093,1}] };
get(_) -> [].