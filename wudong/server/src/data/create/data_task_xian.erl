%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_xian
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_xian).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[1300001,1300002,1300003,1300004,1300005,1300006,1300007,1300008,1300009,1300010,1300011,1300012,1300013,1300014,1300015,1300016,1300017,1300018].

get(1300001) ->
   #task{taskid = 1300001 ,name = ?T("地仙飞升") ,type = 13 ,next = 1300002 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405002,10}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300002) ->
   #task{taskid = 1300002 ,name = ?T("地仙飞升") ,type = 13 ,next = 1300003 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,26003,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300003) ->
   #task{taskid = 1300003 ,name = ?T("地仙飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12008,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300004) ->
   #task{taskid = 1300004 ,name = ?T("天仙飞升") ,type = 13 ,next = 1300005 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405003,40}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300005) ->
   #task{taskid = 1300005 ,name = ?T("天仙飞升") ,type = 13 ,next = 1300006 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,26012,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300006) ->
   #task{taskid = 1300006 ,name = ?T("天仙飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12009,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300007) ->
   #task{taskid = 1300007 ,name = ?T("金仙飞升") ,type = 13 ,next = 1300008 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405004,50}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300008) ->
   #task{taskid = 1300008 ,name = ?T("金仙飞升") ,type = 13 ,next = 1300009 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,26117,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300009) ->
   #task{taskid = 1300009 ,name = ?T("金仙飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12010,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300010) ->
   #task{taskid = 1300010 ,name = ?T("星君飞升") ,type = 13 ,next = 1300011 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405005,50}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300011) ->
   #task{taskid = 1300011 ,name = ?T("星君飞升") ,type = 13 ,next = 1300012 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,26122,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300012) ->
   #task{taskid = 1300012 ,name = ?T("星君飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12011,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300013) ->
   #task{taskid = 1300013 ,name = ?T("仙帝飞升") ,type = 13 ,next = 1300014 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405006,80}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300014) ->
   #task{taskid = 1300014 ,name = ?T("仙帝飞升") ,type = 13 ,next = 1300015 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,28006,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300015) ->
   #task{taskid = 1300015 ,name = ?T("仙帝飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12012,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300016) ->
   #task{taskid = 1300016 ,name = ?T("神子飞升") ,type = 13 ,next = 1300017 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{getgoods,7405007,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300017) ->
   #task{taskid = 1300017 ,name = ?T("神子飞升") ,type = 13 ,next = 1300018 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{kill,28009,100}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(1300018) ->
   #task{taskid = 1300018 ,name = ?T("神子飞升") ,type = 13 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,90}] ,finish = [{dungeon,12013,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [] };
get(_) -> [].