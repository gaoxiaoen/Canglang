-module(map_data).
-include("common.hrl").
-include("map.hrl").
-export(
	[
		startup/0,
		get/1,
		all/0
	]
).
startup() ->
	[1001,1024,1025,103,105,1400,1401,1405,1410,1415,1420,1425,200].
all() ->
	[1001,10011,10012,10021,10022,1003,10031,10032,1004,10041,10042,1005,10051,10052,1006,10061,10062,1007,10071,10072,1008,10081,10082,1009,10091,10092,101,1010,10101,10102,1011,10111,10112,1012,1013,1014,1015,1016,1017,1018,1019,1021,1022,1023,1024,1025,1026,1027,1028,1029,103,1030,1031,1032,1036,1037,1038,1039,1040,105,110,1100,11011,11012,11021,11022,11031,11032,11041,11042,11051,11052,11061,11062,11071,11072,11081,11082,11091,11092,111,112,113,120,12011,12012,12021,12022,12031,12032,12041,12042,12051,12052,12061,12062,12071,12072,12081,12082,12091,12092,12101,12102,12111,12112,12121,12122,12131,12132,130,1300,13011,13012,13021,13022,13031,13032,13041,13042,13051,13052,13061,13062,13071,13072,13081,13082,13091,13092,131,13101,13102,13111,13112,13121,13122,132,133,134,135,136,137,138,1400,1401,14011,14012,14021,14022,14031,14032,14041,14042,1405,14051,14052,14061,14062,14071,14072,14081,14082,14091,14092,1410,14101,14102,14111,14112,14121,14122,1415,1420,1425,150,15011,15012,15021,15022,15031,15032,15041,15042,15051,15052,15061,15062,15071,15072,15081,15082,15091,15092,15101,15102,15111,15112,15121,15122,15131,15132,16011,16012,16021,16022,16031,16032,16041,16042,16051,16052,16061,16062,16071,16072,16081,16082,16091,16092,16101,16102,16111,16112,16121,16122,16131,16132,17011,17012,17021,17022,17031,17032,17041,17042,17051,17052,17061,17062,17071,17072,17081,17082,17091,17092,17101,17102,17111,17112,17121,17122,17131,17132,180,18011,18012,18021,18022,18031,18032,18041,18042,18051,18052,18061,18062,18071,18072,18081,18082,18091,18092,18101,18102,18111,18112,18121,18122,18131,18132,190,191,200,201].
get(1001) ->
	#map_data{
		id = 1001,
		name = <<"1001">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3250,
		height = 640,
		type = 1
	};
get(10011) ->
	#map_data{
		id = 10011,
		name = <<"10011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10300,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10012) ->
	#map_data{
		id = 10012,
		name = <<"10012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11300,{1080,420}, <<>>, []}
		],
		width = 3030,
		height = 640,
		type = 0
	};
get(10021) ->
	#map_data{
		id = 10021,
		name = <<"10021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23001,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10022) ->
	#map_data{
		id = 10022,
		name = <<"10022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24001,{1740,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1003) ->
	#map_data{
		id = 1003,
		name = <<"1003">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10300,{1080,540}, <<>>, []},
			{10301,{2220,540}, <<>>, []},
			{10302,{3360,540}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10031) ->
	#map_data{
		id = 10031,
		name = <<"10031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10303,{1080,420}, <<>>, []},
			{10304,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10032) ->
	#map_data{
		id = 10032,
		name = <<"10032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11303,{1080,420}, <<>>, []},
			{11304,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1004) ->
	#map_data{
		id = 1004,
		name = <<"1004">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10306,{1080,540}, <<>>, []},
			{10307,{2220,540}, <<>>, []},
			{10308,{3360,540}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10041) ->
	#map_data{
		id = 10041,
		name = <<"10041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23004,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10042) ->
	#map_data{
		id = 10042,
		name = <<"10042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24004,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1005) ->
	#map_data{
		id = 1005,
		name = <<"1005">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10318,{1080,540}, <<>>, []},
			{10319,{2220,540}, <<>>, []},
			{10320,{3360,540}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(10051) ->
	#map_data{
		id = 10051,
		name = <<"10051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10306,{1080,420}, <<>>, []},
			{10308,{2220,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10052) ->
	#map_data{
		id = 10052,
		name = <<"10052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11308,{1080,420}, <<>>, []},
			{11306,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1006) ->
	#map_data{
		id = 1006,
		name = <<"1006">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10327,{1080,540}, <<>>, []},
			{10328,{2220,540}, <<>>, []},
			{10329,{3360,540}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(10061) ->
	#map_data{
		id = 10061,
		name = <<"10061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23007,{1080,420}, <<>>, []},
			{23011,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10062) ->
	#map_data{
		id = 10062,
		name = <<"10062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24007,{1080,420}, <<>>, []},
			{24011,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1007) ->
	#map_data{
		id = 1007,
		name = <<"1007">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10082,{660,330}, <<>>, []},
			{10083,{2040,360}, <<>>, []},
			{10081,{1020,330}, <<>>, []},
			{10085,{1260,360}, <<>>, []},
			{10084,{1680,360}, <<>>, []}
		],
		width = 2563,
		height = 640,
		type = 0
	};
get(10071) ->
	#map_data{
		id = 10071,
		name = <<"10071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10309,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10072) ->
	#map_data{
		id = 10072,
		name = <<"10072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11309,{1080,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(1008) ->
	#map_data{
		id = 1008,
		name = <<"1008">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10335,{2640,540}, <<>>, []},
			{10333,{900,540}, <<>>, []},
			{10334,{1740,540}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(10081) ->
	#map_data{
		id = 10081,
		name = <<"10081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23014,{1080,420}, <<>>, []},
			{23017,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10082) ->
	#map_data{
		id = 10082,
		name = <<"10082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24014,{1080,420}, <<>>, []},
			{24017,{1680,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1009) ->
	#map_data{
		id = 1009,
		name = <<"1009">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10342,{900,540}, <<>>, []},
			{10343,{1740,540}, <<>>, []},
			{10344,{2640,540}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(10091) ->
	#map_data{
		id = 10091,
		name = <<"10091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10312,{1080,420}, <<>>, []},
			{10313,{1680,420}, <<>>, []}
		],
		width = 3500,
		height = 640,
		type = 0
	};
get(10092) ->
	#map_data{
		id = 10092,
		name = <<"10092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11312,{1080,420}, <<>>, []},
			{11313,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(101) ->
	#map_data{
		id = 101,
		name = <<"101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 2155,
		height = 640,
		type = 8
	};
get(1010) ->
	#map_data{
		id = 1010,
		name = <<"1010">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10091,{780,390}, <<>>, []},
			{10095,{540,420}, <<>>, []},
			{10096,{2040,360}, <<>>, []},
			{10092,{1140,390}, <<>>, []},
			{10094,{2640,330}, <<>>, []},
			{10093,{1500,330}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(10101) ->
	#map_data{
		id = 10101,
		name = <<"10101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23021,{1140,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(10102) ->
	#map_data{
		id = 10102,
		name = <<"10102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24021,{1320,450}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1011) ->
	#map_data{
		id = 1011,
		name = <<"1011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10381,{1080,540}, <<>>, []},
			{10382,{2220,540}, <<>>, []},
			{10383,{3360,540}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(10111) ->
	#map_data{
		id = 10111,
		name = <<"10111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10317,{1140,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(10112) ->
	#map_data{
		id = 10112,
		name = <<"10112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11317,{1320,450}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1012) ->
	#map_data{
		id = 1012,
		name = <<"1012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10396,{900,540}, <<>>, []},
			{10397,{1740,540}, <<>>, []},
			{10398,{2640,540}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1013) ->
	#map_data{
		id = 1013,
		name = <<"1013">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10086,{1020,360}, <<>>, []},
			{10087,{1500,420}, <<>>, []},
			{10088,{1920,390}, <<>>, []},
			{10089,{2160,360}, <<>>, []},
			{10090,{660,390}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1014) ->
	#map_data{
		id = 1014,
		name = <<"1014">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1015) ->
	#map_data{
		id = 1015,
		name = <<"1015">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10360,{1080,540}, <<>>, []},
			{10361,{2220,540}, <<>>, []},
			{10362,{3360,540}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1016) ->
	#map_data{
		id = 1016,
		name = <<"1016">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10372,{1080,540}, <<>>, []},
			{10373,{2220,540}, <<>>, []},
			{10374,{3360,540}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1017) ->
	#map_data{
		id = 1017,
		name = <<"1017">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 2155,
		height = 640,
		type = 0
	};
get(1018) ->
	#map_data{
		id = 1018,
		name = <<"1018">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{0,{2220,510}, <<>>, []},
			{0,{3720,540}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(1019) ->
	#map_data{
		id = 1019,
		name = <<"1019">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(1021) ->
	#map_data{
		id = 1021,
		name = <<"1021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(1022) ->
	#map_data{
		id = 1022,
		name = <<"1022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3030,
		height = 640,
		type = 6
	};
get(1023) ->
	#map_data{
		id = 1023,
		name = <<"1023">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10101,{1020,510}, <<>>, []}
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(1024) ->
	#map_data{
		id = 1024,
		name = <<"1024">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 1
	};
get(1025) ->
	#map_data{
		id = 1025,
		name = <<"1025">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 1
	};
get(1026) ->
	#map_data{
		id = 1026,
		name = <<"1026">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(1027) ->
	#map_data{
		id = 1027,
		name = <<"1027">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(1028) ->
	#map_data{
		id = 1028,
		name = <<"1028">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 9
	};
get(1029) ->
	#map_data{
		id = 1029,
		name = <<"1029">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(103) ->
	#map_data{
		id = 103,
		name = <<"103">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10101,{900,480}, <<>>, []}
		],
		width = 1280,
		height = 640,
		type = 1
	};
get(1030) ->
	#map_data{
		id = 1030,
		name = <<"1030">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 4300,
		height = 640,
		type = 0
	};
get(1031) ->
	#map_data{
		id = 1031,
		name = <<"1031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 0
	};
get(1032) ->
	#map_data{
		id = 1032,
		name = <<"1032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 640,
		type = 3
	};
get(1036) ->
	#map_data{
		id = 1036,
		name = <<"1036">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 660,
		type = 14
	};
get(1037) ->
	#map_data{
		id = 1037,
		name = <<"1037">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 4077,
		height = 660,
		type = 18
	};
get(1038) ->
	#map_data{
		id = 1038,
		name = <<"1038">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 660,
		type = 13
	};
get(1039) ->
	#map_data{
		id = 1039,
		name = <<"1039">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3250,
		height = 640,
		type = 0
	};
get(1040) ->
	#map_data{
		id = 1040,
		name = <<"1040">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 660,
		type = 18
	};
get(105) ->
	#map_data{
		id = 105,
		name = <<"105">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10326,{960,510}, <<>>, []}
		],
		width = 1280,
		height = 640,
		type = 1
	};
get(110) ->
	#map_data{
		id = 110,
		name = <<"110">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3250,
		height = 640,
		type = 7
	};
get(1100) ->
	#map_data{
		id = 1100,
		name = <<"1100">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3249,
		height = 660,
		type = 0
	};
get(11011) ->
	#map_data{
		id = 11011,
		name = <<"11011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10318,{1080,420}, <<>>, []},
			{10320,{1800,420}, <<>>, []},
			{10319,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11012) ->
	#map_data{
		id = 11012,
		name = <<"11012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11318,{1080,420}, <<>>, []},
			{11320,{1800,420}, <<>>, []},
			{11319,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11021) ->
	#map_data{
		id = 11021,
		name = <<"11021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23024,{1080,420}, <<>>, []},
			{10320,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11022) ->
	#map_data{
		id = 11022,
		name = <<"11032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24024,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11031) ->
	#map_data{
		id = 11031,
		name = <<"11031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10323,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11032) ->
	#map_data{
		id = 11032,
		name = <<"11032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11323,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11041) ->
	#map_data{
		id = 11041,
		name = <<"11041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23027,{1080,420}, <<>>, []},
			{23031,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11042) ->
	#map_data{
		id = 11042,
		name = <<"11042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24027,{1080,420}, <<>>, []},
			{24031,{1680,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11051) ->
	#map_data{
		id = 11051,
		name = <<"11051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10324,{1080,420}, <<>>, []},
			{10325,{1800,420}, <<>>, []},
			{10326,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11052) ->
	#map_data{
		id = 11052,
		name = <<"11052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11324,{1080,420}, <<>>, []},
			{11325,{1800,420}, <<>>, []},
			{11326,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(11061) ->
	#map_data{
		id = 11061,
		name = <<"11061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23034,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11062) ->
	#map_data{
		id = 11062,
		name = <<"11062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24034,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11071) ->
	#map_data{
		id = 11071,
		name = <<"11071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10327,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11072) ->
	#map_data{
		id = 11072,
		name = <<"11072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11327,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11081) ->
	#map_data{
		id = 11081,
		name = <<"11081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23037,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11082) ->
	#map_data{
		id = 11082,
		name = <<"11082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24037,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 0
	};
get(11091) ->
	#map_data{
		id = 11091,
		name = <<"11091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10332,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 12
	};
get(11092) ->
	#map_data{
		id = 11092,
		name = <<"11092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11332,{1080,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 12
	};
get(111) ->
	#map_data{
		id = 111,
		name = <<"111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 4300,
		height = 640,
		type = 7
	};
get(112) ->
	#map_data{
		id = 112,
		name = <<"112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 2563,
		height = 640,
		type = 7
	};
get(113) ->
	#map_data{
		id = 113,
		name = <<"113">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3200,
		height = 640,
		type = 7
	};
get(120) ->
	#map_data{
		id = 120,
		name = <<"120">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3030,
		height = 640,
		type = 4
	};
get(12011) ->
	#map_data{
		id = 12011,
		name = <<"12011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10333,{900,420}, <<>>, []},
			{10334,{1620,420}, <<>>, []},
			{10335,{2340,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12012) ->
	#map_data{
		id = 12012,
		name = <<"12012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11333,{900,420}, <<>>, []},
			{11334,{1620,420}, <<>>, []},
			{11335,{2340,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12021) ->
	#map_data{
		id = 12021,
		name = <<"12021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23041,{1380,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12022) ->
	#map_data{
		id = 12022,
		name = <<"12022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24041,{1260,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12031) ->
	#map_data{
		id = 12031,
		name = <<"12031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10338,{1380,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12032) ->
	#map_data{
		id = 12032,
		name = <<"12032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10338,{1260,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12041) ->
	#map_data{
		id = 12041,
		name = <<"12041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23044,{900,420}, <<>>, []},
			{23047,{1620,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12042) ->
	#map_data{
		id = 12042,
		name = <<"12042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24051,{900,420}, <<>>, []},
			{24054,{1620,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12051) ->
	#map_data{
		id = 12051,
		name = <<"12051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23051,{900,420}, <<>>, []},
			{23054,{1620,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12052) ->
	#map_data{
		id = 12052,
		name = <<"12052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24051,{900,420}, <<>>, []},
			{24054,{1620,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12061) ->
	#map_data{
		id = 12061,
		name = <<"12061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10339,{900,420}, <<>>, []},
			{10340,{1620,420}, <<>>, []},
			{10341,{2340,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12062) ->
	#map_data{
		id = 12062,
		name = <<"12062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11339,{900,420}, <<>>, []},
			{11340,{1620,420}, <<>>, []},
			{11341,{2340,420}, <<>>, []}
		],
		width = 2864,
		height = 640,
		type = 0
	};
get(12071) ->
	#map_data{
		id = 12071,
		name = <<"12071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23057,{900,420}, <<>>, []},
			{23061,{1620,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12072) ->
	#map_data{
		id = 12072,
		name = <<"12072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24057,{900,420}, <<>>, []},
			{24061,{1620,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12081) ->
	#map_data{
		id = 12081,
		name = <<"12081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10342,{900,420}, <<>>, []},
			{10343,{1620,420}, <<>>, []},
			{10344,{2340,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12082) ->
	#map_data{
		id = 12082,
		name = <<"12082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11342,{900,420}, <<>>, []},
			{11343,{1620,420}, <<>>, []},
			{11344,{2340,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12091) ->
	#map_data{
		id = 12091,
		name = <<"12091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23064,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12092) ->
	#map_data{
		id = 12092,
		name = <<"12092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24064,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12101) ->
	#map_data{
		id = 12101,
		name = <<"12101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23067,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12102) ->
	#map_data{
		id = 12102,
		name = <<"12102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24067,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12111) ->
	#map_data{
		id = 12111,
		name = <<"12111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10347,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12112) ->
	#map_data{
		id = 12112,
		name = <<"12112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11347,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12121) ->
	#map_data{
		id = 12121,
		name = <<"12121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23071,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12122) ->
	#map_data{
		id = 12122,
		name = <<"12122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24071,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 0
	};
get(12131) ->
	#map_data{
		id = 12131,
		name = <<"12131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10350,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 12
	};
get(12132) ->
	#map_data{
		id = 12132,
		name = <<"12132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11350,{1080,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 12
	};
get(130) ->
	#map_data{
		id = 130,
		name = <<"130">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16000,{1080,420}, <<>>, []},
			{16003,{1800,420}, <<>>, []},
			{16122,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 5
	};
get(1300) ->
	#map_data{
		id = 1300,
		name = <<"1300">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10302,{1080,420}, <<>>, []},
			{10305,{1680,420}, <<>>, []}
		],
		width = 3250,
		height = 640,
		type = 0
	};
get(13011) ->
	#map_data{
		id = 13011,
		name = <<"13011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10351,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13012) ->
	#map_data{
		id = 13012,
		name = <<"13012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11351,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13021) ->
	#map_data{
		id = 13021,
		name = <<"13021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23074,{1080,420}, <<>>, []},
			{23077,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13022) ->
	#map_data{
		id = 13022,
		name = <<"13022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24074,{1080,420}, <<>>, []},
			{24077,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13031) ->
	#map_data{
		id = 13031,
		name = <<"13031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10354,{1080,420}, <<>>, []},
			{10355,{1800,420}, <<>>, []},
			{10356,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13032) ->
	#map_data{
		id = 13032,
		name = <<"13032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11354,{1080,420}, <<>>, []},
			{11355,{1800,420}, <<>>, []},
			{11356,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13041) ->
	#map_data{
		id = 13041,
		name = <<"13041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23081,{1080,420}, <<>>, []},
			{23084,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13042) ->
	#map_data{
		id = 13042,
		name = <<"13042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24081,{1080,420}, <<>>, []},
			{24084,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13051) ->
	#map_data{
		id = 13051,
		name = <<"13051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23087,{1080,420}, <<>>, []},
			{23091,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13052) ->
	#map_data{
		id = 13052,
		name = <<"13052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24087,{1080,420}, <<>>, []},
			{24091,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13061) ->
	#map_data{
		id = 13061,
		name = <<"13061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10359,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13062) ->
	#map_data{
		id = 13062,
		name = <<"13062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11359,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13071) ->
	#map_data{
		id = 13071,
		name = <<"13071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23094,{1080,420}, <<>>, []},
			{23097,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13072) ->
	#map_data{
		id = 13072,
		name = <<"13072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24094,{1080,420}, <<>>, []},
			{24097,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13081) ->
	#map_data{
		id = 13081,
		name = <<"13081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23101,{1080,420}, <<>>, []},
			{23104,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13082) ->
	#map_data{
		id = 13082,
		name = <<"13082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24101,{1080,420}, <<>>, []},
			{24104,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13091) ->
	#map_data{
		id = 13091,
		name = <<"13091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10360,{1080,420}, <<>>, []},
			{10361,{1800,420}, <<>>, []},
			{10362,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13092) ->
	#map_data{
		id = 13092,
		name = <<"13092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11360,{1080,420}, <<>>, []},
			{11361,{1800,420}, <<>>, []},
			{11362,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(131) ->
	#map_data{
		id = 131,
		name = <<"131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16018,{1080,420}, <<>>, []},
			{16021,{1800,420}, <<>>, []},
			{16027,{2520,420}, <<>>, []}
		],
		width = 3320,
		height = 640,
		type = 5
	};
get(13101) ->
	#map_data{
		id = 13101,
		name = <<"13101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23107,{1080,420}, <<>>, []},
			{23111,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13102) ->
	#map_data{
		id = 13102,
		name = <<"13102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24107,{1080,420}, <<>>, []},
			{24111,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13111) ->
	#map_data{
		id = 13111,
		name = <<"13111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23114,{1080,420}, <<>>, []},
			{23117,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13112) ->
	#map_data{
		id = 13112,
		name = <<"13112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24114,{1080,420}, <<>>, []},
			{24117,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13121) ->
	#map_data{
		id = 13121,
		name = <<"13121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10363,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(13122) ->
	#map_data{
		id = 13122,
		name = <<"13122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11363,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(132) ->
	#map_data{
		id = 132,
		name = <<"132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16036,{900,420}, <<>>, []},
			{16039,{1620,420}, <<>>, []},
			{16045,{2340,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 5
	};
get(133) ->
	#map_data{
		id = 133,
		name = <<"133">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16036,{900,420}, <<>>, []},
			{16039,{1620,420}, <<>>, []},
			{16045,{2340,420}, <<>>, []}
		],
		width = 2890,
		height = 640,
		type = 5
	};
get(134) ->
	#map_data{
		id = 134,
		name = <<"134">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16054,{1080,420}, <<>>, []},
			{16057,{1800,420}, <<>>, []},
			{16125,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 5
	};
get(135) ->
	#map_data{
		id = 135,
		name = <<"135">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16072,{1080,420}, <<>>, []},
			{16075,{1800,420}, <<>>, []},
			{16081,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 5
	};
get(136) ->
	#map_data{
		id = 136,
		name = <<"136">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16090,{900,420}, <<>>, []},
			{16093,{1620,420}, <<>>, []},
			{16099,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 5
	};
get(137) ->
	#map_data{
		id = 137,
		name = <<"137">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16128,{900,420}, <<>>, []},
			{16131,{1620,420}, <<>>, []},
			{16146,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 5
	};
get(138) ->
	#map_data{
		id = 138,
		name = <<"138">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{16147,{1080,420}, <<>>, []},
			{16150,{1680,420}, <<>>, []},
			{16153,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 5
	};
get(1400) ->
	#map_data{
		id = 1400,
		name = <<"沐晨村">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 300,480, <<>>, {100, 420, 570}},
			{200,200, <<>>, 3000,450, <<>>, {100, 420, 570}}
		],
		npc = [
			{10070,{1020,450}, <<>>, []},
			{10072,{2520,420}, <<>>, []},
			{10071,{1800,420}, <<>>, []}
		],
		width = 3250,
		height = 640,
		type = 1
	};
get(1401) ->
	#map_data{
		id = 1401,
		name = <<"1401">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{200,200, <<>>, 2880,450, <<>>, {100, 420, 570}}
		],
		npc = [
			{10106,{2100,450}, <<>>, []}
		],
		width = 3250,
		height = 640,
		type = 1
	};
get(14011) ->
	#map_data{
		id = 14011,
		name = <<"14011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10366,{1080,420}, <<>>, []},
			{10367,{1800,420}, <<>>, []},
			{10368,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14012) ->
	#map_data{
		id = 14012,
		name = <<"14012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11366,{1080,420}, <<>>, []},
			{11367,{1800,420}, <<>>, []},
			{11368,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14021) ->
	#map_data{
		id = 14021,
		name = <<"14021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23121,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14022) ->
	#map_data{
		id = 14022,
		name = <<"14022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24121,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14031) ->
	#map_data{
		id = 14031,
		name = <<"14031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10371,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14032) ->
	#map_data{
		id = 14032,
		name = <<"14032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11371,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14041) ->
	#map_data{
		id = 14041,
		name = <<"14041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23124,{1080,420}, <<>>, []},
			{23127,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14042) ->
	#map_data{
		id = 14042,
		name = <<"14042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24124,{1080,420}, <<>>, []},
			{24124,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1405) ->
	#map_data{
		id = 1405,
		name = <<"中庭之国">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 180,480, <<>>, {100, 420, 570}},
			{200,200, <<>>, 3840,450, <<>>, {100, 420, 570}}
		],
		npc = [
			{10073,{480,420}, <<>>, []},
			{10074,{1260,480}, <<>>, []},
			{10075,{1920,390}, <<>>, []},
			{10077,{2520,390}, <<>>, []},
			{10076,{1500,390}, <<>>, []},
			{10078,{1020,450}, <<>>, []},
			{10079,{3000,420}, <<>>, []},
			{10080,{3480,420}, <<>>, []},
			{10104,{300,330}, <<>>, []}
		],
		width = 4300,
		height = 640,
		type = 1
	};
get(14051) ->
	#map_data{
		id = 14051,
		name = <<"14051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23131,{1080,420}, <<>>, []},
			{23134,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14052) ->
	#map_data{
		id = 14052,
		name = <<"14052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11372,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14061) ->
	#map_data{
		id = 14061,
		name = <<"14061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10372,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14062) ->
	#map_data{
		id = 14062,
		name = <<"14062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11372,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14071) ->
	#map_data{
		id = 14071,
		name = <<"14071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23137,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14072) ->
	#map_data{
		id = 14072,
		name = <<"14072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24137,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14081) ->
	#map_data{
		id = 14081,
		name = <<"14081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23141,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14082) ->
	#map_data{
		id = 14082,
		name = <<"14082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24141,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14091) ->
	#map_data{
		id = 14091,
		name = <<"14091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10377,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14092) ->
	#map_data{
		id = 14092,
		name = <<"14092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11377,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(1410) ->
	#map_data{
		id = 1410,
		name = <<"遗忘小镇">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 420,390, <<>>, {100, 420, 570}},
			{200,200, <<>>, 2220,420, <<>>, {100, 420, 570}}
		],
		npc = [
			{10081,{1080,330}, <<>>, []},
			{10082,{720,330}, <<>>, []},
			{10083,{1560,360}, <<>>, []},
			{10084,{1920,360}, <<>>, []},
			{10085,{1320,360}, <<>>, []}
		],
		width = 2563,
		height = 640,
		type = 1
	};
get(14101) ->
	#map_data{
		id = 14101,
		name = <<"14101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23144,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14102) ->
	#map_data{
		id = 14102,
		name = <<"14102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24144,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14111) ->
	#map_data{
		id = 14111,
		name = <<"14111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23147,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14112) ->
	#map_data{
		id = 14112,
		name = <<"14112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24147,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(14121) ->
	#map_data{
		id = 14121,
		name = <<"14121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10380,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 12
	};
get(14122) ->
	#map_data{
		id = 14122,
		name = <<"14122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11380,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 12
	};
get(1415) ->
	#map_data{
		id = 1415,
		name = <<"侏儒国度">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 300,450, <<>>, {100, 420, 570}},
			{200,200, <<>>, 3000,420, <<>>, {100, 420, 570}}
		],
		npc = [
			{10086,{1020,360}, <<>>, []},
			{10087,{1380,390}, <<>>, []},
			{10088,{2160,360}, <<>>, []},
			{10089,{2400,360}, <<>>, []},
			{10090,{600,390}, <<>>, []},
			{10091,{1740,390}, <<>>, []},
			{10103,{2880,360}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 1
	};
get(1420) ->
	#map_data{
		id = 1420,
		name = <<"雪山边城">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 180,450, <<>>, {100, 420, 570}},
			{200,200, <<>>, 2820,420, <<>>, {100, 420, 570}}
		],
		npc = [
			{10092,{1140,390}, <<>>, []},
			{10093,{1500,330}, <<>>, []},
			{10094,{2460,420}, <<>>, []},
			{10095,{540,420}, <<>>, []},
			{10096,{2040,360}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 1
	};
get(1425) ->
	#map_data{
		id = 1425,
		name = <<"1425">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 60,510, <<>>, {100, 420, 570}},
			{200,200, <<>>, 1860,510, <<>>, {100, 420, 570}}
		],
		npc = [
			{10105,{1680,390}, <<>>, []},
			{10099,{1020,420}, <<>>, []},
			{10098,{660,390}, <<>>, []},
			{10097,{1440,450}, <<>>, []},
			{10100,{240,450}, <<>>, []}
		],
		width = 2155,
		height = 640,
		type = 1
	};
get(150) ->
	#map_data{
		id = 150,
		name = <<"150">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3228,
		height = 640,
		type = 5
	};
get(15011) ->
	#map_data{
		id = 15011,
		name = <<"15011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10381,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15012) ->
	#map_data{
		id = 15012,
		name = <<"15012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11381,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15021) ->
	#map_data{
		id = 15021,
		name = <<"15021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23151,{1080,420}, <<>>, []},
			{23154,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15022) ->
	#map_data{
		id = 15022,
		name = <<"15022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24151,{1080,420}, <<>>, []},
			{24154,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15031) ->
	#map_data{
		id = 15031,
		name = <<"15031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23157,{1080,420}, <<>>, []},
			{23161,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15032) ->
	#map_data{
		id = 15032,
		name = <<"15032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24157,{1080,420}, <<>>, []},
			{24161,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15041) ->
	#map_data{
		id = 15041,
		name = <<"15041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10384,{1080,420}, <<>>, []},
			{10385,{1800,420}, <<>>, []},
			{10386,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15042) ->
	#map_data{
		id = 15042,
		name = <<"15042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11384,{1080,420}, <<>>, []},
			{11385,{1800,420}, <<>>, []},
			{11386,{2520,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15051) ->
	#map_data{
		id = 15051,
		name = <<"15051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23164,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15052) ->
	#map_data{
		id = 15052,
		name = <<"15052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24164,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15061) ->
	#map_data{
		id = 15061,
		name = <<"15061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23167,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15062) ->
	#map_data{
		id = 15062,
		name = <<"15062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24167,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15071) ->
	#map_data{
		id = 15071,
		name = <<"15071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10387,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15072) ->
	#map_data{
		id = 15072,
		name = <<"15072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11387,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15081) ->
	#map_data{
		id = 15081,
		name = <<"15081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23171,{1080,420}, <<>>, []},
			{23174,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15082) ->
	#map_data{
		id = 15082,
		name = <<"15082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24171,{1080,420}, <<>>, []},
			{24174,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15091) ->
	#map_data{
		id = 15091,
		name = <<"15091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23177,{1080,420}, <<>>, []},
			{23181,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15092) ->
	#map_data{
		id = 15092,
		name = <<"15092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24177,{1080,420}, <<>>, []},
			{24181,{1800,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15101) ->
	#map_data{
		id = 15101,
		name = <<"15101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10392,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15102) ->
	#map_data{
		id = 15102,
		name = <<"15102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11392,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15111) ->
	#map_data{
		id = 15111,
		name = <<"15111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23184,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15112) ->
	#map_data{
		id = 15112,
		name = <<"15112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24184,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15121) ->
	#map_data{
		id = 15121,
		name = <<"15121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23187,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15122) ->
	#map_data{
		id = 15122,
		name = <<"15122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11395,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15131) ->
	#map_data{
		id = 15131,
		name = <<"15131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10395,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(15132) ->
	#map_data{
		id = 15132,
		name = <<"15132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11395,{1080,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16011) ->
	#map_data{
		id = 16011,
		name = <<"16011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10396,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16012) ->
	#map_data{
		id = 16012,
		name = <<"16012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11396,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16021) ->
	#map_data{
		id = 16021,
		name = <<"16021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23191,{900,420}, <<>>, []},
			{23194,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16022) ->
	#map_data{
		id = 16022,
		name = <<"16022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24191,{900,420}, <<>>, []},
			{24194,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16031) ->
	#map_data{
		id = 16031,
		name = <<"16031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23197,{900,420}, <<>>, []},
			{23201,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16032) ->
	#map_data{
		id = 16032,
		name = <<"16032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24197,{900,420}, <<>>, []},
			{24201,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16041) ->
	#map_data{
		id = 16041,
		name = <<"16041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10399,{900,420}, <<>>, []},
			{10400,{1620,420}, <<>>, []},
			{10401,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16042) ->
	#map_data{
		id = 16042,
		name = <<"16042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11399,{900,420}, <<>>, []},
			{11400,{1620,420}, <<>>, []},
			{11401,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16051) ->
	#map_data{
		id = 16051,
		name = <<"16051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23204,{900,420}, <<>>, []},
			{23207,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16052) ->
	#map_data{
		id = 16052,
		name = <<"16052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24204,{900,420}, <<>>, []},
			{24207,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16061) ->
	#map_data{
		id = 16061,
		name = <<"16061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23211,{900,420}, <<>>, []},
			{23214,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16062) ->
	#map_data{
		id = 16062,
		name = <<"16062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24211,{900,420}, <<>>, []},
			{24214,{1620,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16071) ->
	#map_data{
		id = 16071,
		name = <<"16071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10402,{900,420}, <<>>, []},
			{10403,{1620,420}, <<>>, []},
			{10404,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16072) ->
	#map_data{
		id = 16072,
		name = <<"16072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11402,{900,420}, <<>>, []},
			{11403,{1620,420}, <<>>, []},
			{11404,{2340,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16081) ->
	#map_data{
		id = 16081,
		name = <<"16081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23217,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16082) ->
	#map_data{
		id = 16082,
		name = <<"16082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24217,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16091) ->
	#map_data{
		id = 16091,
		name = <<"16091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23221,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16092) ->
	#map_data{
		id = 16092,
		name = <<"16092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24221,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16101) ->
	#map_data{
		id = 16101,
		name = <<"16101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10407,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16102) ->
	#map_data{
		id = 16102,
		name = <<"16102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11407,{900,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16111) ->
	#map_data{
		id = 16111,
		name = <<"16111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23224,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16112) ->
	#map_data{
		id = 16112,
		name = <<"16112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24224,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16121) ->
	#map_data{
		id = 16121,
		name = <<"16121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23227,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16122) ->
	#map_data{
		id = 16122,
		name = <<"16122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24227,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 0
	};
get(16131) ->
	#map_data{
		id = 16131,
		name = <<"16131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10410,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 12
	};
get(16132) ->
	#map_data{
		id = 16132,
		name = <<"16132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11410,{1260,420}, <<>>, []}
		],
		width = 3200,
		height = 640,
		type = 12
	};
get(17011) ->
	#map_data{
		id = 17011,
		name = <<"17011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10645,{1080,420}, <<>>, []},
			{10646,{1680,420}, <<>>, []},
			{10647,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17012) ->
	#map_data{
		id = 17012,
		name = <<"17012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11645,{1080,420}, <<>>, []},
			{11646,{1680,420}, <<>>, []},
			{11647,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17021) ->
	#map_data{
		id = 17021,
		name = <<"17021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23231,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17022) ->
	#map_data{
		id = 17022,
		name = <<"17022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24231,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17031) ->
	#map_data{
		id = 17031,
		name = <<"17031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23234,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17032) ->
	#map_data{
		id = 17032,
		name = <<"17032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24234,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17041) ->
	#map_data{
		id = 17041,
		name = <<"17041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10648,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17042) ->
	#map_data{
		id = 17042,
		name = <<"17042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11648,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17051) ->
	#map_data{
		id = 17051,
		name = <<"17051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23237,{1080,420}, <<>>, []},
			{23241,{1680,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17052) ->
	#map_data{
		id = 17052,
		name = <<"17052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24237,{1080,420}, <<>>, []},
			{24241,{1680,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17061) ->
	#map_data{
		id = 17061,
		name = <<"17061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23244,{1080,420}, <<>>, []},
			{10652,{1680,420}, <<>>, []},
			{10653,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17062) ->
	#map_data{
		id = 17062,
		name = <<"17062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11651,{1080,420}, <<>>, []},
			{11652,{1680,420}, <<>>, []},
			{11653,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17071) ->
	#map_data{
		id = 17071,
		name = <<"17071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10651,{1080,420}, <<>>, []},
			{10652,{1680,420}, <<>>, []},
			{10653,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17072) ->
	#map_data{
		id = 17072,
		name = <<"17072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11651,{1080,420}, <<>>, []},
			{11652,{1680,420}, <<>>, []},
			{11653,{2220,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17081) ->
	#map_data{
		id = 17081,
		name = <<"17081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23251,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17082) ->
	#map_data{
		id = 17082,
		name = <<"17082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24251,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17091) ->
	#map_data{
		id = 17091,
		name = <<"17091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23254,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17092) ->
	#map_data{
		id = 17092,
		name = <<"17092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24254,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17101) ->
	#map_data{
		id = 17101,
		name = <<"17101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10654,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17102) ->
	#map_data{
		id = 17102,
		name = <<"17102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11654,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17111) ->
	#map_data{
		id = 17111,
		name = <<"17111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23257,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17112) ->
	#map_data{
		id = 17112,
		name = <<"17112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24257,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17121) ->
	#map_data{
		id = 17121,
		name = <<"17121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23261,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17122) ->
	#map_data{
		id = 17122,
		name = <<"17122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24261,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17131) ->
	#map_data{
		id = 17131,
		name = <<"17131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10659,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(17132) ->
	#map_data{
		id = 17132,
		name = <<"17132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11659,{1080,420}, <<>>, []}
		],
		width = 3180,
		height = 640,
		type = 0
	};
get(180) ->
	#map_data{
		id = 180,
		name = <<"180">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 660,
		type = 15
	};
get(18011) ->
	#map_data{
		id = 18011,
		name = <<"18011">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10660,{1080,420}, <<>>, []},
			{10661,{1680,420}, <<>>, []},
			{10662,{2220,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18012) ->
	#map_data{
		id = 18012,
		name = <<"18012">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11660,{1080,420}, <<>>, []},
			{11661,{1680,420}, <<>>, []},
			{11662,{2220,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18021) ->
	#map_data{
		id = 18021,
		name = <<"18021">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23264,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18022) ->
	#map_data{
		id = 18022,
		name = <<"18022">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24264,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18031) ->
	#map_data{
		id = 18031,
		name = <<"18031">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23267,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18032) ->
	#map_data{
		id = 18032,
		name = <<"18032">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24267,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18041) ->
	#map_data{
		id = 18041,
		name = <<"18041">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10663,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18042) ->
	#map_data{
		id = 18042,
		name = <<"18042">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11663,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18051) ->
	#map_data{
		id = 18051,
		name = <<"18051">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23271,{1080,420}, <<>>, []},
			{23274,{1680,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18052) ->
	#map_data{
		id = 18052,
		name = <<"18052">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24271,{1080,420}, <<>>, []},
			{24274,{1680,420}, <<>>, []},
			{11668,{2220,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18061) ->
	#map_data{
		id = 18061,
		name = <<"18061">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23277,{1080,420}, <<>>, []},
			{23281,{1680,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18062) ->
	#map_data{
		id = 18062,
		name = <<"18062">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24277,{1080,420}, <<>>, []},
			{24281,{1680,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18071) ->
	#map_data{
		id = 18071,
		name = <<"18071">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10668,{1080,420}, <<>>, []},
			{10669,{1680,420}, <<>>, []},
			{10670,{2220,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18072) ->
	#map_data{
		id = 18072,
		name = <<"18072">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11668,{1080,420}, <<>>, []},
			{11669,{1680,420}, <<>>, []},
			{11670,{2220,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18081) ->
	#map_data{
		id = 18081,
		name = <<"18081">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23284,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18082) ->
	#map_data{
		id = 18082,
		name = <<"18082">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24284,{1440,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 12
	};
get(18091) ->
	#map_data{
		id = 18091,
		name = <<"18091">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23287,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18092) ->
	#map_data{
		id = 18092,
		name = <<"18092">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24287,{1440,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 12
	};
get(18101) ->
	#map_data{
		id = 18101,
		name = <<"18101">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10671,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18102) ->
	#map_data{
		id = 18102,
		name = <<"18102">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11671,{1080,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18111) ->
	#map_data{
		id = 18111,
		name = <<"18111">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{23291,{1440,420}, <<>>, []},
			{23294,{1680,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18112) ->
	#map_data{
		id = 18112,
		name = <<"18112">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24291,{1440,420}, <<>>, []},
			{24294,{1680,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18121) ->
	#map_data{
		id = 18121,
		name = <<"18121">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10674,{1440,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18122) ->
	#map_data{
		id = 18122,
		name = <<"18122">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{24297,{1440,420}, <<>>, []},
			{24301,{1920,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18131) ->
	#map_data{
		id = 18131,
		name = <<"18131">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{10674,{1440,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 0
	};
get(18132) ->
	#map_data{
		id = 18132,
		name = <<"18132">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
			{11674,{1440,420}, <<>>, []}
		],
		width = 3228,
		height = 640,
		type = 12
	};
get(190) ->
	#map_data{
		id = 190,
		name = <<"190">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 1280,
		height = 660,
		type = 16
	};
get(191) ->
	#map_data{
		id = 191,
		name = <<"191">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3228,
		height = 640,
		type = 17
	};
get(200) ->
	#map_data{
		id = 200,
		name = <<"200">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
			{100,100, <<>>, 1020,510, <<>>, {100, 420, 570}}
		],
		npc = [
			{10102,{180,540}, <<>>, []},
			{10101,{840,570}, <<>>, []}
		],
		width = 1280,
		height = 640,
		type = 1
	};
get(201) ->
	#map_data{
		id = 201,
		name = <<"201">>,
		revive = [],
		condition = [],
		event = [],
		elem = [
		],
		npc = [
		],
		width = 3228,
		height = 640,
		type = 10
	};
get(_Id) -> false.