%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_branch
	%%% @Created : 2017-11-02 11:53:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_branch).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[200000,200101,200102,200103,200104,200105,200201,200202,200203,200204,200205,200206,200301,200302,200303,200401,200402,200403,200404,200405,200406,200407,200408,200409,200410,200411,200412,200413,200501,200502,200503,200504,200505,200506,200507,200508,200509,200510,200511,200512,200513,200514,200515,200516,200517,200518,200519,200520,200701,200702,200703,200801,200802,200803,200804,200805,200811,200812,200813,200814,200815,200816,200817,200818,200819,200820,200821,200822,200901,200902,200903,200904,200905,200906,200907,200908,200909,200910,200911,200912,200913,200914,201001,201002,201003,201004,201005,201101,201102,201103,201104,201105].

get(200000) ->
   #task{taskid = 200000 ,name = ?T("充值得大礼") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,41}] ,finish = [{charge,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,50000},{0,5101401,1},{0,5101411,1},{0,5101421,1}] };
get(200101) ->
   #task{taskid = 200101 ,name = ?T("蜀山求道") ,type = 2 ,next = 200102 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dungeon,51001,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,66075}] };
get(200102) ->
   #task{taskid = 200102 ,name = ?T("竹海幽径") ,type = 2 ,next = 200103 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dungeon,51002,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,66075}] };
get(200103) ->
   #task{taskid = 200103 ,name = ?T("剑阁天衍") ,type = 2 ,next = 200104 ,loop = 0 ,drop = [] ,accept = [{lv,65},{task,200102}] ,finish = [{dungeon,51003,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200104) ->
   #task{taskid = 200104 ,name = ?T("青云渡口") ,type = 2 ,next = 200105 ,loop = 0 ,drop = [] ,accept = [{lv,75},{task,200103}] ,finish = [{dungeon,51004,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200105) ->
   #task{taskid = 200105 ,name = ?T("夜访蓬莱") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,85},{task,200104}] ,finish = [{dungeon,51005,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200201) ->
   #task{taskid = 200201 ,name = ?T("坐骑副本") ,type = 2 ,next = 200202 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dungeon,50001,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,90000}] };
get(200202) ->
   #task{taskid = 200202 ,name = ?T("神兵副本") ,type = 2 ,next = 200203 ,loop = 0 ,drop = [] ,accept = [{lv,58}] ,finish = [{dungeon,50004,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,66075}] };
get(200203) ->
   #task{taskid = 200203 ,name = ?T("法器副本") ,type = 2 ,next = 200204 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dungeon,50003,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,90000}] };
get(200204) ->
   #task{taskid = 200204 ,name = ?T("仙羽副本") ,type = 2 ,next = 200205 ,loop = 0 ,drop = [] ,accept = [{lv,60},{task,200203}] ,finish = [{dungeon,50002,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200205) ->
   #task{taskid = 200205 ,name = ?T("妖灵副本") ,type = 2 ,next = 200206 ,loop = 0 ,drop = [] ,accept = [{lv,62},{task,200204}] ,finish = [{dungeon,50006,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200206) ->
   #task{taskid = 200206 ,name = ?T("宠物副本") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,63},{task,200205}] ,finish = [{dungeon,50005,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50000}] };
get(200301) ->
   #task{taskid = 200301 ,name = ?T("初战竞技场") ,type = 2 ,next = 200302 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{arena,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,66075}] };
get(200302) ->
   #task{taskid = 200302 ,name = ?T("再战竞技场") ,type = 2 ,next = 200303 ,loop = 0 ,drop = [] ,accept = [{lv,48},{task,200301}] ,finish = [{arena,2}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,35872},{0,10101,4000}] };
get(200303) ->
   #task{taskid = 200303 ,name = ?T("竞技场挑战") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,49},{task,200302}] ,finish = [{arena,3}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,47310},{0,10101,4000}] };
get(200401) ->
   #task{taskid = 200401 ,name = ?T("经验本5波") ,type = 2 ,next = 200402 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dunexp,5}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,35872},{0,10101,4000}] };
get(200402) ->
   #task{taskid = 200402 ,name = ?T("经验本10波") ,type = 2 ,next = 200403 ,loop = 0 ,drop = [] ,accept = [{task,200401}] ,finish = [{dunexp,10}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,36822},{0,10101,4000}] };
get(200403) ->
   #task{taskid = 200403 ,name = ?T("经验本12波") ,type = 2 ,next = 200404 ,loop = 0 ,drop = [] ,accept = [{task,200402}] ,finish = [{dunexp,12}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,48688},{0,10101,4000}] };
get(200404) ->
   #task{taskid = 200404 ,name = ?T("经验本14波") ,type = 2 ,next = 200405 ,loop = 0 ,drop = [] ,accept = [{task,200403}] ,finish = [{dunexp,14}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,48688},{0,10101,4000}] };
get(200405) ->
   #task{taskid = 200405 ,name = ?T("经验本15波") ,type = 2 ,next = 200406 ,loop = 0 ,drop = [] ,accept = [{task,200404}] ,finish = [{dunexp,15}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,51728},{0,10101,4000}] };
get(200406) ->
   #task{taskid = 200406 ,name = ?T("经验本17波") ,type = 2 ,next = 200407 ,loop = 0 ,drop = [] ,accept = [{task,200405}] ,finish = [{dunexp,17}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,51728},{0,10101,4000}] };
get(200407) ->
   #task{taskid = 200407 ,name = ?T("经验本20波") ,type = 2 ,next = 200408 ,loop = 0 ,drop = [] ,accept = [{lv,58},{task,200406}] ,finish = [{dunexp,20}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,53390},{0,10101,4000}] };
get(200408) ->
   #task{taskid = 200408 ,name = ?T("经验本23波") ,type = 2 ,next = 200409 ,loop = 0 ,drop = [] ,accept = [{task,200407}] ,finish = [{dunexp,23}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(200409) ->
   #task{taskid = 200409 ,name = ?T("经验本26波") ,type = 2 ,next = 200410 ,loop = 0 ,drop = [] ,accept = [{task,200408}] ,finish = [{dunexp,26}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200410) ->
   #task{taskid = 200410 ,name = ?T("经验本30波") ,type = 2 ,next = 200411 ,loop = 0 ,drop = [] ,accept = [{task,200409}] ,finish = [{dunexp,30}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200411) ->
   #task{taskid = 200411 ,name = ?T("经验本35波") ,type = 2 ,next = 200412 ,loop = 0 ,drop = [] ,accept = [{task,200410}] ,finish = [{dunexp,35}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200412) ->
   #task{taskid = 200412 ,name = ?T("经验本40波") ,type = 2 ,next = 200413 ,loop = 0 ,drop = [] ,accept = [{task,200411}] ,finish = [{dunexp,40}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200413) ->
   #task{taskid = 200413 ,name = ?T("经验本45波") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,200412}] ,finish = [{dunexp,45}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200501) ->
   #task{taskid = 200501 ,name = ?T("初战符文塔") ,type = 2 ,next = 200502 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{dungeon,20161,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,44840}] };
get(200502) ->
   #task{taskid = 200502 ,name = ?T("诛仙塔3层") ,type = 2 ,next = 200503 ,loop = 0 ,drop = [] ,accept = [{task,200501}] ,finish = [{dungeon,20163,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,53808}] };
get(200503) ->
   #task{taskid = 200503 ,name = ?T("诛仙塔5层") ,type = 2 ,next = 200504 ,loop = 0 ,drop = [] ,accept = [{task,200502}] ,finish = [{dungeon,20165,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,36822},{0,10101,4000}] };
get(200504) ->
   #task{taskid = 200504 ,name = ?T("诛仙塔7层") ,type = 2 ,next = 200505 ,loop = 0 ,drop = [] ,accept = [{task,200503}] ,finish = [{dungeon,20167,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,36822},{0,10101,4000}] };
get(200505) ->
   #task{taskid = 200505 ,name = ?T("诛仙塔9层") ,type = 2 ,next = 200506 ,loop = 0 ,drop = [] ,accept = [{task,200504}] ,finish = [{dungeon,20169,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,48688},{0,10101,4000}] };
get(200506) ->
   #task{taskid = 200506 ,name = ?T("诛仙塔10层") ,type = 2 ,next = 200507 ,loop = 0 ,drop = [] ,accept = [{task,200505}] ,finish = [{dungeon,20170,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50160},{0,10101,4000}] };
get(200507) ->
   #task{taskid = 200507 ,name = ?T("诛仙塔12层") ,type = 2 ,next = 200508 ,loop = 0 ,drop = [] ,accept = [{task,200506}] ,finish = [{dungeon,20172,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,50160},{0,10101,4000}] };
get(200508) ->
   #task{taskid = 200508 ,name = ?T("诛仙塔15层") ,type = 2 ,next = 200509 ,loop = 0 ,drop = [] ,accept = [{task,200507}] ,finish = [{dungeon,20175,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,51728},{0,10101,4000}] };
get(200509) ->
   #task{taskid = 200509 ,name = ?T("诛仙塔18层") ,type = 2 ,next = 200510 ,loop = 0 ,drop = [] ,accept = [{task,200508}] ,finish = [{dungeon,20178,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,53390},{0,10101,4000}] };
get(200510) ->
   #task{taskid = 200510 ,name = ?T("诛仙塔20层") ,type = 2 ,next = 200511 ,loop = 0 ,drop = [] ,accept = [{task,200509}] ,finish = [{dungeon,20180,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,53390},{0,10101,4000}] };
get(200511) ->
   #task{taskid = 200511 ,name = ?T("镇魔塔2层") ,type = 2 ,next = 200512 ,loop = 0 ,drop = [] ,accept = [{task,200510}] ,finish = [{dungeon,20182,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(200512) ->
   #task{taskid = 200512 ,name = ?T("镇魔塔5层") ,type = 2 ,next = 200513 ,loop = 0 ,drop = [] ,accept = [{task,200511}] ,finish = [{dungeon,20185,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,15000}] };
get(200513) ->
   #task{taskid = 200513 ,name = ?T("镇魔塔8层") ,type = 2 ,next = 200514 ,loop = 0 ,drop = [] ,accept = [{task,200512}] ,finish = [{dungeon,20188,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,15000}] };
get(200514) ->
   #task{taskid = 200514 ,name = ?T("镇魔塔10层") ,type = 2 ,next = 200515 ,loop = 0 ,drop = [] ,accept = [{task,200513}] ,finish = [{dungeon,20190,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,15000}] };
get(200515) ->
   #task{taskid = 200515 ,name = ?T("镇魔塔12层") ,type = 2 ,next = 200516 ,loop = 0 ,drop = [] ,accept = [{task,200514}] ,finish = [{dungeon,20192,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200516) ->
   #task{taskid = 200516 ,name = ?T("镇魔塔15层") ,type = 2 ,next = 200517 ,loop = 0 ,drop = [] ,accept = [{task,200515}] ,finish = [{dungeon,20195,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200517) ->
   #task{taskid = 200517 ,name = ?T("镇魔塔18层") ,type = 2 ,next = 200518 ,loop = 0 ,drop = [] ,accept = [{task,200516}] ,finish = [{dungeon,20198,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200518) ->
   #task{taskid = 200518 ,name = ?T("镇魔塔20层") ,type = 2 ,next = 200519 ,loop = 0 ,drop = [] ,accept = [{task,200517}] ,finish = [{dungeon,20200,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200519) ->
   #task{taskid = 200519 ,name = ?T("大雁塔5层") ,type = 2 ,next = 200520 ,loop = 0 ,drop = [] ,accept = [{task,200518}] ,finish = [{dungeon,20205,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200520) ->
   #task{taskid = 200520 ,name = ?T("大雁塔10层") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,200519}] ,finish = [{dungeon,20210,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200701) ->
   #task{taskid = 200701 ,name = ?T("初探经脉本") ,type = 2 ,next = 200702 ,loop = 0 ,drop = [] ,accept = [{lv,999}] ,finish = [{dungeon,53001,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200702) ->
   #task{taskid = 200702 ,name = ?T("经脉副本") ,type = 2 ,next = 200703 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200701}] ,finish = [{dungeon,53002,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200703) ->
   #task{taskid = 200703 ,name = ?T("经脉副本") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200702}] ,finish = [{dungeon,53003,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,30000}] };
get(200801) ->
   #task{taskid = 200801 ,name = ?T("神器副本") ,type = 2 ,next = 200802 ,loop = 0 ,drop = [] ,accept = [{lv,999}] ,finish = [{dungeon,52001,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,46440},{0,10101,4000}] };
get(200802) ->
   #task{taskid = 200802 ,name = ?T("神器副本") ,type = 2 ,next = 200803 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200801}] ,finish = [{dungeon,52002,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,25000}] };
get(200803) ->
   #task{taskid = 200803 ,name = ?T("神器副本") ,type = 2 ,next = 200804 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200802}] ,finish = [{dungeon,52003,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,30000}] };
get(200804) ->
   #task{taskid = 200804 ,name = ?T("神器副本") ,type = 2 ,next = 200805 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200803}] ,finish = [{dungeon,52004,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,30000}] };
get(200805) ->
   #task{taskid = 200805 ,name = ?T("神器副本") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,999},{task,200804}] ,finish = [{dungeon,52005,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,30000}] };
get(200811) ->
   #task{taskid = 200811 ,name = ?T("神器1层") ,type = 2 ,next = 200812 ,loop = 0 ,drop = [] ,accept = [{lv,62}] ,finish = [{dungw,52001,5}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,30000}] };
get(200812) ->
   #task{taskid = 200812 ,name = ?T("神器1层") ,type = 2 ,next = 200813 ,loop = 0 ,drop = [] ,accept = [{task,200811}] ,finish = [{dungw,52001,10}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,10000}] };
get(200813) ->
   #task{taskid = 200813 ,name = ?T("神器1层") ,type = 2 ,next = 200814 ,loop = 0 ,drop = [] ,accept = [{task,200812}] ,finish = [{dungw,52001,15}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,10000}] };
get(200814) ->
   #task{taskid = 200814 ,name = ?T("神器1层") ,type = 2 ,next = 200815 ,loop = 0 ,drop = [] ,accept = [{task,200813}] ,finish = [{dungw,52001,20}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,10000}] };
get(200815) ->
   #task{taskid = 200815 ,name = ?T("神器1层") ,type = 2 ,next = 200816 ,loop = 0 ,drop = [] ,accept = [{task,200814}] ,finish = [{dungw,52001,25}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,15000}] };
get(200816) ->
   #task{taskid = 200816 ,name = ?T("神器1层") ,type = 2 ,next = 200817 ,loop = 0 ,drop = [] ,accept = [{task,200815}] ,finish = [{dungw,52001,30}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,15000}] };
get(200817) ->
   #task{taskid = 200817 ,name = ?T("神器2层") ,type = 2 ,next = 200818 ,loop = 0 ,drop = [] ,accept = [{task,200816}] ,finish = [{dungw,52002,5}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200818) ->
   #task{taskid = 200818 ,name = ?T("神器2层") ,type = 2 ,next = 200819 ,loop = 0 ,drop = [] ,accept = [{task,200817}] ,finish = [{dungw,52002,10}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200819) ->
   #task{taskid = 200819 ,name = ?T("神器2层") ,type = 2 ,next = 200820 ,loop = 0 ,drop = [] ,accept = [{task,200818}] ,finish = [{dungw,52002,15}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200820) ->
   #task{taskid = 200820 ,name = ?T("神器2层") ,type = 2 ,next = 200821 ,loop = 0 ,drop = [] ,accept = [{task,200819}] ,finish = [{dungw,52002,20}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200821) ->
   #task{taskid = 200821 ,name = ?T("神器2层") ,type = 2 ,next = 200822 ,loop = 0 ,drop = [] ,accept = [{task,200820}] ,finish = [{dungw,52002,25}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200822) ->
   #task{taskid = 200822 ,name = ?T("神器2层") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,200821}] ,finish = [{dungw,52002,30}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200901) ->
   #task{taskid = 200901 ,name = ?T("4件装备强化+1") ,type = 2 ,next = 200902 ,loop = 0 ,drop = [] ,accept = [{lv,50}] ,finish = [{equipstrength,1,4}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,35872}] };
get(200902) ->
   #task{taskid = 200902 ,name = ?T("全身强化+1") ,type = 2 ,next = 200903 ,loop = 0 ,drop = [] ,accept = [{task,200901}] ,finish = [{equipstrength,1,8}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,36822}] };
get(200903) ->
   #task{taskid = 200903 ,name = ?T("3件装备强化+2") ,type = 2 ,next = 200904 ,loop = 0 ,drop = [] ,accept = [{task,200902}] ,finish = [{equipstrength,2,3}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,47310},{0,3405000,1}] };
get(200904) ->
   #task{taskid = 200904 ,name = ?T("6件装备强化+2") ,type = 2 ,next = 200905 ,loop = 0 ,drop = [] ,accept = [{task,200903}] ,finish = [{equipstrength,2,6}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200905) ->
   #task{taskid = 200905 ,name = ?T("8件装备强化+2") ,type = 2 ,next = 200906 ,loop = 0 ,drop = [] ,accept = [{task,200904}] ,finish = [{equipstrength,2,8}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200906) ->
   #task{taskid = 200906 ,name = ?T("3件装备强化+3") ,type = 2 ,next = 200907 ,loop = 0 ,drop = [] ,accept = [{task,200905}] ,finish = [{equipstrength,3,3}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200907) ->
   #task{taskid = 200907 ,name = ?T("6件装备强化+3") ,type = 2 ,next = 200908 ,loop = 0 ,drop = [] ,accept = [{lv,60},{task,200906}] ,finish = [{equipstrength,3,6}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200908) ->
   #task{taskid = 200908 ,name = ?T("8件装备强化+3") ,type = 2 ,next = 200909 ,loop = 0 ,drop = [] ,accept = [{task,200907}] ,finish = [{equipstrength,3,8}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200909) ->
   #task{taskid = 200909 ,name = ?T("3件装备强化+4") ,type = 2 ,next = 200910 ,loop = 0 ,drop = [] ,accept = [{task,200908}] ,finish = [{equipstrength,4,3}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200910) ->
   #task{taskid = 200910 ,name = ?T("6件装备强化+4") ,type = 2 ,next = 200911 ,loop = 0 ,drop = [] ,accept = [{task,200909}] ,finish = [{equipstrength,4,6}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200911) ->
   #task{taskid = 200911 ,name = ?T("8件装备强化+4") ,type = 2 ,next = 200912 ,loop = 0 ,drop = [] ,accept = [{task,200910}] ,finish = [{equipstrength,4,8}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200912) ->
   #task{taskid = 200912 ,name = ?T("3件装备强化+5") ,type = 2 ,next = 200913 ,loop = 0 ,drop = [] ,accept = [{task,200911}] ,finish = [{equipstrength,5,3}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200913) ->
   #task{taskid = 200913 ,name = ?T("6件装备强化+5") ,type = 2 ,next = 200914 ,loop = 0 ,drop = [] ,accept = [{task,200912}] ,finish = [{equipstrength,5,6}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(200914) ->
   #task{taskid = 200914 ,name = ?T("8件装备强化+5") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,200913}] ,finish = [{equipstrength,5,8}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201001) ->
   #task{taskid = 201001 ,name = ?T("宠物进阶") ,type = 2 ,next = 201002 ,loop = 0 ,drop = [] ,accept = [{lv,63}] ,finish = [{petstage,2}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201002) ->
   #task{taskid = 201002 ,name = ?T("宠物进阶") ,type = 2 ,next = 201003 ,loop = 0 ,drop = [] ,accept = [{lv,65},{task,201001}] ,finish = [{petstage,4}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201003) ->
   #task{taskid = 201003 ,name = ?T("宠物进阶") ,type = 2 ,next = 201004 ,loop = 0 ,drop = [] ,accept = [{lv,68},{task,201002}] ,finish = [{petstage,6}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201004) ->
   #task{taskid = 201004 ,name = ?T("宠物进阶") ,type = 2 ,next = 201005 ,loop = 0 ,drop = [] ,accept = [{lv,70},{task,201003}] ,finish = [{petstage,10}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201005) ->
   #task{taskid = 201005 ,name = ?T("宠物进阶") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,75},{task,201004}] ,finish = [{petstage,15}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201101) ->
   #task{taskid = 201101 ,name = ?T("宠物升星") ,type = 2 ,next = 201102 ,loop = 0 ,drop = [] ,accept = [{lv,63}] ,finish = [{petstar,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201102) ->
   #task{taskid = 201102 ,name = ?T("宠物升星") ,type = 2 ,next = 201103 ,loop = 0 ,drop = [] ,accept = [{lv,65},{task,201101}] ,finish = [{petstar,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201103) ->
   #task{taskid = 201103 ,name = ?T("宠物升星") ,type = 2 ,next = 201104 ,loop = 0 ,drop = [] ,accept = [{lv,65},{task,201102}] ,finish = [{petstar,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201104) ->
   #task{taskid = 201104 ,name = ?T("宠物升星") ,type = 2 ,next = 201105 ,loop = 0 ,drop = [] ,accept = [{lv,68},{task,201103}] ,finish = [{petstar,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(201105) ->
   #task{taskid = 201105 ,name = ?T("宠物升星") ,type = 2 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,70},{task,201104}] ,finish = [{petstar,1}] ,remote = 1 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 20010 ,goods = [{0,10108,20000}] };
get(_) -> [].