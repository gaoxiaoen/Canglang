%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_awake
	%%% @Created : 2018-03-29 14:31:44
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_awake).
-export([get/2,get_all_type/0,get_all_by_type/1]).
-include("awake.hrl").
-include("common.hrl").
get(1,1) -> #base_awake{ type = 1 ,cell = 1 ,lv_top = 350 ,up_limit1 = [{2003000,100},{10108,500000000}] ,up_limit2 = [{10199,1000}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,1600},{def,800},{hp_lim,16000}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,2) -> #base_awake{ type = 1 ,cell = 2 ,lv_top = 350 ,up_limit1 = [{2003000,120},{10108,520000000}] ,up_limit2 = [{10199,1100}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,3280},{def,1640},{hp_lim,32800}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,3) -> #base_awake{ type = 1 ,cell = 3 ,lv_top = 350 ,up_limit1 = [{2003000,140},{10108,540000000}] ,up_limit2 = [{10199,1200}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,5040},{def,2520},{hp_lim,50400}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,4) -> #base_awake{ type = 1 ,cell = 4 ,lv_top = 350 ,up_limit1 = [{2003000,160},{10108,560000000}] ,up_limit2 = [{10199,1300}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,6880},{def,3440},{hp_lim,68800}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,5) -> #base_awake{ type = 1 ,cell = 5 ,lv_top = 350 ,up_limit1 = [{2003000,200},{10108,580000000}] ,up_limit2 = [{10199,1400}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,8800},{def,4400},{hp_lim,88000}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,6) -> #base_awake{ type = 1 ,cell = 6 ,lv_top = 350 ,up_limit1 = [{2003000,240},{10108,600000000}] ,up_limit2 = [{10199,1500}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,10800},{def,5400},{hp_lim,108000}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,7) -> #base_awake{ type = 1 ,cell = 7 ,lv_top = 350 ,up_limit1 = [{2003000,260},{10108,620000000}] ,up_limit2 = [{10199,1600}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,12880},{def,6440},{hp_lim,128800}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,8) -> #base_awake{ type = 1 ,cell = 8 ,lv_top = 350 ,up_limit1 = [{2003000,280},{10108,640000000}] ,up_limit2 = [{10199,1800}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,15040},{def,7520},{hp_lim,150400}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,9) -> #base_awake{ type = 1 ,cell = 9 ,lv_top = 350 ,up_limit1 = [{2003000,300},{10108,680000000}] ,up_limit2 = [{10199,2000}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,17280},{def,8640},{hp_lim,172800}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,10) -> #base_awake{ type = 1 ,cell = 10 ,lv_top = 350 ,up_limit1 = [{2003000,320},{10108,700000000}] ,up_limit2 = [{10199,2400}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,19600},{def,9800},{hp_lim,196000}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,11) -> #base_awake{ type = 1 ,cell = 11 ,lv_top = 350 ,up_limit1 = [{2003000,360},{10108,750000000}] ,up_limit2 = [{10199,2800}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,22000},{def,11000},{hp_lim,220000}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(1,12) -> #base_awake{ type = 1 ,cell = 12 ,lv_top = 350 ,up_limit1 = [{2003000,400},{10108,800000000}] ,up_limit2 = [{10199,3600}] ,awake_limit = [{lv,120},{equip_suit,60},{equip_suit_lv,6},{feixian,2}] ,attr = [{att,24480},{def,12240},{hp_lim,244800}],awake_attr = [{att,4000},{def,2000},{hp_lim,40000}]};
get(_,_) -> [].
 get_all_type() -> [1].

get_all_by_type(1)->[1,2,3,4,5,6,7,8,9,10,11,12];
 get_all_by_type(_) -> [].

