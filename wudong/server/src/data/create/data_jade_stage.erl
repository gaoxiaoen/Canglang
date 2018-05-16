%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_jade_stage
	%%% @Created : 2017-11-29 18:03:07
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_jade_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("jade.hrl").
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
get(1) -> #base_jade_stage{stage = 1 ,jade_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 1 ,cd = 0 ,attrs = [{att,1650},{def,825},{hp_lim,16500},{crit,363},{ten,347},{hit,330},{dodge,314}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6204000,1},{10106,50}}};
get(2) -> #base_jade_stage{stage = 2 ,jade_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 2 ,cd = 0 ,attrs = [{att,2420},{def,1210},{hp_lim,24200},{crit,532},{ten,508},{hit,484},{dodge,460}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6205000,2},{10106,70}}};
get(3) -> #base_jade_stage{stage = 3 ,jade_id = 110003 ,exp = 350 ,exp_full = 438 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 3 ,cd = 0 ,attrs = [{att,3520},{def,1760},{hp_lim,35200},{crit,774},{ten,739},{hit,704},{dodge,669}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6204000,1},{6205000,1}}};
get(4) -> #base_jade_stage{stage = 4 ,jade_id = 110004 ,exp = 600 ,exp_full = 750 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 4 ,cd = 86400 ,attrs = [{att,4620},{def,2310},{hp_lim,46200},{crit,1016},{ten,970},{hit,924},{dodge,878}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6205000,1},{6221125,1}}};
get(5) -> #base_jade_stage{stage = 5 ,jade_id = 110005 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 5 ,cd = 86400 ,attrs = [{att,6820},{def,3410},{hp_lim,68200},{crit,1500},{ten,1432},{hit,1364},{dodge,1296}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6206000,1},{6222155,1}}};
get(6) -> #base_jade_stage{stage = 6 ,jade_id = 110006 ,exp = 1200 ,exp_full = 1500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 6 ,cd = 86400 ,attrs = [{att,9900},{def,4950},{hp_lim,99000},{crit,2178},{ten,2079},{hit,1980},{dodge,1881}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,1},{6203000,3}}};
get(7) -> #base_jade_stage{stage = 7 ,jade_id = 110007 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 7 ,cd = 86400 ,attrs = [{att,14850},{def,7425},{hp_lim,148500},{crit,3267},{ten,3119},{hit,2970},{dodge,2822}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,2},{6203000,5}}};
get(8) -> #base_jade_stage{stage = 8 ,jade_id = 110008 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 8 ,cd = 86400 ,attrs = [{att,20900},{def,10450},{hp_lim,209000},{crit,4598},{ten,4389},{hit,4180},{dodge,3971}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,2},{6203000,8}}};
get(9) -> #base_jade_stage{stage = 9 ,jade_id = 110009 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 9 ,cd = 86400 ,attrs = [{att,26950},{def,13475},{hp_lim,269500},{crit,5929},{ten,5660},{hit,5390},{dodge,5121}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,3},{6203000,10}}};
get(10) -> #base_jade_stage{stage = 10 ,jade_id = 110010 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 10 ,cd = 86400 ,attrs = [{att,31900},{def,15950},{hp_lim,319000},{crit,7018},{ten,6699},{hit,6380},{dodge,6061}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,3},{6205000,20}}};
get(11) -> #base_jade_stage{stage = 11 ,jade_id = 110011 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 11 ,cd = 86400 ,attrs = [{att,37400},{def,18700},{hp_lim,374000},{crit,8228},{ten,7854},{hit,7480},{dodge,7106}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6202000,3},{6204000,20}}};
get(12) -> #base_jade_stage{stage = 12 ,jade_id = 110012 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {6201000} ,gid_auto = 6201000 ,num = 0 ,cd = 86400 ,attrs = [{att,41800},{def,20900},{hp_lim,418000},{crit,9196},{ten,8778},{hit,8360},{dodge,7942}],bless_attrs = [],award = {}};
get(_Data) -> [].