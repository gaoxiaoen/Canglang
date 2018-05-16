%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wish_tree
	%%% @Created : 2016-08-11 19:52:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wish_tree).
-export([get_wish/1]).
-export([get_self_fertilize/1]).
-export([get_friends_fertilize/1]).
-export([get_self_watering/1]).
-export([get_friends_watering/1]).
-include("wish_tree.hrl").
get_wish(1) -> #base_wish{tree_lv = 1 ,lv_up_exp = 1000 ,add_exp = 50 ,goods_list = [{28150,6,1950,4320},{20001,3,1950,4320},{28000,3,1950,4320},{20200,1,1950,4320},{10109,20000,1450,4320},{37178,1,100,4320}] ,orange_goods_list = [{28211,1,10,7200},{11116,1,20,7200},{11117,1,20,7200},{11118,1,20,7200}] ,add_ref = 10 ,max_ref_process = 100 ,need_times = 43200 ,maturity_degree = 100};
get_wish(2) -> #base_wish{tree_lv = 2 ,lv_up_exp = 1600 ,add_exp = 50 ,goods_list = [{28150,6,1200,4320},{20001,6,1200,4320},{28000,6,1200,4320},{20200,1,1200,4320},{10109,20000,1200,4320},{28102,3,1100,4320},{28122,3,1000,4320},{24501,1,1000,4320},{37178,1,100,4320}] ,orange_goods_list = [{28210,1,0,7200},{28211,1,10,7200},{11116,1,20,7200},{11117,1,20,7200},{11118,1,20,7200}] ,add_ref = 10 ,max_ref_process = 100 ,need_times = 43200 ,maturity_degree = 100};
get_wish(3) -> #base_wish{tree_lv = 3 ,lv_up_exp = 1700 ,add_exp = 50 ,goods_list = [{28150,12,1200,4320},{20001,6,1200,4320},{28000,6,1200,4320},{20200,1,1200,4320},{10109,40000,1200,4320},{28102,6,1100,4320},{28122,6,1000,4320},{24501,2,1000,4320},{37178,1,100,4320}] ,orange_goods_list = [{28210,1,0,7200},{28211,1,10,7200},{11116,1,20,7200},{11117,1,20,7200},{11118,1,20,7200},{43001,1,20,43200},{43002,1,20,7200},{43003,1,20,7200}] ,add_ref = 10 ,max_ref_process = 100 ,need_times = 43200 ,maturity_degree = 100};
get_wish(4) -> #base_wish{tree_lv = 4 ,lv_up_exp = 0 ,add_exp = 0 ,goods_list = [{28150,12,700,4320},{20001,6,700,4320},{28000,6,700,4320},{20200,1,700,4320},{10109,40000,700,4320},{28102,6,800,4320},{28122,6,800,4320},{24501,2,800,4320},{20150,2,800,4320},{20170,2,800,4320},{20340,2,800,4320},{28001,1,800,4320},{37178,1,100,4320}] ,orange_goods_list = [{28210,1,0,7200},{28211,1,10,7200},{11116,1,20,7200},{11117,1,20,7200},{11118,1,20,7200},{43001,1,20,43200},{43002,1,20,7200},{43003,1,20,7200},{27050,1,0,7200}] ,add_ref = 10 ,max_ref_process = 100 ,need_times = 43200 ,maturity_degree = 100};
get_wish(_Data) -> [].

get_self_watering(1) -> #base_wish_tree_watering{times = 1 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(2) -> #base_wish_tree_watering{times = 2 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(3) -> #base_wish_tree_watering{times = 3 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(4) -> #base_wish_tree_watering{times = 4 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(5) -> #base_wish_tree_watering{times = 5 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(6) -> #base_wish_tree_watering{times = 6 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(7) -> #base_wish_tree_watering{times = 7 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(8) -> #base_wish_tree_watering{times = 8 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(9) -> #base_wish_tree_watering{times = 9 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(10) -> #base_wish_tree_watering{times = 10 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(11) -> #base_wish_tree_watering{times = 11 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(12) -> #base_wish_tree_watering{times = 12 ,cd_times = 3600 ,reduce_times = 600 ,add_exp = 5};
get_self_watering(_) -> [].

get_friends_watering(1) -> #base_wish_tree_watering{times = 1 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(2) -> #base_wish_tree_watering{times = 2 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(3) -> #base_wish_tree_watering{times = 3 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(4) -> #base_wish_tree_watering{times = 4 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(5) -> #base_wish_tree_watering{times = 5 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(6) -> #base_wish_tree_watering{times = 6 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(7) -> #base_wish_tree_watering{times = 7 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(8) -> #base_wish_tree_watering{times = 8 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(9) -> #base_wish_tree_watering{times = 9 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(10) -> #base_wish_tree_watering{times = 10 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(11) -> #base_wish_tree_watering{times = 11 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(12) -> #base_wish_tree_watering{times = 12 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(13) -> #base_wish_tree_watering{times = 13 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(14) -> #base_wish_tree_watering{times = 14 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(15) -> #base_wish_tree_watering{times = 15 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(16) -> #base_wish_tree_watering{times = 16 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(17) -> #base_wish_tree_watering{times = 17 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(18) -> #base_wish_tree_watering{times = 18 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(19) -> #base_wish_tree_watering{times = 19 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(20) -> #base_wish_tree_watering{times = 20 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(21) -> #base_wish_tree_watering{times = 21 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(22) -> #base_wish_tree_watering{times = 22 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(23) -> #base_wish_tree_watering{times = 23 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(24) -> #base_wish_tree_watering{times = 24 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(25) -> #base_wish_tree_watering{times = 25 ,cd_times = 5 ,reduce_times = 300 ,add_exp = 5 ,add_intimacy = 1};
get_friends_watering(_) -> [].

get_self_fertilize(1) -> #base_wish_tree_fertilize{times = 1 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(2) -> #base_wish_tree_fertilize{times = 2 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(3) -> #base_wish_tree_fertilize{times = 3 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(4) -> #base_wish_tree_fertilize{times = 4 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(5) -> #base_wish_tree_fertilize{times = 5 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(6) -> #base_wish_tree_fertilize{times = 6 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(7) -> #base_wish_tree_fertilize{times = 7 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(8) -> #base_wish_tree_fertilize{times = 8 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(9) -> #base_wish_tree_fertilize{times = 9 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(10) -> #base_wish_tree_fertilize{times = 10 ,need_money = 8 ,add_maturity = 10 ,add_exp = 20};
get_self_fertilize(_) -> [].

get_friends_fertilize(1) -> #base_wish_tree_fertilize{times = 1 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(2) -> #base_wish_tree_fertilize{times = 2 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(3) -> #base_wish_tree_fertilize{times = 3 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(4) -> #base_wish_tree_fertilize{times = 4 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(5) -> #base_wish_tree_fertilize{times = 5 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(6) -> #base_wish_tree_fertilize{times = 6 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(7) -> #base_wish_tree_fertilize{times = 7 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(8) -> #base_wish_tree_fertilize{times = 8 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(9) -> #base_wish_tree_fertilize{times = 9 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(10) -> #base_wish_tree_fertilize{times = 10 ,need_money = 2 ,add_maturity = 10 ,add_exp = 20 ,add_intimacy = 1};
get_friends_fertilize(_) -> [].

