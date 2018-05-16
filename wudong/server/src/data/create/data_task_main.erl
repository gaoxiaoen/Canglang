%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_main
	%%% @Created : 2017-11-15 14:12:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_main).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[10010,10020,10030,10040,10050,10051,10052,10060,10070,10080,10090,10100,10110,10120,10130,10140,10142,10143,10150,10151,10160,10170,10180,10190,10191,10200,10201,10202,10210,10220,10221,10222,10230,10240,10241,10250,10260,10270,10271,10272,10273,10280,10281,10282,10283,10284,10285,10286,10290,10300,10310,10320,10330,10340,10350,10360,10370,10380,10390,10400,10410,10420,10430,10440,10450,10460,10461,10470,10480,10490,10500,10510,10520,10530,10540,10550,10560,10570,10580,10581,10582,10590,10600,10610,10611,10620,10630,10640,10641,10650,10660,10661,10662,10670,10671,10672,10673,10674,10675,10680,10681,10682,10690,10691,10692,10700,10701,10702,10703,10704,10705,10710,10711,10712,10720,10721,10722,10730,10731,10732,10733,10734,10735,10740,10741,10742,10750,10751,10752,10753,10754,10755,10756,10760,10770,10780,10790,10800,10810,10820,10830,10840,10850,10860,10870,10880,10890,10900,10910,10920,10930,10940,10950,10960,10970,10971,10980,10990,11000,11010,11020,11030,11040,11050,11060,11070,11080,11090,11100,11110,11120,11130,11140,11150,11160,11170,11180,11190,11200,11210,11220,11230,11240,11250,11260,11270,11280,11290,11300,11310,11320,11330,11340,11350,11360,11370,11380,11390,11400,11410,11420,11430,11440,11450,11460,11470,11480,11490,11500,11510,11520,11530,11540,11550,11560,11570,11580,11590,11600,11610,11620,11630,11640,11650,11660,11670,11680,11690,11700,11710,11720,11730,11740,11750,11760,11770,11780,11790,11800,11810,11820,11830,11840,11850,11860,11870,11880,11890,11900,11910,11920,11930,11940,11950,11960,11970,11980,11990,12000,12010,12020,12030,12040,12050,12060,12070,12080,12090,12100,12110,12120,12130,12140,12150,12160,12170,12180,12190,12200,12210,12220,12230,12240,12250,12260,12270,12280,12290,12300,12310,12320,12330,12340,12350,12360,12370,12380,12390,12400,12410,12420,12430,12440,12450,12460,12470,12480,12490,12500,12510,12520,12530,12540,12550,12560,12570,12580,12590,12600,12610,12620,12630,12640,12650,12660,12670,12680,12690,12700,12710,12720,12730,12740,12750,12760,12770,12780,12790,12800,12810,12820,12830,12840,12850,12860,12870,12880,12890,12900,12910,12920,12930,12940,12950,12960,12970,12980,12990,13000,13010,13020,13030,13040,13050,13060,13070,13080,13090,13100,13110,13120,13130,13140,13150,13160,13170,13180,13190,13200,13210,13220,13230,13240,13250,13260,13270,13280,13290,13300,13310,13320,13330,13340,13350,13360,13370,13380,13390,13400,13410,13420,13430,13440,13450,13460,13470,13480,13490,13500,13510,13520,13530,13540,13550,13560,13570,13580,13590,13600,13610,13620,13630,13640,13650,13660,13670,13680,13690,13700,13710,13720,13730,13740,13750,13760,13770,13780,13790,13800,13810,13820,13830,13840,13850,13860,13870,13880,13890,13900,13910,13920,13930,13940,13950,13960,13970,13980,13990,14000,14010,14020,14030,14040,14050,14060,14070,14080,14090,14100,14110,14120,14130,14140,14150,14160,14170,14180,14190,14200].

get(10010) ->
   #task{taskid = 10010 ,name = ?T("真灵降世") ,chapter = 1 ,sort = 1 ,sort_lim = 11 ,type = 1 ,next = 10020 ,loop = 0 ,drop = [] ,accept = [] ,finish = [{npc,11001}] ,remote = 0 ,npcid = 0 ,endnpcid = 11001 ,talkid = 0 ,endtalkid = 1001 ,goods = [{0,10108,2010},{0,10101,1000}] };
get(10020) ->
   #task{taskid = 10020 ,name = ?T("夺回神器") ,chapter = 1 ,sort = 2 ,sort_lim = 11 ,type = 1 ,next = 10030 ,loop = 0 ,drop = [] ,accept = [{task,10010},{lv,1}] ,finish = [{npc,11002}] ,remote = 0 ,npcid = 11001 ,endnpcid = 11002 ,talkid = 0 ,endtalkid = 1002 ,goods = [{0,10108,4900},{0,10101,1000}] };
get(10030) ->
   #task{taskid = 10030 ,name = ?T("蜀山危机") ,chapter = 1 ,sort = 3 ,sort_lim = 11 ,type = 1 ,next = 10040 ,loop = 0 ,drop = [] ,accept = [{task,10020},{lv,1}] ,finish = [{npc,11003}] ,remote = 0 ,npcid = 11002 ,endnpcid = 11003 ,talkid = 0 ,endtalkid = 1003 ,goods = [{0,10108,3500},{0,10101,1000}] };
get(10040) ->
   #task{taskid = 10040 ,name = ?T("灵剑择主") ,chapter = 1 ,sort = 4 ,sort_lim = 11 ,type = 1 ,next = 10050 ,loop = 0 ,drop = [] ,accept = [{task,10030},{lv,1}] ,finish = [{collect,21011,1}] ,remote = 1 ,npcid = 11003 ,endnpcid = 11003 ,talkid = 0 ,endtalkid = 1004 ,goods = [{0,10108,2500},{0,2201001,1}] };
get(10050) ->
   #task{taskid = 10050 ,name = ?T("蜀山剑诀") ,chapter = 1 ,sort = 5 ,sort_lim = 11 ,type = 1 ,next = 10051 ,loop = 0 ,drop = [] ,accept = [{task,10040},{lv,1}] ,finish = [{npc,11005}] ,remote = 0 ,npcid = 11003 ,endnpcid = 11005 ,talkid = 0 ,endtalkid = 1005 ,goods = [{0,10108,4000},{0,10101,1000}] };
get(10051) ->
   #task{taskid = 10051 ,name = ?T("宝剑出鞘") ,chapter = 1 ,sort = 6 ,sort_lim = 11 ,type = 1 ,next = 10052 ,loop = 0 ,drop = [] ,accept = [{task,10050},{lv,1}] ,finish = [{kill,21000,1}] ,remote = 0 ,npcid = 11005 ,endnpcid = 11014 ,talkid = 0 ,endtalkid = 2001 ,goods = [{0,10108,5100},{0,10101,1000}] };
get(10052) ->
   #task{taskid = 10052 ,name = ?T("神器附身") ,chapter = 1 ,sort = 7 ,sort_lim = 11 ,type = 1 ,next = 10060 ,loop = 0 ,drop = [] ,accept = [{task,10051},{lv,1}] ,finish = [{npc,11014}] ,remote = 0 ,npcid = 11014 ,endnpcid = 11014 ,talkid = 0 ,endtalkid = 2101 ,goods = [{0,10108,3100},{0,10101,1000}] };
get(10060) ->
   #task{taskid = 10060 ,name = ?T("冲出重围") ,chapter = 1 ,sort = 8 ,sort_lim = 11 ,type = 1 ,next = 10070 ,loop = 0 ,drop = [] ,accept = [{task,10052},{lv,1}] ,finish = [{kill,21001,18}] ,remote = 0 ,npcid = 11014 ,endnpcid = 11006 ,talkid = 0 ,endtalkid = 1006 ,goods = [{0,10108,3100},{0,10101,1000}] };
get(10070) ->
   #task{taskid = 10070 ,name = ?T("神器之灵") ,chapter = 1 ,sort = 9 ,sort_lim = 11 ,type = 1 ,next = 10080 ,loop = 0 ,drop = [] ,accept = [{task,10060},{lv,1}] ,finish = [{kill,21002,1}] ,remote = 1 ,npcid = 11006 ,endnpcid = 11006 ,talkid = 0 ,endtalkid = 1007 ,goods = [{0,10108,5700},{0,10101,1000}] };
get(10080) ->
   #task{taskid = 10080 ,name = ?T("行尸走肉") ,chapter = 1 ,sort = 10 ,sort_lim = 11 ,type = 1 ,next = 10090 ,loop = 0 ,drop = [] ,accept = [{task,10070},{lv,1}] ,finish = [{kill,21004,12}] ,remote = 0 ,npcid = 11006 ,endnpcid = 11009 ,talkid = 0 ,endtalkid = 1008 ,goods = [{0,10108,6000},{0,2106001,1}] };
get(10090) ->
   #task{taskid = 10090 ,name = ?T("明镜之湖") ,chapter = 1 ,sort = 11 ,sort_lim = 11 ,type = 1 ,next = 10100 ,loop = 0 ,drop = [] ,accept = [{task,10080},{lv,1}] ,finish = [{npc,11007}] ,remote = 0 ,npcid = 11009 ,endnpcid = 11007 ,talkid = 0 ,endtalkid = 1009 ,goods = [{0,10108,5100},{0,10101,1000}] };
get(10100) ->
   #task{taskid = 10100 ,name = ?T("白虎啸月") ,chapter = 2 ,sort = 1 ,sort_lim = 14 ,type = 1 ,next = 10110 ,loop = 0 ,drop = [] ,accept = [{task,10090},{lv,1}] ,finish = [{kill,21005,10}] ,remote = 1 ,npcid = 11007 ,endnpcid = 11007 ,talkid = 0 ,endtalkid = 1010 ,goods = [{0,10108,4000},{0,10101,1000}] };
get(10110) ->
   #task{taskid = 10110 ,name = ?T("百变灵宠") ,chapter = 2 ,sort = 2 ,sort_lim = 14 ,type = 1 ,next = 10120 ,loop = 0 ,drop = [] ,accept = [{task,10100},{lv,1}] ,finish = [{npc,11008}] ,remote = 0 ,npcid = 11007 ,endnpcid = 11008 ,talkid = 0 ,endtalkid = 1011 ,goods = [{0,10108,4000},{0,11501,1}] };
get(10120) ->
   #task{taskid = 10120 ,name = ?T("斩杀灵感") ,chapter = 2 ,sort = 3 ,sort_lim = 14 ,type = 1 ,next = 10130 ,loop = 0 ,drop = [] ,accept = [{task,10110},{lv,1}] ,finish = [{kill,21006,1}] ,remote = 1 ,npcid = 11008 ,endnpcid = 11008 ,talkid = 0 ,endtalkid = 1012 ,goods = [{0,10108,5700},{0,10101,1500}] };
get(10130) ->
   #task{taskid = 10130 ,name = ?T("清扫水族") ,chapter = 2 ,sort = 4 ,sort_lim = 14 ,type = 1 ,next = 10140 ,loop = 0 ,drop = [] ,accept = [{task,10120},{lv,1}] ,finish = [{kill,21007,10}] ,remote = 1 ,npcid = 11008 ,endnpcid = 11008 ,talkid = 0 ,endtalkid = 1013 ,goods = [{0,10108,4500},{0,2102001,1}] };
get(10140) ->
   #task{taskid = 10140 ,name = ?T("前往长留") ,chapter = 2 ,sort = 5 ,sort_lim = 14 ,type = 1 ,next = 10142 ,loop = 0 ,drop = [] ,accept = [{task,10130},{lv,1}] ,finish = [{npc,11049}] ,remote = 0 ,npcid = 11008 ,endnpcid = 11049 ,talkid = 0 ,endtalkid = 1014 ,goods = [{0,10108,4500},{0,10101,1500}] };
get(10142) ->
   #task{taskid = 10142 ,name = ?T("长留山门") ,chapter = 2 ,sort = 6 ,sort_lim = 14 ,type = 1 ,next = 10143 ,loop = 0 ,drop = [] ,accept = [{task,10140},{lv,1}] ,finish = [{npc,13019}] ,remote = 0 ,npcid = 11049 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 1015 ,goods = [{0,10108,7900},{0,10101,1500}] };
get(10143) ->
   #task{taskid = 10143 ,name = ?T("天下大乱") ,chapter = 2 ,sort = 7 ,sort_lim = 14 ,type = 1 ,next = 10150 ,loop = 0 ,drop = [] ,accept = [{task,10142},{lv,1}] ,finish = [{kill,23004,6}] ,remote = 1 ,npcid = 13019 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 1016 ,goods = [{0,10108,8200},{0,10101,1500}] };
get(10150) ->
   #task{taskid = 10150 ,name = ?T("玄镇器灵") ,chapter = 2 ,sort = 8 ,sort_lim = 14 ,type = 1 ,next = 10151 ,loop = 0 ,drop = [] ,accept = [{task,10143},{lv,1}] ,finish = [{kill,23013,1}] ,remote = 1 ,npcid = 13019 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 1017 ,goods = [{0,10108,15300},{0,2107001,1}] };
get(10151) ->
   #task{taskid = 10151 ,name = ?T("灵龙宝剑") ,chapter = 2 ,sort = 9 ,sort_lim = 14 ,type = 1 ,next = 10160 ,loop = 0 ,drop = [] ,accept = [{task,10150},{lv,1}] ,finish = [{collect,23001,1}] ,remote = 0 ,npcid = 13019 ,endnpcid = 13021 ,talkid = 0 ,endtalkid = 1018 ,goods = [{0,10108,25000},{0,10101,1500}] };
get(10160) ->
   #task{taskid = 10160 ,name = ?T("长留门规") ,chapter = 2 ,sort = 10 ,sort_lim = 14 ,type = 1 ,next = 10170 ,loop = 0 ,drop = [] ,accept = [{task,10151},{lv,1}] ,finish = [{npc,13022}] ,remote = 0 ,npcid = 13021 ,endnpcid = 13022 ,talkid = 0 ,endtalkid = 1019 ,goods = [{0,10108,21400},{0,10101,1500}] };
get(10170) ->
   #task{taskid = 10170 ,name = ?T("踏风神驹") ,chapter = 2 ,sort = 11 ,sort_lim = 14 ,type = 1 ,next = 10180 ,loop = 0 ,drop = [] ,accept = [{task,10160},{lv,1}] ,finish = [{kill,23014,10}] ,remote = 0 ,npcid = 13022 ,endnpcid = 13023 ,talkid = 0 ,endtalkid = 1020 ,goods = [{0,10108,14000},{0,10101,1500}] };
get(10180) ->
   #task{taskid = 10180 ,name = ?T("相思长明") ,chapter = 2 ,sort = 12 ,sort_lim = 14 ,type = 1 ,next = 10190 ,loop = 0 ,drop = [] ,accept = [{task,10170},{lv,1}] ,finish = [{collect,23002,1}] ,remote = 0 ,npcid = 13023 ,endnpcid = 13025 ,talkid = 0 ,endtalkid = 1021 ,goods = [{0,10108,17600},{0,2104001,1}] };
get(10190) ->
   #task{taskid = 10190 ,name = ?T("长留弃徒") ,chapter = 2 ,sort = 13 ,sort_lim = 14 ,type = 1 ,next = 10191 ,loop = 0 ,drop = [] ,accept = [{task,10180},{lv,1}] ,finish = [{kill,23030,1}] ,remote = 0 ,npcid = 13025 ,endnpcid = 13024 ,talkid = 0 ,endtalkid = 1022 ,goods = [{0,10108,15000},{0,10101,1500}] };
get(10191) ->
   #task{taskid = 10191 ,name = ?T("帝都长安") ,chapter = 2 ,sort = 14 ,sort_lim = 14 ,type = 1 ,next = 10200 ,loop = 0 ,drop = [] ,accept = [{task,10190},{lv,1}] ,finish = [{npc,12009}] ,remote = 0 ,npcid = 13024 ,endnpcid = 12009 ,talkid = 0 ,endtalkid = 1023 ,goods = [{0,10108,15800},{0,10101,1500}] };
get(10200) ->
   #task{taskid = 10200 ,name = ?T("进阶丹药") ,chapter = 3 ,sort = 1 ,sort_lim = 13 ,type = 1 ,next = 10201 ,loop = 0 ,drop = [] ,accept = [{task,10191},{lv,1}] ,finish = [{npc,12009}] ,remote = 0 ,npcid = 12009 ,endnpcid = 12009 ,talkid = 0 ,endtalkid = 1024 ,goods = [{0,10108,12800},{0,3101000,2}] };
get(10201) ->
   #task{taskid = 10201 ,name = ?T("斗技比试") ,chapter = 3 ,sort = 2 ,sort_lim = 13 ,type = 1 ,next = 10202 ,loop = 0 ,drop = [] ,accept = [{task,10200},{lv,10}] ,finish = [{kill,22008,1}] ,remote = 0 ,npcid = 12009 ,endnpcid = 12012 ,talkid = 0 ,endtalkid = 1025 ,goods = [{0,10108,19100},{0,2105001,1}] };
get(10202) ->
   #task{taskid = 10202 ,name = ?T("蜀山来人") ,chapter = 3 ,sort = 3 ,sort_lim = 13 ,type = 1 ,next = 10210 ,loop = 0 ,drop = [] ,accept = [{task,10201}] ,finish = [{npc,12010}] ,remote = 0 ,npcid = 12012 ,endnpcid = 12010 ,talkid = 0 ,endtalkid = 1026 ,goods = [{0,10108,17000},{0,10101,2000}] };
get(10210) ->
   #task{taskid = 10210 ,name = ?T("神剑择主") ,chapter = 3 ,sort = 4 ,sort_lim = 13 ,type = 1 ,next = 10220 ,loop = 0 ,drop = [] ,accept = [{task,10202}] ,finish = [{npc,12047}] ,remote = 0 ,npcid = 12010 ,endnpcid = 12047 ,talkid = 0 ,endtalkid = 1027 ,goods = [{0,10108,17200},{0,10101,2000}] };
get(10220) ->
   #task{taskid = 10220 ,name = ?T("进阶秘境") ,chapter = 2 ,sort = 5 ,sort_lim = 13 ,type = 1 ,next = 10221 ,loop = 0 ,drop = [] ,accept = [{task,10210}] ,finish = [{npc,12046}] ,remote = 0 ,npcid = 12047 ,endnpcid = 12046 ,talkid = 0 ,endtalkid = 1028 ,goods = [{0,10108,18000},{0,10101,2000}] };
get(10221) ->
   #task{taskid = 10221 ,name = ?T("坊市传闻") ,chapter = 2 ,sort = 6 ,sort_lim = 13 ,type = 1 ,next = 10222 ,loop = 0 ,drop = [] ,accept = [{task,10220}] ,finish = [{npc,12040}] ,remote = 0 ,npcid = 12046 ,endnpcid = 12040 ,talkid = 0 ,endtalkid = 1029 ,goods = [{0,10108,32000},{0,10101,2000}] };
get(10222) ->
   #task{taskid = 10222 ,name = ?T("活人不医") ,chapter = 2 ,sort = 7 ,sort_lim = 13 ,type = 1 ,next = 10230 ,loop = 0 ,drop = [] ,accept = [{task,10221}] ,finish = [{npc,12016}] ,remote = 0 ,npcid = 12040 ,endnpcid = 12016 ,talkid = 0 ,endtalkid = 1030 ,goods = [{0,10108,23700},{0,1008000,3}] };
get(10230) ->
   #task{taskid = 10230 ,name = ?T("重返长留") ,chapter = 2 ,sort = 8 ,sort_lim = 13 ,type = 1 ,next = 10240 ,loop = 0 ,drop = [] ,accept = [{task,10222}] ,finish = [{npc,13019}] ,remote = 0 ,npcid = 12016 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 1031 ,goods = [{0,10108,24200},{0,2108001,1}] };
get(10240) ->
   #task{taskid = 10240 ,name = ?T("扫清道路") ,chapter = 3 ,sort = 9 ,sort_lim = 13 ,type = 1 ,next = 10241 ,loop = 0 ,drop = [] ,accept = [{task,10230}] ,finish = [{kill,23005,10}] ,remote = 0 ,npcid = 13019 ,endnpcid = 13053 ,talkid = 0 ,endtalkid = 1032 ,goods = [{0,10108,30000},{0,2103001,1}] };
get(10241) ->
   #task{taskid = 10241 ,name = ?T("安抚弟子") ,chapter = 3 ,sort = 10 ,sort_lim = 13 ,type = 1 ,next = 10250 ,loop = 0 ,drop = [] ,accept = [{task,10240}] ,finish = [{npc,13020}] ,remote = 0 ,npcid = 13053 ,endnpcid = 13020 ,talkid = 0 ,endtalkid = 1033 ,goods = [{0,10108,25700},{0,10101,2000}] };
get(10250) ->
   #task{taskid = 10250 ,name = ?T("洪荒之力") ,chapter = 3 ,sort = 11 ,sort_lim = 13 ,type = 1 ,next = 10260 ,loop = 0 ,drop = [] ,accept = [{task,10241}] ,finish = [{kill,23011,10}] ,remote = 1 ,npcid = 13020 ,endnpcid = 13019 ,talkid = 0 ,endtalkid = 1034 ,goods = [{0,10108,21000},{0,10101,2000}] };
get(10260) ->
   #task{taskid = 10260 ,name = ?T("战神降临") ,chapter = 3 ,sort = 12 ,sort_lim = 13 ,type = 1 ,next = 10270 ,loop = 0 ,drop = [] ,accept = [{task,10250}] ,finish = [{kill,23012,1}] ,remote = 0 ,npcid = 13019 ,endnpcid = 13037 ,talkid = 0 ,endtalkid = 1035 ,goods = [{0,10108,28900},{0,3101000,4}] };
get(10270) ->
   #task{taskid = 10270 ,name = ?T("追查线索") ,chapter = 3 ,sort = 13 ,sort_lim = 13 ,type = 1 ,next = 10271 ,loop = 0 ,drop = [] ,accept = [{task,10260}] ,finish = [{kill,23029,10}] ,remote = 0 ,npcid = 13037 ,endnpcid = 13036 ,talkid = 0 ,endtalkid = 1036 ,goods = [{0,10108,39600},{0,3101000,3}] };
get(10271) ->
   #task{taskid = 10271 ,name = ?T("长留叛徒") ,chapter = 4 ,sort = 1 ,sort_lim = 11 ,type = 1 ,next = 10272 ,loop = 0 ,drop = [] ,accept = [{task,10270}] ,finish = [{kill,23015,1}] ,remote = 0 ,npcid = 13036 ,endnpcid = 13026 ,talkid = 0 ,endtalkid = 1037 ,goods = [{0,10108,27000},{0,10101,2000}] };
get(10272) ->
   #task{taskid = 10272 ,name = ?T("木灵指路") ,chapter = 4 ,sort = 2 ,sort_lim = 11 ,type = 1 ,next = 10273 ,loop = 0 ,drop = [] ,accept = [{task,10271}] ,finish = [{kill,23016,10}] ,remote = 0 ,npcid = 13026 ,endnpcid = 13027 ,talkid = 0 ,endtalkid = 1038 ,goods = [{0,10108,91200},{0,10101,2000}] };
get(10273) ->
   #task{taskid = 10273 ,name = ?T("长留事毕") ,chapter = 4 ,sort = 3 ,sort_lim = 11 ,type = 1 ,next = 10280 ,loop = 0 ,drop = [] ,accept = [{task,10272}] ,finish = [{kill,23017,10}] ,remote = 1 ,npcid = 13027 ,endnpcid = 13027 ,talkid = 0 ,endtalkid = 1039 ,goods = [{0,10108,73500},{0,10101,2000}] };
get(10280) ->
   #task{taskid = 10280 ,name = ?T("回返长安") ,chapter = 4 ,sort = 4 ,sort_lim = 11 ,type = 1 ,next = 10281 ,loop = 0 ,drop = [] ,accept = [{task,10273}] ,finish = [{npc,12009}] ,remote = 0 ,npcid = 13027 ,endnpcid = 12009 ,talkid = 0 ,endtalkid = 1040 ,goods = [{0,10108,76500},{0,10101,2000}] };
get(10281) ->
   #task{taskid = 10281 ,name = ?T("鸾凤仙台") ,chapter = 4 ,sort = 5 ,sort_lim = 11 ,type = 1 ,next = 10282 ,loop = 0 ,drop = [] ,accept = [{task,10280}] ,finish = [{npc,12011}] ,remote = 0 ,npcid = 12009 ,endnpcid = 12011 ,talkid = 0 ,endtalkid = 1041 ,goods = [{0,10108,48400},{0,10101,2000}] };
get(10282) ->
   #task{taskid = 10282 ,name = ?T("呆鹅十三") ,chapter = 4 ,sort = 6 ,sort_lim = 11 ,type = 1 ,next = 10283 ,loop = 0 ,drop = [] ,accept = [{task,10281}] ,finish = [{npc,12048}] ,remote = 0 ,npcid = 12011 ,endnpcid = 12048 ,talkid = 0 ,endtalkid = 1042 ,goods = [{0,10108,66100},{0,10101,2000}] };
get(10283) ->
   #task{taskid = 10283 ,name = ?T("女儿心事") ,chapter = 4 ,sort = 7 ,sort_lim = 11 ,type = 1 ,next = 10284 ,loop = 0 ,drop = [] ,accept = [{task,10282}] ,finish = [{collect,22004,1}] ,remote = 0 ,npcid = 12048 ,endnpcid = 12018 ,talkid = 0 ,endtalkid = 1043 ,goods = [{0,10108,28700},{0,10101,2000}] };
get(10284) ->
   #task{taskid = 10284 ,name = ?T("收拾行囊") ,chapter = 4 ,sort = 8 ,sort_lim = 11 ,type = 1 ,next = 10285 ,loop = 0 ,drop = [] ,accept = [{task,10283}] ,finish = [{npc,12044}] ,remote = 0 ,npcid = 12018 ,endnpcid = 12044 ,talkid = 0 ,endtalkid = 1044 ,goods = [{0,10108,58800},{0,10101,2000}] };
get(10285) ->
   #task{taskid = 10285 ,name = ?T("失落大陆") ,chapter = 4 ,sort = 9 ,sort_lim = 11 ,type = 1 ,next = 10286 ,loop = 0 ,drop = [] ,accept = [{task,10284}] ,finish = [{npc,12010}] ,remote = 0 ,npcid = 12044 ,endnpcid = 12010 ,talkid = 0 ,endtalkid = 1045 ,goods = [{0,10108,49700},{0,10101,2000}] };
get(10286) ->
   #task{taskid = 10286 ,name = ?T("妖魔掮客") ,chapter = 4 ,sort = 10 ,sort_lim = 11 ,type = 1 ,next = 10290 ,loop = 0 ,drop = [] ,accept = [{task,10285}] ,finish = [{npc,14028}] ,remote = 0 ,npcid = 12010 ,endnpcid = 14028 ,talkid = 0 ,endtalkid = 1046 ,goods = [{0,10108,60900},{0,2003000,5},{0,10101,50000}] };
get(10290) ->
   #task{taskid = 10290 ,name = ?T("意外收获") ,chapter = 4 ,sort = 11 ,sort_lim = 11 ,type = 1 ,next = 10300 ,loop = 0 ,drop = [] ,accept = [{task,10286}] ,finish = [{kill,24001,20}] ,remote = 1 ,npcid = 14028 ,endnpcid = 14028 ,talkid = 0 ,endtalkid = 1047 ,goods = [{0,10108,51800},{0,10101,2500}] };
get(10300) ->
   #task{taskid = 10300 ,name = ?T("毒心百蛊") ,chapter = 5 ,sort = 1 ,sort_lim = 13 ,type = 1 ,next = 10310 ,loop = 0 ,drop = [] ,accept = [{task,10290},{lv,1}] ,finish = [{npc,14029}] ,remote = 0 ,npcid = 14028 ,endnpcid = 14029 ,talkid = 0 ,endtalkid = 1048 ,goods = [{0,10108,63000},{0,8001180,1}] };
get(10310) ->
   #task{taskid = 10310 ,name = ?T("荒漠猛虎") ,chapter = 5 ,sort = 2 ,sort_lim = 13 ,type = 1 ,next = 10320 ,loop = 0 ,drop = [] ,accept = [{task,10300},{lv,1}] ,finish = [{kill,24019,20}] ,remote = 1 ,npcid = 14029 ,endnpcid = 14029 ,talkid = 0 ,endtalkid = 1049 ,goods = [{0,10108,64700},{0,1008000,6}] };
get(10320) ->
   #task{taskid = 10320 ,name = ?T("牛力大仙") ,chapter = 5 ,sort = 3 ,sort_lim = 13 ,type = 1 ,next = 10330 ,loop = 0 ,drop = [] ,accept = [{task,10310},{lv,1}] ,finish = [{kill,24002,1}] ,remote = 1 ,npcid = 14029 ,endnpcid = 14029 ,talkid = 0 ,endtalkid = 1050 ,goods = [{0,10108,32500},{0,10101,2500}] };
get(10330) ->
   #task{taskid = 10330 ,name = ?T("大力开山") ,chapter = 5 ,sort = 4 ,sort_lim = 13 ,type = 1 ,next = 10340 ,loop = 0 ,drop = [] ,accept = [{task,10320},{lv,1}] ,finish = [{kill,24018,25}] ,remote = 0 ,npcid = 14029 ,endnpcid = 14030 ,talkid = 0 ,endtalkid = 1051 ,goods = [{0,10108,47300},{0,10101,2500}] };
get(10340) ->
   #task{taskid = 10340 ,name = ?T("鹿角野猪") ,chapter = 5 ,sort = 5 ,sort_lim = 13 ,type = 1 ,next = 10350 ,loop = 0 ,drop = [] ,accept = [{task,10330},{lv,1}] ,finish = [{kill,24020,25}] ,remote = 1 ,npcid = 14030 ,endnpcid = 14030 ,talkid = 0 ,endtalkid = 1052 ,goods = [{0,10108,38400},{0,10101,2500}] };
get(10350) ->
   #task{taskid = 10350 ,name = ?T("灵感大王") ,chapter = 5 ,sort = 6 ,sort_lim = 13 ,type = 1 ,next = 10360 ,loop = 0 ,drop = [] ,accept = [{task,10340},{lv,1}] ,finish = [{kill,24024,1}] ,remote = 0 ,npcid = 14030 ,endnpcid = 14031 ,talkid = 0 ,endtalkid = 1053 ,goods = [{0,10108,90400},{0,10101,2500}] };
get(10360) ->
   #task{taskid = 10360 ,name = ?T("妖神圣君") ,chapter = 5 ,sort = 7 ,sort_lim = 13 ,type = 1 ,next = 10370 ,loop = 0 ,drop = [] ,accept = [{task,10350},{lv,1}] ,finish = [{npc,14032}] ,remote = 0 ,npcid = 14031 ,endnpcid = 14032 ,talkid = 0 ,endtalkid = 1054 ,goods = [{0,10108,79200},{0,10101,2500}] };
get(10370) ->
   #task{taskid = 10370 ,name = ?T("饕餮为祸") ,chapter = 5 ,sort = 8 ,sort_lim = 13 ,type = 1 ,next = 10380 ,loop = 0 ,drop = [] ,accept = [{task,10360},{lv,1}] ,finish = [{kill,24004,30}] ,remote = 1 ,npcid = 14032 ,endnpcid = 14032 ,talkid = 0 ,endtalkid = 1055 ,goods = [{0,10108,67200},{0,10101,2500}] };
get(10380) ->
   #task{taskid = 10380 ,name = ?T("即时灭火") ,chapter = 5 ,sort = 9 ,sort_lim = 13 ,type = 1 ,next = 10390 ,loop = 0 ,drop = [] ,accept = [{task,10370},{lv,1}] ,finish = [{kill,24021,30}] ,remote = 1 ,npcid = 14032 ,endnpcid = 14032 ,talkid = 0 ,endtalkid = 1056 ,goods = [{0,10108,81600},{0,10101,2500}] };
get(10390) ->
   #task{taskid = 10390 ,name = ?T("巨熊战将") ,chapter = 5 ,sort = 10 ,sort_lim = 13 ,type = 1 ,next = 10400 ,loop = 0 ,drop = [] ,accept = [{task,10380},{lv,1}] ,finish = [{kill,24003,1}] ,remote = 0 ,npcid = 14032 ,endnpcid = 14033 ,talkid = 0 ,endtalkid = 1057 ,goods = [{0,10108,41600},{0,1015000,3}] };
get(10400) ->
   #task{taskid = 10400 ,name = ?T("须臾如风") ,chapter = 5 ,sort = 11 ,sort_lim = 13 ,type = 1 ,next = 10410 ,loop = 0 ,drop = [] ,accept = [{task,10390},{lv,1}] ,finish = [{npc,14034}] ,remote = 0 ,npcid = 14033 ,endnpcid = 14034 ,talkid = 0 ,endtalkid = 1058 ,goods = [{0,10108,56000},{0,10101,2500}] };
get(10410) ->
   #task{taskid = 10410 ,name = ?T("经验秘境") ,chapter = 5 ,sort = 12 ,sort_lim = 13 ,type = 1 ,next = 10420 ,loop = 0 ,drop = [] ,accept = [{task,10400},{lv,30}] ,finish = [{npc,14035}] ,remote = 0 ,npcid = 14034 ,endnpcid = 14035 ,talkid = 0 ,endtalkid = 1059 ,goods = [{0,10108,28000},{0,10101,2500}] };
get(10420) ->
   #task{taskid = 10420 ,name = ?T("幽冥判官") ,chapter = 5 ,sort = 13 ,sort_lim = 13 ,type = 1 ,next = 10430 ,loop = 0 ,drop = [] ,accept = [{task,10410},{lv,1}] ,finish = [{kill,24025,1}] ,remote = 0 ,npcid = 14035 ,endnpcid = 14035 ,talkid = 0 ,endtalkid = 1060 ,goods = [{0,10108,56800},{0,10101,2500}] };
get(10430) ->
   #task{taskid = 10430 ,name = ?T("触手丛生") ,chapter = 6 ,sort = 1 ,sort_lim = 11 ,type = 1 ,next = 10440 ,loop = 0 ,drop = [] ,accept = [{task,10420},{lv,1}] ,finish = [{collect,24007,1}] ,remote = 0 ,npcid = 14035 ,endnpcid = 14050 ,talkid = 0 ,endtalkid = 1061 ,goods = [{0,10108,72000},{0,2003000,10}] };
get(10440) ->
   #task{taskid = 10440 ,name = ?T("断桥飞渡") ,chapter = 6 ,sort = 2 ,sort_lim = 11 ,type = 1 ,next = 10450 ,loop = 0 ,drop = [] ,accept = [{task,10430},{lv,1}] ,finish = [{kill,24026,35}] ,remote = 0 ,npcid = 14050 ,endnpcid = 14052 ,talkid = 0 ,endtalkid = 1062 ,goods = [{0,10108,76500},{0,10101,100000}] };
get(10450) ->
   #task{taskid = 10450 ,name = ?T("魔尸巨力") ,chapter = 6 ,sort = 3 ,sort_lim = 11 ,type = 1 ,next = 10460 ,loop = 0 ,drop = [] ,accept = [{task,10440},{lv,1}] ,finish = [{kill,24023,1}] ,remote = 1 ,npcid = 14052 ,endnpcid = 14052 ,talkid = 0 ,endtalkid = 1063 ,goods = [{0,10108,99900},{0,10101,3000}] };
get(10460) ->
   #task{taskid = 10460 ,name = ?T("醒来") ,chapter = 6 ,sort = 4 ,sort_lim = 11 ,type = 1 ,next = 10461 ,loop = 0 ,drop = [] ,accept = [{task,10450},{lv,1}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 14052 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1064 ,goods = [{0,10108,84600},{0,10101,3000}] };
get(10461) ->
   #task{taskid = 10461 ,name = ?T("异朽阁主") ,chapter = 6 ,sort = 5 ,sort_lim = 11 ,type = 1 ,next = 10470 ,loop = 0 ,drop = [] ,accept = [{task,10460},{lv,1}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1065 ,goods = [{0,10108,85500},{0,10101,3000}] };
get(10470) ->
   #task{taskid = 10470 ,name = ?T("众志成城") ,chapter = 6 ,sort = 6 ,sort_lim = 11 ,type = 1 ,next = 10480 ,loop = 0 ,drop = [] ,accept = [{task,10461},{lv,1}] ,finish = [{npc,12042}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 1066 ,goods = [{0,10108,86800},{0,10101,3000}] };
get(10480) ->
   #task{taskid = 10480 ,name = ?T("藏珍宝阁") ,chapter = 6 ,sort = 7 ,sort_lim = 11 ,type = 1 ,next = 10490 ,loop = 0 ,drop = [] ,accept = [{task,10470},{lv,1}] ,finish = [{collect,22002,1}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12015 ,talkid = 0 ,endtalkid = 1067 ,goods = [{0,10108,87700}] };
get(10490) ->
   #task{taskid = 10490 ,name = ?T("再遇药师") ,chapter = 6 ,sort = 8 ,sort_lim = 11 ,type = 1 ,next = 10500 ,loop = 0 ,drop = [] ,accept = [{task,10480},{lv,1}] ,finish = [{npc,12016}] ,remote = 0 ,npcid = 12015 ,endnpcid = 12016 ,talkid = 0 ,endtalkid = 1068 ,goods = [{0,10108,89100},{0,10101,3000}] };
get(10500) ->
   #task{taskid = 10500 ,name = ?T("女中豪杰") ,chapter = 6 ,sort = 9 ,sort_lim = 11 ,type = 1 ,next = 10510 ,loop = 0 ,drop = [] ,accept = [{task,10490},{lv,1}] ,finish = [{npc,12041}] ,remote = 0 ,npcid = 12016 ,endnpcid = 12041 ,talkid = 0 ,endtalkid = 1069 ,goods = [{0,10108,90000},{0,2601001,1}] };
get(10510) ->
   #task{taskid = 10510 ,name = ?T("蓬莱内乱") ,chapter = 6 ,sort = 10 ,sort_lim = 11 ,type = 1 ,next = 10520 ,loop = 0 ,drop = [] ,accept = [{task,10500},{lv,1}] ,finish = [{npc,15001}] ,remote = 0 ,npcid = 12041 ,endnpcid = 15001 ,talkid = 0 ,endtalkid = 1070 ,goods = [{0,10108,90000},{0,10101,3000}] };
get(10520) ->
   #task{taskid = 10520 ,name = ?T("明月童子") ,chapter = 6 ,sort = 11 ,sort_lim = 11 ,type = 1 ,next = 10530 ,loop = 0 ,drop = [] ,accept = [{task,10510},{lv,1}] ,finish = [{npc,15002}] ,remote = 0 ,npcid = 15001 ,endnpcid = 15002 ,talkid = 0 ,endtalkid = 1071 ,goods = [{0,10108,90100},{0,2003000,10},{0,12050,1}] };
get(10530) ->
   #task{taskid = 10530 ,name = ?T("饿鬼道") ,chapter = 7 ,sort = 1 ,sort_lim = 13 ,type = 1 ,next = 10540 ,loop = 0 ,drop = [] ,accept = [{task,10520},{lv,1}] ,finish = [{kill,25001,30}] ,remote = 1 ,npcid = 15002 ,endnpcid = 15002 ,talkid = 0 ,endtalkid = 1072 ,goods = [{0,10108,96300},{0,3101000,2}] };
get(10540) ->
   #task{taskid = 10540 ,name = ?T("骨爪森寒") ,chapter = 7 ,sort = 2 ,sort_lim = 13 ,type = 1 ,next = 10550 ,loop = 0 ,drop = [] ,accept = [{task,10530},{lv,1}] ,finish = [{kill,25002,30}] ,remote = 0 ,npcid = 15002 ,endnpcid = 15003 ,talkid = 0 ,endtalkid = 1073 ,goods = [{0,10108,100500},{0,6601003,1}] };
get(10550) ->
   #task{taskid = 10550 ,name = ?T("海底妖魔") ,chapter = 7 ,sort = 3 ,sort_lim = 13 ,type = 1 ,next = 10560 ,loop = 0 ,drop = [] ,accept = [{task,10540},{lv,1}] ,finish = [{kill,25003,1}] ,remote = 1 ,npcid = 15003 ,endnpcid = 15003 ,talkid = 0 ,endtalkid = 1074 ,goods = [{0,10108,100800},{0,10101,3000}] };
get(10560) ->
   #task{taskid = 10560 ,name = ?T("妖神残魂") ,chapter = 7 ,sort = 4 ,sort_lim = 13 ,type = 1 ,next = 10570 ,loop = 0 ,drop = [] ,accept = [{task,10550},{lv,1}] ,finish = [{npc,15004}] ,remote = 0 ,npcid = 15003 ,endnpcid = 15004 ,talkid = 0 ,endtalkid = 1075 ,goods = [{0,10108,101100},{0,3401000,2}] };
get(10570) ->
   #task{taskid = 10570 ,name = ?T("倾天铸恨") ,chapter = 7 ,sort = 5 ,sort_lim = 13 ,type = 1 ,next = 10580 ,loop = 0 ,drop = [] ,accept = [{task,10560},{lv,1}] ,finish = [{kill,25004,30}] ,remote = 0 ,npcid = 15004 ,endnpcid = 15019 ,talkid = 0 ,endtalkid = 1076 ,goods = [{0,10108,101600},{0,1009001,2}] };
get(10580) ->
   #task{taskid = 10580 ,name = ?T("长留旧怨") ,chapter = 7 ,sort = 6 ,sort_lim = 13 ,type = 1 ,next = 10581 ,loop = 0 ,drop = [] ,accept = [{task,10570},{lv,1}] ,finish = [{npc,15005}] ,remote = 0 ,npcid = 15019 ,endnpcid = 15005 ,talkid = 0 ,endtalkid = 1077 ,goods = [{0,10108,102000},{0,10101,3000}] };
get(10581) ->
   #task{taskid = 10581 ,name = ?T("打人撒气") ,chapter = 7 ,sort = 7 ,sort_lim = 13 ,type = 1 ,next = 10582 ,loop = 0 ,drop = [] ,accept = [{task,10580},{lv,1}] ,finish = [{kill,25007,30}] ,remote = 1 ,npcid = 15005 ,endnpcid = 15005 ,talkid = 0 ,endtalkid = 1078 ,goods = [{0,10108,102600},{0,10101,3500}] };
get(10582) ->
   #task{taskid = 10582 ,name = ?T("再会十三") ,chapter = 7 ,sort = 8 ,sort_lim = 13 ,type = 1 ,next = 10590 ,loop = 0 ,drop = [] ,accept = [{task,10581},{lv,1}] ,finish = [{kill,25006,1}] ,remote = 0 ,npcid = 15005 ,endnpcid = 15006 ,talkid = 0 ,endtalkid = 1079 ,goods = [{0,10108,103100},{0,3301000,1}] };
get(10590) ->
   #task{taskid = 10590 ,name = ?T("家庭恩怨") ,chapter = 7 ,sort = 9 ,sort_lim = 13 ,type = 1 ,next = 10600 ,loop = 0 ,drop = [] ,accept = [{task,10582},{lv,1}] ,finish = [{npc,15007}] ,remote = 0 ,npcid = 15006 ,endnpcid = 15007 ,talkid = 0 ,endtalkid = 1080 ,goods = [{0,10108,103900},{0,10101,3500}] };
get(10600) ->
   #task{taskid = 10600 ,name = ?T("灵石为价") ,chapter = 7 ,sort = 10 ,sort_lim = 13 ,type = 1 ,next = 10610 ,loop = 0 ,drop = [] ,accept = [{task,10590},{lv,1}] ,finish = [{collect,25030,1}] ,remote = 0 ,npcid = 15007 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 1081 ,goods = [{0,10108,104500},{0,10101,3500}] };
get(10610) ->
   #task{taskid = 10610 ,name = ?T("从中说合") ,chapter = 7 ,sort = 11 ,sort_lim = 13 ,type = 1 ,next = 10611 ,loop = 0 ,drop = [] ,accept = [{task,10600},{lv,40}] ,finish = [{npc,15011}] ,remote = 0 ,npcid = 15010 ,endnpcid = 15011 ,talkid = 0 ,endtalkid = 1082 ,goods = [{0,10108,111800},{0,3304000,1}] };
get(10611) ->
   #task{taskid = 10611 ,name = ?T("老爹一怒") ,chapter = 7 ,sort = 12 ,sort_lim = 13 ,type = 1 ,next = 10620 ,loop = 0 ,drop = [] ,accept = [{task,10610},{lv,1}] ,finish = [{npc,15012}] ,remote = 0 ,npcid = 15011 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 1083 ,goods = [{0,10108,116700},{0,10101,3500}] };
get(10620) ->
   #task{taskid = 10620 ,name = ?T("斩妖除魔") ,chapter = 7 ,sort = 13 ,sort_lim = 13 ,type = 1 ,next = 10630 ,loop = 0 ,drop = [] ,accept = [{task,10611},{lv,1}] ,finish = [{kill,25009,35}] ,remote = 1 ,npcid = 15012 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 1084 ,goods = [{0,10108,130900},{0,3401000,1}] };
get(10630) ->
   #task{taskid = 10630 ,name = ?T("妖魔精英") ,chapter = 8 ,sort = 1 ,sort_lim = 13 ,type = 1 ,next = 10640 ,loop = 0 ,drop = [] ,accept = [{task,10620},{lv,1}] ,finish = [{kill,25010,1}] ,remote = 1 ,npcid = 15012 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 1085 ,goods = [{0,10108,140400},{0,10101,3500}] };
get(10640) ->
   #task{taskid = 10640 ,name = ?T("除恶务尽") ,chapter = 8 ,sort = 2 ,sort_lim = 13 ,type = 1 ,next = 10641 ,loop = 0 ,drop = [] ,accept = [{task,10630},{lv,1}] ,finish = [{kill,25014,35}] ,remote = 0 ,npcid = 15012 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 1086 ,goods = [{0,10108,89100}] };
get(10641) ->
   #task{taskid = 10641 ,name = ?T("精进修为") ,chapter = 8 ,sort = 3 ,sort_lim = 13 ,type = 1 ,next = 10650 ,loop = 0 ,drop = [] ,accept = [{task,10640},{lv,1}] ,finish = [{uplv,49}] ,remote = 0 ,npcid = 15010 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,95625},{0,2003000,10}] };
get(10650) ->
   #task{taskid = 10650 ,name = ?T("花赠美人") ,chapter = 8 ,sort = 4 ,sort_lim = 13 ,type = 1 ,next = 10660 ,loop = 0 ,drop = [] ,accept = [{task,10641},{lv,1}] ,finish = [{collect,25031,1}] ,remote = 0 ,npcid = 15010 ,endnpcid = 15009 ,talkid = 0 ,endtalkid = 1087 ,goods = [{0,10108,95625}] };
get(10660) ->
   #task{taskid = 10660 ,name = ?T("邪道妖人") ,chapter = 8 ,sort = 5 ,sort_lim = 13 ,type = 1 ,next = 10661 ,loop = 0 ,drop = [] ,accept = [{task,10650},{lv,1}] ,finish = [{kill,25013,35}] ,remote = 0 ,npcid = 15009 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 1088 ,goods = [{0,10108,95625},{0,3301000,1}] };
get(10661) ->
   #task{taskid = 10661 ,name = ?T("为虎作伥") ,chapter = 8 ,sort = 6 ,sort_lim = 13 ,type = 1 ,next = 10662 ,loop = 0 ,drop = [] ,accept = [{task,10660},{lv,1}] ,finish = [{kill,25008,35}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 2002 ,goods = [{0,10108,95625},{0,10101,4000}] };
get(10662) ->
   #task{taskid = 10662 ,name = ?T("精进修为") ,chapter = 8 ,sort = 7 ,sort_lim = 13 ,type = 1 ,next = 10670 ,loop = 0 ,drop = [] ,accept = [{task,10661}] ,finish = [{uplv,50}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,87495},{0,1009001,2}] };
get(10670) ->
   #task{taskid = 10670 ,name = ?T("失而复得") ,chapter = 8 ,sort = 8 ,sort_lim = 13 ,type = 1 ,next = 10671 ,loop = 0 ,drop = [] ,accept = [{task,10662}] ,finish = [{collect,25032,1}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 1089 ,goods = [{0,10108,87495},{0,10101,4000}] };
get(10671) ->
   #task{taskid = 10671 ,name = ?T("千里送包") ,chapter = 8 ,sort = 9 ,sort_lim = 13 ,type = 1 ,next = 10672 ,loop = 0 ,drop = [] ,accept = [{task,10670}] ,finish = [{kill,25013,40}] ,remote = 1 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 2003 ,goods = [{0,10108,87495},{0,3401000,1}] };
get(10672) ->
   #task{taskid = 10672 ,name = ?T("人小鬼大") ,chapter = 8 ,sort = 10 ,sort_lim = 13 ,type = 1 ,next = 10673 ,loop = 0 ,drop = [] ,accept = [{task,10671}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 2004 ,goods = [{0,10108,87495},{0,10101,4000}] };
get(10673) ->
   #task{taskid = 10673 ,name = ?T("精进修为") ,chapter = 8 ,sort = 11 ,sort_lim = 13 ,type = 1 ,next = 10674 ,loop = 0 ,drop = [] ,accept = [{task,10672}] ,finish = [{uplv,51}] ,remote = 0 ,npcid = 15010 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,44840},{0,10101,4000}] };
get(10674) ->
   #task{taskid = 10674 ,name = ?T("采集灵石") ,chapter = 8 ,sort = 12 ,sort_lim = 13 ,type = 1 ,next = 10675 ,loop = 0 ,drop = [] ,accept = [{task,10673}] ,finish = [{collect,25030,3}] ,remote = 0 ,npcid = 15010 ,endnpcid = 15010 ,talkid = 0 ,endtalkid = 2005 ,goods = [{0,10108,44840},{0,3306000,1}] };
get(10675) ->
   #task{taskid = 10675 ,name = ?T("清除隐患") ,chapter = 8 ,sort = 13 ,sort_lim = 13 ,type = 1 ,next = 10680 ,loop = 0 ,drop = [] ,accept = [{task,10674}] ,finish = [{kill,25009,40}] ,remote = 1 ,npcid = 15010 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 2006 ,goods = [{0,10108,44840},{0,10101,4000}] };
get(10680) ->
   #task{taskid = 10680 ,name = ?T("森然骨爪") ,chapter = 9 ,sort = 1 ,sort_lim = 12 ,type = 1 ,next = 10681 ,loop = 0 ,drop = [] ,accept = [{task,10675}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 1090 ,goods = [{0,10108,44840},{0,1009001,2}] };
get(10681) ->
   #task{taskid = 10681 ,name = ?T("精进修为") ,chapter = 9 ,sort = 2 ,sort_lim = 12 ,type = 1 ,next = 10682 ,loop = 0 ,drop = [] ,accept = [{task,10680}] ,finish = [{uplv,52}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15016 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,36822},{0,3301000,1}] };
get(10682) ->
   #task{taskid = 10682 ,name = ?T("玄门正宗") ,chapter = 9 ,sort = 3 ,sort_lim = 12 ,type = 1 ,next = 10690 ,loop = 0 ,drop = [] ,accept = [{task,10681}] ,finish = [{kill,25013,30}] ,remote = 0 ,npcid = 15016 ,endnpcid = 15015 ,talkid = 0 ,endtalkid = 2007 ,goods = [{0,10108,36822},{0,10101,4000}] };
get(10690) ->
   #task{taskid = 10690 ,name = ?T("同门情谊") ,chapter = 9 ,sort = 4 ,sort_lim = 12 ,type = 1 ,next = 10691 ,loop = 0 ,drop = [] ,accept = [{task,10682}] ,finish = [{kill,25004,30}] ,remote = 0 ,npcid = 15015 ,endnpcid = 15006 ,talkid = 0 ,endtalkid = 2008 ,goods = [{0,10108,36822},{0,10101,4000}] };
get(10691) ->
   #task{taskid = 10691 ,name = ?T("胖大头陀") ,chapter = 9 ,sort = 5 ,sort_lim = 12 ,type = 1 ,next = 10692 ,loop = 0 ,drop = [] ,accept = [{task,10690}] ,finish = [{kill,25007,30}] ,remote = 0 ,npcid = 15006 ,endnpcid = 15006 ,talkid = 0 ,endtalkid = 1091 ,goods = [{0,10108,36822},{0,3401000,1}] };
get(10692) ->
   #task{taskid = 10692 ,name = ?T("精进修为") ,chapter = 9 ,sort = 6 ,sort_lim = 12 ,type = 1 ,next = 10700 ,loop = 0 ,drop = [] ,accept = [{task,10691}] ,finish = [{uplv,53}] ,remote = 0 ,npcid = 15006 ,endnpcid = 15006 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,47310},{0,10101,4000}] };
get(10700) ->
   #task{taskid = 10700 ,name = ?T("苦口婆心") ,chapter = 9 ,sort = 7 ,sort_lim = 12 ,type = 1 ,next = 10701 ,loop = 0 ,drop = [] ,accept = [{task,10692}] ,finish = [{npc,15013}] ,remote = 0 ,npcid = 15006 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 1092 ,goods = [{0,10108,47310},{0,3301000,1}] };
get(10701) ->
   #task{taskid = 10701 ,name = ?T("实力试炼") ,chapter = 9 ,sort = 8 ,sort_lim = 12 ,type = 1 ,next = 10702 ,loop = 0 ,drop = [] ,accept = [{task,10700}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 2009 ,goods = [{0,10108,47310},{0,10101,4000}] };
get(10702) ->
   #task{taskid = 10702 ,name = ?T("不服来战") ,chapter = 9 ,sort = 9 ,sort_lim = 12 ,type = 1 ,next = 10703 ,loop = 0 ,drop = [] ,accept = [{task,10701}] ,finish = [{kill,25009,40}] ,remote = 0 ,npcid = 15012 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 2010 ,goods = [{0,10108,47310},{0,10101,4000}] };
get(10703) ->
   #task{taskid = 10703 ,name = ?T("精进修为") ,chapter = 9 ,sort = 10 ,sort_lim = 12 ,type = 1 ,next = 10704 ,loop = 0 ,drop = [] ,accept = [{task,10702}] ,finish = [{uplv,54}] ,remote = 0 ,npcid = 15012 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,48688},{0,2003000,10}] };
get(10704) ->
   #task{taskid = 10704 ,name = ?T("三道考题") ,chapter = 9 ,sort = 11 ,sort_lim = 12 ,type = 1 ,next = 10705 ,loop = 0 ,drop = [] ,accept = [{task,10703}] ,finish = [{kill,25009,40}] ,remote = 1 ,npcid = 15012 ,endnpcid = 15012 ,talkid = 0 ,endtalkid = 2011 ,goods = [{0,10108,48688},{0,10101,4000}] };
get(10705) ->
   #task{taskid = 10705 ,name = ?T("再闯难关") ,chapter = 9 ,sort = 12 ,sort_lim = 12 ,type = 1 ,next = 10710 ,loop = 0 ,drop = [] ,accept = [{task,10704}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 15012 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 2012 ,goods = [{0,10108,48688},{0,3401000,1}] };
get(10710) ->
   #task{taskid = 10710 ,name = ?T("冰雪初融") ,chapter = 10 ,sort = 1 ,sort_lim = 12 ,type = 1 ,next = 10711 ,loop = 0 ,drop = [] ,accept = [{task,10705}] ,finish = [{kill,25010,1}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 2013 ,goods = [{0,10108,48688},{0,10101,4000}] };
get(10711) ->
   #task{taskid = 10711 ,name = ?T("精进修为") ,chapter = 10 ,sort = 2 ,sort_lim = 12 ,type = 1 ,next = 10712 ,loop = 0 ,drop = [] ,accept = [{task,10710}] ,finish = [{uplv,55}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,50160},{0,3406000,1}] };
get(10712) ->
   #task{taskid = 10712 ,name = ?T("七情仙子") ,chapter = 10 ,sort = 3 ,sort_lim = 12 ,type = 1 ,next = 10720 ,loop = 0 ,drop = [] ,accept = [{task,10711}] ,finish = [{kill,25011,1}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15014 ,talkid = 0 ,endtalkid = 1093 ,goods = [{0,10108,50160},{0,10101,4000}] };
get(10720) ->
   #task{taskid = 10720 ,name = ?T("忘情花") ,chapter = 10 ,sort = 4 ,sort_lim = 12 ,type = 1 ,next = 10721 ,loop = 0 ,drop = [] ,accept = [{task,10712}] ,finish = [{kill,25012,40}] ,remote = 0 ,npcid = 15014 ,endnpcid = 15018 ,talkid = 0 ,endtalkid = 1094 ,goods = [{0,10108,50160},{0,10101,4000}] };
get(10721) ->
   #task{taskid = 10721 ,name = ?T("助人平乱") ,chapter = 10 ,sort = 5 ,sort_lim = 12 ,type = 1 ,next = 10722 ,loop = 0 ,drop = [] ,accept = [{task,10720}] ,finish = [{kill,25015,40}] ,remote = 0 ,npcid = 15018 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 1095 ,goods = [{0,10108,50160},{0,3301000,1}] };
get(10722) ->
   #task{taskid = 10722 ,name = ?T("精进修为") ,chapter = 10 ,sort = 6 ,sort_lim = 12 ,type = 1 ,next = 10730 ,loop = 0 ,drop = [] ,accept = [{task,10721}] ,finish = [{uplv,56}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,51728},{0,3301000,1}] };
get(10730) ->
   #task{taskid = 10730 ,name = ?T("三桩事") ,chapter = 10 ,sort = 7 ,sort_lim = 12 ,type = 1 ,next = 10731 ,loop = 0 ,drop = [] ,accept = [{task,10722}] ,finish = [{kill,25013,30}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 2014 ,goods = [{0,10108,51728},{0,10101,4000}] };
get(10731) ->
   #task{taskid = 10731 ,name = ?T("迁怒水族") ,chapter = 10 ,sort = 8 ,sort_lim = 12 ,type = 1 ,next = 10732 ,loop = 0 ,drop = [] ,accept = [{task,10730}] ,finish = [{kill,25004,30}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 2015 ,goods = [{0,10108,51728},{0,10101,4000}] };
get(10732) ->
   #task{taskid = 10732 ,name = ?T("铲除精怪") ,chapter = 10 ,sort = 9 ,sort_lim = 12 ,type = 1 ,next = 10733 ,loop = 0 ,drop = [] ,accept = [{task,10731}] ,finish = [{kill,25012,30}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 2016 ,goods = [{0,10108,51728},{0,3304000,1}] };
get(10733) ->
   #task{taskid = 10733 ,name = ?T("精进修为") ,chapter = 10 ,sort = 10 ,sort_lim = 12 ,type = 1 ,next = 10734 ,loop = 0 ,drop = [] ,accept = [{task,10732}] ,finish = [{uplv,57}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,53390},{0,10101,4000}] };
get(10734) ->
   #task{taskid = 10734 ,name = ?T("旧恨难消") ,chapter = 10 ,sort = 11 ,sort_lim = 12 ,type = 1 ,next = 10735 ,loop = 0 ,drop = [] ,accept = [{task,10733}] ,finish = [{kill,25015,40}] ,remote = 0 ,npcid = 15017 ,endnpcid = 15018 ,talkid = 0 ,endtalkid = 2017 ,goods = [{0,10108,53390},{0,10101,4000}] };
get(10735) ->
   #task{taskid = 10735 ,name = ?T("父爱如山") ,chapter = 10 ,sort = 12 ,sort_lim = 12 ,type = 1 ,next = 10740 ,loop = 0 ,drop = [] ,accept = [{task,10734}] ,finish = [{kill,25012,40}] ,remote = 0 ,npcid = 15018 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 2018 ,goods = [{0,10108,53390},{0,3401000,1}] };
get(10740) ->
   #task{taskid = 10740 ,name = ?T("妖神魔女") ,chapter = 11 ,sort = 1 ,sort_lim = 18 ,type = 1 ,next = 10741 ,loop = 0 ,drop = [] ,accept = [{task,10735}] ,finish = [{kill,25011,1}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 2019 ,goods = [{0,10108,53390},{0,3305000,1}] };
get(10741) ->
   #task{taskid = 10741 ,name = ?T("精进修为") ,chapter = 11 ,sort = 2 ,sort_lim = 18 ,type = 1 ,next = 10742 ,loop = 0 ,drop = [] ,accept = [{task,10740}] ,finish = [{uplv,58}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15013 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,46440},{0,10101,4000}] };
get(10742) ->
   #task{taskid = 10742 ,name = ?T("罅隙暗藏") ,chapter = 11 ,sort = 3 ,sort_lim = 18 ,type = 1 ,next = 10750 ,loop = 0 ,drop = [] ,accept = [{task,10741}] ,finish = [{collect,25033,1}] ,remote = 0 ,npcid = 15013 ,endnpcid = 15017 ,talkid = 0 ,endtalkid = 1096 ,goods = [{0,10108,46440},{0,10101,4000}] };
get(10750) ->
   #task{taskid = 10750 ,name = ?T("返回长安") ,chapter = 11 ,sort = 4 ,sort_lim = 18 ,type = 1 ,next = 10751 ,loop = 0 ,drop = [] ,accept = [{task,10742}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 15017 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1097 ,goods = [{0,10108,46440},{0,3406000,1}] };
get(10751) ->
   #task{taskid = 10751 ,name = ?T("东海余波") ,chapter = 11 ,sort = 5 ,sort_lim = 18 ,type = 1 ,next = 10752 ,loop = 0 ,drop = [] ,accept = [{task,10750}] ,finish = [{kill,25013,50}] ,remote = 0 ,npcid = 12038 ,endnpcid = 15006 ,talkid = 0 ,endtalkid = 2020 ,goods = [{0,10108,46440},{0,10101,4000}] };
get(10752) ->
   #task{taskid = 10752 ,name = ?T("清扫战场") ,chapter = 11 ,sort = 6 ,sort_lim = 18 ,type = 1 ,next = 10753 ,loop = 0 ,drop = [] ,accept = [{task,10751}] ,finish = [{kill,25007,50}] ,remote = 0 ,npcid = 15006 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 2021 ,goods = [{0,10108,46440},{0,10101,4000}] };
get(10753) ->
   #task{taskid = 10753 ,name = ?T("精进修为") ,chapter = 11 ,sort = 7 ,sort_lim = 18 ,type = 1 ,next = 10754 ,loop = 0 ,drop = [] ,accept = [{task,10752}] ,finish = [{uplv,59}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(10754) ->
   #task{taskid = 10754 ,name = ?T("例行公事") ,chapter = 11 ,sort = 8 ,sort_lim = 18 ,type = 1 ,next = 10755 ,loop = 0 ,drop = [] ,accept = [{task,10753}] ,finish = [{kill,25013,80}] ,remote = 0 ,npcid = 12038 ,endnpcid = 15015 ,talkid = 0 ,endtalkid = 2022 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(10755) ->
   #task{taskid = 10755 ,name = ?T("补充灵石") ,chapter = 11 ,sort = 9 ,sort_lim = 18 ,type = 1 ,next = 10756 ,loop = 0 ,drop = [] ,accept = [{task,10754}] ,finish = [{collect,25030,3}] ,remote = 0 ,npcid = 15015 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 2023 ,goods = [{0,10108,48000},{0,3401000,1}] };
get(10756) ->
   #task{taskid = 10756 ,name = ?T("磨剑不辍") ,chapter = 11 ,sort = 10 ,sort_lim = 18 ,type = 1 ,next = 10760 ,loop = 0 ,drop = [] ,accept = [{task,10755}] ,finish = [{kill,25012,80}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 2024 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(10760) ->
   #task{taskid = 10760 ,name = ?T("昆仑迷踪") ,chapter = 11 ,sort = 11 ,sort_lim = 18 ,type = 1 ,next = 10770 ,loop = 0 ,drop = [] ,accept = [{task,10756}] ,finish = [{npc,12047}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12047 ,talkid = 0 ,endtalkid = 1098 ,goods = [{0,10108,48000},{0,10101,4000}] };
get(10770) ->
   #task{taskid = 10770 ,name = ?T("精进修为") ,chapter = 11 ,sort = 12 ,sort_lim = 18 ,type = 1 ,next = 10780 ,loop = 0 ,drop = [] ,accept = [{task,10760}] ,finish = [{uplv,60}] ,remote = 0 ,npcid = 12047 ,endnpcid = 12017 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,31025},{0,10101,5000}] };
get(10780) ->
   #task{taskid = 10780 ,name = ?T("天宫何在") ,chapter = 11 ,sort = 13 ,sort_lim = 18 ,type = 1 ,next = 10790 ,loop = 0 ,drop = [] ,accept = [{task,10770},{lv,60}] ,finish = [{collect,22001,1}] ,remote = 0 ,npcid = 12017 ,endnpcid = 12014 ,talkid = 0 ,endtalkid = 1099 ,goods = [{0,10108,31025},{0,10101,5000}] };
get(10790) ->
   #task{taskid = 10790 ,name = ?T("仙鸾梦羽") ,chapter = 11 ,sort = 14 ,sort_lim = 18 ,type = 1 ,next = 10800 ,loop = 0 ,drop = [] ,accept = [{task,10780}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12014 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1100 ,goods = [{0,10108,31025},{0,10101,5000}] };
get(10800) ->
   #task{taskid = 10800 ,name = ?T("异域之门") ,chapter = 11 ,sort = 15 ,sort_lim = 18 ,type = 1 ,next = 10810 ,loop = 0 ,drop = [] ,accept = [{task,10790}] ,finish = [{npc,12043}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12043 ,talkid = 0 ,endtalkid = 1101 ,goods = [{0,10108,31025},{0,10101,5000}] };
get(10810) ->
   #task{taskid = 10810 ,name = ?T("精进修为") ,chapter = 11 ,sort = 16 ,sort_lim = 18 ,type = 1 ,next = 10820 ,loop = 0 ,drop = [] ,accept = [{task,10800}] ,finish = [{uplv,61}] ,remote = 0 ,npcid = 12043 ,endnpcid = 12043 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,32100},{0,10101,5000}] };
get(10820) ->
   #task{taskid = 10820 ,name = ?T("鬼城魔域") ,chapter = 11 ,sort = 17 ,sort_lim = 18 ,type = 1 ,next = 10830 ,loop = 0 ,drop = [] ,accept = [{task,10810}] ,finish = [{kill,27001,100}] ,remote = 0 ,npcid = 12043 ,endnpcid = 16001 ,talkid = 0 ,endtalkid = 1102 ,goods = [{0,10108,32100},{0,10101,5000}] };
get(10830) ->
   #task{taskid = 10830 ,name = ?T("满目苍痍") ,chapter = 11 ,sort = 18 ,sort_lim = 18 ,type = 1 ,next = 10840 ,loop = 0 ,drop = [] ,accept = [{task,10820}] ,finish = [{kill,27002,100}] ,remote = 1 ,npcid = 16001 ,endnpcid = 16001 ,talkid = 0 ,endtalkid = 1103 ,goods = [{0,10108,32100},{0,10101,5000}] };
get(10840) ->
   #task{taskid = 10840 ,name = ?T("天宫魔物") ,chapter = 12 ,sort = 1 ,sort_lim = 15 ,type = 1 ,next = 10850 ,loop = 0 ,drop = [] ,accept = [{task,10830}] ,finish = [{kill,27008,1}] ,remote = 0 ,npcid = 16001 ,endnpcid = 16002 ,talkid = 0 ,endtalkid = 1104 ,goods = [{0,10108,32100},{0,10101,5000}] };
get(10850) ->
   #task{taskid = 10850 ,name = ?T("精进修为") ,chapter = 12 ,sort = 2 ,sort_lim = 15 ,type = 1 ,next = 10860 ,loop = 0 ,drop = [] ,accept = [{task,10840}] ,finish = [{uplv,62}] ,remote = 0 ,npcid = 16002 ,endnpcid = 16002 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,32100},{0,10101,5000}] };
get(10860) ->
   #task{taskid = 10860 ,name = ?T("追寻真相") ,chapter = 12 ,sort = 3 ,sort_lim = 15 ,type = 1 ,next = 10870 ,loop = 0 ,drop = [] ,accept = [{task,10850}] ,finish = [{npc,16001}] ,remote = 0 ,npcid = 16002 ,endnpcid = 16001 ,talkid = 0 ,endtalkid = 1105 ,goods = [{0,10108,33225},{0,10101,5000}] };
get(10870) ->
   #task{taskid = 10870 ,name = ?T("无人生还") ,chapter = 12 ,sort = 4 ,sort_lim = 15 ,type = 1 ,next = 10880 ,loop = 0 ,drop = [] ,accept = [{task,10860}] ,finish = [{kill,27003,100}] ,remote = 1 ,npcid = 16001 ,endnpcid = 16001 ,talkid = 0 ,endtalkid = 1106 ,goods = [{0,10108,33225},{0,10101,5000}] };
get(10880) ->
   #task{taskid = 10880 ,name = ?T("昆仑弟子") ,chapter = 12 ,sort = 5 ,sort_lim = 15 ,type = 1 ,next = 10890 ,loop = 0 ,drop = [] ,accept = [{task,10870}] ,finish = [{kill,27004,100}] ,remote = 0 ,npcid = 16001 ,endnpcid = 16005 ,talkid = 0 ,endtalkid = 1107 ,goods = [{0,10108,33225},{0,10101,5000}] };
get(10890) ->
   #task{taskid = 10890 ,name = ?T("精进修为") ,chapter = 12 ,sort = 6 ,sort_lim = 15 ,type = 1 ,next = 10900 ,loop = 0 ,drop = [] ,accept = [{task,10880}] ,finish = [{uplv,63}] ,remote = 0 ,npcid = 16005 ,endnpcid = 16005 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,33225},{0,10101,5000}] };
get(10900) ->
   #task{taskid = 10900 ,name = ?T("诛仙剑阵") ,chapter = 12 ,sort = 7 ,sort_lim = 15 ,type = 1 ,next = 10910 ,loop = 0 ,drop = [] ,accept = [{task,10890}] ,finish = [{collect,27103,1}] ,remote = 0 ,npcid = 16005 ,endnpcid = 16006 ,talkid = 0 ,endtalkid = 1108 ,goods = [{0,10108,34400},{0,20340,3},{0,1010005,20}] };
get(10910) ->
   #task{taskid = 10910 ,name = ?T("祸起萧墙") ,chapter = 12 ,sort = 8 ,sort_lim = 15 ,type = 1 ,next = 10920 ,loop = 0 ,drop = [] ,accept = [{task,10900}] ,finish = [{npc,16004}] ,remote = 0 ,npcid = 16006 ,endnpcid = 16004 ,talkid = 0 ,endtalkid = 1109 ,goods = [{0,10108,34400},{0,10101,5000}] };
get(10920) ->
   #task{taskid = 10920 ,name = ?T("除其精锐") ,chapter = 12 ,sort = 9 ,sort_lim = 15 ,type = 1 ,next = 10930 ,loop = 0 ,drop = [] ,accept = [{task,10910}] ,finish = [{kill,27010,1}] ,remote = 0 ,npcid = 16004 ,endnpcid = 16010 ,talkid = 0 ,endtalkid = 1110 ,goods = [{0,10108,34400},{0,10101,5000}] };
get(10930) ->
   #task{taskid = 10930 ,name = ?T("精进修为") ,chapter = 12 ,sort = 10 ,sort_lim = 15 ,type = 1 ,next = 10940 ,loop = 0 ,drop = [] ,accept = [{task,10920}] ,finish = [{uplv,64}] ,remote = 0 ,npcid = 16010 ,endnpcid = 16010 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,34400},{0,10101,5000}] };
get(10940) ->
   #task{taskid = 10940 ,name = ?T("寻求建议") ,chapter = 12 ,sort = 11 ,sort_lim = 15 ,type = 1 ,next = 10950 ,loop = 0 ,drop = [] ,accept = [{task,10930}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 16010 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1111 ,goods = [{0,10108,34400},{0,10101,5000}] };
get(10950) ->
   #task{taskid = 10950 ,name = ?T("满目苍痍") ,chapter = 12 ,sort = 12 ,sort_lim = 15 ,type = 1 ,next = 10960 ,loop = 0 ,drop = [] ,accept = [{task,10940}] ,finish = [{kill,27005,110}] ,remote = 0 ,npcid = 12038 ,endnpcid = 16003 ,talkid = 0 ,endtalkid = 1112 ,goods = [{0,10108,35625},{0,10101,5000}] };
get(10960) ->
   #task{taskid = 10960 ,name = ?T("破阵之法") ,chapter = 12 ,sort = 13 ,sort_lim = 15 ,type = 1 ,next = 10970 ,loop = 0 ,drop = [] ,accept = [{task,10950}] ,finish = [{collect,27104,1}] ,remote = 0 ,npcid = 16003 ,endnpcid = 16003 ,talkid = 0 ,endtalkid = 1113 ,goods = [{0,10108,35625},{0,10101,5000}] };
get(10970) ->
   #task{taskid = 10970 ,name = ?T("精进修为") ,chapter = 12 ,sort = 14 ,sort_lim = 15 ,type = 1 ,next = 10971 ,loop = 0 ,drop = [] ,accept = [{task,10960}] ,finish = [{uplv,65}] ,remote = 0 ,npcid = 16003 ,endnpcid = 16003 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,35625},{0,10101,5000}] };
get(10971) ->
   #task{taskid = 10971 ,name = ?T("昔日秘闻") ,chapter = 12 ,sort = 15 ,sort_lim = 15 ,type = 1 ,next = 10980 ,loop = 0 ,drop = [] ,accept = [{task,10970}] ,finish = [{kill,27006,110}] ,remote = 0 ,npcid = 16003 ,endnpcid = 16007 ,talkid = 0 ,endtalkid = 1114 ,goods = [{0,10108,35625},{0,10101,7500}] };
get(10980) ->
   #task{taskid = 10980 ,name = ?T("掌门何在") ,chapter = 13 ,sort = 1 ,sort_lim = 17 ,type = 1 ,next = 10990 ,loop = 0 ,drop = [] ,accept = [{task,10971}] ,finish = [{npc,16007}] ,remote = 0 ,npcid = 16007 ,endnpcid = 16007 ,talkid = 0 ,endtalkid = 1115 ,goods = [{0,10108,36900},{0,10101,7500}] };
get(10990) ->
   #task{taskid = 10990 ,name = ?T("精进修为") ,chapter = 13 ,sort = 2 ,sort_lim = 17 ,type = 1 ,next = 11000 ,loop = 0 ,drop = [] ,accept = [{task,10980}] ,finish = [{uplv,66}] ,remote = 0 ,npcid = 16007 ,endnpcid = 16007 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,63708},{0,10101,7500}] };
get(11000) ->
   #task{taskid = 11000 ,name = ?T("天宫魔物") ,chapter = 13 ,sort = 3 ,sort_lim = 17 ,type = 1 ,next = 11010 ,loop = 0 ,drop = [] ,accept = [{task,10990}] ,finish = [{kill,27007,110}] ,remote = 1 ,npcid = 16007 ,endnpcid = 16007 ,talkid = 0 ,endtalkid = 1116 ,goods = [{0,10108,63708},{0,10101,7500}] };
get(11010) ->
   #task{taskid = 11010 ,name = ?T("剑阵消散") ,chapter = 13 ,sort = 4 ,sort_lim = 17 ,type = 1 ,next = 11020 ,loop = 0 ,drop = [] ,accept = [{task,11000}] ,finish = [{collect,27101,1}] ,remote = 0 ,npcid = 16007 ,endnpcid = 16008 ,talkid = 0 ,endtalkid = 1117 ,goods = [{0,10108,63708},{0,10101,7500}] };
get(11020) ->
   #task{taskid = 11020 ,name = ?T("精进修为") ,chapter = 13 ,sort = 5 ,sort_lim = 17 ,type = 1 ,next = 11030 ,loop = 0 ,drop = [] ,accept = [{task,11010}] ,finish = [{uplv,67}] ,remote = 0 ,npcid = 16008 ,endnpcid = 16008 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,39600},{0,10101,7500}] };
get(11030) ->
   #task{taskid = 11030 ,name = ?T("回报长老") ,chapter = 13 ,sort = 6 ,sort_lim = 17 ,type = 1 ,next = 11040 ,loop = 0 ,drop = [] ,accept = [{task,11020}] ,finish = [{npc,16004}] ,remote = 0 ,npcid = 16008 ,endnpcid = 16004 ,talkid = 0 ,endtalkid = 1118 ,goods = [{0,10108,39600},{0,10101,7500}] };
get(11040) ->
   #task{taskid = 11040 ,name = ?T("混沌之灵") ,chapter = 13 ,sort = 7 ,sort_lim = 17 ,type = 1 ,next = 11050 ,loop = 0 ,drop = [] ,accept = [{task,11030}] ,finish = [{kill,27010,1}] ,remote = 1 ,npcid = 16004 ,endnpcid = 16004 ,talkid = 0 ,endtalkid = 1119 ,goods = [{0,10108,39600},{0,10101,7500}] };
get(11050) ->
   #task{taskid = 11050 ,name = ?T("除恶务尽") ,chapter = 13 ,sort = 8 ,sort_lim = 17 ,type = 1 ,next = 11060 ,loop = 0 ,drop = [] ,accept = [{task,11040}] ,finish = [{kill,27009,1}] ,remote = 0 ,npcid = 16004 ,endnpcid = 16010 ,talkid = 0 ,endtalkid = 1120 ,goods = [{0,10108,39600},{0,10101,7500}] };
get(11060) ->
   #task{taskid = 11060 ,name = ?T("精进修为") ,chapter = 13 ,sort = 9 ,sort_lim = 17 ,type = 1 ,next = 11070 ,loop = 0 ,drop = [] ,accept = [{task,11050}] ,finish = [{uplv,68}] ,remote = 0 ,npcid = 16010 ,endnpcid = 16010 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,41025},{0,10101,7500}] };
get(11070) ->
   #task{taskid = 11070 ,name = ?T("折剑破阵") ,chapter = 13 ,sort = 10 ,sort_lim = 17 ,type = 1 ,next = 11080 ,loop = 0 ,drop = [] ,accept = [{task,11060}] ,finish = [{collect,27102,1}] ,remote = 1 ,npcid = 16010 ,endnpcid = 16010 ,talkid = 0 ,endtalkid = 1121 ,goods = [{0,10108,41025},{0,10101,7500}] };
get(11080) ->
   #task{taskid = 11080 ,name = ?T("昆仑掌门") ,chapter = 13 ,sort = 11 ,sort_lim = 17 ,type = 1 ,next = 11090 ,loop = 0 ,drop = [] ,accept = [{task,11070}] ,finish = [{npc,16009}] ,remote = 0 ,npcid = 16010 ,endnpcid = 16009 ,talkid = 0 ,endtalkid = 1122 ,goods = [{0,10108,41025},{0,10101,7500}] };
get(11090) ->
   #task{taskid = 11090 ,name = ?T("复姓东方") ,chapter = 13 ,sort = 12 ,sort_lim = 17 ,type = 1 ,next = 11100 ,loop = 0 ,drop = [] ,accept = [{task,11080}] ,finish = [{npc,12014}] ,remote = 0 ,npcid = 16009 ,endnpcid = 12014 ,talkid = 0 ,endtalkid = 1123 ,goods = [{0,10108,41025},{0,10101,7500}] };
get(11100) ->
   #task{taskid = 11100 ,name = ?T("精进修为") ,chapter = 13 ,sort = 13 ,sort_lim = 17 ,type = 1 ,next = 11110 ,loop = 0 ,drop = [] ,accept = [{task,11090}] ,finish = [{uplv,69}] ,remote = 0 ,npcid = 12014 ,endnpcid = 12014 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11110) ->
   #task{taskid = 11110 ,name = ?T("讲述真相") ,chapter = 13 ,sort = 14 ,sort_lim = 17 ,type = 1 ,next = 11120 ,loop = 0 ,drop = [] ,accept = [{task,11100}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12014 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1124 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11120) ->
   #task{taskid = 11120 ,name = ?T("回报昆仑") ,chapter = 13 ,sort = 15 ,sort_lim = 17 ,type = 1 ,next = 11130 ,loop = 0 ,drop = [] ,accept = [{task,11110}] ,finish = [{npc,16004}] ,remote = 0 ,npcid = 12038 ,endnpcid = 16004 ,talkid = 0 ,endtalkid = 1125 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11130) ->
   #task{taskid = 11130 ,name = ?T("逝水无痕") ,chapter = 13 ,sort = 16 ,sort_lim = 17 ,type = 1 ,next = 11140 ,loop = 0 ,drop = [] ,accept = [{task,11120}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 16004 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1126 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11140) ->
   #task{taskid = 11140 ,name = ?T("龙脉异动") ,chapter = 13 ,sort = 17 ,sort_lim = 17 ,type = 1 ,next = 11150 ,loop = 0 ,drop = [] ,accept = [{task,11130}] ,finish = [{npc,12042}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 1127 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11150) ->
   #task{taskid = 11150 ,name = ?T("镇压叛军") ,chapter = 14 ,sort = 1 ,sort_lim = 20 ,type = 1 ,next = 11160 ,loop = 0 ,drop = [] ,accept = [{task,11140}] ,finish = [{npc,17001}] ,remote = 0 ,npcid = 12042 ,endnpcid = 17001 ,talkid = 0 ,endtalkid = 1128 ,goods = [{0,10108,28333},{0,10101,7500}] };
get(11160) ->
   #task{taskid = 11160 ,name = ?T("精进修为") ,chapter = 14 ,sort = 2 ,sort_lim = 20 ,type = 1 ,next = 11170 ,loop = 0 ,drop = [] ,accept = [{task,11150}] ,finish = [{uplv,70}] ,remote = 0 ,npcid = 17001 ,endnpcid = 17001 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,29350},{0,10101,7500}] };
get(11170) ->
   #task{taskid = 11170 ,name = ?T("其疾如风") ,chapter = 14 ,sort = 3 ,sort_lim = 20 ,type = 1 ,next = 11180 ,loop = 0 ,drop = [] ,accept = [{task,11160}] ,finish = [{kill,26018,1}] ,remote = 1 ,npcid = 17001 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 1129 ,goods = [{0,10108,29350},{0,10101,7500}] };
get(11180) ->
   #task{taskid = 11180 ,name = ?T("侵略如火") ,chapter = 14 ,sort = 4 ,sort_lim = 20 ,type = 1 ,next = 11190 ,loop = 0 ,drop = [] ,accept = [{task,11170}] ,finish = [{kill,26001,120}] ,remote = 0 ,npcid = 17002 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 1130 ,goods = [{0,10108,29350},{0,10101,7500}] };
get(11190) ->
   #task{taskid = 11190 ,name = ?T("轻取敌酋") ,chapter = 14 ,sort = 5 ,sort_lim = 20 ,type = 1 ,next = 11200 ,loop = 0 ,drop = [] ,accept = [{task,11180}] ,finish = [{kill,26019,1}] ,remote = 0 ,npcid = 17002 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 1131 ,goods = [{0,10108,29350},{0,10101,7500}] };
get(11200) ->
   #task{taskid = 11200 ,name = ?T("精进修为") ,chapter = 14 ,sort = 6 ,sort_lim = 20 ,type = 1 ,next = 11210 ,loop = 0 ,drop = [] ,accept = [{task,11190}] ,finish = [{uplv,71}] ,remote = 0 ,npcid = 17002 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,30400},{0,10101,7500}] };
get(11210) ->
   #task{taskid = 11210 ,name = ?T("无双快斩") ,chapter = 14 ,sort = 7 ,sort_lim = 20 ,type = 1 ,next = 11220 ,loop = 0 ,drop = [] ,accept = [{task,11200}] ,finish = [{kill,26002,120}] ,remote = 0 ,npcid = 17002 ,endnpcid = 17003 ,talkid = 0 ,endtalkid = 1132 ,goods = [{0,10108,30400},{0,10101,7500}] };
get(11220) ->
   #task{taskid = 11220 ,name = ?T("刀刀到肉") ,chapter = 14 ,sort = 8 ,sort_lim = 20 ,type = 1 ,next = 11230 ,loop = 0 ,drop = [] ,accept = [{task,11210}] ,finish = [{kill,26003,120}] ,remote = 0 ,npcid = 17003 ,endnpcid = 17003 ,talkid = 0 ,endtalkid = 1133 ,goods = [{0,10108,30400},{0,10101,10000}] };
get(11230) ->
   #task{taskid = 11230 ,name = ?T("占山为王") ,chapter = 14 ,sort = 9 ,sort_lim = 20 ,type = 1 ,next = 11240 ,loop = 0 ,drop = [] ,accept = [{task,11220}] ,finish = [{kill,26020,1}] ,remote = 0 ,npcid = 17003 ,endnpcid = 17004 ,talkid = 0 ,endtalkid = 1134 ,goods = [{0,10108,30400},{0,10101,10000}] };
get(11240) ->
   #task{taskid = 11240 ,name = ?T("精进修为") ,chapter = 14 ,sort = 10 ,sort_lim = 20 ,type = 1 ,next = 11250 ,loop = 0 ,drop = [] ,accept = [{task,11230}] ,finish = [{uplv,72}] ,remote = 0 ,npcid = 17004 ,endnpcid = 17004 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,31483},{0,10101,10000}] };
get(11250) ->
   #task{taskid = 11250 ,name = ?T("乱军贼寇") ,chapter = 14 ,sort = 11 ,sort_lim = 20 ,type = 1 ,next = 11260 ,loop = 0 ,drop = [] ,accept = [{task,11240}] ,finish = [{kill,26003,120}] ,remote = 1 ,npcid = 17004 ,endnpcid = 17004 ,talkid = 0 ,endtalkid = 1135 ,goods = [{0,10108,31483},{0,10101,10000}] };
get(11260) ->
   #task{taskid = 11260 ,name = ?T("海盗肆虐") ,chapter = 14 ,sort = 12 ,sort_lim = 20 ,type = 1 ,next = 11270 ,loop = 0 ,drop = [] ,accept = [{task,11250}] ,finish = [{kill,26004,130}] ,remote = 0 ,npcid = 17004 ,endnpcid = 17005 ,talkid = 0 ,endtalkid = 1136 ,goods = [{0,10108,31483},{0,10101,10000}] };
get(11270) ->
   #task{taskid = 11270 ,name = ?T("船上藏宝") ,chapter = 14 ,sort = 13 ,sort_lim = 20 ,type = 1 ,next = 11280 ,loop = 0 ,drop = [] ,accept = [{task,11260}] ,finish = [{collect,26031,1}] ,remote = 0 ,npcid = 17005 ,endnpcid = 17016 ,talkid = 0 ,endtalkid = 1137 ,goods = [{0,10108,31483},{0,10101,10000}] };
get(11280) ->
   #task{taskid = 11280 ,name = ?T("精进修为") ,chapter = 14 ,sort = 14 ,sort_lim = 20 ,type = 1 ,next = 11290 ,loop = 0 ,drop = [] ,accept = [{task,11270}] ,finish = [{uplv,73}] ,remote = 0 ,npcid = 17016 ,endnpcid = 17016 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,32600},{0,10101,10000}] };
get(11290) ->
   #task{taskid = 11290 ,name = ?T("青锋龙泉") ,chapter = 14 ,sort = 15 ,sort_lim = 20 ,type = 1 ,next = 11300 ,loop = 0 ,drop = [] ,accept = [{task,11280}] ,finish = [{collect,26027,1}] ,remote = 1 ,npcid = 17016 ,endnpcid = 17001 ,talkid = 0 ,endtalkid = 1138 ,goods = [{0,10108,32600},{0,10101,10000}] };
get(11300) ->
   #task{taskid = 11300 ,name = ?T("初试剑锋") ,chapter = 14 ,sort = 16 ,sort_lim = 20 ,type = 1 ,next = 11310 ,loop = 0 ,drop = [] ,accept = [{task,11290}] ,finish = [{kill,26021,1}] ,remote = 1 ,npcid = 17001 ,endnpcid = 17016 ,talkid = 0 ,endtalkid = 1139 ,goods = [{0,10108,32600},{0,10101,10000}] };
get(11310) ->
   #task{taskid = 11310 ,name = ?T("满目苍痍") ,chapter = 14 ,sort = 17 ,sort_lim = 20 ,type = 1 ,next = 11320 ,loop = 0 ,drop = [] ,accept = [{task,11300}] ,finish = [{kill,26005,130}] ,remote = 0 ,npcid = 17016 ,endnpcid = 17006 ,talkid = 0 ,endtalkid = 1140 ,goods = [{0,10108,32600},{0,10101,10000}] };
get(11320) ->
   #task{taskid = 11320 ,name = ?T("精进修为") ,chapter = 14 ,sort = 18 ,sort_lim = 20 ,type = 1 ,next = 11330 ,loop = 0 ,drop = [] ,accept = [{task,11310}] ,finish = [{uplv,74}] ,remote = 0 ,npcid = 17006 ,endnpcid = 17006 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,33750},{0,10101,10000}] };
get(11330) ->
   #task{taskid = 11330 ,name = ?T("安抚小童") ,chapter = 14 ,sort = 19 ,sort_lim = 20 ,type = 1 ,next = 11340 ,loop = 0 ,drop = [] ,accept = [{task,11320}] ,finish = [{npc,17007}] ,remote = 0 ,npcid = 17006 ,endnpcid = 17007 ,talkid = 0 ,endtalkid = 1141 ,goods = [{0,10108,33750},{0,10101,10000}] };
get(11340) ->
   #task{taskid = 11340 ,name = ?T("不堪骚扰") ,chapter = 14 ,sort = 20 ,sort_lim = 20 ,type = 1 ,next = 11350 ,loop = 0 ,drop = [] ,accept = [{task,11330}] ,finish = [{npc,17004}] ,remote = 0 ,npcid = 17007 ,endnpcid = 17004 ,talkid = 0 ,endtalkid = 1142 ,goods = [{0,10108,33750},{0,10101,10000}] };
get(11350) ->
   #task{taskid = 11350 ,name = ?T("分发武器") ,chapter = 15 ,sort = 1 ,sort_lim = 17 ,type = 1 ,next = 11360 ,loop = 0 ,drop = [] ,accept = [{task,11340}] ,finish = [{collect,26028,1}] ,remote = 0 ,npcid = 17004 ,endnpcid = 17006 ,talkid = 0 ,endtalkid = 1143 ,goods = [{0,10108,33750},{0,10101,10000}] };
get(11360) ->
   #task{taskid = 11360 ,name = ?T("精进修为") ,chapter = 15 ,sort = 2 ,sort_lim = 17 ,type = 1 ,next = 11370 ,loop = 0 ,drop = [] ,accept = [{task,11350}] ,finish = [{uplv,75}] ,remote = 0 ,npcid = 17006 ,endnpcid = 17006 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,34933},{0,10101,10000}] };
get(11370) ->
   #task{taskid = 11370 ,name = ?T("冲散军势") ,chapter = 15 ,sort = 3 ,sort_lim = 17 ,type = 1 ,next = 11380 ,loop = 0 ,drop = [] ,accept = [{task,11360}] ,finish = [{kill,26006,130}] ,remote = 1 ,npcid = 17006 ,endnpcid = 17006 ,talkid = 0 ,endtalkid = 1144 ,goods = [{0,10108,34933},{0,10101,10000}] };
get(11380) ->
   #task{taskid = 11380 ,name = ?T("除恶务尽") ,chapter = 15 ,sort = 4 ,sort_lim = 17 ,type = 1 ,next = 11390 ,loop = 0 ,drop = [] ,accept = [{task,11370}] ,finish = [{kill,26007,140}] ,remote = 0 ,npcid = 17006 ,endnpcid = 17007 ,talkid = 0 ,endtalkid = 1145 ,goods = [{0,10108,34933},{0,10101,10000}] };
get(11390) ->
   #task{taskid = 11390 ,name = ?T("皇位之争") ,chapter = 15 ,sort = 5 ,sort_lim = 17 ,type = 1 ,next = 11400 ,loop = 0 ,drop = [] ,accept = [{task,11380}] ,finish = [{kill,26022,1}] ,remote = 0 ,npcid = 17007 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 1146 ,goods = [{0,10108,34933},{0,10101,10000}] };
get(11400) ->
   #task{taskid = 11400 ,name = ?T("精进修为") ,chapter = 15 ,sort = 6 ,sort_lim = 17 ,type = 1 ,next = 11410 ,loop = 0 ,drop = [] ,accept = [{task,11390}] ,finish = [{uplv,76}] ,remote = 0 ,npcid = 17008 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,36150},{0,10101,10000}] };
get(11410) ->
   #task{taskid = 11410 ,name = ?T("镇国之剑") ,chapter = 15 ,sort = 7 ,sort_lim = 17 ,type = 1 ,next = 11420 ,loop = 0 ,drop = [] ,accept = [{task,11400}] ,finish = [{collect,26029,1}] ,remote = 1 ,npcid = 17008 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 1147 ,goods = [{0,10108,36150},{0,10101,10000}] };
get(11420) ->
   #task{taskid = 11420 ,name = ?T("剪除羽翼") ,chapter = 15 ,sort = 8 ,sort_lim = 17 ,type = 1 ,next = 11430 ,loop = 0 ,drop = [] ,accept = [{task,11410}] ,finish = [{kill,26007,140}] ,remote = 1 ,npcid = 17008 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 1148 ,goods = [{0,10108,36150},{0,10101,10000}] };
get(11430) ->
   #task{taskid = 11430 ,name = ?T("拔去爪牙") ,chapter = 15 ,sort = 9 ,sort_lim = 17 ,type = 1 ,next = 11440 ,loop = 0 ,drop = [] ,accept = [{task,11420}] ,finish = [{kill,26023,1}] ,remote = 0 ,npcid = 17008 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 1149 ,goods = [{0,10108,36150},{0,10101,10000}] };
get(11440) ->
   #task{taskid = 11440 ,name = ?T("精进修为") ,chapter = 15 ,sort = 10 ,sort_lim = 17 ,type = 1 ,next = 11450 ,loop = 0 ,drop = [] ,accept = [{task,11430}] ,finish = [{uplv,77}] ,remote = 0 ,npcid = 17008 ,endnpcid = 17008 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,37400},{0,10101,10000}] };
get(11450) ->
   #task{taskid = 11450 ,name = ?T("双生皇子") ,chapter = 15 ,sort = 11 ,sort_lim = 17 ,type = 1 ,next = 11460 ,loop = 0 ,drop = [] ,accept = [{task,11440}] ,finish = [{kill,26008,140}] ,remote = 0 ,npcid = 17008 ,endnpcid = 17009 ,talkid = 0 ,endtalkid = 1150 ,goods = [{0,10108,37400},{0,10101,10000}] };
get(11460) ->
   #task{taskid = 11460 ,name = ?T("击败守军") ,chapter = 15 ,sort = 12 ,sort_lim = 17 ,type = 1 ,next = 11470 ,loop = 0 ,drop = [] ,accept = [{task,11450}] ,finish = [{kill,26008,140}] ,remote = 1 ,npcid = 17009 ,endnpcid = 17009 ,talkid = 0 ,endtalkid = 1151 ,goods = [{0,10108,37400},{0,10101,10000}] };
get(11470) ->
   #task{taskid = 11470 ,name = ?T("旧人难忘") ,chapter = 15 ,sort = 13 ,sort_lim = 17 ,type = 1 ,next = 11480 ,loop = 0 ,drop = [] ,accept = [{task,11460}] ,finish = [{kill,26009,140}] ,remote = 0 ,npcid = 17009 ,endnpcid = 17010 ,talkid = 0 ,endtalkid = 1152 ,goods = [{0,10108,37400},{0,10101,10000}] };
get(11480) ->
   #task{taskid = 11480 ,name = ?T("棠棣之华") ,chapter = 15 ,sort = 14 ,sort_lim = 17 ,type = 1 ,next = 11490 ,loop = 0 ,drop = [] ,accept = [{task,11470}] ,finish = [{npc,17011}] ,remote = 0 ,npcid = 17010 ,endnpcid = 17011 ,talkid = 0 ,endtalkid = 1153 ,goods = [{0,10108,37400},{0,10101,10000}] };
get(11490) ->
   #task{taskid = 11490 ,name = ?T("精进修为") ,chapter = 15 ,sort = 15 ,sort_lim = 17 ,type = 1 ,next = 11500 ,loop = 0 ,drop = [] ,accept = [{task,11480}] ,finish = [{uplv,78}] ,remote = 0 ,npcid = 17011 ,endnpcid = 17011 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,58025},{0,10101,15000}] };
get(11500) ->
   #task{taskid = 11500 ,name = ?T("巧言解忧") ,chapter = 15 ,sort = 16 ,sort_lim = 17 ,type = 1 ,next = 11510 ,loop = 0 ,drop = [] ,accept = [{task,11490}] ,finish = [{npc,17012}] ,remote = 0 ,npcid = 17011 ,endnpcid = 17012 ,talkid = 0 ,endtalkid = 1154 ,goods = [{0,10108,58025},{0,10101,15000}] };
get(11510) ->
   #task{taskid = 11510 ,name = ?T("妖魔联军") ,chapter = 15 ,sort = 17 ,sort_lim = 17 ,type = 1 ,next = 11520 ,loop = 0 ,drop = [] ,accept = [{task,11500}] ,finish = [{kill,26024,1}] ,remote = 1 ,npcid = 17012 ,endnpcid = 17012 ,talkid = 0 ,endtalkid = 1155 ,goods = [{0,10108,58025},{0,10101,15000}] };
get(11520) ->
   #task{taskid = 11520 ,name = ?T("噬人猛虎") ,chapter = 16 ,sort = 18 ,sort_lim = 18 ,type = 1 ,next = 11530 ,loop = 0 ,drop = [] ,accept = [{task,11510}] ,finish = [{kill,26010,150}] ,remote = 0 ,npcid = 17012 ,endnpcid = 17013 ,talkid = 0 ,endtalkid = 1156 ,goods = [{0,10108,58025},{0,10101,15000}] };
get(11530) ->
   #task{taskid = 11530 ,name = ?T("精进修为") ,chapter = 16 ,sort = 1 ,sort_lim = 18 ,type = 1 ,next = 11540 ,loop = 0 ,drop = [] ,accept = [{task,11520}] ,finish = [{uplv,79}] ,remote = 0 ,npcid = 17013 ,endnpcid = 17013 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,60000},{0,10101,15000}] };
get(11540) ->
   #task{taskid = 11540 ,name = ?T("佛寺鬼钟") ,chapter = 16 ,sort = 2 ,sort_lim = 18 ,type = 1 ,next = 11550 ,loop = 0 ,drop = [] ,accept = [{task,11530}] ,finish = [{kill,26025,1}] ,remote = 0 ,npcid = 17013 ,endnpcid = 17014 ,talkid = 0 ,endtalkid = 1157 ,goods = [{0,10108,60000},{0,10101,15000}] };
get(11550) ->
   #task{taskid = 11550 ,name = ?T("悲酥清风") ,chapter = 16 ,sort = 3 ,sort_lim = 18 ,type = 1 ,next = 11560 ,loop = 0 ,drop = [] ,accept = [{task,11540}] ,finish = [{collect,26030,1}] ,remote = 0 ,npcid = 17014 ,endnpcid = 17014 ,talkid = 0 ,endtalkid = 1158 ,goods = [{0,10108,60000},{0,10101,15000}] };
get(11560) ->
   #task{taskid = 11560 ,name = ?T("传告玄麟") ,chapter = 16 ,sort = 4 ,sort_lim = 18 ,type = 1 ,next = 11570 ,loop = 0 ,drop = [] ,accept = [{task,11550}] ,finish = [{kill,26013,150}] ,remote = 0 ,npcid = 17014 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 1159 ,goods = [{0,10108,60000},{0,10101,15000}] };
get(11570) ->
   #task{taskid = 11570 ,name = ?T("精进修为") ,chapter = 16 ,sort = 5 ,sort_lim = 18 ,type = 1 ,next = 11580 ,loop = 0 ,drop = [] ,accept = [{task,11560}] ,finish = [{uplv,80}] ,remote = 0 ,npcid = 17002 ,endnpcid = 17002 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,124050},{0,10101,15000}] };
get(11580) ->
   #task{taskid = 11580 ,name = ?T("诸般齐备") ,chapter = 16 ,sort = 6 ,sort_lim = 18 ,type = 1 ,next = 11590 ,loop = 0 ,drop = [] ,accept = [{task,11570}] ,finish = [{npc,12016}] ,remote = 0 ,npcid = 17002 ,endnpcid = 12016 ,talkid = 0 ,endtalkid = 1160 ,goods = [{0,10108,124050},{0,10101,15000}] };
get(11590) ->
   #task{taskid = 11590 ,name = ?T("只欠东风") ,chapter = 16 ,sort = 7 ,sort_lim = 18 ,type = 1 ,next = 11600 ,loop = 0 ,drop = [] ,accept = [{task,11580}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12016 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1161 ,goods = [{0,10108,124050},{0,10101,15000}] };
get(11600) ->
   #task{taskid = 11600 ,name = ?T("回报药师") ,chapter = 16 ,sort = 8 ,sort_lim = 18 ,type = 1 ,next = 11610 ,loop = 0 ,drop = [] ,accept = [{task,11590}] ,finish = [{npc,17014}] ,remote = 0 ,npcid = 12038 ,endnpcid = 17014 ,talkid = 0 ,endtalkid = 1162 ,goods = [{0,10108,124050},{0,10101,15000}] };
get(11610) ->
   #task{taskid = 11610 ,name = ?T("精进修为") ,chapter = 16 ,sort = 9 ,sort_lim = 18 ,type = 1 ,next = 11620 ,loop = 0 ,drop = [] ,accept = [{task,11600}] ,finish = [{uplv,81}] ,remote = 0 ,npcid = 17014 ,endnpcid = 17014 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,128200},{0,10101,15000}] };
get(11620) ->
   #task{taskid = 11620 ,name = ?T("兵不血刃") ,chapter = 16 ,sort = 10 ,sort_lim = 18 ,type = 1 ,next = 11630 ,loop = 0 ,drop = [] ,accept = [{task,11610}] ,finish = [{kill,26012,150}] ,remote = 1 ,npcid = 17014 ,endnpcid = 17014 ,talkid = 0 ,endtalkid = 1163 ,goods = [{0,10108,128200},{0,10101,15000}] };
get(11630) ->
   #task{taskid = 11630 ,name = ?T("驱逐妖灵") ,chapter = 16 ,sort = 11 ,sort_lim = 18 ,type = 1 ,next = 11640 ,loop = 0 ,drop = [] ,accept = [{task,11620}] ,finish = [{kill,26011,160}] ,remote = 0 ,npcid = 17014 ,endnpcid = 17013 ,talkid = 0 ,endtalkid = 1164 ,goods = [{0,10108,128200},{0,10101,15000}] };
get(11640) ->
   #task{taskid = 11640 ,name = ?T("精进修为") ,chapter = 16 ,sort = 12 ,sort_lim = 18 ,type = 1 ,next = 11650 ,loop = 0 ,drop = [] ,accept = [{task,11630}] ,finish = [{uplv,82}] ,remote = 0 ,npcid = 17013 ,endnpcid = 17013 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,132450},{0,10101,15000}] };
get(11650) ->
   #task{taskid = 11650 ,name = ?T("幽冥判官") ,chapter = 16 ,sort = 13 ,sort_lim = 18 ,type = 1 ,next = 11660 ,loop = 0 ,drop = [] ,accept = [{task,11640}] ,finish = [{kill,26026,1}] ,remote = 1 ,npcid = 17013 ,endnpcid = 17013 ,talkid = 0 ,endtalkid = 1165 ,goods = [{0,10108,132450},{0,10101,15000}] };
get(11660) ->
   #task{taskid = 11660 ,name = ?T("斧头帮众") ,chapter = 16 ,sort = 14 ,sort_lim = 18 ,type = 1 ,next = 11670 ,loop = 0 ,drop = [] ,accept = [{task,11650}] ,finish = [{kill,26014,160}] ,remote = 0 ,npcid = 17013 ,endnpcid = 17015 ,talkid = 0 ,endtalkid = 1166 ,goods = [{0,10108,132450},{0,10101,15000}] };
get(11670) ->
   #task{taskid = 11670 ,name = ?T("此间事了") ,chapter = 16 ,sort = 15 ,sort_lim = 18 ,type = 1 ,next = 11680 ,loop = 0 ,drop = [] ,accept = [{task,11660}] ,finish = [{npc,12042}] ,remote = 0 ,npcid = 17015 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 1167 ,goods = [{0,10108,132450},{0,10101,15000}] };
get(11680) ->
   #task{taskid = 11680 ,name = ?T("精进修为") ,chapter = 16 ,sort = 16 ,sort_lim = 18 ,type = 1 ,next = 11690 ,loop = 0 ,drop = [] ,accept = [{task,11670}] ,finish = [{uplv,83}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,136800},{0,10101,15000}] };
get(11690) ->
   #task{taskid = 11690 ,name = ?T("匪患难消") ,chapter = 16 ,sort = 18 ,sort_lim = 18 ,type = 1 ,next = 11700 ,loop = 0 ,drop = [] ,accept = [{task,11680}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 1168 ,goods = [{0,10108,136800},{0,10101,15000}] };
get(11700) ->
   #task{taskid = 11700 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 11710 ,loop = 0 ,drop = [] ,accept = [{task,11690}] ,finish = [{kill,26004,160}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,136800},{0,10101,15000}] };
get(11710) ->
   #task{taskid = 11710 ,name = ?T("精进修为") ,chapter = 17 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 11720 ,loop = 0 ,drop = [] ,accept = [{task,11700}] ,finish = [{uplv,84}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,141250},{0,10101,15000}] };
get(11720) ->
   #task{taskid = 11720 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 11730 ,loop = 0 ,drop = [] ,accept = [{task,11710}] ,finish = [{kill,26006,170}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,141250},{0,10101,15000}] };
get(11730) ->
   #task{taskid = 11730 ,name = ?T("精进修为") ,chapter = 17 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 11740 ,loop = 0 ,drop = [] ,accept = [{task,11720}] ,finish = [{uplv,85}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,145800},{0,10101,15000}] };
get(11740) ->
   #task{taskid = 11740 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 11750 ,loop = 0 ,drop = [] ,accept = [{task,11730}] ,finish = [{kill,26007,170}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,145800},{0,10101,15000}] };
get(11750) ->
   #task{taskid = 11750 ,name = ?T("精进修为") ,chapter = 17 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 11760 ,loop = 0 ,drop = [] ,accept = [{task,11740}] ,finish = [{uplv,86}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,150450},{0,10101,15000}] };
get(11760) ->
   #task{taskid = 11760 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 11770 ,loop = 0 ,drop = [] ,accept = [{task,11750}] ,finish = [{kill,26008,170}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,150450},{0,10101,15000}] };
get(11770) ->
   #task{taskid = 11770 ,name = ?T("精进修为") ,chapter = 17 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 11780 ,loop = 0 ,drop = [] ,accept = [{task,11760}] ,finish = [{uplv,87}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,155200},{0,10101,15000}] };
get(11780) ->
   #task{taskid = 11780 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 11790 ,loop = 0 ,drop = [] ,accept = [{task,11770}] ,finish = [{kill,26003,180}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,155200},{0,10101,15000}] };
get(11790) ->
   #task{taskid = 11790 ,name = ?T("精进修为") ,chapter = 17 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 11800 ,loop = 0 ,drop = [] ,accept = [{task,11780}] ,finish = [{uplv,88}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,160050},{0,10101,15000}] };
get(11800) ->
   #task{taskid = 11800 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 11810 ,loop = 0 ,drop = [] ,accept = [{task,11790}] ,finish = [{kill,26002,180}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,160050},{0,10101,15000}] };
get(11810) ->
   #task{taskid = 11810 ,name = ?T("精进修为") ,chapter = 17 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 11820 ,loop = 0 ,drop = [] ,accept = [{task,11800}] ,finish = [{uplv,88}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,160050},{0,10101,15000}] };
get(11820) ->
   #task{taskid = 11820 ,name = ?T("海贼之患") ,chapter = 17 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 11830 ,loop = 0 ,drop = [] ,accept = [{task,11810}] ,finish = [{kill,26012,180}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,160050},{0,10101,15000}] };
get(11830) ->
   #task{taskid = 11830 ,name = ?T("精进修为") ,chapter = 17 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 11840 ,loop = 0 ,drop = [] ,accept = [{task,11820}] ,finish = [{uplv,89}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,165000},{0,10101,15000}] };
get(11840) ->
   #task{taskid = 11840 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 11850 ,loop = 0 ,drop = [] ,accept = [{task,11830}] ,finish = [{kill,26011,190}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,165000},{0,10101,15000}] };
get(11850) ->
   #task{taskid = 11850 ,name = ?T("精进修为") ,chapter = 17 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 11860 ,loop = 0 ,drop = [] ,accept = [{task,11840}] ,finish = [{uplv,90}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,170050},{0,10101,15000}] };
get(11860) ->
   #task{taskid = 11860 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 11870 ,loop = 0 ,drop = [] ,accept = [{task,11850}] ,finish = [{kill,26010,190}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,170050},{0,10101,15000}] };
get(11870) ->
   #task{taskid = 11870 ,name = ?T("精进修为") ,chapter = 17 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 11880 ,loop = 0 ,drop = [] ,accept = [{task,11860}] ,finish = [{uplv,91}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,175200},{0,10101,15000}] };
get(11880) ->
   #task{taskid = 11880 ,name = ?T("剿除匪患") ,chapter = 17 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 11890 ,loop = 0 ,drop = [] ,accept = [{task,11870}] ,finish = [{kill,26004,190}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12042 ,talkid = 0 ,endtalkid = 20036 ,goods = [{0,10108,175200},{0,10101,15000}] };
get(11890) ->
   #task{taskid = 11890 ,name = ?T("精进修为") ,chapter = 17 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 11900 ,loop = 0 ,drop = [] ,accept = [{task,11880}] ,finish = [{uplv,92}] ,remote = 0 ,npcid = 12042 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,257786},{0,10101,15000}] };
get(11900) ->
   #task{taskid = 11900 ,name = ?T("建木之野") ,chapter = 17 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 11910 ,loop = 0 ,drop = [] ,accept = [{task,11890}] ,finish = [{npc,12038}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,265429},{0,10101,15000}] };
get(11910) ->
   #task{taskid = 11910 ,name = ?T("神木传说") ,chapter = 17 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 11920 ,loop = 0 ,drop = [] ,accept = [{task,11900}] ,finish = [{kill,28001,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,273214},{0,10101,15000}] };
get(11920) ->
   #task{taskid = 11920 ,name = ?T("精进修为") ,chapter = 17 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 11930 ,loop = 0 ,drop = [] ,accept = [{task,11910}] ,finish = [{uplv,93}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,281143},{0,10101,15000}] };
get(11930) ->
   #task{taskid = 11930 ,name = ?T("神界之门") ,chapter = 17 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 11940 ,loop = 0 ,drop = [] ,accept = [{task,11920}] ,finish = [{kill,28002,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,289214},{0,10101,15000}] };
get(11940) ->
   #task{taskid = 11940 ,name = ?T("采集奇花") ,chapter = 17 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 11950 ,loop = 0 ,drop = [] ,accept = [{task,11930}] ,finish = [{collect,28201,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,297429},{0,10101,15000}] };
get(11950) ->
   #task{taskid = 11950 ,name = ?T("精进修为") ,chapter = 18 ,sort = 1 ,sort_lim = 26 ,type = 1 ,next = 11960 ,loop = 0 ,drop = [] ,accept = [{task,11940}] ,finish = [{uplv,94}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,305786},{0,10101,20000}] };
get(11960) ->
   #task{taskid = 11960 ,name = ?T("妖灵之首") ,chapter = 18 ,sort = 2 ,sort_lim = 26 ,type = 1 ,next = 11970 ,loop = 0 ,drop = [] ,accept = [{task,11950}] ,finish = [{kill,28100,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,314286},{0,10101,20000}] };
get(11970) ->
   #task{taskid = 11970 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 3 ,sort_lim = 26 ,type = 1 ,next = 11980 ,loop = 0 ,drop = [] ,accept = [{task,11960}] ,finish = [{kill,28003,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,322929},{0,10101,20000}] };
get(11980) ->
   #task{taskid = 11980 ,name = ?T("精进修为") ,chapter = 18 ,sort = 4 ,sort_lim = 26 ,type = 1 ,next = 11990 ,loop = 0 ,drop = [] ,accept = [{task,11970}] ,finish = [{uplv,95}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,331714},{0,10101,20000}] };
get(11990) ->
   #task{taskid = 11990 ,name = ?T("采集奇花") ,chapter = 18 ,sort = 5 ,sort_lim = 26 ,type = 1 ,next = 12000 ,loop = 0 ,drop = [] ,accept = [{task,11980}] ,finish = [{collect,28202,4}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,340643},{0,10101,20000}] };
get(12000) ->
   #task{taskid = 12000 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 6 ,sort_lim = 26 ,type = 1 ,next = 12010 ,loop = 0 ,drop = [] ,accept = [{task,11990}] ,finish = [{kill,28004,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,349714},{0,10101,20000}] };
get(12010) ->
   #task{taskid = 12010 ,name = ?T("精进修为") ,chapter = 18 ,sort = 7 ,sort_lim = 26 ,type = 1 ,next = 12020 ,loop = 0 ,drop = [] ,accept = [{task,12000}] ,finish = [{uplv,96}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,358929},{0,10101,20000}] };
get(12020) ->
   #task{taskid = 12020 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 8 ,sort_lim = 26 ,type = 1 ,next = 12030 ,loop = 0 ,drop = [] ,accept = [{task,12010}] ,finish = [{kill,28005,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,368286},{0,10101,20000}] };
get(12030) ->
   #task{taskid = 12030 ,name = ?T("妖灵之首") ,chapter = 18 ,sort = 9 ,sort_lim = 26 ,type = 1 ,next = 12040 ,loop = 0 ,drop = [] ,accept = [{task,12020}] ,finish = [{kill,28101,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,377786},{0,10101,20000}] };
get(12040) ->
   #task{taskid = 12040 ,name = ?T("精进修为") ,chapter = 18 ,sort = 10 ,sort_lim = 26 ,type = 1 ,next = 12050 ,loop = 0 ,drop = [] ,accept = [{task,12030}] ,finish = [{uplv,97}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,387429},{0,10101,20000}] };
get(12050) ->
   #task{taskid = 12050 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 11 ,sort_lim = 26 ,type = 1 ,next = 12060 ,loop = 0 ,drop = [] ,accept = [{task,12040}] ,finish = [{kill,28006,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,397214},{0,10101,20000}] };
get(12060) ->
   #task{taskid = 12060 ,name = ?T("采集奇花") ,chapter = 18 ,sort = 12 ,sort_lim = 26 ,type = 1 ,next = 12070 ,loop = 0 ,drop = [] ,accept = [{task,12050}] ,finish = [{collect,28203,5}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,407143},{0,10101,20000}] };
get(12070) ->
   #task{taskid = 12070 ,name = ?T("精进修为") ,chapter = 18 ,sort = 13 ,sort_lim = 26 ,type = 1 ,next = 12080 ,loop = 0 ,drop = [] ,accept = [{task,12060}] ,finish = [{uplv,98}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,417214},{0,10101,20000}] };
get(12080) ->
   #task{taskid = 12080 ,name = ?T("妖灵之首") ,chapter = 18 ,sort = 14 ,sort_lim = 26 ,type = 1 ,next = 12090 ,loop = 0 ,drop = [] ,accept = [{task,12070}] ,finish = [{kill,28102,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,427429},{0,10101,20000}] };
get(12090) ->
   #task{taskid = 12090 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 15 ,sort_lim = 26 ,type = 1 ,next = 12100 ,loop = 0 ,drop = [] ,accept = [{task,12080}] ,finish = [{kill,28007,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,437786},{0,10101,20000}] };
get(12100) ->
   #task{taskid = 12100 ,name = ?T("精进修为") ,chapter = 18 ,sort = 16 ,sort_lim = 26 ,type = 1 ,next = 12110 ,loop = 0 ,drop = [] ,accept = [{task,12090}] ,finish = [{uplv,99}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,627600},{0,10101,20000}] };
get(12110) ->
   #task{taskid = 12110 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 17 ,sort_lim = 26 ,type = 1 ,next = 12120 ,loop = 0 ,drop = [] ,accept = [{task,12100}] ,finish = [{kill,28008,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,642500},{0,10101,20000}] };
get(12120) ->
   #task{taskid = 12120 ,name = ?T("采集奇花") ,chapter = 18 ,sort = 18 ,sort_lim = 26 ,type = 1 ,next = 12130 ,loop = 0 ,drop = [] ,accept = [{task,12110}] ,finish = [{collect,28204,5}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,657600},{0,10101,20000}] };
get(12130) ->
   #task{taskid = 12130 ,name = ?T("精进修为") ,chapter = 18 ,sort = 19 ,sort_lim = 26 ,type = 1 ,next = 12140 ,loop = 0 ,drop = [] ,accept = [{task,12120}] ,finish = [{uplv,100}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,672900},{0,10101,20000}] };
get(12140) ->
   #task{taskid = 12140 ,name = ?T("妖灵之首") ,chapter = 18 ,sort = 20 ,sort_lim = 26 ,type = 1 ,next = 12150 ,loop = 0 ,drop = [] ,accept = [{task,12130}] ,finish = [{kill,28103,1}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,688400},{0,10101,20000}] };
get(12150) ->
   #task{taskid = 12150 ,name = ?T("洪荒妖物") ,chapter = 18 ,sort = 21 ,sort_lim = 26 ,type = 1 ,next = 12160 ,loop = 0 ,drop = [] ,accept = [{task,12140}] ,finish = [{kill,28009,250}] ,remote = 1 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,704100},{0,10101,20000}] };
get(12160) ->
   #task{taskid = 12160 ,name = ?T("精进修为") ,chapter = 18 ,sort = 22 ,sort_lim = 26 ,type = 1 ,next = 12170 ,loop = 0 ,drop = [] ,accept = [{task,12150}] ,finish = [{uplv,101}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,720000},{0,10101,20000}] };
get(12170) ->
   #task{taskid = 12170 ,name = ?T("精进修为") ,chapter = 18 ,sort = 23 ,sort_lim = 26 ,type = 1 ,next = 12180 ,loop = 0 ,drop = [] ,accept = [{task,12160}] ,finish = [{uplv,102}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,736100},{0,10101,20000}] };
get(12180) ->
   #task{taskid = 12180 ,name = ?T("精进修为") ,chapter = 18 ,sort = 24 ,sort_lim = 26 ,type = 1 ,next = 12190 ,loop = 0 ,drop = [] ,accept = [{task,12170}] ,finish = [{uplv,103}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,752400},{0,10101,20000}] };
get(12190) ->
   #task{taskid = 12190 ,name = ?T("精进修为") ,chapter = 18 ,sort = 25 ,sort_lim = 26 ,type = 1 ,next = 12200 ,loop = 0 ,drop = [] ,accept = [{task,12180}] ,finish = [{uplv,104}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,768900},{0,10101,20000}] };
get(12200) ->
   #task{taskid = 12200 ,name = ?T("精进修为") ,chapter = 18 ,sort = 26 ,sort_lim = 26 ,type = 1 ,next = 12210 ,loop = 0 ,drop = [] ,accept = [{task,12190}] ,finish = [{uplv,105}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,785600},{0,10101,20000}] };
get(12210) ->
   #task{taskid = 12210 ,name = ?T("精进修为") ,chapter = 19 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 12220 ,loop = 0 ,drop = [] ,accept = [{task,12200}] ,finish = [{uplv,106}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,802500},{0,10101,20000}] };
get(12220) ->
   #task{taskid = 12220 ,name = ?T("精进修为") ,chapter = 19 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 12230 ,loop = 0 ,drop = [] ,accept = [{task,12210}] ,finish = [{uplv,107}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,819600},{0,10101,20000}] };
get(12230) ->
   #task{taskid = 12230 ,name = ?T("精进修为") ,chapter = 19 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 12240 ,loop = 0 ,drop = [] ,accept = [{task,12220}] ,finish = [{uplv,108}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,836900},{0,10101,20000}] };
get(12240) ->
   #task{taskid = 12240 ,name = ?T("精进修为") ,chapter = 19 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 12250 ,loop = 0 ,drop = [] ,accept = [{task,12230}] ,finish = [{uplv,109}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,854400},{0,10101,20000}] };
get(12250) ->
   #task{taskid = 12250 ,name = ?T("精进修为") ,chapter = 19 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 12260 ,loop = 0 ,drop = [] ,accept = [{task,12240}] ,finish = [{uplv,110}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1162800},{0,10101,20000}] };
get(12260) ->
   #task{taskid = 12260 ,name = ?T("精进修为") ,chapter = 19 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 12270 ,loop = 0 ,drop = [] ,accept = [{task,12250}] ,finish = [{uplv,111}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1186667},{0,10101,20000}] };
get(12270) ->
   #task{taskid = 12270 ,name = ?T("精进修为") ,chapter = 19 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 12280 ,loop = 0 ,drop = [] ,accept = [{task,12260}] ,finish = [{uplv,112}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1210800},{0,10101,20000}] };
get(12280) ->
   #task{taskid = 12280 ,name = ?T("精进修为") ,chapter = 19 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 12290 ,loop = 0 ,drop = [] ,accept = [{task,12270}] ,finish = [{uplv,113}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1235200},{0,10101,20000}] };
get(12290) ->
   #task{taskid = 12290 ,name = ?T("精进修为") ,chapter = 19 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 12300 ,loop = 0 ,drop = [] ,accept = [{task,12280}] ,finish = [{uplv,114}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1259867},{0,10101,20000}] };
get(12300) ->
   #task{taskid = 12300 ,name = ?T("精进修为") ,chapter = 19 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 12310 ,loop = 0 ,drop = [] ,accept = [{task,12290}] ,finish = [{uplv,115}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1284800},{0,10101,20000}] };
get(12310) ->
   #task{taskid = 12310 ,name = ?T("精进修为") ,chapter = 19 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 12320 ,loop = 0 ,drop = [] ,accept = [{task,12300}] ,finish = [{uplv,116}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1310000},{0,10101,20000}] };
get(12320) ->
   #task{taskid = 12320 ,name = ?T("精进修为") ,chapter = 19 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 12330 ,loop = 0 ,drop = [] ,accept = [{task,12310}] ,finish = [{uplv,117}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1335467},{0,10101,20000}] };
get(12330) ->
   #task{taskid = 12330 ,name = ?T("精进修为") ,chapter = 19 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 12340 ,loop = 0 ,drop = [] ,accept = [{task,12320}] ,finish = [{uplv,118}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1361200},{0,10101,20000}] };
get(12340) ->
   #task{taskid = 12340 ,name = ?T("精进修为") ,chapter = 19 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 12350 ,loop = 0 ,drop = [] ,accept = [{task,12330}] ,finish = [{uplv,119}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1387200},{0,10101,20000}] };
get(12350) ->
   #task{taskid = 12350 ,name = ?T("精进修为") ,chapter = 19 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 12360 ,loop = 0 ,drop = [] ,accept = [{task,12340}] ,finish = [{uplv,120}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1413467},{0,10101,20000}] };
get(12360) ->
   #task{taskid = 12360 ,name = ?T("精进修为") ,chapter = 19 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 12370 ,loop = 0 ,drop = [] ,accept = [{task,12350}] ,finish = [{uplv,121}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1440000},{0,10101,20000}] };
get(12370) ->
   #task{taskid = 12370 ,name = ?T("精进修为") ,chapter = 19 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 12380 ,loop = 0 ,drop = [] ,accept = [{task,12360}] ,finish = [{uplv,122}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1466800},{0,10101,20000}] };
get(12380) ->
   #task{taskid = 12380 ,name = ?T("精进修为") ,chapter = 19 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 12390 ,loop = 0 ,drop = [] ,accept = [{task,12370}] ,finish = [{uplv,123}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1493867},{0,10101,20000}] };
get(12390) ->
   #task{taskid = 12390 ,name = ?T("精进修为") ,chapter = 19 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 12400 ,loop = 0 ,drop = [] ,accept = [{task,12380}] ,finish = [{uplv,124}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1521200},{0,10101,20000}] };
get(12400) ->
   #task{taskid = 12400 ,name = ?T("精进修为") ,chapter = 19 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 12410 ,loop = 0 ,drop = [] ,accept = [{task,12390}] ,finish = [{uplv,125}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1936000},{0,10101,20000}] };
get(12410) ->
   #task{taskid = 12410 ,name = ?T("精进修为") ,chapter = 19 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 12420 ,loop = 0 ,drop = [] ,accept = [{task,12400}] ,finish = [{uplv,126}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,1970833},{0,10101,20000}] };
get(12420) ->
   #task{taskid = 12420 ,name = ?T("精进修为") ,chapter = 19 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 12430 ,loop = 0 ,drop = [] ,accept = [{task,12410}] ,finish = [{uplv,127}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2006000},{0,10101,20000}] };
get(12430) ->
   #task{taskid = 12430 ,name = ?T("精进修为") ,chapter = 19 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 12440 ,loop = 0 ,drop = [] ,accept = [{task,12420}] ,finish = [{uplv,128}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2041500},{0,10101,20000}] };
get(12440) ->
   #task{taskid = 12440 ,name = ?T("精进修为") ,chapter = 19 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 12450 ,loop = 0 ,drop = [] ,accept = [{task,12430}] ,finish = [{uplv,129}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2077333},{0,10101,20000}] };
get(12450) ->
   #task{taskid = 12450 ,name = ?T("精进修为") ,chapter = 19 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 12460 ,loop = 0 ,drop = [] ,accept = [{task,12440}] ,finish = [{uplv,130}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2113500},{0,10101,20000}] };
get(12460) ->
   #task{taskid = 12460 ,name = ?T("精进修为") ,chapter = 20 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 12470 ,loop = 0 ,drop = [] ,accept = [{task,12450}] ,finish = [{uplv,131}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2150000},{0,10101,20000}] };
get(12470) ->
   #task{taskid = 12470 ,name = ?T("精进修为") ,chapter = 20 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 12480 ,loop = 0 ,drop = [] ,accept = [{task,12460}] ,finish = [{uplv,132}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2186833},{0,10101,20000}] };
get(12480) ->
   #task{taskid = 12480 ,name = ?T("精进修为") ,chapter = 20 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 12490 ,loop = 0 ,drop = [] ,accept = [{task,12470}] ,finish = [{uplv,133}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2224000},{0,10101,20000}] };
get(12490) ->
   #task{taskid = 12490 ,name = ?T("精进修为") ,chapter = 20 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 12500 ,loop = 0 ,drop = [] ,accept = [{task,12480}] ,finish = [{uplv,134}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2261500},{0,10101,20000}] };
get(12500) ->
   #task{taskid = 12500 ,name = ?T("精进修为") ,chapter = 20 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 12510 ,loop = 0 ,drop = [] ,accept = [{task,12490}] ,finish = [{uplv,135}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12510) ->
   #task{taskid = 12510 ,name = ?T("精进修为") ,chapter = 20 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 12520 ,loop = 0 ,drop = [] ,accept = [{task,12500}] ,finish = [{uplv,136}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2337500},{0,10101,20000}] };
get(12520) ->
   #task{taskid = 12520 ,name = ?T("精进修为") ,chapter = 20 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 12530 ,loop = 0 ,drop = [] ,accept = [{task,12510}] ,finish = [{uplv,137}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12530) ->
   #task{taskid = 12530 ,name = ?T("精进修为") ,chapter = 20 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 12540 ,loop = 0 ,drop = [] ,accept = [{task,12520}] ,finish = [{uplv,138}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12540) ->
   #task{taskid = 12540 ,name = ?T("精进修为") ,chapter = 20 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 12550 ,loop = 0 ,drop = [] ,accept = [{task,12530}] ,finish = [{uplv,139}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12550) ->
   #task{taskid = 12550 ,name = ?T("精进修为") ,chapter = 20 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 12560 ,loop = 0 ,drop = [] ,accept = [{task,12540}] ,finish = [{uplv,140}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12560) ->
   #task{taskid = 12560 ,name = ?T("精进修为") ,chapter = 20 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 12570 ,loop = 0 ,drop = [] ,accept = [{task,12550}] ,finish = [{uplv,141}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12570) ->
   #task{taskid = 12570 ,name = ?T("精进修为") ,chapter = 20 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 12580 ,loop = 0 ,drop = [] ,accept = [{task,12560}] ,finish = [{uplv,142}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12580) ->
   #task{taskid = 12580 ,name = ?T("精进修为") ,chapter = 20 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 12590 ,loop = 0 ,drop = [] ,accept = [{task,12570}] ,finish = [{uplv,143}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12590) ->
   #task{taskid = 12590 ,name = ?T("精进修为") ,chapter = 20 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 12600 ,loop = 0 ,drop = [] ,accept = [{task,12580}] ,finish = [{uplv,144}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12600) ->
   #task{taskid = 12600 ,name = ?T("精进修为") ,chapter = 20 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 12610 ,loop = 0 ,drop = [] ,accept = [{task,12590}] ,finish = [{uplv,145}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12610) ->
   #task{taskid = 12610 ,name = ?T("精进修为") ,chapter = 20 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 12620 ,loop = 0 ,drop = [] ,accept = [{task,12600}] ,finish = [{uplv,146}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12620) ->
   #task{taskid = 12620 ,name = ?T("精进修为") ,chapter = 20 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 12630 ,loop = 0 ,drop = [] ,accept = [{task,12610}] ,finish = [{uplv,147}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12630) ->
   #task{taskid = 12630 ,name = ?T("精进修为") ,chapter = 20 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 12640 ,loop = 0 ,drop = [] ,accept = [{task,12620}] ,finish = [{uplv,148}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12640) ->
   #task{taskid = 12640 ,name = ?T("精进修为") ,chapter = 20 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 12650 ,loop = 0 ,drop = [] ,accept = [{task,12630}] ,finish = [{uplv,149}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12650) ->
   #task{taskid = 12650 ,name = ?T("精进修为") ,chapter = 20 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 12660 ,loop = 0 ,drop = [] ,accept = [{task,12640}] ,finish = [{uplv,150}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12660) ->
   #task{taskid = 12660 ,name = ?T("精进修为") ,chapter = 20 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 12670 ,loop = 0 ,drop = [] ,accept = [{task,12650}] ,finish = [{uplv,151}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12670) ->
   #task{taskid = 12670 ,name = ?T("精进修为") ,chapter = 20 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 12680 ,loop = 0 ,drop = [] ,accept = [{task,12660}] ,finish = [{uplv,152}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12680) ->
   #task{taskid = 12680 ,name = ?T("精进修为") ,chapter = 20 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 12690 ,loop = 0 ,drop = [] ,accept = [{task,12670}] ,finish = [{uplv,153}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12690) ->
   #task{taskid = 12690 ,name = ?T("精进修为") ,chapter = 20 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 12700 ,loop = 0 ,drop = [] ,accept = [{task,12680}] ,finish = [{uplv,154}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2337500},{0,10101,20000}] };
get(12700) ->
   #task{taskid = 12700 ,name = ?T("精进修为") ,chapter = 20 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 12710 ,loop = 0 ,drop = [] ,accept = [{task,12690}] ,finish = [{kill,28009,250}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2376000},{0,10101,20000}] };
get(12710) ->
   #task{taskid = 12710 ,name = ?T("精进修为") ,chapter = 21 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 12720 ,loop = 0 ,drop = [] ,accept = [{task,12700}] ,finish = [{kill,28006,250}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12720) ->
   #task{taskid = 12720 ,name = ?T("精进修为") ,chapter = 21 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 12730 ,loop = 0 ,drop = [] ,accept = [{task,12710}] ,finish = [{kill,28002,250}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12730) ->
   #task{taskid = 12730 ,name = ?T("精进修为") ,chapter = 21 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 12740 ,loop = 0 ,drop = [] ,accept = [{task,12720}] ,finish = [{uplv,160}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12740) ->
   #task{taskid = 12740 ,name = ?T("精进修为") ,chapter = 21 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 12750 ,loop = 0 ,drop = [] ,accept = [{task,12730}] ,finish = [{uplv,163}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12750) ->
   #task{taskid = 12750 ,name = ?T("精进修为") ,chapter = 21 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 12760 ,loop = 0 ,drop = [] ,accept = [{task,12740}] ,finish = [{uplv,165}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12760) ->
   #task{taskid = 12760 ,name = ?T("精进修为") ,chapter = 21 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 12770 ,loop = 0 ,drop = [] ,accept = [{task,12750}] ,finish = [{uplv,168}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12770) ->
   #task{taskid = 12770 ,name = ?T("精进修为") ,chapter = 21 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 12780 ,loop = 0 ,drop = [] ,accept = [{task,12760}] ,finish = [{uplv,170}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12780) ->
   #task{taskid = 12780 ,name = ?T("精进修为") ,chapter = 21 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 12790 ,loop = 0 ,drop = [] ,accept = [{task,12770}] ,finish = [{uplv,172}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12790) ->
   #task{taskid = 12790 ,name = ?T("精进修为") ,chapter = 21 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 12800 ,loop = 0 ,drop = [] ,accept = [{task,12780}] ,finish = [{uplv,174}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12800) ->
   #task{taskid = 12800 ,name = ?T("精进修为") ,chapter = 21 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 12810 ,loop = 0 ,drop = [] ,accept = [{task,12790}] ,finish = [{uplv,176}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12810) ->
   #task{taskid = 12810 ,name = ?T("精进修为") ,chapter = 21 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 12820 ,loop = 0 ,drop = [] ,accept = [{task,12800}] ,finish = [{uplv,178}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12820) ->
   #task{taskid = 12820 ,name = ?T("精进修为") ,chapter = 21 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 12830 ,loop = 0 ,drop = [] ,accept = [{task,12810}] ,finish = [{uplv,180}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12830) ->
   #task{taskid = 12830 ,name = ?T("精进修为") ,chapter = 21 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 12840 ,loop = 0 ,drop = [] ,accept = [{task,12820}] ,finish = [{uplv,182}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12840) ->
   #task{taskid = 12840 ,name = ?T("精进修为") ,chapter = 21 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 12850 ,loop = 0 ,drop = [] ,accept = [{task,12830}] ,finish = [{uplv,184}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12850) ->
   #task{taskid = 12850 ,name = ?T("精进修为") ,chapter = 21 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 12860 ,loop = 0 ,drop = [] ,accept = [{task,12840}] ,finish = [{uplv,186}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12860) ->
   #task{taskid = 12860 ,name = ?T("精进修为") ,chapter = 21 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 12870 ,loop = 0 ,drop = [] ,accept = [{task,12850}] ,finish = [{uplv,188}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12870) ->
   #task{taskid = 12870 ,name = ?T("精进修为") ,chapter = 21 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 12880 ,loop = 0 ,drop = [] ,accept = [{task,12860}] ,finish = [{uplv,190}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12880) ->
   #task{taskid = 12880 ,name = ?T("精进修为") ,chapter = 21 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 12890 ,loop = 0 ,drop = [] ,accept = [{task,12870}] ,finish = [{uplv,192}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12890) ->
   #task{taskid = 12890 ,name = ?T("精进修为") ,chapter = 21 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 12900 ,loop = 0 ,drop = [] ,accept = [{task,12880}] ,finish = [{uplv,194}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12900) ->
   #task{taskid = 12900 ,name = ?T("精进修为") ,chapter = 21 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 12910 ,loop = 0 ,drop = [] ,accept = [{task,12890}] ,finish = [{uplv,196}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12910) ->
   #task{taskid = 12910 ,name = ?T("精进修为") ,chapter = 21 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 12920 ,loop = 0 ,drop = [] ,accept = [{task,12900}] ,finish = [{uplv,198}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12920) ->
   #task{taskid = 12920 ,name = ?T("精进修为") ,chapter = 21 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 12930 ,loop = 0 ,drop = [] ,accept = [{task,12910}] ,finish = [{uplv,200}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12930) ->
   #task{taskid = 12930 ,name = ?T("精进修为") ,chapter = 21 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 12940 ,loop = 0 ,drop = [] ,accept = [{task,12920}] ,finish = [{uplv,203}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12940) ->
   #task{taskid = 12940 ,name = ?T("精进修为") ,chapter = 21 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 12950 ,loop = 0 ,drop = [] ,accept = [{task,12930}] ,finish = [{uplv,205}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12950) ->
   #task{taskid = 12950 ,name = ?T("精进修为") ,chapter = 21 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 12960 ,loop = 0 ,drop = [] ,accept = [{task,12940}] ,finish = [{uplv,210}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12960) ->
   #task{taskid = 12960 ,name = ?T("精进修为") ,chapter = 22 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 12970 ,loop = 0 ,drop = [] ,accept = [{task,12950}] ,finish = [{uplv,215}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12970) ->
   #task{taskid = 12970 ,name = ?T("精进修为") ,chapter = 22 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 12980 ,loop = 0 ,drop = [] ,accept = [{task,12960}] ,finish = [{uplv,220}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12980) ->
   #task{taskid = 12980 ,name = ?T("精进修为") ,chapter = 22 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 12990 ,loop = 0 ,drop = [] ,accept = [{task,12970}] ,finish = [{uplv,222}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(12990) ->
   #task{taskid = 12990 ,name = ?T("精进修为") ,chapter = 22 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 13000 ,loop = 0 ,drop = [] ,accept = [{task,12980}] ,finish = [{uplv,224}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13000) ->
   #task{taskid = 13000 ,name = ?T("精进修为") ,chapter = 22 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 13010 ,loop = 0 ,drop = [] ,accept = [{task,12990}] ,finish = [{uplv,226}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13010) ->
   #task{taskid = 13010 ,name = ?T("精进修为") ,chapter = 22 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 13020 ,loop = 0 ,drop = [] ,accept = [{task,13000}] ,finish = [{uplv,228}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13020) ->
   #task{taskid = 13020 ,name = ?T("精进修为") ,chapter = 22 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 13030 ,loop = 0 ,drop = [] ,accept = [{task,13010}] ,finish = [{uplv,230}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13030) ->
   #task{taskid = 13030 ,name = ?T("精进修为") ,chapter = 22 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 13040 ,loop = 0 ,drop = [] ,accept = [{task,13020}] ,finish = [{uplv,232}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13040) ->
   #task{taskid = 13040 ,name = ?T("精进修为") ,chapter = 22 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 13050 ,loop = 0 ,drop = [] ,accept = [{task,13030}] ,finish = [{uplv,234}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13050) ->
   #task{taskid = 13050 ,name = ?T("精进修为") ,chapter = 22 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 13060 ,loop = 0 ,drop = [] ,accept = [{task,13040}] ,finish = [{uplv,236}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13060) ->
   #task{taskid = 13060 ,name = ?T("精进修为") ,chapter = 22 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 13070 ,loop = 0 ,drop = [] ,accept = [{task,13050}] ,finish = [{uplv,238}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13070) ->
   #task{taskid = 13070 ,name = ?T("精进修为") ,chapter = 22 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 13080 ,loop = 0 ,drop = [] ,accept = [{task,13060}] ,finish = [{uplv,240}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13080) ->
   #task{taskid = 13080 ,name = ?T("精进修为") ,chapter = 22 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 13090 ,loop = 0 ,drop = [] ,accept = [{task,13070}] ,finish = [{uplv,242}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13090) ->
   #task{taskid = 13090 ,name = ?T("精进修为") ,chapter = 22 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 13100 ,loop = 0 ,drop = [] ,accept = [{task,13080}] ,finish = [{uplv,244}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13100) ->
   #task{taskid = 13100 ,name = ?T("精进修为") ,chapter = 22 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 13110 ,loop = 0 ,drop = [] ,accept = [{task,13090}] ,finish = [{uplv,246}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13110) ->
   #task{taskid = 13110 ,name = ?T("精进修为") ,chapter = 22 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 13120 ,loop = 0 ,drop = [] ,accept = [{task,13100}] ,finish = [{uplv,248}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13120) ->
   #task{taskid = 13120 ,name = ?T("精进修为") ,chapter = 22 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 13130 ,loop = 0 ,drop = [] ,accept = [{task,13110}] ,finish = [{uplv,250}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13130) ->
   #task{taskid = 13130 ,name = ?T("精进修为") ,chapter = 22 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 13140 ,loop = 0 ,drop = [] ,accept = [{task,13120}] ,finish = [{uplv,255}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13140) ->
   #task{taskid = 13140 ,name = ?T("精进修为") ,chapter = 22 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 13150 ,loop = 0 ,drop = [] ,accept = [{task,13130}] ,finish = [{uplv,258}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13150) ->
   #task{taskid = 13150 ,name = ?T("精进修为") ,chapter = 22 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 13160 ,loop = 0 ,drop = [] ,accept = [{task,13140}] ,finish = [{uplv,261}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13160) ->
   #task{taskid = 13160 ,name = ?T("精进修为") ,chapter = 22 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 13170 ,loop = 0 ,drop = [] ,accept = [{task,13150}] ,finish = [{uplv,264}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13170) ->
   #task{taskid = 13170 ,name = ?T("精进修为") ,chapter = 22 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 13180 ,loop = 0 ,drop = [] ,accept = [{task,13160}] ,finish = [{uplv,267}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13180) ->
   #task{taskid = 13180 ,name = ?T("精进修为") ,chapter = 22 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 13190 ,loop = 0 ,drop = [] ,accept = [{task,13170}] ,finish = [{uplv,270}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13190) ->
   #task{taskid = 13190 ,name = ?T("精进修为") ,chapter = 22 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 13200 ,loop = 0 ,drop = [] ,accept = [{task,13180}] ,finish = [{uplv,273}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13200) ->
   #task{taskid = 13200 ,name = ?T("精进修为") ,chapter = 22 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 13210 ,loop = 0 ,drop = [] ,accept = [{task,13190}] ,finish = [{uplv,276}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13210) ->
   #task{taskid = 13210 ,name = ?T("精进修为") ,chapter = 23 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 13220 ,loop = 0 ,drop = [] ,accept = [{task,13200}] ,finish = [{uplv,278}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13220) ->
   #task{taskid = 13220 ,name = ?T("精进修为") ,chapter = 23 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 13230 ,loop = 0 ,drop = [] ,accept = [{task,13210}] ,finish = [{uplv,281}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13230) ->
   #task{taskid = 13230 ,name = ?T("精进修为") ,chapter = 23 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 13240 ,loop = 0 ,drop = [] ,accept = [{task,13220}] ,finish = [{uplv,283}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13240) ->
   #task{taskid = 13240 ,name = ?T("精进修为") ,chapter = 23 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 13250 ,loop = 0 ,drop = [] ,accept = [{task,13230}] ,finish = [{uplv,285}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13250) ->
   #task{taskid = 13250 ,name = ?T("精进修为") ,chapter = 23 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 13260 ,loop = 0 ,drop = [] ,accept = [{task,13240}] ,finish = [{uplv,287}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13260) ->
   #task{taskid = 13260 ,name = ?T("精进修为") ,chapter = 23 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 13270 ,loop = 0 ,drop = [] ,accept = [{task,13250}] ,finish = [{uplv,289}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13270) ->
   #task{taskid = 13270 ,name = ?T("精进修为") ,chapter = 23 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 13280 ,loop = 0 ,drop = [] ,accept = [{task,13260}] ,finish = [{uplv,291}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13280) ->
   #task{taskid = 13280 ,name = ?T("精进修为") ,chapter = 23 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 13290 ,loop = 0 ,drop = [] ,accept = [{task,13270}] ,finish = [{uplv,293}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13290) ->
   #task{taskid = 13290 ,name = ?T("精进修为") ,chapter = 23 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 13300 ,loop = 0 ,drop = [] ,accept = [{task,13280}] ,finish = [{uplv,295}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13300) ->
   #task{taskid = 13300 ,name = ?T("精进修为") ,chapter = 23 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 13310 ,loop = 0 ,drop = [] ,accept = [{task,13290}] ,finish = [{uplv,297}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13310) ->
   #task{taskid = 13310 ,name = ?T("精进修为") ,chapter = 23 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 13320 ,loop = 0 ,drop = [] ,accept = [{task,13300}] ,finish = [{uplv,300}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13320) ->
   #task{taskid = 13320 ,name = ?T("精进修为") ,chapter = 23 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 13330 ,loop = 0 ,drop = [] ,accept = [{task,13310}] ,finish = [{uplv,302}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13330) ->
   #task{taskid = 13330 ,name = ?T("精进修为") ,chapter = 23 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 13340 ,loop = 0 ,drop = [] ,accept = [{task,13320}] ,finish = [{uplv,303}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13340) ->
   #task{taskid = 13340 ,name = ?T("精进修为") ,chapter = 23 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 13350 ,loop = 0 ,drop = [] ,accept = [{task,13330}] ,finish = [{uplv,304}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13350) ->
   #task{taskid = 13350 ,name = ?T("精进修为") ,chapter = 23 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 13360 ,loop = 0 ,drop = [] ,accept = [{task,13340}] ,finish = [{uplv,305}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13360) ->
   #task{taskid = 13360 ,name = ?T("精进修为") ,chapter = 23 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 13370 ,loop = 0 ,drop = [] ,accept = [{task,13350}] ,finish = [{uplv,306}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13370) ->
   #task{taskid = 13370 ,name = ?T("精进修为") ,chapter = 23 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 13380 ,loop = 0 ,drop = [] ,accept = [{task,13360}] ,finish = [{uplv,307}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13380) ->
   #task{taskid = 13380 ,name = ?T("精进修为") ,chapter = 23 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 13390 ,loop = 0 ,drop = [] ,accept = [{task,13370}] ,finish = [{uplv,308}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13390) ->
   #task{taskid = 13390 ,name = ?T("精进修为") ,chapter = 23 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 13400 ,loop = 0 ,drop = [] ,accept = [{task,13380}] ,finish = [{uplv,309}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13400) ->
   #task{taskid = 13400 ,name = ?T("精进修为") ,chapter = 23 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 13410 ,loop = 0 ,drop = [] ,accept = [{task,13390}] ,finish = [{uplv,310}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13410) ->
   #task{taskid = 13410 ,name = ?T("精进修为") ,chapter = 23 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 13420 ,loop = 0 ,drop = [] ,accept = [{task,13400}] ,finish = [{uplv,311}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13420) ->
   #task{taskid = 13420 ,name = ?T("精进修为") ,chapter = 23 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 13430 ,loop = 0 ,drop = [] ,accept = [{task,13410}] ,finish = [{uplv,312}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13430) ->
   #task{taskid = 13430 ,name = ?T("精进修为") ,chapter = 23 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 13440 ,loop = 0 ,drop = [] ,accept = [{task,13420}] ,finish = [{uplv,313}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13440) ->
   #task{taskid = 13440 ,name = ?T("精进修为") ,chapter = 23 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 13450 ,loop = 0 ,drop = [] ,accept = [{task,13430}] ,finish = [{uplv,314}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13450) ->
   #task{taskid = 13450 ,name = ?T("精进修为") ,chapter = 23 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 13460 ,loop = 0 ,drop = [] ,accept = [{task,13440}] ,finish = [{uplv,315}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13460) ->
   #task{taskid = 13460 ,name = ?T("精进修为") ,chapter = 24 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 13470 ,loop = 0 ,drop = [] ,accept = [{task,13450}] ,finish = [{uplv,316}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13470) ->
   #task{taskid = 13470 ,name = ?T("精进修为") ,chapter = 24 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 13480 ,loop = 0 ,drop = [] ,accept = [{task,13460}] ,finish = [{uplv,317}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13480) ->
   #task{taskid = 13480 ,name = ?T("精进修为") ,chapter = 24 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 13490 ,loop = 0 ,drop = [] ,accept = [{task,13470}] ,finish = [{uplv,318}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13490) ->
   #task{taskid = 13490 ,name = ?T("精进修为") ,chapter = 24 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 13500 ,loop = 0 ,drop = [] ,accept = [{task,13480}] ,finish = [{uplv,319}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13500) ->
   #task{taskid = 13500 ,name = ?T("精进修为") ,chapter = 24 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 13510 ,loop = 0 ,drop = [] ,accept = [{task,13490}] ,finish = [{uplv,320}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13510) ->
   #task{taskid = 13510 ,name = ?T("精进修为") ,chapter = 24 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 13520 ,loop = 0 ,drop = [] ,accept = [{task,13500}] ,finish = [{uplv,321}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13520) ->
   #task{taskid = 13520 ,name = ?T("精进修为") ,chapter = 24 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 13530 ,loop = 0 ,drop = [] ,accept = [{task,13510}] ,finish = [{uplv,322}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13530) ->
   #task{taskid = 13530 ,name = ?T("精进修为") ,chapter = 24 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 13540 ,loop = 0 ,drop = [] ,accept = [{task,13520}] ,finish = [{uplv,323}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13540) ->
   #task{taskid = 13540 ,name = ?T("精进修为") ,chapter = 24 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 13550 ,loop = 0 ,drop = [] ,accept = [{task,13530}] ,finish = [{uplv,324}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13550) ->
   #task{taskid = 13550 ,name = ?T("精进修为") ,chapter = 24 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 13560 ,loop = 0 ,drop = [] ,accept = [{task,13540}] ,finish = [{uplv,325}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13560) ->
   #task{taskid = 13560 ,name = ?T("精进修为") ,chapter = 24 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 13570 ,loop = 0 ,drop = [] ,accept = [{task,13550}] ,finish = [{uplv,326}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13570) ->
   #task{taskid = 13570 ,name = ?T("精进修为") ,chapter = 24 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 13580 ,loop = 0 ,drop = [] ,accept = [{task,13560}] ,finish = [{uplv,327}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13580) ->
   #task{taskid = 13580 ,name = ?T("精进修为") ,chapter = 24 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 13590 ,loop = 0 ,drop = [] ,accept = [{task,13570}] ,finish = [{uplv,328}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13590) ->
   #task{taskid = 13590 ,name = ?T("精进修为") ,chapter = 24 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 13600 ,loop = 0 ,drop = [] ,accept = [{task,13580}] ,finish = [{uplv,329}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13600) ->
   #task{taskid = 13600 ,name = ?T("精进修为") ,chapter = 24 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 13610 ,loop = 0 ,drop = [] ,accept = [{task,13590}] ,finish = [{uplv,330}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13610) ->
   #task{taskid = 13610 ,name = ?T("精进修为") ,chapter = 24 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 13620 ,loop = 0 ,drop = [] ,accept = [{task,13600}] ,finish = [{uplv,331}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13620) ->
   #task{taskid = 13620 ,name = ?T("精进修为") ,chapter = 24 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 13630 ,loop = 0 ,drop = [] ,accept = [{task,13610}] ,finish = [{uplv,332}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13630) ->
   #task{taskid = 13630 ,name = ?T("精进修为") ,chapter = 24 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 13640 ,loop = 0 ,drop = [] ,accept = [{task,13620}] ,finish = [{uplv,333}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13640) ->
   #task{taskid = 13640 ,name = ?T("精进修为") ,chapter = 24 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 13650 ,loop = 0 ,drop = [] ,accept = [{task,13630}] ,finish = [{uplv,334}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13650) ->
   #task{taskid = 13650 ,name = ?T("精进修为") ,chapter = 24 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 13660 ,loop = 0 ,drop = [] ,accept = [{task,13640}] ,finish = [{uplv,335}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13660) ->
   #task{taskid = 13660 ,name = ?T("精进修为") ,chapter = 24 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 13670 ,loop = 0 ,drop = [] ,accept = [{task,13650}] ,finish = [{uplv,336}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13670) ->
   #task{taskid = 13670 ,name = ?T("精进修为") ,chapter = 24 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 13680 ,loop = 0 ,drop = [] ,accept = [{task,13660}] ,finish = [{uplv,337}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13680) ->
   #task{taskid = 13680 ,name = ?T("精进修为") ,chapter = 24 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 13690 ,loop = 0 ,drop = [] ,accept = [{task,13670}] ,finish = [{uplv,338}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13690) ->
   #task{taskid = 13690 ,name = ?T("精进修为") ,chapter = 24 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 13700 ,loop = 0 ,drop = [] ,accept = [{task,13680}] ,finish = [{uplv,339}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13700) ->
   #task{taskid = 13700 ,name = ?T("精进修为") ,chapter = 24 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 13710 ,loop = 0 ,drop = [] ,accept = [{task,13690}] ,finish = [{uplv,340}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13710) ->
   #task{taskid = 13710 ,name = ?T("精进修为") ,chapter = 25 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 13720 ,loop = 0 ,drop = [] ,accept = [{task,13700}] ,finish = [{uplv,341}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13720) ->
   #task{taskid = 13720 ,name = ?T("精进修为") ,chapter = 25 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 13730 ,loop = 0 ,drop = [] ,accept = [{task,13710}] ,finish = [{uplv,342}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13730) ->
   #task{taskid = 13730 ,name = ?T("精进修为") ,chapter = 25 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 13740 ,loop = 0 ,drop = [] ,accept = [{task,13720}] ,finish = [{uplv,343}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13740) ->
   #task{taskid = 13740 ,name = ?T("精进修为") ,chapter = 25 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 13750 ,loop = 0 ,drop = [] ,accept = [{task,13730}] ,finish = [{uplv,344}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13750) ->
   #task{taskid = 13750 ,name = ?T("精进修为") ,chapter = 25 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 13760 ,loop = 0 ,drop = [] ,accept = [{task,13740}] ,finish = [{uplv,345}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13760) ->
   #task{taskid = 13760 ,name = ?T("精进修为") ,chapter = 25 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 13770 ,loop = 0 ,drop = [] ,accept = [{task,13750}] ,finish = [{uplv,346}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13770) ->
   #task{taskid = 13770 ,name = ?T("精进修为") ,chapter = 25 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 13780 ,loop = 0 ,drop = [] ,accept = [{task,13760}] ,finish = [{uplv,347}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13780) ->
   #task{taskid = 13780 ,name = ?T("精进修为") ,chapter = 25 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 13790 ,loop = 0 ,drop = [] ,accept = [{task,13770}] ,finish = [{uplv,348}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13790) ->
   #task{taskid = 13790 ,name = ?T("精进修为") ,chapter = 25 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 13800 ,loop = 0 ,drop = [] ,accept = [{task,13780}] ,finish = [{uplv,349}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13800) ->
   #task{taskid = 13800 ,name = ?T("精进修为") ,chapter = 25 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 13810 ,loop = 0 ,drop = [] ,accept = [{task,13790}] ,finish = [{uplv,350}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13810) ->
   #task{taskid = 13810 ,name = ?T("精进修为") ,chapter = 25 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 13820 ,loop = 0 ,drop = [] ,accept = [{task,13800}] ,finish = [{uplv,351}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13820) ->
   #task{taskid = 13820 ,name = ?T("精进修为") ,chapter = 25 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 13830 ,loop = 0 ,drop = [] ,accept = [{task,13810}] ,finish = [{uplv,352}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13830) ->
   #task{taskid = 13830 ,name = ?T("精进修为") ,chapter = 25 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 13840 ,loop = 0 ,drop = [] ,accept = [{task,13820}] ,finish = [{uplv,353}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13840) ->
   #task{taskid = 13840 ,name = ?T("精进修为") ,chapter = 25 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 13850 ,loop = 0 ,drop = [] ,accept = [{task,13830}] ,finish = [{uplv,354}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13850) ->
   #task{taskid = 13850 ,name = ?T("精进修为") ,chapter = 25 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 13860 ,loop = 0 ,drop = [] ,accept = [{task,13840}] ,finish = [{uplv,355}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13860) ->
   #task{taskid = 13860 ,name = ?T("精进修为") ,chapter = 25 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 13870 ,loop = 0 ,drop = [] ,accept = [{task,13850}] ,finish = [{uplv,356}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13870) ->
   #task{taskid = 13870 ,name = ?T("精进修为") ,chapter = 25 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 13880 ,loop = 0 ,drop = [] ,accept = [{task,13860}] ,finish = [{uplv,357}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13880) ->
   #task{taskid = 13880 ,name = ?T("精进修为") ,chapter = 25 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 13890 ,loop = 0 ,drop = [] ,accept = [{task,13870}] ,finish = [{uplv,358}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13890) ->
   #task{taskid = 13890 ,name = ?T("精进修为") ,chapter = 25 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 13900 ,loop = 0 ,drop = [] ,accept = [{task,13880}] ,finish = [{uplv,359}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13900) ->
   #task{taskid = 13900 ,name = ?T("精进修为") ,chapter = 25 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 13910 ,loop = 0 ,drop = [] ,accept = [{task,13890}] ,finish = [{uplv,360}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13910) ->
   #task{taskid = 13910 ,name = ?T("精进修为") ,chapter = 25 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 13920 ,loop = 0 ,drop = [] ,accept = [{task,13900}] ,finish = [{uplv,361}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13920) ->
   #task{taskid = 13920 ,name = ?T("精进修为") ,chapter = 25 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 13930 ,loop = 0 ,drop = [] ,accept = [{task,13910}] ,finish = [{uplv,362}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13930) ->
   #task{taskid = 13930 ,name = ?T("精进修为") ,chapter = 25 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 13940 ,loop = 0 ,drop = [] ,accept = [{task,13920}] ,finish = [{uplv,363}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13940) ->
   #task{taskid = 13940 ,name = ?T("精进修为") ,chapter = 25 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 13950 ,loop = 0 ,drop = [] ,accept = [{task,13930}] ,finish = [{uplv,364}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13950) ->
   #task{taskid = 13950 ,name = ?T("精进修为") ,chapter = 25 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 13960 ,loop = 0 ,drop = [] ,accept = [{task,13940}] ,finish = [{uplv,365}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13960) ->
   #task{taskid = 13960 ,name = ?T("精进修为") ,chapter = 26 ,sort = 1 ,sort_lim = 25 ,type = 1 ,next = 13970 ,loop = 0 ,drop = [] ,accept = [{task,13950}] ,finish = [{uplv,366}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13970) ->
   #task{taskid = 13970 ,name = ?T("精进修为") ,chapter = 26 ,sort = 2 ,sort_lim = 25 ,type = 1 ,next = 13980 ,loop = 0 ,drop = [] ,accept = [{task,13960}] ,finish = [{uplv,367}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13980) ->
   #task{taskid = 13980 ,name = ?T("精进修为") ,chapter = 26 ,sort = 3 ,sort_lim = 25 ,type = 1 ,next = 13990 ,loop = 0 ,drop = [] ,accept = [{task,13970}] ,finish = [{uplv,368}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(13990) ->
   #task{taskid = 13990 ,name = ?T("精进修为") ,chapter = 26 ,sort = 4 ,sort_lim = 25 ,type = 1 ,next = 14000 ,loop = 0 ,drop = [] ,accept = [{task,13980}] ,finish = [{uplv,369}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14000) ->
   #task{taskid = 14000 ,name = ?T("精进修为") ,chapter = 26 ,sort = 5 ,sort_lim = 25 ,type = 1 ,next = 14010 ,loop = 0 ,drop = [] ,accept = [{task,13990}] ,finish = [{uplv,370}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14010) ->
   #task{taskid = 14010 ,name = ?T("精进修为") ,chapter = 26 ,sort = 6 ,sort_lim = 25 ,type = 1 ,next = 14020 ,loop = 0 ,drop = [] ,accept = [{task,14000}] ,finish = [{uplv,371}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14020) ->
   #task{taskid = 14020 ,name = ?T("精进修为") ,chapter = 26 ,sort = 7 ,sort_lim = 25 ,type = 1 ,next = 14030 ,loop = 0 ,drop = [] ,accept = [{task,14010}] ,finish = [{uplv,372}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14030) ->
   #task{taskid = 14030 ,name = ?T("精进修为") ,chapter = 26 ,sort = 8 ,sort_lim = 25 ,type = 1 ,next = 14040 ,loop = 0 ,drop = [] ,accept = [{task,14020}] ,finish = [{uplv,373}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14040) ->
   #task{taskid = 14040 ,name = ?T("精进修为") ,chapter = 26 ,sort = 9 ,sort_lim = 25 ,type = 1 ,next = 14050 ,loop = 0 ,drop = [] ,accept = [{task,14030}] ,finish = [{uplv,374}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14050) ->
   #task{taskid = 14050 ,name = ?T("精进修为") ,chapter = 26 ,sort = 10 ,sort_lim = 25 ,type = 1 ,next = 14060 ,loop = 0 ,drop = [] ,accept = [{task,14040}] ,finish = [{uplv,375}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14060) ->
   #task{taskid = 14060 ,name = ?T("精进修为") ,chapter = 26 ,sort = 11 ,sort_lim = 25 ,type = 1 ,next = 14070 ,loop = 0 ,drop = [] ,accept = [{task,14050}] ,finish = [{uplv,376}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14070) ->
   #task{taskid = 14070 ,name = ?T("精进修为") ,chapter = 26 ,sort = 12 ,sort_lim = 25 ,type = 1 ,next = 14080 ,loop = 0 ,drop = [] ,accept = [{task,14060}] ,finish = [{uplv,377}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14080) ->
   #task{taskid = 14080 ,name = ?T("精进修为") ,chapter = 26 ,sort = 13 ,sort_lim = 25 ,type = 1 ,next = 14090 ,loop = 0 ,drop = [] ,accept = [{task,14070}] ,finish = [{uplv,378}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14090) ->
   #task{taskid = 14090 ,name = ?T("精进修为") ,chapter = 26 ,sort = 14 ,sort_lim = 25 ,type = 1 ,next = 14100 ,loop = 0 ,drop = [] ,accept = [{task,14080}] ,finish = [{uplv,379}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14100) ->
   #task{taskid = 14100 ,name = ?T("精进修为") ,chapter = 26 ,sort = 15 ,sort_lim = 25 ,type = 1 ,next = 14110 ,loop = 0 ,drop = [] ,accept = [{task,14090}] ,finish = [{uplv,380}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14110) ->
   #task{taskid = 14110 ,name = ?T("精进修为") ,chapter = 26 ,sort = 16 ,sort_lim = 25 ,type = 1 ,next = 14120 ,loop = 0 ,drop = [] ,accept = [{task,14100}] ,finish = [{uplv,381}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14120) ->
   #task{taskid = 14120 ,name = ?T("精进修为") ,chapter = 26 ,sort = 17 ,sort_lim = 25 ,type = 1 ,next = 14130 ,loop = 0 ,drop = [] ,accept = [{task,14110}] ,finish = [{uplv,382}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14130) ->
   #task{taskid = 14130 ,name = ?T("精进修为") ,chapter = 26 ,sort = 18 ,sort_lim = 25 ,type = 1 ,next = 14140 ,loop = 0 ,drop = [] ,accept = [{task,14120}] ,finish = [{uplv,383}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14140) ->
   #task{taskid = 14140 ,name = ?T("精进修为") ,chapter = 26 ,sort = 19 ,sort_lim = 25 ,type = 1 ,next = 14150 ,loop = 0 ,drop = [] ,accept = [{task,14130}] ,finish = [{uplv,384}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14150) ->
   #task{taskid = 14150 ,name = ?T("精进修为") ,chapter = 26 ,sort = 20 ,sort_lim = 25 ,type = 1 ,next = 14160 ,loop = 0 ,drop = [] ,accept = [{task,14140}] ,finish = [{uplv,385}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14160) ->
   #task{taskid = 14160 ,name = ?T("精进修为") ,chapter = 26 ,sort = 21 ,sort_lim = 25 ,type = 1 ,next = 14170 ,loop = 0 ,drop = [] ,accept = [{task,14150}] ,finish = [{uplv,386}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14170) ->
   #task{taskid = 14170 ,name = ?T("精进修为") ,chapter = 26 ,sort = 22 ,sort_lim = 25 ,type = 1 ,next = 14180 ,loop = 0 ,drop = [] ,accept = [{task,14160}] ,finish = [{uplv,387}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14180) ->
   #task{taskid = 14180 ,name = ?T("精进修为") ,chapter = 26 ,sort = 23 ,sort_lim = 25 ,type = 1 ,next = 14190 ,loop = 0 ,drop = [] ,accept = [{task,14170}] ,finish = [{uplv,400}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14190) ->
   #task{taskid = 14190 ,name = ?T("精进修为") ,chapter = 26 ,sort = 24 ,sort_lim = 25 ,type = 1 ,next = 14200 ,loop = 0 ,drop = [] ,accept = [{task,14180}] ,finish = [{uplv,600}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(14200) ->
   #task{taskid = 14200 ,name = ?T("精进修为") ,chapter = 26 ,sort = 25 ,sort_lim = 25 ,type = 1 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{task,14190}] ,finish = [{uplv,700}] ,remote = 0 ,npcid = 12038 ,endnpcid = 12038 ,talkid = 0 ,endtalkid = 20035 ,goods = [{0,10108,2299333},{0,10101,20000}] };
get(_) -> [].