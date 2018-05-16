%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_equip
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_equip).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[1200001,1200002,1200003,1200004,1200005,1200006,1200007].

get(1200001) ->
   #task{taskid = 1200001 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42001,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200002) ->
   #task{taskid = 1200002 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42002,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200003) ->
   #task{taskid = 1200003 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42003,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200004) ->
   #task{taskid = 1200004 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42004,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200005) ->
   #task{taskid = 1200005 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42005,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200006) ->
   #task{taskid = 1200006 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42006,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000},{0,10101,10000}] };
get(1200007) ->
   #task{taskid = 1200007 ,name = ?T("神装副本") ,type = 12 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{dungeon,42007,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,6603077,1},{0,10108,20000},{0,10101,10000}] };
get(_) -> [].