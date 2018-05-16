%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_red_bag_charge
	%%% @Created : 2017-06-08 21:13:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_red_bag_charge).
-export([get/1]).
-include("red_bag.hrl").
  get(Charge) when Charge >= 6480  -> #base_red_bag_charge{ charge=6480,goods_id=1028007,num=1 };
  get(Charge) when Charge >= 3280  -> #base_red_bag_charge{ charge=3280,goods_id=1028006,num=1 };
  get(Charge) when Charge >= 1980  -> #base_red_bag_charge{ charge=1980,goods_id=1028005,num=1 };
  get(Charge) when Charge >= 1280  -> #base_red_bag_charge{ charge=1280,goods_id=1028004,num=1 };
  get(Charge) when Charge >= 600  -> #base_red_bag_charge{ charge=600,goods_id=1028003,num=1 };
  get(Charge) when Charge >= 300  -> #base_red_bag_charge{ charge=300,goods_id=1028002,num=1 };
  get(Charge) when Charge >= 100  -> #base_red_bag_charge{ charge=100,goods_id=1028001,num=1 };
  get(Charge) when Charge >= 60  -> #base_red_bag_charge{ charge=60,goods_id=1028000,num=1 };
get(_) -> [].
