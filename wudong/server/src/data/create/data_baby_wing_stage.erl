%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_wing_stage
	%%% @Created : 2017-11-01 18:03:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_wing_stage).
-export([max_stage/0]).
-export([get/1]).
-include("error_code.hrl").
-include("baby_wing.hrl").
-include("common.hrl").

    max_stage() ->10.
get(1) -> #base_baby_wing_stage{stage = 1 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 1 ,cd = 0 ,attrs = [{att,103},{def,52},{hp_lim,1030},{crit,21},{ten,21},{hit,21},{dodge,20}],image = 110001 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3904000,1},{10106,50}}};
get(2) -> #base_baby_wing_stage{stage = 2 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 2 ,cd = 0 ,attrs = [{att,361},{def,181},{hp_lim,3610},{crit,72},{ten,74},{hit,74},{dodge,70}],image = 110002 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3905000,2},{10106,70}}};
get(3) -> #base_baby_wing_stage{stage = 3 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 3 ,cd = 0 ,attrs = [{att,876},{def,438},{hp_lim,8760},{crit,175},{ten,180},{hit,180},{dodge,171}],image = 110003 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3904000,1},{3905000,1}}};
get(4) -> #base_baby_wing_stage{stage = 4 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 4 ,cd = 86400 ,attrs = [{att,1545},{def,773},{hp_lim,15450},{crit,309},{ten,317},{hit,317},{dodge,301}],image = 110004 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3905000,1},{3921125,1}}};
get(5) -> #base_baby_wing_stage{stage = 5 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 5 ,cd = 86400 ,attrs = [{att,2369},{def,1185},{hp_lim,23690},{crit,474},{ten,486},{hit,486},{dodge,462}],image = 110005 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3906000,1},{3922155,1}}};
get(6) -> #base_baby_wing_stage{stage = 6 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 6 ,cd = 86400 ,attrs = [{att,3399},{def,1700},{hp_lim,33990},{crit,680},{ten,697},{hit,697},{dodge,663}],image = 110006 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3902000,1},{3903000,3}}};
get(7) -> #base_baby_wing_stage{stage = 7 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 7 ,cd = 86400 ,attrs = [{att,5974},{def,2987},{hp_lim,59740},{crit,1195},{ten,1225},{hit,1225},{dodge,1165}],image = 110007 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3902000,2},{3903000,5}}};
get(8) -> #base_baby_wing_stage{stage = 8 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 8 ,cd = 86400 ,attrs = [{att,8755},{def,4378},{hp_lim,87550},{crit,1751},{ten,1795},{hit,1795},{dodge,1707}],image = 110008 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3902000,2},{3903000,8}}};
get(9) -> #base_baby_wing_stage{stage = 9 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 9 ,cd = 86400 ,attrs = [{att,12360},{def,6180},{hp_lim,123600},{crit,2472},{ten,2534},{hit,2534},{dodge,2410}],image = 110009 ,bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3902000,3},{3903000,10}}};
get(10) -> #base_baby_wing_stage{stage = 10 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3901000} ,gid_auto = 3901000 ,num = 0 ,cd = 86400 ,attrs = [{att,16480},{def,8240},{hp_lim,164800},{crit,3296},{ten,3378},{hit,3378},{dodge,3214}],image = 110010 ,bless_attrs = [],award = {}};
get(_Data) -> [].