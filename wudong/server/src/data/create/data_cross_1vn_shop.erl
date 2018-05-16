%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_1vn_shop
	%%% @Created : 2018-03-06 01:16:27
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_1vn_shop).
-export([get/4]).
-export([get_all/3]).
-include("common.hrl").
-include("cross_1vN.hrl").
get(0,1,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 1,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 7405001,goods_num = 500,old_cost = 5000,now_cost = 188,ratio = 30,my_count = 20,all_count = 999};
get(0,2,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 2,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 2003000,goods_num = 100,old_cost = 1000,now_cost = 188,ratio = 18,my_count = 20,all_count = 999};
get(0,3,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 3,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 8001057,goods_num = 50,old_cost = 1000,now_cost = 268,ratio = 26,my_count = 20,all_count = 999};
get(0,4,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 4,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 1015001,goods_num = 10,old_cost = 1500,now_cost = 488,ratio = 32,my_count = 20,all_count = 999};
get(0,5,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 5,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 8002516,goods_num = 30,old_cost = 900,now_cost = 400,ratio = 44,my_count = 20,all_count = 999};
get(0,6,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 6,type = 0,round = 1,merge_up = 0,merge_down = 999,goods_id = 4503001,goods_num = 3,old_cost = 500,now_cost = 120,ratio = 24,my_count = 20,all_count = 999};
get(1,1,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 1,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 4503002,goods_num = 3,old_cost = 500,now_cost = 120,ratio = 24,my_count = 20,all_count = 999};
get(1,2,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 2,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 7303015,goods_num = 1,old_cost = 1000,now_cost = 300,ratio = 30,my_count = 20,all_count = 999};
get(1,3,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 3,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 7415005,goods_num = 15,old_cost = 4000,now_cost = 1200,ratio = 30,my_count = 20,all_count = 999};
get(1,4,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 4,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 8001653,goods_num = 1,old_cost = 10000,now_cost = 4000,ratio = 40,my_count = 20,all_count = 999};
get(1,5,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 5,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 7415007,goods_num = 1,old_cost = 12000,now_cost = 6000,ratio = 50,my_count = 20,all_count = 999};
get(1,6,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 ->#base_cross_1vn_shop{id = 6,type = 1,round = 1,merge_up = 0,merge_down = 999,goods_id = 4107022,goods_num = 1,old_cost = 15000,now_cost = 9800,ratio = 65,my_count = 20,all_count = 999};
get(_,_,_,_) -> [].
get_all(0,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 -> [1,2,3,4,5,6];
get_all(1,1,MergeCount) when MergeCount >= 0 andalso MergeCount =< 999 -> [1,2,3,4,5,6];
get_all(_,_,_) -> [].
