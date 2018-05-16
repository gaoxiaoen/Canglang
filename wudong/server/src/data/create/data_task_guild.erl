%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_guild
	%%% @Created : 2017-11-02 11:53:40
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_guild).
-export([get/1]).
-export([task_ids/0]).
-include("common.hrl").
-include("task.hrl").
task_ids() ->[400101,400102,400103,400104,400105,400106,400107,400108,400109,400110,400111,400112,400113,400114,400115,400116,400117,400118,400119,400120,400121,400122,400123,400124,400125,400126,400127,400128,400129,400130,400201,400202,400203,400204,400205,400206,400207,400208,400209,400210,400211,400212,400213,400214,400215,400216,400217,400218,400219,400220,400221,400222,400223,400224,400225,400226,400227,400228,400229,400230,400301,400302,400303,400304,400305,400306,400307,400308,400309,400310,400311,400312,400313,400314,400315,400316,400317,400318,400319,400320,400321,400322,400323,400324,400325,400326,400327,400328,400329,400330,400401,400402,400403,400404,400405,400406,400407,400408,400409,400410,400411,400412,400413,400414,400415,400416,400417,400418,400419,400420,400421,400422,400423,400424,400425,400426,400427,400428,400429,400430,400501,400502,400503,400504,400505,400506,400507,400508,400509,400510,400511,400512,400513,400514,400515,400516,400517,400518,400519,400520,400521,400522,400523,400524,400525,400526,400527,400528,400529,400530,400601,400602,400603,400604,400605,400606,400607,400608,400609,400610,400611,400612,400613,400614,400615,400616,400617,400618,400619,400620,400621,400622,400623,400624,400625,400626,400627,400628,400629,400630,400701,400702,400703,400704,400705,400706,400707,400708,400709,400710,400711,400712,400713,400714,400715,400716,400717,400718,400719,400720,400721,400722,400723,400724,400725,400726,400727,400728,400729,400730,400801,400802,400803,400804,400805,400806,400807,400808,400809,400810,400811,400812,400813,400814,400815,400816,400817,400818,400819,400820,400821,400822,400823,400824,400825,400826,400827,400828,400829,400830,400901,400902,400903,400904,400905,400906,400907,400908,400909,400910,400911,400912,400913,400914,400915,400916,400917,400918,400919,400920,400921,400922,400923,400924,400925,400926,400927,400928,400929,400930,401001,401002,401003,401004,401005,401006,401007,401008,401009,401010,401011,401012,401013,401014,401015,401016,401017,401018,401019,401020,401021,401022,401023,401024,401025,401026,401027,401028,401029,401030,401101,401102,401103,401104,401105,401106,401107,401108,401109,401110,401111,401112,401113,401114,401115,401116,401117,401118,401119,401120,401121,401122,401123,401124,401125,401126,401127,401128,401129,401130,401201,401202,401203,401204,401205,401206,401207,401208,401209,401210,401211,401212,401213,401214,401215,401216,401217,401218,401219,401220,401221,401222,401223,401224,401225,401226,401227,401228,401229,401230,401301,401302,401303,401304,401305,401306,401307,401308,401309,401310,401311,401312,401313,401314,401315,401316,401317,401318,401319,401320,401321,401322,401323,401324,401325,401326,401327,401328,401329,401330,401401,401402,401403,401404,401405,401406,401407,401408,401409,401410,401411,401412,401413,401414,401415,401416,401417,401418,401419,401420,401421,401422,401423,401424,401425,401426,401427,401428,401429,401430,401501,401502,401503,401504,401505,401506,401507,401508,401509,401510,401511,401512,401513,401514,401515,401516,401517,401518,401519,401520,401521,401522,401523,401524,401525,401526,401527,401528,401529,401530,401601,401602,401603,401604,401605,401606,401607,401608,401609,401610,401611,401612,401613,401614,401615,401616,401617,401618,401619,401620,401621,401622,401623,401624,401625,401626,401627,401628,401629,401630,401701,401702,401703,401704,401705,401706,401707,401708,401709,401710,401711,401712,401713,401714,401715,401716,401717,401718,401719,401720,401721,401722,401723,401724,401725,401726,401727,401728,401729,401730,401801,401802,401803,401804,401805,401806,401807,401808,401809,401810,401811,401812,401813,401814,401815,401816,401817,401818,401819,401820,401821,401822,401823,401824,401825,401826,401827,401828,401829,401830,401901,401902,401903,401904,401905,401906,401907,401908,401909,401910,401911,401912,401913,401914,401915,401916,401917,401918,401919,401920,401921,401922,401923,401924,401925,401926,401927,401928,401929,401930,402001,402002,402003,402004,402005,402006,402007,402008,402009,402010,402011,402012,402013,402014,402015,402016,402017,402018,402019,402020,402021,402022,402023,402024,402025,402026,402027,402028,402029,402030,402101,402102,402103,402104,402105,402106,402107,402108,402109,402110,402111,402112,402113,402114,402115,402116,402117,402118,402119,402120,402121,402122,402123,402124,402125,402126,402127,402128,402129,402130].

get(400101) ->
   #task{taskid = 400101 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24022,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400102) ->
   #task{taskid = 400102 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24021,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400103) ->
   #task{taskid = 400103 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24001,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400104) ->
   #task{taskid = 400104 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24005,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400105) ->
   #task{taskid = 400105 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24018,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400106) ->
   #task{taskid = 400106 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23016,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400107) ->
   #task{taskid = 400107 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23017,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400108) ->
   #task{taskid = 400108 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23014,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400109) ->
   #task{taskid = 400109 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23004,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400110) ->
   #task{taskid = 400110 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23005,30}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400111) ->
   #task{taskid = 400111 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25009,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400112) ->
   #task{taskid = 400112 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400113) ->
   #task{taskid = 400113 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25008,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400114) ->
   #task{taskid = 400114 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400115) ->
   #task{taskid = 400115 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400116) ->
   #task{taskid = 400116 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24022,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400117) ->
   #task{taskid = 400117 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24021,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400118) ->
   #task{taskid = 400118 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400119) ->
   #task{taskid = 400119 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24005,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400120) ->
   #task{taskid = 400120 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,24018,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400121) ->
   #task{taskid = 400121 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23016,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400122) ->
   #task{taskid = 400122 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23017,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400123) ->
   #task{taskid = 400123 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23014,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400124) ->
   #task{taskid = 400124 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23004,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400125) ->
   #task{taskid = 400125 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,23005,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400126) ->
   #task{taskid = 400126 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25009,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400127) ->
   #task{taskid = 400127 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25007,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400128) ->
   #task{taskid = 400128 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25008,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400129) ->
   #task{taskid = 400129 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25013,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400130) ->
   #task{taskid = 400130 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,25014,50}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,6200},{0,1014000,2}] };
get(400201) ->
   #task{taskid = 400201 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400202) ->
   #task{taskid = 400202 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400203) ->
   #task{taskid = 400203 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400204) ->
   #task{taskid = 400204 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400205) ->
   #task{taskid = 400205 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400206) ->
   #task{taskid = 400206 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400207) ->
   #task{taskid = 400207 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400208) ->
   #task{taskid = 400208 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400209) ->
   #task{taskid = 400209 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400210) ->
   #task{taskid = 400210 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400211) ->
   #task{taskid = 400211 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400212) ->
   #task{taskid = 400212 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400213) ->
   #task{taskid = 400213 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400214) ->
   #task{taskid = 400214 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400215) ->
   #task{taskid = 400215 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400216) ->
   #task{taskid = 400216 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400217) ->
   #task{taskid = 400217 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400218) ->
   #task{taskid = 400218 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400219) ->
   #task{taskid = 400219 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400220) ->
   #task{taskid = 400220 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400221) ->
   #task{taskid = 400221 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400222) ->
   #task{taskid = 400222 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400223) ->
   #task{taskid = 400223 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400224) ->
   #task{taskid = 400224 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400225) ->
   #task{taskid = 400225 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400226) ->
   #task{taskid = 400226 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400227) ->
   #task{taskid = 400227 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400228) ->
   #task{taskid = 400228 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400229) ->
   #task{taskid = 400229 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400230) ->
   #task{taskid = 400230 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,7400},{0,1014000,2}] };
get(400301) ->
   #task{taskid = 400301 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400302) ->
   #task{taskid = 400302 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400303) ->
   #task{taskid = 400303 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400304) ->
   #task{taskid = 400304 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400305) ->
   #task{taskid = 400305 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400306) ->
   #task{taskid = 400306 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400307) ->
   #task{taskid = 400307 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400308) ->
   #task{taskid = 400308 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400309) ->
   #task{taskid = 400309 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400310) ->
   #task{taskid = 400310 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400311) ->
   #task{taskid = 400311 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400312) ->
   #task{taskid = 400312 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400313) ->
   #task{taskid = 400313 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400314) ->
   #task{taskid = 400314 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400315) ->
   #task{taskid = 400315 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400316) ->
   #task{taskid = 400316 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400317) ->
   #task{taskid = 400317 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400318) ->
   #task{taskid = 400318 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400319) ->
   #task{taskid = 400319 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400320) ->
   #task{taskid = 400320 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400321) ->
   #task{taskid = 400321 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400322) ->
   #task{taskid = 400322 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400323) ->
   #task{taskid = 400323 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400324) ->
   #task{taskid = 400324 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27003,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400325) ->
   #task{taskid = 400325 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400326) ->
   #task{taskid = 400326 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400327) ->
   #task{taskid = 400327 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400328) ->
   #task{taskid = 400328 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400329) ->
   #task{taskid = 400329 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400330) ->
   #task{taskid = 400330 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,8200},{0,1014000,2}] };
get(400401) ->
   #task{taskid = 400401 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400402) ->
   #task{taskid = 400402 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400403) ->
   #task{taskid = 400403 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400404) ->
   #task{taskid = 400404 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400405) ->
   #task{taskid = 400405 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400406) ->
   #task{taskid = 400406 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400407) ->
   #task{taskid = 400407 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400408) ->
   #task{taskid = 400408 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400409) ->
   #task{taskid = 400409 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400410) ->
   #task{taskid = 400410 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400411) ->
   #task{taskid = 400411 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400412) ->
   #task{taskid = 400412 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400413) ->
   #task{taskid = 400413 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400414) ->
   #task{taskid = 400414 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400415) ->
   #task{taskid = 400415 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400416) ->
   #task{taskid = 400416 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400417) ->
   #task{taskid = 400417 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400418) ->
   #task{taskid = 400418 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400419) ->
   #task{taskid = 400419 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400420) ->
   #task{taskid = 400420 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400421) ->
   #task{taskid = 400421 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400422) ->
   #task{taskid = 400422 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400423) ->
   #task{taskid = 400423 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400424) ->
   #task{taskid = 400424 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400425) ->
   #task{taskid = 400425 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400426) ->
   #task{taskid = 400426 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27005,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400427) ->
   #task{taskid = 400427 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400428) ->
   #task{taskid = 400428 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400429) ->
   #task{taskid = 400429 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400430) ->
   #task{taskid = 400430 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,9100},{0,1014000,3}] };
get(400501) ->
   #task{taskid = 400501 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400502) ->
   #task{taskid = 400502 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400503) ->
   #task{taskid = 400503 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400504) ->
   #task{taskid = 400504 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400505) ->
   #task{taskid = 400505 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400506) ->
   #task{taskid = 400506 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400507) ->
   #task{taskid = 400507 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400508) ->
   #task{taskid = 400508 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400509) ->
   #task{taskid = 400509 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400510) ->
   #task{taskid = 400510 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400511) ->
   #task{taskid = 400511 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400512) ->
   #task{taskid = 400512 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400513) ->
   #task{taskid = 400513 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400514) ->
   #task{taskid = 400514 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400515) ->
   #task{taskid = 400515 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400516) ->
   #task{taskid = 400516 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400517) ->
   #task{taskid = 400517 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400518) ->
   #task{taskid = 400518 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400519) ->
   #task{taskid = 400519 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400520) ->
   #task{taskid = 400520 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400521) ->
   #task{taskid = 400521 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400522) ->
   #task{taskid = 400522 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400523) ->
   #task{taskid = 400523 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400524) ->
   #task{taskid = 400524 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400525) ->
   #task{taskid = 400525 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400526) ->
   #task{taskid = 400526 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400527) ->
   #task{taskid = 400527 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400528) ->
   #task{taskid = 400528 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400529) ->
   #task{taskid = 400529 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400530) ->
   #task{taskid = 400530 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,10100},{0,1014000,3}] };
get(400601) ->
   #task{taskid = 400601 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400602) ->
   #task{taskid = 400602 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400603) ->
   #task{taskid = 400603 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400604) ->
   #task{taskid = 400604 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400605) ->
   #task{taskid = 400605 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400606) ->
   #task{taskid = 400606 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400607) ->
   #task{taskid = 400607 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400608) ->
   #task{taskid = 400608 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400609) ->
   #task{taskid = 400609 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400610) ->
   #task{taskid = 400610 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400611) ->
   #task{taskid = 400611 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400612) ->
   #task{taskid = 400612 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400613) ->
   #task{taskid = 400613 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400614) ->
   #task{taskid = 400614 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400615) ->
   #task{taskid = 400615 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400616) ->
   #task{taskid = 400616 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400617) ->
   #task{taskid = 400617 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400618) ->
   #task{taskid = 400618 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400619) ->
   #task{taskid = 400619 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400620) ->
   #task{taskid = 400620 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400621) ->
   #task{taskid = 400621 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400622) ->
   #task{taskid = 400622 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400623) ->
   #task{taskid = 400623 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400624) ->
   #task{taskid = 400624 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400625) ->
   #task{taskid = 400625 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400626) ->
   #task{taskid = 400626 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400627) ->
   #task{taskid = 400627 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400628) ->
   #task{taskid = 400628 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400629) ->
   #task{taskid = 400629 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400630) ->
   #task{taskid = 400630 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,11200},{0,1014000,3}] };
get(400701) ->
   #task{taskid = 400701 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400702) ->
   #task{taskid = 400702 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400703) ->
   #task{taskid = 400703 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400704) ->
   #task{taskid = 400704 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400705) ->
   #task{taskid = 400705 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400706) ->
   #task{taskid = 400706 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400707) ->
   #task{taskid = 400707 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400708) ->
   #task{taskid = 400708 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400709) ->
   #task{taskid = 400709 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400710) ->
   #task{taskid = 400710 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400711) ->
   #task{taskid = 400711 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400712) ->
   #task{taskid = 400712 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400713) ->
   #task{taskid = 400713 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400714) ->
   #task{taskid = 400714 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400715) ->
   #task{taskid = 400715 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400716) ->
   #task{taskid = 400716 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400717) ->
   #task{taskid = 400717 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400718) ->
   #task{taskid = 400718 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400719) ->
   #task{taskid = 400719 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400720) ->
   #task{taskid = 400720 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400721) ->
   #task{taskid = 400721 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400722) ->
   #task{taskid = 400722 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400723) ->
   #task{taskid = 400723 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400724) ->
   #task{taskid = 400724 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400725) ->
   #task{taskid = 400725 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400726) ->
   #task{taskid = 400726 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400727) ->
   #task{taskid = 400727 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400728) ->
   #task{taskid = 400728 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400729) ->
   #task{taskid = 400729 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27006,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400730) ->
   #task{taskid = 400730 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,27007,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,12000},{0,1014000,3}] };
get(400801) ->
   #task{taskid = 400801 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400802) ->
   #task{taskid = 400802 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400803) ->
   #task{taskid = 400803 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400804) ->
   #task{taskid = 400804 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400805) ->
   #task{taskid = 400805 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400806) ->
   #task{taskid = 400806 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26006,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400807) ->
   #task{taskid = 400807 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26007,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400808) ->
   #task{taskid = 400808 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26008,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400809) ->
   #task{taskid = 400809 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26009,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400810) ->
   #task{taskid = 400810 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26010,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400811) ->
   #task{taskid = 400811 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26011,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400812) ->
   #task{taskid = 400812 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400813) ->
   #task{taskid = 400813 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400814) ->
   #task{taskid = 400814 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400815) ->
   #task{taskid = 400815 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400816) ->
   #task{taskid = 400816 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400817) ->
   #task{taskid = 400817 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26001,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400818) ->
   #task{taskid = 400818 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26002,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400819) ->
   #task{taskid = 400819 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26003,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400820) ->
   #task{taskid = 400820 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26004,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400821) ->
   #task{taskid = 400821 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26005,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400822) ->
   #task{taskid = 400822 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26006,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400823) ->
   #task{taskid = 400823 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26007,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400824) ->
   #task{taskid = 400824 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26008,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400825) ->
   #task{taskid = 400825 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26009,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400826) ->
   #task{taskid = 400826 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26010,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400827) ->
   #task{taskid = 400827 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26011,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400828) ->
   #task{taskid = 400828 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400829) ->
   #task{taskid = 400829 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400830) ->
   #task{taskid = 400830 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,17500},{0,1014000,3}] };
get(400901) ->
   #task{taskid = 400901 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400902) ->
   #task{taskid = 400902 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400903) ->
   #task{taskid = 400903 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400904) ->
   #task{taskid = 400904 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400905) ->
   #task{taskid = 400905 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400906) ->
   #task{taskid = 400906 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400907) ->
   #task{taskid = 400907 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400908) ->
   #task{taskid = 400908 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400909) ->
   #task{taskid = 400909 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400910) ->
   #task{taskid = 400910 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400911) ->
   #task{taskid = 400911 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400912) ->
   #task{taskid = 400912 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400913) ->
   #task{taskid = 400913 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400914) ->
   #task{taskid = 400914 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400915) ->
   #task{taskid = 400915 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400916) ->
   #task{taskid = 400916 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400917) ->
   #task{taskid = 400917 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400918) ->
   #task{taskid = 400918 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400919) ->
   #task{taskid = 400919 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400920) ->
   #task{taskid = 400920 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400921) ->
   #task{taskid = 400921 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400922) ->
   #task{taskid = 400922 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400923) ->
   #task{taskid = 400923 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400924) ->
   #task{taskid = 400924 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400925) ->
   #task{taskid = 400925 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400926) ->
   #task{taskid = 400926 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400927) ->
   #task{taskid = 400927 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400928) ->
   #task{taskid = 400928 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400929) ->
   #task{taskid = 400929 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(400930) ->
   #task{taskid = 400930 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,30600},{0,1014000,4}] };
get(401001) ->
   #task{taskid = 401001 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401002) ->
   #task{taskid = 401002 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401003) ->
   #task{taskid = 401003 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401004) ->
   #task{taskid = 401004 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401005) ->
   #task{taskid = 401005 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401006) ->
   #task{taskid = 401006 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401007) ->
   #task{taskid = 401007 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401008) ->
   #task{taskid = 401008 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401009) ->
   #task{taskid = 401009 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401010) ->
   #task{taskid = 401010 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401011) ->
   #task{taskid = 401011 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401012) ->
   #task{taskid = 401012 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401013) ->
   #task{taskid = 401013 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401014) ->
   #task{taskid = 401014 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401015) ->
   #task{taskid = 401015 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401016) ->
   #task{taskid = 401016 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401017) ->
   #task{taskid = 401017 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401018) ->
   #task{taskid = 401018 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401019) ->
   #task{taskid = 401019 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401020) ->
   #task{taskid = 401020 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401021) ->
   #task{taskid = 401021 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401022) ->
   #task{taskid = 401022 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401023) ->
   #task{taskid = 401023 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401024) ->
   #task{taskid = 401024 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401025) ->
   #task{taskid = 401025 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401026) ->
   #task{taskid = 401026 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401027) ->
   #task{taskid = 401027 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401028) ->
   #task{taskid = 401028 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401029) ->
   #task{taskid = 401029 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401030) ->
   #task{taskid = 401030 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,42700},{0,1014000,4}] };
get(401101) ->
   #task{taskid = 401101 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401102) ->
   #task{taskid = 401102 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401103) ->
   #task{taskid = 401103 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401104) ->
   #task{taskid = 401104 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401105) ->
   #task{taskid = 401105 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401106) ->
   #task{taskid = 401106 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401107) ->
   #task{taskid = 401107 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401108) ->
   #task{taskid = 401108 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401109) ->
   #task{taskid = 401109 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401110) ->
   #task{taskid = 401110 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401111) ->
   #task{taskid = 401111 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401112) ->
   #task{taskid = 401112 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401113) ->
   #task{taskid = 401113 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401114) ->
   #task{taskid = 401114 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401115) ->
   #task{taskid = 401115 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401116) ->
   #task{taskid = 401116 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401117) ->
   #task{taskid = 401117 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401118) ->
   #task{taskid = 401118 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401119) ->
   #task{taskid = 401119 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401120) ->
   #task{taskid = 401120 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401121) ->
   #task{taskid = 401121 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401122) ->
   #task{taskid = 401122 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401123) ->
   #task{taskid = 401123 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401124) ->
   #task{taskid = 401124 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401125) ->
   #task{taskid = 401125 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401126) ->
   #task{taskid = 401126 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401127) ->
   #task{taskid = 401127 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401128) ->
   #task{taskid = 401128 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401129) ->
   #task{taskid = 401129 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401130) ->
   #task{taskid = 401130 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,57000},{0,1014000,4}] };
get(401201) ->
   #task{taskid = 401201 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401202) ->
   #task{taskid = 401202 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401203) ->
   #task{taskid = 401203 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401204) ->
   #task{taskid = 401204 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401205) ->
   #task{taskid = 401205 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401206) ->
   #task{taskid = 401206 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401207) ->
   #task{taskid = 401207 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401208) ->
   #task{taskid = 401208 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401209) ->
   #task{taskid = 401209 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401210) ->
   #task{taskid = 401210 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401211) ->
   #task{taskid = 401211 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401212) ->
   #task{taskid = 401212 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401213) ->
   #task{taskid = 401213 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401214) ->
   #task{taskid = 401214 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401215) ->
   #task{taskid = 401215 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401216) ->
   #task{taskid = 401216 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401217) ->
   #task{taskid = 401217 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401218) ->
   #task{taskid = 401218 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401219) ->
   #task{taskid = 401219 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401220) ->
   #task{taskid = 401220 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401221) ->
   #task{taskid = 401221 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401222) ->
   #task{taskid = 401222 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401223) ->
   #task{taskid = 401223 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401224) ->
   #task{taskid = 401224 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401225) ->
   #task{taskid = 401225 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401226) ->
   #task{taskid = 401226 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401227) ->
   #task{taskid = 401227 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401228) ->
   #task{taskid = 401228 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401229) ->
   #task{taskid = 401229 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401230) ->
   #task{taskid = 401230 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,73600},{0,1014000,4}] };
get(401301) ->
   #task{taskid = 401301 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401302) ->
   #task{taskid = 401302 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401303) ->
   #task{taskid = 401303 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401304) ->
   #task{taskid = 401304 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401305) ->
   #task{taskid = 401305 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401306) ->
   #task{taskid = 401306 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401307) ->
   #task{taskid = 401307 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401308) ->
   #task{taskid = 401308 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401309) ->
   #task{taskid = 401309 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401310) ->
   #task{taskid = 401310 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401311) ->
   #task{taskid = 401311 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401312) ->
   #task{taskid = 401312 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401313) ->
   #task{taskid = 401313 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401314) ->
   #task{taskid = 401314 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401315) ->
   #task{taskid = 401315 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401316) ->
   #task{taskid = 401316 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401317) ->
   #task{taskid = 401317 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401318) ->
   #task{taskid = 401318 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401319) ->
   #task{taskid = 401319 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401320) ->
   #task{taskid = 401320 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401321) ->
   #task{taskid = 401321 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401322) ->
   #task{taskid = 401322 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401323) ->
   #task{taskid = 401323 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401324) ->
   #task{taskid = 401324 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401325) ->
   #task{taskid = 401325 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401326) ->
   #task{taskid = 401326 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401327) ->
   #task{taskid = 401327 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401328) ->
   #task{taskid = 401328 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401329) ->
   #task{taskid = 401329 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401330) ->
   #task{taskid = 401330 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,92400},{0,1014000,4}] };
get(401401) ->
   #task{taskid = 401401 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401402) ->
   #task{taskid = 401402 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401403) ->
   #task{taskid = 401403 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401404) ->
   #task{taskid = 401404 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401405) ->
   #task{taskid = 401405 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401406) ->
   #task{taskid = 401406 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401407) ->
   #task{taskid = 401407 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401408) ->
   #task{taskid = 401408 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401409) ->
   #task{taskid = 401409 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401410) ->
   #task{taskid = 401410 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401411) ->
   #task{taskid = 401411 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401412) ->
   #task{taskid = 401412 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401413) ->
   #task{taskid = 401413 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401414) ->
   #task{taskid = 401414 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401415) ->
   #task{taskid = 401415 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401416) ->
   #task{taskid = 401416 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401417) ->
   #task{taskid = 401417 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401418) ->
   #task{taskid = 401418 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401419) ->
   #task{taskid = 401419 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401420) ->
   #task{taskid = 401420 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401421) ->
   #task{taskid = 401421 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401422) ->
   #task{taskid = 401422 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401423) ->
   #task{taskid = 401423 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401424) ->
   #task{taskid = 401424 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401425) ->
   #task{taskid = 401425 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401426) ->
   #task{taskid = 401426 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401427) ->
   #task{taskid = 401427 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401428) ->
   #task{taskid = 401428 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401429) ->
   #task{taskid = 401429 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401430) ->
   #task{taskid = 401430 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,121000},{0,1014000,5}] };
get(401501) ->
   #task{taskid = 401501 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401502) ->
   #task{taskid = 401502 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401503) ->
   #task{taskid = 401503 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401504) ->
   #task{taskid = 401504 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401505) ->
   #task{taskid = 401505 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401506) ->
   #task{taskid = 401506 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401507) ->
   #task{taskid = 401507 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401508) ->
   #task{taskid = 401508 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401509) ->
   #task{taskid = 401509 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401510) ->
   #task{taskid = 401510 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401511) ->
   #task{taskid = 401511 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401512) ->
   #task{taskid = 401512 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401513) ->
   #task{taskid = 401513 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401514) ->
   #task{taskid = 401514 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401515) ->
   #task{taskid = 401515 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401516) ->
   #task{taskid = 401516 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401517) ->
   #task{taskid = 401517 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401518) ->
   #task{taskid = 401518 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401519) ->
   #task{taskid = 401519 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401520) ->
   #task{taskid = 401520 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401521) ->
   #task{taskid = 401521 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401522) ->
   #task{taskid = 401522 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401523) ->
   #task{taskid = 401523 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401524) ->
   #task{taskid = 401524 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401525) ->
   #task{taskid = 401525 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401526) ->
   #task{taskid = 401526 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401527) ->
   #task{taskid = 401527 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401528) ->
   #task{taskid = 401528 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401529) ->
   #task{taskid = 401529 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401530) ->
   #task{taskid = 401530 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,153600},{0,1014000,5}] };
get(401601) ->
   #task{taskid = 401601 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401602) ->
   #task{taskid = 401602 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401603) ->
   #task{taskid = 401603 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401604) ->
   #task{taskid = 401604 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401605) ->
   #task{taskid = 401605 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401606) ->
   #task{taskid = 401606 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401607) ->
   #task{taskid = 401607 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401608) ->
   #task{taskid = 401608 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401609) ->
   #task{taskid = 401609 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401610) ->
   #task{taskid = 401610 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401611) ->
   #task{taskid = 401611 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401612) ->
   #task{taskid = 401612 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401613) ->
   #task{taskid = 401613 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401614) ->
   #task{taskid = 401614 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401615) ->
   #task{taskid = 401615 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401616) ->
   #task{taskid = 401616 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401617) ->
   #task{taskid = 401617 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401618) ->
   #task{taskid = 401618 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401619) ->
   #task{taskid = 401619 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401620) ->
   #task{taskid = 401620 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401621) ->
   #task{taskid = 401621 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401622) ->
   #task{taskid = 401622 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401623) ->
   #task{taskid = 401623 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401624) ->
   #task{taskid = 401624 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401625) ->
   #task{taskid = 401625 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401626) ->
   #task{taskid = 401626 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401627) ->
   #task{taskid = 401627 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401628) ->
   #task{taskid = 401628 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401629) ->
   #task{taskid = 401629 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401630) ->
   #task{taskid = 401630 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,210000},{0,1014000,5}] };
get(401701) ->
   #task{taskid = 401701 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401702) ->
   #task{taskid = 401702 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401703) ->
   #task{taskid = 401703 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401704) ->
   #task{taskid = 401704 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401705) ->
   #task{taskid = 401705 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401706) ->
   #task{taskid = 401706 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401707) ->
   #task{taskid = 401707 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401708) ->
   #task{taskid = 401708 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401709) ->
   #task{taskid = 401709 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401710) ->
   #task{taskid = 401710 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401711) ->
   #task{taskid = 401711 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401712) ->
   #task{taskid = 401712 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401713) ->
   #task{taskid = 401713 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401714) ->
   #task{taskid = 401714 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401715) ->
   #task{taskid = 401715 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401716) ->
   #task{taskid = 401716 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401717) ->
   #task{taskid = 401717 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401718) ->
   #task{taskid = 401718 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401719) ->
   #task{taskid = 401719 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401720) ->
   #task{taskid = 401720 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401721) ->
   #task{taskid = 401721 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401722) ->
   #task{taskid = 401722 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401723) ->
   #task{taskid = 401723 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401724) ->
   #task{taskid = 401724 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401725) ->
   #task{taskid = 401725 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401726) ->
   #task{taskid = 401726 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401727) ->
   #task{taskid = 401727 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401728) ->
   #task{taskid = 401728 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401729) ->
   #task{taskid = 401729 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401730) ->
   #task{taskid = 401730 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,275400},{0,1014000,5}] };
get(401801) ->
   #task{taskid = 401801 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401802) ->
   #task{taskid = 401802 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401803) ->
   #task{taskid = 401803 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401804) ->
   #task{taskid = 401804 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401805) ->
   #task{taskid = 401805 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401806) ->
   #task{taskid = 401806 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401807) ->
   #task{taskid = 401807 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401808) ->
   #task{taskid = 401808 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401809) ->
   #task{taskid = 401809 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401810) ->
   #task{taskid = 401810 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401811) ->
   #task{taskid = 401811 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401812) ->
   #task{taskid = 401812 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401813) ->
   #task{taskid = 401813 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401814) ->
   #task{taskid = 401814 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401815) ->
   #task{taskid = 401815 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401816) ->
   #task{taskid = 401816 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401817) ->
   #task{taskid = 401817 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401818) ->
   #task{taskid = 401818 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401819) ->
   #task{taskid = 401819 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401820) ->
   #task{taskid = 401820 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401821) ->
   #task{taskid = 401821 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401822) ->
   #task{taskid = 401822 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401823) ->
   #task{taskid = 401823 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401824) ->
   #task{taskid = 401824 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401825) ->
   #task{taskid = 401825 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401826) ->
   #task{taskid = 401826 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401827) ->
   #task{taskid = 401827 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401828) ->
   #task{taskid = 401828 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401829) ->
   #task{taskid = 401829 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401830) ->
   #task{taskid = 401830 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,349800},{0,1014000,5}] };
get(401901) ->
   #task{taskid = 401901 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401902) ->
   #task{taskid = 401902 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401903) ->
   #task{taskid = 401903 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401904) ->
   #task{taskid = 401904 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401905) ->
   #task{taskid = 401905 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401906) ->
   #task{taskid = 401906 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401907) ->
   #task{taskid = 401907 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401908) ->
   #task{taskid = 401908 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401909) ->
   #task{taskid = 401909 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401910) ->
   #task{taskid = 401910 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401911) ->
   #task{taskid = 401911 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401912) ->
   #task{taskid = 401912 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401913) ->
   #task{taskid = 401913 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401914) ->
   #task{taskid = 401914 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401915) ->
   #task{taskid = 401915 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401916) ->
   #task{taskid = 401916 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401917) ->
   #task{taskid = 401917 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401918) ->
   #task{taskid = 401918 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401919) ->
   #task{taskid = 401919 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401920) ->
   #task{taskid = 401920 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401921) ->
   #task{taskid = 401921 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401922) ->
   #task{taskid = 401922 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401923) ->
   #task{taskid = 401923 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401924) ->
   #task{taskid = 401924 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401925) ->
   #task{taskid = 401925 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401926) ->
   #task{taskid = 401926 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401927) ->
   #task{taskid = 401927 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401928) ->
   #task{taskid = 401928 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401929) ->
   #task{taskid = 401929 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(401930) ->
   #task{taskid = 401930 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,433200},{0,1014000,6}] };
get(402001) ->
   #task{taskid = 402001 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402002) ->
   #task{taskid = 402002 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402003) ->
   #task{taskid = 402003 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402004) ->
   #task{taskid = 402004 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402005) ->
   #task{taskid = 402005 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402006) ->
   #task{taskid = 402006 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402007) ->
   #task{taskid = 402007 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402008) ->
   #task{taskid = 402008 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402009) ->
   #task{taskid = 402009 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402010) ->
   #task{taskid = 402010 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402011) ->
   #task{taskid = 402011 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402012) ->
   #task{taskid = 402012 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402013) ->
   #task{taskid = 402013 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402014) ->
   #task{taskid = 402014 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402015) ->
   #task{taskid = 402015 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402016) ->
   #task{taskid = 402016 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402017) ->
   #task{taskid = 402017 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402018) ->
   #task{taskid = 402018 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402019) ->
   #task{taskid = 402019 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402020) ->
   #task{taskid = 402020 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402021) ->
   #task{taskid = 402021 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402022) ->
   #task{taskid = 402022 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402023) ->
   #task{taskid = 402023 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402024) ->
   #task{taskid = 402024 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402025) ->
   #task{taskid = 402025 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402026) ->
   #task{taskid = 402026 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402027) ->
   #task{taskid = 402027 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402028) ->
   #task{taskid = 402028 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402029) ->
   #task{taskid = 402029 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402030) ->
   #task{taskid = 402030 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,525600},{0,1014000,6}] };
get(402101) ->
   #task{taskid = 402101 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402102) ->
   #task{taskid = 402102 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402103) ->
   #task{taskid = 402103 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,40}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402104) ->
   #task{taskid = 402104 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402105) ->
   #task{taskid = 402105 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402106) ->
   #task{taskid = 402106 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402107) ->
   #task{taskid = 402107 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402108) ->
   #task{taskid = 402108 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402109) ->
   #task{taskid = 402109 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402110) ->
   #task{taskid = 402110 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402111) ->
   #task{taskid = 402111 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402112) ->
   #task{taskid = 402112 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402113) ->
   #task{taskid = 402113 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402114) ->
   #task{taskid = 402114 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402115) ->
   #task{taskid = 402115 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,60}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402116) ->
   #task{taskid = 402116 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402117) ->
   #task{taskid = 402117 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402118) ->
   #task{taskid = 402118 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,70}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402119) ->
   #task{taskid = 402119 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402120) ->
   #task{taskid = 402120 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402121) ->
   #task{taskid = 402121 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,80}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402122) ->
   #task{taskid = 402122 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402123) ->
   #task{taskid = 402123 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402124) ->
   #task{taskid = 402124 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,90}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402125) ->
   #task{taskid = 402125 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402126) ->
   #task{taskid = 402126 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402127) ->
   #task{taskid = 402127 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,95}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402128) ->
   #task{taskid = 402128 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26014,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402129) ->
   #task{taskid = 402129 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26013,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(402130) ->
   #task{taskid = 402130 ,name = ?T("仙盟任务") ,type = 4 ,next = 0 ,loop = 0 ,drop = [] ,accept = [{lv,48}] ,finish = [{kill,26012,100}] ,remote = 0 ,npcid = 0 ,endnpcid = 0 ,talkid = 0 ,endtalkid = 0 ,goods = [{0,10108,592200},{0,1014000,6}] };
get(_) -> [].