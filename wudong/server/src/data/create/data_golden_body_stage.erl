%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_golden_body_stage
	%%% @Created : 2017-07-13 10:46:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_golden_body_stage).
-export([max_stage/0]).
-export([figure2stage/1]).
-export([get/1]).
-include("golden_body.hrl").
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
get(1) -> #base_golden_body_stage{stage = 1 ,golden_body_id = 110001 ,exp = 100 ,exp_full = 125 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 1 ,cd = 0 ,attrs = [{att,104},{def,52},{hp_lim,1040},{crit,23},{ten,22},{hit,21},{dodge,20}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3804000,1},{10106,50}}};
get(2) -> #base_golden_body_stage{stage = 2 ,golden_body_id = 110002 ,exp = 200 ,exp_full = 250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 2 ,cd = 0 ,attrs = [{att,362},{def,181},{hp_lim,3620},{crit,80},{ten,76},{hit,72},{dodge,69}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3805000,2},{10106,70}}};
get(3) -> #base_golden_body_stage{stage = 3 ,golden_body_id = 110003 ,exp = 220 ,exp_full = 275 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 3 ,cd = 0 ,attrs = [{att,880},{def,440},{hp_lim,8800},{crit,194},{ten,185},{hit,176},{dodge,167}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3804000,1},{3805000,1}}};
get(4) -> #base_golden_body_stage{stage = 4 ,golden_body_id = 110004 ,exp = 300 ,exp_full = 375 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 4 ,cd = 86400 ,attrs = [{att,1553},{def,777},{hp_lim,15530},{crit,342},{ten,326},{hit,311},{dodge,295}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3805000,1},{3821125,1}}};
get(5) -> #base_golden_body_stage{stage = 5 ,golden_body_id = 110005 ,exp = 400 ,exp_full = 500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 5 ,cd = 86400 ,attrs = [{att,2381},{def,1191},{hp_lim,23810},{crit,524},{ten,500},{hit,476},{dodge,452}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3806000,1},{3822155,1}}};
get(6) -> #base_golden_body_stage{stage = 6 ,golden_body_id = 110006 ,exp = 850 ,exp_full = 1063 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 6 ,cd = 86400 ,attrs = [{att,3416},{def,1708},{hp_lim,34160},{crit,752},{ten,717},{hit,683},{dodge,649}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3802000,1},{3803000,3}}};
get(7) -> #base_golden_body_stage{stage = 7 ,golden_body_id = 110007 ,exp = 1000 ,exp_full = 1250 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 7 ,cd = 86400 ,attrs = [{att,6003},{def,3002},{hp_lim,60030},{crit,1321},{ten,1261},{hit,1201},{dodge,1141}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3802000,2},{3803000,5}}};
get(8) -> #base_golden_body_stage{stage = 8 ,golden_body_id = 110008 ,exp = 1500 ,exp_full = 1875 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 8 ,cd = 86400 ,attrs = [{att,8798},{def,4399},{hp_lim,87980},{crit,1936},{ten,1848},{hit,1760},{dodge,1672}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3802000,2},{3803000,8}}};
get(9) -> #base_golden_body_stage{stage = 9 ,golden_body_id = 110009 ,exp = 2000 ,exp_full = 2500 ,exp_min = 9 ,exp_max = 11 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 9 ,cd = 86400 ,attrs = [{att,12420},{def,6210},{hp_lim,124200},{crit,2732},{ten,2608},{hit,2484},{dodge,2360}],bless_attrs = [{att,2},{def,1},{hp_lim,20},{crit,0},{ten,0},{hit,0},{dodge,0}],award = {{3802000,3},{3803000,10}}};
get(10) -> #base_golden_body_stage{stage = 10 ,golden_body_id = 110010 ,exp = 0 ,exp_full = 0 ,exp_min = 0 ,exp_max = 0 ,goods_ids = {3801000} ,gid_auto = 3801000 ,num = 0 ,cd = 86400 ,attrs = [{att,16560},{def,8280},{hp_lim,165600},{crit,3643},{ten,3478},{hit,3312},{dodge,3146}],bless_attrs = [],award = {}};
get(_Data) -> [].