%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_consume_back_charge
	%%% @Created : 2018-01-22 14:01:53
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_consume_back_charge).
-export([get/1]).
-export([get_list_by_actType_backNum/2, get_ids_by_actType_backNum/2]).
-include("activity.hrl").
get(1) -> 
    #base_consume_back_charge{id = 1, act_type=1, charge_gold=60, back_num=1, power = 0};
get(2) -> 
    #base_consume_back_charge{id = 2, act_type=1, charge_gold=300, back_num=1, power = 0};
get(3) -> 
    #base_consume_back_charge{id = 3, act_type=1, charge_gold=500, back_num=1, power = 0};
get(4) -> 
    #base_consume_back_charge{id = 4, act_type=1, charge_gold=980, back_num=1, power = 0};
get(5) -> 
    #base_consume_back_charge{id = 5, act_type=1, charge_gold=1980, back_num=1, power = 0};
get(6) -> 
    #base_consume_back_charge{id = 6, act_type=1, charge_gold=3280, back_num=1, power = 0};
get(7) -> 
    #base_consume_back_charge{id = 7, act_type=1, charge_gold=6480, back_num=1, power = 0};
get(8) -> 
    #base_consume_back_charge{id = 8, act_type=1, charge_gold=20000, back_num=1, power = 0};
get(9) -> 
    #base_consume_back_charge{id = 9, act_type=1, charge_gold=60, back_num=2, power = 0};
get(10) -> 
    #base_consume_back_charge{id = 10, act_type=1, charge_gold=300, back_num=2, power = 0};
get(11) -> 
    #base_consume_back_charge{id = 11, act_type=1, charge_gold=500, back_num=2, power = 0};
get(12) -> 
    #base_consume_back_charge{id = 12, act_type=1, charge_gold=980, back_num=2, power = 0};
get(13) -> 
    #base_consume_back_charge{id = 13, act_type=1, charge_gold=1980, back_num=2, power = 0};
get(14) -> 
    #base_consume_back_charge{id = 14, act_type=1, charge_gold=3280, back_num=2, power = 0};
get(15) -> 
    #base_consume_back_charge{id = 15, act_type=1, charge_gold=6480, back_num=2, power = 0};
get(16) -> 
    #base_consume_back_charge{id = 16, act_type=1, charge_gold=20000, back_num=2, power = 0};
get(17) -> 
    #base_consume_back_charge{id = 17, act_type=1, charge_gold=60, back_num=3, power = 0};
get(18) -> 
    #base_consume_back_charge{id = 18, act_type=1, charge_gold=300, back_num=3, power = 0};
get(19) -> 
    #base_consume_back_charge{id = 19, act_type=1, charge_gold=500, back_num=3, power = 0};
get(20) -> 
    #base_consume_back_charge{id = 20, act_type=1, charge_gold=980, back_num=3, power = 0};
get(21) -> 
    #base_consume_back_charge{id = 21, act_type=1, charge_gold=1980, back_num=3, power = 0};
get(22) -> 
    #base_consume_back_charge{id = 22, act_type=1, charge_gold=3280, back_num=3, power = 0};
get(23) -> 
    #base_consume_back_charge{id = 23, act_type=1, charge_gold=6480, back_num=3, power = 0};
get(24) -> 
    #base_consume_back_charge{id = 24, act_type=1, charge_gold=20000, back_num=3, power = 0};
get(25) -> 
    #base_consume_back_charge{id = 25, act_type=1, charge_gold=60, back_num=4, power = 0};
get(26) -> 
    #base_consume_back_charge{id = 26, act_type=1, charge_gold=300, back_num=4, power = 0};
get(27) -> 
    #base_consume_back_charge{id = 27, act_type=1, charge_gold=500, back_num=4, power = 0};
get(28) -> 
    #base_consume_back_charge{id = 28, act_type=1, charge_gold=980, back_num=4, power = 0};
get(29) -> 
    #base_consume_back_charge{id = 29, act_type=1, charge_gold=1980, back_num=4, power = 0};
get(30) -> 
    #base_consume_back_charge{id = 30, act_type=1, charge_gold=3280, back_num=4, power = 0};
get(31) -> 
    #base_consume_back_charge{id = 31, act_type=1, charge_gold=6480, back_num=4, power = 0};
get(32) -> 
    #base_consume_back_charge{id = 32, act_type=1, charge_gold=20000, back_num=4, power = 0};
get(33) -> 
    #base_consume_back_charge{id = 33, act_type=1, charge_gold=60, back_num=5, power = 0};
get(34) -> 
    #base_consume_back_charge{id = 34, act_type=1, charge_gold=300, back_num=5, power = 0};
get(35) -> 
    #base_consume_back_charge{id = 35, act_type=1, charge_gold=500, back_num=5, power = 0};
get(36) -> 
    #base_consume_back_charge{id = 36, act_type=1, charge_gold=980, back_num=5, power = 0};
get(37) -> 
    #base_consume_back_charge{id = 37, act_type=1, charge_gold=1980, back_num=5, power = 0};
get(38) -> 
    #base_consume_back_charge{id = 38, act_type=1, charge_gold=3280, back_num=5, power = 0};
get(39) -> 
    #base_consume_back_charge{id = 39, act_type=1, charge_gold=6480, back_num=5, power = 0};
get(40) -> 
    #base_consume_back_charge{id = 40, act_type=1, charge_gold=20000, back_num=5, power = 0};
get(41) -> 
    #base_consume_back_charge{id = 41, act_type=1, charge_gold=60, back_num=6, power = 0};
get(42) -> 
    #base_consume_back_charge{id = 42, act_type=1, charge_gold=300, back_num=6, power = 0};
get(43) -> 
    #base_consume_back_charge{id = 43, act_type=1, charge_gold=500, back_num=6, power = 0};
get(44) -> 
    #base_consume_back_charge{id = 44, act_type=1, charge_gold=980, back_num=6, power = 0};
get(45) -> 
    #base_consume_back_charge{id = 45, act_type=1, charge_gold=1980, back_num=6, power = 0};
get(46) -> 
    #base_consume_back_charge{id = 46, act_type=1, charge_gold=3280, back_num=6, power = 0};
get(47) -> 
    #base_consume_back_charge{id = 47, act_type=1, charge_gold=6480, back_num=6, power = 0};
get(48) -> 
    #base_consume_back_charge{id = 48, act_type=1, charge_gold=20000, back_num=6, power = 0};
get(49) -> 
    #base_consume_back_charge{id = 49, act_type=1, charge_gold=60, back_num=7, power = 0};
get(50) -> 
    #base_consume_back_charge{id = 50, act_type=1, charge_gold=300, back_num=7, power = 0};
get(51) -> 
    #base_consume_back_charge{id = 51, act_type=1, charge_gold=500, back_num=7, power = 0};
get(52) -> 
    #base_consume_back_charge{id = 52, act_type=1, charge_gold=980, back_num=7, power = 0};
get(53) -> 
    #base_consume_back_charge{id = 53, act_type=1, charge_gold=1980, back_num=7, power = 0};
get(54) -> 
    #base_consume_back_charge{id = 54, act_type=1, charge_gold=3280, back_num=7, power = 0};
get(55) -> 
    #base_consume_back_charge{id = 55, act_type=1, charge_gold=6480, back_num=7, power = 0};
get(56) -> 
    #base_consume_back_charge{id = 56, act_type=1, charge_gold=20000, back_num=7, power = 0};
get(57) -> 
    #base_consume_back_charge{id = 57, act_type=1, charge_gold=60, back_num=8, power = 0};
get(58) -> 
    #base_consume_back_charge{id = 58, act_type=1, charge_gold=300, back_num=8, power = 0};
get(59) -> 
    #base_consume_back_charge{id = 59, act_type=1, charge_gold=500, back_num=8, power = 0};
get(60) -> 
    #base_consume_back_charge{id = 60, act_type=1, charge_gold=980, back_num=8, power = 0};
get(61) -> 
    #base_consume_back_charge{id = 61, act_type=1, charge_gold=1980, back_num=8, power = 0};
get(62) -> 
    #base_consume_back_charge{id = 62, act_type=1, charge_gold=3280, back_num=8, power = 0};
get(63) -> 
    #base_consume_back_charge{id = 63, act_type=1, charge_gold=6480, back_num=8, power = 0};
get(64) -> 
    #base_consume_back_charge{id = 64, act_type=1, charge_gold=20000, back_num=8, power = 0};
get(65) -> 
    #base_consume_back_charge{id = 65, act_type=1, charge_gold=60, back_num=9, power = 0};
get(66) -> 
    #base_consume_back_charge{id = 66, act_type=1, charge_gold=300, back_num=9, power = 0};
get(67) -> 
    #base_consume_back_charge{id = 67, act_type=1, charge_gold=500, back_num=9, power = 0};
get(68) -> 
    #base_consume_back_charge{id = 68, act_type=1, charge_gold=980, back_num=9, power = 0};
get(69) -> 
    #base_consume_back_charge{id = 69, act_type=1, charge_gold=1980, back_num=9, power = 0};
get(70) -> 
    #base_consume_back_charge{id = 70, act_type=1, charge_gold=3280, back_num=9, power = 0};
get(71) -> 
    #base_consume_back_charge{id = 71, act_type=1, charge_gold=6480, back_num=9, power = 0};
get(72) -> 
    #base_consume_back_charge{id = 72, act_type=1, charge_gold=20000, back_num=9, power = 0};
get(73) -> 
    #base_consume_back_charge{id = 73, act_type=1, charge_gold=60, back_num=10, power = 0};
get(74) -> 
    #base_consume_back_charge{id = 74, act_type=1, charge_gold=300, back_num=10, power = 0};
get(75) -> 
    #base_consume_back_charge{id = 75, act_type=1, charge_gold=500, back_num=10, power = 0};
get(76) -> 
    #base_consume_back_charge{id = 76, act_type=1, charge_gold=980, back_num=10, power = 0};
get(77) -> 
    #base_consume_back_charge{id = 77, act_type=1, charge_gold=1980, back_num=10, power = 0};
get(78) -> 
    #base_consume_back_charge{id = 78, act_type=1, charge_gold=3280, back_num=10, power = 0};
get(79) -> 
    #base_consume_back_charge{id = 79, act_type=1, charge_gold=6480, back_num=10, power = 0};
get(80) -> 
    #base_consume_back_charge{id = 80, act_type=1, charge_gold=20000, back_num=10, power = 0};
get(81) -> 
    #base_consume_back_charge{id = 81, act_type=2, charge_gold=60, back_num=1, power = 0};
get(82) -> 
    #base_consume_back_charge{id = 82, act_type=2, charge_gold=300, back_num=1, power = 0};
get(83) -> 
    #base_consume_back_charge{id = 83, act_type=2, charge_gold=600, back_num=1, power = 0};
get(84) -> 
    #base_consume_back_charge{id = 84, act_type=2, charge_gold=1280, back_num=1, power = 0};
get(85) -> 
    #base_consume_back_charge{id = 85, act_type=2, charge_gold=1980, back_num=1, power = 0};
get(86) -> 
    #base_consume_back_charge{id = 86, act_type=2, charge_gold=3280, back_num=1, power = 0};
get(87) -> 
    #base_consume_back_charge{id = 87, act_type=2, charge_gold=6480, back_num=1, power = 0};
get(88) -> 
    #base_consume_back_charge{id = 88, act_type=2, charge_gold=60, back_num=2, power = 0};
get(89) -> 
    #base_consume_back_charge{id = 89, act_type=2, charge_gold=300, back_num=2, power = 0};
get(90) -> 
    #base_consume_back_charge{id = 90, act_type=2, charge_gold=600, back_num=2, power = 0};
get(91) -> 
    #base_consume_back_charge{id = 91, act_type=2, charge_gold=1280, back_num=2, power = 0};
get(92) -> 
    #base_consume_back_charge{id = 92, act_type=2, charge_gold=1980, back_num=2, power = 0};
get(93) -> 
    #base_consume_back_charge{id = 93, act_type=2, charge_gold=3280, back_num=2, power = 0};
get(94) -> 
    #base_consume_back_charge{id = 94, act_type=2, charge_gold=6480, back_num=2, power = 0};
get(95) -> 
    #base_consume_back_charge{id = 95, act_type=2, charge_gold=60, back_num=3, power = 0};
get(96) -> 
    #base_consume_back_charge{id = 96, act_type=2, charge_gold=300, back_num=3, power = 0};
get(97) -> 
    #base_consume_back_charge{id = 97, act_type=2, charge_gold=600, back_num=3, power = 0};
get(98) -> 
    #base_consume_back_charge{id = 98, act_type=2, charge_gold=1280, back_num=3, power = 0};
get(99) -> 
    #base_consume_back_charge{id = 99, act_type=2, charge_gold=1980, back_num=3, power = 0};
get(100) -> 
    #base_consume_back_charge{id = 100, act_type=2, charge_gold=3280, back_num=3, power = 0};
get(101) -> 
    #base_consume_back_charge{id = 101, act_type=2, charge_gold=6480, back_num=3, power = 0};
get(102) -> 
    #base_consume_back_charge{id = 102, act_type=2, charge_gold=60, back_num=4, power = 0};
get(103) -> 
    #base_consume_back_charge{id = 103, act_type=2, charge_gold=300, back_num=4, power = 0};
get(104) -> 
    #base_consume_back_charge{id = 104, act_type=2, charge_gold=600, back_num=4, power = 0};
get(105) -> 
    #base_consume_back_charge{id = 105, act_type=2, charge_gold=1280, back_num=4, power = 0};
get(106) -> 
    #base_consume_back_charge{id = 106, act_type=2, charge_gold=1980, back_num=4, power = 0};
get(107) -> 
    #base_consume_back_charge{id = 107, act_type=2, charge_gold=3280, back_num=4, power = 0};
get(108) -> 
    #base_consume_back_charge{id = 108, act_type=2, charge_gold=6480, back_num=4, power = 0};
get(109) -> 
    #base_consume_back_charge{id = 109, act_type=2, charge_gold=60, back_num=5, power = 0};
get(110) -> 
    #base_consume_back_charge{id = 110, act_type=2, charge_gold=300, back_num=5, power = 0};
get(111) -> 
    #base_consume_back_charge{id = 111, act_type=2, charge_gold=600, back_num=5, power = 0};
get(112) -> 
    #base_consume_back_charge{id = 112, act_type=2, charge_gold=1280, back_num=5, power = 0};
get(113) -> 
    #base_consume_back_charge{id = 113, act_type=2, charge_gold=1980, back_num=5, power = 0};
get(114) -> 
    #base_consume_back_charge{id = 114, act_type=2, charge_gold=3280, back_num=5, power = 0};
get(115) -> 
    #base_consume_back_charge{id = 115, act_type=2, charge_gold=6480, back_num=5, power = 0};
get(116) -> 
    #base_consume_back_charge{id = 116, act_type=2, charge_gold=60, back_num=6, power = 0};
get(117) -> 
    #base_consume_back_charge{id = 117, act_type=2, charge_gold=300, back_num=6, power = 0};
get(118) -> 
    #base_consume_back_charge{id = 118, act_type=2, charge_gold=600, back_num=6, power = 0};
get(119) -> 
    #base_consume_back_charge{id = 119, act_type=2, charge_gold=1280, back_num=6, power = 0};
get(120) -> 
    #base_consume_back_charge{id = 120, act_type=2, charge_gold=1980, back_num=6, power = 0};
get(121) -> 
    #base_consume_back_charge{id = 121, act_type=2, charge_gold=3280, back_num=6, power = 0};
get(122) -> 
    #base_consume_back_charge{id = 122, act_type=2, charge_gold=6480, back_num=6, power = 0};
get(123) -> 
    #base_consume_back_charge{id = 123, act_type=2, charge_gold=60, back_num=7, power = 0};
get(124) -> 
    #base_consume_back_charge{id = 124, act_type=2, charge_gold=300, back_num=7, power = 0};
get(125) -> 
    #base_consume_back_charge{id = 125, act_type=2, charge_gold=600, back_num=7, power = 0};
get(126) -> 
    #base_consume_back_charge{id = 126, act_type=2, charge_gold=1280, back_num=7, power = 0};
get(127) -> 
    #base_consume_back_charge{id = 127, act_type=2, charge_gold=1980, back_num=7, power = 0};
get(128) -> 
    #base_consume_back_charge{id = 128, act_type=2, charge_gold=3280, back_num=7, power = 0};
get(129) -> 
    #base_consume_back_charge{id = 129, act_type=2, charge_gold=6480, back_num=7, power = 0};
get(130) -> 
    #base_consume_back_charge{id = 130, act_type=2, charge_gold=60, back_num=8, power = 0};
get(131) -> 
    #base_consume_back_charge{id = 131, act_type=2, charge_gold=300, back_num=8, power = 0};
get(132) -> 
    #base_consume_back_charge{id = 132, act_type=2, charge_gold=600, back_num=8, power = 0};
get(133) -> 
    #base_consume_back_charge{id = 133, act_type=2, charge_gold=1280, back_num=8, power = 0};
get(134) -> 
    #base_consume_back_charge{id = 134, act_type=2, charge_gold=1980, back_num=8, power = 0};
get(135) -> 
    #base_consume_back_charge{id = 135, act_type=2, charge_gold=3280, back_num=8, power = 0};
get(136) -> 
    #base_consume_back_charge{id = 136, act_type=2, charge_gold=6480, back_num=8, power = 0};
get(137) -> 
    #base_consume_back_charge{id = 137, act_type=2, charge_gold=60, back_num=9, power = 0};
get(138) -> 
    #base_consume_back_charge{id = 138, act_type=2, charge_gold=300, back_num=9, power = 0};
get(139) -> 
    #base_consume_back_charge{id = 139, act_type=2, charge_gold=600, back_num=9, power = 0};
get(140) -> 
    #base_consume_back_charge{id = 140, act_type=2, charge_gold=1280, back_num=9, power = 0};
get(141) -> 
    #base_consume_back_charge{id = 141, act_type=2, charge_gold=1980, back_num=9, power = 0};
get(142) -> 
    #base_consume_back_charge{id = 142, act_type=2, charge_gold=3280, back_num=9, power = 0};
get(143) -> 
    #base_consume_back_charge{id = 143, act_type=2, charge_gold=6480, back_num=9, power = 0};
get(144) -> 
    #base_consume_back_charge{id = 144, act_type=2, charge_gold=60, back_num=10, power = 0};
get(145) -> 
    #base_consume_back_charge{id = 145, act_type=2, charge_gold=300, back_num=10, power = 0};
get(146) -> 
    #base_consume_back_charge{id = 146, act_type=2, charge_gold=600, back_num=10, power = 0};
get(147) -> 
    #base_consume_back_charge{id = 147, act_type=2, charge_gold=1280, back_num=10, power = 0};
get(148) -> 
    #base_consume_back_charge{id = 148, act_type=2, charge_gold=1980, back_num=10, power = 0};
get(149) -> 
    #base_consume_back_charge{id = 149, act_type=2, charge_gold=3280, back_num=10, power = 0};
get(150) -> 
    #base_consume_back_charge{id = 150, act_type=2, charge_gold=6480, back_num=10, power = 0};
get(_) -> [].

get_list_by_actType_backNum(1, 1) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 2) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 3) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 4) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 5) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 6) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 7) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 8) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 9) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(1, 10) -> [60,300,500,980,1980,3280,6480,20000];
get_list_by_actType_backNum(2, 1) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 2) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 3) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 4) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 5) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 6) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 7) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 8) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 9) -> [60,300,600,1280,1980,3280,6480];
get_list_by_actType_backNum(2, 10) -> [60,300,600,1280,1980,3280,6480].
get_ids_by_actType_backNum(1, 1) -> [1,2,3,4,5,6,7,8];
get_ids_by_actType_backNum(1, 2) -> [9,10,11,12,13,14,15,16];
get_ids_by_actType_backNum(1, 3) -> [17,18,19,20,21,22,23,24];
get_ids_by_actType_backNum(1, 4) -> [25,26,27,28,29,30,31,32];
get_ids_by_actType_backNum(1, 5) -> [33,34,35,36,37,38,39,40];
get_ids_by_actType_backNum(1, 6) -> [41,42,43,44,45,46,47,48];
get_ids_by_actType_backNum(1, 7) -> [49,50,51,52,53,54,55,56];
get_ids_by_actType_backNum(1, 8) -> [57,58,59,60,61,62,63,64];
get_ids_by_actType_backNum(1, 9) -> [65,66,67,68,69,70,71,72];
get_ids_by_actType_backNum(1, 10) -> [73,74,75,76,77,78,79,80];
get_ids_by_actType_backNum(2, 1) -> [81,82,83,84,85,86,87];
get_ids_by_actType_backNum(2, 2) -> [88,89,90,91,92,93,94];
get_ids_by_actType_backNum(2, 3) -> [95,96,97,98,99,100,101];
get_ids_by_actType_backNum(2, 4) -> [102,103,104,105,106,107,108];
get_ids_by_actType_backNum(2, 5) -> [109,110,111,112,113,114,115];
get_ids_by_actType_backNum(2, 6) -> [116,117,118,119,120,121,122];
get_ids_by_actType_backNum(2, 7) -> [123,124,125,126,127,128,129];
get_ids_by_actType_backNum(2, 8) -> [130,131,132,133,134,135,136];
get_ids_by_actType_backNum(2, 9) -> [137,138,139,140,141,142,143];
get_ids_by_actType_backNum(2, 10) -> [144,145,146,147,148,149,150].
