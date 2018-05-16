%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_reward
	%%% @Created : 2017-11-02 11:53:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_reward).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[900101,900102,900103,900104,900105,900106,900107,900108,900109,900110,900201,900202,900203,900204,900205,900206,900207,900208,900209,900210,900301,900302,900303,900304,900305,900306,900307,900308,900309,900310,900401,900402,900403,900404,900405,900406,900407,900408,900409,900410,900501,900502,900503,900504,900505,900506,900507,900508,900509,900510,900601,900602,900603,900604,900605,900606,900607,900608,900609,900610,900701,900702,900703,900704,900705,900706,900707,900708,900709,900710,900801,900802,900803,900804,900805,900806,900807,900808,900809,900810,900901,900902,900903,900904,900905,900906,900907,900908,900909,900910,901001,901002,901003,901004,901005,901006,901007,901008,901009,901010,901101,901102,901103,901104,901105,901106,901107,901108,901109,901110,901201,901202,901203,901204,901205,901206,901207,901208,901209,901210,901301,901302,901303,901304,901305,901306,901307,901308,901309,901310,901401,901402,901403,901404,901405,901406,901407,901408,901409,901410,901501,901502,901503,901504,901505,901506,901507,901508,901509,901510,901601,901602,901603,901604,901605,901606,901607,901608,901609,901610,901701,901702,901703,901704,901705,901706,901707,901708,901709,901710,901801,901802,901803,901804,901805,901806,901807,901808,901809,901810,901901,901902,901903,901904,901905,901906,901907,901908,901909,901910,902001,902002,902003,902004,902005,902006,902007,902008,902009,902010,902101,902102,902103,902104,902105,902106,902107,902108,902109,902110].

get(900101) ->
   #task{taskid = 900101 ,name = ?T("等级段1任务1") ,type = 9 ,next = 900102 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900102) ->
   #task{taskid = 900102 ,name = ?T("等级段1任务2") ,type = 9 ,next = 900103 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900103) ->
   #task{taskid = 900103 ,name = ?T("等级段1任务3") ,type = 9 ,next = 900104 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900104) ->
   #task{taskid = 900104 ,name = ?T("等级段1任务4") ,type = 9 ,next = 900105 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900105) ->
   #task{taskid = 900105 ,name = ?T("等级段1任务5") ,type = 9 ,next = 900106 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900106) ->
   #task{taskid = 900106 ,name = ?T("等级段1任务6") ,type = 9 ,next = 900107 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900107) ->
   #task{taskid = 900107 ,name = ?T("等级段1任务7") ,type = 9 ,next = 900108 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900108) ->
   #task{taskid = 900108 ,name = ?T("等级段1任务8") ,type = 9 ,next = 900109 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900109) ->
   #task{taskid = 900109 ,name = ?T("等级段1任务9") ,type = 9 ,next = 900110 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900110) ->
   #task{taskid = 900110 ,name = ?T("等级段1任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,46,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400},{0,8001007,2}] ,finish_price = 5 };
get(900201) ->
   #task{taskid = 900201 ,name = ?T("等级段2任务1") ,type = 9 ,next = 900202 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900202) ->
   #task{taskid = 900202 ,name = ?T("等级段2任务2") ,type = 9 ,next = 900203 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900203) ->
   #task{taskid = 900203 ,name = ?T("等级段2任务3") ,type = 9 ,next = 900204 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900204) ->
   #task{taskid = 900204 ,name = ?T("等级段2任务4") ,type = 9 ,next = 900205 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900205) ->
   #task{taskid = 900205 ,name = ?T("等级段2任务5") ,type = 9 ,next = 900206 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900206) ->
   #task{taskid = 900206 ,name = ?T("等级段2任务6") ,type = 9 ,next = 900207 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900207) ->
   #task{taskid = 900207 ,name = ?T("等级段2任务7") ,type = 9 ,next = 900208 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900208) ->
   #task{taskid = 900208 ,name = ?T("等级段2任务8") ,type = 9 ,next = 900209 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900209) ->
   #task{taskid = 900209 ,name = ?T("等级段2任务9") ,type = 9 ,next = 900210 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900210) ->
   #task{taskid = 900210 ,name = ?T("等级段2任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,51,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800},{0,8001008,2}] ,finish_price = 5 };
get(900301) ->
   #task{taskid = 900301 ,name = ?T("等级段3任务1") ,type = 9 ,next = 900302 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900302) ->
   #task{taskid = 900302 ,name = ?T("等级段3任务2") ,type = 9 ,next = 900303 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900303) ->
   #task{taskid = 900303 ,name = ?T("等级段3任务3") ,type = 9 ,next = 900304 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900304) ->
   #task{taskid = 900304 ,name = ?T("等级段3任务4") ,type = 9 ,next = 900305 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900305) ->
   #task{taskid = 900305 ,name = ?T("等级段3任务5") ,type = 9 ,next = 900306 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900306) ->
   #task{taskid = 900306 ,name = ?T("等级段3任务6") ,type = 9 ,next = 900307 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900307) ->
   #task{taskid = 900307 ,name = ?T("等级段3任务7") ,type = 9 ,next = 900308 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900308) ->
   #task{taskid = 900308 ,name = ?T("等级段3任务8") ,type = 9 ,next = 900309 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900309) ->
   #task{taskid = 900309 ,name = ?T("等级段3任务9") ,type = 9 ,next = 900310 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900310) ->
   #task{taskid = 900310 ,name = ?T("等级段3任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,54,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400},{0,8001008,2}] ,finish_price = 5 };
get(900401) ->
   #task{taskid = 900401 ,name = ?T("等级段4任务1") ,type = 9 ,next = 900402 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900402) ->
   #task{taskid = 900402 ,name = ?T("等级段4任务2") ,type = 9 ,next = 900403 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900403) ->
   #task{taskid = 900403 ,name = ?T("等级段4任务3") ,type = 9 ,next = 900404 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900404) ->
   #task{taskid = 900404 ,name = ?T("等级段4任务4") ,type = 9 ,next = 900405 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900405) ->
   #task{taskid = 900405 ,name = ?T("等级段4任务5") ,type = 9 ,next = 900406 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900406) ->
   #task{taskid = 900406 ,name = ?T("等级段4任务6") ,type = 9 ,next = 900407 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900407) ->
   #task{taskid = 900407 ,name = ?T("等级段4任务7") ,type = 9 ,next = 900408 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900408) ->
   #task{taskid = 900408 ,name = ?T("等级段4任务8") ,type = 9 ,next = 900409 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900409) ->
   #task{taskid = 900409 ,name = ?T("等级段4任务9") ,type = 9 ,next = 900410 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900410) ->
   #task{taskid = 900410 ,name = ?T("等级段4任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,57,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200},{0,8001008,2}] ,finish_price = 5 };
get(900501) ->
   #task{taskid = 900501 ,name = ?T("等级段5任务1") ,type = 9 ,next = 900502 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900502) ->
   #task{taskid = 900502 ,name = ?T("等级段5任务2") ,type = 9 ,next = 900503 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900503) ->
   #task{taskid = 900503 ,name = ?T("等级段5任务3") ,type = 9 ,next = 900504 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900504) ->
   #task{taskid = 900504 ,name = ?T("等级段5任务4") ,type = 9 ,next = 900505 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900505) ->
   #task{taskid = 900505 ,name = ?T("等级段5任务5") ,type = 9 ,next = 900506 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900506) ->
   #task{taskid = 900506 ,name = ?T("等级段5任务6") ,type = 9 ,next = 900507 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900507) ->
   #task{taskid = 900507 ,name = ?T("等级段5任务7") ,type = 9 ,next = 900508 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900508) ->
   #task{taskid = 900508 ,name = ?T("等级段5任务8") ,type = 9 ,next = 900509 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900509) ->
   #task{taskid = 900509 ,name = ?T("等级段5任务9") ,type = 9 ,next = 900510 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900510) ->
   #task{taskid = 900510 ,name = ?T("等级段5任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,59,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300},{0,8001009,2}] ,finish_price = 5 };
get(900601) ->
   #task{taskid = 900601 ,name = ?T("等级段6任务1") ,type = 9 ,next = 900602 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900602) ->
   #task{taskid = 900602 ,name = ?T("等级段6任务2") ,type = 9 ,next = 900603 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900603) ->
   #task{taskid = 900603 ,name = ?T("等级段6任务3") ,type = 9 ,next = 900604 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900604) ->
   #task{taskid = 900604 ,name = ?T("等级段6任务4") ,type = 9 ,next = 900605 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900605) ->
   #task{taskid = 900605 ,name = ?T("等级段6任务5") ,type = 9 ,next = 900606 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900606) ->
   #task{taskid = 900606 ,name = ?T("等级段6任务6") ,type = 9 ,next = 900607 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900607) ->
   #task{taskid = 900607 ,name = ?T("等级段6任务7") ,type = 9 ,next = 900608 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900608) ->
   #task{taskid = 900608 ,name = ?T("等级段6任务8") ,type = 9 ,next = 900609 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900609) ->
   #task{taskid = 900609 ,name = ?T("等级段6任务9") ,type = 9 ,next = 900610 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900610) ->
   #task{taskid = 900610 ,name = ?T("等级段6任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,61,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400},{0,8001009,2}] ,finish_price = 5 };
get(900701) ->
   #task{taskid = 900701 ,name = ?T("等级段7任务1") ,type = 9 ,next = 900702 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900702) ->
   #task{taskid = 900702 ,name = ?T("等级段7任务2") ,type = 9 ,next = 900703 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900703) ->
   #task{taskid = 900703 ,name = ?T("等级段7任务3") ,type = 9 ,next = 900704 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900704) ->
   #task{taskid = 900704 ,name = ?T("等级段7任务4") ,type = 9 ,next = 900705 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900705) ->
   #task{taskid = 900705 ,name = ?T("等级段7任务5") ,type = 9 ,next = 900706 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900706) ->
   #task{taskid = 900706 ,name = ?T("等级段7任务6") ,type = 9 ,next = 900707 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900707) ->
   #task{taskid = 900707 ,name = ?T("等级段7任务7") ,type = 9 ,next = 900708 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900708) ->
   #task{taskid = 900708 ,name = ?T("等级段7任务8") ,type = 9 ,next = 900709 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900709) ->
   #task{taskid = 900709 ,name = ?T("等级段7任务9") ,type = 9 ,next = 900710 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900710) ->
   #task{taskid = 900710 ,name = ?T("等级段7任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,62,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000},{0,8001009,2}] ,finish_price = 5 };
get(900801) ->
   #task{taskid = 900801 ,name = ?T("等级段8任务1") ,type = 9 ,next = 900802 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900802) ->
   #task{taskid = 900802 ,name = ?T("等级段8任务2") ,type = 9 ,next = 900803 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900803) ->
   #task{taskid = 900803 ,name = ?T("等级段8任务3") ,type = 9 ,next = 900804 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900804) ->
   #task{taskid = 900804 ,name = ?T("等级段8任务4") ,type = 9 ,next = 900805 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900805) ->
   #task{taskid = 900805 ,name = ?T("等级段8任务5") ,type = 9 ,next = 900806 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900806) ->
   #task{taskid = 900806 ,name = ?T("等级段8任务6") ,type = 9 ,next = 900807 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900807) ->
   #task{taskid = 900807 ,name = ?T("等级段8任务7") ,type = 9 ,next = 900808 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900808) ->
   #task{taskid = 900808 ,name = ?T("等级段8任务8") ,type = 9 ,next = 900809 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900809) ->
   #task{taskid = 900809 ,name = ?T("等级段8任务9") ,type = 9 ,next = 900810 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900810) ->
   #task{taskid = 900810 ,name = ?T("等级段8任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,71,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000},{0,8001010,2}] ,finish_price = 5 };
get(900901) ->
   #task{taskid = 900901 ,name = ?T("等级段9任务1") ,type = 9 ,next = 900902 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900902) ->
   #task{taskid = 900902 ,name = ?T("等级段9任务2") ,type = 9 ,next = 900903 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900903) ->
   #task{taskid = 900903 ,name = ?T("等级段9任务3") ,type = 9 ,next = 900904 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900904) ->
   #task{taskid = 900904 ,name = ?T("等级段9任务4") ,type = 9 ,next = 900905 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900905) ->
   #task{taskid = 900905 ,name = ?T("等级段9任务5") ,type = 9 ,next = 900906 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900906) ->
   #task{taskid = 900906 ,name = ?T("等级段9任务6") ,type = 9 ,next = 900907 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900907) ->
   #task{taskid = 900907 ,name = ?T("等级段9任务7") ,type = 9 ,next = 900908 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900908) ->
   #task{taskid = 900908 ,name = ?T("等级段9任务8") ,type = 9 ,next = 900909 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900909) ->
   #task{taskid = 900909 ,name = ?T("等级段9任务9") ,type = 9 ,next = 900910 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(900910) ->
   #task{taskid = 900910 ,name = ?T("等级段9任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,85,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300},{0,8001011,2}] ,finish_price = 5 };
get(901001) ->
   #task{taskid = 901001 ,name = ?T("等级段10任务1") ,type = 9 ,next = 901002 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901002) ->
   #task{taskid = 901002 ,name = ?T("等级段10任务2") ,type = 9 ,next = 901003 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901003) ->
   #task{taskid = 901003 ,name = ?T("等级段10任务3") ,type = 9 ,next = 901004 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901004) ->
   #task{taskid = 901004 ,name = ?T("等级段10任务4") ,type = 9 ,next = 901005 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901005) ->
   #task{taskid = 901005 ,name = ?T("等级段10任务5") ,type = 9 ,next = 901006 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901006) ->
   #task{taskid = 901006 ,name = ?T("等级段10任务6") ,type = 9 ,next = 901007 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901007) ->
   #task{taskid = 901007 ,name = ?T("等级段10任务7") ,type = 9 ,next = 901008 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901008) ->
   #task{taskid = 901008 ,name = ?T("等级段10任务8") ,type = 9 ,next = 901009 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901009) ->
   #task{taskid = 901009 ,name = ?T("等级段10任务9") ,type = 9 ,next = 901010 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901010) ->
   #task{taskid = 901010 ,name = ?T("等级段10任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,95,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400},{0,8001012,2}] ,finish_price = 5 };
get(901101) ->
   #task{taskid = 901101 ,name = ?T("等级段11任务1") ,type = 9 ,next = 901102 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901102) ->
   #task{taskid = 901102 ,name = ?T("等级段11任务2") ,type = 9 ,next = 901103 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901103) ->
   #task{taskid = 901103 ,name = ?T("等级段11任务3") ,type = 9 ,next = 901104 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901104) ->
   #task{taskid = 901104 ,name = ?T("等级段11任务4") ,type = 9 ,next = 901105 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901105) ->
   #task{taskid = 901105 ,name = ?T("等级段11任务5") ,type = 9 ,next = 901106 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901106) ->
   #task{taskid = 901106 ,name = ?T("等级段11任务6") ,type = 9 ,next = 901107 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901107) ->
   #task{taskid = 901107 ,name = ?T("等级段11任务7") ,type = 9 ,next = 901108 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901108) ->
   #task{taskid = 901108 ,name = ?T("等级段11任务8") ,type = 9 ,next = 901109 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901109) ->
   #task{taskid = 901109 ,name = ?T("等级段11任务9") ,type = 9 ,next = 901110 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901110) ->
   #task{taskid = 901110 ,name = ?T("等级段11任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,100,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100},{0,8001013,2}] ,finish_price = 5 };
get(901201) ->
   #task{taskid = 901201 ,name = ?T("等级段12任务1") ,type = 9 ,next = 901202 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901202) ->
   #task{taskid = 901202 ,name = ?T("等级段12任务2") ,type = 9 ,next = 901203 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901203) ->
   #task{taskid = 901203 ,name = ?T("等级段12任务3") ,type = 9 ,next = 901204 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901204) ->
   #task{taskid = 901204 ,name = ?T("等级段12任务4") ,type = 9 ,next = 901205 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901205) ->
   #task{taskid = 901205 ,name = ?T("等级段12任务5") ,type = 9 ,next = 901206 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901206) ->
   #task{taskid = 901206 ,name = ?T("等级段12任务6") ,type = 9 ,next = 901207 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901207) ->
   #task{taskid = 901207 ,name = ?T("等级段12任务7") ,type = 9 ,next = 901208 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901208) ->
   #task{taskid = 901208 ,name = ?T("等级段12任务8") ,type = 9 ,next = 901209 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901209) ->
   #task{taskid = 901209 ,name = ?T("等级段12任务9") ,type = 9 ,next = 901210 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901210) ->
   #task{taskid = 901210 ,name = ?T("等级段12任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200},{0,8001014,2}] ,finish_price = 5 };
get(901301) ->
   #task{taskid = 901301 ,name = ?T("等级段13任务1") ,type = 9 ,next = 901302 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901302) ->
   #task{taskid = 901302 ,name = ?T("等级段13任务2") ,type = 9 ,next = 901303 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901303) ->
   #task{taskid = 901303 ,name = ?T("等级段13任务3") ,type = 9 ,next = 901304 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901304) ->
   #task{taskid = 901304 ,name = ?T("等级段13任务4") ,type = 9 ,next = 901305 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901305) ->
   #task{taskid = 901305 ,name = ?T("等级段13任务5") ,type = 9 ,next = 901306 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901306) ->
   #task{taskid = 901306 ,name = ?T("等级段13任务6") ,type = 9 ,next = 901307 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901307) ->
   #task{taskid = 901307 ,name = ?T("等级段13任务7") ,type = 9 ,next = 901308 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901308) ->
   #task{taskid = 901308 ,name = ?T("等级段13任务8") ,type = 9 ,next = 901309 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901309) ->
   #task{taskid = 901309 ,name = ?T("等级段13任务9") ,type = 9 ,next = 901310 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901310) ->
   #task{taskid = 901310 ,name = ?T("等级段13任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900},{0,8001015,2}] ,finish_price = 5 };
get(901401) ->
   #task{taskid = 901401 ,name = ?T("等级段14任务1") ,type = 9 ,next = 901402 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901402) ->
   #task{taskid = 901402 ,name = ?T("等级段14任务2") ,type = 9 ,next = 901403 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901403) ->
   #task{taskid = 901403 ,name = ?T("等级段14任务3") ,type = 9 ,next = 901404 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901404) ->
   #task{taskid = 901404 ,name = ?T("等级段14任务4") ,type = 9 ,next = 901405 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901405) ->
   #task{taskid = 901405 ,name = ?T("等级段14任务5") ,type = 9 ,next = 901406 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901406) ->
   #task{taskid = 901406 ,name = ?T("等级段14任务6") ,type = 9 ,next = 901407 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901407) ->
   #task{taskid = 901407 ,name = ?T("等级段14任务7") ,type = 9 ,next = 901408 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901408) ->
   #task{taskid = 901408 ,name = ?T("等级段14任务8") ,type = 9 ,next = 901409 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901409) ->
   #task{taskid = 901409 ,name = ?T("等级段14任务9") ,type = 9 ,next = 901410 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901410) ->
   #task{taskid = 901410 ,name = ?T("等级段14任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100},{0,8001016,2}] ,finish_price = 5 };
get(901501) ->
   #task{taskid = 901501 ,name = ?T("等级段15任务1") ,type = 9 ,next = 901502 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901502) ->
   #task{taskid = 901502 ,name = ?T("等级段15任务2") ,type = 9 ,next = 901503 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901503) ->
   #task{taskid = 901503 ,name = ?T("等级段15任务3") ,type = 9 ,next = 901504 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901504) ->
   #task{taskid = 901504 ,name = ?T("等级段15任务4") ,type = 9 ,next = 901505 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901505) ->
   #task{taskid = 901505 ,name = ?T("等级段15任务5") ,type = 9 ,next = 901506 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901506) ->
   #task{taskid = 901506 ,name = ?T("等级段15任务6") ,type = 9 ,next = 901507 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901507) ->
   #task{taskid = 901507 ,name = ?T("等级段15任务7") ,type = 9 ,next = 901508 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901508) ->
   #task{taskid = 901508 ,name = ?T("等级段15任务8") ,type = 9 ,next = 901509 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901509) ->
   #task{taskid = 901509 ,name = ?T("等级段15任务9") ,type = 9 ,next = 901510 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901510) ->
   #task{taskid = 901510 ,name = ?T("等级段15任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300},{0,8001017,2}] ,finish_price = 5 };
get(901601) ->
   #task{taskid = 901601 ,name = ?T("等级段16任务1") ,type = 9 ,next = 901602 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901602) ->
   #task{taskid = 901602 ,name = ?T("等级段16任务2") ,type = 9 ,next = 901603 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901603) ->
   #task{taskid = 901603 ,name = ?T("等级段16任务3") ,type = 9 ,next = 901604 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901604) ->
   #task{taskid = 901604 ,name = ?T("等级段16任务4") ,type = 9 ,next = 901605 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901605) ->
   #task{taskid = 901605 ,name = ?T("等级段16任务5") ,type = 9 ,next = 901606 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901606) ->
   #task{taskid = 901606 ,name = ?T("等级段16任务6") ,type = 9 ,next = 901607 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901607) ->
   #task{taskid = 901607 ,name = ?T("等级段16任务7") ,type = 9 ,next = 901608 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901608) ->
   #task{taskid = 901608 ,name = ?T("等级段16任务8") ,type = 9 ,next = 901609 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901609) ->
   #task{taskid = 901609 ,name = ?T("等级段16任务9") ,type = 9 ,next = 901610 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901610) ->
   #task{taskid = 901610 ,name = ?T("等级段16任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100},{0,8001018,2}] ,finish_price = 5 };
get(901701) ->
   #task{taskid = 901701 ,name = ?T("等级段17任务1") ,type = 9 ,next = 901702 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901702) ->
   #task{taskid = 901702 ,name = ?T("等级段17任务2") ,type = 9 ,next = 901703 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901703) ->
   #task{taskid = 901703 ,name = ?T("等级段17任务3") ,type = 9 ,next = 901704 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901704) ->
   #task{taskid = 901704 ,name = ?T("等级段17任务4") ,type = 9 ,next = 901705 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901705) ->
   #task{taskid = 901705 ,name = ?T("等级段17任务5") ,type = 9 ,next = 901706 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901706) ->
   #task{taskid = 901706 ,name = ?T("等级段17任务6") ,type = 9 ,next = 901707 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901707) ->
   #task{taskid = 901707 ,name = ?T("等级段17任务7") ,type = 9 ,next = 901708 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901708) ->
   #task{taskid = 901708 ,name = ?T("等级段17任务8") ,type = 9 ,next = 901709 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901709) ->
   #task{taskid = 901709 ,name = ?T("等级段17任务9") ,type = 9 ,next = 901710 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901710) ->
   #task{taskid = 901710 ,name = ?T("等级段17任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900},{0,8001019,2}] ,finish_price = 5 };
get(901801) ->
   #task{taskid = 901801 ,name = ?T("等级段18任务1") ,type = 9 ,next = 901802 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901802) ->
   #task{taskid = 901802 ,name = ?T("等级段18任务2") ,type = 9 ,next = 901803 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901803) ->
   #task{taskid = 901803 ,name = ?T("等级段18任务3") ,type = 9 ,next = 901804 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901804) ->
   #task{taskid = 901804 ,name = ?T("等级段18任务4") ,type = 9 ,next = 901805 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901805) ->
   #task{taskid = 901805 ,name = ?T("等级段18任务5") ,type = 9 ,next = 901806 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901806) ->
   #task{taskid = 901806 ,name = ?T("等级段18任务6") ,type = 9 ,next = 901807 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901807) ->
   #task{taskid = 901807 ,name = ?T("等级段18任务7") ,type = 9 ,next = 901808 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901808) ->
   #task{taskid = 901808 ,name = ?T("等级段18任务8") ,type = 9 ,next = 901809 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901809) ->
   #task{taskid = 901809 ,name = ?T("等级段18任务9") ,type = 9 ,next = 901810 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901810) ->
   #task{taskid = 901810 ,name = ?T("等级段18任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700},{0,8001020,2}] ,finish_price = 5 };
get(901901) ->
   #task{taskid = 901901 ,name = ?T("等级段19任务1") ,type = 9 ,next = 901902 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901902) ->
   #task{taskid = 901902 ,name = ?T("等级段19任务2") ,type = 9 ,next = 901903 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901903) ->
   #task{taskid = 901903 ,name = ?T("等级段19任务3") ,type = 9 ,next = 901904 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901904) ->
   #task{taskid = 901904 ,name = ?T("等级段19任务4") ,type = 9 ,next = 901905 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901905) ->
   #task{taskid = 901905 ,name = ?T("等级段19任务5") ,type = 9 ,next = 901906 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901906) ->
   #task{taskid = 901906 ,name = ?T("等级段19任务6") ,type = 9 ,next = 901907 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901907) ->
   #task{taskid = 901907 ,name = ?T("等级段19任务7") ,type = 9 ,next = 901908 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901908) ->
   #task{taskid = 901908 ,name = ?T("等级段19任务8") ,type = 9 ,next = 901909 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901909) ->
   #task{taskid = 901909 ,name = ?T("等级段19任务9") ,type = 9 ,next = 901910 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(901910) ->
   #task{taskid = 901910 ,name = ?T("等级段19任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500},{0,8001021,2}] ,finish_price = 5 };
get(902001) ->
   #task{taskid = 902001 ,name = ?T("等级段20任务1") ,type = 9 ,next = 902002 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902002) ->
   #task{taskid = 902002 ,name = ?T("等级段20任务2") ,type = 9 ,next = 902003 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902003) ->
   #task{taskid = 902003 ,name = ?T("等级段20任务3") ,type = 9 ,next = 902004 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902004) ->
   #task{taskid = 902004 ,name = ?T("等级段20任务4") ,type = 9 ,next = 902005 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902005) ->
   #task{taskid = 902005 ,name = ?T("等级段20任务5") ,type = 9 ,next = 902006 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902006) ->
   #task{taskid = 902006 ,name = ?T("等级段20任务6") ,type = 9 ,next = 902007 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902007) ->
   #task{taskid = 902007 ,name = ?T("等级段20任务7") ,type = 9 ,next = 902008 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902008) ->
   #task{taskid = 902008 ,name = ?T("等级段20任务8") ,type = 9 ,next = 902009 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902009) ->
   #task{taskid = 902009 ,name = ?T("等级段20任务9") ,type = 9 ,next = 902010 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902010) ->
   #task{taskid = 902010 ,name = ?T("等级段20任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300},{0,8001022,2}] ,finish_price = 5 };
get(902101) ->
   #task{taskid = 902101 ,name = ?T("等级段21任务1") ,type = 9 ,next = 902102 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902102) ->
   #task{taskid = 902102 ,name = ?T("等级段21任务2") ,type = 9 ,next = 902103 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902103) ->
   #task{taskid = 902103 ,name = ?T("等级段21任务3") ,type = 9 ,next = 902104 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902104) ->
   #task{taskid = 902104 ,name = ?T("等级段21任务4") ,type = 9 ,next = 902105 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902105) ->
   #task{taskid = 902105 ,name = ?T("等级段21任务5") ,type = 9 ,next = 902106 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902106) ->
   #task{taskid = 902106 ,name = ?T("等级段21任务6") ,type = 9 ,next = 902107 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1200}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902107) ->
   #task{taskid = 902107 ,name = ?T("等级段21任务7") ,type = 9 ,next = 902108 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1400}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902108) ->
   #task{taskid = 902108 ,name = ?T("等级段21任务8") ,type = 9 ,next = 902109 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1600}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902109) ->
   #task{taskid = 902109 ,name = ?T("等级段21任务9") ,type = 9 ,next = 902110 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,1800}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(902110) ->
   #task{taskid = 902110 ,name = ?T("等级段21任务10") ,type = 9 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,40}] ,finish = [{mlv,107,2000}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500},{0,8001022,2}] ,finish_price = 5 };
get(_) -> [].