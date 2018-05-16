%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_dark
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_dark).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[1000001,1000002,1000003,1000004,1000005].

get(1000001) ->
   #task{taskid = 1000001 ,name = ?T("前往魔宫1层") ,type = 10 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,63}] ,finish = [{npc,21001}] ,remote = 0 ,npcid = 0 ,endnpcid = 21001 ,talkid = 0 ,endtalkid = 1000001 ,goods = [{0,8001002,1}] };
get(1000002) ->
   #task{taskid = 1000002 ,name = ?T("前往魔宫2层") ,type = 10 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,68}] ,finish = [{npc,21002}] ,remote = 0 ,npcid = 0 ,endnpcid = 21002 ,talkid = 0 ,endtalkid = 1000001 ,goods = [{0,8001002,2}] };
get(1000003) ->
   #task{taskid = 1000003 ,name = ?T("前往魔宫3层") ,type = 10 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,73}] ,finish = [{npc,21003}] ,remote = 0 ,npcid = 0 ,endnpcid = 21003 ,talkid = 0 ,endtalkid = 1000001 ,goods = [{0,8001002,3}] };
get(1000004) ->
   #task{taskid = 1000004 ,name = ?T("前往魔宫4层") ,type = 10 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,78}] ,finish = [{npc,21004}] ,remote = 0 ,npcid = 0 ,endnpcid = 21004 ,talkid = 0 ,endtalkid = 1000001 ,goods = [{0,8001002,4}] };
get(1000005) ->
   #task{taskid = 1000005 ,name = ?T("前往魔宫5层") ,type = 10 ,next = 0 ,loop = 1 ,drop = [] ,accept = [{lv,83}] ,finish = [{npc,21005}] ,remote = 0 ,npcid = 0 ,endnpcid = 21005 ,talkid = 0 ,endtalkid = 1000001 ,goods = [{0,8001002,5}] };
get(_) -> [].