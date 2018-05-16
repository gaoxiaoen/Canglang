%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_light_weapon_stage
	%%% @Created : 2018-04-28 12:18:24
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_light_weapon_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("light_weapon.hrl").
-include("common.hrl").

    max_stage() ->12.
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
figure2stage(110012)->12;
figure2stage(_) -> [].
get(1) -> #base_light_weapon_stage{stage = 1 ,weapon_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 1 ,cd = 0 ,attrs = [{att,103},{def,52},{hp_lim,1030},{crit,23},{ten,22},{hit,21},{dodge,20}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3404000,1},{10106,50}}};
get(2) -> #base_light_weapon_stage{stage = 2 ,weapon_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 2 ,cd = 0 ,attrs = [{att,361},{def,181},{hp_lim,3610},{crit,79},{ten,76},{hit,72},{dodge,69}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3405000,2},{10106,70}}};
get(3) -> #base_light_weapon_stage{stage = 3 ,weapon_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 3 ,cd = 0 ,attrs = [{att,876},{def,438},{hp_lim,8760},{crit,193},{ten,184},{hit,175},{dodge,166}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3404000,1},{3405000,1}}};
get(4) -> #base_light_weapon_stage{stage = 4 ,weapon_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 4 ,cd = 86400 ,attrs = [{att,1545},{def,773},{hp_lim,15450},{crit,340},{ten,324},{hit,309},{dodge,294}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3405000,1},{3421125,1}}};
get(5) -> #base_light_weapon_stage{stage = 5 ,weapon_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 5 ,cd = 86400 ,attrs = [{att,2369},{def,1185},{hp_lim,23690},{crit,521},{ten,497},{hit,474},{dodge,450}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3406000,1},{3422155,1}}};
get(6) -> #base_light_weapon_stage{stage = 6 ,weapon_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 6 ,cd = 86400 ,attrs = [{att,3399},{def,1700},{hp_lim,33990},{crit,748},{ten,714},{hit,680},{dodge,646}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,1},{3403000,3}}};
get(7) -> #base_light_weapon_stage{stage = 7 ,weapon_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 7 ,cd = 86400 ,attrs = [{att,5974},{def,2987},{hp_lim,59740},{crit,1314},{ten,1255},{hit,1195},{dodge,1135}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,2},{3403000,5}}};
get(8) -> #base_light_weapon_stage{stage = 8 ,weapon_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 8 ,cd = 86400 ,attrs = [{att,8755},{def,4378},{hp_lim,87550},{crit,1926},{ten,1839},{hit,1751},{dodge,1663}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,2},{3403000,8}}};
get(9) -> #base_light_weapon_stage{stage = 9 ,weapon_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 9 ,cd = 86400 ,attrs = [{att,12360},{def,6180},{hp_lim,123600},{crit,2719},{ten,2596},{hit,2472},{dodge,2348}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,3},{3403000,10}}};
get(10) -> #base_light_weapon_stage{stage = 10 ,weapon_id = 110010 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 10 ,cd = 86400 ,attrs = [{att,16480},{def,8240},{hp_lim,164800},{crit,3626},{ten,3461},{hit,3296},{dodge,3131}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,3},{3404000,20}}};
get(11) -> #base_light_weapon_stage{stage = 11 ,weapon_id = 110011 ,exp = 3500 ,exp_full = 4000 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 11 ,cd = 86400 ,attrs = [{att,22145},{def,11073},{hp_lim,221450},{crit,4872},{ten,4650},{hit,4429},{dodge,4208}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3402000,3},{3404000,30}}};
get(12) -> #base_light_weapon_stage{stage = 12 ,weapon_id = 110012 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3401000} ,gid_auto = 3401000 ,num = 0 ,cd = 86400 ,attrs = [{att,27300},{def,13650},{hp_lim,273000},{crit,6006},{ten,5733},{hit,5460},{dodge,5187}],bless_attrs = [],award = {}};
get(_Data) -> [].