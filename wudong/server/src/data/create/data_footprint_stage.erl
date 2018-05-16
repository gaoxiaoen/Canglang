%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_footprint_stage
	%%% @Created : 2017-07-13 10:40:47
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_footprint_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("footprint_new.hrl").
-include("common.hrl").

    max_stage() ->10.
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
figure2stage(_) -> [].
get(1) -> #base_footprint_stage{stage = 1 ,footprint_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 1 ,cd = 0 ,attrs = [{att,105},{def,53},{hp_lim,1050},{crit,23},{ten,22},{hit,21},{dodge,20}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3604000,1},{10106,50}}};
get(2) -> #base_footprint_stage{stage = 2 ,footprint_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 2 ,cd = 0 ,attrs = [{att,368},{def,184},{hp_lim,3680},{crit,81},{ten,77},{hit,74},{dodge,70}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3605000,2},{10106,70}}};
get(3) -> #base_footprint_stage{stage = 3 ,footprint_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 3 ,cd = 0 ,attrs = [{att,893},{def,447},{hp_lim,8930},{crit,196},{ten,188},{hit,179},{dodge,170}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3604000,1},{3605000,1}}};
get(4) -> #base_footprint_stage{stage = 4 ,footprint_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 4 ,cd = 86400 ,attrs = [{att,1575},{def,788},{hp_lim,15750},{crit,347},{ten,331},{hit,315},{dodge,299}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3605000,1},{3621125,1}}};
get(5) -> #base_footprint_stage{stage = 5 ,footprint_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 5 ,cd = 86400 ,attrs = [{att,2415},{def,1208},{hp_lim,24150},{crit,531},{ten,507},{hit,483},{dodge,459}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3606000,1},{3622155,1}}};
get(6) -> #base_footprint_stage{stage = 6 ,footprint_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 6 ,cd = 86400 ,attrs = [{att,3465},{def,1733},{hp_lim,34650},{crit,762},{ten,728},{hit,693},{dodge,658}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3602000,1},{3603000,3}}};
get(7) -> #base_footprint_stage{stage = 7 ,footprint_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 7 ,cd = 86400 ,attrs = [{att,6090},{def,3045},{hp_lim,60900},{crit,1340},{ten,1279},{hit,1218},{dodge,1157}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3602000,2},{3603000,5}}};
get(8) -> #base_footprint_stage{stage = 8 ,footprint_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 8 ,cd = 86400 ,attrs = [{att,8925},{def,4463},{hp_lim,89250},{crit,1964},{ten,1874},{hit,1785},{dodge,1696}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3602000,2},{3603000,8}}};
get(9) -> #base_footprint_stage{stage = 9 ,footprint_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 9 ,cd = 86400 ,attrs = [{att,12600},{def,6300},{hp_lim,126000},{crit,2772},{ten,2646},{hit,2520},{dodge,2394}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3602000,3},{3603000,10}}};
get(10) -> #base_footprint_stage{stage = 10 ,footprint_id = 110010 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3601000} ,gid_auto = 3601000 ,num = 0 ,cd = 86400 ,attrs = [{att,16800},{def,8400},{hp_lim,168000},{crit,3696},{ten,3528},{hit,3360},{dodge,3192}],bless_attrs = [],award = {}};
get(_Data) -> [].