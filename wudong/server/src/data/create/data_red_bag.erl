%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_red_bag
	%%% @Created : 2017-07-11 10:05:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_red_bag).
-export([get/1]).
-include("red_bag.hrl").
  get(1010000) -> #base_red_bag{ goods_id=1010000,max_num=10,random_id=1 };
  get(1028000) -> #base_red_bag{ goods_id=1028000,max_num=10,random_id=2 };
  get(1028001) -> #base_red_bag{ goods_id=1028001,max_num=1,random_id=3 };
  get(1028002) -> #base_red_bag{ goods_id=1028002,max_num=10,random_id=4 };
  get(1028003) -> #base_red_bag{ goods_id=1028003,max_num=15,random_id=5 };
  get(1028004) -> #base_red_bag{ goods_id=1028004,max_num=20,random_id=6 };
  get(1028005) -> #base_red_bag{ goods_id=1028005,max_num=25,random_id=7 };
  get(1028006) -> #base_red_bag{ goods_id=1028006,max_num=30,random_id=8 };
  get(1028007) -> #base_red_bag{ goods_id=1028007,max_num=50,random_id=9 };
get(_) -> [].
