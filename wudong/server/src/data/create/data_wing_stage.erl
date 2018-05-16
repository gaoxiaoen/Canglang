%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wing_stage
	%%% @Created : 2018-02-28 11:24:56
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wing_stage).
-export([max_stage/0]).
-export([get/1]).
-include("error_code.hrl").
-include("wing.hrl").
-include("common.hrl").

    max_stage() ->12.
get(1) -> #base_wing_stage{stage = 1 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 1 ,cd = 0 ,attrs = [{att,105},{def,53},{hp_lim,1050},{crit,23},{ten,22},{hit,21},{dodge,20}],image = 1020001 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3204000,1},{10106,50}}};
get(2) -> #base_wing_stage{stage = 2 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 2 ,cd = 0 ,attrs = [{att,368},{def,184},{hp_lim,3680},{crit,81},{ten,77},{hit,74},{dodge,70}],image = 1020002 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3205000,2},{10106,70}}};
get(3) -> #base_wing_stage{stage = 3 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 3 ,cd = 0 ,attrs = [{att,893},{def,447},{hp_lim,8930},{crit,196},{ten,188},{hit,179},{dodge,170}],image = 1020003 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3204000,1},{3205000,1}}};
get(4) -> #base_wing_stage{stage = 4 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 4 ,cd = 86400 ,attrs = [{att,1575},{def,788},{hp_lim,15750},{crit,347},{ten,331},{hit,315},{dodge,299}],image = 1020004 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3205000,1},{3221125,1}}};
get(5) -> #base_wing_stage{stage = 5 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 5 ,cd = 86400 ,attrs = [{att,2415},{def,1208},{hp_lim,24150},{crit,531},{ten,507},{hit,483},{dodge,459}],image = 1020005 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3206000,1},{3222155,1}}};
get(6) -> #base_wing_stage{stage = 6 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 6 ,cd = 86400 ,attrs = [{att,3465},{def,1733},{hp_lim,34650},{crit,762},{ten,728},{hit,693},{dodge,658}],image = 1020006 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,1},{3203000,3}}};
get(7) -> #base_wing_stage{stage = 7 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 7 ,cd = 86400 ,attrs = [{att,6090},{def,3045},{hp_lim,60900},{crit,1340},{ten,1279},{hit,1218},{dodge,1157}],image = 1020007 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,2},{3203000,5}}};
get(8) -> #base_wing_stage{stage = 8 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 8 ,cd = 86400 ,attrs = [{att,8925},{def,4463},{hp_lim,89250},{crit,1964},{ten,1874},{hit,1785},{dodge,1696}],image = 1020008 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,2},{3203000,8}}};
get(9) -> #base_wing_stage{stage = 9 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 9 ,cd = 86400 ,attrs = [{att,12600},{def,6300},{hp_lim,126000},{crit,2772},{ten,2646},{hit,2520},{dodge,2394}],image = 1020009 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,3},{3203000,10}}};
get(10) -> #base_wing_stage{stage = 10 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 10 ,cd = 86400 ,attrs = [{att,16800},{def,8400},{hp_lim,168000},{crit,3696},{ten,3528},{hit,3360},{dodge,3192}],image = 1020010 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,3},{3204000,20}}};
get(11) -> #base_wing_stage{stage = 11 ,exp = 3500 ,exp_full = 4000 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 11 ,cd = 86400 ,attrs = [{att,22575},{def,11288},{hp_lim,225750},{crit,4967},{ten,4741},{hit,4515},{dodge,4289}],image = 1021011 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3202000,3},{3205000,20}}};
get(12) -> #base_wing_stage{stage = 12 ,exp = 0 ,exp_full = 0 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3201000} ,gid_auto = 3201000 ,num = 0 ,cd = 86400 ,attrs = [{att,27300},{def,13650},{hp_lim,273000},{crit,6006},{ten,5733},{hit,5460},{dodge,5187}],image = 1021012 ,bless_attrs = [],award = {}};
get(_Data) -> [].