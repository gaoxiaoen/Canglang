%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_sword_pool_upgrade
	%%% @Created : 2017-06-23 15:51:34
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_sword_pool_upgrade).
-export([get/1]).
-export([figure2lv/1]).
-include("common.hrl").
-include("sword_pool.hrl").
get(0) -> 
   #base_sword_pool{lv = 0 ,attrs = [],figure = 10001 ,exp = 10 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(1) -> 
   #base_sword_pool{lv = 1 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 10 ,goods = {{2606001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(2) -> 
   #base_sword_pool{lv = 2 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 10 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(3) -> 
   #base_sword_pool{lv = 3 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 10 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(4) -> 
   #base_sword_pool{lv = 4 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 10 ,goods = {{2602001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(5) -> 
   #base_sword_pool{lv = 5 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{2607001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(6) -> 
   #base_sword_pool{lv = 6 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{2604001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(7) -> 
   #base_sword_pool{lv = 7 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{2605001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(8) -> 
   #base_sword_pool{lv = 8 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{2608001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(9) -> 
   #base_sword_pool{lv = 9 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{2603001,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(10) -> 
   #base_sword_pool{lv = 10 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(11) -> 
   #base_sword_pool{lv = 11 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 15 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(12) -> 
   #base_sword_pool{lv = 12 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 25 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(13) -> 
   #base_sword_pool{lv = 13 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 30 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(14) -> 
   #base_sword_pool{lv = 14 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10001 ,exp = 30 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(15) -> 
   #base_sword_pool{lv = 15 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 35 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(16) -> 
   #base_sword_pool{lv = 16 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 35 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(17) -> 
   #base_sword_pool{lv = 17 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 35 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(18) -> 
   #base_sword_pool{lv = 18 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 35 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(19) -> 
   #base_sword_pool{lv = 19 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 35 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(20) -> 
   #base_sword_pool{lv = 20 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 40 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(21) -> 
   #base_sword_pool{lv = 21 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 40 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(22) -> 
   #base_sword_pool{lv = 22 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 40 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(23) -> 
   #base_sword_pool{lv = 23 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 40 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(24) -> 
   #base_sword_pool{lv = 24 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 40 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(25) -> 
   #base_sword_pool{lv = 25 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 45 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(26) -> 
   #base_sword_pool{lv = 26 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 45 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(27) -> 
   #base_sword_pool{lv = 27 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 45 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(28) -> 
   #base_sword_pool{lv = 28 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 45 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(29) -> 
   #base_sword_pool{lv = 29 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10002 ,exp = 45 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(30) -> 
   #base_sword_pool{lv = 30 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 50 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(31) -> 
   #base_sword_pool{lv = 31 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 50 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(32) -> 
   #base_sword_pool{lv = 32 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 50 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(33) -> 
   #base_sword_pool{lv = 33 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 50 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(34) -> 
   #base_sword_pool{lv = 34 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 50 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(35) -> 
   #base_sword_pool{lv = 35 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 55 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(36) -> 
   #base_sword_pool{lv = 36 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 55 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(37) -> 
   #base_sword_pool{lv = 37 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 55 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(38) -> 
   #base_sword_pool{lv = 38 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 55 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(39) -> 
   #base_sword_pool{lv = 39 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 55 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(40) -> 
   #base_sword_pool{lv = 40 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 60 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(41) -> 
   #base_sword_pool{lv = 41 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 60 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(42) -> 
   #base_sword_pool{lv = 42 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 60 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(43) -> 
   #base_sword_pool{lv = 43 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 60 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(44) -> 
   #base_sword_pool{lv = 44 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 60 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(45) -> 
   #base_sword_pool{lv = 45 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 65 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(46) -> 
   #base_sword_pool{lv = 46 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 65 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(47) -> 
   #base_sword_pool{lv = 47 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 65 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(48) -> 
   #base_sword_pool{lv = 48 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 65 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(49) -> 
   #base_sword_pool{lv = 49 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10003 ,exp = 65 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(50) -> 
   #base_sword_pool{lv = 50 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 70 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(51) -> 
   #base_sword_pool{lv = 51 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 70 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(52) -> 
   #base_sword_pool{lv = 52 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 70 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(53) -> 
   #base_sword_pool{lv = 53 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 70 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(54) -> 
   #base_sword_pool{lv = 54 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 70 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(55) -> 
   #base_sword_pool{lv = 55 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 75 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(56) -> 
   #base_sword_pool{lv = 56 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 75 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(57) -> 
   #base_sword_pool{lv = 57 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 75 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(58) -> 
   #base_sword_pool{lv = 58 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 75 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(59) -> 
   #base_sword_pool{lv = 59 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 75 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(60) -> 
   #base_sword_pool{lv = 60 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 80 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(61) -> 
   #base_sword_pool{lv = 61 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 80 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(62) -> 
   #base_sword_pool{lv = 62 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 80 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(63) -> 
   #base_sword_pool{lv = 63 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 80 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(64) -> 
   #base_sword_pool{lv = 64 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 80 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(65) -> 
   #base_sword_pool{lv = 65 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 85 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(66) -> 
   #base_sword_pool{lv = 66 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 85 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(67) -> 
   #base_sword_pool{lv = 67 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 85 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(68) -> 
   #base_sword_pool{lv = 68 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 85 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(69) -> 
   #base_sword_pool{lv = 69 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 85 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(70) -> 
   #base_sword_pool{lv = 70 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 90 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(71) -> 
   #base_sword_pool{lv = 71 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 90 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(72) -> 
   #base_sword_pool{lv = 72 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 90 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(73) -> 
   #base_sword_pool{lv = 73 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 90 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(74) -> 
   #base_sword_pool{lv = 74 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10004 ,exp = 90 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(75) -> 
   #base_sword_pool{lv = 75 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 95 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(76) -> 
   #base_sword_pool{lv = 76 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 95 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(77) -> 
   #base_sword_pool{lv = 77 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 95 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(78) -> 
   #base_sword_pool{lv = 78 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 95 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(79) -> 
   #base_sword_pool{lv = 79 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 95 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(80) -> 
   #base_sword_pool{lv = 80 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 100 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(81) -> 
   #base_sword_pool{lv = 81 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 100 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(82) -> 
   #base_sword_pool{lv = 82 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 100 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(83) -> 
   #base_sword_pool{lv = 83 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 100 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(84) -> 
   #base_sword_pool{lv = 84 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 100 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(85) -> 
   #base_sword_pool{lv = 85 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 105 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(86) -> 
   #base_sword_pool{lv = 86 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 105 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(87) -> 
   #base_sword_pool{lv = 87 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 105 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(88) -> 
   #base_sword_pool{lv = 88 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 105 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(89) -> 
   #base_sword_pool{lv = 89 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 105 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(90) -> 
   #base_sword_pool{lv = 90 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 110 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(91) -> 
   #base_sword_pool{lv = 91 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 110 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(92) -> 
   #base_sword_pool{lv = 92 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 110 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(93) -> 
   #base_sword_pool{lv = 93 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 110 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(94) -> 
   #base_sword_pool{lv = 94 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 110 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(95) -> 
   #base_sword_pool{lv = 95 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 115 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(96) -> 
   #base_sword_pool{lv = 96 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 115 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(97) -> 
   #base_sword_pool{lv = 97 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 115 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(98) -> 
   #base_sword_pool{lv = 98 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 115 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(99) -> 
   #base_sword_pool{lv = 99 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10005 ,exp = 115 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(100) -> 
   #base_sword_pool{lv = 100 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 120 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(101) -> 
   #base_sword_pool{lv = 101 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 120 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(102) -> 
   #base_sword_pool{lv = 102 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 120 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(103) -> 
   #base_sword_pool{lv = 103 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 120 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(104) -> 
   #base_sword_pool{lv = 104 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 120 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(105) -> 
   #base_sword_pool{lv = 105 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 125 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(106) -> 
   #base_sword_pool{lv = 106 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 125 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(107) -> 
   #base_sword_pool{lv = 107 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 125 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(108) -> 
   #base_sword_pool{lv = 108 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 125 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(109) -> 
   #base_sword_pool{lv = 109 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 125 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(110) -> 
   #base_sword_pool{lv = 110 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 130 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(111) -> 
   #base_sword_pool{lv = 111 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 130 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(112) -> 
   #base_sword_pool{lv = 112 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 130 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(113) -> 
   #base_sword_pool{lv = 113 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 130 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(114) -> 
   #base_sword_pool{lv = 114 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 130 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(115) -> 
   #base_sword_pool{lv = 115 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 135 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(116) -> 
   #base_sword_pool{lv = 116 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 135 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(117) -> 
   #base_sword_pool{lv = 117 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 135 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(118) -> 
   #base_sword_pool{lv = 118 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 135 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(119) -> 
   #base_sword_pool{lv = 119 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 135 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(120) -> 
   #base_sword_pool{lv = 120 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 140 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(121) -> 
   #base_sword_pool{lv = 121 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 140 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(122) -> 
   #base_sword_pool{lv = 122 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 140 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(123) -> 
   #base_sword_pool{lv = 123 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 140 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(124) -> 
   #base_sword_pool{lv = 124 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 140 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(125) -> 
   #base_sword_pool{lv = 125 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 145 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(126) -> 
   #base_sword_pool{lv = 126 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 145 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(127) -> 
   #base_sword_pool{lv = 127 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 145 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(128) -> 
   #base_sword_pool{lv = 128 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 145 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(129) -> 
   #base_sword_pool{lv = 129 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 145 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(130) -> 
   #base_sword_pool{lv = 130 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 150 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(131) -> 
   #base_sword_pool{lv = 131 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 150 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(132) -> 
   #base_sword_pool{lv = 132 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 150 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(133) -> 
   #base_sword_pool{lv = 133 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 150 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(134) -> 
   #base_sword_pool{lv = 134 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 150 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(135) -> 
   #base_sword_pool{lv = 135 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 155 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(136) -> 
   #base_sword_pool{lv = 136 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 155 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(137) -> 
   #base_sword_pool{lv = 137 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 155 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(138) -> 
   #base_sword_pool{lv = 138 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 155 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(139) -> 
   #base_sword_pool{lv = 139 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 155 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(140) -> 
   #base_sword_pool{lv = 140 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 160 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(141) -> 
   #base_sword_pool{lv = 141 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 160 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(142) -> 
   #base_sword_pool{lv = 142 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 160 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(143) -> 
   #base_sword_pool{lv = 143 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 160 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(144) -> 
   #base_sword_pool{lv = 144 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 160 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(145) -> 
   #base_sword_pool{lv = 145 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 165 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(146) -> 
   #base_sword_pool{lv = 146 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 165 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(147) -> 
   #base_sword_pool{lv = 147 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 165 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(148) -> 
   #base_sword_pool{lv = 148 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 165 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(149) -> 
   #base_sword_pool{lv = 149 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 165 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(150) -> 
   #base_sword_pool{lv = 150 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 170 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(151) -> 
   #base_sword_pool{lv = 151 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 170 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(152) -> 
   #base_sword_pool{lv = 152 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 170 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(153) -> 
   #base_sword_pool{lv = 153 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 170 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(154) -> 
   #base_sword_pool{lv = 154 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 170 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(155) -> 
   #base_sword_pool{lv = 155 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 175 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(156) -> 
   #base_sword_pool{lv = 156 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 175 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(157) -> 
   #base_sword_pool{lv = 157 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 175 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(158) -> 
   #base_sword_pool{lv = 158 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 175 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(159) -> 
   #base_sword_pool{lv = 159 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 175 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(160) -> 
   #base_sword_pool{lv = 160 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 180 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(161) -> 
   #base_sword_pool{lv = 161 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 180 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(162) -> 
   #base_sword_pool{lv = 162 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 180 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(163) -> 
   #base_sword_pool{lv = 163 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 180 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(164) -> 
   #base_sword_pool{lv = 164 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 180 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(165) -> 
   #base_sword_pool{lv = 165 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 185 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(166) -> 
   #base_sword_pool{lv = 166 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 185 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(167) -> 
   #base_sword_pool{lv = 167 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 185 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(168) -> 
   #base_sword_pool{lv = 168 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 185 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(169) -> 
   #base_sword_pool{lv = 169 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 185 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(170) -> 
   #base_sword_pool{lv = 170 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 190 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(171) -> 
   #base_sword_pool{lv = 171 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 190 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(172) -> 
   #base_sword_pool{lv = 172 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 190 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(173) -> 
   #base_sword_pool{lv = 173 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 190 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(174) -> 
   #base_sword_pool{lv = 174 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 190 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(175) -> 
   #base_sword_pool{lv = 175 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 195 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(176) -> 
   #base_sword_pool{lv = 176 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 195 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(177) -> 
   #base_sword_pool{lv = 177 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 195 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(178) -> 
   #base_sword_pool{lv = 178 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 195 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(179) -> 
   #base_sword_pool{lv = 179 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10006 ,exp = 195 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(180) -> 
   #base_sword_pool{lv = 180 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 200 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(181) -> 
   #base_sword_pool{lv = 181 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 200 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(182) -> 
   #base_sword_pool{lv = 182 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 200 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(183) -> 
   #base_sword_pool{lv = 183 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 200 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(184) -> 
   #base_sword_pool{lv = 184 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 200 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(185) -> 
   #base_sword_pool{lv = 185 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 205 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(186) -> 
   #base_sword_pool{lv = 186 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 205 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(187) -> 
   #base_sword_pool{lv = 187 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 205 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(188) -> 
   #base_sword_pool{lv = 188 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 205 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(189) -> 
   #base_sword_pool{lv = 189 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 205 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(190) -> 
   #base_sword_pool{lv = 190 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 210 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(191) -> 
   #base_sword_pool{lv = 191 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 210 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(192) -> 
   #base_sword_pool{lv = 192 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 210 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(193) -> 
   #base_sword_pool{lv = 193 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 210 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(194) -> 
   #base_sword_pool{lv = 194 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 210 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(195) -> 
   #base_sword_pool{lv = 195 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 215 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(196) -> 
   #base_sword_pool{lv = 196 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 215 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(197) -> 
   #base_sword_pool{lv = 197 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 215 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(198) -> 
   #base_sword_pool{lv = 198 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 215 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(199) -> 
   #base_sword_pool{lv = 199 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 215 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(200) -> 
   #base_sword_pool{lv = 200 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 220 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(201) -> 
   #base_sword_pool{lv = 201 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 220 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(202) -> 
   #base_sword_pool{lv = 202 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 220 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(203) -> 
   #base_sword_pool{lv = 203 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 220 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(204) -> 
   #base_sword_pool{lv = 204 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 220 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(205) -> 
   #base_sword_pool{lv = 205 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 225 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(206) -> 
   #base_sword_pool{lv = 206 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 225 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(207) -> 
   #base_sword_pool{lv = 207 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 225 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(208) -> 
   #base_sword_pool{lv = 208 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 225 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(209) -> 
   #base_sword_pool{lv = 209 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 225 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(210) -> 
   #base_sword_pool{lv = 210 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 230 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(211) -> 
   #base_sword_pool{lv = 211 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 230 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(212) -> 
   #base_sword_pool{lv = 212 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 230 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(213) -> 
   #base_sword_pool{lv = 213 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 230 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(214) -> 
   #base_sword_pool{lv = 214 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 230 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(215) -> 
   #base_sword_pool{lv = 215 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 235 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(216) -> 
   #base_sword_pool{lv = 216 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 235 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(217) -> 
   #base_sword_pool{lv = 217 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 235 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(218) -> 
   #base_sword_pool{lv = 218 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 235 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(219) -> 
   #base_sword_pool{lv = 219 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 235 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(220) -> 
   #base_sword_pool{lv = 220 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 240 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(221) -> 
   #base_sword_pool{lv = 221 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 240 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(222) -> 
   #base_sword_pool{lv = 222 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 240 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(223) -> 
   #base_sword_pool{lv = 223 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 240 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(224) -> 
   #base_sword_pool{lv = 224 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 240 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(225) -> 
   #base_sword_pool{lv = 225 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 245 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(226) -> 
   #base_sword_pool{lv = 226 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 245 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(227) -> 
   #base_sword_pool{lv = 227 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 245 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(228) -> 
   #base_sword_pool{lv = 228 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 245 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(229) -> 
   #base_sword_pool{lv = 229 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 245 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(230) -> 
   #base_sword_pool{lv = 230 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 250 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(231) -> 
   #base_sword_pool{lv = 231 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 250 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(232) -> 
   #base_sword_pool{lv = 232 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 250 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(233) -> 
   #base_sword_pool{lv = 233 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 250 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(234) -> 
   #base_sword_pool{lv = 234 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 250 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(235) -> 
   #base_sword_pool{lv = 235 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 255 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(236) -> 
   #base_sword_pool{lv = 236 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 255 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(237) -> 
   #base_sword_pool{lv = 237 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 255 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(238) -> 
   #base_sword_pool{lv = 238 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 255 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(239) -> 
   #base_sword_pool{lv = 239 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 255 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(240) -> 
   #base_sword_pool{lv = 240 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(241) -> 
   #base_sword_pool{lv = 241 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(242) -> 
   #base_sword_pool{lv = 242 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(243) -> 
   #base_sword_pool{lv = 243 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(244) -> 
   #base_sword_pool{lv = 244 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(245) -> 
   #base_sword_pool{lv = 245 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(246) -> 
   #base_sword_pool{lv = 246 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(247) -> 
   #base_sword_pool{lv = 247 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(248) -> 
   #base_sword_pool{lv = 248 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(249) -> 
   #base_sword_pool{lv = 249 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(250) -> 
   #base_sword_pool{lv = 250 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(251) -> 
   #base_sword_pool{lv = 251 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(252) -> 
   #base_sword_pool{lv = 252 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(253) -> 
   #base_sword_pool{lv = 253 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(254) -> 
   #base_sword_pool{lv = 254 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(255) -> 
   #base_sword_pool{lv = 255 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(256) -> 
   #base_sword_pool{lv = 256 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(257) -> 
   #base_sword_pool{lv = 257 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(258) -> 
   #base_sword_pool{lv = 258 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(259) -> 
   #base_sword_pool{lv = 259 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(260) -> 
   #base_sword_pool{lv = 260 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(261) -> 
   #base_sword_pool{lv = 261 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(262) -> 
   #base_sword_pool{lv = 262 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(263) -> 
   #base_sword_pool{lv = 263 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(264) -> 
   #base_sword_pool{lv = 264 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(265) -> 
   #base_sword_pool{lv = 265 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(266) -> 
   #base_sword_pool{lv = 266 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(267) -> 
   #base_sword_pool{lv = 267 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(268) -> 
   #base_sword_pool{lv = 268 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(269) -> 
   #base_sword_pool{lv = 269 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(270) -> 
   #base_sword_pool{lv = 270 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(271) -> 
   #base_sword_pool{lv = 271 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(272) -> 
   #base_sword_pool{lv = 272 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(273) -> 
   #base_sword_pool{lv = 273 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(274) -> 
   #base_sword_pool{lv = 274 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(275) -> 
   #base_sword_pool{lv = 275 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(276) -> 
   #base_sword_pool{lv = 276 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(277) -> 
   #base_sword_pool{lv = 277 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(278) -> 
   #base_sword_pool{lv = 278 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(279) -> 
   #base_sword_pool{lv = 279 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10007 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(280) -> 
   #base_sword_pool{lv = 280 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(281) -> 
   #base_sword_pool{lv = 281 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(282) -> 
   #base_sword_pool{lv = 282 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(283) -> 
   #base_sword_pool{lv = 283 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(284) -> 
   #base_sword_pool{lv = 284 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(285) -> 
   #base_sword_pool{lv = 285 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(286) -> 
   #base_sword_pool{lv = 286 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(287) -> 
   #base_sword_pool{lv = 287 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(288) -> 
   #base_sword_pool{lv = 288 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(289) -> 
   #base_sword_pool{lv = 289 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(290) -> 
   #base_sword_pool{lv = 290 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(291) -> 
   #base_sword_pool{lv = 291 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(292) -> 
   #base_sword_pool{lv = 292 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(293) -> 
   #base_sword_pool{lv = 293 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(294) -> 
   #base_sword_pool{lv = 294 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(295) -> 
   #base_sword_pool{lv = 295 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(296) -> 
   #base_sword_pool{lv = 296 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(297) -> 
   #base_sword_pool{lv = 297 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(298) -> 
   #base_sword_pool{lv = 298 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(299) -> 
   #base_sword_pool{lv = 299 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(300) -> 
   #base_sword_pool{lv = 300 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(301) -> 
   #base_sword_pool{lv = 301 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(302) -> 
   #base_sword_pool{lv = 302 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(303) -> 
   #base_sword_pool{lv = 303 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(304) -> 
   #base_sword_pool{lv = 304 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(305) -> 
   #base_sword_pool{lv = 305 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(306) -> 
   #base_sword_pool{lv = 306 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(307) -> 
   #base_sword_pool{lv = 307 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(308) -> 
   #base_sword_pool{lv = 308 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(309) -> 
   #base_sword_pool{lv = 309 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(310) -> 
   #base_sword_pool{lv = 310 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(311) -> 
   #base_sword_pool{lv = 311 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(312) -> 
   #base_sword_pool{lv = 312 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(313) -> 
   #base_sword_pool{lv = 313 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(314) -> 
   #base_sword_pool{lv = 314 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(315) -> 
   #base_sword_pool{lv = 315 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(316) -> 
   #base_sword_pool{lv = 316 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(317) -> 
   #base_sword_pool{lv = 317 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(318) -> 
   #base_sword_pool{lv = 318 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(319) -> 
   #base_sword_pool{lv = 319 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(320) -> 
   #base_sword_pool{lv = 320 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(321) -> 
   #base_sword_pool{lv = 321 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(322) -> 
   #base_sword_pool{lv = 322 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(323) -> 
   #base_sword_pool{lv = 323 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(324) -> 
   #base_sword_pool{lv = 324 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(325) -> 
   #base_sword_pool{lv = 325 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(326) -> 
   #base_sword_pool{lv = 326 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(327) -> 
   #base_sword_pool{lv = 327 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(328) -> 
   #base_sword_pool{lv = 328 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(329) -> 
   #base_sword_pool{lv = 329 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(330) -> 
   #base_sword_pool{lv = 330 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(331) -> 
   #base_sword_pool{lv = 331 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(332) -> 
   #base_sword_pool{lv = 332 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(333) -> 
   #base_sword_pool{lv = 333 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(334) -> 
   #base_sword_pool{lv = 334 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(335) -> 
   #base_sword_pool{lv = 335 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(336) -> 
   #base_sword_pool{lv = 336 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(337) -> 
   #base_sword_pool{lv = 337 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(338) -> 
   #base_sword_pool{lv = 338 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(339) -> 
   #base_sword_pool{lv = 339 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(340) -> 
   #base_sword_pool{lv = 340 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(341) -> 
   #base_sword_pool{lv = 341 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(342) -> 
   #base_sword_pool{lv = 342 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(343) -> 
   #base_sword_pool{lv = 343 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(344) -> 
   #base_sword_pool{lv = 344 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(345) -> 
   #base_sword_pool{lv = 345 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(346) -> 
   #base_sword_pool{lv = 346 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(347) -> 
   #base_sword_pool{lv = 347 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(348) -> 
   #base_sword_pool{lv = 348 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(349) -> 
   #base_sword_pool{lv = 349 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(350) -> 
   #base_sword_pool{lv = 350 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(351) -> 
   #base_sword_pool{lv = 351 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(352) -> 
   #base_sword_pool{lv = 352 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(353) -> 
   #base_sword_pool{lv = 353 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(354) -> 
   #base_sword_pool{lv = 354 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(355) -> 
   #base_sword_pool{lv = 355 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(356) -> 
   #base_sword_pool{lv = 356 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(357) -> 
   #base_sword_pool{lv = 357 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(358) -> 
   #base_sword_pool{lv = 358 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(359) -> 
   #base_sword_pool{lv = 359 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(360) -> 
   #base_sword_pool{lv = 360 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(361) -> 
   #base_sword_pool{lv = 361 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(362) -> 
   #base_sword_pool{lv = 362 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(363) -> 
   #base_sword_pool{lv = 363 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(364) -> 
   #base_sword_pool{lv = 364 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(365) -> 
   #base_sword_pool{lv = 365 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(366) -> 
   #base_sword_pool{lv = 366 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(367) -> 
   #base_sword_pool{lv = 367 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(368) -> 
   #base_sword_pool{lv = 368 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(369) -> 
   #base_sword_pool{lv = 369 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(370) -> 
   #base_sword_pool{lv = 370 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(371) -> 
   #base_sword_pool{lv = 371 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(372) -> 
   #base_sword_pool{lv = 372 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(373) -> 
   #base_sword_pool{lv = 373 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(374) -> 
   #base_sword_pool{lv = 374 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(375) -> 
   #base_sword_pool{lv = 375 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(376) -> 
   #base_sword_pool{lv = 376 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(377) -> 
   #base_sword_pool{lv = 377 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(378) -> 
   #base_sword_pool{lv = 378 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(379) -> 
   #base_sword_pool{lv = 379 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(380) -> 
   #base_sword_pool{lv = 380 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(381) -> 
   #base_sword_pool{lv = 381 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(382) -> 
   #base_sword_pool{lv = 382 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(383) -> 
   #base_sword_pool{lv = 383 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(384) -> 
   #base_sword_pool{lv = 384 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(385) -> 
   #base_sword_pool{lv = 385 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(386) -> 
   #base_sword_pool{lv = 386 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(387) -> 
   #base_sword_pool{lv = 387 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(388) -> 
   #base_sword_pool{lv = 388 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(389) -> 
   #base_sword_pool{lv = 389 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(390) -> 
   #base_sword_pool{lv = 390 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(391) -> 
   #base_sword_pool{lv = 391 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(392) -> 
   #base_sword_pool{lv = 392 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(393) -> 
   #base_sword_pool{lv = 393 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(394) -> 
   #base_sword_pool{lv = 394 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(395) -> 
   #base_sword_pool{lv = 395 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(396) -> 
   #base_sword_pool{lv = 396 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(397) -> 
   #base_sword_pool{lv = 397 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(398) -> 
   #base_sword_pool{lv = 398 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(399) -> 
   #base_sword_pool{lv = 399 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(400) -> 
   #base_sword_pool{lv = 400 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(401) -> 
   #base_sword_pool{lv = 401 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(402) -> 
   #base_sword_pool{lv = 402 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(403) -> 
   #base_sword_pool{lv = 403 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(404) -> 
   #base_sword_pool{lv = 404 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(405) -> 
   #base_sword_pool{lv = 405 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(406) -> 
   #base_sword_pool{lv = 406 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(407) -> 
   #base_sword_pool{lv = 407 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(408) -> 
   #base_sword_pool{lv = 408 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(409) -> 
   #base_sword_pool{lv = 409 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(410) -> 
   #base_sword_pool{lv = 410 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(411) -> 
   #base_sword_pool{lv = 411 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(412) -> 
   #base_sword_pool{lv = 412 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(413) -> 
   #base_sword_pool{lv = 413 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(414) -> 
   #base_sword_pool{lv = 414 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(415) -> 
   #base_sword_pool{lv = 415 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(416) -> 
   #base_sword_pool{lv = 416 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(417) -> 
   #base_sword_pool{lv = 417 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(418) -> 
   #base_sword_pool{lv = 418 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(419) -> 
   #base_sword_pool{lv = 419 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(420) -> 
   #base_sword_pool{lv = 420 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(421) -> 
   #base_sword_pool{lv = 421 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(422) -> 
   #base_sword_pool{lv = 422 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(423) -> 
   #base_sword_pool{lv = 423 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(424) -> 
   #base_sword_pool{lv = 424 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(425) -> 
   #base_sword_pool{lv = 425 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(426) -> 
   #base_sword_pool{lv = 426 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(427) -> 
   #base_sword_pool{lv = 427 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(428) -> 
   #base_sword_pool{lv = 428 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(429) -> 
   #base_sword_pool{lv = 429 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(430) -> 
   #base_sword_pool{lv = 430 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(431) -> 
   #base_sword_pool{lv = 431 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(432) -> 
   #base_sword_pool{lv = 432 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(433) -> 
   #base_sword_pool{lv = 433 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(434) -> 
   #base_sword_pool{lv = 434 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(435) -> 
   #base_sword_pool{lv = 435 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(436) -> 
   #base_sword_pool{lv = 436 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(437) -> 
   #base_sword_pool{lv = 437 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(438) -> 
   #base_sword_pool{lv = 438 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(439) -> 
   #base_sword_pool{lv = 439 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(440) -> 
   #base_sword_pool{lv = 440 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(441) -> 
   #base_sword_pool{lv = 441 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(442) -> 
   #base_sword_pool{lv = 442 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(443) -> 
   #base_sword_pool{lv = 443 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(444) -> 
   #base_sword_pool{lv = 444 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(445) -> 
   #base_sword_pool{lv = 445 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(446) -> 
   #base_sword_pool{lv = 446 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(447) -> 
   #base_sword_pool{lv = 447 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(448) -> 
   #base_sword_pool{lv = 448 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(449) -> 
   #base_sword_pool{lv = 449 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(450) -> 
   #base_sword_pool{lv = 450 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(451) -> 
   #base_sword_pool{lv = 451 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(452) -> 
   #base_sword_pool{lv = 452 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(453) -> 
   #base_sword_pool{lv = 453 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(454) -> 
   #base_sword_pool{lv = 454 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(455) -> 
   #base_sword_pool{lv = 455 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(456) -> 
   #base_sword_pool{lv = 456 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(457) -> 
   #base_sword_pool{lv = 457 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(458) -> 
   #base_sword_pool{lv = 458 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(459) -> 
   #base_sword_pool{lv = 459 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(460) -> 
   #base_sword_pool{lv = 460 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(461) -> 
   #base_sword_pool{lv = 461 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(462) -> 
   #base_sword_pool{lv = 462 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(463) -> 
   #base_sword_pool{lv = 463 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(464) -> 
   #base_sword_pool{lv = 464 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(465) -> 
   #base_sword_pool{lv = 465 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(466) -> 
   #base_sword_pool{lv = 466 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(467) -> 
   #base_sword_pool{lv = 467 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(468) -> 
   #base_sword_pool{lv = 468 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(469) -> 
   #base_sword_pool{lv = 469 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(470) -> 
   #base_sword_pool{lv = 470 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(471) -> 
   #base_sword_pool{lv = 471 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(472) -> 
   #base_sword_pool{lv = 472 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(473) -> 
   #base_sword_pool{lv = 473 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(474) -> 
   #base_sword_pool{lv = 474 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(475) -> 
   #base_sword_pool{lv = 475 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(476) -> 
   #base_sword_pool{lv = 476 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(477) -> 
   #base_sword_pool{lv = 477 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(478) -> 
   #base_sword_pool{lv = 478 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(479) -> 
   #base_sword_pool{lv = 479 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(480) -> 
   #base_sword_pool{lv = 480 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(481) -> 
   #base_sword_pool{lv = 481 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(482) -> 
   #base_sword_pool{lv = 482 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(483) -> 
   #base_sword_pool{lv = 483 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(484) -> 
   #base_sword_pool{lv = 484 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(485) -> 
   #base_sword_pool{lv = 485 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(486) -> 
   #base_sword_pool{lv = 486 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(487) -> 
   #base_sword_pool{lv = 487 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(488) -> 
   #base_sword_pool{lv = 488 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(489) -> 
   #base_sword_pool{lv = 489 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(490) -> 
   #base_sword_pool{lv = 490 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(491) -> 
   #base_sword_pool{lv = 491 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(492) -> 
   #base_sword_pool{lv = 492 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(493) -> 
   #base_sword_pool{lv = 493 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(494) -> 
   #base_sword_pool{lv = 494 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(495) -> 
   #base_sword_pool{lv = 495 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(496) -> 
   #base_sword_pool{lv = 496 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(497) -> 
   #base_sword_pool{lv = 497 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(498) -> 
   #base_sword_pool{lv = 498 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(499) -> 
   #base_sword_pool{lv = 499 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(500) -> 
   #base_sword_pool{lv = 500 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(501) -> 
   #base_sword_pool{lv = 501 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(502) -> 
   #base_sword_pool{lv = 502 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(503) -> 
   #base_sword_pool{lv = 503 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(504) -> 
   #base_sword_pool{lv = 504 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(505) -> 
   #base_sword_pool{lv = 505 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(506) -> 
   #base_sword_pool{lv = 506 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(507) -> 
   #base_sword_pool{lv = 507 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(508) -> 
   #base_sword_pool{lv = 508 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(509) -> 
   #base_sword_pool{lv = 509 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(510) -> 
   #base_sword_pool{lv = 510 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(511) -> 
   #base_sword_pool{lv = 511 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(512) -> 
   #base_sword_pool{lv = 512 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(513) -> 
   #base_sword_pool{lv = 513 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(514) -> 
   #base_sword_pool{lv = 514 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(515) -> 
   #base_sword_pool{lv = 515 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(516) -> 
   #base_sword_pool{lv = 516 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(517) -> 
   #base_sword_pool{lv = 517 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(518) -> 
   #base_sword_pool{lv = 518 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(519) -> 
   #base_sword_pool{lv = 519 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(520) -> 
   #base_sword_pool{lv = 520 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(521) -> 
   #base_sword_pool{lv = 521 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(522) -> 
   #base_sword_pool{lv = 522 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(523) -> 
   #base_sword_pool{lv = 523 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(524) -> 
   #base_sword_pool{lv = 524 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(525) -> 
   #base_sword_pool{lv = 525 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(526) -> 
   #base_sword_pool{lv = 526 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(527) -> 
   #base_sword_pool{lv = 527 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(528) -> 
   #base_sword_pool{lv = 528 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(529) -> 
   #base_sword_pool{lv = 529 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(530) -> 
   #base_sword_pool{lv = 530 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(531) -> 
   #base_sword_pool{lv = 531 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(532) -> 
   #base_sword_pool{lv = 532 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(533) -> 
   #base_sword_pool{lv = 533 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(534) -> 
   #base_sword_pool{lv = 534 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(535) -> 
   #base_sword_pool{lv = 535 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(536) -> 
   #base_sword_pool{lv = 536 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(537) -> 
   #base_sword_pool{lv = 537 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(538) -> 
   #base_sword_pool{lv = 538 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(539) -> 
   #base_sword_pool{lv = 539 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(540) -> 
   #base_sword_pool{lv = 540 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(541) -> 
   #base_sword_pool{lv = 541 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(542) -> 
   #base_sword_pool{lv = 542 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(543) -> 
   #base_sword_pool{lv = 543 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(544) -> 
   #base_sword_pool{lv = 544 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(545) -> 
   #base_sword_pool{lv = 545 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(546) -> 
   #base_sword_pool{lv = 546 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(547) -> 
   #base_sword_pool{lv = 547 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(548) -> 
   #base_sword_pool{lv = 548 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(549) -> 
   #base_sword_pool{lv = 549 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(550) -> 
   #base_sword_pool{lv = 550 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(551) -> 
   #base_sword_pool{lv = 551 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(552) -> 
   #base_sword_pool{lv = 552 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(553) -> 
   #base_sword_pool{lv = 553 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(554) -> 
   #base_sword_pool{lv = 554 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(555) -> 
   #base_sword_pool{lv = 555 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(556) -> 
   #base_sword_pool{lv = 556 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(557) -> 
   #base_sword_pool{lv = 557 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(558) -> 
   #base_sword_pool{lv = 558 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(559) -> 
   #base_sword_pool{lv = 559 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(560) -> 
   #base_sword_pool{lv = 560 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(561) -> 
   #base_sword_pool{lv = 561 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(562) -> 
   #base_sword_pool{lv = 562 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(563) -> 
   #base_sword_pool{lv = 563 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(564) -> 
   #base_sword_pool{lv = 564 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(565) -> 
   #base_sword_pool{lv = 565 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(566) -> 
   #base_sword_pool{lv = 566 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(567) -> 
   #base_sword_pool{lv = 567 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(568) -> 
   #base_sword_pool{lv = 568 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(569) -> 
   #base_sword_pool{lv = 569 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(570) -> 
   #base_sword_pool{lv = 570 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(571) -> 
   #base_sword_pool{lv = 571 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(572) -> 
   #base_sword_pool{lv = 572 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(573) -> 
   #base_sword_pool{lv = 573 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(574) -> 
   #base_sword_pool{lv = 574 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(575) -> 
   #base_sword_pool{lv = 575 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(576) -> 
   #base_sword_pool{lv = 576 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(577) -> 
   #base_sword_pool{lv = 577 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(578) -> 
   #base_sword_pool{lv = 578 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(579) -> 
   #base_sword_pool{lv = 579 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(580) -> 
   #base_sword_pool{lv = 580 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(581) -> 
   #base_sword_pool{lv = 581 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(582) -> 
   #base_sword_pool{lv = 582 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(583) -> 
   #base_sword_pool{lv = 583 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(584) -> 
   #base_sword_pool{lv = 584 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(585) -> 
   #base_sword_pool{lv = 585 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(586) -> 
   #base_sword_pool{lv = 586 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(587) -> 
   #base_sword_pool{lv = 587 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(588) -> 
   #base_sword_pool{lv = 588 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(589) -> 
   #base_sword_pool{lv = 589 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(590) -> 
   #base_sword_pool{lv = 590 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(591) -> 
   #base_sword_pool{lv = 591 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(592) -> 
   #base_sword_pool{lv = 592 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(593) -> 
   #base_sword_pool{lv = 593 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(594) -> 
   #base_sword_pool{lv = 594 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(595) -> 
   #base_sword_pool{lv = 595 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(596) -> 
   #base_sword_pool{lv = 596 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(597) -> 
   #base_sword_pool{lv = 597 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(598) -> 
   #base_sword_pool{lv = 598 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(599) -> 
   #base_sword_pool{lv = 599 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(600) -> 
   #base_sword_pool{lv = 600 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(601) -> 
   #base_sword_pool{lv = 601 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(602) -> 
   #base_sword_pool{lv = 602 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(603) -> 
   #base_sword_pool{lv = 603 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(604) -> 
   #base_sword_pool{lv = 604 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(605) -> 
   #base_sword_pool{lv = 605 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(606) -> 
   #base_sword_pool{lv = 606 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(607) -> 
   #base_sword_pool{lv = 607 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(608) -> 
   #base_sword_pool{lv = 608 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(609) -> 
   #base_sword_pool{lv = 609 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(610) -> 
   #base_sword_pool{lv = 610 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(611) -> 
   #base_sword_pool{lv = 611 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(612) -> 
   #base_sword_pool{lv = 612 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(613) -> 
   #base_sword_pool{lv = 613 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(614) -> 
   #base_sword_pool{lv = 614 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(615) -> 
   #base_sword_pool{lv = 615 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(616) -> 
   #base_sword_pool{lv = 616 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(617) -> 
   #base_sword_pool{lv = 617 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(618) -> 
   #base_sword_pool{lv = 618 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(619) -> 
   #base_sword_pool{lv = 619 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(620) -> 
   #base_sword_pool{lv = 620 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(621) -> 
   #base_sword_pool{lv = 621 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(622) -> 
   #base_sword_pool{lv = 622 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(623) -> 
   #base_sword_pool{lv = 623 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(624) -> 
   #base_sword_pool{lv = 624 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(625) -> 
   #base_sword_pool{lv = 625 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(626) -> 
   #base_sword_pool{lv = 626 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(627) -> 
   #base_sword_pool{lv = 627 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(628) -> 
   #base_sword_pool{lv = 628 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(629) -> 
   #base_sword_pool{lv = 629 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(630) -> 
   #base_sword_pool{lv = 630 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(631) -> 
   #base_sword_pool{lv = 631 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(632) -> 
   #base_sword_pool{lv = 632 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(633) -> 
   #base_sword_pool{lv = 633 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(634) -> 
   #base_sword_pool{lv = 634 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(635) -> 
   #base_sword_pool{lv = 635 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(636) -> 
   #base_sword_pool{lv = 636 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(637) -> 
   #base_sword_pool{lv = 637 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(638) -> 
   #base_sword_pool{lv = 638 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(639) -> 
   #base_sword_pool{lv = 639 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(640) -> 
   #base_sword_pool{lv = 640 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(641) -> 
   #base_sword_pool{lv = 641 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(642) -> 
   #base_sword_pool{lv = 642 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(643) -> 
   #base_sword_pool{lv = 643 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(644) -> 
   #base_sword_pool{lv = 644 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(645) -> 
   #base_sword_pool{lv = 645 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(646) -> 
   #base_sword_pool{lv = 646 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(647) -> 
   #base_sword_pool{lv = 647 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(648) -> 
   #base_sword_pool{lv = 648 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(649) -> 
   #base_sword_pool{lv = 649 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(650) -> 
   #base_sword_pool{lv = 650 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(651) -> 
   #base_sword_pool{lv = 651 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(652) -> 
   #base_sword_pool{lv = 652 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(653) -> 
   #base_sword_pool{lv = 653 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(654) -> 
   #base_sword_pool{lv = 654 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(655) -> 
   #base_sword_pool{lv = 655 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(656) -> 
   #base_sword_pool{lv = 656 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(657) -> 
   #base_sword_pool{lv = 657 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(658) -> 
   #base_sword_pool{lv = 658 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(659) -> 
   #base_sword_pool{lv = 659 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(660) -> 
   #base_sword_pool{lv = 660 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(661) -> 
   #base_sword_pool{lv = 661 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(662) -> 
   #base_sword_pool{lv = 662 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(663) -> 
   #base_sword_pool{lv = 663 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(664) -> 
   #base_sword_pool{lv = 664 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(665) -> 
   #base_sword_pool{lv = 665 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(666) -> 
   #base_sword_pool{lv = 666 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(667) -> 
   #base_sword_pool{lv = 667 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(668) -> 
   #base_sword_pool{lv = 668 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(669) -> 
   #base_sword_pool{lv = 669 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(670) -> 
   #base_sword_pool{lv = 670 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(671) -> 
   #base_sword_pool{lv = 671 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(672) -> 
   #base_sword_pool{lv = 672 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(673) -> 
   #base_sword_pool{lv = 673 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(674) -> 
   #base_sword_pool{lv = 674 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(675) -> 
   #base_sword_pool{lv = 675 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(676) -> 
   #base_sword_pool{lv = 676 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(677) -> 
   #base_sword_pool{lv = 677 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(678) -> 
   #base_sword_pool{lv = 678 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(679) -> 
   #base_sword_pool{lv = 679 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(680) -> 
   #base_sword_pool{lv = 680 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(681) -> 
   #base_sword_pool{lv = 681 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(682) -> 
   #base_sword_pool{lv = 682 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(683) -> 
   #base_sword_pool{lv = 683 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(684) -> 
   #base_sword_pool{lv = 684 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(685) -> 
   #base_sword_pool{lv = 685 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(686) -> 
   #base_sword_pool{lv = 686 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(687) -> 
   #base_sword_pool{lv = 687 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(688) -> 
   #base_sword_pool{lv = 688 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(689) -> 
   #base_sword_pool{lv = 689 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(690) -> 
   #base_sword_pool{lv = 690 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(691) -> 
   #base_sword_pool{lv = 691 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(692) -> 
   #base_sword_pool{lv = 692 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(693) -> 
   #base_sword_pool{lv = 693 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(694) -> 
   #base_sword_pool{lv = 694 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(695) -> 
   #base_sword_pool{lv = 695 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(696) -> 
   #base_sword_pool{lv = 696 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(697) -> 
   #base_sword_pool{lv = 697 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(698) -> 
   #base_sword_pool{lv = 698 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(699) -> 
   #base_sword_pool{lv = 699 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(700) -> 
   #base_sword_pool{lv = 700 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(701) -> 
   #base_sword_pool{lv = 701 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(702) -> 
   #base_sword_pool{lv = 702 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(703) -> 
   #base_sword_pool{lv = 703 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(704) -> 
   #base_sword_pool{lv = 704 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(705) -> 
   #base_sword_pool{lv = 705 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(706) -> 
   #base_sword_pool{lv = 706 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(707) -> 
   #base_sword_pool{lv = 707 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(708) -> 
   #base_sword_pool{lv = 708 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(709) -> 
   #base_sword_pool{lv = 709 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(710) -> 
   #base_sword_pool{lv = 710 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(711) -> 
   #base_sword_pool{lv = 711 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(712) -> 
   #base_sword_pool{lv = 712 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(713) -> 
   #base_sword_pool{lv = 713 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(714) -> 
   #base_sword_pool{lv = 714 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(715) -> 
   #base_sword_pool{lv = 715 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(716) -> 
   #base_sword_pool{lv = 716 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(717) -> 
   #base_sword_pool{lv = 717 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(718) -> 
   #base_sword_pool{lv = 718 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(719) -> 
   #base_sword_pool{lv = 719 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(720) -> 
   #base_sword_pool{lv = 720 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(721) -> 
   #base_sword_pool{lv = 721 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(722) -> 
   #base_sword_pool{lv = 722 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(723) -> 
   #base_sword_pool{lv = 723 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(724) -> 
   #base_sword_pool{lv = 724 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(725) -> 
   #base_sword_pool{lv = 725 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(726) -> 
   #base_sword_pool{lv = 726 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(727) -> 
   #base_sword_pool{lv = 727 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(728) -> 
   #base_sword_pool{lv = 728 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(729) -> 
   #base_sword_pool{lv = 729 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(730) -> 
   #base_sword_pool{lv = 730 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(731) -> 
   #base_sword_pool{lv = 731 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(732) -> 
   #base_sword_pool{lv = 732 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(733) -> 
   #base_sword_pool{lv = 733 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(734) -> 
   #base_sword_pool{lv = 734 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(735) -> 
   #base_sword_pool{lv = 735 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(736) -> 
   #base_sword_pool{lv = 736 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(737) -> 
   #base_sword_pool{lv = 737 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(738) -> 
   #base_sword_pool{lv = 738 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(739) -> 
   #base_sword_pool{lv = 739 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(740) -> 
   #base_sword_pool{lv = 740 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(741) -> 
   #base_sword_pool{lv = 741 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(742) -> 
   #base_sword_pool{lv = 742 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(743) -> 
   #base_sword_pool{lv = 743 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(744) -> 
   #base_sword_pool{lv = 744 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(745) -> 
   #base_sword_pool{lv = 745 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(746) -> 
   #base_sword_pool{lv = 746 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(747) -> 
   #base_sword_pool{lv = 747 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(748) -> 
   #base_sword_pool{lv = 748 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(749) -> 
   #base_sword_pool{lv = 749 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(750) -> 
   #base_sword_pool{lv = 750 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(751) -> 
   #base_sword_pool{lv = 751 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(752) -> 
   #base_sword_pool{lv = 752 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(753) -> 
   #base_sword_pool{lv = 753 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(754) -> 
   #base_sword_pool{lv = 754 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(755) -> 
   #base_sword_pool{lv = 755 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(756) -> 
   #base_sword_pool{lv = 756 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(757) -> 
   #base_sword_pool{lv = 757 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(758) -> 
   #base_sword_pool{lv = 758 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(759) -> 
   #base_sword_pool{lv = 759 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(760) -> 
   #base_sword_pool{lv = 760 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(761) -> 
   #base_sword_pool{lv = 761 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(762) -> 
   #base_sword_pool{lv = 762 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(763) -> 
   #base_sword_pool{lv = 763 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(764) -> 
   #base_sword_pool{lv = 764 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(765) -> 
   #base_sword_pool{lv = 765 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(766) -> 
   #base_sword_pool{lv = 766 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(767) -> 
   #base_sword_pool{lv = 767 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(768) -> 
   #base_sword_pool{lv = 768 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(769) -> 
   #base_sword_pool{lv = 769 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(770) -> 
   #base_sword_pool{lv = 770 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(771) -> 
   #base_sword_pool{lv = 771 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(772) -> 
   #base_sword_pool{lv = 772 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(773) -> 
   #base_sword_pool{lv = 773 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(774) -> 
   #base_sword_pool{lv = 774 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(775) -> 
   #base_sword_pool{lv = 775 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(776) -> 
   #base_sword_pool{lv = 776 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(777) -> 
   #base_sword_pool{lv = 777 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(778) -> 
   #base_sword_pool{lv = 778 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(779) -> 
   #base_sword_pool{lv = 779 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(780) -> 
   #base_sword_pool{lv = 780 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(781) -> 
   #base_sword_pool{lv = 781 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(782) -> 
   #base_sword_pool{lv = 782 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(783) -> 
   #base_sword_pool{lv = 783 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(784) -> 
   #base_sword_pool{lv = 784 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(785) -> 
   #base_sword_pool{lv = 785 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(786) -> 
   #base_sword_pool{lv = 786 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(787) -> 
   #base_sword_pool{lv = 787 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(788) -> 
   #base_sword_pool{lv = 788 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(789) -> 
   #base_sword_pool{lv = 789 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(790) -> 
   #base_sword_pool{lv = 790 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(791) -> 
   #base_sword_pool{lv = 791 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(792) -> 
   #base_sword_pool{lv = 792 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(793) -> 
   #base_sword_pool{lv = 793 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(794) -> 
   #base_sword_pool{lv = 794 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(795) -> 
   #base_sword_pool{lv = 795 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(796) -> 
   #base_sword_pool{lv = 796 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(797) -> 
   #base_sword_pool{lv = 797 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(798) -> 
   #base_sword_pool{lv = 798 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(799) -> 
   #base_sword_pool{lv = 799 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(800) -> 
   #base_sword_pool{lv = 800 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(801) -> 
   #base_sword_pool{lv = 801 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(802) -> 
   #base_sword_pool{lv = 802 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(803) -> 
   #base_sword_pool{lv = 803 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(804) -> 
   #base_sword_pool{lv = 804 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(805) -> 
   #base_sword_pool{lv = 805 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(806) -> 
   #base_sword_pool{lv = 806 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(807) -> 
   #base_sword_pool{lv = 807 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(808) -> 
   #base_sword_pool{lv = 808 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(809) -> 
   #base_sword_pool{lv = 809 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(810) -> 
   #base_sword_pool{lv = 810 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(811) -> 
   #base_sword_pool{lv = 811 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(812) -> 
   #base_sword_pool{lv = 812 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(813) -> 
   #base_sword_pool{lv = 813 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(814) -> 
   #base_sword_pool{lv = 814 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(815) -> 
   #base_sword_pool{lv = 815 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(816) -> 
   #base_sword_pool{lv = 816 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(817) -> 
   #base_sword_pool{lv = 817 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(818) -> 
   #base_sword_pool{lv = 818 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(819) -> 
   #base_sword_pool{lv = 819 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(820) -> 
   #base_sword_pool{lv = 820 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(821) -> 
   #base_sword_pool{lv = 821 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(822) -> 
   #base_sword_pool{lv = 822 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(823) -> 
   #base_sword_pool{lv = 823 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(824) -> 
   #base_sword_pool{lv = 824 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(825) -> 
   #base_sword_pool{lv = 825 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(826) -> 
   #base_sword_pool{lv = 826 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(827) -> 
   #base_sword_pool{lv = 827 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(828) -> 
   #base_sword_pool{lv = 828 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(829) -> 
   #base_sword_pool{lv = 829 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(830) -> 
   #base_sword_pool{lv = 830 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(831) -> 
   #base_sword_pool{lv = 831 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(832) -> 
   #base_sword_pool{lv = 832 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(833) -> 
   #base_sword_pool{lv = 833 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(834) -> 
   #base_sword_pool{lv = 834 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(835) -> 
   #base_sword_pool{lv = 835 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(836) -> 
   #base_sword_pool{lv = 836 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(837) -> 
   #base_sword_pool{lv = 837 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(838) -> 
   #base_sword_pool{lv = 838 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(839) -> 
   #base_sword_pool{lv = 839 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(840) -> 
   #base_sword_pool{lv = 840 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(841) -> 
   #base_sword_pool{lv = 841 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(842) -> 
   #base_sword_pool{lv = 842 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(843) -> 
   #base_sword_pool{lv = 843 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(844) -> 
   #base_sword_pool{lv = 844 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(845) -> 
   #base_sword_pool{lv = 845 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(846) -> 
   #base_sword_pool{lv = 846 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(847) -> 
   #base_sword_pool{lv = 847 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(848) -> 
   #base_sword_pool{lv = 848 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(849) -> 
   #base_sword_pool{lv = 849 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(850) -> 
   #base_sword_pool{lv = 850 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(851) -> 
   #base_sword_pool{lv = 851 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(852) -> 
   #base_sword_pool{lv = 852 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(853) -> 
   #base_sword_pool{lv = 853 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(854) -> 
   #base_sword_pool{lv = 854 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(855) -> 
   #base_sword_pool{lv = 855 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(856) -> 
   #base_sword_pool{lv = 856 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(857) -> 
   #base_sword_pool{lv = 857 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(858) -> 
   #base_sword_pool{lv = 858 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(859) -> 
   #base_sword_pool{lv = 859 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(860) -> 
   #base_sword_pool{lv = 860 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(861) -> 
   #base_sword_pool{lv = 861 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(862) -> 
   #base_sword_pool{lv = 862 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(863) -> 
   #base_sword_pool{lv = 863 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(864) -> 
   #base_sword_pool{lv = 864 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(865) -> 
   #base_sword_pool{lv = 865 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(866) -> 
   #base_sword_pool{lv = 866 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(867) -> 
   #base_sword_pool{lv = 867 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(868) -> 
   #base_sword_pool{lv = 868 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(869) -> 
   #base_sword_pool{lv = 869 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(870) -> 
   #base_sword_pool{lv = 870 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(871) -> 
   #base_sword_pool{lv = 871 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(872) -> 
   #base_sword_pool{lv = 872 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(873) -> 
   #base_sword_pool{lv = 873 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(874) -> 
   #base_sword_pool{lv = 874 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(875) -> 
   #base_sword_pool{lv = 875 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(876) -> 
   #base_sword_pool{lv = 876 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(877) -> 
   #base_sword_pool{lv = 877 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(878) -> 
   #base_sword_pool{lv = 878 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(879) -> 
   #base_sword_pool{lv = 879 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(880) -> 
   #base_sword_pool{lv = 880 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(881) -> 
   #base_sword_pool{lv = 881 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(882) -> 
   #base_sword_pool{lv = 882 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(883) -> 
   #base_sword_pool{lv = 883 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(884) -> 
   #base_sword_pool{lv = 884 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(885) -> 
   #base_sword_pool{lv = 885 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(886) -> 
   #base_sword_pool{lv = 886 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(887) -> 
   #base_sword_pool{lv = 887 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(888) -> 
   #base_sword_pool{lv = 888 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(889) -> 
   #base_sword_pool{lv = 889 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(890) -> 
   #base_sword_pool{lv = 890 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(891) -> 
   #base_sword_pool{lv = 891 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(892) -> 
   #base_sword_pool{lv = 892 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(893) -> 
   #base_sword_pool{lv = 893 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(894) -> 
   #base_sword_pool{lv = 894 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(895) -> 
   #base_sword_pool{lv = 895 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(896) -> 
   #base_sword_pool{lv = 896 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(897) -> 
   #base_sword_pool{lv = 897 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(898) -> 
   #base_sword_pool{lv = 898 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(899) -> 
   #base_sword_pool{lv = 899 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(900) -> 
   #base_sword_pool{lv = 900 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(901) -> 
   #base_sword_pool{lv = 901 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(902) -> 
   #base_sword_pool{lv = 902 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(903) -> 
   #base_sword_pool{lv = 903 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(904) -> 
   #base_sword_pool{lv = 904 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(905) -> 
   #base_sword_pool{lv = 905 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(906) -> 
   #base_sword_pool{lv = 906 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(907) -> 
   #base_sword_pool{lv = 907 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(908) -> 
   #base_sword_pool{lv = 908 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(909) -> 
   #base_sword_pool{lv = 909 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(910) -> 
   #base_sword_pool{lv = 910 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(911) -> 
   #base_sword_pool{lv = 911 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(912) -> 
   #base_sword_pool{lv = 912 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(913) -> 
   #base_sword_pool{lv = 913 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(914) -> 
   #base_sword_pool{lv = 914 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(915) -> 
   #base_sword_pool{lv = 915 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(916) -> 
   #base_sword_pool{lv = 916 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(917) -> 
   #base_sword_pool{lv = 917 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(918) -> 
   #base_sword_pool{lv = 918 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(919) -> 
   #base_sword_pool{lv = 919 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(920) -> 
   #base_sword_pool{lv = 920 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(921) -> 
   #base_sword_pool{lv = 921 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(922) -> 
   #base_sword_pool{lv = 922 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(923) -> 
   #base_sword_pool{lv = 923 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(924) -> 
   #base_sword_pool{lv = 924 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(925) -> 
   #base_sword_pool{lv = 925 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(926) -> 
   #base_sword_pool{lv = 926 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(927) -> 
   #base_sword_pool{lv = 927 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(928) -> 
   #base_sword_pool{lv = 928 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(929) -> 
   #base_sword_pool{lv = 929 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(930) -> 
   #base_sword_pool{lv = 930 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(931) -> 
   #base_sword_pool{lv = 931 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(932) -> 
   #base_sword_pool{lv = 932 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(933) -> 
   #base_sword_pool{lv = 933 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(934) -> 
   #base_sword_pool{lv = 934 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(935) -> 
   #base_sword_pool{lv = 935 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(936) -> 
   #base_sword_pool{lv = 936 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(937) -> 
   #base_sword_pool{lv = 937 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(938) -> 
   #base_sword_pool{lv = 938 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(939) -> 
   #base_sword_pool{lv = 939 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(940) -> 
   #base_sword_pool{lv = 940 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(941) -> 
   #base_sword_pool{lv = 941 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(942) -> 
   #base_sword_pool{lv = 942 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(943) -> 
   #base_sword_pool{lv = 943 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(944) -> 
   #base_sword_pool{lv = 944 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(945) -> 
   #base_sword_pool{lv = 945 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(946) -> 
   #base_sword_pool{lv = 946 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(947) -> 
   #base_sword_pool{lv = 947 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(948) -> 
   #base_sword_pool{lv = 948 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(949) -> 
   #base_sword_pool{lv = 949 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(950) -> 
   #base_sword_pool{lv = 950 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(951) -> 
   #base_sword_pool{lv = 951 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(952) -> 
   #base_sword_pool{lv = 952 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(953) -> 
   #base_sword_pool{lv = 953 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(954) -> 
   #base_sword_pool{lv = 954 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(955) -> 
   #base_sword_pool{lv = 955 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(956) -> 
   #base_sword_pool{lv = 956 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(957) -> 
   #base_sword_pool{lv = 957 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(958) -> 
   #base_sword_pool{lv = 958 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(959) -> 
   #base_sword_pool{lv = 959 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(960) -> 
   #base_sword_pool{lv = 960 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(961) -> 
   #base_sword_pool{lv = 961 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(962) -> 
   #base_sword_pool{lv = 962 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(963) -> 
   #base_sword_pool{lv = 963 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(964) -> 
   #base_sword_pool{lv = 964 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(965) -> 
   #base_sword_pool{lv = 965 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(966) -> 
   #base_sword_pool{lv = 966 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(967) -> 
   #base_sword_pool{lv = 967 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(968) -> 
   #base_sword_pool{lv = 968 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(969) -> 
   #base_sword_pool{lv = 969 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(970) -> 
   #base_sword_pool{lv = 970 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(971) -> 
   #base_sword_pool{lv = 971 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(972) -> 
   #base_sword_pool{lv = 972 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(973) -> 
   #base_sword_pool{lv = 973 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(974) -> 
   #base_sword_pool{lv = 974 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(975) -> 
   #base_sword_pool{lv = 975 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(976) -> 
   #base_sword_pool{lv = 976 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(977) -> 
   #base_sword_pool{lv = 977 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(978) -> 
   #base_sword_pool{lv = 978 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(979) -> 
   #base_sword_pool{lv = 979 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(980) -> 
   #base_sword_pool{lv = 980 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(981) -> 
   #base_sword_pool{lv = 981 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(982) -> 
   #base_sword_pool{lv = 982 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(983) -> 
   #base_sword_pool{lv = 983 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(984) -> 
   #base_sword_pool{lv = 984 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(985) -> 
   #base_sword_pool{lv = 985 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(986) -> 
   #base_sword_pool{lv = 986 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(987) -> 
   #base_sword_pool{lv = 987 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(988) -> 
   #base_sword_pool{lv = 988 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(989) -> 
   #base_sword_pool{lv = 989 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(990) -> 
   #base_sword_pool{lv = 990 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(991) -> 
   #base_sword_pool{lv = 991 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(992) -> 
   #base_sword_pool{lv = 992 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(993) -> 
   #base_sword_pool{lv = 993 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3701000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(994) -> 
   #base_sword_pool{lv = 994 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3101000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(995) -> 
   #base_sword_pool{lv = 995 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3201000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(996) -> 
   #base_sword_pool{lv = 996 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3301000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(997) -> 
   #base_sword_pool{lv = 997 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3401000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(998) -> 
   #base_sword_pool{lv = 998 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3501000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(999) -> 
   #base_sword_pool{lv = 999 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 260 ,goods = {{3601000,1},{10106,10}} ,exp_daily = 0 ,goods_daily = {}};
get(1000) -> 
   #base_sword_pool{lv = 1000 ,attrs = [{att,20},{def,10},{hp_lim,200}],figure = 10008 ,exp = 0 ,goods = {} ,exp_daily = 0 ,goods_daily = {}};
get(_) -> [].


figure2lv(10001)->0;
figure2lv(10002)->15;
figure2lv(10003)->30;
figure2lv(10004)->50;
figure2lv(10005)->75;
figure2lv(10006)->100;
figure2lv(10007)->180;
figure2lv(10008)->280;
figure2lv(_) -> [].
