%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_weapon_stage
	%%% @Created : 2017-09-27 17:52:17
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_weapon_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("baby_weapon.hrl").
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
get(1) -> #base_baby_weapon_stage{stage = 1 ,baby_weapon_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 1 ,cd = 0 ,attrs = [{att,110},{def,55},{hp_lim,1100},{crit,24},{ten,23},{hit,22},{dodge,21}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6004000,1},{10106,50}}};
get(2) -> #base_baby_weapon_stage{stage = 2 ,baby_weapon_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 2 ,cd = 0 ,attrs = [{att,385},{def,193},{hp_lim,3850},{crit,85},{ten,81},{hit,77},{dodge,73}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6005000,2},{10106,70}}};
get(3) -> #base_baby_weapon_stage{stage = 3 ,baby_weapon_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 3 ,cd = 0 ,attrs = [{att,935},{def,468},{hp_lim,9350},{crit,206},{ten,196},{hit,187},{dodge,178}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6004000,1},{6005000,1}}};
get(4) -> #base_baby_weapon_stage{stage = 4 ,baby_weapon_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 4 ,cd = 86400 ,attrs = [{att,1650},{def,825},{hp_lim,16500},{crit,363},{ten,347},{hit,330},{dodge,314}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6005000,1},{6021125,1}}};
get(5) -> #base_baby_weapon_stage{stage = 5 ,baby_weapon_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 5 ,cd = 86400 ,attrs = [{att,2530},{def,1265},{hp_lim,25300},{crit,557},{ten,531},{hit,506},{dodge,481}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6006000,1},{6022155,1}}};
get(6) -> #base_baby_weapon_stage{stage = 6 ,baby_weapon_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 6 ,cd = 86400 ,attrs = [{att,3630},{def,1815},{hp_lim,36300},{crit,799},{ten,762},{hit,726},{dodge,690}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6002000,1},{6003000,3}}};
get(7) -> #base_baby_weapon_stage{stage = 7 ,baby_weapon_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 7 ,cd = 86400 ,attrs = [{att,6380},{def,3190},{hp_lim,63800},{crit,1404},{ten,1340},{hit,1276},{dodge,1212}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6002000,2},{6003000,5}}};
get(8) -> #base_baby_weapon_stage{stage = 8 ,baby_weapon_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 8 ,cd = 86400 ,attrs = [{att,9350},{def,4675},{hp_lim,93500},{crit,2057},{ten,1964},{hit,1870},{dodge,1777}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6002000,2},{6003000,8}}};
get(9) -> #base_baby_weapon_stage{stage = 9 ,baby_weapon_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 9 ,cd = 86400 ,attrs = [{att,13200},{def,6600},{hp_lim,132000},{crit,2904},{ten,2772},{hit,2640},{dodge,2508}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6002000,3},{6003000,10}}};
get(10) -> #base_baby_weapon_stage{stage = 10 ,baby_weapon_id = 110010 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {6001000} ,gid_auto = 6001000 ,num = 0 ,cd = 86400 ,attrs = [{att,17600},{def,8800},{hp_lim,176000},{crit,3872},{ten,3696},{hit,3520},{dodge,3344}],bless_attrs = [],award = {}};
get(_Data) -> [].