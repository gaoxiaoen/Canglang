%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_invest
	%%% @Created : 2016-06-16 10:04:59
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_invest).
-export([get/1]).
-export([get_id_by_type/1]).
-export([get_free_num/0]).
-include("invest.hrl").
get(1) -> #base_invest{need_num = 45,type = 1,goods_list = [{10199,400},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(2) -> #base_invest{need_num = 50,type = 1,goods_list = [{10199,400},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(3) -> #base_invest{need_num = 55,type = 1,goods_list = [{10199,700},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(4) -> #base_invest{need_num = 60,type = 1,goods_list = [{10199,400},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(5) -> #base_invest{need_num = 65,type = 1,goods_list = [{10199,400},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(6) -> #base_invest{need_num = 70,type = 1,goods_list = [{10199,700},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(7) -> #base_invest{need_num = 75,type = 1,goods_list = [{10106,1000},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(8) -> #base_invest{need_num = 80,type = 1,goods_list = [{10106,1000},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(9) -> #base_invest{need_num = 85,type = 1,goods_list = [{10106,1200},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(10) -> #base_invest{need_num = 90,type = 1,goods_list = [{10106,1200},{10109,500000},{11115,20},{29243,10}],need_vip = 0};
get(11) -> #base_invest{need_num = 45,type = 2,goods_list = [{10199,1200},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(12) -> #base_invest{need_num = 50,type = 2,goods_list = [{10199,1200},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(13) -> #base_invest{need_num = 55,type = 2,goods_list = [{10199,2300},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(14) -> #base_invest{need_num = 60,type = 2,goods_list = [{10199,1200},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(15) -> #base_invest{need_num = 65,type = 2,goods_list = [{10199,1200},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(16) -> #base_invest{need_num = 70,type = 2,goods_list = [{10199,2300},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(17) -> #base_invest{need_num = 75,type = 2,goods_list = [{10106,3100},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(18) -> #base_invest{need_num = 80,type = 2,goods_list = [{10106,3100},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(19) -> #base_invest{need_num = 85,type = 2,goods_list = [{10106,3900},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(20) -> #base_invest{need_num = 90,type = 2,goods_list = [{10106,3900},{10109,2000000},{11115,80},{29243,30}],need_vip = 0};
get(21) -> #base_invest{need_num = 5,type = 3,goods_list = [{10106,100},{20253,1},{20254,1},{20255,1}],need_vip = 0};
get(22) -> #base_invest{need_num = 15,type = 3,goods_list = [{10106,150},{20253,2},{20254,2},{20255,2}],need_vip = 0};
get(23) -> #base_invest{need_num = 20,type = 3,goods_list = [{10106,200},{20253,3},{20254,3},{20255,3}],need_vip = 1};
get(24) -> #base_invest{need_num = 40,type = 3,goods_list = [{10106,250},{20253,4},{20254,4},{20255,4}],need_vip = 1};
get(25) -> #base_invest{need_num = 70,type = 3,goods_list = [{20177,1},{20253,5},{20254,5},{20255,5}],need_vip = 2};
get(_Data) -> throw({false,6}).

get_id_by_type(1) -> [1,2,3,4,5,6,7,8,9,10];
get_id_by_type(2) -> [11,12,13,14,15,16,17,18,19,20];
get_id_by_type(3) -> [21,22,23,24,25].
get_free_num() -> [5,15,20,40,70].
