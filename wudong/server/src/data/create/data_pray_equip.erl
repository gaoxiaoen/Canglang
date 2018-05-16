%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pray_equip
	%%% @Created : 2016-02-02 14:36:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pray_equip).
-export([get/1]).
-include("pray.hrl").
get(Lv) when Lv >= 45 andalso Lv =< 52  -> 
   #base_pray_equip{min_lv = 45 ,max_lv = 52 ,color = [{1,5500},{2,4000},{3,500}] ,level = [{45,100}] ,sub_type = [{1,100},{2,100},{3,100},{4,100},{6,100},{7,100},{8,100}] ,need_time = 720 };
get(Lv) when Lv >= 53 andalso Lv =< 60  -> 
   #base_pray_equip{min_lv = 53 ,max_lv = 60 ,color = [{1,5500},{2,4000},{3,500}] ,level = [{53,100}] ,sub_type = [{1,100},{2,100},{3,100},{4,100},{6,100},{7,100},{8,100}] ,need_time = 720 };
get(Lv) when Lv >= 61 andalso Lv =< 68  -> 
   #base_pray_equip{min_lv = 61 ,max_lv = 68 ,color = [{1,5500},{2,4000},{3,500}] ,level = [{61,100}] ,sub_type = [{1,100},{2,100},{3,100},{4,100},{6,100},{7,100},{8,100}] ,need_time = 720 };
get(Lv) when Lv >= 69 andalso Lv =< 76  -> 
   #base_pray_equip{min_lv = 69 ,max_lv = 76 ,color = [{1,5500},{2,4000},{3,500}] ,level = [{69,100}] ,sub_type = [{1,100},{2,100},{3,100},{4,100},{6,100},{7,100},{8,100}] ,need_time = 720 };
get(_) -> [].