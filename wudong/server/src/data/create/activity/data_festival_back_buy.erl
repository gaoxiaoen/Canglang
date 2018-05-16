%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_festival_back_buy
	%%% @Created : 2018-05-14 21:34:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_festival_back_buy).
-export([get/1, get_ids_by_actType/1, get_by_actType_orderId/2]).
-include("activity.hrl").
get(1) -> #base_festival_back_buy{id = 1, order_id=1, act_type=1, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 10000, price = 5800};
get(2) -> #base_festival_back_buy{id = 2, order_id=2, act_type=1, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 5000, price = 3300};
get(3) -> #base_festival_back_buy{id = 3, order_id=3, act_type=1, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 1500, price = 1245};
get(4) -> #base_festival_back_buy{id = 4, order_id=4, act_type=1, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 4000, price = 2800};
get(5) -> #base_festival_back_buy{id = 5, order_id=5, act_type=1, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 1600, price = 1280};
get(6) -> #base_festival_back_buy{id = 6, order_id=6, act_type=1, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 600, price = 540};
get(7) -> #base_festival_back_buy{id = 7, order_id=7, act_type=1, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(8) -> #base_festival_back_buy{id = 8, order_id=8, act_type=1, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(9) -> #base_festival_back_buy{id = 9, order_id=9, act_type=1, goods_id=8002516, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 1800, price = 1260};
get(10) -> #base_festival_back_buy{id = 10, order_id=10, act_type=1, goods_id=8002516, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 900, price = 720};
get(11) -> #base_festival_back_buy{id = 11, order_id=11, act_type=1, goods_id=8002516, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 300, price = 270};
get(12) -> #base_festival_back_buy{id = 12, order_id=12, act_type=1, goods_id=8001058, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 50, base_price = 150, price = 75};
get(13) -> #base_festival_back_buy{id = 13, order_id=13, act_type=1, goods_id=8001085, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 60, base_price = 20, price = 12};
get(14) -> #base_festival_back_buy{id = 14, order_id=14, act_type=1, goods_id=8002404, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 80, price = 56};
get(15) -> #base_festival_back_buy{id = 15, order_id=1, act_type=2, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 10000, price = 5800};
get(16) -> #base_festival_back_buy{id = 16, order_id=2, act_type=2, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 5000, price = 3300};
get(17) -> #base_festival_back_buy{id = 17, order_id=3, act_type=2, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 1500, price = 1245};
get(18) -> #base_festival_back_buy{id = 18, order_id=4, act_type=2, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 4000, price = 2800};
get(19) -> #base_festival_back_buy{id = 19, order_id=5, act_type=2, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 1600, price = 1280};
get(20) -> #base_festival_back_buy{id = 20, order_id=6, act_type=2, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 600, price = 540};
get(21) -> #base_festival_back_buy{id = 21, order_id=7, act_type=2, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(22) -> #base_festival_back_buy{id = 22, order_id=8, act_type=2, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(23) -> #base_festival_back_buy{id = 23, order_id=9, act_type=2, goods_id=8002516, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 1800, price = 1260};
get(24) -> #base_festival_back_buy{id = 24, order_id=10, act_type=2, goods_id=8002516, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 900, price = 720};
get(25) -> #base_festival_back_buy{id = 25, order_id=11, act_type=2, goods_id=8002516, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 300, price = 270};
get(26) -> #base_festival_back_buy{id = 26, order_id=12, act_type=2, goods_id=8001058, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 50, base_price = 150, price = 75};
get(27) -> #base_festival_back_buy{id = 27, order_id=13, act_type=2, goods_id=8001085, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 60, base_price = 20, price = 12};
get(28) -> #base_festival_back_buy{id = 28, order_id=14, act_type=2, goods_id=8002404, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 80, price = 56};
get(29) -> #base_festival_back_buy{id = 29, order_id=1, act_type=3, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 500, price = 290};
get(30) -> #base_festival_back_buy{id = 30, order_id=2, act_type=3, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 500, price = 330};
get(31) -> #base_festival_back_buy{id = 31, order_id=3, act_type=3, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 500, price = 415};
get(32) -> #base_festival_back_buy{id = 32, order_id=4, act_type=3, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 20, price = 14};
get(33) -> #base_festival_back_buy{id = 33, order_id=5, act_type=3, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 20, price = 16};
get(34) -> #base_festival_back_buy{id = 34, order_id=6, act_type=3, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 20, price = 18};
get(35) -> #base_festival_back_buy{id = 35, order_id=7, act_type=3, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(36) -> #base_festival_back_buy{id = 36, order_id=8, act_type=3, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get(37) -> #base_festival_back_buy{id = 37, order_id=9, act_type=3, goods_id=40001, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 30, price = 21};
get(38) -> #base_festival_back_buy{id = 38, order_id=10, act_type=3, goods_id=40001, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 30, price = 24};
get(39) -> #base_festival_back_buy{id = 39, order_id=11, act_type=3, goods_id=40001, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 30, price = 27};
get(40) -> #base_festival_back_buy{id = 40, order_id=12, act_type=3, goods_id=40002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 200, price = 180};
get(41) -> #base_festival_back_buy{id = 41, order_id=13, act_type=3, goods_id=40031, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 300, price = 270};
get(42) -> #base_festival_back_buy{id = 42, order_id=14, act_type=3, goods_id=40032, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 300, price = 270};
get(_Id) -> [].

get_by_actType_orderId(1, 1) -> #base_festival_back_buy{id = 1, order_id=1, act_type=1, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 10000, price = 5800};
get_by_actType_orderId(1, 2) -> #base_festival_back_buy{id = 2, order_id=2, act_type=1, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 5000, price = 3300};
get_by_actType_orderId(1, 3) -> #base_festival_back_buy{id = 3, order_id=3, act_type=1, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 1500, price = 1245};
get_by_actType_orderId(1, 4) -> #base_festival_back_buy{id = 4, order_id=4, act_type=1, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 4000, price = 2800};
get_by_actType_orderId(1, 5) -> #base_festival_back_buy{id = 5, order_id=5, act_type=1, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 1600, price = 1280};
get_by_actType_orderId(1, 6) -> #base_festival_back_buy{id = 6, order_id=6, act_type=1, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 600, price = 540};
get_by_actType_orderId(1, 7) -> #base_festival_back_buy{id = 7, order_id=7, act_type=1, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(1, 8) -> #base_festival_back_buy{id = 8, order_id=8, act_type=1, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(1, 9) -> #base_festival_back_buy{id = 9, order_id=9, act_type=1, goods_id=8002516, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 1800, price = 1260};
get_by_actType_orderId(1, 10) -> #base_festival_back_buy{id = 10, order_id=10, act_type=1, goods_id=8002516, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 900, price = 720};
get_by_actType_orderId(1, 11) -> #base_festival_back_buy{id = 11, order_id=11, act_type=1, goods_id=8002516, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 300, price = 270};
get_by_actType_orderId(1, 12) -> #base_festival_back_buy{id = 12, order_id=12, act_type=1, goods_id=8001058, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 50, base_price = 150, price = 75};
get_by_actType_orderId(1, 13) -> #base_festival_back_buy{id = 13, order_id=13, act_type=1, goods_id=8001085, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 60, base_price = 20, price = 12};
get_by_actType_orderId(1, 14) -> #base_festival_back_buy{id = 14, order_id=14, act_type=1, goods_id=8002404, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 80, price = 56};
get_by_actType_orderId(2, 1) -> #base_festival_back_buy{id = 15, order_id=1, act_type=2, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 10000, price = 5800};
get_by_actType_orderId(2, 2) -> #base_festival_back_buy{id = 16, order_id=2, act_type=2, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 5000, price = 3300};
get_by_actType_orderId(2, 3) -> #base_festival_back_buy{id = 17, order_id=3, act_type=2, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 1500, price = 1245};
get_by_actType_orderId(2, 4) -> #base_festival_back_buy{id = 18, order_id=4, act_type=2, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 4000, price = 2800};
get_by_actType_orderId(2, 5) -> #base_festival_back_buy{id = 19, order_id=5, act_type=2, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 1600, price = 1280};
get_by_actType_orderId(2, 6) -> #base_festival_back_buy{id = 20, order_id=6, act_type=2, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 600, price = 540};
get_by_actType_orderId(2, 7) -> #base_festival_back_buy{id = 21, order_id=7, act_type=2, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(2, 8) -> #base_festival_back_buy{id = 22, order_id=8, act_type=2, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(2, 9) -> #base_festival_back_buy{id = 23, order_id=9, act_type=2, goods_id=8002516, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 1800, price = 1260};
get_by_actType_orderId(2, 10) -> #base_festival_back_buy{id = 24, order_id=10, act_type=2, goods_id=8002516, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 900, price = 720};
get_by_actType_orderId(2, 11) -> #base_festival_back_buy{id = 25, order_id=11, act_type=2, goods_id=8002516, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 300, price = 270};
get_by_actType_orderId(2, 12) -> #base_festival_back_buy{id = 26, order_id=12, act_type=2, goods_id=8001058, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 50, base_price = 150, price = 75};
get_by_actType_orderId(2, 13) -> #base_festival_back_buy{id = 27, order_id=13, act_type=2, goods_id=8001085, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 60, base_price = 20, price = 12};
get_by_actType_orderId(2, 14) -> #base_festival_back_buy{id = 28, order_id=14, act_type=2, goods_id=8002404, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 80, price = 56};
get_by_actType_orderId(3, 1) -> #base_festival_back_buy{id = 29, order_id=1, act_type=3, goods_id=1045006, goods_num=20, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 58, base_price = 500, price = 290};
get_by_actType_orderId(3, 2) -> #base_festival_back_buy{id = 30, order_id=2, act_type=3, goods_id=1045006, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 66, base_price = 500, price = 330};
get_by_actType_orderId(3, 3) -> #base_festival_back_buy{id = 31, order_id=3, act_type=3, goods_id=1045006, goods_num=3, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 83, base_price = 500, price = 415};
get_by_actType_orderId(3, 4) -> #base_festival_back_buy{id = 32, order_id=4, act_type=3, goods_id=1045007, goods_num=200, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 70, base_price = 20, price = 14};
get_by_actType_orderId(3, 5) -> #base_festival_back_buy{id = 33, order_id=5, act_type=3, goods_id=1045007, goods_num=80, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 80, base_price = 20, price = 16};
get_by_actType_orderId(3, 6) -> #base_festival_back_buy{id = 34, order_id=6, act_type=3, goods_id=1045007, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 99, discount = 90, base_price = 20, price = 18};
get_by_actType_orderId(3, 7) -> #base_festival_back_buy{id = 35, order_id=7, act_type=3, goods_id=8001309, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(3, 8) -> #base_festival_back_buy{id = 36, order_id=8, act_type=3, goods_id=1047002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 999, discount = 90, base_price = 300, price = 100};
get_by_actType_orderId(3, 9) -> #base_festival_back_buy{id = 37, order_id=9, act_type=3, goods_id=40001, goods_num=60, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 70, base_price = 30, price = 21};
get_by_actType_orderId(3, 10) -> #base_festival_back_buy{id = 38, order_id=10, act_type=3, goods_id=40001, goods_num=30, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 80, base_price = 30, price = 24};
get_by_actType_orderId(3, 11) -> #base_festival_back_buy{id = 39, order_id=11, act_type=3, goods_id=40001, goods_num=10, hour = 0, sys_limit_num = 999, limit_num = 1, discount = 90, base_price = 30, price = 27};
get_by_actType_orderId(3, 12) -> #base_festival_back_buy{id = 40, order_id=12, act_type=3, goods_id=40002, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 200, price = 180};
get_by_actType_orderId(3, 13) -> #base_festival_back_buy{id = 41, order_id=13, act_type=3, goods_id=40031, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 300, price = 270};
get_by_actType_orderId(3, 14) -> #base_festival_back_buy{id = 42, order_id=14, act_type=3, goods_id=40032, goods_num=1, hour = 0, sys_limit_num = 999, limit_num = 10, discount = 90, base_price = 300, price = 270};
get_by_actType_orderId(_ActType, _OrderId) -> [].

get_ids_by_actType(1) -> 
	[1,2,3,4,5,6,7,8,9,10,11,12,13,14];
get_ids_by_actType(2) -> 
	[15,16,17,18,19,20,21,22,23,24,25,26,27,28];
get_ids_by_actType(3) -> 
	[29,30,31,32,33,34,35,36,37,38,39,40,41,42];
get_ids_by_actType(_ActType) -> [].