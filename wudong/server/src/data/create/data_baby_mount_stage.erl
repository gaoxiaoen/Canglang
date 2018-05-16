%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_mount_stage
	%%% @Created : 2017-12-06 17:11:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_mount_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("baby_mount.hrl").
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
get(1) -> #base_baby_mount_stage{stage = 1 ,baby_mount_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 1 ,cd = 0 ,attrs = [{att,115},{def,58},{hp_lim,1150},{crit,23},{ten,24},{hit,24},{dodge,22}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4004000,1},{10106,50}}};
get(2) -> #base_baby_mount_stage{stage = 2 ,baby_mount_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 2 ,cd = 0 ,attrs = [{att,403},{def,202},{hp_lim,4030},{crit,81},{ten,83},{hit,83},{dodge,79}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4005000,2},{10106,70}}};
get(3) -> #base_baby_mount_stage{stage = 3 ,baby_mount_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 3 ,cd = 0 ,attrs = [{att,978},{def,489},{hp_lim,9780},{crit,196},{ten,200},{hit,200},{dodge,191}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4004000,1},{4005000,1}}};
get(4) -> #base_baby_mount_stage{stage = 4 ,baby_mount_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 4 ,cd = 86400 ,attrs = [{att,1725},{def,863},{hp_lim,17250},{crit,345},{ten,354},{hit,354},{dodge,336}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4005000,1},{4021125,1}}};
get(5) -> #base_baby_mount_stage{stage = 5 ,baby_mount_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 5 ,cd = 86400 ,attrs = [{att,2645},{def,1323},{hp_lim,26450},{crit,529},{ten,542},{hit,542},{dodge,516}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4006000,1},{4022155,1}}};
get(6) -> #base_baby_mount_stage{stage = 6 ,baby_mount_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 6 ,cd = 86400 ,attrs = [{att,3795},{def,1898},{hp_lim,37950},{crit,759},{ten,778},{hit,778},{dodge,740}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4002000,1},{4003000,3}}};
get(7) -> #base_baby_mount_stage{stage = 7 ,baby_mount_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 7 ,cd = 86400 ,attrs = [{att,6670},{def,3335},{hp_lim,66700},{crit,1334},{ten,1367},{hit,1367},{dodge,1301}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4002000,2},{4003000,5}}};
get(8) -> #base_baby_mount_stage{stage = 8 ,baby_mount_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 8 ,cd = 86400 ,attrs = [{att,9775},{def,4888},{hp_lim,97750},{crit,1955},{ten,2004},{hit,2004},{dodge,1906}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4002000,2},{4003000,8}}};
get(9) -> #base_baby_mount_stage{stage = 9 ,baby_mount_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 9 ,cd = 86400 ,attrs = [{att,13800},{def,6900},{hp_lim,138000},{crit,2760},{ten,2829},{hit,2829},{dodge,2691}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{4002000,3},{4003000,10}}};
get(10) -> #base_baby_mount_stage{stage = 10 ,baby_mount_id = 110010 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {4001000} ,gid_auto = 4001000 ,num = 0 ,cd = 86400 ,attrs = [{att,18400},{def,9200},{hp_lim,184000},{crit,3680},{ten,3772},{hit,3772},{dodge,3588}],bless_attrs = [],award = {}};
get(_Data) -> [].