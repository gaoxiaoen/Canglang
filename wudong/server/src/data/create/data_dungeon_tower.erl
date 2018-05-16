%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_dungeon_tower
	%%% @Created : 2017-05-04 11:44:07
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_dungeon_tower).
-export([dun_list/0]).
-export([max_layer/0]).
-export([get/1]).
-export([layer_to_scene/1, get_combat_by_round/1]).
-include("common.hrl").
-include("dungeon.hrl").

    dun_list() ->
    [20001,20002,20003,20004,20005,20006,20007,20008,20009,20010,20011,20012,20013,20014,20015,20016,20017,20018,20019,20020,20021,20022,20023,20024,20025,20026,20027,20028,20029,20030,20031,20032,20033,20034,20035,20036,20037,20038,20039,20040,20041,20042,20043,20044,20045,20046,20047,20048,20049,20050,20051,20052,20053,20054,20055,20056,20057,20058,20059,20060,20061,20062,20063,20064,20065,20066,20067,20068,20069,20070,20071,20072,20073,20074,20075,20076,20077,20078,20079,20080,20081,20082,20083,20084,20085,20086,20087,20088,20089,20090,20091,20092,20093,20094,20095,20096,20097,20098,20099,20100,20101,20102,20103,20104,20105,20106,20107,20108,20109,20110,20111,20112,20113,20114,20115,20116,20117,20118,20119,20120,20121,20122,20123,20124,20125,20126,20127,20128,20129,20130,20131,20132,20133,20134,20135,20136,20137,20138,20139,20140,20141,20142,20143,20144,20145,20146,20147,20148,20149,20150,20151,20152,20153,20154,20155,20156,20157,20158,20159,20160].
max_layer() ->160.
layer_to_scene(1)->20001;
layer_to_scene(2)->20002;
layer_to_scene(3)->20003;
layer_to_scene(4)->20004;
layer_to_scene(5)->20005;
layer_to_scene(6)->20006;
layer_to_scene(7)->20007;
layer_to_scene(8)->20008;
layer_to_scene(9)->20009;
layer_to_scene(10)->20010;
layer_to_scene(11)->20011;
layer_to_scene(12)->20012;
layer_to_scene(13)->20013;
layer_to_scene(14)->20014;
layer_to_scene(15)->20015;
layer_to_scene(16)->20016;
layer_to_scene(17)->20017;
layer_to_scene(18)->20018;
layer_to_scene(19)->20019;
layer_to_scene(20)->20020;
layer_to_scene(21)->20021;
layer_to_scene(22)->20022;
layer_to_scene(23)->20023;
layer_to_scene(24)->20024;
layer_to_scene(25)->20025;
layer_to_scene(26)->20026;
layer_to_scene(27)->20027;
layer_to_scene(28)->20028;
layer_to_scene(29)->20029;
layer_to_scene(30)->20030;
layer_to_scene(31)->20031;
layer_to_scene(32)->20032;
layer_to_scene(33)->20033;
layer_to_scene(34)->20034;
layer_to_scene(35)->20035;
layer_to_scene(36)->20036;
layer_to_scene(37)->20037;
layer_to_scene(38)->20038;
layer_to_scene(39)->20039;
layer_to_scene(40)->20040;
layer_to_scene(41)->20041;
layer_to_scene(42)->20042;
layer_to_scene(43)->20043;
layer_to_scene(44)->20044;
layer_to_scene(45)->20045;
layer_to_scene(46)->20046;
layer_to_scene(47)->20047;
layer_to_scene(48)->20048;
layer_to_scene(49)->20049;
layer_to_scene(50)->20050;
layer_to_scene(51)->20051;
layer_to_scene(52)->20052;
layer_to_scene(53)->20053;
layer_to_scene(54)->20054;
layer_to_scene(55)->20055;
layer_to_scene(56)->20056;
layer_to_scene(57)->20057;
layer_to_scene(58)->20058;
layer_to_scene(59)->20059;
layer_to_scene(60)->20060;
layer_to_scene(61)->20061;
layer_to_scene(62)->20062;
layer_to_scene(63)->20063;
layer_to_scene(64)->20064;
layer_to_scene(65)->20065;
layer_to_scene(66)->20066;
layer_to_scene(67)->20067;
layer_to_scene(68)->20068;
layer_to_scene(69)->20069;
layer_to_scene(70)->20070;
layer_to_scene(71)->20071;
layer_to_scene(72)->20072;
layer_to_scene(73)->20073;
layer_to_scene(74)->20074;
layer_to_scene(75)->20075;
layer_to_scene(76)->20076;
layer_to_scene(77)->20077;
layer_to_scene(78)->20078;
layer_to_scene(79)->20079;
layer_to_scene(80)->20080;
layer_to_scene(81)->20081;
layer_to_scene(82)->20082;
layer_to_scene(83)->20083;
layer_to_scene(84)->20084;
layer_to_scene(85)->20085;
layer_to_scene(86)->20086;
layer_to_scene(87)->20087;
layer_to_scene(88)->20088;
layer_to_scene(89)->20089;
layer_to_scene(90)->20090;
layer_to_scene(91)->20091;
layer_to_scene(92)->20092;
layer_to_scene(93)->20093;
layer_to_scene(94)->20094;
layer_to_scene(95)->20095;
layer_to_scene(96)->20096;
layer_to_scene(97)->20097;
layer_to_scene(98)->20098;
layer_to_scene(99)->20099;
layer_to_scene(100)->20100;
layer_to_scene(101)->20101;
layer_to_scene(102)->20102;
layer_to_scene(103)->20103;
layer_to_scene(104)->20104;
layer_to_scene(105)->20105;
layer_to_scene(106)->20106;
layer_to_scene(107)->20107;
layer_to_scene(108)->20108;
layer_to_scene(109)->20109;
layer_to_scene(110)->20110;
layer_to_scene(111)->20111;
layer_to_scene(112)->20112;
layer_to_scene(113)->20113;
layer_to_scene(114)->20114;
layer_to_scene(115)->20115;
layer_to_scene(116)->20116;
layer_to_scene(117)->20117;
layer_to_scene(118)->20118;
layer_to_scene(119)->20119;
layer_to_scene(120)->20120;
layer_to_scene(121)->20121;
layer_to_scene(122)->20122;
layer_to_scene(123)->20123;
layer_to_scene(124)->20124;
layer_to_scene(125)->20125;
layer_to_scene(126)->20126;
layer_to_scene(127)->20127;
layer_to_scene(128)->20128;
layer_to_scene(129)->20129;
layer_to_scene(130)->20130;
layer_to_scene(131)->20131;
layer_to_scene(132)->20132;
layer_to_scene(133)->20133;
layer_to_scene(134)->20134;
layer_to_scene(135)->20135;
layer_to_scene(136)->20136;
layer_to_scene(137)->20137;
layer_to_scene(138)->20138;
layer_to_scene(139)->20139;
layer_to_scene(140)->20140;
layer_to_scene(141)->20141;
layer_to_scene(142)->20142;
layer_to_scene(143)->20143;
layer_to_scene(144)->20144;
layer_to_scene(145)->20145;
layer_to_scene(146)->20146;
layer_to_scene(147)->20147;
layer_to_scene(148)->20148;
layer_to_scene(149)->20149;
layer_to_scene(150)->20150;
layer_to_scene(151)->20151;
layer_to_scene(152)->20152;
layer_to_scene(153)->20153;
layer_to_scene(154)->20154;
layer_to_scene(155)->20155;
layer_to_scene(156)->20156;
layer_to_scene(157)->20157;
layer_to_scene(158)->20158;
layer_to_scene(159)->20159;
layer_to_scene(160)->20160;
layer_to_scene(_) -> [].
get(20001) ->
	#base_dun_tower{layer = 1 ,dun_id = 20001 ,pre_id = 0 ,next_id = 20002 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 5475 ,star1_goods = {{10108,3000}} ,star2_goods = {{10108,3000},{10101,200}} ,star3_goods = {{10108,3000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,3000},{10101,200}} };
get(20002) ->
	#base_dun_tower{layer = 2 ,dun_id = 20002 ,pre_id = 20001 ,next_id = 20003 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 7771 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20003) ->
	#base_dun_tower{layer = 3 ,dun_id = 20003 ,pre_id = 20002 ,next_id = 20004 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 10067 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20004) ->
	#base_dun_tower{layer = 4 ,dun_id = 20004 ,pre_id = 20003 ,next_id = 20005 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 12363 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{10106,100}} ,sweep_goods = {{10108,2000},{10101,200},{8001002,1}} };
get(20005) ->
	#base_dun_tower{layer = 5 ,dun_id = 20005 ,pre_id = 20004 ,next_id = 20006 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 14660 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20006) ->
	#base_dun_tower{layer = 6 ,dun_id = 20006 ,pre_id = 20005 ,next_id = 20007 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 16956 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20007) ->
	#base_dun_tower{layer = 7 ,dun_id = 20007 ,pre_id = 20006 ,next_id = 20008 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 19252 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20008) ->
	#base_dun_tower{layer = 8 ,dun_id = 20008 ,pre_id = 20007 ,next_id = 20009 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 24279 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{10106,100}} ,sweep_goods = {{10108,2000},{10101,200},{8001002,1}} };
get(20009) ->
	#base_dun_tower{layer = 9 ,dun_id = 20009 ,pre_id = 20008 ,next_id = 20010 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 29397 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20010) ->
	#base_dun_tower{layer = 10 ,dun_id = 20010 ,pre_id = 20009 ,next_id = 20011 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 34424 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20011) ->
	#base_dun_tower{layer = 11 ,dun_id = 20011 ,pre_id = 20010 ,next_id = 20012 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 39451 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20012) ->
	#base_dun_tower{layer = 12 ,dun_id = 20012 ,pre_id = 20011 ,next_id = 20013 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 44569 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{10106,100}} ,sweep_goods = {{10108,2000},{10101,200},{8001002,1}} };
get(20013) ->
	#base_dun_tower{layer = 13 ,dun_id = 20013 ,pre_id = 20012 ,next_id = 20014 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 49596 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20014) ->
	#base_dun_tower{layer = 14 ,dun_id = 20014 ,pre_id = 20013 ,next_id = 20015 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 70281 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20015) ->
	#base_dun_tower{layer = 15 ,dun_id = 20015 ,pre_id = 20014 ,next_id = 20016 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 90966 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20016) ->
	#base_dun_tower{layer = 16 ,dun_id = 20016 ,pre_id = 20015 ,next_id = 20017 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 111650 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{10106,100}} ,sweep_goods = {{10108,2000},{10101,200},{8001002,1}} };
get(20017) ->
	#base_dun_tower{layer = 17 ,dun_id = 20017 ,pre_id = 20016 ,next_id = 20018 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 132335 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20018) ->
	#base_dun_tower{layer = 18 ,dun_id = 20018 ,pre_id = 20017 ,next_id = 20019 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 143372 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20019) ->
	#base_dun_tower{layer = 19 ,dun_id = 20019 ,pre_id = 20018 ,next_id = 20020 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 144759 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20020) ->
	#base_dun_tower{layer = 20 ,dun_id = 20020 ,pre_id = 20019 ,next_id = 20021 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 146147 ,star1_goods = {{10108,1100}} ,star2_goods = {{10108,1100},{10101,200}} ,star3_goods = {{10108,1100},{10101,200},{10106,100}} ,sweep_goods = {{10108,1100},{10101,200},{8001002,1}} };
get(20021) ->
	#base_dun_tower{layer = 21 ,dun_id = 20021 ,pre_id = 20020 ,next_id = 20022 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 147445 ,star1_goods = {{10108,400}} ,star2_goods = {{10108,400},{10101,200}} ,star3_goods = {{10108,400},{10101,200},{8001002,1}} ,sweep_goods = {{10108,400},{10101,200}} };
get(20022) ->
	#base_dun_tower{layer = 22 ,dun_id = 20022 ,pre_id = 20021 ,next_id = 20023 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 148832 ,star1_goods = {{10108,800}} ,star2_goods = {{10108,800},{10101,200}} ,star3_goods = {{10108,800},{10101,200},{8001002,1}} ,sweep_goods = {{10108,800},{10101,200}} };
get(20023) ->
	#base_dun_tower{layer = 23 ,dun_id = 20023 ,pre_id = 20022 ,next_id = 20024 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 150220 ,star1_goods = {{10108,1200}} ,star2_goods = {{10108,1200},{10101,200}} ,star3_goods = {{10108,1200},{10101,200},{8001002,1}} ,sweep_goods = {{10108,1200},{10101,200}} };
get(20024) ->
	#base_dun_tower{layer = 24 ,dun_id = 20024 ,pre_id = 20023 ,next_id = 20025 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 151608 ,star1_goods = {{10108,1600}} ,star2_goods = {{10108,1600},{10101,200}} ,star3_goods = {{10108,1600},{10101,200},{10106,100}} ,sweep_goods = {{10108,1600},{10101,200},{8001002,1}} };
get(20025) ->
	#base_dun_tower{layer = 25 ,dun_id = 20025 ,pre_id = 20024 ,next_id = 20026 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 152996 ,star1_goods = {{10108,2000}} ,star2_goods = {{10108,2000},{10101,200}} ,star3_goods = {{10108,2000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2000},{10101,200}} };
get(20026) ->
	#base_dun_tower{layer = 26 ,dun_id = 20026 ,pre_id = 20025 ,next_id = 20027 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 164760 ,star1_goods = {{10108,2400}} ,star2_goods = {{10108,2400},{10101,200}} ,star3_goods = {{10108,2400},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2400},{10101,200}} };
get(20027) ->
	#base_dun_tower{layer = 27 ,dun_id = 20027 ,pre_id = 20026 ,next_id = 20028 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 176524 ,star1_goods = {{10108,2800}} ,star2_goods = {{10108,2800},{10101,200}} ,star3_goods = {{10108,2800},{10101,200},{8001002,1}} ,sweep_goods = {{10108,2800},{10101,200}} };
get(20028) ->
	#base_dun_tower{layer = 28 ,dun_id = 20028 ,pre_id = 20027 ,next_id = 20029 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 188289 ,star1_goods = {{10108,3200}} ,star2_goods = {{10108,3200},{10101,200}} ,star3_goods = {{10108,3200},{10101,200},{10106,100}} ,sweep_goods = {{10108,3200},{10101,200},{8001002,1}} };
get(20029) ->
	#base_dun_tower{layer = 29 ,dun_id = 20029 ,pre_id = 20028 ,next_id = 20030 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 200053 ,star1_goods = {{10108,3600}} ,star2_goods = {{10108,3600},{10101,200}} ,star3_goods = {{10108,3600},{10101,200},{8001002,1}} ,sweep_goods = {{10108,3600},{10101,200}} };
get(20030) ->
	#base_dun_tower{layer = 30 ,dun_id = 20030 ,pre_id = 20029 ,next_id = 20031 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 211818 ,star1_goods = {{10108,4000}} ,star2_goods = {{10108,4000},{10101,200}} ,star3_goods = {{10108,4000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,4000},{10101,200}} };
get(20031) ->
	#base_dun_tower{layer = 31 ,dun_id = 20031 ,pre_id = 20030 ,next_id = 20032 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 218565 ,star1_goods = {{10108,4400}} ,star2_goods = {{10108,4400},{10101,200}} ,star3_goods = {{10108,4400},{10101,200},{8001002,1}} ,sweep_goods = {{10108,4400},{10101,200}} };
get(20032) ->
	#base_dun_tower{layer = 32 ,dun_id = 20032 ,pre_id = 20031 ,next_id = 20033 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 220387 ,star1_goods = {{10108,4800}} ,star2_goods = {{10108,4800},{10101,200}} ,star3_goods = {{10108,4800},{10101,200},{10106,100}} ,sweep_goods = {{10108,4800},{10101,200},{8001002,1}} };
get(20033) ->
	#base_dun_tower{layer = 33 ,dun_id = 20033 ,pre_id = 20032 ,next_id = 20034 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 222208 ,star1_goods = {{10108,5200}} ,star2_goods = {{10108,5200},{10101,200}} ,star3_goods = {{10108,5200},{10101,200},{8001002,1}} ,sweep_goods = {{10108,5200},{10101,200}} };
get(20034) ->
	#base_dun_tower{layer = 34 ,dun_id = 20034 ,pre_id = 20033 ,next_id = 20035 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 224029 ,star1_goods = {{10108,5600}} ,star2_goods = {{10108,5600},{10101,200}} ,star3_goods = {{10108,5600},{10101,200},{8001002,1}} ,sweep_goods = {{10108,5600},{10101,200}} };
get(20035) ->
	#base_dun_tower{layer = 35 ,dun_id = 20035 ,pre_id = 20034 ,next_id = 20036 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 225851 ,star1_goods = {{10108,6000}} ,star2_goods = {{10108,6000},{10101,200}} ,star3_goods = {{10108,6000},{10101,200},{8001002,1}} ,sweep_goods = {{10108,6000},{10101,200}} };
get(20036) ->
	#base_dun_tower{layer = 36 ,dun_id = 20036 ,pre_id = 20035 ,next_id = 20037 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 227672 ,star1_goods = {{10108,6400}} ,star2_goods = {{10108,6400},{10101,200}} ,star3_goods = {{10108,6400},{10101,200},{10106,100}} ,sweep_goods = {{10108,6400},{10101,200},{8001002,1}} };
get(20037) ->
	#base_dun_tower{layer = 37 ,dun_id = 20037 ,pre_id = 20036 ,next_id = 20038 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 229493 ,star1_goods = {{10108,6800}} ,star2_goods = {{10108,6800},{10101,200}} ,star3_goods = {{10108,6800},{10101,200},{8001002,1}} ,sweep_goods = {{10108,6800},{10101,200}} };
get(20038) ->
	#base_dun_tower{layer = 38 ,dun_id = 20038 ,pre_id = 20037 ,next_id = 20039 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 231315 ,star1_goods = {{10108,7200}} ,star2_goods = {{10108,7200},{10101,200}} ,star3_goods = {{10108,7200},{10101,200},{8001002,1}} ,sweep_goods = {{10108,7200},{10101,200}} };
get(20039) ->
	#base_dun_tower{layer = 39 ,dun_id = 20039 ,pre_id = 20038 ,next_id = 20040 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 233136 ,star1_goods = {{10108,7600}} ,star2_goods = {{10108,7600},{10101,200}} ,star3_goods = {{10108,7600},{10101,200},{8001002,1}} ,sweep_goods = {{10108,7600},{10101,200}} };
get(20040) ->
	#base_dun_tower{layer = 40 ,dun_id = 20040 ,pre_id = 20039 ,next_id = 20041 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 234958 ,star1_goods = {{10108,8000}} ,star2_goods = {{10108,8000},{10101,600}} ,star3_goods = {{10108,8000},{10101,600},{10106,100}} ,sweep_goods = {{10108,8000},{10101,600},{8001002,1}} };
get(20041) ->
	#base_dun_tower{layer = 41 ,dun_id = 20041 ,pre_id = 20040 ,next_id = 20042 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 254702 ,star1_goods = {{10108,8400}} ,star2_goods = {{10108,8400},{10101,400}} ,star3_goods = {{10108,8400},{10101,400},{8001002,1}} ,sweep_goods = {{10108,8400},{10101,400}} };
get(20042) ->
	#base_dun_tower{layer = 42 ,dun_id = 20042 ,pre_id = 20041 ,next_id = 20043 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 277628 ,star1_goods = {{10108,8800}} ,star2_goods = {{10108,8800},{10101,400}} ,star3_goods = {{10108,8800},{10101,400},{8001002,1}} ,sweep_goods = {{10108,8800},{10101,400}} };
get(20043) ->
	#base_dun_tower{layer = 43 ,dun_id = 20043 ,pre_id = 20042 ,next_id = 20044 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 302437 ,star1_goods = {{10108,9200}} ,star2_goods = {{10108,9200},{10101,500}} ,star3_goods = {{10108,9200},{10101,500},{8001002,1}} ,sweep_goods = {{10108,9200},{10101,500}} };
get(20044) ->
	#base_dun_tower{layer = 44 ,dun_id = 20044 ,pre_id = 20043 ,next_id = 20045 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 480749 ,star1_goods = {{10108,9600}} ,star2_goods = {{10108,9600},{10101,400}} ,star3_goods = {{10108,9600},{10101,400},{10106,100}} ,sweep_goods = {{10108,9600},{10101,400},{8001002,1}} };
get(20045) ->
	#base_dun_tower{layer = 45 ,dun_id = 20045 ,pre_id = 20044 ,next_id = 20046 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 503954 ,star1_goods = {{10108,10000}} ,star2_goods = {{10108,10000},{10101,500}} ,star3_goods = {{10108,10000},{10101,500},{8001002,1}} ,sweep_goods = {{10108,10000},{10101,500}} };
get(20046) ->
	#base_dun_tower{layer = 46 ,dun_id = 20046 ,pre_id = 20045 ,next_id = 20047 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 536530 ,star1_goods = {{10108,10400}} ,star2_goods = {{10108,10400},{10101,500}} ,star3_goods = {{10108,10400},{10101,500},{8001002,1}} ,sweep_goods = {{10108,10400},{10101,500}} };
get(20047) ->
	#base_dun_tower{layer = 47 ,dun_id = 20047 ,pre_id = 20046 ,next_id = 20048 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 611157 ,star1_goods = {{10108,10800}} ,star2_goods = {{10108,10800},{10101,500}} ,star3_goods = {{10108,10800},{10101,500},{8001002,1}} ,sweep_goods = {{10108,10800},{10101,500}} };
get(20048) ->
	#base_dun_tower{layer = 48 ,dun_id = 20048 ,pre_id = 20047 ,next_id = 20049 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 711215 ,star1_goods = {{10108,11200}} ,star2_goods = {{10108,11200},{10101,500}} ,star3_goods = {{10108,11200},{10101,500},{10106,100}} ,sweep_goods = {{10108,11200},{10101,500},{8001002,1}} };
get(20049) ->
	#base_dun_tower{layer = 49 ,dun_id = 20049 ,pre_id = 20048 ,next_id = 20050 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 1184530 ,star1_goods = {{10108,11600}} ,star2_goods = {{10108,11600},{10101,600}} ,star3_goods = {{10108,11600},{10101,600},{8001002,1}} ,sweep_goods = {{10108,11600},{10101,600}} };
get(20050) ->
	#base_dun_tower{layer = 50 ,dun_id = 20050 ,pre_id = 20049 ,next_id = 20051 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 1323178 ,star1_goods = {{10108,12000}} ,star2_goods = {{10108,12000},{10101,600}} ,star3_goods = {{10108,12000},{10101,600},{8001002,1}} ,sweep_goods = {{10108,12000},{10101,600}} };
get(20051) ->
	#base_dun_tower{layer = 51 ,dun_id = 20051 ,pre_id = 20050 ,next_id = 20052 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 1402624 ,star1_goods = {{10108,12400}} ,star2_goods = {{10108,12400},{10101,600}} ,star3_goods = {{10108,12400},{10101,600},{8001002,1}} ,sweep_goods = {{10108,12400},{10101,600}} };
get(20052) ->
	#base_dun_tower{layer = 52 ,dun_id = 20052 ,pre_id = 20051 ,next_id = 20053 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 1974402 ,star1_goods = {{10108,12800}} ,star2_goods = {{10108,12800},{10101,600}} ,star3_goods = {{10108,12800},{10101,600},{10106,100}} ,sweep_goods = {{10108,12800},{10101,600},{8001002,1}} };
get(20053) ->
	#base_dun_tower{layer = 53 ,dun_id = 20053 ,pre_id = 20052 ,next_id = 20054 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 2118859 ,star1_goods = {{10108,13200}} ,star2_goods = {{10108,13200},{10101,700}} ,star3_goods = {{10108,13200},{10101,700},{8001002,1}} ,sweep_goods = {{10108,13200},{10101,700}} };
get(20054) ->
	#base_dun_tower{layer = 54 ,dun_id = 20054 ,pre_id = 20053 ,next_id = 20055 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 2278130 ,star1_goods = {{10108,13600}} ,star2_goods = {{10108,13600},{10101,700}} ,star3_goods = {{10108,13600},{10101,700},{8001002,1}} ,sweep_goods = {{10108,13600},{10101,700}} };
get(20055) ->
	#base_dun_tower{layer = 55 ,dun_id = 20055 ,pre_id = 20054 ,next_id = 20056 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 2954579 ,star1_goods = {{10108,14000}} ,star2_goods = {{10108,14000},{10101,700}} ,star3_goods = {{10108,14000},{10101,700},{8001002,1}} ,sweep_goods = {{10108,14000},{10101,700}} };
get(20056) ->
	#base_dun_tower{layer = 56 ,dun_id = 20056 ,pre_id = 20055 ,next_id = 20057 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 3131455 ,star1_goods = {{10108,14400}} ,star2_goods = {{10108,14400},{10101,700}} ,star3_goods = {{10108,14400},{10101,700},{10106,100}} ,sweep_goods = {{10108,14400},{10101,700},{8001002,1}} };
get(20057) ->
	#base_dun_tower{layer = 57 ,dun_id = 20057 ,pre_id = 20056 ,next_id = 20058 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 3324321 ,star1_goods = {{10108,14800}} ,star2_goods = {{10108,14800},{10101,800}} ,star3_goods = {{10108,14800},{10101,800},{8001002,1}} ,sweep_goods = {{10108,14800},{10101,800}} };
get(20058) ->
	#base_dun_tower{layer = 58 ,dun_id = 20058 ,pre_id = 20057 ,next_id = 20059 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 3525688 ,star1_goods = {{10108,15200}} ,star2_goods = {{10108,15200},{10101,800}} ,star3_goods = {{10108,15200},{10101,800},{8001002,1}} ,sweep_goods = {{10108,15200},{10101,800}} };
get(20059) ->
	#base_dun_tower{layer = 59 ,dun_id = 20059 ,pre_id = 20058 ,next_id = 20060 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 4462727 ,star1_goods = {{10108,15600}} ,star2_goods = {{10108,15600},{10101,800}} ,star3_goods = {{10108,15600},{10101,800},{8001002,1}} ,sweep_goods = {{10108,15600},{10101,800}} };
get(20060) ->
	#base_dun_tower{layer = 60 ,dun_id = 20060 ,pre_id = 20059 ,next_id = 20061 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 4591740 ,star1_goods = {{10108,16000}} ,star2_goods = {{10108,16000},{10101,900}} ,star3_goods = {{10108,16000},{10101,900},{10106,100}} ,sweep_goods = {{10108,16000},{10101,900},{8001002,1}} };
get(20061) ->
	#base_dun_tower{layer = 61 ,dun_id = 20061 ,pre_id = 20060 ,next_id = 20062 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 4893416 ,star1_goods = {{10108,16400}} ,star2_goods = {{10108,16400},{10101,900}} ,star3_goods = {{10108,16400},{10101,900},{8001002,1}} ,sweep_goods = {{10108,16400},{10101,900}} };
get(20062) ->
	#base_dun_tower{layer = 62 ,dun_id = 20062 ,pre_id = 20061 ,next_id = 20063 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 5108239 ,star1_goods = {{10108,16800}} ,star2_goods = {{10108,16800},{10101,900}} ,star3_goods = {{10108,16800},{10101,900},{8001002,1}} ,sweep_goods = {{10108,16800},{10101,900}} };
get(20063) ->
	#base_dun_tower{layer = 63 ,dun_id = 20063 ,pre_id = 20062 ,next_id = 20064 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 5389308 ,star1_goods = {{10108,17200}} ,star2_goods = {{10108,17200},{10101,900}} ,star3_goods = {{10108,17200},{10101,900},{8001002,1}} ,sweep_goods = {{10108,17200},{10101,900}} };
get(20064) ->
	#base_dun_tower{layer = 64 ,dun_id = 20064 ,pre_id = 20063 ,next_id = 20065 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 5533779 ,star1_goods = {{10108,17600}} ,star2_goods = {{10108,17600},{10101,1000}} ,star3_goods = {{10108,17600},{10101,1000},{10106,100}} ,sweep_goods = {{10108,17600},{10101,1000},{8001002,1}} };
get(20065) ->
	#base_dun_tower{layer = 65 ,dun_id = 20065 ,pre_id = 20064 ,next_id = 20066 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 7713518 ,star1_goods = {{10108,18000}} ,star2_goods = {{10108,18000},{10101,1000}} ,star3_goods = {{10108,18000},{10101,1000},{8001002,1}} ,sweep_goods = {{10108,18000},{10101,1000}} };
get(20066) ->
	#base_dun_tower{layer = 66 ,dun_id = 20066 ,pre_id = 20065 ,next_id = 20067 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 7995328 ,star1_goods = {{10108,18400}} ,star2_goods = {{10108,18400},{10101,1000}} ,star3_goods = {{10108,18400},{10101,1000},{8001002,1}} ,sweep_goods = {{10108,18400},{10101,1000}} };
get(20067) ->
	#base_dun_tower{layer = 67 ,dun_id = 20067 ,pre_id = 20066 ,next_id = 20068 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 8217052 ,star1_goods = {{10108,18800}} ,star2_goods = {{10108,18800},{10101,1100}} ,star3_goods = {{10108,18800},{10101,1100},{8001002,1}} ,sweep_goods = {{10108,18800},{10101,1100}} };
get(20068) ->
	#base_dun_tower{layer = 68 ,dun_id = 20068 ,pre_id = 20067 ,next_id = 20069 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 8488292 ,star1_goods = {{10108,19200}} ,star2_goods = {{10108,19200},{10101,1100}} ,star3_goods = {{10108,19200},{10101,1100},{10106,100}} ,sweep_goods = {{10108,19200},{10101,1100},{8001002,1}} };
get(20069) ->
	#base_dun_tower{layer = 69 ,dun_id = 20069 ,pre_id = 20068 ,next_id = 20070 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 8732048 ,star1_goods = {{10108,19600}} ,star2_goods = {{10108,19600},{10101,1100}} ,star3_goods = {{10108,19600},{10101,1100},{8001002,1}} ,sweep_goods = {{10108,19600},{10101,1100}} };
get(20070) ->
	#base_dun_tower{layer = 70 ,dun_id = 20070 ,pre_id = 20069 ,next_id = 20071 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 8877365 ,star1_goods = {{10108,20000}} ,star2_goods = {{10108,20000},{10101,1100}} ,star3_goods = {{10108,20000},{10101,1100},{8001002,1}} ,sweep_goods = {{10108,20000},{10101,1100}} };
get(20071) ->
	#base_dun_tower{layer = 71 ,dun_id = 20071 ,pre_id = 20070 ,next_id = 20072 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 9125424 ,star1_goods = {{10108,20400}} ,star2_goods = {{10108,20400},{10101,1200}} ,star3_goods = {{10108,20400},{10101,1200},{8001002,1}} ,sweep_goods = {{10108,20400},{10101,1200}} };
get(20072) ->
	#base_dun_tower{layer = 72 ,dun_id = 20072 ,pre_id = 20071 ,next_id = 20073 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 11733326 ,star1_goods = {{10108,20800}} ,star2_goods = {{10108,20800},{10101,1300}} ,star3_goods = {{10108,20800},{10101,1300},{10106,100}} ,sweep_goods = {{10108,20800},{10101,1300},{8001002,1}} };
get(20073) ->
	#base_dun_tower{layer = 73 ,dun_id = 20073 ,pre_id = 20072 ,next_id = 20074 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 11975921 ,star1_goods = {{10108,21200}} ,star2_goods = {{10108,21200},{10101,1200}} ,star3_goods = {{10108,21200},{10101,1200},{8001002,1}} ,sweep_goods = {{10108,21200},{10101,1200}} };
get(20074) ->
	#base_dun_tower{layer = 74 ,dun_id = 20074 ,pre_id = 20073 ,next_id = 20075 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 12387197 ,star1_goods = {{10108,21600}} ,star2_goods = {{10108,21600},{10101,1300}} ,star3_goods = {{10108,21600},{10101,1300},{8001002,1}} ,sweep_goods = {{10108,21600},{10101,1300}} };
get(20075) ->
	#base_dun_tower{layer = 75 ,dun_id = 20075 ,pre_id = 20074 ,next_id = 20076 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 12743581 ,star1_goods = {{10108,22000}} ,star2_goods = {{10108,22000},{10101,1400}} ,star3_goods = {{10108,22000},{10101,1400},{8001002,1}} ,sweep_goods = {{10108,22000},{10101,1400}} };
get(20076) ->
	#base_dun_tower{layer = 76 ,dun_id = 20076 ,pre_id = 20075 ,next_id = 20077 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 13000615 ,star1_goods = {{10108,22400}} ,star2_goods = {{10108,22400},{10101,1300}} ,star3_goods = {{10108,22400},{10101,1300},{10106,100}} ,sweep_goods = {{10108,22400},{10101,1300},{8001002,1}} };
get(20077) ->
	#base_dun_tower{layer = 77 ,dun_id = 20077 ,pre_id = 20076 ,next_id = 20078 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 13302378 ,star1_goods = {{10108,22800}} ,star2_goods = {{10108,22800},{10101,1400}} ,star3_goods = {{10108,22800},{10101,1400},{8001002,1}} ,sweep_goods = {{10108,22800},{10101,1400}} };
get(20078) ->
	#base_dun_tower{layer = 78 ,dun_id = 20078 ,pre_id = 20077 ,next_id = 20079 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 13645451 ,star1_goods = {{10108,23200}} ,star2_goods = {{10108,23200},{10101,1500}} ,star3_goods = {{10108,23200},{10101,1500},{8001002,1}} ,sweep_goods = {{10108,23200},{10101,1500}} };
get(20079) ->
	#base_dun_tower{layer = 79 ,dun_id = 20079 ,pre_id = 20078 ,next_id = 20080 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 13932106 ,star1_goods = {{10108,23600}} ,star2_goods = {{10108,23600},{10101,1400}} ,star3_goods = {{10108,23600},{10101,1400},{8001002,1}} ,sweep_goods = {{10108,23600},{10101,1400}} };
get(20080) ->
	#base_dun_tower{layer = 80 ,dun_id = 20080 ,pre_id = 20079 ,next_id = 20081 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 14215309 ,star1_goods = {{10108,24000}} ,star2_goods = {{10108,24000},{10101,1600}} ,star3_goods = {{10108,24000},{10101,1600},{10106,100}} ,sweep_goods = {{10108,24000},{10101,1600},{8001002,1}} };
get(20081) ->
	#base_dun_tower{layer = 81 ,dun_id = 20081 ,pre_id = 20080 ,next_id = 20082 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 14655332 ,star1_goods = {{10108,24400}} ,star2_goods = {{10108,24400},{10101,1500}} ,star3_goods = {{10108,24400},{10101,1500},{8001002,1}} ,sweep_goods = {{10108,24400},{10101,1500}} };
get(20082) ->
	#base_dun_tower{layer = 82 ,dun_id = 20082 ,pre_id = 20081 ,next_id = 20083 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 18344197 ,star1_goods = {{10108,24800}} ,star2_goods = {{10108,24800},{10101,1600}} ,star3_goods = {{10108,24800},{10101,1600},{8001002,1}} ,sweep_goods = {{10108,24800},{10101,1600}} };
get(20083) ->
	#base_dun_tower{layer = 83 ,dun_id = 20083 ,pre_id = 20082 ,next_id = 20084 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 18821550 ,star1_goods = {{10108,25200}} ,star2_goods = {{10108,25200},{10101,1600}} ,star3_goods = {{10108,25200},{10101,1600},{8001002,1}} ,sweep_goods = {{10108,25200},{10101,1600}} };
get(20084) ->
	#base_dun_tower{layer = 84 ,dun_id = 20084 ,pre_id = 20083 ,next_id = 20085 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 19358645 ,star1_goods = {{10108,25600}} ,star2_goods = {{10108,25600},{10101,1700}} ,star3_goods = {{10108,25600},{10101,1700},{10106,100}} ,sweep_goods = {{10108,25600},{10101,1700},{8001002,1}} };
get(20085) ->
	#base_dun_tower{layer = 85 ,dun_id = 20085 ,pre_id = 20084 ,next_id = 20086 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 19717328 ,star1_goods = {{10108,26000}} ,star2_goods = {{10108,26000},{10101,1700}} ,star3_goods = {{10108,26000},{10101,1700},{8001002,1}} ,sweep_goods = {{10108,26000},{10101,1700}} };
get(20086) ->
	#base_dun_tower{layer = 86 ,dun_id = 20086 ,pre_id = 20085 ,next_id = 20087 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 20245552 ,star1_goods = {{10108,26400}} ,star2_goods = {{10108,26400},{10101,1800}} ,star3_goods = {{10108,26400},{10101,1800},{8001002,1}} ,sweep_goods = {{10108,26400},{10101,1800}} };
get(20087) ->
	#base_dun_tower{layer = 87 ,dun_id = 20087 ,pre_id = 20086 ,next_id = 20088 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 20491376 ,star1_goods = {{10108,26800}} ,star2_goods = {{10108,26800},{10101,1800}} ,star3_goods = {{10108,26800},{10101,1800},{8001002,1}} ,sweep_goods = {{10108,26800},{10101,1800}} };
get(20088) ->
	#base_dun_tower{layer = 88 ,dun_id = 20088 ,pre_id = 20087 ,next_id = 20089 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 20897636 ,star1_goods = {{10108,27200}} ,star2_goods = {{10108,27200},{10101,1800}} ,star3_goods = {{10108,27200},{10101,1800},{10106,100}} ,sweep_goods = {{10108,27200},{10101,1800},{8001002,1}} };
get(20089) ->
	#base_dun_tower{layer = 89 ,dun_id = 20089 ,pre_id = 20088 ,next_id = 20090 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 21219909 ,star1_goods = {{10108,27600}} ,star2_goods = {{10108,27600},{10101,1900}} ,star3_goods = {{10108,27600},{10101,1900},{8001002,1}} ,sweep_goods = {{10108,27600},{10101,1900}} };
get(20090) ->
	#base_dun_tower{layer = 90 ,dun_id = 20090 ,pre_id = 20089 ,next_id = 20091 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 21672744 ,star1_goods = {{10108,28000}} ,star2_goods = {{10108,28000},{10101,1900}} ,star3_goods = {{10108,28000},{10101,1900},{8001002,1}} ,sweep_goods = {{10108,28000},{10101,1900}} };
get(20091) ->
	#base_dun_tower{layer = 91 ,dun_id = 20091 ,pre_id = 20090 ,next_id = 20092 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 26641196 ,star1_goods = {{10108,28400}} ,star2_goods = {{10108,28400},{10101,2000}} ,star3_goods = {{10108,28400},{10101,2000},{8001002,1}} ,sweep_goods = {{10108,28400},{10101,2000}} };
get(20092) ->
	#base_dun_tower{layer = 92 ,dun_id = 20092 ,pre_id = 20091 ,next_id = 20093 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 27115820 ,star1_goods = {{10108,28800}} ,star2_goods = {{10108,28800},{10101,2000}} ,star3_goods = {{10108,28800},{10101,2000},{10106,100}} ,sweep_goods = {{10108,28800},{10101,2000},{8001002,1}} };
get(20093) ->
	#base_dun_tower{layer = 93 ,dun_id = 20093 ,pre_id = 20092 ,next_id = 20094 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 27385828 ,star1_goods = {{10108,29200}} ,star2_goods = {{10108,29200},{10101,2000}} ,star3_goods = {{10108,29200},{10101,2000},{8001002,1}} ,sweep_goods = {{10108,29200},{10101,2000}} };
get(20094) ->
	#base_dun_tower{layer = 94 ,dun_id = 20094 ,pre_id = 20093 ,next_id = 20095 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 27670989 ,star1_goods = {{10108,29600}} ,star2_goods = {{10108,29600},{10101,2100}} ,star3_goods = {{10108,29600},{10101,2100},{8001002,1}} ,sweep_goods = {{10108,29600},{10101,2100}} };
get(20095) ->
	#base_dun_tower{layer = 95 ,dun_id = 20095 ,pre_id = 20094 ,next_id = 20096 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 28126338 ,star1_goods = {{10108,30000}} ,star2_goods = {{10108,30000},{10101,2200}} ,star3_goods = {{10108,30000},{10101,2200},{8001002,1}} ,sweep_goods = {{10108,30000},{10101,2200}} };
get(20096) ->
	#base_dun_tower{layer = 96 ,dun_id = 20096 ,pre_id = 20095 ,next_id = 20097 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 28376449 ,star1_goods = {{10108,30400}} ,star2_goods = {{10108,30400},{10101,2200}} ,star3_goods = {{10108,30400},{10101,2200},{10106,100}} ,sweep_goods = {{10108,30400},{10101,2200},{8001002,1}} };
get(20097) ->
	#base_dun_tower{layer = 97 ,dun_id = 20097 ,pre_id = 20096 ,next_id = 20098 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 28683000 ,star1_goods = {{10108,30800}} ,star2_goods = {{10108,30800},{10101,2200}} ,star3_goods = {{10108,30800},{10101,2200},{8001002,1}} ,sweep_goods = {{10108,30800},{10101,2200}} };
get(20098) ->
	#base_dun_tower{layer = 98 ,dun_id = 20098 ,pre_id = 20097 ,next_id = 20099 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 28958870 ,star1_goods = {{10108,31200}} ,star2_goods = {{10108,31200},{10101,2300}} ,star3_goods = {{10108,31200},{10101,2300},{8001002,1}} ,sweep_goods = {{10108,31200},{10101,2300}} };
get(20099) ->
	#base_dun_tower{layer = 99 ,dun_id = 20099 ,pre_id = 20098 ,next_id = 20100 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 29639805 ,star1_goods = {{10108,31600}} ,star2_goods = {{10108,31600},{10101,2300}} ,star3_goods = {{10108,31600},{10101,2300},{8001002,1}} ,sweep_goods = {{10108,31600},{10101,2300}} };
get(20100) ->
	#base_dun_tower{layer = 100 ,dun_id = 20100 ,pre_id = 20099 ,next_id = 20101 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 29971472 ,star1_goods = {{10108,32000}} ,star2_goods = {{10108,32000},{10101,2400}} ,star3_goods = {{10108,32000},{10101,2400},{10106,100}} ,sweep_goods = {{10108,32000},{10101,2400},{8001002,1}} };
get(20101) ->
	#base_dun_tower{layer = 101 ,dun_id = 20101 ,pre_id = 20100 ,next_id = 20102 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 30206013 ,star1_goods = {{10108,32400}} ,star2_goods = {{10108,32400},{10101,2400}} ,star3_goods = {{10108,32400},{10101,2400},{8001002,1}} ,sweep_goods = {{10108,32400},{10101,2400}} };
get(20102) ->
	#base_dun_tower{layer = 102 ,dun_id = 20102 ,pre_id = 20101 ,next_id = 20103 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 30490020 ,star1_goods = {{10108,32800}} ,star2_goods = {{10108,32800},{10101,2500}} ,star3_goods = {{10108,32800},{10101,2500},{8001002,1}} ,sweep_goods = {{10108,32800},{10101,2500}} };
get(20103) ->
	#base_dun_tower{layer = 103 ,dun_id = 20103 ,pre_id = 20102 ,next_id = 20104 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 31056583 ,star1_goods = {{10108,33200}} ,star2_goods = {{10108,33200},{10101,2500}} ,star3_goods = {{10108,33200},{10101,2500},{8001002,1}} ,sweep_goods = {{10108,33200},{10101,2500}} };
get(20104) ->
	#base_dun_tower{layer = 104 ,dun_id = 20104 ,pre_id = 20103 ,next_id = 20105 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 31329626 ,star1_goods = {{10108,33600}} ,star2_goods = {{10108,33600},{10101,2600}} ,star3_goods = {{10108,33600},{10101,2600},{10106,100}} ,sweep_goods = {{10108,33600},{10101,2600},{8001002,1}} };
get(20105) ->
	#base_dun_tower{layer = 105 ,dun_id = 20105 ,pre_id = 20104 ,next_id = 20106 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 31564594 ,star1_goods = {{10108,34000}} ,star2_goods = {{10108,34000},{10101,2600}} ,star3_goods = {{10108,34000},{10101,2600},{8001002,1}} ,sweep_goods = {{10108,34000},{10101,2600}} };
get(20106) ->
	#base_dun_tower{layer = 106 ,dun_id = 20106 ,pre_id = 20105 ,next_id = 20107 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 31830280 ,star1_goods = {{10108,34400}} ,star2_goods = {{10108,34400},{10101,2700}} ,star3_goods = {{10108,34400},{10101,2700},{8001002,1}} ,sweep_goods = {{10108,34400},{10101,2700}} };
get(20107) ->
	#base_dun_tower{layer = 107 ,dun_id = 20107 ,pre_id = 20106 ,next_id = 20108 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 32401214 ,star1_goods = {{10108,34800}} ,star2_goods = {{10108,34800},{10101,2700}} ,star3_goods = {{10108,34800},{10101,2700},{8001002,1}} ,sweep_goods = {{10108,34800},{10101,2700}} };
get(20108) ->
	#base_dun_tower{layer = 108 ,dun_id = 20108 ,pre_id = 20107 ,next_id = 20109 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 32673629 ,star1_goods = {{10108,35200}} ,star2_goods = {{10108,35200},{10101,2800}} ,star3_goods = {{10108,35200},{10101,2800},{10106,100}} ,sweep_goods = {{10108,35200},{10101,2800},{8001002,1}} };
get(20109) ->
	#base_dun_tower{layer = 109 ,dun_id = 20109 ,pre_id = 20108 ,next_id = 20110 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 33073377 ,star1_goods = {{10108,35600}} ,star2_goods = {{10108,35600},{10101,2800}} ,star3_goods = {{10108,35600},{10101,2800},{8001002,1}} ,sweep_goods = {{10108,35600},{10101,2800}} };
get(20110) ->
	#base_dun_tower{layer = 110 ,dun_id = 20110 ,pre_id = 20109 ,next_id = 20111 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 33384286 ,star1_goods = {{10108,36000}} ,star2_goods = {{10108,36000},{10101,2900}} ,star3_goods = {{10108,36000},{10101,2900},{8001002,1}} ,sweep_goods = {{10108,36000},{10101,2900}} };
get(20111) ->
	#base_dun_tower{layer = 111 ,dun_id = 20111 ,pre_id = 20110 ,next_id = 20112 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 33737305 ,star1_goods = {{10108,36400}} ,star2_goods = {{10108,36400},{10101,2900}} ,star3_goods = {{10108,36400},{10101,2900},{8001002,1}} ,sweep_goods = {{10108,36400},{10101,2900}} };
get(20112) ->
	#base_dun_tower{layer = 112 ,dun_id = 20112 ,pre_id = 20111 ,next_id = 20113 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 34016941 ,star1_goods = {{10108,36800}} ,star2_goods = {{10108,36800},{10101,3000}} ,star3_goods = {{10108,36800},{10101,3000},{10106,100}} ,sweep_goods = {{10108,36800},{10101,3000},{8001002,1}} };
get(20113) ->
	#base_dun_tower{layer = 113 ,dun_id = 20113 ,pre_id = 20112 ,next_id = 20114 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 34339439 ,star1_goods = {{10108,37200}} ,star2_goods = {{10108,37200},{10101,3000}} ,star3_goods = {{10108,37200},{10101,3000},{8001002,1}} ,sweep_goods = {{10108,37200},{10101,3000}} };
get(20114) ->
	#base_dun_tower{layer = 114 ,dun_id = 20114 ,pre_id = 20113 ,next_id = 20115 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 34712519 ,star1_goods = {{10108,37600}} ,star2_goods = {{10108,37600},{10101,3100}} ,star3_goods = {{10108,37600},{10101,3100},{8001002,1}} ,sweep_goods = {{10108,37600},{10101,3100}} };
get(20115) ->
	#base_dun_tower{layer = 115 ,dun_id = 20115 ,pre_id = 20114 ,next_id = 20116 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 35035868 ,star1_goods = {{10108,38000}} ,star2_goods = {{10108,38000},{10101,3200}} ,star3_goods = {{10108,38000},{10101,3200},{8001002,1}} ,sweep_goods = {{10108,38000},{10101,3200}} };
get(20116) ->
	#base_dun_tower{layer = 116 ,dun_id = 20116 ,pre_id = 20115 ,next_id = 20117 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 35317907 ,star1_goods = {{10108,38400}} ,star2_goods = {{10108,38400},{10101,3200}} ,star3_goods = {{10108,38400},{10101,3200},{10106,100}} ,sweep_goods = {{10108,38400},{10101,3200},{8001002,1}} };
get(20117) ->
	#base_dun_tower{layer = 117 ,dun_id = 20117 ,pre_id = 20116 ,next_id = 20118 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 35655829 ,star1_goods = {{10108,38800}} ,star2_goods = {{10108,38800},{10101,3200}} ,star3_goods = {{10108,38800},{10101,3200},{8001002,1}} ,sweep_goods = {{10108,38800},{10101,3200}} };
get(20118) ->
	#base_dun_tower{layer = 118 ,dun_id = 20118 ,pre_id = 20117 ,next_id = 20119 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 35996231 ,star1_goods = {{10108,39200}} ,star2_goods = {{10108,39200},{10101,3300}} ,star3_goods = {{10108,39200},{10101,3300},{8001002,1}} ,sweep_goods = {{10108,39200},{10101,3300}} };
get(20119) ->
	#base_dun_tower{layer = 119 ,dun_id = 20119 ,pre_id = 20118 ,next_id = 20120 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 36361488 ,star1_goods = {{10108,39600}} ,star2_goods = {{10108,39600},{10101,3400}} ,star3_goods = {{10108,39600},{10101,3400},{8001002,1}} ,sweep_goods = {{10108,39600},{10101,3400}} };
get(20120) ->
	#base_dun_tower{layer = 120 ,dun_id = 20120 ,pre_id = 20119 ,next_id = 20121 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 36701176 ,star1_goods = {{10108,40000}} ,star2_goods = {{10108,40000},{10101,3400}} ,star3_goods = {{10108,40000},{10101,3400},{10106,100}} ,sweep_goods = {{10108,40000},{10101,3400},{8001002,1}} };
get(20121) ->
	#base_dun_tower{layer = 121 ,dun_id = 20121 ,pre_id = 20120 ,next_id = 20122 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 36993050 ,star1_goods = {{10108,40400}} ,star2_goods = {{10108,40400},{10101,3500}} ,star3_goods = {{10108,40400},{10101,3500},{8001002,1}} ,sweep_goods = {{10108,40400},{10101,3500}} };
get(20122) ->
	#base_dun_tower{layer = 122 ,dun_id = 20122 ,pre_id = 20121 ,next_id = 20123 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 37325384 ,star1_goods = {{10108,40800}} ,star2_goods = {{10108,40800},{10101,3600}} ,star3_goods = {{10108,40800},{10101,3600},{8001002,1}} ,sweep_goods = {{10108,40800},{10101,3600}} };
get(20123) ->
	#base_dun_tower{layer = 123 ,dun_id = 20123 ,pre_id = 20122 ,next_id = 20124 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 37620019 ,star1_goods = {{10108,41200}} ,star2_goods = {{10108,41200},{10101,3600}} ,star3_goods = {{10108,41200},{10101,3600},{8001002,1}} ,sweep_goods = {{10108,41200},{10101,3600}} };
get(20124) ->
	#base_dun_tower{layer = 124 ,dun_id = 20124 ,pre_id = 20123 ,next_id = 20125 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 38020939 ,star1_goods = {{10108,41600}} ,star2_goods = {{10108,41600},{10101,3600}} ,star3_goods = {{10108,41600},{10101,3600},{10106,100}} ,sweep_goods = {{10108,41600},{10101,3600},{8001002,1}} };
get(20125) ->
	#base_dun_tower{layer = 125 ,dun_id = 20125 ,pre_id = 20124 ,next_id = 20126 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 38384176 ,star1_goods = {{10108,42000}} ,star2_goods = {{10108,42000},{10101,3800}} ,star3_goods = {{10108,42000},{10101,3800},{8001002,1}} ,sweep_goods = {{10108,42000},{10101,3800}} };
get(20126) ->
	#base_dun_tower{layer = 126 ,dun_id = 20126 ,pre_id = 20125 ,next_id = 20127 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 38735743 ,star1_goods = {{10108,42400}} ,star2_goods = {{10108,42400},{10101,3700}} ,star3_goods = {{10108,42400},{10101,3700},{8001002,1}} ,sweep_goods = {{10108,42400},{10101,3700}} };
get(20127) ->
	#base_dun_tower{layer = 127 ,dun_id = 20127 ,pre_id = 20126 ,next_id = 20128 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 39028972 ,star1_goods = {{10108,42800}} ,star2_goods = {{10108,42800},{10101,3900}} ,star3_goods = {{10108,42800},{10101,3900},{8001002,1}} ,sweep_goods = {{10108,42800},{10101,3900}} };
get(20128) ->
	#base_dun_tower{layer = 128 ,dun_id = 20128 ,pre_id = 20127 ,next_id = 20129 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 39422389 ,star1_goods = {{10108,43200}} ,star2_goods = {{10108,43200},{10101,3900}} ,star3_goods = {{10108,43200},{10101,3900},{10106,100}} ,sweep_goods = {{10108,43200},{10101,3900},{8001002,1}} };
get(20129) ->
	#base_dun_tower{layer = 129 ,dun_id = 20129 ,pre_id = 20128 ,next_id = 20130 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 39818895 ,star1_goods = {{10108,43600}} ,star2_goods = {{10108,43600},{10101,3900}} ,star3_goods = {{10108,43600},{10101,3900},{8001002,1}} ,sweep_goods = {{10108,43600},{10101,3900}} };
get(20130) ->
	#base_dun_tower{layer = 130 ,dun_id = 20130 ,pre_id = 20129 ,next_id = 20131 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 40150950 ,star1_goods = {{10108,44000}} ,star2_goods = {{10108,44000},{10101,4100}} ,star3_goods = {{10108,44000},{10101,4100},{8001002,1}} ,sweep_goods = {{10108,44000},{10101,4100}} };
get(20131) ->
	#base_dun_tower{layer = 131 ,dun_id = 20131 ,pre_id = 20130 ,next_id = 20132 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 40420466 ,star1_goods = {{10108,44400}} ,star2_goods = {{10108,44400},{10101,4000}} ,star3_goods = {{10108,44400},{10101,4000},{8001002,1}} ,sweep_goods = {{10108,44400},{10101,4000}} };
get(20132) ->
	#base_dun_tower{layer = 132 ,dun_id = 20132 ,pre_id = 20131 ,next_id = 20133 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 40802172 ,star1_goods = {{10108,44800}} ,star2_goods = {{10108,44800},{10101,4200}} ,star3_goods = {{10108,44800},{10101,4200},{10106,100}} ,sweep_goods = {{10108,44800},{10101,4200},{8001002,1}} };
get(20133) ->
	#base_dun_tower{layer = 133 ,dun_id = 20133 ,pre_id = 20132 ,next_id = 20134 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 41071972 ,star1_goods = {{10108,45200}} ,star2_goods = {{10108,45200},{10101,4200}} ,star3_goods = {{10108,45200},{10101,4200},{8001002,1}} ,sweep_goods = {{10108,45200},{10101,4200}} };
get(20134) ->
	#base_dun_tower{layer = 134 ,dun_id = 20134 ,pre_id = 20133 ,next_id = 20135 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 41412567 ,star1_goods = {{10108,45600}} ,star2_goods = {{10108,45600},{10101,4300}} ,star3_goods = {{10108,45600},{10101,4300},{8001002,1}} ,sweep_goods = {{10108,45600},{10101,4300}} };
get(20135) ->
	#base_dun_tower{layer = 135 ,dun_id = 20135 ,pre_id = 20134 ,next_id = 20136 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 41705298 ,star1_goods = {{10108,46000}} ,star2_goods = {{10108,46000},{10101,4300}} ,star3_goods = {{10108,46000},{10101,4300},{8001002,1}} ,sweep_goods = {{10108,46000},{10101,4300}} };
get(20136) ->
	#base_dun_tower{layer = 136 ,dun_id = 20136 ,pre_id = 20135 ,next_id = 20137 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 42039673 ,star1_goods = {{10108,46400}} ,star2_goods = {{10108,46400},{10101,4400}} ,star3_goods = {{10108,46400},{10101,4400},{10106,100}} ,sweep_goods = {{10108,46400},{10101,4400},{8001002,1}} };
get(20137) ->
	#base_dun_tower{layer = 137 ,dun_id = 20137 ,pre_id = 20136 ,next_id = 20138 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 42349674 ,star1_goods = {{10108,46800}} ,star2_goods = {{10108,46800},{10101,4500}} ,star3_goods = {{10108,46800},{10101,4500},{8001002,1}} ,sweep_goods = {{10108,46800},{10101,4500}} };
get(20138) ->
	#base_dun_tower{layer = 138 ,dun_id = 20138 ,pre_id = 20137 ,next_id = 20139 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 42696627 ,star1_goods = {{10108,47200}} ,star2_goods = {{10108,47200},{10101,4500}} ,star3_goods = {{10108,47200},{10101,4500},{8001002,1}} ,sweep_goods = {{10108,47200},{10101,4500}} };
get(20139) ->
	#base_dun_tower{layer = 139 ,dun_id = 20139 ,pre_id = 20138 ,next_id = 20140 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 43060821 ,star1_goods = {{10108,47600}} ,star2_goods = {{10108,47600},{10101,4700}} ,star3_goods = {{10108,47600},{10101,4700},{8001002,1}} ,sweep_goods = {{10108,47600},{10101,4700}} };
get(20140) ->
	#base_dun_tower{layer = 140 ,dun_id = 20140 ,pre_id = 20139 ,next_id = 20141 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 43400764 ,star1_goods = {{10108,48000}} ,star2_goods = {{10108,48000},{10101,4600}} ,star3_goods = {{10108,48000},{10101,4600},{10106,100}} ,sweep_goods = {{10108,48000},{10101,4600},{8001002,1}} };
get(20141) ->
	#base_dun_tower{layer = 141 ,dun_id = 20141 ,pre_id = 20140 ,next_id = 20142 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 43683678 ,star1_goods = {{10108,48400}} ,star2_goods = {{10108,48400},{10101,4800}} ,star3_goods = {{10108,48400},{10101,4800},{8001002,1}} ,sweep_goods = {{10108,48400},{10101,4800}} };
get(20142) ->
	#base_dun_tower{layer = 142 ,dun_id = 20142 ,pre_id = 20141 ,next_id = 20143 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 44049579 ,star1_goods = {{10108,48800}} ,star2_goods = {{10108,48800},{10101,4800}} ,star3_goods = {{10108,48800},{10101,4800},{8001002,1}} ,sweep_goods = {{10108,48800},{10101,4800}} };
get(20143) ->
	#base_dun_tower{layer = 143 ,dun_id = 20143 ,pre_id = 20142 ,next_id = 20144 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 44347576 ,star1_goods = {{10108,49200}} ,star2_goods = {{10108,49200},{10101,4800}} ,star3_goods = {{10108,49200},{10101,4800},{8001002,1}} ,sweep_goods = {{10108,49200},{10101,4800}} };
get(20144) ->
	#base_dun_tower{layer = 144 ,dun_id = 20144 ,pre_id = 20143 ,next_id = 20145 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 44674203 ,star1_goods = {{10108,49600}} ,star2_goods = {{10108,49600},{10101,5000}} ,star3_goods = {{10108,49600},{10101,5000},{10106,100}} ,sweep_goods = {{10108,49600},{10101,5000},{8001002,1}} };
get(20145) ->
	#base_dun_tower{layer = 145 ,dun_id = 20145 ,pre_id = 20144 ,next_id = 20146 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 45040786 ,star1_goods = {{10108,50000}} ,star2_goods = {{10108,50000},{10101,5000}} ,star3_goods = {{10108,50000},{10101,5000},{8001002,1}} ,sweep_goods = {{10108,50000},{10101,5000}} };
get(20146) ->
	#base_dun_tower{layer = 146 ,dun_id = 20146 ,pre_id = 20145 ,next_id = 20147 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 45325384 ,star1_goods = {{10108,50400}} ,star2_goods = {{10108,50400},{10101,5100}} ,star3_goods = {{10108,50400},{10101,5100},{8001002,1}} ,sweep_goods = {{10108,50400},{10101,5100}} };
get(20147) ->
	#base_dun_tower{layer = 147 ,dun_id = 20147 ,pre_id = 20146 ,next_id = 20148 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 45685072 ,star1_goods = {{10108,50800}} ,star2_goods = {{10108,50800},{10101,5100}} ,star3_goods = {{10108,50800},{10101,5100},{8001002,1}} ,sweep_goods = {{10108,50800},{10101,5100}} };
get(20148) ->
	#base_dun_tower{layer = 148 ,dun_id = 20148 ,pre_id = 20147 ,next_id = 20149 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 45949499 ,star1_goods = {{10108,51200}} ,star2_goods = {{10108,51200},{10101,5200}} ,star3_goods = {{10108,51200},{10101,5200},{10106,100}} ,sweep_goods = {{10108,51200},{10101,5200},{8001002,1}} };
get(20149) ->
	#base_dun_tower{layer = 149 ,dun_id = 20149 ,pre_id = 20148 ,next_id = 20150 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 46332750 ,star1_goods = {{10108,51600}} ,star2_goods = {{10108,51600},{10101,5300}} ,star3_goods = {{10108,51600},{10101,5300},{8001002,1}} ,sweep_goods = {{10108,51600},{10101,5300}} };
get(20150) ->
	#base_dun_tower{layer = 150 ,dun_id = 20150 ,pre_id = 20149 ,next_id = 20151 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 46706175 ,star1_goods = {{10108,52000}} ,star2_goods = {{10108,52000},{10101,5400}} ,star3_goods = {{10108,52000},{10101,5400},{8001002,1}} ,sweep_goods = {{10108,52000},{10101,5400}} };
get(20151) ->
	#base_dun_tower{layer = 151 ,dun_id = 20151 ,pre_id = 20150 ,next_id = 20152 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 47048520 ,star1_goods = {{10108,52400}} ,star2_goods = {{10108,52400},{10101,5400}} ,star3_goods = {{10108,52400},{10101,5400},{8001002,1}} ,sweep_goods = {{10108,52400},{10101,5400}} };
get(20152) ->
	#base_dun_tower{layer = 152 ,dun_id = 20152 ,pre_id = 20151 ,next_id = 20153 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 47379263 ,star1_goods = {{10108,52800}} ,star2_goods = {{10108,52800},{10101,5500}} ,star3_goods = {{10108,52800},{10101,5500},{10106,100}} ,sweep_goods = {{10108,52800},{10101,5500},{8001002,1}} };
get(20153) ->
	#base_dun_tower{layer = 153 ,dun_id = 20153 ,pre_id = 20152 ,next_id = 20154 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 47656713 ,star1_goods = {{10108,53200}} ,star2_goods = {{10108,53200},{10101,5600}} ,star3_goods = {{10108,53200},{10101,5600},{8001002,1}} ,sweep_goods = {{10108,53200},{10101,5600}} };
get(20154) ->
	#base_dun_tower{layer = 154 ,dun_id = 20154 ,pre_id = 20153 ,next_id = 20155 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 48097024 ,star1_goods = {{10108,53600}} ,star2_goods = {{10108,53600},{10101,5700}} ,star3_goods = {{10108,53600},{10101,5700},{8001002,1}} ,sweep_goods = {{10108,53600},{10101,5700}} };
get(20155) ->
	#base_dun_tower{layer = 155 ,dun_id = 20155 ,pre_id = 20154 ,next_id = 20156 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 48395020 ,star1_goods = {{10108,54000}} ,star2_goods = {{10108,54000},{10101,5700}} ,star3_goods = {{10108,54000},{10101,5700},{8001002,1}} ,sweep_goods = {{10108,54000},{10101,5700}} };
get(20156) ->
	#base_dun_tower{layer = 156 ,dun_id = 20156 ,pre_id = 20155 ,next_id = 20157 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 48747397 ,star1_goods = {{10108,54400}} ,star2_goods = {{10108,54400},{10101,5800}} ,star3_goods = {{10108,54400},{10101,5800},{10106,100}} ,sweep_goods = {{10108,54400},{10101,5800},{8001002,1}} };
get(20157) ->
	#base_dun_tower{layer = 157 ,dun_id = 20157 ,pre_id = 20156 ,next_id = 20158 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 49030311 ,star1_goods = {{10108,54800}} ,star2_goods = {{10108,54800},{10101,5900}} ,star3_goods = {{10108,54800},{10101,5900},{8001002,1}} ,sweep_goods = {{10108,54800},{10101,5900}} };
get(20158) ->
	#base_dun_tower{layer = 158 ,dun_id = 20158 ,pre_id = 20157 ,next_id = 20159 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 49399876 ,star1_goods = {{10108,55200}} ,star2_goods = {{10108,55200},{10101,5900}} ,star3_goods = {{10108,55200},{10101,5900},{8001002,1}} ,sweep_goods = {{10108,55200},{10101,5900}} };
get(20159) ->
	#base_dun_tower{layer = 159 ,dun_id = 20159 ,pre_id = 20158 ,next_id = 20160 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 49677326 ,star1_goods = {{10108,55600}} ,star2_goods = {{10108,55600},{10101,6100}} ,star3_goods = {{10108,55600},{10101,6100},{8001002,1}} ,sweep_goods = {{10108,55600},{10101,6100}} };
get(20160) ->
	#base_dun_tower{layer = 160 ,dun_id = 20160 ,pre_id = 20159 ,next_id = 20161 ,star = 3 ,condition = {{1,90},{2,70},{3,50}} ,cbp = 49977790 ,star1_goods = {{10108,56000}} ,star2_goods = {{10108,56000},{10101,6100}} ,star3_goods = {{10108,56000},{10101,6100},{10106,100}} ,sweep_goods = {{10108,56000},{10101,6100},{8001002,1}} };
get(_) -> [].
get_combat_by_round(1)->{5475, 5000};
get_combat_by_round(2)->{7771, 5000};
get_combat_by_round(3)->{10067, 5000};
get_combat_by_round(4)->{12363, 5000};
get_combat_by_round(5)->{14660, 5000};
get_combat_by_round(6)->{16956, 5000};
get_combat_by_round(7)->{19252, 5000};
get_combat_by_round(8)->{24279, 5000};
get_combat_by_round(9)->{29397, 5000};
get_combat_by_round(10)->{34424, 5000};
get_combat_by_round(11)->{39451, 5000};
get_combat_by_round(12)->{44569, 5000};
get_combat_by_round(13)->{49596, 5000};
get_combat_by_round(14)->{70281, 5000};
get_combat_by_round(15)->{90966, 5000};
get_combat_by_round(16)->{111650, 5000};
get_combat_by_round(17)->{132335, 5000};
get_combat_by_round(18)->{143372, 5000};
get_combat_by_round(19)->{144759, 5000};
get_combat_by_round(20)->{146147, 5000};
get_combat_by_round(21)->{147445, 5000};
get_combat_by_round(22)->{148832, 5000};
get_combat_by_round(23)->{150220, 5000};
get_combat_by_round(24)->{151608, 5000};
get_combat_by_round(25)->{152996, 5000};
get_combat_by_round(26)->{164760, 5000};
get_combat_by_round(27)->{176524, 5000};
get_combat_by_round(28)->{188289, 5000};
get_combat_by_round(29)->{200053, 5000};
get_combat_by_round(30)->{211818, 5000};
get_combat_by_round(31)->{218565, 5000};
get_combat_by_round(32)->{220387, 5000};
get_combat_by_round(33)->{222208, 5000};
get_combat_by_round(34)->{224029, 5000};
get_combat_by_round(35)->{225851, 5000};
get_combat_by_round(36)->{227672, 5000};
get_combat_by_round(37)->{229493, 5000};
get_combat_by_round(38)->{231315, 5000};
get_combat_by_round(39)->{233136, 5000};
get_combat_by_round(40)->{234958, 5000};
get_combat_by_round(41)->{254702, 5000};
get_combat_by_round(42)->{277628, 5000};
get_combat_by_round(43)->{302437, 5000};
get_combat_by_round(44)->{480749, 5000};
get_combat_by_round(45)->{503954, 5000};
get_combat_by_round(46)->{536530, 5000};
get_combat_by_round(47)->{611157, 5000};
get_combat_by_round(48)->{711215, 5000};
get_combat_by_round(49)->{1184530, 5000};
get_combat_by_round(50)->{1323178, 5000};
get_combat_by_round(51)->{1402624, 5000};
get_combat_by_round(52)->{1974402, 5000};
get_combat_by_round(53)->{2118859, 5000};
get_combat_by_round(54)->{2278130, 5000};
get_combat_by_round(55)->{2954579, 5000};
get_combat_by_round(56)->{3131455, 5000};
get_combat_by_round(57)->{3324321, 5000};
get_combat_by_round(58)->{3525688, 5000};
get_combat_by_round(59)->{4462727, 5000};
get_combat_by_round(60)->{4591740, 5000};
get_combat_by_round(61)->{4893416, 5000};
get_combat_by_round(62)->{5108239, 5000};
get_combat_by_round(63)->{5389308, 5000};
get_combat_by_round(64)->{5533779, 5000};
get_combat_by_round(65)->{7713518, 5000};
get_combat_by_round(66)->{7995328, 5000};
get_combat_by_round(67)->{8217052, 5000};
get_combat_by_round(68)->{8488292, 5000};
get_combat_by_round(69)->{8732048, 5000};
get_combat_by_round(70)->{8877365, 5000};
get_combat_by_round(71)->{9125424, 5000};
get_combat_by_round(72)->{11733326, 5000};
get_combat_by_round(73)->{11975921, 5000};
get_combat_by_round(74)->{12387197, 5000};
get_combat_by_round(75)->{12743581, 5000};
get_combat_by_round(76)->{13000615, 5000};
get_combat_by_round(77)->{13302378, 5000};
get_combat_by_round(78)->{13645451, 5000};
get_combat_by_round(79)->{13932106, 5000};
get_combat_by_round(80)->{14215309, 5000};
get_combat_by_round(81)->{14655332, 5000};
get_combat_by_round(82)->{18344197, 5000};
get_combat_by_round(83)->{18821550, 5000};
get_combat_by_round(84)->{19358645, 5000};
get_combat_by_round(85)->{19717328, 5000};
get_combat_by_round(86)->{20245552, 5000};
get_combat_by_round(87)->{20491376, 5000};
get_combat_by_round(88)->{20897636, 5000};
get_combat_by_round(89)->{21219909, 5000};
get_combat_by_round(90)->{21672744, 5000};
get_combat_by_round(91)->{26641196, 5000};
get_combat_by_round(92)->{27115820, 5000};
get_combat_by_round(93)->{27385828, 5000};
get_combat_by_round(94)->{27670989, 5000};
get_combat_by_round(95)->{28126338, 5000};
get_combat_by_round(96)->{28376449, 5000};
get_combat_by_round(97)->{28683000, 5000};
get_combat_by_round(98)->{28958870, 5000};
get_combat_by_round(99)->{29639805, 5000};
get_combat_by_round(100)->{29971472, 5000};
get_combat_by_round(101)->{30206013, 5000};
get_combat_by_round(102)->{30490020, 5000};
get_combat_by_round(103)->{31056583, 5000};
get_combat_by_round(104)->{31329626, 5000};
get_combat_by_round(105)->{31564594, 5000};
get_combat_by_round(106)->{31830280, 5000};
get_combat_by_round(107)->{32401214, 5000};
get_combat_by_round(108)->{32673629, 5000};
get_combat_by_round(109)->{33073377, 5000};
get_combat_by_round(110)->{33384286, 5000};
get_combat_by_round(111)->{33737305, 5000};
get_combat_by_round(112)->{34016941, 5000};
get_combat_by_round(113)->{34339439, 5000};
get_combat_by_round(114)->{34712519, 5000};
get_combat_by_round(115)->{35035868, 5000};
get_combat_by_round(116)->{35317907, 5000};
get_combat_by_round(117)->{35655829, 5000};
get_combat_by_round(118)->{35996231, 5000};
get_combat_by_round(119)->{36361488, 5000};
get_combat_by_round(120)->{36701176, 5000};
get_combat_by_round(121)->{36993050, 5000};
get_combat_by_round(122)->{37325384, 5000};
get_combat_by_round(123)->{37620019, 5000};
get_combat_by_round(124)->{38020939, 5000};
get_combat_by_round(125)->{38384176, 5000};
get_combat_by_round(126)->{38735743, 5000};
get_combat_by_round(127)->{39028972, 5000};
get_combat_by_round(128)->{39422389, 5000};
get_combat_by_round(129)->{39818895, 5000};
get_combat_by_round(130)->{40150950, 5000};
get_combat_by_round(131)->{40420466, 5000};
get_combat_by_round(132)->{40802172, 5000};
get_combat_by_round(133)->{41071972, 5000};
get_combat_by_round(134)->{41412567, 5000};
get_combat_by_round(135)->{41705298, 5000};
get_combat_by_round(136)->{42039673, 5000};
get_combat_by_round(137)->{42349674, 5000};
get_combat_by_round(138)->{42696627, 5000};
get_combat_by_round(139)->{43060821, 5000};
get_combat_by_round(140)->{43400764, 5000};
get_combat_by_round(141)->{43683678, 5000};
get_combat_by_round(142)->{44049579, 5000};
get_combat_by_round(143)->{44347576, 5000};
get_combat_by_round(144)->{44674203, 5000};
get_combat_by_round(145)->{45040786, 5000};
get_combat_by_round(146)->{45325384, 5000};
get_combat_by_round(147)->{45685072, 5000};
get_combat_by_round(148)->{45949499, 5000};
get_combat_by_round(149)->{46332750, 5000};
get_combat_by_round(150)->{46706175, 5000};
get_combat_by_round(151)->{47048520, 5000};
get_combat_by_round(152)->{47379263, 5000};
get_combat_by_round(153)->{47656713, 5000};
get_combat_by_round(154)->{48097024, 5000};
get_combat_by_round(155)->{48395020, 5000};
get_combat_by_round(156)->{48747397, 5000};
get_combat_by_round(157)->{49030311, 5000};
get_combat_by_round(158)->{49399876, 5000};
get_combat_by_round(159)->{49677326, 5000};
get_combat_by_round(160)->{49977790, 5000};
get_combat_by_round(_) -> [].
