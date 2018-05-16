%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_magic_weapon_stage
	%%% @Created : 2018-05-07 10:39:10
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_magic_weapon_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("magic_weapon.hrl").
-include("common.hrl").

    max_stage() ->11.
figure2stage(10001)->1;
figure2stage(10002)->2;
figure2stage(10003)->3;
figure2stage(10004)->4;
figure2stage(10005)->5;
figure2stage(10006)->6;
figure2stage(10007)->7;
figure2stage(10008)->8;
figure2stage(10009)->9;
figure2stage(10010)->10;
figure2stage(10011)->11;
figure2stage(_) -> [].
get(1) -> #base_magic_weapon_stage{stage = 1 ,weapon_id = 10001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 1 ,cd = 0 ,attrs = [{att,102},{def,51},{hp_lim,1020},{crit,22},{ten,21},{hit,20},{dodge,19}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3304000,1},{10106,50}}};
get(2) -> #base_magic_weapon_stage{stage = 2 ,weapon_id = 10002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 2 ,cd = 0 ,attrs = [{att,357},{def,179},{hp_lim,3570},{crit,79},{ten,75},{hit,71},{dodge,68}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3305000,2},{10106,70}}};
get(3) -> #base_magic_weapon_stage{stage = 3 ,weapon_id = 10003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 3 ,cd = 0 ,attrs = [{att,867},{def,434},{hp_lim,8670},{crit,191},{ten,182},{hit,173},{dodge,165}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3304000,1},{3305000,1}}};
get(4) -> #base_magic_weapon_stage{stage = 4 ,weapon_id = 10004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 4 ,cd = 86400 ,attrs = [{att,1530},{def,765},{hp_lim,15300},{crit,337},{ten,321},{hit,306},{dodge,291}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3305000,1},{3321125,1}}};
get(5) -> #base_magic_weapon_stage{stage = 5 ,weapon_id = 10005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 5 ,cd = 86400 ,attrs = [{att,2346},{def,1173},{hp_lim,23460},{crit,516},{ten,493},{hit,469},{dodge,446}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3306000,1},{3322155,1}}};
get(6) -> #base_magic_weapon_stage{stage = 6 ,weapon_id = 10006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 6 ,cd = 86400 ,attrs = [{att,3366},{def,1683},{hp_lim,33660},{crit,741},{ten,707},{hit,673},{dodge,640}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3302000,1},{3303000,3}}};
get(7) -> #base_magic_weapon_stage{stage = 7 ,weapon_id = 10007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 7 ,cd = 86400 ,attrs = [{att,5916},{def,2958},{hp_lim,59160},{crit,1302},{ten,1242},{hit,1183},{dodge,1124}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3302000,2},{3303000,5}}};
get(8) -> #base_magic_weapon_stage{stage = 8 ,weapon_id = 10008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 8 ,cd = 86400 ,attrs = [{att,8670},{def,4335},{hp_lim,86700},{crit,1907},{ten,1821},{hit,1734},{dodge,1647}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3302000,2},{3303000,8}}};
get(9) -> #base_magic_weapon_stage{stage = 9 ,weapon_id = 10009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 9 ,cd = 86400 ,attrs = [{att,12240},{def,6120},{hp_lim,122400},{crit,2693},{ten,2570},{hit,2448},{dodge,2326}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3302000,3},{3303000,10}}};
get(10) -> #base_magic_weapon_stage{stage = 10 ,weapon_id = 10010 ,exp = 4000 ,exp_full = 4500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 10 ,cd = 86400 ,attrs = [{att,16320},{def,8160},{hp_lim,163200},{crit,3590},{ten,3427},{hit,3264},{dodge,3101}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3302000,4},{3303000,12}}};
get(11) -> #base_magic_weapon_stage{stage = 11 ,weapon_id = 10011 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3301000} ,gid_auto = 3301000 ,num = 0 ,cd = 86400 ,attrs = [{att,22575},{def,11288},{hp_lim,225750},{crit,4967},{ten,4741},{hit,4515},{dodge,4289}],bless_attrs = [],award = {}};
get(_Data) -> [].