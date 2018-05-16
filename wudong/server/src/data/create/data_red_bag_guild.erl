%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_red_bag_guild
	%%% @Created : 2017-07-11 10:05:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_red_bag_guild).
-export([get/1]).
-include("red_bag.hrl").
  get(1011000) -> #base_red_bag_guild{ goods_id=1011000,max_num=10,gold_list=[{7,{1,5}},{2,{6,10}},{1,{11,15}}] };
  get(1011001) -> #base_red_bag_guild{ goods_id=1011001,max_num=15,gold_list=[{10,{1,10}},{3,{11,15}},{2,{16,20}}] };
  get(1011002) -> #base_red_bag_guild{ goods_id=1011002,max_num=20,gold_list=[{10,{1,10}},{7,{11,20}},{3,{21,30}}] };
  get(1011003) -> #base_red_bag_guild{ goods_id=1011003,max_num=10,gold_list=[{10,{2,4}}] };
  get(1011004) -> #base_red_bag_guild{ goods_id=1011004,max_num=10,gold_list=[{10,{2,4}}] };
  get(1011005) -> #base_red_bag_guild{ goods_id=1011005,max_num=10,gold_list=[{10,{3,5}}] };
  get(1011006) -> #base_red_bag_guild{ goods_id=1011006,max_num=10,gold_list=[{10,{3,5}}] };
  get(1011007) -> #base_red_bag_guild{ goods_id=1011007,max_num=10,gold_list=[{10,{4,6}}] };
  get(1011008) -> #base_red_bag_guild{ goods_id=1011008,max_num=10,gold_list=[{10,{4,6}}] };
  get(1011009) -> #base_red_bag_guild{ goods_id=1011009,max_num=10,gold_list=[{10,{4,6}}] };
  get(7204001) -> #base_red_bag_guild{ goods_id=7204001,max_num=10,gold_list=[{10,{4,6}}] };
get(_) -> [].
