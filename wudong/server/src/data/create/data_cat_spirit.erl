%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cat_spirit
	%%% @Created : 2017-07-13 10:42:19
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cat_spirit).
-export([max_type/0]).
-export([type_list/0]).
-export([get/2]).
-include("cat.hrl").
-include("common.hrl").

    max_type()->8. 


    type_list() ->
    [1,2,3,4,5,6,7,8].
get(1,1) ->
	#base_cat_spirit{type = 1 ,lv = 1 ,attrs = [{def,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,1) ->
	#base_cat_spirit{type = 2 ,lv = 1 ,attrs = [{hp_lim,40}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,1) ->
	#base_cat_spirit{type = 3 ,lv = 1 ,attrs = [{crit,1}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,1) ->
	#base_cat_spirit{type = 4 ,lv = 1 ,attrs = [{ten,1}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,1) ->
	#base_cat_spirit{type = 5 ,lv = 1 ,attrs = [{hit,1}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,1) ->
	#base_cat_spirit{type = 6 ,lv = 1 ,attrs = [{dodge,1}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,1) ->
	#base_cat_spirit{type = 7 ,lv = 1 ,attrs = [{att,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,1) ->
	#base_cat_spirit{type = 8 ,lv = 1 ,attrs = [{hit,1},{dodge,1},{att,4}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,2) ->
	#base_cat_spirit{type = 1 ,lv = 2 ,attrs = [{def,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,2) ->
	#base_cat_spirit{type = 2 ,lv = 2 ,attrs = [{hp_lim,80}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,2) ->
	#base_cat_spirit{type = 3 ,lv = 2 ,attrs = [{crit,2}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,2) ->
	#base_cat_spirit{type = 4 ,lv = 2 ,attrs = [{ten,2}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,2) ->
	#base_cat_spirit{type = 5 ,lv = 2 ,attrs = [{hit,2}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,2) ->
	#base_cat_spirit{type = 6 ,lv = 2 ,attrs = [{dodge,2}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,2) ->
	#base_cat_spirit{type = 7 ,lv = 2 ,attrs = [{att,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,2) ->
	#base_cat_spirit{type = 8 ,lv = 2 ,attrs = [{hit,2},{dodge,2},{att,8}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,3) ->
	#base_cat_spirit{type = 1 ,lv = 3 ,attrs = [{def,12}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,3) ->
	#base_cat_spirit{type = 2 ,lv = 3 ,attrs = [{hp_lim,120}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,3) ->
	#base_cat_spirit{type = 3 ,lv = 3 ,attrs = [{crit,3}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,3) ->
	#base_cat_spirit{type = 4 ,lv = 3 ,attrs = [{ten,3}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,3) ->
	#base_cat_spirit{type = 5 ,lv = 3 ,attrs = [{hit,3}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,3) ->
	#base_cat_spirit{type = 6 ,lv = 3 ,attrs = [{dodge,3}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,3) ->
	#base_cat_spirit{type = 7 ,lv = 3 ,attrs = [{att,12}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,3) ->
	#base_cat_spirit{type = 8 ,lv = 3 ,attrs = [{hit,3},{dodge,3},{att,12}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,4) ->
	#base_cat_spirit{type = 1 ,lv = 4 ,attrs = [{def,16}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,4) ->
	#base_cat_spirit{type = 2 ,lv = 4 ,attrs = [{hp_lim,160}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,4) ->
	#base_cat_spirit{type = 3 ,lv = 4 ,attrs = [{crit,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,4) ->
	#base_cat_spirit{type = 4 ,lv = 4 ,attrs = [{ten,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,4) ->
	#base_cat_spirit{type = 5 ,lv = 4 ,attrs = [{hit,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,4) ->
	#base_cat_spirit{type = 6 ,lv = 4 ,attrs = [{dodge,4}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,4) ->
	#base_cat_spirit{type = 7 ,lv = 4 ,attrs = [{att,16}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,4) ->
	#base_cat_spirit{type = 8 ,lv = 4 ,attrs = [{hit,4},{dodge,4},{att,16}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,5) ->
	#base_cat_spirit{type = 1 ,lv = 5 ,attrs = [{def,20}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,5) ->
	#base_cat_spirit{type = 2 ,lv = 5 ,attrs = [{hp_lim,200}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,5) ->
	#base_cat_spirit{type = 3 ,lv = 5 ,attrs = [{crit,5}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,5) ->
	#base_cat_spirit{type = 4 ,lv = 5 ,attrs = [{ten,5}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,5) ->
	#base_cat_spirit{type = 5 ,lv = 5 ,attrs = [{hit,5}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,5) ->
	#base_cat_spirit{type = 6 ,lv = 5 ,attrs = [{dodge,5}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,5) ->
	#base_cat_spirit{type = 7 ,lv = 5 ,attrs = [{att,20}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,5) ->
	#base_cat_spirit{type = 8 ,lv = 5 ,attrs = [{hit,5},{dodge,5},{att,20}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,6) ->
	#base_cat_spirit{type = 1 ,lv = 6 ,attrs = [{def,24}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,6) ->
	#base_cat_spirit{type = 2 ,lv = 6 ,attrs = [{hp_lim,240}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,6) ->
	#base_cat_spirit{type = 3 ,lv = 6 ,attrs = [{crit,6}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,6) ->
	#base_cat_spirit{type = 4 ,lv = 6 ,attrs = [{ten,6}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,6) ->
	#base_cat_spirit{type = 5 ,lv = 6 ,attrs = [{hit,6}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,6) ->
	#base_cat_spirit{type = 6 ,lv = 6 ,attrs = [{dodge,6}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,6) ->
	#base_cat_spirit{type = 7 ,lv = 6 ,attrs = [{att,24}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,6) ->
	#base_cat_spirit{type = 8 ,lv = 6 ,attrs = [{hit,6},{dodge,6},{att,24}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,7) ->
	#base_cat_spirit{type = 1 ,lv = 7 ,attrs = [{def,28}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,7) ->
	#base_cat_spirit{type = 2 ,lv = 7 ,attrs = [{hp_lim,280}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,7) ->
	#base_cat_spirit{type = 3 ,lv = 7 ,attrs = [{crit,7}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,7) ->
	#base_cat_spirit{type = 4 ,lv = 7 ,attrs = [{ten,7}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,7) ->
	#base_cat_spirit{type = 5 ,lv = 7 ,attrs = [{hit,7}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,7) ->
	#base_cat_spirit{type = 6 ,lv = 7 ,attrs = [{dodge,7}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,7) ->
	#base_cat_spirit{type = 7 ,lv = 7 ,attrs = [{att,28}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,7) ->
	#base_cat_spirit{type = 8 ,lv = 7 ,attrs = [{hit,7},{dodge,7},{att,28}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,8) ->
	#base_cat_spirit{type = 1 ,lv = 8 ,attrs = [{def,32}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,8) ->
	#base_cat_spirit{type = 2 ,lv = 8 ,attrs = [{hp_lim,320}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,8) ->
	#base_cat_spirit{type = 3 ,lv = 8 ,attrs = [{crit,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,8) ->
	#base_cat_spirit{type = 4 ,lv = 8 ,attrs = [{ten,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,8) ->
	#base_cat_spirit{type = 5 ,lv = 8 ,attrs = [{hit,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,8) ->
	#base_cat_spirit{type = 6 ,lv = 8 ,attrs = [{dodge,8}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,8) ->
	#base_cat_spirit{type = 7 ,lv = 8 ,attrs = [{att,32}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,8) ->
	#base_cat_spirit{type = 8 ,lv = 8 ,attrs = [{hit,8},{dodge,8},{att,32}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,9) ->
	#base_cat_spirit{type = 1 ,lv = 9 ,attrs = [{def,36}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,9) ->
	#base_cat_spirit{type = 2 ,lv = 9 ,attrs = [{hp_lim,360}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,9) ->
	#base_cat_spirit{type = 3 ,lv = 9 ,attrs = [{crit,9}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,9) ->
	#base_cat_spirit{type = 4 ,lv = 9 ,attrs = [{ten,9}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,9) ->
	#base_cat_spirit{type = 5 ,lv = 9 ,attrs = [{hit,9}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,9) ->
	#base_cat_spirit{type = 6 ,lv = 9 ,attrs = [{dodge,9}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,9) ->
	#base_cat_spirit{type = 7 ,lv = 9 ,attrs = [{att,36}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,9) ->
	#base_cat_spirit{type = 8 ,lv = 9 ,attrs = [{hit,9},{dodge,9},{att,36}],goods_id = 3710000 ,goods_num = 3 ,stage = 1 };
get(1,10) ->
	#base_cat_spirit{type = 1 ,lv = 10 ,attrs = [{def,40}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(2,10) ->
	#base_cat_spirit{type = 2 ,lv = 10 ,attrs = [{hp_lim,400}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(3,10) ->
	#base_cat_spirit{type = 3 ,lv = 10 ,attrs = [{crit,10}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(4,10) ->
	#base_cat_spirit{type = 4 ,lv = 10 ,attrs = [{ten,10}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(5,10) ->
	#base_cat_spirit{type = 5 ,lv = 10 ,attrs = [{hit,10}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(6,10) ->
	#base_cat_spirit{type = 6 ,lv = 10 ,attrs = [{dodge,10}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(7,10) ->
	#base_cat_spirit{type = 7 ,lv = 10 ,attrs = [{att,40}],goods_id = 3710000 ,goods_num = 1 ,stage = 1 };
get(8,10) ->
	#base_cat_spirit{type = 8 ,lv = 10 ,attrs = [{hit,10},{dodge,10},{att,40}],goods_id = 3711000 ,goods_num = 2 ,stage = 1 };
get(1,11) ->
	#base_cat_spirit{type = 1 ,lv = 11 ,attrs = [{def,48}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,11) ->
	#base_cat_spirit{type = 2 ,lv = 11 ,attrs = [{hp_lim,480}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,11) ->
	#base_cat_spirit{type = 3 ,lv = 11 ,attrs = [{crit,13}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,11) ->
	#base_cat_spirit{type = 4 ,lv = 11 ,attrs = [{ten,13}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,11) ->
	#base_cat_spirit{type = 5 ,lv = 11 ,attrs = [{hit,13}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,11) ->
	#base_cat_spirit{type = 6 ,lv = 11 ,attrs = [{dodge,13}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,11) ->
	#base_cat_spirit{type = 7 ,lv = 11 ,attrs = [{att,48}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,11) ->
	#base_cat_spirit{type = 8 ,lv = 11 ,attrs = [{hit,13},{dodge,13},{att,48}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,12) ->
	#base_cat_spirit{type = 1 ,lv = 12 ,attrs = [{def,56}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,12) ->
	#base_cat_spirit{type = 2 ,lv = 12 ,attrs = [{hp_lim,560}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,12) ->
	#base_cat_spirit{type = 3 ,lv = 12 ,attrs = [{crit,16}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,12) ->
	#base_cat_spirit{type = 4 ,lv = 12 ,attrs = [{ten,16}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,12) ->
	#base_cat_spirit{type = 5 ,lv = 12 ,attrs = [{hit,16}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,12) ->
	#base_cat_spirit{type = 6 ,lv = 12 ,attrs = [{dodge,16}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,12) ->
	#base_cat_spirit{type = 7 ,lv = 12 ,attrs = [{att,56}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,12) ->
	#base_cat_spirit{type = 8 ,lv = 12 ,attrs = [{hit,16},{dodge,16},{att,56}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,13) ->
	#base_cat_spirit{type = 1 ,lv = 13 ,attrs = [{def,64}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,13) ->
	#base_cat_spirit{type = 2 ,lv = 13 ,attrs = [{hp_lim,640}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,13) ->
	#base_cat_spirit{type = 3 ,lv = 13 ,attrs = [{crit,19}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,13) ->
	#base_cat_spirit{type = 4 ,lv = 13 ,attrs = [{ten,19}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,13) ->
	#base_cat_spirit{type = 5 ,lv = 13 ,attrs = [{hit,19}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,13) ->
	#base_cat_spirit{type = 6 ,lv = 13 ,attrs = [{dodge,19}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,13) ->
	#base_cat_spirit{type = 7 ,lv = 13 ,attrs = [{att,64}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,13) ->
	#base_cat_spirit{type = 8 ,lv = 13 ,attrs = [{hit,19},{dodge,19},{att,64}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,14) ->
	#base_cat_spirit{type = 1 ,lv = 14 ,attrs = [{def,72}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,14) ->
	#base_cat_spirit{type = 2 ,lv = 14 ,attrs = [{hp_lim,720}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,14) ->
	#base_cat_spirit{type = 3 ,lv = 14 ,attrs = [{crit,22}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,14) ->
	#base_cat_spirit{type = 4 ,lv = 14 ,attrs = [{ten,22}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,14) ->
	#base_cat_spirit{type = 5 ,lv = 14 ,attrs = [{hit,22}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,14) ->
	#base_cat_spirit{type = 6 ,lv = 14 ,attrs = [{dodge,22}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,14) ->
	#base_cat_spirit{type = 7 ,lv = 14 ,attrs = [{att,72}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,14) ->
	#base_cat_spirit{type = 8 ,lv = 14 ,attrs = [{hit,22},{dodge,22},{att,72}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,15) ->
	#base_cat_spirit{type = 1 ,lv = 15 ,attrs = [{def,80}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,15) ->
	#base_cat_spirit{type = 2 ,lv = 15 ,attrs = [{hp_lim,800}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,15) ->
	#base_cat_spirit{type = 3 ,lv = 15 ,attrs = [{crit,25}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,15) ->
	#base_cat_spirit{type = 4 ,lv = 15 ,attrs = [{ten,25}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,15) ->
	#base_cat_spirit{type = 5 ,lv = 15 ,attrs = [{hit,25}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,15) ->
	#base_cat_spirit{type = 6 ,lv = 15 ,attrs = [{dodge,25}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,15) ->
	#base_cat_spirit{type = 7 ,lv = 15 ,attrs = [{att,80}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,15) ->
	#base_cat_spirit{type = 8 ,lv = 15 ,attrs = [{hit,25},{dodge,25},{att,80}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,16) ->
	#base_cat_spirit{type = 1 ,lv = 16 ,attrs = [{def,88}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,16) ->
	#base_cat_spirit{type = 2 ,lv = 16 ,attrs = [{hp_lim,880}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,16) ->
	#base_cat_spirit{type = 3 ,lv = 16 ,attrs = [{crit,28}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,16) ->
	#base_cat_spirit{type = 4 ,lv = 16 ,attrs = [{ten,28}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,16) ->
	#base_cat_spirit{type = 5 ,lv = 16 ,attrs = [{hit,28}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,16) ->
	#base_cat_spirit{type = 6 ,lv = 16 ,attrs = [{dodge,28}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,16) ->
	#base_cat_spirit{type = 7 ,lv = 16 ,attrs = [{att,88}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,16) ->
	#base_cat_spirit{type = 8 ,lv = 16 ,attrs = [{hit,28},{dodge,28},{att,88}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,17) ->
	#base_cat_spirit{type = 1 ,lv = 17 ,attrs = [{def,96}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,17) ->
	#base_cat_spirit{type = 2 ,lv = 17 ,attrs = [{hp_lim,960}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,17) ->
	#base_cat_spirit{type = 3 ,lv = 17 ,attrs = [{crit,31}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,17) ->
	#base_cat_spirit{type = 4 ,lv = 17 ,attrs = [{ten,31}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,17) ->
	#base_cat_spirit{type = 5 ,lv = 17 ,attrs = [{hit,31}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,17) ->
	#base_cat_spirit{type = 6 ,lv = 17 ,attrs = [{dodge,31}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,17) ->
	#base_cat_spirit{type = 7 ,lv = 17 ,attrs = [{att,96}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,17) ->
	#base_cat_spirit{type = 8 ,lv = 17 ,attrs = [{hit,31},{dodge,31},{att,96}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,18) ->
	#base_cat_spirit{type = 1 ,lv = 18 ,attrs = [{def,104}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,18) ->
	#base_cat_spirit{type = 2 ,lv = 18 ,attrs = [{hp_lim,1040}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,18) ->
	#base_cat_spirit{type = 3 ,lv = 18 ,attrs = [{crit,34}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,18) ->
	#base_cat_spirit{type = 4 ,lv = 18 ,attrs = [{ten,34}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,18) ->
	#base_cat_spirit{type = 5 ,lv = 18 ,attrs = [{hit,34}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,18) ->
	#base_cat_spirit{type = 6 ,lv = 18 ,attrs = [{dodge,34}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,18) ->
	#base_cat_spirit{type = 7 ,lv = 18 ,attrs = [{att,104}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,18) ->
	#base_cat_spirit{type = 8 ,lv = 18 ,attrs = [{hit,34},{dodge,34},{att,104}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,19) ->
	#base_cat_spirit{type = 1 ,lv = 19 ,attrs = [{def,112}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,19) ->
	#base_cat_spirit{type = 2 ,lv = 19 ,attrs = [{hp_lim,1120}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,19) ->
	#base_cat_spirit{type = 3 ,lv = 19 ,attrs = [{crit,37}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,19) ->
	#base_cat_spirit{type = 4 ,lv = 19 ,attrs = [{ten,37}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,19) ->
	#base_cat_spirit{type = 5 ,lv = 19 ,attrs = [{hit,37}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,19) ->
	#base_cat_spirit{type = 6 ,lv = 19 ,attrs = [{dodge,37}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,19) ->
	#base_cat_spirit{type = 7 ,lv = 19 ,attrs = [{att,112}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,19) ->
	#base_cat_spirit{type = 8 ,lv = 19 ,attrs = [{hit,37},{dodge,37},{att,112}],goods_id = 3710000 ,goods_num = 6 ,stage = 2 };
get(1,20) ->
	#base_cat_spirit{type = 1 ,lv = 20 ,attrs = [{def,120}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(2,20) ->
	#base_cat_spirit{type = 2 ,lv = 20 ,attrs = [{hp_lim,1200}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(3,20) ->
	#base_cat_spirit{type = 3 ,lv = 20 ,attrs = [{crit,40}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(4,20) ->
	#base_cat_spirit{type = 4 ,lv = 20 ,attrs = [{ten,40}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(5,20) ->
	#base_cat_spirit{type = 5 ,lv = 20 ,attrs = [{hit,40}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(6,20) ->
	#base_cat_spirit{type = 6 ,lv = 20 ,attrs = [{dodge,40}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(7,20) ->
	#base_cat_spirit{type = 7 ,lv = 20 ,attrs = [{att,120}],goods_id = 3710000 ,goods_num = 2 ,stage = 2 };
get(8,20) ->
	#base_cat_spirit{type = 8 ,lv = 20 ,attrs = [{hit,40},{dodge,40},{att,120}],goods_id = 3711000 ,goods_num = 4 ,stage = 2 };
get(1,21) ->
	#base_cat_spirit{type = 1 ,lv = 21 ,attrs = [{def,132}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,21) ->
	#base_cat_spirit{type = 2 ,lv = 21 ,attrs = [{hp_lim,1320}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,21) ->
	#base_cat_spirit{type = 3 ,lv = 21 ,attrs = [{crit,44}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,21) ->
	#base_cat_spirit{type = 4 ,lv = 21 ,attrs = [{ten,44}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,21) ->
	#base_cat_spirit{type = 5 ,lv = 21 ,attrs = [{hit,44}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,21) ->
	#base_cat_spirit{type = 6 ,lv = 21 ,attrs = [{dodge,44}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,21) ->
	#base_cat_spirit{type = 7 ,lv = 21 ,attrs = [{att,132}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,21) ->
	#base_cat_spirit{type = 8 ,lv = 21 ,attrs = [{hit,44},{dodge,44},{att,132}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,22) ->
	#base_cat_spirit{type = 1 ,lv = 22 ,attrs = [{def,144}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,22) ->
	#base_cat_spirit{type = 2 ,lv = 22 ,attrs = [{hp_lim,1440}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,22) ->
	#base_cat_spirit{type = 3 ,lv = 22 ,attrs = [{crit,48}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,22) ->
	#base_cat_spirit{type = 4 ,lv = 22 ,attrs = [{ten,48}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,22) ->
	#base_cat_spirit{type = 5 ,lv = 22 ,attrs = [{hit,48}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,22) ->
	#base_cat_spirit{type = 6 ,lv = 22 ,attrs = [{dodge,48}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,22) ->
	#base_cat_spirit{type = 7 ,lv = 22 ,attrs = [{att,144}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,22) ->
	#base_cat_spirit{type = 8 ,lv = 22 ,attrs = [{hit,48},{dodge,48},{att,144}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,23) ->
	#base_cat_spirit{type = 1 ,lv = 23 ,attrs = [{def,156}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,23) ->
	#base_cat_spirit{type = 2 ,lv = 23 ,attrs = [{hp_lim,1560}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,23) ->
	#base_cat_spirit{type = 3 ,lv = 23 ,attrs = [{crit,52}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,23) ->
	#base_cat_spirit{type = 4 ,lv = 23 ,attrs = [{ten,52}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,23) ->
	#base_cat_spirit{type = 5 ,lv = 23 ,attrs = [{hit,52}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,23) ->
	#base_cat_spirit{type = 6 ,lv = 23 ,attrs = [{dodge,52}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,23) ->
	#base_cat_spirit{type = 7 ,lv = 23 ,attrs = [{att,156}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,23) ->
	#base_cat_spirit{type = 8 ,lv = 23 ,attrs = [{hit,52},{dodge,52},{att,156}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,24) ->
	#base_cat_spirit{type = 1 ,lv = 24 ,attrs = [{def,168}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,24) ->
	#base_cat_spirit{type = 2 ,lv = 24 ,attrs = [{hp_lim,1680}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,24) ->
	#base_cat_spirit{type = 3 ,lv = 24 ,attrs = [{crit,56}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,24) ->
	#base_cat_spirit{type = 4 ,lv = 24 ,attrs = [{ten,56}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,24) ->
	#base_cat_spirit{type = 5 ,lv = 24 ,attrs = [{hit,56}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,24) ->
	#base_cat_spirit{type = 6 ,lv = 24 ,attrs = [{dodge,56}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,24) ->
	#base_cat_spirit{type = 7 ,lv = 24 ,attrs = [{att,168}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,24) ->
	#base_cat_spirit{type = 8 ,lv = 24 ,attrs = [{hit,56},{dodge,56},{att,168}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,25) ->
	#base_cat_spirit{type = 1 ,lv = 25 ,attrs = [{def,180}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,25) ->
	#base_cat_spirit{type = 2 ,lv = 25 ,attrs = [{hp_lim,1800}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,25) ->
	#base_cat_spirit{type = 3 ,lv = 25 ,attrs = [{crit,60}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,25) ->
	#base_cat_spirit{type = 4 ,lv = 25 ,attrs = [{ten,60}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,25) ->
	#base_cat_spirit{type = 5 ,lv = 25 ,attrs = [{hit,60}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,25) ->
	#base_cat_spirit{type = 6 ,lv = 25 ,attrs = [{dodge,60}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,25) ->
	#base_cat_spirit{type = 7 ,lv = 25 ,attrs = [{att,180}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,25) ->
	#base_cat_spirit{type = 8 ,lv = 25 ,attrs = [{hit,60},{dodge,60},{att,180}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,26) ->
	#base_cat_spirit{type = 1 ,lv = 26 ,attrs = [{def,192}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,26) ->
	#base_cat_spirit{type = 2 ,lv = 26 ,attrs = [{hp_lim,1920}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,26) ->
	#base_cat_spirit{type = 3 ,lv = 26 ,attrs = [{crit,64}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,26) ->
	#base_cat_spirit{type = 4 ,lv = 26 ,attrs = [{ten,64}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,26) ->
	#base_cat_spirit{type = 5 ,lv = 26 ,attrs = [{hit,64}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,26) ->
	#base_cat_spirit{type = 6 ,lv = 26 ,attrs = [{dodge,64}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,26) ->
	#base_cat_spirit{type = 7 ,lv = 26 ,attrs = [{att,192}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,26) ->
	#base_cat_spirit{type = 8 ,lv = 26 ,attrs = [{hit,64},{dodge,64},{att,192}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,27) ->
	#base_cat_spirit{type = 1 ,lv = 27 ,attrs = [{def,204}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,27) ->
	#base_cat_spirit{type = 2 ,lv = 27 ,attrs = [{hp_lim,2040}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,27) ->
	#base_cat_spirit{type = 3 ,lv = 27 ,attrs = [{crit,68}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,27) ->
	#base_cat_spirit{type = 4 ,lv = 27 ,attrs = [{ten,68}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,27) ->
	#base_cat_spirit{type = 5 ,lv = 27 ,attrs = [{hit,68}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,27) ->
	#base_cat_spirit{type = 6 ,lv = 27 ,attrs = [{dodge,68}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,27) ->
	#base_cat_spirit{type = 7 ,lv = 27 ,attrs = [{att,204}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,27) ->
	#base_cat_spirit{type = 8 ,lv = 27 ,attrs = [{hit,68},{dodge,68},{att,204}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,28) ->
	#base_cat_spirit{type = 1 ,lv = 28 ,attrs = [{def,216}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,28) ->
	#base_cat_spirit{type = 2 ,lv = 28 ,attrs = [{hp_lim,2160}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,28) ->
	#base_cat_spirit{type = 3 ,lv = 28 ,attrs = [{crit,72}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,28) ->
	#base_cat_spirit{type = 4 ,lv = 28 ,attrs = [{ten,72}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,28) ->
	#base_cat_spirit{type = 5 ,lv = 28 ,attrs = [{hit,72}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,28) ->
	#base_cat_spirit{type = 6 ,lv = 28 ,attrs = [{dodge,72}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,28) ->
	#base_cat_spirit{type = 7 ,lv = 28 ,attrs = [{att,216}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,28) ->
	#base_cat_spirit{type = 8 ,lv = 28 ,attrs = [{hit,72},{dodge,72},{att,216}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,29) ->
	#base_cat_spirit{type = 1 ,lv = 29 ,attrs = [{def,228}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,29) ->
	#base_cat_spirit{type = 2 ,lv = 29 ,attrs = [{hp_lim,2280}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,29) ->
	#base_cat_spirit{type = 3 ,lv = 29 ,attrs = [{crit,76}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,29) ->
	#base_cat_spirit{type = 4 ,lv = 29 ,attrs = [{ten,76}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,29) ->
	#base_cat_spirit{type = 5 ,lv = 29 ,attrs = [{hit,76}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,29) ->
	#base_cat_spirit{type = 6 ,lv = 29 ,attrs = [{dodge,76}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,29) ->
	#base_cat_spirit{type = 7 ,lv = 29 ,attrs = [{att,228}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,29) ->
	#base_cat_spirit{type = 8 ,lv = 29 ,attrs = [{hit,76},{dodge,76},{att,228}],goods_id = 3710000 ,goods_num = 9 ,stage = 3 };
get(1,30) ->
	#base_cat_spirit{type = 1 ,lv = 30 ,attrs = [{def,240}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(2,30) ->
	#base_cat_spirit{type = 2 ,lv = 30 ,attrs = [{hp_lim,2400}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(3,30) ->
	#base_cat_spirit{type = 3 ,lv = 30 ,attrs = [{crit,80}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(4,30) ->
	#base_cat_spirit{type = 4 ,lv = 30 ,attrs = [{ten,80}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(5,30) ->
	#base_cat_spirit{type = 5 ,lv = 30 ,attrs = [{hit,80}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(6,30) ->
	#base_cat_spirit{type = 6 ,lv = 30 ,attrs = [{dodge,80}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(7,30) ->
	#base_cat_spirit{type = 7 ,lv = 30 ,attrs = [{att,240}],goods_id = 3710000 ,goods_num = 3 ,stage = 3 };
get(8,30) ->
	#base_cat_spirit{type = 8 ,lv = 30 ,attrs = [{hit,80},{dodge,80},{att,240}],goods_id = 3711000 ,goods_num = 6 ,stage = 3 };
get(1,31) ->
	#base_cat_spirit{type = 1 ,lv = 31 ,attrs = [{def,256}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,31) ->
	#base_cat_spirit{type = 2 ,lv = 31 ,attrs = [{hp_lim,2560}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,31) ->
	#base_cat_spirit{type = 3 ,lv = 31 ,attrs = [{crit,85}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,31) ->
	#base_cat_spirit{type = 4 ,lv = 31 ,attrs = [{ten,85}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,31) ->
	#base_cat_spirit{type = 5 ,lv = 31 ,attrs = [{hit,85}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,31) ->
	#base_cat_spirit{type = 6 ,lv = 31 ,attrs = [{dodge,85}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,31) ->
	#base_cat_spirit{type = 7 ,lv = 31 ,attrs = [{att,256}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,31) ->
	#base_cat_spirit{type = 8 ,lv = 31 ,attrs = [{hit,85},{dodge,85},{att,256}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,32) ->
	#base_cat_spirit{type = 1 ,lv = 32 ,attrs = [{def,272}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,32) ->
	#base_cat_spirit{type = 2 ,lv = 32 ,attrs = [{hp_lim,2720}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,32) ->
	#base_cat_spirit{type = 3 ,lv = 32 ,attrs = [{crit,90}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,32) ->
	#base_cat_spirit{type = 4 ,lv = 32 ,attrs = [{ten,90}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,32) ->
	#base_cat_spirit{type = 5 ,lv = 32 ,attrs = [{hit,90}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,32) ->
	#base_cat_spirit{type = 6 ,lv = 32 ,attrs = [{dodge,90}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,32) ->
	#base_cat_spirit{type = 7 ,lv = 32 ,attrs = [{att,272}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,32) ->
	#base_cat_spirit{type = 8 ,lv = 32 ,attrs = [{hit,90},{dodge,90},{att,272}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,33) ->
	#base_cat_spirit{type = 1 ,lv = 33 ,attrs = [{def,288}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,33) ->
	#base_cat_spirit{type = 2 ,lv = 33 ,attrs = [{hp_lim,2880}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,33) ->
	#base_cat_spirit{type = 3 ,lv = 33 ,attrs = [{crit,95}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,33) ->
	#base_cat_spirit{type = 4 ,lv = 33 ,attrs = [{ten,95}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,33) ->
	#base_cat_spirit{type = 5 ,lv = 33 ,attrs = [{hit,95}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,33) ->
	#base_cat_spirit{type = 6 ,lv = 33 ,attrs = [{dodge,95}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,33) ->
	#base_cat_spirit{type = 7 ,lv = 33 ,attrs = [{att,288}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,33) ->
	#base_cat_spirit{type = 8 ,lv = 33 ,attrs = [{hit,95},{dodge,95},{att,288}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,34) ->
	#base_cat_spirit{type = 1 ,lv = 34 ,attrs = [{def,304}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,34) ->
	#base_cat_spirit{type = 2 ,lv = 34 ,attrs = [{hp_lim,3040}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,34) ->
	#base_cat_spirit{type = 3 ,lv = 34 ,attrs = [{crit,100}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,34) ->
	#base_cat_spirit{type = 4 ,lv = 34 ,attrs = [{ten,100}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,34) ->
	#base_cat_spirit{type = 5 ,lv = 34 ,attrs = [{hit,100}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,34) ->
	#base_cat_spirit{type = 6 ,lv = 34 ,attrs = [{dodge,100}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,34) ->
	#base_cat_spirit{type = 7 ,lv = 34 ,attrs = [{att,304}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,34) ->
	#base_cat_spirit{type = 8 ,lv = 34 ,attrs = [{hit,100},{dodge,100},{att,304}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,35) ->
	#base_cat_spirit{type = 1 ,lv = 35 ,attrs = [{def,320}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,35) ->
	#base_cat_spirit{type = 2 ,lv = 35 ,attrs = [{hp_lim,3200}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,35) ->
	#base_cat_spirit{type = 3 ,lv = 35 ,attrs = [{crit,105}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,35) ->
	#base_cat_spirit{type = 4 ,lv = 35 ,attrs = [{ten,105}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,35) ->
	#base_cat_spirit{type = 5 ,lv = 35 ,attrs = [{hit,105}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,35) ->
	#base_cat_spirit{type = 6 ,lv = 35 ,attrs = [{dodge,105}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,35) ->
	#base_cat_spirit{type = 7 ,lv = 35 ,attrs = [{att,320}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,35) ->
	#base_cat_spirit{type = 8 ,lv = 35 ,attrs = [{hit,105},{dodge,105},{att,320}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,36) ->
	#base_cat_spirit{type = 1 ,lv = 36 ,attrs = [{def,336}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,36) ->
	#base_cat_spirit{type = 2 ,lv = 36 ,attrs = [{hp_lim,3360}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,36) ->
	#base_cat_spirit{type = 3 ,lv = 36 ,attrs = [{crit,110}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,36) ->
	#base_cat_spirit{type = 4 ,lv = 36 ,attrs = [{ten,110}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,36) ->
	#base_cat_spirit{type = 5 ,lv = 36 ,attrs = [{hit,110}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,36) ->
	#base_cat_spirit{type = 6 ,lv = 36 ,attrs = [{dodge,110}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,36) ->
	#base_cat_spirit{type = 7 ,lv = 36 ,attrs = [{att,336}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,36) ->
	#base_cat_spirit{type = 8 ,lv = 36 ,attrs = [{hit,110},{dodge,110},{att,336}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,37) ->
	#base_cat_spirit{type = 1 ,lv = 37 ,attrs = [{def,352}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,37) ->
	#base_cat_spirit{type = 2 ,lv = 37 ,attrs = [{hp_lim,3520}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,37) ->
	#base_cat_spirit{type = 3 ,lv = 37 ,attrs = [{crit,115}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,37) ->
	#base_cat_spirit{type = 4 ,lv = 37 ,attrs = [{ten,115}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,37) ->
	#base_cat_spirit{type = 5 ,lv = 37 ,attrs = [{hit,115}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,37) ->
	#base_cat_spirit{type = 6 ,lv = 37 ,attrs = [{dodge,115}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,37) ->
	#base_cat_spirit{type = 7 ,lv = 37 ,attrs = [{att,352}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,37) ->
	#base_cat_spirit{type = 8 ,lv = 37 ,attrs = [{hit,115},{dodge,115},{att,352}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,38) ->
	#base_cat_spirit{type = 1 ,lv = 38 ,attrs = [{def,368}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,38) ->
	#base_cat_spirit{type = 2 ,lv = 38 ,attrs = [{hp_lim,3680}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,38) ->
	#base_cat_spirit{type = 3 ,lv = 38 ,attrs = [{crit,120}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,38) ->
	#base_cat_spirit{type = 4 ,lv = 38 ,attrs = [{ten,120}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,38) ->
	#base_cat_spirit{type = 5 ,lv = 38 ,attrs = [{hit,120}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,38) ->
	#base_cat_spirit{type = 6 ,lv = 38 ,attrs = [{dodge,120}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,38) ->
	#base_cat_spirit{type = 7 ,lv = 38 ,attrs = [{att,368}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,38) ->
	#base_cat_spirit{type = 8 ,lv = 38 ,attrs = [{hit,120},{dodge,120},{att,368}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,39) ->
	#base_cat_spirit{type = 1 ,lv = 39 ,attrs = [{def,384}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,39) ->
	#base_cat_spirit{type = 2 ,lv = 39 ,attrs = [{hp_lim,3840}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,39) ->
	#base_cat_spirit{type = 3 ,lv = 39 ,attrs = [{crit,125}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,39) ->
	#base_cat_spirit{type = 4 ,lv = 39 ,attrs = [{ten,125}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,39) ->
	#base_cat_spirit{type = 5 ,lv = 39 ,attrs = [{hit,125}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,39) ->
	#base_cat_spirit{type = 6 ,lv = 39 ,attrs = [{dodge,125}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,39) ->
	#base_cat_spirit{type = 7 ,lv = 39 ,attrs = [{att,384}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,39) ->
	#base_cat_spirit{type = 8 ,lv = 39 ,attrs = [{hit,125},{dodge,125},{att,384}],goods_id = 3710000 ,goods_num = 12 ,stage = 4 };
get(1,40) ->
	#base_cat_spirit{type = 1 ,lv = 40 ,attrs = [{def,400}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(2,40) ->
	#base_cat_spirit{type = 2 ,lv = 40 ,attrs = [{hp_lim,4000}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(3,40) ->
	#base_cat_spirit{type = 3 ,lv = 40 ,attrs = [{crit,130}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(4,40) ->
	#base_cat_spirit{type = 4 ,lv = 40 ,attrs = [{ten,130}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(5,40) ->
	#base_cat_spirit{type = 5 ,lv = 40 ,attrs = [{hit,130}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(6,40) ->
	#base_cat_spirit{type = 6 ,lv = 40 ,attrs = [{dodge,130}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(7,40) ->
	#base_cat_spirit{type = 7 ,lv = 40 ,attrs = [{att,400}],goods_id = 3710000 ,goods_num = 4 ,stage = 4 };
get(8,40) ->
	#base_cat_spirit{type = 8 ,lv = 40 ,attrs = [{hit,130},{dodge,130},{att,400}],goods_id = 3711000 ,goods_num = 8 ,stage = 4 };
get(1,41) ->
	#base_cat_spirit{type = 1 ,lv = 41 ,attrs = [{def,420}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,41) ->
	#base_cat_spirit{type = 2 ,lv = 41 ,attrs = [{hp_lim,4200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,41) ->
	#base_cat_spirit{type = 3 ,lv = 41 ,attrs = [{crit,137}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,41) ->
	#base_cat_spirit{type = 4 ,lv = 41 ,attrs = [{ten,137}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,41) ->
	#base_cat_spirit{type = 5 ,lv = 41 ,attrs = [{hit,137}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,41) ->
	#base_cat_spirit{type = 6 ,lv = 41 ,attrs = [{dodge,137}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,41) ->
	#base_cat_spirit{type = 7 ,lv = 41 ,attrs = [{att,420}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,41) ->
	#base_cat_spirit{type = 8 ,lv = 41 ,attrs = [{hit,137},{dodge,137},{att,420}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,42) ->
	#base_cat_spirit{type = 1 ,lv = 42 ,attrs = [{def,440}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,42) ->
	#base_cat_spirit{type = 2 ,lv = 42 ,attrs = [{hp_lim,4400}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,42) ->
	#base_cat_spirit{type = 3 ,lv = 42 ,attrs = [{crit,144}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,42) ->
	#base_cat_spirit{type = 4 ,lv = 42 ,attrs = [{ten,144}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,42) ->
	#base_cat_spirit{type = 5 ,lv = 42 ,attrs = [{hit,144}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,42) ->
	#base_cat_spirit{type = 6 ,lv = 42 ,attrs = [{dodge,144}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,42) ->
	#base_cat_spirit{type = 7 ,lv = 42 ,attrs = [{att,440}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,42) ->
	#base_cat_spirit{type = 8 ,lv = 42 ,attrs = [{hit,144},{dodge,144},{att,440}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,43) ->
	#base_cat_spirit{type = 1 ,lv = 43 ,attrs = [{def,460}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,43) ->
	#base_cat_spirit{type = 2 ,lv = 43 ,attrs = [{hp_lim,4600}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,43) ->
	#base_cat_spirit{type = 3 ,lv = 43 ,attrs = [{crit,151}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,43) ->
	#base_cat_spirit{type = 4 ,lv = 43 ,attrs = [{ten,151}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,43) ->
	#base_cat_spirit{type = 5 ,lv = 43 ,attrs = [{hit,151}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,43) ->
	#base_cat_spirit{type = 6 ,lv = 43 ,attrs = [{dodge,151}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,43) ->
	#base_cat_spirit{type = 7 ,lv = 43 ,attrs = [{att,460}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,43) ->
	#base_cat_spirit{type = 8 ,lv = 43 ,attrs = [{hit,151},{dodge,151},{att,460}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,44) ->
	#base_cat_spirit{type = 1 ,lv = 44 ,attrs = [{def,480}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,44) ->
	#base_cat_spirit{type = 2 ,lv = 44 ,attrs = [{hp_lim,4800}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,44) ->
	#base_cat_spirit{type = 3 ,lv = 44 ,attrs = [{crit,158}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,44) ->
	#base_cat_spirit{type = 4 ,lv = 44 ,attrs = [{ten,158}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,44) ->
	#base_cat_spirit{type = 5 ,lv = 44 ,attrs = [{hit,158}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,44) ->
	#base_cat_spirit{type = 6 ,lv = 44 ,attrs = [{dodge,158}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,44) ->
	#base_cat_spirit{type = 7 ,lv = 44 ,attrs = [{att,480}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,44) ->
	#base_cat_spirit{type = 8 ,lv = 44 ,attrs = [{hit,158},{dodge,158},{att,480}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,45) ->
	#base_cat_spirit{type = 1 ,lv = 45 ,attrs = [{def,500}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,45) ->
	#base_cat_spirit{type = 2 ,lv = 45 ,attrs = [{hp_lim,5000}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,45) ->
	#base_cat_spirit{type = 3 ,lv = 45 ,attrs = [{crit,165}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,45) ->
	#base_cat_spirit{type = 4 ,lv = 45 ,attrs = [{ten,165}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,45) ->
	#base_cat_spirit{type = 5 ,lv = 45 ,attrs = [{hit,165}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,45) ->
	#base_cat_spirit{type = 6 ,lv = 45 ,attrs = [{dodge,165}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,45) ->
	#base_cat_spirit{type = 7 ,lv = 45 ,attrs = [{att,500}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,45) ->
	#base_cat_spirit{type = 8 ,lv = 45 ,attrs = [{hit,165},{dodge,165},{att,500}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,46) ->
	#base_cat_spirit{type = 1 ,lv = 46 ,attrs = [{def,520}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,46) ->
	#base_cat_spirit{type = 2 ,lv = 46 ,attrs = [{hp_lim,5200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,46) ->
	#base_cat_spirit{type = 3 ,lv = 46 ,attrs = [{crit,172}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,46) ->
	#base_cat_spirit{type = 4 ,lv = 46 ,attrs = [{ten,172}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,46) ->
	#base_cat_spirit{type = 5 ,lv = 46 ,attrs = [{hit,172}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,46) ->
	#base_cat_spirit{type = 6 ,lv = 46 ,attrs = [{dodge,172}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,46) ->
	#base_cat_spirit{type = 7 ,lv = 46 ,attrs = [{att,520}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,46) ->
	#base_cat_spirit{type = 8 ,lv = 46 ,attrs = [{hit,172},{dodge,172},{att,520}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,47) ->
	#base_cat_spirit{type = 1 ,lv = 47 ,attrs = [{def,540}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,47) ->
	#base_cat_spirit{type = 2 ,lv = 47 ,attrs = [{hp_lim,5400}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,47) ->
	#base_cat_spirit{type = 3 ,lv = 47 ,attrs = [{crit,179}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,47) ->
	#base_cat_spirit{type = 4 ,lv = 47 ,attrs = [{ten,179}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,47) ->
	#base_cat_spirit{type = 5 ,lv = 47 ,attrs = [{hit,179}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,47) ->
	#base_cat_spirit{type = 6 ,lv = 47 ,attrs = [{dodge,179}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,47) ->
	#base_cat_spirit{type = 7 ,lv = 47 ,attrs = [{att,540}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,47) ->
	#base_cat_spirit{type = 8 ,lv = 47 ,attrs = [{hit,179},{dodge,179},{att,540}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,48) ->
	#base_cat_spirit{type = 1 ,lv = 48 ,attrs = [{def,560}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,48) ->
	#base_cat_spirit{type = 2 ,lv = 48 ,attrs = [{hp_lim,5600}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,48) ->
	#base_cat_spirit{type = 3 ,lv = 48 ,attrs = [{crit,186}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,48) ->
	#base_cat_spirit{type = 4 ,lv = 48 ,attrs = [{ten,186}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,48) ->
	#base_cat_spirit{type = 5 ,lv = 48 ,attrs = [{hit,186}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,48) ->
	#base_cat_spirit{type = 6 ,lv = 48 ,attrs = [{dodge,186}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,48) ->
	#base_cat_spirit{type = 7 ,lv = 48 ,attrs = [{att,560}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,48) ->
	#base_cat_spirit{type = 8 ,lv = 48 ,attrs = [{hit,186},{dodge,186},{att,560}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,49) ->
	#base_cat_spirit{type = 1 ,lv = 49 ,attrs = [{def,580}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,49) ->
	#base_cat_spirit{type = 2 ,lv = 49 ,attrs = [{hp_lim,5800}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,49) ->
	#base_cat_spirit{type = 3 ,lv = 49 ,attrs = [{crit,193}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,49) ->
	#base_cat_spirit{type = 4 ,lv = 49 ,attrs = [{ten,193}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,49) ->
	#base_cat_spirit{type = 5 ,lv = 49 ,attrs = [{hit,193}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,49) ->
	#base_cat_spirit{type = 6 ,lv = 49 ,attrs = [{dodge,193}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,49) ->
	#base_cat_spirit{type = 7 ,lv = 49 ,attrs = [{att,580}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,49) ->
	#base_cat_spirit{type = 8 ,lv = 49 ,attrs = [{hit,193},{dodge,193},{att,580}],goods_id = 3710000 ,goods_num = 15 ,stage = 5 };
get(1,50) ->
	#base_cat_spirit{type = 1 ,lv = 50 ,attrs = [{def,600}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(2,50) ->
	#base_cat_spirit{type = 2 ,lv = 50 ,attrs = [{hp_lim,6000}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(3,50) ->
	#base_cat_spirit{type = 3 ,lv = 50 ,attrs = [{crit,200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(4,50) ->
	#base_cat_spirit{type = 4 ,lv = 50 ,attrs = [{ten,200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(5,50) ->
	#base_cat_spirit{type = 5 ,lv = 50 ,attrs = [{hit,200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(6,50) ->
	#base_cat_spirit{type = 6 ,lv = 50 ,attrs = [{dodge,200}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(7,50) ->
	#base_cat_spirit{type = 7 ,lv = 50 ,attrs = [{att,600}],goods_id = 3710000 ,goods_num = 5 ,stage = 5 };
get(8,50) ->
	#base_cat_spirit{type = 8 ,lv = 50 ,attrs = [{hit,200},{dodge,200},{att,600}],goods_id = 3711000 ,goods_num = 10 ,stage = 5 };
get(1,51) ->
	#base_cat_spirit{type = 1 ,lv = 51 ,attrs = [{def,624}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,51) ->
	#base_cat_spirit{type = 2 ,lv = 51 ,attrs = [{hp_lim,6240}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,51) ->
	#base_cat_spirit{type = 3 ,lv = 51 ,attrs = [{crit,208}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,51) ->
	#base_cat_spirit{type = 4 ,lv = 51 ,attrs = [{ten,208}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,51) ->
	#base_cat_spirit{type = 5 ,lv = 51 ,attrs = [{hit,208}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,51) ->
	#base_cat_spirit{type = 6 ,lv = 51 ,attrs = [{dodge,208}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,51) ->
	#base_cat_spirit{type = 7 ,lv = 51 ,attrs = [{att,624}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,51) ->
	#base_cat_spirit{type = 8 ,lv = 51 ,attrs = [{hit,208},{dodge,208},{att,624}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,52) ->
	#base_cat_spirit{type = 1 ,lv = 52 ,attrs = [{def,648}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,52) ->
	#base_cat_spirit{type = 2 ,lv = 52 ,attrs = [{hp_lim,6480}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,52) ->
	#base_cat_spirit{type = 3 ,lv = 52 ,attrs = [{crit,216}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,52) ->
	#base_cat_spirit{type = 4 ,lv = 52 ,attrs = [{ten,216}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,52) ->
	#base_cat_spirit{type = 5 ,lv = 52 ,attrs = [{hit,216}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,52) ->
	#base_cat_spirit{type = 6 ,lv = 52 ,attrs = [{dodge,216}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,52) ->
	#base_cat_spirit{type = 7 ,lv = 52 ,attrs = [{att,648}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,52) ->
	#base_cat_spirit{type = 8 ,lv = 52 ,attrs = [{hit,216},{dodge,216},{att,648}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,53) ->
	#base_cat_spirit{type = 1 ,lv = 53 ,attrs = [{def,672}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,53) ->
	#base_cat_spirit{type = 2 ,lv = 53 ,attrs = [{hp_lim,6720}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,53) ->
	#base_cat_spirit{type = 3 ,lv = 53 ,attrs = [{crit,224}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,53) ->
	#base_cat_spirit{type = 4 ,lv = 53 ,attrs = [{ten,224}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,53) ->
	#base_cat_spirit{type = 5 ,lv = 53 ,attrs = [{hit,224}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,53) ->
	#base_cat_spirit{type = 6 ,lv = 53 ,attrs = [{dodge,224}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,53) ->
	#base_cat_spirit{type = 7 ,lv = 53 ,attrs = [{att,672}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,53) ->
	#base_cat_spirit{type = 8 ,lv = 53 ,attrs = [{hit,224},{dodge,224},{att,672}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,54) ->
	#base_cat_spirit{type = 1 ,lv = 54 ,attrs = [{def,696}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,54) ->
	#base_cat_spirit{type = 2 ,lv = 54 ,attrs = [{hp_lim,6960}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,54) ->
	#base_cat_spirit{type = 3 ,lv = 54 ,attrs = [{crit,232}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,54) ->
	#base_cat_spirit{type = 4 ,lv = 54 ,attrs = [{ten,232}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,54) ->
	#base_cat_spirit{type = 5 ,lv = 54 ,attrs = [{hit,232}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,54) ->
	#base_cat_spirit{type = 6 ,lv = 54 ,attrs = [{dodge,232}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,54) ->
	#base_cat_spirit{type = 7 ,lv = 54 ,attrs = [{att,696}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,54) ->
	#base_cat_spirit{type = 8 ,lv = 54 ,attrs = [{hit,232},{dodge,232},{att,696}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,55) ->
	#base_cat_spirit{type = 1 ,lv = 55 ,attrs = [{def,720}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,55) ->
	#base_cat_spirit{type = 2 ,lv = 55 ,attrs = [{hp_lim,7200}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,55) ->
	#base_cat_spirit{type = 3 ,lv = 55 ,attrs = [{crit,240}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,55) ->
	#base_cat_spirit{type = 4 ,lv = 55 ,attrs = [{ten,240}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,55) ->
	#base_cat_spirit{type = 5 ,lv = 55 ,attrs = [{hit,240}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,55) ->
	#base_cat_spirit{type = 6 ,lv = 55 ,attrs = [{dodge,240}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,55) ->
	#base_cat_spirit{type = 7 ,lv = 55 ,attrs = [{att,720}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,55) ->
	#base_cat_spirit{type = 8 ,lv = 55 ,attrs = [{hit,240},{dodge,240},{att,720}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,56) ->
	#base_cat_spirit{type = 1 ,lv = 56 ,attrs = [{def,744}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,56) ->
	#base_cat_spirit{type = 2 ,lv = 56 ,attrs = [{hp_lim,7440}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,56) ->
	#base_cat_spirit{type = 3 ,lv = 56 ,attrs = [{crit,248}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,56) ->
	#base_cat_spirit{type = 4 ,lv = 56 ,attrs = [{ten,248}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,56) ->
	#base_cat_spirit{type = 5 ,lv = 56 ,attrs = [{hit,248}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,56) ->
	#base_cat_spirit{type = 6 ,lv = 56 ,attrs = [{dodge,248}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,56) ->
	#base_cat_spirit{type = 7 ,lv = 56 ,attrs = [{att,744}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,56) ->
	#base_cat_spirit{type = 8 ,lv = 56 ,attrs = [{hit,248},{dodge,248},{att,744}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,57) ->
	#base_cat_spirit{type = 1 ,lv = 57 ,attrs = [{def,768}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,57) ->
	#base_cat_spirit{type = 2 ,lv = 57 ,attrs = [{hp_lim,7680}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,57) ->
	#base_cat_spirit{type = 3 ,lv = 57 ,attrs = [{crit,256}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,57) ->
	#base_cat_spirit{type = 4 ,lv = 57 ,attrs = [{ten,256}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,57) ->
	#base_cat_spirit{type = 5 ,lv = 57 ,attrs = [{hit,256}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,57) ->
	#base_cat_spirit{type = 6 ,lv = 57 ,attrs = [{dodge,256}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,57) ->
	#base_cat_spirit{type = 7 ,lv = 57 ,attrs = [{att,768}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,57) ->
	#base_cat_spirit{type = 8 ,lv = 57 ,attrs = [{hit,256},{dodge,256},{att,768}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,58) ->
	#base_cat_spirit{type = 1 ,lv = 58 ,attrs = [{def,792}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,58) ->
	#base_cat_spirit{type = 2 ,lv = 58 ,attrs = [{hp_lim,7920}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,58) ->
	#base_cat_spirit{type = 3 ,lv = 58 ,attrs = [{crit,264}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,58) ->
	#base_cat_spirit{type = 4 ,lv = 58 ,attrs = [{ten,264}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,58) ->
	#base_cat_spirit{type = 5 ,lv = 58 ,attrs = [{hit,264}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,58) ->
	#base_cat_spirit{type = 6 ,lv = 58 ,attrs = [{dodge,264}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,58) ->
	#base_cat_spirit{type = 7 ,lv = 58 ,attrs = [{att,792}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,58) ->
	#base_cat_spirit{type = 8 ,lv = 58 ,attrs = [{hit,264},{dodge,264},{att,792}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,59) ->
	#base_cat_spirit{type = 1 ,lv = 59 ,attrs = [{def,816}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,59) ->
	#base_cat_spirit{type = 2 ,lv = 59 ,attrs = [{hp_lim,8160}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,59) ->
	#base_cat_spirit{type = 3 ,lv = 59 ,attrs = [{crit,272}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,59) ->
	#base_cat_spirit{type = 4 ,lv = 59 ,attrs = [{ten,272}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,59) ->
	#base_cat_spirit{type = 5 ,lv = 59 ,attrs = [{hit,272}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,59) ->
	#base_cat_spirit{type = 6 ,lv = 59 ,attrs = [{dodge,272}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,59) ->
	#base_cat_spirit{type = 7 ,lv = 59 ,attrs = [{att,816}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,59) ->
	#base_cat_spirit{type = 8 ,lv = 59 ,attrs = [{hit,272},{dodge,272},{att,816}],goods_id = 3710000 ,goods_num = 18 ,stage = 6 };
get(1,60) ->
	#base_cat_spirit{type = 1 ,lv = 60 ,attrs = [{def,840}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(2,60) ->
	#base_cat_spirit{type = 2 ,lv = 60 ,attrs = [{hp_lim,8400}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(3,60) ->
	#base_cat_spirit{type = 3 ,lv = 60 ,attrs = [{crit,280}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(4,60) ->
	#base_cat_spirit{type = 4 ,lv = 60 ,attrs = [{ten,280}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(5,60) ->
	#base_cat_spirit{type = 5 ,lv = 60 ,attrs = [{hit,280}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(6,60) ->
	#base_cat_spirit{type = 6 ,lv = 60 ,attrs = [{dodge,280}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(7,60) ->
	#base_cat_spirit{type = 7 ,lv = 60 ,attrs = [{att,840}],goods_id = 3710000 ,goods_num = 6 ,stage = 6 };
get(8,60) ->
	#base_cat_spirit{type = 8 ,lv = 60 ,attrs = [{hit,280},{dodge,280},{att,840}],goods_id = 3711000 ,goods_num = 12 ,stage = 6 };
get(1,61) ->
	#base_cat_spirit{type = 1 ,lv = 61 ,attrs = [{def,868}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,61) ->
	#base_cat_spirit{type = 2 ,lv = 61 ,attrs = [{hp_lim,8680}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,61) ->
	#base_cat_spirit{type = 3 ,lv = 61 ,attrs = [{crit,289}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,61) ->
	#base_cat_spirit{type = 4 ,lv = 61 ,attrs = [{ten,289}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,61) ->
	#base_cat_spirit{type = 5 ,lv = 61 ,attrs = [{hit,289}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,61) ->
	#base_cat_spirit{type = 6 ,lv = 61 ,attrs = [{dodge,289}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,61) ->
	#base_cat_spirit{type = 7 ,lv = 61 ,attrs = [{att,868}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,61) ->
	#base_cat_spirit{type = 8 ,lv = 61 ,attrs = [{hit,289},{dodge,289},{att,868}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,62) ->
	#base_cat_spirit{type = 1 ,lv = 62 ,attrs = [{def,896}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,62) ->
	#base_cat_spirit{type = 2 ,lv = 62 ,attrs = [{hp_lim,8960}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,62) ->
	#base_cat_spirit{type = 3 ,lv = 62 ,attrs = [{crit,298}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,62) ->
	#base_cat_spirit{type = 4 ,lv = 62 ,attrs = [{ten,298}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,62) ->
	#base_cat_spirit{type = 5 ,lv = 62 ,attrs = [{hit,298}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,62) ->
	#base_cat_spirit{type = 6 ,lv = 62 ,attrs = [{dodge,298}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,62) ->
	#base_cat_spirit{type = 7 ,lv = 62 ,attrs = [{att,896}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,62) ->
	#base_cat_spirit{type = 8 ,lv = 62 ,attrs = [{hit,298},{dodge,298},{att,896}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,63) ->
	#base_cat_spirit{type = 1 ,lv = 63 ,attrs = [{def,924}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,63) ->
	#base_cat_spirit{type = 2 ,lv = 63 ,attrs = [{hp_lim,9240}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,63) ->
	#base_cat_spirit{type = 3 ,lv = 63 ,attrs = [{crit,307}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,63) ->
	#base_cat_spirit{type = 4 ,lv = 63 ,attrs = [{ten,307}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,63) ->
	#base_cat_spirit{type = 5 ,lv = 63 ,attrs = [{hit,307}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,63) ->
	#base_cat_spirit{type = 6 ,lv = 63 ,attrs = [{dodge,307}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,63) ->
	#base_cat_spirit{type = 7 ,lv = 63 ,attrs = [{att,924}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,63) ->
	#base_cat_spirit{type = 8 ,lv = 63 ,attrs = [{hit,307},{dodge,307},{att,924}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,64) ->
	#base_cat_spirit{type = 1 ,lv = 64 ,attrs = [{def,952}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,64) ->
	#base_cat_spirit{type = 2 ,lv = 64 ,attrs = [{hp_lim,9520}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,64) ->
	#base_cat_spirit{type = 3 ,lv = 64 ,attrs = [{crit,316}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,64) ->
	#base_cat_spirit{type = 4 ,lv = 64 ,attrs = [{ten,316}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,64) ->
	#base_cat_spirit{type = 5 ,lv = 64 ,attrs = [{hit,316}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,64) ->
	#base_cat_spirit{type = 6 ,lv = 64 ,attrs = [{dodge,316}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,64) ->
	#base_cat_spirit{type = 7 ,lv = 64 ,attrs = [{att,952}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,64) ->
	#base_cat_spirit{type = 8 ,lv = 64 ,attrs = [{hit,316},{dodge,316},{att,952}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,65) ->
	#base_cat_spirit{type = 1 ,lv = 65 ,attrs = [{def,980}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,65) ->
	#base_cat_spirit{type = 2 ,lv = 65 ,attrs = [{hp_lim,9800}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,65) ->
	#base_cat_spirit{type = 3 ,lv = 65 ,attrs = [{crit,325}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,65) ->
	#base_cat_spirit{type = 4 ,lv = 65 ,attrs = [{ten,325}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,65) ->
	#base_cat_spirit{type = 5 ,lv = 65 ,attrs = [{hit,325}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,65) ->
	#base_cat_spirit{type = 6 ,lv = 65 ,attrs = [{dodge,325}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,65) ->
	#base_cat_spirit{type = 7 ,lv = 65 ,attrs = [{att,980}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,65) ->
	#base_cat_spirit{type = 8 ,lv = 65 ,attrs = [{hit,325},{dodge,325},{att,980}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,66) ->
	#base_cat_spirit{type = 1 ,lv = 66 ,attrs = [{def,1008}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,66) ->
	#base_cat_spirit{type = 2 ,lv = 66 ,attrs = [{hp_lim,10080}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,66) ->
	#base_cat_spirit{type = 3 ,lv = 66 ,attrs = [{crit,334}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,66) ->
	#base_cat_spirit{type = 4 ,lv = 66 ,attrs = [{ten,334}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,66) ->
	#base_cat_spirit{type = 5 ,lv = 66 ,attrs = [{hit,334}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,66) ->
	#base_cat_spirit{type = 6 ,lv = 66 ,attrs = [{dodge,334}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,66) ->
	#base_cat_spirit{type = 7 ,lv = 66 ,attrs = [{att,1008}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,66) ->
	#base_cat_spirit{type = 8 ,lv = 66 ,attrs = [{hit,334},{dodge,334},{att,1008}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,67) ->
	#base_cat_spirit{type = 1 ,lv = 67 ,attrs = [{def,1036}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,67) ->
	#base_cat_spirit{type = 2 ,lv = 67 ,attrs = [{hp_lim,10360}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,67) ->
	#base_cat_spirit{type = 3 ,lv = 67 ,attrs = [{crit,343}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,67) ->
	#base_cat_spirit{type = 4 ,lv = 67 ,attrs = [{ten,343}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,67) ->
	#base_cat_spirit{type = 5 ,lv = 67 ,attrs = [{hit,343}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,67) ->
	#base_cat_spirit{type = 6 ,lv = 67 ,attrs = [{dodge,343}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,67) ->
	#base_cat_spirit{type = 7 ,lv = 67 ,attrs = [{att,1036}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,67) ->
	#base_cat_spirit{type = 8 ,lv = 67 ,attrs = [{hit,343},{dodge,343},{att,1036}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,68) ->
	#base_cat_spirit{type = 1 ,lv = 68 ,attrs = [{def,1064}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,68) ->
	#base_cat_spirit{type = 2 ,lv = 68 ,attrs = [{hp_lim,10640}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,68) ->
	#base_cat_spirit{type = 3 ,lv = 68 ,attrs = [{crit,352}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,68) ->
	#base_cat_spirit{type = 4 ,lv = 68 ,attrs = [{ten,352}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,68) ->
	#base_cat_spirit{type = 5 ,lv = 68 ,attrs = [{hit,352}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,68) ->
	#base_cat_spirit{type = 6 ,lv = 68 ,attrs = [{dodge,352}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,68) ->
	#base_cat_spirit{type = 7 ,lv = 68 ,attrs = [{att,1064}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,68) ->
	#base_cat_spirit{type = 8 ,lv = 68 ,attrs = [{hit,352},{dodge,352},{att,1064}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,69) ->
	#base_cat_spirit{type = 1 ,lv = 69 ,attrs = [{def,1092}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,69) ->
	#base_cat_spirit{type = 2 ,lv = 69 ,attrs = [{hp_lim,10920}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,69) ->
	#base_cat_spirit{type = 3 ,lv = 69 ,attrs = [{crit,361}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,69) ->
	#base_cat_spirit{type = 4 ,lv = 69 ,attrs = [{ten,361}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,69) ->
	#base_cat_spirit{type = 5 ,lv = 69 ,attrs = [{hit,361}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,69) ->
	#base_cat_spirit{type = 6 ,lv = 69 ,attrs = [{dodge,361}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,69) ->
	#base_cat_spirit{type = 7 ,lv = 69 ,attrs = [{att,1092}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,69) ->
	#base_cat_spirit{type = 8 ,lv = 69 ,attrs = [{hit,361},{dodge,361},{att,1092}],goods_id = 3710000 ,goods_num = 21 ,stage = 7 };
get(1,70) ->
	#base_cat_spirit{type = 1 ,lv = 70 ,attrs = [{def,1120}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(2,70) ->
	#base_cat_spirit{type = 2 ,lv = 70 ,attrs = [{hp_lim,11200}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(3,70) ->
	#base_cat_spirit{type = 3 ,lv = 70 ,attrs = [{crit,370}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(4,70) ->
	#base_cat_spirit{type = 4 ,lv = 70 ,attrs = [{ten,370}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(5,70) ->
	#base_cat_spirit{type = 5 ,lv = 70 ,attrs = [{hit,370}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(6,70) ->
	#base_cat_spirit{type = 6 ,lv = 70 ,attrs = [{dodge,370}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(7,70) ->
	#base_cat_spirit{type = 7 ,lv = 70 ,attrs = [{att,1120}],goods_id = 3710000 ,goods_num = 7 ,stage = 7 };
get(8,70) ->
	#base_cat_spirit{type = 8 ,lv = 70 ,attrs = [{hit,370},{dodge,370},{att,1120}],goods_id = 3711000 ,goods_num = 14 ,stage = 7 };
get(1,71) ->
	#base_cat_spirit{type = 1 ,lv = 71 ,attrs = [{def,1152}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,71) ->
	#base_cat_spirit{type = 2 ,lv = 71 ,attrs = [{hp_lim,11520}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,71) ->
	#base_cat_spirit{type = 3 ,lv = 71 ,attrs = [{crit,381}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,71) ->
	#base_cat_spirit{type = 4 ,lv = 71 ,attrs = [{ten,381}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,71) ->
	#base_cat_spirit{type = 5 ,lv = 71 ,attrs = [{hit,381}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,71) ->
	#base_cat_spirit{type = 6 ,lv = 71 ,attrs = [{dodge,381}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,71) ->
	#base_cat_spirit{type = 7 ,lv = 71 ,attrs = [{att,1152}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,71) ->
	#base_cat_spirit{type = 8 ,lv = 71 ,attrs = [{hit,381},{dodge,381},{att,1152}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,72) ->
	#base_cat_spirit{type = 1 ,lv = 72 ,attrs = [{def,1184}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,72) ->
	#base_cat_spirit{type = 2 ,lv = 72 ,attrs = [{hp_lim,11840}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,72) ->
	#base_cat_spirit{type = 3 ,lv = 72 ,attrs = [{crit,392}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,72) ->
	#base_cat_spirit{type = 4 ,lv = 72 ,attrs = [{ten,392}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,72) ->
	#base_cat_spirit{type = 5 ,lv = 72 ,attrs = [{hit,392}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,72) ->
	#base_cat_spirit{type = 6 ,lv = 72 ,attrs = [{dodge,392}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,72) ->
	#base_cat_spirit{type = 7 ,lv = 72 ,attrs = [{att,1184}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,72) ->
	#base_cat_spirit{type = 8 ,lv = 72 ,attrs = [{hit,392},{dodge,392},{att,1184}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,73) ->
	#base_cat_spirit{type = 1 ,lv = 73 ,attrs = [{def,1216}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,73) ->
	#base_cat_spirit{type = 2 ,lv = 73 ,attrs = [{hp_lim,12160}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,73) ->
	#base_cat_spirit{type = 3 ,lv = 73 ,attrs = [{crit,403}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,73) ->
	#base_cat_spirit{type = 4 ,lv = 73 ,attrs = [{ten,403}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,73) ->
	#base_cat_spirit{type = 5 ,lv = 73 ,attrs = [{hit,403}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,73) ->
	#base_cat_spirit{type = 6 ,lv = 73 ,attrs = [{dodge,403}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,73) ->
	#base_cat_spirit{type = 7 ,lv = 73 ,attrs = [{att,1216}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,73) ->
	#base_cat_spirit{type = 8 ,lv = 73 ,attrs = [{hit,403},{dodge,403},{att,1216}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,74) ->
	#base_cat_spirit{type = 1 ,lv = 74 ,attrs = [{def,1248}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,74) ->
	#base_cat_spirit{type = 2 ,lv = 74 ,attrs = [{hp_lim,12480}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,74) ->
	#base_cat_spirit{type = 3 ,lv = 74 ,attrs = [{crit,414}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,74) ->
	#base_cat_spirit{type = 4 ,lv = 74 ,attrs = [{ten,414}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,74) ->
	#base_cat_spirit{type = 5 ,lv = 74 ,attrs = [{hit,414}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,74) ->
	#base_cat_spirit{type = 6 ,lv = 74 ,attrs = [{dodge,414}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,74) ->
	#base_cat_spirit{type = 7 ,lv = 74 ,attrs = [{att,1248}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,74) ->
	#base_cat_spirit{type = 8 ,lv = 74 ,attrs = [{hit,414},{dodge,414},{att,1248}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,75) ->
	#base_cat_spirit{type = 1 ,lv = 75 ,attrs = [{def,1280}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,75) ->
	#base_cat_spirit{type = 2 ,lv = 75 ,attrs = [{hp_lim,12800}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,75) ->
	#base_cat_spirit{type = 3 ,lv = 75 ,attrs = [{crit,425}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,75) ->
	#base_cat_spirit{type = 4 ,lv = 75 ,attrs = [{ten,425}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,75) ->
	#base_cat_spirit{type = 5 ,lv = 75 ,attrs = [{hit,425}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,75) ->
	#base_cat_spirit{type = 6 ,lv = 75 ,attrs = [{dodge,425}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,75) ->
	#base_cat_spirit{type = 7 ,lv = 75 ,attrs = [{att,1280}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,75) ->
	#base_cat_spirit{type = 8 ,lv = 75 ,attrs = [{hit,425},{dodge,425},{att,1280}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,76) ->
	#base_cat_spirit{type = 1 ,lv = 76 ,attrs = [{def,1312}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,76) ->
	#base_cat_spirit{type = 2 ,lv = 76 ,attrs = [{hp_lim,13120}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,76) ->
	#base_cat_spirit{type = 3 ,lv = 76 ,attrs = [{crit,436}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,76) ->
	#base_cat_spirit{type = 4 ,lv = 76 ,attrs = [{ten,436}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,76) ->
	#base_cat_spirit{type = 5 ,lv = 76 ,attrs = [{hit,436}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,76) ->
	#base_cat_spirit{type = 6 ,lv = 76 ,attrs = [{dodge,436}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,76) ->
	#base_cat_spirit{type = 7 ,lv = 76 ,attrs = [{att,1312}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,76) ->
	#base_cat_spirit{type = 8 ,lv = 76 ,attrs = [{hit,436},{dodge,436},{att,1312}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,77) ->
	#base_cat_spirit{type = 1 ,lv = 77 ,attrs = [{def,1344}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,77) ->
	#base_cat_spirit{type = 2 ,lv = 77 ,attrs = [{hp_lim,13440}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,77) ->
	#base_cat_spirit{type = 3 ,lv = 77 ,attrs = [{crit,447}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,77) ->
	#base_cat_spirit{type = 4 ,lv = 77 ,attrs = [{ten,447}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,77) ->
	#base_cat_spirit{type = 5 ,lv = 77 ,attrs = [{hit,447}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,77) ->
	#base_cat_spirit{type = 6 ,lv = 77 ,attrs = [{dodge,447}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,77) ->
	#base_cat_spirit{type = 7 ,lv = 77 ,attrs = [{att,1344}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,77) ->
	#base_cat_spirit{type = 8 ,lv = 77 ,attrs = [{hit,447},{dodge,447},{att,1344}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,78) ->
	#base_cat_spirit{type = 1 ,lv = 78 ,attrs = [{def,1376}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,78) ->
	#base_cat_spirit{type = 2 ,lv = 78 ,attrs = [{hp_lim,13760}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,78) ->
	#base_cat_spirit{type = 3 ,lv = 78 ,attrs = [{crit,458}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,78) ->
	#base_cat_spirit{type = 4 ,lv = 78 ,attrs = [{ten,458}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,78) ->
	#base_cat_spirit{type = 5 ,lv = 78 ,attrs = [{hit,458}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,78) ->
	#base_cat_spirit{type = 6 ,lv = 78 ,attrs = [{dodge,458}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,78) ->
	#base_cat_spirit{type = 7 ,lv = 78 ,attrs = [{att,1376}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,78) ->
	#base_cat_spirit{type = 8 ,lv = 78 ,attrs = [{hit,458},{dodge,458},{att,1376}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,79) ->
	#base_cat_spirit{type = 1 ,lv = 79 ,attrs = [{def,1408}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,79) ->
	#base_cat_spirit{type = 2 ,lv = 79 ,attrs = [{hp_lim,14080}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,79) ->
	#base_cat_spirit{type = 3 ,lv = 79 ,attrs = [{crit,469}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,79) ->
	#base_cat_spirit{type = 4 ,lv = 79 ,attrs = [{ten,469}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,79) ->
	#base_cat_spirit{type = 5 ,lv = 79 ,attrs = [{hit,469}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,79) ->
	#base_cat_spirit{type = 6 ,lv = 79 ,attrs = [{dodge,469}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,79) ->
	#base_cat_spirit{type = 7 ,lv = 79 ,attrs = [{att,1408}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,79) ->
	#base_cat_spirit{type = 8 ,lv = 79 ,attrs = [{hit,469},{dodge,469},{att,1408}],goods_id = 3710000 ,goods_num = 24 ,stage = 8 };
get(1,80) ->
	#base_cat_spirit{type = 1 ,lv = 80 ,attrs = [{def,1440}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(2,80) ->
	#base_cat_spirit{type = 2 ,lv = 80 ,attrs = [{hp_lim,14400}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(3,80) ->
	#base_cat_spirit{type = 3 ,lv = 80 ,attrs = [{crit,480}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(4,80) ->
	#base_cat_spirit{type = 4 ,lv = 80 ,attrs = [{ten,480}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(5,80) ->
	#base_cat_spirit{type = 5 ,lv = 80 ,attrs = [{hit,480}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(6,80) ->
	#base_cat_spirit{type = 6 ,lv = 80 ,attrs = [{dodge,480}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(7,80) ->
	#base_cat_spirit{type = 7 ,lv = 80 ,attrs = [{att,1440}],goods_id = 3710000 ,goods_num = 8 ,stage = 8 };
get(8,80) ->
	#base_cat_spirit{type = 8 ,lv = 80 ,attrs = [{hit,480},{dodge,480},{att,1440}],goods_id = 3711000 ,goods_num = 16 ,stage = 8 };
get(1,81) ->
	#base_cat_spirit{type = 1 ,lv = 81 ,attrs = [{def,1476}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,81) ->
	#base_cat_spirit{type = 2 ,lv = 81 ,attrs = [{hp_lim,14760}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,81) ->
	#base_cat_spirit{type = 3 ,lv = 81 ,attrs = [{crit,492}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,81) ->
	#base_cat_spirit{type = 4 ,lv = 81 ,attrs = [{ten,492}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,81) ->
	#base_cat_spirit{type = 5 ,lv = 81 ,attrs = [{hit,492}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,81) ->
	#base_cat_spirit{type = 6 ,lv = 81 ,attrs = [{dodge,492}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,81) ->
	#base_cat_spirit{type = 7 ,lv = 81 ,attrs = [{att,1476}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,81) ->
	#base_cat_spirit{type = 8 ,lv = 81 ,attrs = [{hit,492},{dodge,492},{att,1476}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,82) ->
	#base_cat_spirit{type = 1 ,lv = 82 ,attrs = [{def,1512}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,82) ->
	#base_cat_spirit{type = 2 ,lv = 82 ,attrs = [{hp_lim,15120}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,82) ->
	#base_cat_spirit{type = 3 ,lv = 82 ,attrs = [{crit,504}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,82) ->
	#base_cat_spirit{type = 4 ,lv = 82 ,attrs = [{ten,504}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,82) ->
	#base_cat_spirit{type = 5 ,lv = 82 ,attrs = [{hit,504}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,82) ->
	#base_cat_spirit{type = 6 ,lv = 82 ,attrs = [{dodge,504}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,82) ->
	#base_cat_spirit{type = 7 ,lv = 82 ,attrs = [{att,1512}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,82) ->
	#base_cat_spirit{type = 8 ,lv = 82 ,attrs = [{hit,504},{dodge,504},{att,1512}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,83) ->
	#base_cat_spirit{type = 1 ,lv = 83 ,attrs = [{def,1548}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,83) ->
	#base_cat_spirit{type = 2 ,lv = 83 ,attrs = [{hp_lim,15480}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,83) ->
	#base_cat_spirit{type = 3 ,lv = 83 ,attrs = [{crit,516}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,83) ->
	#base_cat_spirit{type = 4 ,lv = 83 ,attrs = [{ten,516}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,83) ->
	#base_cat_spirit{type = 5 ,lv = 83 ,attrs = [{hit,516}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,83) ->
	#base_cat_spirit{type = 6 ,lv = 83 ,attrs = [{dodge,516}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,83) ->
	#base_cat_spirit{type = 7 ,lv = 83 ,attrs = [{att,1548}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,83) ->
	#base_cat_spirit{type = 8 ,lv = 83 ,attrs = [{hit,516},{dodge,516},{att,1548}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,84) ->
	#base_cat_spirit{type = 1 ,lv = 84 ,attrs = [{def,1584}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,84) ->
	#base_cat_spirit{type = 2 ,lv = 84 ,attrs = [{hp_lim,15840}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,84) ->
	#base_cat_spirit{type = 3 ,lv = 84 ,attrs = [{crit,528}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,84) ->
	#base_cat_spirit{type = 4 ,lv = 84 ,attrs = [{ten,528}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,84) ->
	#base_cat_spirit{type = 5 ,lv = 84 ,attrs = [{hit,528}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,84) ->
	#base_cat_spirit{type = 6 ,lv = 84 ,attrs = [{dodge,528}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,84) ->
	#base_cat_spirit{type = 7 ,lv = 84 ,attrs = [{att,1584}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,84) ->
	#base_cat_spirit{type = 8 ,lv = 84 ,attrs = [{hit,528},{dodge,528},{att,1584}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,85) ->
	#base_cat_spirit{type = 1 ,lv = 85 ,attrs = [{def,1620}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,85) ->
	#base_cat_spirit{type = 2 ,lv = 85 ,attrs = [{hp_lim,16200}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,85) ->
	#base_cat_spirit{type = 3 ,lv = 85 ,attrs = [{crit,540}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,85) ->
	#base_cat_spirit{type = 4 ,lv = 85 ,attrs = [{ten,540}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,85) ->
	#base_cat_spirit{type = 5 ,lv = 85 ,attrs = [{hit,540}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,85) ->
	#base_cat_spirit{type = 6 ,lv = 85 ,attrs = [{dodge,540}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,85) ->
	#base_cat_spirit{type = 7 ,lv = 85 ,attrs = [{att,1620}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,85) ->
	#base_cat_spirit{type = 8 ,lv = 85 ,attrs = [{hit,540},{dodge,540},{att,1620}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,86) ->
	#base_cat_spirit{type = 1 ,lv = 86 ,attrs = [{def,1656}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,86) ->
	#base_cat_spirit{type = 2 ,lv = 86 ,attrs = [{hp_lim,16560}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,86) ->
	#base_cat_spirit{type = 3 ,lv = 86 ,attrs = [{crit,552}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,86) ->
	#base_cat_spirit{type = 4 ,lv = 86 ,attrs = [{ten,552}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,86) ->
	#base_cat_spirit{type = 5 ,lv = 86 ,attrs = [{hit,552}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,86) ->
	#base_cat_spirit{type = 6 ,lv = 86 ,attrs = [{dodge,552}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,86) ->
	#base_cat_spirit{type = 7 ,lv = 86 ,attrs = [{att,1656}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,86) ->
	#base_cat_spirit{type = 8 ,lv = 86 ,attrs = [{hit,552},{dodge,552},{att,1656}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,87) ->
	#base_cat_spirit{type = 1 ,lv = 87 ,attrs = [{def,1692}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,87) ->
	#base_cat_spirit{type = 2 ,lv = 87 ,attrs = [{hp_lim,16920}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,87) ->
	#base_cat_spirit{type = 3 ,lv = 87 ,attrs = [{crit,564}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,87) ->
	#base_cat_spirit{type = 4 ,lv = 87 ,attrs = [{ten,564}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,87) ->
	#base_cat_spirit{type = 5 ,lv = 87 ,attrs = [{hit,564}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,87) ->
	#base_cat_spirit{type = 6 ,lv = 87 ,attrs = [{dodge,564}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,87) ->
	#base_cat_spirit{type = 7 ,lv = 87 ,attrs = [{att,1692}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,87) ->
	#base_cat_spirit{type = 8 ,lv = 87 ,attrs = [{hit,564},{dodge,564},{att,1692}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,88) ->
	#base_cat_spirit{type = 1 ,lv = 88 ,attrs = [{def,1728}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,88) ->
	#base_cat_spirit{type = 2 ,lv = 88 ,attrs = [{hp_lim,17280}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,88) ->
	#base_cat_spirit{type = 3 ,lv = 88 ,attrs = [{crit,576}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,88) ->
	#base_cat_spirit{type = 4 ,lv = 88 ,attrs = [{ten,576}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,88) ->
	#base_cat_spirit{type = 5 ,lv = 88 ,attrs = [{hit,576}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,88) ->
	#base_cat_spirit{type = 6 ,lv = 88 ,attrs = [{dodge,576}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,88) ->
	#base_cat_spirit{type = 7 ,lv = 88 ,attrs = [{att,1728}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,88) ->
	#base_cat_spirit{type = 8 ,lv = 88 ,attrs = [{hit,576},{dodge,576},{att,1728}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,89) ->
	#base_cat_spirit{type = 1 ,lv = 89 ,attrs = [{def,1764}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,89) ->
	#base_cat_spirit{type = 2 ,lv = 89 ,attrs = [{hp_lim,17640}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,89) ->
	#base_cat_spirit{type = 3 ,lv = 89 ,attrs = [{crit,588}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,89) ->
	#base_cat_spirit{type = 4 ,lv = 89 ,attrs = [{ten,588}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,89) ->
	#base_cat_spirit{type = 5 ,lv = 89 ,attrs = [{hit,588}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,89) ->
	#base_cat_spirit{type = 6 ,lv = 89 ,attrs = [{dodge,588}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,89) ->
	#base_cat_spirit{type = 7 ,lv = 89 ,attrs = [{att,1764}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,89) ->
	#base_cat_spirit{type = 8 ,lv = 89 ,attrs = [{hit,588},{dodge,588},{att,1764}],goods_id = 3710000 ,goods_num = 27 ,stage = 9 };
get(1,90) ->
	#base_cat_spirit{type = 1 ,lv = 90 ,attrs = [{def,1800}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(2,90) ->
	#base_cat_spirit{type = 2 ,lv = 90 ,attrs = [{hp_lim,18000}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(3,90) ->
	#base_cat_spirit{type = 3 ,lv = 90 ,attrs = [{crit,600}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(4,90) ->
	#base_cat_spirit{type = 4 ,lv = 90 ,attrs = [{ten,600}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(5,90) ->
	#base_cat_spirit{type = 5 ,lv = 90 ,attrs = [{hit,600}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(6,90) ->
	#base_cat_spirit{type = 6 ,lv = 90 ,attrs = [{dodge,600}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(7,90) ->
	#base_cat_spirit{type = 7 ,lv = 90 ,attrs = [{att,1800}],goods_id = 3710000 ,goods_num = 9 ,stage = 9 };
get(8,90) ->
	#base_cat_spirit{type = 8 ,lv = 90 ,attrs = [{hit,600},{dodge,600},{att,1800}],goods_id = 3711000 ,goods_num = 18 ,stage = 9 };
get(1,91) ->
	#base_cat_spirit{type = 1 ,lv = 91 ,attrs = [{def,1840}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,91) ->
	#base_cat_spirit{type = 2 ,lv = 91 ,attrs = [{hp_lim,18400}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,91) ->
	#base_cat_spirit{type = 3 ,lv = 91 ,attrs = [{crit,613}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,91) ->
	#base_cat_spirit{type = 4 ,lv = 91 ,attrs = [{ten,613}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,91) ->
	#base_cat_spirit{type = 5 ,lv = 91 ,attrs = [{hit,613}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,91) ->
	#base_cat_spirit{type = 6 ,lv = 91 ,attrs = [{dodge,613}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,91) ->
	#base_cat_spirit{type = 7 ,lv = 91 ,attrs = [{att,1840}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,91) ->
	#base_cat_spirit{type = 8 ,lv = 91 ,attrs = [{hit,613},{dodge,613},{att,1840}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,92) ->
	#base_cat_spirit{type = 1 ,lv = 92 ,attrs = [{def,1880}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,92) ->
	#base_cat_spirit{type = 2 ,lv = 92 ,attrs = [{hp_lim,18800}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,92) ->
	#base_cat_spirit{type = 3 ,lv = 92 ,attrs = [{crit,626}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,92) ->
	#base_cat_spirit{type = 4 ,lv = 92 ,attrs = [{ten,626}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,92) ->
	#base_cat_spirit{type = 5 ,lv = 92 ,attrs = [{hit,626}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,92) ->
	#base_cat_spirit{type = 6 ,lv = 92 ,attrs = [{dodge,626}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,92) ->
	#base_cat_spirit{type = 7 ,lv = 92 ,attrs = [{att,1880}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,92) ->
	#base_cat_spirit{type = 8 ,lv = 92 ,attrs = [{hit,626},{dodge,626},{att,1880}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,93) ->
	#base_cat_spirit{type = 1 ,lv = 93 ,attrs = [{def,1920}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,93) ->
	#base_cat_spirit{type = 2 ,lv = 93 ,attrs = [{hp_lim,19200}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,93) ->
	#base_cat_spirit{type = 3 ,lv = 93 ,attrs = [{crit,639}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,93) ->
	#base_cat_spirit{type = 4 ,lv = 93 ,attrs = [{ten,639}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,93) ->
	#base_cat_spirit{type = 5 ,lv = 93 ,attrs = [{hit,639}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,93) ->
	#base_cat_spirit{type = 6 ,lv = 93 ,attrs = [{dodge,639}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,93) ->
	#base_cat_spirit{type = 7 ,lv = 93 ,attrs = [{att,1920}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,93) ->
	#base_cat_spirit{type = 8 ,lv = 93 ,attrs = [{hit,639},{dodge,639},{att,1920}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,94) ->
	#base_cat_spirit{type = 1 ,lv = 94 ,attrs = [{def,1960}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,94) ->
	#base_cat_spirit{type = 2 ,lv = 94 ,attrs = [{hp_lim,19600}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,94) ->
	#base_cat_spirit{type = 3 ,lv = 94 ,attrs = [{crit,652}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,94) ->
	#base_cat_spirit{type = 4 ,lv = 94 ,attrs = [{ten,652}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,94) ->
	#base_cat_spirit{type = 5 ,lv = 94 ,attrs = [{hit,652}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,94) ->
	#base_cat_spirit{type = 6 ,lv = 94 ,attrs = [{dodge,652}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,94) ->
	#base_cat_spirit{type = 7 ,lv = 94 ,attrs = [{att,1960}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,94) ->
	#base_cat_spirit{type = 8 ,lv = 94 ,attrs = [{hit,652},{dodge,652},{att,1960}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,95) ->
	#base_cat_spirit{type = 1 ,lv = 95 ,attrs = [{def,2000}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,95) ->
	#base_cat_spirit{type = 2 ,lv = 95 ,attrs = [{hp_lim,20000}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,95) ->
	#base_cat_spirit{type = 3 ,lv = 95 ,attrs = [{crit,665}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,95) ->
	#base_cat_spirit{type = 4 ,lv = 95 ,attrs = [{ten,665}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,95) ->
	#base_cat_spirit{type = 5 ,lv = 95 ,attrs = [{hit,665}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,95) ->
	#base_cat_spirit{type = 6 ,lv = 95 ,attrs = [{dodge,665}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,95) ->
	#base_cat_spirit{type = 7 ,lv = 95 ,attrs = [{att,2000}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,95) ->
	#base_cat_spirit{type = 8 ,lv = 95 ,attrs = [{hit,665},{dodge,665},{att,2000}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,96) ->
	#base_cat_spirit{type = 1 ,lv = 96 ,attrs = [{def,2040}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,96) ->
	#base_cat_spirit{type = 2 ,lv = 96 ,attrs = [{hp_lim,20400}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,96) ->
	#base_cat_spirit{type = 3 ,lv = 96 ,attrs = [{crit,678}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,96) ->
	#base_cat_spirit{type = 4 ,lv = 96 ,attrs = [{ten,678}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,96) ->
	#base_cat_spirit{type = 5 ,lv = 96 ,attrs = [{hit,678}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,96) ->
	#base_cat_spirit{type = 6 ,lv = 96 ,attrs = [{dodge,678}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,96) ->
	#base_cat_spirit{type = 7 ,lv = 96 ,attrs = [{att,2040}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,96) ->
	#base_cat_spirit{type = 8 ,lv = 96 ,attrs = [{hit,678},{dodge,678},{att,2040}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,97) ->
	#base_cat_spirit{type = 1 ,lv = 97 ,attrs = [{def,2080}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,97) ->
	#base_cat_spirit{type = 2 ,lv = 97 ,attrs = [{hp_lim,20800}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,97) ->
	#base_cat_spirit{type = 3 ,lv = 97 ,attrs = [{crit,691}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,97) ->
	#base_cat_spirit{type = 4 ,lv = 97 ,attrs = [{ten,691}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,97) ->
	#base_cat_spirit{type = 5 ,lv = 97 ,attrs = [{hit,691}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,97) ->
	#base_cat_spirit{type = 6 ,lv = 97 ,attrs = [{dodge,691}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,97) ->
	#base_cat_spirit{type = 7 ,lv = 97 ,attrs = [{att,2080}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,97) ->
	#base_cat_spirit{type = 8 ,lv = 97 ,attrs = [{hit,691},{dodge,691},{att,2080}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,98) ->
	#base_cat_spirit{type = 1 ,lv = 98 ,attrs = [{def,2120}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,98) ->
	#base_cat_spirit{type = 2 ,lv = 98 ,attrs = [{hp_lim,21200}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,98) ->
	#base_cat_spirit{type = 3 ,lv = 98 ,attrs = [{crit,704}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,98) ->
	#base_cat_spirit{type = 4 ,lv = 98 ,attrs = [{ten,704}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,98) ->
	#base_cat_spirit{type = 5 ,lv = 98 ,attrs = [{hit,704}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,98) ->
	#base_cat_spirit{type = 6 ,lv = 98 ,attrs = [{dodge,704}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,98) ->
	#base_cat_spirit{type = 7 ,lv = 98 ,attrs = [{att,2120}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,98) ->
	#base_cat_spirit{type = 8 ,lv = 98 ,attrs = [{hit,704},{dodge,704},{att,2120}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,99) ->
	#base_cat_spirit{type = 1 ,lv = 99 ,attrs = [{def,2160}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,99) ->
	#base_cat_spirit{type = 2 ,lv = 99 ,attrs = [{hp_lim,21600}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,99) ->
	#base_cat_spirit{type = 3 ,lv = 99 ,attrs = [{crit,717}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,99) ->
	#base_cat_spirit{type = 4 ,lv = 99 ,attrs = [{ten,717}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,99) ->
	#base_cat_spirit{type = 5 ,lv = 99 ,attrs = [{hit,717}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,99) ->
	#base_cat_spirit{type = 6 ,lv = 99 ,attrs = [{dodge,717}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,99) ->
	#base_cat_spirit{type = 7 ,lv = 99 ,attrs = [{att,2160}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,99) ->
	#base_cat_spirit{type = 8 ,lv = 99 ,attrs = [{hit,717},{dodge,717},{att,2160}],goods_id = 3710000 ,goods_num = 30 ,stage = 10 };
get(1,100) ->
	#base_cat_spirit{type = 1 ,lv = 100 ,attrs = [{def,2200}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(2,100) ->
	#base_cat_spirit{type = 2 ,lv = 100 ,attrs = [{hp_lim,22000}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(3,100) ->
	#base_cat_spirit{type = 3 ,lv = 100 ,attrs = [{crit,730}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(4,100) ->
	#base_cat_spirit{type = 4 ,lv = 100 ,attrs = [{ten,730}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(5,100) ->
	#base_cat_spirit{type = 5 ,lv = 100 ,attrs = [{hit,730}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(6,100) ->
	#base_cat_spirit{type = 6 ,lv = 100 ,attrs = [{dodge,730}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(7,100) ->
	#base_cat_spirit{type = 7 ,lv = 100 ,attrs = [{att,2200}],goods_id = 3710000 ,goods_num = 10 ,stage = 10 };
get(8,100) ->
	#base_cat_spirit{type = 8 ,lv = 100 ,attrs = [{hit,730},{dodge,730},{att,2200}],goods_id = 3711000 ,goods_num = 20 ,stage = 10 };
get(_,_) -> [].