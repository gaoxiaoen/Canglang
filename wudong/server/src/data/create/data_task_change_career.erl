%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_change_career
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_change_career).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[110001,110002,110003,110004,110005,110006,110007,110008,110009,110010,110011,110012,110013,110014,110015,110016].

get(110001) ->
   #task{taskid = 110001 ,name = ?T("霜火劫·一") ,type = 11 ,next = 110002 ,loop = 0 ,drop = [] ,accept = [{lv,63}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 0 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110001 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,2},{pos,1,1}] ,finish_price = 0 };
get(110002) ->
   #task{taskid = 110002 ,name = ?T("霜火劫·二") ,type = 11 ,next = 110003 ,loop = 0 ,drop = [] ,accept = [{task,110001}] ,finish = [{kill,27004,90}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110002 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,2},{pos,1,2}] ,finish_price = 0 };
get(110003) ->
   #task{taskid = 110003 ,name = ?T("霜火劫·三") ,type = 11 ,next = 110004 ,loop = 0 ,drop = [] ,accept = [{task,110002}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110003 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,2},{pos,2,1}] ,finish_price = 0 };
get(110004) ->
   #task{taskid = 110004 ,name = ?T("霜火劫·四") ,type = 11 ,next = 110005 ,loop = 0 ,drop = [] ,accept = [{task,110003}] ,finish = [{kill,27006,90}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110004 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,2},{pos,2,2}] ,finish_price = 0 };
get(110005) ->
   #task{taskid = 110005 ,name = ?T("霜火劫·降临") ,type = 11 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,110004}] ,finish = [{dungeon,41101,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110005 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,2},{pos,3,1}] ,finish_price = 0 };
get(110006) ->
   #task{taskid = 110006 ,name = ?T("辰雷劫·一") ,type = 11 ,next = 110007 ,loop = 0 ,drop = [] ,accept = [{lv,75},{task,110004},{career,2}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110006 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,3},{pos,1,1}] ,finish_price = 0 };
get(110007) ->
   #task{taskid = 110007 ,name = ?T("辰雷劫·二") ,type = 11 ,next = 110008 ,loop = 0 ,drop = [] ,accept = [{task,110006}] ,finish = [{kill,26005,150}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110007 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,3},{pos,1,2}] ,finish_price = 0 };
get(110008) ->
   #task{taskid = 110008 ,name = ?T("辰雷劫·三") ,type = 11 ,next = 110009 ,loop = 0 ,drop = [] ,accept = [{task,110007}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110008 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,3},{pos,2,1}] ,finish_price = 0 };
get(110009) ->
   #task{taskid = 110009 ,name = ?T("辰雷劫·四") ,type = 11 ,next = 110010 ,loop = 0 ,drop = [] ,accept = [{task,110008}] ,finish = [{kill,26006,90}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110009 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,3},{pos,2,2}] ,finish_price = 0 };
get(110010) ->
   #task{taskid = 110010 ,name = ?T("辰雷劫·降临") ,type = 11 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,110009}] ,finish = [{dungeon,41102,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110010 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,3},{pos,3,1}] ,finish_price = 0 };
get(110011) ->
   #task{taskid = 110011 ,name = ?T("道心劫·一") ,type = 11 ,next = 110012 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,110007},{career,3}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110011 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,1,1}] ,finish_price = 1000 };
get(110012) ->
   #task{taskid = 110012 ,name = ?T("道心劫·二") ,type = 11 ,next = 110013 ,loop = 0 ,drop = [] ,accept = [{task,110011}] ,finish = [{kill,28001,200}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110012 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,1,2}] ,finish_price = 1000 };
get(110013) ->
   #task{taskid = 110013 ,name = ?T("道心劫·三") ,type = 11 ,next = 110014 ,loop = 0 ,drop = [] ,accept = [{task,110012}] ,finish = [{collect,28203,5}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110013 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,2,1}] ,finish_price = 1000 };
get(110014) ->
   #task{taskid = 110014 ,name = ?T("道心劫·四") ,type = 11 ,next = 110015 ,loop = 0 ,drop = [] ,accept = [{task,110013}] ,finish = [{uplv,105}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110014 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,2,2}] ,finish_price = 1000 };
get(110015) ->
   #task{taskid = 110015 ,name = ?T("道心劫·五") ,type = 11 ,next = 110016 ,loop = 0 ,drop = [] ,accept = [{task,110014}] ,finish = [{goods,10101,1000000}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110015 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,2,3}] ,finish_price = 1000 };
get(110016) ->
   #task{taskid = 110016 ,name = ?T("道心劫·降临") ,type = 11 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,110015}] ,finish = [{dungeon,41103,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 110016 ,goods = [{0,10108,20000},{0,10101,5000}] ,extra = [{career,4},{pos,3,1}] ,finish_price = 1000 };
get(_) -> [].