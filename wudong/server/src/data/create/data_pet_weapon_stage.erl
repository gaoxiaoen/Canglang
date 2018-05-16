%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_pet_weapon_stage
	%%% @Created : 2018-05-07 10:38:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_pet_weapon_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("pet_weapon.hrl").
-include("common.hrl").

    max_stage() ->11.
figure2stage(110001)->1;
figure2stage(110002)->2;
figure2stage(110003)->3;
figure2stage(110004)->4;
figure2stage(110005)->5;
figure2stage(110006)->6;
figure2stage(110007)->7;
figure2stage(110008)->8;
figure2stage(110009)->9;
figure2stage(110010)->10;
figure2stage(110011)->11;
figure2stage(_) -> [].
get(1) -> #base_pet_weapon_stage{stage = 1 ,weapon_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 1 ,cd = 0 ,attrs = [{att,104},{def,52},{hp_lim,1040},{crit,23},{ten,22},{hit,21},{dodge,20}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3504000,1},{10106,50}}};
get(2) -> #base_pet_weapon_stage{stage = 2 ,weapon_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 2 ,cd = 0 ,attrs = [{att,364},{def,182},{hp_lim,3640},{crit,80},{ten,76},{hit,73},{dodge,69}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3505000,2},{10106,70}}};
get(3) -> #base_pet_weapon_stage{stage = 3 ,weapon_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 3 ,cd = 0 ,attrs = [{att,884},{def,442},{hp_lim,8840},{crit,194},{ten,186},{hit,177},{dodge,168}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3504000,1},{3505000,1}}};
get(4) -> #base_pet_weapon_stage{stage = 4 ,weapon_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 4 ,cd = 86400 ,attrs = [{att,1560},{def,780},{hp_lim,15600},{crit,343},{ten,328},{hit,312},{dodge,296}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3505000,1},{3521125,1}}};
get(5) -> #base_pet_weapon_stage{stage = 5 ,weapon_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 5 ,cd = 86400 ,attrs = [{att,2392},{def,1196},{hp_lim,23920},{crit,526},{ten,502},{hit,478},{dodge,454}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3506000,1},{3522155,1}}};
get(6) -> #base_pet_weapon_stage{stage = 6 ,weapon_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 6 ,cd = 86400 ,attrs = [{att,3432},{def,1716},{hp_lim,34320},{crit,755},{ten,721},{hit,686},{dodge,652}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3502000,1},{3503000,3}}};
get(7) -> #base_pet_weapon_stage{stage = 7 ,weapon_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 7 ,cd = 86400 ,attrs = [{att,6032},{def,3016},{hp_lim,60320},{crit,1327},{ten,1267},{hit,1206},{dodge,1146}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3502000,2},{3503000,5}}};
get(8) -> #base_pet_weapon_stage{stage = 8 ,weapon_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 8 ,cd = 86400 ,attrs = [{att,8840},{def,4420},{hp_lim,88400},{crit,1945},{ten,1856},{hit,1768},{dodge,1680}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3502000,2},{3503000,8}}};
get(9) -> #base_pet_weapon_stage{stage = 9 ,weapon_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 9 ,cd = 86400 ,attrs = [{att,12480},{def,6240},{hp_lim,124800},{crit,2746},{ten,2621},{hit,2496},{dodge,2371}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3502000,3},{3503000,10}}};
get(10) -> #base_pet_weapon_stage{stage = 10 ,weapon_id = 110010 ,exp = 4000 ,exp_full = 4500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 10 ,cd = 86400 ,attrs = [{att,16640},{def,8320},{hp_lim,166400},{crit,3661},{ten,3494},{hit,3328},{dodge,3162}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3502000,4},{3503000,12}}};
get(11) -> #base_pet_weapon_stage{stage = 11 ,weapon_id = 110011 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3501000} ,gid_auto = 3501000 ,num = 0 ,cd = 86400 ,attrs = [{att,22575},{def,11288},{hp_lim,225750},{crit,4967},{ten,4741},{hit,4515},{dodge,4289}],bless_attrs = [],award = {}};
get(_Data) -> [].