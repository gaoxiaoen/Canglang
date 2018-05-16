%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_god_treasure_stage
	%%% @Created : 2017-11-29 18:02:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_god_treasure_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("god_treasure.hrl").
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
get(1) -> #base_god_treasure_stage{stage = 1 ,god_treasure_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 1 ,cd = 0 ,attrs = [{att,1725},{def,863},{hp_lim,17250},{crit,380},{ten,362},{hit,345},{dodge,328}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6304000,1},{10106,50}}};
get(2) -> #base_god_treasure_stage{stage = 2 ,god_treasure_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 2 ,cd = 0 ,attrs = [{att,2530},{def,1265},{hp_lim,25300},{crit,557},{ten,531},{hit,506},{dodge,481}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6305000,2},{10106,70}}};
get(3) -> #base_god_treasure_stage{stage = 3 ,god_treasure_id = 110003 ,exp = 350 ,exp_full = 438 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 3 ,cd = 0 ,attrs = [{att,3680},{def,1840},{hp_lim,36800},{crit,810},{ten,773},{hit,736},{dodge,699}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6304000,1},{6305000,1}}};
get(4) -> #base_god_treasure_stage{stage = 4 ,god_treasure_id = 110004 ,exp = 600 ,exp_full = 750 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 4 ,cd = 86400 ,attrs = [{att,4830},{def,2415},{hp_lim,48300},{crit,1063},{ten,1014},{hit,966},{dodge,918}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6305000,1},{6321125,1}}};
get(5) -> #base_god_treasure_stage{stage = 5 ,god_treasure_id = 110005 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 5 ,cd = 86400 ,attrs = [{att,7130},{def,3565},{hp_lim,71300},{crit,1569},{ten,1497},{hit,1426},{dodge,1355}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6306000,1},{6322155,1}}};
get(6) -> #base_god_treasure_stage{stage = 6 ,god_treasure_id = 110006 ,exp = 1200 ,exp_full = 1500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 6 ,cd = 86400 ,attrs = [{att,10350},{def,5175},{hp_lim,103500},{crit,2277},{ten,2174},{hit,2070},{dodge,1967}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,1},{6303000,3}}};
get(7) -> #base_god_treasure_stage{stage = 7 ,god_treasure_id = 110007 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 7 ,cd = 86400 ,attrs = [{att,15525},{def,7763},{hp_lim,155250},{crit,3416},{ten,3260},{hit,3105},{dodge,2950}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,2},{6303000,5}}};
get(8) -> #base_god_treasure_stage{stage = 8 ,god_treasure_id = 110008 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 8 ,cd = 86400 ,attrs = [{att,21850},{def,10925},{hp_lim,218500},{crit,4807},{ten,4589},{hit,4370},{dodge,4152}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,2},{6303000,8}}};
get(9) -> #base_god_treasure_stage{stage = 9 ,god_treasure_id = 110009 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 9 ,cd = 86400 ,attrs = [{att,28175},{def,14088},{hp_lim,281750},{crit,6199},{ten,5917},{hit,5635},{dodge,5353}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,3},{6303000,10}}};
get(10) -> #base_god_treasure_stage{stage = 10 ,god_treasure_id = 110010 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 10 ,cd = 86400 ,attrs = [{att,33350},{def,16675},{hp_lim,333500},{crit,7337},{ten,7004},{hit,6670},{dodge,6337}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,3},{6305000,20}}};
get(11) -> #base_god_treasure_stage{stage = 11 ,god_treasure_id = 110011 ,exp = 2500 ,exp_full = 3125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 11 ,cd = 86400 ,attrs = [{att,39100},{def,19550},{hp_lim,391000},{crit,8602},{ten,8211},{hit,7820},{dodge,7429}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{6302000,3},{6304000,20}}};
get(12) -> #base_god_treasure_stage{stage = 12 ,god_treasure_id = 110012 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {6301000} ,gid_auto = 6301000 ,num = 0 ,cd = 86400 ,attrs = [{att,43700},{def,21850},{hp_lim,437000},{crit,9614},{ten,9177},{hit,8740},{dodge,8303}],bless_attrs = [],award = {}};
get(_Data) -> [].