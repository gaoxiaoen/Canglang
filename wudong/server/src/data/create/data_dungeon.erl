%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon
	%%% @Created : 2018-05-14 21:14:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon).
-export([ids/0]).
-export([get/1]).
-export([dun_team_ids/0]).
-export([dun_activity_ids/0]).
-include("common.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
ids() ->[12001,12003,12005,12008,12009,12010,12011,12012,12013,12015,12016,12017,12018,13001,13002,20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018,20019,20020,20021,20022,20023,20024,20025,20026,20027,20028,20029,20030,20031,20032,20033,20034,20035,20036,20037,20038,20039,20040,20041,20042,20043,20044,20045,20046,20047,20048,20049,20050,20051,20052,20053,20054,20055,20056,20057,20058,20059,20060,20061,20062,20063,20064,20065,20066,20067,20068,20069,20070,20071,20072,20073,20074,20075,20076,20077,20078,20079,20080,20081,20082,20083,20084,20085,20086,20087,20088,20089,20090,20091,20092,20093,20094,20095,20096,20097,20098,20099,20100,20101,20102,20103,20104,20105,20106,20107,20108,20109,20110,20111,20112,20113,20114,20115,20116,20117,20118,20119,20120,20121,20122,20123,20124,20125,20126,20127,20128,20129,20130,20131,20132,20133,20134,20135,20136,20137,20138,20139,20140,20141,20142,20143,20144,20145,20146,20147,20148,20149,20150,20151,20152,20153,20154,20155,20156,20157,20158,20159,20160,20161,20162,20163,20164,20165,20166,20167,20168,20169,20170,20171,20172,20173,20174,20175,20176,20177,20178,20179,20180,20181,20182,20183,20184,20185,20186,20187,20188,20189,20190,20191,20192,20193,20194,20195,20196,20197,20198,20199,20200,20201,20202,20203,20204,20205,20206,20207,20208,20209,20210,20211,20212,20213,20214,20215,20216,20217,20218,20219,20220,20221,20222,20223,20224,20225,20226,20227,20228,20229,20230,20231,20232,20233,20234,20235,20236,20237,20238,20239,20240,20241,20242,20243,20244,20245,20246,20247,20248,20249,20250,20251,20252,20253,20254,20255,20256,20257,20258,20259,20260,20261,20262,20263,20264,20265,20266,20267,20268,20269,20270,20271,20272,20273,20274,20275,20276,20277,20278,20279,20280,20281,20282,20283,20284,20285,20286,20287,20288,20289,20290,20291,20292,20293,20294,20295,20296,20297,20298,20299,20300,20301,20302,20303,20304,20305,20306,20307,20308,20309,20310,20311,20312,20313,20314,20315,20316,20317,20318,20319,20320,50001,50002,50003,50004,50005,50006,50007,50008,50009,50010,50011,50012,50013,50014,50015,51001,51002,51003,51004,51005,51006,51007,51008,51009,51010,51011,51012,51013,51014,51015,51016,51017,51018,51019,51020,52001,52002,52003,52004,52005,52006,52007,52008,52009,52010,52011,52012,52013,52014,52015,52016,52017,52018,52019,52020,53001,53002,53003,53004,53005,53006,53007,53008,53009,53010,54001,54002,54003,54004,54005,54006,54007,54008,54009,54010,54011,54012,54013,55001,55002,55003,55004,55005,55006,55007,55008,55009,55010,55011,55012,55013,60001,60002,60003,30401,21001,21002,21003,21004,21005,21006,21007,21008,21009,21010,60501,60502,60503,60504,60505,60506,60507,60508,60509,60510,60511,60512,60513,60514,60515,60516,60517,60518,60519,60520,60521,60522,60523,60524,60525,14001,56001,56002,56003,56004,56005,56006,40101,40102,41101,41102,41103,41104,41105,42001,42002,42003,42004,42005,42006,42007,16001,16002,16003,16004,16005,16006,16007,16008,16009,16010,16011,16012,16013,16014,16015,16016,16017,16018,16019,16020,16021,16022,16023,16024,16025,16026,16027,16028,16029,16030,16031,16032,16033,16034,16035,16036,16037,16038,16039,16040,16041,16042,60801,60802,60803,60804,60805,60806,60807,60808,60809,60810,60811,60812,60813,60814,60815,60816,60817,60818,60819,60902,61001,61002,61003,62001,62002,62003,63001,63002,63003,64001,64002,64003,65001,65002,65003,61601,61602,61603,61101,61102,61103].
dun_team_ids() ->[].
dun_activity_ids() ->[].
get(12001) ->
	#dungeon{id = 12001 ,sid = 12001 ,name = ?T("竞技场"), type = 3 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 90 ,count = 60 ,condition = [{lvup,1},{lvdown,120}] ,scenes = [] ,out = [] };
get(12003) ->
	#dungeon{id = 12003 ,sid = 12003 ,name = ?T("竞技场新"), type = 3 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 90 ,count = 60 ,condition = [{lvup,1},{lvdown,120}] ,scenes = [] ,out = [] };
get(12005) ->
	#dungeon{id = 12005 ,sid = 12005 ,name = ?T("爱情试炼"), type = 20 ,lv = 59 ,mon = [] ,round_time = 0 ,time = 900 ,count = 2 ,condition = [{lvup,59},{lvdown,999}] ,scenes = [] ,out = [] };
get(12008) ->
	#dungeon{id = 12008 ,sid = 12008 ,name = ?T("地仙天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52121,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12009) ->
	#dungeon{id = 12009 ,sid = 12009 ,name = ?T("天仙天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52122,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12010) ->
	#dungeon{id = 12010 ,sid = 12010 ,name = ?T("金仙天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52123,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12011) ->
	#dungeon{id = 12011 ,sid = 12011 ,name = ?T("星君天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52124,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12012) ->
	#dungeon{id = 12012 ,sid = 12012 ,name = ?T("仙帝天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52125,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12013) ->
	#dungeon{id = 12013 ,sid = 12013 ,name = ?T("神子天劫"), type = 23 ,lv = 1 ,mon = [{1,[{52126,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(12015) ->
	#dungeon{id = 12015 ,sid = 12015 ,name = ?T("青铜试炼"), type = 24 ,lv = 90 ,mon = [{50301,26,35,5000000},{50302,20,48,5000000},{50303,31,48,5000000}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(12016) ->
	#dungeon{id = 12016 ,sid = 12016 ,name = ?T("白银试炼"), type = 24 ,lv = 120 ,mon = [{50301,26,35,16500000},{50302,20,48,16500000},{50303,31,48,16500000}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(12017) ->
	#dungeon{id = 12017 ,sid = 12017 ,name = ?T("黄金试炼"), type = 24 ,lv = 150 ,mon = [{50301,26,35,37000000},{50302,20,48,37000000},{50303,31,48,37000000}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,150},{lvdown,999}] ,scenes = [] ,out = [] };
get(12018) ->
	#dungeon{id = 12018 ,sid = 12018 ,name = ?T("白金试炼"), type = 24 ,lv = 180 ,mon = [{50301,26,35,52500000},{50302,20,48,52500000},{50303,31,48,52500000}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,180},{lvdown,999}] ,scenes = [] ,out = [] };
get(13001) ->
	#dungeon{id = 13001 ,sid = 13001 ,name = ?T("夺宝"), type = 4 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 90 ,count = 300 ,condition = [{lvup,99},{lvdown,120}] ,scenes = [] ,out = [] };
get(13002) ->
	#dungeon{id = 13002 ,sid = 13002 ,name = ?T("抢楼PK"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 90 ,count = 0 ,condition = [{lvup,99},{lvdown,120}] ,scenes = [] ,out = [] };
get(20001) ->
	#dungeon{id = 20001 ,sid = 20001 ,name = ?T("九霄塔1层"), type = 13 ,lv = 1 ,mon = [{1,[{40001,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20002) ->
	#dungeon{id = 20002 ,sid = 20002 ,name = ?T("九霄塔2层"), type = 13 ,lv = 1 ,mon = [{1,[{40004,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20003) ->
	#dungeon{id = 20003 ,sid = 20003 ,name = ?T("九霄塔3层"), type = 13 ,lv = 1 ,mon = [{1,[{40007,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20004) ->
	#dungeon{id = 20004 ,sid = 20004 ,name = ?T("九霄塔4层"), type = 13 ,lv = 1 ,mon = [{1,[{40010,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20005) ->
	#dungeon{id = 20005 ,sid = 20005 ,name = ?T("九霄塔5层"), type = 13 ,lv = 1 ,mon = [{1,[{40013,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20006) ->
	#dungeon{id = 20006 ,sid = 20006 ,name = ?T("九霄塔6层"), type = 13 ,lv = 1 ,mon = [{1,[{40016,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20007) ->
	#dungeon{id = 20007 ,sid = 20007 ,name = ?T("九霄塔7层"), type = 13 ,lv = 1 ,mon = [{1,[{40019,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20008) ->
	#dungeon{id = 20008 ,sid = 20008 ,name = ?T("九霄塔8层"), type = 13 ,lv = 1 ,mon = [{1,[{40022,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20009) ->
	#dungeon{id = 20009 ,sid = 20009 ,name = ?T("九霄塔9层"), type = 13 ,lv = 1 ,mon = [{1,[{40025,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20010) ->
	#dungeon{id = 20010 ,sid = 20010 ,name = ?T("九霄塔10层"), type = 13 ,lv = 1 ,mon = [{1,[{40028,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20011) ->
	#dungeon{id = 20011 ,sid = 20011 ,name = ?T("九霄塔11层"), type = 13 ,lv = 1 ,mon = [{1,[{40031,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20012) ->
	#dungeon{id = 20012 ,sid = 20012 ,name = ?T("九霄塔12层"), type = 13 ,lv = 1 ,mon = [{1,[{40034,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20013) ->
	#dungeon{id = 20013 ,sid = 20013 ,name = ?T("九霄塔13层"), type = 13 ,lv = 1 ,mon = [{1,[{40037,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20014) ->
	#dungeon{id = 20014 ,sid = 20014 ,name = ?T("九霄塔14层"), type = 13 ,lv = 1 ,mon = [{1,[{40040,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20015) ->
	#dungeon{id = 20015 ,sid = 20015 ,name = ?T("九霄塔15层"), type = 13 ,lv = 1 ,mon = [{1,[{40043,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20016) ->
	#dungeon{id = 20016 ,sid = 20016 ,name = ?T("九霄塔16层"), type = 13 ,lv = 1 ,mon = [{1,[{40046,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20017) ->
	#dungeon{id = 20017 ,sid = 20017 ,name = ?T("九霄塔17层"), type = 13 ,lv = 1 ,mon = [{1,[{40049,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20018) ->
	#dungeon{id = 20018 ,sid = 20018 ,name = ?T("九霄塔18层"), type = 13 ,lv = 1 ,mon = [{1,[{40052,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20019) ->
	#dungeon{id = 20019 ,sid = 20019 ,name = ?T("九霄塔19层"), type = 13 ,lv = 1 ,mon = [{1,[{40055,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20020) ->
	#dungeon{id = 20020 ,sid = 20020 ,name = ?T("九霄塔20层"), type = 13 ,lv = 1 ,mon = [{1,[{40058,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20021) ->
	#dungeon{id = 20021 ,sid = 20021 ,name = ?T("九霄塔21层"), type = 13 ,lv = 1 ,mon = [{1,[{40061,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20022) ->
	#dungeon{id = 20022 ,sid = 20022 ,name = ?T("九霄塔22层"), type = 13 ,lv = 1 ,mon = [{1,[{40064,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20023) ->
	#dungeon{id = 20023 ,sid = 20023 ,name = ?T("九霄塔23层"), type = 13 ,lv = 1 ,mon = [{1,[{40067,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20024) ->
	#dungeon{id = 20024 ,sid = 20024 ,name = ?T("九霄塔24层"), type = 13 ,lv = 1 ,mon = [{1,[{40070,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20025) ->
	#dungeon{id = 20025 ,sid = 20025 ,name = ?T("九霄塔25层"), type = 13 ,lv = 1 ,mon = [{1,[{40073,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20026) ->
	#dungeon{id = 20026 ,sid = 20026 ,name = ?T("九霄塔26层"), type = 13 ,lv = 1 ,mon = [{1,[{40076,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20027) ->
	#dungeon{id = 20027 ,sid = 20027 ,name = ?T("九霄塔27层"), type = 13 ,lv = 1 ,mon = [{1,[{40079,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20028) ->
	#dungeon{id = 20028 ,sid = 20028 ,name = ?T("九霄塔28层"), type = 13 ,lv = 1 ,mon = [{1,[{40082,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20029) ->
	#dungeon{id = 20029 ,sid = 20029 ,name = ?T("九霄塔29层"), type = 13 ,lv = 1 ,mon = [{1,[{40085,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20030) ->
	#dungeon{id = 20030 ,sid = 20030 ,name = ?T("九霄塔30层"), type = 13 ,lv = 1 ,mon = [{1,[{40088,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20031) ->
	#dungeon{id = 20031 ,sid = 20031 ,name = ?T("九霄塔31层"), type = 13 ,lv = 1 ,mon = [{1,[{40091,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20032) ->
	#dungeon{id = 20032 ,sid = 20032 ,name = ?T("九霄塔32层"), type = 13 ,lv = 1 ,mon = [{1,[{40094,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20033) ->
	#dungeon{id = 20033 ,sid = 20033 ,name = ?T("九霄塔33层"), type = 13 ,lv = 1 ,mon = [{1,[{40097,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20034) ->
	#dungeon{id = 20034 ,sid = 20034 ,name = ?T("九霄塔34层"), type = 13 ,lv = 1 ,mon = [{1,[{40100,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20035) ->
	#dungeon{id = 20035 ,sid = 20035 ,name = ?T("九霄塔35层"), type = 13 ,lv = 1 ,mon = [{1,[{40103,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20036) ->
	#dungeon{id = 20036 ,sid = 20036 ,name = ?T("九霄塔36层"), type = 13 ,lv = 1 ,mon = [{1,[{40106,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20037) ->
	#dungeon{id = 20037 ,sid = 20037 ,name = ?T("九霄塔37层"), type = 13 ,lv = 1 ,mon = [{1,[{40109,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20038) ->
	#dungeon{id = 20038 ,sid = 20038 ,name = ?T("九霄塔38层"), type = 13 ,lv = 1 ,mon = [{1,[{40112,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20039) ->
	#dungeon{id = 20039 ,sid = 20039 ,name = ?T("九霄塔39层"), type = 13 ,lv = 1 ,mon = [{1,[{40115,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20040) ->
	#dungeon{id = 20040 ,sid = 20040 ,name = ?T("九霄塔40层"), type = 13 ,lv = 1 ,mon = [{1,[{40118,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20041) ->
	#dungeon{id = 20041 ,sid = 20041 ,name = ?T("九霄塔41层"), type = 13 ,lv = 1 ,mon = [{1,[{40121,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20042) ->
	#dungeon{id = 20042 ,sid = 20042 ,name = ?T("九霄塔42层"), type = 13 ,lv = 1 ,mon = [{1,[{40124,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20043) ->
	#dungeon{id = 20043 ,sid = 20043 ,name = ?T("九霄塔43层"), type = 13 ,lv = 1 ,mon = [{1,[{40127,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20044) ->
	#dungeon{id = 20044 ,sid = 20044 ,name = ?T("九霄塔44层"), type = 13 ,lv = 1 ,mon = [{1,[{40130,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20045) ->
	#dungeon{id = 20045 ,sid = 20045 ,name = ?T("九霄塔45层"), type = 13 ,lv = 1 ,mon = [{1,[{40133,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20046) ->
	#dungeon{id = 20046 ,sid = 20046 ,name = ?T("九霄塔46层"), type = 13 ,lv = 1 ,mon = [{1,[{40136,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20047) ->
	#dungeon{id = 20047 ,sid = 20047 ,name = ?T("九霄塔47层"), type = 13 ,lv = 1 ,mon = [{1,[{40139,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20048) ->
	#dungeon{id = 20048 ,sid = 20048 ,name = ?T("九霄塔48层"), type = 13 ,lv = 1 ,mon = [{1,[{40142,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20049) ->
	#dungeon{id = 20049 ,sid = 20049 ,name = ?T("九霄塔49层"), type = 13 ,lv = 1 ,mon = [{1,[{40145,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20050) ->
	#dungeon{id = 20050 ,sid = 20050 ,name = ?T("九霄塔50层"), type = 13 ,lv = 1 ,mon = [{1,[{40148,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20051) ->
	#dungeon{id = 20051 ,sid = 20051 ,name = ?T("九霄塔51层"), type = 13 ,lv = 1 ,mon = [{1,[{40151,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20052) ->
	#dungeon{id = 20052 ,sid = 20052 ,name = ?T("九霄塔52层"), type = 13 ,lv = 1 ,mon = [{1,[{40154,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20053) ->
	#dungeon{id = 20053 ,sid = 20053 ,name = ?T("九霄塔53层"), type = 13 ,lv = 1 ,mon = [{1,[{40157,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20054) ->
	#dungeon{id = 20054 ,sid = 20054 ,name = ?T("九霄塔54层"), type = 13 ,lv = 1 ,mon = [{1,[{40160,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20055) ->
	#dungeon{id = 20055 ,sid = 20055 ,name = ?T("九霄塔55层"), type = 13 ,lv = 1 ,mon = [{1,[{40163,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20056) ->
	#dungeon{id = 20056 ,sid = 20056 ,name = ?T("九霄塔56层"), type = 13 ,lv = 1 ,mon = [{1,[{40166,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20057) ->
	#dungeon{id = 20057 ,sid = 20057 ,name = ?T("九霄塔57层"), type = 13 ,lv = 1 ,mon = [{1,[{40169,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20058) ->
	#dungeon{id = 20058 ,sid = 20058 ,name = ?T("九霄塔58层"), type = 13 ,lv = 1 ,mon = [{1,[{40172,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20059) ->
	#dungeon{id = 20059 ,sid = 20059 ,name = ?T("九霄塔59层"), type = 13 ,lv = 1 ,mon = [{1,[{40175,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20060) ->
	#dungeon{id = 20060 ,sid = 20060 ,name = ?T("九霄塔60层"), type = 13 ,lv = 1 ,mon = [{1,[{40178,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20061) ->
	#dungeon{id = 20061 ,sid = 20021 ,name = ?T("九霄塔61层"), type = 13 ,lv = 1 ,mon = [{1,[{40181,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20062) ->
	#dungeon{id = 20062 ,sid = 20022 ,name = ?T("九霄塔62层"), type = 13 ,lv = 1 ,mon = [{1,[{40184,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20063) ->
	#dungeon{id = 20063 ,sid = 20023 ,name = ?T("九霄塔63层"), type = 13 ,lv = 1 ,mon = [{1,[{40187,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20064) ->
	#dungeon{id = 20064 ,sid = 20024 ,name = ?T("九霄塔64层"), type = 13 ,lv = 1 ,mon = [{1,[{40190,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20065) ->
	#dungeon{id = 20065 ,sid = 20025 ,name = ?T("九霄塔65层"), type = 13 ,lv = 1 ,mon = [{1,[{40193,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20066) ->
	#dungeon{id = 20066 ,sid = 20026 ,name = ?T("九霄塔66层"), type = 13 ,lv = 1 ,mon = [{1,[{40196,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20067) ->
	#dungeon{id = 20067 ,sid = 20027 ,name = ?T("九霄塔67层"), type = 13 ,lv = 1 ,mon = [{1,[{40199,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20068) ->
	#dungeon{id = 20068 ,sid = 20028 ,name = ?T("九霄塔68层"), type = 13 ,lv = 1 ,mon = [{1,[{40202,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20069) ->
	#dungeon{id = 20069 ,sid = 20029 ,name = ?T("九霄塔69层"), type = 13 ,lv = 1 ,mon = [{1,[{40205,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20070) ->
	#dungeon{id = 20070 ,sid = 20030 ,name = ?T("九霄塔70层"), type = 13 ,lv = 1 ,mon = [{1,[{40208,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20071) ->
	#dungeon{id = 20071 ,sid = 20031 ,name = ?T("九霄塔71层"), type = 13 ,lv = 1 ,mon = [{1,[{40211,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20072) ->
	#dungeon{id = 20072 ,sid = 20032 ,name = ?T("九霄塔72层"), type = 13 ,lv = 1 ,mon = [{1,[{40214,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20073) ->
	#dungeon{id = 20073 ,sid = 20033 ,name = ?T("九霄塔73层"), type = 13 ,lv = 1 ,mon = [{1,[{40217,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20074) ->
	#dungeon{id = 20074 ,sid = 20034 ,name = ?T("九霄塔74层"), type = 13 ,lv = 1 ,mon = [{1,[{40220,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20075) ->
	#dungeon{id = 20075 ,sid = 20035 ,name = ?T("九霄塔75层"), type = 13 ,lv = 1 ,mon = [{1,[{40223,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20076) ->
	#dungeon{id = 20076 ,sid = 20036 ,name = ?T("九霄塔76层"), type = 13 ,lv = 1 ,mon = [{1,[{40226,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20077) ->
	#dungeon{id = 20077 ,sid = 20037 ,name = ?T("九霄塔77层"), type = 13 ,lv = 1 ,mon = [{1,[{40229,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20078) ->
	#dungeon{id = 20078 ,sid = 20038 ,name = ?T("九霄塔78层"), type = 13 ,lv = 1 ,mon = [{1,[{40232,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20079) ->
	#dungeon{id = 20079 ,sid = 20039 ,name = ?T("九霄塔79层"), type = 13 ,lv = 1 ,mon = [{1,[{40235,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20080) ->
	#dungeon{id = 20080 ,sid = 20040 ,name = ?T("九霄塔80层"), type = 13 ,lv = 1 ,mon = [{1,[{40238,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20081) ->
	#dungeon{id = 20081 ,sid = 20041 ,name = ?T("九霄塔81层"), type = 13 ,lv = 1 ,mon = [{1,[{40241,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20082) ->
	#dungeon{id = 20082 ,sid = 20042 ,name = ?T("九霄塔82层"), type = 13 ,lv = 1 ,mon = [{1,[{40244,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20083) ->
	#dungeon{id = 20083 ,sid = 20043 ,name = ?T("九霄塔83层"), type = 13 ,lv = 1 ,mon = [{1,[{40247,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20084) ->
	#dungeon{id = 20084 ,sid = 20044 ,name = ?T("九霄塔84层"), type = 13 ,lv = 1 ,mon = [{1,[{40250,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20085) ->
	#dungeon{id = 20085 ,sid = 20045 ,name = ?T("九霄塔85层"), type = 13 ,lv = 1 ,mon = [{1,[{40253,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20086) ->
	#dungeon{id = 20086 ,sid = 20046 ,name = ?T("九霄塔86层"), type = 13 ,lv = 1 ,mon = [{1,[{40256,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20087) ->
	#dungeon{id = 20087 ,sid = 20047 ,name = ?T("九霄塔87层"), type = 13 ,lv = 1 ,mon = [{1,[{40259,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20088) ->
	#dungeon{id = 20088 ,sid = 20048 ,name = ?T("九霄塔88层"), type = 13 ,lv = 1 ,mon = [{1,[{40262,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20089) ->
	#dungeon{id = 20089 ,sid = 20049 ,name = ?T("九霄塔89层"), type = 13 ,lv = 1 ,mon = [{1,[{40265,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20090) ->
	#dungeon{id = 20090 ,sid = 20050 ,name = ?T("九霄塔90层"), type = 13 ,lv = 1 ,mon = [{1,[{40268,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20091) ->
	#dungeon{id = 20091 ,sid = 20051 ,name = ?T("九霄塔91层"), type = 13 ,lv = 1 ,mon = [{1,[{40271,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20092) ->
	#dungeon{id = 20092 ,sid = 20052 ,name = ?T("九霄塔92层"), type = 13 ,lv = 1 ,mon = [{1,[{40274,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20093) ->
	#dungeon{id = 20093 ,sid = 20053 ,name = ?T("九霄塔93层"), type = 13 ,lv = 1 ,mon = [{1,[{40277,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20094) ->
	#dungeon{id = 20094 ,sid = 20054 ,name = ?T("九霄塔94层"), type = 13 ,lv = 1 ,mon = [{1,[{40280,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20095) ->
	#dungeon{id = 20095 ,sid = 20055 ,name = ?T("九霄塔95层"), type = 13 ,lv = 1 ,mon = [{1,[{40283,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20096) ->
	#dungeon{id = 20096 ,sid = 20056 ,name = ?T("九霄塔96层"), type = 13 ,lv = 1 ,mon = [{1,[{40286,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20097) ->
	#dungeon{id = 20097 ,sid = 20057 ,name = ?T("九霄塔97层"), type = 13 ,lv = 1 ,mon = [{1,[{40289,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20098) ->
	#dungeon{id = 20098 ,sid = 20058 ,name = ?T("九霄塔98层"), type = 13 ,lv = 1 ,mon = [{1,[{40292,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20099) ->
	#dungeon{id = 20099 ,sid = 20059 ,name = ?T("九霄塔99层"), type = 13 ,lv = 1 ,mon = [{1,[{40295,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20100) ->
	#dungeon{id = 20100 ,sid = 20060 ,name = ?T("九霄塔100层"), type = 13 ,lv = 1 ,mon = [{1,[{40298,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20101) ->
	#dungeon{id = 20101 ,sid = 20061 ,name = ?T("九霄塔101层"), type = 13 ,lv = 1 ,mon = [{1,[{40301,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20102) ->
	#dungeon{id = 20102 ,sid = 20062 ,name = ?T("九霄塔102层"), type = 13 ,lv = 1 ,mon = [{1,[{40304,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20103) ->
	#dungeon{id = 20103 ,sid = 20063 ,name = ?T("九霄塔103层"), type = 13 ,lv = 1 ,mon = [{1,[{40307,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20104) ->
	#dungeon{id = 20104 ,sid = 20064 ,name = ?T("九霄塔104层"), type = 13 ,lv = 1 ,mon = [{1,[{40310,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20105) ->
	#dungeon{id = 20105 ,sid = 20065 ,name = ?T("九霄塔105层"), type = 13 ,lv = 1 ,mon = [{1,[{40313,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20106) ->
	#dungeon{id = 20106 ,sid = 20066 ,name = ?T("九霄塔106层"), type = 13 ,lv = 1 ,mon = [{1,[{40316,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20107) ->
	#dungeon{id = 20107 ,sid = 20067 ,name = ?T("九霄塔107层"), type = 13 ,lv = 1 ,mon = [{1,[{40319,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20108) ->
	#dungeon{id = 20108 ,sid = 20068 ,name = ?T("九霄塔108层"), type = 13 ,lv = 1 ,mon = [{1,[{40322,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20109) ->
	#dungeon{id = 20109 ,sid = 20069 ,name = ?T("九霄塔109层"), type = 13 ,lv = 1 ,mon = [{1,[{40325,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20110) ->
	#dungeon{id = 20110 ,sid = 20070 ,name = ?T("九霄塔110层"), type = 13 ,lv = 1 ,mon = [{1,[{40328,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20111) ->
	#dungeon{id = 20111 ,sid = 20071 ,name = ?T("九霄塔111层"), type = 13 ,lv = 1 ,mon = [{1,[{40331,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20112) ->
	#dungeon{id = 20112 ,sid = 20072 ,name = ?T("九霄塔112层"), type = 13 ,lv = 1 ,mon = [{1,[{40334,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20113) ->
	#dungeon{id = 20113 ,sid = 20073 ,name = ?T("九霄塔113层"), type = 13 ,lv = 1 ,mon = [{1,[{40337,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20114) ->
	#dungeon{id = 20114 ,sid = 20074 ,name = ?T("九霄塔114层"), type = 13 ,lv = 1 ,mon = [{1,[{40340,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20115) ->
	#dungeon{id = 20115 ,sid = 20075 ,name = ?T("九霄塔115层"), type = 13 ,lv = 1 ,mon = [{1,[{40343,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20116) ->
	#dungeon{id = 20116 ,sid = 20076 ,name = ?T("九霄塔116层"), type = 13 ,lv = 1 ,mon = [{1,[{40346,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20117) ->
	#dungeon{id = 20117 ,sid = 20077 ,name = ?T("九霄塔117层"), type = 13 ,lv = 1 ,mon = [{1,[{40349,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20118) ->
	#dungeon{id = 20118 ,sid = 20078 ,name = ?T("九霄塔118层"), type = 13 ,lv = 1 ,mon = [{1,[{40352,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20119) ->
	#dungeon{id = 20119 ,sid = 20079 ,name = ?T("九霄塔119层"), type = 13 ,lv = 1 ,mon = [{1,[{40355,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20120) ->
	#dungeon{id = 20120 ,sid = 20080 ,name = ?T("九霄塔120层"), type = 13 ,lv = 1 ,mon = [{1,[{40358,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20121) ->
	#dungeon{id = 20121 ,sid = 20081 ,name = ?T("九霄塔121层"), type = 13 ,lv = 1 ,mon = [{1,[{40361,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20122) ->
	#dungeon{id = 20122 ,sid = 20082 ,name = ?T("九霄塔122层"), type = 13 ,lv = 1 ,mon = [{1,[{40364,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20123) ->
	#dungeon{id = 20123 ,sid = 20083 ,name = ?T("九霄塔123层"), type = 13 ,lv = 1 ,mon = [{1,[{40367,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20124) ->
	#dungeon{id = 20124 ,sid = 20084 ,name = ?T("九霄塔124层"), type = 13 ,lv = 1 ,mon = [{1,[{40370,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20125) ->
	#dungeon{id = 20125 ,sid = 20085 ,name = ?T("九霄塔125层"), type = 13 ,lv = 1 ,mon = [{1,[{40373,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20126) ->
	#dungeon{id = 20126 ,sid = 20086 ,name = ?T("九霄塔126层"), type = 13 ,lv = 1 ,mon = [{1,[{40376,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20127) ->
	#dungeon{id = 20127 ,sid = 20087 ,name = ?T("九霄塔127层"), type = 13 ,lv = 1 ,mon = [{1,[{40379,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20128) ->
	#dungeon{id = 20128 ,sid = 20088 ,name = ?T("九霄塔128层"), type = 13 ,lv = 1 ,mon = [{1,[{40382,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20129) ->
	#dungeon{id = 20129 ,sid = 20089 ,name = ?T("九霄塔129层"), type = 13 ,lv = 1 ,mon = [{1,[{40385,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20130) ->
	#dungeon{id = 20130 ,sid = 20090 ,name = ?T("九霄塔130层"), type = 13 ,lv = 1 ,mon = [{1,[{40388,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20131) ->
	#dungeon{id = 20131 ,sid = 20091 ,name = ?T("九霄塔131层"), type = 13 ,lv = 1 ,mon = [{1,[{40391,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20132) ->
	#dungeon{id = 20132 ,sid = 20092 ,name = ?T("九霄塔132层"), type = 13 ,lv = 1 ,mon = [{1,[{40394,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20133) ->
	#dungeon{id = 20133 ,sid = 20093 ,name = ?T("九霄塔133层"), type = 13 ,lv = 1 ,mon = [{1,[{40397,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20134) ->
	#dungeon{id = 20134 ,sid = 20094 ,name = ?T("九霄塔134层"), type = 13 ,lv = 1 ,mon = [{1,[{40400,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20135) ->
	#dungeon{id = 20135 ,sid = 20095 ,name = ?T("九霄塔135层"), type = 13 ,lv = 1 ,mon = [{1,[{40403,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20136) ->
	#dungeon{id = 20136 ,sid = 20096 ,name = ?T("九霄塔136层"), type = 13 ,lv = 1 ,mon = [{1,[{40406,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20137) ->
	#dungeon{id = 20137 ,sid = 20097 ,name = ?T("九霄塔137层"), type = 13 ,lv = 1 ,mon = [{1,[{40409,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20138) ->
	#dungeon{id = 20138 ,sid = 20098 ,name = ?T("九霄塔138层"), type = 13 ,lv = 1 ,mon = [{1,[{40412,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20139) ->
	#dungeon{id = 20139 ,sid = 20099 ,name = ?T("九霄塔139层"), type = 13 ,lv = 1 ,mon = [{1,[{40415,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20140) ->
	#dungeon{id = 20140 ,sid = 20100 ,name = ?T("九霄塔140层"), type = 13 ,lv = 1 ,mon = [{1,[{40418,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20141) ->
	#dungeon{id = 20141 ,sid = 20101 ,name = ?T("九霄塔141层"), type = 13 ,lv = 1 ,mon = [{1,[{40421,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20142) ->
	#dungeon{id = 20142 ,sid = 20102 ,name = ?T("九霄塔142层"), type = 13 ,lv = 1 ,mon = [{1,[{40424,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20143) ->
	#dungeon{id = 20143 ,sid = 20103 ,name = ?T("九霄塔143层"), type = 13 ,lv = 1 ,mon = [{1,[{40427,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20144) ->
	#dungeon{id = 20144 ,sid = 20104 ,name = ?T("九霄塔144层"), type = 13 ,lv = 1 ,mon = [{1,[{40430,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20145) ->
	#dungeon{id = 20145 ,sid = 20105 ,name = ?T("九霄塔145层"), type = 13 ,lv = 1 ,mon = [{1,[{40433,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20146) ->
	#dungeon{id = 20146 ,sid = 20106 ,name = ?T("九霄塔146层"), type = 13 ,lv = 1 ,mon = [{1,[{40436,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20147) ->
	#dungeon{id = 20147 ,sid = 20107 ,name = ?T("九霄塔147层"), type = 13 ,lv = 1 ,mon = [{1,[{40439,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20148) ->
	#dungeon{id = 20148 ,sid = 20108 ,name = ?T("九霄塔148层"), type = 13 ,lv = 1 ,mon = [{1,[{40442,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20149) ->
	#dungeon{id = 20149 ,sid = 20109 ,name = ?T("九霄塔149层"), type = 13 ,lv = 1 ,mon = [{1,[{40445,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20150) ->
	#dungeon{id = 20150 ,sid = 20110 ,name = ?T("九霄塔150层"), type = 13 ,lv = 1 ,mon = [{1,[{40448,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20151) ->
	#dungeon{id = 20151 ,sid = 20111 ,name = ?T("九霄塔151层"), type = 13 ,lv = 1 ,mon = [{1,[{40451,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20152) ->
	#dungeon{id = 20152 ,sid = 20112 ,name = ?T("九霄塔152层"), type = 13 ,lv = 1 ,mon = [{1,[{40454,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20153) ->
	#dungeon{id = 20153 ,sid = 20113 ,name = ?T("九霄塔153层"), type = 13 ,lv = 1 ,mon = [{1,[{40457,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20154) ->
	#dungeon{id = 20154 ,sid = 20114 ,name = ?T("九霄塔154层"), type = 13 ,lv = 1 ,mon = [{1,[{40460,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20155) ->
	#dungeon{id = 20155 ,sid = 20115 ,name = ?T("九霄塔155层"), type = 13 ,lv = 1 ,mon = [{1,[{40463,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20156) ->
	#dungeon{id = 20156 ,sid = 20116 ,name = ?T("九霄塔156层"), type = 13 ,lv = 1 ,mon = [{1,[{40466,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20157) ->
	#dungeon{id = 20157 ,sid = 20117 ,name = ?T("九霄塔157层"), type = 13 ,lv = 1 ,mon = [{1,[{40469,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20158) ->
	#dungeon{id = 20158 ,sid = 20118 ,name = ?T("九霄塔158层"), type = 13 ,lv = 1 ,mon = [{1,[{40472,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20159) ->
	#dungeon{id = 20159 ,sid = 20119 ,name = ?T("九霄塔159层"), type = 13 ,lv = 1 ,mon = [{1,[{40475,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20160) ->
	#dungeon{id = 20160 ,sid = 20120 ,name = ?T("九霄塔160层"), type = 13 ,lv = 1 ,mon = [{1,[{40478,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20161) ->
	#dungeon{id = 20161 ,sid = 20001 ,name = ?T("诛仙塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40001,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20162) ->
	#dungeon{id = 20162 ,sid = 20002 ,name = ?T("诛仙塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40004,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20163) ->
	#dungeon{id = 20163 ,sid = 20003 ,name = ?T("诛仙塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40007,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20164) ->
	#dungeon{id = 20164 ,sid = 20004 ,name = ?T("诛仙塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40010,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20165) ->
	#dungeon{id = 20165 ,sid = 20005 ,name = ?T("诛仙塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40013,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20166) ->
	#dungeon{id = 20166 ,sid = 20006 ,name = ?T("诛仙塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40016,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20167) ->
	#dungeon{id = 20167 ,sid = 20007 ,name = ?T("诛仙塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40019,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20168) ->
	#dungeon{id = 20168 ,sid = 20008 ,name = ?T("诛仙塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40022,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20169) ->
	#dungeon{id = 20169 ,sid = 20009 ,name = ?T("诛仙塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40025,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20170) ->
	#dungeon{id = 20170 ,sid = 20010 ,name = ?T("诛仙塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40028,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20171) ->
	#dungeon{id = 20171 ,sid = 20011 ,name = ?T("诛仙塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40031,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20172) ->
	#dungeon{id = 20172 ,sid = 20012 ,name = ?T("诛仙塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40034,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20173) ->
	#dungeon{id = 20173 ,sid = 20013 ,name = ?T("诛仙塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40037,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20174) ->
	#dungeon{id = 20174 ,sid = 20014 ,name = ?T("诛仙塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40040,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20175) ->
	#dungeon{id = 20175 ,sid = 20015 ,name = ?T("诛仙塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40043,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20176) ->
	#dungeon{id = 20176 ,sid = 20016 ,name = ?T("诛仙塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40046,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20177) ->
	#dungeon{id = 20177 ,sid = 20017 ,name = ?T("诛仙塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40049,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20178) ->
	#dungeon{id = 20178 ,sid = 20018 ,name = ?T("诛仙塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40052,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20179) ->
	#dungeon{id = 20179 ,sid = 20019 ,name = ?T("诛仙塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40055,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20180) ->
	#dungeon{id = 20180 ,sid = 20020 ,name = ?T("诛仙塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40058,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20181) ->
	#dungeon{id = 20181 ,sid = 20021 ,name = ?T("镇魔塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40061,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20182) ->
	#dungeon{id = 20182 ,sid = 20022 ,name = ?T("镇魔塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40064,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20183) ->
	#dungeon{id = 20183 ,sid = 20023 ,name = ?T("镇魔塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40067,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20184) ->
	#dungeon{id = 20184 ,sid = 20024 ,name = ?T("镇魔塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40070,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20185) ->
	#dungeon{id = 20185 ,sid = 20025 ,name = ?T("镇魔塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40073,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20186) ->
	#dungeon{id = 20186 ,sid = 20026 ,name = ?T("镇魔塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40076,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20187) ->
	#dungeon{id = 20187 ,sid = 20027 ,name = ?T("镇魔塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40079,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20188) ->
	#dungeon{id = 20188 ,sid = 20028 ,name = ?T("镇魔塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40082,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20189) ->
	#dungeon{id = 20189 ,sid = 20029 ,name = ?T("镇魔塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40085,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20190) ->
	#dungeon{id = 20190 ,sid = 20030 ,name = ?T("镇魔塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40088,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20191) ->
	#dungeon{id = 20191 ,sid = 20031 ,name = ?T("镇魔塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40091,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20192) ->
	#dungeon{id = 20192 ,sid = 20032 ,name = ?T("镇魔塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40094,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20193) ->
	#dungeon{id = 20193 ,sid = 20033 ,name = ?T("镇魔塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40097,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20194) ->
	#dungeon{id = 20194 ,sid = 20034 ,name = ?T("镇魔塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40100,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20195) ->
	#dungeon{id = 20195 ,sid = 20035 ,name = ?T("镇魔塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40103,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20196) ->
	#dungeon{id = 20196 ,sid = 20036 ,name = ?T("镇魔塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40106,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20197) ->
	#dungeon{id = 20197 ,sid = 20037 ,name = ?T("镇魔塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40109,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20198) ->
	#dungeon{id = 20198 ,sid = 20038 ,name = ?T("镇魔塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40112,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20199) ->
	#dungeon{id = 20199 ,sid = 20039 ,name = ?T("镇魔塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40115,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20200) ->
	#dungeon{id = 20200 ,sid = 20040 ,name = ?T("镇魔塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40118,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20201) ->
	#dungeon{id = 20201 ,sid = 20041 ,name = ?T("大雁塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40121,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20202) ->
	#dungeon{id = 20202 ,sid = 20042 ,name = ?T("大雁塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40124,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20203) ->
	#dungeon{id = 20203 ,sid = 20043 ,name = ?T("大雁塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40127,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20204) ->
	#dungeon{id = 20204 ,sid = 20044 ,name = ?T("大雁塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40130,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20205) ->
	#dungeon{id = 20205 ,sid = 20045 ,name = ?T("大雁塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40133,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20206) ->
	#dungeon{id = 20206 ,sid = 20046 ,name = ?T("大雁塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40136,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20207) ->
	#dungeon{id = 20207 ,sid = 20047 ,name = ?T("大雁塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40139,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20208) ->
	#dungeon{id = 20208 ,sid = 20048 ,name = ?T("大雁塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40142,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20209) ->
	#dungeon{id = 20209 ,sid = 20049 ,name = ?T("大雁塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40145,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20210) ->
	#dungeon{id = 20210 ,sid = 20050 ,name = ?T("大雁塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40148,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20211) ->
	#dungeon{id = 20211 ,sid = 20051 ,name = ?T("大雁塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40151,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20212) ->
	#dungeon{id = 20212 ,sid = 20052 ,name = ?T("大雁塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40154,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20213) ->
	#dungeon{id = 20213 ,sid = 20053 ,name = ?T("大雁塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40157,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20214) ->
	#dungeon{id = 20214 ,sid = 20054 ,name = ?T("大雁塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40160,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20215) ->
	#dungeon{id = 20215 ,sid = 20055 ,name = ?T("大雁塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40163,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20216) ->
	#dungeon{id = 20216 ,sid = 20056 ,name = ?T("大雁塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40166,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20217) ->
	#dungeon{id = 20217 ,sid = 20057 ,name = ?T("大雁塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40169,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20218) ->
	#dungeon{id = 20218 ,sid = 20058 ,name = ?T("大雁塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40172,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20219) ->
	#dungeon{id = 20219 ,sid = 20059 ,name = ?T("大雁塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40175,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20220) ->
	#dungeon{id = 20220 ,sid = 20060 ,name = ?T("大雁塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40178,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20221) ->
	#dungeon{id = 20221 ,sid = 20021 ,name = ?T("释迦塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40181,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20222) ->
	#dungeon{id = 20222 ,sid = 20022 ,name = ?T("释迦塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40184,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20223) ->
	#dungeon{id = 20223 ,sid = 20023 ,name = ?T("释迦塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40187,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20224) ->
	#dungeon{id = 20224 ,sid = 20024 ,name = ?T("释迦塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40190,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20225) ->
	#dungeon{id = 20225 ,sid = 20025 ,name = ?T("释迦塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40193,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20226) ->
	#dungeon{id = 20226 ,sid = 20026 ,name = ?T("释迦塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40196,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20227) ->
	#dungeon{id = 20227 ,sid = 20027 ,name = ?T("释迦塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40199,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20228) ->
	#dungeon{id = 20228 ,sid = 20028 ,name = ?T("释迦塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40202,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20229) ->
	#dungeon{id = 20229 ,sid = 20029 ,name = ?T("释迦塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40205,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20230) ->
	#dungeon{id = 20230 ,sid = 20030 ,name = ?T("释迦塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40208,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20231) ->
	#dungeon{id = 20231 ,sid = 20031 ,name = ?T("释迦塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40211,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20232) ->
	#dungeon{id = 20232 ,sid = 20032 ,name = ?T("释迦塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40214,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20233) ->
	#dungeon{id = 20233 ,sid = 20033 ,name = ?T("释迦塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40217,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20234) ->
	#dungeon{id = 20234 ,sid = 20034 ,name = ?T("释迦塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40220,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20235) ->
	#dungeon{id = 20235 ,sid = 20035 ,name = ?T("释迦塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40223,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20236) ->
	#dungeon{id = 20236 ,sid = 20036 ,name = ?T("释迦塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40226,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20237) ->
	#dungeon{id = 20237 ,sid = 20037 ,name = ?T("释迦塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40229,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20238) ->
	#dungeon{id = 20238 ,sid = 20038 ,name = ?T("释迦塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40232,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20239) ->
	#dungeon{id = 20239 ,sid = 20039 ,name = ?T("释迦塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40235,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20240) ->
	#dungeon{id = 20240 ,sid = 20040 ,name = ?T("释迦塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40238,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20241) ->
	#dungeon{id = 20241 ,sid = 20041 ,name = ?T("飞虹塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40241,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20242) ->
	#dungeon{id = 20242 ,sid = 20042 ,name = ?T("飞虹塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40244,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20243) ->
	#dungeon{id = 20243 ,sid = 20043 ,name = ?T("飞虹塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40247,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20244) ->
	#dungeon{id = 20244 ,sid = 20044 ,name = ?T("飞虹塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40250,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20245) ->
	#dungeon{id = 20245 ,sid = 20045 ,name = ?T("飞虹塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40253,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20246) ->
	#dungeon{id = 20246 ,sid = 20046 ,name = ?T("飞虹塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40256,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20247) ->
	#dungeon{id = 20247 ,sid = 20047 ,name = ?T("飞虹塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40259,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20248) ->
	#dungeon{id = 20248 ,sid = 20048 ,name = ?T("飞虹塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40262,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20249) ->
	#dungeon{id = 20249 ,sid = 20049 ,name = ?T("飞虹塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40265,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20250) ->
	#dungeon{id = 20250 ,sid = 20050 ,name = ?T("飞虹塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40268,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20251) ->
	#dungeon{id = 20251 ,sid = 20051 ,name = ?T("飞虹塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40271,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20252) ->
	#dungeon{id = 20252 ,sid = 20052 ,name = ?T("飞虹塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40274,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20253) ->
	#dungeon{id = 20253 ,sid = 20053 ,name = ?T("飞虹塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40277,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20254) ->
	#dungeon{id = 20254 ,sid = 20054 ,name = ?T("飞虹塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40280,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20255) ->
	#dungeon{id = 20255 ,sid = 20055 ,name = ?T("飞虹塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40283,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20256) ->
	#dungeon{id = 20256 ,sid = 20056 ,name = ?T("飞虹塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40286,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20257) ->
	#dungeon{id = 20257 ,sid = 20057 ,name = ?T("飞虹塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40289,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20258) ->
	#dungeon{id = 20258 ,sid = 20058 ,name = ?T("飞虹塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40292,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20259) ->
	#dungeon{id = 20259 ,sid = 20059 ,name = ?T("飞虹塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40295,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20260) ->
	#dungeon{id = 20260 ,sid = 20060 ,name = ?T("飞虹塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40298,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20261) ->
	#dungeon{id = 20261 ,sid = 20061 ,name = ?T("天诛塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40301,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20262) ->
	#dungeon{id = 20262 ,sid = 20062 ,name = ?T("天诛塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40304,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20263) ->
	#dungeon{id = 20263 ,sid = 20063 ,name = ?T("天诛塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40307,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20264) ->
	#dungeon{id = 20264 ,sid = 20064 ,name = ?T("天诛塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40310,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20265) ->
	#dungeon{id = 20265 ,sid = 20065 ,name = ?T("天诛塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40313,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20266) ->
	#dungeon{id = 20266 ,sid = 20066 ,name = ?T("天诛塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40316,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20267) ->
	#dungeon{id = 20267 ,sid = 20067 ,name = ?T("天诛塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40319,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20268) ->
	#dungeon{id = 20268 ,sid = 20068 ,name = ?T("天诛塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40322,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20269) ->
	#dungeon{id = 20269 ,sid = 20069 ,name = ?T("天诛塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40325,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20270) ->
	#dungeon{id = 20270 ,sid = 20070 ,name = ?T("天诛塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40328,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20271) ->
	#dungeon{id = 20271 ,sid = 20071 ,name = ?T("天诛塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40331,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20272) ->
	#dungeon{id = 20272 ,sid = 20072 ,name = ?T("天诛塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40334,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20273) ->
	#dungeon{id = 20273 ,sid = 20073 ,name = ?T("天诛塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40337,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20274) ->
	#dungeon{id = 20274 ,sid = 20074 ,name = ?T("天诛塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40340,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20275) ->
	#dungeon{id = 20275 ,sid = 20075 ,name = ?T("天诛塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40343,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20276) ->
	#dungeon{id = 20276 ,sid = 20076 ,name = ?T("天诛塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40346,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20277) ->
	#dungeon{id = 20277 ,sid = 20077 ,name = ?T("天诛塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40349,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20278) ->
	#dungeon{id = 20278 ,sid = 20078 ,name = ?T("天诛塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40352,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20279) ->
	#dungeon{id = 20279 ,sid = 20079 ,name = ?T("天诛塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40355,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20280) ->
	#dungeon{id = 20280 ,sid = 20080 ,name = ?T("天诛塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40358,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20281) ->
	#dungeon{id = 20281 ,sid = 20081 ,name = ?T("地灭塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40361,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20282) ->
	#dungeon{id = 20282 ,sid = 20082 ,name = ?T("地灭塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40364,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20283) ->
	#dungeon{id = 20283 ,sid = 20083 ,name = ?T("地灭塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40367,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20284) ->
	#dungeon{id = 20284 ,sid = 20084 ,name = ?T("地灭塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40370,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20285) ->
	#dungeon{id = 20285 ,sid = 20085 ,name = ?T("地灭塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40373,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20286) ->
	#dungeon{id = 20286 ,sid = 20086 ,name = ?T("地灭塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40376,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20287) ->
	#dungeon{id = 20287 ,sid = 20087 ,name = ?T("地灭塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40379,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20288) ->
	#dungeon{id = 20288 ,sid = 20088 ,name = ?T("地灭塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40382,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20289) ->
	#dungeon{id = 20289 ,sid = 20089 ,name = ?T("地灭塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40385,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20290) ->
	#dungeon{id = 20290 ,sid = 20090 ,name = ?T("地灭塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40388,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20291) ->
	#dungeon{id = 20291 ,sid = 20091 ,name = ?T("地灭塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40391,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20292) ->
	#dungeon{id = 20292 ,sid = 20092 ,name = ?T("地灭塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40394,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20293) ->
	#dungeon{id = 20293 ,sid = 20093 ,name = ?T("地灭塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40397,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20294) ->
	#dungeon{id = 20294 ,sid = 20094 ,name = ?T("地灭塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40400,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20295) ->
	#dungeon{id = 20295 ,sid = 20095 ,name = ?T("地灭塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40403,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20296) ->
	#dungeon{id = 20296 ,sid = 20096 ,name = ?T("地灭塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40406,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20297) ->
	#dungeon{id = 20297 ,sid = 20097 ,name = ?T("地灭塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40409,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20298) ->
	#dungeon{id = 20298 ,sid = 20098 ,name = ?T("地灭塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40412,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20299) ->
	#dungeon{id = 20299 ,sid = 20099 ,name = ?T("地灭塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40415,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20300) ->
	#dungeon{id = 20300 ,sid = 20100 ,name = ?T("地灭塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40418,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20301) ->
	#dungeon{id = 20301 ,sid = 20101 ,name = ?T("轮回塔1层"), type = 18 ,lv = 1 ,mon = [{1,[{40421,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20302) ->
	#dungeon{id = 20302 ,sid = 20102 ,name = ?T("轮回塔2层"), type = 18 ,lv = 1 ,mon = [{1,[{40424,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20303) ->
	#dungeon{id = 20303 ,sid = 20103 ,name = ?T("轮回塔3层"), type = 18 ,lv = 1 ,mon = [{1,[{40427,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20304) ->
	#dungeon{id = 20304 ,sid = 20104 ,name = ?T("轮回塔4层"), type = 18 ,lv = 1 ,mon = [{1,[{40430,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20305) ->
	#dungeon{id = 20305 ,sid = 20105 ,name = ?T("轮回塔5层"), type = 18 ,lv = 1 ,mon = [{1,[{40433,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20306) ->
	#dungeon{id = 20306 ,sid = 20106 ,name = ?T("轮回塔6层"), type = 18 ,lv = 1 ,mon = [{1,[{40436,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20307) ->
	#dungeon{id = 20307 ,sid = 20107 ,name = ?T("轮回塔7层"), type = 18 ,lv = 1 ,mon = [{1,[{40439,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20308) ->
	#dungeon{id = 20308 ,sid = 20108 ,name = ?T("轮回塔8层"), type = 18 ,lv = 1 ,mon = [{1,[{40442,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20309) ->
	#dungeon{id = 20309 ,sid = 20109 ,name = ?T("轮回塔9层"), type = 18 ,lv = 1 ,mon = [{1,[{40445,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20310) ->
	#dungeon{id = 20310 ,sid = 20110 ,name = ?T("轮回塔10层"), type = 18 ,lv = 1 ,mon = [{1,[{40448,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20311) ->
	#dungeon{id = 20311 ,sid = 20111 ,name = ?T("轮回塔11层"), type = 18 ,lv = 1 ,mon = [{1,[{40451,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20312) ->
	#dungeon{id = 20312 ,sid = 20112 ,name = ?T("轮回塔12层"), type = 18 ,lv = 1 ,mon = [{1,[{40454,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20313) ->
	#dungeon{id = 20313 ,sid = 20113 ,name = ?T("轮回塔13层"), type = 18 ,lv = 1 ,mon = [{1,[{40457,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20314) ->
	#dungeon{id = 20314 ,sid = 20114 ,name = ?T("轮回塔14层"), type = 18 ,lv = 1 ,mon = [{1,[{40460,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20315) ->
	#dungeon{id = 20315 ,sid = 20115 ,name = ?T("轮回塔15层"), type = 18 ,lv = 1 ,mon = [{1,[{40463,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20316) ->
	#dungeon{id = 20316 ,sid = 20116 ,name = ?T("轮回塔16层"), type = 18 ,lv = 1 ,mon = [{1,[{40466,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20317) ->
	#dungeon{id = 20317 ,sid = 20117 ,name = ?T("轮回塔17层"), type = 18 ,lv = 1 ,mon = [{1,[{40469,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20318) ->
	#dungeon{id = 20318 ,sid = 20118 ,name = ?T("轮回塔18层"), type = 18 ,lv = 1 ,mon = [{1,[{40472,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20319) ->
	#dungeon{id = 20319 ,sid = 20119 ,name = ?T("轮回塔19层"), type = 18 ,lv = 1 ,mon = [{1,[{40475,15,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(20320) ->
	#dungeon{id = 20320 ,sid = 20120 ,name = ?T("轮回塔20层"), type = 18 ,lv = 1 ,mon = [{1,[{40478,24,29}]}] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(50001) ->
	#dungeon{id = 50001 ,sid = 50001 ,name = ?T("坐骑副本"), type = 8 ,lv = 16 ,mon = [{1,[{10001,10,31},{10001,10,29},{10001,10,27},{10002,10,27},{10002,10,30},{10002,11,28},{10003,10,28},{10003,8,30},{10003,11,30},{10003,8,30}]},{2,[{10004,20,36},{10004,17,35},{10004,14,35},{10005,17,34},{10005,16,38},{10005,16,36},{10006,19,34},{10006,20,35},{10006,18,34},{10006,19,37}]},{3,[{10007,30,36},{10007,30,36},{10007,24,34},{10008,28,33},{10008,26,34},{10008,27,35},{10009,24,34},{10009,27,35},{10009,26,35},{10009,24,36}]},{4,[{10010,31,31},{10010,32,26},{10010,37,34},{10011,34,26},{10011,36,33},{10011,32,31},{10012,36,31},{10012,31,25},{10012,37,34},{10012,34,34}]},{5,[{10013,44,34},{10013,43,25},{10013,45,30},{10014,45,24},{10014,43,28},{10014,41,31},{10015,47,29},{10015,41,26},{10015,41,35},{10015,47,28}]},{6,[{10018,48,21}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,16},{lvdown,999}] ,scenes = [] ,out = [] };
get(50002) ->
	#dungeon{id = 50002 ,sid = 50002 ,name = ?T("仙羽副本"), type = 8 ,lv = 60 ,mon = [{1,[{10031,13,49},{10031,13,46},{10031,12,45},{10031,12,48},{10031,12,48},{10032,14,44},{10032,15,51},{10032,15,46},{10032,13,45},{10032,12,50},{10033,13,46},{10033,13,44},{10033,14,47},{10033,15,44},{10033,14,44}]},{2,[{10034,20,44},{10034,19,50},{10034,22,48},{10034,18,45},{10034,22,47},{10035,22,50},{10035,22,49},{10035,18,46},{10035,22,48},{10035,20,49},{10036,18,46},{10036,21,48},{10036,18,47},{10036,18,46},{10036,18,45}]},{3,[{10037,33,28},{10037,31,27},{10037,32,28},{10037,32,31},{10037,32,31},{10038,30,32},{10038,30,28},{10038,28,30},{10038,31,28},{10038,32,26},{10039,32,30},{10039,28,32},{10039,32,28},{10039,32,28},{10039,30,31}]},{4,[{10040,35,21},{10040,34,17},{10040,33,19},{10040,30,18},{10040,33,18},{10041,35,18},{10041,31,25},{10041,31,22},{10041,32,18},{10041,34,26},{10042,31,24},{10042,33,23},{10042,34,21},{10042,31,26},{10042,32,27}]},{5,[{10043,12,8},{10043,12,10},{10043,12,17},{10043,12,15},{10043,15,10},{10044,15,18},{10044,12,16},{10044,13,17},{10044,10,12},{10044,11,17},{10045,14,9},{10045,13,11},{10045,12,11},{10045,13,16},{10045,20,14}]},{6,[{10048,8,10}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,60},{lvdown,999}] ,scenes = [] ,out = [] };
get(50003) ->
	#dungeon{id = 50003 ,sid = 50003 ,name = ?T("法器副本"), type = 8 ,lv = 40 ,mon = [{1,[{10061,9,64},{10061,9,60},{10061,12,68},{10061,10,61},{10061,9,73},{10062,10,74},{10062,11,56},{10062,10,53},{10062,10,58},{10062,10,57},{10063,10,57},{10063,9,61},{10063,11,56},{10063,10,71},{10063,9,71}]},{2,[{10064,17,46},{10064,21,48},{10064,16,46},{10064,18,48},{10064,21,49},{10065,16,46},{10065,21,48},{10065,17,47},{10065,16,48},{10065,19,51},{10066,18,49},{10066,17,48},{10066,20,45},{10066,19,47},{10066,18,51}]},{3,[{10067,15,34},{10067,11,34},{10067,8,40},{10067,9,35},{10067,14,36},{10068,13,38},{10068,8,40},{10068,12,34},{10068,14,40},{10068,12,38},{10069,12,34},{10069,12,38},{10069,8,33},{10069,11,36},{10069,14,39}]},{4,[{10070,15,24},{10070,12,26},{10070,14,27},{10070,15,25},{10070,11,22},{10071,15,27},{10071,17,24},{10071,11,22},{10071,17,23},{10071,10,26},{10072,16,25},{10072,14,25},{10072,15,28},{10072,15,23},{10072,12,22}]},{5,[{10073,24,17},{10073,27,19},{10073,26,17},{10073,24,22},{10073,27,17},{10074,23,23},{10074,23,22},{10074,21,23},{10074,24,19},{10074,25,22},{10075,25,23},{10075,26,16},{10075,26,22},{10075,23,21},{10075,27,21}]},{6,[{10078,25,20}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,40},{lvdown,999}] ,scenes = [] ,out = [] };
get(50004) ->
	#dungeon{id = 50004 ,sid = 50004 ,name = ?T("神兵副本"), type = 8 ,lv = 58 ,mon = [{1,[{10091,13,71},{10091,14,71},{10091,15,71},{10091,16,71},{10091,17,71},{10092,18,71},{10092,18,72},{10092,17,72},{10092,16,72},{10092,15,72},{10093,14,72},{10093,13,72},{10093,13,73},{10093,13,73},{10093,13,73}]},{2,[{10094,18,79},{10094,19,79},{10094,20,79},{10094,21,79},{10094,22,79},{10095,23,79},{10095,24,79},{10095,24,80},{10095,23,80},{10095,22,80},{10096,21,80},{10096,20,80},{10096,20,81},{10096,21,81},{10096,22,81}]},{3,[{10097,25,76},{10097,28,79},{10097,24,78},{10097,26,78},{10097,23,75},{10098,21,79},{10098,19,75},{10098,21,76},{10098,27,73},{10098,28,83},{10099,24,82},{10099,26,78},{10099,23,74},{10099,21,81},{10099,19,72}]},{4,[{10100,20,57},{10100,21,57},{10101,22,57},{10101,23,57},{10101,21,54},{10102,22,54},{10102,23,54},{10102,24,54}]},{5,[{10103,20,42},{10103,24,42},{10103,21,43},{10103,25,45},{10104,24,47},{10104,26,48},{10104,21,43},{10104,26,42},{10104,29,43},{10105,20,42},{10105,24,42},{10105,21,43},{10105,25,42},{10105,23,47}]},{6,[{10108,29,37}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,58},{lvdown,999}] ,scenes = [] ,out = [] };
get(50005) ->
	#dungeon{id = 50005 ,sid = 50005 ,name = ?T("宠物副本"), type = 8 ,lv = 20 ,mon = [{1,[{10121,33,59},{10121,33,56},{10121,33,55},{10121,33,53},{10121,34,52},{10122,35,51},{10122,36,50},{10122,36,49},{10122,35,55},{10122,35,54},{10123,34,54},{10123,33,56},{10123,32,58},{10123,36,52},{10123,35,54}]},{2,[{10124,27,55},{10124,29,53},{10124,30,52},{10124,31,51},{10124,31,50},{10125,32,49},{10125,34,50},{10125,30,55},{10125,31,53},{10125,32,52},{10126,33,51},{10126,35,51},{10126,30,57},{10126,31,55},{10126,31,57}]},{3,[{10127,20,37},{10127,20,36},{10127,21,35},{10127,22,34},{10127,23,33},{10128,25,34},{10128,25,32},{10128,26,32},{10128,27,33},{10128,25,35},{10129,20,34},{10129,22,33},{10129,23,31},{10129,24,33},{10129,25,34}]},{4,[{10130,26,25},{10130,28,27},{10130,28,28},{10130,29,29},{10130,30,30},{10131,25,27},{10131,23,29},{10131,22,30},{10131,21,30},{10131,26,28},{10132,26,31},{10132,25,23},{10132,23,24},{10132,22,25},{10132,23,30}]},{5,[{10133,17,25},{10133,18,24},{10133,19,23},{10133,21,22},{10134,21,21},{10134,23,19},{10134,20,24},{10134,25,21},{10134,23,21},{10135,22,23},{10135,19,23},{10135,21,22},{10135,21,21},{10135,20,25}]},{6,[{10138,9,10}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,20},{lvdown,999}] ,scenes = [] ,out = [] };
get(50006) ->
	#dungeon{id = 50006 ,sid = 50006 ,name = ?T("妖灵副本"), type = 8 ,lv = 62 ,mon = [{1,[{10151,10,67},{10151,12,65},{10151,13,63},{10151,14,64},{10151,13,65},{10152,11,67},{10152,12,69},{10152,14,67},{10152,15,65},{10152,17,67},{10153,15,68},{10153,14,70},{10153,15,72},{10153,16,70},{10153,18,68}]},{2,[{10154,23,73},{10154,21,74},{10154,19,76},{10154,18,74},{10154,19,72},{10155,21,71},{10155,20,69},{10155,16,70},{10155,16,72},{10155,15,72},{10156,16,70},{10156,18,67},{10156,26,58},{10156,27,60},{10156,26,60}]},{3,[{10157,18,34},{10157,19,33},{10157,20,31},{10157,19,29},{10157,18,30},{10158,17,32},{10158,16,30},{10158,17,29},{10158,18,27},{10158,17,25},{10159,16,27},{10159,15,28},{10159,13,25},{10159,15,24},{10159,16,22}]},{4,[{10160,7,19},{10160,8,18},{10160,5,20},{10160,10,15},{10160,11,15},{10161,13,14},{10161,11,16},{10161,10,16},{10161,9,19},{10161,8,21},{10162,7,23},{10162,9,24},{10162,10,21},{10162,12,19},{10162,14,18}]},{5,[{10163,18,28},{10163,19,27},{10163,20,26},{10163,19,29},{10163,18,30},{10164,17,32},{10164,16,30},{10164,17,29},{10164,18,27},{10164,17,25},{10165,16,27},{10165,15,28},{10165,13,25},{10165,15,24},{10165,16,22}]},{6,[{10168,9,19}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(50007) ->
	#dungeon{id = 50007 ,sid = 50007 ,name = ?T("足迹副本"), type = 8 ,lv = 66 ,mon = [{1,[{10181,14,47},{10181,15,46},{10181,15,48},{10181,16,49},{10181,16,48},{10182,15,47},{10182,15,45},{10182,16,46},{10182,17,48},{10182,18,47},{10183,17,46},{10183,16,44},{10183,17,43},{10183,18,44},{10183,19,46}]},{2,[{10184,20,40},{10184,21,41},{10184,22,42},{10184,21,38},{10184,22,39},{10185,23,41},{10185,24,39},{10185,23,38},{10185,22,36},{10185,23,35},{10186,24,37},{10186,25,38},{10186,26,38},{10186,23,34},{10186,25,36}]},{3,[{10187,25,30},{10187,24,31},{10187,23,33},{10187,23,31},{10187,23,40},{10188,24,29},{10188,23,29},{10188,22,30},{10188,25,29},{10188,28,31},{10189,27,32},{10189,28,30},{10189,26,31},{10189,25,32},{10189,24,27}]},{4,[{10190,36,51},{10190,37,49},{10190,38,48},{10190,39,47},{10190,39,45},{10191,38,46},{10191,37,47},{10191,36,48},{10191,35,49},{10191,34,49},{10192,35,47},{10192,36,45},{10192,37,44},{10192,37,43},{10192,36,44}]},{5,[{10193,25,30},{10193,24,31},{10193,23,33},{10193,23,31},{10193,23,40},{10194,24,29},{10194,23,29},{10194,22,30},{10194,29,30},{10194,30,31},{10195,31,32},{10195,31,30},{10195,31,28},{10195,30,28},{10195,31,27}]},{6,[{10198,35,21}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,66},{lvdown,999}] ,scenes = [] ,out = [] };
get(50008) ->
	#dungeon{id = 50008 ,sid = 50008 ,name = ?T("灵猫副本"), type = 8 ,lv = 70 ,mon = [{1,[{10211,20,61},{10211,21,61},{10211,22,61},{10212,17,60},{10212,18,60},{10212,19,60},{10212,20,60},{10212,21,60},{10213,22,60},{10213,18,59},{10213,19,59},{10213,20,59},{10213,21,59}]},{2,[{10214,5,46},{10214,6,46},{10214,7,46},{10214,8,46},{10214,9,46},{10215,6,48},{10215,7,48},{10215,8,48},{10215,9,48},{10215,10,48},{10216,5,51},{10216,6,51},{10216,7,51},{10216,8,51},{10216,9,51}]},{3,[{10217,10,39},{10217,11,39},{10217,12,39},{10217,13,39},{10217,14,39},{10218,11,40},{10218,12,40},{10218,13,40},{10218,14,40},{10219,10,41},{10219,11,41},{10219,12,41},{10219,13,41},{10219,14,41}]},{4,[{10220,17,29},{10220,18,28},{10220,19,28},{10220,20,28},{10220,21,28},{10221,17,29},{10221,18,29},{10221,19,29},{10221,20,29},{10222,20,26},{10222,21,26},{10222,22,26},{10222,23,26}]},{5,[{10223,22,16},{10223,23,16},{10223,24,16},{10223,25,16},{10223,26,16},{10224,23,18},{10224,24,18},{10224,25,18},{10224,26,18},{10224,27,18},{10225,22,20},{10225,23,20},{10225,24,20},{10225,25,20},{10225,26,20}]},{6,[{10228,27,16}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,70},{lvdown,999}] ,scenes = [] ,out = [] };
get(50009) ->
	#dungeon{id = 50009 ,sid = 50009 ,name = ?T("法身副本"), type = 8 ,lv = 72 ,mon = [{1,[{10241,10,31},{10241,10,29},{10241,10,27},{10242,10,27},{10242,10,30},{10242,11,28},{10243,10,28},{10243,8,30},{10243,11,30},{10243,8,30}]},{2,[{10244,20,36},{10244,17,35},{10244,14,35},{10245,17,34},{10245,16,38},{10245,16,36},{10246,19,34},{10246,20,35},{10246,18,34},{10246,19,37}]},{3,[{10247,30,36},{10247,30,36},{10247,24,34},{10248,28,33},{10248,26,34},{10248,27,35},{10249,24,34},{10249,27,35},{10249,26,35},{10249,24,36}]},{4,[{10250,31,31},{10250,32,26},{10250,37,34},{10251,34,26},{10251,36,33},{10251,32,31},{10252,36,31},{10252,31,25},{10252,37,34},{10252,34,34}]},{5,[{10253,44,34},{10253,43,25},{10253,45,30},{10254,45,24},{10254,43,28},{10254,41,31},{10255,47,29},{10255,41,26},{10255,41,35},{10255,47,28}]},{6,[{10258,48,21}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,72},{lvdown,999}] ,scenes = [] ,out = [] };
get(50010) ->
	#dungeon{id = 50010 ,sid = 50010 ,name = ?T("宝宝副本"), type = 8 ,lv = 59 ,mon = [{1,[{10271,10,31},{10271,10,29},{10271,10,27},{10272,10,27},{10272,10,30},{10272,11,28},{10273,10,28},{10273,8,30},{10273,11,30},{10273,8,30}]},{2,[{10274,20,36},{10274,17,35},{10274,14,35},{10275,17,34},{10275,16,38},{10275,16,36},{10276,19,34},{10276,20,35},{10276,18,34},{10276,19,37}]},{3,[{10277,30,36},{10277,30,36},{10277,24,34},{10278,28,33},{10278,26,34},{10278,27,35},{10279,24,34},{10279,27,35},{10279,26,35},{10279,24,36}]},{4,[{10280,31,31},{10280,32,26},{10280,37,34},{10281,34,26},{10281,36,33},{10281,32,31},{10282,36,31},{10282,31,25},{10282,37,34},{10282,34,34}]},{5,[{10283,44,34},{10283,43,25},{10283,45,30},{10284,45,24},{10284,43,28},{10284,41,31},{10285,47,29},{10285,41,26},{10285,41,35},{10285,47,28}]},{6,[{10288,48,21}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,59},{lvdown,999}] ,scenes = [] ,out = [] };
get(50011) ->
	#dungeon{id = 50011 ,sid = 50011 ,name = ?T("灵羽副本"), type = 8 ,lv = 59 ,mon = [{1,[{10301,13,49},{10301,13,46},{10301,12,45},{10301,12,48},{10301,12,48},{10302,14,44},{10302,15,51},{10302,15,46},{10302,13,45},{10302,12,50},{10303,13,46},{10303,13,44},{10303,14,47},{10303,15,44},{10303,14,44}]},{2,[{10304,20,44},{10304,19,50},{10304,22,48},{10304,18,45},{10304,22,47},{10305,22,50},{10305,22,49},{10305,18,46},{10305,22,48},{10305,20,49},{10306,18,46},{10306,21,48},{10306,18,47},{10306,18,46},{10306,18,45}]},{3,[{10307,33,28},{10307,31,27},{10307,32,28},{10307,32,31},{10307,32,31},{10308,30,32},{10308,30,28},{10308,28,30},{10308,31,28},{10308,32,26},{10309,32,30},{10309,28,32},{10309,32,28},{10309,32,28},{10309,30,31}]},{4,[{10310,35,21},{10310,34,17},{10310,33,19},{10310,30,18},{10310,33,18},{10311,35,18},{10311,31,25},{10311,31,22},{10311,32,18},{10311,34,26},{10312,31,24},{10312,33,23},{10312,34,21},{10312,31,26},{10312,32,27}]},{5,[{10313,12,8},{10313,12,10},{10313,12,17},{10313,12,15},{10313,15,10},{10314,15,18},{10314,12,16},{10314,13,17},{10314,10,12},{10314,11,17},{10315,14,9},{10315,13,11},{10315,12,11},{10315,13,16},{10315,20,14}]},{6,[{10318,8,10}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,59},{lvdown,999}] ,scenes = [] ,out = [] };
get(50012) ->
	#dungeon{id = 50012 ,sid = 50012 ,name = ?T("灵骑副本"), type = 8 ,lv = 90 ,mon = [{1,[{10331,14,47},{10331,15,46},{10331,15,48},{10331,16,49},{10331,16,48},{10332,15,47},{10332,15,45},{10332,16,46},{10332,17,48},{10332,18,47},{10333,17,46},{10333,16,44},{10333,17,43},{10333,18,44},{10333,19,46}]},{2,[{10334,20,40},{10334,21,41},{10334,22,42},{10334,21,38},{10334,22,39},{10335,23,41},{10335,24,39},{10335,23,38},{10335,22,36},{10335,23,35},{10336,24,37},{10336,25,38},{10336,26,38},{10336,23,34},{10336,25,36}]},{3,[{10337,25,30},{10337,24,31},{10337,23,33},{10337,23,31},{10337,23,40},{10338,24,29},{10338,23,29},{10338,22,30},{10338,25,29},{10338,28,31},{10339,27,32},{10339,28,30},{10339,26,31},{10339,25,32},{10339,24,27}]},{4,[{10340,36,51},{10340,37,49},{10340,38,48},{10340,39,47},{10340,39,45},{10341,38,46},{10341,37,47},{10341,36,48},{10341,35,49},{10341,34,49},{10342,35,47},{10342,36,45},{10342,37,44},{10342,37,43},{10342,36,44}]},{5,[{10343,25,30},{10343,24,31},{10343,23,33},{10343,23,31},{10343,23,40},{10344,24,29},{10344,23,29},{10344,22,30},{10344,29,30},{10344,30,31},{10345,31,32},{10345,31,30},{10345,31,28},{10345,30,28},{10345,31,27}]},{6,[{10348,35,21}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(50013) ->
	#dungeon{id = 50013 ,sid = 50013 ,name = ?T("灵弓副本"), type = 8 ,lv = 95 ,mon = [{1,[{10361,10,67},{10361,12,65},{10361,13,63},{10361,14,64},{10361,13,65},{10362,11,67},{10362,12,69},{10362,14,67},{10362,15,65},{10362,17,67},{10363,15,68},{10363,14,70},{10363,15,72},{10363,16,70},{10363,18,68}]},{2,[{10364,23,73},{10364,21,74},{10364,19,76},{10364,18,74},{10364,19,72},{10365,21,71},{10365,20,69},{10365,16,70},{10365,16,72},{10365,15,72},{10366,16,70},{10366,18,67},{10366,26,58},{10366,27,60},{10366,26,60}]},{3,[{10367,18,34},{10367,19,33},{10367,20,31},{10367,19,29},{10367,18,30},{10368,17,32},{10368,16,30},{10368,17,29},{10368,18,27},{10368,17,25},{10369,16,27},{10369,15,28},{10369,13,25},{10369,15,24},{10369,16,22}]},{4,[{10370,7,19},{10370,8,18},{10370,5,20},{10370,10,15},{10370,11,15},{10371,13,14},{10371,11,16},{10371,10,16},{10371,9,19},{10371,8,21},{10372,7,23},{10372,9,24},{10372,10,21},{10372,12,19},{10372,14,18}]},{5,[{10373,18,28},{10373,19,27},{10373,20,26},{10373,19,29},{10373,18,30},{10374,17,32},{10374,16,30},{10374,17,29},{10374,18,27},{10374,17,25},{10375,16,27},{10375,15,28},{10375,13,25},{10375,15,24},{10375,16,22}]},{6,[{10378,9,19}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,95},{lvdown,999}] ,scenes = [] ,out = [] };
get(50014) ->
	#dungeon{id = 50014 ,sid = 50014 ,name = ?T("灵佩副本"), type = 8 ,lv = 120 ,mon = [{1,[{10391,13,49},{10391,13,46},{10391,12,45},{10391,12,48},{10391,12,48},{10392,14,44},{10392,15,51},{10392,15,46},{10392,13,45},{10392,12,50},{10393,13,46},{10393,13,44},{10393,14,47},{10393,15,44},{10393,14,44}]},{2,[{10394,20,44},{10394,19,50},{10394,22,48},{10394,18,45},{10394,22,47},{10395,22,50},{10395,22,49},{10395,18,46},{10395,22,48},{10395,20,49},{10396,18,46},{10396,21,48},{10396,18,47},{10396,18,46},{10396,18,45}]},{3,[{10397,33,28},{10397,31,27},{10397,32,28},{10397,32,31},{10397,32,31},{10398,30,32},{10398,30,28},{10398,28,30},{10398,31,28},{10398,32,26},{10399,32,30},{10399,28,32},{10399,32,28},{10399,32,28},{10399,30,31}]},{4,[{10400,35,21},{10400,34,17},{10400,33,19},{10400,30,18},{10400,33,18},{10401,35,18},{10401,31,25},{10401,31,22},{10401,32,18},{10401,34,26},{10402,31,24},{10402,33,23},{10402,34,21},{10402,31,26},{10402,32,27}]},{5,[{10403,12,8},{10403,12,10},{10403,12,17},{10403,12,15},{10403,15,10},{10404,15,18},{10404,12,16},{10404,13,17},{10404,10,12},{10404,11,17},{10405,14,9},{10405,13,11},{10405,12,11},{10405,13,16},{10405,20,14}]},{6,[{10408,8,10}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(50015) ->
	#dungeon{id = 50015 ,sid = 50015 ,name = ?T("仙宝副本"), type = 8 ,lv = 110 ,mon = [{1,[{10421,9,64},{10421,9,60},{10421,12,68},{10421,10,61},{10421,9,73},{10422,10,74},{10422,11,56},{10422,10,53},{10422,10,58},{10422,12,58},{10423,12,58},{10423,9,61},{10423,11,56},{10423,10,71},{10423,9,71}]},{2,[{10424,17,46},{10424,21,48},{10424,16,46},{10424,16,45},{10424,21,49},{10425,15,46},{10425,21,48},{10425,15,46},{10425,16,48},{10425,19,51},{10426,18,49},{10426,17,48},{10426,20,45},{10426,19,47},{10426,18,51}]},{3,[{10427,15,34},{10427,11,34},{10427,8,40},{10427,9,35},{10427,14,36},{10428,13,38},{10428,8,40},{10428,12,34},{10428,14,40},{10428,12,38},{10429,12,34},{10429,12,38},{10429,8,33},{10429,11,36},{10429,14,39}]},{4,[{10430,15,24},{10430,12,26},{10430,14,27},{10430,15,25},{10430,11,22},{10431,15,27},{10431,17,24},{10431,11,22},{10431,17,23},{10431,10,26},{10432,16,25},{10432,14,25},{10432,15,28},{10432,15,23},{10432,12,22}]},{5,[{10433,24,17},{10433,27,19},{10433,26,17},{10433,24,22},{10433,27,17},{10434,23,23},{10434,23,22},{10434,21,23},{10434,21,16},{10434,25,22},{10435,25,23},{10435,26,16},{10435,26,22},{10435,23,21},{10435,27,21}]},{6,[{10438,25,20}]}] ,round_time = 0 ,time = 300 ,count = 4 ,condition = [{lvup,110},{lvdown,999}] ,scenes = [] ,out = [] };
get(51001) ->
	#dungeon{id = 51001 ,sid = 51001 ,name = ?T("求道蜀山难"), type = 14 ,lv = 13 ,mon = [{1,[{38001,16,45},{38001,16,47},{38001,16,51},{38001,16,47},{38001,16,44},{38002,17,47},{38002,17,49},{38002,17,49},{38002,16,47},{38002,16,45},{38003,17,44},{38003,18,47},{38003,18,49},{38003,19,48},{38003,18,45}]},{2,[{38004,17,44},{38004,18,47},{38004,18,49},{38004,19,48},{38004,19,46},{38005,18,44},{38005,18,42},{38005,19,44},{38005,20,46},{38005,21,47},{38006,22,46},{38006,20,41},{38006,21,40},{38006,25,43},{38006,19,44}]},{3,[{38007,31,22},{38007,33,22},{38007,35,22},{38007,37,22},{38007,31,20},{38008,33,20},{38008,35,20},{38008,37,20},{38008,34,23},{38008,32,23},{38009,37,20},{38009,33,20},{38009,36,20},{38009,33,22},{38009,32,20},{38009,38,18},{38009,37,15},{38009,32,18},{38009,34,18},{38009,35,18},{38009,35,19}]},{4,[{38015,10,13}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,13},{lvdown,999}] ,scenes = [] ,out = [] };
get(51002) ->
	#dungeon{id = 51002 ,sid = 51002 ,name = ?T("竹海幽径深"), type = 14 ,lv = 40 ,mon = [{1,[{38031,10,31},{38031,10,29},{38031,10,27},{38032,10,27},{38032,10,30},{38032,11,28},{38033,10,28},{38033,8,30},{38033,11,30},{38033,8,30}]},{2,[{38034,20,36},{38034,17,35},{38034,14,35},{38035,17,34},{38035,16,38},{38035,16,36},{38036,19,34},{38036,20,35},{38036,18,34},{38036,19,37}]},{3,[{38037,30,36},{38037,30,36},{38037,24,34},{38038,28,33},{38038,26,34},{38038,27,35},{38039,24,34},{38039,27,35},{38039,26,35},{38039,24,36}]},{4,[{38040,31,31},{38040,32,26},{38040,37,34},{38041,34,26},{38041,36,33},{38041,32,31},{38042,36,31},{38042,31,25},{38042,37,34},{38042,34,34}]},{5,[{38043,44,34},{38043,43,25},{38043,45,30},{38044,45,24},{38044,43,28},{38044,41,31},{38045,47,29},{38045,41,26},{38045,41,35},{38045,47,28}]},{6,[{38048,48,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,40},{lvdown,999}] ,scenes = [] ,out = [] };
get(51003) ->
	#dungeon{id = 51003 ,sid = 51003 ,name = ?T("剑阁观天衍"), type = 14 ,lv = 55 ,mon = [{1,[{38061,14,47},{38061,15,46},{38061,15,48},{38061,16,49},{38061,16,48},{38062,15,47},{38062,15,45},{38062,16,46},{38062,17,48},{38062,18,47},{38063,17,46},{38063,16,44},{38063,17,43},{38063,18,44},{38063,19,46}]},{2,[{38064,20,40},{38064,21,41},{38064,22,42},{38064,21,38},{38064,22,39},{38065,23,41},{38065,24,39},{38065,23,38},{38065,22,36},{38065,23,35},{38066,24,37},{38066,25,38},{38066,26,38},{38066,23,34},{38066,25,36}]},{3,[{38067,25,30},{38067,24,31},{38067,23,33},{38067,23,31},{38067,23,40},{38068,24,29},{38068,23,29},{38068,22,30},{38068,25,29},{38068,28,31},{38069,27,32},{38069,28,30},{38069,26,31},{38069,25,32},{38069,24,27}]},{4,[{38070,36,51},{38070,37,49},{38070,38,48},{38070,39,47},{38070,39,45},{38071,38,46},{38071,37,47},{38071,36,48},{38071,35,49},{38071,34,49},{38072,35,47},{38072,36,45},{38072,37,44},{38072,37,43},{38072,36,44}]},{5,[{38073,25,30},{38073,24,31},{38073,23,33},{38073,23,31},{38073,23,40},{38074,24,29},{38074,23,29},{38074,22,30},{38074,29,30},{38074,30,31},{38075,31,32},{38075,31,30},{38075,31,28},{38075,30,28},{38075,31,27}]},{6,[{38078,35,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,55},{lvdown,999}] ,scenes = [] ,out = [] };
get(51004) ->
	#dungeon{id = 51004 ,sid = 51004 ,name = ?T("青云寻渡口"), type = 14 ,lv = 65 ,mon = [{1,[{38091,13,71},{38091,14,71},{38091,15,71},{38091,16,71},{38091,17,71},{38092,18,71},{38092,18,72},{38092,17,72},{38092,16,72},{38092,15,72},{38093,14,72},{38093,13,72},{38093,13,73},{38093,13,73},{38093,13,73}]},{2,[{38094,18,79},{38094,19,79},{38094,20,79},{38094,21,79},{38094,22,79},{38095,23,79},{38095,24,79},{38095,24,80},{38095,23,80},{38095,22,80},{38096,21,80},{38096,20,80},{38096,20,81},{38096,21,81},{38096,22,81}]},{3,[{38097,25,76},{38097,28,79},{38097,24,78},{38097,26,78},{38097,23,75},{38098,21,79},{38098,19,75},{38098,21,76},{38098,27,73},{38098,28,83},{38099,24,82},{38099,26,78},{38099,23,74},{38099,21,81},{38099,19,72}]},{4,[{38100,20,57},{38100,21,57},{38101,22,57},{38101,23,57},{38101,21,54},{38102,22,54},{38102,23,54},{38102,24,54}]},{5,[{38103,20,42},{38103,24,42},{38103,21,43},{38103,25,45},{38104,24,47},{38104,26,48},{38104,21,43},{38104,26,42},{38104,29,43},{38105,20,42},{38105,24,42},{38105,21,43},{38105,25,42},{38105,23,47}]},{6,[{38108,29,37}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,65},{lvdown,999}] ,scenes = [] ,out = [] };
get(51005) ->
	#dungeon{id = 51005 ,sid = 51005 ,name = ?T("夜访蓬莱院"), type = 14 ,lv = 75 ,mon = [{1,[{38121,17,31},{38121,19,30},{38121,21,32},{38121,20,33},{38121,20,36},{38122,23,36},{38122,23,33},{38122,23,30},{38122,22,27},{38122,21,26},{38123,19,25},{38123,17,25},{38123,24,33},{38123,23,30},{38123,23,28}]},{2,[{38124,17,25},{38124,18,22},{38124,20,23},{38124,21,22},{38124,22,22},{38125,23,23},{38125,21,22},{38125,20,23},{38125,19,25},{38125,18,27},{38126,19,28},{38126,21,26},{38126,22,24},{38126,24,22},{38126,25,24}]},{3,[{38127,26,32},{38127,28,32},{38127,30,33},{38127,32,33},{38127,32,30},{38128,30,30},{38128,28,30},{38128,26,30},{38128,26,28},{38128,28,28},{38129,29,28},{38129,31,28},{38129,31,31},{38129,31,34},{38129,25,30},{38129,33,15}]},{4,[{38130,34,17},{38130,35,18},{38130,36,21},{38130,37,23},{38130,31,16},{38131,32,18},{38131,33,21},{38131,34,23},{38131,35,23},{38131,37,25},{38132,35,26},{38132,34,24},{38132,32,22},{38132,31,21},{38132,37,38}]},{5,[{38133,38,36},{38133,40,34},{38133,41,32},{38133,41,29},{38133,41,28},{38134,40,26},{38134,39,30},{38134,38,31},{38134,37,33},{38134,35,35},{38135,34,37},{38135,33,34},{38135,35,32},{38135,36,29},{38135,42,32}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,75},{lvdown,999}] ,scenes = [] ,out = [] };
get(51006) ->
	#dungeon{id = 51006 ,sid = 51006 ,name = ?T("诛仙破囚牢"), type = 14 ,lv = 85 ,mon = [{1,[{38151,9,64},{38151,9,60},{38151,12,68},{38151,10,61},{38151,9,73},{38152,10,74},{38152,11,56},{38152,10,53},{38152,10,58},{38152,12,58},{38153,12,58},{38153,9,61},{38153,11,56},{38153,10,71},{38153,9,71}]},{2,[{38154,17,46},{38154,21,48},{38154,16,46},{38154,16,45},{38154,21,49},{38155,15,46},{38155,21,48},{38155,15,46},{38155,16,48},{38155,19,51},{38156,18,49},{38156,17,48},{38156,20,45},{38156,19,47},{38156,18,51}]},{3,[{38157,15,34},{38157,11,34},{38157,8,40},{38157,9,35},{38157,14,36},{38158,13,38},{38158,8,40},{38158,12,34},{38158,14,40},{38158,12,38},{38159,12,34},{38159,12,38},{38159,8,33},{38159,11,36},{38159,14,39}]},{4,[{38160,15,24},{38160,12,26},{38160,14,27},{38160,15,25},{38160,11,22},{38161,15,27},{38161,17,24},{38161,11,22},{38161,17,23},{38161,10,26},{38162,16,25},{38162,14,25},{38162,15,28},{38162,15,23},{38162,12,22}]},{5,[{38163,24,17},{38163,27,19},{38163,26,17},{38163,24,22},{38163,27,17},{38164,23,23},{38164,23,22},{38164,21,23},{38164,21,16},{38164,25,22},{38165,25,23},{38165,26,16},{38165,26,22},{38165,23,21},{38165,27,21}]},{6,[{38168,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,85},{lvdown,999}] ,scenes = [] ,out = [] };
get(51007) ->
	#dungeon{id = 51007 ,sid = 51007 ,name = ?T("攀天云台路"), type = 14 ,lv = 95 ,mon = [{1,[{38181,33,59},{38181,33,56},{38181,33,55},{38181,33,53},{38181,34,52},{38182,35,51},{38182,36,50},{38182,36,49},{38182,35,55},{38182,35,54},{38183,34,54},{38183,33,56},{38183,32,58},{38183,36,52},{38183,35,54}]},{2,[{38184,27,55},{38184,29,53},{38184,30,52},{38184,31,51},{38184,31,50},{38185,32,49},{38185,34,50},{38185,30,55},{38185,31,53},{38185,32,52},{38186,33,51},{38186,35,51},{38186,30,57},{38186,31,55},{38186,31,57}]},{3,[{38187,20,37},{38187,20,36},{38187,21,35},{38187,22,34},{38187,23,33},{38188,25,34},{38188,25,32},{38188,26,32},{38188,27,33},{38188,25,35},{38189,20,34},{38189,22,33},{38189,23,31},{38189,24,33},{38189,25,34}]},{4,[{38190,26,25},{38190,28,27},{38190,28,28},{38190,29,29},{38190,30,30},{38191,25,27},{38191,23,29},{38191,22,30},{38191,21,30},{38191,26,28},{38192,26,31},{38192,25,23},{38192,23,24},{38192,22,25},{38192,23,30}]},{5,[{38193,17,25},{38193,18,24},{38193,19,23},{38193,21,22},{38194,21,21},{38194,23,19},{38194,20,24},{38194,25,21},{38194,23,21},{38195,22,23},{38195,19,23},{38195,21,22},{38195,21,21},{38195,20,25}]},{6,[{38198,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,95},{lvdown,999}] ,scenes = [] ,out = [] };
get(51008) ->
	#dungeon{id = 51008 ,sid = 51008 ,name = ?T("暗影锁龙城"), type = 14 ,lv = 105 ,mon = [{1,[{38211,10,67},{38211,12,65},{38211,13,63},{38211,14,64},{38211,13,65},{38212,11,67},{38212,12,69},{38212,14,67},{38212,15,65},{38212,17,67},{38213,15,68},{38213,14,70},{38213,15,72},{38213,16,70},{38213,18,68}]},{2,[{38214,23,73},{38214,21,74},{38214,19,76},{38214,18,74},{38214,19,72},{38215,21,71},{38215,20,69},{38215,16,70},{38215,16,72},{38215,15,72},{38216,16,70},{38216,18,67},{38216,26,58},{38216,27,60},{38216,26,60}]},{3,[{38217,18,34},{38217,19,33},{38217,20,31},{38217,19,29},{38217,18,30},{38218,17,32},{38218,16,30},{38218,17,29},{38218,18,27},{38218,17,25},{38219,16,27},{38219,15,28},{38219,13,25},{38219,15,24},{38219,16,22}]},{4,[{38220,7,19},{38220,8,18},{38220,5,20},{38220,10,15},{38220,11,15},{38221,13,14},{38221,11,16},{38221,10,16},{38221,9,19},{38221,8,21},{38222,7,23},{38222,9,24},{38222,10,21},{38222,12,19},{38222,14,18}]},{5,[{38223,18,28},{38223,19,27},{38223,20,26},{38223,19,29},{38223,18,30},{38224,17,32},{38224,16,30},{38224,17,29},{38224,18,27},{38224,17,25},{38225,16,27},{38225,15,28},{38225,13,25},{38225,15,24},{38225,16,22}]},{6,[{38228,9,19}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,105},{lvdown,999}] ,scenes = [] ,out = [] };
get(51009) ->
	#dungeon{id = 51009 ,sid = 51009 ,name = ?T("青木迷树海"), type = 14 ,lv = 115 ,mon = [{1,[{38241,13,43},{38241,12,44},{38241,11,46},{38241,10,47},{38241,12,48},{38242,13,46},{38242,14,44},{38242,15,45},{38242,14,46},{38242,13,47},{38243,13,49},{38243,13,52},{38243,15,48},{38243,16,46},{38243,16,48}]},{2,[{38244,24,46},{38244,25,48},{38244,26,50},{38244,25,45},{38244,26,47},{38245,27,49},{38245,27,43},{38245,27,46},{38245,28,46},{38245,29,49},{38246,28,42},{38246,29,45},{38246,30,47},{38246,29,41},{38246,30,43}]},{3,[{38247,29,49},{38247,28,42},{38247,29,45},{38247,30,47},{38247,29,41},{38248,30,43},{38248,18,47},{38248,18,49},{38248,18,51},{38248,18,53},{38249,17,56},{38249,19,56},{38249,22,50},{38249,21,50},{38249,17,49}]},{4,[{38250,29,37},{38250,31,38},{38250,32,39},{38250,33,41},{38250,35,43},{38251,35,40},{38251,34,37},{38251,31,35},{38251,29,34},{38251,27,35},{38252,32,45},{38252,37,43},{38252,37,39},{38252,36,36},{38252,35,35}]},{5,[{38253,29,30},{38253,32,30},{38253,33,30},{38253,35,30},{38253,37,31},{38254,38,31},{38254,40,33},{38254,39,36},{38254,37,34},{38254,35,25},{38255,35,25},{38255,35,25},{38255,35,25},{38255,35,25},{38255,35,25}]},{6,[{38258,35,25}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,115},{lvdown,999}] ,scenes = [] ,out = [] };
get(51010) ->
	#dungeon{id = 51010 ,sid = 51010 ,name = ?T("东海玲珑宫"), type = 14 ,lv = 125 ,mon = [{1,[{38271,20,61},{38271,21,61},{38271,22,61},{38272,17,60},{38272,18,60},{38272,19,60},{38272,20,60},{38272,21,60},{38273,22,60},{38273,18,59},{38273,19,59},{38273,20,59},{38273,21,59}]},{2,[{38274,5,46},{38274,6,46},{38274,7,46},{38274,8,46},{38274,9,46},{38275,6,48},{38275,7,48},{38275,8,48},{38275,9,48},{38275,10,48},{38276,5,51},{38276,6,51},{38276,7,51},{38276,8,51},{38276,9,51}]},{3,[{38277,10,39},{38277,11,39},{38277,12,39},{38277,13,39},{38277,14,39},{38278,11,40},{38278,12,40},{38278,13,40},{38278,14,40},{38279,10,41},{38279,11,41},{38279,12,41},{38279,13,41},{38279,14,41}]},{4,[{38280,17,29},{38280,18,28},{38280,19,28},{38280,20,28},{38280,21,28},{38281,17,29},{38281,18,29},{38281,19,29},{38281,20,29},{38282,20,26},{38282,21,26},{38282,22,26},{38282,23,26}]},{5,[{38283,22,16},{38283,23,16},{38283,24,16},{38283,25,16},{38283,26,16},{38284,23,18},{38284,24,18},{38284,25,18},{38284,26,18},{38284,27,18},{38285,22,20},{38285,23,20},{38285,24,20},{38285,25,20},{38285,26,20}]},{6,[{38288,27,16}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,125},{lvdown,999}] ,scenes = [] ,out = [] };
get(51011) ->
	#dungeon{id = 51011 ,sid = 51011 ,name = ?T("问道试剑路"), type = 14 ,lv = 135 ,mon = [{1,[{38301,10,31},{38301,10,29},{38301,10,27},{38302,10,27},{38302,10,30},{38302,11,28},{38303,10,28},{38303,8,30},{38303,11,30},{38303,8,30}]},{2,[{38304,20,36},{38304,17,35},{38304,14,35},{38305,17,34},{38305,16,38},{38305,16,36},{38306,19,34},{38306,20,35},{38306,18,34},{38306,19,37}]},{3,[{38307,30,36},{38307,30,36},{38307,24,34},{38308,28,33},{38308,26,34},{38308,27,35},{38309,24,34},{38309,27,35},{38309,26,35},{38309,24,36}]},{4,[{38310,31,31},{38310,32,26},{38310,37,34},{38311,34,26},{38311,36,33},{38311,32,31},{38312,36,31},{38312,31,25},{38312,37,34},{38312,34,34}]},{5,[{38313,44,34},{38313,43,25},{38313,45,30},{38314,45,24},{38314,43,28},{38314,41,31},{38315,47,29},{38315,41,26},{38315,41,35},{38315,47,28}]},{6,[{38318,48,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,135},{lvdown,999}] ,scenes = [] ,out = [] };
get(51012) ->
	#dungeon{id = 51012 ,sid = 51012 ,name = ?T("拭心洗剑池"), type = 14 ,lv = 145 ,mon = [{1,[{38331,9,64},{38331,9,60},{38331,12,68},{38331,10,61},{38331,9,73},{38332,10,74},{38332,11,56},{38332,10,53},{38332,10,58},{38332,12,58},{38333,12,58},{38333,9,61},{38333,11,56},{38333,10,71},{38333,9,71}]},{2,[{38334,17,46},{38334,21,48},{38334,16,46},{38334,16,45},{38334,21,49},{38335,15,46},{38335,21,48},{38335,15,46},{38335,16,48},{38335,19,51},{38336,18,49},{38336,17,48},{38336,20,45},{38336,19,47},{38336,18,51}]},{3,[{38337,15,34},{38337,11,34},{38337,8,40},{38337,9,35},{38337,14,36},{38338,13,38},{38338,8,40},{38338,12,34},{38338,14,40},{38338,12,38},{38339,12,34},{38339,12,38},{38339,8,33},{38339,11,36},{38339,14,39}]},{4,[{38340,15,24},{38340,12,26},{38340,14,27},{38340,15,25},{38340,11,22},{38341,15,27},{38341,17,24},{38341,11,22},{38341,17,23},{38341,10,26},{38342,16,25},{38342,14,25},{38342,15,28},{38342,15,23},{38342,12,22}]},{5,[{38343,24,17},{38343,27,19},{38343,26,17},{38343,24,22},{38343,27,17},{38344,23,23},{38344,23,22},{38344,21,23},{38344,21,16},{38344,25,22},{38345,25,23},{38345,26,16},{38345,26,22},{38345,23,21},{38345,27,21}]},{6,[{38348,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,145},{lvdown,999}] ,scenes = [] ,out = [] };
get(51013) ->
	#dungeon{id = 51013 ,sid = 51013 ,name = ?T("万象归一殿"), type = 14 ,lv = 155 ,mon = [{1,[{38361,14,47},{38361,15,46},{38361,15,48},{38361,16,49},{38361,16,48},{38362,15,47},{38362,15,45},{38362,16,46},{38362,17,48},{38362,18,47},{38363,17,46},{38363,16,44},{38363,17,43},{38363,18,44},{38363,19,46}]},{2,[{38364,20,40},{38364,21,41},{38364,22,42},{38364,21,38},{38364,22,39},{38365,23,41},{38365,24,39},{38365,23,38},{38365,22,36},{38365,23,35},{38366,24,37},{38366,25,38},{38366,26,38},{38366,23,34},{38366,25,36}]},{3,[{38367,25,30},{38367,24,31},{38367,23,33},{38367,23,31},{38367,23,40},{38368,24,29},{38368,23,29},{38368,22,30},{38368,25,29},{38368,28,31},{38369,27,32},{38369,28,30},{38369,26,31},{38369,25,32},{38369,24,27}]},{4,[{38370,36,51},{38370,37,49},{38370,38,48},{38370,39,47},{38370,39,45},{38371,38,46},{38371,37,47},{38371,36,48},{38371,35,49},{38371,34,49},{38372,35,47},{38372,36,45},{38372,37,44},{38372,37,43},{38372,36,44}]},{5,[{38373,25,30},{38373,24,31},{38373,23,33},{38373,23,31},{38373,23,40},{38374,24,29},{38374,23,29},{38374,22,30},{38374,29,30},{38374,30,31},{38375,31,32},{38375,31,30},{38375,31,28},{38375,30,28},{38375,31,27}]},{6,[{38378,35,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,155},{lvdown,999}] ,scenes = [] ,out = [] };
get(51014) ->
	#dungeon{id = 51014 ,sid = 51014 ,name = ?T("初入泪竹峰"), type = 14 ,lv = 165 ,mon = [{1,[{38391,20,61},{38391,21,61},{38391,22,61},{38392,17,60},{38392,18,60},{38392,19,60},{38392,20,60},{38392,21,60},{38393,22,60},{38393,18,59},{38393,19,59},{38393,20,59},{38393,21,59}]},{2,[{38394,5,46},{38394,6,46},{38394,7,46},{38394,8,46},{38394,9,46},{38395,6,48},{38395,7,48},{38395,8,48},{38395,9,48},{38395,10,48},{38396,5,51},{38396,6,51},{38396,7,51},{38396,8,51},{38396,9,51}]},{3,[{38397,10,39},{38397,11,39},{38397,12,39},{38397,13,39},{38397,14,39},{38398,11,40},{38398,12,40},{38398,13,40},{38398,14,40},{38399,10,41},{38399,11,41},{38399,12,41},{38399,13,41},{38399,14,41}]},{4,[{38400,17,29},{38400,18,28},{38400,19,28},{38400,20,28},{38400,21,28},{38401,17,29},{38401,18,29},{38401,19,29},{38401,20,29},{38402,20,26},{38402,21,26},{38402,22,26},{38402,23,26}]},{5,[{38403,22,16},{38403,23,16},{38403,24,16},{38403,25,16},{38403,26,16},{38404,23,18},{38404,24,18},{38404,25,18},{38404,26,18},{38404,27,18},{38405,22,20},{38405,23,20},{38405,24,20},{38405,25,20},{38405,26,20}]},{6,[{38408,27,16}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,165},{lvdown,999}] ,scenes = [] ,out = [] };
get(51015) ->
	#dungeon{id = 51015 ,sid = 51015 ,name = ?T("九霄镇天尺"), type = 14 ,lv = 175 ,mon = [{1,[{38421,17,31},{38421,19,30},{38421,21,32},{38421,20,33},{38421,20,36},{38422,23,36},{38422,23,33},{38422,23,30},{38422,22,27},{38422,21,26},{38423,19,25},{38423,17,25},{38423,24,33},{38423,23,30},{38423,23,28}]},{2,[{38424,17,25},{38424,18,22},{38424,20,23},{38424,21,22},{38424,22,22},{38425,23,23},{38425,21,22},{38425,20,23},{38425,19,25},{38425,18,27},{38426,19,28},{38426,21,26},{38426,22,24},{38426,24,22},{38426,25,24}]},{3,[{38427,26,32},{38427,28,32},{38427,30,33},{38427,32,33},{38427,32,30},{38428,30,30},{38428,28,30},{38428,26,30},{38428,26,28},{38428,28,28},{38429,29,28},{38429,31,28},{38429,31,31},{38429,31,34},{38429,25,30},{38429,33,15}]},{4,[{38430,34,17},{38430,35,18},{38430,36,21},{38430,37,23},{38430,31,16},{38431,32,18},{38431,33,21},{38431,34,23},{38431,35,23},{38431,37,25},{38432,35,26},{38432,34,24},{38432,32,22},{38432,31,21},{38432,37,38}]},{5,[{38433,38,36},{38433,40,34},{38433,41,32},{38433,41,29},{38433,41,28},{38434,40,26},{38434,39,30},{38434,38,31},{38434,37,33},{38434,35,35},{38435,34,37},{38435,33,34},{38435,35,32},{38435,36,29},{38435,42,32}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,175},{lvdown,999}] ,scenes = [] ,out = [] };
get(51016) ->
	#dungeon{id = 51016 ,sid = 51016 ,name = ?T("破敌青云巅"), type = 14 ,lv = 185 ,mon = [{1,[{38451,10,67},{38451,12,65},{38451,13,63},{38451,14,64},{38451,13,65},{38452,11,67},{38452,12,69},{38452,14,67},{38452,15,65},{38452,17,67},{38453,15,68},{38453,14,70},{38453,15,72},{38453,16,70},{38453,18,68}]},{2,[{38454,23,73},{38454,21,74},{38454,19,76},{38454,18,74},{38454,19,72},{38455,21,71},{38455,20,69},{38455,16,70},{38455,16,72},{38455,15,72},{38456,16,70},{38456,18,67},{38456,26,58},{38456,27,60},{38456,26,60}]},{3,[{38457,18,34},{38457,19,33},{38457,20,31},{38457,19,29},{38457,18,30},{38458,17,32},{38458,16,30},{38458,17,29},{38458,18,27},{38458,17,25},{38459,16,27},{38459,15,28},{38459,13,25},{38459,15,24},{38459,16,22}]},{4,[{38460,7,19},{38460,8,18},{38460,5,20},{38460,10,15},{38460,11,15},{38461,13,14},{38461,11,16},{38461,10,16},{38461,9,19},{38461,8,21},{38462,7,23},{38462,9,24},{38462,10,21},{38462,12,19},{38462,14,18}]},{5,[{38463,18,28},{38463,19,27},{38463,20,26},{38463,19,29},{38463,18,30},{38464,17,32},{38464,16,30},{38464,17,29},{38464,18,27},{38464,17,25},{38465,16,27},{38465,15,28},{38465,13,25},{38465,15,24},{38465,16,22}]},{6,[{38468,9,19}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,185},{lvdown,999}] ,scenes = [] ,out = [] };
get(51017) ->
	#dungeon{id = 51017 ,sid = 51017 ,name = ?T("镇魔古皇陵"), type = 14 ,lv = 195 ,mon = [{1,[{38481,13,71},{38481,14,71},{38481,15,71},{38481,16,71},{38481,17,71},{38482,18,71},{38482,18,72},{38482,17,72},{38482,16,72},{38482,15,72},{38483,14,72},{38483,13,72},{38483,13,73},{38483,13,73},{38483,13,73}]},{2,[{38484,18,79},{38484,19,79},{38484,20,79},{38484,21,79},{38484,22,79},{38485,23,79},{38485,24,79},{38485,24,80},{38485,23,80},{38485,22,80},{38486,21,80},{38486,20,80},{38486,20,81},{38486,21,81},{38486,22,81}]},{3,[{38487,25,76},{38487,28,79},{38487,24,78},{38487,26,78},{38487,23,75},{38488,21,79},{38488,19,75},{38488,21,76},{38488,27,73},{38488,28,83},{38489,24,82},{38489,26,78},{38489,23,74},{38489,21,81},{38489,19,72}]},{4,[{38490,20,57},{38490,21,57},{38491,22,57},{38491,23,57},{38491,21,54},{38492,22,54},{38492,23,54},{38492,24,54}]},{5,[{38493,20,42},{38493,24,42},{38493,21,43},{38493,25,45},{38494,24,47},{38494,26,48},{38494,21,43},{38494,26,42},{38494,29,43},{38495,20,42},{38495,24,42},{38495,21,43},{38495,25,42},{38495,23,47}]},{6,[{38498,29,37}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,195},{lvdown,999}] ,scenes = [] ,out = [] };
get(51018) ->
	#dungeon{id = 51018 ,sid = 51018 ,name = ?T("摘星接天台"), type = 14 ,lv = 205 ,mon = [{1,[{38511,13,49},{38511,13,46},{38511,12,45},{38511,12,48},{38511,12,48},{38512,14,44},{38512,15,51},{38512,15,46},{38512,13,45},{38512,12,50},{38513,13,46},{38513,13,44},{38513,14,47},{38513,15,44},{38513,14,44}]},{2,[{38514,20,44},{38514,19,50},{38514,22,48},{38514,18,45},{38514,22,47},{38515,22,50},{38515,22,49},{38515,18,46},{38515,22,48},{38515,20,49},{38516,18,46},{38516,21,48},{38516,18,47},{38516,18,46},{38516,18,45}]},{3,[{38517,33,28},{38517,31,27},{38517,32,28},{38517,32,31},{38517,32,31},{38518,30,32},{38518,30,28},{38518,28,30},{38518,31,28},{38518,32,26},{38519,32,30},{38519,28,32},{38519,32,28},{38519,32,28},{38519,30,31}]},{4,[{38520,35,21},{38520,34,17},{38520,33,19},{38520,30,18},{38520,33,18},{38521,35,18},{38521,31,25},{38521,31,22},{38521,32,18},{38521,34,26},{38522,31,24},{38522,33,23},{38522,34,21},{38522,31,26},{38522,32,27}]},{5,[{38523,12,8},{38523,12,10},{38523,12,17},{38523,12,15},{38523,15,10},{38524,15,18},{38524,12,16},{38524,13,17},{38524,10,12},{38524,11,17},{38525,14,9},{38525,13,11},{38525,12,11},{38525,13,16},{38525,20,14}]},{6,[{38528,8,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,205},{lvdown,999}] ,scenes = [] ,out = [] };
get(51019) ->
	#dungeon{id = 51019 ,sid = 51019 ,name = ?T("失堕珊瑚海"), type = 14 ,lv = 215 ,mon = [{1,[{38541,33,59},{38541,33,56},{38541,33,55},{38541,33,53},{38541,34,52},{38542,35,51},{38542,36,50},{38542,36,49},{38542,35,55},{38542,35,54},{38543,34,54},{38543,33,56},{38543,32,58},{38543,36,52},{38543,35,54}]},{2,[{38544,27,55},{38544,29,53},{38544,30,52},{38544,31,51},{38544,31,50},{38545,32,49},{38545,34,50},{38545,30,55},{38545,31,53},{38545,32,52},{38546,33,51},{38546,35,51},{38546,30,57},{38546,31,55},{38546,31,57}]},{3,[{38547,20,37},{38547,20,36},{38547,21,35},{38547,22,34},{38547,23,33},{38548,25,34},{38548,25,32},{38548,26,32},{38548,27,33},{38548,25,35},{38549,20,34},{38549,22,33},{38549,23,31},{38549,24,33},{38549,25,34}]},{4,[{38550,26,25},{38550,28,27},{38550,28,28},{38550,29,29},{38550,30,30},{38551,25,27},{38551,23,29},{38551,22,30},{38551,21,30},{38551,26,28},{38552,26,31},{38552,25,23},{38552,23,24},{38552,22,25},{38552,23,30}]},{5,[{38553,17,25},{38553,18,24},{38553,19,23},{38553,21,22},{38554,21,21},{38554,23,19},{38554,20,24},{38554,25,21},{38554,23,21},{38555,22,23},{38555,19,23},{38555,21,22},{38555,21,21},{38555,20,25}]},{6,[{38558,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,215},{lvdown,999}] ,scenes = [] ,out = [] };
get(51020) ->
	#dungeon{id = 51020 ,sid = 51020 ,name = ?T("九转锁龙柱"), type = 14 ,lv = 225 ,mon = [{1,[{38571,10,31},{38571,10,29},{38571,10,27},{38572,10,27},{38572,10,30},{38572,11,28},{38573,10,28},{38573,8,30},{38573,11,30},{38573,8,30}]},{2,[{38574,20,36},{38574,17,35},{38574,14,35},{38575,17,34},{38575,16,38},{38575,16,36},{38576,19,34},{38576,20,35},{38576,18,34},{38576,19,37}]},{3,[{38577,30,36},{38577,30,36},{38577,24,34},{38578,28,33},{38578,26,34},{38578,27,35},{38579,24,34},{38579,27,35},{38579,26,35},{38579,24,36}]},{4,[{38580,31,31},{38580,32,26},{38580,37,34},{38581,34,26},{38581,36,33},{38581,32,31},{38582,36,31},{38582,31,25},{38582,37,34},{38582,34,34}]},{5,[{38583,44,34},{38583,43,25},{38583,45,30},{38584,45,24},{38584,43,28},{38584,41,31},{38585,47,29},{38585,41,26},{38585,41,35},{38585,47,28}]},{6,[{38588,48,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,225},{lvdown,999}] ,scenes = [] ,out = [] };
get(52001) ->
	#dungeon{id = 52001 ,sid = 52001 ,name = ?T("神器1层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52002) ->
	#dungeon{id = 52002 ,sid = 52002 ,name = ?T("神器2层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52003) ->
	#dungeon{id = 52003 ,sid = 52003 ,name = ?T("神器3层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52004) ->
	#dungeon{id = 52004 ,sid = 52004 ,name = ?T("神器4层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52005) ->
	#dungeon{id = 52005 ,sid = 52005 ,name = ?T("神器5层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52006) ->
	#dungeon{id = 52006 ,sid = 52006 ,name = ?T("神器6层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52007) ->
	#dungeon{id = 52007 ,sid = 52007 ,name = ?T("神器7层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52008) ->
	#dungeon{id = 52008 ,sid = 52008 ,name = ?T("神器8层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52009) ->
	#dungeon{id = 52009 ,sid = 52009 ,name = ?T("神器9层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52010) ->
	#dungeon{id = 52010 ,sid = 52010 ,name = ?T("神器10层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,62},{lvdown,999}] ,scenes = [] ,out = [] };
get(52011) ->
	#dungeon{id = 52011 ,sid = 52011 ,name = ?T("神器11层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52012) ->
	#dungeon{id = 52012 ,sid = 52012 ,name = ?T("神器12层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52013) ->
	#dungeon{id = 52013 ,sid = 52013 ,name = ?T("神器13层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52014) ->
	#dungeon{id = 52014 ,sid = 52014 ,name = ?T("神器14层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52015) ->
	#dungeon{id = 52015 ,sid = 52015 ,name = ?T("神器15层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52016) ->
	#dungeon{id = 52016 ,sid = 52016 ,name = ?T("神器16层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52017) ->
	#dungeon{id = 52017 ,sid = 52017 ,name = ?T("神器17层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52018) ->
	#dungeon{id = 52018 ,sid = 52018 ,name = ?T("神器18层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52019) ->
	#dungeon{id = 52019 ,sid = 52019 ,name = ?T("神器19层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(52020) ->
	#dungeon{id = 52020 ,sid = 52020 ,name = ?T("神器20层"), type = 1 ,lv = 62 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(53001) ->
	#dungeon{id = 53001 ,sid = 53001 ,name = ?T("初识经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15001,14,47},{15001,15,46},{15001,15,48},{15001,16,49},{15001,16,48},{15002,15,47},{15002,15,45},{15002,16,46},{15002,17,48},{15002,18,47},{15003,17,46},{15003,16,44}]},{2,[{15004,20,40},{15004,21,41},{15004,21,38},{15005,23,38},{15005,22,36},{15006,23,38}]},{3,[{15007,25,30},{15007,24,31},{15007,23,33},{15007,23,31},{15007,23,40},{15008,26,30},{15008,25,29},{15009,26,31},{15009,25,32},{15009,25,27}]},{4,[{15010,36,51},{15010,37,49},{15010,38,48},{15010,39,47},{15010,39,45},{15011,38,46},{15011,37,47},{15011,36,48},{15011,35,49},{15011,34,49},{15012,35,47},{15012,36,45},{15012,37,44},{15012,37,43},{15012,36,44}]},{5,[{15013,25,30},{15013,24,31},{15013,23,33},{15013,23,31},{15013,23,40},{15014,24,29},{15014,23,29},{15014,22,30},{15014,29,30},{15014,30,31},{15015,31,32},{15015,31,30},{15015,31,28},{15015,30,28},{15015,31,27}]},{6,[{15018,35,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53002) ->
	#dungeon{id = 53002 ,sid = 53002 ,name = ?T("耹音经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15031,20,61},{15031,21,61},{15031,22,61},{15032,17,60},{15032,18,60},{15032,19,60},{15032,20,60},{15032,21,60},{15033,22,60},{15033,18,59},{15033,19,59},{15033,20,59},{15033,21,59}]},{2,[{15034,5,46},{15034,6,46},{15034,7,46},{15034,8,46},{15034,9,46},{15035,6,48},{15035,7,48},{15035,8,48},{15035,9,48},{15035,10,48},{15036,5,51},{15036,6,51},{15036,7,51},{15036,8,51},{15036,9,51}]},{3,[{15037,10,39},{15037,11,39},{15037,12,39},{15037,13,39},{15037,14,39},{15038,11,40},{15038,12,40},{15038,13,40},{15038,14,40},{15039,10,41},{15039,11,41},{15039,12,41},{15039,13,41},{15039,14,41}]},{4,[{15040,17,29},{15040,18,28},{15040,19,28},{15040,20,28},{15040,21,28},{15041,17,29},{15041,18,29},{15041,19,29},{15041,20,29},{15042,20,26},{15042,21,26},{15042,22,26},{15042,23,26}]},{5,[{15043,22,16},{15043,23,16},{15043,24,16},{15043,25,16},{15043,26,16},{15044,23,18},{15044,24,18},{15044,25,18},{15044,26,18},{15044,27,18},{15045,22,20},{15045,23,20},{15045,24,20},{15045,25,20},{15045,26,20}]},{6,[{15048,27,16}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53003) ->
	#dungeon{id = 53003 ,sid = 53003 ,name = ?T("破望经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15061,10,67},{15061,12,65},{15061,13,63},{15061,14,64},{15061,13,65},{15062,11,67},{15062,12,69},{15062,14,67},{15062,15,65},{15062,17,67},{15063,15,68},{15063,14,70},{15063,15,72},{15063,16,70},{15063,18,68}]},{2,[{15064,23,73},{15064,21,74},{15064,19,76},{15064,18,74},{15064,19,72},{15065,21,71},{15065,20,69},{15065,16,70},{15065,16,72},{15065,15,72},{15066,16,70},{15066,18,67},{15066,26,58},{15066,27,60},{15066,26,60}]},{3,[{15067,18,34},{15067,19,33},{15067,20,31},{15067,19,29},{15067,18,30},{15068,17,32},{15068,16,30},{15068,17,29},{15068,18,27},{15068,17,25},{15069,16,27},{15069,15,28},{15069,13,25},{15069,15,24},{15069,16,22}]},{4,[{15070,7,19},{15070,8,18},{15070,5,20},{15070,10,15},{15070,11,15},{15071,13,14},{15071,11,16},{15071,10,16},{15071,9,19},{15071,8,21},{15072,7,23},{15072,9,24},{15072,10,21},{15072,12,19},{15072,14,18}]},{5,[{15073,18,28},{15073,19,27},{15073,20,26},{15073,19,29},{15073,18,30},{15074,17,32},{15074,16,30},{15074,17,29},{15074,18,27},{15074,17,25},{15075,16,27},{15075,15,28},{15075,13,25},{15075,15,24},{15075,16,22}]},{6,[{15078,9,19}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53004) ->
	#dungeon{id = 53004 ,sid = 53004 ,name = ?T("知微经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15091,9,64},{15091,9,60},{15091,12,68},{15091,10,61},{15091,9,73},{15092,10,74},{15092,11,56},{15092,10,53},{15092,10,58},{15092,12,58},{15093,12,58},{15093,9,61},{15093,11,56},{15093,10,71},{15093,9,71}]},{2,[{15094,17,46},{15094,21,48},{15094,16,46},{15094,16,45},{15094,21,49},{15095,15,46},{15095,21,48},{15095,15,46},{15095,16,48},{15095,19,51},{15096,18,49},{15096,17,48},{15096,20,45},{15096,19,47},{15096,18,51}]},{3,[{15097,15,34},{15097,11,34},{15097,8,40},{15097,9,35},{15097,14,36},{15098,13,38},{15098,8,40},{15098,12,34},{15098,14,40},{15098,12,38},{15099,12,34},{15099,12,38},{15099,8,33},{15099,11,36},{15099,14,39}]},{4,[{15100,15,24},{15100,12,26},{15100,14,27},{15100,15,25},{15100,11,22},{15101,15,27},{15101,17,24},{15101,11,22},{15101,17,23},{15101,10,26},{15102,16,25},{15102,14,25},{15102,15,28},{15102,15,23},{15102,12,22}]},{5,[{15103,24,17},{15103,27,19},{15103,26,17},{15103,24,22},{15103,27,17},{15104,23,23},{15104,23,22},{15104,21,23},{15104,21,16},{15104,25,22},{15105,25,23},{15105,26,16},{15105,26,22},{15105,23,21},{15105,27,21}]},{6,[{15108,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53005) ->
	#dungeon{id = 53005 ,sid = 53005 ,name = ?T("堪心经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15121,33,59},{15121,33,56},{15121,33,55},{15121,33,53},{15121,34,52},{15122,35,51},{15122,36,50},{15122,36,49},{15122,35,55},{15122,35,54},{15123,34,54},{15123,33,56},{15123,32,58},{15123,36,52},{15123,35,54}]},{2,[{15124,27,55},{15124,29,53},{15124,30,52},{15124,31,51},{15124,31,50},{15125,32,49},{15125,34,50},{15125,30,55},{15125,31,53},{15125,32,52},{15126,33,51},{15126,35,51},{15126,30,57},{15126,31,55},{15126,31,57}]},{3,[{15127,20,37},{15127,20,36},{15127,21,35},{15127,22,34},{15127,23,33},{15128,25,34},{15128,25,32},{15128,26,32},{15128,27,33},{15128,25,35},{15129,20,34},{15129,22,33},{15129,23,31},{15129,24,33},{15129,25,34}]},{4,[{15130,26,25},{15130,28,27},{15130,28,28},{15130,29,29},{15130,30,30},{15131,25,27},{15131,23,29},{15131,22,30},{15131,21,30},{15131,26,28},{15132,26,31},{15132,25,23},{15132,23,24},{15132,22,25},{15132,23,30}]},{5,[{15133,17,25},{15133,18,24},{15133,19,23},{15133,21,22},{15134,21,21},{15134,23,19},{15134,20,24},{15134,25,21},{15134,23,21},{15135,22,23},{15135,19,23},{15135,21,22},{15135,21,21},{15135,20,25}]},{6,[{15138,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53006) ->
	#dungeon{id = 53006 ,sid = 53006 ,name = ?T("登堂经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15151,10,31},{15151,10,29},{15151,10,27},{15152,10,27},{15152,10,30},{15152,11,28},{15153,10,28},{15153,8,30},{15153,11,30},{15153,8,30}]},{2,[{15154,20,36},{15154,17,35},{15154,14,35},{15155,17,34},{15155,16,38},{15155,16,36},{15156,19,34},{15156,20,35},{15156,18,34},{15156,19,37}]},{3,[{15157,30,36},{15157,30,36},{15157,24,34},{15158,28,33},{15158,26,34},{15158,27,35},{15159,24,34},{15159,27,35},{15159,26,35},{15159,24,36}]},{4,[{15160,31,31},{15160,32,26},{15160,37,34},{15161,34,26},{15161,36,33},{15161,32,31},{15162,36,31},{15162,31,25},{15162,37,34},{15162,34,34}]},{5,[{15163,44,34},{15163,43,25},{15163,45,30},{15164,45,24},{15164,43,28},{15164,41,31},{15165,47,29},{15165,41,26},{15165,41,35},{15165,47,28}]},{6,[{15168,48,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53007) ->
	#dungeon{id = 53007 ,sid = 53007 ,name = ?T("舍归经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15181,13,43},{15181,12,44},{15181,11,46},{15181,10,47},{15181,12,48},{15182,13,46},{15182,14,44},{15182,15,45},{15182,14,46},{15182,13,47},{15183,13,49},{15183,13,52},{15183,15,48},{15183,16,46},{15183,16,48}]},{2,[{15184,24,46},{15184,25,48},{15184,26,50},{15184,25,45},{15184,26,47},{15185,27,49},{15185,27,43},{15185,27,46},{15185,28,46},{15185,29,49},{15186,28,42},{15186,29,45},{15186,30,47},{15186,29,41},{15186,30,43}]},{3,[{15187,29,49},{15187,28,42},{15187,29,45},{15187,30,47},{15187,29,41},{15188,30,43},{15188,18,47},{15188,18,49},{15188,18,51},{15188,18,53},{15189,17,56},{15189,19,56},{15189,22,50},{15189,21,50},{15189,17,49}]},{4,[{15190,29,37},{15190,31,38},{15190,32,39},{15190,33,41},{15190,35,43},{15191,35,40},{15191,34,37},{15191,31,35},{15191,29,34},{15191,27,35},{15192,32,45},{15192,37,43},{15192,37,39},{15192,36,36},{15192,35,35}]},{5,[{15193,29,30},{15193,32,30},{15193,33,30},{15193,35,30},{15193,37,31},{15194,38,31},{15194,40,33},{15194,39,36},{15194,37,34},{15194,35,25},{15195,35,25},{15195,35,25},{15195,35,25},{15195,35,25},{15195,35,25}]},{6,[{15198,35,25}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53008) ->
	#dungeon{id = 53008 ,sid = 53008 ,name = ?T("造化经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15211,17,31},{15211,19,30},{15211,21,32},{15211,20,33},{15211,20,36},{15212,23,36},{15212,23,33},{15212,23,30},{15212,22,27},{15212,21,26},{15213,19,25},{15213,17,25},{15213,24,33},{15213,23,30},{15213,23,28}]},{2,[{15214,17,25},{15214,18,22},{15214,20,23},{15214,21,22},{15214,22,22},{15215,23,23},{15215,21,22},{15215,20,23},{15215,19,25},{15215,18,27},{15216,19,28},{15216,21,26},{15216,22,24},{15216,24,22},{15216,25,24}]},{3,[{15217,26,32},{15217,28,32},{15217,30,33},{15217,32,33},{15217,32,30},{15218,30,30},{15218,28,30},{15218,26,30},{15218,26,28},{15218,28,28},{15219,29,28},{15219,31,28},{15219,31,31},{15219,31,34},{15219,25,30},{15219,33,15}]},{4,[{15220,34,17},{15220,35,18},{15220,36,21},{15220,37,23},{15220,31,16},{15221,32,18},{15221,33,21},{15221,34,23},{15221,35,23},{15221,37,25},{15222,35,26},{15222,34,24},{15222,32,22},{15222,31,21},{15222,37,38}]},{5,[{15223,38,36},{15223,40,34},{15223,41,32},{15223,41,29},{15223,41,28},{15224,40,26},{15224,39,30},{15224,38,31},{15224,37,33},{15224,35,35},{15225,34,37},{15225,33,34},{15225,35,32},{15225,36,29},{15225,42,32}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53009) ->
	#dungeon{id = 53009 ,sid = 53009 ,name = ?T("飞升经脉"), type = 14 ,lv = 999 ,mon = [{1,[{15241,13,49},{15241,13,46},{15241,12,45},{15241,12,48},{15241,12,48},{15242,14,44},{15242,15,51},{15242,15,46},{15242,13,45},{15242,12,50},{15243,13,46},{15243,13,44},{15243,14,47},{15243,15,44},{15243,14,44}]},{2,[{15244,20,44},{15244,19,50},{15244,22,48},{15244,18,45},{15244,22,47},{15245,22,50},{15245,22,49},{15245,18,46},{15245,22,48},{15245,20,49},{15246,18,46},{15246,21,48},{15246,18,47},{15246,18,46},{15246,18,45}]},{3,[{15247,33,28},{15247,31,27},{15247,32,28},{15247,32,31},{15247,32,31},{15248,30,32},{15248,30,28},{15248,28,30},{15248,31,28},{15248,32,26},{15249,32,30},{15249,28,32},{15249,32,28},{15249,32,28},{15249,30,31}]},{4,[{15250,35,21},{15250,34,17},{15250,33,19},{15250,30,18},{15250,33,18},{15251,35,18},{15251,31,25},{15251,31,22},{15251,32,18},{15251,34,26},{15252,31,24},{15252,33,23},{15252,34,21},{15252,31,26},{15252,32,27}]},{5,[{15253,12,8},{15253,12,10},{15253,12,17},{15253,12,15},{15253,15,10},{15254,15,18},{15254,12,16},{15254,13,17},{15254,10,12},{15254,11,17},{15255,14,9},{15255,13,11},{15255,12,11},{15255,13,16},{15255,20,14}]},{6,[{15258,8,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(53010) ->
	#dungeon{id = 53010 ,sid = 53010 ,name = ?T("经脉10"), type = 14 ,lv = 999 ,mon = [{1,[{65059,20,28}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,998},{lvdown,999}] ,scenes = [] ,out = [] };
get(54001) ->
	#dungeon{id = 54001 ,sid = 54001 ,name = ?T("坐骑灵脉"), type = 14 ,lv = 75 ,mon = [{1,[{10501,9,64},{10501,9,60},{10501,12,68},{10501,10,61},{10501,9,73},{10502,10,74},{10502,11,56},{10502,10,53},{10502,10,58},{10502,12,58},{10503,12,58},{10503,9,61},{10503,11,56},{10503,10,71},{10503,9,71}]},{2,[{10504,17,46},{10504,21,48},{10504,16,46},{10504,16,45},{10504,21,49},{10505,15,46},{10505,21,48},{10505,15,46},{10505,16,48},{10505,19,51},{10506,18,49},{10506,17,48},{10506,20,45},{10506,19,47},{10506,18,51}]},{3,[{10507,15,34},{10507,11,34},{10507,8,40},{10507,9,35},{10507,14,36},{10508,13,38},{10508,8,40},{10508,12,34},{10508,14,40},{10508,12,38},{10509,12,34},{10509,12,38},{10509,8,33},{10509,11,36},{10509,14,39}]},{4,[{10510,15,24},{10510,12,26},{10510,14,27},{10510,15,25},{10510,11,22},{10511,15,27},{10511,17,24},{10511,11,22},{10511,17,23},{10511,10,26},{10512,16,25},{10512,14,25},{10512,15,28},{10512,15,23},{10512,12,22}]},{5,[{10513,24,17},{10513,27,19},{10513,26,17},{10513,24,22},{10513,27,17},{10514,23,23},{10514,23,22},{10514,21,23},{10514,21,16},{10514,25,22},{10515,25,23},{10515,26,16},{10515,26,22},{10515,23,21},{10515,27,21}]},{6,[{10518,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,75},{lvdown,999}] ,scenes = [] ,out = [] };
get(54002) ->
	#dungeon{id = 54002 ,sid = 54002 ,name = ?T("法器灵脉"), type = 14 ,lv = 80 ,mon = [{1,[{10531,33,59},{10531,33,56},{10531,33,55},{10531,33,53},{10531,34,52},{10532,35,51},{10532,36,50},{10532,36,49},{10532,35,55},{10532,35,54},{10533,34,54},{10533,33,56},{10533,32,58},{10533,36,52},{10533,35,54}]},{2,[{10534,27,55},{10534,29,53},{10534,30,52},{10534,31,51},{10534,31,50},{10535,32,49},{10535,34,50},{10535,30,55},{10535,31,53},{10535,32,52},{10536,33,51},{10536,35,51},{10536,30,57},{10536,31,55},{10536,31,57}]},{3,[{10537,20,37},{10537,20,36},{10537,21,35},{10537,22,34},{10537,23,33},{10538,25,34},{10538,25,32},{10538,26,32},{10538,27,33},{10538,25,35},{10539,20,34},{10539,22,33},{10539,23,31},{10539,24,33},{10539,25,34}]},{4,[{10540,26,25},{10540,28,27},{10540,28,28},{10540,29,29},{10540,30,30},{10541,25,27},{10541,23,29},{10541,22,30},{10541,21,30},{10541,26,28},{10542,26,31},{10542,25,23},{10542,23,24},{10542,22,25},{10542,23,30}]},{5,[{10543,17,25},{10543,18,24},{10543,19,23},{10543,21,22},{10544,21,21},{10544,23,19},{10544,20,24},{10544,25,21},{10544,23,21},{10545,22,23},{10545,19,23},{10545,21,22},{10545,21,21},{10545,20,25}]},{6,[{10548,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,80},{lvdown,999}] ,scenes = [] ,out = [] };
get(54003) ->
	#dungeon{id = 54003 ,sid = 54003 ,name = ?T("神兵灵脉"), type = 14 ,lv = 85 ,mon = [{1,[{10561,10,31},{10561,10,29},{10561,10,27},{10562,10,27},{10562,10,30},{10562,11,28},{10563,10,28},{10563,8,30},{10563,11,30},{10563,8,30}]},{2,[{10564,20,36},{10564,17,35},{10564,14,35},{10565,17,34},{10565,16,38},{10565,16,36},{10566,19,34},{10566,20,35},{10566,18,34},{10566,19,37}]},{3,[{10567,30,36},{10567,30,36},{10567,24,34},{10568,28,33},{10568,26,34},{10568,27,35},{10569,24,34},{10569,27,35},{10569,26,35},{10569,24,36}]},{4,[{10570,31,31},{10570,32,26},{10570,37,34},{10571,34,26},{10571,36,33},{10571,32,31},{10572,36,31},{10572,31,25},{10572,37,34},{10572,34,34}]},{5,[{10573,44,34},{10573,43,25},{10573,45,30},{10574,45,24},{10574,43,28},{10574,41,31},{10575,47,29},{10575,41,26},{10575,41,35},{10575,47,28}]},{6,[{10578,48,21}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,85},{lvdown,999}] ,scenes = [] ,out = [] };
get(54004) ->
	#dungeon{id = 54004 ,sid = 54004 ,name = ?T("仙羽灵脉"), type = 14 ,lv = 78 ,mon = [{1,[{10591,13,43},{10591,12,44},{10591,11,46},{10591,10,47},{10591,12,48},{10592,13,46},{10592,14,44},{10592,15,45},{10592,14,46},{10592,13,47},{10593,13,49},{10593,13,52},{10593,15,48},{10593,16,46},{10593,16,48}]},{2,[{10594,24,46},{10594,25,48},{10594,26,50},{10594,25,45},{10594,26,47},{10595,27,49},{10595,27,43},{10595,27,46},{10595,28,46},{10595,29,49},{10596,28,42},{10596,29,45},{10596,30,47},{10596,29,41},{10596,30,43}]},{3,[{10597,29,49},{10597,28,42},{10597,29,45},{10597,30,47},{10597,29,41},{10598,30,43},{10598,18,47},{10598,18,49},{10598,18,51},{10598,18,53},{10599,17,56},{10599,19,56},{10599,22,50},{10599,21,50},{10599,17,49}]},{4,[{10600,29,37},{10600,31,38},{10600,32,39},{10600,33,41},{10600,35,43},{10601,35,40},{10601,34,37},{10601,31,35},{10601,29,34},{10601,27,35},{10602,32,45},{10602,37,43},{10602,37,39},{10602,36,36},{10602,35,35}]},{5,[{10603,29,30},{10603,32,30},{10603,33,30},{10603,35,30},{10603,37,31},{10604,38,31},{10604,40,33},{10604,39,36},{10604,37,34},{10604,35,25},{10605,35,25},{10605,35,25},{10605,35,25},{10605,35,25},{10605,35,25}]},{6,[{10608,35,25}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,78},{lvdown,999}] ,scenes = [] ,out = [] };
get(54005) ->
	#dungeon{id = 54005 ,sid = 54005 ,name = ?T("妖灵灵脉"), type = 14 ,lv = 88 ,mon = [{1,[{10621,17,31},{10621,19,30},{10621,21,32},{10621,20,33},{10621,20,36},{10622,23,36},{10622,23,33},{10622,23,30},{10622,22,27},{10622,21,26},{10623,19,25},{10623,17,25},{10623,24,33},{10623,23,30},{10623,23,28}]},{2,[{10624,17,25},{10624,18,22},{10624,20,23},{10624,21,22},{10624,22,22},{10625,23,23},{10625,21,22},{10625,20,23},{10625,19,25},{10625,18,27},{10626,19,28},{10626,21,26},{10626,22,24},{10626,24,22},{10626,25,24}]},{3,[{10627,26,32},{10627,28,32},{10627,30,33},{10627,32,33},{10627,32,30},{10628,30,30},{10628,28,30},{10628,26,30},{10628,26,28},{10628,28,28},{10629,29,28},{10629,31,28},{10629,31,31},{10629,31,34},{10629,25,30},{10629,33,15}]},{4,[{10630,34,17},{10630,35,18},{10630,36,21},{10630,37,23},{10630,31,16},{10631,32,18},{10631,33,21},{10631,34,23},{10631,35,23},{10631,37,25},{10632,35,26},{10632,34,24},{10632,32,22},{10632,31,21},{10632,37,38}]},{5,[{10633,38,36},{10633,40,34},{10633,41,32},{10633,41,29},{10633,41,28},{10634,40,26},{10634,39,30},{10634,38,31},{10634,37,33},{10634,35,35},{10635,34,37},{10635,33,34},{10635,35,32},{10635,36,29},{10635,42,32}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,88},{lvdown,999}] ,scenes = [] ,out = [] };
get(54006) ->
	#dungeon{id = 54006 ,sid = 54006 ,name = ?T("足迹灵脉"), type = 14 ,lv = 94 ,mon = [{1,[{10651,13,49},{10651,13,46},{10651,12,45},{10651,12,48},{10651,12,48},{10652,14,44},{10652,15,51},{10652,15,46},{10652,13,45},{10652,12,50},{10653,13,46},{10653,13,44},{10653,14,47},{10653,15,44},{10653,14,44}]},{2,[{10654,20,44},{10654,19,50},{10654,22,48},{10654,18,45},{10654,22,47},{10655,22,50},{10655,22,49},{10655,18,46},{10655,22,48},{10655,20,49},{10656,18,46},{10656,21,48},{10656,18,47},{10656,18,46},{10656,18,45}]},{3,[{10657,33,28},{10657,31,27},{10657,32,28},{10657,32,31},{10657,32,31},{10658,30,32},{10658,30,28},{10658,28,30},{10658,31,28},{10658,32,26},{10659,32,30},{10659,28,32},{10659,32,28},{10659,32,28},{10659,30,31}]},{4,[{10660,35,21},{10660,34,17},{10660,33,19},{10660,30,18},{10660,33,18},{10661,35,18},{10661,31,25},{10661,31,22},{10661,32,18},{10661,34,26},{10662,31,24},{10662,33,23},{10662,34,21},{10662,31,26},{10662,32,27}]},{5,[{10663,12,8},{10663,12,10},{10663,12,17},{10663,12,15},{10663,15,10},{10664,15,18},{10664,12,16},{10664,13,17},{10664,10,12},{10664,11,17},{10665,14,9},{10665,13,11},{10665,12,11},{10665,13,16},{10665,20,14}]},{6,[{10668,8,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,94},{lvdown,999}] ,scenes = [] ,out = [] };
get(54007) ->
	#dungeon{id = 54007 ,sid = 54007 ,name = ?T("灵猫灵脉"), type = 14 ,lv = 98 ,mon = [{1,[{10681,33,59},{10681,33,56},{10681,33,55},{10681,33,53},{10681,34,52},{10682,35,51},{10682,36,50},{10682,36,49},{10682,35,55},{10682,35,54},{10683,34,54},{10683,33,56},{10683,32,58},{10683,36,52},{10683,35,54}]},{2,[{10684,27,55},{10684,29,53},{10684,30,52},{10684,31,51},{10684,31,50},{10685,32,49},{10685,34,50},{10685,30,55},{10685,31,53},{10685,32,52},{10686,33,51},{10686,35,51},{10686,30,57},{10686,31,55},{10686,31,57}]},{3,[{10687,20,37},{10687,20,36},{10687,21,35},{10687,22,34},{10687,23,33},{10688,25,34},{10688,25,32},{10688,26,32},{10688,27,33},{10688,25,35},{10689,20,34},{10689,22,33},{10689,23,31},{10689,24,33},{10689,25,34}]},{4,[{10690,26,25},{10690,28,27},{10690,28,28},{10690,29,29},{10690,30,30},{10691,25,27},{10691,23,29},{10691,22,30},{10691,21,30},{10691,26,28},{10692,26,31},{10692,25,23},{10692,23,24},{10692,22,25},{10692,23,30}]},{5,[{10693,17,25},{10693,18,24},{10693,19,23},{10693,21,22},{10694,21,21},{10694,23,19},{10694,20,24},{10694,25,21},{10694,23,21},{10695,22,23},{10695,19,23},{10695,21,22},{10695,21,21},{10695,20,25}]},{6,[{10698,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,98},{lvdown,999}] ,scenes = [] ,out = [] };
get(54008) ->
	#dungeon{id = 54008 ,sid = 54008 ,name = ?T("法身灵脉"), type = 14 ,lv = 100 ,mon = [{1,[{10711,9,64},{10711,9,60},{10711,12,68},{10711,10,61},{10711,9,73},{10712,10,74},{10712,11,56},{10712,10,53},{10712,10,58},{10712,12,58},{10713,12,58},{10713,9,61},{10713,11,56},{10713,10,71},{10713,9,71}]},{2,[{10714,17,46},{10714,21,48},{10714,16,46},{10714,16,45},{10714,21,49},{10715,15,46},{10715,21,48},{10715,15,46},{10715,16,48},{10715,19,51},{10716,18,49},{10716,17,48},{10716,20,45},{10716,19,47},{10716,18,51}]},{3,[{10717,15,34},{10717,11,34},{10717,8,40},{10717,9,35},{10717,14,36},{10718,13,38},{10718,8,40},{10718,12,34},{10718,14,40},{10718,12,38},{10719,12,34},{10719,12,38},{10719,8,33},{10719,11,36},{10719,14,39}]},{4,[{10720,15,24},{10720,12,26},{10720,14,27},{10720,15,25},{10720,11,22},{10721,15,27},{10721,17,24},{10721,11,22},{10721,17,23},{10721,10,26},{10722,16,25},{10722,14,25},{10722,15,28},{10722,15,23},{10722,12,22}]},{5,[{10723,24,17},{10723,27,19},{10723,26,17},{10723,24,22},{10723,27,17},{10724,23,23},{10724,23,22},{10724,21,23},{10724,21,16},{10724,25,22},{10725,25,23},{10725,26,16},{10725,26,22},{10725,23,21},{10725,27,21}]},{6,[{10728,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,100},{lvdown,999}] ,scenes = [] ,out = [] };
get(54009) ->
	#dungeon{id = 54009 ,sid = 54009 ,name = ?T("灵羽灵脉"), type = 14 ,lv = 102 ,mon = [{1,[{10741,9,64},{10741,9,60},{10741,12,68},{10741,10,61},{10741,9,73},{10742,10,74},{10742,11,56},{10742,10,53},{10742,10,58},{10742,12,58},{10743,12,58},{10743,9,61},{10743,11,56},{10743,10,71},{10743,9,71}]},{2,[{10744,17,46},{10744,21,48},{10744,16,46},{10744,16,45},{10744,21,49},{10745,15,46},{10745,21,48},{10745,15,46},{10745,16,48},{10745,19,51},{10746,18,49},{10746,17,48},{10746,20,45},{10746,19,47},{10746,18,51}]},{3,[{10747,15,34},{10747,11,34},{10747,8,40},{10747,9,35},{10747,14,36},{10748,13,38},{10748,8,40},{10748,12,34},{10748,14,40},{10748,12,38},{10749,12,34},{10749,12,38},{10749,8,33},{10749,11,36},{10749,14,39}]},{4,[{10750,15,24},{10750,12,26},{10750,14,27},{10750,15,25},{10750,11,22},{10751,15,27},{10751,17,24},{10751,11,22},{10751,17,23},{10751,10,26},{10752,16,25},{10752,14,25},{10752,15,28},{10752,15,23},{10752,12,22}]},{5,[{10753,24,17},{10753,27,19},{10753,26,17},{10753,24,22},{10753,27,17},{10754,23,23},{10754,23,22},{10754,21,23},{10754,21,16},{10754,25,22},{10755,25,23},{10755,26,16},{10755,26,22},{10755,23,21},{10755,27,21}]},{6,[{10758,25,20}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,102},{lvdown,999}] ,scenes = [] ,out = [] };
get(54010) ->
	#dungeon{id = 54010 ,sid = 54010 ,name = ?T("灵骑灵脉"), type = 14 ,lv = 104 ,mon = [{1,[{10771,13,49},{10771,13,46},{10771,12,45},{10771,12,48},{10771,12,48},{10772,14,44},{10772,15,51},{10772,15,46},{10772,13,45},{10772,12,50},{10773,13,46},{10773,13,44},{10773,14,47},{10773,15,44},{10773,14,44}]},{2,[{10774,20,44},{10774,19,50},{10774,22,48},{10774,18,45},{10774,22,47},{10775,22,50},{10775,22,49},{10775,18,46},{10775,22,48},{10775,20,49},{10776,18,46},{10776,21,48},{10776,18,47},{10776,18,46},{10776,18,45}]},{3,[{10777,33,28},{10777,31,27},{10777,32,28},{10777,32,31},{10777,32,31},{10778,30,32},{10778,30,28},{10778,28,30},{10778,31,28},{10778,32,26},{10779,32,30},{10779,28,32},{10779,32,28},{10779,32,28},{10779,30,31}]},{4,[{10780,35,21},{10780,34,17},{10780,33,19},{10780,30,18},{10780,33,18},{10781,35,18},{10781,31,25},{10781,31,22},{10781,32,18},{10781,34,26},{10782,31,24},{10782,33,23},{10782,34,21},{10782,31,26},{10782,32,27}]},{5,[{10783,12,8},{10783,12,10},{10783,12,17},{10783,12,15},{10783,15,10},{10784,15,18},{10784,12,16},{10784,13,17},{10784,10,12},{10784,11,17},{10785,14,9},{10785,13,11},{10785,12,11},{10785,13,16},{10785,20,14}]},{6,[{10788,8,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,104},{lvdown,999}] ,scenes = [] ,out = [] };
get(54011) ->
	#dungeon{id = 54011 ,sid = 54011 ,name = ?T("灵弓灵脉"), type = 14 ,lv = 106 ,mon = [{1,[{10801,33,59},{10801,33,56},{10801,33,55},{10801,33,53},{10801,34,52},{10802,35,51},{10802,36,50},{10802,36,49},{10802,35,55},{10802,35,54},{10803,34,54},{10803,33,56},{10803,32,58},{10803,36,52},{10803,35,54}]},{2,[{10804,27,55},{10804,29,53},{10804,30,52},{10804,31,51},{10804,31,50},{10805,32,49},{10805,34,50},{10805,30,55},{10805,31,53},{10805,32,52},{10806,33,51},{10806,35,51},{10806,30,57},{10806,31,55},{10806,31,57}]},{3,[{10807,20,37},{10807,20,36},{10807,21,35},{10807,22,34},{10807,23,33},{10808,25,34},{10808,25,32},{10808,26,32},{10808,27,33},{10808,25,35},{10809,20,34},{10809,22,33},{10809,23,31},{10809,24,33},{10809,25,34}]},{4,[{10810,26,25},{10810,28,27},{10810,28,28},{10810,29,29},{10810,30,30},{10811,25,27},{10811,23,29},{10811,22,30},{10811,21,30},{10811,26,28},{10812,26,31},{10812,25,23},{10812,23,24},{10812,22,25},{10812,23,30}]},{5,[{10813,17,25},{10813,18,24},{10813,19,23},{10813,21,22},{10814,21,21},{10814,23,19},{10814,20,24},{10814,25,21},{10814,23,21},{10815,22,23},{10815,19,23},{10815,21,22},{10815,21,21},{10815,20,25}]},{6,[{10818,9,10}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,106},{lvdown,999}] ,scenes = [] ,out = [] };
get(54012) ->
	#dungeon{id = 54012 ,sid = 54012 ,name = ?T("灵佩灵脉"), type = 14 ,lv = 125 ,mon = [{1,[{10831,13,43},{10831,12,44},{10831,11,46},{10831,10,47},{10831,12,48},{10832,13,46},{10832,14,44},{10832,15,45},{10832,14,46},{10832,13,47},{10833,13,49},{10833,13,52},{10833,15,48},{10833,16,46},{10833,16,48}]},{2,[{10834,24,46},{10834,25,48},{10834,26,50},{10834,25,45},{10834,26,47},{10835,27,49},{10835,27,43},{10835,27,46},{10835,28,46},{10835,29,49},{10836,28,42},{10836,29,45},{10836,30,47},{10836,29,41},{10836,30,43}]},{3,[{10837,29,49},{10837,28,42},{10837,29,45},{10837,30,47},{10837,29,41},{10838,30,43},{10838,18,47},{10838,18,49},{10838,18,51},{10838,18,53},{10839,17,56},{10839,19,56},{10839,22,50},{10839,21,50},{10839,17,49}]},{4,[{10840,29,37},{10840,31,38},{10840,32,39},{10840,33,41},{10840,35,43},{10841,35,40},{10841,34,37},{10841,31,35},{10841,29,34},{10841,27,35},{10842,32,45},{10842,37,43},{10842,37,39},{10842,36,36},{10842,35,35}]},{5,[{10843,29,30},{10843,32,30},{10843,33,30},{10843,35,30},{10843,37,31},{10844,38,31},{10844,40,33},{10844,39,36},{10844,37,34},{10844,35,25},{10845,35,25},{10845,35,25},{10845,35,25},{10845,35,25},{10845,35,25}]},{6,[{10848,35,25}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,125},{lvdown,999}] ,scenes = [] ,out = [] };
get(54013) ->
	#dungeon{id = 54013 ,sid = 54013 ,name = ?T("仙宝灵脉"), type = 14 ,lv = 115 ,mon = [{1,[{10861,17,31},{10861,19,30},{10861,21,32},{10861,20,33},{10861,20,36},{10862,23,36},{10862,23,33},{10862,23,30},{10862,22,27},{10862,21,26},{10863,19,25},{10863,17,25},{10863,24,33},{10863,23,30},{10863,23,28}]},{2,[{10864,17,25},{10864,18,22},{10864,20,23},{10864,21,22},{10864,22,22},{10865,23,23},{10865,21,22},{10865,20,23},{10865,19,25},{10865,18,27},{10866,19,28},{10866,21,26},{10866,22,24},{10866,24,22},{10866,25,24}]},{3,[{10867,26,32},{10867,28,32},{10867,30,33},{10867,32,33},{10867,32,30},{10868,30,30},{10868,28,30},{10868,26,30},{10868,26,28},{10868,28,28},{10869,29,28},{10869,31,28},{10869,31,31},{10869,31,34},{10869,25,30},{10869,33,15}]},{4,[{10870,34,17},{10870,35,18},{10870,36,21},{10870,37,23},{10870,31,16},{10871,32,18},{10871,33,21},{10871,34,23},{10871,35,23},{10871,37,25},{10872,35,26},{10872,34,24},{10872,32,22},{10872,31,21},{10872,37,38}]},{5,[{10873,38,36},{10873,40,34},{10873,41,32},{10873,41,29},{10873,41,28},{10874,40,26},{10874,39,30},{10874,38,31},{10874,37,33},{10874,35,35},{10875,34,37},{10875,33,34},{10875,35,32},{10875,36,29},{10875,42,32}]}] ,round_time = 0 ,time = 300 ,count = 1 ,condition = [{lvup,115},{lvdown,999}] ,scenes = [] ,out = [] };
get(55001) ->
	#dungeon{id = 55001 ,sid = 55001 ,name = ?T("试炼·蜀山"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55002) ->
	#dungeon{id = 55002 ,sid = 55002 ,name = ?T("试炼·青云"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55003) ->
	#dungeon{id = 55003 ,sid = 55003 ,name = ?T("试炼·长安"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55004) ->
	#dungeon{id = 55004 ,sid = 55004 ,name = ?T("试炼·蛮荒"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55005) ->
	#dungeon{id = 55005 ,sid = 55005 ,name = ?T("试炼·东海"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55006) ->
	#dungeon{id = 55006 ,sid = 55006 ,name = ?T("英雄试炼·蜀山"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55007) ->
	#dungeon{id = 55007 ,sid = 55007 ,name = ?T("英雄试炼·青云"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55008) ->
	#dungeon{id = 55008 ,sid = 55008 ,name = ?T("英雄试炼·长安"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55009) ->
	#dungeon{id = 55009 ,sid = 55009 ,name = ?T("英雄试炼·蛮荒"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55010) ->
	#dungeon{id = 55010 ,sid = 55010 ,name = ?T("英雄试炼·东海"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55011) ->
	#dungeon{id = 55011 ,sid = 55011 ,name = ?T("魔神试炼·蜀山"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55012) ->
	#dungeon{id = 55012 ,sid = 55012 ,name = ?T("魔神试炼·青云"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(55013) ->
	#dungeon{id = 55013 ,sid = 55013 ,name = ?T("魔神试炼·长安"), type = 7 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 60 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(60001) ->
	#dungeon{id = 60001 ,sid = 60001 ,name = ?T("单人boss(普通)"), type = 10 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 120 ,count = 13 ,condition = [{lvup,1},{lvdown,120}] ,scenes = [] ,out = [] };
get(60002) ->
	#dungeon{id = 60002 ,sid = 60002 ,name = ?T("单人boss(苦难)"), type = 10 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 120 ,count = 5 ,condition = [{lvup,1},{lvdown,120}] ,scenes = [] ,out = [] };
get(60003) ->
	#dungeon{id = 60003 ,sid = 60003 ,name = ?T("单人boss(炼狱)"), type = 10 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 120 ,count = 3 ,condition = [{lvup,1},{lvdown,120}] ,scenes = [] ,out = [] };
get(30401) ->
	#dungeon{id = 30401 ,sid = 30401 ,name = ?T("守护剑像"), type = 19 ,lv = 30 ,mon = [{1,[{10001,10,31},{10001,10,29},{10001,10,27},{10002,10,27},{10002,10,30},{10002,11,28},{10003,10,28},{10003,8,30},{10003,11,30},{10003,8,30}]},{2,[{10004,20,36},{10004,17,35},{10004,14,35},{10005,17,34},{10005,16,38},{10005,16,36},{10006,19,34},{10006,20,35},{10006,18,34},{10006,19,37}]},{3,[{10007,30,36},{10007,30,36},{10007,24,34},{10008,28,33},{10008,26,34},{10008,27,35},{10009,24,34},{10009,27,35},{10009,26,35},{10009,24,36}]},{4,[{10010,31,31},{10010,32,26},{10010,37,34},{10011,34,26},{10011,36,33},{10011,32,31},{10012,36,31},{10012,31,25},{10012,37,34},{10012,34,34}]},{5,[{10013,44,34},{10013,43,25},{10013,45,30},{10014,45,24},{10014,43,28},{10014,41,31},{10015,47,29},{10015,41,26},{10015,41,35},{10015,47,28}]},{6,[{10018,48,21}]}] ,round_time = 60 ,time = 300 ,count = 3 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21001) ->
	#dungeon{id = 21001 ,sid = 21001 ,name = ?T("公会副本1"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21002) ->
	#dungeon{id = 21002 ,sid = 21002 ,name = ?T("公会副本2"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21003) ->
	#dungeon{id = 21003 ,sid = 21003 ,name = ?T("公会副本3"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21004) ->
	#dungeon{id = 21004 ,sid = 21004 ,name = ?T("公会副本4"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21005) ->
	#dungeon{id = 21005 ,sid = 21005 ,name = ?T("公会副本5"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21006) ->
	#dungeon{id = 21006 ,sid = 21006 ,name = ?T("公会副本6"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21007) ->
	#dungeon{id = 21007 ,sid = 21007 ,name = ?T("公会副本7"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21008) ->
	#dungeon{id = 21008 ,sid = 21008 ,name = ?T("公会副本8"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21009) ->
	#dungeon{id = 21009 ,sid = 21009 ,name = ?T("公会副本9"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(21010) ->
	#dungeon{id = 21010 ,sid = 21010 ,name = ?T("公会副本10"), type = 11 ,lv = 45 ,mon = [] ,round_time = 0 ,time = 180 ,count = 2 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(60501) ->
	#dungeon{id = 60501 ,sid = 60501 ,name = ?T("观星台前山"), type = 12 ,lv = 50 ,mon = [{1,[{30001,13,56},{30001,15,58},{30001,18,56},{30001,12,53},{30001,13,49},{30002,16,48},{30002,15,53},{30002,18,51},{30002,9,51},{30002,9,55}]},{2,[{30004,18,50},{30004,18,54},{30004,20,57},{30004,20,53},{30004,23,54},{30005,23,59},{30005,26,57},{30005,26,62},{30005,24,58},{30005,22,55}]},{3,[{30006,30,62}]},{4,[{30007,31,57},{30007,34,59},{30007,35,55},{30007,34,53},{30007,31,51},{30008,33,48},{30008,31,47},{30008,29,49},{30008,30,44},{30008,28,46}]},{5,[{30009,27,45},{30009,30,43},{30009,33,41},{30009,33,37},{30009,30,39},{30010,25,42},{30010,25,38},{30010,31,34},{30010,28,38},{30010,28,34}]},{6,[{30011,27,44},{30011,30,42},{30011,33,39},{30011,28,40},{30011,31,36},{30012,22,34},{30012,25,30},{30012,29,28},{30012,25,36},{30012,28,33}]},{7,[{30013,28,35}]},{8,[{30014,24,31},{30014,24,27},{30014,28,29},{30014,20,27},{30014,22,29},{30015,21,23},{30015,17,24},{30015,17,20},{30015,15,22},{30015,19,23}]},{9,[{30016,13,22},{30016,16,18},{30016,9,21},{30016,12,17},{30016,15,13},{30017,5,20},{30017,8,16},{30017,11,13},{30017,13,10},{30017,7,25}]},{10,[{30018,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,50},{lvdown,500}] ,scenes = [] ,out = [] };
get(60502) ->
	#dungeon{id = 60502 ,sid = 60502 ,name = ?T("九霄塔前山"), type = 12 ,lv = 60 ,mon = [{1,[{30051,14,53},{30051,14,60},{30051,13,57},{30051,16,55},{30051,16,59},{30052,18,51},{30052,19,53},{30052,19,58},{30052,21,50},{30052,22,52},{30053,21,56},{30053,22,60},{30053,23,49},{30053,24,58},{30053,25,53}]},{2,[{30054,25,51},{30054,25,57},{30054,27,55},{30054,27,52},{30054,29,49},{30055,29,55},{30055,30,52},{30055,32,55},{30055,30,46},{30055,32,49},{30056,34,53},{30056,36,50},{30056,35,46},{30056,32,45},{30056,34,48}]},{3,[{30057,34,47}]},{4,[{30058,31,45},{30058,35,43},{30058,31,41},{30058,34,39},{30058,35,35},{30059,33,41},{30059,33,33},{30059,31,35},{30059,33,36},{30059,29,39},{30060,30,31},{30060,28,33},{30060,29,37},{30060,31,38},{30060,27,37}]},{5,[{30061,30,31},{30061,28,33},{30061,29,37},{30061,31,38},{30061,27,37},{30062,26,41},{30062,27,30},{30062,24,39},{30062,25,36},{30062,26,32},{30063,24,30},{30063,22,40},{30063,20,38},{30063,22,37},{30063,23,24}]},{6,[{30064,13,34},{30064,13,38},{30064,15,39},{30064,15,36},{30064,10,33},{30065,12,29},{30065,7,32},{30065,9,30},{30065,11,28},{30065,4,26},{30066,4,21},{30066,6,17},{30066,10,18},{30066,8,22},{30066,7,27}]},{7,[{30067,9,18}]},{8,[{30068,10,11},{30068,12,15},{30068,13,9},{30068,15,14},{30068,16,7},{30069,14,12},{30069,16,10},{30069,18,14},{30069,19,8},{30069,19,11},{30070,20,16},{30070,22,10},{30070,23,12},{30070,23,17},{30070,21,13}]},{9,[{30071,18,8},{30071,17,12},{30071,19,16},{30071,21,10},{30071,22,18},{30072,26,11},{30072,28,18},{30072,26,18},{30072,24,14},{30072,15,8},{30073,15,14},{30073,20,12},{30073,14,11},{30073,17,7}]},{10,[{30074,28,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,60},{lvdown,500}] ,scenes = [] ,out = [] };
get(60503) ->
	#dungeon{id = 60503 ,sid = 60503 ,name = ?T("古皇陵前山"), type = 12 ,lv = 70 ,mon = [{1,[{30101,3,64},{30101,4,65},{30101,5,66},{30101,6,67},{30101,7,68},{30102,6,62},{30102,7,63},{30102,8,64},{30102,9,65},{30102,10,66}]},{2,[{30103,12,56},{30103,13,57},{30103,14,58},{30103,15,59},{30103,16,60},{30104,14,54},{30104,15,55},{30104,16,56},{30104,17,57},{30104,18,58}]},{3,[{30105,9,60},{30105,10,61},{30105,11,62},{30105,12,63},{30105,13,64},{30105,14,63},{30105,15,62},{30105,16,61},{30105,17,55},{30105,17,56},{30106,17,50},{30106,18,51},{30106,19,52},{30106,20,53},{30107,21,51}]},{4,[{30108,12,56},{30108,13,57},{30108,14,58},{30108,15,59},{30108,16,60},{30108,12,59},{30108,13,61},{30109,25,45},{30109,25,44},{30109,26,47},{30109,27,45},{30109,28,45},{30109,29,45},{30109,30,50}]},{5,[{30110,29,42},{30110,30,42},{30110,31,45},{30110,30,39},{30110,31,39},{30110,32,41},{30110,33,41},{30110,32,44},{30110,31,42},{30110,30,43}]},{6,[{30111,40,43},{30111,41,42},{30111,43,42},{30111,42,40},{30111,44,40},{30112,49,50},{30112,50,50},{30112,51,50},{30112,52,50},{30112,49,48},{30112,50,48},{30112,51,48},{30112,52,48},{30112,51,51},{30113,52,46}]},{7,[{30114,31,39},{30114,32,41},{30114,33,41},{30114,32,44},{30114,31,42},{30115,19,48},{30115,20,49},{30115,21,50},{30115,19,51},{30115,20,52}]},{8,[{30116,37,29},{30116,39,35},{30116,39,32},{30116,41,32},{30116,42,31},{30117,43,31},{30117,41,30},{30117,41,28},{30117,39,29},{30117,40,26}]},{9,[{30120,48,20}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,70},{lvdown,500}] ,scenes = [] ,out = [] };
get(60504) ->
	#dungeon{id = 60504 ,sid = 60504 ,name = ?T("妖神宫前山"), type = 12 ,lv = 80 ,mon = [{1,[{30201,27,66},{30201,26,67},{30201,26,67},{30201,27,67},{30201,26,66},{30201,28,64},{30201,26,66},{30201,28,64},{30201,25,67},{30201,25,64},{30201,26,67},{30201,25,67},{30201,27,65},{30201,27,67},{30201,27,65}]},{2,[{30201,31,54},{30202,33,56},{30202,31,55},{30202,31,58},{30202,33,58},{30202,32,57},{30202,32,56},{30202,32,55},{30202,31,58},{30202,32,54},{30202,33,57},{30202,32,54},{30202,35,56},{30202,31,56},{30202,32,56}]},{3,[{30202,28,49},{30203,29,51},{30203,27,53},{30203,28,50},{30203,26,48},{30203,27,53},{30203,26,54},{30203,29,51},{30203,29,52},{30203,26,52},{30203,26,51},{30203,26,48},{30203,28,49},{30203,26,50},{30203,26,48}]},{4,[{30211,26,48}]},{5,[{30203,24,45},{30204,23,45},{30204,22,46},{30204,22,45},{30204,23,45},{30204,24,46},{30204,25,47},{30204,25,44},{30204,22,45},{30204,22,47},{30204,24,47},{30204,23,44},{30204,24,44},{30204,23,44},{30204,22,44}]},{6,[{30204,18,37},{30205,19,39},{30205,19,36},{30205,17,38},{30205,19,36},{30205,18,37},{30205,19,39},{30205,20,39},{30205,19,40},{30205,16,36},{30205,19,40},{30205,19,40},{30205,19,36},{30205,19,37},{30205,17,40}]},{7,[{30205,12,32},{30206,13,32},{30206,12,33},{30206,13,31},{30206,12,32},{30206,13,35},{30206,11,34},{30206,13,31},{30206,12,32},{30206,11,32},{30206,13,35},{30206,11,35},{30206,13,31},{30206,12,32},{30206,12,35}]},{8,[{30212,12,35}]},{9,[{30206,10,30},{30207,7,27},{30207,7,29},{30207,9,27},{30207,8,27},{30207,6,29},{30207,10,27},{30207,8,30},{30207,9,27},{30207,9,28},{30207,6,26},{30207,6,27},{30207,8,25},{30207,6,30},{30207,10,28}]},{10,[{30207,9,21},{30208,8,24},{30208,9,20},{30208,8,19},{30208,9,19},{30208,8,22},{30208,8,20},{30208,9,20},{30208,9,22},{30208,10,22},{30208,10,20},{30208,10,22},{30208,8,19},{30208,8,21},{30208,9,23}]},{11,[{30208,14,14},{30209,12,15},{30209,13,15},{30209,12,16},{30209,13,17},{30209,14,15},{30209,13,14},{30209,13,15},{30209,15,18},{30209,15,15},{30209,12,18},{30209,14,14},{30209,12,18},{30209,13,17},{30209,12,15}]},{12,[{30210,17,12}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,80},{lvdown,500}] ,scenes = [] ,out = [] };
get(60505) ->
	#dungeon{id = 60505 ,sid = 60505 ,name = ?T("归墟境前山"), type = 12 ,lv = 90 ,mon = [{1,[{51181,23,57},{51181,26,57},{51181,23,58},{51181,24,56},{51181,29,57},{51182,24,58},{51182,27,58},{51182,27,57},{51182,25,55},{51182,29,55},{51183,24,58},{51183,31,60},{51183,31,58},{51183,29,58},{51183,22,55}]},{2,[{51184,22,53},{51184,21,53},{51184,20,55},{51184,21,54},{51184,21,52},{51185,22,54},{51185,22,50},{51185,22,50},{51185,20,51},{51185,20,54},{51186,20,51},{51186,18,55},{51186,18,51},{51186,21,53},{51186,21,52}]},{3,[{51187,14,45},{51187,19,49},{51187,15,48},{51187,14,48},{51187,16,47},{51188,17,49},{51188,16,50},{51188,19,48},{51188,15,50},{51188,19,45},{51189,19,47},{51189,15,45},{51189,19,49},{51189,17,46},{51189,16,49}]},{4,[{51192,14,43}]},{5,[{51193,15,40},{51193,16,41},{51193,17,41},{51193,15,43},{51193,14,42},{51194,19,40},{51194,18,42},{51194,16,42},{51194,19,43},{51194,14,43},{51195,16,42},{51195,15,40},{51195,15,40},{51195,15,44},{51195,15,44}]},{6,[{51196,20,37},{51196,23,39},{51196,22,37},{51196,25,36},{51196,23,38},{51197,20,35},{51197,21,35},{51197,24,36},{51197,23,35},{51197,24,36},{51198,20,37},{51198,24,35},{51198,24,38},{51198,20,35},{51198,19,36}]},{7,[{51199,26,29},{51199,24,26},{51199,26,29},{51199,28,27},{51199,24,25},{51200,27,24},{51200,27,26},{51200,27,27},{51200,24,26},{51200,27,25},{51201,25,29},{51201,27,26},{51201,24,28},{51201,27,27},{51201,28,28}]},{8,[{51204,14,16}]},{9,[{51205,15,16},{51205,14,16},{51205,15,16},{51205,17,15},{51205,19,15},{51206,20,16},{51206,22,19},{51206,22,21},{51206,21,23},{51206,14,17},{51207,16,18},{51207,18,17},{51207,19,18},{51207,19,19},{51207,19,19}]},{10,[{51208,23,20},{51208,21,19},{51208,21,22},{51208,22,20},{51208,17,20},{51209,21,21},{51209,19,18},{51209,23,21},{51209,18,17},{51209,22,22},{51210,17,22},{51210,17,22},{51210,17,17},{51210,19,22},{51210,19,17}]},{11,[{51211,11,25},{51211,11,21},{51211,12,22},{51211,12,23},{51211,10,25},{51212,11,22},{51212,9,18},{51212,13,23},{51212,11,20},{51212,9,19},{51213,12,19},{51213,11,20},{51213,11,19},{51213,12,25},{51213,13,18}]},{12,[{51216,11,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,90},{lvdown,500}] ,scenes = [] ,out = [] };
get(60506) ->
	#dungeon{id = 60506 ,sid = 60506 ,name = ?T("观星台密道"), type = 12 ,lv = 100 ,mon = [{1,[{51226,13,56},{51226,15,58},{51226,18,56},{51227,12,53},{51227,13,49},{51227,16,48},{51228,15,53},{51228,18,51},{51228,9,51},{51228,9,55}]},{2,[{51229,18,50},{51229,18,54},{51229,20,57},{51230,20,53},{51230,23,54},{51230,23,59},{51231,26,57},{51231,26,62},{51231,24,58},{51231,22,55}]},{3,[{51234,30,62}]},{4,[{51235,31,57},{51235,34,59},{51235,35,55},{51236,34,53},{51236,31,51},{51236,33,48},{51237,31,47},{51237,29,49},{51237,30,44},{51237,28,46}]},{5,[{51238,27,45},{51238,30,43},{51238,33,41},{51239,33,37},{51239,30,39},{51239,25,42},{51240,25,38},{51240,31,34},{51240,28,38},{51240,28,34}]},{6,[{51241,27,44},{51241,30,42},{51241,33,39},{51242,28,40},{51242,31,36},{51242,22,34},{51243,25,30},{51243,29,28},{51243,25,36},{51243,28,33}]},{7,[{51246,28,35}]},{8,[{51247,24,31},{51247,24,27},{51247,28,29},{51248,20,27},{51248,22,29},{51248,21,23},{51249,17,24},{51249,17,20},{51249,15,22},{51249,19,23}]},{9,[{51250,13,22},{51250,16,18},{51250,9,21},{51251,12,17},{51251,15,13},{51251,5,20},{51252,8,16},{51252,11,13},{51252,13,10},{51252,7,25}]},{10,[{51255,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,100},{lvdown,500}] ,scenes = [] ,out = [] };
get(60507) ->
	#dungeon{id = 60507 ,sid = 60507 ,name = ?T("九霄塔密道"), type = 12 ,lv = 110 ,mon = [{1,[{51271,14,53},{51271,14,60},{51271,13,57},{51271,16,55},{51271,16,59},{51272,18,51},{51272,19,53},{51272,19,58},{51272,21,50},{51272,22,52},{51273,21,56},{51273,22,60},{51273,23,49},{51273,24,58},{51273,25,53}]},{2,[{51274,25,51},{51274,25,57},{51274,27,55},{51274,27,52},{51274,29,49},{51275,29,55},{51275,30,52},{51275,32,55},{51275,30,46},{51275,32,49},{51276,34,53},{51276,36,50},{51276,35,46},{51276,32,45},{51276,34,48}]},{3,[{51279,34,47}]},{4,[{51280,31,45},{51280,35,43},{51280,31,41},{51280,34,39},{51280,35,35},{51281,33,41},{51281,33,33},{51281,31,35},{51281,33,36},{51281,29,39},{51282,30,31},{51282,28,33},{51282,29,37},{51282,31,38},{51282,27,37}]},{5,[{51283,30,31},{51283,28,33},{51283,29,37},{51283,31,38},{51283,27,37},{51284,26,41},{51284,27,30},{51284,24,39},{51284,25,36},{51284,26,32},{51285,24,30},{51285,22,40},{51285,20,38},{51285,22,37},{51285,23,24}]},{6,[{51286,13,34},{51286,13,38},{51286,15,39},{51286,15,36},{51286,10,33},{51287,12,29},{51287,7,32},{51287,9,30},{51287,11,28},{51287,4,26},{51288,4,21},{51288,6,17},{51288,10,18},{51288,8,22},{51288,7,27}]},{7,[{51291,9,18}]},{8,[{51292,10,11},{51292,12,15},{51292,13,9},{51292,15,14},{51292,16,7},{51293,14,12},{51293,16,10},{51293,18,14},{51293,19,8},{51293,19,11},{51294,20,16},{51294,22,10},{51294,23,12},{51294,23,17},{51294,21,13}]},{9,[{51295,18,8},{51295,17,12},{51295,19,16},{51295,21,10},{51296,22,18},{51296,26,11},{51296,28,18},{51296,26,18},{51296,24,14},{51297,15,8},{51297,15,14},{51297,20,12},{51297,14,11},{51297,17,7}]},{10,[{51300,28,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,110},{lvdown,500}] ,scenes = [] ,out = [] };
get(60508) ->
	#dungeon{id = 60508 ,sid = 60508 ,name = ?T("古皇陵密道"), type = 12 ,lv = 120 ,mon = [{1,[{51316,3,64},{51316,4,65},{51316,5,66},{51317,6,67},{51317,7,68},{51317,6,62},{51318,7,63},{51318,8,64},{51318,9,65},{51318,10,66}]},{2,[{51319,12,56},{51319,13,57},{51319,14,58},{51320,15,59},{51320,16,60},{51320,14,54},{51321,15,55},{51321,16,56},{51321,17,57},{51321,18,58}]},{3,[{51322,9,60},{51322,10,61},{51322,11,62},{51322,12,63},{51322,13,64},{51323,14,63},{51323,15,62},{51323,16,61},{51323,17,55},{51323,17,56},{51324,17,50},{51324,18,51},{51324,19,52},{51324,20,53},{51324,21,51}]},{4,[{51325,12,56},{51325,13,57},{51325,14,58},{51325,15,59},{51326,16,60},{51326,12,59},{51326,13,61},{51326,25,45},{51326,25,44},{51327,26,47},{51327,27,45},{51327,28,45},{51327,29,45},{51327,30,50}]},{5,[{51328,29,42},{51328,30,42},{51328,31,45},{51329,30,39},{51329,31,39},{51329,32,41},{51330,33,41},{51330,32,44},{51330,31,42},{51330,30,43}]},{6,[{51331,40,43},{51331,41,42},{51331,43,42},{51331,42,40},{51331,44,40},{51332,49,50},{51332,50,50},{51332,51,50},{51332,52,50},{51332,49,48},{51333,50,48},{51333,51,48},{51333,52,48},{51333,51,51},{51333,52,46}]},{7,[{51334,31,39},{51334,32,41},{51334,33,41},{51335,32,44},{51335,31,42},{51335,19,48},{51336,20,49},{51336,21,50},{51336,19,51},{51336,20,52}]},{8,[{51337,37,29},{51337,39,35},{51337,39,32},{51338,41,32},{51338,42,31},{51338,43,31},{51339,41,30},{51339,41,28},{51339,39,29},{51339,40,26}]},{9,[{51342,48,20}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,120},{lvdown,500}] ,scenes = [] ,out = [] };
get(60509) ->
	#dungeon{id = 60509 ,sid = 60509 ,name = ?T("妖神宫密道"), type = 12 ,lv = 130 ,mon = [{1,[{51361,27,66},{51361,26,67},{51361,26,67},{51361,27,67},{51361,26,66},{51362,28,64},{51362,26,66},{51362,28,64},{51362,25,67},{51362,25,64},{51363,26,67},{51363,25,67},{51363,27,65},{51363,27,67},{51363,27,65}]},{2,[{51364,31,54},{51364,33,56},{51364,31,55},{51364,31,58},{51364,33,58},{51365,32,57},{51365,32,56},{51365,32,55},{51365,31,58},{51365,32,54},{51366,33,57},{51366,32,54},{51366,35,56},{51366,31,56},{51366,32,56}]},{3,[{51367,28,49},{51367,29,51},{51367,27,53},{51367,28,50},{51367,26,48},{51368,27,53},{51368,26,54},{51368,29,51},{51368,29,52},{51368,26,52},{51369,26,51},{51369,26,48},{51369,28,49},{51369,26,50},{51369,26,48}]},{4,[{51372,26,48}]},{5,[{51373,24,45},{51373,23,45},{51373,22,46},{51373,22,45},{51373,23,45},{51374,24,46},{51374,25,47},{51374,25,44},{51374,22,45},{51374,22,47},{51375,24,47},{51375,23,44},{51375,24,44},{51375,23,44},{51375,22,44}]},{6,[{51376,18,37},{51376,19,39},{51376,19,36},{51376,17,38},{51376,19,36},{51377,18,37},{51377,19,39},{51377,20,39},{51377,19,40},{51377,16,36},{51378,19,40},{51378,19,40},{51378,19,36},{51378,19,37},{51378,17,40}]},{7,[{51379,12,32},{51379,13,32},{51379,12,33},{51379,13,31},{51379,12,32},{51380,13,35},{51380,11,34},{51380,13,31},{51380,12,32},{51380,11,32},{51381,13,35},{51381,11,35},{51381,13,31},{51381,12,32},{51381,12,35}]},{8,[{51384,12,35}]},{9,[{51385,10,30},{51385,7,27},{51385,7,29},{51385,9,27},{51385,8,27},{51386,6,29},{51386,10,27},{51386,8,30},{51386,9,27},{51386,9,28},{51387,6,26},{51387,6,27},{51387,8,25},{51387,6,30},{51387,10,28}]},{10,[{51388,9,21},{51388,8,24},{51388,9,20},{51388,8,19},{51388,9,19},{51389,8,22},{51389,8,20},{51389,9,20},{51389,9,22},{51389,10,22},{51390,10,20},{51390,10,22},{51390,8,19},{51390,8,21},{51390,9,23}]},{11,[{51391,14,14},{51391,12,15},{51391,13,15},{51391,12,16},{51391,13,17},{51392,14,15},{51392,13,14},{51392,13,15},{51392,15,18},{51392,15,15},{51393,12,18},{51393,14,14},{51393,12,18},{51393,13,17},{51393,12,15}]},{12,[{51396,17,12}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,130},{lvdown,502}] ,scenes = [] ,out = [] };
get(60510) ->
	#dungeon{id = 60510 ,sid = 60510 ,name = ?T("归墟境密道"), type = 12 ,lv = 140 ,mon = [{1,[{51406,23,57},{51406,26,57},{51406,23,58},{51406,24,56},{51406,29,57},{51407,24,58},{51407,27,58},{51407,27,57},{51407,25,55},{51407,29,55},{51408,24,58},{51408,31,60},{51408,31,58},{51408,29,58},{51408,22,55}]},{2,[{51409,22,53},{51409,21,53},{51409,20,55},{51409,21,54},{51409,21,52},{51410,22,54},{51410,22,50},{51410,22,50},{51410,20,51},{51410,20,54},{51411,20,51},{51411,18,55},{51411,18,51},{51411,21,53},{51411,21,52}]},{3,[{51412,14,45},{51412,19,49},{51412,15,48},{51412,14,48},{51412,16,47},{51413,17,49},{51413,16,50},{51413,19,48},{51413,15,50},{51413,19,45},{51414,19,47},{51414,15,45},{51414,19,49},{51414,17,46},{51414,16,49}]},{4,[{51417,14,43}]},{5,[{51418,15,40},{51418,16,41},{51418,17,41},{51418,15,43},{51418,14,42},{51419,19,40},{51419,18,42},{51419,16,42},{51419,19,43},{51419,14,43},{51420,16,42},{51420,15,40},{51420,15,40},{51420,15,44},{51420,15,44}]},{6,[{51421,20,37},{51421,23,39},{51421,22,37},{51421,25,36},{51421,23,38},{51422,20,35},{51422,21,35},{51422,24,36},{51422,23,35},{51422,24,36},{51423,20,37},{51423,24,35},{51423,24,38},{51423,20,35},{51423,19,36}]},{7,[{51424,26,29},{51424,24,26},{51424,26,29},{51424,28,27},{51424,24,25},{51425,27,24},{51425,27,26},{51425,27,27},{51425,24,26},{51425,27,25},{51426,25,29},{51426,27,26},{51426,24,28},{51426,27,27},{51426,28,28}]},{8,[{51429,14,16}]},{9,[{51430,15,16},{51430,14,16},{51430,15,16},{51430,17,15},{51430,19,15},{51431,20,16},{51431,22,19},{51431,22,21},{51431,21,23},{51431,14,17},{51432,16,18},{51432,18,17},{51432,19,18},{51432,19,19},{51432,19,19}]},{10,[{51433,23,20},{51433,21,19},{51433,21,22},{51433,22,20},{51433,17,20},{51434,21,21},{51434,19,18},{51434,23,21},{51434,18,17},{51434,22,22},{51435,17,22},{51435,17,22},{51435,17,17},{51435,19,22},{51435,19,17}]},{11,[{51436,11,25},{51436,11,21},{51436,12,22},{51436,12,23},{51436,10,25},{51437,11,22},{51437,9,18},{51437,13,23},{51437,11,20},{51437,9,19},{51438,12,19},{51438,11,20},{51438,11,19},{51438,12,25},{51438,13,18}]},{12,[{51441,11,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,140},{lvdown,503}] ,scenes = [] ,out = [] };
get(60511) ->
	#dungeon{id = 60511 ,sid = 60511 ,name = ?T("观星台后殿"), type = 12 ,lv = 150 ,mon = [{1,[{51451,13,56},{51451,15,58},{51451,18,56},{51452,12,53},{51452,13,49},{51452,16,48},{51453,15,53},{51453,18,51},{51453,9,51},{51453,9,55}]},{2,[{51454,18,50},{51454,18,54},{51454,20,57},{51455,20,53},{51455,23,54},{51455,23,59},{51456,26,57},{51456,26,62},{51456,24,58},{51456,22,55}]},{3,[{51459,30,62}]},{4,[{51460,31,57},{51460,34,59},{51460,35,55},{51461,34,53},{51461,31,51},{51461,33,48},{51462,31,47},{51462,29,49},{51462,30,44},{51462,28,46}]},{5,[{51463,27,45},{51463,30,43},{51463,33,41},{51464,33,37},{51464,30,39},{51464,25,42},{51465,25,38},{51465,31,34},{51465,28,38},{51465,28,34}]},{6,[{51466,27,44},{51466,30,42},{51466,33,39},{51467,28,40},{51467,31,36},{51467,22,34},{51468,25,30},{51468,29,28},{51468,25,36},{51468,28,33}]},{7,[{51471,28,35}]},{8,[{51472,24,31},{51472,24,27},{51472,28,29},{51473,20,27},{51473,22,29},{51473,21,23},{51474,17,24},{51474,17,20},{51474,15,22},{51474,19,23}]},{9,[{51475,13,22},{51475,16,18},{51475,9,21},{51476,12,17},{51476,15,13},{51476,5,20},{51477,8,16},{51477,11,13},{51477,13,10},{51477,7,25}]},{10,[{51480,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,150},{lvdown,503}] ,scenes = [] ,out = [] };
get(60512) ->
	#dungeon{id = 60512 ,sid = 60512 ,name = ?T("九霄塔后殿"), type = 12 ,lv = 160 ,mon = [{1,[{51496,14,53},{51496,14,60},{51496,13,57},{51496,16,55},{51496,16,59},{51497,18,51},{51497,19,53},{51497,19,58},{51497,21,50},{51497,22,52},{51498,21,56},{51498,22,60},{51498,23,49},{51498,24,58},{51498,25,53}]},{2,[{51499,25,51},{51499,25,57},{51499,27,55},{51499,27,52},{51499,29,49},{51500,29,55},{51500,30,52},{51500,32,55},{51500,30,46},{51500,32,49},{51501,34,53},{51501,36,50},{51501,35,46},{51501,32,45},{51501,34,48}]},{3,[{51504,34,47}]},{4,[{51505,31,45},{51505,35,43},{51505,31,41},{51505,34,39},{51505,35,35},{51506,33,41},{51506,33,33},{51506,31,35},{51506,33,36},{51506,29,39},{51507,30,31},{51507,28,33},{51507,29,37},{51507,31,38},{51507,27,37}]},{5,[{51508,30,31},{51508,28,33},{51508,29,37},{51508,31,38},{51508,27,37},{51509,26,41},{51509,27,30},{51509,24,39},{51509,25,36},{51509,26,32},{51510,24,30},{51510,22,40},{51510,20,38},{51510,22,37},{51510,23,24}]},{6,[{51511,13,34},{51511,13,38},{51511,15,39},{51511,15,36},{51511,10,33},{51512,12,29},{51512,7,32},{51512,9,30},{51512,11,28},{51512,4,26},{51513,4,21},{51513,6,17},{51513,10,18},{51513,8,22},{51513,7,27}]},{7,[{51516,9,18}]},{8,[{51517,10,11},{51517,12,15},{51517,13,9},{51517,15,14},{51517,16,7},{51518,14,12},{51518,16,10},{51518,18,14},{51518,19,8},{51518,19,11},{51519,20,16},{51519,22,10},{51519,23,12},{51519,23,17},{51519,21,13}]},{9,[{51520,18,8},{51520,17,12},{51520,19,16},{51520,21,10},{51521,22,18},{51521,26,11},{51521,28,18},{51521,26,18},{51521,24,14},{51522,15,8},{51522,15,14},{51522,20,12},{51522,14,11},{51522,17,7}]},{10,[{51525,28,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,160},{lvdown,503}] ,scenes = [] ,out = [] };
get(60513) ->
	#dungeon{id = 60513 ,sid = 60513 ,name = ?T("古皇陵后殿"), type = 12 ,lv = 170 ,mon = [{1,[{51541,3,64},{51541,4,65},{51541,5,66},{51542,6,67},{51542,7,68},{51542,6,62},{51543,7,63},{51543,8,64},{51543,9,65},{51543,10,66}]},{2,[{51544,12,56},{51544,13,57},{51544,14,58},{51545,15,59},{51545,16,60},{51545,14,54},{51546,15,55},{51546,16,56},{51546,17,57},{51546,18,58}]},{3,[{51547,9,60},{51547,10,61},{51547,11,62},{51547,12,63},{51547,13,64},{51548,14,63},{51548,15,62},{51548,16,61},{51548,17,55},{51548,17,56},{51549,17,50},{51549,18,51},{51549,19,52},{51549,20,53},{51549,21,51}]},{4,[{51550,12,56},{51550,13,57},{51550,14,58},{51550,15,59},{51551,16,60},{51551,12,59},{51551,13,61},{51551,25,45},{51551,25,44},{51552,26,47},{51552,27,45},{51552,28,45},{51552,29,45},{51552,30,50}]},{5,[{51553,29,42},{51553,30,42},{51553,31,45},{51554,30,39},{51554,31,39},{51554,32,41},{51555,33,41},{51555,32,44},{51555,31,42},{51555,30,43}]},{6,[{51556,40,43},{51556,41,42},{51556,43,42},{51556,42,40},{51556,44,40},{51557,49,50},{51557,50,50},{51557,51,50},{51557,52,50},{51557,49,48},{51558,50,48},{51558,51,48},{51558,52,48},{51558,51,51},{51558,52,46}]},{7,[{51559,31,39},{51559,32,41},{51559,33,41},{51560,32,44},{51560,31,42},{51560,19,48},{51561,20,49},{51561,21,50},{51561,19,51},{51561,20,52}]},{8,[{51562,37,29},{51562,39,35},{51562,39,32},{51563,41,32},{51563,42,31},{51563,43,31},{51564,41,30},{51564,41,28},{51564,39,29},{51564,40,26}]},{9,[{51567,48,20}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,170},{lvdown,504}] ,scenes = [] ,out = [] };
get(60514) ->
	#dungeon{id = 60514 ,sid = 60514 ,name = ?T("妖神宫后殿"), type = 12 ,lv = 180 ,mon = [{1,[{51586,27,66},{51586,26,67},{51586,26,67},{51586,27,67},{51586,26,66},{51587,28,64},{51587,26,66},{51587,28,64},{51587,25,67},{51587,25,64},{51588,26,67},{51588,25,67},{51588,27,65},{51588,27,67},{51588,27,65}]},{2,[{51589,31,54},{51589,33,56},{51589,31,55},{51589,31,58},{51589,33,58},{51590,32,57},{51590,32,56},{51590,32,55},{51590,31,58},{51590,32,54},{51591,33,57},{51591,32,54},{51591,35,56},{51591,31,56},{51591,32,56}]},{3,[{51592,28,49},{51592,29,51},{51592,27,53},{51592,28,50},{51592,26,48},{51593,27,53},{51593,26,54},{51593,29,51},{51593,29,52},{51593,26,52},{51594,26,51},{51594,26,48},{51594,28,49},{51594,26,50},{51594,26,48}]},{4,[{51597,26,48}]},{5,[{51598,24,45},{51598,23,45},{51598,22,46},{51598,22,45},{51598,23,45},{51599,24,46},{51599,25,47},{51599,25,44},{51599,22,45},{51599,22,47},{51600,24,47},{51600,23,44},{51600,24,44},{51600,23,44},{51600,22,44}]},{6,[{51601,18,37},{51601,19,39},{51601,19,36},{51601,17,38},{51601,19,36},{51602,18,37},{51602,19,39},{51602,20,39},{51602,19,40},{51602,16,36},{51603,19,40},{51603,19,40},{51603,19,36},{51603,19,37},{51603,17,40}]},{7,[{51604,12,32},{51604,13,32},{51604,12,33},{51604,13,31},{51604,12,32},{51605,13,35},{51605,11,34},{51605,13,31},{51605,12,32},{51605,11,32},{51606,13,35},{51606,11,35},{51606,13,31},{51606,12,32},{51606,12,35}]},{8,[{51609,12,35}]},{9,[{51610,10,30},{51610,7,27},{51610,7,29},{51610,9,27},{51610,8,27},{51611,6,29},{51611,10,27},{51611,8,30},{51611,9,27},{51611,9,28},{51612,6,26},{51612,6,27},{51612,8,25},{51612,6,30},{51612,10,28}]},{10,[{51613,9,21},{51613,8,24},{51613,9,20},{51613,8,19},{51613,9,19},{51614,8,22},{51614,8,20},{51614,9,20},{51614,9,22},{51614,10,22},{51615,10,20},{51615,10,22},{51615,8,19},{51615,8,21},{51615,9,23}]},{11,[{51616,14,14},{51616,12,15},{51616,13,15},{51616,12,16},{51616,13,17},{51617,14,15},{51617,13,14},{51617,13,15},{51617,15,18},{51617,15,15},{51618,12,18},{51618,14,14},{51618,12,18},{51618,13,17},{51618,12,15}]},{12,[{51621,17,12}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,180},{lvdown,504}] ,scenes = [] ,out = [] };
get(60515) ->
	#dungeon{id = 60515 ,sid = 60515 ,name = ?T("归墟境后殿"), type = 12 ,lv = 190 ,mon = [{1,[{51631,23,57},{51631,26,57},{51631,23,58},{51631,24,56},{51631,29,57},{51632,24,58},{51632,27,58},{51632,27,57},{51632,25,55},{51632,29,55},{51633,24,58},{51633,31,60},{51633,31,58},{51633,29,58},{51633,22,55}]},{2,[{51634,22,53},{51634,21,53},{51634,20,55},{51634,21,54},{51634,21,52},{51635,22,54},{51635,22,50},{51635,22,50},{51635,20,51},{51635,20,54},{51636,20,51},{51636,18,55},{51636,18,51},{51636,21,53},{51636,21,52}]},{3,[{51637,14,45},{51637,19,49},{51637,15,48},{51637,14,48},{51637,16,47},{51638,17,49},{51638,16,50},{51638,19,48},{51638,15,50},{51638,19,45},{51639,19,47},{51639,15,45},{51639,19,49},{51639,17,46},{51639,16,49}]},{4,[{51642,14,43}]},{5,[{51643,15,40},{51643,16,41},{51643,17,41},{51643,15,43},{51643,14,42},{51644,19,40},{51644,18,42},{51644,16,42},{51644,19,43},{51644,14,43},{51645,16,42},{51645,15,40},{51645,15,40},{51645,15,44},{51645,15,44}]},{6,[{51646,20,37},{51646,23,39},{51646,22,37},{51646,25,36},{51646,23,38},{51647,20,35},{51647,21,35},{51647,24,36},{51647,23,35},{51647,24,36},{51648,20,37},{51648,24,35},{51648,24,38},{51648,20,35},{51648,19,36}]},{7,[{51649,26,29},{51649,24,26},{51649,26,29},{51649,28,27},{51649,24,25},{51650,27,24},{51650,27,26},{51650,27,27},{51650,24,26},{51650,27,25},{51651,25,29},{51651,27,26},{51651,24,28},{51651,27,27},{51651,28,28}]},{8,[{51654,14,16}]},{9,[{51655,15,16},{51655,14,16},{51655,15,16},{51655,17,15},{51655,19,15},{51656,20,16},{51656,22,19},{51656,22,21},{51656,21,23},{51656,14,17},{51657,16,18},{51657,18,17},{51657,19,18},{51657,19,19},{51657,19,19}]},{10,[{51658,23,20},{51658,21,19},{51658,21,22},{51658,22,20},{51658,17,20},{51659,21,21},{51659,19,18},{51659,23,21},{51659,18,17},{51659,22,22},{51660,17,22},{51660,17,22},{51660,17,17},{51660,19,22},{51660,19,17}]},{11,[{51661,11,25},{51661,11,21},{51661,12,22},{51661,12,23},{51661,10,25},{51662,11,22},{51662,9,18},{51662,13,23},{51662,11,20},{51662,9,19},{51663,12,19},{51663,11,20},{51663,11,19},{51663,12,25},{51663,13,18}]},{12,[{51666,11,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,190},{lvdown,504}] ,scenes = [] ,out = [] };
get(60516) ->
	#dungeon{id = 60516 ,sid = 60516 ,name = ?T("英雄观星台"), type = 12 ,lv = 200 ,mon = [{1,[{51676,13,56},{51676,15,58},{51676,18,56},{51677,12,53},{51677,13,49},{51677,16,48},{51678,15,53},{51678,18,51},{51678,9,51},{51678,9,55}]},{2,[{51679,18,50},{51679,18,54},{51679,20,57},{51680,20,53},{51680,23,54},{51680,23,59},{51681,26,57},{51681,26,62},{51681,24,58},{51681,22,55}]},{3,[{51684,30,62}]},{4,[{51685,31,57},{51685,34,59},{51685,35,55},{51686,34,53},{51686,31,51},{51686,33,48},{51687,31,47},{51687,29,49},{51687,30,44},{51687,28,46}]},{5,[{51688,27,45},{51688,30,43},{51688,33,41},{51689,33,37},{51689,30,39},{51689,25,42},{51690,25,38},{51690,31,34},{51690,28,38},{51690,28,34}]},{6,[{51691,27,44},{51691,30,42},{51691,33,39},{51692,28,40},{51692,31,36},{51692,22,34},{51693,25,30},{51693,29,28},{51693,25,36},{51693,28,33}]},{7,[{51696,28,35}]},{8,[{51697,24,31},{51697,24,27},{51697,28,29},{51698,20,27},{51698,22,29},{51698,21,23},{51699,17,24},{51699,17,20},{51699,15,22},{51699,19,23}]},{9,[{51700,13,22},{51700,16,18},{51700,9,21},{51701,12,17},{51701,15,13},{51701,5,20},{51702,8,16},{51702,11,13},{51702,13,10},{51702,7,25}]},{10,[{51705,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,200},{lvdown,505}] ,scenes = [] ,out = [] };
get(60517) ->
	#dungeon{id = 60517 ,sid = 60517 ,name = ?T("英雄九霄塔"), type = 12 ,lv = 210 ,mon = [{1,[{51721,14,53},{51721,14,60},{51721,13,57},{51721,16,55},{51721,16,59},{51722,18,51},{51722,19,53},{51722,19,58},{51722,21,50},{51722,22,52},{51723,21,56},{51723,22,60},{51723,23,49},{51723,24,58},{51723,25,53}]},{2,[{51724,25,51},{51724,25,57},{51724,27,55},{51724,27,52},{51724,29,49},{51725,29,55},{51725,30,52},{51725,32,55},{51725,30,46},{51725,32,49},{51726,34,53},{51726,36,50},{51726,35,46},{51726,32,45},{51726,34,48}]},{3,[{51729,34,47}]},{4,[{51730,31,45},{51730,35,43},{51730,31,41},{51730,34,39},{51730,35,35},{51731,33,41},{51731,33,33},{51731,31,35},{51731,33,36},{51731,29,39},{51732,30,31},{51732,28,33},{51732,29,37},{51732,31,38},{51732,27,37}]},{5,[{51733,30,31},{51733,28,33},{51733,29,37},{51733,31,38},{51733,27,37},{51734,26,41},{51734,27,30},{51734,24,39},{51734,25,36},{51734,26,32},{51735,24,30},{51735,22,40},{51735,20,38},{51735,22,37},{51735,23,24}]},{6,[{51736,13,34},{51736,13,38},{51736,15,39},{51736,15,36},{51736,10,33},{51737,12,29},{51737,7,32},{51737,9,30},{51737,11,28},{51737,4,26},{51738,4,21},{51738,6,17},{51738,10,18},{51738,8,22},{51738,7,27}]},{7,[{51741,9,18}]},{8,[{51742,10,11},{51742,12,15},{51742,13,9},{51742,15,14},{51742,16,7},{51743,14,12},{51743,16,10},{51743,18,14},{51743,19,8},{51743,19,11},{51744,20,16},{51744,22,10},{51744,23,12},{51744,23,17},{51744,21,13}]},{9,[{51745,18,8},{51745,17,12},{51745,19,16},{51745,21,10},{51746,22,18},{51746,26,11},{51746,28,18},{51746,26,18},{51746,24,14},{51747,15,8},{51747,15,14},{51747,20,12},{51747,14,11},{51747,17,7}]},{10,[{51750,28,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,210},{lvdown,505}] ,scenes = [] ,out = [] };
get(60518) ->
	#dungeon{id = 60518 ,sid = 60518 ,name = ?T("英雄古皇陵"), type = 12 ,lv = 220 ,mon = [{1,[{51766,3,64},{51766,4,65},{51766,5,66},{51767,6,67},{51767,7,68},{51767,6,62},{51768,7,63},{51768,8,64},{51768,9,65},{51768,10,66}]},{2,[{51769,12,56},{51769,13,57},{51769,14,58},{51770,15,59},{51770,16,60},{51770,14,54},{51771,15,55},{51771,16,56},{51771,17,57},{51771,18,58}]},{3,[{51772,9,60},{51772,10,61},{51772,11,62},{51772,12,63},{51772,13,64},{51773,14,63},{51773,15,62},{51773,16,61},{51773,17,55},{51773,17,56},{51774,17,50},{51774,18,51},{51774,19,52},{51774,20,53},{51774,21,51}]},{4,[{51775,12,56},{51775,13,57},{51775,14,58},{51775,15,59},{51776,16,60},{51776,12,59},{51776,13,61},{51776,25,45},{51776,25,44},{51777,26,47},{51777,27,45},{51777,28,45},{51777,29,45},{51777,30,50}]},{5,[{51778,29,42},{51778,30,42},{51778,31,45},{51779,30,39},{51779,31,39},{51779,32,41},{51780,33,41},{51780,32,44},{51780,31,42},{51780,30,43}]},{6,[{51781,40,43},{51781,41,42},{51781,43,42},{51781,42,40},{51781,44,40},{51782,49,50},{51782,50,50},{51782,51,50},{51782,52,50},{51782,49,48},{51783,50,48},{51783,51,48},{51783,52,48},{51783,51,51},{51783,52,46}]},{7,[{51784,31,39},{51784,32,41},{51784,33,41},{51785,32,44},{51785,31,42},{51785,19,48},{51786,20,49},{51786,21,50},{51786,19,51},{51786,20,52}]},{8,[{51787,37,29},{51787,39,35},{51787,39,32},{51788,41,32},{51788,42,31},{51788,43,31},{51789,41,30},{51789,41,28},{51789,39,29},{51789,40,26}]},{9,[{51792,48,20}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,220},{lvdown,505}] ,scenes = [] ,out = [] };
get(60519) ->
	#dungeon{id = 60519 ,sid = 60519 ,name = ?T("英雄妖神宫"), type = 12 ,lv = 230 ,mon = [{1,[{51811,27,66},{51811,26,67},{51811,26,67},{51811,27,67},{51811,26,66},{51812,28,64},{51812,26,66},{51812,28,64},{51812,25,67},{51812,25,64},{51813,26,67},{51813,25,67},{51813,27,65},{51813,27,67},{51813,27,65}]},{2,[{51814,31,54},{51814,33,56},{51814,31,55},{51814,31,58},{51814,33,58},{51815,32,57},{51815,32,56},{51815,32,55},{51815,31,58},{51815,32,54},{51816,33,57},{51816,32,54},{51816,35,56},{51816,31,56},{51816,32,56}]},{3,[{51817,28,49},{51817,29,51},{51817,27,53},{51817,28,50},{51817,26,48},{51818,27,53},{51818,26,54},{51818,29,51},{51818,29,52},{51818,26,52},{51819,26,51},{51819,26,48},{51819,28,49},{51819,26,50},{51819,26,48}]},{4,[{51822,26,48}]},{5,[{51823,24,45},{51823,23,45},{51823,22,46},{51823,22,45},{51823,23,45},{51824,24,46},{51824,25,47},{51824,25,44},{51824,22,45},{51824,22,47},{51825,24,47},{51825,23,44},{51825,24,44},{51825,23,44},{51825,22,44}]},{6,[{51826,18,37},{51826,19,39},{51826,19,36},{51826,17,38},{51826,19,36},{51827,18,37},{51827,19,39},{51827,20,39},{51827,19,40},{51827,16,36},{51828,19,40},{51828,19,40},{51828,19,36},{51828,19,37},{51828,17,40}]},{7,[{51829,12,32},{51829,13,32},{51829,12,33},{51829,13,31},{51829,12,32},{51830,13,35},{51830,11,34},{51830,13,31},{51830,12,32},{51830,11,32},{51831,13,35},{51831,11,35},{51831,13,31},{51831,12,32},{51831,12,35}]},{8,[{51834,12,35}]},{9,[{51835,10,30},{51835,7,27},{51835,7,29},{51835,9,27},{51835,8,27},{51836,6,29},{51836,10,27},{51836,8,30},{51836,9,27},{51836,9,28},{51837,6,26},{51837,6,27},{51837,8,25},{51837,6,30},{51837,10,28}]},{10,[{51838,9,21},{51838,8,24},{51838,9,20},{51838,8,19},{51838,9,19},{51839,8,22},{51839,8,20},{51839,9,20},{51839,9,22},{51839,10,22},{51840,10,20},{51840,10,22},{51840,8,19},{51840,8,21},{51840,9,23}]},{11,[{51841,14,14},{51841,12,15},{51841,13,15},{51841,12,16},{51841,13,17},{51842,14,15},{51842,13,14},{51842,13,15},{51842,15,18},{51842,15,15},{51843,12,18},{51843,14,14},{51843,12,18},{51843,13,17},{51843,12,15}]},{12,[{51846,17,12}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,230},{lvdown,506}] ,scenes = [] ,out = [] };
get(60520) ->
	#dungeon{id = 60520 ,sid = 60520 ,name = ?T("英雄归墟境"), type = 12 ,lv = 240 ,mon = [{1,[{51856,23,57},{51856,26,57},{51856,23,58},{51856,24,56},{51856,29,57},{51857,24,58},{51857,27,58},{51857,27,57},{51857,25,55},{51857,29,55},{51858,24,58},{51858,31,60},{51858,31,58},{51858,29,58},{51858,22,55}]},{2,[{51859,22,53},{51859,21,53},{51859,20,55},{51859,21,54},{51859,21,52},{51860,22,54},{51860,22,50},{51860,22,50},{51860,20,51},{51860,20,54},{51861,20,51},{51861,18,55},{51861,18,51},{51861,21,53},{51861,21,52}]},{3,[{51862,14,45},{51862,19,49},{51862,15,48},{51862,14,48},{51862,16,47},{51863,17,49},{51863,16,50},{51863,19,48},{51863,15,50},{51863,19,45},{51864,19,47},{51864,15,45},{51864,19,49},{51864,17,46},{51864,16,49}]},{4,[{51867,14,43}]},{5,[{51868,15,40},{51868,16,41},{51868,17,41},{51868,15,43},{51868,14,42},{51869,19,40},{51869,18,42},{51869,16,42},{51869,19,43},{51869,14,43},{51870,16,42},{51870,15,40},{51870,15,40},{51870,15,44},{51870,15,44}]},{6,[{51871,20,37},{51871,23,39},{51871,22,37},{51871,25,36},{51871,23,38},{51872,20,35},{51872,21,35},{51872,24,36},{51872,23,35},{51872,24,36},{51873,20,37},{51873,24,35},{51873,24,38},{51873,20,35},{51873,19,36}]},{7,[{51874,26,29},{51874,24,26},{51874,26,29},{51874,28,27},{51874,24,25},{51875,27,24},{51875,27,26},{51875,27,27},{51875,24,26},{51875,27,25},{51876,25,29},{51876,27,26},{51876,24,28},{51876,27,27},{51876,28,28}]},{8,[{51879,14,16}]},{9,[{51880,15,16},{51880,14,16},{51880,15,16},{51880,17,15},{51880,19,15},{51881,20,16},{51881,22,19},{51881,22,21},{51881,21,23},{51881,14,17},{51882,16,18},{51882,18,17},{51882,19,18},{51882,19,19},{51882,19,19}]},{10,[{51883,23,20},{51883,21,19},{51883,21,22},{51883,22,20},{51883,17,20},{51884,21,21},{51884,19,18},{51884,23,21},{51884,18,17},{51884,22,22},{51885,17,22},{51885,17,22},{51885,17,17},{51885,19,22},{51885,19,17}]},{11,[{51886,11,25},{51886,11,21},{51886,12,22},{51886,12,23},{51886,10,25},{51887,11,22},{51887,9,18},{51887,13,23},{51887,11,20},{51887,9,19},{51888,12,19},{51888,11,20},{51888,11,19},{51888,12,25},{51888,13,18}]},{12,[{51891,11,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,240},{lvdown,506}] ,scenes = [] ,out = [] };
get(60521) ->
	#dungeon{id = 60521 ,sid = 60521 ,name = ?T("魔神观星台"), type = 12 ,lv = 250 ,mon = [{1,[{53901,13,56},{53901,15,58},{53901,18,56},{53902,12,53},{53902,13,49},{53902,16,48},{53903,15,53},{53903,18,51},{53903,9,51},{53903,9,55}]},{2,[{53904,18,50},{53904,18,54},{53904,20,57},{53905,20,53},{53905,23,54},{53905,23,59},{53906,26,57},{53906,26,62},{53906,24,58},{53906,22,55}]},{3,[{53909,30,62}]},{4,[{53910,31,57},{53910,34,59},{53910,35,55},{53911,34,53},{53911,31,51},{53911,33,48},{53912,31,47},{53912,29,49},{53912,30,44},{53912,28,46}]},{5,[{53913,27,45},{53913,30,43},{53913,33,41},{53914,33,37},{53914,30,39},{53914,25,42},{53915,25,38},{53915,31,34},{53915,28,38},{53915,28,34}]},{6,[{53916,27,44},{53916,30,42},{53916,33,39},{53917,28,40},{53917,31,36},{53917,22,34},{53918,25,30},{53918,29,28},{53918,25,36},{53918,28,33}]},{7,[{53921,28,35}]},{8,[{53922,24,31},{53922,24,27},{53922,28,29},{53923,20,27},{53923,22,29},{53923,21,23},{53924,17,24},{53924,17,20},{53924,15,22},{53924,19,23}]},{9,[{53925,13,22},{53925,16,18},{53925,9,21},{53926,12,17},{53926,15,13},{53926,5,20},{53927,8,16},{53927,11,13},{53927,13,10},{53927,7,25}]},{10,[{53930,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,250},{lvdown,506}] ,scenes = [] ,out = [] };
get(60522) ->
	#dungeon{id = 60522 ,sid = 60522 ,name = ?T("魔神九霄塔"), type = 12 ,lv = 260 ,mon = [{1,[{53946,14,53},{53946,14,60},{53946,13,57},{53946,16,55},{53946,16,59},{53947,18,51},{53947,19,53},{53947,19,58},{53947,21,50},{53947,22,52},{53948,21,56},{53948,22,60},{53948,23,49},{53948,24,58},{53948,25,53}]},{2,[{53949,25,51},{53949,25,57},{53949,27,55},{53949,27,52},{53949,29,49},{53950,29,55},{53950,30,52},{53950,32,55},{53950,30,46},{53950,32,49},{53951,34,53},{53951,36,50},{53951,35,46},{53951,32,45},{53951,34,48}]},{3,[{53954,34,47}]},{4,[{53955,31,45},{53955,35,43},{53955,31,41},{53955,34,39},{53955,35,35},{53956,33,41},{53956,33,33},{53956,31,35},{53956,33,36},{53956,29,39},{53957,30,31},{53957,28,33},{53957,29,37},{53957,31,38},{53957,27,37}]},{5,[{53958,30,31},{53958,28,33},{53958,29,37},{53958,31,38},{53958,27,37},{53959,26,41},{53959,27,30},{53959,24,39},{53959,25,36},{53959,26,32},{53960,24,30},{53960,22,40},{53960,20,38},{53960,22,37},{53960,23,24}]},{6,[{53961,13,34},{53961,13,38},{53961,15,39},{53961,15,36},{53961,10,33},{53962,12,29},{53962,7,32},{53962,9,30},{53962,11,28},{53962,4,26},{53963,4,21},{53963,6,17},{53963,10,18},{53963,8,22},{53963,7,27}]},{7,[{53966,9,18}]},{8,[{53967,10,11},{53967,12,15},{53967,13,9},{53967,15,14},{53967,16,7},{53968,14,12},{53968,16,10},{53968,18,14},{53968,19,8},{53968,19,11},{53969,20,16},{53969,22,10},{53969,23,12},{53969,23,17},{53969,21,13}]},{9,[{53970,18,8},{53970,17,12},{53970,19,16},{53970,21,10},{53971,22,18},{53971,26,11},{53971,28,18},{53971,26,18},{53971,24,14},{53972,15,8},{53972,15,14},{53972,20,12},{53972,14,11},{53972,17,7}]},{10,[{53975,28,14}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,260},{lvdown,507}] ,scenes = [] ,out = [] };
get(60523) ->
	#dungeon{id = 60523 ,sid = 60523 ,name = ?T("魔神古皇陵"), type = 12 ,lv = 270 ,mon = [{1,[{53991,3,64},{53991,4,65},{53991,5,66},{53992,6,67},{53992,7,68},{53992,6,62},{53993,7,63},{53993,8,64},{53993,9,65},{53993,10,66}]},{2,[{53994,12,56},{53994,13,57},{53994,14,58},{53995,15,59},{53995,16,60},{53995,14,54},{53996,15,55},{53996,16,56},{53996,17,57},{53996,18,58}]},{3,[{53997,9,60},{53997,10,61},{53997,11,62},{53997,12,63},{53997,13,64},{53998,14,63},{53998,15,62},{53998,16,61},{53998,17,55},{53998,17,56},{53999,17,50},{53999,18,51},{53999,19,52},{53999,20,53},{53999,21,51}]},{4,[{54000,12,56},{54000,13,57},{54000,14,58},{54000,15,59},{54001,16,60},{54001,12,59},{54001,13,61},{54001,25,45},{54001,25,44},{54002,26,47},{54002,27,45},{54002,28,45},{54002,29,45},{54002,30,50}]},{5,[{54003,29,42},{54003,30,42},{54003,31,45},{54004,30,39},{54004,31,39},{54004,32,41},{54005,33,41},{54005,32,44},{54005,31,42},{54005,30,43}]},{6,[{54006,40,43},{54006,41,42},{54006,43,42},{54006,42,40},{54006,44,40},{54007,49,50},{54007,50,50},{54007,51,50},{54007,52,50},{54007,49,48},{54008,50,48},{54008,51,48},{54008,52,48},{54008,51,51},{54008,52,46}]},{7,[{54009,31,39},{54009,32,41},{54009,33,41},{54010,32,44},{54010,31,42},{54010,19,48},{54011,20,49},{54011,21,50},{54011,19,51},{54011,20,52}]},{8,[{54012,37,29},{54012,39,35},{54012,39,32},{54013,41,32},{54013,42,31},{54013,43,31},{54014,41,30},{54014,41,28},{54014,39,29},{54014,40,26}]},{9,[{54017,48,20}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,270},{lvdown,507}] ,scenes = [] ,out = [] };
get(60524) ->
	#dungeon{id = 60524 ,sid = 60524 ,name = ?T("魔神妖神宫"), type = 12 ,lv = 280 ,mon = [{1,[{54036,27,66},{54036,26,67},{54036,26,67},{54036,27,67},{54036,26,66},{54037,28,64},{54037,26,66},{54037,28,64},{54037,25,67},{54037,25,64},{54038,26,67},{54038,25,67},{54038,27,65},{54038,27,67},{54038,27,65}]},{2,[{54039,31,54},{54039,33,56},{54039,31,55},{54039,31,58},{54039,33,58},{54040,32,57},{54040,32,56},{54040,32,55},{54040,31,58},{54040,32,54},{54041,33,57},{54041,32,54},{54041,35,56},{54041,31,56},{54041,32,56}]},{3,[{54042,28,49},{54042,29,51},{54042,27,53},{54042,28,50},{54042,26,48},{54043,27,53},{54043,26,54},{54043,29,51},{54043,29,52},{54043,26,52},{54044,26,51},{54044,26,48},{54044,28,49},{54044,26,50},{54044,26,48}]},{4,[{54047,26,48}]},{5,[{54048,24,45},{54048,23,45},{54048,22,46},{54048,22,45},{54048,23,45},{54049,24,46},{54049,25,47},{54049,25,44},{54049,22,45},{54049,22,47},{54050,24,47},{54050,23,44},{54050,24,44},{54050,23,44},{54050,22,44}]},{6,[{54051,18,37},{54051,19,39},{54051,19,36},{54051,17,38},{54051,19,36},{54052,18,37},{54052,19,39},{54052,20,39},{54052,19,40},{54052,16,36},{54053,19,40},{54053,19,40},{54053,19,36},{54053,19,37},{54053,17,40}]},{7,[{54054,12,32},{54054,13,32},{54054,12,33},{54054,13,31},{54054,12,32},{54055,13,35},{54055,11,34},{54055,13,31},{54055,12,32},{54055,11,32},{54056,13,35},{54056,11,35},{54056,13,31},{54056,12,32},{54056,12,35}]},{8,[{54059,12,35}]},{9,[{54060,10,30},{54060,7,27},{54060,7,29},{54060,9,27},{54060,8,27},{54061,6,29},{54061,10,27},{54061,8,30},{54061,9,27},{54061,9,28},{54062,6,26},{54062,6,27},{54062,8,25},{54062,6,30},{54062,10,28}]},{10,[{54063,9,21},{54063,8,24},{54063,9,20},{54063,8,19},{54063,9,19},{54064,8,22},{54064,8,20},{54064,9,20},{54064,9,22},{54064,10,22},{54065,10,20},{54065,10,22},{54065,8,19},{54065,8,21},{54065,9,23}]},{11,[{54066,14,14},{54066,12,15},{54066,13,15},{54066,12,16},{54066,13,17},{54067,14,15},{54067,13,14},{54067,13,15},{54067,15,18},{54067,15,15},{54068,12,18},{54068,14,14},{54068,12,18},{54068,13,17},{54068,12,15}]},{12,[{54071,17,12}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,280},{lvdown,507}] ,scenes = [] ,out = [] };
get(60525) ->
	#dungeon{id = 60525 ,sid = 60525 ,name = ?T("魔神归墟境"), type = 12 ,lv = 290 ,mon = [{1,[{54081,13,56},{54081,15,58},{54081,18,56},{54082,12,53},{54082,13,49},{54082,16,48},{54083,15,53},{54083,18,51},{54083,9,51},{54083,9,55}]},{2,[{54084,18,50},{54084,18,54},{54084,20,57},{54085,20,53},{54085,23,54},{54085,23,59},{54086,26,57},{54086,26,62},{54086,24,58},{54086,22,55}]},{3,[{54089,30,62}]},{4,[{54090,31,57},{54090,34,59},{54090,35,55},{54091,34,53},{54091,31,51},{54091,33,48},{54092,31,47},{54092,29,49},{54092,30,44},{54092,28,46}]},{5,[{54093,27,45},{54093,30,43},{54093,33,41},{54094,33,37},{54094,30,39},{54094,25,42},{54095,25,38},{54095,31,34},{54095,28,38},{54095,28,34}]},{6,[{54096,27,44},{54096,30,42},{54096,33,39},{54097,28,40},{54097,31,36},{54097,22,34},{54098,25,30},{54098,29,28},{54098,25,36},{54098,28,33}]},{7,[{54101,28,35}]},{8,[{54102,24,31},{54102,24,27},{54102,28,29},{54103,20,27},{54103,22,29},{54103,21,23},{54104,17,24},{54104,17,20},{54104,15,22},{54104,19,23}]},{9,[{54105,13,22},{54105,16,18},{54105,9,21},{54106,12,17},{54106,15,13},{54106,5,20},{54107,8,16},{54107,11,13},{54107,13,10},{54107,7,25}]},{10,[{54110,9,16}]}] ,round_time = 0 ,time = 1800 ,count = 999 ,condition = [{lvup,290},{lvdown,500}] ,scenes = [] ,out = [] };
get(14001) ->
	#dungeon{id = 14001 ,sid = 14001 ,name = ?T("王城守卫"), type = 15 ,lv = 40 ,mon = [{64529,26,36},{64529,40,23}] ,round_time = 30 ,time = 3600 ,count = 999 ,condition = [{lvup,40},{lvdown,999}] ,scenes = [] ,out = [] };
get(56001) ->
	#dungeon{id = 56001 ,sid = 56001 ,name = ?T("V1副本"), type = 17 ,lv = 1 ,mon = [{1,[{42104,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(56002) ->
	#dungeon{id = 56002 ,sid = 56002 ,name = ?T("V3副本"), type = 17 ,lv = 1 ,mon = [{1,[{42101,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(56003) ->
	#dungeon{id = 56003 ,sid = 56003 ,name = ?T("V6副本"), type = 17 ,lv = 1 ,mon = [{1,[{42107,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(56004) ->
	#dungeon{id = 56004 ,sid = 56004 ,name = ?T("V9副本"), type = 17 ,lv = 1 ,mon = [{1,[{42110,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(56005) ->
	#dungeon{id = 56005 ,sid = 56005 ,name = ?T("V12副本"), type = 17 ,lv = 1 ,mon = [{1,[{42114,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(56006) ->
	#dungeon{id = 56006 ,sid = 56006 ,name = ?T("V15副本"), type = 17 ,lv = 1 ,mon = [{1,[{42117,17,23}]}] ,round_time = 0 ,time = 1800 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(40101) ->
	#dungeon{id = 40101 ,sid = 40101 ,name = ?T("妖魔入侵1"), type = 16 ,lv = 37 ,mon = [] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,37},{lvdown,999}] ,scenes = [] ,out = [] };
get(40102) ->
	#dungeon{id = 40102 ,sid = 40102 ,name = ?T("妖魔入侵2"), type = 16 ,lv = 37 ,mon = [] ,round_time = 0 ,time = 90 ,count = 1 ,condition = [{lvup,37},{lvdown,999}] ,scenes = [] ,out = [] };
get(41101) ->
	#dungeon{id = 41101 ,sid = 41101 ,name = ?T("一转副本"), type = 21 ,lv = 63 ,mon = [{1,[{52101,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,63},{lvdown,999}] ,scenes = [] ,out = [] };
get(41102) ->
	#dungeon{id = 41102 ,sid = 41102 ,name = ?T("二转副本"), type = 21 ,lv = 63 ,mon = [{1,[{52102,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,63},{lvdown,999}] ,scenes = [] ,out = [] };
get(41103) ->
	#dungeon{id = 41103 ,sid = 41103 ,name = ?T("三转副本"), type = 21 ,lv = 63 ,mon = [{1,[{52103,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,63},{lvdown,999}] ,scenes = [] ,out = [] };
get(41104) ->
	#dungeon{id = 41104 ,sid = 41104 ,name = ?T("四转副本"), type = 21 ,lv = 63 ,mon = [{1,[{52104,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,63},{lvdown,999}] ,scenes = [] ,out = [] };
get(41105) ->
	#dungeon{id = 41105 ,sid = 41105 ,name = ?T("五转副本"), type = 21 ,lv = 63 ,mon = [{1,[{52105,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,63},{lvdown,999}] ,scenes = [] ,out = [] };
get(42001) ->
	#dungeon{id = 42001 ,sid = 42001 ,name = ?T("铸剑峰"), type = 22 ,lv = 41 ,mon = [{1,[{52111,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42002) ->
	#dungeon{id = 42002 ,sid = 42002 ,name = ?T("火淬山"), type = 22 ,lv = 41 ,mon = [{1,[{52112,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42003) ->
	#dungeon{id = 42003 ,sid = 42003 ,name = ?T("炎融顶"), type = 22 ,lv = 41 ,mon = [{1,[{52113,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42004) ->
	#dungeon{id = 42004 ,sid = 42004 ,name = ?T("磨剑石"), type = 22 ,lv = 41 ,mon = [{1,[{52114,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42005) ->
	#dungeon{id = 42005 ,sid = 42005 ,name = ?T("神炼处"), type = 22 ,lv = 41 ,mon = [{1,[{52115,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42006) ->
	#dungeon{id = 42006 ,sid = 42006 ,name = ?T("麒麟座"), type = 22 ,lv = 41 ,mon = [{1,[{52116,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(42007) ->
	#dungeon{id = 42007 ,sid = 42007 ,name = ?T("天雷劫台"), type = 22 ,lv = 41 ,mon = [{1,[{52117,17,23}]}] ,round_time = 0 ,time = 180 ,count = 1 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(16001) ->
	#dungeon{id = 16001 ,sid = 16001 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56001,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16002) ->
	#dungeon{id = 16002 ,sid = 16002 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56002,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16003) ->
	#dungeon{id = 16003 ,sid = 16003 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56003,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16004) ->
	#dungeon{id = 16004 ,sid = 16004 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56004,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16005) ->
	#dungeon{id = 16005 ,sid = 16005 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56005,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16006) ->
	#dungeon{id = 16006 ,sid = 16006 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56006,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16007) ->
	#dungeon{id = 16007 ,sid = 16007 ,name = ?T("降神台1层"), type = 25 ,lv = 90 ,mon = [{1,[{56007,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16008) ->
	#dungeon{id = 16008 ,sid = 16008 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56008,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16009) ->
	#dungeon{id = 16009 ,sid = 16009 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56009,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16010) ->
	#dungeon{id = 16010 ,sid = 16010 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56010,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16011) ->
	#dungeon{id = 16011 ,sid = 16011 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56011,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16012) ->
	#dungeon{id = 16012 ,sid = 16012 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56012,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16013) ->
	#dungeon{id = 16013 ,sid = 16013 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56013,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16014) ->
	#dungeon{id = 16014 ,sid = 16014 ,name = ?T("极·降神台1层"), type = 25 ,lv = 90 ,mon = [{1,[{56014,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(16015) ->
	#dungeon{id = 16015 ,sid = 16015 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56015,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16016) ->
	#dungeon{id = 16016 ,sid = 16016 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56016,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16017) ->
	#dungeon{id = 16017 ,sid = 16017 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56017,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16018) ->
	#dungeon{id = 16018 ,sid = 16018 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56018,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16019) ->
	#dungeon{id = 16019 ,sid = 16019 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56019,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16020) ->
	#dungeon{id = 16020 ,sid = 16020 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56020,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16021) ->
	#dungeon{id = 16021 ,sid = 16021 ,name = ?T("降神台2层"), type = 25 ,lv = 90 ,mon = [{1,[{56021,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16022) ->
	#dungeon{id = 16022 ,sid = 16022 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56022,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16023) ->
	#dungeon{id = 16023 ,sid = 16023 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56023,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16024) ->
	#dungeon{id = 16024 ,sid = 16024 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56024,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16025) ->
	#dungeon{id = 16025 ,sid = 16025 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56025,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16026) ->
	#dungeon{id = 16026 ,sid = 16026 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56026,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16027) ->
	#dungeon{id = 16027 ,sid = 16027 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56027,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16028) ->
	#dungeon{id = 16028 ,sid = 16028 ,name = ?T("极·降神台2层"), type = 25 ,lv = 90 ,mon = [{1,[{56028,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(16029) ->
	#dungeon{id = 16029 ,sid = 16029 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56029,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16030) ->
	#dungeon{id = 16030 ,sid = 16030 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56030,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16031) ->
	#dungeon{id = 16031 ,sid = 16031 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56031,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16032) ->
	#dungeon{id = 16032 ,sid = 16032 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56032,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16033) ->
	#dungeon{id = 16033 ,sid = 16033 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56033,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16034) ->
	#dungeon{id = 16034 ,sid = 16034 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56034,15,29}]}] ,round_time = 0 ,time = 180 ,count = 6 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16035) ->
	#dungeon{id = 16035 ,sid = 16035 ,name = ?T("降神台3层"), type = 25 ,lv = 90 ,mon = [{1,[{56035,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16036) ->
	#dungeon{id = 16036 ,sid = 16036 ,name = ?T("1号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56036,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16037) ->
	#dungeon{id = 16037 ,sid = 16037 ,name = ?T("2号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56037,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16038) ->
	#dungeon{id = 16038 ,sid = 16038 ,name = ?T("3号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56038,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16039) ->
	#dungeon{id = 16039 ,sid = 16039 ,name = ?T("4号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56039,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16040) ->
	#dungeon{id = 16040 ,sid = 16040 ,name = ?T("5号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56040,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16041) ->
	#dungeon{id = 16041 ,sid = 16041 ,name = ?T("6号御魂副本"), type = 25 ,lv = 90 ,mon = [{1,[{56041,15,29}]}] ,round_time = 0 ,time = 180 ,count = 18 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(16042) ->
	#dungeon{id = 16042 ,sid = 16042 ,name = ?T("极·降神台3层"), type = 25 ,lv = 90 ,mon = [{1,[{56042,24,29}]}] ,round_time = 0 ,time = 180 ,count = 3 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(60801) ->
	#dungeon{id = 60801 ,sid = 60801 ,name = ?T("精英boss副本"), type = 26 ,lv = 60 ,mon = [{1,[{36201,16,21}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,60},{lvdown,999}] ,scenes = [] ,out = [] };
get(60802) ->
	#dungeon{id = 60802 ,sid = 60802 ,name = ?T("精英boss副本"), type = 26 ,lv = 70 ,mon = [{1,[{36202,11,36}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,70},{lvdown,999}] ,scenes = [] ,out = [] };
get(60803) ->
	#dungeon{id = 60803 ,sid = 60803 ,name = ?T("精英boss副本"), type = 26 ,lv = 80 ,mon = [{1,[{36203,17,23}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,80},{lvdown,999}] ,scenes = [] ,out = [] };
get(60804) ->
	#dungeon{id = 60804 ,sid = 60804 ,name = ?T("精英boss副本"), type = 26 ,lv = 90 ,mon = [{1,[{36204,36,47}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,90},{lvdown,999}] ,scenes = [] ,out = [] };
get(60805) ->
	#dungeon{id = 60805 ,sid = 60805 ,name = ?T("精英boss副本"), type = 26 ,lv = 100 ,mon = [{1,[{36205,17,27}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,100},{lvdown,999}] ,scenes = [] ,out = [] };
get(60806) ->
	#dungeon{id = 60806 ,sid = 60806 ,name = ?T("精英boss副本"), type = 26 ,lv = 110 ,mon = [{1,[{36206,20,41}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,110},{lvdown,999}] ,scenes = [] ,out = [] };
get(60807) ->
	#dungeon{id = 60807 ,sid = 60807 ,name = ?T("精英boss副本"), type = 26 ,lv = 120 ,mon = [{1,[{36207,22,26}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,120},{lvdown,999}] ,scenes = [] ,out = [] };
get(60808) ->
	#dungeon{id = 60808 ,sid = 60808 ,name = ?T("精英boss副本"), type = 26 ,lv = 130 ,mon = [{1,[{36208,16,21}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,130},{lvdown,999}] ,scenes = [] ,out = [] };
get(60809) ->
	#dungeon{id = 60809 ,sid = 60809 ,name = ?T("精英boss副本"), type = 26 ,lv = 140 ,mon = [{1,[{36209,11,36}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,140},{lvdown,999}] ,scenes = [] ,out = [] };
get(60810) ->
	#dungeon{id = 60810 ,sid = 60810 ,name = ?T("精英boss副本"), type = 26 ,lv = 150 ,mon = [{1,[{36210,17,23}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,150},{lvdown,999}] ,scenes = [] ,out = [] };
get(60811) ->
	#dungeon{id = 60811 ,sid = 60811 ,name = ?T("精英boss副本"), type = 26 ,lv = 160 ,mon = [{1,[{36211,36,47}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,160},{lvdown,999}] ,scenes = [] ,out = [] };
get(60812) ->
	#dungeon{id = 60812 ,sid = 60812 ,name = ?T("精英boss副本"), type = 26 ,lv = 170 ,mon = [{1,[{36212,17,27}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,170},{lvdown,999}] ,scenes = [] ,out = [] };
get(60813) ->
	#dungeon{id = 60813 ,sid = 60813 ,name = ?T("精英boss副本"), type = 26 ,lv = 180 ,mon = [{1,[{36213,20,41}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,180},{lvdown,999}] ,scenes = [] ,out = [] };
get(60814) ->
	#dungeon{id = 60814 ,sid = 60814 ,name = ?T("精英boss副本"), type = 26 ,lv = 190 ,mon = [{1,[{36214,22,26}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,190},{lvdown,999}] ,scenes = [] ,out = [] };
get(60815) ->
	#dungeon{id = 60815 ,sid = 60815 ,name = ?T("精英boss副本"), type = 26 ,lv = 200 ,mon = [{1,[{36215,17,23}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,200},{lvdown,999}] ,scenes = [] ,out = [] };
get(60816) ->
	#dungeon{id = 60816 ,sid = 60816 ,name = ?T("精英boss副本"), type = 26 ,lv = 210 ,mon = [{1,[{36216,36,47}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,210},{lvdown,999}] ,scenes = [] ,out = [] };
get(60817) ->
	#dungeon{id = 60817 ,sid = 60817 ,name = ?T("精英boss副本"), type = 26 ,lv = 220 ,mon = [{1,[{36217,17,27}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,220},{lvdown,999}] ,scenes = [] ,out = [] };
get(60818) ->
	#dungeon{id = 60818 ,sid = 60818 ,name = ?T("精英boss副本"), type = 26 ,lv = 230 ,mon = [{1,[{36218,20,41}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,230},{lvdown,999}] ,scenes = [] ,out = [] };
get(60819) ->
	#dungeon{id = 60819 ,sid = 60819 ,name = ?T("精英boss副本"), type = 26 ,lv = 240 ,mon = [{1,[{36219,22,26}]}] ,round_time = 0 ,time = 600 ,count = 999 ,condition = [{lvup,240},{lvdown,999}] ,scenes = [] ,out = [] };
get(60902) ->
	#dungeon{id = 60902 ,sid = 60902 ,name = ?T("仙盟对战"), type = 27 ,lv = 1 ,mon = [] ,round_time = 0 ,time = 90 ,count = 60 ,condition = [{lvup,1},{lvdown,999}] ,scenes = [] ,out = [] };
get(61001) ->
	#dungeon{id = 61001 ,sid = 61001 ,name = ?T("火元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61002) ->
	#dungeon{id = 61002 ,sid = 61002 ,name = ?T("火元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61003) ->
	#dungeon{id = 61003 ,sid = 61003 ,name = ?T("火元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(62001) ->
	#dungeon{id = 62001 ,sid = 62001 ,name = ?T("风元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(62002) ->
	#dungeon{id = 62002 ,sid = 62002 ,name = ?T("风元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(62003) ->
	#dungeon{id = 62003 ,sid = 62003 ,name = ?T("风元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(63001) ->
	#dungeon{id = 63001 ,sid = 63001 ,name = ?T("水元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(63002) ->
	#dungeon{id = 63002 ,sid = 63002 ,name = ?T("水元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(63003) ->
	#dungeon{id = 63003 ,sid = 63003 ,name = ?T("水元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(64001) ->
	#dungeon{id = 64001 ,sid = 64001 ,name = ?T("木元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(64002) ->
	#dungeon{id = 64002 ,sid = 64002 ,name = ?T("木元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(64003) ->
	#dungeon{id = 64003 ,sid = 64003 ,name = ?T("木元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(65001) ->
	#dungeon{id = 65001 ,sid = 65001 ,name = ?T("光元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(65002) ->
	#dungeon{id = 65002 ,sid = 65002 ,name = ?T("光元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(65003) ->
	#dungeon{id = 65003 ,sid = 65003 ,name = ?T("光元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61601) ->
	#dungeon{id = 61601 ,sid = 61601 ,name = ?T("暗元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61602) ->
	#dungeon{id = 61602 ,sid = 61602 ,name = ?T("暗元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61603) ->
	#dungeon{id = 61603 ,sid = 61603 ,name = ?T("暗元素副本"), type = 28 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 1800 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61101) ->
	#dungeon{id = 61101 ,sid = 61101 ,name = ?T("剑道副本"), type = 29 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 30 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61102) ->
	#dungeon{id = 61102 ,sid = 61102 ,name = ?T("剑道副本"), type = 29 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 30 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(61103) ->
	#dungeon{id = 61103 ,sid = 61103 ,name = ?T("剑道副本"), type = 29 ,lv = 120 ,mon = [] ,round_time = 0 ,time = 30 ,count = 0 ,condition = [{lvup,50},{lvdown,999}] ,scenes = [] ,out = [] };
get(_) -> [].