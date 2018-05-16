%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_cycle
	%%% @Created : 2017-11-02 11:53:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_cycle).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[300101,300102,300103,300104,300105,300106,300107,300108,300109,300110,300111,300112,300113,300114,300115,300116,300117,300118,300119,300120,300121,300122,300123,300124,300125,300126,300127,300128,300129,300130,300201,300202,300203,300204,300205,300206,300207,300208,300209,300210,300211,300212,300213,300214,300215,300216,300217,300218,300219,300220,300221,300222,300223,300224,300225,300226,300227,300228,300229,300230,300301,300302,300303,300304,300305,300306,300307,300308,300309,300310,300311,300312,300313,300314,300315,300316,300317,300318,300319,300320,300321,300322,300323,300324,300325,300326,300327,300328,300329,300330,300401,300402,300403,300404,300405,300406,300407,300408,300409,300410,300411,300412,300413,300414,300415,300416,300417,300418,300419,300420,300421,300422,300423,300424,300425,300426,300427,300428,300429,300430,300501,300502,300503,300504,300505,300506,300507,300508,300509,300510,300511,300512,300513,300514,300515,300516,300517,300518,300519,300520,300521,300522,300523,300524,300525,300526,300527,300528,300529,300530,300601,300602,300603,300604,300605,300606,300607,300608,300609,300610,300611,300612,300613,300614,300615,300616,300617,300618,300619,300620,300621,300622,300623,300624,300625,300626,300627,300628,300629,300630,300701,300702,300703,300704,300705,300706,300707,300708,300709,300710,300711,300712,300713,300714,300715,300716,300717,300718,300719,300720,300721,300722,300723,300724,300725,300726,300727,300728,300729,300730,300801,300802,300803,300804,300805,300806,300807,300808,300809,300810,300811,300812,300813,300814,300815,300816,300817,300818,300819,300820,300821,300822,300823,300824,300825,300826,300827,300828,300829,300830,300901,300902,300903,300904,300905,300906,300907,300908,300909,300910,300911,300912,300913,300914,300915,300916,300917,300918,300919,300920,300921,300922,300923,300924,300925,300926,300927,300928,300929,300930,301001,301002,301003,301004,301005,301006,301007,301008,301009,301010,301011,301012,301013,301014,301015,301016,301017,301018,301019,301020,301021,301022,301023,301024,301025,301026,301027,301028,301029,301030,301101,301102,301103,301104,301105,301106,301107,301108,301109,301110,301111,301112,301113,301114,301115,301116,301117,301118,301119,301120,301121,301122,301123,301124,301125,301126,301127,301128,301129,301130,301201,301202,301203,301204,301205,301206,301207,301208,301209,301210,301211,301212,301213,301214,301215,301216,301217,301218,301219,301220,301221,301222,301223,301224,301225,301226,301227,301228,301229,301230,301301,301302,301303,301304,301305,301306,301307,301308,301309,301310,301311,301312,301313,301314,301315,301316,301317,301318,301319,301320,301321,301322,301323,301324,301325,301326,301327,301328,301329,301330,301401,301402,301403,301404,301405,301406,301407,301408,301409,301410,301411,301412,301413,301414,301415,301416,301417,301418,301419,301420,301421,301422,301423,301424,301425,301426,301427,301428,301429,301430,301501,301502,301503,301504,301505,301506,301507,301508,301509,301510,301511,301512,301513,301514,301515,301516,301517,301518,301519,301520,301521,301522,301523,301524,301525,301526,301527,301528,301529,301530,301601,301602,301603,301604,301605,301606,301607,301608,301609,301610,301611,301612,301613,301614,301615,301616,301617,301618,301619,301620,301621,301622,301623,301624,301625,301626,301627,301628,301629,301630,301701,301702,301703,301704,301705,301706,301707,301708,301709,301710,301711,301712,301713,301714,301715,301716,301717,301718,301719,301720,301721,301722,301723,301724,301725,301726,301727,301728,301729,301730,301801,301802,301803,301804,301805,301806,301807,301808,301809,301810,301811,301812,301813,301814,301815,301816,301817,301818,301819,301820,301821,301822,301823,301824,301825,301826,301827,301828,301829,301830,301901,301902,301903,301904,301905,301906,301907,301908,301909,301910,301911,301912,301913,301914,301915,301916,301917,301918,301919,301920,301921,301922,301923,301924,301925,301926,301927,301928,301929,301930,302001,302002,302003,302004,302005,302006,302007,302008,302009,302010,302011,302012,302013,302014,302015,302016,302017,302018,302019,302020,302021,302022,302023,302024,302025,302026,302027,302028,302029,302030,302101,302102,302103,302104,302105,302106,302107,302108,302109,302110,302111,302112,302113,302114,302115,302116,302117,302118,302119,302120,302121,302122,302123,302124,302125,302126,302127,302128,302129,302130].

get(300101) ->
   #task{taskid = 300101 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24022,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300102) ->
   #task{taskid = 300102 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24021,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300103) ->
   #task{taskid = 300103 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24001,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300104) ->
   #task{taskid = 300104 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24005,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300105) ->
   #task{taskid = 300105 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24018,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300106) ->
   #task{taskid = 300106 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23016,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300107) ->
   #task{taskid = 300107 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23017,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300108) ->
   #task{taskid = 300108 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23014,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300109) ->
   #task{taskid = 300109 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23004,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300110) ->
   #task{taskid = 300110 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23005,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300111) ->
   #task{taskid = 300111 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25009,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300112) ->
   #task{taskid = 300112 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300113) ->
   #task{taskid = 300113 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25008,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300114) ->
   #task{taskid = 300114 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300115) ->
   #task{taskid = 300115 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300116) ->
   #task{taskid = 300116 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24022,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300117) ->
   #task{taskid = 300117 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24021,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300118) ->
   #task{taskid = 300118 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300119) ->
   #task{taskid = 300119 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24005,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300120) ->
   #task{taskid = 300120 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24018,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300121) ->
   #task{taskid = 300121 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23016,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300122) ->
   #task{taskid = 300122 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23017,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300123) ->
   #task{taskid = 300123 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23014,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300124) ->
   #task{taskid = 300124 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23004,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300125) ->
   #task{taskid = 300125 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23005,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300126) ->
   #task{taskid = 300126 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25009,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300127) ->
   #task{taskid = 300127 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25007,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300128) ->
   #task{taskid = 300128 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25008,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300129) ->
   #task{taskid = 300129 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25013,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300130) ->
   #task{taskid = 300130 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25014,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12400}] };
get(300201) ->
   #task{taskid = 300201 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300202) ->
   #task{taskid = 300202 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300203) ->
   #task{taskid = 300203 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300204) ->
   #task{taskid = 300204 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300205) ->
   #task{taskid = 300205 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300206) ->
   #task{taskid = 300206 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300207) ->
   #task{taskid = 300207 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300208) ->
   #task{taskid = 300208 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300209) ->
   #task{taskid = 300209 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300210) ->
   #task{taskid = 300210 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300211) ->
   #task{taskid = 300211 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300212) ->
   #task{taskid = 300212 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300213) ->
   #task{taskid = 300213 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300214) ->
   #task{taskid = 300214 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300215) ->
   #task{taskid = 300215 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300216) ->
   #task{taskid = 300216 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300217) ->
   #task{taskid = 300217 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300218) ->
   #task{taskid = 300218 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300219) ->
   #task{taskid = 300219 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300220) ->
   #task{taskid = 300220 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300221) ->
   #task{taskid = 300221 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300222) ->
   #task{taskid = 300222 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300223) ->
   #task{taskid = 300223 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300224) ->
   #task{taskid = 300224 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300225) ->
   #task{taskid = 300225 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300226) ->
   #task{taskid = 300226 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300227) ->
   #task{taskid = 300227 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300228) ->
   #task{taskid = 300228 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300229) ->
   #task{taskid = 300229 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300230) ->
   #task{taskid = 300230 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,14800}] };
get(300301) ->
   #task{taskid = 300301 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300302) ->
   #task{taskid = 300302 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300303) ->
   #task{taskid = 300303 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300304) ->
   #task{taskid = 300304 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300305) ->
   #task{taskid = 300305 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300306) ->
   #task{taskid = 300306 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300307) ->
   #task{taskid = 300307 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300308) ->
   #task{taskid = 300308 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300309) ->
   #task{taskid = 300309 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300310) ->
   #task{taskid = 300310 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300311) ->
   #task{taskid = 300311 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300312) ->
   #task{taskid = 300312 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300313) ->
   #task{taskid = 300313 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300314) ->
   #task{taskid = 300314 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300315) ->
   #task{taskid = 300315 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300316) ->
   #task{taskid = 300316 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300317) ->
   #task{taskid = 300317 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300318) ->
   #task{taskid = 300318 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300319) ->
   #task{taskid = 300319 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300320) ->
   #task{taskid = 300320 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300321) ->
   #task{taskid = 300321 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300322) ->
   #task{taskid = 300322 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300323) ->
   #task{taskid = 300323 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300324) ->
   #task{taskid = 300324 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300325) ->
   #task{taskid = 300325 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300326) ->
   #task{taskid = 300326 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300327) ->
   #task{taskid = 300327 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300328) ->
   #task{taskid = 300328 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300329) ->
   #task{taskid = 300329 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300330) ->
   #task{taskid = 300330 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,16400}] };
get(300401) ->
   #task{taskid = 300401 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300402) ->
   #task{taskid = 300402 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300403) ->
   #task{taskid = 300403 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300404) ->
   #task{taskid = 300404 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300405) ->
   #task{taskid = 300405 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300406) ->
   #task{taskid = 300406 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300407) ->
   #task{taskid = 300407 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300408) ->
   #task{taskid = 300408 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300409) ->
   #task{taskid = 300409 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300410) ->
   #task{taskid = 300410 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300411) ->
   #task{taskid = 300411 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300412) ->
   #task{taskid = 300412 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300413) ->
   #task{taskid = 300413 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300414) ->
   #task{taskid = 300414 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300415) ->
   #task{taskid = 300415 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300416) ->
   #task{taskid = 300416 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300417) ->
   #task{taskid = 300417 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300418) ->
   #task{taskid = 300418 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300419) ->
   #task{taskid = 300419 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300420) ->
   #task{taskid = 300420 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300421) ->
   #task{taskid = 300421 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300422) ->
   #task{taskid = 300422 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300423) ->
   #task{taskid = 300423 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300424) ->
   #task{taskid = 300424 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300425) ->
   #task{taskid = 300425 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300426) ->
   #task{taskid = 300426 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300427) ->
   #task{taskid = 300427 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300428) ->
   #task{taskid = 300428 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300429) ->
   #task{taskid = 300429 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300430) ->
   #task{taskid = 300430 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,18200}] };
get(300501) ->
   #task{taskid = 300501 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300502) ->
   #task{taskid = 300502 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300503) ->
   #task{taskid = 300503 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300504) ->
   #task{taskid = 300504 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300505) ->
   #task{taskid = 300505 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300506) ->
   #task{taskid = 300506 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300507) ->
   #task{taskid = 300507 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300508) ->
   #task{taskid = 300508 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300509) ->
   #task{taskid = 300509 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300510) ->
   #task{taskid = 300510 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300511) ->
   #task{taskid = 300511 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300512) ->
   #task{taskid = 300512 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300513) ->
   #task{taskid = 300513 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300514) ->
   #task{taskid = 300514 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300515) ->
   #task{taskid = 300515 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300516) ->
   #task{taskid = 300516 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300517) ->
   #task{taskid = 300517 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300518) ->
   #task{taskid = 300518 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300519) ->
   #task{taskid = 300519 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300520) ->
   #task{taskid = 300520 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300521) ->
   #task{taskid = 300521 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300522) ->
   #task{taskid = 300522 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300523) ->
   #task{taskid = 300523 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300524) ->
   #task{taskid = 300524 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300525) ->
   #task{taskid = 300525 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300526) ->
   #task{taskid = 300526 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300527) ->
   #task{taskid = 300527 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300528) ->
   #task{taskid = 300528 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300529) ->
   #task{taskid = 300529 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300530) ->
   #task{taskid = 300530 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,20300}] };
get(300601) ->
   #task{taskid = 300601 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300602) ->
   #task{taskid = 300602 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300603) ->
   #task{taskid = 300603 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300604) ->
   #task{taskid = 300604 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300605) ->
   #task{taskid = 300605 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300606) ->
   #task{taskid = 300606 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300607) ->
   #task{taskid = 300607 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300608) ->
   #task{taskid = 300608 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300609) ->
   #task{taskid = 300609 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300610) ->
   #task{taskid = 300610 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300611) ->
   #task{taskid = 300611 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300612) ->
   #task{taskid = 300612 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300613) ->
   #task{taskid = 300613 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300614) ->
   #task{taskid = 300614 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300615) ->
   #task{taskid = 300615 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300616) ->
   #task{taskid = 300616 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300617) ->
   #task{taskid = 300617 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300618) ->
   #task{taskid = 300618 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300619) ->
   #task{taskid = 300619 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300620) ->
   #task{taskid = 300620 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300621) ->
   #task{taskid = 300621 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300622) ->
   #task{taskid = 300622 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300623) ->
   #task{taskid = 300623 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300624) ->
   #task{taskid = 300624 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300625) ->
   #task{taskid = 300625 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300626) ->
   #task{taskid = 300626 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300627) ->
   #task{taskid = 300627 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300628) ->
   #task{taskid = 300628 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300629) ->
   #task{taskid = 300629 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300630) ->
   #task{taskid = 300630 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,22400}] };
get(300701) ->
   #task{taskid = 300701 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300702) ->
   #task{taskid = 300702 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300703) ->
   #task{taskid = 300703 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300704) ->
   #task{taskid = 300704 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300705) ->
   #task{taskid = 300705 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300706) ->
   #task{taskid = 300706 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300707) ->
   #task{taskid = 300707 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300708) ->
   #task{taskid = 300708 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300709) ->
   #task{taskid = 300709 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300710) ->
   #task{taskid = 300710 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300711) ->
   #task{taskid = 300711 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300712) ->
   #task{taskid = 300712 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300713) ->
   #task{taskid = 300713 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300714) ->
   #task{taskid = 300714 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300715) ->
   #task{taskid = 300715 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300716) ->
   #task{taskid = 300716 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300717) ->
   #task{taskid = 300717 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300718) ->
   #task{taskid = 300718 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300719) ->
   #task{taskid = 300719 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300720) ->
   #task{taskid = 300720 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300721) ->
   #task{taskid = 300721 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300722) ->
   #task{taskid = 300722 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300723) ->
   #task{taskid = 300723 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300724) ->
   #task{taskid = 300724 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300725) ->
   #task{taskid = 300725 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300726) ->
   #task{taskid = 300726 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300727) ->
   #task{taskid = 300727 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300728) ->
   #task{taskid = 300728 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300729) ->
   #task{taskid = 300729 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300730) ->
   #task{taskid = 300730 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,24000}] };
get(300801) ->
   #task{taskid = 300801 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300802) ->
   #task{taskid = 300802 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300803) ->
   #task{taskid = 300803 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300804) ->
   #task{taskid = 300804 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300805) ->
   #task{taskid = 300805 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300806) ->
   #task{taskid = 300806 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300807) ->
   #task{taskid = 300807 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300808) ->
   #task{taskid = 300808 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26008,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300809) ->
   #task{taskid = 300809 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26009,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300810) ->
   #task{taskid = 300810 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26010,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300811) ->
   #task{taskid = 300811 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26011,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300812) ->
   #task{taskid = 300812 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300813) ->
   #task{taskid = 300813 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300814) ->
   #task{taskid = 300814 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300815) ->
   #task{taskid = 300815 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300816) ->
   #task{taskid = 300816 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300817) ->
   #task{taskid = 300817 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300818) ->
   #task{taskid = 300818 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300819) ->
   #task{taskid = 300819 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300820) ->
   #task{taskid = 300820 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300821) ->
   #task{taskid = 300821 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300822) ->
   #task{taskid = 300822 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300823) ->
   #task{taskid = 300823 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300824) ->
   #task{taskid = 300824 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26008,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300825) ->
   #task{taskid = 300825 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26009,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300826) ->
   #task{taskid = 300826 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26010,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300827) ->
   #task{taskid = 300827 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26011,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300828) ->
   #task{taskid = 300828 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300829) ->
   #task{taskid = 300829 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300830) ->
   #task{taskid = 300830 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,35000}] };
get(300901) ->
   #task{taskid = 300901 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300902) ->
   #task{taskid = 300902 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300903) ->
   #task{taskid = 300903 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300904) ->
   #task{taskid = 300904 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300905) ->
   #task{taskid = 300905 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300906) ->
   #task{taskid = 300906 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300907) ->
   #task{taskid = 300907 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300908) ->
   #task{taskid = 300908 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300909) ->
   #task{taskid = 300909 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300910) ->
   #task{taskid = 300910 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300911) ->
   #task{taskid = 300911 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300912) ->
   #task{taskid = 300912 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300913) ->
   #task{taskid = 300913 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300914) ->
   #task{taskid = 300914 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300915) ->
   #task{taskid = 300915 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300916) ->
   #task{taskid = 300916 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300917) ->
   #task{taskid = 300917 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300918) ->
   #task{taskid = 300918 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300919) ->
   #task{taskid = 300919 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300920) ->
   #task{taskid = 300920 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300921) ->
   #task{taskid = 300921 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300922) ->
   #task{taskid = 300922 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300923) ->
   #task{taskid = 300923 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300924) ->
   #task{taskid = 300924 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300925) ->
   #task{taskid = 300925 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300926) ->
   #task{taskid = 300926 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300927) ->
   #task{taskid = 300927 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300928) ->
   #task{taskid = 300928 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300929) ->
   #task{taskid = 300929 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(300930) ->
   #task{taskid = 300930 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,61300}] };
get(301001) ->
   #task{taskid = 301001 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301002) ->
   #task{taskid = 301002 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301003) ->
   #task{taskid = 301003 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301004) ->
   #task{taskid = 301004 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301005) ->
   #task{taskid = 301005 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301006) ->
   #task{taskid = 301006 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301007) ->
   #task{taskid = 301007 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301008) ->
   #task{taskid = 301008 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301009) ->
   #task{taskid = 301009 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301010) ->
   #task{taskid = 301010 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301011) ->
   #task{taskid = 301011 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301012) ->
   #task{taskid = 301012 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301013) ->
   #task{taskid = 301013 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301014) ->
   #task{taskid = 301014 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301015) ->
   #task{taskid = 301015 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301016) ->
   #task{taskid = 301016 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301017) ->
   #task{taskid = 301017 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301018) ->
   #task{taskid = 301018 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301019) ->
   #task{taskid = 301019 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301020) ->
   #task{taskid = 301020 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301021) ->
   #task{taskid = 301021 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301022) ->
   #task{taskid = 301022 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301023) ->
   #task{taskid = 301023 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301024) ->
   #task{taskid = 301024 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301025) ->
   #task{taskid = 301025 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301026) ->
   #task{taskid = 301026 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301027) ->
   #task{taskid = 301027 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301028) ->
   #task{taskid = 301028 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301029) ->
   #task{taskid = 301029 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301030) ->
   #task{taskid = 301030 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,85400}] };
get(301101) ->
   #task{taskid = 301101 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301102) ->
   #task{taskid = 301102 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301103) ->
   #task{taskid = 301103 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301104) ->
   #task{taskid = 301104 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301105) ->
   #task{taskid = 301105 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301106) ->
   #task{taskid = 301106 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301107) ->
   #task{taskid = 301107 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301108) ->
   #task{taskid = 301108 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301109) ->
   #task{taskid = 301109 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301110) ->
   #task{taskid = 301110 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301111) ->
   #task{taskid = 301111 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301112) ->
   #task{taskid = 301112 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301113) ->
   #task{taskid = 301113 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301114) ->
   #task{taskid = 301114 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301115) ->
   #task{taskid = 301115 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301116) ->
   #task{taskid = 301116 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301117) ->
   #task{taskid = 301117 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301118) ->
   #task{taskid = 301118 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301119) ->
   #task{taskid = 301119 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301120) ->
   #task{taskid = 301120 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301121) ->
   #task{taskid = 301121 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301122) ->
   #task{taskid = 301122 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301123) ->
   #task{taskid = 301123 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301124) ->
   #task{taskid = 301124 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301125) ->
   #task{taskid = 301125 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301126) ->
   #task{taskid = 301126 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301127) ->
   #task{taskid = 301127 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301128) ->
   #task{taskid = 301128 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301129) ->
   #task{taskid = 301129 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301130) ->
   #task{taskid = 301130 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,114100}] };
get(301201) ->
   #task{taskid = 301201 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301202) ->
   #task{taskid = 301202 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301203) ->
   #task{taskid = 301203 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301204) ->
   #task{taskid = 301204 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301205) ->
   #task{taskid = 301205 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301206) ->
   #task{taskid = 301206 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301207) ->
   #task{taskid = 301207 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301208) ->
   #task{taskid = 301208 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301209) ->
   #task{taskid = 301209 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301210) ->
   #task{taskid = 301210 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301211) ->
   #task{taskid = 301211 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301212) ->
   #task{taskid = 301212 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301213) ->
   #task{taskid = 301213 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301214) ->
   #task{taskid = 301214 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301215) ->
   #task{taskid = 301215 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301216) ->
   #task{taskid = 301216 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301217) ->
   #task{taskid = 301217 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301218) ->
   #task{taskid = 301218 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301219) ->
   #task{taskid = 301219 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301220) ->
   #task{taskid = 301220 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301221) ->
   #task{taskid = 301221 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301222) ->
   #task{taskid = 301222 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301223) ->
   #task{taskid = 301223 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301224) ->
   #task{taskid = 301224 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301225) ->
   #task{taskid = 301225 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301226) ->
   #task{taskid = 301226 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301227) ->
   #task{taskid = 301227 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301228) ->
   #task{taskid = 301228 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301229) ->
   #task{taskid = 301229 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301230) ->
   #task{taskid = 301230 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,147200}] };
get(301301) ->
   #task{taskid = 301301 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301302) ->
   #task{taskid = 301302 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301303) ->
   #task{taskid = 301303 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301304) ->
   #task{taskid = 301304 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301305) ->
   #task{taskid = 301305 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301306) ->
   #task{taskid = 301306 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301307) ->
   #task{taskid = 301307 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301308) ->
   #task{taskid = 301308 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301309) ->
   #task{taskid = 301309 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301310) ->
   #task{taskid = 301310 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301311) ->
   #task{taskid = 301311 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301312) ->
   #task{taskid = 301312 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301313) ->
   #task{taskid = 301313 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301314) ->
   #task{taskid = 301314 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301315) ->
   #task{taskid = 301315 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301316) ->
   #task{taskid = 301316 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301317) ->
   #task{taskid = 301317 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301318) ->
   #task{taskid = 301318 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301319) ->
   #task{taskid = 301319 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301320) ->
   #task{taskid = 301320 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301321) ->
   #task{taskid = 301321 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301322) ->
   #task{taskid = 301322 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301323) ->
   #task{taskid = 301323 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301324) ->
   #task{taskid = 301324 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301325) ->
   #task{taskid = 301325 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301326) ->
   #task{taskid = 301326 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301327) ->
   #task{taskid = 301327 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301328) ->
   #task{taskid = 301328 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301329) ->
   #task{taskid = 301329 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301330) ->
   #task{taskid = 301330 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,184900}] };
get(301401) ->
   #task{taskid = 301401 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301402) ->
   #task{taskid = 301402 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301403) ->
   #task{taskid = 301403 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301404) ->
   #task{taskid = 301404 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301405) ->
   #task{taskid = 301405 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301406) ->
   #task{taskid = 301406 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301407) ->
   #task{taskid = 301407 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301408) ->
   #task{taskid = 301408 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301409) ->
   #task{taskid = 301409 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301410) ->
   #task{taskid = 301410 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301411) ->
   #task{taskid = 301411 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301412) ->
   #task{taskid = 301412 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301413) ->
   #task{taskid = 301413 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301414) ->
   #task{taskid = 301414 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301415) ->
   #task{taskid = 301415 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301416) ->
   #task{taskid = 301416 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301417) ->
   #task{taskid = 301417 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301418) ->
   #task{taskid = 301418 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301419) ->
   #task{taskid = 301419 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301420) ->
   #task{taskid = 301420 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301421) ->
   #task{taskid = 301421 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301422) ->
   #task{taskid = 301422 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301423) ->
   #task{taskid = 301423 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301424) ->
   #task{taskid = 301424 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301425) ->
   #task{taskid = 301425 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301426) ->
   #task{taskid = 301426 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301427) ->
   #task{taskid = 301427 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301428) ->
   #task{taskid = 301428 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301429) ->
   #task{taskid = 301429 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301430) ->
   #task{taskid = 301430 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,242100}] };
get(301501) ->
   #task{taskid = 301501 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301502) ->
   #task{taskid = 301502 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301503) ->
   #task{taskid = 301503 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301504) ->
   #task{taskid = 301504 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301505) ->
   #task{taskid = 301505 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301506) ->
   #task{taskid = 301506 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301507) ->
   #task{taskid = 301507 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301508) ->
   #task{taskid = 301508 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301509) ->
   #task{taskid = 301509 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301510) ->
   #task{taskid = 301510 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301511) ->
   #task{taskid = 301511 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301512) ->
   #task{taskid = 301512 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301513) ->
   #task{taskid = 301513 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301514) ->
   #task{taskid = 301514 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301515) ->
   #task{taskid = 301515 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301516) ->
   #task{taskid = 301516 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301517) ->
   #task{taskid = 301517 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301518) ->
   #task{taskid = 301518 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301519) ->
   #task{taskid = 301519 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301520) ->
   #task{taskid = 301520 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301521) ->
   #task{taskid = 301521 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301522) ->
   #task{taskid = 301522 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301523) ->
   #task{taskid = 301523 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301524) ->
   #task{taskid = 301524 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301525) ->
   #task{taskid = 301525 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301526) ->
   #task{taskid = 301526 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301527) ->
   #task{taskid = 301527 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301528) ->
   #task{taskid = 301528 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301529) ->
   #task{taskid = 301529 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301530) ->
   #task{taskid = 301530 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,307300}] };
get(301601) ->
   #task{taskid = 301601 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301602) ->
   #task{taskid = 301602 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301603) ->
   #task{taskid = 301603 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301604) ->
   #task{taskid = 301604 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301605) ->
   #task{taskid = 301605 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301606) ->
   #task{taskid = 301606 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301607) ->
   #task{taskid = 301607 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301608) ->
   #task{taskid = 301608 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301609) ->
   #task{taskid = 301609 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301610) ->
   #task{taskid = 301610 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301611) ->
   #task{taskid = 301611 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301612) ->
   #task{taskid = 301612 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301613) ->
   #task{taskid = 301613 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301614) ->
   #task{taskid = 301614 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301615) ->
   #task{taskid = 301615 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301616) ->
   #task{taskid = 301616 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301617) ->
   #task{taskid = 301617 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301618) ->
   #task{taskid = 301618 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301619) ->
   #task{taskid = 301619 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301620) ->
   #task{taskid = 301620 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301621) ->
   #task{taskid = 301621 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301622) ->
   #task{taskid = 301622 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301623) ->
   #task{taskid = 301623 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301624) ->
   #task{taskid = 301624 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301625) ->
   #task{taskid = 301625 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301626) ->
   #task{taskid = 301626 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301627) ->
   #task{taskid = 301627 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301628) ->
   #task{taskid = 301628 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301629) ->
   #task{taskid = 301629 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301630) ->
   #task{taskid = 301630 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,420100}] };
get(301701) ->
   #task{taskid = 301701 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301702) ->
   #task{taskid = 301702 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301703) ->
   #task{taskid = 301703 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301704) ->
   #task{taskid = 301704 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301705) ->
   #task{taskid = 301705 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301706) ->
   #task{taskid = 301706 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301707) ->
   #task{taskid = 301707 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301708) ->
   #task{taskid = 301708 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301709) ->
   #task{taskid = 301709 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301710) ->
   #task{taskid = 301710 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301711) ->
   #task{taskid = 301711 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301712) ->
   #task{taskid = 301712 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301713) ->
   #task{taskid = 301713 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301714) ->
   #task{taskid = 301714 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301715) ->
   #task{taskid = 301715 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301716) ->
   #task{taskid = 301716 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301717) ->
   #task{taskid = 301717 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301718) ->
   #task{taskid = 301718 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301719) ->
   #task{taskid = 301719 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301720) ->
   #task{taskid = 301720 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301721) ->
   #task{taskid = 301721 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301722) ->
   #task{taskid = 301722 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301723) ->
   #task{taskid = 301723 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301724) ->
   #task{taskid = 301724 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301725) ->
   #task{taskid = 301725 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301726) ->
   #task{taskid = 301726 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301727) ->
   #task{taskid = 301727 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301728) ->
   #task{taskid = 301728 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301729) ->
   #task{taskid = 301729 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301730) ->
   #task{taskid = 301730 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,550900}] };
get(301801) ->
   #task{taskid = 301801 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301802) ->
   #task{taskid = 301802 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301803) ->
   #task{taskid = 301803 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301804) ->
   #task{taskid = 301804 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301805) ->
   #task{taskid = 301805 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301806) ->
   #task{taskid = 301806 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301807) ->
   #task{taskid = 301807 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301808) ->
   #task{taskid = 301808 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301809) ->
   #task{taskid = 301809 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301810) ->
   #task{taskid = 301810 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301811) ->
   #task{taskid = 301811 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301812) ->
   #task{taskid = 301812 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301813) ->
   #task{taskid = 301813 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301814) ->
   #task{taskid = 301814 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301815) ->
   #task{taskid = 301815 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301816) ->
   #task{taskid = 301816 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301817) ->
   #task{taskid = 301817 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301818) ->
   #task{taskid = 301818 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301819) ->
   #task{taskid = 301819 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301820) ->
   #task{taskid = 301820 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301821) ->
   #task{taskid = 301821 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301822) ->
   #task{taskid = 301822 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301823) ->
   #task{taskid = 301823 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301824) ->
   #task{taskid = 301824 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301825) ->
   #task{taskid = 301825 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301826) ->
   #task{taskid = 301826 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301827) ->
   #task{taskid = 301827 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301828) ->
   #task{taskid = 301828 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301829) ->
   #task{taskid = 301829 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301830) ->
   #task{taskid = 301830 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,699700}] };
get(301901) ->
   #task{taskid = 301901 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301902) ->
   #task{taskid = 301902 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301903) ->
   #task{taskid = 301903 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301904) ->
   #task{taskid = 301904 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301905) ->
   #task{taskid = 301905 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301906) ->
   #task{taskid = 301906 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301907) ->
   #task{taskid = 301907 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301908) ->
   #task{taskid = 301908 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301909) ->
   #task{taskid = 301909 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301910) ->
   #task{taskid = 301910 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301911) ->
   #task{taskid = 301911 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301912) ->
   #task{taskid = 301912 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301913) ->
   #task{taskid = 301913 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301914) ->
   #task{taskid = 301914 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301915) ->
   #task{taskid = 301915 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301916) ->
   #task{taskid = 301916 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301917) ->
   #task{taskid = 301917 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301918) ->
   #task{taskid = 301918 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301919) ->
   #task{taskid = 301919 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301920) ->
   #task{taskid = 301920 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301921) ->
   #task{taskid = 301921 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301922) ->
   #task{taskid = 301922 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301923) ->
   #task{taskid = 301923 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301924) ->
   #task{taskid = 301924 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301925) ->
   #task{taskid = 301925 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301926) ->
   #task{taskid = 301926 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301927) ->
   #task{taskid = 301927 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301928) ->
   #task{taskid = 301928 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301929) ->
   #task{taskid = 301929 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(301930) ->
   #task{taskid = 301930 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,866500}] };
get(302001) ->
   #task{taskid = 302001 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302002) ->
   #task{taskid = 302002 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302003) ->
   #task{taskid = 302003 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302004) ->
   #task{taskid = 302004 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302005) ->
   #task{taskid = 302005 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302006) ->
   #task{taskid = 302006 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302007) ->
   #task{taskid = 302007 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302008) ->
   #task{taskid = 302008 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302009) ->
   #task{taskid = 302009 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302010) ->
   #task{taskid = 302010 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302011) ->
   #task{taskid = 302011 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302012) ->
   #task{taskid = 302012 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302013) ->
   #task{taskid = 302013 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302014) ->
   #task{taskid = 302014 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302015) ->
   #task{taskid = 302015 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302016) ->
   #task{taskid = 302016 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302017) ->
   #task{taskid = 302017 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302018) ->
   #task{taskid = 302018 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302019) ->
   #task{taskid = 302019 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302020) ->
   #task{taskid = 302020 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302021) ->
   #task{taskid = 302021 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302022) ->
   #task{taskid = 302022 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302023) ->
   #task{taskid = 302023 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302024) ->
   #task{taskid = 302024 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302025) ->
   #task{taskid = 302025 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302026) ->
   #task{taskid = 302026 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302027) ->
   #task{taskid = 302027 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302028) ->
   #task{taskid = 302028 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302029) ->
   #task{taskid = 302029 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302030) ->
   #task{taskid = 302030 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1051300}] };
get(302101) ->
   #task{taskid = 302101 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302102) ->
   #task{taskid = 302102 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302103) ->
   #task{taskid = 302103 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302104) ->
   #task{taskid = 302104 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302105) ->
   #task{taskid = 302105 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302106) ->
   #task{taskid = 302106 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302107) ->
   #task{taskid = 302107 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302108) ->
   #task{taskid = 302108 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302109) ->
   #task{taskid = 302109 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302110) ->
   #task{taskid = 302110 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302111) ->
   #task{taskid = 302111 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302112) ->
   #task{taskid = 302112 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302113) ->
   #task{taskid = 302113 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302114) ->
   #task{taskid = 302114 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302115) ->
   #task{taskid = 302115 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302116) ->
   #task{taskid = 302116 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302117) ->
   #task{taskid = 302117 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302118) ->
   #task{taskid = 302118 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302119) ->
   #task{taskid = 302119 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302120) ->
   #task{taskid = 302120 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302121) ->
   #task{taskid = 302121 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302122) ->
   #task{taskid = 302122 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302123) ->
   #task{taskid = 302123 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302124) ->
   #task{taskid = 302124 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302125) ->
   #task{taskid = 302125 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302126) ->
   #task{taskid = 302126 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302127) ->
   #task{taskid = 302127 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302128) ->
   #task{taskid = 302128 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302129) ->
   #task{taskid = 302129 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(302130) ->
   #task{taskid = 302130 ,name = ?T("日常任务") ,type = 3 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,1184500}] };
get(_) -> [].