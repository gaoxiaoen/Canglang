%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_god_weapon_spirit
	%%% @Created : 2018-05-14 16:35:42
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_god_weapon_spirit).
-export([get_type/1]).
-export([get/3]).
-include("god_weapon.hrl").
-include("common.hrl").
get_type(10001) -> [1,2,3,4,5,6];
get_type(10002) -> [1,2,3,4,5,6];
get_type(10003) -> [1,2,3,4,5,6];
get_type(10004) -> [1,2,3,4,5,6];
get_type(10005) -> [1,2,3,4,5,6];
get_type(10006) -> [1,2,3,4,5,6];
get_type(10007) -> [1,2,3,4,5,6];
get_type(10008) -> [1,2,3,4,5,6];
get_type(10009) -> [1,2,3,4,5,6];
get_type(10010) -> [1,2,3,4,5,6];
get_type(_) -> [].
get(10001,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10001,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10001,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10001,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10001,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10001,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 1 ,attrs = [{att,8}],goods_id = 6102003 ,goods_num = 1 };
get(10001,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10001,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10001,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10001,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10001,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10001,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 2 ,attrs = [{att,16}],goods_id = 6102003 ,goods_num = 1 };
get(10001,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10001,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10001,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10001,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10001,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10001,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 3 ,attrs = [{att,24}],goods_id = 6102003 ,goods_num = 2 };
get(10001,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10001,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10001,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10001,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10001,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10001,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 4 ,attrs = [{att,32}],goods_id = 6102003 ,goods_num = 2 };
get(10001,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10001,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10001,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10001,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10001,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10001,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 5 ,attrs = [{att,40}],goods_id = 6102003 ,goods_num = 2 };
get(10001,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10001,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10001,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10001,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10001,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10001,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 6 ,attrs = [{att,56}],goods_id = 6102003 ,goods_num = 3 };
get(10001,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10001,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10001,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10001,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10001,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10001,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 7 ,attrs = [{att,72}],goods_id = 6102003 ,goods_num = 3 };
get(10001,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10001,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10001,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10001,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10001,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10001,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 8 ,attrs = [{att,88}],goods_id = 6102003 ,goods_num = 4 };
get(10001,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10001,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10001,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10001,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10001,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10001,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 9 ,attrs = [{att,104}],goods_id = 6102003 ,goods_num = 4 };
get(10001,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10001,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10001,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10001,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10001,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10001,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 10 ,attrs = [{att,120}],goods_id = 6102003 ,goods_num = 4 };
get(10001,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10001,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10001,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10001,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10001,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10001,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 11 ,attrs = [{att,144}],goods_id = 6102003 ,goods_num = 5 };
get(10001,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10001,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10001,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10001,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10001,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10001,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 12 ,attrs = [{att,168}],goods_id = 6102003 ,goods_num = 5 };
get(10001,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10001,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10001,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10001,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10001,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10001,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 13 ,attrs = [{att,192}],goods_id = 6102003 ,goods_num = 6 };
get(10001,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10001,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10001,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10001,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10001,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10001,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 14 ,attrs = [{att,216}],goods_id = 6102003 ,goods_num = 6 };
get(10001,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10001,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10001,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10001,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10001,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10001,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 15 ,attrs = [{att,240}],goods_id = 6102003 ,goods_num = 6 };
get(10001,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10001,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10001,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10001,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10001,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10001,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 16 ,attrs = [{att,272}],goods_id = 6102003 ,goods_num = 7 };
get(10001,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10001,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10001,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10001,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10001,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10001,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 17 ,attrs = [{att,304}],goods_id = 6102003 ,goods_num = 7 };
get(10001,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10001,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10001,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10001,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10001,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10001,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 18 ,attrs = [{att,336}],goods_id = 6102003 ,goods_num = 8 };
get(10001,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10001,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10001,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10001,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10001,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10001,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 19 ,attrs = [{att,368}],goods_id = 6102003 ,goods_num = 8 };
get(10001,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10001,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10001,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10001,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10001,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10001,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 20 ,attrs = [{att,400}],goods_id = 6102003 ,goods_num = 8 };
get(10001,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10001,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10001,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10001,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10001,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10001,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 21 ,attrs = [{att,440}],goods_id = 6102003 ,goods_num = 9 };
get(10001,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10001,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10001,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10001,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10001,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10001,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 22 ,attrs = [{att,480}],goods_id = 6102003 ,goods_num = 9 };
get(10001,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10001,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10001,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10001,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10001,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10001,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 23 ,attrs = [{att,520}],goods_id = 6102003 ,goods_num = 10 };
get(10001,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10001,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10001,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10001,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10001,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10001,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 24 ,attrs = [{att,560}],goods_id = 6102003 ,goods_num = 10 };
get(10001,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10001,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10001,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10001,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10001,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10001,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 25 ,attrs = [{att,600}],goods_id = 6102003 ,goods_num = 10 };
get(10001,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10001,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10001,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10001,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10001,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10001,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 26 ,attrs = [{att,648}],goods_id = 6102003 ,goods_num = 11 };
get(10001,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10001,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10001,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10001,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10001,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10001,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 27 ,attrs = [{att,696}],goods_id = 6102003 ,goods_num = 11 };
get(10001,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10001,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10001,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10001,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10001,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10001,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 28 ,attrs = [{att,744}],goods_id = 6102003 ,goods_num = 12 };
get(10001,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10001,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10001,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10001,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10001,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10001,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 29 ,attrs = [{att,792}],goods_id = 6102003 ,goods_num = 12 };
get(10001,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10001,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10001,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10001,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10001,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10001,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 30 ,attrs = [{att,840}],goods_id = 6102003 ,goods_num = 12 };
get(10001,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10001,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10001,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10001,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10001,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10001,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 31 ,attrs = [{att,896}],goods_id = 6102003 ,goods_num = 13 };
get(10001,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10001,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10001,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10001,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10001,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10001,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 32 ,attrs = [{att,952}],goods_id = 6102003 ,goods_num = 13 };
get(10001,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10001,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10001,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10001,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10001,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10001,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6102003 ,goods_num = 14 };
get(10001,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10001,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10001,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10001,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10001,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10001,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6102003 ,goods_num = 14 };
get(10001,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10001,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10001,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10001,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10001,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10001,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6102003 ,goods_num = 14 };
get(10001,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10001,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10001,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10001,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10001,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10001,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6102003 ,goods_num = 15 };
get(10001,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10001,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10001,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10001,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10001,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10001,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6102003 ,goods_num = 15 };
get(10001,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10001,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10001,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10001,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10001,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10001,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6102003 ,goods_num = 16 };
get(10001,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10001,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10001,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10001,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10001,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10001,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6102003 ,goods_num = 16 };
get(10001,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10001,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10001,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10001,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10001,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10001,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6102003 ,goods_num = 16 };
get(10001,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10001,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10001,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10001,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10001,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10001,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6102003 ,goods_num = 17 };
get(10001,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10001,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10001,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10001,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10001,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10001,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6102003 ,goods_num = 17 };
get(10001,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10001,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10001,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10001,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10001,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10001,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6102003 ,goods_num = 18 };
get(10001,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10001,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10001,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10001,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10001,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10001,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6102003 ,goods_num = 18 };
get(10001,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10001,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10001,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10001,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10001,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10001,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6102003 ,goods_num = 18 };
get(10001,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10001,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10001,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10001,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10001,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10001,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6102003 ,goods_num = 19 };
get(10001,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10001,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10001,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10001,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10001,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10001,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6102003 ,goods_num = 19 };
get(10001,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10001,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10001,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10001,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10001,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10001,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6102003 ,goods_num = 20 };
get(10001,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10001,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10001,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10001,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10001,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10001,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6102003 ,goods_num = 20 };
get(10001,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 1 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10001,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 2 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10001,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 3 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10001,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 4 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10001,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 5 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10001,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10001 ,type = 6 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6102003 ,goods_num = 20 };
get(10002,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10002,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10002,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10002,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10002,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10002,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 1 ,attrs = [{def,4}],goods_id = 6102008 ,goods_num = 1 };
get(10002,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10002,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10002,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10002,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10002,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10002,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 2 ,attrs = [{def,8}],goods_id = 6102008 ,goods_num = 1 };
get(10002,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10002,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10002,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10002,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10002,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10002,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 3 ,attrs = [{def,12}],goods_id = 6102008 ,goods_num = 2 };
get(10002,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10002,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10002,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10002,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10002,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10002,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 4 ,attrs = [{def,16}],goods_id = 6102008 ,goods_num = 2 };
get(10002,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10002,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10002,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10002,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10002,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10002,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 5 ,attrs = [{def,20}],goods_id = 6102008 ,goods_num = 2 };
get(10002,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10002,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10002,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10002,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10002,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10002,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 6 ,attrs = [{def,28}],goods_id = 6102008 ,goods_num = 3 };
get(10002,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10002,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10002,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10002,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10002,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10002,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 7 ,attrs = [{def,36}],goods_id = 6102008 ,goods_num = 3 };
get(10002,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10002,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10002,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10002,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10002,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10002,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 8 ,attrs = [{def,44}],goods_id = 6102008 ,goods_num = 4 };
get(10002,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10002,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10002,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10002,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10002,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10002,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 9 ,attrs = [{def,52}],goods_id = 6102008 ,goods_num = 4 };
get(10002,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10002,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10002,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10002,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10002,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10002,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 10 ,attrs = [{def,60}],goods_id = 6102008 ,goods_num = 4 };
get(10002,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10002,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10002,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10002,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10002,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10002,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 11 ,attrs = [{def,72}],goods_id = 6102008 ,goods_num = 5 };
get(10002,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10002,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10002,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10002,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10002,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10002,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 12 ,attrs = [{def,84}],goods_id = 6102008 ,goods_num = 5 };
get(10002,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10002,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10002,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10002,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10002,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10002,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 13 ,attrs = [{def,96}],goods_id = 6102008 ,goods_num = 6 };
get(10002,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10002,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10002,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10002,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10002,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10002,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 14 ,attrs = [{def,108}],goods_id = 6102008 ,goods_num = 6 };
get(10002,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10002,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10002,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10002,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10002,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10002,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 15 ,attrs = [{def,120}],goods_id = 6102008 ,goods_num = 6 };
get(10002,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10002,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10002,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10002,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10002,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10002,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 16 ,attrs = [{def,136}],goods_id = 6102008 ,goods_num = 7 };
get(10002,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10002,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10002,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10002,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10002,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10002,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 17 ,attrs = [{def,152}],goods_id = 6102008 ,goods_num = 7 };
get(10002,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10002,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10002,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10002,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10002,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10002,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 18 ,attrs = [{def,168}],goods_id = 6102008 ,goods_num = 8 };
get(10002,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10002,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10002,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10002,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10002,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10002,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 19 ,attrs = [{def,184}],goods_id = 6102008 ,goods_num = 8 };
get(10002,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10002,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10002,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10002,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10002,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10002,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 20 ,attrs = [{def,200}],goods_id = 6102008 ,goods_num = 8 };
get(10002,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10002,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10002,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10002,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10002,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10002,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 21 ,attrs = [{def,220}],goods_id = 6102008 ,goods_num = 9 };
get(10002,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10002,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10002,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10002,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10002,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10002,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 22 ,attrs = [{def,240}],goods_id = 6102008 ,goods_num = 9 };
get(10002,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10002,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10002,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10002,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10002,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10002,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 23 ,attrs = [{def,260}],goods_id = 6102008 ,goods_num = 10 };
get(10002,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10002,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10002,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10002,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10002,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10002,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 24 ,attrs = [{def,280}],goods_id = 6102008 ,goods_num = 10 };
get(10002,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10002,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10002,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10002,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10002,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10002,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 25 ,attrs = [{def,300}],goods_id = 6102008 ,goods_num = 10 };
get(10002,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10002,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10002,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10002,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10002,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10002,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 26 ,attrs = [{def,324}],goods_id = 6102008 ,goods_num = 11 };
get(10002,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10002,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10002,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10002,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10002,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10002,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 27 ,attrs = [{def,348}],goods_id = 6102008 ,goods_num = 11 };
get(10002,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10002,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10002,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10002,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10002,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10002,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 28 ,attrs = [{def,372}],goods_id = 6102008 ,goods_num = 12 };
get(10002,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10002,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10002,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10002,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10002,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10002,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 29 ,attrs = [{def,396}],goods_id = 6102008 ,goods_num = 12 };
get(10002,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10002,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10002,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10002,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10002,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10002,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 30 ,attrs = [{def,420}],goods_id = 6102008 ,goods_num = 12 };
get(10002,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10002,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10002,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10002,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10002,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10002,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 31 ,attrs = [{def,448}],goods_id = 6102008 ,goods_num = 13 };
get(10002,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10002,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10002,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10002,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10002,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10002,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 32 ,attrs = [{def,476}],goods_id = 6102008 ,goods_num = 13 };
get(10002,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10002,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10002,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10002,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10002,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10002,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 33 ,attrs = [{def,504}],goods_id = 6102008 ,goods_num = 14 };
get(10002,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10002,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10002,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10002,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10002,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10002,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 34 ,attrs = [{def,532}],goods_id = 6102008 ,goods_num = 14 };
get(10002,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10002,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10002,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10002,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10002,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10002,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 35 ,attrs = [{def,560}],goods_id = 6102008 ,goods_num = 14 };
get(10002,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10002,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10002,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10002,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10002,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10002,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 36 ,attrs = [{def,592}],goods_id = 6102008 ,goods_num = 15 };
get(10002,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10002,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10002,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10002,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10002,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10002,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 37 ,attrs = [{def,624}],goods_id = 6102008 ,goods_num = 15 };
get(10002,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10002,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10002,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10002,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10002,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10002,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 38 ,attrs = [{def,656}],goods_id = 6102008 ,goods_num = 16 };
get(10002,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10002,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10002,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10002,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10002,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10002,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 39 ,attrs = [{def,688}],goods_id = 6102008 ,goods_num = 16 };
get(10002,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10002,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10002,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10002,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10002,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10002,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 40 ,attrs = [{def,720}],goods_id = 6102008 ,goods_num = 16 };
get(10002,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10002,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10002,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10002,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10002,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10002,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 41 ,attrs = [{def,756}],goods_id = 6102008 ,goods_num = 17 };
get(10002,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10002,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10002,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10002,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10002,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10002,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 42 ,attrs = [{def,792}],goods_id = 6102008 ,goods_num = 17 };
get(10002,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10002,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10002,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10002,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10002,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10002,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 43 ,attrs = [{def,828}],goods_id = 6102008 ,goods_num = 18 };
get(10002,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10002,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10002,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10002,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10002,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10002,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 44 ,attrs = [{def,864}],goods_id = 6102008 ,goods_num = 18 };
get(10002,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10002,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10002,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10002,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10002,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10002,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 45 ,attrs = [{def,900}],goods_id = 6102008 ,goods_num = 18 };
get(10002,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10002,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10002,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10002,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10002,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10002,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 46 ,attrs = [{def,940}],goods_id = 6102008 ,goods_num = 19 };
get(10002,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10002,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10002,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10002,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10002,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10002,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 47 ,attrs = [{def,980}],goods_id = 6102008 ,goods_num = 19 };
get(10002,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10002,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10002,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10002,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10002,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10002,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6102008 ,goods_num = 20 };
get(10002,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10002,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10002,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10002,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10002,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10002,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6102008 ,goods_num = 20 };
get(10002,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 1 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10002,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 2 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10002,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 3 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10002,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 4 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10002,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 5 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10002,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10002 ,type = 6 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6102008 ,goods_num = 20 };
get(10003,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10003,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10003,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10003,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10003,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10003,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6102001 ,goods_num = 1 };
get(10003,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10003,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10003,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10003,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10003,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10003,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6102001 ,goods_num = 1 };
get(10003,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10003,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10003,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10003,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10003,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10003,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6102001 ,goods_num = 2 };
get(10003,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10003,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10003,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10003,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10003,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10003,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6102001 ,goods_num = 2 };
get(10003,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10003,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10003,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10003,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10003,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10003,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6102001 ,goods_num = 2 };
get(10003,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10003,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10003,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10003,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10003,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10003,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6102001 ,goods_num = 3 };
get(10003,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10003,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10003,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10003,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10003,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10003,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6102001 ,goods_num = 3 };
get(10003,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10003,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10003,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10003,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10003,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10003,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6102001 ,goods_num = 4 };
get(10003,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10003,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10003,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10003,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10003,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10003,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6102001 ,goods_num = 4 };
get(10003,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10003,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10003,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10003,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10003,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10003,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6102001 ,goods_num = 4 };
get(10003,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10003,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10003,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10003,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10003,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10003,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6102001 ,goods_num = 5 };
get(10003,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10003,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10003,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10003,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10003,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10003,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6102001 ,goods_num = 5 };
get(10003,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10003,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10003,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10003,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10003,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10003,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6102001 ,goods_num = 6 };
get(10003,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10003,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10003,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10003,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10003,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10003,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6102001 ,goods_num = 6 };
get(10003,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10003,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10003,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10003,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10003,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10003,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6102001 ,goods_num = 6 };
get(10003,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10003,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10003,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10003,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10003,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10003,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6102001 ,goods_num = 7 };
get(10003,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10003,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10003,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10003,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10003,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10003,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6102001 ,goods_num = 7 };
get(10003,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10003,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10003,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10003,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10003,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10003,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6102001 ,goods_num = 8 };
get(10003,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10003,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10003,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10003,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10003,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10003,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6102001 ,goods_num = 8 };
get(10003,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10003,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10003,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10003,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10003,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10003,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6102001 ,goods_num = 8 };
get(10003,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10003,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10003,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10003,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10003,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10003,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6102001 ,goods_num = 9 };
get(10003,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10003,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10003,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10003,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10003,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10003,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6102001 ,goods_num = 9 };
get(10003,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10003,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10003,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10003,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10003,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10003,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6102001 ,goods_num = 10 };
get(10003,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10003,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10003,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10003,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10003,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10003,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6102001 ,goods_num = 10 };
get(10003,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10003,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10003,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10003,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10003,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10003,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6102001 ,goods_num = 10 };
get(10003,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10003,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10003,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10003,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10003,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10003,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6102001 ,goods_num = 11 };
get(10003,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10003,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10003,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10003,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10003,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10003,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6102001 ,goods_num = 11 };
get(10003,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10003,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10003,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10003,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10003,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10003,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6102001 ,goods_num = 12 };
get(10003,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10003,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10003,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10003,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10003,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10003,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6102001 ,goods_num = 12 };
get(10003,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10003,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10003,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10003,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10003,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10003,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6102001 ,goods_num = 12 };
get(10003,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10003,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10003,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10003,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10003,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10003,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6102001 ,goods_num = 13 };
get(10003,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10003,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10003,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10003,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10003,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10003,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6102001 ,goods_num = 13 };
get(10003,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10003,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10003,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10003,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10003,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10003,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6102001 ,goods_num = 14 };
get(10003,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10003,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10003,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10003,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10003,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10003,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6102001 ,goods_num = 14 };
get(10003,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10003,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10003,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10003,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10003,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10003,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6102001 ,goods_num = 14 };
get(10003,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10003,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10003,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10003,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10003,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10003,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6102001 ,goods_num = 15 };
get(10003,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10003,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10003,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10003,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10003,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10003,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6102001 ,goods_num = 15 };
get(10003,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10003,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10003,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10003,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10003,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10003,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6102001 ,goods_num = 16 };
get(10003,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10003,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10003,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10003,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10003,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10003,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6102001 ,goods_num = 16 };
get(10003,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10003,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10003,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10003,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10003,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10003,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6102001 ,goods_num = 16 };
get(10003,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10003,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10003,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10003,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10003,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10003,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6102001 ,goods_num = 17 };
get(10003,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10003,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10003,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10003,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10003,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10003,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6102001 ,goods_num = 17 };
get(10003,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10003,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10003,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10003,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10003,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10003,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6102001 ,goods_num = 18 };
get(10003,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10003,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10003,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10003,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10003,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10003,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6102001 ,goods_num = 18 };
get(10003,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10003,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10003,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10003,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10003,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10003,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6102001 ,goods_num = 18 };
get(10003,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10003,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10003,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10003,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10003,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10003,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6102001 ,goods_num = 19 };
get(10003,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10003,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10003,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10003,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10003,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10003,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6102001 ,goods_num = 19 };
get(10003,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10003,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10003,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10003,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10003,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10003,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6102001 ,goods_num = 20 };
get(10003,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10003,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10003,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10003,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10003,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10003,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6102001 ,goods_num = 20 };
get(10003,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 1 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10003,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 2 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10003,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 3 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10003,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 4 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10003,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 5 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10003,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10003 ,type = 6 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6102001 ,goods_num = 20 };
get(10004,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10004,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10004,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10004,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10004,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10004,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6102002 ,goods_num = 1 };
get(10004,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10004,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10004,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10004,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10004,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10004,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6102002 ,goods_num = 1 };
get(10004,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10004,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10004,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10004,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10004,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10004,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6102002 ,goods_num = 2 };
get(10004,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10004,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10004,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10004,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10004,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10004,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6102002 ,goods_num = 2 };
get(10004,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10004,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10004,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10004,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10004,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10004,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6102002 ,goods_num = 2 };
get(10004,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10004,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10004,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10004,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10004,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10004,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6102002 ,goods_num = 3 };
get(10004,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10004,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10004,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10004,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10004,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10004,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6102002 ,goods_num = 3 };
get(10004,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10004,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10004,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10004,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10004,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10004,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6102002 ,goods_num = 4 };
get(10004,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10004,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10004,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10004,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10004,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10004,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6102002 ,goods_num = 4 };
get(10004,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10004,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10004,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10004,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10004,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10004,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6102002 ,goods_num = 4 };
get(10004,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10004,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10004,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10004,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10004,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10004,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6102002 ,goods_num = 5 };
get(10004,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10004,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10004,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10004,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10004,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10004,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6102002 ,goods_num = 5 };
get(10004,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10004,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10004,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10004,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10004,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10004,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6102002 ,goods_num = 6 };
get(10004,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10004,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10004,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10004,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10004,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10004,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6102002 ,goods_num = 6 };
get(10004,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10004,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10004,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10004,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10004,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10004,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6102002 ,goods_num = 6 };
get(10004,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10004,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10004,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10004,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10004,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10004,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6102002 ,goods_num = 7 };
get(10004,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10004,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10004,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10004,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10004,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10004,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6102002 ,goods_num = 7 };
get(10004,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10004,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10004,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10004,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10004,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10004,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6102002 ,goods_num = 8 };
get(10004,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10004,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10004,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10004,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10004,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10004,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6102002 ,goods_num = 8 };
get(10004,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10004,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10004,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10004,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10004,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10004,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6102002 ,goods_num = 8 };
get(10004,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10004,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10004,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10004,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10004,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10004,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6102002 ,goods_num = 9 };
get(10004,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10004,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10004,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10004,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10004,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10004,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6102002 ,goods_num = 9 };
get(10004,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10004,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10004,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10004,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10004,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10004,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6102002 ,goods_num = 10 };
get(10004,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10004,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10004,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10004,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10004,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10004,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6102002 ,goods_num = 10 };
get(10004,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10004,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10004,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10004,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10004,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10004,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6102002 ,goods_num = 10 };
get(10004,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10004,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10004,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10004,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10004,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10004,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6102002 ,goods_num = 11 };
get(10004,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10004,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10004,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10004,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10004,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10004,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6102002 ,goods_num = 11 };
get(10004,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10004,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10004,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10004,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10004,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10004,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6102002 ,goods_num = 12 };
get(10004,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10004,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10004,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10004,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10004,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10004,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6102002 ,goods_num = 12 };
get(10004,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10004,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10004,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10004,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10004,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10004,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6102002 ,goods_num = 12 };
get(10004,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10004,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10004,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10004,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10004,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10004,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6102002 ,goods_num = 13 };
get(10004,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10004,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10004,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10004,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10004,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10004,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6102002 ,goods_num = 13 };
get(10004,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10004,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10004,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10004,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10004,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10004,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6102002 ,goods_num = 14 };
get(10004,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10004,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10004,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10004,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10004,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10004,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6102002 ,goods_num = 14 };
get(10004,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10004,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10004,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10004,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10004,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10004,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6102002 ,goods_num = 14 };
get(10004,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10004,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10004,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10004,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10004,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10004,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6102002 ,goods_num = 15 };
get(10004,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10004,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10004,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10004,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10004,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10004,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6102002 ,goods_num = 15 };
get(10004,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10004,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10004,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10004,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10004,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10004,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6102002 ,goods_num = 16 };
get(10004,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10004,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10004,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10004,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10004,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10004,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6102002 ,goods_num = 16 };
get(10004,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10004,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10004,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10004,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10004,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10004,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6102002 ,goods_num = 16 };
get(10004,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10004,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10004,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10004,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10004,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10004,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6102002 ,goods_num = 17 };
get(10004,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10004,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10004,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10004,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10004,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10004,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6102002 ,goods_num = 17 };
get(10004,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10004,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10004,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10004,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10004,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10004,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6102002 ,goods_num = 18 };
get(10004,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10004,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10004,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10004,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10004,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10004,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6102002 ,goods_num = 18 };
get(10004,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10004,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10004,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10004,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10004,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10004,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6102002 ,goods_num = 18 };
get(10004,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10004,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10004,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10004,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10004,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10004,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6102002 ,goods_num = 19 };
get(10004,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10004,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10004,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10004,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10004,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10004,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6102002 ,goods_num = 19 };
get(10004,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10004,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10004,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10004,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10004,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10004,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6102002 ,goods_num = 20 };
get(10004,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10004,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10004,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10004,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10004,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10004,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6102002 ,goods_num = 20 };
get(10004,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 1 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10004,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 2 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10004,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 3 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10004,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 4 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10004,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 5 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10004,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10004 ,type = 6 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6102002 ,goods_num = 20 };
get(10005,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10005,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10005,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10005,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10005,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10005,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6102004 ,goods_num = 1 };
get(10005,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10005,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10005,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10005,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10005,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10005,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6102004 ,goods_num = 1 };
get(10005,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10005,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10005,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10005,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10005,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10005,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6102004 ,goods_num = 2 };
get(10005,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10005,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10005,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10005,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10005,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10005,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6102004 ,goods_num = 2 };
get(10005,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10005,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10005,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10005,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10005,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10005,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6102004 ,goods_num = 2 };
get(10005,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10005,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10005,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10005,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10005,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10005,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6102004 ,goods_num = 3 };
get(10005,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10005,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10005,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10005,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10005,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10005,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6102004 ,goods_num = 3 };
get(10005,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10005,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10005,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10005,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10005,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10005,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6102004 ,goods_num = 4 };
get(10005,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10005,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10005,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10005,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10005,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10005,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6102004 ,goods_num = 4 };
get(10005,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10005,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10005,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10005,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10005,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10005,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6102004 ,goods_num = 4 };
get(10005,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10005,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10005,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10005,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10005,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10005,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6102004 ,goods_num = 5 };
get(10005,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10005,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10005,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10005,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10005,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10005,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6102004 ,goods_num = 5 };
get(10005,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10005,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10005,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10005,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10005,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10005,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6102004 ,goods_num = 6 };
get(10005,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10005,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10005,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10005,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10005,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10005,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6102004 ,goods_num = 6 };
get(10005,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10005,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10005,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10005,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10005,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10005,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6102004 ,goods_num = 6 };
get(10005,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10005,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10005,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10005,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10005,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10005,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6102004 ,goods_num = 7 };
get(10005,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10005,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10005,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10005,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10005,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10005,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6102004 ,goods_num = 7 };
get(10005,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10005,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10005,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10005,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10005,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10005,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6102004 ,goods_num = 8 };
get(10005,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10005,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10005,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10005,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10005,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10005,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6102004 ,goods_num = 8 };
get(10005,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10005,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10005,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10005,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10005,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10005,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6102004 ,goods_num = 8 };
get(10005,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10005,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10005,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10005,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10005,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10005,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6102004 ,goods_num = 9 };
get(10005,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10005,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10005,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10005,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10005,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10005,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6102004 ,goods_num = 9 };
get(10005,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10005,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10005,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10005,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10005,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10005,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6102004 ,goods_num = 10 };
get(10005,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10005,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10005,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10005,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10005,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10005,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6102004 ,goods_num = 10 };
get(10005,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10005,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10005,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10005,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10005,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10005,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6102004 ,goods_num = 10 };
get(10005,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10005,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10005,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10005,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10005,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10005,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6102004 ,goods_num = 11 };
get(10005,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10005,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10005,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10005,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10005,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10005,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6102004 ,goods_num = 11 };
get(10005,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10005,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10005,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10005,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10005,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10005,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6102004 ,goods_num = 12 };
get(10005,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10005,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10005,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10005,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10005,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10005,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6102004 ,goods_num = 12 };
get(10005,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10005,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10005,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10005,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10005,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10005,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6102004 ,goods_num = 12 };
get(10005,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10005,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10005,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10005,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10005,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10005,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6102004 ,goods_num = 13 };
get(10005,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10005,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10005,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10005,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10005,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10005,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6102004 ,goods_num = 13 };
get(10005,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10005,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10005,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10005,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10005,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10005,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6102004 ,goods_num = 14 };
get(10005,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10005,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10005,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10005,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10005,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10005,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6102004 ,goods_num = 14 };
get(10005,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10005,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10005,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10005,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10005,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10005,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6102004 ,goods_num = 14 };
get(10005,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10005,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10005,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10005,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10005,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10005,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6102004 ,goods_num = 15 };
get(10005,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10005,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10005,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10005,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10005,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10005,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6102004 ,goods_num = 15 };
get(10005,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10005,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10005,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10005,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10005,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10005,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6102004 ,goods_num = 16 };
get(10005,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10005,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10005,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10005,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10005,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10005,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6102004 ,goods_num = 16 };
get(10005,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10005,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10005,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10005,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10005,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10005,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6102004 ,goods_num = 16 };
get(10005,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10005,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10005,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10005,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10005,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10005,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6102004 ,goods_num = 17 };
get(10005,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10005,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10005,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10005,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10005,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10005,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6102004 ,goods_num = 17 };
get(10005,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10005,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10005,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10005,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10005,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10005,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6102004 ,goods_num = 18 };
get(10005,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10005,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10005,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10005,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10005,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10005,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6102004 ,goods_num = 18 };
get(10005,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10005,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10005,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10005,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10005,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10005,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6102004 ,goods_num = 18 };
get(10005,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10005,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10005,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10005,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10005,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10005,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6102004 ,goods_num = 19 };
get(10005,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10005,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10005,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10005,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10005,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10005,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6102004 ,goods_num = 19 };
get(10005,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10005,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10005,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10005,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10005,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10005,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6102004 ,goods_num = 20 };
get(10005,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10005,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10005,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10005,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10005,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10005,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6102004 ,goods_num = 20 };
get(10005,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 1 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10005,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 2 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10005,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 3 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10005,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 4 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10005,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 5 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10005,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10005 ,type = 6 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6102004 ,goods_num = 20 };
get(10006,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10006,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10006,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10006,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10006,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10006,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6102005 ,goods_num = 1 };
get(10006,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10006,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10006,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10006,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10006,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10006,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6102005 ,goods_num = 1 };
get(10006,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10006,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10006,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10006,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10006,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10006,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6102005 ,goods_num = 2 };
get(10006,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10006,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10006,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10006,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10006,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10006,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6102005 ,goods_num = 2 };
get(10006,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10006,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10006,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10006,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10006,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10006,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6102005 ,goods_num = 2 };
get(10006,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10006,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10006,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10006,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10006,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10006,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6102005 ,goods_num = 3 };
get(10006,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10006,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10006,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10006,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10006,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10006,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6102005 ,goods_num = 3 };
get(10006,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10006,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10006,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10006,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10006,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10006,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6102005 ,goods_num = 4 };
get(10006,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10006,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10006,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10006,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10006,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10006,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6102005 ,goods_num = 4 };
get(10006,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10006,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10006,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10006,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10006,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10006,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6102005 ,goods_num = 4 };
get(10006,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10006,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10006,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10006,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10006,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10006,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6102005 ,goods_num = 5 };
get(10006,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10006,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10006,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10006,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10006,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10006,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6102005 ,goods_num = 5 };
get(10006,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10006,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10006,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10006,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10006,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10006,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6102005 ,goods_num = 6 };
get(10006,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10006,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10006,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10006,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10006,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10006,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6102005 ,goods_num = 6 };
get(10006,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10006,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10006,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10006,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10006,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10006,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6102005 ,goods_num = 6 };
get(10006,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10006,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10006,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10006,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10006,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10006,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6102005 ,goods_num = 7 };
get(10006,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10006,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10006,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10006,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10006,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10006,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6102005 ,goods_num = 7 };
get(10006,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10006,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10006,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10006,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10006,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10006,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6102005 ,goods_num = 8 };
get(10006,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10006,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10006,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10006,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10006,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10006,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6102005 ,goods_num = 8 };
get(10006,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10006,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10006,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10006,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10006,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10006,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6102005 ,goods_num = 8 };
get(10006,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10006,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10006,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10006,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10006,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10006,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6102005 ,goods_num = 9 };
get(10006,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10006,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10006,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10006,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10006,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10006,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6102005 ,goods_num = 9 };
get(10006,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10006,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10006,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10006,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10006,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10006,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6102005 ,goods_num = 10 };
get(10006,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10006,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10006,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10006,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10006,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10006,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6102005 ,goods_num = 10 };
get(10006,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10006,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10006,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10006,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10006,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10006,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6102005 ,goods_num = 10 };
get(10006,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10006,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10006,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10006,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10006,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10006,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6102005 ,goods_num = 11 };
get(10006,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10006,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10006,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10006,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10006,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10006,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6102005 ,goods_num = 11 };
get(10006,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10006,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10006,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10006,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10006,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10006,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6102005 ,goods_num = 12 };
get(10006,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10006,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10006,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10006,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10006,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10006,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6102005 ,goods_num = 12 };
get(10006,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10006,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10006,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10006,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10006,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10006,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6102005 ,goods_num = 12 };
get(10006,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10006,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10006,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10006,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10006,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10006,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6102005 ,goods_num = 13 };
get(10006,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10006,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10006,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10006,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10006,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10006,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6102005 ,goods_num = 13 };
get(10006,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10006,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10006,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10006,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10006,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10006,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6102005 ,goods_num = 14 };
get(10006,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10006,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10006,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10006,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10006,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10006,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6102005 ,goods_num = 14 };
get(10006,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10006,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10006,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10006,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10006,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10006,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6102005 ,goods_num = 14 };
get(10006,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10006,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10006,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10006,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10006,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10006,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6102005 ,goods_num = 15 };
get(10006,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10006,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10006,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10006,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10006,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10006,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6102005 ,goods_num = 15 };
get(10006,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10006,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10006,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10006,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10006,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10006,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6102005 ,goods_num = 16 };
get(10006,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10006,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10006,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10006,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10006,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10006,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6102005 ,goods_num = 16 };
get(10006,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10006,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10006,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10006,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10006,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10006,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6102005 ,goods_num = 16 };
get(10006,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10006,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10006,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10006,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10006,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10006,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6102005 ,goods_num = 17 };
get(10006,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10006,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10006,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10006,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10006,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10006,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6102005 ,goods_num = 17 };
get(10006,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10006,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10006,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10006,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10006,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10006,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6102005 ,goods_num = 18 };
get(10006,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10006,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10006,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10006,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10006,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10006,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6102005 ,goods_num = 18 };
get(10006,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10006,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10006,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10006,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10006,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10006,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6102005 ,goods_num = 18 };
get(10006,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10006,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10006,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10006,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10006,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10006,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6102005 ,goods_num = 19 };
get(10006,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10006,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10006,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10006,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10006,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10006,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6102005 ,goods_num = 19 };
get(10006,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10006,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10006,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10006,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10006,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10006,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6102005 ,goods_num = 20 };
get(10006,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10006,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10006,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10006,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10006,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10006,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6102005 ,goods_num = 20 };
get(10006,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 1 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10006,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 2 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10006,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 3 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10006,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 4 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10006,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 5 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10006,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10006 ,type = 6 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6102005 ,goods_num = 20 };
get(10007,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10007,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10007,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10007,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10007,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10007,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6102006 ,goods_num = 1 };
get(10007,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10007,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10007,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10007,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10007,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10007,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6102006 ,goods_num = 1 };
get(10007,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10007,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10007,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10007,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10007,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10007,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6102006 ,goods_num = 2 };
get(10007,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10007,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10007,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10007,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10007,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10007,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6102006 ,goods_num = 2 };
get(10007,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10007,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10007,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10007,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10007,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10007,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6102006 ,goods_num = 2 };
get(10007,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10007,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10007,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10007,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10007,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10007,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6102006 ,goods_num = 3 };
get(10007,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10007,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10007,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10007,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10007,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10007,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6102006 ,goods_num = 3 };
get(10007,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10007,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10007,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10007,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10007,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10007,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6102006 ,goods_num = 4 };
get(10007,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10007,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10007,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10007,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10007,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10007,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6102006 ,goods_num = 4 };
get(10007,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10007,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10007,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10007,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10007,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10007,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6102006 ,goods_num = 4 };
get(10007,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10007,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10007,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10007,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10007,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10007,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6102006 ,goods_num = 5 };
get(10007,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10007,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10007,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10007,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10007,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10007,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6102006 ,goods_num = 5 };
get(10007,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10007,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10007,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10007,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10007,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10007,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6102006 ,goods_num = 6 };
get(10007,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10007,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10007,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10007,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10007,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10007,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6102006 ,goods_num = 6 };
get(10007,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10007,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10007,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10007,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10007,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10007,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6102006 ,goods_num = 6 };
get(10007,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10007,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10007,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10007,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10007,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10007,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6102006 ,goods_num = 7 };
get(10007,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10007,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10007,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10007,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10007,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10007,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6102006 ,goods_num = 7 };
get(10007,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10007,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10007,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10007,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10007,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10007,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6102006 ,goods_num = 8 };
get(10007,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10007,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10007,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10007,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10007,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10007,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6102006 ,goods_num = 8 };
get(10007,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10007,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10007,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10007,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10007,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10007,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6102006 ,goods_num = 8 };
get(10007,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10007,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10007,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10007,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10007,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10007,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6102006 ,goods_num = 9 };
get(10007,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10007,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10007,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10007,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10007,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10007,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6102006 ,goods_num = 9 };
get(10007,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10007,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10007,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10007,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10007,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10007,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6102006 ,goods_num = 10 };
get(10007,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10007,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10007,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10007,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10007,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10007,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6102006 ,goods_num = 10 };
get(10007,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10007,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10007,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10007,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10007,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10007,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6102006 ,goods_num = 10 };
get(10007,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10007,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10007,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10007,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10007,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10007,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6102006 ,goods_num = 11 };
get(10007,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10007,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10007,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10007,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10007,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10007,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6102006 ,goods_num = 11 };
get(10007,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10007,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10007,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10007,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10007,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10007,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6102006 ,goods_num = 12 };
get(10007,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10007,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10007,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10007,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10007,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10007,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6102006 ,goods_num = 12 };
get(10007,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10007,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10007,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10007,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10007,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10007,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6102006 ,goods_num = 12 };
get(10007,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10007,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10007,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10007,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10007,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10007,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6102006 ,goods_num = 13 };
get(10007,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10007,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10007,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10007,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10007,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10007,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6102006 ,goods_num = 13 };
get(10007,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10007,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10007,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10007,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10007,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10007,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6102006 ,goods_num = 14 };
get(10007,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10007,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10007,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10007,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10007,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10007,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6102006 ,goods_num = 14 };
get(10007,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10007,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10007,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10007,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10007,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10007,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6102006 ,goods_num = 14 };
get(10007,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10007,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10007,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10007,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10007,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10007,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6102006 ,goods_num = 15 };
get(10007,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10007,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10007,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10007,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10007,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10007,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6102006 ,goods_num = 15 };
get(10007,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10007,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10007,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10007,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10007,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10007,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6102006 ,goods_num = 16 };
get(10007,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10007,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10007,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10007,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10007,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10007,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6102006 ,goods_num = 16 };
get(10007,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10007,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10007,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10007,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10007,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10007,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6102006 ,goods_num = 16 };
get(10007,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10007,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10007,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10007,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10007,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10007,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6102006 ,goods_num = 17 };
get(10007,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10007,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10007,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10007,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10007,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10007,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6102006 ,goods_num = 17 };
get(10007,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10007,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10007,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10007,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10007,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10007,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6102006 ,goods_num = 18 };
get(10007,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10007,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10007,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10007,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10007,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10007,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6102006 ,goods_num = 18 };
get(10007,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10007,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10007,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10007,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10007,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10007,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6102006 ,goods_num = 18 };
get(10007,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10007,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10007,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10007,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10007,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10007,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6102006 ,goods_num = 19 };
get(10007,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10007,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10007,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10007,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10007,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10007,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6102006 ,goods_num = 19 };
get(10007,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10007,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10007,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10007,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10007,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10007,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6102006 ,goods_num = 20 };
get(10007,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10007,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10007,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10007,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10007,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10007,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6102006 ,goods_num = 20 };
get(10007,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 1 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10007,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 2 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10007,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 3 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10007,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 4 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10007,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 5 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10007,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10007 ,type = 6 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6102006 ,goods_num = 20 };
get(10008,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10008,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10008,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10008,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10008,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10008,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 1 ,attrs = [{att,8}],goods_id = 6102007 ,goods_num = 1 };
get(10008,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10008,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10008,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10008,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10008,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10008,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 2 ,attrs = [{att,16}],goods_id = 6102007 ,goods_num = 1 };
get(10008,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10008,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10008,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10008,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10008,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10008,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 3 ,attrs = [{att,24}],goods_id = 6102007 ,goods_num = 2 };
get(10008,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10008,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10008,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10008,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10008,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10008,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 4 ,attrs = [{att,32}],goods_id = 6102007 ,goods_num = 2 };
get(10008,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10008,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10008,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10008,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10008,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10008,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 5 ,attrs = [{att,40}],goods_id = 6102007 ,goods_num = 2 };
get(10008,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10008,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10008,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10008,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10008,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10008,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 6 ,attrs = [{att,56}],goods_id = 6102007 ,goods_num = 3 };
get(10008,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10008,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10008,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10008,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10008,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10008,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 7 ,attrs = [{att,72}],goods_id = 6102007 ,goods_num = 3 };
get(10008,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10008,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10008,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10008,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10008,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10008,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 8 ,attrs = [{att,88}],goods_id = 6102007 ,goods_num = 4 };
get(10008,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10008,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10008,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10008,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10008,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10008,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 9 ,attrs = [{att,104}],goods_id = 6102007 ,goods_num = 4 };
get(10008,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10008,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10008,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10008,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10008,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10008,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 10 ,attrs = [{att,120}],goods_id = 6102007 ,goods_num = 4 };
get(10008,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10008,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10008,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10008,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10008,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10008,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 11 ,attrs = [{att,144}],goods_id = 6102007 ,goods_num = 5 };
get(10008,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10008,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10008,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10008,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10008,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10008,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 12 ,attrs = [{att,168}],goods_id = 6102007 ,goods_num = 5 };
get(10008,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10008,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10008,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10008,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10008,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10008,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 13 ,attrs = [{att,192}],goods_id = 6102007 ,goods_num = 6 };
get(10008,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10008,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10008,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10008,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10008,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10008,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 14 ,attrs = [{att,216}],goods_id = 6102007 ,goods_num = 6 };
get(10008,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10008,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10008,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10008,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10008,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10008,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 15 ,attrs = [{att,240}],goods_id = 6102007 ,goods_num = 6 };
get(10008,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10008,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10008,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10008,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10008,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10008,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 16 ,attrs = [{att,272}],goods_id = 6102007 ,goods_num = 7 };
get(10008,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10008,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10008,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10008,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10008,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10008,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 17 ,attrs = [{att,304}],goods_id = 6102007 ,goods_num = 7 };
get(10008,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10008,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10008,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10008,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10008,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10008,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 18 ,attrs = [{att,336}],goods_id = 6102007 ,goods_num = 8 };
get(10008,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10008,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10008,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10008,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10008,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10008,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 19 ,attrs = [{att,368}],goods_id = 6102007 ,goods_num = 8 };
get(10008,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10008,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10008,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10008,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10008,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10008,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 20 ,attrs = [{att,400}],goods_id = 6102007 ,goods_num = 8 };
get(10008,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10008,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10008,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10008,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10008,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10008,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 21 ,attrs = [{att,440}],goods_id = 6102007 ,goods_num = 9 };
get(10008,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10008,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10008,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10008,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10008,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10008,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 22 ,attrs = [{att,480}],goods_id = 6102007 ,goods_num = 9 };
get(10008,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10008,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10008,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10008,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10008,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10008,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 23 ,attrs = [{att,520}],goods_id = 6102007 ,goods_num = 10 };
get(10008,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10008,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10008,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10008,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10008,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10008,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 24 ,attrs = [{att,560}],goods_id = 6102007 ,goods_num = 10 };
get(10008,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10008,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10008,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10008,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10008,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10008,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 25 ,attrs = [{att,600}],goods_id = 6102007 ,goods_num = 10 };
get(10008,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10008,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10008,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10008,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10008,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10008,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 26 ,attrs = [{att,648}],goods_id = 6102007 ,goods_num = 11 };
get(10008,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10008,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10008,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10008,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10008,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10008,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 27 ,attrs = [{att,696}],goods_id = 6102007 ,goods_num = 11 };
get(10008,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10008,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10008,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10008,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10008,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10008,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 28 ,attrs = [{att,744}],goods_id = 6102007 ,goods_num = 12 };
get(10008,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10008,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10008,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10008,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10008,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10008,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 29 ,attrs = [{att,792}],goods_id = 6102007 ,goods_num = 12 };
get(10008,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10008,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10008,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10008,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10008,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10008,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 30 ,attrs = [{att,840}],goods_id = 6102007 ,goods_num = 12 };
get(10008,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10008,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10008,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10008,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10008,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10008,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 31 ,attrs = [{att,896}],goods_id = 6102007 ,goods_num = 13 };
get(10008,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10008,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10008,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10008,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10008,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10008,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 32 ,attrs = [{att,952}],goods_id = 6102007 ,goods_num = 13 };
get(10008,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10008,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10008,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10008,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10008,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10008,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6102007 ,goods_num = 14 };
get(10008,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10008,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10008,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10008,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10008,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10008,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6102007 ,goods_num = 14 };
get(10008,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10008,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10008,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10008,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10008,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10008,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6102007 ,goods_num = 14 };
get(10008,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10008,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10008,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10008,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10008,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10008,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6102007 ,goods_num = 15 };
get(10008,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10008,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10008,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10008,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10008,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10008,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6102007 ,goods_num = 15 };
get(10008,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10008,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10008,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10008,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10008,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10008,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6102007 ,goods_num = 16 };
get(10008,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10008,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10008,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10008,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10008,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10008,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6102007 ,goods_num = 16 };
get(10008,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10008,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10008,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10008,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10008,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10008,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6102007 ,goods_num = 16 };
get(10008,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10008,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10008,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10008,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10008,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10008,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6102007 ,goods_num = 17 };
get(10008,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10008,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10008,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10008,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10008,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10008,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6102007 ,goods_num = 17 };
get(10008,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10008,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10008,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10008,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10008,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10008,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6102007 ,goods_num = 18 };
get(10008,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10008,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10008,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10008,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10008,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10008,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6102007 ,goods_num = 18 };
get(10008,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10008,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10008,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10008,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10008,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10008,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6102007 ,goods_num = 18 };
get(10008,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10008,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10008,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10008,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10008,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10008,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6102007 ,goods_num = 19 };
get(10008,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10008,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10008,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10008,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10008,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10008,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6102007 ,goods_num = 19 };
get(10008,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10008,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10008,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10008,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10008,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10008,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6102007 ,goods_num = 20 };
get(10008,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10008,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10008,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10008,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10008,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10008,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6102007 ,goods_num = 20 };
get(10008,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 1 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10008,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 2 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10008,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 3 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10008,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 4 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10008,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 5 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10008,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10008 ,type = 6 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6102007 ,goods_num = 20 };
get(10009,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10009,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10009,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 1 ,attrs = [{ten,2}],goods_id = 6101000 ,goods_num = 20 };
get(10009,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 1 ,attrs = [{hit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10009,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10009,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 1 ,attrs = [{def,4}],goods_id = 6102009 ,goods_num = 1 };
get(10009,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10009,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10009,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 2 ,attrs = [{ten,4}],goods_id = 6101000 ,goods_num = 20 };
get(10009,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 2 ,attrs = [{hit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10009,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10009,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 2 ,attrs = [{def,8}],goods_id = 6102009 ,goods_num = 1 };
get(10009,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10009,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10009,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 3 ,attrs = [{ten,6}],goods_id = 6101000 ,goods_num = 20 };
get(10009,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 3 ,attrs = [{hit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10009,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10009,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 3 ,attrs = [{def,12}],goods_id = 6102009 ,goods_num = 2 };
get(10009,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10009,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10009,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 4 ,attrs = [{ten,8}],goods_id = 6101000 ,goods_num = 20 };
get(10009,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 4 ,attrs = [{hit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10009,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10009,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 4 ,attrs = [{def,16}],goods_id = 6102009 ,goods_num = 2 };
get(10009,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10009,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10009,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 5 ,attrs = [{ten,10}],goods_id = 6101000 ,goods_num = 20 };
get(10009,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 5 ,attrs = [{hit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10009,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10009,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 5 ,attrs = [{def,20}],goods_id = 6102009 ,goods_num = 2 };
get(10009,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10009,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10009,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 6 ,attrs = [{ten,13}],goods_id = 6101000 ,goods_num = 40 };
get(10009,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 6 ,attrs = [{hit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10009,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10009,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 6 ,attrs = [{def,28}],goods_id = 6102009 ,goods_num = 3 };
get(10009,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10009,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10009,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 7 ,attrs = [{ten,16}],goods_id = 6101000 ,goods_num = 40 };
get(10009,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 7 ,attrs = [{hit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10009,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10009,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 7 ,attrs = [{def,36}],goods_id = 6102009 ,goods_num = 3 };
get(10009,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10009,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10009,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 8 ,attrs = [{ten,19}],goods_id = 6101000 ,goods_num = 40 };
get(10009,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 8 ,attrs = [{hit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10009,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10009,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 8 ,attrs = [{def,44}],goods_id = 6102009 ,goods_num = 4 };
get(10009,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10009,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10009,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 9 ,attrs = [{ten,22}],goods_id = 6101000 ,goods_num = 40 };
get(10009,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 9 ,attrs = [{hit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10009,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10009,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 9 ,attrs = [{def,52}],goods_id = 6102009 ,goods_num = 4 };
get(10009,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10009,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10009,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 10 ,attrs = [{ten,25}],goods_id = 6101000 ,goods_num = 40 };
get(10009,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 10 ,attrs = [{hit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10009,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10009,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 10 ,attrs = [{def,60}],goods_id = 6102009 ,goods_num = 4 };
get(10009,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10009,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10009,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 11 ,attrs = [{ten,30}],goods_id = 6101000 ,goods_num = 60 };
get(10009,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 11 ,attrs = [{hit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10009,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10009,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 11 ,attrs = [{def,72}],goods_id = 6102009 ,goods_num = 5 };
get(10009,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10009,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10009,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 12 ,attrs = [{ten,35}],goods_id = 6101000 ,goods_num = 60 };
get(10009,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 12 ,attrs = [{hit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10009,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10009,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 12 ,attrs = [{def,84}],goods_id = 6102009 ,goods_num = 5 };
get(10009,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10009,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10009,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 13 ,attrs = [{ten,40}],goods_id = 6101000 ,goods_num = 60 };
get(10009,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 13 ,attrs = [{hit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10009,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10009,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 13 ,attrs = [{def,96}],goods_id = 6102009 ,goods_num = 6 };
get(10009,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10009,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10009,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 14 ,attrs = [{ten,45}],goods_id = 6101000 ,goods_num = 60 };
get(10009,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 14 ,attrs = [{hit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10009,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10009,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 14 ,attrs = [{def,108}],goods_id = 6102009 ,goods_num = 6 };
get(10009,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10009,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10009,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 15 ,attrs = [{ten,50}],goods_id = 6101000 ,goods_num = 60 };
get(10009,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 15 ,attrs = [{hit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10009,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10009,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 15 ,attrs = [{def,120}],goods_id = 6102009 ,goods_num = 6 };
get(10009,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10009,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10009,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 16 ,attrs = [{ten,56}],goods_id = 6101000 ,goods_num = 80 };
get(10009,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 16 ,attrs = [{hit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10009,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10009,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 16 ,attrs = [{def,136}],goods_id = 6102009 ,goods_num = 7 };
get(10009,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10009,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10009,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 17 ,attrs = [{ten,62}],goods_id = 6101000 ,goods_num = 80 };
get(10009,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 17 ,attrs = [{hit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10009,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10009,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 17 ,attrs = [{def,152}],goods_id = 6102009 ,goods_num = 7 };
get(10009,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10009,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10009,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 18 ,attrs = [{ten,68}],goods_id = 6101000 ,goods_num = 80 };
get(10009,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 18 ,attrs = [{hit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10009,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10009,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 18 ,attrs = [{def,168}],goods_id = 6102009 ,goods_num = 8 };
get(10009,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10009,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10009,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 19 ,attrs = [{ten,74}],goods_id = 6101000 ,goods_num = 80 };
get(10009,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 19 ,attrs = [{hit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10009,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10009,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 19 ,attrs = [{def,184}],goods_id = 6102009 ,goods_num = 8 };
get(10009,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10009,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10009,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 20 ,attrs = [{ten,80}],goods_id = 6101000 ,goods_num = 80 };
get(10009,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 20 ,attrs = [{hit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10009,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10009,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 20 ,attrs = [{def,200}],goods_id = 6102009 ,goods_num = 8 };
get(10009,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10009,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10009,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 21 ,attrs = [{ten,88}],goods_id = 6101000 ,goods_num = 100 };
get(10009,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 21 ,attrs = [{hit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10009,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10009,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 21 ,attrs = [{def,220}],goods_id = 6102009 ,goods_num = 9 };
get(10009,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10009,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10009,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 22 ,attrs = [{ten,96}],goods_id = 6101000 ,goods_num = 100 };
get(10009,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 22 ,attrs = [{hit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10009,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10009,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 22 ,attrs = [{def,240}],goods_id = 6102009 ,goods_num = 9 };
get(10009,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10009,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10009,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 23 ,attrs = [{ten,104}],goods_id = 6101000 ,goods_num = 100 };
get(10009,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 23 ,attrs = [{hit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10009,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10009,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 23 ,attrs = [{def,260}],goods_id = 6102009 ,goods_num = 10 };
get(10009,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10009,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10009,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 24 ,attrs = [{ten,112}],goods_id = 6101000 ,goods_num = 100 };
get(10009,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 24 ,attrs = [{hit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10009,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10009,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 24 ,attrs = [{def,280}],goods_id = 6102009 ,goods_num = 10 };
get(10009,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10009,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10009,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 25 ,attrs = [{ten,120}],goods_id = 6101000 ,goods_num = 100 };
get(10009,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 25 ,attrs = [{hit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10009,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10009,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 25 ,attrs = [{def,300}],goods_id = 6102009 ,goods_num = 10 };
get(10009,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10009,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10009,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 26 ,attrs = [{ten,130}],goods_id = 6101000 ,goods_num = 120 };
get(10009,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 26 ,attrs = [{hit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10009,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10009,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 26 ,attrs = [{def,324}],goods_id = 6102009 ,goods_num = 11 };
get(10009,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10009,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10009,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 27 ,attrs = [{ten,140}],goods_id = 6101000 ,goods_num = 120 };
get(10009,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 27 ,attrs = [{hit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10009,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10009,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 27 ,attrs = [{def,348}],goods_id = 6102009 ,goods_num = 11 };
get(10009,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10009,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10009,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 28 ,attrs = [{ten,150}],goods_id = 6101000 ,goods_num = 120 };
get(10009,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 28 ,attrs = [{hit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10009,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10009,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 28 ,attrs = [{def,372}],goods_id = 6102009 ,goods_num = 12 };
get(10009,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10009,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10009,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 29 ,attrs = [{ten,160}],goods_id = 6101000 ,goods_num = 120 };
get(10009,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 29 ,attrs = [{hit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10009,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10009,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 29 ,attrs = [{def,396}],goods_id = 6102009 ,goods_num = 12 };
get(10009,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10009,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10009,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 30 ,attrs = [{ten,170}],goods_id = 6101000 ,goods_num = 120 };
get(10009,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 30 ,attrs = [{hit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10009,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10009,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 30 ,attrs = [{def,420}],goods_id = 6102009 ,goods_num = 12 };
get(10009,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10009,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10009,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 31 ,attrs = [{ten,181}],goods_id = 6101000 ,goods_num = 140 };
get(10009,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 31 ,attrs = [{hit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10009,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10009,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 31 ,attrs = [{def,448}],goods_id = 6102009 ,goods_num = 13 };
get(10009,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10009,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10009,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 32 ,attrs = [{ten,192}],goods_id = 6101000 ,goods_num = 140 };
get(10009,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 32 ,attrs = [{hit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10009,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10009,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 32 ,attrs = [{def,476}],goods_id = 6102009 ,goods_num = 13 };
get(10009,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10009,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10009,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 33 ,attrs = [{ten,203}],goods_id = 6101000 ,goods_num = 140 };
get(10009,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 33 ,attrs = [{hit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10009,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10009,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 33 ,attrs = [{def,504}],goods_id = 6102009 ,goods_num = 14 };
get(10009,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10009,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10009,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 34 ,attrs = [{ten,214}],goods_id = 6101000 ,goods_num = 140 };
get(10009,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 34 ,attrs = [{hit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10009,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10009,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 34 ,attrs = [{def,532}],goods_id = 6102009 ,goods_num = 14 };
get(10009,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10009,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10009,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 35 ,attrs = [{ten,225}],goods_id = 6101000 ,goods_num = 140 };
get(10009,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 35 ,attrs = [{hit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10009,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10009,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 35 ,attrs = [{def,560}],goods_id = 6102009 ,goods_num = 14 };
get(10009,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10009,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10009,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 36 ,attrs = [{ten,238}],goods_id = 6101000 ,goods_num = 160 };
get(10009,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 36 ,attrs = [{hit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10009,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10009,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 36 ,attrs = [{def,592}],goods_id = 6102009 ,goods_num = 15 };
get(10009,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10009,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10009,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 37 ,attrs = [{ten,251}],goods_id = 6101000 ,goods_num = 160 };
get(10009,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 37 ,attrs = [{hit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10009,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10009,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 37 ,attrs = [{def,624}],goods_id = 6102009 ,goods_num = 15 };
get(10009,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10009,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10009,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 38 ,attrs = [{ten,264}],goods_id = 6101000 ,goods_num = 160 };
get(10009,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 38 ,attrs = [{hit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10009,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10009,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 38 ,attrs = [{def,656}],goods_id = 6102009 ,goods_num = 16 };
get(10009,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10009,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10009,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 39 ,attrs = [{ten,277}],goods_id = 6101000 ,goods_num = 160 };
get(10009,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 39 ,attrs = [{hit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10009,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10009,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 39 ,attrs = [{def,688}],goods_id = 6102009 ,goods_num = 16 };
get(10009,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10009,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10009,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 40 ,attrs = [{ten,290}],goods_id = 6101000 ,goods_num = 160 };
get(10009,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 40 ,attrs = [{hit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10009,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10009,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 40 ,attrs = [{def,720}],goods_id = 6102009 ,goods_num = 16 };
get(10009,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10009,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10009,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 41 ,attrs = [{ten,304}],goods_id = 6101000 ,goods_num = 180 };
get(10009,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 41 ,attrs = [{hit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10009,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10009,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 41 ,attrs = [{def,756}],goods_id = 6102009 ,goods_num = 17 };
get(10009,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10009,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10009,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 42 ,attrs = [{ten,318}],goods_id = 6101000 ,goods_num = 180 };
get(10009,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 42 ,attrs = [{hit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10009,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10009,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 42 ,attrs = [{def,792}],goods_id = 6102009 ,goods_num = 17 };
get(10009,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10009,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10009,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 43 ,attrs = [{ten,332}],goods_id = 6101000 ,goods_num = 180 };
get(10009,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 43 ,attrs = [{hit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10009,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10009,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 43 ,attrs = [{def,828}],goods_id = 6102009 ,goods_num = 18 };
get(10009,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10009,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10009,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 44 ,attrs = [{ten,346}],goods_id = 6101000 ,goods_num = 180 };
get(10009,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 44 ,attrs = [{hit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10009,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10009,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 44 ,attrs = [{def,864}],goods_id = 6102009 ,goods_num = 18 };
get(10009,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10009,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10009,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 45 ,attrs = [{ten,360}],goods_id = 6101000 ,goods_num = 180 };
get(10009,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 45 ,attrs = [{hit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10009,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10009,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 45 ,attrs = [{def,900}],goods_id = 6102009 ,goods_num = 18 };
get(10009,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10009,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10009,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 46 ,attrs = [{ten,376}],goods_id = 6101000 ,goods_num = 200 };
get(10009,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 46 ,attrs = [{hit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10009,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10009,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 46 ,attrs = [{def,940}],goods_id = 6102009 ,goods_num = 19 };
get(10009,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10009,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10009,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 47 ,attrs = [{ten,392}],goods_id = 6101000 ,goods_num = 200 };
get(10009,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 47 ,attrs = [{hit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10009,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10009,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 47 ,attrs = [{def,980}],goods_id = 6102009 ,goods_num = 19 };
get(10009,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10009,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10009,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 48 ,attrs = [{ten,408}],goods_id = 6101000 ,goods_num = 200 };
get(10009,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 48 ,attrs = [{hit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10009,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10009,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6102009 ,goods_num = 20 };
get(10009,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10009,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10009,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 49 ,attrs = [{ten,424}],goods_id = 6101000 ,goods_num = 200 };
get(10009,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 49 ,attrs = [{hit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10009,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10009,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6102009 ,goods_num = 20 };
get(10009,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 1 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10009,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 2 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10009,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 3 ,lv = 50 ,attrs = [{ten,440}],goods_id = 6101000 ,goods_num = 200 };
get(10009,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 4 ,lv = 50 ,attrs = [{hit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10009,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 5 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10009,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10009 ,type = 6 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6102009 ,goods_num = 20 };
get(10010,1,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6101000 ,goods_num = 20 };
get(10010,2,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 1 ,attrs = [{def,4}],goods_id = 6101000 ,goods_num = 20 };
get(10010,3,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 1 ,attrs = [{att,8}],goods_id = 6101000 ,goods_num = 20 };
get(10010,4,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 1 ,attrs = [{dodge,2}],goods_id = 6101000 ,goods_num = 20 };
get(10010,5,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 1 ,attrs = [{crit,2}],goods_id = 6101000 ,goods_num = 20 };
get(10010,6,1) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 1 ,attrs = [{hp_lim,80}],goods_id = 6102010 ,goods_num = 1 };
get(10010,1,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6101000 ,goods_num = 20 };
get(10010,2,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 2 ,attrs = [{def,8}],goods_id = 6101000 ,goods_num = 20 };
get(10010,3,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 2 ,attrs = [{att,16}],goods_id = 6101000 ,goods_num = 20 };
get(10010,4,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 2 ,attrs = [{dodge,4}],goods_id = 6101000 ,goods_num = 20 };
get(10010,5,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 2 ,attrs = [{crit,4}],goods_id = 6101000 ,goods_num = 20 };
get(10010,6,2) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 2 ,attrs = [{hp_lim,160}],goods_id = 6102010 ,goods_num = 1 };
get(10010,1,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6101000 ,goods_num = 20 };
get(10010,2,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 3 ,attrs = [{def,12}],goods_id = 6101000 ,goods_num = 20 };
get(10010,3,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 3 ,attrs = [{att,24}],goods_id = 6101000 ,goods_num = 20 };
get(10010,4,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 3 ,attrs = [{dodge,6}],goods_id = 6101000 ,goods_num = 20 };
get(10010,5,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 3 ,attrs = [{crit,6}],goods_id = 6101000 ,goods_num = 20 };
get(10010,6,3) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 3 ,attrs = [{hp_lim,240}],goods_id = 6102010 ,goods_num = 2 };
get(10010,1,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6101000 ,goods_num = 20 };
get(10010,2,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 4 ,attrs = [{def,16}],goods_id = 6101000 ,goods_num = 20 };
get(10010,3,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 4 ,attrs = [{att,32}],goods_id = 6101000 ,goods_num = 20 };
get(10010,4,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 4 ,attrs = [{dodge,8}],goods_id = 6101000 ,goods_num = 20 };
get(10010,5,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 4 ,attrs = [{crit,8}],goods_id = 6101000 ,goods_num = 20 };
get(10010,6,4) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 4 ,attrs = [{hp_lim,320}],goods_id = 6102010 ,goods_num = 2 };
get(10010,1,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6101000 ,goods_num = 20 };
get(10010,2,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 5 ,attrs = [{def,20}],goods_id = 6101000 ,goods_num = 20 };
get(10010,3,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 5 ,attrs = [{att,40}],goods_id = 6101000 ,goods_num = 20 };
get(10010,4,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 5 ,attrs = [{dodge,10}],goods_id = 6101000 ,goods_num = 20 };
get(10010,5,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 5 ,attrs = [{crit,10}],goods_id = 6101000 ,goods_num = 20 };
get(10010,6,5) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 5 ,attrs = [{hp_lim,400}],goods_id = 6102010 ,goods_num = 2 };
get(10010,1,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6101000 ,goods_num = 40 };
get(10010,2,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 6 ,attrs = [{def,28}],goods_id = 6101000 ,goods_num = 40 };
get(10010,3,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 6 ,attrs = [{att,56}],goods_id = 6101000 ,goods_num = 40 };
get(10010,4,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 6 ,attrs = [{dodge,13}],goods_id = 6101000 ,goods_num = 40 };
get(10010,5,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 6 ,attrs = [{crit,13}],goods_id = 6101000 ,goods_num = 40 };
get(10010,6,6) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 6 ,attrs = [{hp_lim,560}],goods_id = 6102010 ,goods_num = 3 };
get(10010,1,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6101000 ,goods_num = 40 };
get(10010,2,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 7 ,attrs = [{def,36}],goods_id = 6101000 ,goods_num = 40 };
get(10010,3,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 7 ,attrs = [{att,72}],goods_id = 6101000 ,goods_num = 40 };
get(10010,4,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 7 ,attrs = [{dodge,16}],goods_id = 6101000 ,goods_num = 40 };
get(10010,5,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 7 ,attrs = [{crit,16}],goods_id = 6101000 ,goods_num = 40 };
get(10010,6,7) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 7 ,attrs = [{hp_lim,720}],goods_id = 6102010 ,goods_num = 3 };
get(10010,1,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6101000 ,goods_num = 40 };
get(10010,2,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 8 ,attrs = [{def,44}],goods_id = 6101000 ,goods_num = 40 };
get(10010,3,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 8 ,attrs = [{att,88}],goods_id = 6101000 ,goods_num = 40 };
get(10010,4,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 8 ,attrs = [{dodge,19}],goods_id = 6101000 ,goods_num = 40 };
get(10010,5,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 8 ,attrs = [{crit,19}],goods_id = 6101000 ,goods_num = 40 };
get(10010,6,8) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 8 ,attrs = [{hp_lim,880}],goods_id = 6102010 ,goods_num = 4 };
get(10010,1,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6101000 ,goods_num = 40 };
get(10010,2,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 9 ,attrs = [{def,52}],goods_id = 6101000 ,goods_num = 40 };
get(10010,3,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 9 ,attrs = [{att,104}],goods_id = 6101000 ,goods_num = 40 };
get(10010,4,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 9 ,attrs = [{dodge,22}],goods_id = 6101000 ,goods_num = 40 };
get(10010,5,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 9 ,attrs = [{crit,22}],goods_id = 6101000 ,goods_num = 40 };
get(10010,6,9) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 9 ,attrs = [{hp_lim,1040}],goods_id = 6102010 ,goods_num = 4 };
get(10010,1,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6101000 ,goods_num = 40 };
get(10010,2,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 10 ,attrs = [{def,60}],goods_id = 6101000 ,goods_num = 40 };
get(10010,3,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 10 ,attrs = [{att,120}],goods_id = 6101000 ,goods_num = 40 };
get(10010,4,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 10 ,attrs = [{dodge,25}],goods_id = 6101000 ,goods_num = 40 };
get(10010,5,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 10 ,attrs = [{crit,25}],goods_id = 6101000 ,goods_num = 40 };
get(10010,6,10) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 10 ,attrs = [{hp_lim,1200}],goods_id = 6102010 ,goods_num = 4 };
get(10010,1,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6101000 ,goods_num = 60 };
get(10010,2,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 11 ,attrs = [{def,72}],goods_id = 6101000 ,goods_num = 60 };
get(10010,3,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 11 ,attrs = [{att,144}],goods_id = 6101000 ,goods_num = 60 };
get(10010,4,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 11 ,attrs = [{dodge,30}],goods_id = 6101000 ,goods_num = 60 };
get(10010,5,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 11 ,attrs = [{crit,30}],goods_id = 6101000 ,goods_num = 60 };
get(10010,6,11) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 11 ,attrs = [{hp_lim,1440}],goods_id = 6102010 ,goods_num = 5 };
get(10010,1,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6101000 ,goods_num = 60 };
get(10010,2,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 12 ,attrs = [{def,84}],goods_id = 6101000 ,goods_num = 60 };
get(10010,3,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 12 ,attrs = [{att,168}],goods_id = 6101000 ,goods_num = 60 };
get(10010,4,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 12 ,attrs = [{dodge,35}],goods_id = 6101000 ,goods_num = 60 };
get(10010,5,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 12 ,attrs = [{crit,35}],goods_id = 6101000 ,goods_num = 60 };
get(10010,6,12) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 12 ,attrs = [{hp_lim,1680}],goods_id = 6102010 ,goods_num = 5 };
get(10010,1,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6101000 ,goods_num = 60 };
get(10010,2,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 13 ,attrs = [{def,96}],goods_id = 6101000 ,goods_num = 60 };
get(10010,3,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 13 ,attrs = [{att,192}],goods_id = 6101000 ,goods_num = 60 };
get(10010,4,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 13 ,attrs = [{dodge,40}],goods_id = 6101000 ,goods_num = 60 };
get(10010,5,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 13 ,attrs = [{crit,40}],goods_id = 6101000 ,goods_num = 60 };
get(10010,6,13) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 13 ,attrs = [{hp_lim,1920}],goods_id = 6102010 ,goods_num = 6 };
get(10010,1,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6101000 ,goods_num = 60 };
get(10010,2,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 14 ,attrs = [{def,108}],goods_id = 6101000 ,goods_num = 60 };
get(10010,3,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 14 ,attrs = [{att,216}],goods_id = 6101000 ,goods_num = 60 };
get(10010,4,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 14 ,attrs = [{dodge,45}],goods_id = 6101000 ,goods_num = 60 };
get(10010,5,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 14 ,attrs = [{crit,45}],goods_id = 6101000 ,goods_num = 60 };
get(10010,6,14) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 14 ,attrs = [{hp_lim,2160}],goods_id = 6102010 ,goods_num = 6 };
get(10010,1,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6101000 ,goods_num = 60 };
get(10010,2,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 15 ,attrs = [{def,120}],goods_id = 6101000 ,goods_num = 60 };
get(10010,3,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 15 ,attrs = [{att,240}],goods_id = 6101000 ,goods_num = 60 };
get(10010,4,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 15 ,attrs = [{dodge,50}],goods_id = 6101000 ,goods_num = 60 };
get(10010,5,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 15 ,attrs = [{crit,50}],goods_id = 6101000 ,goods_num = 60 };
get(10010,6,15) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 15 ,attrs = [{hp_lim,2400}],goods_id = 6102010 ,goods_num = 6 };
get(10010,1,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6101000 ,goods_num = 80 };
get(10010,2,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 16 ,attrs = [{def,136}],goods_id = 6101000 ,goods_num = 80 };
get(10010,3,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 16 ,attrs = [{att,272}],goods_id = 6101000 ,goods_num = 80 };
get(10010,4,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 16 ,attrs = [{dodge,56}],goods_id = 6101000 ,goods_num = 80 };
get(10010,5,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 16 ,attrs = [{crit,56}],goods_id = 6101000 ,goods_num = 80 };
get(10010,6,16) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 16 ,attrs = [{hp_lim,2720}],goods_id = 6102010 ,goods_num = 7 };
get(10010,1,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6101000 ,goods_num = 80 };
get(10010,2,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 17 ,attrs = [{def,152}],goods_id = 6101000 ,goods_num = 80 };
get(10010,3,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 17 ,attrs = [{att,304}],goods_id = 6101000 ,goods_num = 80 };
get(10010,4,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 17 ,attrs = [{dodge,62}],goods_id = 6101000 ,goods_num = 80 };
get(10010,5,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 17 ,attrs = [{crit,62}],goods_id = 6101000 ,goods_num = 80 };
get(10010,6,17) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 17 ,attrs = [{hp_lim,3040}],goods_id = 6102010 ,goods_num = 7 };
get(10010,1,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6101000 ,goods_num = 80 };
get(10010,2,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 18 ,attrs = [{def,168}],goods_id = 6101000 ,goods_num = 80 };
get(10010,3,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 18 ,attrs = [{att,336}],goods_id = 6101000 ,goods_num = 80 };
get(10010,4,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 18 ,attrs = [{dodge,68}],goods_id = 6101000 ,goods_num = 80 };
get(10010,5,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 18 ,attrs = [{crit,68}],goods_id = 6101000 ,goods_num = 80 };
get(10010,6,18) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 18 ,attrs = [{hp_lim,3360}],goods_id = 6102010 ,goods_num = 8 };
get(10010,1,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6101000 ,goods_num = 80 };
get(10010,2,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 19 ,attrs = [{def,184}],goods_id = 6101000 ,goods_num = 80 };
get(10010,3,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 19 ,attrs = [{att,368}],goods_id = 6101000 ,goods_num = 80 };
get(10010,4,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 19 ,attrs = [{dodge,74}],goods_id = 6101000 ,goods_num = 80 };
get(10010,5,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 19 ,attrs = [{crit,74}],goods_id = 6101000 ,goods_num = 80 };
get(10010,6,19) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 19 ,attrs = [{hp_lim,3680}],goods_id = 6102010 ,goods_num = 8 };
get(10010,1,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6101000 ,goods_num = 80 };
get(10010,2,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 20 ,attrs = [{def,200}],goods_id = 6101000 ,goods_num = 80 };
get(10010,3,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 20 ,attrs = [{att,400}],goods_id = 6101000 ,goods_num = 80 };
get(10010,4,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 20 ,attrs = [{dodge,80}],goods_id = 6101000 ,goods_num = 80 };
get(10010,5,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 20 ,attrs = [{crit,80}],goods_id = 6101000 ,goods_num = 80 };
get(10010,6,20) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 20 ,attrs = [{hp_lim,4000}],goods_id = 6102010 ,goods_num = 8 };
get(10010,1,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6101000 ,goods_num = 100 };
get(10010,2,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 21 ,attrs = [{def,220}],goods_id = 6101000 ,goods_num = 100 };
get(10010,3,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 21 ,attrs = [{att,440}],goods_id = 6101000 ,goods_num = 100 };
get(10010,4,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 21 ,attrs = [{dodge,88}],goods_id = 6101000 ,goods_num = 100 };
get(10010,5,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 21 ,attrs = [{crit,88}],goods_id = 6101000 ,goods_num = 100 };
get(10010,6,21) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 21 ,attrs = [{hp_lim,4400}],goods_id = 6102010 ,goods_num = 9 };
get(10010,1,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6101000 ,goods_num = 100 };
get(10010,2,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 22 ,attrs = [{def,240}],goods_id = 6101000 ,goods_num = 100 };
get(10010,3,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 22 ,attrs = [{att,480}],goods_id = 6101000 ,goods_num = 100 };
get(10010,4,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 22 ,attrs = [{dodge,96}],goods_id = 6101000 ,goods_num = 100 };
get(10010,5,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 22 ,attrs = [{crit,96}],goods_id = 6101000 ,goods_num = 100 };
get(10010,6,22) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 22 ,attrs = [{hp_lim,4800}],goods_id = 6102010 ,goods_num = 9 };
get(10010,1,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6101000 ,goods_num = 100 };
get(10010,2,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 23 ,attrs = [{def,260}],goods_id = 6101000 ,goods_num = 100 };
get(10010,3,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 23 ,attrs = [{att,520}],goods_id = 6101000 ,goods_num = 100 };
get(10010,4,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 23 ,attrs = [{dodge,104}],goods_id = 6101000 ,goods_num = 100 };
get(10010,5,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 23 ,attrs = [{crit,104}],goods_id = 6101000 ,goods_num = 100 };
get(10010,6,23) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 23 ,attrs = [{hp_lim,5200}],goods_id = 6102010 ,goods_num = 10 };
get(10010,1,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6101000 ,goods_num = 100 };
get(10010,2,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 24 ,attrs = [{def,280}],goods_id = 6101000 ,goods_num = 100 };
get(10010,3,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 24 ,attrs = [{att,560}],goods_id = 6101000 ,goods_num = 100 };
get(10010,4,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 24 ,attrs = [{dodge,112}],goods_id = 6101000 ,goods_num = 100 };
get(10010,5,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 24 ,attrs = [{crit,112}],goods_id = 6101000 ,goods_num = 100 };
get(10010,6,24) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 24 ,attrs = [{hp_lim,5600}],goods_id = 6102010 ,goods_num = 10 };
get(10010,1,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6101000 ,goods_num = 100 };
get(10010,2,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 25 ,attrs = [{def,300}],goods_id = 6101000 ,goods_num = 100 };
get(10010,3,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 25 ,attrs = [{att,600}],goods_id = 6101000 ,goods_num = 100 };
get(10010,4,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 25 ,attrs = [{dodge,120}],goods_id = 6101000 ,goods_num = 100 };
get(10010,5,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 25 ,attrs = [{crit,120}],goods_id = 6101000 ,goods_num = 100 };
get(10010,6,25) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 25 ,attrs = [{hp_lim,6000}],goods_id = 6102010 ,goods_num = 10 };
get(10010,1,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6101000 ,goods_num = 120 };
get(10010,2,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 26 ,attrs = [{def,324}],goods_id = 6101000 ,goods_num = 120 };
get(10010,3,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 26 ,attrs = [{att,648}],goods_id = 6101000 ,goods_num = 120 };
get(10010,4,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 26 ,attrs = [{dodge,130}],goods_id = 6101000 ,goods_num = 120 };
get(10010,5,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 26 ,attrs = [{crit,130}],goods_id = 6101000 ,goods_num = 120 };
get(10010,6,26) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 26 ,attrs = [{hp_lim,6480}],goods_id = 6102010 ,goods_num = 11 };
get(10010,1,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6101000 ,goods_num = 120 };
get(10010,2,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 27 ,attrs = [{def,348}],goods_id = 6101000 ,goods_num = 120 };
get(10010,3,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 27 ,attrs = [{att,696}],goods_id = 6101000 ,goods_num = 120 };
get(10010,4,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 27 ,attrs = [{dodge,140}],goods_id = 6101000 ,goods_num = 120 };
get(10010,5,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 27 ,attrs = [{crit,140}],goods_id = 6101000 ,goods_num = 120 };
get(10010,6,27) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 27 ,attrs = [{hp_lim,6960}],goods_id = 6102010 ,goods_num = 11 };
get(10010,1,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6101000 ,goods_num = 120 };
get(10010,2,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 28 ,attrs = [{def,372}],goods_id = 6101000 ,goods_num = 120 };
get(10010,3,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 28 ,attrs = [{att,744}],goods_id = 6101000 ,goods_num = 120 };
get(10010,4,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 28 ,attrs = [{dodge,150}],goods_id = 6101000 ,goods_num = 120 };
get(10010,5,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 28 ,attrs = [{crit,150}],goods_id = 6101000 ,goods_num = 120 };
get(10010,6,28) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 28 ,attrs = [{hp_lim,7440}],goods_id = 6102010 ,goods_num = 12 };
get(10010,1,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6101000 ,goods_num = 120 };
get(10010,2,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 29 ,attrs = [{def,396}],goods_id = 6101000 ,goods_num = 120 };
get(10010,3,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 29 ,attrs = [{att,792}],goods_id = 6101000 ,goods_num = 120 };
get(10010,4,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 29 ,attrs = [{dodge,160}],goods_id = 6101000 ,goods_num = 120 };
get(10010,5,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 29 ,attrs = [{crit,160}],goods_id = 6101000 ,goods_num = 120 };
get(10010,6,29) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 29 ,attrs = [{hp_lim,7920}],goods_id = 6102010 ,goods_num = 12 };
get(10010,1,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6101000 ,goods_num = 120 };
get(10010,2,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 30 ,attrs = [{def,420}],goods_id = 6101000 ,goods_num = 120 };
get(10010,3,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 30 ,attrs = [{att,840}],goods_id = 6101000 ,goods_num = 120 };
get(10010,4,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 30 ,attrs = [{dodge,170}],goods_id = 6101000 ,goods_num = 120 };
get(10010,5,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 30 ,attrs = [{crit,170}],goods_id = 6101000 ,goods_num = 120 };
get(10010,6,30) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 30 ,attrs = [{hp_lim,8400}],goods_id = 6102010 ,goods_num = 12 };
get(10010,1,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6101000 ,goods_num = 140 };
get(10010,2,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 31 ,attrs = [{def,448}],goods_id = 6101000 ,goods_num = 140 };
get(10010,3,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 31 ,attrs = [{att,896}],goods_id = 6101000 ,goods_num = 140 };
get(10010,4,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 31 ,attrs = [{dodge,181}],goods_id = 6101000 ,goods_num = 140 };
get(10010,5,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 31 ,attrs = [{crit,181}],goods_id = 6101000 ,goods_num = 140 };
get(10010,6,31) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 31 ,attrs = [{hp_lim,8960}],goods_id = 6102010 ,goods_num = 13 };
get(10010,1,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6101000 ,goods_num = 140 };
get(10010,2,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 32 ,attrs = [{def,476}],goods_id = 6101000 ,goods_num = 140 };
get(10010,3,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 32 ,attrs = [{att,952}],goods_id = 6101000 ,goods_num = 140 };
get(10010,4,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 32 ,attrs = [{dodge,192}],goods_id = 6101000 ,goods_num = 140 };
get(10010,5,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 32 ,attrs = [{crit,192}],goods_id = 6101000 ,goods_num = 140 };
get(10010,6,32) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 32 ,attrs = [{hp_lim,9520}],goods_id = 6102010 ,goods_num = 13 };
get(10010,1,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6101000 ,goods_num = 140 };
get(10010,2,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 33 ,attrs = [{def,504}],goods_id = 6101000 ,goods_num = 140 };
get(10010,3,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 33 ,attrs = [{att,1008}],goods_id = 6101000 ,goods_num = 140 };
get(10010,4,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 33 ,attrs = [{dodge,203}],goods_id = 6101000 ,goods_num = 140 };
get(10010,5,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 33 ,attrs = [{crit,203}],goods_id = 6101000 ,goods_num = 140 };
get(10010,6,33) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 33 ,attrs = [{hp_lim,10080}],goods_id = 6102010 ,goods_num = 14 };
get(10010,1,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6101000 ,goods_num = 140 };
get(10010,2,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 34 ,attrs = [{def,532}],goods_id = 6101000 ,goods_num = 140 };
get(10010,3,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 34 ,attrs = [{att,1064}],goods_id = 6101000 ,goods_num = 140 };
get(10010,4,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 34 ,attrs = [{dodge,214}],goods_id = 6101000 ,goods_num = 140 };
get(10010,5,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 34 ,attrs = [{crit,214}],goods_id = 6101000 ,goods_num = 140 };
get(10010,6,34) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 34 ,attrs = [{hp_lim,10640}],goods_id = 6102010 ,goods_num = 14 };
get(10010,1,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6101000 ,goods_num = 140 };
get(10010,2,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 35 ,attrs = [{def,560}],goods_id = 6101000 ,goods_num = 140 };
get(10010,3,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 35 ,attrs = [{att,1120}],goods_id = 6101000 ,goods_num = 140 };
get(10010,4,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 35 ,attrs = [{dodge,225}],goods_id = 6101000 ,goods_num = 140 };
get(10010,5,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 35 ,attrs = [{crit,225}],goods_id = 6101000 ,goods_num = 140 };
get(10010,6,35) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 35 ,attrs = [{hp_lim,11200}],goods_id = 6102010 ,goods_num = 14 };
get(10010,1,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6101000 ,goods_num = 160 };
get(10010,2,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 36 ,attrs = [{def,592}],goods_id = 6101000 ,goods_num = 160 };
get(10010,3,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 36 ,attrs = [{att,1184}],goods_id = 6101000 ,goods_num = 160 };
get(10010,4,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 36 ,attrs = [{dodge,238}],goods_id = 6101000 ,goods_num = 160 };
get(10010,5,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 36 ,attrs = [{crit,238}],goods_id = 6101000 ,goods_num = 160 };
get(10010,6,36) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 36 ,attrs = [{hp_lim,11840}],goods_id = 6102010 ,goods_num = 15 };
get(10010,1,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6101000 ,goods_num = 160 };
get(10010,2,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 37 ,attrs = [{def,624}],goods_id = 6101000 ,goods_num = 160 };
get(10010,3,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 37 ,attrs = [{att,1248}],goods_id = 6101000 ,goods_num = 160 };
get(10010,4,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 37 ,attrs = [{dodge,251}],goods_id = 6101000 ,goods_num = 160 };
get(10010,5,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 37 ,attrs = [{crit,251}],goods_id = 6101000 ,goods_num = 160 };
get(10010,6,37) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 37 ,attrs = [{hp_lim,12480}],goods_id = 6102010 ,goods_num = 15 };
get(10010,1,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6101000 ,goods_num = 160 };
get(10010,2,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 38 ,attrs = [{def,656}],goods_id = 6101000 ,goods_num = 160 };
get(10010,3,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 38 ,attrs = [{att,1312}],goods_id = 6101000 ,goods_num = 160 };
get(10010,4,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 38 ,attrs = [{dodge,264}],goods_id = 6101000 ,goods_num = 160 };
get(10010,5,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 38 ,attrs = [{crit,264}],goods_id = 6101000 ,goods_num = 160 };
get(10010,6,38) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 38 ,attrs = [{hp_lim,13120}],goods_id = 6102010 ,goods_num = 16 };
get(10010,1,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6101000 ,goods_num = 160 };
get(10010,2,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 39 ,attrs = [{def,688}],goods_id = 6101000 ,goods_num = 160 };
get(10010,3,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 39 ,attrs = [{att,1376}],goods_id = 6101000 ,goods_num = 160 };
get(10010,4,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 39 ,attrs = [{dodge,277}],goods_id = 6101000 ,goods_num = 160 };
get(10010,5,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 39 ,attrs = [{crit,277}],goods_id = 6101000 ,goods_num = 160 };
get(10010,6,39) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 39 ,attrs = [{hp_lim,13760}],goods_id = 6102010 ,goods_num = 16 };
get(10010,1,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6101000 ,goods_num = 160 };
get(10010,2,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 40 ,attrs = [{def,720}],goods_id = 6101000 ,goods_num = 160 };
get(10010,3,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 40 ,attrs = [{att,1440}],goods_id = 6101000 ,goods_num = 160 };
get(10010,4,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 40 ,attrs = [{dodge,290}],goods_id = 6101000 ,goods_num = 160 };
get(10010,5,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 40 ,attrs = [{crit,290}],goods_id = 6101000 ,goods_num = 160 };
get(10010,6,40) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 40 ,attrs = [{hp_lim,14400}],goods_id = 6102010 ,goods_num = 16 };
get(10010,1,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6101000 ,goods_num = 180 };
get(10010,2,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 41 ,attrs = [{def,756}],goods_id = 6101000 ,goods_num = 180 };
get(10010,3,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 41 ,attrs = [{att,1512}],goods_id = 6101000 ,goods_num = 180 };
get(10010,4,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 41 ,attrs = [{dodge,304}],goods_id = 6101000 ,goods_num = 180 };
get(10010,5,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 41 ,attrs = [{crit,304}],goods_id = 6101000 ,goods_num = 180 };
get(10010,6,41) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 41 ,attrs = [{hp_lim,15120}],goods_id = 6102010 ,goods_num = 17 };
get(10010,1,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6101000 ,goods_num = 180 };
get(10010,2,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 42 ,attrs = [{def,792}],goods_id = 6101000 ,goods_num = 180 };
get(10010,3,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 42 ,attrs = [{att,1584}],goods_id = 6101000 ,goods_num = 180 };
get(10010,4,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 42 ,attrs = [{dodge,318}],goods_id = 6101000 ,goods_num = 180 };
get(10010,5,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 42 ,attrs = [{crit,318}],goods_id = 6101000 ,goods_num = 180 };
get(10010,6,42) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 42 ,attrs = [{hp_lim,15840}],goods_id = 6102010 ,goods_num = 17 };
get(10010,1,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6101000 ,goods_num = 180 };
get(10010,2,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 43 ,attrs = [{def,828}],goods_id = 6101000 ,goods_num = 180 };
get(10010,3,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 43 ,attrs = [{att,1656}],goods_id = 6101000 ,goods_num = 180 };
get(10010,4,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 43 ,attrs = [{dodge,332}],goods_id = 6101000 ,goods_num = 180 };
get(10010,5,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 43 ,attrs = [{crit,332}],goods_id = 6101000 ,goods_num = 180 };
get(10010,6,43) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 43 ,attrs = [{hp_lim,16560}],goods_id = 6102010 ,goods_num = 18 };
get(10010,1,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6101000 ,goods_num = 180 };
get(10010,2,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 44 ,attrs = [{def,864}],goods_id = 6101000 ,goods_num = 180 };
get(10010,3,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 44 ,attrs = [{att,1728}],goods_id = 6101000 ,goods_num = 180 };
get(10010,4,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 44 ,attrs = [{dodge,346}],goods_id = 6101000 ,goods_num = 180 };
get(10010,5,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 44 ,attrs = [{crit,346}],goods_id = 6101000 ,goods_num = 180 };
get(10010,6,44) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 44 ,attrs = [{hp_lim,17280}],goods_id = 6102010 ,goods_num = 18 };
get(10010,1,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6101000 ,goods_num = 180 };
get(10010,2,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 45 ,attrs = [{def,900}],goods_id = 6101000 ,goods_num = 180 };
get(10010,3,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 45 ,attrs = [{att,1800}],goods_id = 6101000 ,goods_num = 180 };
get(10010,4,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 45 ,attrs = [{dodge,360}],goods_id = 6101000 ,goods_num = 180 };
get(10010,5,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 45 ,attrs = [{crit,360}],goods_id = 6101000 ,goods_num = 180 };
get(10010,6,45) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 45 ,attrs = [{hp_lim,18000}],goods_id = 6102010 ,goods_num = 18 };
get(10010,1,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6101000 ,goods_num = 200 };
get(10010,2,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 46 ,attrs = [{def,940}],goods_id = 6101000 ,goods_num = 200 };
get(10010,3,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 46 ,attrs = [{att,1880}],goods_id = 6101000 ,goods_num = 200 };
get(10010,4,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 46 ,attrs = [{dodge,376}],goods_id = 6101000 ,goods_num = 200 };
get(10010,5,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 46 ,attrs = [{crit,376}],goods_id = 6101000 ,goods_num = 200 };
get(10010,6,46) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 46 ,attrs = [{hp_lim,18800}],goods_id = 6102010 ,goods_num = 19 };
get(10010,1,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6101000 ,goods_num = 200 };
get(10010,2,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 47 ,attrs = [{def,980}],goods_id = 6101000 ,goods_num = 200 };
get(10010,3,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 47 ,attrs = [{att,1960}],goods_id = 6101000 ,goods_num = 200 };
get(10010,4,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 47 ,attrs = [{dodge,392}],goods_id = 6101000 ,goods_num = 200 };
get(10010,5,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 47 ,attrs = [{crit,392}],goods_id = 6101000 ,goods_num = 200 };
get(10010,6,47) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 47 ,attrs = [{hp_lim,19600}],goods_id = 6102010 ,goods_num = 19 };
get(10010,1,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6101000 ,goods_num = 200 };
get(10010,2,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 48 ,attrs = [{def,1020}],goods_id = 6101000 ,goods_num = 200 };
get(10010,3,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 48 ,attrs = [{att,2040}],goods_id = 6101000 ,goods_num = 200 };
get(10010,4,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 48 ,attrs = [{dodge,408}],goods_id = 6101000 ,goods_num = 200 };
get(10010,5,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 48 ,attrs = [{crit,408}],goods_id = 6101000 ,goods_num = 200 };
get(10010,6,48) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 48 ,attrs = [{hp_lim,20400}],goods_id = 6102010 ,goods_num = 20 };
get(10010,1,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6101000 ,goods_num = 200 };
get(10010,2,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 49 ,attrs = [{def,1060}],goods_id = 6101000 ,goods_num = 200 };
get(10010,3,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 49 ,attrs = [{att,2120}],goods_id = 6101000 ,goods_num = 200 };
get(10010,4,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 49 ,attrs = [{dodge,424}],goods_id = 6101000 ,goods_num = 200 };
get(10010,5,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 49 ,attrs = [{crit,424}],goods_id = 6101000 ,goods_num = 200 };
get(10010,6,49) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 49 ,attrs = [{hp_lim,21200}],goods_id = 6102010 ,goods_num = 20 };
get(10010,1,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 1 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6101000 ,goods_num = 200 };
get(10010,2,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 2 ,lv = 50 ,attrs = [{def,1100}],goods_id = 6101000 ,goods_num = 200 };
get(10010,3,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 3 ,lv = 50 ,attrs = [{att,2200}],goods_id = 6101000 ,goods_num = 200 };
get(10010,4,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 4 ,lv = 50 ,attrs = [{dodge,440}],goods_id = 6101000 ,goods_num = 200 };
get(10010,5,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 5 ,lv = 50 ,attrs = [{crit,440}],goods_id = 6101000 ,goods_num = 200 };
get(10010,6,50) ->
	#base_god_weapon_spirit{weapon_id = 10010 ,type = 6 ,lv = 50 ,attrs = [{hp_lim,22000}],goods_id = 6102010 ,goods_num = 20 };
get(_,_,_) -> [].