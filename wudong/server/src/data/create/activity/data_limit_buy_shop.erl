%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_limit_buy_shop
	%%% @Created : 2018-03-26 20:12:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_limit_buy_shop).
-export([get/1, get/3, get_all/0, get_time_by_type/1, get_ids_by_type/1]).
-include("activity.hrl").
get(1) -> 
    #base_limit_buy_shop{id = 1, time=12, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(2) -> 
    #base_limit_buy_shop{id = 2, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(3) -> 
    #base_limit_buy_shop{id = 3, time=12, goods_id=8001203, goods_num=10, price1 = 200, price2 = 180, buy_num = 5,  sys_buy_num = 100, type = 1};
get(4) -> 
    #base_limit_buy_shop{id = 4, time=12, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(5) -> 
    #base_limit_buy_shop{id = 5, time=12, goods_id=3303000, goods_num=10, price1 = 100, price2 = 90, buy_num = 5,  sys_buy_num = 100, type = 1};
get(6) -> 
    #base_limit_buy_shop{id = 6, time=12, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(7) -> 
    #base_limit_buy_shop{id = 7, time=14, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(8) -> 
    #base_limit_buy_shop{id = 8, time=14, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(9) -> 
    #base_limit_buy_shop{id = 9, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 200, buy_num = 5,  sys_buy_num = 100, type = 1};
get(10) -> 
    #base_limit_buy_shop{id = 10, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 5,  sys_buy_num = 100, type = 1};
get(11) -> 
    #base_limit_buy_shop{id = 11, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 85, buy_num = 5,  sys_buy_num = 100, type = 1};
get(12) -> 
    #base_limit_buy_shop{id = 12, time=14, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(13) -> 
    #base_limit_buy_shop{id = 13, time=16, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(14) -> 
    #base_limit_buy_shop{id = 14, time=16, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(15) -> 
    #base_limit_buy_shop{id = 15, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(16) -> 
    #base_limit_buy_shop{id = 16, time=16, goods_id=1010005, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(17) -> 
    #base_limit_buy_shop{id = 17, time=16, goods_id=20340, goods_num=5, price1 = 75, price2 = 66, buy_num = 5,  sys_buy_num = 100, type = 1};
get(18) -> 
    #base_limit_buy_shop{id = 18, time=16, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(19) -> 
    #base_limit_buy_shop{id = 19, time=18, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(20) -> 
    #base_limit_buy_shop{id = 20, time=18, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(21) -> 
    #base_limit_buy_shop{id = 21, time=18, goods_id=8001203, goods_num=10, price1 = 200, price2 = 180, buy_num = 5,  sys_buy_num = 100, type = 1};
get(22) -> 
    #base_limit_buy_shop{id = 22, time=18, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(23) -> 
    #base_limit_buy_shop{id = 23, time=18, goods_id=3303000, goods_num=10, price1 = 100, price2 = 90, buy_num = 5,  sys_buy_num = 100, type = 1};
get(24) -> 
    #base_limit_buy_shop{id = 24, time=18, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(25) -> 
    #base_limit_buy_shop{id = 25, time=20, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(26) -> 
    #base_limit_buy_shop{id = 26, time=20, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(27) -> 
    #base_limit_buy_shop{id = 27, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 200, buy_num = 5,  sys_buy_num = 100, type = 1};
get(28) -> 
    #base_limit_buy_shop{id = 28, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 5,  sys_buy_num = 100, type = 1};
get(29) -> 
    #base_limit_buy_shop{id = 29, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 85, buy_num = 5,  sys_buy_num = 100, type = 1};
get(30) -> 
    #base_limit_buy_shop{id = 30, time=20, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(31) -> 
    #base_limit_buy_shop{id = 31, time=22, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(32) -> 
    #base_limit_buy_shop{id = 32, time=22, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(33) -> 
    #base_limit_buy_shop{id = 33, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(34) -> 
    #base_limit_buy_shop{id = 34, time=22, goods_id=1010005, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(35) -> 
    #base_limit_buy_shop{id = 35, time=22, goods_id=20340, goods_num=5, price1 = 75, price2 = 66, buy_num = 5,  sys_buy_num = 100, type = 1};
get(36) -> 
    #base_limit_buy_shop{id = 36, time=22, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(37) -> 
    #base_limit_buy_shop{id = 37, time=12, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(38) -> 
    #base_limit_buy_shop{id = 38, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(39) -> 
    #base_limit_buy_shop{id = 39, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 2};
get(40) -> 
    #base_limit_buy_shop{id = 40, time=12, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 2};
get(41) -> 
    #base_limit_buy_shop{id = 41, time=12, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 2};
get(42) -> 
    #base_limit_buy_shop{id = 42, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(43) -> 
    #base_limit_buy_shop{id = 43, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(44) -> 
    #base_limit_buy_shop{id = 44, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(45) -> 
    #base_limit_buy_shop{id = 45, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(46) -> 
    #base_limit_buy_shop{id = 46, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(47) -> 
    #base_limit_buy_shop{id = 47, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(48) -> 
    #base_limit_buy_shop{id = 48, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(49) -> 
    #base_limit_buy_shop{id = 49, time=16, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(50) -> 
    #base_limit_buy_shop{id = 50, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(51) -> 
    #base_limit_buy_shop{id = 51, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(52) -> 
    #base_limit_buy_shop{id = 52, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(53) -> 
    #base_limit_buy_shop{id = 53, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(54) -> 
    #base_limit_buy_shop{id = 54, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 2};
get(55) -> 
    #base_limit_buy_shop{id = 55, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(56) -> 
    #base_limit_buy_shop{id = 56, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(57) -> 
    #base_limit_buy_shop{id = 57, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 2};
get(58) -> 
    #base_limit_buy_shop{id = 58, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 2};
get(59) -> 
    #base_limit_buy_shop{id = 59, time=18, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 2};
get(60) -> 
    #base_limit_buy_shop{id = 60, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(61) -> 
    #base_limit_buy_shop{id = 61, time=20, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(62) -> 
    #base_limit_buy_shop{id = 62, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(63) -> 
    #base_limit_buy_shop{id = 63, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(64) -> 
    #base_limit_buy_shop{id = 64, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(65) -> 
    #base_limit_buy_shop{id = 65, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(66) -> 
    #base_limit_buy_shop{id = 66, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 2};
get(67) -> 
    #base_limit_buy_shop{id = 67, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(68) -> 
    #base_limit_buy_shop{id = 68, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(69) -> 
    #base_limit_buy_shop{id = 69, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(70) -> 
    #base_limit_buy_shop{id = 70, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(71) -> 
    #base_limit_buy_shop{id = 71, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 2};
get(72) -> 
    #base_limit_buy_shop{id = 72, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(73) -> 
    #base_limit_buy_shop{id = 73, time=12, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(74) -> 
    #base_limit_buy_shop{id = 74, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(75) -> 
    #base_limit_buy_shop{id = 75, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 3};
get(76) -> 
    #base_limit_buy_shop{id = 76, time=12, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 3};
get(77) -> 
    #base_limit_buy_shop{id = 77, time=12, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 3};
get(78) -> 
    #base_limit_buy_shop{id = 78, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(79) -> 
    #base_limit_buy_shop{id = 79, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(80) -> 
    #base_limit_buy_shop{id = 80, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(81) -> 
    #base_limit_buy_shop{id = 81, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(82) -> 
    #base_limit_buy_shop{id = 82, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(83) -> 
    #base_limit_buy_shop{id = 83, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(84) -> 
    #base_limit_buy_shop{id = 84, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(85) -> 
    #base_limit_buy_shop{id = 85, time=16, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(86) -> 
    #base_limit_buy_shop{id = 86, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(87) -> 
    #base_limit_buy_shop{id = 87, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(88) -> 
    #base_limit_buy_shop{id = 88, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(89) -> 
    #base_limit_buy_shop{id = 89, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(90) -> 
    #base_limit_buy_shop{id = 90, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 3};
get(91) -> 
    #base_limit_buy_shop{id = 91, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(92) -> 
    #base_limit_buy_shop{id = 92, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(93) -> 
    #base_limit_buy_shop{id = 93, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 3};
get(94) -> 
    #base_limit_buy_shop{id = 94, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 3};
get(95) -> 
    #base_limit_buy_shop{id = 95, time=18, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 3};
get(96) -> 
    #base_limit_buy_shop{id = 96, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(97) -> 
    #base_limit_buy_shop{id = 97, time=20, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(98) -> 
    #base_limit_buy_shop{id = 98, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(99) -> 
    #base_limit_buy_shop{id = 99, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(100) -> 
    #base_limit_buy_shop{id = 100, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(101) -> 
    #base_limit_buy_shop{id = 101, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(102) -> 
    #base_limit_buy_shop{id = 102, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 3};
get(103) -> 
    #base_limit_buy_shop{id = 103, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(104) -> 
    #base_limit_buy_shop{id = 104, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(105) -> 
    #base_limit_buy_shop{id = 105, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(106) -> 
    #base_limit_buy_shop{id = 106, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(107) -> 
    #base_limit_buy_shop{id = 107, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 3};
get(108) -> 
    #base_limit_buy_shop{id = 108, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(109) -> 
    #base_limit_buy_shop{id = 109, time=12, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(110) -> 
    #base_limit_buy_shop{id = 110, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(111) -> 
    #base_limit_buy_shop{id = 111, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 4};
get(112) -> 
    #base_limit_buy_shop{id = 112, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 4};
get(113) -> 
    #base_limit_buy_shop{id = 113, time=12, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 4};
get(114) -> 
    #base_limit_buy_shop{id = 114, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(115) -> 
    #base_limit_buy_shop{id = 115, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(116) -> 
    #base_limit_buy_shop{id = 116, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(117) -> 
    #base_limit_buy_shop{id = 117, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(118) -> 
    #base_limit_buy_shop{id = 118, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(119) -> 
    #base_limit_buy_shop{id = 119, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(120) -> 
    #base_limit_buy_shop{id = 120, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(121) -> 
    #base_limit_buy_shop{id = 121, time=16, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(122) -> 
    #base_limit_buy_shop{id = 122, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(123) -> 
    #base_limit_buy_shop{id = 123, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(124) -> 
    #base_limit_buy_shop{id = 124, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(125) -> 
    #base_limit_buy_shop{id = 125, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(126) -> 
    #base_limit_buy_shop{id = 126, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 4};
get(127) -> 
    #base_limit_buy_shop{id = 127, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(128) -> 
    #base_limit_buy_shop{id = 128, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(129) -> 
    #base_limit_buy_shop{id = 129, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 4};
get(130) -> 
    #base_limit_buy_shop{id = 130, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 4};
get(131) -> 
    #base_limit_buy_shop{id = 131, time=18, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 4};
get(132) -> 
    #base_limit_buy_shop{id = 132, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(133) -> 
    #base_limit_buy_shop{id = 133, time=20, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(134) -> 
    #base_limit_buy_shop{id = 134, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(135) -> 
    #base_limit_buy_shop{id = 135, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(136) -> 
    #base_limit_buy_shop{id = 136, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(137) -> 
    #base_limit_buy_shop{id = 137, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(138) -> 
    #base_limit_buy_shop{id = 138, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 4};
get(139) -> 
    #base_limit_buy_shop{id = 139, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(140) -> 
    #base_limit_buy_shop{id = 140, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(141) -> 
    #base_limit_buy_shop{id = 141, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(142) -> 
    #base_limit_buy_shop{id = 142, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(143) -> 
    #base_limit_buy_shop{id = 143, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 4};
get(144) -> 
    #base_limit_buy_shop{id = 144, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(145) -> 
    #base_limit_buy_shop{id = 145, time=12, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(146) -> 
    #base_limit_buy_shop{id = 146, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(147) -> 
    #base_limit_buy_shop{id = 147, time=12, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 5};
get(148) -> 
    #base_limit_buy_shop{id = 148, time=12, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 5};
get(149) -> 
    #base_limit_buy_shop{id = 149, time=12, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 5};
get(150) -> 
    #base_limit_buy_shop{id = 150, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(151) -> 
    #base_limit_buy_shop{id = 151, time=14, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(152) -> 
    #base_limit_buy_shop{id = 152, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(153) -> 
    #base_limit_buy_shop{id = 153, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(154) -> 
    #base_limit_buy_shop{id = 154, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(155) -> 
    #base_limit_buy_shop{id = 155, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(156) -> 
    #base_limit_buy_shop{id = 156, time=14, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(157) -> 
    #base_limit_buy_shop{id = 157, time=16, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(158) -> 
    #base_limit_buy_shop{id = 158, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(159) -> 
    #base_limit_buy_shop{id = 159, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(160) -> 
    #base_limit_buy_shop{id = 160, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(161) -> 
    #base_limit_buy_shop{id = 161, time=16, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(162) -> 
    #base_limit_buy_shop{id = 162, time=16, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 5};
get(163) -> 
    #base_limit_buy_shop{id = 163, time=18, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(164) -> 
    #base_limit_buy_shop{id = 164, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(165) -> 
    #base_limit_buy_shop{id = 165, time=18, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 5};
get(166) -> 
    #base_limit_buy_shop{id = 166, time=18, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 5};
get(167) -> 
    #base_limit_buy_shop{id = 167, time=18, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 5};
get(168) -> 
    #base_limit_buy_shop{id = 168, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(169) -> 
    #base_limit_buy_shop{id = 169, time=20, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(170) -> 
    #base_limit_buy_shop{id = 170, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(171) -> 
    #base_limit_buy_shop{id = 171, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(172) -> 
    #base_limit_buy_shop{id = 172, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(173) -> 
    #base_limit_buy_shop{id = 173, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(174) -> 
    #base_limit_buy_shop{id = 174, time=20, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(175) -> 
    #base_limit_buy_shop{id = 175, time=22, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(176) -> 
    #base_limit_buy_shop{id = 176, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(177) -> 
    #base_limit_buy_shop{id = 177, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(178) -> 
    #base_limit_buy_shop{id = 178, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(179) -> 
    #base_limit_buy_shop{id = 179, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 5};
get(180) -> 
    #base_limit_buy_shop{id = 180, time=22, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 5};
get(181) -> 
    #base_limit_buy_shop{id = 181, time=12, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(182) -> 
    #base_limit_buy_shop{id = 182, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(183) -> 
    #base_limit_buy_shop{id = 183, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 6};
get(184) -> 
    #base_limit_buy_shop{id = 184, time=12, goods_id=3101000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 6};
get(185) -> 
    #base_limit_buy_shop{id = 185, time=12, goods_id=3102000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 6};
get(186) -> 
    #base_limit_buy_shop{id = 186, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(187) -> 
    #base_limit_buy_shop{id = 187, time=14, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(188) -> 
    #base_limit_buy_shop{id = 188, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(189) -> 
    #base_limit_buy_shop{id = 189, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(190) -> 
    #base_limit_buy_shop{id = 190, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(191) -> 
    #base_limit_buy_shop{id = 191, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(192) -> 
    #base_limit_buy_shop{id = 192, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(193) -> 
    #base_limit_buy_shop{id = 193, time=16, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(194) -> 
    #base_limit_buy_shop{id = 194, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(195) -> 
    #base_limit_buy_shop{id = 195, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(196) -> 
    #base_limit_buy_shop{id = 196, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(197) -> 
    #base_limit_buy_shop{id = 197, time=16, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(198) -> 
    #base_limit_buy_shop{id = 198, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 6};
get(199) -> 
    #base_limit_buy_shop{id = 199, time=18, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(200) -> 
    #base_limit_buy_shop{id = 200, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(201) -> 
    #base_limit_buy_shop{id = 201, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 6};
get(202) -> 
    #base_limit_buy_shop{id = 202, time=18, goods_id=3101000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 6};
get(203) -> 
    #base_limit_buy_shop{id = 203, time=18, goods_id=3102000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 6};
get(204) -> 
    #base_limit_buy_shop{id = 204, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(205) -> 
    #base_limit_buy_shop{id = 205, time=20, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(206) -> 
    #base_limit_buy_shop{id = 206, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(207) -> 
    #base_limit_buy_shop{id = 207, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(208) -> 
    #base_limit_buy_shop{id = 208, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(209) -> 
    #base_limit_buy_shop{id = 209, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(210) -> 
    #base_limit_buy_shop{id = 210, time=20, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 6};
get(211) -> 
    #base_limit_buy_shop{id = 211, time=22, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(212) -> 
    #base_limit_buy_shop{id = 212, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(213) -> 
    #base_limit_buy_shop{id = 213, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(214) -> 
    #base_limit_buy_shop{id = 214, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(215) -> 
    #base_limit_buy_shop{id = 215, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 6};
get(216) -> 
    #base_limit_buy_shop{id = 216, time=22, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(217) -> 
    #base_limit_buy_shop{id = 217, time=12, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(218) -> 
    #base_limit_buy_shop{id = 218, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(219) -> 
    #base_limit_buy_shop{id = 219, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 7};
get(220) -> 
    #base_limit_buy_shop{id = 220, time=12, goods_id=3201000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 7};
get(221) -> 
    #base_limit_buy_shop{id = 221, time=12, goods_id=3202000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 7};
get(222) -> 
    #base_limit_buy_shop{id = 222, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(223) -> 
    #base_limit_buy_shop{id = 223, time=14, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(224) -> 
    #base_limit_buy_shop{id = 224, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(225) -> 
    #base_limit_buy_shop{id = 225, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(226) -> 
    #base_limit_buy_shop{id = 226, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(227) -> 
    #base_limit_buy_shop{id = 227, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(228) -> 
    #base_limit_buy_shop{id = 228, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(229) -> 
    #base_limit_buy_shop{id = 229, time=16, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(230) -> 
    #base_limit_buy_shop{id = 230, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(231) -> 
    #base_limit_buy_shop{id = 231, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(232) -> 
    #base_limit_buy_shop{id = 232, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(233) -> 
    #base_limit_buy_shop{id = 233, time=16, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(234) -> 
    #base_limit_buy_shop{id = 234, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 7};
get(235) -> 
    #base_limit_buy_shop{id = 235, time=18, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(236) -> 
    #base_limit_buy_shop{id = 236, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(237) -> 
    #base_limit_buy_shop{id = 237, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 7};
get(238) -> 
    #base_limit_buy_shop{id = 238, time=18, goods_id=3201000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 7};
get(239) -> 
    #base_limit_buy_shop{id = 239, time=18, goods_id=3202000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 7};
get(240) -> 
    #base_limit_buy_shop{id = 240, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(241) -> 
    #base_limit_buy_shop{id = 241, time=20, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(242) -> 
    #base_limit_buy_shop{id = 242, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(243) -> 
    #base_limit_buy_shop{id = 243, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(244) -> 
    #base_limit_buy_shop{id = 244, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(245) -> 
    #base_limit_buy_shop{id = 245, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(246) -> 
    #base_limit_buy_shop{id = 246, time=20, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 7};
get(247) -> 
    #base_limit_buy_shop{id = 247, time=22, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(248) -> 
    #base_limit_buy_shop{id = 248, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(249) -> 
    #base_limit_buy_shop{id = 249, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(250) -> 
    #base_limit_buy_shop{id = 250, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(251) -> 
    #base_limit_buy_shop{id = 251, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 7};
get(252) -> 
    #base_limit_buy_shop{id = 252, time=22, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(253) -> 
    #base_limit_buy_shop{id = 253, time=12, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(254) -> 
    #base_limit_buy_shop{id = 254, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(255) -> 
    #base_limit_buy_shop{id = 255, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 8};
get(256) -> 
    #base_limit_buy_shop{id = 256, time=12, goods_id=3301000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 8};
get(257) -> 
    #base_limit_buy_shop{id = 257, time=12, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 8};
get(258) -> 
    #base_limit_buy_shop{id = 258, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(259) -> 
    #base_limit_buy_shop{id = 259, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(260) -> 
    #base_limit_buy_shop{id = 260, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(261) -> 
    #base_limit_buy_shop{id = 261, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(262) -> 
    #base_limit_buy_shop{id = 262, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(263) -> 
    #base_limit_buy_shop{id = 263, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(264) -> 
    #base_limit_buy_shop{id = 264, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(265) -> 
    #base_limit_buy_shop{id = 265, time=16, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(266) -> 
    #base_limit_buy_shop{id = 266, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(267) -> 
    #base_limit_buy_shop{id = 267, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(268) -> 
    #base_limit_buy_shop{id = 268, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(269) -> 
    #base_limit_buy_shop{id = 269, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(270) -> 
    #base_limit_buy_shop{id = 270, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 8};
get(271) -> 
    #base_limit_buy_shop{id = 271, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(272) -> 
    #base_limit_buy_shop{id = 272, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(273) -> 
    #base_limit_buy_shop{id = 273, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 8};
get(274) -> 
    #base_limit_buy_shop{id = 274, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 8};
get(275) -> 
    #base_limit_buy_shop{id = 275, time=18, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 8};
get(276) -> 
    #base_limit_buy_shop{id = 276, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(277) -> 
    #base_limit_buy_shop{id = 277, time=20, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(278) -> 
    #base_limit_buy_shop{id = 278, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(279) -> 
    #base_limit_buy_shop{id = 279, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(280) -> 
    #base_limit_buy_shop{id = 280, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(281) -> 
    #base_limit_buy_shop{id = 281, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(282) -> 
    #base_limit_buy_shop{id = 282, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 8};
get(283) -> 
    #base_limit_buy_shop{id = 283, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(284) -> 
    #base_limit_buy_shop{id = 284, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(285) -> 
    #base_limit_buy_shop{id = 285, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(286) -> 
    #base_limit_buy_shop{id = 286, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(287) -> 
    #base_limit_buy_shop{id = 287, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 8};
get(288) -> 
    #base_limit_buy_shop{id = 288, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(289) -> 
    #base_limit_buy_shop{id = 289, time=12, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(290) -> 
    #base_limit_buy_shop{id = 290, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(291) -> 
    #base_limit_buy_shop{id = 291, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 9};
get(292) -> 
    #base_limit_buy_shop{id = 292, time=12, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 9};
get(293) -> 
    #base_limit_buy_shop{id = 293, time=12, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 9};
get(294) -> 
    #base_limit_buy_shop{id = 294, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(295) -> 
    #base_limit_buy_shop{id = 295, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(296) -> 
    #base_limit_buy_shop{id = 296, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(297) -> 
    #base_limit_buy_shop{id = 297, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(298) -> 
    #base_limit_buy_shop{id = 298, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(299) -> 
    #base_limit_buy_shop{id = 299, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(300) -> 
    #base_limit_buy_shop{id = 300, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(301) -> 
    #base_limit_buy_shop{id = 301, time=16, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(302) -> 
    #base_limit_buy_shop{id = 302, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(303) -> 
    #base_limit_buy_shop{id = 303, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(304) -> 
    #base_limit_buy_shop{id = 304, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(305) -> 
    #base_limit_buy_shop{id = 305, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(306) -> 
    #base_limit_buy_shop{id = 306, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 9};
get(307) -> 
    #base_limit_buy_shop{id = 307, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(308) -> 
    #base_limit_buy_shop{id = 308, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(309) -> 
    #base_limit_buy_shop{id = 309, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 9};
get(310) -> 
    #base_limit_buy_shop{id = 310, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 9};
get(311) -> 
    #base_limit_buy_shop{id = 311, time=18, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 9};
get(312) -> 
    #base_limit_buy_shop{id = 312, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(313) -> 
    #base_limit_buy_shop{id = 313, time=20, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(314) -> 
    #base_limit_buy_shop{id = 314, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(315) -> 
    #base_limit_buy_shop{id = 315, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(316) -> 
    #base_limit_buy_shop{id = 316, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(317) -> 
    #base_limit_buy_shop{id = 317, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(318) -> 
    #base_limit_buy_shop{id = 318, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 9};
get(319) -> 
    #base_limit_buy_shop{id = 319, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(320) -> 
    #base_limit_buy_shop{id = 320, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(321) -> 
    #base_limit_buy_shop{id = 321, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(322) -> 
    #base_limit_buy_shop{id = 322, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(323) -> 
    #base_limit_buy_shop{id = 323, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 9};
get(324) -> 
    #base_limit_buy_shop{id = 324, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(325) -> 
    #base_limit_buy_shop{id = 325, time=12, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(326) -> 
    #base_limit_buy_shop{id = 326, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(327) -> 
    #base_limit_buy_shop{id = 327, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 10};
get(328) -> 
    #base_limit_buy_shop{id = 328, time=12, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 10};
get(329) -> 
    #base_limit_buy_shop{id = 329, time=12, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 10};
get(330) -> 
    #base_limit_buy_shop{id = 330, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(331) -> 
    #base_limit_buy_shop{id = 331, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(332) -> 
    #base_limit_buy_shop{id = 332, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(333) -> 
    #base_limit_buy_shop{id = 333, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(334) -> 
    #base_limit_buy_shop{id = 334, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(335) -> 
    #base_limit_buy_shop{id = 335, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(336) -> 
    #base_limit_buy_shop{id = 336, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(337) -> 
    #base_limit_buy_shop{id = 337, time=16, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(338) -> 
    #base_limit_buy_shop{id = 338, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(339) -> 
    #base_limit_buy_shop{id = 339, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(340) -> 
    #base_limit_buy_shop{id = 340, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(341) -> 
    #base_limit_buy_shop{id = 341, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(342) -> 
    #base_limit_buy_shop{id = 342, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 10};
get(343) -> 
    #base_limit_buy_shop{id = 343, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(344) -> 
    #base_limit_buy_shop{id = 344, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(345) -> 
    #base_limit_buy_shop{id = 345, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 10};
get(346) -> 
    #base_limit_buy_shop{id = 346, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 10};
get(347) -> 
    #base_limit_buy_shop{id = 347, time=18, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 10};
get(348) -> 
    #base_limit_buy_shop{id = 348, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(349) -> 
    #base_limit_buy_shop{id = 349, time=20, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(350) -> 
    #base_limit_buy_shop{id = 350, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(351) -> 
    #base_limit_buy_shop{id = 351, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(352) -> 
    #base_limit_buy_shop{id = 352, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(353) -> 
    #base_limit_buy_shop{id = 353, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(354) -> 
    #base_limit_buy_shop{id = 354, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 10};
get(355) -> 
    #base_limit_buy_shop{id = 355, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(356) -> 
    #base_limit_buy_shop{id = 356, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(357) -> 
    #base_limit_buy_shop{id = 357, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(358) -> 
    #base_limit_buy_shop{id = 358, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(359) -> 
    #base_limit_buy_shop{id = 359, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 10};
get(360) -> 
    #base_limit_buy_shop{id = 360, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(361) -> 
    #base_limit_buy_shop{id = 361, time=12, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(362) -> 
    #base_limit_buy_shop{id = 362, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(363) -> 
    #base_limit_buy_shop{id = 363, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 11};
get(364) -> 
    #base_limit_buy_shop{id = 364, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 11};
get(365) -> 
    #base_limit_buy_shop{id = 365, time=12, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 11};
get(366) -> 
    #base_limit_buy_shop{id = 366, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(367) -> 
    #base_limit_buy_shop{id = 367, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(368) -> 
    #base_limit_buy_shop{id = 368, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(369) -> 
    #base_limit_buy_shop{id = 369, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(370) -> 
    #base_limit_buy_shop{id = 370, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(371) -> 
    #base_limit_buy_shop{id = 371, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(372) -> 
    #base_limit_buy_shop{id = 372, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(373) -> 
    #base_limit_buy_shop{id = 373, time=16, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(374) -> 
    #base_limit_buy_shop{id = 374, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(375) -> 
    #base_limit_buy_shop{id = 375, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(376) -> 
    #base_limit_buy_shop{id = 376, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(377) -> 
    #base_limit_buy_shop{id = 377, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(378) -> 
    #base_limit_buy_shop{id = 378, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 11};
get(379) -> 
    #base_limit_buy_shop{id = 379, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(380) -> 
    #base_limit_buy_shop{id = 380, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(381) -> 
    #base_limit_buy_shop{id = 381, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 11};
get(382) -> 
    #base_limit_buy_shop{id = 382, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 11};
get(383) -> 
    #base_limit_buy_shop{id = 383, time=18, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 11};
get(384) -> 
    #base_limit_buy_shop{id = 384, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(385) -> 
    #base_limit_buy_shop{id = 385, time=20, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(386) -> 
    #base_limit_buy_shop{id = 386, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(387) -> 
    #base_limit_buy_shop{id = 387, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(388) -> 
    #base_limit_buy_shop{id = 388, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(389) -> 
    #base_limit_buy_shop{id = 389, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(390) -> 
    #base_limit_buy_shop{id = 390, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 11};
get(391) -> 
    #base_limit_buy_shop{id = 391, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(392) -> 
    #base_limit_buy_shop{id = 392, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(393) -> 
    #base_limit_buy_shop{id = 393, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(394) -> 
    #base_limit_buy_shop{id = 394, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(395) -> 
    #base_limit_buy_shop{id = 395, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 11};
get(396) -> 
    #base_limit_buy_shop{id = 396, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(397) -> 
    #base_limit_buy_shop{id = 397, time=12, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(398) -> 
    #base_limit_buy_shop{id = 398, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(399) -> 
    #base_limit_buy_shop{id = 399, time=12, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 12};
get(400) -> 
    #base_limit_buy_shop{id = 400, time=12, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 12};
get(401) -> 
    #base_limit_buy_shop{id = 401, time=12, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 12};
get(402) -> 
    #base_limit_buy_shop{id = 402, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(403) -> 
    #base_limit_buy_shop{id = 403, time=14, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(404) -> 
    #base_limit_buy_shop{id = 404, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(405) -> 
    #base_limit_buy_shop{id = 405, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(406) -> 
    #base_limit_buy_shop{id = 406, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(407) -> 
    #base_limit_buy_shop{id = 407, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(408) -> 
    #base_limit_buy_shop{id = 408, time=14, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(409) -> 
    #base_limit_buy_shop{id = 409, time=16, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(410) -> 
    #base_limit_buy_shop{id = 410, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(411) -> 
    #base_limit_buy_shop{id = 411, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(412) -> 
    #base_limit_buy_shop{id = 412, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(413) -> 
    #base_limit_buy_shop{id = 413, time=16, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(414) -> 
    #base_limit_buy_shop{id = 414, time=16, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 12};
get(415) -> 
    #base_limit_buy_shop{id = 415, time=18, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(416) -> 
    #base_limit_buy_shop{id = 416, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(417) -> 
    #base_limit_buy_shop{id = 417, time=18, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 12};
get(418) -> 
    #base_limit_buy_shop{id = 418, time=18, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 12};
get(419) -> 
    #base_limit_buy_shop{id = 419, time=18, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 12};
get(420) -> 
    #base_limit_buy_shop{id = 420, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(421) -> 
    #base_limit_buy_shop{id = 421, time=20, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(422) -> 
    #base_limit_buy_shop{id = 422, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(423) -> 
    #base_limit_buy_shop{id = 423, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(424) -> 
    #base_limit_buy_shop{id = 424, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(425) -> 
    #base_limit_buy_shop{id = 425, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(426) -> 
    #base_limit_buy_shop{id = 426, time=20, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(427) -> 
    #base_limit_buy_shop{id = 427, time=22, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(428) -> 
    #base_limit_buy_shop{id = 428, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(429) -> 
    #base_limit_buy_shop{id = 429, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(430) -> 
    #base_limit_buy_shop{id = 430, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(431) -> 
    #base_limit_buy_shop{id = 431, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 12};
get(432) -> 
    #base_limit_buy_shop{id = 432, time=22, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 12};
get(433) -> 
    #base_limit_buy_shop{id = 433, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 13};
get(434) -> 
    #base_limit_buy_shop{id = 434, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 13};
get(435) -> 
    #base_limit_buy_shop{id = 435, time=12, goods_id=3601000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 13};
get(436) -> 
    #base_limit_buy_shop{id = 436, time=12, goods_id=3601000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 13};
get(437) -> 
    #base_limit_buy_shop{id = 437, time=12, goods_id=3601000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 13};
get(438) -> 
    #base_limit_buy_shop{id = 438, time=12, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 13};
get(439) -> 
    #base_limit_buy_shop{id = 439, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 13};
get(440) -> 
    #base_limit_buy_shop{id = 440, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 13};
get(441) -> 
    #base_limit_buy_shop{id = 441, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 13};
get(442) -> 
    #base_limit_buy_shop{id = 442, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(443) -> 
    #base_limit_buy_shop{id = 443, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(444) -> 
    #base_limit_buy_shop{id = 444, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(445) -> 
    #base_limit_buy_shop{id = 445, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(446) -> 
    #base_limit_buy_shop{id = 446, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(447) -> 
    #base_limit_buy_shop{id = 447, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(448) -> 
    #base_limit_buy_shop{id = 448, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(449) -> 
    #base_limit_buy_shop{id = 449, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(450) -> 
    #base_limit_buy_shop{id = 450, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(451) -> 
    #base_limit_buy_shop{id = 451, time=18, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 13};
get(452) -> 
    #base_limit_buy_shop{id = 452, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 13};
get(453) -> 
    #base_limit_buy_shop{id = 453, time=18, goods_id=3601000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 13};
get(454) -> 
    #base_limit_buy_shop{id = 454, time=18, goods_id=3601000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 13};
get(455) -> 
    #base_limit_buy_shop{id = 455, time=18, goods_id=3601000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 13};
get(456) -> 
    #base_limit_buy_shop{id = 456, time=18, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 13};
get(457) -> 
    #base_limit_buy_shop{id = 457, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 13};
get(458) -> 
    #base_limit_buy_shop{id = 458, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 13};
get(459) -> 
    #base_limit_buy_shop{id = 459, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 13};
get(460) -> 
    #base_limit_buy_shop{id = 460, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(461) -> 
    #base_limit_buy_shop{id = 461, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(462) -> 
    #base_limit_buy_shop{id = 462, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(463) -> 
    #base_limit_buy_shop{id = 463, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(464) -> 
    #base_limit_buy_shop{id = 464, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(465) -> 
    #base_limit_buy_shop{id = 465, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(466) -> 
    #base_limit_buy_shop{id = 466, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(467) -> 
    #base_limit_buy_shop{id = 467, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(468) -> 
    #base_limit_buy_shop{id = 468, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(469) -> 
    #base_limit_buy_shop{id = 469, time=12, goods_id=20340, goods_num=6, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 14};
get(470) -> 
    #base_limit_buy_shop{id = 470, time=12, goods_id=20340, goods_num=10, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 14};
get(471) -> 
    #base_limit_buy_shop{id = 471, time=12, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 14};
get(472) -> 
    #base_limit_buy_shop{id = 472, time=12, goods_id=20340, goods_num=40, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 14};
get(473) -> 
    #base_limit_buy_shop{id = 473, time=12, goods_id=20340, goods_num=120, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 14};
get(474) -> 
    #base_limit_buy_shop{id = 474, time=12, goods_id=20340, goods_num=200, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 14};
get(475) -> 
    #base_limit_buy_shop{id = 475, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 14};
get(476) -> 
    #base_limit_buy_shop{id = 476, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 14};
get(477) -> 
    #base_limit_buy_shop{id = 477, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 14};
get(478) -> 
    #base_limit_buy_shop{id = 478, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(479) -> 
    #base_limit_buy_shop{id = 479, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(480) -> 
    #base_limit_buy_shop{id = 480, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(481) -> 
    #base_limit_buy_shop{id = 481, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(482) -> 
    #base_limit_buy_shop{id = 482, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(483) -> 
    #base_limit_buy_shop{id = 483, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(484) -> 
    #base_limit_buy_shop{id = 484, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(485) -> 
    #base_limit_buy_shop{id = 485, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(486) -> 
    #base_limit_buy_shop{id = 486, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(487) -> 
    #base_limit_buy_shop{id = 487, time=18, goods_id=20340, goods_num=6, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 14};
get(488) -> 
    #base_limit_buy_shop{id = 488, time=18, goods_id=20340, goods_num=10, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 14};
get(489) -> 
    #base_limit_buy_shop{id = 489, time=18, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 14};
get(490) -> 
    #base_limit_buy_shop{id = 490, time=18, goods_id=20340, goods_num=40, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 14};
get(491) -> 
    #base_limit_buy_shop{id = 491, time=18, goods_id=20340, goods_num=120, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 14};
get(492) -> 
    #base_limit_buy_shop{id = 492, time=18, goods_id=20340, goods_num=200, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 14};
get(493) -> 
    #base_limit_buy_shop{id = 493, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 14};
get(494) -> 
    #base_limit_buy_shop{id = 494, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 14};
get(495) -> 
    #base_limit_buy_shop{id = 495, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 14};
get(496) -> 
    #base_limit_buy_shop{id = 496, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(497) -> 
    #base_limit_buy_shop{id = 497, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(498) -> 
    #base_limit_buy_shop{id = 498, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(499) -> 
    #base_limit_buy_shop{id = 499, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(500) -> 
    #base_limit_buy_shop{id = 500, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(501) -> 
    #base_limit_buy_shop{id = 501, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(502) -> 
    #base_limit_buy_shop{id = 502, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(503) -> 
    #base_limit_buy_shop{id = 503, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(504) -> 
    #base_limit_buy_shop{id = 504, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(505) -> 
    #base_limit_buy_shop{id = 505, time=12, goods_id=3101000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 15};
get(506) -> 
    #base_limit_buy_shop{id = 506, time=12, goods_id=3101000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 15};
get(507) -> 
    #base_limit_buy_shop{id = 507, time=12, goods_id=3101000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 15};
get(508) -> 
    #base_limit_buy_shop{id = 508, time=12, goods_id=3101000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 15};
get(509) -> 
    #base_limit_buy_shop{id = 509, time=12, goods_id=3101000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 15};
get(510) -> 
    #base_limit_buy_shop{id = 510, time=12, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 15};
get(511) -> 
    #base_limit_buy_shop{id = 511, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 15};
get(512) -> 
    #base_limit_buy_shop{id = 512, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 15};
get(513) -> 
    #base_limit_buy_shop{id = 513, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 15};
get(514) -> 
    #base_limit_buy_shop{id = 514, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(515) -> 
    #base_limit_buy_shop{id = 515, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(516) -> 
    #base_limit_buy_shop{id = 516, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(517) -> 
    #base_limit_buy_shop{id = 517, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(518) -> 
    #base_limit_buy_shop{id = 518, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(519) -> 
    #base_limit_buy_shop{id = 519, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(520) -> 
    #base_limit_buy_shop{id = 520, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(521) -> 
    #base_limit_buy_shop{id = 521, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(522) -> 
    #base_limit_buy_shop{id = 522, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(523) -> 
    #base_limit_buy_shop{id = 523, time=18, goods_id=3101000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 15};
get(524) -> 
    #base_limit_buy_shop{id = 524, time=18, goods_id=3101000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 15};
get(525) -> 
    #base_limit_buy_shop{id = 525, time=18, goods_id=3101000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 15};
get(526) -> 
    #base_limit_buy_shop{id = 526, time=18, goods_id=3101000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 15};
get(527) -> 
    #base_limit_buy_shop{id = 527, time=18, goods_id=3101000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 15};
get(528) -> 
    #base_limit_buy_shop{id = 528, time=18, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 15};
get(529) -> 
    #base_limit_buy_shop{id = 529, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 15};
get(530) -> 
    #base_limit_buy_shop{id = 530, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 15};
get(531) -> 
    #base_limit_buy_shop{id = 531, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 15};
get(532) -> 
    #base_limit_buy_shop{id = 532, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(533) -> 
    #base_limit_buy_shop{id = 533, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(534) -> 
    #base_limit_buy_shop{id = 534, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(535) -> 
    #base_limit_buy_shop{id = 535, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(536) -> 
    #base_limit_buy_shop{id = 536, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(537) -> 
    #base_limit_buy_shop{id = 537, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(538) -> 
    #base_limit_buy_shop{id = 538, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(539) -> 
    #base_limit_buy_shop{id = 539, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(540) -> 
    #base_limit_buy_shop{id = 540, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(541) -> 
    #base_limit_buy_shop{id = 541, time=12, goods_id=3201000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 16};
get(542) -> 
    #base_limit_buy_shop{id = 542, time=12, goods_id=3201000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 16};
get(543) -> 
    #base_limit_buy_shop{id = 543, time=12, goods_id=3201000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 16};
get(544) -> 
    #base_limit_buy_shop{id = 544, time=12, goods_id=3201000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 16};
get(545) -> 
    #base_limit_buy_shop{id = 545, time=12, goods_id=3201000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 16};
get(546) -> 
    #base_limit_buy_shop{id = 546, time=12, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 16};
get(547) -> 
    #base_limit_buy_shop{id = 547, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 16};
get(548) -> 
    #base_limit_buy_shop{id = 548, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 16};
get(549) -> 
    #base_limit_buy_shop{id = 549, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 16};
get(550) -> 
    #base_limit_buy_shop{id = 550, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(551) -> 
    #base_limit_buy_shop{id = 551, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(552) -> 
    #base_limit_buy_shop{id = 552, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(553) -> 
    #base_limit_buy_shop{id = 553, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(554) -> 
    #base_limit_buy_shop{id = 554, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(555) -> 
    #base_limit_buy_shop{id = 555, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(556) -> 
    #base_limit_buy_shop{id = 556, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(557) -> 
    #base_limit_buy_shop{id = 557, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(558) -> 
    #base_limit_buy_shop{id = 558, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(559) -> 
    #base_limit_buy_shop{id = 559, time=18, goods_id=3201000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 16};
get(560) -> 
    #base_limit_buy_shop{id = 560, time=18, goods_id=3201000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 16};
get(561) -> 
    #base_limit_buy_shop{id = 561, time=18, goods_id=3201000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 16};
get(562) -> 
    #base_limit_buy_shop{id = 562, time=18, goods_id=3201000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 16};
get(563) -> 
    #base_limit_buy_shop{id = 563, time=18, goods_id=3201000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 16};
get(564) -> 
    #base_limit_buy_shop{id = 564, time=18, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 16};
get(565) -> 
    #base_limit_buy_shop{id = 565, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 16};
get(566) -> 
    #base_limit_buy_shop{id = 566, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 16};
get(567) -> 
    #base_limit_buy_shop{id = 567, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 16};
get(568) -> 
    #base_limit_buy_shop{id = 568, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(569) -> 
    #base_limit_buy_shop{id = 569, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(570) -> 
    #base_limit_buy_shop{id = 570, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(571) -> 
    #base_limit_buy_shop{id = 571, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(572) -> 
    #base_limit_buy_shop{id = 572, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(573) -> 
    #base_limit_buy_shop{id = 573, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(574) -> 
    #base_limit_buy_shop{id = 574, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(575) -> 
    #base_limit_buy_shop{id = 575, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(576) -> 
    #base_limit_buy_shop{id = 576, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(577) -> 
    #base_limit_buy_shop{id = 577, time=12, goods_id=3401000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 17};
get(578) -> 
    #base_limit_buy_shop{id = 578, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 17};
get(579) -> 
    #base_limit_buy_shop{id = 579, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 17};
get(580) -> 
    #base_limit_buy_shop{id = 580, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 17};
get(581) -> 
    #base_limit_buy_shop{id = 581, time=12, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 17};
get(582) -> 
    #base_limit_buy_shop{id = 582, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 17};
get(583) -> 
    #base_limit_buy_shop{id = 583, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(584) -> 
    #base_limit_buy_shop{id = 584, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 17};
get(585) -> 
    #base_limit_buy_shop{id = 585, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 17};
get(586) -> 
    #base_limit_buy_shop{id = 586, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 17};
get(587) -> 
    #base_limit_buy_shop{id = 587, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(588) -> 
    #base_limit_buy_shop{id = 588, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 17};
get(589) -> 
    #base_limit_buy_shop{id = 589, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 17};
get(590) -> 
    #base_limit_buy_shop{id = 590, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 17};
get(591) -> 
    #base_limit_buy_shop{id = 591, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(592) -> 
    #base_limit_buy_shop{id = 592, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 17};
get(593) -> 
    #base_limit_buy_shop{id = 593, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 17};
get(594) -> 
    #base_limit_buy_shop{id = 594, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 17};
get(595) -> 
    #base_limit_buy_shop{id = 595, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(596) -> 
    #base_limit_buy_shop{id = 596, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 17};
get(597) -> 
    #base_limit_buy_shop{id = 597, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 17};
get(598) -> 
    #base_limit_buy_shop{id = 598, time=18, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 17};
get(599) -> 
    #base_limit_buy_shop{id = 599, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 17};
get(600) -> 
    #base_limit_buy_shop{id = 600, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 17};
get(601) -> 
    #base_limit_buy_shop{id = 601, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 17};
get(602) -> 
    #base_limit_buy_shop{id = 602, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 17};
get(603) -> 
    #base_limit_buy_shop{id = 603, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(604) -> 
    #base_limit_buy_shop{id = 604, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 17};
get(605) -> 
    #base_limit_buy_shop{id = 605, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 17};
get(606) -> 
    #base_limit_buy_shop{id = 606, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 17};
get(607) -> 
    #base_limit_buy_shop{id = 607, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(608) -> 
    #base_limit_buy_shop{id = 608, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 17};
get(609) -> 
    #base_limit_buy_shop{id = 609, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 17};
get(610) -> 
    #base_limit_buy_shop{id = 610, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 17};
get(611) -> 
    #base_limit_buy_shop{id = 611, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 17};
get(612) -> 
    #base_limit_buy_shop{id = 612, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 17};
get(613) -> 
    #base_limit_buy_shop{id = 613, time=12, goods_id=3501000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 18};
get(614) -> 
    #base_limit_buy_shop{id = 614, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 18};
get(615) -> 
    #base_limit_buy_shop{id = 615, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 18};
get(616) -> 
    #base_limit_buy_shop{id = 616, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 18};
get(617) -> 
    #base_limit_buy_shop{id = 617, time=12, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 18};
get(618) -> 
    #base_limit_buy_shop{id = 618, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 18};
get(619) -> 
    #base_limit_buy_shop{id = 619, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(620) -> 
    #base_limit_buy_shop{id = 620, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 18};
get(621) -> 
    #base_limit_buy_shop{id = 621, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 18};
get(622) -> 
    #base_limit_buy_shop{id = 622, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 18};
get(623) -> 
    #base_limit_buy_shop{id = 623, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 18};
get(624) -> 
    #base_limit_buy_shop{id = 624, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 18};
get(625) -> 
    #base_limit_buy_shop{id = 625, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 18};
get(626) -> 
    #base_limit_buy_shop{id = 626, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 18};
get(627) -> 
    #base_limit_buy_shop{id = 627, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 18};
get(628) -> 
    #base_limit_buy_shop{id = 628, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 18};
get(629) -> 
    #base_limit_buy_shop{id = 629, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 18};
get(630) -> 
    #base_limit_buy_shop{id = 630, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 18};
get(631) -> 
    #base_limit_buy_shop{id = 631, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(632) -> 
    #base_limit_buy_shop{id = 632, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 18};
get(633) -> 
    #base_limit_buy_shop{id = 633, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 18};
get(634) -> 
    #base_limit_buy_shop{id = 634, time=18, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 18};
get(635) -> 
    #base_limit_buy_shop{id = 635, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 18};
get(636) -> 
    #base_limit_buy_shop{id = 636, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 18};
get(637) -> 
    #base_limit_buy_shop{id = 637, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 18};
get(638) -> 
    #base_limit_buy_shop{id = 638, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 18};
get(639) -> 
    #base_limit_buy_shop{id = 639, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 18};
get(640) -> 
    #base_limit_buy_shop{id = 640, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 18};
get(641) -> 
    #base_limit_buy_shop{id = 641, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 18};
get(642) -> 
    #base_limit_buy_shop{id = 642, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 18};
get(643) -> 
    #base_limit_buy_shop{id = 643, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(644) -> 
    #base_limit_buy_shop{id = 644, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 18};
get(645) -> 
    #base_limit_buy_shop{id = 645, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 18};
get(646) -> 
    #base_limit_buy_shop{id = 646, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 18};
get(647) -> 
    #base_limit_buy_shop{id = 647, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 18};
get(648) -> 
    #base_limit_buy_shop{id = 648, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 18};
get(649) -> 
    #base_limit_buy_shop{id = 649, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 19};
get(650) -> 
    #base_limit_buy_shop{id = 650, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 19};
get(651) -> 
    #base_limit_buy_shop{id = 651, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 19};
get(652) -> 
    #base_limit_buy_shop{id = 652, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 19};
get(653) -> 
    #base_limit_buy_shop{id = 653, time=12, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 19};
get(654) -> 
    #base_limit_buy_shop{id = 654, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 19};
get(655) -> 
    #base_limit_buy_shop{id = 655, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(656) -> 
    #base_limit_buy_shop{id = 656, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 19};
get(657) -> 
    #base_limit_buy_shop{id = 657, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 19};
get(658) -> 
    #base_limit_buy_shop{id = 658, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 19};
get(659) -> 
    #base_limit_buy_shop{id = 659, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 19};
get(660) -> 
    #base_limit_buy_shop{id = 660, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 19};
get(661) -> 
    #base_limit_buy_shop{id = 661, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 19};
get(662) -> 
    #base_limit_buy_shop{id = 662, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 19};
get(663) -> 
    #base_limit_buy_shop{id = 663, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 19};
get(664) -> 
    #base_limit_buy_shop{id = 664, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 19};
get(665) -> 
    #base_limit_buy_shop{id = 665, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 19};
get(666) -> 
    #base_limit_buy_shop{id = 666, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 19};
get(667) -> 
    #base_limit_buy_shop{id = 667, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(668) -> 
    #base_limit_buy_shop{id = 668, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 19};
get(669) -> 
    #base_limit_buy_shop{id = 669, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 19};
get(670) -> 
    #base_limit_buy_shop{id = 670, time=18, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 19};
get(671) -> 
    #base_limit_buy_shop{id = 671, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 19};
get(672) -> 
    #base_limit_buy_shop{id = 672, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 19};
get(673) -> 
    #base_limit_buy_shop{id = 673, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 19};
get(674) -> 
    #base_limit_buy_shop{id = 674, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 19};
get(675) -> 
    #base_limit_buy_shop{id = 675, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 19};
get(676) -> 
    #base_limit_buy_shop{id = 676, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 19};
get(677) -> 
    #base_limit_buy_shop{id = 677, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 19};
get(678) -> 
    #base_limit_buy_shop{id = 678, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 19};
get(679) -> 
    #base_limit_buy_shop{id = 679, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(680) -> 
    #base_limit_buy_shop{id = 680, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 19};
get(681) -> 
    #base_limit_buy_shop{id = 681, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 19};
get(682) -> 
    #base_limit_buy_shop{id = 682, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 19};
get(683) -> 
    #base_limit_buy_shop{id = 683, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 19};
get(684) -> 
    #base_limit_buy_shop{id = 684, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 19};
get(685) -> 
    #base_limit_buy_shop{id = 685, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 20};
get(686) -> 
    #base_limit_buy_shop{id = 686, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 20};
get(687) -> 
    #base_limit_buy_shop{id = 687, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 20};
get(688) -> 
    #base_limit_buy_shop{id = 688, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 20};
get(689) -> 
    #base_limit_buy_shop{id = 689, time=12, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 20};
get(690) -> 
    #base_limit_buy_shop{id = 690, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 20};
get(691) -> 
    #base_limit_buy_shop{id = 691, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(692) -> 
    #base_limit_buy_shop{id = 692, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 20};
get(693) -> 
    #base_limit_buy_shop{id = 693, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 20};
get(694) -> 
    #base_limit_buy_shop{id = 694, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 20};
get(695) -> 
    #base_limit_buy_shop{id = 695, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 20};
get(696) -> 
    #base_limit_buy_shop{id = 696, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 20};
get(697) -> 
    #base_limit_buy_shop{id = 697, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 20};
get(698) -> 
    #base_limit_buy_shop{id = 698, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 20};
get(699) -> 
    #base_limit_buy_shop{id = 699, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 20};
get(700) -> 
    #base_limit_buy_shop{id = 700, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 20};
get(701) -> 
    #base_limit_buy_shop{id = 701, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 20};
get(702) -> 
    #base_limit_buy_shop{id = 702, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 20};
get(703) -> 
    #base_limit_buy_shop{id = 703, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(704) -> 
    #base_limit_buy_shop{id = 704, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 20};
get(705) -> 
    #base_limit_buy_shop{id = 705, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 20};
get(706) -> 
    #base_limit_buy_shop{id = 706, time=18, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 20};
get(707) -> 
    #base_limit_buy_shop{id = 707, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 20};
get(708) -> 
    #base_limit_buy_shop{id = 708, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 20};
get(709) -> 
    #base_limit_buy_shop{id = 709, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 20};
get(710) -> 
    #base_limit_buy_shop{id = 710, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 20};
get(711) -> 
    #base_limit_buy_shop{id = 711, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 20};
get(712) -> 
    #base_limit_buy_shop{id = 712, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 20};
get(713) -> 
    #base_limit_buy_shop{id = 713, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 20};
get(714) -> 
    #base_limit_buy_shop{id = 714, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 20};
get(715) -> 
    #base_limit_buy_shop{id = 715, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(716) -> 
    #base_limit_buy_shop{id = 716, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 20};
get(717) -> 
    #base_limit_buy_shop{id = 717, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 20};
get(718) -> 
    #base_limit_buy_shop{id = 718, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 20};
get(719) -> 
    #base_limit_buy_shop{id = 719, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 20};
get(720) -> 
    #base_limit_buy_shop{id = 720, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 20};
get(721) -> 
    #base_limit_buy_shop{id = 721, time=12, goods_id=3501000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 21};
get(722) -> 
    #base_limit_buy_shop{id = 722, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 21};
get(723) -> 
    #base_limit_buy_shop{id = 723, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 21};
get(724) -> 
    #base_limit_buy_shop{id = 724, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 21};
get(725) -> 
    #base_limit_buy_shop{id = 725, time=12, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 21};
get(726) -> 
    #base_limit_buy_shop{id = 726, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 21};
get(727) -> 
    #base_limit_buy_shop{id = 727, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(728) -> 
    #base_limit_buy_shop{id = 728, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 21};
get(729) -> 
    #base_limit_buy_shop{id = 729, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 21};
get(730) -> 
    #base_limit_buy_shop{id = 730, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 21};
get(731) -> 
    #base_limit_buy_shop{id = 731, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(732) -> 
    #base_limit_buy_shop{id = 732, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 21};
get(733) -> 
    #base_limit_buy_shop{id = 733, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 21};
get(734) -> 
    #base_limit_buy_shop{id = 734, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 21};
get(735) -> 
    #base_limit_buy_shop{id = 735, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(736) -> 
    #base_limit_buy_shop{id = 736, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 21};
get(737) -> 
    #base_limit_buy_shop{id = 737, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 21};
get(738) -> 
    #base_limit_buy_shop{id = 738, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 21};
get(739) -> 
    #base_limit_buy_shop{id = 739, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(740) -> 
    #base_limit_buy_shop{id = 740, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 21};
get(741) -> 
    #base_limit_buy_shop{id = 741, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 21};
get(742) -> 
    #base_limit_buy_shop{id = 742, time=18, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 21};
get(743) -> 
    #base_limit_buy_shop{id = 743, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 21};
get(744) -> 
    #base_limit_buy_shop{id = 744, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 21};
get(745) -> 
    #base_limit_buy_shop{id = 745, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 21};
get(746) -> 
    #base_limit_buy_shop{id = 746, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 21};
get(747) -> 
    #base_limit_buy_shop{id = 747, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(748) -> 
    #base_limit_buy_shop{id = 748, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 21};
get(749) -> 
    #base_limit_buy_shop{id = 749, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 21};
get(750) -> 
    #base_limit_buy_shop{id = 750, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 21};
get(751) -> 
    #base_limit_buy_shop{id = 751, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(752) -> 
    #base_limit_buy_shop{id = 752, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 21};
get(753) -> 
    #base_limit_buy_shop{id = 753, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 21};
get(754) -> 
    #base_limit_buy_shop{id = 754, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 21};
get(755) -> 
    #base_limit_buy_shop{id = 755, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 21};
get(756) -> 
    #base_limit_buy_shop{id = 756, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 21};
get(757) -> 
    #base_limit_buy_shop{id = 757, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 22};
get(758) -> 
    #base_limit_buy_shop{id = 758, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 22};
get(759) -> 
    #base_limit_buy_shop{id = 759, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 22};
get(760) -> 
    #base_limit_buy_shop{id = 760, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 22};
get(761) -> 
    #base_limit_buy_shop{id = 761, time=12, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 22};
get(762) -> 
    #base_limit_buy_shop{id = 762, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 22};
get(763) -> 
    #base_limit_buy_shop{id = 763, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(764) -> 
    #base_limit_buy_shop{id = 764, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 22};
get(765) -> 
    #base_limit_buy_shop{id = 765, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 22};
get(766) -> 
    #base_limit_buy_shop{id = 766, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 22};
get(767) -> 
    #base_limit_buy_shop{id = 767, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(768) -> 
    #base_limit_buy_shop{id = 768, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 22};
get(769) -> 
    #base_limit_buy_shop{id = 769, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 22};
get(770) -> 
    #base_limit_buy_shop{id = 770, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 22};
get(771) -> 
    #base_limit_buy_shop{id = 771, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(772) -> 
    #base_limit_buy_shop{id = 772, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 22};
get(773) -> 
    #base_limit_buy_shop{id = 773, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 22};
get(774) -> 
    #base_limit_buy_shop{id = 774, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 22};
get(775) -> 
    #base_limit_buy_shop{id = 775, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(776) -> 
    #base_limit_buy_shop{id = 776, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 22};
get(777) -> 
    #base_limit_buy_shop{id = 777, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 22};
get(778) -> 
    #base_limit_buy_shop{id = 778, time=18, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 22};
get(779) -> 
    #base_limit_buy_shop{id = 779, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 22};
get(780) -> 
    #base_limit_buy_shop{id = 780, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 22};
get(781) -> 
    #base_limit_buy_shop{id = 781, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 22};
get(782) -> 
    #base_limit_buy_shop{id = 782, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 22};
get(783) -> 
    #base_limit_buy_shop{id = 783, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(784) -> 
    #base_limit_buy_shop{id = 784, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 22};
get(785) -> 
    #base_limit_buy_shop{id = 785, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 22};
get(786) -> 
    #base_limit_buy_shop{id = 786, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 22};
get(787) -> 
    #base_limit_buy_shop{id = 787, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(788) -> 
    #base_limit_buy_shop{id = 788, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 22};
get(789) -> 
    #base_limit_buy_shop{id = 789, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 22};
get(790) -> 
    #base_limit_buy_shop{id = 790, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 22};
get(791) -> 
    #base_limit_buy_shop{id = 791, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 22};
get(792) -> 
    #base_limit_buy_shop{id = 792, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 22};
get(793) -> 
    #base_limit_buy_shop{id = 793, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 23};
get(794) -> 
    #base_limit_buy_shop{id = 794, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 23};
get(795) -> 
    #base_limit_buy_shop{id = 795, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 23};
get(796) -> 
    #base_limit_buy_shop{id = 796, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 23};
get(797) -> 
    #base_limit_buy_shop{id = 797, time=12, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 23};
get(798) -> 
    #base_limit_buy_shop{id = 798, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 23};
get(799) -> 
    #base_limit_buy_shop{id = 799, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(800) -> 
    #base_limit_buy_shop{id = 800, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 23};
get(801) -> 
    #base_limit_buy_shop{id = 801, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 23};
get(802) -> 
    #base_limit_buy_shop{id = 802, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 23};
get(803) -> 
    #base_limit_buy_shop{id = 803, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(804) -> 
    #base_limit_buy_shop{id = 804, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 23};
get(805) -> 
    #base_limit_buy_shop{id = 805, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 23};
get(806) -> 
    #base_limit_buy_shop{id = 806, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 23};
get(807) -> 
    #base_limit_buy_shop{id = 807, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(808) -> 
    #base_limit_buy_shop{id = 808, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 23};
get(809) -> 
    #base_limit_buy_shop{id = 809, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 23};
get(810) -> 
    #base_limit_buy_shop{id = 810, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 23};
get(811) -> 
    #base_limit_buy_shop{id = 811, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(812) -> 
    #base_limit_buy_shop{id = 812, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 23};
get(813) -> 
    #base_limit_buy_shop{id = 813, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 23};
get(814) -> 
    #base_limit_buy_shop{id = 814, time=18, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 23};
get(815) -> 
    #base_limit_buy_shop{id = 815, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 23};
get(816) -> 
    #base_limit_buy_shop{id = 816, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 23};
get(817) -> 
    #base_limit_buy_shop{id = 817, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 23};
get(818) -> 
    #base_limit_buy_shop{id = 818, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 23};
get(819) -> 
    #base_limit_buy_shop{id = 819, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(820) -> 
    #base_limit_buy_shop{id = 820, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 23};
get(821) -> 
    #base_limit_buy_shop{id = 821, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 23};
get(822) -> 
    #base_limit_buy_shop{id = 822, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 23};
get(823) -> 
    #base_limit_buy_shop{id = 823, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(824) -> 
    #base_limit_buy_shop{id = 824, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 23};
get(825) -> 
    #base_limit_buy_shop{id = 825, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 23};
get(826) -> 
    #base_limit_buy_shop{id = 826, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 23};
get(827) -> 
    #base_limit_buy_shop{id = 827, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 23};
get(828) -> 
    #base_limit_buy_shop{id = 828, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 23};
get(829) -> 
    #base_limit_buy_shop{id = 829, time=12, goods_id=3701000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 24};
get(830) -> 
    #base_limit_buy_shop{id = 830, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 24};
get(831) -> 
    #base_limit_buy_shop{id = 831, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 24};
get(832) -> 
    #base_limit_buy_shop{id = 832, time=12, goods_id=8001207, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 24};
get(833) -> 
    #base_limit_buy_shop{id = 833, time=12, goods_id=3702000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 24};
get(834) -> 
    #base_limit_buy_shop{id = 834, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 24};
get(835) -> 
    #base_limit_buy_shop{id = 835, time=14, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(836) -> 
    #base_limit_buy_shop{id = 836, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 24};
get(837) -> 
    #base_limit_buy_shop{id = 837, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 24};
get(838) -> 
    #base_limit_buy_shop{id = 838, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 24};
get(839) -> 
    #base_limit_buy_shop{id = 839, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(840) -> 
    #base_limit_buy_shop{id = 840, time=14, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 24};
get(841) -> 
    #base_limit_buy_shop{id = 841, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 24};
get(842) -> 
    #base_limit_buy_shop{id = 842, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 24};
get(843) -> 
    #base_limit_buy_shop{id = 843, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(844) -> 
    #base_limit_buy_shop{id = 844, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 24};
get(845) -> 
    #base_limit_buy_shop{id = 845, time=16, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 24};
get(846) -> 
    #base_limit_buy_shop{id = 846, time=16, goods_id=3701000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 24};
get(847) -> 
    #base_limit_buy_shop{id = 847, time=18, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(848) -> 
    #base_limit_buy_shop{id = 848, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 24};
get(849) -> 
    #base_limit_buy_shop{id = 849, time=18, goods_id=8001207, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 24};
get(850) -> 
    #base_limit_buy_shop{id = 850, time=18, goods_id=3702000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 24};
get(851) -> 
    #base_limit_buy_shop{id = 851, time=18, goods_id=3701000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 24};
get(852) -> 
    #base_limit_buy_shop{id = 852, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 24};
get(853) -> 
    #base_limit_buy_shop{id = 853, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 24};
get(854) -> 
    #base_limit_buy_shop{id = 854, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 24};
get(855) -> 
    #base_limit_buy_shop{id = 855, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(856) -> 
    #base_limit_buy_shop{id = 856, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 24};
get(857) -> 
    #base_limit_buy_shop{id = 857, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 24};
get(858) -> 
    #base_limit_buy_shop{id = 858, time=20, goods_id=3701000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 24};
get(859) -> 
    #base_limit_buy_shop{id = 859, time=22, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(860) -> 
    #base_limit_buy_shop{id = 860, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 24};
get(861) -> 
    #base_limit_buy_shop{id = 861, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 24};
get(862) -> 
    #base_limit_buy_shop{id = 862, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 24};
get(863) -> 
    #base_limit_buy_shop{id = 863, time=22, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 24};
get(864) -> 
    #base_limit_buy_shop{id = 864, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 24};
get(865) -> 
    #base_limit_buy_shop{id = 865, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(866) -> 
    #base_limit_buy_shop{id = 866, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 25};
get(867) -> 
    #base_limit_buy_shop{id = 867, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(868) -> 
    #base_limit_buy_shop{id = 868, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 25};
get(869) -> 
    #base_limit_buy_shop{id = 869, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 25};
get(870) -> 
    #base_limit_buy_shop{id = 870, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 25};
get(871) -> 
    #base_limit_buy_shop{id = 871, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(872) -> 
    #base_limit_buy_shop{id = 872, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(873) -> 
    #base_limit_buy_shop{id = 873, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 25};
get(874) -> 
    #base_limit_buy_shop{id = 874, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 25};
get(875) -> 
    #base_limit_buy_shop{id = 875, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(876) -> 
    #base_limit_buy_shop{id = 876, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 25};
get(877) -> 
    #base_limit_buy_shop{id = 877, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(878) -> 
    #base_limit_buy_shop{id = 878, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 25};
get(879) -> 
    #base_limit_buy_shop{id = 879, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(880) -> 
    #base_limit_buy_shop{id = 880, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 25};
get(881) -> 
    #base_limit_buy_shop{id = 881, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(882) -> 
    #base_limit_buy_shop{id = 882, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 25};
get(883) -> 
    #base_limit_buy_shop{id = 883, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(884) -> 
    #base_limit_buy_shop{id = 884, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 25};
get(885) -> 
    #base_limit_buy_shop{id = 885, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(886) -> 
    #base_limit_buy_shop{id = 886, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 25};
get(887) -> 
    #base_limit_buy_shop{id = 887, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 25};
get(888) -> 
    #base_limit_buy_shop{id = 888, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 25};
get(889) -> 
    #base_limit_buy_shop{id = 889, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(890) -> 
    #base_limit_buy_shop{id = 890, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(891) -> 
    #base_limit_buy_shop{id = 891, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 25};
get(892) -> 
    #base_limit_buy_shop{id = 892, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 25};
get(893) -> 
    #base_limit_buy_shop{id = 893, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(894) -> 
    #base_limit_buy_shop{id = 894, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 25};
get(895) -> 
    #base_limit_buy_shop{id = 895, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(896) -> 
    #base_limit_buy_shop{id = 896, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 25};
get(897) -> 
    #base_limit_buy_shop{id = 897, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(898) -> 
    #base_limit_buy_shop{id = 898, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 25};
get(899) -> 
    #base_limit_buy_shop{id = 899, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(900) -> 
    #base_limit_buy_shop{id = 900, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 25};
get(901) -> 
    #base_limit_buy_shop{id = 901, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(902) -> 
    #base_limit_buy_shop{id = 902, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 26};
get(903) -> 
    #base_limit_buy_shop{id = 903, time=12, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(904) -> 
    #base_limit_buy_shop{id = 904, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 26};
get(905) -> 
    #base_limit_buy_shop{id = 905, time=12, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 26};
get(906) -> 
    #base_limit_buy_shop{id = 906, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 26};
get(907) -> 
    #base_limit_buy_shop{id = 907, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(908) -> 
    #base_limit_buy_shop{id = 908, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(909) -> 
    #base_limit_buy_shop{id = 909, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 26};
get(910) -> 
    #base_limit_buy_shop{id = 910, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 26};
get(911) -> 
    #base_limit_buy_shop{id = 911, time=14, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(912) -> 
    #base_limit_buy_shop{id = 912, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 26};
get(913) -> 
    #base_limit_buy_shop{id = 913, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(914) -> 
    #base_limit_buy_shop{id = 914, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 26};
get(915) -> 
    #base_limit_buy_shop{id = 915, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(916) -> 
    #base_limit_buy_shop{id = 916, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 26};
get(917) -> 
    #base_limit_buy_shop{id = 917, time=16, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(918) -> 
    #base_limit_buy_shop{id = 918, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 26};
get(919) -> 
    #base_limit_buy_shop{id = 919, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(920) -> 
    #base_limit_buy_shop{id = 920, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 26};
get(921) -> 
    #base_limit_buy_shop{id = 921, time=18, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(922) -> 
    #base_limit_buy_shop{id = 922, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 26};
get(923) -> 
    #base_limit_buy_shop{id = 923, time=18, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 26};
get(924) -> 
    #base_limit_buy_shop{id = 924, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 26};
get(925) -> 
    #base_limit_buy_shop{id = 925, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(926) -> 
    #base_limit_buy_shop{id = 926, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(927) -> 
    #base_limit_buy_shop{id = 927, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 26};
get(928) -> 
    #base_limit_buy_shop{id = 928, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 26};
get(929) -> 
    #base_limit_buy_shop{id = 929, time=20, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(930) -> 
    #base_limit_buy_shop{id = 930, time=20, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 26};
get(931) -> 
    #base_limit_buy_shop{id = 931, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(932) -> 
    #base_limit_buy_shop{id = 932, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 26};
get(933) -> 
    #base_limit_buy_shop{id = 933, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(934) -> 
    #base_limit_buy_shop{id = 934, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 26};
get(935) -> 
    #base_limit_buy_shop{id = 935, time=22, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(936) -> 
    #base_limit_buy_shop{id = 936, time=22, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 26};
get(937) -> 
    #base_limit_buy_shop{id = 937, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(938) -> 
    #base_limit_buy_shop{id = 938, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 27};
get(939) -> 
    #base_limit_buy_shop{id = 939, time=12, goods_id=3511000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(940) -> 
    #base_limit_buy_shop{id = 940, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 27};
get(941) -> 
    #base_limit_buy_shop{id = 941, time=12, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 27};
get(942) -> 
    #base_limit_buy_shop{id = 942, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 27};
get(943) -> 
    #base_limit_buy_shop{id = 943, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(944) -> 
    #base_limit_buy_shop{id = 944, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(945) -> 
    #base_limit_buy_shop{id = 945, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 27};
get(946) -> 
    #base_limit_buy_shop{id = 946, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 27};
get(947) -> 
    #base_limit_buy_shop{id = 947, time=14, goods_id=3511000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(948) -> 
    #base_limit_buy_shop{id = 948, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 27};
get(949) -> 
    #base_limit_buy_shop{id = 949, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(950) -> 
    #base_limit_buy_shop{id = 950, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 27};
get(951) -> 
    #base_limit_buy_shop{id = 951, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(952) -> 
    #base_limit_buy_shop{id = 952, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 27};
get(953) -> 
    #base_limit_buy_shop{id = 953, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(954) -> 
    #base_limit_buy_shop{id = 954, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 27};
get(955) -> 
    #base_limit_buy_shop{id = 955, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(956) -> 
    #base_limit_buy_shop{id = 956, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 27};
get(957) -> 
    #base_limit_buy_shop{id = 957, time=18, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(958) -> 
    #base_limit_buy_shop{id = 958, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 27};
get(959) -> 
    #base_limit_buy_shop{id = 959, time=18, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 27};
get(960) -> 
    #base_limit_buy_shop{id = 960, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 27};
get(961) -> 
    #base_limit_buy_shop{id = 961, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(962) -> 
    #base_limit_buy_shop{id = 962, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(963) -> 
    #base_limit_buy_shop{id = 963, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 27};
get(964) -> 
    #base_limit_buy_shop{id = 964, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 27};
get(965) -> 
    #base_limit_buy_shop{id = 965, time=20, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(966) -> 
    #base_limit_buy_shop{id = 966, time=20, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 27};
get(967) -> 
    #base_limit_buy_shop{id = 967, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(968) -> 
    #base_limit_buy_shop{id = 968, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 27};
get(969) -> 
    #base_limit_buy_shop{id = 969, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(970) -> 
    #base_limit_buy_shop{id = 970, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 27};
get(971) -> 
    #base_limit_buy_shop{id = 971, time=22, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(972) -> 
    #base_limit_buy_shop{id = 972, time=22, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 27};
get(973) -> 
    #base_limit_buy_shop{id = 973, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(974) -> 
    #base_limit_buy_shop{id = 974, time=12, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(975) -> 
    #base_limit_buy_shop{id = 975, time=12, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 28};
get(976) -> 
    #base_limit_buy_shop{id = 976, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 60, buy_num = 5,  sys_buy_num = 20, type = 28};
get(977) -> 
    #base_limit_buy_shop{id = 977, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 28};
get(978) -> 
    #base_limit_buy_shop{id = 978, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 28};
get(979) -> 
    #base_limit_buy_shop{id = 979, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(980) -> 
    #base_limit_buy_shop{id = 980, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(981) -> 
    #base_limit_buy_shop{id = 981, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 28};
get(982) -> 
    #base_limit_buy_shop{id = 982, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 28};
get(983) -> 
    #base_limit_buy_shop{id = 983, time=14, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(984) -> 
    #base_limit_buy_shop{id = 984, time=14, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 28};
get(985) -> 
    #base_limit_buy_shop{id = 985, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(986) -> 
    #base_limit_buy_shop{id = 986, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(987) -> 
    #base_limit_buy_shop{id = 987, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(988) -> 
    #base_limit_buy_shop{id = 988, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 28};
get(989) -> 
    #base_limit_buy_shop{id = 989, time=16, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(990) -> 
    #base_limit_buy_shop{id = 990, time=16, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 28};
get(991) -> 
    #base_limit_buy_shop{id = 991, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(992) -> 
    #base_limit_buy_shop{id = 992, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(993) -> 
    #base_limit_buy_shop{id = 993, time=18, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 28};
get(994) -> 
    #base_limit_buy_shop{id = 994, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 60, buy_num = 5,  sys_buy_num = 20, type = 28};
get(995) -> 
    #base_limit_buy_shop{id = 995, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 28};
get(996) -> 
    #base_limit_buy_shop{id = 996, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 28};
get(997) -> 
    #base_limit_buy_shop{id = 997, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(998) -> 
    #base_limit_buy_shop{id = 998, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(999) -> 
    #base_limit_buy_shop{id = 999, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1000) -> 
    #base_limit_buy_shop{id = 1000, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1001) -> 
    #base_limit_buy_shop{id = 1001, time=20, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1002) -> 
    #base_limit_buy_shop{id = 1002, time=20, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1003) -> 
    #base_limit_buy_shop{id = 1003, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(1004) -> 
    #base_limit_buy_shop{id = 1004, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1005) -> 
    #base_limit_buy_shop{id = 1005, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1006) -> 
    #base_limit_buy_shop{id = 1006, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1007) -> 
    #base_limit_buy_shop{id = 1007, time=22, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1008) -> 
    #base_limit_buy_shop{id = 1008, time=22, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1009) -> 
    #base_limit_buy_shop{id = 1009, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1010) -> 
    #base_limit_buy_shop{id = 1010, time=12, goods_id=1015001, goods_num=1, price1 = 150, price2 = 105, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1011) -> 
    #base_limit_buy_shop{id = 1011, time=12, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1012) -> 
    #base_limit_buy_shop{id = 1012, time=12, goods_id=5101405, goods_num=1, price1 = 240, price2 = 168, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1013) -> 
    #base_limit_buy_shop{id = 1013, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1014) -> 
    #base_limit_buy_shop{id = 1014, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1015) -> 
    #base_limit_buy_shop{id = 1015, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1016) -> 
    #base_limit_buy_shop{id = 1016, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1017) -> 
    #base_limit_buy_shop{id = 1017, time=14, goods_id=8001069, goods_num=6, price1 = 450, price2 = 315, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1018) -> 
    #base_limit_buy_shop{id = 1018, time=14, goods_id=5101425, goods_num=1, price1 = 240, price2 = 168, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1019) -> 
    #base_limit_buy_shop{id = 1019, time=14, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1020) -> 
    #base_limit_buy_shop{id = 1020, time=14, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1021) -> 
    #base_limit_buy_shop{id = 1021, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1022) -> 
    #base_limit_buy_shop{id = 1022, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1023) -> 
    #base_limit_buy_shop{id = 1023, time=16, goods_id=5101415, goods_num=1, price1 = 240, price2 = 160, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1024) -> 
    #base_limit_buy_shop{id = 1024, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1025) -> 
    #base_limit_buy_shop{id = 1025, time=16, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1026) -> 
    #base_limit_buy_shop{id = 1026, time=16, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1027) -> 
    #base_limit_buy_shop{id = 1027, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1028) -> 
    #base_limit_buy_shop{id = 1028, time=18, goods_id=1015001, goods_num=1, price1 = 150, price2 = 105, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1029) -> 
    #base_limit_buy_shop{id = 1029, time=18, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1030) -> 
    #base_limit_buy_shop{id = 1030, time=18, goods_id=5101405, goods_num=1, price1 = 240, price2 = 168, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1031) -> 
    #base_limit_buy_shop{id = 1031, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1032) -> 
    #base_limit_buy_shop{id = 1032, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1033) -> 
    #base_limit_buy_shop{id = 1033, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1034) -> 
    #base_limit_buy_shop{id = 1034, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1035) -> 
    #base_limit_buy_shop{id = 1035, time=20, goods_id=8001069, goods_num=6, price1 = 450, price2 = 315, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1036) -> 
    #base_limit_buy_shop{id = 1036, time=20, goods_id=5101425, goods_num=1, price1 = 240, price2 = 168, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1037) -> 
    #base_limit_buy_shop{id = 1037, time=20, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1038) -> 
    #base_limit_buy_shop{id = 1038, time=20, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1039) -> 
    #base_limit_buy_shop{id = 1039, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1040) -> 
    #base_limit_buy_shop{id = 1040, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1041) -> 
    #base_limit_buy_shop{id = 1041, time=22, goods_id=5101415, goods_num=1, price1 = 240, price2 = 160, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1042) -> 
    #base_limit_buy_shop{id = 1042, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1043) -> 
    #base_limit_buy_shop{id = 1043, time=22, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1044) -> 
    #base_limit_buy_shop{id = 1044, time=22, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1045) -> 
    #base_limit_buy_shop{id = 1045, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1046) -> 
    #base_limit_buy_shop{id = 1046, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1047) -> 
    #base_limit_buy_shop{id = 1047, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1048) -> 
    #base_limit_buy_shop{id = 1048, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1049) -> 
    #base_limit_buy_shop{id = 1049, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1050) -> 
    #base_limit_buy_shop{id = 1050, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1051) -> 
    #base_limit_buy_shop{id = 1051, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1052) -> 
    #base_limit_buy_shop{id = 1052, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1053) -> 
    #base_limit_buy_shop{id = 1053, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1054) -> 
    #base_limit_buy_shop{id = 1054, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1055) -> 
    #base_limit_buy_shop{id = 1055, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1056) -> 
    #base_limit_buy_shop{id = 1056, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1057) -> 
    #base_limit_buy_shop{id = 1057, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1058) -> 
    #base_limit_buy_shop{id = 1058, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1059) -> 
    #base_limit_buy_shop{id = 1059, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1060) -> 
    #base_limit_buy_shop{id = 1060, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1061) -> 
    #base_limit_buy_shop{id = 1061, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1062) -> 
    #base_limit_buy_shop{id = 1062, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1063) -> 
    #base_limit_buy_shop{id = 1063, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1064) -> 
    #base_limit_buy_shop{id = 1064, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1065) -> 
    #base_limit_buy_shop{id = 1065, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1066) -> 
    #base_limit_buy_shop{id = 1066, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1067) -> 
    #base_limit_buy_shop{id = 1067, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1068) -> 
    #base_limit_buy_shop{id = 1068, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1069) -> 
    #base_limit_buy_shop{id = 1069, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1070) -> 
    #base_limit_buy_shop{id = 1070, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1071) -> 
    #base_limit_buy_shop{id = 1071, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1072) -> 
    #base_limit_buy_shop{id = 1072, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1073) -> 
    #base_limit_buy_shop{id = 1073, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1074) -> 
    #base_limit_buy_shop{id = 1074, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1075) -> 
    #base_limit_buy_shop{id = 1075, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1076) -> 
    #base_limit_buy_shop{id = 1076, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1077) -> 
    #base_limit_buy_shop{id = 1077, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1078) -> 
    #base_limit_buy_shop{id = 1078, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1079) -> 
    #base_limit_buy_shop{id = 1079, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1080) -> 
    #base_limit_buy_shop{id = 1080, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1081) -> 
    #base_limit_buy_shop{id = 1081, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1082) -> 
    #base_limit_buy_shop{id = 1082, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1083) -> 
    #base_limit_buy_shop{id = 1083, time=12, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1084) -> 
    #base_limit_buy_shop{id = 1084, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1085) -> 
    #base_limit_buy_shop{id = 1085, time=12, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1086) -> 
    #base_limit_buy_shop{id = 1086, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1087) -> 
    #base_limit_buy_shop{id = 1087, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1088) -> 
    #base_limit_buy_shop{id = 1088, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1089) -> 
    #base_limit_buy_shop{id = 1089, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1090) -> 
    #base_limit_buy_shop{id = 1090, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1091) -> 
    #base_limit_buy_shop{id = 1091, time=14, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1092) -> 
    #base_limit_buy_shop{id = 1092, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1093) -> 
    #base_limit_buy_shop{id = 1093, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1094) -> 
    #base_limit_buy_shop{id = 1094, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1095) -> 
    #base_limit_buy_shop{id = 1095, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1096) -> 
    #base_limit_buy_shop{id = 1096, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1097) -> 
    #base_limit_buy_shop{id = 1097, time=16, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1098) -> 
    #base_limit_buy_shop{id = 1098, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1099) -> 
    #base_limit_buy_shop{id = 1099, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1100) -> 
    #base_limit_buy_shop{id = 1100, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1101) -> 
    #base_limit_buy_shop{id = 1101, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1102) -> 
    #base_limit_buy_shop{id = 1102, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1103) -> 
    #base_limit_buy_shop{id = 1103, time=18, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1104) -> 
    #base_limit_buy_shop{id = 1104, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1105) -> 
    #base_limit_buy_shop{id = 1105, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1106) -> 
    #base_limit_buy_shop{id = 1106, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1107) -> 
    #base_limit_buy_shop{id = 1107, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1108) -> 
    #base_limit_buy_shop{id = 1108, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1109) -> 
    #base_limit_buy_shop{id = 1109, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1110) -> 
    #base_limit_buy_shop{id = 1110, time=20, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1111) -> 
    #base_limit_buy_shop{id = 1111, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1112) -> 
    #base_limit_buy_shop{id = 1112, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1113) -> 
    #base_limit_buy_shop{id = 1113, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1114) -> 
    #base_limit_buy_shop{id = 1114, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1115) -> 
    #base_limit_buy_shop{id = 1115, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1116) -> 
    #base_limit_buy_shop{id = 1116, time=22, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1117) -> 
    #base_limit_buy_shop{id = 1117, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1118) -> 
    #base_limit_buy_shop{id = 1118, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 32};
get(1119) -> 
    #base_limit_buy_shop{id = 1119, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1120) -> 
    #base_limit_buy_shop{id = 1120, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1121) -> 
    #base_limit_buy_shop{id = 1121, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1122) -> 
    #base_limit_buy_shop{id = 1122, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1123) -> 
    #base_limit_buy_shop{id = 1123, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1124) -> 
    #base_limit_buy_shop{id = 1124, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1125) -> 
    #base_limit_buy_shop{id = 1125, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1126) -> 
    #base_limit_buy_shop{id = 1126, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1127) -> 
    #base_limit_buy_shop{id = 1127, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1128) -> 
    #base_limit_buy_shop{id = 1128, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1129) -> 
    #base_limit_buy_shop{id = 1129, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1130) -> 
    #base_limit_buy_shop{id = 1130, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1131) -> 
    #base_limit_buy_shop{id = 1131, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1132) -> 
    #base_limit_buy_shop{id = 1132, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1133) -> 
    #base_limit_buy_shop{id = 1133, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1134) -> 
    #base_limit_buy_shop{id = 1134, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1135) -> 
    #base_limit_buy_shop{id = 1135, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1136) -> 
    #base_limit_buy_shop{id = 1136, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 32};
get(1137) -> 
    #base_limit_buy_shop{id = 1137, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1138) -> 
    #base_limit_buy_shop{id = 1138, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1139) -> 
    #base_limit_buy_shop{id = 1139, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1140) -> 
    #base_limit_buy_shop{id = 1140, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1141) -> 
    #base_limit_buy_shop{id = 1141, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1142) -> 
    #base_limit_buy_shop{id = 1142, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1143) -> 
    #base_limit_buy_shop{id = 1143, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1144) -> 
    #base_limit_buy_shop{id = 1144, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1145) -> 
    #base_limit_buy_shop{id = 1145, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1146) -> 
    #base_limit_buy_shop{id = 1146, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1147) -> 
    #base_limit_buy_shop{id = 1147, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1148) -> 
    #base_limit_buy_shop{id = 1148, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1149) -> 
    #base_limit_buy_shop{id = 1149, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1150) -> 
    #base_limit_buy_shop{id = 1150, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1151) -> 
    #base_limit_buy_shop{id = 1151, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1152) -> 
    #base_limit_buy_shop{id = 1152, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1153) -> 
    #base_limit_buy_shop{id = 1153, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1154) -> 
    #base_limit_buy_shop{id = 1154, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 33};
get(1155) -> 
    #base_limit_buy_shop{id = 1155, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1156) -> 
    #base_limit_buy_shop{id = 1156, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1157) -> 
    #base_limit_buy_shop{id = 1157, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1158) -> 
    #base_limit_buy_shop{id = 1158, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1159) -> 
    #base_limit_buy_shop{id = 1159, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1160) -> 
    #base_limit_buy_shop{id = 1160, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1161) -> 
    #base_limit_buy_shop{id = 1161, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1162) -> 
    #base_limit_buy_shop{id = 1162, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 33};
get(1163) -> 
    #base_limit_buy_shop{id = 1163, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1164) -> 
    #base_limit_buy_shop{id = 1164, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1165) -> 
    #base_limit_buy_shop{id = 1165, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1166) -> 
    #base_limit_buy_shop{id = 1166, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1167) -> 
    #base_limit_buy_shop{id = 1167, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1168) -> 
    #base_limit_buy_shop{id = 1168, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1169) -> 
    #base_limit_buy_shop{id = 1169, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1170) -> 
    #base_limit_buy_shop{id = 1170, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1171) -> 
    #base_limit_buy_shop{id = 1171, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1172) -> 
    #base_limit_buy_shop{id = 1172, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 33};
get(1173) -> 
    #base_limit_buy_shop{id = 1173, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1174) -> 
    #base_limit_buy_shop{id = 1174, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1175) -> 
    #base_limit_buy_shop{id = 1175, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1176) -> 
    #base_limit_buy_shop{id = 1176, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1177) -> 
    #base_limit_buy_shop{id = 1177, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1178) -> 
    #base_limit_buy_shop{id = 1178, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1179) -> 
    #base_limit_buy_shop{id = 1179, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1180) -> 
    #base_limit_buy_shop{id = 1180, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 33};
get(1181) -> 
    #base_limit_buy_shop{id = 1181, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1182) -> 
    #base_limit_buy_shop{id = 1182, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1183) -> 
    #base_limit_buy_shop{id = 1183, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1184) -> 
    #base_limit_buy_shop{id = 1184, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1185) -> 
    #base_limit_buy_shop{id = 1185, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1186) -> 
    #base_limit_buy_shop{id = 1186, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1187) -> 
    #base_limit_buy_shop{id = 1187, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1188) -> 
    #base_limit_buy_shop{id = 1188, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1189) -> 
    #base_limit_buy_shop{id = 1189, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1190) -> 
    #base_limit_buy_shop{id = 1190, time=12, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1191) -> 
    #base_limit_buy_shop{id = 1191, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1192) -> 
    #base_limit_buy_shop{id = 1192, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1193) -> 
    #base_limit_buy_shop{id = 1193, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1194) -> 
    #base_limit_buy_shop{id = 1194, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1195) -> 
    #base_limit_buy_shop{id = 1195, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1196) -> 
    #base_limit_buy_shop{id = 1196, time=14, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1197) -> 
    #base_limit_buy_shop{id = 1197, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1198) -> 
    #base_limit_buy_shop{id = 1198, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 34};
get(1199) -> 
    #base_limit_buy_shop{id = 1199, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1200) -> 
    #base_limit_buy_shop{id = 1200, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1201) -> 
    #base_limit_buy_shop{id = 1201, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1202) -> 
    #base_limit_buy_shop{id = 1202, time=16, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1203) -> 
    #base_limit_buy_shop{id = 1203, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1204) -> 
    #base_limit_buy_shop{id = 1204, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1205) -> 
    #base_limit_buy_shop{id = 1205, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1206) -> 
    #base_limit_buy_shop{id = 1206, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1207) -> 
    #base_limit_buy_shop{id = 1207, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1208) -> 
    #base_limit_buy_shop{id = 1208, time=18, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1209) -> 
    #base_limit_buy_shop{id = 1209, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1210) -> 
    #base_limit_buy_shop{id = 1210, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1211) -> 
    #base_limit_buy_shop{id = 1211, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1212) -> 
    #base_limit_buy_shop{id = 1212, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1213) -> 
    #base_limit_buy_shop{id = 1213, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1214) -> 
    #base_limit_buy_shop{id = 1214, time=20, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1215) -> 
    #base_limit_buy_shop{id = 1215, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1216) -> 
    #base_limit_buy_shop{id = 1216, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 34};
get(1217) -> 
    #base_limit_buy_shop{id = 1217, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1218) -> 
    #base_limit_buy_shop{id = 1218, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1219) -> 
    #base_limit_buy_shop{id = 1219, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1220) -> 
    #base_limit_buy_shop{id = 1220, time=22, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1221) -> 
    #base_limit_buy_shop{id = 1221, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1222) -> 
    #base_limit_buy_shop{id = 1222, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1223) -> 
    #base_limit_buy_shop{id = 1223, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1224) -> 
    #base_limit_buy_shop{id = 1224, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1225) -> 
    #base_limit_buy_shop{id = 1225, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1226) -> 
    #base_limit_buy_shop{id = 1226, time=12, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1227) -> 
    #base_limit_buy_shop{id = 1227, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1228) -> 
    #base_limit_buy_shop{id = 1228, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1229) -> 
    #base_limit_buy_shop{id = 1229, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1230) -> 
    #base_limit_buy_shop{id = 1230, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1231) -> 
    #base_limit_buy_shop{id = 1231, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1232) -> 
    #base_limit_buy_shop{id = 1232, time=14, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1233) -> 
    #base_limit_buy_shop{id = 1233, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1234) -> 
    #base_limit_buy_shop{id = 1234, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1235) -> 
    #base_limit_buy_shop{id = 1235, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1236) -> 
    #base_limit_buy_shop{id = 1236, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1237) -> 
    #base_limit_buy_shop{id = 1237, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1238) -> 
    #base_limit_buy_shop{id = 1238, time=16, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1239) -> 
    #base_limit_buy_shop{id = 1239, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1240) -> 
    #base_limit_buy_shop{id = 1240, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1241) -> 
    #base_limit_buy_shop{id = 1241, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1242) -> 
    #base_limit_buy_shop{id = 1242, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1243) -> 
    #base_limit_buy_shop{id = 1243, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1244) -> 
    #base_limit_buy_shop{id = 1244, time=18, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1245) -> 
    #base_limit_buy_shop{id = 1245, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1246) -> 
    #base_limit_buy_shop{id = 1246, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1247) -> 
    #base_limit_buy_shop{id = 1247, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1248) -> 
    #base_limit_buy_shop{id = 1248, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1249) -> 
    #base_limit_buy_shop{id = 1249, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1250) -> 
    #base_limit_buy_shop{id = 1250, time=20, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1251) -> 
    #base_limit_buy_shop{id = 1251, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1252) -> 
    #base_limit_buy_shop{id = 1252, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1253) -> 
    #base_limit_buy_shop{id = 1253, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1254) -> 
    #base_limit_buy_shop{id = 1254, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1255) -> 
    #base_limit_buy_shop{id = 1255, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1256) -> 
    #base_limit_buy_shop{id = 1256, time=22, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1257) -> 
    #base_limit_buy_shop{id = 1257, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1258) -> 
    #base_limit_buy_shop{id = 1258, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1259) -> 
    #base_limit_buy_shop{id = 1259, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1260) -> 
    #base_limit_buy_shop{id = 1260, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1261) -> 
    #base_limit_buy_shop{id = 1261, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1262) -> 
    #base_limit_buy_shop{id = 1262, time=12, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1263) -> 
    #base_limit_buy_shop{id = 1263, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1264) -> 
    #base_limit_buy_shop{id = 1264, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1265) -> 
    #base_limit_buy_shop{id = 1265, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1266) -> 
    #base_limit_buy_shop{id = 1266, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1267) -> 
    #base_limit_buy_shop{id = 1267, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1268) -> 
    #base_limit_buy_shop{id = 1268, time=14, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1269) -> 
    #base_limit_buy_shop{id = 1269, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1270) -> 
    #base_limit_buy_shop{id = 1270, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1271) -> 
    #base_limit_buy_shop{id = 1271, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1272) -> 
    #base_limit_buy_shop{id = 1272, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1273) -> 
    #base_limit_buy_shop{id = 1273, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1274) -> 
    #base_limit_buy_shop{id = 1274, time=16, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1275) -> 
    #base_limit_buy_shop{id = 1275, time=16, goods_id=3107001, goods_num=1, price1 = 400, price2 = 360, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1276) -> 
    #base_limit_buy_shop{id = 1276, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1277) -> 
    #base_limit_buy_shop{id = 1277, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1278) -> 
    #base_limit_buy_shop{id = 1278, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1279) -> 
    #base_limit_buy_shop{id = 1279, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1280) -> 
    #base_limit_buy_shop{id = 1280, time=18, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1281) -> 
    #base_limit_buy_shop{id = 1281, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1282) -> 
    #base_limit_buy_shop{id = 1282, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1283) -> 
    #base_limit_buy_shop{id = 1283, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1284) -> 
    #base_limit_buy_shop{id = 1284, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1285) -> 
    #base_limit_buy_shop{id = 1285, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1286) -> 
    #base_limit_buy_shop{id = 1286, time=20, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1287) -> 
    #base_limit_buy_shop{id = 1287, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1288) -> 
    #base_limit_buy_shop{id = 1288, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1289) -> 
    #base_limit_buy_shop{id = 1289, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1290) -> 
    #base_limit_buy_shop{id = 1290, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1291) -> 
    #base_limit_buy_shop{id = 1291, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1292) -> 
    #base_limit_buy_shop{id = 1292, time=22, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1293) -> 
    #base_limit_buy_shop{id = 1293, time=22, goods_id=3107001, goods_num=1, price1 = 400, price2 = 360, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1294) -> 
    #base_limit_buy_shop{id = 1294, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1295) -> 
    #base_limit_buy_shop{id = 1295, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1296) -> 
    #base_limit_buy_shop{id = 1296, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1297) -> 
    #base_limit_buy_shop{id = 1297, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1298) -> 
    #base_limit_buy_shop{id = 1298, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1299) -> 
    #base_limit_buy_shop{id = 1299, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1300) -> 
    #base_limit_buy_shop{id = 1300, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1301) -> 
    #base_limit_buy_shop{id = 1301, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1302) -> 
    #base_limit_buy_shop{id = 1302, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1303) -> 
    #base_limit_buy_shop{id = 1303, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1304) -> 
    #base_limit_buy_shop{id = 1304, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1305) -> 
    #base_limit_buy_shop{id = 1305, time=14, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1306) -> 
    #base_limit_buy_shop{id = 1306, time=14, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1307) -> 
    #base_limit_buy_shop{id = 1307, time=14, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1308) -> 
    #base_limit_buy_shop{id = 1308, time=14, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1309) -> 
    #base_limit_buy_shop{id = 1309, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1310) -> 
    #base_limit_buy_shop{id = 1310, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1311) -> 
    #base_limit_buy_shop{id = 1311, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1312) -> 
    #base_limit_buy_shop{id = 1312, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1313) -> 
    #base_limit_buy_shop{id = 1313, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1314) -> 
    #base_limit_buy_shop{id = 1314, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1315) -> 
    #base_limit_buy_shop{id = 1315, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1316) -> 
    #base_limit_buy_shop{id = 1316, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1317) -> 
    #base_limit_buy_shop{id = 1317, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1318) -> 
    #base_limit_buy_shop{id = 1318, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1319) -> 
    #base_limit_buy_shop{id = 1319, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1320) -> 
    #base_limit_buy_shop{id = 1320, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1321) -> 
    #base_limit_buy_shop{id = 1321, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1322) -> 
    #base_limit_buy_shop{id = 1322, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1323) -> 
    #base_limit_buy_shop{id = 1323, time=20, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1324) -> 
    #base_limit_buy_shop{id = 1324, time=20, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1325) -> 
    #base_limit_buy_shop{id = 1325, time=20, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1326) -> 
    #base_limit_buy_shop{id = 1326, time=20, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1327) -> 
    #base_limit_buy_shop{id = 1327, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1328) -> 
    #base_limit_buy_shop{id = 1328, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1329) -> 
    #base_limit_buy_shop{id = 1329, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1330) -> 
    #base_limit_buy_shop{id = 1330, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1331) -> 
    #base_limit_buy_shop{id = 1331, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1332) -> 
    #base_limit_buy_shop{id = 1332, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1333) -> 
    #base_limit_buy_shop{id = 1333, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1334) -> 
    #base_limit_buy_shop{id = 1334, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1335) -> 
    #base_limit_buy_shop{id = 1335, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1336) -> 
    #base_limit_buy_shop{id = 1336, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1337) -> 
    #base_limit_buy_shop{id = 1337, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1338) -> 
    #base_limit_buy_shop{id = 1338, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1339) -> 
    #base_limit_buy_shop{id = 1339, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1340) -> 
    #base_limit_buy_shop{id = 1340, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1341) -> 
    #base_limit_buy_shop{id = 1341, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1342) -> 
    #base_limit_buy_shop{id = 1342, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1343) -> 
    #base_limit_buy_shop{id = 1343, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1344) -> 
    #base_limit_buy_shop{id = 1344, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1345) -> 
    #base_limit_buy_shop{id = 1345, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1346) -> 
    #base_limit_buy_shop{id = 1346, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1347) -> 
    #base_limit_buy_shop{id = 1347, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1348) -> 
    #base_limit_buy_shop{id = 1348, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1349) -> 
    #base_limit_buy_shop{id = 1349, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1350) -> 
    #base_limit_buy_shop{id = 1350, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1351) -> 
    #base_limit_buy_shop{id = 1351, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1352) -> 
    #base_limit_buy_shop{id = 1352, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1353) -> 
    #base_limit_buy_shop{id = 1353, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1354) -> 
    #base_limit_buy_shop{id = 1354, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1355) -> 
    #base_limit_buy_shop{id = 1355, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1356) -> 
    #base_limit_buy_shop{id = 1356, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1357) -> 
    #base_limit_buy_shop{id = 1357, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1358) -> 
    #base_limit_buy_shop{id = 1358, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1359) -> 
    #base_limit_buy_shop{id = 1359, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1360) -> 
    #base_limit_buy_shop{id = 1360, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1361) -> 
    #base_limit_buy_shop{id = 1361, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1362) -> 
    #base_limit_buy_shop{id = 1362, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1363) -> 
    #base_limit_buy_shop{id = 1363, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1364) -> 
    #base_limit_buy_shop{id = 1364, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1365) -> 
    #base_limit_buy_shop{id = 1365, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1366) -> 
    #base_limit_buy_shop{id = 1366, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1367) -> 
    #base_limit_buy_shop{id = 1367, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1368) -> 
    #base_limit_buy_shop{id = 1368, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1369) -> 
    #base_limit_buy_shop{id = 1369, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1370) -> 
    #base_limit_buy_shop{id = 1370, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1371) -> 
    #base_limit_buy_shop{id = 1371, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1372) -> 
    #base_limit_buy_shop{id = 1372, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1373) -> 
    #base_limit_buy_shop{id = 1373, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1374) -> 
    #base_limit_buy_shop{id = 1374, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1375) -> 
    #base_limit_buy_shop{id = 1375, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1376) -> 
    #base_limit_buy_shop{id = 1376, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1377) -> 
    #base_limit_buy_shop{id = 1377, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1378) -> 
    #base_limit_buy_shop{id = 1378, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1379) -> 
    #base_limit_buy_shop{id = 1379, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1380) -> 
    #base_limit_buy_shop{id = 1380, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1381) -> 
    #base_limit_buy_shop{id = 1381, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1382) -> 
    #base_limit_buy_shop{id = 1382, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1383) -> 
    #base_limit_buy_shop{id = 1383, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1384) -> 
    #base_limit_buy_shop{id = 1384, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1385) -> 
    #base_limit_buy_shop{id = 1385, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1386) -> 
    #base_limit_buy_shop{id = 1386, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1387) -> 
    #base_limit_buy_shop{id = 1387, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1388) -> 
    #base_limit_buy_shop{id = 1388, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1389) -> 
    #base_limit_buy_shop{id = 1389, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1390) -> 
    #base_limit_buy_shop{id = 1390, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1391) -> 
    #base_limit_buy_shop{id = 1391, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1392) -> 
    #base_limit_buy_shop{id = 1392, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1393) -> 
    #base_limit_buy_shop{id = 1393, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1394) -> 
    #base_limit_buy_shop{id = 1394, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1395) -> 
    #base_limit_buy_shop{id = 1395, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1396) -> 
    #base_limit_buy_shop{id = 1396, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1397) -> 
    #base_limit_buy_shop{id = 1397, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1398) -> 
    #base_limit_buy_shop{id = 1398, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1399) -> 
    #base_limit_buy_shop{id = 1399, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1400) -> 
    #base_limit_buy_shop{id = 1400, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1401) -> 
    #base_limit_buy_shop{id = 1401, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1402) -> 
    #base_limit_buy_shop{id = 1402, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1403) -> 
    #base_limit_buy_shop{id = 1403, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1404) -> 
    #base_limit_buy_shop{id = 1404, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1405) -> 
    #base_limit_buy_shop{id = 1405, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1406) -> 
    #base_limit_buy_shop{id = 1406, time=12, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1407) -> 
    #base_limit_buy_shop{id = 1407, time=12, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1408) -> 
    #base_limit_buy_shop{id = 1408, time=12, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1409) -> 
    #base_limit_buy_shop{id = 1409, time=12, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1410) -> 
    #base_limit_buy_shop{id = 1410, time=12, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1411) -> 
    #base_limit_buy_shop{id = 1411, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1412) -> 
    #base_limit_buy_shop{id = 1412, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1413) -> 
    #base_limit_buy_shop{id = 1413, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1414) -> 
    #base_limit_buy_shop{id = 1414, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1415) -> 
    #base_limit_buy_shop{id = 1415, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1416) -> 
    #base_limit_buy_shop{id = 1416, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1417) -> 
    #base_limit_buy_shop{id = 1417, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1418) -> 
    #base_limit_buy_shop{id = 1418, time=16, goods_id=20340, goods_num=99, price1 = 1485, price2 = 297, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1419) -> 
    #base_limit_buy_shop{id = 1419, time=16, goods_id=1010005, goods_num=10, price1 = 150, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1420) -> 
    #base_limit_buy_shop{id = 1420, time=16, goods_id=1010006, goods_num=10, price1 = 1350, price2 = 338, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1421) -> 
    #base_limit_buy_shop{id = 1421, time=16, goods_id=4503001, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1422) -> 
    #base_limit_buy_shop{id = 1422, time=16, goods_id=4503002, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1423) -> 
    #base_limit_buy_shop{id = 1423, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1424) -> 
    #base_limit_buy_shop{id = 1424, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1425) -> 
    #base_limit_buy_shop{id = 1425, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1426) -> 
    #base_limit_buy_shop{id = 1426, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1427) -> 
    #base_limit_buy_shop{id = 1427, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1428) -> 
    #base_limit_buy_shop{id = 1428, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1429) -> 
    #base_limit_buy_shop{id = 1429, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1430) -> 
    #base_limit_buy_shop{id = 1430, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1431) -> 
    #base_limit_buy_shop{id = 1431, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1432) -> 
    #base_limit_buy_shop{id = 1432, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1433) -> 
    #base_limit_buy_shop{id = 1433, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1434) -> 
    #base_limit_buy_shop{id = 1434, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1435) -> 
    #base_limit_buy_shop{id = 1435, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1436) -> 
    #base_limit_buy_shop{id = 1436, time=22, goods_id=20340, goods_num=99, price1 = 1485, price2 = 297, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1437) -> 
    #base_limit_buy_shop{id = 1437, time=22, goods_id=1010005, goods_num=10, price1 = 150, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1438) -> 
    #base_limit_buy_shop{id = 1438, time=22, goods_id=1010006, goods_num=10, price1 = 1350, price2 = 338, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1439) -> 
    #base_limit_buy_shop{id = 1439, time=22, goods_id=4503001, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1440) -> 
    #base_limit_buy_shop{id = 1440, time=22, goods_id=4503002, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1441) -> 
    #base_limit_buy_shop{id = 1441, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1442) -> 
    #base_limit_buy_shop{id = 1442, time=12, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1443) -> 
    #base_limit_buy_shop{id = 1443, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1444) -> 
    #base_limit_buy_shop{id = 1444, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1445) -> 
    #base_limit_buy_shop{id = 1445, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1446) -> 
    #base_limit_buy_shop{id = 1446, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1447) -> 
    #base_limit_buy_shop{id = 1447, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1448) -> 
    #base_limit_buy_shop{id = 1448, time=14, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1449) -> 
    #base_limit_buy_shop{id = 1449, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1450) -> 
    #base_limit_buy_shop{id = 1450, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1451) -> 
    #base_limit_buy_shop{id = 1451, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1452) -> 
    #base_limit_buy_shop{id = 1452, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1453) -> 
    #base_limit_buy_shop{id = 1453, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1454) -> 
    #base_limit_buy_shop{id = 1454, time=16, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1455) -> 
    #base_limit_buy_shop{id = 1455, time=16, goods_id=3107002, goods_num=1, price1 = 400, price2 = 360, buy_num = 10,  sys_buy_num = 10, type = 41};
get(1456) -> 
    #base_limit_buy_shop{id = 1456, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1457) -> 
    #base_limit_buy_shop{id = 1457, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1458) -> 
    #base_limit_buy_shop{id = 1458, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1459) -> 
    #base_limit_buy_shop{id = 1459, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1460) -> 
    #base_limit_buy_shop{id = 1460, time=18, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1461) -> 
    #base_limit_buy_shop{id = 1461, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1462) -> 
    #base_limit_buy_shop{id = 1462, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1463) -> 
    #base_limit_buy_shop{id = 1463, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1464) -> 
    #base_limit_buy_shop{id = 1464, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1465) -> 
    #base_limit_buy_shop{id = 1465, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1466) -> 
    #base_limit_buy_shop{id = 1466, time=20, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1467) -> 
    #base_limit_buy_shop{id = 1467, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1468) -> 
    #base_limit_buy_shop{id = 1468, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1469) -> 
    #base_limit_buy_shop{id = 1469, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1470) -> 
    #base_limit_buy_shop{id = 1470, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1471) -> 
    #base_limit_buy_shop{id = 1471, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1472) -> 
    #base_limit_buy_shop{id = 1472, time=22, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1473) -> 
    #base_limit_buy_shop{id = 1473, time=22, goods_id=3107002, goods_num=1, price1 = 400, price2 = 360, buy_num = 10,  sys_buy_num = 10, type = 41};
get(1474) -> 
    #base_limit_buy_shop{id = 1474, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1475) -> 
    #base_limit_buy_shop{id = 1475, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1476) -> 
    #base_limit_buy_shop{id = 1476, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1477) -> 
    #base_limit_buy_shop{id = 1477, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1478) -> 
    #base_limit_buy_shop{id = 1478, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1479) -> 
    #base_limit_buy_shop{id = 1479, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1480) -> 
    #base_limit_buy_shop{id = 1480, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1481) -> 
    #base_limit_buy_shop{id = 1481, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1482) -> 
    #base_limit_buy_shop{id = 1482, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1483) -> 
    #base_limit_buy_shop{id = 1483, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1484) -> 
    #base_limit_buy_shop{id = 1484, time=14, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1485) -> 
    #base_limit_buy_shop{id = 1485, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1486) -> 
    #base_limit_buy_shop{id = 1486, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1487) -> 
    #base_limit_buy_shop{id = 1487, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1488) -> 
    #base_limit_buy_shop{id = 1488, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1489) -> 
    #base_limit_buy_shop{id = 1489, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1490) -> 
    #base_limit_buy_shop{id = 1490, time=16, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1491) -> 
    #base_limit_buy_shop{id = 1491, time=16, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 30, type = 42};
get(1492) -> 
    #base_limit_buy_shop{id = 1492, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1493) -> 
    #base_limit_buy_shop{id = 1493, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1494) -> 
    #base_limit_buy_shop{id = 1494, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1495) -> 
    #base_limit_buy_shop{id = 1495, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1496) -> 
    #base_limit_buy_shop{id = 1496, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1497) -> 
    #base_limit_buy_shop{id = 1497, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1498) -> 
    #base_limit_buy_shop{id = 1498, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1499) -> 
    #base_limit_buy_shop{id = 1499, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1500) -> 
    #base_limit_buy_shop{id = 1500, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1501) -> 
    #base_limit_buy_shop{id = 1501, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1502) -> 
    #base_limit_buy_shop{id = 1502, time=20, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1503) -> 
    #base_limit_buy_shop{id = 1503, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1504) -> 
    #base_limit_buy_shop{id = 1504, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1505) -> 
    #base_limit_buy_shop{id = 1505, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1506) -> 
    #base_limit_buy_shop{id = 1506, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1507) -> 
    #base_limit_buy_shop{id = 1507, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1508) -> 
    #base_limit_buy_shop{id = 1508, time=22, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1509) -> 
    #base_limit_buy_shop{id = 1509, time=22, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 30, type = 42};
get(1510) -> 
    #base_limit_buy_shop{id = 1510, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1511) -> 
    #base_limit_buy_shop{id = 1511, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1512) -> 
    #base_limit_buy_shop{id = 1512, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1513) -> 
    #base_limit_buy_shop{id = 1513, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1514) -> 
    #base_limit_buy_shop{id = 1514, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1515) -> 
    #base_limit_buy_shop{id = 1515, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1516) -> 
    #base_limit_buy_shop{id = 1516, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1517) -> 
    #base_limit_buy_shop{id = 1517, time=12, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1518) -> 
    #base_limit_buy_shop{id = 1518, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1519) -> 
    #base_limit_buy_shop{id = 1519, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1520) -> 
    #base_limit_buy_shop{id = 1520, time=14, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1521) -> 
    #base_limit_buy_shop{id = 1521, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1522) -> 
    #base_limit_buy_shop{id = 1522, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1523) -> 
    #base_limit_buy_shop{id = 1523, time=14, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1524) -> 
    #base_limit_buy_shop{id = 1524, time=14, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1525) -> 
    #base_limit_buy_shop{id = 1525, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1526) -> 
    #base_limit_buy_shop{id = 1526, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1527) -> 
    #base_limit_buy_shop{id = 1527, time=16, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 10, type = 43};
get(1528) -> 
    #base_limit_buy_shop{id = 1528, time=16, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1529) -> 
    #base_limit_buy_shop{id = 1529, time=16, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1530) -> 
    #base_limit_buy_shop{id = 1530, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1531) -> 
    #base_limit_buy_shop{id = 1531, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1532) -> 
    #base_limit_buy_shop{id = 1532, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1533) -> 
    #base_limit_buy_shop{id = 1533, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1534) -> 
    #base_limit_buy_shop{id = 1534, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1535) -> 
    #base_limit_buy_shop{id = 1535, time=18, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1536) -> 
    #base_limit_buy_shop{id = 1536, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1537) -> 
    #base_limit_buy_shop{id = 1537, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1538) -> 
    #base_limit_buy_shop{id = 1538, time=20, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1539) -> 
    #base_limit_buy_shop{id = 1539, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1540) -> 
    #base_limit_buy_shop{id = 1540, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1541) -> 
    #base_limit_buy_shop{id = 1541, time=20, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1542) -> 
    #base_limit_buy_shop{id = 1542, time=20, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1543) -> 
    #base_limit_buy_shop{id = 1543, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1544) -> 
    #base_limit_buy_shop{id = 1544, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1545) -> 
    #base_limit_buy_shop{id = 1545, time=22, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 10, type = 43};
get(1546) -> 
    #base_limit_buy_shop{id = 1546, time=22, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1547) -> 
    #base_limit_buy_shop{id = 1547, time=22, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1548) -> 
    #base_limit_buy_shop{id = 1548, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1549) -> 
    #base_limit_buy_shop{id = 1549, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1550) -> 
    #base_limit_buy_shop{id = 1550, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1551) -> 
    #base_limit_buy_shop{id = 1551, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1552) -> 
    #base_limit_buy_shop{id = 1552, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1553) -> 
    #base_limit_buy_shop{id = 1553, time=12, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1554) -> 
    #base_limit_buy_shop{id = 1554, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1555) -> 
    #base_limit_buy_shop{id = 1555, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1556) -> 
    #base_limit_buy_shop{id = 1556, time=14, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1557) -> 
    #base_limit_buy_shop{id = 1557, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1558) -> 
    #base_limit_buy_shop{id = 1558, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1559) -> 
    #base_limit_buy_shop{id = 1559, time=14, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1560) -> 
    #base_limit_buy_shop{id = 1560, time=14, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1561) -> 
    #base_limit_buy_shop{id = 1561, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1562) -> 
    #base_limit_buy_shop{id = 1562, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1563) -> 
    #base_limit_buy_shop{id = 1563, time=16, goods_id=6602008, goods_num=1, price1 = 200, price2 = 180, buy_num = 10,  sys_buy_num = 10, type = 44};
get(1564) -> 
    #base_limit_buy_shop{id = 1564, time=16, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1565) -> 
    #base_limit_buy_shop{id = 1565, time=16, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1566) -> 
    #base_limit_buy_shop{id = 1566, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1567) -> 
    #base_limit_buy_shop{id = 1567, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1568) -> 
    #base_limit_buy_shop{id = 1568, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1569) -> 
    #base_limit_buy_shop{id = 1569, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1570) -> 
    #base_limit_buy_shop{id = 1570, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1571) -> 
    #base_limit_buy_shop{id = 1571, time=18, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1572) -> 
    #base_limit_buy_shop{id = 1572, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1573) -> 
    #base_limit_buy_shop{id = 1573, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1574) -> 
    #base_limit_buy_shop{id = 1574, time=20, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1575) -> 
    #base_limit_buy_shop{id = 1575, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1576) -> 
    #base_limit_buy_shop{id = 1576, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1577) -> 
    #base_limit_buy_shop{id = 1577, time=20, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1578) -> 
    #base_limit_buy_shop{id = 1578, time=20, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1579) -> 
    #base_limit_buy_shop{id = 1579, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1580) -> 
    #base_limit_buy_shop{id = 1580, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1581) -> 
    #base_limit_buy_shop{id = 1581, time=22, goods_id=6602008, goods_num=1, price1 = 200, price2 = 180, buy_num = 10,  sys_buy_num = 10, type = 44};
get(1582) -> 
    #base_limit_buy_shop{id = 1582, time=22, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1583) -> 
    #base_limit_buy_shop{id = 1583, time=22, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1584) -> 
    #base_limit_buy_shop{id = 1584, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1585) -> 
    #base_limit_buy_shop{id = 1585, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1586) -> 
    #base_limit_buy_shop{id = 1586, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1587) -> 
    #base_limit_buy_shop{id = 1587, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1588) -> 
    #base_limit_buy_shop{id = 1588, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1589) -> 
    #base_limit_buy_shop{id = 1589, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1590) -> 
    #base_limit_buy_shop{id = 1590, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1591) -> 
    #base_limit_buy_shop{id = 1591, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1592) -> 
    #base_limit_buy_shop{id = 1592, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1593) -> 
    #base_limit_buy_shop{id = 1593, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1594) -> 
    #base_limit_buy_shop{id = 1594, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1595) -> 
    #base_limit_buy_shop{id = 1595, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1596) -> 
    #base_limit_buy_shop{id = 1596, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1597) -> 
    #base_limit_buy_shop{id = 1597, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1598) -> 
    #base_limit_buy_shop{id = 1598, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1599) -> 
    #base_limit_buy_shop{id = 1599, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1600) -> 
    #base_limit_buy_shop{id = 1600, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1601) -> 
    #base_limit_buy_shop{id = 1601, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1602) -> 
    #base_limit_buy_shop{id = 1602, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1603) -> 
    #base_limit_buy_shop{id = 1603, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1604) -> 
    #base_limit_buy_shop{id = 1604, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1605) -> 
    #base_limit_buy_shop{id = 1605, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1606) -> 
    #base_limit_buy_shop{id = 1606, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1607) -> 
    #base_limit_buy_shop{id = 1607, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1608) -> 
    #base_limit_buy_shop{id = 1608, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1609) -> 
    #base_limit_buy_shop{id = 1609, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1610) -> 
    #base_limit_buy_shop{id = 1610, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1611) -> 
    #base_limit_buy_shop{id = 1611, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1612) -> 
    #base_limit_buy_shop{id = 1612, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1613) -> 
    #base_limit_buy_shop{id = 1613, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1614) -> 
    #base_limit_buy_shop{id = 1614, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1615) -> 
    #base_limit_buy_shop{id = 1615, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1616) -> 
    #base_limit_buy_shop{id = 1616, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1617) -> 
    #base_limit_buy_shop{id = 1617, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1618) -> 
    #base_limit_buy_shop{id = 1618, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1619) -> 
    #base_limit_buy_shop{id = 1619, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1620) -> 
    #base_limit_buy_shop{id = 1620, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1621) -> 
    #base_limit_buy_shop{id = 1621, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1622) -> 
    #base_limit_buy_shop{id = 1622, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1623) -> 
    #base_limit_buy_shop{id = 1623, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1624) -> 
    #base_limit_buy_shop{id = 1624, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1625) -> 
    #base_limit_buy_shop{id = 1625, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1626) -> 
    #base_limit_buy_shop{id = 1626, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1627) -> 
    #base_limit_buy_shop{id = 1627, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1628) -> 
    #base_limit_buy_shop{id = 1628, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1629) -> 
    #base_limit_buy_shop{id = 1629, time=14, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1630) -> 
    #base_limit_buy_shop{id = 1630, time=14, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1631) -> 
    #base_limit_buy_shop{id = 1631, time=14, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1632) -> 
    #base_limit_buy_shop{id = 1632, time=14, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1633) -> 
    #base_limit_buy_shop{id = 1633, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1634) -> 
    #base_limit_buy_shop{id = 1634, time=16, goods_id=3101000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1635) -> 
    #base_limit_buy_shop{id = 1635, time=16, goods_id=3201000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1636) -> 
    #base_limit_buy_shop{id = 1636, time=16, goods_id=3301000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1637) -> 
    #base_limit_buy_shop{id = 1637, time=16, goods_id=3401000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1638) -> 
    #base_limit_buy_shop{id = 1638, time=16, goods_id=3501000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1639) -> 
    #base_limit_buy_shop{id = 1639, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1640) -> 
    #base_limit_buy_shop{id = 1640, time=18, goods_id=3101000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1641) -> 
    #base_limit_buy_shop{id = 1641, time=18, goods_id=3201000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1642) -> 
    #base_limit_buy_shop{id = 1642, time=18, goods_id=3301000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1643) -> 
    #base_limit_buy_shop{id = 1643, time=18, goods_id=3401000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1644) -> 
    #base_limit_buy_shop{id = 1644, time=18, goods_id=3501000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1645) -> 
    #base_limit_buy_shop{id = 1645, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1646) -> 
    #base_limit_buy_shop{id = 1646, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1647) -> 
    #base_limit_buy_shop{id = 1647, time=20, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1648) -> 
    #base_limit_buy_shop{id = 1648, time=20, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1649) -> 
    #base_limit_buy_shop{id = 1649, time=20, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1650) -> 
    #base_limit_buy_shop{id = 1650, time=20, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1651) -> 
    #base_limit_buy_shop{id = 1651, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1652) -> 
    #base_limit_buy_shop{id = 1652, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1653) -> 
    #base_limit_buy_shop{id = 1653, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1654) -> 
    #base_limit_buy_shop{id = 1654, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1655) -> 
    #base_limit_buy_shop{id = 1655, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1656) -> 
    #base_limit_buy_shop{id = 1656, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1657) -> 
    #base_limit_buy_shop{id = 1657, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1658) -> 
    #base_limit_buy_shop{id = 1658, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1659) -> 
    #base_limit_buy_shop{id = 1659, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1660) -> 
    #base_limit_buy_shop{id = 1660, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1661) -> 
    #base_limit_buy_shop{id = 1661, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1662) -> 
    #base_limit_buy_shop{id = 1662, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1663) -> 
    #base_limit_buy_shop{id = 1663, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1664) -> 
    #base_limit_buy_shop{id = 1664, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1665) -> 
    #base_limit_buy_shop{id = 1665, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1666) -> 
    #base_limit_buy_shop{id = 1666, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1667) -> 
    #base_limit_buy_shop{id = 1667, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1668) -> 
    #base_limit_buy_shop{id = 1668, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1669) -> 
    #base_limit_buy_shop{id = 1669, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1670) -> 
    #base_limit_buy_shop{id = 1670, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1671) -> 
    #base_limit_buy_shop{id = 1671, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1672) -> 
    #base_limit_buy_shop{id = 1672, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1673) -> 
    #base_limit_buy_shop{id = 1673, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1674) -> 
    #base_limit_buy_shop{id = 1674, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1675) -> 
    #base_limit_buy_shop{id = 1675, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1676) -> 
    #base_limit_buy_shop{id = 1676, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1677) -> 
    #base_limit_buy_shop{id = 1677, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1678) -> 
    #base_limit_buy_shop{id = 1678, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1679) -> 
    #base_limit_buy_shop{id = 1679, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1680) -> 
    #base_limit_buy_shop{id = 1680, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1681) -> 
    #base_limit_buy_shop{id = 1681, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1682) -> 
    #base_limit_buy_shop{id = 1682, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1683) -> 
    #base_limit_buy_shop{id = 1683, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1684) -> 
    #base_limit_buy_shop{id = 1684, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1685) -> 
    #base_limit_buy_shop{id = 1685, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1686) -> 
    #base_limit_buy_shop{id = 1686, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1687) -> 
    #base_limit_buy_shop{id = 1687, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1688) -> 
    #base_limit_buy_shop{id = 1688, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1689) -> 
    #base_limit_buy_shop{id = 1689, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1690) -> 
    #base_limit_buy_shop{id = 1690, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1691) -> 
    #base_limit_buy_shop{id = 1691, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1692) -> 
    #base_limit_buy_shop{id = 1692, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1693) -> 
    #base_limit_buy_shop{id = 1693, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1694) -> 
    #base_limit_buy_shop{id = 1694, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1695) -> 
    #base_limit_buy_shop{id = 1695, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1696) -> 
    #base_limit_buy_shop{id = 1696, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1697) -> 
    #base_limit_buy_shop{id = 1697, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1698) -> 
    #base_limit_buy_shop{id = 1698, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1699) -> 
    #base_limit_buy_shop{id = 1699, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1700) -> 
    #base_limit_buy_shop{id = 1700, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1701) -> 
    #base_limit_buy_shop{id = 1701, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1702) -> 
    #base_limit_buy_shop{id = 1702, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1703) -> 
    #base_limit_buy_shop{id = 1703, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1704) -> 
    #base_limit_buy_shop{id = 1704, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1705) -> 
    #base_limit_buy_shop{id = 1705, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1706) -> 
    #base_limit_buy_shop{id = 1706, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1707) -> 
    #base_limit_buy_shop{id = 1707, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1708) -> 
    #base_limit_buy_shop{id = 1708, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1709) -> 
    #base_limit_buy_shop{id = 1709, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1710) -> 
    #base_limit_buy_shop{id = 1710, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1711) -> 
    #base_limit_buy_shop{id = 1711, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1712) -> 
    #base_limit_buy_shop{id = 1712, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1713) -> 
    #base_limit_buy_shop{id = 1713, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1714) -> 
    #base_limit_buy_shop{id = 1714, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1715) -> 
    #base_limit_buy_shop{id = 1715, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1716) -> 
    #base_limit_buy_shop{id = 1716, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1717) -> 
    #base_limit_buy_shop{id = 1717, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1718) -> 
    #base_limit_buy_shop{id = 1718, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1719) -> 
    #base_limit_buy_shop{id = 1719, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1720) -> 
    #base_limit_buy_shop{id = 1720, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1721) -> 
    #base_limit_buy_shop{id = 1721, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1722) -> 
    #base_limit_buy_shop{id = 1722, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1723) -> 
    #base_limit_buy_shop{id = 1723, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1724) -> 
    #base_limit_buy_shop{id = 1724, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1725) -> 
    #base_limit_buy_shop{id = 1725, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1726) -> 
    #base_limit_buy_shop{id = 1726, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1727) -> 
    #base_limit_buy_shop{id = 1727, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1728) -> 
    #base_limit_buy_shop{id = 1728, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1729) -> 
    #base_limit_buy_shop{id = 1729, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1730) -> 
    #base_limit_buy_shop{id = 1730, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 84, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1731) -> 
    #base_limit_buy_shop{id = 1731, time=12, goods_id=2003000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1732) -> 
    #base_limit_buy_shop{id = 1732, time=12, goods_id=8002516, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1733) -> 
    #base_limit_buy_shop{id = 1733, time=12, goods_id=7302001, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1734) -> 
    #base_limit_buy_shop{id = 1734, time=12, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1735) -> 
    #base_limit_buy_shop{id = 1735, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1736) -> 
    #base_limit_buy_shop{id = 1736, time=14, goods_id=2001000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1737) -> 
    #base_limit_buy_shop{id = 1737, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1738) -> 
    #base_limit_buy_shop{id = 1738, time=14, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1739) -> 
    #base_limit_buy_shop{id = 1739, time=14, goods_id=2002000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1740) -> 
    #base_limit_buy_shop{id = 1740, time=14, goods_id=7303005, goods_num=5, price1 = 150, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1741) -> 
    #base_limit_buy_shop{id = 1741, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1742) -> 
    #base_limit_buy_shop{id = 1742, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1743) -> 
    #base_limit_buy_shop{id = 1743, time=16, goods_id=10101, goods_num=60000, price1 = 60, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1744) -> 
    #base_limit_buy_shop{id = 1744, time=16, goods_id=7321002, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1745) -> 
    #base_limit_buy_shop{id = 1745, time=16, goods_id=8002518, goods_num=40, price1 = 800, price2 = 280, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1746) -> 
    #base_limit_buy_shop{id = 1746, time=16, goods_id=7321001, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1747) -> 
    #base_limit_buy_shop{id = 1747, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1748) -> 
    #base_limit_buy_shop{id = 1748, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1749) -> 
    #base_limit_buy_shop{id = 1749, time=18, goods_id=2003000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1750) -> 
    #base_limit_buy_shop{id = 1750, time=18, goods_id=8002516, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1751) -> 
    #base_limit_buy_shop{id = 1751, time=18, goods_id=7302001, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1752) -> 
    #base_limit_buy_shop{id = 1752, time=18, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1753) -> 
    #base_limit_buy_shop{id = 1753, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1754) -> 
    #base_limit_buy_shop{id = 1754, time=20, goods_id=2001000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1755) -> 
    #base_limit_buy_shop{id = 1755, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1756) -> 
    #base_limit_buy_shop{id = 1756, time=20, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1757) -> 
    #base_limit_buy_shop{id = 1757, time=20, goods_id=2002000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1758) -> 
    #base_limit_buy_shop{id = 1758, time=20, goods_id=7303010, goods_num=5, price1 = 250, price2 = 125, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1759) -> 
    #base_limit_buy_shop{id = 1759, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1760) -> 
    #base_limit_buy_shop{id = 1760, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1761) -> 
    #base_limit_buy_shop{id = 1761, time=22, goods_id=10101, goods_num=60000, price1 = 60, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1762) -> 
    #base_limit_buy_shop{id = 1762, time=22, goods_id=7321002, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1763) -> 
    #base_limit_buy_shop{id = 1763, time=22, goods_id=8002518, goods_num=40, price1 = 800, price2 = 280, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1764) -> 
    #base_limit_buy_shop{id = 1764, time=22, goods_id=7321001, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(_id) -> [].

get(1, 12, 1) -> 
    #base_limit_buy_shop{id = 1, time=12, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(2, 12, 1) -> 
    #base_limit_buy_shop{id = 2, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(3, 12, 1) -> 
    #base_limit_buy_shop{id = 3, time=12, goods_id=8001203, goods_num=10, price1 = 200, price2 = 180, buy_num = 5,  sys_buy_num = 100, type = 1};
get(4, 12, 1) -> 
    #base_limit_buy_shop{id = 4, time=12, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(5, 12, 1) -> 
    #base_limit_buy_shop{id = 5, time=12, goods_id=3303000, goods_num=10, price1 = 100, price2 = 90, buy_num = 5,  sys_buy_num = 100, type = 1};
get(6, 12, 1) -> 
    #base_limit_buy_shop{id = 6, time=12, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(7, 14, 1) -> 
    #base_limit_buy_shop{id = 7, time=14, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(8, 14, 1) -> 
    #base_limit_buy_shop{id = 8, time=14, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(9, 14, 1) -> 
    #base_limit_buy_shop{id = 9, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 200, buy_num = 5,  sys_buy_num = 100, type = 1};
get(10, 14, 1) -> 
    #base_limit_buy_shop{id = 10, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 5,  sys_buy_num = 100, type = 1};
get(11, 14, 1) -> 
    #base_limit_buy_shop{id = 11, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 85, buy_num = 5,  sys_buy_num = 100, type = 1};
get(12, 14, 1) -> 
    #base_limit_buy_shop{id = 12, time=14, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(13, 16, 1) -> 
    #base_limit_buy_shop{id = 13, time=16, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(14, 16, 1) -> 
    #base_limit_buy_shop{id = 14, time=16, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(15, 16, 1) -> 
    #base_limit_buy_shop{id = 15, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(16, 16, 1) -> 
    #base_limit_buy_shop{id = 16, time=16, goods_id=1010005, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(17, 16, 1) -> 
    #base_limit_buy_shop{id = 17, time=16, goods_id=20340, goods_num=5, price1 = 75, price2 = 66, buy_num = 5,  sys_buy_num = 100, type = 1};
get(18, 16, 1) -> 
    #base_limit_buy_shop{id = 18, time=16, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(19, 18, 1) -> 
    #base_limit_buy_shop{id = 19, time=18, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(20, 18, 1) -> 
    #base_limit_buy_shop{id = 20, time=18, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(21, 18, 1) -> 
    #base_limit_buy_shop{id = 21, time=18, goods_id=8001203, goods_num=10, price1 = 200, price2 = 180, buy_num = 5,  sys_buy_num = 100, type = 1};
get(22, 18, 1) -> 
    #base_limit_buy_shop{id = 22, time=18, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(23, 18, 1) -> 
    #base_limit_buy_shop{id = 23, time=18, goods_id=3303000, goods_num=10, price1 = 100, price2 = 90, buy_num = 5,  sys_buy_num = 100, type = 1};
get(24, 18, 1) -> 
    #base_limit_buy_shop{id = 24, time=18, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(25, 20, 1) -> 
    #base_limit_buy_shop{id = 25, time=20, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(26, 20, 1) -> 
    #base_limit_buy_shop{id = 26, time=20, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(27, 20, 1) -> 
    #base_limit_buy_shop{id = 27, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 200, buy_num = 5,  sys_buy_num = 100, type = 1};
get(28, 20, 1) -> 
    #base_limit_buy_shop{id = 28, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 5,  sys_buy_num = 100, type = 1};
get(29, 20, 1) -> 
    #base_limit_buy_shop{id = 29, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 85, buy_num = 5,  sys_buy_num = 100, type = 1};
get(30, 20, 1) -> 
    #base_limit_buy_shop{id = 30, time=20, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(31, 22, 1) -> 
    #base_limit_buy_shop{id = 31, time=22, goods_id=3301000, goods_num=10, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(32, 22, 1) -> 
    #base_limit_buy_shop{id = 32, time=22, goods_id=3301000, goods_num=3, price1 = 90, price2 = 72, buy_num = 5,  sys_buy_num = 100, type = 1};
get(33, 22, 1) -> 
    #base_limit_buy_shop{id = 33, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(34, 22, 1) -> 
    #base_limit_buy_shop{id = 34, time=22, goods_id=1010005, goods_num=20, price1 = 300, price2 = 270, buy_num = 5,  sys_buy_num = 100, type = 1};
get(35, 22, 1) -> 
    #base_limit_buy_shop{id = 35, time=22, goods_id=20340, goods_num=5, price1 = 75, price2 = 66, buy_num = 5,  sys_buy_num = 100, type = 1};
get(36, 22, 1) -> 
    #base_limit_buy_shop{id = 36, time=22, goods_id=8001165, goods_num=5, price1 = 120, price2 = 100, buy_num = 5,  sys_buy_num = 100, type = 1};
get(37, 12, 2) -> 
    #base_limit_buy_shop{id = 37, time=12, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(38, 12, 2) -> 
    #base_limit_buy_shop{id = 38, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(39, 12, 2) -> 
    #base_limit_buy_shop{id = 39, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 2};
get(40, 12, 2) -> 
    #base_limit_buy_shop{id = 40, time=12, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 2};
get(41, 12, 2) -> 
    #base_limit_buy_shop{id = 41, time=12, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 2};
get(42, 12, 2) -> 
    #base_limit_buy_shop{id = 42, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(43, 14, 2) -> 
    #base_limit_buy_shop{id = 43, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(44, 14, 2) -> 
    #base_limit_buy_shop{id = 44, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(45, 14, 2) -> 
    #base_limit_buy_shop{id = 45, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(46, 14, 2) -> 
    #base_limit_buy_shop{id = 46, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(47, 14, 2) -> 
    #base_limit_buy_shop{id = 47, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(48, 14, 2) -> 
    #base_limit_buy_shop{id = 48, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(49, 16, 2) -> 
    #base_limit_buy_shop{id = 49, time=16, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(50, 16, 2) -> 
    #base_limit_buy_shop{id = 50, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(51, 16, 2) -> 
    #base_limit_buy_shop{id = 51, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(52, 16, 2) -> 
    #base_limit_buy_shop{id = 52, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(53, 16, 2) -> 
    #base_limit_buy_shop{id = 53, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(54, 16, 2) -> 
    #base_limit_buy_shop{id = 54, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 2};
get(55, 18, 2) -> 
    #base_limit_buy_shop{id = 55, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(56, 18, 2) -> 
    #base_limit_buy_shop{id = 56, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(57, 18, 2) -> 
    #base_limit_buy_shop{id = 57, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 2};
get(58, 18, 2) -> 
    #base_limit_buy_shop{id = 58, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 2};
get(59, 18, 2) -> 
    #base_limit_buy_shop{id = 59, time=18, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 2};
get(60, 18, 2) -> 
    #base_limit_buy_shop{id = 60, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(61, 20, 2) -> 
    #base_limit_buy_shop{id = 61, time=20, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(62, 20, 2) -> 
    #base_limit_buy_shop{id = 62, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(63, 20, 2) -> 
    #base_limit_buy_shop{id = 63, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(64, 20, 2) -> 
    #base_limit_buy_shop{id = 64, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 2};
get(65, 20, 2) -> 
    #base_limit_buy_shop{id = 65, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(66, 20, 2) -> 
    #base_limit_buy_shop{id = 66, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 2};
get(67, 22, 2) -> 
    #base_limit_buy_shop{id = 67, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(68, 22, 2) -> 
    #base_limit_buy_shop{id = 68, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 2};
get(69, 22, 2) -> 
    #base_limit_buy_shop{id = 69, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(70, 22, 2) -> 
    #base_limit_buy_shop{id = 70, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 2};
get(71, 22, 2) -> 
    #base_limit_buy_shop{id = 71, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 2};
get(72, 22, 2) -> 
    #base_limit_buy_shop{id = 72, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 2};
get(73, 12, 3) -> 
    #base_limit_buy_shop{id = 73, time=12, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(74, 12, 3) -> 
    #base_limit_buy_shop{id = 74, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(75, 12, 3) -> 
    #base_limit_buy_shop{id = 75, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 3};
get(76, 12, 3) -> 
    #base_limit_buy_shop{id = 76, time=12, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 3};
get(77, 12, 3) -> 
    #base_limit_buy_shop{id = 77, time=12, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 3};
get(78, 12, 3) -> 
    #base_limit_buy_shop{id = 78, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(79, 14, 3) -> 
    #base_limit_buy_shop{id = 79, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(80, 14, 3) -> 
    #base_limit_buy_shop{id = 80, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(81, 14, 3) -> 
    #base_limit_buy_shop{id = 81, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(82, 14, 3) -> 
    #base_limit_buy_shop{id = 82, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(83, 14, 3) -> 
    #base_limit_buy_shop{id = 83, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(84, 14, 3) -> 
    #base_limit_buy_shop{id = 84, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(85, 16, 3) -> 
    #base_limit_buy_shop{id = 85, time=16, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(86, 16, 3) -> 
    #base_limit_buy_shop{id = 86, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(87, 16, 3) -> 
    #base_limit_buy_shop{id = 87, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(88, 16, 3) -> 
    #base_limit_buy_shop{id = 88, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(89, 16, 3) -> 
    #base_limit_buy_shop{id = 89, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(90, 16, 3) -> 
    #base_limit_buy_shop{id = 90, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 3};
get(91, 18, 3) -> 
    #base_limit_buy_shop{id = 91, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(92, 18, 3) -> 
    #base_limit_buy_shop{id = 92, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(93, 18, 3) -> 
    #base_limit_buy_shop{id = 93, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 3};
get(94, 18, 3) -> 
    #base_limit_buy_shop{id = 94, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 3};
get(95, 18, 3) -> 
    #base_limit_buy_shop{id = 95, time=18, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 3};
get(96, 18, 3) -> 
    #base_limit_buy_shop{id = 96, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(97, 20, 3) -> 
    #base_limit_buy_shop{id = 97, time=20, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(98, 20, 3) -> 
    #base_limit_buy_shop{id = 98, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(99, 20, 3) -> 
    #base_limit_buy_shop{id = 99, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(100, 20, 3) -> 
    #base_limit_buy_shop{id = 100, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 3};
get(101, 20, 3) -> 
    #base_limit_buy_shop{id = 101, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(102, 20, 3) -> 
    #base_limit_buy_shop{id = 102, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 3};
get(103, 22, 3) -> 
    #base_limit_buy_shop{id = 103, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(104, 22, 3) -> 
    #base_limit_buy_shop{id = 104, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 3};
get(105, 22, 3) -> 
    #base_limit_buy_shop{id = 105, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(106, 22, 3) -> 
    #base_limit_buy_shop{id = 106, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 3};
get(107, 22, 3) -> 
    #base_limit_buy_shop{id = 107, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 3};
get(108, 22, 3) -> 
    #base_limit_buy_shop{id = 108, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 3};
get(109, 12, 4) -> 
    #base_limit_buy_shop{id = 109, time=12, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(110, 12, 4) -> 
    #base_limit_buy_shop{id = 110, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(111, 12, 4) -> 
    #base_limit_buy_shop{id = 111, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 4};
get(112, 12, 4) -> 
    #base_limit_buy_shop{id = 112, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 4};
get(113, 12, 4) -> 
    #base_limit_buy_shop{id = 113, time=12, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 4};
get(114, 12, 4) -> 
    #base_limit_buy_shop{id = 114, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(115, 14, 4) -> 
    #base_limit_buy_shop{id = 115, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(116, 14, 4) -> 
    #base_limit_buy_shop{id = 116, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(117, 14, 4) -> 
    #base_limit_buy_shop{id = 117, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(118, 14, 4) -> 
    #base_limit_buy_shop{id = 118, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(119, 14, 4) -> 
    #base_limit_buy_shop{id = 119, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(120, 14, 4) -> 
    #base_limit_buy_shop{id = 120, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(121, 16, 4) -> 
    #base_limit_buy_shop{id = 121, time=16, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(122, 16, 4) -> 
    #base_limit_buy_shop{id = 122, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(123, 16, 4) -> 
    #base_limit_buy_shop{id = 123, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(124, 16, 4) -> 
    #base_limit_buy_shop{id = 124, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(125, 16, 4) -> 
    #base_limit_buy_shop{id = 125, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(126, 16, 4) -> 
    #base_limit_buy_shop{id = 126, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 4};
get(127, 18, 4) -> 
    #base_limit_buy_shop{id = 127, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(128, 18, 4) -> 
    #base_limit_buy_shop{id = 128, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(129, 18, 4) -> 
    #base_limit_buy_shop{id = 129, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 4};
get(130, 18, 4) -> 
    #base_limit_buy_shop{id = 130, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 4};
get(131, 18, 4) -> 
    #base_limit_buy_shop{id = 131, time=18, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 4};
get(132, 18, 4) -> 
    #base_limit_buy_shop{id = 132, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(133, 20, 4) -> 
    #base_limit_buy_shop{id = 133, time=20, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(134, 20, 4) -> 
    #base_limit_buy_shop{id = 134, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(135, 20, 4) -> 
    #base_limit_buy_shop{id = 135, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(136, 20, 4) -> 
    #base_limit_buy_shop{id = 136, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 4};
get(137, 20, 4) -> 
    #base_limit_buy_shop{id = 137, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(138, 20, 4) -> 
    #base_limit_buy_shop{id = 138, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 4};
get(139, 22, 4) -> 
    #base_limit_buy_shop{id = 139, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(140, 22, 4) -> 
    #base_limit_buy_shop{id = 140, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 4};
get(141, 22, 4) -> 
    #base_limit_buy_shop{id = 141, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(142, 22, 4) -> 
    #base_limit_buy_shop{id = 142, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 4};
get(143, 22, 4) -> 
    #base_limit_buy_shop{id = 143, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 4};
get(144, 22, 4) -> 
    #base_limit_buy_shop{id = 144, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 4};
get(145, 12, 5) -> 
    #base_limit_buy_shop{id = 145, time=12, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(146, 12, 5) -> 
    #base_limit_buy_shop{id = 146, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(147, 12, 5) -> 
    #base_limit_buy_shop{id = 147, time=12, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 5};
get(148, 12, 5) -> 
    #base_limit_buy_shop{id = 148, time=12, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 5};
get(149, 12, 5) -> 
    #base_limit_buy_shop{id = 149, time=12, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 5};
get(150, 12, 5) -> 
    #base_limit_buy_shop{id = 150, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(151, 14, 5) -> 
    #base_limit_buy_shop{id = 151, time=14, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(152, 14, 5) -> 
    #base_limit_buy_shop{id = 152, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(153, 14, 5) -> 
    #base_limit_buy_shop{id = 153, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(154, 14, 5) -> 
    #base_limit_buy_shop{id = 154, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(155, 14, 5) -> 
    #base_limit_buy_shop{id = 155, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(156, 14, 5) -> 
    #base_limit_buy_shop{id = 156, time=14, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(157, 16, 5) -> 
    #base_limit_buy_shop{id = 157, time=16, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(158, 16, 5) -> 
    #base_limit_buy_shop{id = 158, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(159, 16, 5) -> 
    #base_limit_buy_shop{id = 159, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(160, 16, 5) -> 
    #base_limit_buy_shop{id = 160, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(161, 16, 5) -> 
    #base_limit_buy_shop{id = 161, time=16, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(162, 16, 5) -> 
    #base_limit_buy_shop{id = 162, time=16, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 5};
get(163, 18, 5) -> 
    #base_limit_buy_shop{id = 163, time=18, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(164, 18, 5) -> 
    #base_limit_buy_shop{id = 164, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(165, 18, 5) -> 
    #base_limit_buy_shop{id = 165, time=18, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 5};
get(166, 18, 5) -> 
    #base_limit_buy_shop{id = 166, time=18, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 5};
get(167, 18, 5) -> 
    #base_limit_buy_shop{id = 167, time=18, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 5};
get(168, 18, 5) -> 
    #base_limit_buy_shop{id = 168, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(169, 20, 5) -> 
    #base_limit_buy_shop{id = 169, time=20, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(170, 20, 5) -> 
    #base_limit_buy_shop{id = 170, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(171, 20, 5) -> 
    #base_limit_buy_shop{id = 171, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(172, 20, 5) -> 
    #base_limit_buy_shop{id = 172, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 5};
get(173, 20, 5) -> 
    #base_limit_buy_shop{id = 173, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(174, 20, 5) -> 
    #base_limit_buy_shop{id = 174, time=20, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 5};
get(175, 22, 5) -> 
    #base_limit_buy_shop{id = 175, time=22, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(176, 22, 5) -> 
    #base_limit_buy_shop{id = 176, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 5};
get(177, 22, 5) -> 
    #base_limit_buy_shop{id = 177, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(178, 22, 5) -> 
    #base_limit_buy_shop{id = 178, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 5};
get(179, 22, 5) -> 
    #base_limit_buy_shop{id = 179, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 5};
get(180, 22, 5) -> 
    #base_limit_buy_shop{id = 180, time=22, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 5};
get(181, 12, 6) -> 
    #base_limit_buy_shop{id = 181, time=12, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(182, 12, 6) -> 
    #base_limit_buy_shop{id = 182, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(183, 12, 6) -> 
    #base_limit_buy_shop{id = 183, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 6};
get(184, 12, 6) -> 
    #base_limit_buy_shop{id = 184, time=12, goods_id=3101000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 6};
get(185, 12, 6) -> 
    #base_limit_buy_shop{id = 185, time=12, goods_id=3102000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 6};
get(186, 12, 6) -> 
    #base_limit_buy_shop{id = 186, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(187, 14, 6) -> 
    #base_limit_buy_shop{id = 187, time=14, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(188, 14, 6) -> 
    #base_limit_buy_shop{id = 188, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(189, 14, 6) -> 
    #base_limit_buy_shop{id = 189, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(190, 14, 6) -> 
    #base_limit_buy_shop{id = 190, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(191, 14, 6) -> 
    #base_limit_buy_shop{id = 191, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(192, 14, 6) -> 
    #base_limit_buy_shop{id = 192, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(193, 16, 6) -> 
    #base_limit_buy_shop{id = 193, time=16, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(194, 16, 6) -> 
    #base_limit_buy_shop{id = 194, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(195, 16, 6) -> 
    #base_limit_buy_shop{id = 195, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(196, 16, 6) -> 
    #base_limit_buy_shop{id = 196, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(197, 16, 6) -> 
    #base_limit_buy_shop{id = 197, time=16, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(198, 16, 6) -> 
    #base_limit_buy_shop{id = 198, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 6};
get(199, 18, 6) -> 
    #base_limit_buy_shop{id = 199, time=18, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(200, 18, 6) -> 
    #base_limit_buy_shop{id = 200, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(201, 18, 6) -> 
    #base_limit_buy_shop{id = 201, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 6};
get(202, 18, 6) -> 
    #base_limit_buy_shop{id = 202, time=18, goods_id=3101000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 6};
get(203, 18, 6) -> 
    #base_limit_buy_shop{id = 203, time=18, goods_id=3102000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 6};
get(204, 18, 6) -> 
    #base_limit_buy_shop{id = 204, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(205, 20, 6) -> 
    #base_limit_buy_shop{id = 205, time=20, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(206, 20, 6) -> 
    #base_limit_buy_shop{id = 206, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(207, 20, 6) -> 
    #base_limit_buy_shop{id = 207, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(208, 20, 6) -> 
    #base_limit_buy_shop{id = 208, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 6};
get(209, 20, 6) -> 
    #base_limit_buy_shop{id = 209, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(210, 20, 6) -> 
    #base_limit_buy_shop{id = 210, time=20, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 6};
get(211, 22, 6) -> 
    #base_limit_buy_shop{id = 211, time=22, goods_id=3101000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(212, 22, 6) -> 
    #base_limit_buy_shop{id = 212, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 6};
get(213, 22, 6) -> 
    #base_limit_buy_shop{id = 213, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(214, 22, 6) -> 
    #base_limit_buy_shop{id = 214, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 6};
get(215, 22, 6) -> 
    #base_limit_buy_shop{id = 215, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 6};
get(216, 22, 6) -> 
    #base_limit_buy_shop{id = 216, time=22, goods_id=3101000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 6};
get(217, 12, 7) -> 
    #base_limit_buy_shop{id = 217, time=12, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(218, 12, 7) -> 
    #base_limit_buy_shop{id = 218, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(219, 12, 7) -> 
    #base_limit_buy_shop{id = 219, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 7};
get(220, 12, 7) -> 
    #base_limit_buy_shop{id = 220, time=12, goods_id=3201000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 7};
get(221, 12, 7) -> 
    #base_limit_buy_shop{id = 221, time=12, goods_id=3202000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 7};
get(222, 12, 7) -> 
    #base_limit_buy_shop{id = 222, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(223, 14, 7) -> 
    #base_limit_buy_shop{id = 223, time=14, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(224, 14, 7) -> 
    #base_limit_buy_shop{id = 224, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(225, 14, 7) -> 
    #base_limit_buy_shop{id = 225, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(226, 14, 7) -> 
    #base_limit_buy_shop{id = 226, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(227, 14, 7) -> 
    #base_limit_buy_shop{id = 227, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(228, 14, 7) -> 
    #base_limit_buy_shop{id = 228, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(229, 16, 7) -> 
    #base_limit_buy_shop{id = 229, time=16, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(230, 16, 7) -> 
    #base_limit_buy_shop{id = 230, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(231, 16, 7) -> 
    #base_limit_buy_shop{id = 231, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(232, 16, 7) -> 
    #base_limit_buy_shop{id = 232, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(233, 16, 7) -> 
    #base_limit_buy_shop{id = 233, time=16, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(234, 16, 7) -> 
    #base_limit_buy_shop{id = 234, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 7};
get(235, 18, 7) -> 
    #base_limit_buy_shop{id = 235, time=18, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(236, 18, 7) -> 
    #base_limit_buy_shop{id = 236, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(237, 18, 7) -> 
    #base_limit_buy_shop{id = 237, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 7};
get(238, 18, 7) -> 
    #base_limit_buy_shop{id = 238, time=18, goods_id=3201000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 7};
get(239, 18, 7) -> 
    #base_limit_buy_shop{id = 239, time=18, goods_id=3202000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 7};
get(240, 18, 7) -> 
    #base_limit_buy_shop{id = 240, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(241, 20, 7) -> 
    #base_limit_buy_shop{id = 241, time=20, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(242, 20, 7) -> 
    #base_limit_buy_shop{id = 242, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(243, 20, 7) -> 
    #base_limit_buy_shop{id = 243, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(244, 20, 7) -> 
    #base_limit_buy_shop{id = 244, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 7};
get(245, 20, 7) -> 
    #base_limit_buy_shop{id = 245, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(246, 20, 7) -> 
    #base_limit_buy_shop{id = 246, time=20, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 7};
get(247, 22, 7) -> 
    #base_limit_buy_shop{id = 247, time=22, goods_id=3201000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(248, 22, 7) -> 
    #base_limit_buy_shop{id = 248, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 7};
get(249, 22, 7) -> 
    #base_limit_buy_shop{id = 249, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(250, 22, 7) -> 
    #base_limit_buy_shop{id = 250, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 7};
get(251, 22, 7) -> 
    #base_limit_buy_shop{id = 251, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 7};
get(252, 22, 7) -> 
    #base_limit_buy_shop{id = 252, time=22, goods_id=3201000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 7};
get(253, 12, 8) -> 
    #base_limit_buy_shop{id = 253, time=12, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(254, 12, 8) -> 
    #base_limit_buy_shop{id = 254, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(255, 12, 8) -> 
    #base_limit_buy_shop{id = 255, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 8};
get(256, 12, 8) -> 
    #base_limit_buy_shop{id = 256, time=12, goods_id=3301000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 8};
get(257, 12, 8) -> 
    #base_limit_buy_shop{id = 257, time=12, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 8};
get(258, 12, 8) -> 
    #base_limit_buy_shop{id = 258, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(259, 14, 8) -> 
    #base_limit_buy_shop{id = 259, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(260, 14, 8) -> 
    #base_limit_buy_shop{id = 260, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(261, 14, 8) -> 
    #base_limit_buy_shop{id = 261, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(262, 14, 8) -> 
    #base_limit_buy_shop{id = 262, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(263, 14, 8) -> 
    #base_limit_buy_shop{id = 263, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(264, 14, 8) -> 
    #base_limit_buy_shop{id = 264, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(265, 16, 8) -> 
    #base_limit_buy_shop{id = 265, time=16, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(266, 16, 8) -> 
    #base_limit_buy_shop{id = 266, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(267, 16, 8) -> 
    #base_limit_buy_shop{id = 267, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(268, 16, 8) -> 
    #base_limit_buy_shop{id = 268, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(269, 16, 8) -> 
    #base_limit_buy_shop{id = 269, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(270, 16, 8) -> 
    #base_limit_buy_shop{id = 270, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 8};
get(271, 18, 8) -> 
    #base_limit_buy_shop{id = 271, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(272, 18, 8) -> 
    #base_limit_buy_shop{id = 272, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(273, 18, 8) -> 
    #base_limit_buy_shop{id = 273, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 8};
get(274, 18, 8) -> 
    #base_limit_buy_shop{id = 274, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 8};
get(275, 18, 8) -> 
    #base_limit_buy_shop{id = 275, time=18, goods_id=3302000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 8};
get(276, 18, 8) -> 
    #base_limit_buy_shop{id = 276, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(277, 20, 8) -> 
    #base_limit_buy_shop{id = 277, time=20, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(278, 20, 8) -> 
    #base_limit_buy_shop{id = 278, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(279, 20, 8) -> 
    #base_limit_buy_shop{id = 279, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(280, 20, 8) -> 
    #base_limit_buy_shop{id = 280, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 8};
get(281, 20, 8) -> 
    #base_limit_buy_shop{id = 281, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(282, 20, 8) -> 
    #base_limit_buy_shop{id = 282, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 8};
get(283, 22, 8) -> 
    #base_limit_buy_shop{id = 283, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(284, 22, 8) -> 
    #base_limit_buy_shop{id = 284, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 8};
get(285, 22, 8) -> 
    #base_limit_buy_shop{id = 285, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(286, 22, 8) -> 
    #base_limit_buy_shop{id = 286, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 8};
get(287, 22, 8) -> 
    #base_limit_buy_shop{id = 287, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 8};
get(288, 22, 8) -> 
    #base_limit_buy_shop{id = 288, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 8};
get(289, 12, 9) -> 
    #base_limit_buy_shop{id = 289, time=12, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(290, 12, 9) -> 
    #base_limit_buy_shop{id = 290, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(291, 12, 9) -> 
    #base_limit_buy_shop{id = 291, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 9};
get(292, 12, 9) -> 
    #base_limit_buy_shop{id = 292, time=12, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 9};
get(293, 12, 9) -> 
    #base_limit_buy_shop{id = 293, time=12, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 9};
get(294, 12, 9) -> 
    #base_limit_buy_shop{id = 294, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(295, 14, 9) -> 
    #base_limit_buy_shop{id = 295, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(296, 14, 9) -> 
    #base_limit_buy_shop{id = 296, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(297, 14, 9) -> 
    #base_limit_buy_shop{id = 297, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(298, 14, 9) -> 
    #base_limit_buy_shop{id = 298, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(299, 14, 9) -> 
    #base_limit_buy_shop{id = 299, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(300, 14, 9) -> 
    #base_limit_buy_shop{id = 300, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(301, 16, 9) -> 
    #base_limit_buy_shop{id = 301, time=16, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(302, 16, 9) -> 
    #base_limit_buy_shop{id = 302, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(303, 16, 9) -> 
    #base_limit_buy_shop{id = 303, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(304, 16, 9) -> 
    #base_limit_buy_shop{id = 304, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(305, 16, 9) -> 
    #base_limit_buy_shop{id = 305, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(306, 16, 9) -> 
    #base_limit_buy_shop{id = 306, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 9};
get(307, 18, 9) -> 
    #base_limit_buy_shop{id = 307, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(308, 18, 9) -> 
    #base_limit_buy_shop{id = 308, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(309, 18, 9) -> 
    #base_limit_buy_shop{id = 309, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 9};
get(310, 18, 9) -> 
    #base_limit_buy_shop{id = 310, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 9};
get(311, 18, 9) -> 
    #base_limit_buy_shop{id = 311, time=18, goods_id=3402000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 9};
get(312, 18, 9) -> 
    #base_limit_buy_shop{id = 312, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(313, 20, 9) -> 
    #base_limit_buy_shop{id = 313, time=20, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(314, 20, 9) -> 
    #base_limit_buy_shop{id = 314, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(315, 20, 9) -> 
    #base_limit_buy_shop{id = 315, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(316, 20, 9) -> 
    #base_limit_buy_shop{id = 316, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 9};
get(317, 20, 9) -> 
    #base_limit_buy_shop{id = 317, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(318, 20, 9) -> 
    #base_limit_buy_shop{id = 318, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 9};
get(319, 22, 9) -> 
    #base_limit_buy_shop{id = 319, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(320, 22, 9) -> 
    #base_limit_buy_shop{id = 320, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 9};
get(321, 22, 9) -> 
    #base_limit_buy_shop{id = 321, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(322, 22, 9) -> 
    #base_limit_buy_shop{id = 322, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 9};
get(323, 22, 9) -> 
    #base_limit_buy_shop{id = 323, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 9};
get(324, 22, 9) -> 
    #base_limit_buy_shop{id = 324, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 9};
get(325, 12, 10) -> 
    #base_limit_buy_shop{id = 325, time=12, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(326, 12, 10) -> 
    #base_limit_buy_shop{id = 326, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(327, 12, 10) -> 
    #base_limit_buy_shop{id = 327, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 10};
get(328, 12, 10) -> 
    #base_limit_buy_shop{id = 328, time=12, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 10};
get(329, 12, 10) -> 
    #base_limit_buy_shop{id = 329, time=12, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 10};
get(330, 12, 10) -> 
    #base_limit_buy_shop{id = 330, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(331, 14, 10) -> 
    #base_limit_buy_shop{id = 331, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(332, 14, 10) -> 
    #base_limit_buy_shop{id = 332, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(333, 14, 10) -> 
    #base_limit_buy_shop{id = 333, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(334, 14, 10) -> 
    #base_limit_buy_shop{id = 334, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(335, 14, 10) -> 
    #base_limit_buy_shop{id = 335, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(336, 14, 10) -> 
    #base_limit_buy_shop{id = 336, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(337, 16, 10) -> 
    #base_limit_buy_shop{id = 337, time=16, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(338, 16, 10) -> 
    #base_limit_buy_shop{id = 338, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(339, 16, 10) -> 
    #base_limit_buy_shop{id = 339, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(340, 16, 10) -> 
    #base_limit_buy_shop{id = 340, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(341, 16, 10) -> 
    #base_limit_buy_shop{id = 341, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(342, 16, 10) -> 
    #base_limit_buy_shop{id = 342, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 10};
get(343, 18, 10) -> 
    #base_limit_buy_shop{id = 343, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(344, 18, 10) -> 
    #base_limit_buy_shop{id = 344, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(345, 18, 10) -> 
    #base_limit_buy_shop{id = 345, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 10};
get(346, 18, 10) -> 
    #base_limit_buy_shop{id = 346, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 10};
get(347, 18, 10) -> 
    #base_limit_buy_shop{id = 347, time=18, goods_id=3502000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 10};
get(348, 18, 10) -> 
    #base_limit_buy_shop{id = 348, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(349, 20, 10) -> 
    #base_limit_buy_shop{id = 349, time=20, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(350, 20, 10) -> 
    #base_limit_buy_shop{id = 350, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(351, 20, 10) -> 
    #base_limit_buy_shop{id = 351, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(352, 20, 10) -> 
    #base_limit_buy_shop{id = 352, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 10};
get(353, 20, 10) -> 
    #base_limit_buy_shop{id = 353, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(354, 20, 10) -> 
    #base_limit_buy_shop{id = 354, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 10};
get(355, 22, 10) -> 
    #base_limit_buy_shop{id = 355, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(356, 22, 10) -> 
    #base_limit_buy_shop{id = 356, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 10};
get(357, 22, 10) -> 
    #base_limit_buy_shop{id = 357, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(358, 22, 10) -> 
    #base_limit_buy_shop{id = 358, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 10};
get(359, 22, 10) -> 
    #base_limit_buy_shop{id = 359, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 10};
get(360, 22, 10) -> 
    #base_limit_buy_shop{id = 360, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 10};
get(361, 12, 11) -> 
    #base_limit_buy_shop{id = 361, time=12, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(362, 12, 11) -> 
    #base_limit_buy_shop{id = 362, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(363, 12, 11) -> 
    #base_limit_buy_shop{id = 363, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 11};
get(364, 12, 11) -> 
    #base_limit_buy_shop{id = 364, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 11};
get(365, 12, 11) -> 
    #base_limit_buy_shop{id = 365, time=12, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 11};
get(366, 12, 11) -> 
    #base_limit_buy_shop{id = 366, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(367, 14, 11) -> 
    #base_limit_buy_shop{id = 367, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(368, 14, 11) -> 
    #base_limit_buy_shop{id = 368, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(369, 14, 11) -> 
    #base_limit_buy_shop{id = 369, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(370, 14, 11) -> 
    #base_limit_buy_shop{id = 370, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(371, 14, 11) -> 
    #base_limit_buy_shop{id = 371, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(372, 14, 11) -> 
    #base_limit_buy_shop{id = 372, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(373, 16, 11) -> 
    #base_limit_buy_shop{id = 373, time=16, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(374, 16, 11) -> 
    #base_limit_buy_shop{id = 374, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(375, 16, 11) -> 
    #base_limit_buy_shop{id = 375, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(376, 16, 11) -> 
    #base_limit_buy_shop{id = 376, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(377, 16, 11) -> 
    #base_limit_buy_shop{id = 377, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(378, 16, 11) -> 
    #base_limit_buy_shop{id = 378, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 11};
get(379, 18, 11) -> 
    #base_limit_buy_shop{id = 379, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(380, 18, 11) -> 
    #base_limit_buy_shop{id = 380, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(381, 18, 11) -> 
    #base_limit_buy_shop{id = 381, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 3,  sys_buy_num = 100, type = 11};
get(382, 18, 11) -> 
    #base_limit_buy_shop{id = 382, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 11};
get(383, 18, 11) -> 
    #base_limit_buy_shop{id = 383, time=18, goods_id=3602000, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 11};
get(384, 18, 11) -> 
    #base_limit_buy_shop{id = 384, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(385, 20, 11) -> 
    #base_limit_buy_shop{id = 385, time=20, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(386, 20, 11) -> 
    #base_limit_buy_shop{id = 386, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(387, 20, 11) -> 
    #base_limit_buy_shop{id = 387, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(388, 20, 11) -> 
    #base_limit_buy_shop{id = 388, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 11};
get(389, 20, 11) -> 
    #base_limit_buy_shop{id = 389, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(390, 20, 11) -> 
    #base_limit_buy_shop{id = 390, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 11};
get(391, 22, 11) -> 
    #base_limit_buy_shop{id = 391, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(392, 22, 11) -> 
    #base_limit_buy_shop{id = 392, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 11};
get(393, 22, 11) -> 
    #base_limit_buy_shop{id = 393, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(394, 22, 11) -> 
    #base_limit_buy_shop{id = 394, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 11};
get(395, 22, 11) -> 
    #base_limit_buy_shop{id = 395, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 11};
get(396, 22, 11) -> 
    #base_limit_buy_shop{id = 396, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 11};
get(397, 12, 12) -> 
    #base_limit_buy_shop{id = 397, time=12, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(398, 12, 12) -> 
    #base_limit_buy_shop{id = 398, time=12, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(399, 12, 12) -> 
    #base_limit_buy_shop{id = 399, time=12, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 12};
get(400, 12, 12) -> 
    #base_limit_buy_shop{id = 400, time=12, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 12};
get(401, 12, 12) -> 
    #base_limit_buy_shop{id = 401, time=12, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 12};
get(402, 12, 12) -> 
    #base_limit_buy_shop{id = 402, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(403, 14, 12) -> 
    #base_limit_buy_shop{id = 403, time=14, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(404, 14, 12) -> 
    #base_limit_buy_shop{id = 404, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(405, 14, 12) -> 
    #base_limit_buy_shop{id = 405, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(406, 14, 12) -> 
    #base_limit_buy_shop{id = 406, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(407, 14, 12) -> 
    #base_limit_buy_shop{id = 407, time=14, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(408, 14, 12) -> 
    #base_limit_buy_shop{id = 408, time=14, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(409, 16, 12) -> 
    #base_limit_buy_shop{id = 409, time=16, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(410, 16, 12) -> 
    #base_limit_buy_shop{id = 410, time=16, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(411, 16, 12) -> 
    #base_limit_buy_shop{id = 411, time=16, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(412, 16, 12) -> 
    #base_limit_buy_shop{id = 412, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(413, 16, 12) -> 
    #base_limit_buy_shop{id = 413, time=16, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(414, 16, 12) -> 
    #base_limit_buy_shop{id = 414, time=16, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 12};
get(415, 18, 12) -> 
    #base_limit_buy_shop{id = 415, time=18, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(416, 18, 12) -> 
    #base_limit_buy_shop{id = 416, time=18, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(417, 18, 12) -> 
    #base_limit_buy_shop{id = 417, time=18, goods_id=10400, goods_num=100, price1 = 200, price2 = 50, buy_num = 3,  sys_buy_num = 100, type = 12};
get(418, 18, 12) -> 
    #base_limit_buy_shop{id = 418, time=18, goods_id=20340, goods_num=5, price1 = 150, price2 = 100, buy_num = 3,  sys_buy_num = 100, type = 12};
get(419, 18, 12) -> 
    #base_limit_buy_shop{id = 419, time=18, goods_id=8001161, goods_num=1, price1 = 300, price2 = 270, buy_num = 3,  sys_buy_num = 100, type = 12};
get(420, 18, 12) -> 
    #base_limit_buy_shop{id = 420, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(421, 20, 12) -> 
    #base_limit_buy_shop{id = 421, time=20, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(422, 20, 12) -> 
    #base_limit_buy_shop{id = 422, time=20, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(423, 20, 12) -> 
    #base_limit_buy_shop{id = 423, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(424, 20, 12) -> 
    #base_limit_buy_shop{id = 424, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 80, buy_num = 3,  sys_buy_num = 100, type = 12};
get(425, 20, 12) -> 
    #base_limit_buy_shop{id = 425, time=20, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(426, 20, 12) -> 
    #base_limit_buy_shop{id = 426, time=20, goods_id=20340, goods_num=20, price1 = 600, price2 = 500, buy_num = 3,  sys_buy_num = 100, type = 12};
get(427, 22, 12) -> 
    #base_limit_buy_shop{id = 427, time=22, goods_id=20340, goods_num=4, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(428, 22, 12) -> 
    #base_limit_buy_shop{id = 428, time=22, goods_id=8001165, goods_num=3, price1 = 60, price2 = 10, buy_num = 2,  sys_buy_num = 100, type = 12};
get(429, 22, 12) -> 
    #base_limit_buy_shop{id = 429, time=22, goods_id=1025001, goods_num=10, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(430, 22, 12) -> 
    #base_limit_buy_shop{id = 430, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 100, buy_num = 1,  sys_buy_num = 100, type = 12};
get(431, 22, 12) -> 
    #base_limit_buy_shop{id = 431, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 3,  sys_buy_num = 100, type = 12};
get(432, 22, 12) -> 
    #base_limit_buy_shop{id = 432, time=22, goods_id=20340, goods_num=100, price1 = 3000, price2 = 2000, buy_num = 1,  sys_buy_num = 100, type = 12};
get(433, 12, 13) -> 
    #base_limit_buy_shop{id = 433, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 13};
get(434, 12, 13) -> 
    #base_limit_buy_shop{id = 434, time=12, goods_id=3601000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 13};
get(435, 12, 13) -> 
    #base_limit_buy_shop{id = 435, time=12, goods_id=3601000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 13};
get(436, 12, 13) -> 
    #base_limit_buy_shop{id = 436, time=12, goods_id=3601000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 13};
get(437, 12, 13) -> 
    #base_limit_buy_shop{id = 437, time=12, goods_id=3601000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 13};
get(438, 12, 13) -> 
    #base_limit_buy_shop{id = 438, time=12, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 13};
get(439, 14, 13) -> 
    #base_limit_buy_shop{id = 439, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 13};
get(440, 14, 13) -> 
    #base_limit_buy_shop{id = 440, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 13};
get(441, 14, 13) -> 
    #base_limit_buy_shop{id = 441, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 13};
get(442, 14, 13) -> 
    #base_limit_buy_shop{id = 442, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(443, 14, 13) -> 
    #base_limit_buy_shop{id = 443, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(444, 14, 13) -> 
    #base_limit_buy_shop{id = 444, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(445, 16, 13) -> 
    #base_limit_buy_shop{id = 445, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(446, 16, 13) -> 
    #base_limit_buy_shop{id = 446, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(447, 16, 13) -> 
    #base_limit_buy_shop{id = 447, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(448, 16, 13) -> 
    #base_limit_buy_shop{id = 448, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(449, 16, 13) -> 
    #base_limit_buy_shop{id = 449, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(450, 16, 13) -> 
    #base_limit_buy_shop{id = 450, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(451, 18, 13) -> 
    #base_limit_buy_shop{id = 451, time=18, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 13};
get(452, 18, 13) -> 
    #base_limit_buy_shop{id = 452, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 13};
get(453, 18, 13) -> 
    #base_limit_buy_shop{id = 453, time=18, goods_id=3601000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 13};
get(454, 18, 13) -> 
    #base_limit_buy_shop{id = 454, time=18, goods_id=3601000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 13};
get(455, 18, 13) -> 
    #base_limit_buy_shop{id = 455, time=18, goods_id=3601000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 13};
get(456, 18, 13) -> 
    #base_limit_buy_shop{id = 456, time=18, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 13};
get(457, 20, 13) -> 
    #base_limit_buy_shop{id = 457, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 13};
get(458, 20, 13) -> 
    #base_limit_buy_shop{id = 458, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 13};
get(459, 20, 13) -> 
    #base_limit_buy_shop{id = 459, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 13};
get(460, 20, 13) -> 
    #base_limit_buy_shop{id = 460, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(461, 20, 13) -> 
    #base_limit_buy_shop{id = 461, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(462, 20, 13) -> 
    #base_limit_buy_shop{id = 462, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 13};
get(463, 22, 13) -> 
    #base_limit_buy_shop{id = 463, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(464, 22, 13) -> 
    #base_limit_buy_shop{id = 464, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(465, 22, 13) -> 
    #base_limit_buy_shop{id = 465, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(466, 22, 13) -> 
    #base_limit_buy_shop{id = 466, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(467, 22, 13) -> 
    #base_limit_buy_shop{id = 467, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(468, 22, 13) -> 
    #base_limit_buy_shop{id = 468, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 13};
get(469, 12, 14) -> 
    #base_limit_buy_shop{id = 469, time=12, goods_id=20340, goods_num=6, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 14};
get(470, 12, 14) -> 
    #base_limit_buy_shop{id = 470, time=12, goods_id=20340, goods_num=10, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 14};
get(471, 12, 14) -> 
    #base_limit_buy_shop{id = 471, time=12, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 14};
get(472, 12, 14) -> 
    #base_limit_buy_shop{id = 472, time=12, goods_id=20340, goods_num=40, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 14};
get(473, 12, 14) -> 
    #base_limit_buy_shop{id = 473, time=12, goods_id=20340, goods_num=120, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 14};
get(474, 12, 14) -> 
    #base_limit_buy_shop{id = 474, time=12, goods_id=20340, goods_num=200, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 14};
get(475, 14, 14) -> 
    #base_limit_buy_shop{id = 475, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 14};
get(476, 14, 14) -> 
    #base_limit_buy_shop{id = 476, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 14};
get(477, 14, 14) -> 
    #base_limit_buy_shop{id = 477, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 14};
get(478, 14, 14) -> 
    #base_limit_buy_shop{id = 478, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(479, 14, 14) -> 
    #base_limit_buy_shop{id = 479, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(480, 14, 14) -> 
    #base_limit_buy_shop{id = 480, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(481, 16, 14) -> 
    #base_limit_buy_shop{id = 481, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(482, 16, 14) -> 
    #base_limit_buy_shop{id = 482, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(483, 16, 14) -> 
    #base_limit_buy_shop{id = 483, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(484, 16, 14) -> 
    #base_limit_buy_shop{id = 484, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(485, 16, 14) -> 
    #base_limit_buy_shop{id = 485, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(486, 16, 14) -> 
    #base_limit_buy_shop{id = 486, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(487, 18, 14) -> 
    #base_limit_buy_shop{id = 487, time=18, goods_id=20340, goods_num=6, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 14};
get(488, 18, 14) -> 
    #base_limit_buy_shop{id = 488, time=18, goods_id=20340, goods_num=10, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 14};
get(489, 18, 14) -> 
    #base_limit_buy_shop{id = 489, time=18, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 14};
get(490, 18, 14) -> 
    #base_limit_buy_shop{id = 490, time=18, goods_id=20340, goods_num=40, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 14};
get(491, 18, 14) -> 
    #base_limit_buy_shop{id = 491, time=18, goods_id=20340, goods_num=120, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 14};
get(492, 18, 14) -> 
    #base_limit_buy_shop{id = 492, time=18, goods_id=20340, goods_num=200, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 14};
get(493, 20, 14) -> 
    #base_limit_buy_shop{id = 493, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 14};
get(494, 20, 14) -> 
    #base_limit_buy_shop{id = 494, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 14};
get(495, 20, 14) -> 
    #base_limit_buy_shop{id = 495, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 14};
get(496, 20, 14) -> 
    #base_limit_buy_shop{id = 496, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(497, 20, 14) -> 
    #base_limit_buy_shop{id = 497, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(498, 20, 14) -> 
    #base_limit_buy_shop{id = 498, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 14};
get(499, 22, 14) -> 
    #base_limit_buy_shop{id = 499, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(500, 22, 14) -> 
    #base_limit_buy_shop{id = 500, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(501, 22, 14) -> 
    #base_limit_buy_shop{id = 501, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(502, 22, 14) -> 
    #base_limit_buy_shop{id = 502, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(503, 22, 14) -> 
    #base_limit_buy_shop{id = 503, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(504, 22, 14) -> 
    #base_limit_buy_shop{id = 504, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 14};
get(505, 12, 15) -> 
    #base_limit_buy_shop{id = 505, time=12, goods_id=3101000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 15};
get(506, 12, 15) -> 
    #base_limit_buy_shop{id = 506, time=12, goods_id=3101000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 15};
get(507, 12, 15) -> 
    #base_limit_buy_shop{id = 507, time=12, goods_id=3101000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 15};
get(508, 12, 15) -> 
    #base_limit_buy_shop{id = 508, time=12, goods_id=3101000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 15};
get(509, 12, 15) -> 
    #base_limit_buy_shop{id = 509, time=12, goods_id=3101000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 15};
get(510, 12, 15) -> 
    #base_limit_buy_shop{id = 510, time=12, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 15};
get(511, 14, 15) -> 
    #base_limit_buy_shop{id = 511, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 15};
get(512, 14, 15) -> 
    #base_limit_buy_shop{id = 512, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 15};
get(513, 14, 15) -> 
    #base_limit_buy_shop{id = 513, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 15};
get(514, 14, 15) -> 
    #base_limit_buy_shop{id = 514, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(515, 14, 15) -> 
    #base_limit_buy_shop{id = 515, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(516, 14, 15) -> 
    #base_limit_buy_shop{id = 516, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(517, 16, 15) -> 
    #base_limit_buy_shop{id = 517, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(518, 16, 15) -> 
    #base_limit_buy_shop{id = 518, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(519, 16, 15) -> 
    #base_limit_buy_shop{id = 519, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(520, 16, 15) -> 
    #base_limit_buy_shop{id = 520, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(521, 16, 15) -> 
    #base_limit_buy_shop{id = 521, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(522, 16, 15) -> 
    #base_limit_buy_shop{id = 522, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(523, 18, 15) -> 
    #base_limit_buy_shop{id = 523, time=18, goods_id=3101000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 15};
get(524, 18, 15) -> 
    #base_limit_buy_shop{id = 524, time=18, goods_id=3101000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 15};
get(525, 18, 15) -> 
    #base_limit_buy_shop{id = 525, time=18, goods_id=3101000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 15};
get(526, 18, 15) -> 
    #base_limit_buy_shop{id = 526, time=18, goods_id=3101000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 15};
get(527, 18, 15) -> 
    #base_limit_buy_shop{id = 527, time=18, goods_id=3101000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 15};
get(528, 18, 15) -> 
    #base_limit_buy_shop{id = 528, time=18, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 15};
get(529, 20, 15) -> 
    #base_limit_buy_shop{id = 529, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 15};
get(530, 20, 15) -> 
    #base_limit_buy_shop{id = 530, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 15};
get(531, 20, 15) -> 
    #base_limit_buy_shop{id = 531, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 15};
get(532, 20, 15) -> 
    #base_limit_buy_shop{id = 532, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(533, 20, 15) -> 
    #base_limit_buy_shop{id = 533, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(534, 20, 15) -> 
    #base_limit_buy_shop{id = 534, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 15};
get(535, 22, 15) -> 
    #base_limit_buy_shop{id = 535, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(536, 22, 15) -> 
    #base_limit_buy_shop{id = 536, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(537, 22, 15) -> 
    #base_limit_buy_shop{id = 537, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(538, 22, 15) -> 
    #base_limit_buy_shop{id = 538, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(539, 22, 15) -> 
    #base_limit_buy_shop{id = 539, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(540, 22, 15) -> 
    #base_limit_buy_shop{id = 540, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 15};
get(541, 12, 16) -> 
    #base_limit_buy_shop{id = 541, time=12, goods_id=3201000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 16};
get(542, 12, 16) -> 
    #base_limit_buy_shop{id = 542, time=12, goods_id=3201000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 16};
get(543, 12, 16) -> 
    #base_limit_buy_shop{id = 543, time=12, goods_id=3201000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 16};
get(544, 12, 16) -> 
    #base_limit_buy_shop{id = 544, time=12, goods_id=3201000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 16};
get(545, 12, 16) -> 
    #base_limit_buy_shop{id = 545, time=12, goods_id=3201000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 16};
get(546, 12, 16) -> 
    #base_limit_buy_shop{id = 546, time=12, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 16};
get(547, 14, 16) -> 
    #base_limit_buy_shop{id = 547, time=14, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 16};
get(548, 14, 16) -> 
    #base_limit_buy_shop{id = 548, time=14, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 16};
get(549, 14, 16) -> 
    #base_limit_buy_shop{id = 549, time=14, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 16};
get(550, 14, 16) -> 
    #base_limit_buy_shop{id = 550, time=14, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(551, 14, 16) -> 
    #base_limit_buy_shop{id = 551, time=14, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(552, 14, 16) -> 
    #base_limit_buy_shop{id = 552, time=14, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(553, 16, 16) -> 
    #base_limit_buy_shop{id = 553, time=16, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(554, 16, 16) -> 
    #base_limit_buy_shop{id = 554, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(555, 16, 16) -> 
    #base_limit_buy_shop{id = 555, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(556, 16, 16) -> 
    #base_limit_buy_shop{id = 556, time=16, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(557, 16, 16) -> 
    #base_limit_buy_shop{id = 557, time=16, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(558, 16, 16) -> 
    #base_limit_buy_shop{id = 558, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(559, 18, 16) -> 
    #base_limit_buy_shop{id = 559, time=18, goods_id=3201000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 16};
get(560, 18, 16) -> 
    #base_limit_buy_shop{id = 560, time=18, goods_id=3201000, goods_num=5, price1 = 150, price2 = 105, buy_num = 1,  sys_buy_num = 100, type = 16};
get(561, 18, 16) -> 
    #base_limit_buy_shop{id = 561, time=18, goods_id=3201000, goods_num=10, price1 = 300, price2 = 180, buy_num = 1,  sys_buy_num = 100, type = 16};
get(562, 18, 16) -> 
    #base_limit_buy_shop{id = 562, time=18, goods_id=3201000, goods_num=20, price1 = 600, price2 = 480, buy_num = 1,  sys_buy_num = 100, type = 16};
get(563, 18, 16) -> 
    #base_limit_buy_shop{id = 563, time=18, goods_id=3201000, goods_num=60, price1 = 1800, price2 = 1260, buy_num = 1,  sys_buy_num = 100, type = 16};
get(564, 18, 16) -> 
    #base_limit_buy_shop{id = 564, time=18, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 1800, buy_num = 1,  sys_buy_num = 100, type = 16};
get(565, 20, 16) -> 
    #base_limit_buy_shop{id = 565, time=20, goods_id=10400, goods_num=100, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 16};
get(566, 20, 16) -> 
    #base_limit_buy_shop{id = 566, time=20, goods_id=10400, goods_num=500, price1 = 1000, price2 = 600, buy_num = 1,  sys_buy_num = 100, type = 16};
get(567, 20, 16) -> 
    #base_limit_buy_shop{id = 567, time=20, goods_id=10400, goods_num=1000, price1 = 2000, price2 = 1000, buy_num = 1,  sys_buy_num = 100, type = 16};
get(568, 20, 16) -> 
    #base_limit_buy_shop{id = 568, time=20, goods_id=6002001, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(569, 20, 16) -> 
    #base_limit_buy_shop{id = 569, time=20, goods_id=6002002, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(570, 20, 16) -> 
    #base_limit_buy_shop{id = 570, time=20, goods_id=6002003, goods_num=10, price1 = 500, price2 = 350, buy_num = 1,  sys_buy_num = 100, type = 16};
get(571, 22, 16) -> 
    #base_limit_buy_shop{id = 571, time=22, goods_id=2601003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(572, 22, 16) -> 
    #base_limit_buy_shop{id = 572, time=22, goods_id=2602003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(573, 22, 16) -> 
    #base_limit_buy_shop{id = 573, time=22, goods_id=2603003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(574, 22, 16) -> 
    #base_limit_buy_shop{id = 574, time=22, goods_id=2604003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(575, 22, 16) -> 
    #base_limit_buy_shop{id = 575, time=22, goods_id=2605003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(576, 22, 16) -> 
    #base_limit_buy_shop{id = 576, time=22, goods_id=2606003, goods_num=10, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 16};
get(577, 12, 17) -> 
    #base_limit_buy_shop{id = 577, time=12, goods_id=3401000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 17};
get(578, 12, 17) -> 
    #base_limit_buy_shop{id = 578, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 17};
get(579, 12, 17) -> 
    #base_limit_buy_shop{id = 579, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 17};
get(580, 12, 17) -> 
    #base_limit_buy_shop{id = 580, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 17};
get(581, 12, 17) -> 
    #base_limit_buy_shop{id = 581, time=12, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 17};
get(582, 12, 17) -> 
    #base_limit_buy_shop{id = 582, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 17};
get(583, 14, 17) -> 
    #base_limit_buy_shop{id = 583, time=14, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(584, 14, 17) -> 
    #base_limit_buy_shop{id = 584, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 17};
get(585, 14, 17) -> 
    #base_limit_buy_shop{id = 585, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 17};
get(586, 14, 17) -> 
    #base_limit_buy_shop{id = 586, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 17};
get(587, 14, 17) -> 
    #base_limit_buy_shop{id = 587, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(588, 14, 17) -> 
    #base_limit_buy_shop{id = 588, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 17};
get(589, 16, 17) -> 
    #base_limit_buy_shop{id = 589, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 17};
get(590, 16, 17) -> 
    #base_limit_buy_shop{id = 590, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 17};
get(591, 16, 17) -> 
    #base_limit_buy_shop{id = 591, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(592, 16, 17) -> 
    #base_limit_buy_shop{id = 592, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 17};
get(593, 16, 17) -> 
    #base_limit_buy_shop{id = 593, time=16, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 17};
get(594, 16, 17) -> 
    #base_limit_buy_shop{id = 594, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 17};
get(595, 18, 17) -> 
    #base_limit_buy_shop{id = 595, time=18, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(596, 18, 17) -> 
    #base_limit_buy_shop{id = 596, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 17};
get(597, 18, 17) -> 
    #base_limit_buy_shop{id = 597, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 17};
get(598, 18, 17) -> 
    #base_limit_buy_shop{id = 598, time=18, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 17};
get(599, 18, 17) -> 
    #base_limit_buy_shop{id = 599, time=18, goods_id=3401000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 17};
get(600, 18, 17) -> 
    #base_limit_buy_shop{id = 600, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 17};
get(601, 20, 17) -> 
    #base_limit_buy_shop{id = 601, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 17};
get(602, 20, 17) -> 
    #base_limit_buy_shop{id = 602, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 17};
get(603, 20, 17) -> 
    #base_limit_buy_shop{id = 603, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 17};
get(604, 20, 17) -> 
    #base_limit_buy_shop{id = 604, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 17};
get(605, 20, 17) -> 
    #base_limit_buy_shop{id = 605, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 17};
get(606, 20, 17) -> 
    #base_limit_buy_shop{id = 606, time=20, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 17};
get(607, 22, 17) -> 
    #base_limit_buy_shop{id = 607, time=22, goods_id=3401000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 17};
get(608, 22, 17) -> 
    #base_limit_buy_shop{id = 608, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 17};
get(609, 22, 17) -> 
    #base_limit_buy_shop{id = 609, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 17};
get(610, 22, 17) -> 
    #base_limit_buy_shop{id = 610, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 17};
get(611, 22, 17) -> 
    #base_limit_buy_shop{id = 611, time=22, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 17};
get(612, 22, 17) -> 
    #base_limit_buy_shop{id = 612, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 17};
get(613, 12, 18) -> 
    #base_limit_buy_shop{id = 613, time=12, goods_id=3501000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 18};
get(614, 12, 18) -> 
    #base_limit_buy_shop{id = 614, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 18};
get(615, 12, 18) -> 
    #base_limit_buy_shop{id = 615, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 18};
get(616, 12, 18) -> 
    #base_limit_buy_shop{id = 616, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 18};
get(617, 12, 18) -> 
    #base_limit_buy_shop{id = 617, time=12, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 18};
get(618, 12, 18) -> 
    #base_limit_buy_shop{id = 618, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 18};
get(619, 14, 18) -> 
    #base_limit_buy_shop{id = 619, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(620, 14, 18) -> 
    #base_limit_buy_shop{id = 620, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 18};
get(621, 14, 18) -> 
    #base_limit_buy_shop{id = 621, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 18};
get(622, 14, 18) -> 
    #base_limit_buy_shop{id = 622, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 18};
get(623, 14, 18) -> 
    #base_limit_buy_shop{id = 623, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 18};
get(624, 14, 18) -> 
    #base_limit_buy_shop{id = 624, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 18};
get(625, 16, 18) -> 
    #base_limit_buy_shop{id = 625, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 18};
get(626, 16, 18) -> 
    #base_limit_buy_shop{id = 626, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 18};
get(627, 16, 18) -> 
    #base_limit_buy_shop{id = 627, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 18};
get(628, 16, 18) -> 
    #base_limit_buy_shop{id = 628, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 18};
get(629, 16, 18) -> 
    #base_limit_buy_shop{id = 629, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 18};
get(630, 16, 18) -> 
    #base_limit_buy_shop{id = 630, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 18};
get(631, 18, 18) -> 
    #base_limit_buy_shop{id = 631, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(632, 18, 18) -> 
    #base_limit_buy_shop{id = 632, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 18};
get(633, 18, 18) -> 
    #base_limit_buy_shop{id = 633, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 18};
get(634, 18, 18) -> 
    #base_limit_buy_shop{id = 634, time=18, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 18};
get(635, 18, 18) -> 
    #base_limit_buy_shop{id = 635, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 18};
get(636, 18, 18) -> 
    #base_limit_buy_shop{id = 636, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 18};
get(637, 20, 18) -> 
    #base_limit_buy_shop{id = 637, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 18};
get(638, 20, 18) -> 
    #base_limit_buy_shop{id = 638, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 18};
get(639, 20, 18) -> 
    #base_limit_buy_shop{id = 639, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 18};
get(640, 20, 18) -> 
    #base_limit_buy_shop{id = 640, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 18};
get(641, 20, 18) -> 
    #base_limit_buy_shop{id = 641, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 18};
get(642, 20, 18) -> 
    #base_limit_buy_shop{id = 642, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 18};
get(643, 22, 18) -> 
    #base_limit_buy_shop{id = 643, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 18};
get(644, 22, 18) -> 
    #base_limit_buy_shop{id = 644, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 18};
get(645, 22, 18) -> 
    #base_limit_buy_shop{id = 645, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 18};
get(646, 22, 18) -> 
    #base_limit_buy_shop{id = 646, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 18};
get(647, 22, 18) -> 
    #base_limit_buy_shop{id = 647, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 18};
get(648, 22, 18) -> 
    #base_limit_buy_shop{id = 648, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 18};
get(649, 12, 19) -> 
    #base_limit_buy_shop{id = 649, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 19};
get(650, 12, 19) -> 
    #base_limit_buy_shop{id = 650, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 19};
get(651, 12, 19) -> 
    #base_limit_buy_shop{id = 651, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 19};
get(652, 12, 19) -> 
    #base_limit_buy_shop{id = 652, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 19};
get(653, 12, 19) -> 
    #base_limit_buy_shop{id = 653, time=12, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 19};
get(654, 12, 19) -> 
    #base_limit_buy_shop{id = 654, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 19};
get(655, 14, 19) -> 
    #base_limit_buy_shop{id = 655, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(656, 14, 19) -> 
    #base_limit_buy_shop{id = 656, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 19};
get(657, 14, 19) -> 
    #base_limit_buy_shop{id = 657, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 19};
get(658, 14, 19) -> 
    #base_limit_buy_shop{id = 658, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 19};
get(659, 14, 19) -> 
    #base_limit_buy_shop{id = 659, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 19};
get(660, 14, 19) -> 
    #base_limit_buy_shop{id = 660, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 19};
get(661, 16, 19) -> 
    #base_limit_buy_shop{id = 661, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 19};
get(662, 16, 19) -> 
    #base_limit_buy_shop{id = 662, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 19};
get(663, 16, 19) -> 
    #base_limit_buy_shop{id = 663, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 19};
get(664, 16, 19) -> 
    #base_limit_buy_shop{id = 664, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 19};
get(665, 16, 19) -> 
    #base_limit_buy_shop{id = 665, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 19};
get(666, 16, 19) -> 
    #base_limit_buy_shop{id = 666, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 19};
get(667, 18, 19) -> 
    #base_limit_buy_shop{id = 667, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(668, 18, 19) -> 
    #base_limit_buy_shop{id = 668, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 19};
get(669, 18, 19) -> 
    #base_limit_buy_shop{id = 669, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 19};
get(670, 18, 19) -> 
    #base_limit_buy_shop{id = 670, time=18, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 19};
get(671, 18, 19) -> 
    #base_limit_buy_shop{id = 671, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 19};
get(672, 18, 19) -> 
    #base_limit_buy_shop{id = 672, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 19};
get(673, 20, 19) -> 
    #base_limit_buy_shop{id = 673, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 19};
get(674, 20, 19) -> 
    #base_limit_buy_shop{id = 674, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 19};
get(675, 20, 19) -> 
    #base_limit_buy_shop{id = 675, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 19};
get(676, 20, 19) -> 
    #base_limit_buy_shop{id = 676, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 19};
get(677, 20, 19) -> 
    #base_limit_buy_shop{id = 677, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 19};
get(678, 20, 19) -> 
    #base_limit_buy_shop{id = 678, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 19};
get(679, 22, 19) -> 
    #base_limit_buy_shop{id = 679, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 19};
get(680, 22, 19) -> 
    #base_limit_buy_shop{id = 680, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 19};
get(681, 22, 19) -> 
    #base_limit_buy_shop{id = 681, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 19};
get(682, 22, 19) -> 
    #base_limit_buy_shop{id = 682, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 19};
get(683, 22, 19) -> 
    #base_limit_buy_shop{id = 683, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 19};
get(684, 22, 19) -> 
    #base_limit_buy_shop{id = 684, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 19};
get(685, 12, 20) -> 
    #base_limit_buy_shop{id = 685, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 20};
get(686, 12, 20) -> 
    #base_limit_buy_shop{id = 686, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 20};
get(687, 12, 20) -> 
    #base_limit_buy_shop{id = 687, time=12, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 5,  sys_buy_num = 100, type = 20};
get(688, 12, 20) -> 
    #base_limit_buy_shop{id = 688, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 20};
get(689, 12, 20) -> 
    #base_limit_buy_shop{id = 689, time=12, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 20};
get(690, 12, 20) -> 
    #base_limit_buy_shop{id = 690, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 20};
get(691, 14, 20) -> 
    #base_limit_buy_shop{id = 691, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(692, 14, 20) -> 
    #base_limit_buy_shop{id = 692, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 20};
get(693, 14, 20) -> 
    #base_limit_buy_shop{id = 693, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 20};
get(694, 14, 20) -> 
    #base_limit_buy_shop{id = 694, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 20};
get(695, 14, 20) -> 
    #base_limit_buy_shop{id = 695, time=14, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 20};
get(696, 14, 20) -> 
    #base_limit_buy_shop{id = 696, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 20};
get(697, 16, 20) -> 
    #base_limit_buy_shop{id = 697, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 20};
get(698, 16, 20) -> 
    #base_limit_buy_shop{id = 698, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 20};
get(699, 16, 20) -> 
    #base_limit_buy_shop{id = 699, time=16, goods_id=1025001, goods_num=5, price1 = 10, price2 = 5, buy_num = 1,  sys_buy_num = 100, type = 20};
get(700, 16, 20) -> 
    #base_limit_buy_shop{id = 700, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 20};
get(701, 16, 20) -> 
    #base_limit_buy_shop{id = 701, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 20};
get(702, 16, 20) -> 
    #base_limit_buy_shop{id = 702, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 20};
get(703, 18, 20) -> 
    #base_limit_buy_shop{id = 703, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(704, 18, 20) -> 
    #base_limit_buy_shop{id = 704, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 20};
get(705, 18, 20) -> 
    #base_limit_buy_shop{id = 705, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 20};
get(706, 18, 20) -> 
    #base_limit_buy_shop{id = 706, time=18, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 20};
get(707, 18, 20) -> 
    #base_limit_buy_shop{id = 707, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 20};
get(708, 18, 20) -> 
    #base_limit_buy_shop{id = 708, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 20};
get(709, 20, 20) -> 
    #base_limit_buy_shop{id = 709, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 20};
get(710, 20, 20) -> 
    #base_limit_buy_shop{id = 710, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 20};
get(711, 20, 20) -> 
    #base_limit_buy_shop{id = 711, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 20};
get(712, 20, 20) -> 
    #base_limit_buy_shop{id = 712, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 20};
get(713, 20, 20) -> 
    #base_limit_buy_shop{id = 713, time=20, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 1,  sys_buy_num = 100, type = 20};
get(714, 20, 20) -> 
    #base_limit_buy_shop{id = 714, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 20};
get(715, 22, 20) -> 
    #base_limit_buy_shop{id = 715, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 20};
get(716, 22, 20) -> 
    #base_limit_buy_shop{id = 716, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 20};
get(717, 22, 20) -> 
    #base_limit_buy_shop{id = 717, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 300, buy_num = 10,  sys_buy_num = 100, type = 20};
get(718, 22, 20) -> 
    #base_limit_buy_shop{id = 718, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 20};
get(719, 22, 20) -> 
    #base_limit_buy_shop{id = 719, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 20};
get(720, 22, 20) -> 
    #base_limit_buy_shop{id = 720, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 20};
get(721, 12, 21) -> 
    #base_limit_buy_shop{id = 721, time=12, goods_id=3501000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 21};
get(722, 12, 21) -> 
    #base_limit_buy_shop{id = 722, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 21};
get(723, 12, 21) -> 
    #base_limit_buy_shop{id = 723, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 21};
get(724, 12, 21) -> 
    #base_limit_buy_shop{id = 724, time=12, goods_id=8001205, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 21};
get(725, 12, 21) -> 
    #base_limit_buy_shop{id = 725, time=12, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 21};
get(726, 12, 21) -> 
    #base_limit_buy_shop{id = 726, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 21};
get(727, 14, 21) -> 
    #base_limit_buy_shop{id = 727, time=14, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(728, 14, 21) -> 
    #base_limit_buy_shop{id = 728, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 21};
get(729, 14, 21) -> 
    #base_limit_buy_shop{id = 729, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 21};
get(730, 14, 21) -> 
    #base_limit_buy_shop{id = 730, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 21};
get(731, 14, 21) -> 
    #base_limit_buy_shop{id = 731, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(732, 14, 21) -> 
    #base_limit_buy_shop{id = 732, time=14, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 21};
get(733, 16, 21) -> 
    #base_limit_buy_shop{id = 733, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 21};
get(734, 16, 21) -> 
    #base_limit_buy_shop{id = 734, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 21};
get(735, 16, 21) -> 
    #base_limit_buy_shop{id = 735, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(736, 16, 21) -> 
    #base_limit_buy_shop{id = 736, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 21};
get(737, 16, 21) -> 
    #base_limit_buy_shop{id = 737, time=16, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 21};
get(738, 16, 21) -> 
    #base_limit_buy_shop{id = 738, time=16, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 21};
get(739, 18, 21) -> 
    #base_limit_buy_shop{id = 739, time=18, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(740, 18, 21) -> 
    #base_limit_buy_shop{id = 740, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 21};
get(741, 18, 21) -> 
    #base_limit_buy_shop{id = 741, time=18, goods_id=8001205, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 21};
get(742, 18, 21) -> 
    #base_limit_buy_shop{id = 742, time=18, goods_id=3502000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 21};
get(743, 18, 21) -> 
    #base_limit_buy_shop{id = 743, time=18, goods_id=3501000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 21};
get(744, 18, 21) -> 
    #base_limit_buy_shop{id = 744, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 21};
get(745, 20, 21) -> 
    #base_limit_buy_shop{id = 745, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 21};
get(746, 20, 21) -> 
    #base_limit_buy_shop{id = 746, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 21};
get(747, 20, 21) -> 
    #base_limit_buy_shop{id = 747, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 21};
get(748, 20, 21) -> 
    #base_limit_buy_shop{id = 748, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 21};
get(749, 20, 21) -> 
    #base_limit_buy_shop{id = 749, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 21};
get(750, 20, 21) -> 
    #base_limit_buy_shop{id = 750, time=20, goods_id=3501000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 21};
get(751, 22, 21) -> 
    #base_limit_buy_shop{id = 751, time=22, goods_id=3501000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 21};
get(752, 22, 21) -> 
    #base_limit_buy_shop{id = 752, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 21};
get(753, 22, 21) -> 
    #base_limit_buy_shop{id = 753, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 21};
get(754, 22, 21) -> 
    #base_limit_buy_shop{id = 754, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 21};
get(755, 22, 21) -> 
    #base_limit_buy_shop{id = 755, time=22, goods_id=3501000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 21};
get(756, 22, 21) -> 
    #base_limit_buy_shop{id = 756, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 21};
get(757, 12, 22) -> 
    #base_limit_buy_shop{id = 757, time=12, goods_id=3301000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 22};
get(758, 12, 22) -> 
    #base_limit_buy_shop{id = 758, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 22};
get(759, 12, 22) -> 
    #base_limit_buy_shop{id = 759, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 22};
get(760, 12, 22) -> 
    #base_limit_buy_shop{id = 760, time=12, goods_id=8001203, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 22};
get(761, 12, 22) -> 
    #base_limit_buy_shop{id = 761, time=12, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 22};
get(762, 12, 22) -> 
    #base_limit_buy_shop{id = 762, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 22};
get(763, 14, 22) -> 
    #base_limit_buy_shop{id = 763, time=14, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(764, 14, 22) -> 
    #base_limit_buy_shop{id = 764, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 22};
get(765, 14, 22) -> 
    #base_limit_buy_shop{id = 765, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 22};
get(766, 14, 22) -> 
    #base_limit_buy_shop{id = 766, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 22};
get(767, 14, 22) -> 
    #base_limit_buy_shop{id = 767, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(768, 14, 22) -> 
    #base_limit_buy_shop{id = 768, time=14, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 22};
get(769, 16, 22) -> 
    #base_limit_buy_shop{id = 769, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 22};
get(770, 16, 22) -> 
    #base_limit_buy_shop{id = 770, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 22};
get(771, 16, 22) -> 
    #base_limit_buy_shop{id = 771, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(772, 16, 22) -> 
    #base_limit_buy_shop{id = 772, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 22};
get(773, 16, 22) -> 
    #base_limit_buy_shop{id = 773, time=16, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 22};
get(774, 16, 22) -> 
    #base_limit_buy_shop{id = 774, time=16, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 22};
get(775, 18, 22) -> 
    #base_limit_buy_shop{id = 775, time=18, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(776, 18, 22) -> 
    #base_limit_buy_shop{id = 776, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 22};
get(777, 18, 22) -> 
    #base_limit_buy_shop{id = 777, time=18, goods_id=8001203, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 22};
get(778, 18, 22) -> 
    #base_limit_buy_shop{id = 778, time=18, goods_id=3302000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 22};
get(779, 18, 22) -> 
    #base_limit_buy_shop{id = 779, time=18, goods_id=3301000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 22};
get(780, 18, 22) -> 
    #base_limit_buy_shop{id = 780, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 22};
get(781, 20, 22) -> 
    #base_limit_buy_shop{id = 781, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 22};
get(782, 20, 22) -> 
    #base_limit_buy_shop{id = 782, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 22};
get(783, 20, 22) -> 
    #base_limit_buy_shop{id = 783, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 22};
get(784, 20, 22) -> 
    #base_limit_buy_shop{id = 784, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 22};
get(785, 20, 22) -> 
    #base_limit_buy_shop{id = 785, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 22};
get(786, 20, 22) -> 
    #base_limit_buy_shop{id = 786, time=20, goods_id=3301000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 22};
get(787, 22, 22) -> 
    #base_limit_buy_shop{id = 787, time=22, goods_id=3301000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 22};
get(788, 22, 22) -> 
    #base_limit_buy_shop{id = 788, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 22};
get(789, 22, 22) -> 
    #base_limit_buy_shop{id = 789, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 22};
get(790, 22, 22) -> 
    #base_limit_buy_shop{id = 790, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 22};
get(791, 22, 22) -> 
    #base_limit_buy_shop{id = 791, time=22, goods_id=3301000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 22};
get(792, 22, 22) -> 
    #base_limit_buy_shop{id = 792, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 22};
get(793, 12, 23) -> 
    #base_limit_buy_shop{id = 793, time=12, goods_id=3601000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 23};
get(794, 12, 23) -> 
    #base_limit_buy_shop{id = 794, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 23};
get(795, 12, 23) -> 
    #base_limit_buy_shop{id = 795, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 23};
get(796, 12, 23) -> 
    #base_limit_buy_shop{id = 796, time=12, goods_id=8001206, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 23};
get(797, 12, 23) -> 
    #base_limit_buy_shop{id = 797, time=12, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 23};
get(798, 12, 23) -> 
    #base_limit_buy_shop{id = 798, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 23};
get(799, 14, 23) -> 
    #base_limit_buy_shop{id = 799, time=14, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(800, 14, 23) -> 
    #base_limit_buy_shop{id = 800, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 23};
get(801, 14, 23) -> 
    #base_limit_buy_shop{id = 801, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 23};
get(802, 14, 23) -> 
    #base_limit_buy_shop{id = 802, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 23};
get(803, 14, 23) -> 
    #base_limit_buy_shop{id = 803, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(804, 14, 23) -> 
    #base_limit_buy_shop{id = 804, time=14, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 23};
get(805, 16, 23) -> 
    #base_limit_buy_shop{id = 805, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 23};
get(806, 16, 23) -> 
    #base_limit_buy_shop{id = 806, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 23};
get(807, 16, 23) -> 
    #base_limit_buy_shop{id = 807, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(808, 16, 23) -> 
    #base_limit_buy_shop{id = 808, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 23};
get(809, 16, 23) -> 
    #base_limit_buy_shop{id = 809, time=16, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 23};
get(810, 16, 23) -> 
    #base_limit_buy_shop{id = 810, time=16, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 23};
get(811, 18, 23) -> 
    #base_limit_buy_shop{id = 811, time=18, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(812, 18, 23) -> 
    #base_limit_buy_shop{id = 812, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 23};
get(813, 18, 23) -> 
    #base_limit_buy_shop{id = 813, time=18, goods_id=8001206, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 23};
get(814, 18, 23) -> 
    #base_limit_buy_shop{id = 814, time=18, goods_id=3602000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 23};
get(815, 18, 23) -> 
    #base_limit_buy_shop{id = 815, time=18, goods_id=3601000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 23};
get(816, 18, 23) -> 
    #base_limit_buy_shop{id = 816, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 23};
get(817, 20, 23) -> 
    #base_limit_buy_shop{id = 817, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 23};
get(818, 20, 23) -> 
    #base_limit_buy_shop{id = 818, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 23};
get(819, 20, 23) -> 
    #base_limit_buy_shop{id = 819, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 23};
get(820, 20, 23) -> 
    #base_limit_buy_shop{id = 820, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 23};
get(821, 20, 23) -> 
    #base_limit_buy_shop{id = 821, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 23};
get(822, 20, 23) -> 
    #base_limit_buy_shop{id = 822, time=20, goods_id=3601000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 23};
get(823, 22, 23) -> 
    #base_limit_buy_shop{id = 823, time=22, goods_id=3601000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 23};
get(824, 22, 23) -> 
    #base_limit_buy_shop{id = 824, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 23};
get(825, 22, 23) -> 
    #base_limit_buy_shop{id = 825, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 23};
get(826, 22, 23) -> 
    #base_limit_buy_shop{id = 826, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 23};
get(827, 22, 23) -> 
    #base_limit_buy_shop{id = 827, time=22, goods_id=3601000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 23};
get(828, 22, 23) -> 
    #base_limit_buy_shop{id = 828, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 23};
get(829, 12, 24) -> 
    #base_limit_buy_shop{id = 829, time=12, goods_id=3701000, goods_num=3, price1 = 90, price2 = 27, buy_num = 1,  sys_buy_num = 100, type = 24};
get(830, 12, 24) -> 
    #base_limit_buy_shop{id = 830, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 1,  sys_buy_num = 100, type = 24};
get(831, 12, 24) -> 
    #base_limit_buy_shop{id = 831, time=12, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 100, type = 24};
get(832, 12, 24) -> 
    #base_limit_buy_shop{id = 832, time=12, goods_id=8001207, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 100, type = 24};
get(833, 12, 24) -> 
    #base_limit_buy_shop{id = 833, time=12, goods_id=3702000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 24};
get(834, 12, 24) -> 
    #base_limit_buy_shop{id = 834, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 24};
get(835, 14, 24) -> 
    #base_limit_buy_shop{id = 835, time=14, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(836, 14, 24) -> 
    #base_limit_buy_shop{id = 836, time=14, goods_id=8001165, goods_num=3, price1 = 60, price2 = 36, buy_num = 1,  sys_buy_num = 100, type = 24};
get(837, 14, 24) -> 
    #base_limit_buy_shop{id = 837, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 1,  sys_buy_num = 100, type = 24};
get(838, 14, 24) -> 
    #base_limit_buy_shop{id = 838, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 24};
get(839, 14, 24) -> 
    #base_limit_buy_shop{id = 839, time=14, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(840, 14, 24) -> 
    #base_limit_buy_shop{id = 840, time=14, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 24};
get(841, 16, 24) -> 
    #base_limit_buy_shop{id = 841, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 24};
get(842, 16, 24) -> 
    #base_limit_buy_shop{id = 842, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 24};
get(843, 16, 24) -> 
    #base_limit_buy_shop{id = 843, time=16, goods_id=1025001, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(844, 16, 24) -> 
    #base_limit_buy_shop{id = 844, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 100, type = 24};
get(845, 16, 24) -> 
    #base_limit_buy_shop{id = 845, time=16, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 100, type = 24};
get(846, 16, 24) -> 
    #base_limit_buy_shop{id = 846, time=16, goods_id=3701000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 100, type = 24};
get(847, 18, 24) -> 
    #base_limit_buy_shop{id = 847, time=18, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(848, 18, 24) -> 
    #base_limit_buy_shop{id = 848, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 1,  sys_buy_num = 100, type = 24};
get(849, 18, 24) -> 
    #base_limit_buy_shop{id = 849, time=18, goods_id=8001207, goods_num=5, price1 = 100, price2 = 60, buy_num = 1,  sys_buy_num = 100, type = 24};
get(850, 18, 24) -> 
    #base_limit_buy_shop{id = 850, time=18, goods_id=3702000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 100, type = 24};
get(851, 18, 24) -> 
    #base_limit_buy_shop{id = 851, time=18, goods_id=3701000, goods_num=5, price1 = 150, price2 = 120, buy_num = 5,  sys_buy_num = 100, type = 24};
get(852, 18, 24) -> 
    #base_limit_buy_shop{id = 852, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 450, buy_num = 5,  sys_buy_num = 100, type = 24};
get(853, 20, 24) -> 
    #base_limit_buy_shop{id = 853, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 50, type = 24};
get(854, 20, 24) -> 
    #base_limit_buy_shop{id = 854, time=20, goods_id=8001167, goods_num=2, price1 = 40, price2 = 24, buy_num = 1,  sys_buy_num = 100, type = 24};
get(855, 20, 24) -> 
    #base_limit_buy_shop{id = 855, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 100, type = 24};
get(856, 20, 24) -> 
    #base_limit_buy_shop{id = 856, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 100, type = 24};
get(857, 20, 24) -> 
    #base_limit_buy_shop{id = 857, time=20, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 24};
get(858, 20, 24) -> 
    #base_limit_buy_shop{id = 858, time=20, goods_id=3701000, goods_num=100, price1 = 3000, price2 = 1950, buy_num = 1,  sys_buy_num = 100, type = 24};
get(859, 22, 24) -> 
    #base_limit_buy_shop{id = 859, time=22, goods_id=3701000, goods_num=2, price1 = 60, price2 = 18, buy_num = 1,  sys_buy_num = 100, type = 24};
get(860, 22, 24) -> 
    #base_limit_buy_shop{id = 860, time=22, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 10,  sys_buy_num = 100, type = 24};
get(861, 22, 24) -> 
    #base_limit_buy_shop{id = 861, time=22, goods_id=1025003, goods_num=1, price1 = 450, price2 = 225, buy_num = 5,  sys_buy_num = 100, type = 24};
get(862, 22, 24) -> 
    #base_limit_buy_shop{id = 862, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 10,  sys_buy_num = 100, type = 24};
get(863, 22, 24) -> 
    #base_limit_buy_shop{id = 863, time=22, goods_id=3701000, goods_num=20, price1 = 600, price2 = 420, buy_num = 10,  sys_buy_num = 100, type = 24};
get(864, 22, 24) -> 
    #base_limit_buy_shop{id = 864, time=22, goods_id=10400, goods_num=500, price1 = 1000, price2 = 700, buy_num = 10,  sys_buy_num = 100, type = 24};
get(865, 12, 25) -> 
    #base_limit_buy_shop{id = 865, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(866, 12, 25) -> 
    #base_limit_buy_shop{id = 866, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 25};
get(867, 12, 25) -> 
    #base_limit_buy_shop{id = 867, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(868, 12, 25) -> 
    #base_limit_buy_shop{id = 868, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 25};
get(869, 12, 25) -> 
    #base_limit_buy_shop{id = 869, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 25};
get(870, 12, 25) -> 
    #base_limit_buy_shop{id = 870, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 25};
get(871, 14, 25) -> 
    #base_limit_buy_shop{id = 871, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(872, 14, 25) -> 
    #base_limit_buy_shop{id = 872, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(873, 14, 25) -> 
    #base_limit_buy_shop{id = 873, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 25};
get(874, 14, 25) -> 
    #base_limit_buy_shop{id = 874, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 25};
get(875, 14, 25) -> 
    #base_limit_buy_shop{id = 875, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(876, 14, 25) -> 
    #base_limit_buy_shop{id = 876, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 25};
get(877, 16, 25) -> 
    #base_limit_buy_shop{id = 877, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(878, 16, 25) -> 
    #base_limit_buy_shop{id = 878, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 25};
get(879, 16, 25) -> 
    #base_limit_buy_shop{id = 879, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(880, 16, 25) -> 
    #base_limit_buy_shop{id = 880, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 25};
get(881, 16, 25) -> 
    #base_limit_buy_shop{id = 881, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(882, 16, 25) -> 
    #base_limit_buy_shop{id = 882, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 25};
get(883, 18, 25) -> 
    #base_limit_buy_shop{id = 883, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(884, 18, 25) -> 
    #base_limit_buy_shop{id = 884, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 25};
get(885, 18, 25) -> 
    #base_limit_buy_shop{id = 885, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(886, 18, 25) -> 
    #base_limit_buy_shop{id = 886, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 25};
get(887, 18, 25) -> 
    #base_limit_buy_shop{id = 887, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 25};
get(888, 18, 25) -> 
    #base_limit_buy_shop{id = 888, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 25};
get(889, 20, 25) -> 
    #base_limit_buy_shop{id = 889, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(890, 20, 25) -> 
    #base_limit_buy_shop{id = 890, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(891, 20, 25) -> 
    #base_limit_buy_shop{id = 891, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 25};
get(892, 20, 25) -> 
    #base_limit_buy_shop{id = 892, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 25};
get(893, 20, 25) -> 
    #base_limit_buy_shop{id = 893, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(894, 20, 25) -> 
    #base_limit_buy_shop{id = 894, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 25};
get(895, 22, 25) -> 
    #base_limit_buy_shop{id = 895, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 25};
get(896, 22, 25) -> 
    #base_limit_buy_shop{id = 896, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 25};
get(897, 22, 25) -> 
    #base_limit_buy_shop{id = 897, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 25};
get(898, 22, 25) -> 
    #base_limit_buy_shop{id = 898, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 25};
get(899, 22, 25) -> 
    #base_limit_buy_shop{id = 899, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 25};
get(900, 22, 25) -> 
    #base_limit_buy_shop{id = 900, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 25};
get(901, 12, 26) -> 
    #base_limit_buy_shop{id = 901, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(902, 12, 26) -> 
    #base_limit_buy_shop{id = 902, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 26};
get(903, 12, 26) -> 
    #base_limit_buy_shop{id = 903, time=12, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(904, 12, 26) -> 
    #base_limit_buy_shop{id = 904, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 26};
get(905, 12, 26) -> 
    #base_limit_buy_shop{id = 905, time=12, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 26};
get(906, 12, 26) -> 
    #base_limit_buy_shop{id = 906, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 26};
get(907, 14, 26) -> 
    #base_limit_buy_shop{id = 907, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(908, 14, 26) -> 
    #base_limit_buy_shop{id = 908, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(909, 14, 26) -> 
    #base_limit_buy_shop{id = 909, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 26};
get(910, 14, 26) -> 
    #base_limit_buy_shop{id = 910, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 26};
get(911, 14, 26) -> 
    #base_limit_buy_shop{id = 911, time=14, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(912, 14, 26) -> 
    #base_limit_buy_shop{id = 912, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 26};
get(913, 16, 26) -> 
    #base_limit_buy_shop{id = 913, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(914, 16, 26) -> 
    #base_limit_buy_shop{id = 914, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 26};
get(915, 16, 26) -> 
    #base_limit_buy_shop{id = 915, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(916, 16, 26) -> 
    #base_limit_buy_shop{id = 916, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 26};
get(917, 16, 26) -> 
    #base_limit_buy_shop{id = 917, time=16, goods_id=3411000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(918, 16, 26) -> 
    #base_limit_buy_shop{id = 918, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 26};
get(919, 18, 26) -> 
    #base_limit_buy_shop{id = 919, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(920, 18, 26) -> 
    #base_limit_buy_shop{id = 920, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 26};
get(921, 18, 26) -> 
    #base_limit_buy_shop{id = 921, time=18, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(922, 18, 26) -> 
    #base_limit_buy_shop{id = 922, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 26};
get(923, 18, 26) -> 
    #base_limit_buy_shop{id = 923, time=18, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 26};
get(924, 18, 26) -> 
    #base_limit_buy_shop{id = 924, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 26};
get(925, 20, 26) -> 
    #base_limit_buy_shop{id = 925, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(926, 20, 26) -> 
    #base_limit_buy_shop{id = 926, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(927, 20, 26) -> 
    #base_limit_buy_shop{id = 927, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 26};
get(928, 20, 26) -> 
    #base_limit_buy_shop{id = 928, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 26};
get(929, 20, 26) -> 
    #base_limit_buy_shop{id = 929, time=20, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(930, 20, 26) -> 
    #base_limit_buy_shop{id = 930, time=20, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 26};
get(931, 22, 26) -> 
    #base_limit_buy_shop{id = 931, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 26};
get(932, 22, 26) -> 
    #base_limit_buy_shop{id = 932, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 26};
get(933, 22, 26) -> 
    #base_limit_buy_shop{id = 933, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 26};
get(934, 22, 26) -> 
    #base_limit_buy_shop{id = 934, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 26};
get(935, 22, 26) -> 
    #base_limit_buy_shop{id = 935, time=22, goods_id=3311000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 26};
get(936, 22, 26) -> 
    #base_limit_buy_shop{id = 936, time=22, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 26};
get(937, 12, 27) -> 
    #base_limit_buy_shop{id = 937, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(938, 12, 27) -> 
    #base_limit_buy_shop{id = 938, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 27};
get(939, 12, 27) -> 
    #base_limit_buy_shop{id = 939, time=12, goods_id=3511000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(940, 12, 27) -> 
    #base_limit_buy_shop{id = 940, time=12, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 27};
get(941, 12, 27) -> 
    #base_limit_buy_shop{id = 941, time=12, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 27};
get(942, 12, 27) -> 
    #base_limit_buy_shop{id = 942, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 27};
get(943, 14, 27) -> 
    #base_limit_buy_shop{id = 943, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(944, 14, 27) -> 
    #base_limit_buy_shop{id = 944, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(945, 14, 27) -> 
    #base_limit_buy_shop{id = 945, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 27};
get(946, 14, 27) -> 
    #base_limit_buy_shop{id = 946, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 27};
get(947, 14, 27) -> 
    #base_limit_buy_shop{id = 947, time=14, goods_id=3511000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(948, 14, 27) -> 
    #base_limit_buy_shop{id = 948, time=14, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 27};
get(949, 16, 27) -> 
    #base_limit_buy_shop{id = 949, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(950, 16, 27) -> 
    #base_limit_buy_shop{id = 950, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 27};
get(951, 16, 27) -> 
    #base_limit_buy_shop{id = 951, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(952, 16, 27) -> 
    #base_limit_buy_shop{id = 952, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 27};
get(953, 16, 27) -> 
    #base_limit_buy_shop{id = 953, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(954, 16, 27) -> 
    #base_limit_buy_shop{id = 954, time=16, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 27};
get(955, 18, 27) -> 
    #base_limit_buy_shop{id = 955, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(956, 18, 27) -> 
    #base_limit_buy_shop{id = 956, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 27};
get(957, 18, 27) -> 
    #base_limit_buy_shop{id = 957, time=18, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(958, 18, 27) -> 
    #base_limit_buy_shop{id = 958, time=18, goods_id=8001204, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 27};
get(959, 18, 27) -> 
    #base_limit_buy_shop{id = 959, time=18, goods_id=3402000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 27};
get(960, 18, 27) -> 
    #base_limit_buy_shop{id = 960, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 27};
get(961, 20, 27) -> 
    #base_limit_buy_shop{id = 961, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(962, 20, 27) -> 
    #base_limit_buy_shop{id = 962, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(963, 20, 27) -> 
    #base_limit_buy_shop{id = 963, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 27};
get(964, 20, 27) -> 
    #base_limit_buy_shop{id = 964, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 27};
get(965, 20, 27) -> 
    #base_limit_buy_shop{id = 965, time=20, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(966, 20, 27) -> 
    #base_limit_buy_shop{id = 966, time=20, goods_id=3401000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 27};
get(967, 22, 27) -> 
    #base_limit_buy_shop{id = 967, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 27};
get(968, 22, 27) -> 
    #base_limit_buy_shop{id = 968, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 27};
get(969, 22, 27) -> 
    #base_limit_buy_shop{id = 969, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 27};
get(970, 22, 27) -> 
    #base_limit_buy_shop{id = 970, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 27};
get(971, 22, 27) -> 
    #base_limit_buy_shop{id = 971, time=22, goods_id=3611000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 27};
get(972, 22, 27) -> 
    #base_limit_buy_shop{id = 972, time=22, goods_id=3401000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 27};
get(973, 12, 28) -> 
    #base_limit_buy_shop{id = 973, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(974, 12, 28) -> 
    #base_limit_buy_shop{id = 974, time=12, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(975, 12, 28) -> 
    #base_limit_buy_shop{id = 975, time=12, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 28};
get(976, 12, 28) -> 
    #base_limit_buy_shop{id = 976, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 60, buy_num = 5,  sys_buy_num = 20, type = 28};
get(977, 12, 28) -> 
    #base_limit_buy_shop{id = 977, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 28};
get(978, 12, 28) -> 
    #base_limit_buy_shop{id = 978, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 28};
get(979, 14, 28) -> 
    #base_limit_buy_shop{id = 979, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(980, 14, 28) -> 
    #base_limit_buy_shop{id = 980, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(981, 14, 28) -> 
    #base_limit_buy_shop{id = 981, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 28};
get(982, 14, 28) -> 
    #base_limit_buy_shop{id = 982, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 28};
get(983, 14, 28) -> 
    #base_limit_buy_shop{id = 983, time=14, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(984, 14, 28) -> 
    #base_limit_buy_shop{id = 984, time=14, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 28};
get(985, 16, 28) -> 
    #base_limit_buy_shop{id = 985, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(986, 16, 28) -> 
    #base_limit_buy_shop{id = 986, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(987, 16, 28) -> 
    #base_limit_buy_shop{id = 987, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(988, 16, 28) -> 
    #base_limit_buy_shop{id = 988, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 28};
get(989, 16, 28) -> 
    #base_limit_buy_shop{id = 989, time=16, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(990, 16, 28) -> 
    #base_limit_buy_shop{id = 990, time=16, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 28};
get(991, 18, 28) -> 
    #base_limit_buy_shop{id = 991, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(992, 18, 28) -> 
    #base_limit_buy_shop{id = 992, time=18, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(993, 18, 28) -> 
    #base_limit_buy_shop{id = 993, time=18, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 28};
get(994, 18, 28) -> 
    #base_limit_buy_shop{id = 994, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 60, buy_num = 5,  sys_buy_num = 20, type = 28};
get(995, 18, 28) -> 
    #base_limit_buy_shop{id = 995, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 28};
get(996, 18, 28) -> 
    #base_limit_buy_shop{id = 996, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 28};
get(997, 20, 28) -> 
    #base_limit_buy_shop{id = 997, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(998, 20, 28) -> 
    #base_limit_buy_shop{id = 998, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(999, 20, 28) -> 
    #base_limit_buy_shop{id = 999, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1000, 20, 28) -> 
    #base_limit_buy_shop{id = 1000, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1001, 20, 28) -> 
    #base_limit_buy_shop{id = 1001, time=20, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1002, 20, 28) -> 
    #base_limit_buy_shop{id = 1002, time=20, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1003, 22, 28) -> 
    #base_limit_buy_shop{id = 1003, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 28};
get(1004, 22, 28) -> 
    #base_limit_buy_shop{id = 1004, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1005, 22, 28) -> 
    #base_limit_buy_shop{id = 1005, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 28};
get(1006, 22, 28) -> 
    #base_limit_buy_shop{id = 1006, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1007, 22, 28) -> 
    #base_limit_buy_shop{id = 1007, time=22, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1008, 22, 28) -> 
    #base_limit_buy_shop{id = 1008, time=22, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 28};
get(1009, 12, 29) -> 
    #base_limit_buy_shop{id = 1009, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1010, 12, 29) -> 
    #base_limit_buy_shop{id = 1010, time=12, goods_id=1015001, goods_num=1, price1 = 150, price2 = 105, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1011, 12, 29) -> 
    #base_limit_buy_shop{id = 1011, time=12, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1012, 12, 29) -> 
    #base_limit_buy_shop{id = 1012, time=12, goods_id=5101405, goods_num=1, price1 = 240, price2 = 168, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1013, 12, 29) -> 
    #base_limit_buy_shop{id = 1013, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1014, 12, 29) -> 
    #base_limit_buy_shop{id = 1014, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1015, 14, 29) -> 
    #base_limit_buy_shop{id = 1015, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1016, 14, 29) -> 
    #base_limit_buy_shop{id = 1016, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1017, 14, 29) -> 
    #base_limit_buy_shop{id = 1017, time=14, goods_id=8001069, goods_num=6, price1 = 450, price2 = 315, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1018, 14, 29) -> 
    #base_limit_buy_shop{id = 1018, time=14, goods_id=5101425, goods_num=1, price1 = 240, price2 = 168, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1019, 14, 29) -> 
    #base_limit_buy_shop{id = 1019, time=14, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1020, 14, 29) -> 
    #base_limit_buy_shop{id = 1020, time=14, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1021, 16, 29) -> 
    #base_limit_buy_shop{id = 1021, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1022, 16, 29) -> 
    #base_limit_buy_shop{id = 1022, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1023, 16, 29) -> 
    #base_limit_buy_shop{id = 1023, time=16, goods_id=5101415, goods_num=1, price1 = 240, price2 = 160, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1024, 16, 29) -> 
    #base_limit_buy_shop{id = 1024, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1025, 16, 29) -> 
    #base_limit_buy_shop{id = 1025, time=16, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1026, 16, 29) -> 
    #base_limit_buy_shop{id = 1026, time=16, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1027, 18, 29) -> 
    #base_limit_buy_shop{id = 1027, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1028, 18, 29) -> 
    #base_limit_buy_shop{id = 1028, time=18, goods_id=1015001, goods_num=1, price1 = 150, price2 = 105, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1029, 18, 29) -> 
    #base_limit_buy_shop{id = 1029, time=18, goods_id=8001002, goods_num=1, price1 = 30, price2 = 15, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1030, 18, 29) -> 
    #base_limit_buy_shop{id = 1030, time=18, goods_id=5101405, goods_num=1, price1 = 240, price2 = 168, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1031, 18, 29) -> 
    #base_limit_buy_shop{id = 1031, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1032, 18, 29) -> 
    #base_limit_buy_shop{id = 1032, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1033, 20, 29) -> 
    #base_limit_buy_shop{id = 1033, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1034, 20, 29) -> 
    #base_limit_buy_shop{id = 1034, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1035, 20, 29) -> 
    #base_limit_buy_shop{id = 1035, time=20, goods_id=8001069, goods_num=6, price1 = 450, price2 = 315, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1036, 20, 29) -> 
    #base_limit_buy_shop{id = 1036, time=20, goods_id=5101425, goods_num=1, price1 = 240, price2 = 168, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1037, 20, 29) -> 
    #base_limit_buy_shop{id = 1037, time=20, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1038, 20, 29) -> 
    #base_limit_buy_shop{id = 1038, time=20, goods_id=8001002, goods_num=20, price1 = 600, price2 = 300, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1039, 22, 29) -> 
    #base_limit_buy_shop{id = 1039, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 29};
get(1040, 22, 29) -> 
    #base_limit_buy_shop{id = 1040, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1041, 22, 29) -> 
    #base_limit_buy_shop{id = 1041, time=22, goods_id=5101415, goods_num=1, price1 = 240, price2 = 160, buy_num = 3,  sys_buy_num = 20, type = 29};
get(1042, 22, 29) -> 
    #base_limit_buy_shop{id = 1042, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 150, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1043, 22, 29) -> 
    #base_limit_buy_shop{id = 1043, time=22, goods_id=10101, goods_num=100000, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1044, 22, 29) -> 
    #base_limit_buy_shop{id = 1044, time=22, goods_id=8001002, goods_num=100, price1 = 3000, price2 = 1500, buy_num = 5,  sys_buy_num = 20, type = 29};
get(1045, 12, 30) -> 
    #base_limit_buy_shop{id = 1045, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1046, 12, 30) -> 
    #base_limit_buy_shop{id = 1046, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1047, 12, 30) -> 
    #base_limit_buy_shop{id = 1047, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1048, 12, 30) -> 
    #base_limit_buy_shop{id = 1048, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1049, 12, 30) -> 
    #base_limit_buy_shop{id = 1049, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1050, 12, 30) -> 
    #base_limit_buy_shop{id = 1050, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1051, 14, 30) -> 
    #base_limit_buy_shop{id = 1051, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1052, 14, 30) -> 
    #base_limit_buy_shop{id = 1052, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1053, 14, 30) -> 
    #base_limit_buy_shop{id = 1053, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1054, 14, 30) -> 
    #base_limit_buy_shop{id = 1054, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1055, 14, 30) -> 
    #base_limit_buy_shop{id = 1055, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1056, 14, 30) -> 
    #base_limit_buy_shop{id = 1056, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1057, 16, 30) -> 
    #base_limit_buy_shop{id = 1057, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1058, 16, 30) -> 
    #base_limit_buy_shop{id = 1058, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1059, 16, 30) -> 
    #base_limit_buy_shop{id = 1059, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1060, 16, 30) -> 
    #base_limit_buy_shop{id = 1060, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1061, 16, 30) -> 
    #base_limit_buy_shop{id = 1061, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1062, 16, 30) -> 
    #base_limit_buy_shop{id = 1062, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1063, 18, 30) -> 
    #base_limit_buy_shop{id = 1063, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1064, 18, 30) -> 
    #base_limit_buy_shop{id = 1064, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1065, 18, 30) -> 
    #base_limit_buy_shop{id = 1065, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1066, 18, 30) -> 
    #base_limit_buy_shop{id = 1066, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1067, 18, 30) -> 
    #base_limit_buy_shop{id = 1067, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1068, 18, 30) -> 
    #base_limit_buy_shop{id = 1068, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1069, 20, 30) -> 
    #base_limit_buy_shop{id = 1069, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1070, 20, 30) -> 
    #base_limit_buy_shop{id = 1070, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1071, 20, 30) -> 
    #base_limit_buy_shop{id = 1071, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1072, 20, 30) -> 
    #base_limit_buy_shop{id = 1072, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1073, 20, 30) -> 
    #base_limit_buy_shop{id = 1073, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1074, 20, 30) -> 
    #base_limit_buy_shop{id = 1074, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1075, 22, 30) -> 
    #base_limit_buy_shop{id = 1075, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 30};
get(1076, 22, 30) -> 
    #base_limit_buy_shop{id = 1076, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1077, 22, 30) -> 
    #base_limit_buy_shop{id = 1077, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 30};
get(1078, 22, 30) -> 
    #base_limit_buy_shop{id = 1078, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1079, 22, 30) -> 
    #base_limit_buy_shop{id = 1079, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1080, 22, 30) -> 
    #base_limit_buy_shop{id = 1080, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 30};
get(1081, 12, 31) -> 
    #base_limit_buy_shop{id = 1081, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1082, 12, 31) -> 
    #base_limit_buy_shop{id = 1082, time=12, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1083, 12, 31) -> 
    #base_limit_buy_shop{id = 1083, time=12, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1084, 12, 31) -> 
    #base_limit_buy_shop{id = 1084, time=12, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1085, 12, 31) -> 
    #base_limit_buy_shop{id = 1085, time=12, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1086, 12, 31) -> 
    #base_limit_buy_shop{id = 1086, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1087, 14, 31) -> 
    #base_limit_buy_shop{id = 1087, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1088, 14, 31) -> 
    #base_limit_buy_shop{id = 1088, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1089, 14, 31) -> 
    #base_limit_buy_shop{id = 1089, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1090, 14, 31) -> 
    #base_limit_buy_shop{id = 1090, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1091, 14, 31) -> 
    #base_limit_buy_shop{id = 1091, time=14, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1092, 14, 31) -> 
    #base_limit_buy_shop{id = 1092, time=14, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1093, 16, 31) -> 
    #base_limit_buy_shop{id = 1093, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1094, 16, 31) -> 
    #base_limit_buy_shop{id = 1094, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1095, 16, 31) -> 
    #base_limit_buy_shop{id = 1095, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1096, 16, 31) -> 
    #base_limit_buy_shop{id = 1096, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1097, 16, 31) -> 
    #base_limit_buy_shop{id = 1097, time=16, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1098, 16, 31) -> 
    #base_limit_buy_shop{id = 1098, time=16, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1099, 18, 31) -> 
    #base_limit_buy_shop{id = 1099, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1100, 18, 31) -> 
    #base_limit_buy_shop{id = 1100, time=18, goods_id=8001167, goods_num=2, price1 = 40, price2 = 28, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1101, 18, 31) -> 
    #base_limit_buy_shop{id = 1101, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1102, 18, 31) -> 
    #base_limit_buy_shop{id = 1102, time=18, goods_id=8001202, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1103, 18, 31) -> 
    #base_limit_buy_shop{id = 1103, time=18, goods_id=3202000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1104, 18, 31) -> 
    #base_limit_buy_shop{id = 1104, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1105, 20, 31) -> 
    #base_limit_buy_shop{id = 1105, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1106, 20, 31) -> 
    #base_limit_buy_shop{id = 1106, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1107, 20, 31) -> 
    #base_limit_buy_shop{id = 1107, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1108, 20, 31) -> 
    #base_limit_buy_shop{id = 1108, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1109, 20, 31) -> 
    #base_limit_buy_shop{id = 1109, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1110, 20, 31) -> 
    #base_limit_buy_shop{id = 1110, time=20, goods_id=3201000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1111, 22, 31) -> 
    #base_limit_buy_shop{id = 1111, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 31};
get(1112, 22, 31) -> 
    #base_limit_buy_shop{id = 1112, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1113, 22, 31) -> 
    #base_limit_buy_shop{id = 1113, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 300, buy_num = 3,  sys_buy_num = 20, type = 31};
get(1114, 22, 31) -> 
    #base_limit_buy_shop{id = 1114, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1115, 22, 31) -> 
    #base_limit_buy_shop{id = 1115, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1116, 22, 31) -> 
    #base_limit_buy_shop{id = 1116, time=22, goods_id=3201000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 31};
get(1117, 12, 32) -> 
    #base_limit_buy_shop{id = 1117, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1118, 12, 32) -> 
    #base_limit_buy_shop{id = 1118, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 32};
get(1119, 12, 32) -> 
    #base_limit_buy_shop{id = 1119, time=12, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1120, 12, 32) -> 
    #base_limit_buy_shop{id = 1120, time=12, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1121, 12, 32) -> 
    #base_limit_buy_shop{id = 1121, time=12, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1122, 12, 32) -> 
    #base_limit_buy_shop{id = 1122, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1123, 14, 32) -> 
    #base_limit_buy_shop{id = 1123, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1124, 14, 32) -> 
    #base_limit_buy_shop{id = 1124, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1125, 14, 32) -> 
    #base_limit_buy_shop{id = 1125, time=14, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1126, 14, 32) -> 
    #base_limit_buy_shop{id = 1126, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1127, 14, 32) -> 
    #base_limit_buy_shop{id = 1127, time=14, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1128, 14, 32) -> 
    #base_limit_buy_shop{id = 1128, time=14, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1129, 16, 32) -> 
    #base_limit_buy_shop{id = 1129, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1130, 16, 32) -> 
    #base_limit_buy_shop{id = 1130, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1131, 16, 32) -> 
    #base_limit_buy_shop{id = 1131, time=16, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1132, 16, 32) -> 
    #base_limit_buy_shop{id = 1132, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1133, 16, 32) -> 
    #base_limit_buy_shop{id = 1133, time=16, goods_id=3111000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1134, 16, 32) -> 
    #base_limit_buy_shop{id = 1134, time=16, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1135, 18, 32) -> 
    #base_limit_buy_shop{id = 1135, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1136, 18, 32) -> 
    #base_limit_buy_shop{id = 1136, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 32};
get(1137, 18, 32) -> 
    #base_limit_buy_shop{id = 1137, time=18, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1138, 18, 32) -> 
    #base_limit_buy_shop{id = 1138, time=18, goods_id=8001201, goods_num=5, price1 = 100, price2 = 70, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1139, 18, 32) -> 
    #base_limit_buy_shop{id = 1139, time=18, goods_id=3102000, goods_num=1, price1 = 150, price2 = 105, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1140, 18, 32) -> 
    #base_limit_buy_shop{id = 1140, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1141, 20, 32) -> 
    #base_limit_buy_shop{id = 1141, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1142, 20, 32) -> 
    #base_limit_buy_shop{id = 1142, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1143, 20, 32) -> 
    #base_limit_buy_shop{id = 1143, time=20, goods_id=2003000, goods_num=20, price1 = 100, price2 = 65, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1144, 20, 32) -> 
    #base_limit_buy_shop{id = 1144, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1145, 20, 32) -> 
    #base_limit_buy_shop{id = 1145, time=20, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1146, 20, 32) -> 
    #base_limit_buy_shop{id = 1146, time=20, goods_id=3101000, goods_num=20, price1 = 600, price2 = 420, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1147, 22, 32) -> 
    #base_limit_buy_shop{id = 1147, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1148, 22, 32) -> 
    #base_limit_buy_shop{id = 1148, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 32};
get(1149, 22, 32) -> 
    #base_limit_buy_shop{id = 1149, time=22, goods_id=8001167, goods_num=1, price1 = 20, price2 = 14, buy_num = 3,  sys_buy_num = 20, type = 32};
get(1150, 22, 32) -> 
    #base_limit_buy_shop{id = 1150, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1151, 22, 32) -> 
    #base_limit_buy_shop{id = 1151, time=22, goods_id=3211000, goods_num=1, price1 = 50, price2 = 35, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1152, 22, 32) -> 
    #base_limit_buy_shop{id = 1152, time=22, goods_id=3101000, goods_num=100, price1 = 3000, price2 = 2100, buy_num = 5,  sys_buy_num = 20, type = 32};
get(1153, 12, 33) -> 
    #base_limit_buy_shop{id = 1153, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1154, 12, 33) -> 
    #base_limit_buy_shop{id = 1154, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 33};
get(1155, 12, 33) -> 
    #base_limit_buy_shop{id = 1155, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1156, 12, 33) -> 
    #base_limit_buy_shop{id = 1156, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1157, 12, 33) -> 
    #base_limit_buy_shop{id = 1157, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1158, 12, 33) -> 
    #base_limit_buy_shop{id = 1158, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1159, 14, 33) -> 
    #base_limit_buy_shop{id = 1159, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1160, 14, 33) -> 
    #base_limit_buy_shop{id = 1160, time=14, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1161, 14, 33) -> 
    #base_limit_buy_shop{id = 1161, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1162, 14, 33) -> 
    #base_limit_buy_shop{id = 1162, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 33};
get(1163, 14, 33) -> 
    #base_limit_buy_shop{id = 1163, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1164, 14, 33) -> 
    #base_limit_buy_shop{id = 1164, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1165, 16, 33) -> 
    #base_limit_buy_shop{id = 1165, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1166, 16, 33) -> 
    #base_limit_buy_shop{id = 1166, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1167, 16, 33) -> 
    #base_limit_buy_shop{id = 1167, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1168, 16, 33) -> 
    #base_limit_buy_shop{id = 1168, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1169, 16, 33) -> 
    #base_limit_buy_shop{id = 1169, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1170, 16, 33) -> 
    #base_limit_buy_shop{id = 1170, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1171, 18, 33) -> 
    #base_limit_buy_shop{id = 1171, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1172, 18, 33) -> 
    #base_limit_buy_shop{id = 1172, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 10, type = 33};
get(1173, 18, 33) -> 
    #base_limit_buy_shop{id = 1173, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1174, 18, 33) -> 
    #base_limit_buy_shop{id = 1174, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1175, 18, 33) -> 
    #base_limit_buy_shop{id = 1175, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1176, 18, 33) -> 
    #base_limit_buy_shop{id = 1176, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1177, 20, 33) -> 
    #base_limit_buy_shop{id = 1177, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1178, 20, 33) -> 
    #base_limit_buy_shop{id = 1178, time=20, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1179, 20, 33) -> 
    #base_limit_buy_shop{id = 1179, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1180, 20, 33) -> 
    #base_limit_buy_shop{id = 1180, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 33};
get(1181, 20, 33) -> 
    #base_limit_buy_shop{id = 1181, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1182, 20, 33) -> 
    #base_limit_buy_shop{id = 1182, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1183, 22, 33) -> 
    #base_limit_buy_shop{id = 1183, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1184, 22, 33) -> 
    #base_limit_buy_shop{id = 1184, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 225, buy_num = 1,  sys_buy_num = 20, type = 33};
get(1185, 22, 33) -> 
    #base_limit_buy_shop{id = 1185, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1186, 22, 33) -> 
    #base_limit_buy_shop{id = 1186, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1187, 22, 33) -> 
    #base_limit_buy_shop{id = 1187, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1188, 22, 33) -> 
    #base_limit_buy_shop{id = 1188, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 33};
get(1189, 12, 34) -> 
    #base_limit_buy_shop{id = 1189, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1190, 12, 34) -> 
    #base_limit_buy_shop{id = 1190, time=12, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1191, 12, 34) -> 
    #base_limit_buy_shop{id = 1191, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1192, 12, 34) -> 
    #base_limit_buy_shop{id = 1192, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1193, 12, 34) -> 
    #base_limit_buy_shop{id = 1193, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1194, 12, 34) -> 
    #base_limit_buy_shop{id = 1194, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1195, 14, 34) -> 
    #base_limit_buy_shop{id = 1195, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1196, 14, 34) -> 
    #base_limit_buy_shop{id = 1196, time=14, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1197, 14, 34) -> 
    #base_limit_buy_shop{id = 1197, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1198, 14, 34) -> 
    #base_limit_buy_shop{id = 1198, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 34};
get(1199, 14, 34) -> 
    #base_limit_buy_shop{id = 1199, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1200, 14, 34) -> 
    #base_limit_buy_shop{id = 1200, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1201, 16, 34) -> 
    #base_limit_buy_shop{id = 1201, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1202, 16, 34) -> 
    #base_limit_buy_shop{id = 1202, time=16, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1203, 16, 34) -> 
    #base_limit_buy_shop{id = 1203, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1204, 16, 34) -> 
    #base_limit_buy_shop{id = 1204, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 210, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1205, 16, 34) -> 
    #base_limit_buy_shop{id = 1205, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1206, 16, 34) -> 
    #base_limit_buy_shop{id = 1206, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1207, 18, 34) -> 
    #base_limit_buy_shop{id = 1207, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1208, 18, 34) -> 
    #base_limit_buy_shop{id = 1208, time=18, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1209, 18, 34) -> 
    #base_limit_buy_shop{id = 1209, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1210, 18, 34) -> 
    #base_limit_buy_shop{id = 1210, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1211, 18, 34) -> 
    #base_limit_buy_shop{id = 1211, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1212, 18, 34) -> 
    #base_limit_buy_shop{id = 1212, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 375, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1213, 20, 34) -> 
    #base_limit_buy_shop{id = 1213, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1214, 20, 34) -> 
    #base_limit_buy_shop{id = 1214, time=20, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1215, 20, 34) -> 
    #base_limit_buy_shop{id = 1215, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1216, 20, 34) -> 
    #base_limit_buy_shop{id = 1216, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 3,  sys_buy_num = 20, type = 34};
get(1217, 20, 34) -> 
    #base_limit_buy_shop{id = 1217, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1218, 20, 34) -> 
    #base_limit_buy_shop{id = 1218, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1219, 22, 34) -> 
    #base_limit_buy_shop{id = 1219, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 20, type = 34};
get(1220, 22, 34) -> 
    #base_limit_buy_shop{id = 1220, time=22, goods_id=7303002, goods_num=1, price1 = 30, price2 = 30, buy_num = 1,  sys_buy_num = 10, type = 34};
get(1221, 22, 34) -> 
    #base_limit_buy_shop{id = 1221, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 270, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1222, 22, 34) -> 
    #base_limit_buy_shop{id = 1222, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 180, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1223, 22, 34) -> 
    #base_limit_buy_shop{id = 1223, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1224, 22, 34) -> 
    #base_limit_buy_shop{id = 1224, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 5,  sys_buy_num = 20, type = 34};
get(1225, 12, 35) -> 
    #base_limit_buy_shop{id = 1225, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1226, 12, 35) -> 
    #base_limit_buy_shop{id = 1226, time=12, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1227, 12, 35) -> 
    #base_limit_buy_shop{id = 1227, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1228, 12, 35) -> 
    #base_limit_buy_shop{id = 1228, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1229, 12, 35) -> 
    #base_limit_buy_shop{id = 1229, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1230, 12, 35) -> 
    #base_limit_buy_shop{id = 1230, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1231, 14, 35) -> 
    #base_limit_buy_shop{id = 1231, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1232, 14, 35) -> 
    #base_limit_buy_shop{id = 1232, time=14, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1233, 14, 35) -> 
    #base_limit_buy_shop{id = 1233, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1234, 14, 35) -> 
    #base_limit_buy_shop{id = 1234, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1235, 14, 35) -> 
    #base_limit_buy_shop{id = 1235, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1236, 14, 35) -> 
    #base_limit_buy_shop{id = 1236, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1237, 16, 35) -> 
    #base_limit_buy_shop{id = 1237, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1238, 16, 35) -> 
    #base_limit_buy_shop{id = 1238, time=16, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1239, 16, 35) -> 
    #base_limit_buy_shop{id = 1239, time=16, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1240, 16, 35) -> 
    #base_limit_buy_shop{id = 1240, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1241, 16, 35) -> 
    #base_limit_buy_shop{id = 1241, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1242, 16, 35) -> 
    #base_limit_buy_shop{id = 1242, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1243, 18, 35) -> 
    #base_limit_buy_shop{id = 1243, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1244, 18, 35) -> 
    #base_limit_buy_shop{id = 1244, time=18, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1245, 18, 35) -> 
    #base_limit_buy_shop{id = 1245, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1246, 18, 35) -> 
    #base_limit_buy_shop{id = 1246, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1247, 18, 35) -> 
    #base_limit_buy_shop{id = 1247, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1248, 18, 35) -> 
    #base_limit_buy_shop{id = 1248, time=18, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1249, 20, 35) -> 
    #base_limit_buy_shop{id = 1249, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1250, 20, 35) -> 
    #base_limit_buy_shop{id = 1250, time=20, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1251, 20, 35) -> 
    #base_limit_buy_shop{id = 1251, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1252, 20, 35) -> 
    #base_limit_buy_shop{id = 1252, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1253, 20, 35) -> 
    #base_limit_buy_shop{id = 1253, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1254, 20, 35) -> 
    #base_limit_buy_shop{id = 1254, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1255, 22, 35) -> 
    #base_limit_buy_shop{id = 1255, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1256, 22, 35) -> 
    #base_limit_buy_shop{id = 1256, time=22, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1257, 22, 35) -> 
    #base_limit_buy_shop{id = 1257, time=22, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1258, 22, 35) -> 
    #base_limit_buy_shop{id = 1258, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1259, 22, 35) -> 
    #base_limit_buy_shop{id = 1259, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1260, 22, 35) -> 
    #base_limit_buy_shop{id = 1260, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 35};
get(1261, 12, 36) -> 
    #base_limit_buy_shop{id = 1261, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1262, 12, 36) -> 
    #base_limit_buy_shop{id = 1262, time=12, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1263, 12, 36) -> 
    #base_limit_buy_shop{id = 1263, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1264, 12, 36) -> 
    #base_limit_buy_shop{id = 1264, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1265, 12, 36) -> 
    #base_limit_buy_shop{id = 1265, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1266, 12, 36) -> 
    #base_limit_buy_shop{id = 1266, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1267, 14, 36) -> 
    #base_limit_buy_shop{id = 1267, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1268, 14, 36) -> 
    #base_limit_buy_shop{id = 1268, time=14, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1269, 14, 36) -> 
    #base_limit_buy_shop{id = 1269, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1270, 14, 36) -> 
    #base_limit_buy_shop{id = 1270, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1271, 14, 36) -> 
    #base_limit_buy_shop{id = 1271, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1272, 14, 36) -> 
    #base_limit_buy_shop{id = 1272, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1273, 16, 36) -> 
    #base_limit_buy_shop{id = 1273, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1274, 16, 36) -> 
    #base_limit_buy_shop{id = 1274, time=16, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1275, 16, 36) -> 
    #base_limit_buy_shop{id = 1275, time=16, goods_id=3107001, goods_num=1, price1 = 400, price2 = 360, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1276, 16, 36) -> 
    #base_limit_buy_shop{id = 1276, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1277, 16, 36) -> 
    #base_limit_buy_shop{id = 1277, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1278, 16, 36) -> 
    #base_limit_buy_shop{id = 1278, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1279, 18, 36) -> 
    #base_limit_buy_shop{id = 1279, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1280, 18, 36) -> 
    #base_limit_buy_shop{id = 1280, time=18, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1281, 18, 36) -> 
    #base_limit_buy_shop{id = 1281, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1282, 18, 36) -> 
    #base_limit_buy_shop{id = 1282, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1283, 18, 36) -> 
    #base_limit_buy_shop{id = 1283, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1284, 18, 36) -> 
    #base_limit_buy_shop{id = 1284, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1285, 20, 36) -> 
    #base_limit_buy_shop{id = 1285, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1286, 20, 36) -> 
    #base_limit_buy_shop{id = 1286, time=20, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1287, 20, 36) -> 
    #base_limit_buy_shop{id = 1287, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1288, 20, 36) -> 
    #base_limit_buy_shop{id = 1288, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1289, 20, 36) -> 
    #base_limit_buy_shop{id = 1289, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1290, 20, 36) -> 
    #base_limit_buy_shop{id = 1290, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1291, 22, 36) -> 
    #base_limit_buy_shop{id = 1291, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1292, 22, 36) -> 
    #base_limit_buy_shop{id = 1292, time=22, goods_id=7303003, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1293, 22, 36) -> 
    #base_limit_buy_shop{id = 1293, time=22, goods_id=3107001, goods_num=1, price1 = 400, price2 = 360, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1294, 22, 36) -> 
    #base_limit_buy_shop{id = 1294, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1295, 22, 36) -> 
    #base_limit_buy_shop{id = 1295, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1296, 22, 36) -> 
    #base_limit_buy_shop{id = 1296, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 36};
get(1297, 12, 37) -> 
    #base_limit_buy_shop{id = 1297, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1298, 12, 37) -> 
    #base_limit_buy_shop{id = 1298, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1299, 12, 37) -> 
    #base_limit_buy_shop{id = 1299, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1300, 12, 37) -> 
    #base_limit_buy_shop{id = 1300, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1301, 12, 37) -> 
    #base_limit_buy_shop{id = 1301, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1302, 12, 37) -> 
    #base_limit_buy_shop{id = 1302, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1303, 14, 37) -> 
    #base_limit_buy_shop{id = 1303, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1304, 14, 37) -> 
    #base_limit_buy_shop{id = 1304, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1305, 14, 37) -> 
    #base_limit_buy_shop{id = 1305, time=14, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1306, 14, 37) -> 
    #base_limit_buy_shop{id = 1306, time=14, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1307, 14, 37) -> 
    #base_limit_buy_shop{id = 1307, time=14, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1308, 14, 37) -> 
    #base_limit_buy_shop{id = 1308, time=14, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1309, 16, 37) -> 
    #base_limit_buy_shop{id = 1309, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1310, 16, 37) -> 
    #base_limit_buy_shop{id = 1310, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1311, 16, 37) -> 
    #base_limit_buy_shop{id = 1311, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1312, 16, 37) -> 
    #base_limit_buy_shop{id = 1312, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1313, 16, 37) -> 
    #base_limit_buy_shop{id = 1313, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1314, 16, 37) -> 
    #base_limit_buy_shop{id = 1314, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1315, 18, 37) -> 
    #base_limit_buy_shop{id = 1315, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1316, 18, 37) -> 
    #base_limit_buy_shop{id = 1316, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1317, 18, 37) -> 
    #base_limit_buy_shop{id = 1317, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1318, 18, 37) -> 
    #base_limit_buy_shop{id = 1318, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1319, 18, 37) -> 
    #base_limit_buy_shop{id = 1319, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1320, 18, 37) -> 
    #base_limit_buy_shop{id = 1320, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1321, 20, 37) -> 
    #base_limit_buy_shop{id = 1321, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1322, 20, 37) -> 
    #base_limit_buy_shop{id = 1322, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1323, 20, 37) -> 
    #base_limit_buy_shop{id = 1323, time=20, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1324, 20, 37) -> 
    #base_limit_buy_shop{id = 1324, time=20, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1325, 20, 37) -> 
    #base_limit_buy_shop{id = 1325, time=20, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1326, 20, 37) -> 
    #base_limit_buy_shop{id = 1326, time=20, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1327, 22, 37) -> 
    #base_limit_buy_shop{id = 1327, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 37};
get(1328, 22, 37) -> 
    #base_limit_buy_shop{id = 1328, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1329, 22, 37) -> 
    #base_limit_buy_shop{id = 1329, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1330, 22, 37) -> 
    #base_limit_buy_shop{id = 1330, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1331, 22, 37) -> 
    #base_limit_buy_shop{id = 1331, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1332, 22, 37) -> 
    #base_limit_buy_shop{id = 1332, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 37};
get(1333, 12, 38) -> 
    #base_limit_buy_shop{id = 1333, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1334, 12, 38) -> 
    #base_limit_buy_shop{id = 1334, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1335, 12, 38) -> 
    #base_limit_buy_shop{id = 1335, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1336, 12, 38) -> 
    #base_limit_buy_shop{id = 1336, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1337, 12, 38) -> 
    #base_limit_buy_shop{id = 1337, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1338, 12, 38) -> 
    #base_limit_buy_shop{id = 1338, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1339, 14, 38) -> 
    #base_limit_buy_shop{id = 1339, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1340, 14, 38) -> 
    #base_limit_buy_shop{id = 1340, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1341, 14, 38) -> 
    #base_limit_buy_shop{id = 1341, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1342, 14, 38) -> 
    #base_limit_buy_shop{id = 1342, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1343, 14, 38) -> 
    #base_limit_buy_shop{id = 1343, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1344, 14, 38) -> 
    #base_limit_buy_shop{id = 1344, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1345, 16, 38) -> 
    #base_limit_buy_shop{id = 1345, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1346, 16, 38) -> 
    #base_limit_buy_shop{id = 1346, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1347, 16, 38) -> 
    #base_limit_buy_shop{id = 1347, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1348, 16, 38) -> 
    #base_limit_buy_shop{id = 1348, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1349, 16, 38) -> 
    #base_limit_buy_shop{id = 1349, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1350, 16, 38) -> 
    #base_limit_buy_shop{id = 1350, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1351, 18, 38) -> 
    #base_limit_buy_shop{id = 1351, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1352, 18, 38) -> 
    #base_limit_buy_shop{id = 1352, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1353, 18, 38) -> 
    #base_limit_buy_shop{id = 1353, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1354, 18, 38) -> 
    #base_limit_buy_shop{id = 1354, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1355, 18, 38) -> 
    #base_limit_buy_shop{id = 1355, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1356, 18, 38) -> 
    #base_limit_buy_shop{id = 1356, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1357, 20, 38) -> 
    #base_limit_buy_shop{id = 1357, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1358, 20, 38) -> 
    #base_limit_buy_shop{id = 1358, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1359, 20, 38) -> 
    #base_limit_buy_shop{id = 1359, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1360, 20, 38) -> 
    #base_limit_buy_shop{id = 1360, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1361, 20, 38) -> 
    #base_limit_buy_shop{id = 1361, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1362, 20, 38) -> 
    #base_limit_buy_shop{id = 1362, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1363, 22, 38) -> 
    #base_limit_buy_shop{id = 1363, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 38};
get(1364, 22, 38) -> 
    #base_limit_buy_shop{id = 1364, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1365, 22, 38) -> 
    #base_limit_buy_shop{id = 1365, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1366, 22, 38) -> 
    #base_limit_buy_shop{id = 1366, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1367, 22, 38) -> 
    #base_limit_buy_shop{id = 1367, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1368, 22, 38) -> 
    #base_limit_buy_shop{id = 1368, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 38};
get(1369, 12, 39) -> 
    #base_limit_buy_shop{id = 1369, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1370, 12, 39) -> 
    #base_limit_buy_shop{id = 1370, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1371, 12, 39) -> 
    #base_limit_buy_shop{id = 1371, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1372, 12, 39) -> 
    #base_limit_buy_shop{id = 1372, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1373, 12, 39) -> 
    #base_limit_buy_shop{id = 1373, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1374, 12, 39) -> 
    #base_limit_buy_shop{id = 1374, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1375, 14, 39) -> 
    #base_limit_buy_shop{id = 1375, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1376, 14, 39) -> 
    #base_limit_buy_shop{id = 1376, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1377, 14, 39) -> 
    #base_limit_buy_shop{id = 1377, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1378, 14, 39) -> 
    #base_limit_buy_shop{id = 1378, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1379, 14, 39) -> 
    #base_limit_buy_shop{id = 1379, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1380, 14, 39) -> 
    #base_limit_buy_shop{id = 1380, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1381, 16, 39) -> 
    #base_limit_buy_shop{id = 1381, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1382, 16, 39) -> 
    #base_limit_buy_shop{id = 1382, time=16, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1383, 16, 39) -> 
    #base_limit_buy_shop{id = 1383, time=16, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1384, 16, 39) -> 
    #base_limit_buy_shop{id = 1384, time=16, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1385, 16, 39) -> 
    #base_limit_buy_shop{id = 1385, time=16, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1386, 16, 39) -> 
    #base_limit_buy_shop{id = 1386, time=16, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1387, 18, 39) -> 
    #base_limit_buy_shop{id = 1387, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1388, 18, 39) -> 
    #base_limit_buy_shop{id = 1388, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1389, 18, 39) -> 
    #base_limit_buy_shop{id = 1389, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1390, 18, 39) -> 
    #base_limit_buy_shop{id = 1390, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1391, 18, 39) -> 
    #base_limit_buy_shop{id = 1391, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1392, 18, 39) -> 
    #base_limit_buy_shop{id = 1392, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1393, 20, 39) -> 
    #base_limit_buy_shop{id = 1393, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1394, 20, 39) -> 
    #base_limit_buy_shop{id = 1394, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1395, 20, 39) -> 
    #base_limit_buy_shop{id = 1395, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1396, 20, 39) -> 
    #base_limit_buy_shop{id = 1396, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1397, 20, 39) -> 
    #base_limit_buy_shop{id = 1397, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1398, 20, 39) -> 
    #base_limit_buy_shop{id = 1398, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1399, 22, 39) -> 
    #base_limit_buy_shop{id = 1399, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 39};
get(1400, 22, 39) -> 
    #base_limit_buy_shop{id = 1400, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1401, 22, 39) -> 
    #base_limit_buy_shop{id = 1401, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1402, 22, 39) -> 
    #base_limit_buy_shop{id = 1402, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1403, 22, 39) -> 
    #base_limit_buy_shop{id = 1403, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1404, 22, 39) -> 
    #base_limit_buy_shop{id = 1404, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 1,  sys_buy_num = 6, type = 39};
get(1405, 12, 40) -> 
    #base_limit_buy_shop{id = 1405, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1406, 12, 40) -> 
    #base_limit_buy_shop{id = 1406, time=12, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1407, 12, 40) -> 
    #base_limit_buy_shop{id = 1407, time=12, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1408, 12, 40) -> 
    #base_limit_buy_shop{id = 1408, time=12, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1409, 12, 40) -> 
    #base_limit_buy_shop{id = 1409, time=12, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1410, 12, 40) -> 
    #base_limit_buy_shop{id = 1410, time=12, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1411, 14, 40) -> 
    #base_limit_buy_shop{id = 1411, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1412, 14, 40) -> 
    #base_limit_buy_shop{id = 1412, time=14, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1413, 14, 40) -> 
    #base_limit_buy_shop{id = 1413, time=14, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1414, 14, 40) -> 
    #base_limit_buy_shop{id = 1414, time=14, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1415, 14, 40) -> 
    #base_limit_buy_shop{id = 1415, time=14, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1416, 14, 40) -> 
    #base_limit_buy_shop{id = 1416, time=14, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1417, 16, 40) -> 
    #base_limit_buy_shop{id = 1417, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1418, 16, 40) -> 
    #base_limit_buy_shop{id = 1418, time=16, goods_id=20340, goods_num=99, price1 = 1485, price2 = 297, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1419, 16, 40) -> 
    #base_limit_buy_shop{id = 1419, time=16, goods_id=1010005, goods_num=10, price1 = 150, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1420, 16, 40) -> 
    #base_limit_buy_shop{id = 1420, time=16, goods_id=1010006, goods_num=10, price1 = 1350, price2 = 338, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1421, 16, 40) -> 
    #base_limit_buy_shop{id = 1421, time=16, goods_id=4503001, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1422, 16, 40) -> 
    #base_limit_buy_shop{id = 1422, time=16, goods_id=4503002, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1423, 18, 40) -> 
    #base_limit_buy_shop{id = 1423, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1424, 18, 40) -> 
    #base_limit_buy_shop{id = 1424, time=18, goods_id=2603003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1425, 18, 40) -> 
    #base_limit_buy_shop{id = 1425, time=18, goods_id=2608003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1426, 18, 40) -> 
    #base_limit_buy_shop{id = 1426, time=18, goods_id=2606003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1427, 18, 40) -> 
    #base_limit_buy_shop{id = 1427, time=18, goods_id=2602003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1428, 18, 40) -> 
    #base_limit_buy_shop{id = 1428, time=18, goods_id=2607003, goods_num=10, price1 = 300, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1429, 20, 40) -> 
    #base_limit_buy_shop{id = 1429, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1430, 20, 40) -> 
    #base_limit_buy_shop{id = 1430, time=20, goods_id=7301001, goods_num=50, price1 = 400, price2 = 120, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1431, 20, 40) -> 
    #base_limit_buy_shop{id = 1431, time=20, goods_id=7302001, goods_num=50, price1 = 1500, price2 = 150, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1432, 20, 40) -> 
    #base_limit_buy_shop{id = 1432, time=20, goods_id=7321001, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1433, 20, 40) -> 
    #base_limit_buy_shop{id = 1433, time=20, goods_id=7321002, goods_num=10, price1 = 1000, price2 = 200, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1434, 20, 40) -> 
    #base_limit_buy_shop{id = 1434, time=20, goods_id=3902000, goods_num=3, price1 = 450, price2 = 135, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1435, 22, 40) -> 
    #base_limit_buy_shop{id = 1435, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 40};
get(1436, 22, 40) -> 
    #base_limit_buy_shop{id = 1436, time=22, goods_id=20340, goods_num=99, price1 = 1485, price2 = 297, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1437, 22, 40) -> 
    #base_limit_buy_shop{id = 1437, time=22, goods_id=1010005, goods_num=10, price1 = 150, price2 = 75, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1438, 22, 40) -> 
    #base_limit_buy_shop{id = 1438, time=22, goods_id=1010006, goods_num=10, price1 = 1350, price2 = 338, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1439, 22, 40) -> 
    #base_limit_buy_shop{id = 1439, time=22, goods_id=4503001, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1440, 22, 40) -> 
    #base_limit_buy_shop{id = 1440, time=22, goods_id=4503002, goods_num=10, price1 = 750, price2 = 188, buy_num = 1,  sys_buy_num = 6, type = 40};
get(1441, 12, 41) -> 
    #base_limit_buy_shop{id = 1441, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1442, 12, 41) -> 
    #base_limit_buy_shop{id = 1442, time=12, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1443, 12, 41) -> 
    #base_limit_buy_shop{id = 1443, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1444, 12, 41) -> 
    #base_limit_buy_shop{id = 1444, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1445, 12, 41) -> 
    #base_limit_buy_shop{id = 1445, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1446, 12, 41) -> 
    #base_limit_buy_shop{id = 1446, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1447, 14, 41) -> 
    #base_limit_buy_shop{id = 1447, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1448, 14, 41) -> 
    #base_limit_buy_shop{id = 1448, time=14, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1449, 14, 41) -> 
    #base_limit_buy_shop{id = 1449, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1450, 14, 41) -> 
    #base_limit_buy_shop{id = 1450, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1451, 14, 41) -> 
    #base_limit_buy_shop{id = 1451, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1452, 14, 41) -> 
    #base_limit_buy_shop{id = 1452, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1453, 16, 41) -> 
    #base_limit_buy_shop{id = 1453, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1454, 16, 41) -> 
    #base_limit_buy_shop{id = 1454, time=16, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1455, 16, 41) -> 
    #base_limit_buy_shop{id = 1455, time=16, goods_id=3107002, goods_num=1, price1 = 400, price2 = 360, buy_num = 10,  sys_buy_num = 10, type = 41};
get(1456, 16, 41) -> 
    #base_limit_buy_shop{id = 1456, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1457, 16, 41) -> 
    #base_limit_buy_shop{id = 1457, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1458, 16, 41) -> 
    #base_limit_buy_shop{id = 1458, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1459, 18, 41) -> 
    #base_limit_buy_shop{id = 1459, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1460, 18, 41) -> 
    #base_limit_buy_shop{id = 1460, time=18, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1461, 18, 41) -> 
    #base_limit_buy_shop{id = 1461, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1462, 18, 41) -> 
    #base_limit_buy_shop{id = 1462, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1463, 18, 41) -> 
    #base_limit_buy_shop{id = 1463, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1464, 18, 41) -> 
    #base_limit_buy_shop{id = 1464, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1465, 20, 41) -> 
    #base_limit_buy_shop{id = 1465, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1466, 20, 41) -> 
    #base_limit_buy_shop{id = 1466, time=20, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1467, 20, 41) -> 
    #base_limit_buy_shop{id = 1467, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1468, 20, 41) -> 
    #base_limit_buy_shop{id = 1468, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1469, 20, 41) -> 
    #base_limit_buy_shop{id = 1469, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1470, 20, 41) -> 
    #base_limit_buy_shop{id = 1470, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1471, 22, 41) -> 
    #base_limit_buy_shop{id = 1471, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1472, 22, 41) -> 
    #base_limit_buy_shop{id = 1472, time=22, goods_id=8001054, goods_num=1, price1 = 30, price2 = 15, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1473, 22, 41) -> 
    #base_limit_buy_shop{id = 1473, time=22, goods_id=3107002, goods_num=1, price1 = 400, price2 = 360, buy_num = 10,  sys_buy_num = 10, type = 41};
get(1474, 22, 41) -> 
    #base_limit_buy_shop{id = 1474, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1475, 22, 41) -> 
    #base_limit_buy_shop{id = 1475, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1476, 22, 41) -> 
    #base_limit_buy_shop{id = 1476, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 41};
get(1477, 12, 42) -> 
    #base_limit_buy_shop{id = 1477, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1478, 12, 42) -> 
    #base_limit_buy_shop{id = 1478, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1479, 12, 42) -> 
    #base_limit_buy_shop{id = 1479, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1480, 12, 42) -> 
    #base_limit_buy_shop{id = 1480, time=12, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1481, 12, 42) -> 
    #base_limit_buy_shop{id = 1481, time=12, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1482, 12, 42) -> 
    #base_limit_buy_shop{id = 1482, time=12, goods_id=1010005, goods_num=50, price1 = 750, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1483, 14, 42) -> 
    #base_limit_buy_shop{id = 1483, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1484, 14, 42) -> 
    #base_limit_buy_shop{id = 1484, time=14, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1485, 14, 42) -> 
    #base_limit_buy_shop{id = 1485, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1486, 14, 42) -> 
    #base_limit_buy_shop{id = 1486, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1487, 14, 42) -> 
    #base_limit_buy_shop{id = 1487, time=14, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1488, 14, 42) -> 
    #base_limit_buy_shop{id = 1488, time=14, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1489, 16, 42) -> 
    #base_limit_buy_shop{id = 1489, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1490, 16, 42) -> 
    #base_limit_buy_shop{id = 1490, time=16, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1491, 16, 42) -> 
    #base_limit_buy_shop{id = 1491, time=16, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 30, type = 42};
get(1492, 16, 42) -> 
    #base_limit_buy_shop{id = 1492, time=16, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1493, 16, 42) -> 
    #base_limit_buy_shop{id = 1493, time=16, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1494, 16, 42) -> 
    #base_limit_buy_shop{id = 1494, time=16, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1495, 18, 42) -> 
    #base_limit_buy_shop{id = 1495, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1496, 18, 42) -> 
    #base_limit_buy_shop{id = 1496, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1497, 18, 42) -> 
    #base_limit_buy_shop{id = 1497, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1498, 18, 42) -> 
    #base_limit_buy_shop{id = 1498, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1499, 18, 42) -> 
    #base_limit_buy_shop{id = 1499, time=18, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1500, 18, 42) -> 
    #base_limit_buy_shop{id = 1500, time=18, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1501, 20, 42) -> 
    #base_limit_buy_shop{id = 1501, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1502, 20, 42) -> 
    #base_limit_buy_shop{id = 1502, time=20, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1503, 20, 42) -> 
    #base_limit_buy_shop{id = 1503, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 45, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1504, 20, 42) -> 
    #base_limit_buy_shop{id = 1504, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 70, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1505, 20, 42) -> 
    #base_limit_buy_shop{id = 1505, time=20, goods_id=8001085, goods_num=5, price1 = 100, price2 = 50, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1506, 20, 42) -> 
    #base_limit_buy_shop{id = 1506, time=20, goods_id=8001058, goods_num=1, price1 = 150, price2 = 90, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1507, 22, 42) -> 
    #base_limit_buy_shop{id = 1507, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1508, 22, 42) -> 
    #base_limit_buy_shop{id = 1508, time=22, goods_id=8002516, goods_num=10, price1 = 300, price2 = 150, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1509, 22, 42) -> 
    #base_limit_buy_shop{id = 1509, time=22, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 30, type = 42};
get(1510, 22, 42) -> 
    #base_limit_buy_shop{id = 1510, time=22, goods_id=20340, goods_num=20, price1 = 300, price2 = 60, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1511, 22, 42) -> 
    #base_limit_buy_shop{id = 1511, time=22, goods_id=8001085, goods_num=5, price1 = 100, price2 = 20, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1512, 22, 42) -> 
    #base_limit_buy_shop{id = 1512, time=22, goods_id=8001058, goods_num=1, price1 = 150, price2 = 30, buy_num = 1,  sys_buy_num = 5, type = 42};
get(1513, 12, 43) -> 
    #base_limit_buy_shop{id = 1513, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1514, 12, 43) -> 
    #base_limit_buy_shop{id = 1514, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1515, 12, 43) -> 
    #base_limit_buy_shop{id = 1515, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1516, 12, 43) -> 
    #base_limit_buy_shop{id = 1516, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1517, 12, 43) -> 
    #base_limit_buy_shop{id = 1517, time=12, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1518, 12, 43) -> 
    #base_limit_buy_shop{id = 1518, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1519, 14, 43) -> 
    #base_limit_buy_shop{id = 1519, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1520, 14, 43) -> 
    #base_limit_buy_shop{id = 1520, time=14, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1521, 14, 43) -> 
    #base_limit_buy_shop{id = 1521, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1522, 14, 43) -> 
    #base_limit_buy_shop{id = 1522, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1523, 14, 43) -> 
    #base_limit_buy_shop{id = 1523, time=14, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1524, 14, 43) -> 
    #base_limit_buy_shop{id = 1524, time=14, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1525, 16, 43) -> 
    #base_limit_buy_shop{id = 1525, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1526, 16, 43) -> 
    #base_limit_buy_shop{id = 1526, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1527, 16, 43) -> 
    #base_limit_buy_shop{id = 1527, time=16, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 10, type = 43};
get(1528, 16, 43) -> 
    #base_limit_buy_shop{id = 1528, time=16, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1529, 16, 43) -> 
    #base_limit_buy_shop{id = 1529, time=16, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1530, 16, 43) -> 
    #base_limit_buy_shop{id = 1530, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1531, 18, 43) -> 
    #base_limit_buy_shop{id = 1531, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1532, 18, 43) -> 
    #base_limit_buy_shop{id = 1532, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1533, 18, 43) -> 
    #base_limit_buy_shop{id = 1533, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1534, 18, 43) -> 
    #base_limit_buy_shop{id = 1534, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1535, 18, 43) -> 
    #base_limit_buy_shop{id = 1535, time=18, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1536, 18, 43) -> 
    #base_limit_buy_shop{id = 1536, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1537, 20, 43) -> 
    #base_limit_buy_shop{id = 1537, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1538, 20, 43) -> 
    #base_limit_buy_shop{id = 1538, time=20, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1539, 20, 43) -> 
    #base_limit_buy_shop{id = 1539, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1540, 20, 43) -> 
    #base_limit_buy_shop{id = 1540, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1541, 20, 43) -> 
    #base_limit_buy_shop{id = 1541, time=20, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1542, 20, 43) -> 
    #base_limit_buy_shop{id = 1542, time=20, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1543, 22, 43) -> 
    #base_limit_buy_shop{id = 1543, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1544, 22, 43) -> 
    #base_limit_buy_shop{id = 1544, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1545, 22, 43) -> 
    #base_limit_buy_shop{id = 1545, time=22, goods_id=3307008, goods_num=1, price1 = 300, price2 = 270, buy_num = 10,  sys_buy_num = 10, type = 43};
get(1546, 22, 43) -> 
    #base_limit_buy_shop{id = 1546, time=22, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1547, 22, 43) -> 
    #base_limit_buy_shop{id = 1547, time=22, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1548, 22, 43) -> 
    #base_limit_buy_shop{id = 1548, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 43};
get(1549, 12, 44) -> 
    #base_limit_buy_shop{id = 1549, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1550, 12, 44) -> 
    #base_limit_buy_shop{id = 1550, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1551, 12, 44) -> 
    #base_limit_buy_shop{id = 1551, time=12, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1552, 12, 44) -> 
    #base_limit_buy_shop{id = 1552, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1553, 12, 44) -> 
    #base_limit_buy_shop{id = 1553, time=12, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1554, 12, 44) -> 
    #base_limit_buy_shop{id = 1554, time=12, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1555, 14, 44) -> 
    #base_limit_buy_shop{id = 1555, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1556, 14, 44) -> 
    #base_limit_buy_shop{id = 1556, time=14, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1557, 14, 44) -> 
    #base_limit_buy_shop{id = 1557, time=14, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1558, 14, 44) -> 
    #base_limit_buy_shop{id = 1558, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1559, 14, 44) -> 
    #base_limit_buy_shop{id = 1559, time=14, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1560, 14, 44) -> 
    #base_limit_buy_shop{id = 1560, time=14, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1561, 16, 44) -> 
    #base_limit_buy_shop{id = 1561, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1562, 16, 44) -> 
    #base_limit_buy_shop{id = 1562, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1563, 16, 44) -> 
    #base_limit_buy_shop{id = 1563, time=16, goods_id=6602008, goods_num=1, price1 = 200, price2 = 180, buy_num = 10,  sys_buy_num = 10, type = 44};
get(1564, 16, 44) -> 
    #base_limit_buy_shop{id = 1564, time=16, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1565, 16, 44) -> 
    #base_limit_buy_shop{id = 1565, time=16, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1566, 16, 44) -> 
    #base_limit_buy_shop{id = 1566, time=16, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1567, 18, 44) -> 
    #base_limit_buy_shop{id = 1567, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1568, 18, 44) -> 
    #base_limit_buy_shop{id = 1568, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1569, 18, 44) -> 
    #base_limit_buy_shop{id = 1569, time=18, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1570, 18, 44) -> 
    #base_limit_buy_shop{id = 1570, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1571, 18, 44) -> 
    #base_limit_buy_shop{id = 1571, time=18, goods_id=2014001, goods_num=5, price1 = 500, price2 = 100, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1572, 18, 44) -> 
    #base_limit_buy_shop{id = 1572, time=18, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1573, 20, 44) -> 
    #base_limit_buy_shop{id = 1573, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1574, 20, 44) -> 
    #base_limit_buy_shop{id = 1574, time=20, goods_id=2001000, goods_num=10, price1 = 50, price2 = 25, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1575, 20, 44) -> 
    #base_limit_buy_shop{id = 1575, time=20, goods_id=1015001, goods_num=3, price1 = 450, price2 = 90, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1576, 20, 44) -> 
    #base_limit_buy_shop{id = 1576, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 20, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1577, 20, 44) -> 
    #base_limit_buy_shop{id = 1577, time=20, goods_id=2002000, goods_num=30, price1 = 60, price2 = 24, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1578, 20, 44) -> 
    #base_limit_buy_shop{id = 1578, time=20, goods_id=6002002, goods_num=30, price1 = 1500, price2 = 150, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1579, 22, 44) -> 
    #base_limit_buy_shop{id = 1579, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1580, 22, 44) -> 
    #base_limit_buy_shop{id = 1580, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1581, 22, 44) -> 
    #base_limit_buy_shop{id = 1581, time=22, goods_id=6602008, goods_num=1, price1 = 200, price2 = 180, buy_num = 10,  sys_buy_num = 10, type = 44};
get(1582, 22, 44) -> 
    #base_limit_buy_shop{id = 1582, time=22, goods_id=2602003, goods_num=20, price1 = 600, price2 = 192, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1583, 22, 44) -> 
    #base_limit_buy_shop{id = 1583, time=22, goods_id=6102001, goods_num=30, price1 = 600, price2 = 120, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1584, 22, 44) -> 
    #base_limit_buy_shop{id = 1584, time=22, goods_id=11601, goods_num=1, price1 = 450, price2 = 144, buy_num = 5,  sys_buy_num = 5, type = 44};
get(1585, 12, 45) -> 
    #base_limit_buy_shop{id = 1585, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1586, 12, 45) -> 
    #base_limit_buy_shop{id = 1586, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1587, 12, 45) -> 
    #base_limit_buy_shop{id = 1587, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1588, 12, 45) -> 
    #base_limit_buy_shop{id = 1588, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1589, 12, 45) -> 
    #base_limit_buy_shop{id = 1589, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1590, 12, 45) -> 
    #base_limit_buy_shop{id = 1590, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1591, 14, 45) -> 
    #base_limit_buy_shop{id = 1591, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1592, 14, 45) -> 
    #base_limit_buy_shop{id = 1592, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1593, 14, 45) -> 
    #base_limit_buy_shop{id = 1593, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1594, 14, 45) -> 
    #base_limit_buy_shop{id = 1594, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1595, 14, 45) -> 
    #base_limit_buy_shop{id = 1595, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1596, 14, 45) -> 
    #base_limit_buy_shop{id = 1596, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1597, 16, 45) -> 
    #base_limit_buy_shop{id = 1597, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1598, 16, 45) -> 
    #base_limit_buy_shop{id = 1598, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1599, 16, 45) -> 
    #base_limit_buy_shop{id = 1599, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1600, 16, 45) -> 
    #base_limit_buy_shop{id = 1600, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1601, 16, 45) -> 
    #base_limit_buy_shop{id = 1601, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1602, 16, 45) -> 
    #base_limit_buy_shop{id = 1602, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1603, 18, 45) -> 
    #base_limit_buy_shop{id = 1603, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1604, 18, 45) -> 
    #base_limit_buy_shop{id = 1604, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1605, 18, 45) -> 
    #base_limit_buy_shop{id = 1605, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1606, 18, 45) -> 
    #base_limit_buy_shop{id = 1606, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1607, 18, 45) -> 
    #base_limit_buy_shop{id = 1607, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1608, 18, 45) -> 
    #base_limit_buy_shop{id = 1608, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1609, 20, 45) -> 
    #base_limit_buy_shop{id = 1609, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1610, 20, 45) -> 
    #base_limit_buy_shop{id = 1610, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1611, 20, 45) -> 
    #base_limit_buy_shop{id = 1611, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1612, 20, 45) -> 
    #base_limit_buy_shop{id = 1612, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1613, 20, 45) -> 
    #base_limit_buy_shop{id = 1613, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1614, 20, 45) -> 
    #base_limit_buy_shop{id = 1614, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1615, 22, 45) -> 
    #base_limit_buy_shop{id = 1615, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 45};
get(1616, 22, 45) -> 
    #base_limit_buy_shop{id = 1616, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1617, 22, 45) -> 
    #base_limit_buy_shop{id = 1617, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1618, 22, 45) -> 
    #base_limit_buy_shop{id = 1618, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1619, 22, 45) -> 
    #base_limit_buy_shop{id = 1619, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1620, 22, 45) -> 
    #base_limit_buy_shop{id = 1620, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 45};
get(1621, 12, 46) -> 
    #base_limit_buy_shop{id = 1621, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1622, 12, 46) -> 
    #base_limit_buy_shop{id = 1622, time=12, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1623, 12, 46) -> 
    #base_limit_buy_shop{id = 1623, time=12, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1624, 12, 46) -> 
    #base_limit_buy_shop{id = 1624, time=12, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1625, 12, 46) -> 
    #base_limit_buy_shop{id = 1625, time=12, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1626, 12, 46) -> 
    #base_limit_buy_shop{id = 1626, time=12, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1627, 14, 46) -> 
    #base_limit_buy_shop{id = 1627, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1628, 14, 46) -> 
    #base_limit_buy_shop{id = 1628, time=14, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1629, 14, 46) -> 
    #base_limit_buy_shop{id = 1629, time=14, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1630, 14, 46) -> 
    #base_limit_buy_shop{id = 1630, time=14, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1631, 14, 46) -> 
    #base_limit_buy_shop{id = 1631, time=14, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1632, 14, 46) -> 
    #base_limit_buy_shop{id = 1632, time=14, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1633, 16, 46) -> 
    #base_limit_buy_shop{id = 1633, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1634, 16, 46) -> 
    #base_limit_buy_shop{id = 1634, time=16, goods_id=3101000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1635, 16, 46) -> 
    #base_limit_buy_shop{id = 1635, time=16, goods_id=3201000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1636, 16, 46) -> 
    #base_limit_buy_shop{id = 1636, time=16, goods_id=3301000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1637, 16, 46) -> 
    #base_limit_buy_shop{id = 1637, time=16, goods_id=3401000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1638, 16, 46) -> 
    #base_limit_buy_shop{id = 1638, time=16, goods_id=3501000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1639, 18, 46) -> 
    #base_limit_buy_shop{id = 1639, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1640, 18, 46) -> 
    #base_limit_buy_shop{id = 1640, time=18, goods_id=3101000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1641, 18, 46) -> 
    #base_limit_buy_shop{id = 1641, time=18, goods_id=3201000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1642, 18, 46) -> 
    #base_limit_buy_shop{id = 1642, time=18, goods_id=3301000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1643, 18, 46) -> 
    #base_limit_buy_shop{id = 1643, time=18, goods_id=3401000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1644, 18, 46) -> 
    #base_limit_buy_shop{id = 1644, time=18, goods_id=3501000, goods_num=10, price1 = 300, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1645, 20, 46) -> 
    #base_limit_buy_shop{id = 1645, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1646, 20, 46) -> 
    #base_limit_buy_shop{id = 1646, time=20, goods_id=2003000, goods_num=50, price1 = 250, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1647, 20, 46) -> 
    #base_limit_buy_shop{id = 1647, time=20, goods_id=10101, goods_num=200000, price1 = 200, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1648, 20, 46) -> 
    #base_limit_buy_shop{id = 1648, time=20, goods_id=5101423, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1649, 20, 46) -> 
    #base_limit_buy_shop{id = 1649, time=20, goods_id=5101433, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1650, 20, 46) -> 
    #base_limit_buy_shop{id = 1650, time=20, goods_id=5101443, goods_num=1, price1 = 40, price2 = 20, buy_num = 3,  sys_buy_num = 10, type = 46};
get(1651, 22, 46) -> 
    #base_limit_buy_shop{id = 1651, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 10, type = 46};
get(1652, 22, 46) -> 
    #base_limit_buy_shop{id = 1652, time=22, goods_id=1025001, goods_num=99, price1 = 198, price2 = 99, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1653, 22, 46) -> 
    #base_limit_buy_shop{id = 1653, time=22, goods_id=1025002, goods_num=9, price1 = 900, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1654, 22, 46) -> 
    #base_limit_buy_shop{id = 1654, time=22, goods_id=1025003, goods_num=1, price1 = 600, price2 = 360, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1655, 22, 46) -> 
    #base_limit_buy_shop{id = 1655, time=22, goods_id=7206001, goods_num=200, price1 = 200, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1656, 22, 46) -> 
    #base_limit_buy_shop{id = 1656, time=22, goods_id=7207001, goods_num=100, price1 = 500, price2 = 100, buy_num = 3,  sys_buy_num = 6, type = 46};
get(1657, 12, 47) -> 
    #base_limit_buy_shop{id = 1657, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1658, 12, 47) -> 
    #base_limit_buy_shop{id = 1658, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1659, 12, 47) -> 
    #base_limit_buy_shop{id = 1659, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1660, 12, 47) -> 
    #base_limit_buy_shop{id = 1660, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1661, 12, 47) -> 
    #base_limit_buy_shop{id = 1661, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1662, 12, 47) -> 
    #base_limit_buy_shop{id = 1662, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1663, 14, 47) -> 
    #base_limit_buy_shop{id = 1663, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1664, 14, 47) -> 
    #base_limit_buy_shop{id = 1664, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1665, 14, 47) -> 
    #base_limit_buy_shop{id = 1665, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1666, 14, 47) -> 
    #base_limit_buy_shop{id = 1666, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1667, 14, 47) -> 
    #base_limit_buy_shop{id = 1667, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1668, 14, 47) -> 
    #base_limit_buy_shop{id = 1668, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1669, 16, 47) -> 
    #base_limit_buy_shop{id = 1669, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1670, 16, 47) -> 
    #base_limit_buy_shop{id = 1670, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1671, 16, 47) -> 
    #base_limit_buy_shop{id = 1671, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1672, 16, 47) -> 
    #base_limit_buy_shop{id = 1672, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1673, 16, 47) -> 
    #base_limit_buy_shop{id = 1673, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1674, 16, 47) -> 
    #base_limit_buy_shop{id = 1674, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1675, 18, 47) -> 
    #base_limit_buy_shop{id = 1675, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1676, 18, 47) -> 
    #base_limit_buy_shop{id = 1676, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1677, 18, 47) -> 
    #base_limit_buy_shop{id = 1677, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1678, 18, 47) -> 
    #base_limit_buy_shop{id = 1678, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1679, 18, 47) -> 
    #base_limit_buy_shop{id = 1679, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1680, 18, 47) -> 
    #base_limit_buy_shop{id = 1680, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1681, 20, 47) -> 
    #base_limit_buy_shop{id = 1681, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1682, 20, 47) -> 
    #base_limit_buy_shop{id = 1682, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1683, 20, 47) -> 
    #base_limit_buy_shop{id = 1683, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1684, 20, 47) -> 
    #base_limit_buy_shop{id = 1684, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1685, 20, 47) -> 
    #base_limit_buy_shop{id = 1685, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1686, 20, 47) -> 
    #base_limit_buy_shop{id = 1686, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1687, 22, 47) -> 
    #base_limit_buy_shop{id = 1687, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 47};
get(1688, 22, 47) -> 
    #base_limit_buy_shop{id = 1688, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1689, 22, 47) -> 
    #base_limit_buy_shop{id = 1689, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1690, 22, 47) -> 
    #base_limit_buy_shop{id = 1690, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1691, 22, 47) -> 
    #base_limit_buy_shop{id = 1691, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1692, 22, 47) -> 
    #base_limit_buy_shop{id = 1692, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 47};
get(1693, 12, 48) -> 
    #base_limit_buy_shop{id = 1693, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1694, 12, 48) -> 
    #base_limit_buy_shop{id = 1694, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1695, 12, 48) -> 
    #base_limit_buy_shop{id = 1695, time=12, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1696, 12, 48) -> 
    #base_limit_buy_shop{id = 1696, time=12, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1697, 12, 48) -> 
    #base_limit_buy_shop{id = 1697, time=12, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1698, 12, 48) -> 
    #base_limit_buy_shop{id = 1698, time=12, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1699, 14, 48) -> 
    #base_limit_buy_shop{id = 1699, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1700, 14, 48) -> 
    #base_limit_buy_shop{id = 1700, time=14, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1701, 14, 48) -> 
    #base_limit_buy_shop{id = 1701, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1702, 14, 48) -> 
    #base_limit_buy_shop{id = 1702, time=14, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1703, 14, 48) -> 
    #base_limit_buy_shop{id = 1703, time=14, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1704, 14, 48) -> 
    #base_limit_buy_shop{id = 1704, time=14, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1705, 16, 48) -> 
    #base_limit_buy_shop{id = 1705, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1706, 16, 48) -> 
    #base_limit_buy_shop{id = 1706, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1707, 16, 48) -> 
    #base_limit_buy_shop{id = 1707, time=16, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1708, 16, 48) -> 
    #base_limit_buy_shop{id = 1708, time=16, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1709, 16, 48) -> 
    #base_limit_buy_shop{id = 1709, time=16, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1710, 16, 48) -> 
    #base_limit_buy_shop{id = 1710, time=16, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1711, 18, 48) -> 
    #base_limit_buy_shop{id = 1711, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1712, 18, 48) -> 
    #base_limit_buy_shop{id = 1712, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1713, 18, 48) -> 
    #base_limit_buy_shop{id = 1713, time=18, goods_id=2003000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1714, 18, 48) -> 
    #base_limit_buy_shop{id = 1714, time=18, goods_id=8002516, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1715, 18, 48) -> 
    #base_limit_buy_shop{id = 1715, time=18, goods_id=7302001, goods_num=10, price1 = 300, price2 = 90, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1716, 18, 48) -> 
    #base_limit_buy_shop{id = 1716, time=18, goods_id=2005000, goods_num=50, price1 = 100, price2 = 32, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1717, 20, 48) -> 
    #base_limit_buy_shop{id = 1717, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1718, 20, 48) -> 
    #base_limit_buy_shop{id = 1718, time=20, goods_id=2001000, goods_num=20, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1719, 20, 48) -> 
    #base_limit_buy_shop{id = 1719, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1720, 20, 48) -> 
    #base_limit_buy_shop{id = 1720, time=20, goods_id=2005000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1721, 20, 48) -> 
    #base_limit_buy_shop{id = 1721, time=20, goods_id=2002000, goods_num=50, price1 = 100, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1722, 20, 48) -> 
    #base_limit_buy_shop{id = 1722, time=20, goods_id=8002517, goods_num=20, price1 = 1000, price2 = 200, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1723, 22, 48) -> 
    #base_limit_buy_shop{id = 1723, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 48};
get(1724, 22, 48) -> 
    #base_limit_buy_shop{id = 1724, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1725, 22, 48) -> 
    #base_limit_buy_shop{id = 1725, time=22, goods_id=10101, goods_num=30000, price1 = 30, price2 = 15, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1726, 22, 48) -> 
    #base_limit_buy_shop{id = 1726, time=22, goods_id=7321002, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1727, 22, 48) -> 
    #base_limit_buy_shop{id = 1727, time=22, goods_id=8002518, goods_num=20, price1 = 400, price2 = 120, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1728, 22, 48) -> 
    #base_limit_buy_shop{id = 1728, time=22, goods_id=7321001, goods_num=3, price1 = 300, price2 = 150, buy_num = 3,  sys_buy_num = 6, type = 48};
get(1729, 12, 49) -> 
    #base_limit_buy_shop{id = 1729, time=12, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1730, 12, 49) -> 
    #base_limit_buy_shop{id = 1730, time=12, goods_id=5101415, goods_num=1, price1 = 240, price2 = 84, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1731, 12, 49) -> 
    #base_limit_buy_shop{id = 1731, time=12, goods_id=2003000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1732, 12, 49) -> 
    #base_limit_buy_shop{id = 1732, time=12, goods_id=8002516, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1733, 12, 49) -> 
    #base_limit_buy_shop{id = 1733, time=12, goods_id=7302001, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1734, 12, 49) -> 
    #base_limit_buy_shop{id = 1734, time=12, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1735, 14, 49) -> 
    #base_limit_buy_shop{id = 1735, time=14, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1736, 14, 49) -> 
    #base_limit_buy_shop{id = 1736, time=14, goods_id=2001000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1737, 14, 49) -> 
    #base_limit_buy_shop{id = 1737, time=14, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1738, 14, 49) -> 
    #base_limit_buy_shop{id = 1738, time=14, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1739, 14, 49) -> 
    #base_limit_buy_shop{id = 1739, time=14, goods_id=2002000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1740, 14, 49) -> 
    #base_limit_buy_shop{id = 1740, time=14, goods_id=7303005, goods_num=5, price1 = 150, price2 = 75, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1741, 16, 49) -> 
    #base_limit_buy_shop{id = 1741, time=16, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1742, 16, 49) -> 
    #base_limit_buy_shop{id = 1742, time=16, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1743, 16, 49) -> 
    #base_limit_buy_shop{id = 1743, time=16, goods_id=10101, goods_num=60000, price1 = 60, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1744, 16, 49) -> 
    #base_limit_buy_shop{id = 1744, time=16, goods_id=7321002, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1745, 16, 49) -> 
    #base_limit_buy_shop{id = 1745, time=16, goods_id=8002518, goods_num=40, price1 = 800, price2 = 280, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1746, 16, 49) -> 
    #base_limit_buy_shop{id = 1746, time=16, goods_id=7321001, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1747, 18, 49) -> 
    #base_limit_buy_shop{id = 1747, time=18, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1748, 18, 49) -> 
    #base_limit_buy_shop{id = 1748, time=18, goods_id=5101415, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1749, 18, 49) -> 
    #base_limit_buy_shop{id = 1749, time=18, goods_id=2003000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1750, 18, 49) -> 
    #base_limit_buy_shop{id = 1750, time=18, goods_id=8002516, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1751, 18, 49) -> 
    #base_limit_buy_shop{id = 1751, time=18, goods_id=7302001, goods_num=20, price1 = 600, price2 = 210, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1752, 18, 49) -> 
    #base_limit_buy_shop{id = 1752, time=18, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1753, 20, 49) -> 
    #base_limit_buy_shop{id = 1753, time=20, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1754, 20, 49) -> 
    #base_limit_buy_shop{id = 1754, time=20, goods_id=2001000, goods_num=40, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1755, 20, 49) -> 
    #base_limit_buy_shop{id = 1755, time=20, goods_id=5101405, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1756, 20, 49) -> 
    #base_limit_buy_shop{id = 1756, time=20, goods_id=2005000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1757, 20, 49) -> 
    #base_limit_buy_shop{id = 1757, time=20, goods_id=2002000, goods_num=100, price1 = 200, price2 = 70, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1758, 20, 49) -> 
    #base_limit_buy_shop{id = 1758, time=20, goods_id=7303010, goods_num=5, price1 = 250, price2 = 125, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1759, 22, 49) -> 
    #base_limit_buy_shop{id = 1759, time=22, goods_id=8001181, goods_num=1, price1 = 400, price2 = 10, buy_num = 1,  sys_buy_num = 6, type = 49};
get(1760, 22, 49) -> 
    #base_limit_buy_shop{id = 1760, time=22, goods_id=5101425, goods_num=1, price1 = 240, price2 = 60, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1761, 22, 49) -> 
    #base_limit_buy_shop{id = 1761, time=22, goods_id=10101, goods_num=60000, price1 = 60, price2 = 30, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1762, 22, 49) -> 
    #base_limit_buy_shop{id = 1762, time=22, goods_id=7321002, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1763, 22, 49) -> 
    #base_limit_buy_shop{id = 1763, time=22, goods_id=8002518, goods_num=40, price1 = 800, price2 = 280, buy_num = 3,  sys_buy_num = 6, type = 49};
get(1764, 22, 49) -> 
    #base_limit_buy_shop{id = 1764, time=22, goods_id=7321001, goods_num=6, price1 = 600, price2 = 300, buy_num = 3,  sys_buy_num = 6, type = 49};
get(_id, _time, _type) -> [].

get_all() -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440,1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471,1472,1473,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489,1490,1491,1492,1493,1494,1495,1496,1497,1498,1499,1500,1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,1539,1540,1541,1542,1543,1544,1545,1546,1547,1548,1549,1550,1551,1552,1553,1554,1555,1556,1557,1558,1559,1560,1561,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1584,1585,1586,1587,1588,1589,1590,1591,1592,1593,1594,1595,1596,1597,1598,1599,1600,1601,1602,1603,1604,1605,1606,1607,1608,1609,1610,1611,1612,1613,1614,1615,1616,1617,1618,1619,1620,1621,1622,1623,1624,1625,1626,1627,1628,1629,1630,1631,1632,1633,1634,1635,1636,1637,1638,1639,1640,1641,1642,1643,1644,1645,1646,1647,1648,1649,1650,1651,1652,1653,1654,1655,1656,1657,1658,1659,1660,1661,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1672,1673,1674,1675,1676,1677,1678,1679,1680,1681,1682,1683,1684,1685,1686,1687,1688,1689,1690,1691,1692,1693,1694,1695,1696,1697,1698,1699,1700,1701,1702,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728,1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1741,1742,1743,1744,1745,1746,1747,1748,1749,1750,1751,1752,1753,1754,1755,1756,1757,1758,1759,1760,1761,1762,1763,1764].

get_time_by_type(1) -> [12,14,16,18,20,22];

get_time_by_type(2) -> [12,14,16,18,20,22];

get_time_by_type(3) -> [12,14,16,18,20,22];

get_time_by_type(4) -> [12,14,16,18,20,22];

get_time_by_type(5) -> [12,14,16,18,20,22];

get_time_by_type(6) -> [12,14,16,18,20,22];

get_time_by_type(7) -> [12,14,16,18,20,22];

get_time_by_type(8) -> [12,14,16,18,20,22];

get_time_by_type(9) -> [12,14,16,18,20,22];

get_time_by_type(10) -> [12,14,16,18,20,22];

get_time_by_type(11) -> [12,14,16,18,20,22];

get_time_by_type(12) -> [12,14,16,18,20,22];

get_time_by_type(13) -> [12,14,16,18,20,22];

get_time_by_type(14) -> [12,14,16,18,20,22];

get_time_by_type(15) -> [12,14,16,18,20,22];

get_time_by_type(16) -> [12,14,16,18,20,22];

get_time_by_type(17) -> [12,14,16,18,20,22];

get_time_by_type(18) -> [12,14,16,18,20,22];

get_time_by_type(19) -> [12,14,16,18,20,22];

get_time_by_type(20) -> [12,14,16,18,20,22];

get_time_by_type(21) -> [12,14,16,18,20,22];

get_time_by_type(22) -> [12,14,16,18,20,22];

get_time_by_type(23) -> [12,14,16,18,20,22];

get_time_by_type(24) -> [12,14,16,18,20,22];

get_time_by_type(25) -> [12,14,16,18,20,22];

get_time_by_type(26) -> [12,14,16,18,20,22];

get_time_by_type(27) -> [12,14,16,18,20,22];

get_time_by_type(28) -> [12,14,16,18,20,22];

get_time_by_type(29) -> [12,14,16,18,20,22];

get_time_by_type(30) -> [12,14,16,18,20,22];

get_time_by_type(31) -> [12,14,16,18,20,22];

get_time_by_type(32) -> [12,14,16,18,20,22];

get_time_by_type(33) -> [12,14,16,18,20,22];

get_time_by_type(34) -> [12,14,16,18,20,22];

get_time_by_type(35) -> [12,14,16,18,20,22];

get_time_by_type(36) -> [12,14,16,18,20,22];

get_time_by_type(37) -> [12,14,16,18,20,22];

get_time_by_type(38) -> [12,14,16,18,20,22];

get_time_by_type(39) -> [12,14,16,18,20,22];

get_time_by_type(40) -> [12,14,16,18,20,22];

get_time_by_type(41) -> [12,14,16,18,20,22];

get_time_by_type(42) -> [12,14,16,18,20,22];

get_time_by_type(43) -> [12,14,16,18,20,22];

get_time_by_type(44) -> [12,14,16,18,20,22];

get_time_by_type(45) -> [12,14,16,18,20,22];

get_time_by_type(46) -> [12,14,16,18,20,22];

get_time_by_type(47) -> [12,14,16,18,20,22];

get_time_by_type(48) -> [12,14,16,18,20,22];

get_time_by_type(49) -> [12,14,16,18,20,22].

get_ids_by_type(1) -> [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];

get_ids_by_type(2) -> [37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72];

get_ids_by_type(3) -> [73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108];

get_ids_by_type(4) -> [109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144];

get_ids_by_type(5) -> [145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180];

get_ids_by_type(6) -> [181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216];

get_ids_by_type(7) -> [217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252];

get_ids_by_type(8) -> [253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288];

get_ids_by_type(9) -> [289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324];

get_ids_by_type(10) -> [325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360];

get_ids_by_type(11) -> [361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396];

get_ids_by_type(12) -> [397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432];

get_ids_by_type(13) -> [433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468];

get_ids_by_type(14) -> [469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504];

get_ids_by_type(15) -> [505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540];

get_ids_by_type(16) -> [541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576];

get_ids_by_type(17) -> [577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612];

get_ids_by_type(18) -> [613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,643,644,645,646,647,648];

get_ids_by_type(19) -> [649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684];

get_ids_by_type(20) -> [685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720];

get_ids_by_type(21) -> [721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756];

get_ids_by_type(22) -> [757,758,759,760,761,762,763,764,765,766,767,768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792];

get_ids_by_type(23) -> [793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828];

get_ids_by_type(24) -> [829,830,831,832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864];

get_ids_by_type(25) -> [865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900];

get_ids_by_type(26) -> [901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936];

get_ids_by_type(27) -> [937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,963,964,965,966,967,968,969,970,971,972];

get_ids_by_type(28) -> [973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008];

get_ids_by_type(29) -> [1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044];

get_ids_by_type(30) -> [1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080];

get_ids_by_type(31) -> [1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116];

get_ids_by_type(32) -> [1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152];

get_ids_by_type(33) -> [1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188];

get_ids_by_type(34) -> [1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1219,1220,1221,1222,1223,1224];

get_ids_by_type(35) -> [1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260];

get_ids_by_type(36) -> [1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296];

get_ids_by_type(37) -> [1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332];

get_ids_by_type(38) -> [1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368];

get_ids_by_type(39) -> [1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404];

get_ids_by_type(40) -> [1405,1406,1407,1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440];

get_ids_by_type(41) -> [1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471,1472,1473,1474,1475,1476];

get_ids_by_type(42) -> [1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489,1490,1491,1492,1493,1494,1495,1496,1497,1498,1499,1500,1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512];

get_ids_by_type(43) -> [1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,1539,1540,1541,1542,1543,1544,1545,1546,1547,1548];

get_ids_by_type(44) -> [1549,1550,1551,1552,1553,1554,1555,1556,1557,1558,1559,1560,1561,1562,1563,1564,1565,1566,1567,1568,1569,1570,1571,1572,1573,1574,1575,1576,1577,1578,1579,1580,1581,1582,1583,1584];

get_ids_by_type(45) -> [1585,1586,1587,1588,1589,1590,1591,1592,1593,1594,1595,1596,1597,1598,1599,1600,1601,1602,1603,1604,1605,1606,1607,1608,1609,1610,1611,1612,1613,1614,1615,1616,1617,1618,1619,1620];

get_ids_by_type(46) -> [1621,1622,1623,1624,1625,1626,1627,1628,1629,1630,1631,1632,1633,1634,1635,1636,1637,1638,1639,1640,1641,1642,1643,1644,1645,1646,1647,1648,1649,1650,1651,1652,1653,1654,1655,1656];

get_ids_by_type(47) -> [1657,1658,1659,1660,1661,1662,1663,1664,1665,1666,1667,1668,1669,1670,1671,1672,1673,1674,1675,1676,1677,1678,1679,1680,1681,1682,1683,1684,1685,1686,1687,1688,1689,1690,1691,1692];

get_ids_by_type(48) -> [1693,1694,1695,1696,1697,1698,1699,1700,1701,1702,1703,1704,1705,1706,1707,1708,1709,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,1722,1723,1724,1725,1726,1727,1728];

get_ids_by_type(49) -> [1729,1730,1731,1732,1733,1734,1735,1736,1737,1738,1739,1740,1741,1742,1743,1744,1745,1746,1747,1748,1749,1750,1751,1752,1753,1754,1755,1756,1757,1758,1759,1760,1761,1762,1763,1764].

