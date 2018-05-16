%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_cycle_conf
	%%% @Created : 2017-10-12 17:28:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_cycle_conf).
-export([min_lv/0]).
-export([get_task/1]).
-include("common.hrl").
-include("task.hrl").

    min_lv() ->48.
get_task(Lv)when Lv>=48 andalso Lv=<55->[300101,300102,300103,300104,300105,300106,300107,300108,300109,300110];
get_task(Lv)when Lv>=56 andalso Lv=<60->[300201,300202,300203,300204,300205,300206,300207,300208,300209,300210,300211,300212,300213,300214,300215,300216,300217,300218,300219,300220,300221,300222,300223,300224,300225,300226,300227,300228,300229,300230];
get_task(Lv)when Lv>=61 andalso Lv=<63->[300301,300302,300303,300304,300305,300306,300307,300308,300309,300310,300311,300312,300313,300314,300315,300316,300317,300318,300319,300320,300321,300322,300323,300324,300325,300326,300327,300328,300329,300330];
get_task(Lv)when Lv>=64 andalso Lv=<66->[300401,300402,300403,300404,300405,300406,300407,300408,300409,300410,300411,300412,300413,300414,300415,300416,300417,300418,300419,300420,300421,300422,300423,300424,300425,300426,300427,300428,300429,300430];
get_task(Lv)when Lv>=67 andalso Lv=<68->[300501,300502,300503,300504,300505,300506,300507,300508,300509,300510,300511,300512,300513,300514,300515,300516,300517,300518,300519,300520,300521,300522,300523,300524,300525,300526,300527,300528,300529,300530];
get_task(Lv)when Lv>=69 andalso Lv=<70->[300601,300602,300603,300604,300605,300606,300607,300608,300609,300610,300611,300612,300613,300614,300615,300616,300617,300618,300619,300620,300621,300622,300623,300624,300625,300626,300627,300628,300629,300630];
get_task(Lv)when Lv>=71 andalso Lv=<71->[300701,300702,300703,300704,300705,300706,300707,300708,300709,300710,300711,300712,300713,300714,300715,300716,300717,300718,300719,300720,300721,300722,300723,300724,300725,300726,300727,300728,300729,300730];
get_task(Lv)when Lv>=72 andalso Lv=<80->[300801,300802,300803,300804,300805,300806,300807,300808,300809,300810,300811,300812,300813,300814,300815,300816,300817,300818,300819,300820,300821,300822,300823,300824,300825,300826,300827,300828,300829,300830];
get_task(Lv)when Lv>=81 andalso Lv=<95->[300901,300902,300903,300904,300905,300906,300907,300908,300909,300910,300911,300912,300913,300914,300915,300916,300917,300918,300919,300920,300921,300922,300923,300924,300925,300926,300927,300928,300929,300930];
get_task(Lv)when Lv>=96 andalso Lv=<107->[301001,301002,301003,301004,301005,301006,301007,301008,301009,301010,301011,301012,301013,301014,301015,301016,301017,301018,301019,301020,301021,301022,301023,301024,301025,301026,301027,301028,301029,301030];
get_task(Lv)when Lv>=108 andalso Lv=<122->[301101,301102,301103,301104,301105,301106,301107,301108,301109,301110,301111,301112,301113,301114,301115,301116,301117,301118,301119,301120,301121,301122,301123,301124,301125,301126,301127,301128,301129,301130];
get_task(Lv)when Lv>=123 andalso Lv=<137->[301201,301202,301203,301204,301205,301206,301207,301208,301209,301210,301211,301212,301213,301214,301215,301216,301217,301218,301219,301220,301221,301222,301223,301224,301225,301226,301227,301228,301229,301230];
get_task(Lv)when Lv>=138 andalso Lv=<152->[301301,301302,301303,301304,301305,301306,301307,301308,301309,301310,301311,301312,301313,301314,301315,301316,301317,301318,301319,301320,301321,301322,301323,301324,301325,301326,301327,301328,301329,301330];
get_task(Lv)when Lv>=153 andalso Lv=<172->[301401,301402,301403,301404,301405,301406,301407,301408,301409,301410,301411,301412,301413,301414,301415,301416,301417,301418,301419,301420,301421,301422,301423,301424,301425,301426,301427,301428,301429,301430];
get_task(Lv)when Lv>=173 andalso Lv=<192->[301501,301502,301503,301504,301505,301506,301507,301508,301509,301510,301511,301512,301513,301514,301515,301516,301517,301518,301519,301520,301521,301522,301523,301524,301525,301526,301527,301528,301529,301530];
get_task(Lv)when Lv>=193 andalso Lv=<222->[301601,301602,301603,301604,301605,301606,301607,301608,301609,301610,301611,301612,301613,301614,301615,301616,301617,301618,301619,301620,301621,301622,301623,301624,301625,301626,301627,301628,301629,301630];
get_task(Lv)when Lv>=223 andalso Lv=<252->[301701,301702,301703,301704,301705,301706,301707,301708,301709,301710,301711,301712,301713,301714,301715,301716,301717,301718,301719,301720,301721,301722,301723,301724,301725,301726,301727,301728,301729,301730];
get_task(Lv)when Lv>=253 andalso Lv=<282->[301801,301802,301803,301804,301805,301806,301807,301808,301809,301810,301811,301812,301813,301814,301815,301816,301817,301818,301819,301820,301821,301822,301823,301824,301825,301826,301827,301828,301829,301830];
get_task(Lv)when Lv>=283 andalso Lv=<312->[301901,301902,301903,301904,301905,301906,301907,301908,301909,301910,301911,301912,301913,301914,301915,301916,301917,301918,301919,301920,301921,301922,301923,301924,301925,301926,301927,301928,301929,301930];
get_task(Lv)when Lv>=313 andalso Lv=<342->[302001,302002,302003,302004,302005,302006,302007,302008,302009,302010,302011,302012,302013,302014,302015,302016,302017,302018,302019,302020,302021,302022,302023,302024,302025,302026,302027,302028,302029,302030];
get_task(Lv)when Lv>=343 andalso Lv=<362->[302101,302102,302103,302104,302105,302106,302107,302108,302109,302110,302111,302112,302113,302114,302115,302116,302117,302118,302119,302120,302121,302122,302123,302124,302125,302126,302127,302128,302129,302130];
get_task(_) -> [].
