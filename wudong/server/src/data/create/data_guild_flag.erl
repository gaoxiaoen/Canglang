%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_flag
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_flag).
-export([get/1]).
-export([get_max_guild_lv/0]).
-export([get_all_mon_id/0]).
-include("guild_fight.hrl").
get(1) -> #base_guild_flag{lv=1, mon_id=56101, guild_lv=1, need_medal=15000, attrs_list=[{att,232},{def,116},{hp_lim,2325},{crit,34},{ten,34},{hit,34},{dodge,34}], z_attrs_list=[{att,279},{def,139},{hp_lim,2790},{crit,41},{ten,41},{hit,41},{dodge,41}]};
get(2) -> #base_guild_flag{lv=2, mon_id=56102, guild_lv=2, need_medal=47320, attrs_list=[{att,465},{def,232},{hp_lim,4651},{crit,69},{ten,69},{hit,69},{dodge,69}], z_attrs_list=[{att,558},{def,279},{hp_lim,5581},{crit,83},{ten,83},{hit,83},{dodge,83}]};
get(3) -> #base_guild_flag{lv=3, mon_id=56103, guild_lv=3, need_medal=102060, attrs_list=[{att,930},{def,465},{hp_lim,9302},{crit,139},{ten,139},{hit,139},{dodge,139}], z_attrs_list=[{att,1116},{def,558},{hp_lim,11162},{crit,167},{ten,167},{hit,167},{dodge,167}]};
get(4) -> #base_guild_flag{lv=4, mon_id=56104, guild_lv=4, need_medal=219520, attrs_list=[{att,1395},{def,697},{hp_lim,13953},{crit,209},{ten,209},{hit,209},{dodge,209}], z_attrs_list=[{att,1674},{def,837},{hp_lim,16744},{crit,251},{ten,251},{hit,251},{dodge,251}]};
get(5) -> #base_guild_flag{lv=5, mon_id=56105, guild_lv=5, need_medal=470960, attrs_list=[{att,1860},{def,930},{hp_lim,18604},{crit,279},{ten,279},{hit,279},{dodge,279}], z_attrs_list=[{att,2232},{def,1116},{hp_lim,22325},{crit,334},{ten,334},{hit,334},{dodge,334}]};
get(6) -> #base_guild_flag{lv=6, mon_id=56106, guild_lv=6, need_medal=1008000, attrs_list=[{att,2325},{def,1162},{hp_lim,23255},{crit,348},{ten,348},{hit,348},{dodge,348}], z_attrs_list=[{att,2790},{def,1395},{hp_lim,27906},{crit,418},{ten,418},{hit,418},{dodge,418}]};
get(7) -> #base_guild_flag{lv=7, mon_id=56107, guild_lv=7, need_medal=2152640, attrs_list=[{att,3720},{def,1860},{hp_lim,37209},{crit,558},{ten,558},{hit,558},{dodge,558}], z_attrs_list=[{att,4465},{def,2232},{hp_lim,44651},{crit,669},{ten,669},{hit,669},{dodge,669}]};
get(8) -> #base_guild_flag{lv=8, mon_id=56108, guild_lv=8, need_medal=2293760, attrs_list=[{att,4651},{def,2325},{hp_lim,46511},{crit,697},{ten,697},{hit,697},{dodge,697}], z_attrs_list=[{att,5581},{def,2790},{hp_lim,55813},{crit,837},{ten,837},{hit,837},{dodge,837}]};
get(9) -> #base_guild_flag{lv=9, mon_id=56109, guild_lv=9, need_medal=2439360, attrs_list=[{att,6976},{def,3488},{hp_lim,69767},{crit,1046},{ten,1046},{hit,1046},{dodge,1046}], z_attrs_list=[{att,8372},{def,4186},{hp_lim,83720},{crit,1255},{ten,1255},{hit,1255},{dodge,1255}]};
get(10) -> #base_guild_flag{lv=10, mon_id=56110, guild_lv=10, need_medal=99999999999, attrs_list=[{att,9302},{def,4651},{hp_lim,93023},{crit,1395},{ten,1395},{hit,1395},{dodge,1395}], z_attrs_list=[{att,11162},{def,5581},{hp_lim,111627},{crit,1674},{ten,1674},{hit,1674},{dodge,1674}]};
get(_Lv) -> [].

get_max_guild_lv()->10.

get_all_mon_id()->[56101,56102,56103,56104,56105,56106,56107,56108,56109,56110].

