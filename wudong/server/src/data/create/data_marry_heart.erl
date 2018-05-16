%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_marry_heart
	%%% @Created : 2018-04-27 18:01:22
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_marry_heart).
-export([max_type/0]).
-export([type_list/0]).
-export([get/2]).
-include("marry.hrl").
-include("common.hrl").

    max_type()->8. 


    type_list() ->
    [1,2,3,4,5,6,7,8].
get(1,1) ->
	#base_marry_heart{type = 1 ,lv = 1 ,attrs = [{att,4}],goods_num = 10 };
get(2,1) ->
	#base_marry_heart{type = 2 ,lv = 1 ,attrs = [{def,4}],goods_num = 10 };
get(3,1) ->
	#base_marry_heart{type = 3 ,lv = 1 ,attrs = [{hp_lim,40}],goods_num = 10 };
get(4,1) ->
	#base_marry_heart{type = 4 ,lv = 1 ,attrs = [{crit,1}],goods_num = 10 };
get(5,1) ->
	#base_marry_heart{type = 5 ,lv = 1 ,attrs = [{ten,1}],goods_num = 10 };
get(6,1) ->
	#base_marry_heart{type = 6 ,lv = 1 ,attrs = [{hit,1}],goods_num = 10 };
get(7,1) ->
	#base_marry_heart{type = 7 ,lv = 1 ,attrs = [{dodge,1}],goods_num = 10 };
get(8,1) ->
	#base_marry_heart{type = 8 ,lv = 1 ,attrs = [{att,4},{def,4},{hp_lim,40}],goods_num = 30 };
get(1,2) ->
	#base_marry_heart{type = 1 ,lv = 2 ,attrs = [{att,8}],goods_num = 10 };
get(2,2) ->
	#base_marry_heart{type = 2 ,lv = 2 ,attrs = [{def,8}],goods_num = 10 };
get(3,2) ->
	#base_marry_heart{type = 3 ,lv = 2 ,attrs = [{hp_lim,80}],goods_num = 10 };
get(4,2) ->
	#base_marry_heart{type = 4 ,lv = 2 ,attrs = [{crit,2}],goods_num = 10 };
get(5,2) ->
	#base_marry_heart{type = 5 ,lv = 2 ,attrs = [{ten,2}],goods_num = 10 };
get(6,2) ->
	#base_marry_heart{type = 6 ,lv = 2 ,attrs = [{hit,2}],goods_num = 10 };
get(7,2) ->
	#base_marry_heart{type = 7 ,lv = 2 ,attrs = [{dodge,2}],goods_num = 10 };
get(8,2) ->
	#base_marry_heart{type = 8 ,lv = 2 ,attrs = [{att,8},{def,8},{hp_lim,80}],goods_num = 30 };
get(1,3) ->
	#base_marry_heart{type = 1 ,lv = 3 ,attrs = [{att,12}],goods_num = 10 };
get(2,3) ->
	#base_marry_heart{type = 2 ,lv = 3 ,attrs = [{def,12}],goods_num = 10 };
get(3,3) ->
	#base_marry_heart{type = 3 ,lv = 3 ,attrs = [{hp_lim,120}],goods_num = 10 };
get(4,3) ->
	#base_marry_heart{type = 4 ,lv = 3 ,attrs = [{crit,3}],goods_num = 10 };
get(5,3) ->
	#base_marry_heart{type = 5 ,lv = 3 ,attrs = [{ten,3}],goods_num = 10 };
get(6,3) ->
	#base_marry_heart{type = 6 ,lv = 3 ,attrs = [{hit,3}],goods_num = 10 };
get(7,3) ->
	#base_marry_heart{type = 7 ,lv = 3 ,attrs = [{dodge,3}],goods_num = 10 };
get(8,3) ->
	#base_marry_heart{type = 8 ,lv = 3 ,attrs = [{att,12},{def,12},{hp_lim,120}],goods_num = 30 };
get(1,4) ->
	#base_marry_heart{type = 1 ,lv = 4 ,attrs = [{att,16}],goods_num = 10 };
get(2,4) ->
	#base_marry_heart{type = 2 ,lv = 4 ,attrs = [{def,16}],goods_num = 10 };
get(3,4) ->
	#base_marry_heart{type = 3 ,lv = 4 ,attrs = [{hp_lim,160}],goods_num = 10 };
get(4,4) ->
	#base_marry_heart{type = 4 ,lv = 4 ,attrs = [{crit,4}],goods_num = 10 };
get(5,4) ->
	#base_marry_heart{type = 5 ,lv = 4 ,attrs = [{ten,4}],goods_num = 10 };
get(6,4) ->
	#base_marry_heart{type = 6 ,lv = 4 ,attrs = [{hit,4}],goods_num = 10 };
get(7,4) ->
	#base_marry_heart{type = 7 ,lv = 4 ,attrs = [{dodge,4}],goods_num = 10 };
get(8,4) ->
	#base_marry_heart{type = 8 ,lv = 4 ,attrs = [{att,16},{def,16},{hp_lim,160}],goods_num = 30 };
get(1,5) ->
	#base_marry_heart{type = 1 ,lv = 5 ,attrs = [{att,20}],goods_num = 10 };
get(2,5) ->
	#base_marry_heart{type = 2 ,lv = 5 ,attrs = [{def,20}],goods_num = 10 };
get(3,5) ->
	#base_marry_heart{type = 3 ,lv = 5 ,attrs = [{hp_lim,200}],goods_num = 10 };
get(4,5) ->
	#base_marry_heart{type = 4 ,lv = 5 ,attrs = [{crit,5}],goods_num = 10 };
get(5,5) ->
	#base_marry_heart{type = 5 ,lv = 5 ,attrs = [{ten,5}],goods_num = 10 };
get(6,5) ->
	#base_marry_heart{type = 6 ,lv = 5 ,attrs = [{hit,5}],goods_num = 10 };
get(7,5) ->
	#base_marry_heart{type = 7 ,lv = 5 ,attrs = [{dodge,5}],goods_num = 10 };
get(8,5) ->
	#base_marry_heart{type = 8 ,lv = 5 ,attrs = [{att,20},{def,20},{hp_lim,200}],goods_num = 30 };
get(1,6) ->
	#base_marry_heart{type = 1 ,lv = 6 ,attrs = [{att,24}],goods_num = 10 };
get(2,6) ->
	#base_marry_heart{type = 2 ,lv = 6 ,attrs = [{def,24}],goods_num = 10 };
get(3,6) ->
	#base_marry_heart{type = 3 ,lv = 6 ,attrs = [{hp_lim,240}],goods_num = 10 };
get(4,6) ->
	#base_marry_heart{type = 4 ,lv = 6 ,attrs = [{crit,6}],goods_num = 10 };
get(5,6) ->
	#base_marry_heart{type = 5 ,lv = 6 ,attrs = [{ten,6}],goods_num = 10 };
get(6,6) ->
	#base_marry_heart{type = 6 ,lv = 6 ,attrs = [{hit,6}],goods_num = 10 };
get(7,6) ->
	#base_marry_heart{type = 7 ,lv = 6 ,attrs = [{dodge,6}],goods_num = 10 };
get(8,6) ->
	#base_marry_heart{type = 8 ,lv = 6 ,attrs = [{att,24},{def,24},{hp_lim,240}],goods_num = 30 };
get(1,7) ->
	#base_marry_heart{type = 1 ,lv = 7 ,attrs = [{att,28}],goods_num = 10 };
get(2,7) ->
	#base_marry_heart{type = 2 ,lv = 7 ,attrs = [{def,28}],goods_num = 10 };
get(3,7) ->
	#base_marry_heart{type = 3 ,lv = 7 ,attrs = [{hp_lim,280}],goods_num = 10 };
get(4,7) ->
	#base_marry_heart{type = 4 ,lv = 7 ,attrs = [{crit,7}],goods_num = 10 };
get(5,7) ->
	#base_marry_heart{type = 5 ,lv = 7 ,attrs = [{ten,7}],goods_num = 10 };
get(6,7) ->
	#base_marry_heart{type = 6 ,lv = 7 ,attrs = [{hit,7}],goods_num = 10 };
get(7,7) ->
	#base_marry_heart{type = 7 ,lv = 7 ,attrs = [{dodge,7}],goods_num = 10 };
get(8,7) ->
	#base_marry_heart{type = 8 ,lv = 7 ,attrs = [{att,28},{def,28},{hp_lim,280}],goods_num = 30 };
get(1,8) ->
	#base_marry_heart{type = 1 ,lv = 8 ,attrs = [{att,32}],goods_num = 10 };
get(2,8) ->
	#base_marry_heart{type = 2 ,lv = 8 ,attrs = [{def,32}],goods_num = 10 };
get(3,8) ->
	#base_marry_heart{type = 3 ,lv = 8 ,attrs = [{hp_lim,320}],goods_num = 10 };
get(4,8) ->
	#base_marry_heart{type = 4 ,lv = 8 ,attrs = [{crit,8}],goods_num = 10 };
get(5,8) ->
	#base_marry_heart{type = 5 ,lv = 8 ,attrs = [{ten,8}],goods_num = 10 };
get(6,8) ->
	#base_marry_heart{type = 6 ,lv = 8 ,attrs = [{hit,8}],goods_num = 10 };
get(7,8) ->
	#base_marry_heart{type = 7 ,lv = 8 ,attrs = [{dodge,8}],goods_num = 10 };
get(8,8) ->
	#base_marry_heart{type = 8 ,lv = 8 ,attrs = [{att,32},{def,32},{hp_lim,320}],goods_num = 30 };
get(1,9) ->
	#base_marry_heart{type = 1 ,lv = 9 ,attrs = [{att,36}],goods_num = 10 };
get(2,9) ->
	#base_marry_heart{type = 2 ,lv = 9 ,attrs = [{def,36}],goods_num = 10 };
get(3,9) ->
	#base_marry_heart{type = 3 ,lv = 9 ,attrs = [{hp_lim,360}],goods_num = 10 };
get(4,9) ->
	#base_marry_heart{type = 4 ,lv = 9 ,attrs = [{crit,9}],goods_num = 10 };
get(5,9) ->
	#base_marry_heart{type = 5 ,lv = 9 ,attrs = [{ten,9}],goods_num = 10 };
get(6,9) ->
	#base_marry_heart{type = 6 ,lv = 9 ,attrs = [{hit,9}],goods_num = 10 };
get(7,9) ->
	#base_marry_heart{type = 7 ,lv = 9 ,attrs = [{dodge,9}],goods_num = 10 };
get(8,9) ->
	#base_marry_heart{type = 8 ,lv = 9 ,attrs = [{att,36},{def,36},{hp_lim,360}],goods_num = 30 };
get(1,10) ->
	#base_marry_heart{type = 1 ,lv = 10 ,attrs = [{att,40}],goods_num = 10 };
get(2,10) ->
	#base_marry_heart{type = 2 ,lv = 10 ,attrs = [{def,40}],goods_num = 10 };
get(3,10) ->
	#base_marry_heart{type = 3 ,lv = 10 ,attrs = [{hp_lim,400}],goods_num = 10 };
get(4,10) ->
	#base_marry_heart{type = 4 ,lv = 10 ,attrs = [{crit,10}],goods_num = 10 };
get(5,10) ->
	#base_marry_heart{type = 5 ,lv = 10 ,attrs = [{ten,10}],goods_num = 10 };
get(6,10) ->
	#base_marry_heart{type = 6 ,lv = 10 ,attrs = [{hit,10}],goods_num = 10 };
get(7,10) ->
	#base_marry_heart{type = 7 ,lv = 10 ,attrs = [{dodge,10}],goods_num = 10 };
get(8,10) ->
	#base_marry_heart{type = 8 ,lv = 10 ,attrs = [{att,40},{def,40},{hp_lim,400}],goods_num = 30 };
get(1,11) ->
	#base_marry_heart{type = 1 ,lv = 11 ,attrs = [{att,48}],goods_num = 20 };
get(2,11) ->
	#base_marry_heart{type = 2 ,lv = 11 ,attrs = [{def,48}],goods_num = 20 };
get(3,11) ->
	#base_marry_heart{type = 3 ,lv = 11 ,attrs = [{hp_lim,480}],goods_num = 20 };
get(4,11) ->
	#base_marry_heart{type = 4 ,lv = 11 ,attrs = [{crit,13}],goods_num = 20 };
get(5,11) ->
	#base_marry_heart{type = 5 ,lv = 11 ,attrs = [{ten,13}],goods_num = 20 };
get(6,11) ->
	#base_marry_heart{type = 6 ,lv = 11 ,attrs = [{hit,13}],goods_num = 20 };
get(7,11) ->
	#base_marry_heart{type = 7 ,lv = 11 ,attrs = [{dodge,13}],goods_num = 20 };
get(8,11) ->
	#base_marry_heart{type = 8 ,lv = 11 ,attrs = [{att,48},{def,48},{hp_lim,480}],goods_num = 60 };
get(1,12) ->
	#base_marry_heart{type = 1 ,lv = 12 ,attrs = [{att,56}],goods_num = 20 };
get(2,12) ->
	#base_marry_heart{type = 2 ,lv = 12 ,attrs = [{def,56}],goods_num = 20 };
get(3,12) ->
	#base_marry_heart{type = 3 ,lv = 12 ,attrs = [{hp_lim,560}],goods_num = 20 };
get(4,12) ->
	#base_marry_heart{type = 4 ,lv = 12 ,attrs = [{crit,16}],goods_num = 20 };
get(5,12) ->
	#base_marry_heart{type = 5 ,lv = 12 ,attrs = [{ten,16}],goods_num = 20 };
get(6,12) ->
	#base_marry_heart{type = 6 ,lv = 12 ,attrs = [{hit,16}],goods_num = 20 };
get(7,12) ->
	#base_marry_heart{type = 7 ,lv = 12 ,attrs = [{dodge,16}],goods_num = 20 };
get(8,12) ->
	#base_marry_heart{type = 8 ,lv = 12 ,attrs = [{att,56},{def,56},{hp_lim,560}],goods_num = 60 };
get(1,13) ->
	#base_marry_heart{type = 1 ,lv = 13 ,attrs = [{att,64}],goods_num = 20 };
get(2,13) ->
	#base_marry_heart{type = 2 ,lv = 13 ,attrs = [{def,64}],goods_num = 20 };
get(3,13) ->
	#base_marry_heart{type = 3 ,lv = 13 ,attrs = [{hp_lim,640}],goods_num = 20 };
get(4,13) ->
	#base_marry_heart{type = 4 ,lv = 13 ,attrs = [{crit,19}],goods_num = 20 };
get(5,13) ->
	#base_marry_heart{type = 5 ,lv = 13 ,attrs = [{ten,19}],goods_num = 20 };
get(6,13) ->
	#base_marry_heart{type = 6 ,lv = 13 ,attrs = [{hit,19}],goods_num = 20 };
get(7,13) ->
	#base_marry_heart{type = 7 ,lv = 13 ,attrs = [{dodge,19}],goods_num = 20 };
get(8,13) ->
	#base_marry_heart{type = 8 ,lv = 13 ,attrs = [{att,64},{def,64},{hp_lim,640}],goods_num = 60 };
get(1,14) ->
	#base_marry_heart{type = 1 ,lv = 14 ,attrs = [{att,72}],goods_num = 20 };
get(2,14) ->
	#base_marry_heart{type = 2 ,lv = 14 ,attrs = [{def,72}],goods_num = 20 };
get(3,14) ->
	#base_marry_heart{type = 3 ,lv = 14 ,attrs = [{hp_lim,720}],goods_num = 20 };
get(4,14) ->
	#base_marry_heart{type = 4 ,lv = 14 ,attrs = [{crit,22}],goods_num = 20 };
get(5,14) ->
	#base_marry_heart{type = 5 ,lv = 14 ,attrs = [{ten,22}],goods_num = 20 };
get(6,14) ->
	#base_marry_heart{type = 6 ,lv = 14 ,attrs = [{hit,22}],goods_num = 20 };
get(7,14) ->
	#base_marry_heart{type = 7 ,lv = 14 ,attrs = [{dodge,22}],goods_num = 20 };
get(8,14) ->
	#base_marry_heart{type = 8 ,lv = 14 ,attrs = [{att,72},{def,72},{hp_lim,720}],goods_num = 60 };
get(1,15) ->
	#base_marry_heart{type = 1 ,lv = 15 ,attrs = [{att,80}],goods_num = 20 };
get(2,15) ->
	#base_marry_heart{type = 2 ,lv = 15 ,attrs = [{def,80}],goods_num = 20 };
get(3,15) ->
	#base_marry_heart{type = 3 ,lv = 15 ,attrs = [{hp_lim,800}],goods_num = 20 };
get(4,15) ->
	#base_marry_heart{type = 4 ,lv = 15 ,attrs = [{crit,25}],goods_num = 20 };
get(5,15) ->
	#base_marry_heart{type = 5 ,lv = 15 ,attrs = [{ten,25}],goods_num = 20 };
get(6,15) ->
	#base_marry_heart{type = 6 ,lv = 15 ,attrs = [{hit,25}],goods_num = 20 };
get(7,15) ->
	#base_marry_heart{type = 7 ,lv = 15 ,attrs = [{dodge,25}],goods_num = 20 };
get(8,15) ->
	#base_marry_heart{type = 8 ,lv = 15 ,attrs = [{att,80},{def,80},{hp_lim,800}],goods_num = 60 };
get(1,16) ->
	#base_marry_heart{type = 1 ,lv = 16 ,attrs = [{att,88}],goods_num = 20 };
get(2,16) ->
	#base_marry_heart{type = 2 ,lv = 16 ,attrs = [{def,88}],goods_num = 20 };
get(3,16) ->
	#base_marry_heart{type = 3 ,lv = 16 ,attrs = [{hp_lim,880}],goods_num = 20 };
get(4,16) ->
	#base_marry_heart{type = 4 ,lv = 16 ,attrs = [{crit,28}],goods_num = 20 };
get(5,16) ->
	#base_marry_heart{type = 5 ,lv = 16 ,attrs = [{ten,28}],goods_num = 20 };
get(6,16) ->
	#base_marry_heart{type = 6 ,lv = 16 ,attrs = [{hit,28}],goods_num = 20 };
get(7,16) ->
	#base_marry_heart{type = 7 ,lv = 16 ,attrs = [{dodge,28}],goods_num = 20 };
get(8,16) ->
	#base_marry_heart{type = 8 ,lv = 16 ,attrs = [{att,88},{def,88},{hp_lim,880}],goods_num = 60 };
get(1,17) ->
	#base_marry_heart{type = 1 ,lv = 17 ,attrs = [{att,96}],goods_num = 20 };
get(2,17) ->
	#base_marry_heart{type = 2 ,lv = 17 ,attrs = [{def,96}],goods_num = 20 };
get(3,17) ->
	#base_marry_heart{type = 3 ,lv = 17 ,attrs = [{hp_lim,960}],goods_num = 20 };
get(4,17) ->
	#base_marry_heart{type = 4 ,lv = 17 ,attrs = [{crit,31}],goods_num = 20 };
get(5,17) ->
	#base_marry_heart{type = 5 ,lv = 17 ,attrs = [{ten,31}],goods_num = 20 };
get(6,17) ->
	#base_marry_heart{type = 6 ,lv = 17 ,attrs = [{hit,31}],goods_num = 20 };
get(7,17) ->
	#base_marry_heart{type = 7 ,lv = 17 ,attrs = [{dodge,31}],goods_num = 20 };
get(8,17) ->
	#base_marry_heart{type = 8 ,lv = 17 ,attrs = [{att,96},{def,96},{hp_lim,960}],goods_num = 60 };
get(1,18) ->
	#base_marry_heart{type = 1 ,lv = 18 ,attrs = [{att,104}],goods_num = 20 };
get(2,18) ->
	#base_marry_heart{type = 2 ,lv = 18 ,attrs = [{def,104}],goods_num = 20 };
get(3,18) ->
	#base_marry_heart{type = 3 ,lv = 18 ,attrs = [{hp_lim,1040}],goods_num = 20 };
get(4,18) ->
	#base_marry_heart{type = 4 ,lv = 18 ,attrs = [{crit,34}],goods_num = 20 };
get(5,18) ->
	#base_marry_heart{type = 5 ,lv = 18 ,attrs = [{ten,34}],goods_num = 20 };
get(6,18) ->
	#base_marry_heart{type = 6 ,lv = 18 ,attrs = [{hit,34}],goods_num = 20 };
get(7,18) ->
	#base_marry_heart{type = 7 ,lv = 18 ,attrs = [{dodge,34}],goods_num = 20 };
get(8,18) ->
	#base_marry_heart{type = 8 ,lv = 18 ,attrs = [{att,104},{def,104},{hp_lim,1040}],goods_num = 60 };
get(1,19) ->
	#base_marry_heart{type = 1 ,lv = 19 ,attrs = [{att,112}],goods_num = 20 };
get(2,19) ->
	#base_marry_heart{type = 2 ,lv = 19 ,attrs = [{def,112}],goods_num = 20 };
get(3,19) ->
	#base_marry_heart{type = 3 ,lv = 19 ,attrs = [{hp_lim,1120}],goods_num = 20 };
get(4,19) ->
	#base_marry_heart{type = 4 ,lv = 19 ,attrs = [{crit,37}],goods_num = 20 };
get(5,19) ->
	#base_marry_heart{type = 5 ,lv = 19 ,attrs = [{ten,37}],goods_num = 20 };
get(6,19) ->
	#base_marry_heart{type = 6 ,lv = 19 ,attrs = [{hit,37}],goods_num = 20 };
get(7,19) ->
	#base_marry_heart{type = 7 ,lv = 19 ,attrs = [{dodge,37}],goods_num = 20 };
get(8,19) ->
	#base_marry_heart{type = 8 ,lv = 19 ,attrs = [{att,112},{def,112},{hp_lim,1120}],goods_num = 60 };
get(1,20) ->
	#base_marry_heart{type = 1 ,lv = 20 ,attrs = [{att,120}],goods_num = 20 };
get(2,20) ->
	#base_marry_heart{type = 2 ,lv = 20 ,attrs = [{def,120}],goods_num = 20 };
get(3,20) ->
	#base_marry_heart{type = 3 ,lv = 20 ,attrs = [{hp_lim,1200}],goods_num = 20 };
get(4,20) ->
	#base_marry_heart{type = 4 ,lv = 20 ,attrs = [{crit,40}],goods_num = 20 };
get(5,20) ->
	#base_marry_heart{type = 5 ,lv = 20 ,attrs = [{ten,40}],goods_num = 20 };
get(6,20) ->
	#base_marry_heart{type = 6 ,lv = 20 ,attrs = [{hit,40}],goods_num = 20 };
get(7,20) ->
	#base_marry_heart{type = 7 ,lv = 20 ,attrs = [{dodge,40}],goods_num = 20 };
get(8,20) ->
	#base_marry_heart{type = 8 ,lv = 20 ,attrs = [{att,120},{def,120},{hp_lim,1200}],goods_num = 60 };
get(1,21) ->
	#base_marry_heart{type = 1 ,lv = 21 ,attrs = [{att,132}],goods_num = 30 };
get(2,21) ->
	#base_marry_heart{type = 2 ,lv = 21 ,attrs = [{def,132}],goods_num = 30 };
get(3,21) ->
	#base_marry_heart{type = 3 ,lv = 21 ,attrs = [{hp_lim,1320}],goods_num = 30 };
get(4,21) ->
	#base_marry_heart{type = 4 ,lv = 21 ,attrs = [{crit,44}],goods_num = 30 };
get(5,21) ->
	#base_marry_heart{type = 5 ,lv = 21 ,attrs = [{ten,44}],goods_num = 30 };
get(6,21) ->
	#base_marry_heart{type = 6 ,lv = 21 ,attrs = [{hit,44}],goods_num = 30 };
get(7,21) ->
	#base_marry_heart{type = 7 ,lv = 21 ,attrs = [{dodge,44}],goods_num = 30 };
get(8,21) ->
	#base_marry_heart{type = 8 ,lv = 21 ,attrs = [{att,132},{def,132},{hp_lim,1320}],goods_num = 90 };
get(1,22) ->
	#base_marry_heart{type = 1 ,lv = 22 ,attrs = [{att,144}],goods_num = 30 };
get(2,22) ->
	#base_marry_heart{type = 2 ,lv = 22 ,attrs = [{def,144}],goods_num = 30 };
get(3,22) ->
	#base_marry_heart{type = 3 ,lv = 22 ,attrs = [{hp_lim,1440}],goods_num = 30 };
get(4,22) ->
	#base_marry_heart{type = 4 ,lv = 22 ,attrs = [{crit,48}],goods_num = 30 };
get(5,22) ->
	#base_marry_heart{type = 5 ,lv = 22 ,attrs = [{ten,48}],goods_num = 30 };
get(6,22) ->
	#base_marry_heart{type = 6 ,lv = 22 ,attrs = [{hit,48}],goods_num = 30 };
get(7,22) ->
	#base_marry_heart{type = 7 ,lv = 22 ,attrs = [{dodge,48}],goods_num = 30 };
get(8,22) ->
	#base_marry_heart{type = 8 ,lv = 22 ,attrs = [{att,144},{def,144},{hp_lim,1440}],goods_num = 90 };
get(1,23) ->
	#base_marry_heart{type = 1 ,lv = 23 ,attrs = [{att,156}],goods_num = 30 };
get(2,23) ->
	#base_marry_heart{type = 2 ,lv = 23 ,attrs = [{def,156}],goods_num = 30 };
get(3,23) ->
	#base_marry_heart{type = 3 ,lv = 23 ,attrs = [{hp_lim,1560}],goods_num = 30 };
get(4,23) ->
	#base_marry_heart{type = 4 ,lv = 23 ,attrs = [{crit,52}],goods_num = 30 };
get(5,23) ->
	#base_marry_heart{type = 5 ,lv = 23 ,attrs = [{ten,52}],goods_num = 30 };
get(6,23) ->
	#base_marry_heart{type = 6 ,lv = 23 ,attrs = [{hit,52}],goods_num = 30 };
get(7,23) ->
	#base_marry_heart{type = 7 ,lv = 23 ,attrs = [{dodge,52}],goods_num = 30 };
get(8,23) ->
	#base_marry_heart{type = 8 ,lv = 23 ,attrs = [{att,156},{def,156},{hp_lim,1560}],goods_num = 90 };
get(1,24) ->
	#base_marry_heart{type = 1 ,lv = 24 ,attrs = [{att,168}],goods_num = 30 };
get(2,24) ->
	#base_marry_heart{type = 2 ,lv = 24 ,attrs = [{def,168}],goods_num = 30 };
get(3,24) ->
	#base_marry_heart{type = 3 ,lv = 24 ,attrs = [{hp_lim,1680}],goods_num = 30 };
get(4,24) ->
	#base_marry_heart{type = 4 ,lv = 24 ,attrs = [{crit,56}],goods_num = 30 };
get(5,24) ->
	#base_marry_heart{type = 5 ,lv = 24 ,attrs = [{ten,56}],goods_num = 30 };
get(6,24) ->
	#base_marry_heart{type = 6 ,lv = 24 ,attrs = [{hit,56}],goods_num = 30 };
get(7,24) ->
	#base_marry_heart{type = 7 ,lv = 24 ,attrs = [{dodge,56}],goods_num = 30 };
get(8,24) ->
	#base_marry_heart{type = 8 ,lv = 24 ,attrs = [{att,168},{def,168},{hp_lim,1680}],goods_num = 90 };
get(1,25) ->
	#base_marry_heart{type = 1 ,lv = 25 ,attrs = [{att,180}],goods_num = 30 };
get(2,25) ->
	#base_marry_heart{type = 2 ,lv = 25 ,attrs = [{def,180}],goods_num = 30 };
get(3,25) ->
	#base_marry_heart{type = 3 ,lv = 25 ,attrs = [{hp_lim,1800}],goods_num = 30 };
get(4,25) ->
	#base_marry_heart{type = 4 ,lv = 25 ,attrs = [{crit,60}],goods_num = 30 };
get(5,25) ->
	#base_marry_heart{type = 5 ,lv = 25 ,attrs = [{ten,60}],goods_num = 30 };
get(6,25) ->
	#base_marry_heart{type = 6 ,lv = 25 ,attrs = [{hit,60}],goods_num = 30 };
get(7,25) ->
	#base_marry_heart{type = 7 ,lv = 25 ,attrs = [{dodge,60}],goods_num = 30 };
get(8,25) ->
	#base_marry_heart{type = 8 ,lv = 25 ,attrs = [{att,180},{def,180},{hp_lim,1800}],goods_num = 90 };
get(1,26) ->
	#base_marry_heart{type = 1 ,lv = 26 ,attrs = [{att,192}],goods_num = 30 };
get(2,26) ->
	#base_marry_heart{type = 2 ,lv = 26 ,attrs = [{def,192}],goods_num = 30 };
get(3,26) ->
	#base_marry_heart{type = 3 ,lv = 26 ,attrs = [{hp_lim,1920}],goods_num = 30 };
get(4,26) ->
	#base_marry_heart{type = 4 ,lv = 26 ,attrs = [{crit,64}],goods_num = 30 };
get(5,26) ->
	#base_marry_heart{type = 5 ,lv = 26 ,attrs = [{ten,64}],goods_num = 30 };
get(6,26) ->
	#base_marry_heart{type = 6 ,lv = 26 ,attrs = [{hit,64}],goods_num = 30 };
get(7,26) ->
	#base_marry_heart{type = 7 ,lv = 26 ,attrs = [{dodge,64}],goods_num = 30 };
get(8,26) ->
	#base_marry_heart{type = 8 ,lv = 26 ,attrs = [{att,192},{def,192},{hp_lim,1920}],goods_num = 90 };
get(1,27) ->
	#base_marry_heart{type = 1 ,lv = 27 ,attrs = [{att,204}],goods_num = 30 };
get(2,27) ->
	#base_marry_heart{type = 2 ,lv = 27 ,attrs = [{def,204}],goods_num = 30 };
get(3,27) ->
	#base_marry_heart{type = 3 ,lv = 27 ,attrs = [{hp_lim,2040}],goods_num = 30 };
get(4,27) ->
	#base_marry_heart{type = 4 ,lv = 27 ,attrs = [{crit,68}],goods_num = 30 };
get(5,27) ->
	#base_marry_heart{type = 5 ,lv = 27 ,attrs = [{ten,68}],goods_num = 30 };
get(6,27) ->
	#base_marry_heart{type = 6 ,lv = 27 ,attrs = [{hit,68}],goods_num = 30 };
get(7,27) ->
	#base_marry_heart{type = 7 ,lv = 27 ,attrs = [{dodge,68}],goods_num = 30 };
get(8,27) ->
	#base_marry_heart{type = 8 ,lv = 27 ,attrs = [{att,204},{def,204},{hp_lim,2040}],goods_num = 90 };
get(1,28) ->
	#base_marry_heart{type = 1 ,lv = 28 ,attrs = [{att,216}],goods_num = 30 };
get(2,28) ->
	#base_marry_heart{type = 2 ,lv = 28 ,attrs = [{def,216}],goods_num = 30 };
get(3,28) ->
	#base_marry_heart{type = 3 ,lv = 28 ,attrs = [{hp_lim,2160}],goods_num = 30 };
get(4,28) ->
	#base_marry_heart{type = 4 ,lv = 28 ,attrs = [{crit,72}],goods_num = 30 };
get(5,28) ->
	#base_marry_heart{type = 5 ,lv = 28 ,attrs = [{ten,72}],goods_num = 30 };
get(6,28) ->
	#base_marry_heart{type = 6 ,lv = 28 ,attrs = [{hit,72}],goods_num = 30 };
get(7,28) ->
	#base_marry_heart{type = 7 ,lv = 28 ,attrs = [{dodge,72}],goods_num = 30 };
get(8,28) ->
	#base_marry_heart{type = 8 ,lv = 28 ,attrs = [{att,216},{def,216},{hp_lim,2160}],goods_num = 90 };
get(1,29) ->
	#base_marry_heart{type = 1 ,lv = 29 ,attrs = [{att,228}],goods_num = 30 };
get(2,29) ->
	#base_marry_heart{type = 2 ,lv = 29 ,attrs = [{def,228}],goods_num = 30 };
get(3,29) ->
	#base_marry_heart{type = 3 ,lv = 29 ,attrs = [{hp_lim,2280}],goods_num = 30 };
get(4,29) ->
	#base_marry_heart{type = 4 ,lv = 29 ,attrs = [{crit,76}],goods_num = 30 };
get(5,29) ->
	#base_marry_heart{type = 5 ,lv = 29 ,attrs = [{ten,76}],goods_num = 30 };
get(6,29) ->
	#base_marry_heart{type = 6 ,lv = 29 ,attrs = [{hit,76}],goods_num = 30 };
get(7,29) ->
	#base_marry_heart{type = 7 ,lv = 29 ,attrs = [{dodge,76}],goods_num = 30 };
get(8,29) ->
	#base_marry_heart{type = 8 ,lv = 29 ,attrs = [{att,228},{def,228},{hp_lim,2280}],goods_num = 90 };
get(1,30) ->
	#base_marry_heart{type = 1 ,lv = 30 ,attrs = [{att,240}],goods_num = 30 };
get(2,30) ->
	#base_marry_heart{type = 2 ,lv = 30 ,attrs = [{def,240}],goods_num = 30 };
get(3,30) ->
	#base_marry_heart{type = 3 ,lv = 30 ,attrs = [{hp_lim,2400}],goods_num = 30 };
get(4,30) ->
	#base_marry_heart{type = 4 ,lv = 30 ,attrs = [{crit,80}],goods_num = 30 };
get(5,30) ->
	#base_marry_heart{type = 5 ,lv = 30 ,attrs = [{ten,80}],goods_num = 30 };
get(6,30) ->
	#base_marry_heart{type = 6 ,lv = 30 ,attrs = [{hit,80}],goods_num = 30 };
get(7,30) ->
	#base_marry_heart{type = 7 ,lv = 30 ,attrs = [{dodge,80}],goods_num = 30 };
get(8,30) ->
	#base_marry_heart{type = 8 ,lv = 30 ,attrs = [{att,240},{def,240},{hp_lim,2400}],goods_num = 90 };
get(1,31) ->
	#base_marry_heart{type = 1 ,lv = 31 ,attrs = [{att,256}],goods_num = 40 };
get(2,31) ->
	#base_marry_heart{type = 2 ,lv = 31 ,attrs = [{def,256}],goods_num = 40 };
get(3,31) ->
	#base_marry_heart{type = 3 ,lv = 31 ,attrs = [{hp_lim,2560}],goods_num = 40 };
get(4,31) ->
	#base_marry_heart{type = 4 ,lv = 31 ,attrs = [{crit,85}],goods_num = 40 };
get(5,31) ->
	#base_marry_heart{type = 5 ,lv = 31 ,attrs = [{ten,85}],goods_num = 40 };
get(6,31) ->
	#base_marry_heart{type = 6 ,lv = 31 ,attrs = [{hit,85}],goods_num = 40 };
get(7,31) ->
	#base_marry_heart{type = 7 ,lv = 31 ,attrs = [{dodge,85}],goods_num = 40 };
get(8,31) ->
	#base_marry_heart{type = 8 ,lv = 31 ,attrs = [{att,256},{def,256},{hp_lim,2560}],goods_num = 120 };
get(1,32) ->
	#base_marry_heart{type = 1 ,lv = 32 ,attrs = [{att,272}],goods_num = 40 };
get(2,32) ->
	#base_marry_heart{type = 2 ,lv = 32 ,attrs = [{def,272}],goods_num = 40 };
get(3,32) ->
	#base_marry_heart{type = 3 ,lv = 32 ,attrs = [{hp_lim,2720}],goods_num = 40 };
get(4,32) ->
	#base_marry_heart{type = 4 ,lv = 32 ,attrs = [{crit,90}],goods_num = 40 };
get(5,32) ->
	#base_marry_heart{type = 5 ,lv = 32 ,attrs = [{ten,90}],goods_num = 40 };
get(6,32) ->
	#base_marry_heart{type = 6 ,lv = 32 ,attrs = [{hit,90}],goods_num = 40 };
get(7,32) ->
	#base_marry_heart{type = 7 ,lv = 32 ,attrs = [{dodge,90}],goods_num = 40 };
get(8,32) ->
	#base_marry_heart{type = 8 ,lv = 32 ,attrs = [{att,272},{def,272},{hp_lim,2720}],goods_num = 120 };
get(1,33) ->
	#base_marry_heart{type = 1 ,lv = 33 ,attrs = [{att,288}],goods_num = 40 };
get(2,33) ->
	#base_marry_heart{type = 2 ,lv = 33 ,attrs = [{def,288}],goods_num = 40 };
get(3,33) ->
	#base_marry_heart{type = 3 ,lv = 33 ,attrs = [{hp_lim,2880}],goods_num = 40 };
get(4,33) ->
	#base_marry_heart{type = 4 ,lv = 33 ,attrs = [{crit,95}],goods_num = 40 };
get(5,33) ->
	#base_marry_heart{type = 5 ,lv = 33 ,attrs = [{ten,95}],goods_num = 40 };
get(6,33) ->
	#base_marry_heart{type = 6 ,lv = 33 ,attrs = [{hit,95}],goods_num = 40 };
get(7,33) ->
	#base_marry_heart{type = 7 ,lv = 33 ,attrs = [{dodge,95}],goods_num = 40 };
get(8,33) ->
	#base_marry_heart{type = 8 ,lv = 33 ,attrs = [{att,288},{def,288},{hp_lim,2880}],goods_num = 120 };
get(1,34) ->
	#base_marry_heart{type = 1 ,lv = 34 ,attrs = [{att,304}],goods_num = 40 };
get(2,34) ->
	#base_marry_heart{type = 2 ,lv = 34 ,attrs = [{def,304}],goods_num = 40 };
get(3,34) ->
	#base_marry_heart{type = 3 ,lv = 34 ,attrs = [{hp_lim,3040}],goods_num = 40 };
get(4,34) ->
	#base_marry_heart{type = 4 ,lv = 34 ,attrs = [{crit,100}],goods_num = 40 };
get(5,34) ->
	#base_marry_heart{type = 5 ,lv = 34 ,attrs = [{ten,100}],goods_num = 40 };
get(6,34) ->
	#base_marry_heart{type = 6 ,lv = 34 ,attrs = [{hit,100}],goods_num = 40 };
get(7,34) ->
	#base_marry_heart{type = 7 ,lv = 34 ,attrs = [{dodge,100}],goods_num = 40 };
get(8,34) ->
	#base_marry_heart{type = 8 ,lv = 34 ,attrs = [{att,304},{def,304},{hp_lim,3040}],goods_num = 120 };
get(1,35) ->
	#base_marry_heart{type = 1 ,lv = 35 ,attrs = [{att,320}],goods_num = 40 };
get(2,35) ->
	#base_marry_heart{type = 2 ,lv = 35 ,attrs = [{def,320}],goods_num = 40 };
get(3,35) ->
	#base_marry_heart{type = 3 ,lv = 35 ,attrs = [{hp_lim,3200}],goods_num = 40 };
get(4,35) ->
	#base_marry_heart{type = 4 ,lv = 35 ,attrs = [{crit,105}],goods_num = 40 };
get(5,35) ->
	#base_marry_heart{type = 5 ,lv = 35 ,attrs = [{ten,105}],goods_num = 40 };
get(6,35) ->
	#base_marry_heart{type = 6 ,lv = 35 ,attrs = [{hit,105}],goods_num = 40 };
get(7,35) ->
	#base_marry_heart{type = 7 ,lv = 35 ,attrs = [{dodge,105}],goods_num = 40 };
get(8,35) ->
	#base_marry_heart{type = 8 ,lv = 35 ,attrs = [{att,320},{def,320},{hp_lim,3200}],goods_num = 120 };
get(1,36) ->
	#base_marry_heart{type = 1 ,lv = 36 ,attrs = [{att,336}],goods_num = 40 };
get(2,36) ->
	#base_marry_heart{type = 2 ,lv = 36 ,attrs = [{def,336}],goods_num = 40 };
get(3,36) ->
	#base_marry_heart{type = 3 ,lv = 36 ,attrs = [{hp_lim,3360}],goods_num = 40 };
get(4,36) ->
	#base_marry_heart{type = 4 ,lv = 36 ,attrs = [{crit,110}],goods_num = 40 };
get(5,36) ->
	#base_marry_heart{type = 5 ,lv = 36 ,attrs = [{ten,110}],goods_num = 40 };
get(6,36) ->
	#base_marry_heart{type = 6 ,lv = 36 ,attrs = [{hit,110}],goods_num = 40 };
get(7,36) ->
	#base_marry_heart{type = 7 ,lv = 36 ,attrs = [{dodge,110}],goods_num = 40 };
get(8,36) ->
	#base_marry_heart{type = 8 ,lv = 36 ,attrs = [{att,336},{def,336},{hp_lim,3360}],goods_num = 120 };
get(1,37) ->
	#base_marry_heart{type = 1 ,lv = 37 ,attrs = [{att,352}],goods_num = 40 };
get(2,37) ->
	#base_marry_heart{type = 2 ,lv = 37 ,attrs = [{def,352}],goods_num = 40 };
get(3,37) ->
	#base_marry_heart{type = 3 ,lv = 37 ,attrs = [{hp_lim,3520}],goods_num = 40 };
get(4,37) ->
	#base_marry_heart{type = 4 ,lv = 37 ,attrs = [{crit,115}],goods_num = 40 };
get(5,37) ->
	#base_marry_heart{type = 5 ,lv = 37 ,attrs = [{ten,115}],goods_num = 40 };
get(6,37) ->
	#base_marry_heart{type = 6 ,lv = 37 ,attrs = [{hit,115}],goods_num = 40 };
get(7,37) ->
	#base_marry_heart{type = 7 ,lv = 37 ,attrs = [{dodge,115}],goods_num = 40 };
get(8,37) ->
	#base_marry_heart{type = 8 ,lv = 37 ,attrs = [{att,352},{def,352},{hp_lim,3520}],goods_num = 120 };
get(1,38) ->
	#base_marry_heart{type = 1 ,lv = 38 ,attrs = [{att,368}],goods_num = 40 };
get(2,38) ->
	#base_marry_heart{type = 2 ,lv = 38 ,attrs = [{def,368}],goods_num = 40 };
get(3,38) ->
	#base_marry_heart{type = 3 ,lv = 38 ,attrs = [{hp_lim,3680}],goods_num = 40 };
get(4,38) ->
	#base_marry_heart{type = 4 ,lv = 38 ,attrs = [{crit,120}],goods_num = 40 };
get(5,38) ->
	#base_marry_heart{type = 5 ,lv = 38 ,attrs = [{ten,120}],goods_num = 40 };
get(6,38) ->
	#base_marry_heart{type = 6 ,lv = 38 ,attrs = [{hit,120}],goods_num = 40 };
get(7,38) ->
	#base_marry_heart{type = 7 ,lv = 38 ,attrs = [{dodge,120}],goods_num = 40 };
get(8,38) ->
	#base_marry_heart{type = 8 ,lv = 38 ,attrs = [{att,368},{def,368},{hp_lim,3680}],goods_num = 120 };
get(1,39) ->
	#base_marry_heart{type = 1 ,lv = 39 ,attrs = [{att,384}],goods_num = 40 };
get(2,39) ->
	#base_marry_heart{type = 2 ,lv = 39 ,attrs = [{def,384}],goods_num = 40 };
get(3,39) ->
	#base_marry_heart{type = 3 ,lv = 39 ,attrs = [{hp_lim,3840}],goods_num = 40 };
get(4,39) ->
	#base_marry_heart{type = 4 ,lv = 39 ,attrs = [{crit,125}],goods_num = 40 };
get(5,39) ->
	#base_marry_heart{type = 5 ,lv = 39 ,attrs = [{ten,125}],goods_num = 40 };
get(6,39) ->
	#base_marry_heart{type = 6 ,lv = 39 ,attrs = [{hit,125}],goods_num = 40 };
get(7,39) ->
	#base_marry_heart{type = 7 ,lv = 39 ,attrs = [{dodge,125}],goods_num = 40 };
get(8,39) ->
	#base_marry_heart{type = 8 ,lv = 39 ,attrs = [{att,384},{def,384},{hp_lim,3840}],goods_num = 120 };
get(1,40) ->
	#base_marry_heart{type = 1 ,lv = 40 ,attrs = [{att,400}],goods_num = 40 };
get(2,40) ->
	#base_marry_heart{type = 2 ,lv = 40 ,attrs = [{def,400}],goods_num = 40 };
get(3,40) ->
	#base_marry_heart{type = 3 ,lv = 40 ,attrs = [{hp_lim,4000}],goods_num = 40 };
get(4,40) ->
	#base_marry_heart{type = 4 ,lv = 40 ,attrs = [{crit,130}],goods_num = 40 };
get(5,40) ->
	#base_marry_heart{type = 5 ,lv = 40 ,attrs = [{ten,130}],goods_num = 40 };
get(6,40) ->
	#base_marry_heart{type = 6 ,lv = 40 ,attrs = [{hit,130}],goods_num = 40 };
get(7,40) ->
	#base_marry_heart{type = 7 ,lv = 40 ,attrs = [{dodge,130}],goods_num = 40 };
get(8,40) ->
	#base_marry_heart{type = 8 ,lv = 40 ,attrs = [{att,400},{def,400},{hp_lim,4000}],goods_num = 120 };
get(1,41) ->
	#base_marry_heart{type = 1 ,lv = 41 ,attrs = [{att,420}],goods_num = 50 };
get(2,41) ->
	#base_marry_heart{type = 2 ,lv = 41 ,attrs = [{def,420}],goods_num = 50 };
get(3,41) ->
	#base_marry_heart{type = 3 ,lv = 41 ,attrs = [{hp_lim,4200}],goods_num = 50 };
get(4,41) ->
	#base_marry_heart{type = 4 ,lv = 41 ,attrs = [{crit,137}],goods_num = 50 };
get(5,41) ->
	#base_marry_heart{type = 5 ,lv = 41 ,attrs = [{ten,137}],goods_num = 50 };
get(6,41) ->
	#base_marry_heart{type = 6 ,lv = 41 ,attrs = [{hit,137}],goods_num = 50 };
get(7,41) ->
	#base_marry_heart{type = 7 ,lv = 41 ,attrs = [{dodge,137}],goods_num = 50 };
get(8,41) ->
	#base_marry_heart{type = 8 ,lv = 41 ,attrs = [{att,420},{def,420},{hp_lim,4200}],goods_num = 150 };
get(1,42) ->
	#base_marry_heart{type = 1 ,lv = 42 ,attrs = [{att,440}],goods_num = 50 };
get(2,42) ->
	#base_marry_heart{type = 2 ,lv = 42 ,attrs = [{def,440}],goods_num = 50 };
get(3,42) ->
	#base_marry_heart{type = 3 ,lv = 42 ,attrs = [{hp_lim,4400}],goods_num = 50 };
get(4,42) ->
	#base_marry_heart{type = 4 ,lv = 42 ,attrs = [{crit,144}],goods_num = 50 };
get(5,42) ->
	#base_marry_heart{type = 5 ,lv = 42 ,attrs = [{ten,144}],goods_num = 50 };
get(6,42) ->
	#base_marry_heart{type = 6 ,lv = 42 ,attrs = [{hit,144}],goods_num = 50 };
get(7,42) ->
	#base_marry_heart{type = 7 ,lv = 42 ,attrs = [{dodge,144}],goods_num = 50 };
get(8,42) ->
	#base_marry_heart{type = 8 ,lv = 42 ,attrs = [{att,440},{def,440},{hp_lim,4400}],goods_num = 150 };
get(1,43) ->
	#base_marry_heart{type = 1 ,lv = 43 ,attrs = [{att,460}],goods_num = 50 };
get(2,43) ->
	#base_marry_heart{type = 2 ,lv = 43 ,attrs = [{def,460}],goods_num = 50 };
get(3,43) ->
	#base_marry_heart{type = 3 ,lv = 43 ,attrs = [{hp_lim,4600}],goods_num = 50 };
get(4,43) ->
	#base_marry_heart{type = 4 ,lv = 43 ,attrs = [{crit,151}],goods_num = 50 };
get(5,43) ->
	#base_marry_heart{type = 5 ,lv = 43 ,attrs = [{ten,151}],goods_num = 50 };
get(6,43) ->
	#base_marry_heart{type = 6 ,lv = 43 ,attrs = [{hit,151}],goods_num = 50 };
get(7,43) ->
	#base_marry_heart{type = 7 ,lv = 43 ,attrs = [{dodge,151}],goods_num = 50 };
get(8,43) ->
	#base_marry_heart{type = 8 ,lv = 43 ,attrs = [{att,460},{def,460},{hp_lim,4600}],goods_num = 150 };
get(1,44) ->
	#base_marry_heart{type = 1 ,lv = 44 ,attrs = [{att,480}],goods_num = 50 };
get(2,44) ->
	#base_marry_heart{type = 2 ,lv = 44 ,attrs = [{def,480}],goods_num = 50 };
get(3,44) ->
	#base_marry_heart{type = 3 ,lv = 44 ,attrs = [{hp_lim,4800}],goods_num = 50 };
get(4,44) ->
	#base_marry_heart{type = 4 ,lv = 44 ,attrs = [{crit,158}],goods_num = 50 };
get(5,44) ->
	#base_marry_heart{type = 5 ,lv = 44 ,attrs = [{ten,158}],goods_num = 50 };
get(6,44) ->
	#base_marry_heart{type = 6 ,lv = 44 ,attrs = [{hit,158}],goods_num = 50 };
get(7,44) ->
	#base_marry_heart{type = 7 ,lv = 44 ,attrs = [{dodge,158}],goods_num = 50 };
get(8,44) ->
	#base_marry_heart{type = 8 ,lv = 44 ,attrs = [{att,480},{def,480},{hp_lim,4800}],goods_num = 150 };
get(1,45) ->
	#base_marry_heart{type = 1 ,lv = 45 ,attrs = [{att,500}],goods_num = 50 };
get(2,45) ->
	#base_marry_heart{type = 2 ,lv = 45 ,attrs = [{def,500}],goods_num = 50 };
get(3,45) ->
	#base_marry_heart{type = 3 ,lv = 45 ,attrs = [{hp_lim,5000}],goods_num = 50 };
get(4,45) ->
	#base_marry_heart{type = 4 ,lv = 45 ,attrs = [{crit,165}],goods_num = 50 };
get(5,45) ->
	#base_marry_heart{type = 5 ,lv = 45 ,attrs = [{ten,165}],goods_num = 50 };
get(6,45) ->
	#base_marry_heart{type = 6 ,lv = 45 ,attrs = [{hit,165}],goods_num = 50 };
get(7,45) ->
	#base_marry_heart{type = 7 ,lv = 45 ,attrs = [{dodge,165}],goods_num = 50 };
get(8,45) ->
	#base_marry_heart{type = 8 ,lv = 45 ,attrs = [{att,500},{def,500},{hp_lim,5000}],goods_num = 150 };
get(1,46) ->
	#base_marry_heart{type = 1 ,lv = 46 ,attrs = [{att,520}],goods_num = 50 };
get(2,46) ->
	#base_marry_heart{type = 2 ,lv = 46 ,attrs = [{def,520}],goods_num = 50 };
get(3,46) ->
	#base_marry_heart{type = 3 ,lv = 46 ,attrs = [{hp_lim,5200}],goods_num = 50 };
get(4,46) ->
	#base_marry_heart{type = 4 ,lv = 46 ,attrs = [{crit,172}],goods_num = 50 };
get(5,46) ->
	#base_marry_heart{type = 5 ,lv = 46 ,attrs = [{ten,172}],goods_num = 50 };
get(6,46) ->
	#base_marry_heart{type = 6 ,lv = 46 ,attrs = [{hit,172}],goods_num = 50 };
get(7,46) ->
	#base_marry_heart{type = 7 ,lv = 46 ,attrs = [{dodge,172}],goods_num = 50 };
get(8,46) ->
	#base_marry_heart{type = 8 ,lv = 46 ,attrs = [{att,520},{def,520},{hp_lim,5200}],goods_num = 150 };
get(1,47) ->
	#base_marry_heart{type = 1 ,lv = 47 ,attrs = [{att,540}],goods_num = 50 };
get(2,47) ->
	#base_marry_heart{type = 2 ,lv = 47 ,attrs = [{def,540}],goods_num = 50 };
get(3,47) ->
	#base_marry_heart{type = 3 ,lv = 47 ,attrs = [{hp_lim,5400}],goods_num = 50 };
get(4,47) ->
	#base_marry_heart{type = 4 ,lv = 47 ,attrs = [{crit,179}],goods_num = 50 };
get(5,47) ->
	#base_marry_heart{type = 5 ,lv = 47 ,attrs = [{ten,179}],goods_num = 50 };
get(6,47) ->
	#base_marry_heart{type = 6 ,lv = 47 ,attrs = [{hit,179}],goods_num = 50 };
get(7,47) ->
	#base_marry_heart{type = 7 ,lv = 47 ,attrs = [{dodge,179}],goods_num = 50 };
get(8,47) ->
	#base_marry_heart{type = 8 ,lv = 47 ,attrs = [{att,540},{def,540},{hp_lim,5400}],goods_num = 150 };
get(1,48) ->
	#base_marry_heart{type = 1 ,lv = 48 ,attrs = [{att,560}],goods_num = 50 };
get(2,48) ->
	#base_marry_heart{type = 2 ,lv = 48 ,attrs = [{def,560}],goods_num = 50 };
get(3,48) ->
	#base_marry_heart{type = 3 ,lv = 48 ,attrs = [{hp_lim,5600}],goods_num = 50 };
get(4,48) ->
	#base_marry_heart{type = 4 ,lv = 48 ,attrs = [{crit,186}],goods_num = 50 };
get(5,48) ->
	#base_marry_heart{type = 5 ,lv = 48 ,attrs = [{ten,186}],goods_num = 50 };
get(6,48) ->
	#base_marry_heart{type = 6 ,lv = 48 ,attrs = [{hit,186}],goods_num = 50 };
get(7,48) ->
	#base_marry_heart{type = 7 ,lv = 48 ,attrs = [{dodge,186}],goods_num = 50 };
get(8,48) ->
	#base_marry_heart{type = 8 ,lv = 48 ,attrs = [{att,560},{def,560},{hp_lim,5600}],goods_num = 150 };
get(1,49) ->
	#base_marry_heart{type = 1 ,lv = 49 ,attrs = [{att,580}],goods_num = 50 };
get(2,49) ->
	#base_marry_heart{type = 2 ,lv = 49 ,attrs = [{def,580}],goods_num = 50 };
get(3,49) ->
	#base_marry_heart{type = 3 ,lv = 49 ,attrs = [{hp_lim,5800}],goods_num = 50 };
get(4,49) ->
	#base_marry_heart{type = 4 ,lv = 49 ,attrs = [{crit,193}],goods_num = 50 };
get(5,49) ->
	#base_marry_heart{type = 5 ,lv = 49 ,attrs = [{ten,193}],goods_num = 50 };
get(6,49) ->
	#base_marry_heart{type = 6 ,lv = 49 ,attrs = [{hit,193}],goods_num = 50 };
get(7,49) ->
	#base_marry_heart{type = 7 ,lv = 49 ,attrs = [{dodge,193}],goods_num = 50 };
get(8,49) ->
	#base_marry_heart{type = 8 ,lv = 49 ,attrs = [{att,580},{def,580},{hp_lim,5800}],goods_num = 150 };
get(1,50) ->
	#base_marry_heart{type = 1 ,lv = 50 ,attrs = [{att,600}],goods_num = 50 };
get(2,50) ->
	#base_marry_heart{type = 2 ,lv = 50 ,attrs = [{def,600}],goods_num = 50 };
get(3,50) ->
	#base_marry_heart{type = 3 ,lv = 50 ,attrs = [{hp_lim,6000}],goods_num = 50 };
get(4,50) ->
	#base_marry_heart{type = 4 ,lv = 50 ,attrs = [{crit,200}],goods_num = 50 };
get(5,50) ->
	#base_marry_heart{type = 5 ,lv = 50 ,attrs = [{ten,200}],goods_num = 50 };
get(6,50) ->
	#base_marry_heart{type = 6 ,lv = 50 ,attrs = [{hit,200}],goods_num = 50 };
get(7,50) ->
	#base_marry_heart{type = 7 ,lv = 50 ,attrs = [{dodge,200}],goods_num = 50 };
get(8,50) ->
	#base_marry_heart{type = 8 ,lv = 50 ,attrs = [{att,600},{def,600},{hp_lim,6000}],goods_num = 150 };
get(1,51) ->
	#base_marry_heart{type = 1 ,lv = 51 ,attrs = [{att,624}],goods_num = 60 };
get(2,51) ->
	#base_marry_heart{type = 2 ,lv = 51 ,attrs = [{def,624}],goods_num = 60 };
get(3,51) ->
	#base_marry_heart{type = 3 ,lv = 51 ,attrs = [{hp_lim,6240}],goods_num = 60 };
get(4,51) ->
	#base_marry_heart{type = 4 ,lv = 51 ,attrs = [{crit,208}],goods_num = 60 };
get(5,51) ->
	#base_marry_heart{type = 5 ,lv = 51 ,attrs = [{ten,208}],goods_num = 60 };
get(6,51) ->
	#base_marry_heart{type = 6 ,lv = 51 ,attrs = [{hit,208}],goods_num = 60 };
get(7,51) ->
	#base_marry_heart{type = 7 ,lv = 51 ,attrs = [{dodge,208}],goods_num = 60 };
get(8,51) ->
	#base_marry_heart{type = 8 ,lv = 51 ,attrs = [{att,624},{def,624},{hp_lim,6240}],goods_num = 180 };
get(1,52) ->
	#base_marry_heart{type = 1 ,lv = 52 ,attrs = [{att,648}],goods_num = 60 };
get(2,52) ->
	#base_marry_heart{type = 2 ,lv = 52 ,attrs = [{def,648}],goods_num = 60 };
get(3,52) ->
	#base_marry_heart{type = 3 ,lv = 52 ,attrs = [{hp_lim,6480}],goods_num = 60 };
get(4,52) ->
	#base_marry_heart{type = 4 ,lv = 52 ,attrs = [{crit,216}],goods_num = 60 };
get(5,52) ->
	#base_marry_heart{type = 5 ,lv = 52 ,attrs = [{ten,216}],goods_num = 60 };
get(6,52) ->
	#base_marry_heart{type = 6 ,lv = 52 ,attrs = [{hit,216}],goods_num = 60 };
get(7,52) ->
	#base_marry_heart{type = 7 ,lv = 52 ,attrs = [{dodge,216}],goods_num = 60 };
get(8,52) ->
	#base_marry_heart{type = 8 ,lv = 52 ,attrs = [{att,648},{def,648},{hp_lim,6480}],goods_num = 180 };
get(1,53) ->
	#base_marry_heart{type = 1 ,lv = 53 ,attrs = [{att,672}],goods_num = 60 };
get(2,53) ->
	#base_marry_heart{type = 2 ,lv = 53 ,attrs = [{def,672}],goods_num = 60 };
get(3,53) ->
	#base_marry_heart{type = 3 ,lv = 53 ,attrs = [{hp_lim,6720}],goods_num = 60 };
get(4,53) ->
	#base_marry_heart{type = 4 ,lv = 53 ,attrs = [{crit,224}],goods_num = 60 };
get(5,53) ->
	#base_marry_heart{type = 5 ,lv = 53 ,attrs = [{ten,224}],goods_num = 60 };
get(6,53) ->
	#base_marry_heart{type = 6 ,lv = 53 ,attrs = [{hit,224}],goods_num = 60 };
get(7,53) ->
	#base_marry_heart{type = 7 ,lv = 53 ,attrs = [{dodge,224}],goods_num = 60 };
get(8,53) ->
	#base_marry_heart{type = 8 ,lv = 53 ,attrs = [{att,672},{def,672},{hp_lim,6720}],goods_num = 180 };
get(1,54) ->
	#base_marry_heart{type = 1 ,lv = 54 ,attrs = [{att,696}],goods_num = 60 };
get(2,54) ->
	#base_marry_heart{type = 2 ,lv = 54 ,attrs = [{def,696}],goods_num = 60 };
get(3,54) ->
	#base_marry_heart{type = 3 ,lv = 54 ,attrs = [{hp_lim,6960}],goods_num = 60 };
get(4,54) ->
	#base_marry_heart{type = 4 ,lv = 54 ,attrs = [{crit,232}],goods_num = 60 };
get(5,54) ->
	#base_marry_heart{type = 5 ,lv = 54 ,attrs = [{ten,232}],goods_num = 60 };
get(6,54) ->
	#base_marry_heart{type = 6 ,lv = 54 ,attrs = [{hit,232}],goods_num = 60 };
get(7,54) ->
	#base_marry_heart{type = 7 ,lv = 54 ,attrs = [{dodge,232}],goods_num = 60 };
get(8,54) ->
	#base_marry_heart{type = 8 ,lv = 54 ,attrs = [{att,696},{def,696},{hp_lim,6960}],goods_num = 180 };
get(1,55) ->
	#base_marry_heart{type = 1 ,lv = 55 ,attrs = [{att,720}],goods_num = 60 };
get(2,55) ->
	#base_marry_heart{type = 2 ,lv = 55 ,attrs = [{def,720}],goods_num = 60 };
get(3,55) ->
	#base_marry_heart{type = 3 ,lv = 55 ,attrs = [{hp_lim,7200}],goods_num = 60 };
get(4,55) ->
	#base_marry_heart{type = 4 ,lv = 55 ,attrs = [{crit,240}],goods_num = 60 };
get(5,55) ->
	#base_marry_heart{type = 5 ,lv = 55 ,attrs = [{ten,240}],goods_num = 60 };
get(6,55) ->
	#base_marry_heart{type = 6 ,lv = 55 ,attrs = [{hit,240}],goods_num = 60 };
get(7,55) ->
	#base_marry_heart{type = 7 ,lv = 55 ,attrs = [{dodge,240}],goods_num = 60 };
get(8,55) ->
	#base_marry_heart{type = 8 ,lv = 55 ,attrs = [{att,720},{def,720},{hp_lim,7200}],goods_num = 180 };
get(1,56) ->
	#base_marry_heart{type = 1 ,lv = 56 ,attrs = [{att,744}],goods_num = 60 };
get(2,56) ->
	#base_marry_heart{type = 2 ,lv = 56 ,attrs = [{def,744}],goods_num = 60 };
get(3,56) ->
	#base_marry_heart{type = 3 ,lv = 56 ,attrs = [{hp_lim,7440}],goods_num = 60 };
get(4,56) ->
	#base_marry_heart{type = 4 ,lv = 56 ,attrs = [{crit,248}],goods_num = 60 };
get(5,56) ->
	#base_marry_heart{type = 5 ,lv = 56 ,attrs = [{ten,248}],goods_num = 60 };
get(6,56) ->
	#base_marry_heart{type = 6 ,lv = 56 ,attrs = [{hit,248}],goods_num = 60 };
get(7,56) ->
	#base_marry_heart{type = 7 ,lv = 56 ,attrs = [{dodge,248}],goods_num = 60 };
get(8,56) ->
	#base_marry_heart{type = 8 ,lv = 56 ,attrs = [{att,744},{def,744},{hp_lim,7440}],goods_num = 180 };
get(1,57) ->
	#base_marry_heart{type = 1 ,lv = 57 ,attrs = [{att,768}],goods_num = 60 };
get(2,57) ->
	#base_marry_heart{type = 2 ,lv = 57 ,attrs = [{def,768}],goods_num = 60 };
get(3,57) ->
	#base_marry_heart{type = 3 ,lv = 57 ,attrs = [{hp_lim,7680}],goods_num = 60 };
get(4,57) ->
	#base_marry_heart{type = 4 ,lv = 57 ,attrs = [{crit,256}],goods_num = 60 };
get(5,57) ->
	#base_marry_heart{type = 5 ,lv = 57 ,attrs = [{ten,256}],goods_num = 60 };
get(6,57) ->
	#base_marry_heart{type = 6 ,lv = 57 ,attrs = [{hit,256}],goods_num = 60 };
get(7,57) ->
	#base_marry_heart{type = 7 ,lv = 57 ,attrs = [{dodge,256}],goods_num = 60 };
get(8,57) ->
	#base_marry_heart{type = 8 ,lv = 57 ,attrs = [{att,768},{def,768},{hp_lim,7680}],goods_num = 180 };
get(1,58) ->
	#base_marry_heart{type = 1 ,lv = 58 ,attrs = [{att,792}],goods_num = 60 };
get(2,58) ->
	#base_marry_heart{type = 2 ,lv = 58 ,attrs = [{def,792}],goods_num = 60 };
get(3,58) ->
	#base_marry_heart{type = 3 ,lv = 58 ,attrs = [{hp_lim,7920}],goods_num = 60 };
get(4,58) ->
	#base_marry_heart{type = 4 ,lv = 58 ,attrs = [{crit,264}],goods_num = 60 };
get(5,58) ->
	#base_marry_heart{type = 5 ,lv = 58 ,attrs = [{ten,264}],goods_num = 60 };
get(6,58) ->
	#base_marry_heart{type = 6 ,lv = 58 ,attrs = [{hit,264}],goods_num = 60 };
get(7,58) ->
	#base_marry_heart{type = 7 ,lv = 58 ,attrs = [{dodge,264}],goods_num = 60 };
get(8,58) ->
	#base_marry_heart{type = 8 ,lv = 58 ,attrs = [{att,792},{def,792},{hp_lim,7920}],goods_num = 180 };
get(1,59) ->
	#base_marry_heart{type = 1 ,lv = 59 ,attrs = [{att,816}],goods_num = 60 };
get(2,59) ->
	#base_marry_heart{type = 2 ,lv = 59 ,attrs = [{def,816}],goods_num = 60 };
get(3,59) ->
	#base_marry_heart{type = 3 ,lv = 59 ,attrs = [{hp_lim,8160}],goods_num = 60 };
get(4,59) ->
	#base_marry_heart{type = 4 ,lv = 59 ,attrs = [{crit,272}],goods_num = 60 };
get(5,59) ->
	#base_marry_heart{type = 5 ,lv = 59 ,attrs = [{ten,272}],goods_num = 60 };
get(6,59) ->
	#base_marry_heart{type = 6 ,lv = 59 ,attrs = [{hit,272}],goods_num = 60 };
get(7,59) ->
	#base_marry_heart{type = 7 ,lv = 59 ,attrs = [{dodge,272}],goods_num = 60 };
get(8,59) ->
	#base_marry_heart{type = 8 ,lv = 59 ,attrs = [{att,816},{def,816},{hp_lim,8160}],goods_num = 180 };
get(1,60) ->
	#base_marry_heart{type = 1 ,lv = 60 ,attrs = [{att,840}],goods_num = 60 };
get(2,60) ->
	#base_marry_heart{type = 2 ,lv = 60 ,attrs = [{def,840}],goods_num = 60 };
get(3,60) ->
	#base_marry_heart{type = 3 ,lv = 60 ,attrs = [{hp_lim,8400}],goods_num = 60 };
get(4,60) ->
	#base_marry_heart{type = 4 ,lv = 60 ,attrs = [{crit,280}],goods_num = 60 };
get(5,60) ->
	#base_marry_heart{type = 5 ,lv = 60 ,attrs = [{ten,280}],goods_num = 60 };
get(6,60) ->
	#base_marry_heart{type = 6 ,lv = 60 ,attrs = [{hit,280}],goods_num = 60 };
get(7,60) ->
	#base_marry_heart{type = 7 ,lv = 60 ,attrs = [{dodge,280}],goods_num = 60 };
get(8,60) ->
	#base_marry_heart{type = 8 ,lv = 60 ,attrs = [{att,840},{def,840},{hp_lim,8400}],goods_num = 180 };
get(1,61) ->
	#base_marry_heart{type = 1 ,lv = 61 ,attrs = [{att,868}],goods_num = 70 };
get(2,61) ->
	#base_marry_heart{type = 2 ,lv = 61 ,attrs = [{def,868}],goods_num = 70 };
get(3,61) ->
	#base_marry_heart{type = 3 ,lv = 61 ,attrs = [{hp_lim,8680}],goods_num = 70 };
get(4,61) ->
	#base_marry_heart{type = 4 ,lv = 61 ,attrs = [{crit,289}],goods_num = 70 };
get(5,61) ->
	#base_marry_heart{type = 5 ,lv = 61 ,attrs = [{ten,289}],goods_num = 70 };
get(6,61) ->
	#base_marry_heart{type = 6 ,lv = 61 ,attrs = [{hit,289}],goods_num = 70 };
get(7,61) ->
	#base_marry_heart{type = 7 ,lv = 61 ,attrs = [{dodge,289}],goods_num = 70 };
get(8,61) ->
	#base_marry_heart{type = 8 ,lv = 61 ,attrs = [{att,868},{def,868},{hp_lim,8680}],goods_num = 210 };
get(1,62) ->
	#base_marry_heart{type = 1 ,lv = 62 ,attrs = [{att,896}],goods_num = 70 };
get(2,62) ->
	#base_marry_heart{type = 2 ,lv = 62 ,attrs = [{def,896}],goods_num = 70 };
get(3,62) ->
	#base_marry_heart{type = 3 ,lv = 62 ,attrs = [{hp_lim,8960}],goods_num = 70 };
get(4,62) ->
	#base_marry_heart{type = 4 ,lv = 62 ,attrs = [{crit,298}],goods_num = 70 };
get(5,62) ->
	#base_marry_heart{type = 5 ,lv = 62 ,attrs = [{ten,298}],goods_num = 70 };
get(6,62) ->
	#base_marry_heart{type = 6 ,lv = 62 ,attrs = [{hit,298}],goods_num = 70 };
get(7,62) ->
	#base_marry_heart{type = 7 ,lv = 62 ,attrs = [{dodge,298}],goods_num = 70 };
get(8,62) ->
	#base_marry_heart{type = 8 ,lv = 62 ,attrs = [{att,896},{def,896},{hp_lim,8960}],goods_num = 210 };
get(1,63) ->
	#base_marry_heart{type = 1 ,lv = 63 ,attrs = [{att,924}],goods_num = 70 };
get(2,63) ->
	#base_marry_heart{type = 2 ,lv = 63 ,attrs = [{def,924}],goods_num = 70 };
get(3,63) ->
	#base_marry_heart{type = 3 ,lv = 63 ,attrs = [{hp_lim,9240}],goods_num = 70 };
get(4,63) ->
	#base_marry_heart{type = 4 ,lv = 63 ,attrs = [{crit,307}],goods_num = 70 };
get(5,63) ->
	#base_marry_heart{type = 5 ,lv = 63 ,attrs = [{ten,307}],goods_num = 70 };
get(6,63) ->
	#base_marry_heart{type = 6 ,lv = 63 ,attrs = [{hit,307}],goods_num = 70 };
get(7,63) ->
	#base_marry_heart{type = 7 ,lv = 63 ,attrs = [{dodge,307}],goods_num = 70 };
get(8,63) ->
	#base_marry_heart{type = 8 ,lv = 63 ,attrs = [{att,924},{def,924},{hp_lim,9240}],goods_num = 210 };
get(1,64) ->
	#base_marry_heart{type = 1 ,lv = 64 ,attrs = [{att,952}],goods_num = 70 };
get(2,64) ->
	#base_marry_heart{type = 2 ,lv = 64 ,attrs = [{def,952}],goods_num = 70 };
get(3,64) ->
	#base_marry_heart{type = 3 ,lv = 64 ,attrs = [{hp_lim,9520}],goods_num = 70 };
get(4,64) ->
	#base_marry_heart{type = 4 ,lv = 64 ,attrs = [{crit,316}],goods_num = 70 };
get(5,64) ->
	#base_marry_heart{type = 5 ,lv = 64 ,attrs = [{ten,316}],goods_num = 70 };
get(6,64) ->
	#base_marry_heart{type = 6 ,lv = 64 ,attrs = [{hit,316}],goods_num = 70 };
get(7,64) ->
	#base_marry_heart{type = 7 ,lv = 64 ,attrs = [{dodge,316}],goods_num = 70 };
get(8,64) ->
	#base_marry_heart{type = 8 ,lv = 64 ,attrs = [{att,952},{def,952},{hp_lim,9520}],goods_num = 210 };
get(1,65) ->
	#base_marry_heart{type = 1 ,lv = 65 ,attrs = [{att,980}],goods_num = 70 };
get(2,65) ->
	#base_marry_heart{type = 2 ,lv = 65 ,attrs = [{def,980}],goods_num = 70 };
get(3,65) ->
	#base_marry_heart{type = 3 ,lv = 65 ,attrs = [{hp_lim,9800}],goods_num = 70 };
get(4,65) ->
	#base_marry_heart{type = 4 ,lv = 65 ,attrs = [{crit,325}],goods_num = 70 };
get(5,65) ->
	#base_marry_heart{type = 5 ,lv = 65 ,attrs = [{ten,325}],goods_num = 70 };
get(6,65) ->
	#base_marry_heart{type = 6 ,lv = 65 ,attrs = [{hit,325}],goods_num = 70 };
get(7,65) ->
	#base_marry_heart{type = 7 ,lv = 65 ,attrs = [{dodge,325}],goods_num = 70 };
get(8,65) ->
	#base_marry_heart{type = 8 ,lv = 65 ,attrs = [{att,980},{def,980},{hp_lim,9800}],goods_num = 210 };
get(1,66) ->
	#base_marry_heart{type = 1 ,lv = 66 ,attrs = [{att,1008}],goods_num = 70 };
get(2,66) ->
	#base_marry_heart{type = 2 ,lv = 66 ,attrs = [{def,1008}],goods_num = 70 };
get(3,66) ->
	#base_marry_heart{type = 3 ,lv = 66 ,attrs = [{hp_lim,10080}],goods_num = 70 };
get(4,66) ->
	#base_marry_heart{type = 4 ,lv = 66 ,attrs = [{crit,334}],goods_num = 70 };
get(5,66) ->
	#base_marry_heart{type = 5 ,lv = 66 ,attrs = [{ten,334}],goods_num = 70 };
get(6,66) ->
	#base_marry_heart{type = 6 ,lv = 66 ,attrs = [{hit,334}],goods_num = 70 };
get(7,66) ->
	#base_marry_heart{type = 7 ,lv = 66 ,attrs = [{dodge,334}],goods_num = 70 };
get(8,66) ->
	#base_marry_heart{type = 8 ,lv = 66 ,attrs = [{att,1008},{def,1008},{hp_lim,10080}],goods_num = 210 };
get(1,67) ->
	#base_marry_heart{type = 1 ,lv = 67 ,attrs = [{att,1036}],goods_num = 70 };
get(2,67) ->
	#base_marry_heart{type = 2 ,lv = 67 ,attrs = [{def,1036}],goods_num = 70 };
get(3,67) ->
	#base_marry_heart{type = 3 ,lv = 67 ,attrs = [{hp_lim,10360}],goods_num = 70 };
get(4,67) ->
	#base_marry_heart{type = 4 ,lv = 67 ,attrs = [{crit,343}],goods_num = 70 };
get(5,67) ->
	#base_marry_heart{type = 5 ,lv = 67 ,attrs = [{ten,343}],goods_num = 70 };
get(6,67) ->
	#base_marry_heart{type = 6 ,lv = 67 ,attrs = [{hit,343}],goods_num = 70 };
get(7,67) ->
	#base_marry_heart{type = 7 ,lv = 67 ,attrs = [{dodge,343}],goods_num = 70 };
get(8,67) ->
	#base_marry_heart{type = 8 ,lv = 67 ,attrs = [{att,1036},{def,1036},{hp_lim,10360}],goods_num = 210 };
get(1,68) ->
	#base_marry_heart{type = 1 ,lv = 68 ,attrs = [{att,1064}],goods_num = 70 };
get(2,68) ->
	#base_marry_heart{type = 2 ,lv = 68 ,attrs = [{def,1064}],goods_num = 70 };
get(3,68) ->
	#base_marry_heart{type = 3 ,lv = 68 ,attrs = [{hp_lim,10640}],goods_num = 70 };
get(4,68) ->
	#base_marry_heart{type = 4 ,lv = 68 ,attrs = [{crit,352}],goods_num = 70 };
get(5,68) ->
	#base_marry_heart{type = 5 ,lv = 68 ,attrs = [{ten,352}],goods_num = 70 };
get(6,68) ->
	#base_marry_heart{type = 6 ,lv = 68 ,attrs = [{hit,352}],goods_num = 70 };
get(7,68) ->
	#base_marry_heart{type = 7 ,lv = 68 ,attrs = [{dodge,352}],goods_num = 70 };
get(8,68) ->
	#base_marry_heart{type = 8 ,lv = 68 ,attrs = [{att,1064},{def,1064},{hp_lim,10640}],goods_num = 210 };
get(1,69) ->
	#base_marry_heart{type = 1 ,lv = 69 ,attrs = [{att,1092}],goods_num = 70 };
get(2,69) ->
	#base_marry_heart{type = 2 ,lv = 69 ,attrs = [{def,1092}],goods_num = 70 };
get(3,69) ->
	#base_marry_heart{type = 3 ,lv = 69 ,attrs = [{hp_lim,10920}],goods_num = 70 };
get(4,69) ->
	#base_marry_heart{type = 4 ,lv = 69 ,attrs = [{crit,361}],goods_num = 70 };
get(5,69) ->
	#base_marry_heart{type = 5 ,lv = 69 ,attrs = [{ten,361}],goods_num = 70 };
get(6,69) ->
	#base_marry_heart{type = 6 ,lv = 69 ,attrs = [{hit,361}],goods_num = 70 };
get(7,69) ->
	#base_marry_heart{type = 7 ,lv = 69 ,attrs = [{dodge,361}],goods_num = 70 };
get(8,69) ->
	#base_marry_heart{type = 8 ,lv = 69 ,attrs = [{att,1092},{def,1092},{hp_lim,10920}],goods_num = 210 };
get(1,70) ->
	#base_marry_heart{type = 1 ,lv = 70 ,attrs = [{att,1120}],goods_num = 70 };
get(2,70) ->
	#base_marry_heart{type = 2 ,lv = 70 ,attrs = [{def,1120}],goods_num = 70 };
get(3,70) ->
	#base_marry_heart{type = 3 ,lv = 70 ,attrs = [{hp_lim,11200}],goods_num = 70 };
get(4,70) ->
	#base_marry_heart{type = 4 ,lv = 70 ,attrs = [{crit,370}],goods_num = 70 };
get(5,70) ->
	#base_marry_heart{type = 5 ,lv = 70 ,attrs = [{ten,370}],goods_num = 70 };
get(6,70) ->
	#base_marry_heart{type = 6 ,lv = 70 ,attrs = [{hit,370}],goods_num = 70 };
get(7,70) ->
	#base_marry_heart{type = 7 ,lv = 70 ,attrs = [{dodge,370}],goods_num = 70 };
get(8,70) ->
	#base_marry_heart{type = 8 ,lv = 70 ,attrs = [{att,1120},{def,1120},{hp_lim,11200}],goods_num = 210 };
get(1,71) ->
	#base_marry_heart{type = 1 ,lv = 71 ,attrs = [{att,1152}],goods_num = 80 };
get(2,71) ->
	#base_marry_heart{type = 2 ,lv = 71 ,attrs = [{def,1152}],goods_num = 80 };
get(3,71) ->
	#base_marry_heart{type = 3 ,lv = 71 ,attrs = [{hp_lim,11520}],goods_num = 80 };
get(4,71) ->
	#base_marry_heart{type = 4 ,lv = 71 ,attrs = [{crit,381}],goods_num = 80 };
get(5,71) ->
	#base_marry_heart{type = 5 ,lv = 71 ,attrs = [{ten,381}],goods_num = 80 };
get(6,71) ->
	#base_marry_heart{type = 6 ,lv = 71 ,attrs = [{hit,381}],goods_num = 80 };
get(7,71) ->
	#base_marry_heart{type = 7 ,lv = 71 ,attrs = [{dodge,381}],goods_num = 80 };
get(8,71) ->
	#base_marry_heart{type = 8 ,lv = 71 ,attrs = [{att,1152},{def,1152},{hp_lim,11520}],goods_num = 240 };
get(1,72) ->
	#base_marry_heart{type = 1 ,lv = 72 ,attrs = [{att,1184}],goods_num = 80 };
get(2,72) ->
	#base_marry_heart{type = 2 ,lv = 72 ,attrs = [{def,1184}],goods_num = 80 };
get(3,72) ->
	#base_marry_heart{type = 3 ,lv = 72 ,attrs = [{hp_lim,11840}],goods_num = 80 };
get(4,72) ->
	#base_marry_heart{type = 4 ,lv = 72 ,attrs = [{crit,392}],goods_num = 80 };
get(5,72) ->
	#base_marry_heart{type = 5 ,lv = 72 ,attrs = [{ten,392}],goods_num = 80 };
get(6,72) ->
	#base_marry_heart{type = 6 ,lv = 72 ,attrs = [{hit,392}],goods_num = 80 };
get(7,72) ->
	#base_marry_heart{type = 7 ,lv = 72 ,attrs = [{dodge,392}],goods_num = 80 };
get(8,72) ->
	#base_marry_heart{type = 8 ,lv = 72 ,attrs = [{att,1184},{def,1184},{hp_lim,11840}],goods_num = 240 };
get(1,73) ->
	#base_marry_heart{type = 1 ,lv = 73 ,attrs = [{att,1216}],goods_num = 80 };
get(2,73) ->
	#base_marry_heart{type = 2 ,lv = 73 ,attrs = [{def,1216}],goods_num = 80 };
get(3,73) ->
	#base_marry_heart{type = 3 ,lv = 73 ,attrs = [{hp_lim,12160}],goods_num = 80 };
get(4,73) ->
	#base_marry_heart{type = 4 ,lv = 73 ,attrs = [{crit,403}],goods_num = 80 };
get(5,73) ->
	#base_marry_heart{type = 5 ,lv = 73 ,attrs = [{ten,403}],goods_num = 80 };
get(6,73) ->
	#base_marry_heart{type = 6 ,lv = 73 ,attrs = [{hit,403}],goods_num = 80 };
get(7,73) ->
	#base_marry_heart{type = 7 ,lv = 73 ,attrs = [{dodge,403}],goods_num = 80 };
get(8,73) ->
	#base_marry_heart{type = 8 ,lv = 73 ,attrs = [{att,1216},{def,1216},{hp_lim,12160}],goods_num = 240 };
get(1,74) ->
	#base_marry_heart{type = 1 ,lv = 74 ,attrs = [{att,1248}],goods_num = 80 };
get(2,74) ->
	#base_marry_heart{type = 2 ,lv = 74 ,attrs = [{def,1248}],goods_num = 80 };
get(3,74) ->
	#base_marry_heart{type = 3 ,lv = 74 ,attrs = [{hp_lim,12480}],goods_num = 80 };
get(4,74) ->
	#base_marry_heart{type = 4 ,lv = 74 ,attrs = [{crit,414}],goods_num = 80 };
get(5,74) ->
	#base_marry_heart{type = 5 ,lv = 74 ,attrs = [{ten,414}],goods_num = 80 };
get(6,74) ->
	#base_marry_heart{type = 6 ,lv = 74 ,attrs = [{hit,414}],goods_num = 80 };
get(7,74) ->
	#base_marry_heart{type = 7 ,lv = 74 ,attrs = [{dodge,414}],goods_num = 80 };
get(8,74) ->
	#base_marry_heart{type = 8 ,lv = 74 ,attrs = [{att,1248},{def,1248},{hp_lim,12480}],goods_num = 240 };
get(1,75) ->
	#base_marry_heart{type = 1 ,lv = 75 ,attrs = [{att,1280}],goods_num = 80 };
get(2,75) ->
	#base_marry_heart{type = 2 ,lv = 75 ,attrs = [{def,1280}],goods_num = 80 };
get(3,75) ->
	#base_marry_heart{type = 3 ,lv = 75 ,attrs = [{hp_lim,12800}],goods_num = 80 };
get(4,75) ->
	#base_marry_heart{type = 4 ,lv = 75 ,attrs = [{crit,425}],goods_num = 80 };
get(5,75) ->
	#base_marry_heart{type = 5 ,lv = 75 ,attrs = [{ten,425}],goods_num = 80 };
get(6,75) ->
	#base_marry_heart{type = 6 ,lv = 75 ,attrs = [{hit,425}],goods_num = 80 };
get(7,75) ->
	#base_marry_heart{type = 7 ,lv = 75 ,attrs = [{dodge,425}],goods_num = 80 };
get(8,75) ->
	#base_marry_heart{type = 8 ,lv = 75 ,attrs = [{att,1280},{def,1280},{hp_lim,12800}],goods_num = 240 };
get(1,76) ->
	#base_marry_heart{type = 1 ,lv = 76 ,attrs = [{att,1312}],goods_num = 80 };
get(2,76) ->
	#base_marry_heart{type = 2 ,lv = 76 ,attrs = [{def,1312}],goods_num = 80 };
get(3,76) ->
	#base_marry_heart{type = 3 ,lv = 76 ,attrs = [{hp_lim,13120}],goods_num = 80 };
get(4,76) ->
	#base_marry_heart{type = 4 ,lv = 76 ,attrs = [{crit,436}],goods_num = 80 };
get(5,76) ->
	#base_marry_heart{type = 5 ,lv = 76 ,attrs = [{ten,436}],goods_num = 80 };
get(6,76) ->
	#base_marry_heart{type = 6 ,lv = 76 ,attrs = [{hit,436}],goods_num = 80 };
get(7,76) ->
	#base_marry_heart{type = 7 ,lv = 76 ,attrs = [{dodge,436}],goods_num = 80 };
get(8,76) ->
	#base_marry_heart{type = 8 ,lv = 76 ,attrs = [{att,1312},{def,1312},{hp_lim,13120}],goods_num = 240 };
get(1,77) ->
	#base_marry_heart{type = 1 ,lv = 77 ,attrs = [{att,1344}],goods_num = 80 };
get(2,77) ->
	#base_marry_heart{type = 2 ,lv = 77 ,attrs = [{def,1344}],goods_num = 80 };
get(3,77) ->
	#base_marry_heart{type = 3 ,lv = 77 ,attrs = [{hp_lim,13440}],goods_num = 80 };
get(4,77) ->
	#base_marry_heart{type = 4 ,lv = 77 ,attrs = [{crit,447}],goods_num = 80 };
get(5,77) ->
	#base_marry_heart{type = 5 ,lv = 77 ,attrs = [{ten,447}],goods_num = 80 };
get(6,77) ->
	#base_marry_heart{type = 6 ,lv = 77 ,attrs = [{hit,447}],goods_num = 80 };
get(7,77) ->
	#base_marry_heart{type = 7 ,lv = 77 ,attrs = [{dodge,447}],goods_num = 80 };
get(8,77) ->
	#base_marry_heart{type = 8 ,lv = 77 ,attrs = [{att,1344},{def,1344},{hp_lim,13440}],goods_num = 240 };
get(1,78) ->
	#base_marry_heart{type = 1 ,lv = 78 ,attrs = [{att,1376}],goods_num = 80 };
get(2,78) ->
	#base_marry_heart{type = 2 ,lv = 78 ,attrs = [{def,1376}],goods_num = 80 };
get(3,78) ->
	#base_marry_heart{type = 3 ,lv = 78 ,attrs = [{hp_lim,13760}],goods_num = 80 };
get(4,78) ->
	#base_marry_heart{type = 4 ,lv = 78 ,attrs = [{crit,458}],goods_num = 80 };
get(5,78) ->
	#base_marry_heart{type = 5 ,lv = 78 ,attrs = [{ten,458}],goods_num = 80 };
get(6,78) ->
	#base_marry_heart{type = 6 ,lv = 78 ,attrs = [{hit,458}],goods_num = 80 };
get(7,78) ->
	#base_marry_heart{type = 7 ,lv = 78 ,attrs = [{dodge,458}],goods_num = 80 };
get(8,78) ->
	#base_marry_heart{type = 8 ,lv = 78 ,attrs = [{att,1376},{def,1376},{hp_lim,13760}],goods_num = 240 };
get(1,79) ->
	#base_marry_heart{type = 1 ,lv = 79 ,attrs = [{att,1408}],goods_num = 80 };
get(2,79) ->
	#base_marry_heart{type = 2 ,lv = 79 ,attrs = [{def,1408}],goods_num = 80 };
get(3,79) ->
	#base_marry_heart{type = 3 ,lv = 79 ,attrs = [{hp_lim,14080}],goods_num = 80 };
get(4,79) ->
	#base_marry_heart{type = 4 ,lv = 79 ,attrs = [{crit,469}],goods_num = 80 };
get(5,79) ->
	#base_marry_heart{type = 5 ,lv = 79 ,attrs = [{ten,469}],goods_num = 80 };
get(6,79) ->
	#base_marry_heart{type = 6 ,lv = 79 ,attrs = [{hit,469}],goods_num = 80 };
get(7,79) ->
	#base_marry_heart{type = 7 ,lv = 79 ,attrs = [{dodge,469}],goods_num = 80 };
get(8,79) ->
	#base_marry_heart{type = 8 ,lv = 79 ,attrs = [{att,1408},{def,1408},{hp_lim,14080}],goods_num = 240 };
get(1,80) ->
	#base_marry_heart{type = 1 ,lv = 80 ,attrs = [{att,1440}],goods_num = 80 };
get(2,80) ->
	#base_marry_heart{type = 2 ,lv = 80 ,attrs = [{def,1440}],goods_num = 80 };
get(3,80) ->
	#base_marry_heart{type = 3 ,lv = 80 ,attrs = [{hp_lim,14400}],goods_num = 80 };
get(4,80) ->
	#base_marry_heart{type = 4 ,lv = 80 ,attrs = [{crit,480}],goods_num = 80 };
get(5,80) ->
	#base_marry_heart{type = 5 ,lv = 80 ,attrs = [{ten,480}],goods_num = 80 };
get(6,80) ->
	#base_marry_heart{type = 6 ,lv = 80 ,attrs = [{hit,480}],goods_num = 80 };
get(7,80) ->
	#base_marry_heart{type = 7 ,lv = 80 ,attrs = [{dodge,480}],goods_num = 80 };
get(8,80) ->
	#base_marry_heart{type = 8 ,lv = 80 ,attrs = [{att,1440},{def,1440},{hp_lim,14400}],goods_num = 240 };
get(1,81) ->
	#base_marry_heart{type = 1 ,lv = 81 ,attrs = [{att,1476}],goods_num = 90 };
get(2,81) ->
	#base_marry_heart{type = 2 ,lv = 81 ,attrs = [{def,1476}],goods_num = 90 };
get(3,81) ->
	#base_marry_heart{type = 3 ,lv = 81 ,attrs = [{hp_lim,14760}],goods_num = 90 };
get(4,81) ->
	#base_marry_heart{type = 4 ,lv = 81 ,attrs = [{crit,492}],goods_num = 90 };
get(5,81) ->
	#base_marry_heart{type = 5 ,lv = 81 ,attrs = [{ten,492}],goods_num = 90 };
get(6,81) ->
	#base_marry_heart{type = 6 ,lv = 81 ,attrs = [{hit,492}],goods_num = 90 };
get(7,81) ->
	#base_marry_heart{type = 7 ,lv = 81 ,attrs = [{dodge,492}],goods_num = 90 };
get(8,81) ->
	#base_marry_heart{type = 8 ,lv = 81 ,attrs = [{att,1476},{def,1476},{hp_lim,14760}],goods_num = 270 };
get(1,82) ->
	#base_marry_heart{type = 1 ,lv = 82 ,attrs = [{att,1512}],goods_num = 90 };
get(2,82) ->
	#base_marry_heart{type = 2 ,lv = 82 ,attrs = [{def,1512}],goods_num = 90 };
get(3,82) ->
	#base_marry_heart{type = 3 ,lv = 82 ,attrs = [{hp_lim,15120}],goods_num = 90 };
get(4,82) ->
	#base_marry_heart{type = 4 ,lv = 82 ,attrs = [{crit,504}],goods_num = 90 };
get(5,82) ->
	#base_marry_heart{type = 5 ,lv = 82 ,attrs = [{ten,504}],goods_num = 90 };
get(6,82) ->
	#base_marry_heart{type = 6 ,lv = 82 ,attrs = [{hit,504}],goods_num = 90 };
get(7,82) ->
	#base_marry_heart{type = 7 ,lv = 82 ,attrs = [{dodge,504}],goods_num = 90 };
get(8,82) ->
	#base_marry_heart{type = 8 ,lv = 82 ,attrs = [{att,1512},{def,1512},{hp_lim,15120}],goods_num = 270 };
get(1,83) ->
	#base_marry_heart{type = 1 ,lv = 83 ,attrs = [{att,1548}],goods_num = 90 };
get(2,83) ->
	#base_marry_heart{type = 2 ,lv = 83 ,attrs = [{def,1548}],goods_num = 90 };
get(3,83) ->
	#base_marry_heart{type = 3 ,lv = 83 ,attrs = [{hp_lim,15480}],goods_num = 90 };
get(4,83) ->
	#base_marry_heart{type = 4 ,lv = 83 ,attrs = [{crit,516}],goods_num = 90 };
get(5,83) ->
	#base_marry_heart{type = 5 ,lv = 83 ,attrs = [{ten,516}],goods_num = 90 };
get(6,83) ->
	#base_marry_heart{type = 6 ,lv = 83 ,attrs = [{hit,516}],goods_num = 90 };
get(7,83) ->
	#base_marry_heart{type = 7 ,lv = 83 ,attrs = [{dodge,516}],goods_num = 90 };
get(8,83) ->
	#base_marry_heart{type = 8 ,lv = 83 ,attrs = [{att,1548},{def,1548},{hp_lim,15480}],goods_num = 270 };
get(1,84) ->
	#base_marry_heart{type = 1 ,lv = 84 ,attrs = [{att,1584}],goods_num = 90 };
get(2,84) ->
	#base_marry_heart{type = 2 ,lv = 84 ,attrs = [{def,1584}],goods_num = 90 };
get(3,84) ->
	#base_marry_heart{type = 3 ,lv = 84 ,attrs = [{hp_lim,15840}],goods_num = 90 };
get(4,84) ->
	#base_marry_heart{type = 4 ,lv = 84 ,attrs = [{crit,528}],goods_num = 90 };
get(5,84) ->
	#base_marry_heart{type = 5 ,lv = 84 ,attrs = [{ten,528}],goods_num = 90 };
get(6,84) ->
	#base_marry_heart{type = 6 ,lv = 84 ,attrs = [{hit,528}],goods_num = 90 };
get(7,84) ->
	#base_marry_heart{type = 7 ,lv = 84 ,attrs = [{dodge,528}],goods_num = 90 };
get(8,84) ->
	#base_marry_heart{type = 8 ,lv = 84 ,attrs = [{att,1584},{def,1584},{hp_lim,15840}],goods_num = 270 };
get(1,85) ->
	#base_marry_heart{type = 1 ,lv = 85 ,attrs = [{att,1620}],goods_num = 90 };
get(2,85) ->
	#base_marry_heart{type = 2 ,lv = 85 ,attrs = [{def,1620}],goods_num = 90 };
get(3,85) ->
	#base_marry_heart{type = 3 ,lv = 85 ,attrs = [{hp_lim,16200}],goods_num = 90 };
get(4,85) ->
	#base_marry_heart{type = 4 ,lv = 85 ,attrs = [{crit,540}],goods_num = 90 };
get(5,85) ->
	#base_marry_heart{type = 5 ,lv = 85 ,attrs = [{ten,540}],goods_num = 90 };
get(6,85) ->
	#base_marry_heart{type = 6 ,lv = 85 ,attrs = [{hit,540}],goods_num = 90 };
get(7,85) ->
	#base_marry_heart{type = 7 ,lv = 85 ,attrs = [{dodge,540}],goods_num = 90 };
get(8,85) ->
	#base_marry_heart{type = 8 ,lv = 85 ,attrs = [{att,1620},{def,1620},{hp_lim,16200}],goods_num = 270 };
get(1,86) ->
	#base_marry_heart{type = 1 ,lv = 86 ,attrs = [{att,1656}],goods_num = 90 };
get(2,86) ->
	#base_marry_heart{type = 2 ,lv = 86 ,attrs = [{def,1656}],goods_num = 90 };
get(3,86) ->
	#base_marry_heart{type = 3 ,lv = 86 ,attrs = [{hp_lim,16560}],goods_num = 90 };
get(4,86) ->
	#base_marry_heart{type = 4 ,lv = 86 ,attrs = [{crit,552}],goods_num = 90 };
get(5,86) ->
	#base_marry_heart{type = 5 ,lv = 86 ,attrs = [{ten,552}],goods_num = 90 };
get(6,86) ->
	#base_marry_heart{type = 6 ,lv = 86 ,attrs = [{hit,552}],goods_num = 90 };
get(7,86) ->
	#base_marry_heart{type = 7 ,lv = 86 ,attrs = [{dodge,552}],goods_num = 90 };
get(8,86) ->
	#base_marry_heart{type = 8 ,lv = 86 ,attrs = [{att,1656},{def,1656},{hp_lim,16560}],goods_num = 270 };
get(1,87) ->
	#base_marry_heart{type = 1 ,lv = 87 ,attrs = [{att,1692}],goods_num = 90 };
get(2,87) ->
	#base_marry_heart{type = 2 ,lv = 87 ,attrs = [{def,1692}],goods_num = 90 };
get(3,87) ->
	#base_marry_heart{type = 3 ,lv = 87 ,attrs = [{hp_lim,16920}],goods_num = 90 };
get(4,87) ->
	#base_marry_heart{type = 4 ,lv = 87 ,attrs = [{crit,564}],goods_num = 90 };
get(5,87) ->
	#base_marry_heart{type = 5 ,lv = 87 ,attrs = [{ten,564}],goods_num = 90 };
get(6,87) ->
	#base_marry_heart{type = 6 ,lv = 87 ,attrs = [{hit,564}],goods_num = 90 };
get(7,87) ->
	#base_marry_heart{type = 7 ,lv = 87 ,attrs = [{dodge,564}],goods_num = 90 };
get(8,87) ->
	#base_marry_heart{type = 8 ,lv = 87 ,attrs = [{att,1692},{def,1692},{hp_lim,16920}],goods_num = 270 };
get(1,88) ->
	#base_marry_heart{type = 1 ,lv = 88 ,attrs = [{att,1728}],goods_num = 90 };
get(2,88) ->
	#base_marry_heart{type = 2 ,lv = 88 ,attrs = [{def,1728}],goods_num = 90 };
get(3,88) ->
	#base_marry_heart{type = 3 ,lv = 88 ,attrs = [{hp_lim,17280}],goods_num = 90 };
get(4,88) ->
	#base_marry_heart{type = 4 ,lv = 88 ,attrs = [{crit,576}],goods_num = 90 };
get(5,88) ->
	#base_marry_heart{type = 5 ,lv = 88 ,attrs = [{ten,576}],goods_num = 90 };
get(6,88) ->
	#base_marry_heart{type = 6 ,lv = 88 ,attrs = [{hit,576}],goods_num = 90 };
get(7,88) ->
	#base_marry_heart{type = 7 ,lv = 88 ,attrs = [{dodge,576}],goods_num = 90 };
get(8,88) ->
	#base_marry_heart{type = 8 ,lv = 88 ,attrs = [{att,1728},{def,1728},{hp_lim,17280}],goods_num = 270 };
get(1,89) ->
	#base_marry_heart{type = 1 ,lv = 89 ,attrs = [{att,1764}],goods_num = 90 };
get(2,89) ->
	#base_marry_heart{type = 2 ,lv = 89 ,attrs = [{def,1764}],goods_num = 90 };
get(3,89) ->
	#base_marry_heart{type = 3 ,lv = 89 ,attrs = [{hp_lim,17640}],goods_num = 90 };
get(4,89) ->
	#base_marry_heart{type = 4 ,lv = 89 ,attrs = [{crit,588}],goods_num = 90 };
get(5,89) ->
	#base_marry_heart{type = 5 ,lv = 89 ,attrs = [{ten,588}],goods_num = 90 };
get(6,89) ->
	#base_marry_heart{type = 6 ,lv = 89 ,attrs = [{hit,588}],goods_num = 90 };
get(7,89) ->
	#base_marry_heart{type = 7 ,lv = 89 ,attrs = [{dodge,588}],goods_num = 90 };
get(8,89) ->
	#base_marry_heart{type = 8 ,lv = 89 ,attrs = [{att,1764},{def,1764},{hp_lim,17640}],goods_num = 270 };
get(1,90) ->
	#base_marry_heart{type = 1 ,lv = 90 ,attrs = [{att,1800}],goods_num = 90 };
get(2,90) ->
	#base_marry_heart{type = 2 ,lv = 90 ,attrs = [{def,1800}],goods_num = 90 };
get(3,90) ->
	#base_marry_heart{type = 3 ,lv = 90 ,attrs = [{hp_lim,18000}],goods_num = 90 };
get(4,90) ->
	#base_marry_heart{type = 4 ,lv = 90 ,attrs = [{crit,600}],goods_num = 90 };
get(5,90) ->
	#base_marry_heart{type = 5 ,lv = 90 ,attrs = [{ten,600}],goods_num = 90 };
get(6,90) ->
	#base_marry_heart{type = 6 ,lv = 90 ,attrs = [{hit,600}],goods_num = 90 };
get(7,90) ->
	#base_marry_heart{type = 7 ,lv = 90 ,attrs = [{dodge,600}],goods_num = 90 };
get(8,90) ->
	#base_marry_heart{type = 8 ,lv = 90 ,attrs = [{att,1800},{def,1800},{hp_lim,18000}],goods_num = 270 };
get(1,91) ->
	#base_marry_heart{type = 1 ,lv = 91 ,attrs = [{att,1840}],goods_num = 100 };
get(2,91) ->
	#base_marry_heart{type = 2 ,lv = 91 ,attrs = [{def,1840}],goods_num = 100 };
get(3,91) ->
	#base_marry_heart{type = 3 ,lv = 91 ,attrs = [{hp_lim,18400}],goods_num = 100 };
get(4,91) ->
	#base_marry_heart{type = 4 ,lv = 91 ,attrs = [{crit,613}],goods_num = 100 };
get(5,91) ->
	#base_marry_heart{type = 5 ,lv = 91 ,attrs = [{ten,613}],goods_num = 100 };
get(6,91) ->
	#base_marry_heart{type = 6 ,lv = 91 ,attrs = [{hit,613}],goods_num = 100 };
get(7,91) ->
	#base_marry_heart{type = 7 ,lv = 91 ,attrs = [{dodge,613}],goods_num = 100 };
get(8,91) ->
	#base_marry_heart{type = 8 ,lv = 91 ,attrs = [{att,1840},{def,1840},{hp_lim,18400}],goods_num = 300 };
get(1,92) ->
	#base_marry_heart{type = 1 ,lv = 92 ,attrs = [{att,1880}],goods_num = 100 };
get(2,92) ->
	#base_marry_heart{type = 2 ,lv = 92 ,attrs = [{def,1880}],goods_num = 100 };
get(3,92) ->
	#base_marry_heart{type = 3 ,lv = 92 ,attrs = [{hp_lim,18800}],goods_num = 100 };
get(4,92) ->
	#base_marry_heart{type = 4 ,lv = 92 ,attrs = [{crit,626}],goods_num = 100 };
get(5,92) ->
	#base_marry_heart{type = 5 ,lv = 92 ,attrs = [{ten,626}],goods_num = 100 };
get(6,92) ->
	#base_marry_heart{type = 6 ,lv = 92 ,attrs = [{hit,626}],goods_num = 100 };
get(7,92) ->
	#base_marry_heart{type = 7 ,lv = 92 ,attrs = [{dodge,626}],goods_num = 100 };
get(8,92) ->
	#base_marry_heart{type = 8 ,lv = 92 ,attrs = [{att,1880},{def,1880},{hp_lim,18800}],goods_num = 300 };
get(1,93) ->
	#base_marry_heart{type = 1 ,lv = 93 ,attrs = [{att,1920}],goods_num = 100 };
get(2,93) ->
	#base_marry_heart{type = 2 ,lv = 93 ,attrs = [{def,1920}],goods_num = 100 };
get(3,93) ->
	#base_marry_heart{type = 3 ,lv = 93 ,attrs = [{hp_lim,19200}],goods_num = 100 };
get(4,93) ->
	#base_marry_heart{type = 4 ,lv = 93 ,attrs = [{crit,639}],goods_num = 100 };
get(5,93) ->
	#base_marry_heart{type = 5 ,lv = 93 ,attrs = [{ten,639}],goods_num = 100 };
get(6,93) ->
	#base_marry_heart{type = 6 ,lv = 93 ,attrs = [{hit,639}],goods_num = 100 };
get(7,93) ->
	#base_marry_heart{type = 7 ,lv = 93 ,attrs = [{dodge,639}],goods_num = 100 };
get(8,93) ->
	#base_marry_heart{type = 8 ,lv = 93 ,attrs = [{att,1920},{def,1920},{hp_lim,19200}],goods_num = 300 };
get(1,94) ->
	#base_marry_heart{type = 1 ,lv = 94 ,attrs = [{att,1960}],goods_num = 100 };
get(2,94) ->
	#base_marry_heart{type = 2 ,lv = 94 ,attrs = [{def,1960}],goods_num = 100 };
get(3,94) ->
	#base_marry_heart{type = 3 ,lv = 94 ,attrs = [{hp_lim,19600}],goods_num = 100 };
get(4,94) ->
	#base_marry_heart{type = 4 ,lv = 94 ,attrs = [{crit,652}],goods_num = 100 };
get(5,94) ->
	#base_marry_heart{type = 5 ,lv = 94 ,attrs = [{ten,652}],goods_num = 100 };
get(6,94) ->
	#base_marry_heart{type = 6 ,lv = 94 ,attrs = [{hit,652}],goods_num = 100 };
get(7,94) ->
	#base_marry_heart{type = 7 ,lv = 94 ,attrs = [{dodge,652}],goods_num = 100 };
get(8,94) ->
	#base_marry_heart{type = 8 ,lv = 94 ,attrs = [{att,1960},{def,1960},{hp_lim,19600}],goods_num = 300 };
get(1,95) ->
	#base_marry_heart{type = 1 ,lv = 95 ,attrs = [{att,2000}],goods_num = 100 };
get(2,95) ->
	#base_marry_heart{type = 2 ,lv = 95 ,attrs = [{def,2000}],goods_num = 100 };
get(3,95) ->
	#base_marry_heart{type = 3 ,lv = 95 ,attrs = [{hp_lim,20000}],goods_num = 100 };
get(4,95) ->
	#base_marry_heart{type = 4 ,lv = 95 ,attrs = [{crit,665}],goods_num = 100 };
get(5,95) ->
	#base_marry_heart{type = 5 ,lv = 95 ,attrs = [{ten,665}],goods_num = 100 };
get(6,95) ->
	#base_marry_heart{type = 6 ,lv = 95 ,attrs = [{hit,665}],goods_num = 100 };
get(7,95) ->
	#base_marry_heart{type = 7 ,lv = 95 ,attrs = [{dodge,665}],goods_num = 100 };
get(8,95) ->
	#base_marry_heart{type = 8 ,lv = 95 ,attrs = [{att,2000},{def,2000},{hp_lim,20000}],goods_num = 300 };
get(1,96) ->
	#base_marry_heart{type = 1 ,lv = 96 ,attrs = [{att,2040}],goods_num = 100 };
get(2,96) ->
	#base_marry_heart{type = 2 ,lv = 96 ,attrs = [{def,2040}],goods_num = 100 };
get(3,96) ->
	#base_marry_heart{type = 3 ,lv = 96 ,attrs = [{hp_lim,20400}],goods_num = 100 };
get(4,96) ->
	#base_marry_heart{type = 4 ,lv = 96 ,attrs = [{crit,678}],goods_num = 100 };
get(5,96) ->
	#base_marry_heart{type = 5 ,lv = 96 ,attrs = [{ten,678}],goods_num = 100 };
get(6,96) ->
	#base_marry_heart{type = 6 ,lv = 96 ,attrs = [{hit,678}],goods_num = 100 };
get(7,96) ->
	#base_marry_heart{type = 7 ,lv = 96 ,attrs = [{dodge,678}],goods_num = 100 };
get(8,96) ->
	#base_marry_heart{type = 8 ,lv = 96 ,attrs = [{att,2040},{def,2040},{hp_lim,20400}],goods_num = 300 };
get(1,97) ->
	#base_marry_heart{type = 1 ,lv = 97 ,attrs = [{att,2080}],goods_num = 100 };
get(2,97) ->
	#base_marry_heart{type = 2 ,lv = 97 ,attrs = [{def,2080}],goods_num = 100 };
get(3,97) ->
	#base_marry_heart{type = 3 ,lv = 97 ,attrs = [{hp_lim,20800}],goods_num = 100 };
get(4,97) ->
	#base_marry_heart{type = 4 ,lv = 97 ,attrs = [{crit,691}],goods_num = 100 };
get(5,97) ->
	#base_marry_heart{type = 5 ,lv = 97 ,attrs = [{ten,691}],goods_num = 100 };
get(6,97) ->
	#base_marry_heart{type = 6 ,lv = 97 ,attrs = [{hit,691}],goods_num = 100 };
get(7,97) ->
	#base_marry_heart{type = 7 ,lv = 97 ,attrs = [{dodge,691}],goods_num = 100 };
get(8,97) ->
	#base_marry_heart{type = 8 ,lv = 97 ,attrs = [{att,2080},{def,2080},{hp_lim,20800}],goods_num = 300 };
get(1,98) ->
	#base_marry_heart{type = 1 ,lv = 98 ,attrs = [{att,2120}],goods_num = 100 };
get(2,98) ->
	#base_marry_heart{type = 2 ,lv = 98 ,attrs = [{def,2120}],goods_num = 100 };
get(3,98) ->
	#base_marry_heart{type = 3 ,lv = 98 ,attrs = [{hp_lim,21200}],goods_num = 100 };
get(4,98) ->
	#base_marry_heart{type = 4 ,lv = 98 ,attrs = [{crit,704}],goods_num = 100 };
get(5,98) ->
	#base_marry_heart{type = 5 ,lv = 98 ,attrs = [{ten,704}],goods_num = 100 };
get(6,98) ->
	#base_marry_heart{type = 6 ,lv = 98 ,attrs = [{hit,704}],goods_num = 100 };
get(7,98) ->
	#base_marry_heart{type = 7 ,lv = 98 ,attrs = [{dodge,704}],goods_num = 100 };
get(8,98) ->
	#base_marry_heart{type = 8 ,lv = 98 ,attrs = [{att,2120},{def,2120},{hp_lim,21200}],goods_num = 300 };
get(1,99) ->
	#base_marry_heart{type = 1 ,lv = 99 ,attrs = [{att,2160}],goods_num = 100 };
get(2,99) ->
	#base_marry_heart{type = 2 ,lv = 99 ,attrs = [{def,2160}],goods_num = 100 };
get(3,99) ->
	#base_marry_heart{type = 3 ,lv = 99 ,attrs = [{hp_lim,21600}],goods_num = 100 };
get(4,99) ->
	#base_marry_heart{type = 4 ,lv = 99 ,attrs = [{crit,717}],goods_num = 100 };
get(5,99) ->
	#base_marry_heart{type = 5 ,lv = 99 ,attrs = [{ten,717}],goods_num = 100 };
get(6,99) ->
	#base_marry_heart{type = 6 ,lv = 99 ,attrs = [{hit,717}],goods_num = 100 };
get(7,99) ->
	#base_marry_heart{type = 7 ,lv = 99 ,attrs = [{dodge,717}],goods_num = 100 };
get(8,99) ->
	#base_marry_heart{type = 8 ,lv = 99 ,attrs = [{att,2160},{def,2160},{hp_lim,21600}],goods_num = 300 };
get(1,100) ->
	#base_marry_heart{type = 1 ,lv = 100 ,attrs = [{att,2200}],goods_num = 100 };
get(2,100) ->
	#base_marry_heart{type = 2 ,lv = 100 ,attrs = [{def,2200}],goods_num = 100 };
get(3,100) ->
	#base_marry_heart{type = 3 ,lv = 100 ,attrs = [{hp_lim,22000}],goods_num = 100 };
get(4,100) ->
	#base_marry_heart{type = 4 ,lv = 100 ,attrs = [{crit,730}],goods_num = 100 };
get(5,100) ->
	#base_marry_heart{type = 5 ,lv = 100 ,attrs = [{ten,730}],goods_num = 100 };
get(6,100) ->
	#base_marry_heart{type = 6 ,lv = 100 ,attrs = [{hit,730}],goods_num = 100 };
get(7,100) ->
	#base_marry_heart{type = 7 ,lv = 100 ,attrs = [{dodge,730}],goods_num = 100 };
get(8,100) ->
	#base_marry_heart{type = 8 ,lv = 100 ,attrs = [{att,2200},{def,2200},{hp_lim,22000}],goods_num = 300 };
get(1,101) ->
	#base_marry_heart{type = 1 ,lv = 101 ,attrs = [{att,2240}],goods_num = 102 };
get(2,101) ->
	#base_marry_heart{type = 2 ,lv = 101 ,attrs = [{def,2240}],goods_num = 102 };
get(3,101) ->
	#base_marry_heart{type = 3 ,lv = 101 ,attrs = [{hp_lim,22400}],goods_num = 102 };
get(4,101) ->
	#base_marry_heart{type = 4 ,lv = 101 ,attrs = [{crit,743}],goods_num = 102 };
get(5,101) ->
	#base_marry_heart{type = 5 ,lv = 101 ,attrs = [{ten,743}],goods_num = 102 };
get(6,101) ->
	#base_marry_heart{type = 6 ,lv = 101 ,attrs = [{hit,743}],goods_num = 102 };
get(7,101) ->
	#base_marry_heart{type = 7 ,lv = 101 ,attrs = [{dodge,743}],goods_num = 102 };
get(8,101) ->
	#base_marry_heart{type = 8 ,lv = 101 ,attrs = [{att,2240},{def,2240},{hp_lim,22400}],goods_num = 306 };
get(1,102) ->
	#base_marry_heart{type = 1 ,lv = 102 ,attrs = [{att,2280}],goods_num = 104 };
get(2,102) ->
	#base_marry_heart{type = 2 ,lv = 102 ,attrs = [{def,2280}],goods_num = 104 };
get(3,102) ->
	#base_marry_heart{type = 3 ,lv = 102 ,attrs = [{hp_lim,22800}],goods_num = 104 };
get(4,102) ->
	#base_marry_heart{type = 4 ,lv = 102 ,attrs = [{crit,756}],goods_num = 104 };
get(5,102) ->
	#base_marry_heart{type = 5 ,lv = 102 ,attrs = [{ten,756}],goods_num = 104 };
get(6,102) ->
	#base_marry_heart{type = 6 ,lv = 102 ,attrs = [{hit,756}],goods_num = 104 };
get(7,102) ->
	#base_marry_heart{type = 7 ,lv = 102 ,attrs = [{dodge,756}],goods_num = 104 };
get(8,102) ->
	#base_marry_heart{type = 8 ,lv = 102 ,attrs = [{att,2280},{def,2280},{hp_lim,22800}],goods_num = 312 };
get(1,103) ->
	#base_marry_heart{type = 1 ,lv = 103 ,attrs = [{att,2320}],goods_num = 106 };
get(2,103) ->
	#base_marry_heart{type = 2 ,lv = 103 ,attrs = [{def,2320}],goods_num = 106 };
get(3,103) ->
	#base_marry_heart{type = 3 ,lv = 103 ,attrs = [{hp_lim,23200}],goods_num = 106 };
get(4,103) ->
	#base_marry_heart{type = 4 ,lv = 103 ,attrs = [{crit,769}],goods_num = 106 };
get(5,103) ->
	#base_marry_heart{type = 5 ,lv = 103 ,attrs = [{ten,769}],goods_num = 106 };
get(6,103) ->
	#base_marry_heart{type = 6 ,lv = 103 ,attrs = [{hit,769}],goods_num = 106 };
get(7,103) ->
	#base_marry_heart{type = 7 ,lv = 103 ,attrs = [{dodge,769}],goods_num = 106 };
get(8,103) ->
	#base_marry_heart{type = 8 ,lv = 103 ,attrs = [{att,2320},{def,2320},{hp_lim,23200}],goods_num = 318 };
get(1,104) ->
	#base_marry_heart{type = 1 ,lv = 104 ,attrs = [{att,2360}],goods_num = 108 };
get(2,104) ->
	#base_marry_heart{type = 2 ,lv = 104 ,attrs = [{def,2360}],goods_num = 108 };
get(3,104) ->
	#base_marry_heart{type = 3 ,lv = 104 ,attrs = [{hp_lim,23600}],goods_num = 108 };
get(4,104) ->
	#base_marry_heart{type = 4 ,lv = 104 ,attrs = [{crit,782}],goods_num = 108 };
get(5,104) ->
	#base_marry_heart{type = 5 ,lv = 104 ,attrs = [{ten,782}],goods_num = 108 };
get(6,104) ->
	#base_marry_heart{type = 6 ,lv = 104 ,attrs = [{hit,782}],goods_num = 108 };
get(7,104) ->
	#base_marry_heart{type = 7 ,lv = 104 ,attrs = [{dodge,782}],goods_num = 108 };
get(8,104) ->
	#base_marry_heart{type = 8 ,lv = 104 ,attrs = [{att,2360},{def,2360},{hp_lim,23600}],goods_num = 324 };
get(1,105) ->
	#base_marry_heart{type = 1 ,lv = 105 ,attrs = [{att,2400}],goods_num = 110 };
get(2,105) ->
	#base_marry_heart{type = 2 ,lv = 105 ,attrs = [{def,2400}],goods_num = 110 };
get(3,105) ->
	#base_marry_heart{type = 3 ,lv = 105 ,attrs = [{hp_lim,24000}],goods_num = 110 };
get(4,105) ->
	#base_marry_heart{type = 4 ,lv = 105 ,attrs = [{crit,795}],goods_num = 110 };
get(5,105) ->
	#base_marry_heart{type = 5 ,lv = 105 ,attrs = [{ten,795}],goods_num = 110 };
get(6,105) ->
	#base_marry_heart{type = 6 ,lv = 105 ,attrs = [{hit,795}],goods_num = 110 };
get(7,105) ->
	#base_marry_heart{type = 7 ,lv = 105 ,attrs = [{dodge,795}],goods_num = 110 };
get(8,105) ->
	#base_marry_heart{type = 8 ,lv = 105 ,attrs = [{att,2400},{def,2400},{hp_lim,24000}],goods_num = 330 };
get(1,106) ->
	#base_marry_heart{type = 1 ,lv = 106 ,attrs = [{att,2440}],goods_num = 112 };
get(2,106) ->
	#base_marry_heart{type = 2 ,lv = 106 ,attrs = [{def,2440}],goods_num = 112 };
get(3,106) ->
	#base_marry_heart{type = 3 ,lv = 106 ,attrs = [{hp_lim,24400}],goods_num = 112 };
get(4,106) ->
	#base_marry_heart{type = 4 ,lv = 106 ,attrs = [{crit,808}],goods_num = 112 };
get(5,106) ->
	#base_marry_heart{type = 5 ,lv = 106 ,attrs = [{ten,808}],goods_num = 112 };
get(6,106) ->
	#base_marry_heart{type = 6 ,lv = 106 ,attrs = [{hit,808}],goods_num = 112 };
get(7,106) ->
	#base_marry_heart{type = 7 ,lv = 106 ,attrs = [{dodge,808}],goods_num = 112 };
get(8,106) ->
	#base_marry_heart{type = 8 ,lv = 106 ,attrs = [{att,2440},{def,2440},{hp_lim,24400}],goods_num = 336 };
get(1,107) ->
	#base_marry_heart{type = 1 ,lv = 107 ,attrs = [{att,2480}],goods_num = 114 };
get(2,107) ->
	#base_marry_heart{type = 2 ,lv = 107 ,attrs = [{def,2480}],goods_num = 114 };
get(3,107) ->
	#base_marry_heart{type = 3 ,lv = 107 ,attrs = [{hp_lim,24800}],goods_num = 114 };
get(4,107) ->
	#base_marry_heart{type = 4 ,lv = 107 ,attrs = [{crit,821}],goods_num = 114 };
get(5,107) ->
	#base_marry_heart{type = 5 ,lv = 107 ,attrs = [{ten,821}],goods_num = 114 };
get(6,107) ->
	#base_marry_heart{type = 6 ,lv = 107 ,attrs = [{hit,821}],goods_num = 114 };
get(7,107) ->
	#base_marry_heart{type = 7 ,lv = 107 ,attrs = [{dodge,821}],goods_num = 114 };
get(8,107) ->
	#base_marry_heart{type = 8 ,lv = 107 ,attrs = [{att,2480},{def,2480},{hp_lim,24800}],goods_num = 342 };
get(1,108) ->
	#base_marry_heart{type = 1 ,lv = 108 ,attrs = [{att,2520}],goods_num = 116 };
get(2,108) ->
	#base_marry_heart{type = 2 ,lv = 108 ,attrs = [{def,2520}],goods_num = 116 };
get(3,108) ->
	#base_marry_heart{type = 3 ,lv = 108 ,attrs = [{hp_lim,25200}],goods_num = 116 };
get(4,108) ->
	#base_marry_heart{type = 4 ,lv = 108 ,attrs = [{crit,834}],goods_num = 116 };
get(5,108) ->
	#base_marry_heart{type = 5 ,lv = 108 ,attrs = [{ten,834}],goods_num = 116 };
get(6,108) ->
	#base_marry_heart{type = 6 ,lv = 108 ,attrs = [{hit,834}],goods_num = 116 };
get(7,108) ->
	#base_marry_heart{type = 7 ,lv = 108 ,attrs = [{dodge,834}],goods_num = 116 };
get(8,108) ->
	#base_marry_heart{type = 8 ,lv = 108 ,attrs = [{att,2520},{def,2520},{hp_lim,25200}],goods_num = 348 };
get(1,109) ->
	#base_marry_heart{type = 1 ,lv = 109 ,attrs = [{att,2560}],goods_num = 118 };
get(2,109) ->
	#base_marry_heart{type = 2 ,lv = 109 ,attrs = [{def,2560}],goods_num = 118 };
get(3,109) ->
	#base_marry_heart{type = 3 ,lv = 109 ,attrs = [{hp_lim,25600}],goods_num = 118 };
get(4,109) ->
	#base_marry_heart{type = 4 ,lv = 109 ,attrs = [{crit,847}],goods_num = 118 };
get(5,109) ->
	#base_marry_heart{type = 5 ,lv = 109 ,attrs = [{ten,847}],goods_num = 118 };
get(6,109) ->
	#base_marry_heart{type = 6 ,lv = 109 ,attrs = [{hit,847}],goods_num = 118 };
get(7,109) ->
	#base_marry_heart{type = 7 ,lv = 109 ,attrs = [{dodge,847}],goods_num = 118 };
get(8,109) ->
	#base_marry_heart{type = 8 ,lv = 109 ,attrs = [{att,2560},{def,2560},{hp_lim,25600}],goods_num = 354 };
get(1,110) ->
	#base_marry_heart{type = 1 ,lv = 110 ,attrs = [{att,2600}],goods_num = 120 };
get(2,110) ->
	#base_marry_heart{type = 2 ,lv = 110 ,attrs = [{def,2600}],goods_num = 120 };
get(3,110) ->
	#base_marry_heart{type = 3 ,lv = 110 ,attrs = [{hp_lim,26000}],goods_num = 120 };
get(4,110) ->
	#base_marry_heart{type = 4 ,lv = 110 ,attrs = [{crit,860}],goods_num = 120 };
get(5,110) ->
	#base_marry_heart{type = 5 ,lv = 110 ,attrs = [{ten,860}],goods_num = 120 };
get(6,110) ->
	#base_marry_heart{type = 6 ,lv = 110 ,attrs = [{hit,860}],goods_num = 120 };
get(7,110) ->
	#base_marry_heart{type = 7 ,lv = 110 ,attrs = [{dodge,860}],goods_num = 120 };
get(8,110) ->
	#base_marry_heart{type = 8 ,lv = 110 ,attrs = [{att,2600},{def,2600},{hp_lim,26000}],goods_num = 361 };
get(1,111) ->
	#base_marry_heart{type = 1 ,lv = 111 ,attrs = [{att,2640}],goods_num = 122 };
get(2,111) ->
	#base_marry_heart{type = 2 ,lv = 111 ,attrs = [{def,2640}],goods_num = 122 };
get(3,111) ->
	#base_marry_heart{type = 3 ,lv = 111 ,attrs = [{hp_lim,26400}],goods_num = 122 };
get(4,111) ->
	#base_marry_heart{type = 4 ,lv = 111 ,attrs = [{crit,873}],goods_num = 122 };
get(5,111) ->
	#base_marry_heart{type = 5 ,lv = 111 ,attrs = [{ten,873}],goods_num = 122 };
get(6,111) ->
	#base_marry_heart{type = 6 ,lv = 111 ,attrs = [{hit,873}],goods_num = 122 };
get(7,111) ->
	#base_marry_heart{type = 7 ,lv = 111 ,attrs = [{dodge,873}],goods_num = 122 };
get(8,111) ->
	#base_marry_heart{type = 8 ,lv = 111 ,attrs = [{att,2640},{def,2640},{hp_lim,26400}],goods_num = 368 };
get(1,112) ->
	#base_marry_heart{type = 1 ,lv = 112 ,attrs = [{att,2680}],goods_num = 124 };
get(2,112) ->
	#base_marry_heart{type = 2 ,lv = 112 ,attrs = [{def,2680}],goods_num = 124 };
get(3,112) ->
	#base_marry_heart{type = 3 ,lv = 112 ,attrs = [{hp_lim,26800}],goods_num = 124 };
get(4,112) ->
	#base_marry_heart{type = 4 ,lv = 112 ,attrs = [{crit,886}],goods_num = 124 };
get(5,112) ->
	#base_marry_heart{type = 5 ,lv = 112 ,attrs = [{ten,886}],goods_num = 124 };
get(6,112) ->
	#base_marry_heart{type = 6 ,lv = 112 ,attrs = [{hit,886}],goods_num = 124 };
get(7,112) ->
	#base_marry_heart{type = 7 ,lv = 112 ,attrs = [{dodge,886}],goods_num = 124 };
get(8,112) ->
	#base_marry_heart{type = 8 ,lv = 112 ,attrs = [{att,2680},{def,2680},{hp_lim,26800}],goods_num = 375 };
get(1,113) ->
	#base_marry_heart{type = 1 ,lv = 113 ,attrs = [{att,2720}],goods_num = 126 };
get(2,113) ->
	#base_marry_heart{type = 2 ,lv = 113 ,attrs = [{def,2720}],goods_num = 126 };
get(3,113) ->
	#base_marry_heart{type = 3 ,lv = 113 ,attrs = [{hp_lim,27200}],goods_num = 126 };
get(4,113) ->
	#base_marry_heart{type = 4 ,lv = 113 ,attrs = [{crit,899}],goods_num = 126 };
get(5,113) ->
	#base_marry_heart{type = 5 ,lv = 113 ,attrs = [{ten,899}],goods_num = 126 };
get(6,113) ->
	#base_marry_heart{type = 6 ,lv = 113 ,attrs = [{hit,899}],goods_num = 126 };
get(7,113) ->
	#base_marry_heart{type = 7 ,lv = 113 ,attrs = [{dodge,899}],goods_num = 126 };
get(8,113) ->
	#base_marry_heart{type = 8 ,lv = 113 ,attrs = [{att,2720},{def,2720},{hp_lim,27200}],goods_num = 382 };
get(1,114) ->
	#base_marry_heart{type = 1 ,lv = 114 ,attrs = [{att,2760}],goods_num = 128 };
get(2,114) ->
	#base_marry_heart{type = 2 ,lv = 114 ,attrs = [{def,2760}],goods_num = 128 };
get(3,114) ->
	#base_marry_heart{type = 3 ,lv = 114 ,attrs = [{hp_lim,27600}],goods_num = 128 };
get(4,114) ->
	#base_marry_heart{type = 4 ,lv = 114 ,attrs = [{crit,912}],goods_num = 128 };
get(5,114) ->
	#base_marry_heart{type = 5 ,lv = 114 ,attrs = [{ten,912}],goods_num = 128 };
get(6,114) ->
	#base_marry_heart{type = 6 ,lv = 114 ,attrs = [{hit,912}],goods_num = 128 };
get(7,114) ->
	#base_marry_heart{type = 7 ,lv = 114 ,attrs = [{dodge,912}],goods_num = 128 };
get(8,114) ->
	#base_marry_heart{type = 8 ,lv = 114 ,attrs = [{att,2760},{def,2760},{hp_lim,27600}],goods_num = 389 };
get(1,115) ->
	#base_marry_heart{type = 1 ,lv = 115 ,attrs = [{att,2800}],goods_num = 130 };
get(2,115) ->
	#base_marry_heart{type = 2 ,lv = 115 ,attrs = [{def,2800}],goods_num = 130 };
get(3,115) ->
	#base_marry_heart{type = 3 ,lv = 115 ,attrs = [{hp_lim,28000}],goods_num = 130 };
get(4,115) ->
	#base_marry_heart{type = 4 ,lv = 115 ,attrs = [{crit,925}],goods_num = 130 };
get(5,115) ->
	#base_marry_heart{type = 5 ,lv = 115 ,attrs = [{ten,925}],goods_num = 130 };
get(6,115) ->
	#base_marry_heart{type = 6 ,lv = 115 ,attrs = [{hit,925}],goods_num = 130 };
get(7,115) ->
	#base_marry_heart{type = 7 ,lv = 115 ,attrs = [{dodge,925}],goods_num = 130 };
get(8,115) ->
	#base_marry_heart{type = 8 ,lv = 115 ,attrs = [{att,2800},{def,2800},{hp_lim,28000}],goods_num = 396 };
get(1,116) ->
	#base_marry_heart{type = 1 ,lv = 116 ,attrs = [{att,2840}],goods_num = 132 };
get(2,116) ->
	#base_marry_heart{type = 2 ,lv = 116 ,attrs = [{def,2840}],goods_num = 132 };
get(3,116) ->
	#base_marry_heart{type = 3 ,lv = 116 ,attrs = [{hp_lim,28400}],goods_num = 132 };
get(4,116) ->
	#base_marry_heart{type = 4 ,lv = 116 ,attrs = [{crit,938}],goods_num = 132 };
get(5,116) ->
	#base_marry_heart{type = 5 ,lv = 116 ,attrs = [{ten,938}],goods_num = 132 };
get(6,116) ->
	#base_marry_heart{type = 6 ,lv = 116 ,attrs = [{hit,938}],goods_num = 132 };
get(7,116) ->
	#base_marry_heart{type = 7 ,lv = 116 ,attrs = [{dodge,938}],goods_num = 132 };
get(8,116) ->
	#base_marry_heart{type = 8 ,lv = 116 ,attrs = [{att,2840},{def,2840},{hp_lim,28400}],goods_num = 403 };
get(1,117) ->
	#base_marry_heart{type = 1 ,lv = 117 ,attrs = [{att,2880}],goods_num = 134 };
get(2,117) ->
	#base_marry_heart{type = 2 ,lv = 117 ,attrs = [{def,2880}],goods_num = 134 };
get(3,117) ->
	#base_marry_heart{type = 3 ,lv = 117 ,attrs = [{hp_lim,28800}],goods_num = 134 };
get(4,117) ->
	#base_marry_heart{type = 4 ,lv = 117 ,attrs = [{crit,951}],goods_num = 134 };
get(5,117) ->
	#base_marry_heart{type = 5 ,lv = 117 ,attrs = [{ten,951}],goods_num = 134 };
get(6,117) ->
	#base_marry_heart{type = 6 ,lv = 117 ,attrs = [{hit,951}],goods_num = 134 };
get(7,117) ->
	#base_marry_heart{type = 7 ,lv = 117 ,attrs = [{dodge,951}],goods_num = 134 };
get(8,117) ->
	#base_marry_heart{type = 8 ,lv = 117 ,attrs = [{att,2880},{def,2880},{hp_lim,28800}],goods_num = 411 };
get(1,118) ->
	#base_marry_heart{type = 1 ,lv = 118 ,attrs = [{att,2920}],goods_num = 136 };
get(2,118) ->
	#base_marry_heart{type = 2 ,lv = 118 ,attrs = [{def,2920}],goods_num = 136 };
get(3,118) ->
	#base_marry_heart{type = 3 ,lv = 118 ,attrs = [{hp_lim,29200}],goods_num = 136 };
get(4,118) ->
	#base_marry_heart{type = 4 ,lv = 118 ,attrs = [{crit,964}],goods_num = 136 };
get(5,118) ->
	#base_marry_heart{type = 5 ,lv = 118 ,attrs = [{ten,964}],goods_num = 136 };
get(6,118) ->
	#base_marry_heart{type = 6 ,lv = 118 ,attrs = [{hit,964}],goods_num = 136 };
get(7,118) ->
	#base_marry_heart{type = 7 ,lv = 118 ,attrs = [{dodge,964}],goods_num = 136 };
get(8,118) ->
	#base_marry_heart{type = 8 ,lv = 118 ,attrs = [{att,2920},{def,2920},{hp_lim,29200}],goods_num = 419 };
get(1,119) ->
	#base_marry_heart{type = 1 ,lv = 119 ,attrs = [{att,2960}],goods_num = 138 };
get(2,119) ->
	#base_marry_heart{type = 2 ,lv = 119 ,attrs = [{def,2960}],goods_num = 138 };
get(3,119) ->
	#base_marry_heart{type = 3 ,lv = 119 ,attrs = [{hp_lim,29600}],goods_num = 138 };
get(4,119) ->
	#base_marry_heart{type = 4 ,lv = 119 ,attrs = [{crit,977}],goods_num = 138 };
get(5,119) ->
	#base_marry_heart{type = 5 ,lv = 119 ,attrs = [{ten,977}],goods_num = 138 };
get(6,119) ->
	#base_marry_heart{type = 6 ,lv = 119 ,attrs = [{hit,977}],goods_num = 138 };
get(7,119) ->
	#base_marry_heart{type = 7 ,lv = 119 ,attrs = [{dodge,977}],goods_num = 138 };
get(8,119) ->
	#base_marry_heart{type = 8 ,lv = 119 ,attrs = [{att,2960},{def,2960},{hp_lim,29600}],goods_num = 427 };
get(1,120) ->
	#base_marry_heart{type = 1 ,lv = 120 ,attrs = [{att,3000}],goods_num = 140 };
get(2,120) ->
	#base_marry_heart{type = 2 ,lv = 120 ,attrs = [{def,3000}],goods_num = 140 };
get(3,120) ->
	#base_marry_heart{type = 3 ,lv = 120 ,attrs = [{hp_lim,30000}],goods_num = 140 };
get(4,120) ->
	#base_marry_heart{type = 4 ,lv = 120 ,attrs = [{crit,990}],goods_num = 140 };
get(5,120) ->
	#base_marry_heart{type = 5 ,lv = 120 ,attrs = [{ten,990}],goods_num = 140 };
get(6,120) ->
	#base_marry_heart{type = 6 ,lv = 120 ,attrs = [{hit,990}],goods_num = 140 };
get(7,120) ->
	#base_marry_heart{type = 7 ,lv = 120 ,attrs = [{dodge,990}],goods_num = 140 };
get(8,120) ->
	#base_marry_heart{type = 8 ,lv = 120 ,attrs = [{att,3000},{def,3000},{hp_lim,30000}],goods_num = 435 };
get(1,121) ->
	#base_marry_heart{type = 1 ,lv = 121 ,attrs = [{att,3040}],goods_num = 142 };
get(2,121) ->
	#base_marry_heart{type = 2 ,lv = 121 ,attrs = [{def,3040}],goods_num = 142 };
get(3,121) ->
	#base_marry_heart{type = 3 ,lv = 121 ,attrs = [{hp_lim,30400}],goods_num = 142 };
get(4,121) ->
	#base_marry_heart{type = 4 ,lv = 121 ,attrs = [{crit,1003}],goods_num = 142 };
get(5,121) ->
	#base_marry_heart{type = 5 ,lv = 121 ,attrs = [{ten,1003}],goods_num = 142 };
get(6,121) ->
	#base_marry_heart{type = 6 ,lv = 121 ,attrs = [{hit,1003}],goods_num = 142 };
get(7,121) ->
	#base_marry_heart{type = 7 ,lv = 121 ,attrs = [{dodge,1003}],goods_num = 142 };
get(8,121) ->
	#base_marry_heart{type = 8 ,lv = 121 ,attrs = [{att,3040},{def,3040},{hp_lim,30400}],goods_num = 443 };
get(1,122) ->
	#base_marry_heart{type = 1 ,lv = 122 ,attrs = [{att,3080}],goods_num = 144 };
get(2,122) ->
	#base_marry_heart{type = 2 ,lv = 122 ,attrs = [{def,3080}],goods_num = 144 };
get(3,122) ->
	#base_marry_heart{type = 3 ,lv = 122 ,attrs = [{hp_lim,30800}],goods_num = 144 };
get(4,122) ->
	#base_marry_heart{type = 4 ,lv = 122 ,attrs = [{crit,1016}],goods_num = 144 };
get(5,122) ->
	#base_marry_heart{type = 5 ,lv = 122 ,attrs = [{ten,1016}],goods_num = 144 };
get(6,122) ->
	#base_marry_heart{type = 6 ,lv = 122 ,attrs = [{hit,1016}],goods_num = 144 };
get(7,122) ->
	#base_marry_heart{type = 7 ,lv = 122 ,attrs = [{dodge,1016}],goods_num = 144 };
get(8,122) ->
	#base_marry_heart{type = 8 ,lv = 122 ,attrs = [{att,3080},{def,3080},{hp_lim,30800}],goods_num = 451 };
get(1,123) ->
	#base_marry_heart{type = 1 ,lv = 123 ,attrs = [{att,3120}],goods_num = 146 };
get(2,123) ->
	#base_marry_heart{type = 2 ,lv = 123 ,attrs = [{def,3120}],goods_num = 146 };
get(3,123) ->
	#base_marry_heart{type = 3 ,lv = 123 ,attrs = [{hp_lim,31200}],goods_num = 146 };
get(4,123) ->
	#base_marry_heart{type = 4 ,lv = 123 ,attrs = [{crit,1029}],goods_num = 146 };
get(5,123) ->
	#base_marry_heart{type = 5 ,lv = 123 ,attrs = [{ten,1029}],goods_num = 146 };
get(6,123) ->
	#base_marry_heart{type = 6 ,lv = 123 ,attrs = [{hit,1029}],goods_num = 146 };
get(7,123) ->
	#base_marry_heart{type = 7 ,lv = 123 ,attrs = [{dodge,1029}],goods_num = 146 };
get(8,123) ->
	#base_marry_heart{type = 8 ,lv = 123 ,attrs = [{att,3120},{def,3120},{hp_lim,31200}],goods_num = 460 };
get(1,124) ->
	#base_marry_heart{type = 1 ,lv = 124 ,attrs = [{att,3160}],goods_num = 148 };
get(2,124) ->
	#base_marry_heart{type = 2 ,lv = 124 ,attrs = [{def,3160}],goods_num = 148 };
get(3,124) ->
	#base_marry_heart{type = 3 ,lv = 124 ,attrs = [{hp_lim,31600}],goods_num = 148 };
get(4,124) ->
	#base_marry_heart{type = 4 ,lv = 124 ,attrs = [{crit,1042}],goods_num = 148 };
get(5,124) ->
	#base_marry_heart{type = 5 ,lv = 124 ,attrs = [{ten,1042}],goods_num = 148 };
get(6,124) ->
	#base_marry_heart{type = 6 ,lv = 124 ,attrs = [{hit,1042}],goods_num = 148 };
get(7,124) ->
	#base_marry_heart{type = 7 ,lv = 124 ,attrs = [{dodge,1042}],goods_num = 148 };
get(8,124) ->
	#base_marry_heart{type = 8 ,lv = 124 ,attrs = [{att,3160},{def,3160},{hp_lim,31600}],goods_num = 469 };
get(1,125) ->
	#base_marry_heart{type = 1 ,lv = 125 ,attrs = [{att,3200}],goods_num = 150 };
get(2,125) ->
	#base_marry_heart{type = 2 ,lv = 125 ,attrs = [{def,3200}],goods_num = 150 };
get(3,125) ->
	#base_marry_heart{type = 3 ,lv = 125 ,attrs = [{hp_lim,32000}],goods_num = 150 };
get(4,125) ->
	#base_marry_heart{type = 4 ,lv = 125 ,attrs = [{crit,1055}],goods_num = 150 };
get(5,125) ->
	#base_marry_heart{type = 5 ,lv = 125 ,attrs = [{ten,1055}],goods_num = 150 };
get(6,125) ->
	#base_marry_heart{type = 6 ,lv = 125 ,attrs = [{hit,1055}],goods_num = 150 };
get(7,125) ->
	#base_marry_heart{type = 7 ,lv = 125 ,attrs = [{dodge,1055}],goods_num = 150 };
get(8,125) ->
	#base_marry_heart{type = 8 ,lv = 125 ,attrs = [{att,3200},{def,3200},{hp_lim,32000}],goods_num = 478 };
get(1,126) ->
	#base_marry_heart{type = 1 ,lv = 126 ,attrs = [{att,3240}],goods_num = 153 };
get(2,126) ->
	#base_marry_heart{type = 2 ,lv = 126 ,attrs = [{def,3240}],goods_num = 153 };
get(3,126) ->
	#base_marry_heart{type = 3 ,lv = 126 ,attrs = [{hp_lim,32400}],goods_num = 153 };
get(4,126) ->
	#base_marry_heart{type = 4 ,lv = 126 ,attrs = [{crit,1068}],goods_num = 153 };
get(5,126) ->
	#base_marry_heart{type = 5 ,lv = 126 ,attrs = [{ten,1068}],goods_num = 153 };
get(6,126) ->
	#base_marry_heart{type = 6 ,lv = 126 ,attrs = [{hit,1068}],goods_num = 153 };
get(7,126) ->
	#base_marry_heart{type = 7 ,lv = 126 ,attrs = [{dodge,1068}],goods_num = 153 };
get(8,126) ->
	#base_marry_heart{type = 8 ,lv = 126 ,attrs = [{att,3240},{def,3240},{hp_lim,32400}],goods_num = 487 };
get(1,127) ->
	#base_marry_heart{type = 1 ,lv = 127 ,attrs = [{att,3280}],goods_num = 156 };
get(2,127) ->
	#base_marry_heart{type = 2 ,lv = 127 ,attrs = [{def,3280}],goods_num = 156 };
get(3,127) ->
	#base_marry_heart{type = 3 ,lv = 127 ,attrs = [{hp_lim,32800}],goods_num = 156 };
get(4,127) ->
	#base_marry_heart{type = 4 ,lv = 127 ,attrs = [{crit,1081}],goods_num = 156 };
get(5,127) ->
	#base_marry_heart{type = 5 ,lv = 127 ,attrs = [{ten,1081}],goods_num = 156 };
get(6,127) ->
	#base_marry_heart{type = 6 ,lv = 127 ,attrs = [{hit,1081}],goods_num = 156 };
get(7,127) ->
	#base_marry_heart{type = 7 ,lv = 127 ,attrs = [{dodge,1081}],goods_num = 156 };
get(8,127) ->
	#base_marry_heart{type = 8 ,lv = 127 ,attrs = [{att,3280},{def,3280},{hp_lim,32800}],goods_num = 496 };
get(1,128) ->
	#base_marry_heart{type = 1 ,lv = 128 ,attrs = [{att,3320}],goods_num = 159 };
get(2,128) ->
	#base_marry_heart{type = 2 ,lv = 128 ,attrs = [{def,3320}],goods_num = 159 };
get(3,128) ->
	#base_marry_heart{type = 3 ,lv = 128 ,attrs = [{hp_lim,33200}],goods_num = 159 };
get(4,128) ->
	#base_marry_heart{type = 4 ,lv = 128 ,attrs = [{crit,1094}],goods_num = 159 };
get(5,128) ->
	#base_marry_heart{type = 5 ,lv = 128 ,attrs = [{ten,1094}],goods_num = 159 };
get(6,128) ->
	#base_marry_heart{type = 6 ,lv = 128 ,attrs = [{hit,1094}],goods_num = 159 };
get(7,128) ->
	#base_marry_heart{type = 7 ,lv = 128 ,attrs = [{dodge,1094}],goods_num = 159 };
get(8,128) ->
	#base_marry_heart{type = 8 ,lv = 128 ,attrs = [{att,3320},{def,3320},{hp_lim,33200}],goods_num = 505 };
get(1,129) ->
	#base_marry_heart{type = 1 ,lv = 129 ,attrs = [{att,3360}],goods_num = 162 };
get(2,129) ->
	#base_marry_heart{type = 2 ,lv = 129 ,attrs = [{def,3360}],goods_num = 162 };
get(3,129) ->
	#base_marry_heart{type = 3 ,lv = 129 ,attrs = [{hp_lim,33600}],goods_num = 162 };
get(4,129) ->
	#base_marry_heart{type = 4 ,lv = 129 ,attrs = [{crit,1107}],goods_num = 162 };
get(5,129) ->
	#base_marry_heart{type = 5 ,lv = 129 ,attrs = [{ten,1107}],goods_num = 162 };
get(6,129) ->
	#base_marry_heart{type = 6 ,lv = 129 ,attrs = [{hit,1107}],goods_num = 162 };
get(7,129) ->
	#base_marry_heart{type = 7 ,lv = 129 ,attrs = [{dodge,1107}],goods_num = 162 };
get(8,129) ->
	#base_marry_heart{type = 8 ,lv = 129 ,attrs = [{att,3360},{def,3360},{hp_lim,33600}],goods_num = 515 };
get(1,130) ->
	#base_marry_heart{type = 1 ,lv = 130 ,attrs = [{att,3400}],goods_num = 165 };
get(2,130) ->
	#base_marry_heart{type = 2 ,lv = 130 ,attrs = [{def,3400}],goods_num = 165 };
get(3,130) ->
	#base_marry_heart{type = 3 ,lv = 130 ,attrs = [{hp_lim,34000}],goods_num = 165 };
get(4,130) ->
	#base_marry_heart{type = 4 ,lv = 130 ,attrs = [{crit,1120}],goods_num = 165 };
get(5,130) ->
	#base_marry_heart{type = 5 ,lv = 130 ,attrs = [{ten,1120}],goods_num = 165 };
get(6,130) ->
	#base_marry_heart{type = 6 ,lv = 130 ,attrs = [{hit,1120}],goods_num = 165 };
get(7,130) ->
	#base_marry_heart{type = 7 ,lv = 130 ,attrs = [{dodge,1120}],goods_num = 165 };
get(8,130) ->
	#base_marry_heart{type = 8 ,lv = 130 ,attrs = [{att,3400},{def,3400},{hp_lim,34000}],goods_num = 525 };
get(1,131) ->
	#base_marry_heart{type = 1 ,lv = 131 ,attrs = [{att,3440}],goods_num = 168 };
get(2,131) ->
	#base_marry_heart{type = 2 ,lv = 131 ,attrs = [{def,3440}],goods_num = 168 };
get(3,131) ->
	#base_marry_heart{type = 3 ,lv = 131 ,attrs = [{hp_lim,34400}],goods_num = 168 };
get(4,131) ->
	#base_marry_heart{type = 4 ,lv = 131 ,attrs = [{crit,1133}],goods_num = 168 };
get(5,131) ->
	#base_marry_heart{type = 5 ,lv = 131 ,attrs = [{ten,1133}],goods_num = 168 };
get(6,131) ->
	#base_marry_heart{type = 6 ,lv = 131 ,attrs = [{hit,1133}],goods_num = 168 };
get(7,131) ->
	#base_marry_heart{type = 7 ,lv = 131 ,attrs = [{dodge,1133}],goods_num = 168 };
get(8,131) ->
	#base_marry_heart{type = 8 ,lv = 131 ,attrs = [{att,3440},{def,3440},{hp_lim,34400}],goods_num = 535 };
get(1,132) ->
	#base_marry_heart{type = 1 ,lv = 132 ,attrs = [{att,3480}],goods_num = 171 };
get(2,132) ->
	#base_marry_heart{type = 2 ,lv = 132 ,attrs = [{def,3480}],goods_num = 171 };
get(3,132) ->
	#base_marry_heart{type = 3 ,lv = 132 ,attrs = [{hp_lim,34800}],goods_num = 171 };
get(4,132) ->
	#base_marry_heart{type = 4 ,lv = 132 ,attrs = [{crit,1146}],goods_num = 171 };
get(5,132) ->
	#base_marry_heart{type = 5 ,lv = 132 ,attrs = [{ten,1146}],goods_num = 171 };
get(6,132) ->
	#base_marry_heart{type = 6 ,lv = 132 ,attrs = [{hit,1146}],goods_num = 171 };
get(7,132) ->
	#base_marry_heart{type = 7 ,lv = 132 ,attrs = [{dodge,1146}],goods_num = 171 };
get(8,132) ->
	#base_marry_heart{type = 8 ,lv = 132 ,attrs = [{att,3480},{def,3480},{hp_lim,34800}],goods_num = 545 };
get(1,133) ->
	#base_marry_heart{type = 1 ,lv = 133 ,attrs = [{att,3520}],goods_num = 174 };
get(2,133) ->
	#base_marry_heart{type = 2 ,lv = 133 ,attrs = [{def,3520}],goods_num = 174 };
get(3,133) ->
	#base_marry_heart{type = 3 ,lv = 133 ,attrs = [{hp_lim,35200}],goods_num = 174 };
get(4,133) ->
	#base_marry_heart{type = 4 ,lv = 133 ,attrs = [{crit,1159}],goods_num = 174 };
get(5,133) ->
	#base_marry_heart{type = 5 ,lv = 133 ,attrs = [{ten,1159}],goods_num = 174 };
get(6,133) ->
	#base_marry_heart{type = 6 ,lv = 133 ,attrs = [{hit,1159}],goods_num = 174 };
get(7,133) ->
	#base_marry_heart{type = 7 ,lv = 133 ,attrs = [{dodge,1159}],goods_num = 174 };
get(8,133) ->
	#base_marry_heart{type = 8 ,lv = 133 ,attrs = [{att,3520},{def,3520},{hp_lim,35200}],goods_num = 555 };
get(1,134) ->
	#base_marry_heart{type = 1 ,lv = 134 ,attrs = [{att,3560}],goods_num = 177 };
get(2,134) ->
	#base_marry_heart{type = 2 ,lv = 134 ,attrs = [{def,3560}],goods_num = 177 };
get(3,134) ->
	#base_marry_heart{type = 3 ,lv = 134 ,attrs = [{hp_lim,35600}],goods_num = 177 };
get(4,134) ->
	#base_marry_heart{type = 4 ,lv = 134 ,attrs = [{crit,1172}],goods_num = 177 };
get(5,134) ->
	#base_marry_heart{type = 5 ,lv = 134 ,attrs = [{ten,1172}],goods_num = 177 };
get(6,134) ->
	#base_marry_heart{type = 6 ,lv = 134 ,attrs = [{hit,1172}],goods_num = 177 };
get(7,134) ->
	#base_marry_heart{type = 7 ,lv = 134 ,attrs = [{dodge,1172}],goods_num = 177 };
get(8,134) ->
	#base_marry_heart{type = 8 ,lv = 134 ,attrs = [{att,3560},{def,3560},{hp_lim,35600}],goods_num = 566 };
get(1,135) ->
	#base_marry_heart{type = 1 ,lv = 135 ,attrs = [{att,3600}],goods_num = 180 };
get(2,135) ->
	#base_marry_heart{type = 2 ,lv = 135 ,attrs = [{def,3600}],goods_num = 180 };
get(3,135) ->
	#base_marry_heart{type = 3 ,lv = 135 ,attrs = [{hp_lim,36000}],goods_num = 180 };
get(4,135) ->
	#base_marry_heart{type = 4 ,lv = 135 ,attrs = [{crit,1185}],goods_num = 180 };
get(5,135) ->
	#base_marry_heart{type = 5 ,lv = 135 ,attrs = [{ten,1185}],goods_num = 180 };
get(6,135) ->
	#base_marry_heart{type = 6 ,lv = 135 ,attrs = [{hit,1185}],goods_num = 180 };
get(7,135) ->
	#base_marry_heart{type = 7 ,lv = 135 ,attrs = [{dodge,1185}],goods_num = 180 };
get(8,135) ->
	#base_marry_heart{type = 8 ,lv = 135 ,attrs = [{att,3600},{def,3600},{hp_lim,36000}],goods_num = 577 };
get(1,136) ->
	#base_marry_heart{type = 1 ,lv = 136 ,attrs = [{att,3640}],goods_num = 183 };
get(2,136) ->
	#base_marry_heart{type = 2 ,lv = 136 ,attrs = [{def,3640}],goods_num = 183 };
get(3,136) ->
	#base_marry_heart{type = 3 ,lv = 136 ,attrs = [{hp_lim,36400}],goods_num = 183 };
get(4,136) ->
	#base_marry_heart{type = 4 ,lv = 136 ,attrs = [{crit,1198}],goods_num = 183 };
get(5,136) ->
	#base_marry_heart{type = 5 ,lv = 136 ,attrs = [{ten,1198}],goods_num = 183 };
get(6,136) ->
	#base_marry_heart{type = 6 ,lv = 136 ,attrs = [{hit,1198}],goods_num = 183 };
get(7,136) ->
	#base_marry_heart{type = 7 ,lv = 136 ,attrs = [{dodge,1198}],goods_num = 183 };
get(8,136) ->
	#base_marry_heart{type = 8 ,lv = 136 ,attrs = [{att,3640},{def,3640},{hp_lim,36400}],goods_num = 588 };
get(1,137) ->
	#base_marry_heart{type = 1 ,lv = 137 ,attrs = [{att,3680}],goods_num = 186 };
get(2,137) ->
	#base_marry_heart{type = 2 ,lv = 137 ,attrs = [{def,3680}],goods_num = 186 };
get(3,137) ->
	#base_marry_heart{type = 3 ,lv = 137 ,attrs = [{hp_lim,36800}],goods_num = 186 };
get(4,137) ->
	#base_marry_heart{type = 4 ,lv = 137 ,attrs = [{crit,1211}],goods_num = 186 };
get(5,137) ->
	#base_marry_heart{type = 5 ,lv = 137 ,attrs = [{ten,1211}],goods_num = 186 };
get(6,137) ->
	#base_marry_heart{type = 6 ,lv = 137 ,attrs = [{hit,1211}],goods_num = 186 };
get(7,137) ->
	#base_marry_heart{type = 7 ,lv = 137 ,attrs = [{dodge,1211}],goods_num = 186 };
get(8,137) ->
	#base_marry_heart{type = 8 ,lv = 137 ,attrs = [{att,3680},{def,3680},{hp_lim,36800}],goods_num = 599 };
get(1,138) ->
	#base_marry_heart{type = 1 ,lv = 138 ,attrs = [{att,3720}],goods_num = 189 };
get(2,138) ->
	#base_marry_heart{type = 2 ,lv = 138 ,attrs = [{def,3720}],goods_num = 189 };
get(3,138) ->
	#base_marry_heart{type = 3 ,lv = 138 ,attrs = [{hp_lim,37200}],goods_num = 189 };
get(4,138) ->
	#base_marry_heart{type = 4 ,lv = 138 ,attrs = [{crit,1224}],goods_num = 189 };
get(5,138) ->
	#base_marry_heart{type = 5 ,lv = 138 ,attrs = [{ten,1224}],goods_num = 189 };
get(6,138) ->
	#base_marry_heart{type = 6 ,lv = 138 ,attrs = [{hit,1224}],goods_num = 189 };
get(7,138) ->
	#base_marry_heart{type = 7 ,lv = 138 ,attrs = [{dodge,1224}],goods_num = 189 };
get(8,138) ->
	#base_marry_heart{type = 8 ,lv = 138 ,attrs = [{att,3720},{def,3720},{hp_lim,37200}],goods_num = 610 };
get(1,139) ->
	#base_marry_heart{type = 1 ,lv = 139 ,attrs = [{att,3760}],goods_num = 192 };
get(2,139) ->
	#base_marry_heart{type = 2 ,lv = 139 ,attrs = [{def,3760}],goods_num = 192 };
get(3,139) ->
	#base_marry_heart{type = 3 ,lv = 139 ,attrs = [{hp_lim,37600}],goods_num = 192 };
get(4,139) ->
	#base_marry_heart{type = 4 ,lv = 139 ,attrs = [{crit,1237}],goods_num = 192 };
get(5,139) ->
	#base_marry_heart{type = 5 ,lv = 139 ,attrs = [{ten,1237}],goods_num = 192 };
get(6,139) ->
	#base_marry_heart{type = 6 ,lv = 139 ,attrs = [{hit,1237}],goods_num = 192 };
get(7,139) ->
	#base_marry_heart{type = 7 ,lv = 139 ,attrs = [{dodge,1237}],goods_num = 192 };
get(8,139) ->
	#base_marry_heart{type = 8 ,lv = 139 ,attrs = [{att,3760},{def,3760},{hp_lim,37600}],goods_num = 622 };
get(1,140) ->
	#base_marry_heart{type = 1 ,lv = 140 ,attrs = [{att,3800}],goods_num = 195 };
get(2,140) ->
	#base_marry_heart{type = 2 ,lv = 140 ,attrs = [{def,3800}],goods_num = 195 };
get(3,140) ->
	#base_marry_heart{type = 3 ,lv = 140 ,attrs = [{hp_lim,38000}],goods_num = 195 };
get(4,140) ->
	#base_marry_heart{type = 4 ,lv = 140 ,attrs = [{crit,1250}],goods_num = 195 };
get(5,140) ->
	#base_marry_heart{type = 5 ,lv = 140 ,attrs = [{ten,1250}],goods_num = 195 };
get(6,140) ->
	#base_marry_heart{type = 6 ,lv = 140 ,attrs = [{hit,1250}],goods_num = 195 };
get(7,140) ->
	#base_marry_heart{type = 7 ,lv = 140 ,attrs = [{dodge,1250}],goods_num = 195 };
get(8,140) ->
	#base_marry_heart{type = 8 ,lv = 140 ,attrs = [{att,3800},{def,3800},{hp_lim,38000}],goods_num = 634 };
get(1,141) ->
	#base_marry_heart{type = 1 ,lv = 141 ,attrs = [{att,3840}],goods_num = 198 };
get(2,141) ->
	#base_marry_heart{type = 2 ,lv = 141 ,attrs = [{def,3840}],goods_num = 198 };
get(3,141) ->
	#base_marry_heart{type = 3 ,lv = 141 ,attrs = [{hp_lim,38400}],goods_num = 198 };
get(4,141) ->
	#base_marry_heart{type = 4 ,lv = 141 ,attrs = [{crit,1263}],goods_num = 198 };
get(5,141) ->
	#base_marry_heart{type = 5 ,lv = 141 ,attrs = [{ten,1263}],goods_num = 198 };
get(6,141) ->
	#base_marry_heart{type = 6 ,lv = 141 ,attrs = [{hit,1263}],goods_num = 198 };
get(7,141) ->
	#base_marry_heart{type = 7 ,lv = 141 ,attrs = [{dodge,1263}],goods_num = 198 };
get(8,141) ->
	#base_marry_heart{type = 8 ,lv = 141 ,attrs = [{att,3840},{def,3840},{hp_lim,38400}],goods_num = 646 };
get(1,142) ->
	#base_marry_heart{type = 1 ,lv = 142 ,attrs = [{att,3880}],goods_num = 201 };
get(2,142) ->
	#base_marry_heart{type = 2 ,lv = 142 ,attrs = [{def,3880}],goods_num = 201 };
get(3,142) ->
	#base_marry_heart{type = 3 ,lv = 142 ,attrs = [{hp_lim,38800}],goods_num = 201 };
get(4,142) ->
	#base_marry_heart{type = 4 ,lv = 142 ,attrs = [{crit,1276}],goods_num = 201 };
get(5,142) ->
	#base_marry_heart{type = 5 ,lv = 142 ,attrs = [{ten,1276}],goods_num = 201 };
get(6,142) ->
	#base_marry_heart{type = 6 ,lv = 142 ,attrs = [{hit,1276}],goods_num = 201 };
get(7,142) ->
	#base_marry_heart{type = 7 ,lv = 142 ,attrs = [{dodge,1276}],goods_num = 201 };
get(8,142) ->
	#base_marry_heart{type = 8 ,lv = 142 ,attrs = [{att,3880},{def,3880},{hp_lim,38800}],goods_num = 658 };
get(1,143) ->
	#base_marry_heart{type = 1 ,lv = 143 ,attrs = [{att,3920}],goods_num = 205 };
get(2,143) ->
	#base_marry_heart{type = 2 ,lv = 143 ,attrs = [{def,3920}],goods_num = 205 };
get(3,143) ->
	#base_marry_heart{type = 3 ,lv = 143 ,attrs = [{hp_lim,39200}],goods_num = 205 };
get(4,143) ->
	#base_marry_heart{type = 4 ,lv = 143 ,attrs = [{crit,1289}],goods_num = 205 };
get(5,143) ->
	#base_marry_heart{type = 5 ,lv = 143 ,attrs = [{ten,1289}],goods_num = 205 };
get(6,143) ->
	#base_marry_heart{type = 6 ,lv = 143 ,attrs = [{hit,1289}],goods_num = 205 };
get(7,143) ->
	#base_marry_heart{type = 7 ,lv = 143 ,attrs = [{dodge,1289}],goods_num = 205 };
get(8,143) ->
	#base_marry_heart{type = 8 ,lv = 143 ,attrs = [{att,3920},{def,3920},{hp_lim,39200}],goods_num = 671 };
get(1,144) ->
	#base_marry_heart{type = 1 ,lv = 144 ,attrs = [{att,3960}],goods_num = 209 };
get(2,144) ->
	#base_marry_heart{type = 2 ,lv = 144 ,attrs = [{def,3960}],goods_num = 209 };
get(3,144) ->
	#base_marry_heart{type = 3 ,lv = 144 ,attrs = [{hp_lim,39600}],goods_num = 209 };
get(4,144) ->
	#base_marry_heart{type = 4 ,lv = 144 ,attrs = [{crit,1302}],goods_num = 209 };
get(5,144) ->
	#base_marry_heart{type = 5 ,lv = 144 ,attrs = [{ten,1302}],goods_num = 209 };
get(6,144) ->
	#base_marry_heart{type = 6 ,lv = 144 ,attrs = [{hit,1302}],goods_num = 209 };
get(7,144) ->
	#base_marry_heart{type = 7 ,lv = 144 ,attrs = [{dodge,1302}],goods_num = 209 };
get(8,144) ->
	#base_marry_heart{type = 8 ,lv = 144 ,attrs = [{att,3960},{def,3960},{hp_lim,39600}],goods_num = 684 };
get(1,145) ->
	#base_marry_heart{type = 1 ,lv = 145 ,attrs = [{att,4000}],goods_num = 213 };
get(2,145) ->
	#base_marry_heart{type = 2 ,lv = 145 ,attrs = [{def,4000}],goods_num = 213 };
get(3,145) ->
	#base_marry_heart{type = 3 ,lv = 145 ,attrs = [{hp_lim,40000}],goods_num = 213 };
get(4,145) ->
	#base_marry_heart{type = 4 ,lv = 145 ,attrs = [{crit,1315}],goods_num = 213 };
get(5,145) ->
	#base_marry_heart{type = 5 ,lv = 145 ,attrs = [{ten,1315}],goods_num = 213 };
get(6,145) ->
	#base_marry_heart{type = 6 ,lv = 145 ,attrs = [{hit,1315}],goods_num = 213 };
get(7,145) ->
	#base_marry_heart{type = 7 ,lv = 145 ,attrs = [{dodge,1315}],goods_num = 213 };
get(8,145) ->
	#base_marry_heart{type = 8 ,lv = 145 ,attrs = [{att,4000},{def,4000},{hp_lim,40000}],goods_num = 697 };
get(1,146) ->
	#base_marry_heart{type = 1 ,lv = 146 ,attrs = [{att,4040}],goods_num = 217 };
get(2,146) ->
	#base_marry_heart{type = 2 ,lv = 146 ,attrs = [{def,4040}],goods_num = 217 };
get(3,146) ->
	#base_marry_heart{type = 3 ,lv = 146 ,attrs = [{hp_lim,40400}],goods_num = 217 };
get(4,146) ->
	#base_marry_heart{type = 4 ,lv = 146 ,attrs = [{crit,1328}],goods_num = 217 };
get(5,146) ->
	#base_marry_heart{type = 5 ,lv = 146 ,attrs = [{ten,1328}],goods_num = 217 };
get(6,146) ->
	#base_marry_heart{type = 6 ,lv = 146 ,attrs = [{hit,1328}],goods_num = 217 };
get(7,146) ->
	#base_marry_heart{type = 7 ,lv = 146 ,attrs = [{dodge,1328}],goods_num = 217 };
get(8,146) ->
	#base_marry_heart{type = 8 ,lv = 146 ,attrs = [{att,4040},{def,4040},{hp_lim,40400}],goods_num = 710 };
get(1,147) ->
	#base_marry_heart{type = 1 ,lv = 147 ,attrs = [{att,4080}],goods_num = 221 };
get(2,147) ->
	#base_marry_heart{type = 2 ,lv = 147 ,attrs = [{def,4080}],goods_num = 221 };
get(3,147) ->
	#base_marry_heart{type = 3 ,lv = 147 ,attrs = [{hp_lim,40800}],goods_num = 221 };
get(4,147) ->
	#base_marry_heart{type = 4 ,lv = 147 ,attrs = [{crit,1341}],goods_num = 221 };
get(5,147) ->
	#base_marry_heart{type = 5 ,lv = 147 ,attrs = [{ten,1341}],goods_num = 221 };
get(6,147) ->
	#base_marry_heart{type = 6 ,lv = 147 ,attrs = [{hit,1341}],goods_num = 221 };
get(7,147) ->
	#base_marry_heart{type = 7 ,lv = 147 ,attrs = [{dodge,1341}],goods_num = 221 };
get(8,147) ->
	#base_marry_heart{type = 8 ,lv = 147 ,attrs = [{att,4080},{def,4080},{hp_lim,40800}],goods_num = 724 };
get(1,148) ->
	#base_marry_heart{type = 1 ,lv = 148 ,attrs = [{att,4120}],goods_num = 225 };
get(2,148) ->
	#base_marry_heart{type = 2 ,lv = 148 ,attrs = [{def,4120}],goods_num = 225 };
get(3,148) ->
	#base_marry_heart{type = 3 ,lv = 148 ,attrs = [{hp_lim,41200}],goods_num = 225 };
get(4,148) ->
	#base_marry_heart{type = 4 ,lv = 148 ,attrs = [{crit,1354}],goods_num = 225 };
get(5,148) ->
	#base_marry_heart{type = 5 ,lv = 148 ,attrs = [{ten,1354}],goods_num = 225 };
get(6,148) ->
	#base_marry_heart{type = 6 ,lv = 148 ,attrs = [{hit,1354}],goods_num = 225 };
get(7,148) ->
	#base_marry_heart{type = 7 ,lv = 148 ,attrs = [{dodge,1354}],goods_num = 225 };
get(8,148) ->
	#base_marry_heart{type = 8 ,lv = 148 ,attrs = [{att,4120},{def,4120},{hp_lim,41200}],goods_num = 738 };
get(1,149) ->
	#base_marry_heart{type = 1 ,lv = 149 ,attrs = [{att,4160}],goods_num = 229 };
get(2,149) ->
	#base_marry_heart{type = 2 ,lv = 149 ,attrs = [{def,4160}],goods_num = 229 };
get(3,149) ->
	#base_marry_heart{type = 3 ,lv = 149 ,attrs = [{hp_lim,41600}],goods_num = 229 };
get(4,149) ->
	#base_marry_heart{type = 4 ,lv = 149 ,attrs = [{crit,1367}],goods_num = 229 };
get(5,149) ->
	#base_marry_heart{type = 5 ,lv = 149 ,attrs = [{ten,1367}],goods_num = 229 };
get(6,149) ->
	#base_marry_heart{type = 6 ,lv = 149 ,attrs = [{hit,1367}],goods_num = 229 };
get(7,149) ->
	#base_marry_heart{type = 7 ,lv = 149 ,attrs = [{dodge,1367}],goods_num = 229 };
get(8,149) ->
	#base_marry_heart{type = 8 ,lv = 149 ,attrs = [{att,4160},{def,4160},{hp_lim,41600}],goods_num = 752 };
get(1,150) ->
	#base_marry_heart{type = 1 ,lv = 150 ,attrs = [{att,4200}],goods_num = 233 };
get(2,150) ->
	#base_marry_heart{type = 2 ,lv = 150 ,attrs = [{def,4200}],goods_num = 233 };
get(3,150) ->
	#base_marry_heart{type = 3 ,lv = 150 ,attrs = [{hp_lim,42000}],goods_num = 233 };
get(4,150) ->
	#base_marry_heart{type = 4 ,lv = 150 ,attrs = [{crit,1380}],goods_num = 233 };
get(5,150) ->
	#base_marry_heart{type = 5 ,lv = 150 ,attrs = [{ten,1380}],goods_num = 233 };
get(6,150) ->
	#base_marry_heart{type = 6 ,lv = 150 ,attrs = [{hit,1380}],goods_num = 233 };
get(7,150) ->
	#base_marry_heart{type = 7 ,lv = 150 ,attrs = [{dodge,1380}],goods_num = 233 };
get(8,150) ->
	#base_marry_heart{type = 8 ,lv = 150 ,attrs = [{att,4200},{def,4200},{hp_lim,42000}],goods_num = 767 };
get(1,151) ->
	#base_marry_heart{type = 1 ,lv = 151 ,attrs = [{att,4240}],goods_num = 237 };
get(2,151) ->
	#base_marry_heart{type = 2 ,lv = 151 ,attrs = [{def,4240}],goods_num = 237 };
get(3,151) ->
	#base_marry_heart{type = 3 ,lv = 151 ,attrs = [{hp_lim,42400}],goods_num = 237 };
get(4,151) ->
	#base_marry_heart{type = 4 ,lv = 151 ,attrs = [{crit,1393}],goods_num = 237 };
get(5,151) ->
	#base_marry_heart{type = 5 ,lv = 151 ,attrs = [{ten,1393}],goods_num = 237 };
get(6,151) ->
	#base_marry_heart{type = 6 ,lv = 151 ,attrs = [{hit,1393}],goods_num = 237 };
get(7,151) ->
	#base_marry_heart{type = 7 ,lv = 151 ,attrs = [{dodge,1393}],goods_num = 237 };
get(8,151) ->
	#base_marry_heart{type = 8 ,lv = 151 ,attrs = [{att,4240},{def,4240},{hp_lim,42400}],goods_num = 782 };
get(1,152) ->
	#base_marry_heart{type = 1 ,lv = 152 ,attrs = [{att,4280}],goods_num = 241 };
get(2,152) ->
	#base_marry_heart{type = 2 ,lv = 152 ,attrs = [{def,4280}],goods_num = 241 };
get(3,152) ->
	#base_marry_heart{type = 3 ,lv = 152 ,attrs = [{hp_lim,42800}],goods_num = 241 };
get(4,152) ->
	#base_marry_heart{type = 4 ,lv = 152 ,attrs = [{crit,1406}],goods_num = 241 };
get(5,152) ->
	#base_marry_heart{type = 5 ,lv = 152 ,attrs = [{ten,1406}],goods_num = 241 };
get(6,152) ->
	#base_marry_heart{type = 6 ,lv = 152 ,attrs = [{hit,1406}],goods_num = 241 };
get(7,152) ->
	#base_marry_heart{type = 7 ,lv = 152 ,attrs = [{dodge,1406}],goods_num = 241 };
get(8,152) ->
	#base_marry_heart{type = 8 ,lv = 152 ,attrs = [{att,4280},{def,4280},{hp_lim,42800}],goods_num = 797 };
get(1,153) ->
	#base_marry_heart{type = 1 ,lv = 153 ,attrs = [{att,4320}],goods_num = 245 };
get(2,153) ->
	#base_marry_heart{type = 2 ,lv = 153 ,attrs = [{def,4320}],goods_num = 245 };
get(3,153) ->
	#base_marry_heart{type = 3 ,lv = 153 ,attrs = [{hp_lim,43200}],goods_num = 245 };
get(4,153) ->
	#base_marry_heart{type = 4 ,lv = 153 ,attrs = [{crit,1419}],goods_num = 245 };
get(5,153) ->
	#base_marry_heart{type = 5 ,lv = 153 ,attrs = [{ten,1419}],goods_num = 245 };
get(6,153) ->
	#base_marry_heart{type = 6 ,lv = 153 ,attrs = [{hit,1419}],goods_num = 245 };
get(7,153) ->
	#base_marry_heart{type = 7 ,lv = 153 ,attrs = [{dodge,1419}],goods_num = 245 };
get(8,153) ->
	#base_marry_heart{type = 8 ,lv = 153 ,attrs = [{att,4320},{def,4320},{hp_lim,43200}],goods_num = 812 };
get(1,154) ->
	#base_marry_heart{type = 1 ,lv = 154 ,attrs = [{att,4360}],goods_num = 249 };
get(2,154) ->
	#base_marry_heart{type = 2 ,lv = 154 ,attrs = [{def,4360}],goods_num = 249 };
get(3,154) ->
	#base_marry_heart{type = 3 ,lv = 154 ,attrs = [{hp_lim,43600}],goods_num = 249 };
get(4,154) ->
	#base_marry_heart{type = 4 ,lv = 154 ,attrs = [{crit,1432}],goods_num = 249 };
get(5,154) ->
	#base_marry_heart{type = 5 ,lv = 154 ,attrs = [{ten,1432}],goods_num = 249 };
get(6,154) ->
	#base_marry_heart{type = 6 ,lv = 154 ,attrs = [{hit,1432}],goods_num = 249 };
get(7,154) ->
	#base_marry_heart{type = 7 ,lv = 154 ,attrs = [{dodge,1432}],goods_num = 249 };
get(8,154) ->
	#base_marry_heart{type = 8 ,lv = 154 ,attrs = [{att,4360},{def,4360},{hp_lim,43600}],goods_num = 828 };
get(1,155) ->
	#base_marry_heart{type = 1 ,lv = 155 ,attrs = [{att,4400}],goods_num = 253 };
get(2,155) ->
	#base_marry_heart{type = 2 ,lv = 155 ,attrs = [{def,4400}],goods_num = 253 };
get(3,155) ->
	#base_marry_heart{type = 3 ,lv = 155 ,attrs = [{hp_lim,44000}],goods_num = 253 };
get(4,155) ->
	#base_marry_heart{type = 4 ,lv = 155 ,attrs = [{crit,1445}],goods_num = 253 };
get(5,155) ->
	#base_marry_heart{type = 5 ,lv = 155 ,attrs = [{ten,1445}],goods_num = 253 };
get(6,155) ->
	#base_marry_heart{type = 6 ,lv = 155 ,attrs = [{hit,1445}],goods_num = 253 };
get(7,155) ->
	#base_marry_heart{type = 7 ,lv = 155 ,attrs = [{dodge,1445}],goods_num = 253 };
get(8,155) ->
	#base_marry_heart{type = 8 ,lv = 155 ,attrs = [{att,4400},{def,4400},{hp_lim,44000}],goods_num = 844 };
get(1,156) ->
	#base_marry_heart{type = 1 ,lv = 156 ,attrs = [{att,4440}],goods_num = 258 };
get(2,156) ->
	#base_marry_heart{type = 2 ,lv = 156 ,attrs = [{def,4440}],goods_num = 258 };
get(3,156) ->
	#base_marry_heart{type = 3 ,lv = 156 ,attrs = [{hp_lim,44400}],goods_num = 258 };
get(4,156) ->
	#base_marry_heart{type = 4 ,lv = 156 ,attrs = [{crit,1458}],goods_num = 258 };
get(5,156) ->
	#base_marry_heart{type = 5 ,lv = 156 ,attrs = [{ten,1458}],goods_num = 258 };
get(6,156) ->
	#base_marry_heart{type = 6 ,lv = 156 ,attrs = [{hit,1458}],goods_num = 258 };
get(7,156) ->
	#base_marry_heart{type = 7 ,lv = 156 ,attrs = [{dodge,1458}],goods_num = 258 };
get(8,156) ->
	#base_marry_heart{type = 8 ,lv = 156 ,attrs = [{att,4440},{def,4440},{hp_lim,44400}],goods_num = 860 };
get(1,157) ->
	#base_marry_heart{type = 1 ,lv = 157 ,attrs = [{att,4480}],goods_num = 263 };
get(2,157) ->
	#base_marry_heart{type = 2 ,lv = 157 ,attrs = [{def,4480}],goods_num = 263 };
get(3,157) ->
	#base_marry_heart{type = 3 ,lv = 157 ,attrs = [{hp_lim,44800}],goods_num = 263 };
get(4,157) ->
	#base_marry_heart{type = 4 ,lv = 157 ,attrs = [{crit,1471}],goods_num = 263 };
get(5,157) ->
	#base_marry_heart{type = 5 ,lv = 157 ,attrs = [{ten,1471}],goods_num = 263 };
get(6,157) ->
	#base_marry_heart{type = 6 ,lv = 157 ,attrs = [{hit,1471}],goods_num = 263 };
get(7,157) ->
	#base_marry_heart{type = 7 ,lv = 157 ,attrs = [{dodge,1471}],goods_num = 263 };
get(8,157) ->
	#base_marry_heart{type = 8 ,lv = 157 ,attrs = [{att,4480},{def,4480},{hp_lim,44800}],goods_num = 877 };
get(1,158) ->
	#base_marry_heart{type = 1 ,lv = 158 ,attrs = [{att,4520}],goods_num = 268 };
get(2,158) ->
	#base_marry_heart{type = 2 ,lv = 158 ,attrs = [{def,4520}],goods_num = 268 };
get(3,158) ->
	#base_marry_heart{type = 3 ,lv = 158 ,attrs = [{hp_lim,45200}],goods_num = 268 };
get(4,158) ->
	#base_marry_heart{type = 4 ,lv = 158 ,attrs = [{crit,1484}],goods_num = 268 };
get(5,158) ->
	#base_marry_heart{type = 5 ,lv = 158 ,attrs = [{ten,1484}],goods_num = 268 };
get(6,158) ->
	#base_marry_heart{type = 6 ,lv = 158 ,attrs = [{hit,1484}],goods_num = 268 };
get(7,158) ->
	#base_marry_heart{type = 7 ,lv = 158 ,attrs = [{dodge,1484}],goods_num = 268 };
get(8,158) ->
	#base_marry_heart{type = 8 ,lv = 158 ,attrs = [{att,4520},{def,4520},{hp_lim,45200}],goods_num = 894 };
get(1,159) ->
	#base_marry_heart{type = 1 ,lv = 159 ,attrs = [{att,4560}],goods_num = 273 };
get(2,159) ->
	#base_marry_heart{type = 2 ,lv = 159 ,attrs = [{def,4560}],goods_num = 273 };
get(3,159) ->
	#base_marry_heart{type = 3 ,lv = 159 ,attrs = [{hp_lim,45600}],goods_num = 273 };
get(4,159) ->
	#base_marry_heart{type = 4 ,lv = 159 ,attrs = [{crit,1497}],goods_num = 273 };
get(5,159) ->
	#base_marry_heart{type = 5 ,lv = 159 ,attrs = [{ten,1497}],goods_num = 273 };
get(6,159) ->
	#base_marry_heart{type = 6 ,lv = 159 ,attrs = [{hit,1497}],goods_num = 273 };
get(7,159) ->
	#base_marry_heart{type = 7 ,lv = 159 ,attrs = [{dodge,1497}],goods_num = 273 };
get(8,159) ->
	#base_marry_heart{type = 8 ,lv = 159 ,attrs = [{att,4560},{def,4560},{hp_lim,45600}],goods_num = 911 };
get(1,160) ->
	#base_marry_heart{type = 1 ,lv = 160 ,attrs = [{att,4600}],goods_num = 278 };
get(2,160) ->
	#base_marry_heart{type = 2 ,lv = 160 ,attrs = [{def,4600}],goods_num = 278 };
get(3,160) ->
	#base_marry_heart{type = 3 ,lv = 160 ,attrs = [{hp_lim,46000}],goods_num = 278 };
get(4,160) ->
	#base_marry_heart{type = 4 ,lv = 160 ,attrs = [{crit,1510}],goods_num = 278 };
get(5,160) ->
	#base_marry_heart{type = 5 ,lv = 160 ,attrs = [{ten,1510}],goods_num = 278 };
get(6,160) ->
	#base_marry_heart{type = 6 ,lv = 160 ,attrs = [{hit,1510}],goods_num = 278 };
get(7,160) ->
	#base_marry_heart{type = 7 ,lv = 160 ,attrs = [{dodge,1510}],goods_num = 278 };
get(8,160) ->
	#base_marry_heart{type = 8 ,lv = 160 ,attrs = [{att,4600},{def,4600},{hp_lim,46000}],goods_num = 929 };
get(1,161) ->
	#base_marry_heart{type = 1 ,lv = 161 ,attrs = [{att,4640}],goods_num = 283 };
get(2,161) ->
	#base_marry_heart{type = 2 ,lv = 161 ,attrs = [{def,4640}],goods_num = 283 };
get(3,161) ->
	#base_marry_heart{type = 3 ,lv = 161 ,attrs = [{hp_lim,46400}],goods_num = 283 };
get(4,161) ->
	#base_marry_heart{type = 4 ,lv = 161 ,attrs = [{crit,1523}],goods_num = 283 };
get(5,161) ->
	#base_marry_heart{type = 5 ,lv = 161 ,attrs = [{ten,1523}],goods_num = 283 };
get(6,161) ->
	#base_marry_heart{type = 6 ,lv = 161 ,attrs = [{hit,1523}],goods_num = 283 };
get(7,161) ->
	#base_marry_heart{type = 7 ,lv = 161 ,attrs = [{dodge,1523}],goods_num = 283 };
get(8,161) ->
	#base_marry_heart{type = 8 ,lv = 161 ,attrs = [{att,4640},{def,4640},{hp_lim,46400}],goods_num = 947 };
get(1,162) ->
	#base_marry_heart{type = 1 ,lv = 162 ,attrs = [{att,4680}],goods_num = 288 };
get(2,162) ->
	#base_marry_heart{type = 2 ,lv = 162 ,attrs = [{def,4680}],goods_num = 288 };
get(3,162) ->
	#base_marry_heart{type = 3 ,lv = 162 ,attrs = [{hp_lim,46800}],goods_num = 288 };
get(4,162) ->
	#base_marry_heart{type = 4 ,lv = 162 ,attrs = [{crit,1536}],goods_num = 288 };
get(5,162) ->
	#base_marry_heart{type = 5 ,lv = 162 ,attrs = [{ten,1536}],goods_num = 288 };
get(6,162) ->
	#base_marry_heart{type = 6 ,lv = 162 ,attrs = [{hit,1536}],goods_num = 288 };
get(7,162) ->
	#base_marry_heart{type = 7 ,lv = 162 ,attrs = [{dodge,1536}],goods_num = 288 };
get(8,162) ->
	#base_marry_heart{type = 8 ,lv = 162 ,attrs = [{att,4680},{def,4680},{hp_lim,46800}],goods_num = 965 };
get(1,163) ->
	#base_marry_heart{type = 1 ,lv = 163 ,attrs = [{att,4720}],goods_num = 293 };
get(2,163) ->
	#base_marry_heart{type = 2 ,lv = 163 ,attrs = [{def,4720}],goods_num = 293 };
get(3,163) ->
	#base_marry_heart{type = 3 ,lv = 163 ,attrs = [{hp_lim,47200}],goods_num = 293 };
get(4,163) ->
	#base_marry_heart{type = 4 ,lv = 163 ,attrs = [{crit,1549}],goods_num = 293 };
get(5,163) ->
	#base_marry_heart{type = 5 ,lv = 163 ,attrs = [{ten,1549}],goods_num = 293 };
get(6,163) ->
	#base_marry_heart{type = 6 ,lv = 163 ,attrs = [{hit,1549}],goods_num = 293 };
get(7,163) ->
	#base_marry_heart{type = 7 ,lv = 163 ,attrs = [{dodge,1549}],goods_num = 293 };
get(8,163) ->
	#base_marry_heart{type = 8 ,lv = 163 ,attrs = [{att,4720},{def,4720},{hp_lim,47200}],goods_num = 984 };
get(1,164) ->
	#base_marry_heart{type = 1 ,lv = 164 ,attrs = [{att,4760}],goods_num = 298 };
get(2,164) ->
	#base_marry_heart{type = 2 ,lv = 164 ,attrs = [{def,4760}],goods_num = 298 };
get(3,164) ->
	#base_marry_heart{type = 3 ,lv = 164 ,attrs = [{hp_lim,47600}],goods_num = 298 };
get(4,164) ->
	#base_marry_heart{type = 4 ,lv = 164 ,attrs = [{crit,1562}],goods_num = 298 };
get(5,164) ->
	#base_marry_heart{type = 5 ,lv = 164 ,attrs = [{ten,1562}],goods_num = 298 };
get(6,164) ->
	#base_marry_heart{type = 6 ,lv = 164 ,attrs = [{hit,1562}],goods_num = 298 };
get(7,164) ->
	#base_marry_heart{type = 7 ,lv = 164 ,attrs = [{dodge,1562}],goods_num = 298 };
get(8,164) ->
	#base_marry_heart{type = 8 ,lv = 164 ,attrs = [{att,4760},{def,4760},{hp_lim,47600}],goods_num = 1003 };
get(1,165) ->
	#base_marry_heart{type = 1 ,lv = 165 ,attrs = [{att,4800}],goods_num = 303 };
get(2,165) ->
	#base_marry_heart{type = 2 ,lv = 165 ,attrs = [{def,4800}],goods_num = 303 };
get(3,165) ->
	#base_marry_heart{type = 3 ,lv = 165 ,attrs = [{hp_lim,48000}],goods_num = 303 };
get(4,165) ->
	#base_marry_heart{type = 4 ,lv = 165 ,attrs = [{crit,1575}],goods_num = 303 };
get(5,165) ->
	#base_marry_heart{type = 5 ,lv = 165 ,attrs = [{ten,1575}],goods_num = 303 };
get(6,165) ->
	#base_marry_heart{type = 6 ,lv = 165 ,attrs = [{hit,1575}],goods_num = 303 };
get(7,165) ->
	#base_marry_heart{type = 7 ,lv = 165 ,attrs = [{dodge,1575}],goods_num = 303 };
get(8,165) ->
	#base_marry_heart{type = 8 ,lv = 165 ,attrs = [{att,4800},{def,4800},{hp_lim,48000}],goods_num = 1023 };
get(1,166) ->
	#base_marry_heart{type = 1 ,lv = 166 ,attrs = [{att,4840}],goods_num = 309 };
get(2,166) ->
	#base_marry_heart{type = 2 ,lv = 166 ,attrs = [{def,4840}],goods_num = 309 };
get(3,166) ->
	#base_marry_heart{type = 3 ,lv = 166 ,attrs = [{hp_lim,48400}],goods_num = 309 };
get(4,166) ->
	#base_marry_heart{type = 4 ,lv = 166 ,attrs = [{crit,1588}],goods_num = 309 };
get(5,166) ->
	#base_marry_heart{type = 5 ,lv = 166 ,attrs = [{ten,1588}],goods_num = 309 };
get(6,166) ->
	#base_marry_heart{type = 6 ,lv = 166 ,attrs = [{hit,1588}],goods_num = 309 };
get(7,166) ->
	#base_marry_heart{type = 7 ,lv = 166 ,attrs = [{dodge,1588}],goods_num = 309 };
get(8,166) ->
	#base_marry_heart{type = 8 ,lv = 166 ,attrs = [{att,4840},{def,4840},{hp_lim,48400}],goods_num = 1043 };
get(1,167) ->
	#base_marry_heart{type = 1 ,lv = 167 ,attrs = [{att,4880}],goods_num = 315 };
get(2,167) ->
	#base_marry_heart{type = 2 ,lv = 167 ,attrs = [{def,4880}],goods_num = 315 };
get(3,167) ->
	#base_marry_heart{type = 3 ,lv = 167 ,attrs = [{hp_lim,48800}],goods_num = 315 };
get(4,167) ->
	#base_marry_heart{type = 4 ,lv = 167 ,attrs = [{crit,1601}],goods_num = 315 };
get(5,167) ->
	#base_marry_heart{type = 5 ,lv = 167 ,attrs = [{ten,1601}],goods_num = 315 };
get(6,167) ->
	#base_marry_heart{type = 6 ,lv = 167 ,attrs = [{hit,1601}],goods_num = 315 };
get(7,167) ->
	#base_marry_heart{type = 7 ,lv = 167 ,attrs = [{dodge,1601}],goods_num = 315 };
get(8,167) ->
	#base_marry_heart{type = 8 ,lv = 167 ,attrs = [{att,4880},{def,4880},{hp_lim,48800}],goods_num = 1063 };
get(1,168) ->
	#base_marry_heart{type = 1 ,lv = 168 ,attrs = [{att,4920}],goods_num = 321 };
get(2,168) ->
	#base_marry_heart{type = 2 ,lv = 168 ,attrs = [{def,4920}],goods_num = 321 };
get(3,168) ->
	#base_marry_heart{type = 3 ,lv = 168 ,attrs = [{hp_lim,49200}],goods_num = 321 };
get(4,168) ->
	#base_marry_heart{type = 4 ,lv = 168 ,attrs = [{crit,1614}],goods_num = 321 };
get(5,168) ->
	#base_marry_heart{type = 5 ,lv = 168 ,attrs = [{ten,1614}],goods_num = 321 };
get(6,168) ->
	#base_marry_heart{type = 6 ,lv = 168 ,attrs = [{hit,1614}],goods_num = 321 };
get(7,168) ->
	#base_marry_heart{type = 7 ,lv = 168 ,attrs = [{dodge,1614}],goods_num = 321 };
get(8,168) ->
	#base_marry_heart{type = 8 ,lv = 168 ,attrs = [{att,4920},{def,4920},{hp_lim,49200}],goods_num = 1084 };
get(1,169) ->
	#base_marry_heart{type = 1 ,lv = 169 ,attrs = [{att,4960}],goods_num = 327 };
get(2,169) ->
	#base_marry_heart{type = 2 ,lv = 169 ,attrs = [{def,4960}],goods_num = 327 };
get(3,169) ->
	#base_marry_heart{type = 3 ,lv = 169 ,attrs = [{hp_lim,49600}],goods_num = 327 };
get(4,169) ->
	#base_marry_heart{type = 4 ,lv = 169 ,attrs = [{crit,1627}],goods_num = 327 };
get(5,169) ->
	#base_marry_heart{type = 5 ,lv = 169 ,attrs = [{ten,1627}],goods_num = 327 };
get(6,169) ->
	#base_marry_heart{type = 6 ,lv = 169 ,attrs = [{hit,1627}],goods_num = 327 };
get(7,169) ->
	#base_marry_heart{type = 7 ,lv = 169 ,attrs = [{dodge,1627}],goods_num = 327 };
get(8,169) ->
	#base_marry_heart{type = 8 ,lv = 169 ,attrs = [{att,4960},{def,4960},{hp_lim,49600}],goods_num = 1105 };
get(1,170) ->
	#base_marry_heart{type = 1 ,lv = 170 ,attrs = [{att,5000}],goods_num = 333 };
get(2,170) ->
	#base_marry_heart{type = 2 ,lv = 170 ,attrs = [{def,5000}],goods_num = 333 };
get(3,170) ->
	#base_marry_heart{type = 3 ,lv = 170 ,attrs = [{hp_lim,50000}],goods_num = 333 };
get(4,170) ->
	#base_marry_heart{type = 4 ,lv = 170 ,attrs = [{crit,1640}],goods_num = 333 };
get(5,170) ->
	#base_marry_heart{type = 5 ,lv = 170 ,attrs = [{ten,1640}],goods_num = 333 };
get(6,170) ->
	#base_marry_heart{type = 6 ,lv = 170 ,attrs = [{hit,1640}],goods_num = 333 };
get(7,170) ->
	#base_marry_heart{type = 7 ,lv = 170 ,attrs = [{dodge,1640}],goods_num = 333 };
get(8,170) ->
	#base_marry_heart{type = 8 ,lv = 170 ,attrs = [{att,5000},{def,5000},{hp_lim,50000}],goods_num = 1127 };
get(1,171) ->
	#base_marry_heart{type = 1 ,lv = 171 ,attrs = [{att,5040}],goods_num = 339 };
get(2,171) ->
	#base_marry_heart{type = 2 ,lv = 171 ,attrs = [{def,5040}],goods_num = 339 };
get(3,171) ->
	#base_marry_heart{type = 3 ,lv = 171 ,attrs = [{hp_lim,50400}],goods_num = 339 };
get(4,171) ->
	#base_marry_heart{type = 4 ,lv = 171 ,attrs = [{crit,1653}],goods_num = 339 };
get(5,171) ->
	#base_marry_heart{type = 5 ,lv = 171 ,attrs = [{ten,1653}],goods_num = 339 };
get(6,171) ->
	#base_marry_heart{type = 6 ,lv = 171 ,attrs = [{hit,1653}],goods_num = 339 };
get(7,171) ->
	#base_marry_heart{type = 7 ,lv = 171 ,attrs = [{dodge,1653}],goods_num = 339 };
get(8,171) ->
	#base_marry_heart{type = 8 ,lv = 171 ,attrs = [{att,5040},{def,5040},{hp_lim,50400}],goods_num = 1149 };
get(1,172) ->
	#base_marry_heart{type = 1 ,lv = 172 ,attrs = [{att,5080}],goods_num = 345 };
get(2,172) ->
	#base_marry_heart{type = 2 ,lv = 172 ,attrs = [{def,5080}],goods_num = 345 };
get(3,172) ->
	#base_marry_heart{type = 3 ,lv = 172 ,attrs = [{hp_lim,50800}],goods_num = 345 };
get(4,172) ->
	#base_marry_heart{type = 4 ,lv = 172 ,attrs = [{crit,1666}],goods_num = 345 };
get(5,172) ->
	#base_marry_heart{type = 5 ,lv = 172 ,attrs = [{ten,1666}],goods_num = 345 };
get(6,172) ->
	#base_marry_heart{type = 6 ,lv = 172 ,attrs = [{hit,1666}],goods_num = 345 };
get(7,172) ->
	#base_marry_heart{type = 7 ,lv = 172 ,attrs = [{dodge,1666}],goods_num = 345 };
get(8,172) ->
	#base_marry_heart{type = 8 ,lv = 172 ,attrs = [{att,5080},{def,5080},{hp_lim,50800}],goods_num = 1171 };
get(1,173) ->
	#base_marry_heart{type = 1 ,lv = 173 ,attrs = [{att,5120}],goods_num = 351 };
get(2,173) ->
	#base_marry_heart{type = 2 ,lv = 173 ,attrs = [{def,5120}],goods_num = 351 };
get(3,173) ->
	#base_marry_heart{type = 3 ,lv = 173 ,attrs = [{hp_lim,51200}],goods_num = 351 };
get(4,173) ->
	#base_marry_heart{type = 4 ,lv = 173 ,attrs = [{crit,1679}],goods_num = 351 };
get(5,173) ->
	#base_marry_heart{type = 5 ,lv = 173 ,attrs = [{ten,1679}],goods_num = 351 };
get(6,173) ->
	#base_marry_heart{type = 6 ,lv = 173 ,attrs = [{hit,1679}],goods_num = 351 };
get(7,173) ->
	#base_marry_heart{type = 7 ,lv = 173 ,attrs = [{dodge,1679}],goods_num = 351 };
get(8,173) ->
	#base_marry_heart{type = 8 ,lv = 173 ,attrs = [{att,5120},{def,5120},{hp_lim,51200}],goods_num = 1194 };
get(1,174) ->
	#base_marry_heart{type = 1 ,lv = 174 ,attrs = [{att,5160}],goods_num = 358 };
get(2,174) ->
	#base_marry_heart{type = 2 ,lv = 174 ,attrs = [{def,5160}],goods_num = 358 };
get(3,174) ->
	#base_marry_heart{type = 3 ,lv = 174 ,attrs = [{hp_lim,51600}],goods_num = 358 };
get(4,174) ->
	#base_marry_heart{type = 4 ,lv = 174 ,attrs = [{crit,1692}],goods_num = 358 };
get(5,174) ->
	#base_marry_heart{type = 5 ,lv = 174 ,attrs = [{ten,1692}],goods_num = 358 };
get(6,174) ->
	#base_marry_heart{type = 6 ,lv = 174 ,attrs = [{hit,1692}],goods_num = 358 };
get(7,174) ->
	#base_marry_heart{type = 7 ,lv = 174 ,attrs = [{dodge,1692}],goods_num = 358 };
get(8,174) ->
	#base_marry_heart{type = 8 ,lv = 174 ,attrs = [{att,5160},{def,5160},{hp_lim,51600}],goods_num = 1217 };
get(1,175) ->
	#base_marry_heart{type = 1 ,lv = 175 ,attrs = [{att,5200}],goods_num = 365 };
get(2,175) ->
	#base_marry_heart{type = 2 ,lv = 175 ,attrs = [{def,5200}],goods_num = 365 };
get(3,175) ->
	#base_marry_heart{type = 3 ,lv = 175 ,attrs = [{hp_lim,52000}],goods_num = 365 };
get(4,175) ->
	#base_marry_heart{type = 4 ,lv = 175 ,attrs = [{crit,1705}],goods_num = 365 };
get(5,175) ->
	#base_marry_heart{type = 5 ,lv = 175 ,attrs = [{ten,1705}],goods_num = 365 };
get(6,175) ->
	#base_marry_heart{type = 6 ,lv = 175 ,attrs = [{hit,1705}],goods_num = 365 };
get(7,175) ->
	#base_marry_heart{type = 7 ,lv = 175 ,attrs = [{dodge,1705}],goods_num = 365 };
get(8,175) ->
	#base_marry_heart{type = 8 ,lv = 175 ,attrs = [{att,5200},{def,5200},{hp_lim,52000}],goods_num = 1241 };
get(1,176) ->
	#base_marry_heart{type = 1 ,lv = 176 ,attrs = [{att,5240}],goods_num = 372 };
get(2,176) ->
	#base_marry_heart{type = 2 ,lv = 176 ,attrs = [{def,5240}],goods_num = 372 };
get(3,176) ->
	#base_marry_heart{type = 3 ,lv = 176 ,attrs = [{hp_lim,52400}],goods_num = 372 };
get(4,176) ->
	#base_marry_heart{type = 4 ,lv = 176 ,attrs = [{crit,1718}],goods_num = 372 };
get(5,176) ->
	#base_marry_heart{type = 5 ,lv = 176 ,attrs = [{ten,1718}],goods_num = 372 };
get(6,176) ->
	#base_marry_heart{type = 6 ,lv = 176 ,attrs = [{hit,1718}],goods_num = 372 };
get(7,176) ->
	#base_marry_heart{type = 7 ,lv = 176 ,attrs = [{dodge,1718}],goods_num = 372 };
get(8,176) ->
	#base_marry_heart{type = 8 ,lv = 176 ,attrs = [{att,5240},{def,5240},{hp_lim,52400}],goods_num = 1265 };
get(1,177) ->
	#base_marry_heart{type = 1 ,lv = 177 ,attrs = [{att,5280}],goods_num = 379 };
get(2,177) ->
	#base_marry_heart{type = 2 ,lv = 177 ,attrs = [{def,5280}],goods_num = 379 };
get(3,177) ->
	#base_marry_heart{type = 3 ,lv = 177 ,attrs = [{hp_lim,52800}],goods_num = 379 };
get(4,177) ->
	#base_marry_heart{type = 4 ,lv = 177 ,attrs = [{crit,1731}],goods_num = 379 };
get(5,177) ->
	#base_marry_heart{type = 5 ,lv = 177 ,attrs = [{ten,1731}],goods_num = 379 };
get(6,177) ->
	#base_marry_heart{type = 6 ,lv = 177 ,attrs = [{hit,1731}],goods_num = 379 };
get(7,177) ->
	#base_marry_heart{type = 7 ,lv = 177 ,attrs = [{dodge,1731}],goods_num = 379 };
get(8,177) ->
	#base_marry_heart{type = 8 ,lv = 177 ,attrs = [{att,5280},{def,5280},{hp_lim,52800}],goods_num = 1290 };
get(1,178) ->
	#base_marry_heart{type = 1 ,lv = 178 ,attrs = [{att,5320}],goods_num = 386 };
get(2,178) ->
	#base_marry_heart{type = 2 ,lv = 178 ,attrs = [{def,5320}],goods_num = 386 };
get(3,178) ->
	#base_marry_heart{type = 3 ,lv = 178 ,attrs = [{hp_lim,53200}],goods_num = 386 };
get(4,178) ->
	#base_marry_heart{type = 4 ,lv = 178 ,attrs = [{crit,1744}],goods_num = 386 };
get(5,178) ->
	#base_marry_heart{type = 5 ,lv = 178 ,attrs = [{ten,1744}],goods_num = 386 };
get(6,178) ->
	#base_marry_heart{type = 6 ,lv = 178 ,attrs = [{hit,1744}],goods_num = 386 };
get(7,178) ->
	#base_marry_heart{type = 7 ,lv = 178 ,attrs = [{dodge,1744}],goods_num = 386 };
get(8,178) ->
	#base_marry_heart{type = 8 ,lv = 178 ,attrs = [{att,5320},{def,5320},{hp_lim,53200}],goods_num = 1315 };
get(1,179) ->
	#base_marry_heart{type = 1 ,lv = 179 ,attrs = [{att,5360}],goods_num = 393 };
get(2,179) ->
	#base_marry_heart{type = 2 ,lv = 179 ,attrs = [{def,5360}],goods_num = 393 };
get(3,179) ->
	#base_marry_heart{type = 3 ,lv = 179 ,attrs = [{hp_lim,53600}],goods_num = 393 };
get(4,179) ->
	#base_marry_heart{type = 4 ,lv = 179 ,attrs = [{crit,1757}],goods_num = 393 };
get(5,179) ->
	#base_marry_heart{type = 5 ,lv = 179 ,attrs = [{ten,1757}],goods_num = 393 };
get(6,179) ->
	#base_marry_heart{type = 6 ,lv = 179 ,attrs = [{hit,1757}],goods_num = 393 };
get(7,179) ->
	#base_marry_heart{type = 7 ,lv = 179 ,attrs = [{dodge,1757}],goods_num = 393 };
get(8,179) ->
	#base_marry_heart{type = 8 ,lv = 179 ,attrs = [{att,5360},{def,5360},{hp_lim,53600}],goods_num = 1341 };
get(1,180) ->
	#base_marry_heart{type = 1 ,lv = 180 ,attrs = [{att,5400}],goods_num = 400 };
get(2,180) ->
	#base_marry_heart{type = 2 ,lv = 180 ,attrs = [{def,5400}],goods_num = 400 };
get(3,180) ->
	#base_marry_heart{type = 3 ,lv = 180 ,attrs = [{hp_lim,54000}],goods_num = 400 };
get(4,180) ->
	#base_marry_heart{type = 4 ,lv = 180 ,attrs = [{crit,1770}],goods_num = 400 };
get(5,180) ->
	#base_marry_heart{type = 5 ,lv = 180 ,attrs = [{ten,1770}],goods_num = 400 };
get(6,180) ->
	#base_marry_heart{type = 6 ,lv = 180 ,attrs = [{hit,1770}],goods_num = 400 };
get(7,180) ->
	#base_marry_heart{type = 7 ,lv = 180 ,attrs = [{dodge,1770}],goods_num = 400 };
get(8,180) ->
	#base_marry_heart{type = 8 ,lv = 180 ,attrs = [{att,5400},{def,5400},{hp_lim,54000}],goods_num = 1367 };
get(1,181) ->
	#base_marry_heart{type = 1 ,lv = 181 ,attrs = [{att,5440}],goods_num = 408 };
get(2,181) ->
	#base_marry_heart{type = 2 ,lv = 181 ,attrs = [{def,5440}],goods_num = 408 };
get(3,181) ->
	#base_marry_heart{type = 3 ,lv = 181 ,attrs = [{hp_lim,54400}],goods_num = 408 };
get(4,181) ->
	#base_marry_heart{type = 4 ,lv = 181 ,attrs = [{crit,1783}],goods_num = 408 };
get(5,181) ->
	#base_marry_heart{type = 5 ,lv = 181 ,attrs = [{ten,1783}],goods_num = 408 };
get(6,181) ->
	#base_marry_heart{type = 6 ,lv = 181 ,attrs = [{hit,1783}],goods_num = 408 };
get(7,181) ->
	#base_marry_heart{type = 7 ,lv = 181 ,attrs = [{dodge,1783}],goods_num = 408 };
get(8,181) ->
	#base_marry_heart{type = 8 ,lv = 181 ,attrs = [{att,5440},{def,5440},{hp_lim,54400}],goods_num = 1394 };
get(1,182) ->
	#base_marry_heart{type = 1 ,lv = 182 ,attrs = [{att,5480}],goods_num = 416 };
get(2,182) ->
	#base_marry_heart{type = 2 ,lv = 182 ,attrs = [{def,5480}],goods_num = 416 };
get(3,182) ->
	#base_marry_heart{type = 3 ,lv = 182 ,attrs = [{hp_lim,54800}],goods_num = 416 };
get(4,182) ->
	#base_marry_heart{type = 4 ,lv = 182 ,attrs = [{crit,1796}],goods_num = 416 };
get(5,182) ->
	#base_marry_heart{type = 5 ,lv = 182 ,attrs = [{ten,1796}],goods_num = 416 };
get(6,182) ->
	#base_marry_heart{type = 6 ,lv = 182 ,attrs = [{hit,1796}],goods_num = 416 };
get(7,182) ->
	#base_marry_heart{type = 7 ,lv = 182 ,attrs = [{dodge,1796}],goods_num = 416 };
get(8,182) ->
	#base_marry_heart{type = 8 ,lv = 182 ,attrs = [{att,5480},{def,5480},{hp_lim,54800}],goods_num = 1421 };
get(1,183) ->
	#base_marry_heart{type = 1 ,lv = 183 ,attrs = [{att,5520}],goods_num = 424 };
get(2,183) ->
	#base_marry_heart{type = 2 ,lv = 183 ,attrs = [{def,5520}],goods_num = 424 };
get(3,183) ->
	#base_marry_heart{type = 3 ,lv = 183 ,attrs = [{hp_lim,55200}],goods_num = 424 };
get(4,183) ->
	#base_marry_heart{type = 4 ,lv = 183 ,attrs = [{crit,1809}],goods_num = 424 };
get(5,183) ->
	#base_marry_heart{type = 5 ,lv = 183 ,attrs = [{ten,1809}],goods_num = 424 };
get(6,183) ->
	#base_marry_heart{type = 6 ,lv = 183 ,attrs = [{hit,1809}],goods_num = 424 };
get(7,183) ->
	#base_marry_heart{type = 7 ,lv = 183 ,attrs = [{dodge,1809}],goods_num = 424 };
get(8,183) ->
	#base_marry_heart{type = 8 ,lv = 183 ,attrs = [{att,5520},{def,5520},{hp_lim,55200}],goods_num = 1449 };
get(1,184) ->
	#base_marry_heart{type = 1 ,lv = 184 ,attrs = [{att,5560}],goods_num = 432 };
get(2,184) ->
	#base_marry_heart{type = 2 ,lv = 184 ,attrs = [{def,5560}],goods_num = 432 };
get(3,184) ->
	#base_marry_heart{type = 3 ,lv = 184 ,attrs = [{hp_lim,55600}],goods_num = 432 };
get(4,184) ->
	#base_marry_heart{type = 4 ,lv = 184 ,attrs = [{crit,1822}],goods_num = 432 };
get(5,184) ->
	#base_marry_heart{type = 5 ,lv = 184 ,attrs = [{ten,1822}],goods_num = 432 };
get(6,184) ->
	#base_marry_heart{type = 6 ,lv = 184 ,attrs = [{hit,1822}],goods_num = 432 };
get(7,184) ->
	#base_marry_heart{type = 7 ,lv = 184 ,attrs = [{dodge,1822}],goods_num = 432 };
get(8,184) ->
	#base_marry_heart{type = 8 ,lv = 184 ,attrs = [{att,5560},{def,5560},{hp_lim,55600}],goods_num = 1477 };
get(1,185) ->
	#base_marry_heart{type = 1 ,lv = 185 ,attrs = [{att,5600}],goods_num = 440 };
get(2,185) ->
	#base_marry_heart{type = 2 ,lv = 185 ,attrs = [{def,5600}],goods_num = 440 };
get(3,185) ->
	#base_marry_heart{type = 3 ,lv = 185 ,attrs = [{hp_lim,56000}],goods_num = 440 };
get(4,185) ->
	#base_marry_heart{type = 4 ,lv = 185 ,attrs = [{crit,1835}],goods_num = 440 };
get(5,185) ->
	#base_marry_heart{type = 5 ,lv = 185 ,attrs = [{ten,1835}],goods_num = 440 };
get(6,185) ->
	#base_marry_heart{type = 6 ,lv = 185 ,attrs = [{hit,1835}],goods_num = 440 };
get(7,185) ->
	#base_marry_heart{type = 7 ,lv = 185 ,attrs = [{dodge,1835}],goods_num = 440 };
get(8,185) ->
	#base_marry_heart{type = 8 ,lv = 185 ,attrs = [{att,5600},{def,5600},{hp_lim,56000}],goods_num = 1506 };
get(1,186) ->
	#base_marry_heart{type = 1 ,lv = 186 ,attrs = [{att,5640}],goods_num = 448 };
get(2,186) ->
	#base_marry_heart{type = 2 ,lv = 186 ,attrs = [{def,5640}],goods_num = 448 };
get(3,186) ->
	#base_marry_heart{type = 3 ,lv = 186 ,attrs = [{hp_lim,56400}],goods_num = 448 };
get(4,186) ->
	#base_marry_heart{type = 4 ,lv = 186 ,attrs = [{crit,1848}],goods_num = 448 };
get(5,186) ->
	#base_marry_heart{type = 5 ,lv = 186 ,attrs = [{ten,1848}],goods_num = 448 };
get(6,186) ->
	#base_marry_heart{type = 6 ,lv = 186 ,attrs = [{hit,1848}],goods_num = 448 };
get(7,186) ->
	#base_marry_heart{type = 7 ,lv = 186 ,attrs = [{dodge,1848}],goods_num = 448 };
get(8,186) ->
	#base_marry_heart{type = 8 ,lv = 186 ,attrs = [{att,5640},{def,5640},{hp_lim,56400}],goods_num = 1536 };
get(1,187) ->
	#base_marry_heart{type = 1 ,lv = 187 ,attrs = [{att,5680}],goods_num = 456 };
get(2,187) ->
	#base_marry_heart{type = 2 ,lv = 187 ,attrs = [{def,5680}],goods_num = 456 };
get(3,187) ->
	#base_marry_heart{type = 3 ,lv = 187 ,attrs = [{hp_lim,56800}],goods_num = 456 };
get(4,187) ->
	#base_marry_heart{type = 4 ,lv = 187 ,attrs = [{crit,1861}],goods_num = 456 };
get(5,187) ->
	#base_marry_heart{type = 5 ,lv = 187 ,attrs = [{ten,1861}],goods_num = 456 };
get(6,187) ->
	#base_marry_heart{type = 6 ,lv = 187 ,attrs = [{hit,1861}],goods_num = 456 };
get(7,187) ->
	#base_marry_heart{type = 7 ,lv = 187 ,attrs = [{dodge,1861}],goods_num = 456 };
get(8,187) ->
	#base_marry_heart{type = 8 ,lv = 187 ,attrs = [{att,5680},{def,5680},{hp_lim,56800}],goods_num = 1566 };
get(1,188) ->
	#base_marry_heart{type = 1 ,lv = 188 ,attrs = [{att,5720}],goods_num = 465 };
get(2,188) ->
	#base_marry_heart{type = 2 ,lv = 188 ,attrs = [{def,5720}],goods_num = 465 };
get(3,188) ->
	#base_marry_heart{type = 3 ,lv = 188 ,attrs = [{hp_lim,57200}],goods_num = 465 };
get(4,188) ->
	#base_marry_heart{type = 4 ,lv = 188 ,attrs = [{crit,1874}],goods_num = 465 };
get(5,188) ->
	#base_marry_heart{type = 5 ,lv = 188 ,attrs = [{ten,1874}],goods_num = 465 };
get(6,188) ->
	#base_marry_heart{type = 6 ,lv = 188 ,attrs = [{hit,1874}],goods_num = 465 };
get(7,188) ->
	#base_marry_heart{type = 7 ,lv = 188 ,attrs = [{dodge,1874}],goods_num = 465 };
get(8,188) ->
	#base_marry_heart{type = 8 ,lv = 188 ,attrs = [{att,5720},{def,5720},{hp_lim,57200}],goods_num = 1597 };
get(1,189) ->
	#base_marry_heart{type = 1 ,lv = 189 ,attrs = [{att,5760}],goods_num = 474 };
get(2,189) ->
	#base_marry_heart{type = 2 ,lv = 189 ,attrs = [{def,5760}],goods_num = 474 };
get(3,189) ->
	#base_marry_heart{type = 3 ,lv = 189 ,attrs = [{hp_lim,57600}],goods_num = 474 };
get(4,189) ->
	#base_marry_heart{type = 4 ,lv = 189 ,attrs = [{crit,1887}],goods_num = 474 };
get(5,189) ->
	#base_marry_heart{type = 5 ,lv = 189 ,attrs = [{ten,1887}],goods_num = 474 };
get(6,189) ->
	#base_marry_heart{type = 6 ,lv = 189 ,attrs = [{hit,1887}],goods_num = 474 };
get(7,189) ->
	#base_marry_heart{type = 7 ,lv = 189 ,attrs = [{dodge,1887}],goods_num = 474 };
get(8,189) ->
	#base_marry_heart{type = 8 ,lv = 189 ,attrs = [{att,5760},{def,5760},{hp_lim,57600}],goods_num = 1628 };
get(1,190) ->
	#base_marry_heart{type = 1 ,lv = 190 ,attrs = [{att,5800}],goods_num = 483 };
get(2,190) ->
	#base_marry_heart{type = 2 ,lv = 190 ,attrs = [{def,5800}],goods_num = 483 };
get(3,190) ->
	#base_marry_heart{type = 3 ,lv = 190 ,attrs = [{hp_lim,58000}],goods_num = 483 };
get(4,190) ->
	#base_marry_heart{type = 4 ,lv = 190 ,attrs = [{crit,1900}],goods_num = 483 };
get(5,190) ->
	#base_marry_heart{type = 5 ,lv = 190 ,attrs = [{ten,1900}],goods_num = 483 };
get(6,190) ->
	#base_marry_heart{type = 6 ,lv = 190 ,attrs = [{hit,1900}],goods_num = 483 };
get(7,190) ->
	#base_marry_heart{type = 7 ,lv = 190 ,attrs = [{dodge,1900}],goods_num = 483 };
get(8,190) ->
	#base_marry_heart{type = 8 ,lv = 190 ,attrs = [{att,5800},{def,5800},{hp_lim,58000}],goods_num = 1660 };
get(1,191) ->
	#base_marry_heart{type = 1 ,lv = 191 ,attrs = [{att,5840}],goods_num = 492 };
get(2,191) ->
	#base_marry_heart{type = 2 ,lv = 191 ,attrs = [{def,5840}],goods_num = 492 };
get(3,191) ->
	#base_marry_heart{type = 3 ,lv = 191 ,attrs = [{hp_lim,58400}],goods_num = 492 };
get(4,191) ->
	#base_marry_heart{type = 4 ,lv = 191 ,attrs = [{crit,1913}],goods_num = 492 };
get(5,191) ->
	#base_marry_heart{type = 5 ,lv = 191 ,attrs = [{ten,1913}],goods_num = 492 };
get(6,191) ->
	#base_marry_heart{type = 6 ,lv = 191 ,attrs = [{hit,1913}],goods_num = 492 };
get(7,191) ->
	#base_marry_heart{type = 7 ,lv = 191 ,attrs = [{dodge,1913}],goods_num = 492 };
get(8,191) ->
	#base_marry_heart{type = 8 ,lv = 191 ,attrs = [{att,5840},{def,5840},{hp_lim,58400}],goods_num = 1693 };
get(1,192) ->
	#base_marry_heart{type = 1 ,lv = 192 ,attrs = [{att,5880}],goods_num = 501 };
get(2,192) ->
	#base_marry_heart{type = 2 ,lv = 192 ,attrs = [{def,5880}],goods_num = 501 };
get(3,192) ->
	#base_marry_heart{type = 3 ,lv = 192 ,attrs = [{hp_lim,58800}],goods_num = 501 };
get(4,192) ->
	#base_marry_heart{type = 4 ,lv = 192 ,attrs = [{crit,1926}],goods_num = 501 };
get(5,192) ->
	#base_marry_heart{type = 5 ,lv = 192 ,attrs = [{ten,1926}],goods_num = 501 };
get(6,192) ->
	#base_marry_heart{type = 6 ,lv = 192 ,attrs = [{hit,1926}],goods_num = 501 };
get(7,192) ->
	#base_marry_heart{type = 7 ,lv = 192 ,attrs = [{dodge,1926}],goods_num = 501 };
get(8,192) ->
	#base_marry_heart{type = 8 ,lv = 192 ,attrs = [{att,5880},{def,5880},{hp_lim,58800}],goods_num = 1726 };
get(1,193) ->
	#base_marry_heart{type = 1 ,lv = 193 ,attrs = [{att,5920}],goods_num = 511 };
get(2,193) ->
	#base_marry_heart{type = 2 ,lv = 193 ,attrs = [{def,5920}],goods_num = 511 };
get(3,193) ->
	#base_marry_heart{type = 3 ,lv = 193 ,attrs = [{hp_lim,59200}],goods_num = 511 };
get(4,193) ->
	#base_marry_heart{type = 4 ,lv = 193 ,attrs = [{crit,1939}],goods_num = 511 };
get(5,193) ->
	#base_marry_heart{type = 5 ,lv = 193 ,attrs = [{ten,1939}],goods_num = 511 };
get(6,193) ->
	#base_marry_heart{type = 6 ,lv = 193 ,attrs = [{hit,1939}],goods_num = 511 };
get(7,193) ->
	#base_marry_heart{type = 7 ,lv = 193 ,attrs = [{dodge,1939}],goods_num = 511 };
get(8,193) ->
	#base_marry_heart{type = 8 ,lv = 193 ,attrs = [{att,5920},{def,5920},{hp_lim,59200}],goods_num = 1760 };
get(1,194) ->
	#base_marry_heart{type = 1 ,lv = 194 ,attrs = [{att,5960}],goods_num = 521 };
get(2,194) ->
	#base_marry_heart{type = 2 ,lv = 194 ,attrs = [{def,5960}],goods_num = 521 };
get(3,194) ->
	#base_marry_heart{type = 3 ,lv = 194 ,attrs = [{hp_lim,59600}],goods_num = 521 };
get(4,194) ->
	#base_marry_heart{type = 4 ,lv = 194 ,attrs = [{crit,1952}],goods_num = 521 };
get(5,194) ->
	#base_marry_heart{type = 5 ,lv = 194 ,attrs = [{ten,1952}],goods_num = 521 };
get(6,194) ->
	#base_marry_heart{type = 6 ,lv = 194 ,attrs = [{hit,1952}],goods_num = 521 };
get(7,194) ->
	#base_marry_heart{type = 7 ,lv = 194 ,attrs = [{dodge,1952}],goods_num = 521 };
get(8,194) ->
	#base_marry_heart{type = 8 ,lv = 194 ,attrs = [{att,5960},{def,5960},{hp_lim,59600}],goods_num = 1795 };
get(1,195) ->
	#base_marry_heart{type = 1 ,lv = 195 ,attrs = [{att,6000}],goods_num = 531 };
get(2,195) ->
	#base_marry_heart{type = 2 ,lv = 195 ,attrs = [{def,6000}],goods_num = 531 };
get(3,195) ->
	#base_marry_heart{type = 3 ,lv = 195 ,attrs = [{hp_lim,60000}],goods_num = 531 };
get(4,195) ->
	#base_marry_heart{type = 4 ,lv = 195 ,attrs = [{crit,1965}],goods_num = 531 };
get(5,195) ->
	#base_marry_heart{type = 5 ,lv = 195 ,attrs = [{ten,1965}],goods_num = 531 };
get(6,195) ->
	#base_marry_heart{type = 6 ,lv = 195 ,attrs = [{hit,1965}],goods_num = 531 };
get(7,195) ->
	#base_marry_heart{type = 7 ,lv = 195 ,attrs = [{dodge,1965}],goods_num = 531 };
get(8,195) ->
	#base_marry_heart{type = 8 ,lv = 195 ,attrs = [{att,6000},{def,6000},{hp_lim,60000}],goods_num = 1830 };
get(1,196) ->
	#base_marry_heart{type = 1 ,lv = 196 ,attrs = [{att,6040}],goods_num = 541 };
get(2,196) ->
	#base_marry_heart{type = 2 ,lv = 196 ,attrs = [{def,6040}],goods_num = 541 };
get(3,196) ->
	#base_marry_heart{type = 3 ,lv = 196 ,attrs = [{hp_lim,60400}],goods_num = 541 };
get(4,196) ->
	#base_marry_heart{type = 4 ,lv = 196 ,attrs = [{crit,1978}],goods_num = 541 };
get(5,196) ->
	#base_marry_heart{type = 5 ,lv = 196 ,attrs = [{ten,1978}],goods_num = 541 };
get(6,196) ->
	#base_marry_heart{type = 6 ,lv = 196 ,attrs = [{hit,1978}],goods_num = 541 };
get(7,196) ->
	#base_marry_heart{type = 7 ,lv = 196 ,attrs = [{dodge,1978}],goods_num = 541 };
get(8,196) ->
	#base_marry_heart{type = 8 ,lv = 196 ,attrs = [{att,6040},{def,6040},{hp_lim,60400}],goods_num = 1866 };
get(1,197) ->
	#base_marry_heart{type = 1 ,lv = 197 ,attrs = [{att,6080}],goods_num = 551 };
get(2,197) ->
	#base_marry_heart{type = 2 ,lv = 197 ,attrs = [{def,6080}],goods_num = 551 };
get(3,197) ->
	#base_marry_heart{type = 3 ,lv = 197 ,attrs = [{hp_lim,60800}],goods_num = 551 };
get(4,197) ->
	#base_marry_heart{type = 4 ,lv = 197 ,attrs = [{crit,1991}],goods_num = 551 };
get(5,197) ->
	#base_marry_heart{type = 5 ,lv = 197 ,attrs = [{ten,1991}],goods_num = 551 };
get(6,197) ->
	#base_marry_heart{type = 6 ,lv = 197 ,attrs = [{hit,1991}],goods_num = 551 };
get(7,197) ->
	#base_marry_heart{type = 7 ,lv = 197 ,attrs = [{dodge,1991}],goods_num = 551 };
get(8,197) ->
	#base_marry_heart{type = 8 ,lv = 197 ,attrs = [{att,6080},{def,6080},{hp_lim,60800}],goods_num = 1903 };
get(1,198) ->
	#base_marry_heart{type = 1 ,lv = 198 ,attrs = [{att,6120}],goods_num = 562 };
get(2,198) ->
	#base_marry_heart{type = 2 ,lv = 198 ,attrs = [{def,6120}],goods_num = 562 };
get(3,198) ->
	#base_marry_heart{type = 3 ,lv = 198 ,attrs = [{hp_lim,61200}],goods_num = 562 };
get(4,198) ->
	#base_marry_heart{type = 4 ,lv = 198 ,attrs = [{crit,2004}],goods_num = 562 };
get(5,198) ->
	#base_marry_heart{type = 5 ,lv = 198 ,attrs = [{ten,2004}],goods_num = 562 };
get(6,198) ->
	#base_marry_heart{type = 6 ,lv = 198 ,attrs = [{hit,2004}],goods_num = 562 };
get(7,198) ->
	#base_marry_heart{type = 7 ,lv = 198 ,attrs = [{dodge,2004}],goods_num = 562 };
get(8,198) ->
	#base_marry_heart{type = 8 ,lv = 198 ,attrs = [{att,6120},{def,6120},{hp_lim,61200}],goods_num = 1941 };
get(1,199) ->
	#base_marry_heart{type = 1 ,lv = 199 ,attrs = [{att,6160}],goods_num = 573 };
get(2,199) ->
	#base_marry_heart{type = 2 ,lv = 199 ,attrs = [{def,6160}],goods_num = 573 };
get(3,199) ->
	#base_marry_heart{type = 3 ,lv = 199 ,attrs = [{hp_lim,61600}],goods_num = 573 };
get(4,199) ->
	#base_marry_heart{type = 4 ,lv = 199 ,attrs = [{crit,2017}],goods_num = 573 };
get(5,199) ->
	#base_marry_heart{type = 5 ,lv = 199 ,attrs = [{ten,2017}],goods_num = 573 };
get(6,199) ->
	#base_marry_heart{type = 6 ,lv = 199 ,attrs = [{hit,2017}],goods_num = 573 };
get(7,199) ->
	#base_marry_heart{type = 7 ,lv = 199 ,attrs = [{dodge,2017}],goods_num = 573 };
get(8,199) ->
	#base_marry_heart{type = 8 ,lv = 199 ,attrs = [{att,6160},{def,6160},{hp_lim,61600}],goods_num = 1979 };
get(1,200) ->
	#base_marry_heart{type = 1 ,lv = 200 ,attrs = [{att,6200}],goods_num = 584 };
get(2,200) ->
	#base_marry_heart{type = 2 ,lv = 200 ,attrs = [{def,6200}],goods_num = 584 };
get(3,200) ->
	#base_marry_heart{type = 3 ,lv = 200 ,attrs = [{hp_lim,62000}],goods_num = 584 };
get(4,200) ->
	#base_marry_heart{type = 4 ,lv = 200 ,attrs = [{crit,2030}],goods_num = 584 };
get(5,200) ->
	#base_marry_heart{type = 5 ,lv = 200 ,attrs = [{ten,2030}],goods_num = 584 };
get(6,200) ->
	#base_marry_heart{type = 6 ,lv = 200 ,attrs = [{hit,2030}],goods_num = 584 };
get(7,200) ->
	#base_marry_heart{type = 7 ,lv = 200 ,attrs = [{dodge,2030}],goods_num = 584 };
get(8,200) ->
	#base_marry_heart{type = 8 ,lv = 200 ,attrs = [{att,6200},{def,6200},{hp_lim,62000}],goods_num = 2018 };
get(1,201) ->
	#base_marry_heart{type = 1 ,lv = 201 ,attrs = [{att,6240}],goods_num = 595 };
get(2,201) ->
	#base_marry_heart{type = 2 ,lv = 201 ,attrs = [{def,6240}],goods_num = 595 };
get(3,201) ->
	#base_marry_heart{type = 3 ,lv = 201 ,attrs = [{hp_lim,62400}],goods_num = 595 };
get(4,201) ->
	#base_marry_heart{type = 4 ,lv = 201 ,attrs = [{crit,2043}],goods_num = 595 };
get(5,201) ->
	#base_marry_heart{type = 5 ,lv = 201 ,attrs = [{ten,2043}],goods_num = 595 };
get(6,201) ->
	#base_marry_heart{type = 6 ,lv = 201 ,attrs = [{hit,2043}],goods_num = 595 };
get(7,201) ->
	#base_marry_heart{type = 7 ,lv = 201 ,attrs = [{dodge,2043}],goods_num = 595 };
get(8,201) ->
	#base_marry_heart{type = 8 ,lv = 201 ,attrs = [{att,6240},{def,6240},{hp_lim,62400}],goods_num = 2058 };
get(1,202) ->
	#base_marry_heart{type = 1 ,lv = 202 ,attrs = [{att,6280}],goods_num = 606 };
get(2,202) ->
	#base_marry_heart{type = 2 ,lv = 202 ,attrs = [{def,6280}],goods_num = 606 };
get(3,202) ->
	#base_marry_heart{type = 3 ,lv = 202 ,attrs = [{hp_lim,62800}],goods_num = 606 };
get(4,202) ->
	#base_marry_heart{type = 4 ,lv = 202 ,attrs = [{crit,2056}],goods_num = 606 };
get(5,202) ->
	#base_marry_heart{type = 5 ,lv = 202 ,attrs = [{ten,2056}],goods_num = 606 };
get(6,202) ->
	#base_marry_heart{type = 6 ,lv = 202 ,attrs = [{hit,2056}],goods_num = 606 };
get(7,202) ->
	#base_marry_heart{type = 7 ,lv = 202 ,attrs = [{dodge,2056}],goods_num = 606 };
get(8,202) ->
	#base_marry_heart{type = 8 ,lv = 202 ,attrs = [{att,6280},{def,6280},{hp_lim,62800}],goods_num = 2099 };
get(1,203) ->
	#base_marry_heart{type = 1 ,lv = 203 ,attrs = [{att,6320}],goods_num = 618 };
get(2,203) ->
	#base_marry_heart{type = 2 ,lv = 203 ,attrs = [{def,6320}],goods_num = 618 };
get(3,203) ->
	#base_marry_heart{type = 3 ,lv = 203 ,attrs = [{hp_lim,63200}],goods_num = 618 };
get(4,203) ->
	#base_marry_heart{type = 4 ,lv = 203 ,attrs = [{crit,2069}],goods_num = 618 };
get(5,203) ->
	#base_marry_heart{type = 5 ,lv = 203 ,attrs = [{ten,2069}],goods_num = 618 };
get(6,203) ->
	#base_marry_heart{type = 6 ,lv = 203 ,attrs = [{hit,2069}],goods_num = 618 };
get(7,203) ->
	#base_marry_heart{type = 7 ,lv = 203 ,attrs = [{dodge,2069}],goods_num = 618 };
get(8,203) ->
	#base_marry_heart{type = 8 ,lv = 203 ,attrs = [{att,6320},{def,6320},{hp_lim,63200}],goods_num = 2140 };
get(1,204) ->
	#base_marry_heart{type = 1 ,lv = 204 ,attrs = [{att,6360}],goods_num = 630 };
get(2,204) ->
	#base_marry_heart{type = 2 ,lv = 204 ,attrs = [{def,6360}],goods_num = 630 };
get(3,204) ->
	#base_marry_heart{type = 3 ,lv = 204 ,attrs = [{hp_lim,63600}],goods_num = 630 };
get(4,204) ->
	#base_marry_heart{type = 4 ,lv = 204 ,attrs = [{crit,2082}],goods_num = 630 };
get(5,204) ->
	#base_marry_heart{type = 5 ,lv = 204 ,attrs = [{ten,2082}],goods_num = 630 };
get(6,204) ->
	#base_marry_heart{type = 6 ,lv = 204 ,attrs = [{hit,2082}],goods_num = 630 };
get(7,204) ->
	#base_marry_heart{type = 7 ,lv = 204 ,attrs = [{dodge,2082}],goods_num = 630 };
get(8,204) ->
	#base_marry_heart{type = 8 ,lv = 204 ,attrs = [{att,6360},{def,6360},{hp_lim,63600}],goods_num = 2182 };
get(1,205) ->
	#base_marry_heart{type = 1 ,lv = 205 ,attrs = [{att,6400}],goods_num = 642 };
get(2,205) ->
	#base_marry_heart{type = 2 ,lv = 205 ,attrs = [{def,6400}],goods_num = 642 };
get(3,205) ->
	#base_marry_heart{type = 3 ,lv = 205 ,attrs = [{hp_lim,64000}],goods_num = 642 };
get(4,205) ->
	#base_marry_heart{type = 4 ,lv = 205 ,attrs = [{crit,2095}],goods_num = 642 };
get(5,205) ->
	#base_marry_heart{type = 5 ,lv = 205 ,attrs = [{ten,2095}],goods_num = 642 };
get(6,205) ->
	#base_marry_heart{type = 6 ,lv = 205 ,attrs = [{hit,2095}],goods_num = 642 };
get(7,205) ->
	#base_marry_heart{type = 7 ,lv = 205 ,attrs = [{dodge,2095}],goods_num = 642 };
get(8,205) ->
	#base_marry_heart{type = 8 ,lv = 205 ,attrs = [{att,6400},{def,6400},{hp_lim,64000}],goods_num = 2225 };
get(1,206) ->
	#base_marry_heart{type = 1 ,lv = 206 ,attrs = [{att,6440}],goods_num = 654 };
get(2,206) ->
	#base_marry_heart{type = 2 ,lv = 206 ,attrs = [{def,6440}],goods_num = 654 };
get(3,206) ->
	#base_marry_heart{type = 3 ,lv = 206 ,attrs = [{hp_lim,64400}],goods_num = 654 };
get(4,206) ->
	#base_marry_heart{type = 4 ,lv = 206 ,attrs = [{crit,2108}],goods_num = 654 };
get(5,206) ->
	#base_marry_heart{type = 5 ,lv = 206 ,attrs = [{ten,2108}],goods_num = 654 };
get(6,206) ->
	#base_marry_heart{type = 6 ,lv = 206 ,attrs = [{hit,2108}],goods_num = 654 };
get(7,206) ->
	#base_marry_heart{type = 7 ,lv = 206 ,attrs = [{dodge,2108}],goods_num = 654 };
get(8,206) ->
	#base_marry_heart{type = 8 ,lv = 206 ,attrs = [{att,6440},{def,6440},{hp_lim,64400}],goods_num = 2269 };
get(1,207) ->
	#base_marry_heart{type = 1 ,lv = 207 ,attrs = [{att,6480}],goods_num = 667 };
get(2,207) ->
	#base_marry_heart{type = 2 ,lv = 207 ,attrs = [{def,6480}],goods_num = 667 };
get(3,207) ->
	#base_marry_heart{type = 3 ,lv = 207 ,attrs = [{hp_lim,64800}],goods_num = 667 };
get(4,207) ->
	#base_marry_heart{type = 4 ,lv = 207 ,attrs = [{crit,2121}],goods_num = 667 };
get(5,207) ->
	#base_marry_heart{type = 5 ,lv = 207 ,attrs = [{ten,2121}],goods_num = 667 };
get(6,207) ->
	#base_marry_heart{type = 6 ,lv = 207 ,attrs = [{hit,2121}],goods_num = 667 };
get(7,207) ->
	#base_marry_heart{type = 7 ,lv = 207 ,attrs = [{dodge,2121}],goods_num = 667 };
get(8,207) ->
	#base_marry_heart{type = 8 ,lv = 207 ,attrs = [{att,6480},{def,6480},{hp_lim,64800}],goods_num = 2314 };
get(1,208) ->
	#base_marry_heart{type = 1 ,lv = 208 ,attrs = [{att,6520}],goods_num = 680 };
get(2,208) ->
	#base_marry_heart{type = 2 ,lv = 208 ,attrs = [{def,6520}],goods_num = 680 };
get(3,208) ->
	#base_marry_heart{type = 3 ,lv = 208 ,attrs = [{hp_lim,65200}],goods_num = 680 };
get(4,208) ->
	#base_marry_heart{type = 4 ,lv = 208 ,attrs = [{crit,2134}],goods_num = 680 };
get(5,208) ->
	#base_marry_heart{type = 5 ,lv = 208 ,attrs = [{ten,2134}],goods_num = 680 };
get(6,208) ->
	#base_marry_heart{type = 6 ,lv = 208 ,attrs = [{hit,2134}],goods_num = 680 };
get(7,208) ->
	#base_marry_heart{type = 7 ,lv = 208 ,attrs = [{dodge,2134}],goods_num = 680 };
get(8,208) ->
	#base_marry_heart{type = 8 ,lv = 208 ,attrs = [{att,6520},{def,6520},{hp_lim,65200}],goods_num = 2360 };
get(1,209) ->
	#base_marry_heart{type = 1 ,lv = 209 ,attrs = [{att,6560}],goods_num = 693 };
get(2,209) ->
	#base_marry_heart{type = 2 ,lv = 209 ,attrs = [{def,6560}],goods_num = 693 };
get(3,209) ->
	#base_marry_heart{type = 3 ,lv = 209 ,attrs = [{hp_lim,65600}],goods_num = 693 };
get(4,209) ->
	#base_marry_heart{type = 4 ,lv = 209 ,attrs = [{crit,2147}],goods_num = 693 };
get(5,209) ->
	#base_marry_heart{type = 5 ,lv = 209 ,attrs = [{ten,2147}],goods_num = 693 };
get(6,209) ->
	#base_marry_heart{type = 6 ,lv = 209 ,attrs = [{hit,2147}],goods_num = 693 };
get(7,209) ->
	#base_marry_heart{type = 7 ,lv = 209 ,attrs = [{dodge,2147}],goods_num = 693 };
get(8,209) ->
	#base_marry_heart{type = 8 ,lv = 209 ,attrs = [{att,6560},{def,6560},{hp_lim,65600}],goods_num = 2407 };
get(1,210) ->
	#base_marry_heart{type = 1 ,lv = 210 ,attrs = [{att,6600}],goods_num = 706 };
get(2,210) ->
	#base_marry_heart{type = 2 ,lv = 210 ,attrs = [{def,6600}],goods_num = 706 };
get(3,210) ->
	#base_marry_heart{type = 3 ,lv = 210 ,attrs = [{hp_lim,66000}],goods_num = 706 };
get(4,210) ->
	#base_marry_heart{type = 4 ,lv = 210 ,attrs = [{crit,2160}],goods_num = 706 };
get(5,210) ->
	#base_marry_heart{type = 5 ,lv = 210 ,attrs = [{ten,2160}],goods_num = 706 };
get(6,210) ->
	#base_marry_heart{type = 6 ,lv = 210 ,attrs = [{hit,2160}],goods_num = 706 };
get(7,210) ->
	#base_marry_heart{type = 7 ,lv = 210 ,attrs = [{dodge,2160}],goods_num = 706 };
get(8,210) ->
	#base_marry_heart{type = 8 ,lv = 210 ,attrs = [{att,6600},{def,6600},{hp_lim,66000}],goods_num = 2455 };
get(1,211) ->
	#base_marry_heart{type = 1 ,lv = 211 ,attrs = [{att,6640}],goods_num = 720 };
get(2,211) ->
	#base_marry_heart{type = 2 ,lv = 211 ,attrs = [{def,6640}],goods_num = 720 };
get(3,211) ->
	#base_marry_heart{type = 3 ,lv = 211 ,attrs = [{hp_lim,66400}],goods_num = 720 };
get(4,211) ->
	#base_marry_heart{type = 4 ,lv = 211 ,attrs = [{crit,2173}],goods_num = 720 };
get(5,211) ->
	#base_marry_heart{type = 5 ,lv = 211 ,attrs = [{ten,2173}],goods_num = 720 };
get(6,211) ->
	#base_marry_heart{type = 6 ,lv = 211 ,attrs = [{hit,2173}],goods_num = 720 };
get(7,211) ->
	#base_marry_heart{type = 7 ,lv = 211 ,attrs = [{dodge,2173}],goods_num = 720 };
get(8,211) ->
	#base_marry_heart{type = 8 ,lv = 211 ,attrs = [{att,6640},{def,6640},{hp_lim,66400}],goods_num = 2504 };
get(1,212) ->
	#base_marry_heart{type = 1 ,lv = 212 ,attrs = [{att,6680}],goods_num = 734 };
get(2,212) ->
	#base_marry_heart{type = 2 ,lv = 212 ,attrs = [{def,6680}],goods_num = 734 };
get(3,212) ->
	#base_marry_heart{type = 3 ,lv = 212 ,attrs = [{hp_lim,66800}],goods_num = 734 };
get(4,212) ->
	#base_marry_heart{type = 4 ,lv = 212 ,attrs = [{crit,2186}],goods_num = 734 };
get(5,212) ->
	#base_marry_heart{type = 5 ,lv = 212 ,attrs = [{ten,2186}],goods_num = 734 };
get(6,212) ->
	#base_marry_heart{type = 6 ,lv = 212 ,attrs = [{hit,2186}],goods_num = 734 };
get(7,212) ->
	#base_marry_heart{type = 7 ,lv = 212 ,attrs = [{dodge,2186}],goods_num = 734 };
get(8,212) ->
	#base_marry_heart{type = 8 ,lv = 212 ,attrs = [{att,6680},{def,6680},{hp_lim,66800}],goods_num = 2554 };
get(1,213) ->
	#base_marry_heart{type = 1 ,lv = 213 ,attrs = [{att,6720}],goods_num = 748 };
get(2,213) ->
	#base_marry_heart{type = 2 ,lv = 213 ,attrs = [{def,6720}],goods_num = 748 };
get(3,213) ->
	#base_marry_heart{type = 3 ,lv = 213 ,attrs = [{hp_lim,67200}],goods_num = 748 };
get(4,213) ->
	#base_marry_heart{type = 4 ,lv = 213 ,attrs = [{crit,2199}],goods_num = 748 };
get(5,213) ->
	#base_marry_heart{type = 5 ,lv = 213 ,attrs = [{ten,2199}],goods_num = 748 };
get(6,213) ->
	#base_marry_heart{type = 6 ,lv = 213 ,attrs = [{hit,2199}],goods_num = 748 };
get(7,213) ->
	#base_marry_heart{type = 7 ,lv = 213 ,attrs = [{dodge,2199}],goods_num = 748 };
get(8,213) ->
	#base_marry_heart{type = 8 ,lv = 213 ,attrs = [{att,6720},{def,6720},{hp_lim,67200}],goods_num = 2605 };
get(1,214) ->
	#base_marry_heart{type = 1 ,lv = 214 ,attrs = [{att,6760}],goods_num = 762 };
get(2,214) ->
	#base_marry_heart{type = 2 ,lv = 214 ,attrs = [{def,6760}],goods_num = 762 };
get(3,214) ->
	#base_marry_heart{type = 3 ,lv = 214 ,attrs = [{hp_lim,67600}],goods_num = 762 };
get(4,214) ->
	#base_marry_heart{type = 4 ,lv = 214 ,attrs = [{crit,2212}],goods_num = 762 };
get(5,214) ->
	#base_marry_heart{type = 5 ,lv = 214 ,attrs = [{ten,2212}],goods_num = 762 };
get(6,214) ->
	#base_marry_heart{type = 6 ,lv = 214 ,attrs = [{hit,2212}],goods_num = 762 };
get(7,214) ->
	#base_marry_heart{type = 7 ,lv = 214 ,attrs = [{dodge,2212}],goods_num = 762 };
get(8,214) ->
	#base_marry_heart{type = 8 ,lv = 214 ,attrs = [{att,6760},{def,6760},{hp_lim,67600}],goods_num = 2657 };
get(1,215) ->
	#base_marry_heart{type = 1 ,lv = 215 ,attrs = [{att,6800}],goods_num = 777 };
get(2,215) ->
	#base_marry_heart{type = 2 ,lv = 215 ,attrs = [{def,6800}],goods_num = 777 };
get(3,215) ->
	#base_marry_heart{type = 3 ,lv = 215 ,attrs = [{hp_lim,68000}],goods_num = 777 };
get(4,215) ->
	#base_marry_heart{type = 4 ,lv = 215 ,attrs = [{crit,2225}],goods_num = 777 };
get(5,215) ->
	#base_marry_heart{type = 5 ,lv = 215 ,attrs = [{ten,2225}],goods_num = 777 };
get(6,215) ->
	#base_marry_heart{type = 6 ,lv = 215 ,attrs = [{hit,2225}],goods_num = 777 };
get(7,215) ->
	#base_marry_heart{type = 7 ,lv = 215 ,attrs = [{dodge,2225}],goods_num = 777 };
get(8,215) ->
	#base_marry_heart{type = 8 ,lv = 215 ,attrs = [{att,6800},{def,6800},{hp_lim,68000}],goods_num = 2710 };
get(1,216) ->
	#base_marry_heart{type = 1 ,lv = 216 ,attrs = [{att,6840}],goods_num = 792 };
get(2,216) ->
	#base_marry_heart{type = 2 ,lv = 216 ,attrs = [{def,6840}],goods_num = 792 };
get(3,216) ->
	#base_marry_heart{type = 3 ,lv = 216 ,attrs = [{hp_lim,68400}],goods_num = 792 };
get(4,216) ->
	#base_marry_heart{type = 4 ,lv = 216 ,attrs = [{crit,2238}],goods_num = 792 };
get(5,216) ->
	#base_marry_heart{type = 5 ,lv = 216 ,attrs = [{ten,2238}],goods_num = 792 };
get(6,216) ->
	#base_marry_heart{type = 6 ,lv = 216 ,attrs = [{hit,2238}],goods_num = 792 };
get(7,216) ->
	#base_marry_heart{type = 7 ,lv = 216 ,attrs = [{dodge,2238}],goods_num = 792 };
get(8,216) ->
	#base_marry_heart{type = 8 ,lv = 216 ,attrs = [{att,6840},{def,6840},{hp_lim,68400}],goods_num = 2764 };
get(1,217) ->
	#base_marry_heart{type = 1 ,lv = 217 ,attrs = [{att,6880}],goods_num = 807 };
get(2,217) ->
	#base_marry_heart{type = 2 ,lv = 217 ,attrs = [{def,6880}],goods_num = 807 };
get(3,217) ->
	#base_marry_heart{type = 3 ,lv = 217 ,attrs = [{hp_lim,68800}],goods_num = 807 };
get(4,217) ->
	#base_marry_heart{type = 4 ,lv = 217 ,attrs = [{crit,2251}],goods_num = 807 };
get(5,217) ->
	#base_marry_heart{type = 5 ,lv = 217 ,attrs = [{ten,2251}],goods_num = 807 };
get(6,217) ->
	#base_marry_heart{type = 6 ,lv = 217 ,attrs = [{hit,2251}],goods_num = 807 };
get(7,217) ->
	#base_marry_heart{type = 7 ,lv = 217 ,attrs = [{dodge,2251}],goods_num = 807 };
get(8,217) ->
	#base_marry_heart{type = 8 ,lv = 217 ,attrs = [{att,6880},{def,6880},{hp_lim,68800}],goods_num = 2819 };
get(1,218) ->
	#base_marry_heart{type = 1 ,lv = 218 ,attrs = [{att,6920}],goods_num = 823 };
get(2,218) ->
	#base_marry_heart{type = 2 ,lv = 218 ,attrs = [{def,6920}],goods_num = 823 };
get(3,218) ->
	#base_marry_heart{type = 3 ,lv = 218 ,attrs = [{hp_lim,69200}],goods_num = 823 };
get(4,218) ->
	#base_marry_heart{type = 4 ,lv = 218 ,attrs = [{crit,2264}],goods_num = 823 };
get(5,218) ->
	#base_marry_heart{type = 5 ,lv = 218 ,attrs = [{ten,2264}],goods_num = 823 };
get(6,218) ->
	#base_marry_heart{type = 6 ,lv = 218 ,attrs = [{hit,2264}],goods_num = 823 };
get(7,218) ->
	#base_marry_heart{type = 7 ,lv = 218 ,attrs = [{dodge,2264}],goods_num = 823 };
get(8,218) ->
	#base_marry_heart{type = 8 ,lv = 218 ,attrs = [{att,6920},{def,6920},{hp_lim,69200}],goods_num = 2875 };
get(1,219) ->
	#base_marry_heart{type = 1 ,lv = 219 ,attrs = [{att,6960}],goods_num = 839 };
get(2,219) ->
	#base_marry_heart{type = 2 ,lv = 219 ,attrs = [{def,6960}],goods_num = 839 };
get(3,219) ->
	#base_marry_heart{type = 3 ,lv = 219 ,attrs = [{hp_lim,69600}],goods_num = 839 };
get(4,219) ->
	#base_marry_heart{type = 4 ,lv = 219 ,attrs = [{crit,2277}],goods_num = 839 };
get(5,219) ->
	#base_marry_heart{type = 5 ,lv = 219 ,attrs = [{ten,2277}],goods_num = 839 };
get(6,219) ->
	#base_marry_heart{type = 6 ,lv = 219 ,attrs = [{hit,2277}],goods_num = 839 };
get(7,219) ->
	#base_marry_heart{type = 7 ,lv = 219 ,attrs = [{dodge,2277}],goods_num = 839 };
get(8,219) ->
	#base_marry_heart{type = 8 ,lv = 219 ,attrs = [{att,6960},{def,6960},{hp_lim,69600}],goods_num = 2932 };
get(1,220) ->
	#base_marry_heart{type = 1 ,lv = 220 ,attrs = [{att,7000}],goods_num = 855 };
get(2,220) ->
	#base_marry_heart{type = 2 ,lv = 220 ,attrs = [{def,7000}],goods_num = 855 };
get(3,220) ->
	#base_marry_heart{type = 3 ,lv = 220 ,attrs = [{hp_lim,70000}],goods_num = 855 };
get(4,220) ->
	#base_marry_heart{type = 4 ,lv = 220 ,attrs = [{crit,2290}],goods_num = 855 };
get(5,220) ->
	#base_marry_heart{type = 5 ,lv = 220 ,attrs = [{ten,2290}],goods_num = 855 };
get(6,220) ->
	#base_marry_heart{type = 6 ,lv = 220 ,attrs = [{hit,2290}],goods_num = 855 };
get(7,220) ->
	#base_marry_heart{type = 7 ,lv = 220 ,attrs = [{dodge,2290}],goods_num = 855 };
get(8,220) ->
	#base_marry_heart{type = 8 ,lv = 220 ,attrs = [{att,7000},{def,7000},{hp_lim,70000}],goods_num = 2990 };
get(1,221) ->
	#base_marry_heart{type = 1 ,lv = 221 ,attrs = [{att,7040}],goods_num = 872 };
get(2,221) ->
	#base_marry_heart{type = 2 ,lv = 221 ,attrs = [{def,7040}],goods_num = 872 };
get(3,221) ->
	#base_marry_heart{type = 3 ,lv = 221 ,attrs = [{hp_lim,70400}],goods_num = 872 };
get(4,221) ->
	#base_marry_heart{type = 4 ,lv = 221 ,attrs = [{crit,2303}],goods_num = 872 };
get(5,221) ->
	#base_marry_heart{type = 5 ,lv = 221 ,attrs = [{ten,2303}],goods_num = 872 };
get(6,221) ->
	#base_marry_heart{type = 6 ,lv = 221 ,attrs = [{hit,2303}],goods_num = 872 };
get(7,221) ->
	#base_marry_heart{type = 7 ,lv = 221 ,attrs = [{dodge,2303}],goods_num = 872 };
get(8,221) ->
	#base_marry_heart{type = 8 ,lv = 221 ,attrs = [{att,7040},{def,7040},{hp_lim,70400}],goods_num = 3049 };
get(1,222) ->
	#base_marry_heart{type = 1 ,lv = 222 ,attrs = [{att,7080}],goods_num = 889 };
get(2,222) ->
	#base_marry_heart{type = 2 ,lv = 222 ,attrs = [{def,7080}],goods_num = 889 };
get(3,222) ->
	#base_marry_heart{type = 3 ,lv = 222 ,attrs = [{hp_lim,70800}],goods_num = 889 };
get(4,222) ->
	#base_marry_heart{type = 4 ,lv = 222 ,attrs = [{crit,2316}],goods_num = 889 };
get(5,222) ->
	#base_marry_heart{type = 5 ,lv = 222 ,attrs = [{ten,2316}],goods_num = 889 };
get(6,222) ->
	#base_marry_heart{type = 6 ,lv = 222 ,attrs = [{hit,2316}],goods_num = 889 };
get(7,222) ->
	#base_marry_heart{type = 7 ,lv = 222 ,attrs = [{dodge,2316}],goods_num = 889 };
get(8,222) ->
	#base_marry_heart{type = 8 ,lv = 222 ,attrs = [{att,7080},{def,7080},{hp_lim,70800}],goods_num = 3109 };
get(1,223) ->
	#base_marry_heart{type = 1 ,lv = 223 ,attrs = [{att,7120}],goods_num = 906 };
get(2,223) ->
	#base_marry_heart{type = 2 ,lv = 223 ,attrs = [{def,7120}],goods_num = 906 };
get(3,223) ->
	#base_marry_heart{type = 3 ,lv = 223 ,attrs = [{hp_lim,71200}],goods_num = 906 };
get(4,223) ->
	#base_marry_heart{type = 4 ,lv = 223 ,attrs = [{crit,2329}],goods_num = 906 };
get(5,223) ->
	#base_marry_heart{type = 5 ,lv = 223 ,attrs = [{ten,2329}],goods_num = 906 };
get(6,223) ->
	#base_marry_heart{type = 6 ,lv = 223 ,attrs = [{hit,2329}],goods_num = 906 };
get(7,223) ->
	#base_marry_heart{type = 7 ,lv = 223 ,attrs = [{dodge,2329}],goods_num = 906 };
get(8,223) ->
	#base_marry_heart{type = 8 ,lv = 223 ,attrs = [{att,7120},{def,7120},{hp_lim,71200}],goods_num = 3171 };
get(1,224) ->
	#base_marry_heart{type = 1 ,lv = 224 ,attrs = [{att,7160}],goods_num = 924 };
get(2,224) ->
	#base_marry_heart{type = 2 ,lv = 224 ,attrs = [{def,7160}],goods_num = 924 };
get(3,224) ->
	#base_marry_heart{type = 3 ,lv = 224 ,attrs = [{hp_lim,71600}],goods_num = 924 };
get(4,224) ->
	#base_marry_heart{type = 4 ,lv = 224 ,attrs = [{crit,2342}],goods_num = 924 };
get(5,224) ->
	#base_marry_heart{type = 5 ,lv = 224 ,attrs = [{ten,2342}],goods_num = 924 };
get(6,224) ->
	#base_marry_heart{type = 6 ,lv = 224 ,attrs = [{hit,2342}],goods_num = 924 };
get(7,224) ->
	#base_marry_heart{type = 7 ,lv = 224 ,attrs = [{dodge,2342}],goods_num = 924 };
get(8,224) ->
	#base_marry_heart{type = 8 ,lv = 224 ,attrs = [{att,7160},{def,7160},{hp_lim,71600}],goods_num = 3234 };
get(1,225) ->
	#base_marry_heart{type = 1 ,lv = 225 ,attrs = [{att,7200}],goods_num = 942 };
get(2,225) ->
	#base_marry_heart{type = 2 ,lv = 225 ,attrs = [{def,7200}],goods_num = 942 };
get(3,225) ->
	#base_marry_heart{type = 3 ,lv = 225 ,attrs = [{hp_lim,72000}],goods_num = 942 };
get(4,225) ->
	#base_marry_heart{type = 4 ,lv = 225 ,attrs = [{crit,2355}],goods_num = 942 };
get(5,225) ->
	#base_marry_heart{type = 5 ,lv = 225 ,attrs = [{ten,2355}],goods_num = 942 };
get(6,225) ->
	#base_marry_heart{type = 6 ,lv = 225 ,attrs = [{hit,2355}],goods_num = 942 };
get(7,225) ->
	#base_marry_heart{type = 7 ,lv = 225 ,attrs = [{dodge,2355}],goods_num = 942 };
get(8,225) ->
	#base_marry_heart{type = 8 ,lv = 225 ,attrs = [{att,7200},{def,7200},{hp_lim,72000}],goods_num = 3298 };
get(1,226) ->
	#base_marry_heart{type = 1 ,lv = 226 ,attrs = [{att,7240}],goods_num = 960 };
get(2,226) ->
	#base_marry_heart{type = 2 ,lv = 226 ,attrs = [{def,7240}],goods_num = 960 };
get(3,226) ->
	#base_marry_heart{type = 3 ,lv = 226 ,attrs = [{hp_lim,72400}],goods_num = 960 };
get(4,226) ->
	#base_marry_heart{type = 4 ,lv = 226 ,attrs = [{crit,2368}],goods_num = 960 };
get(5,226) ->
	#base_marry_heart{type = 5 ,lv = 226 ,attrs = [{ten,2368}],goods_num = 960 };
get(6,226) ->
	#base_marry_heart{type = 6 ,lv = 226 ,attrs = [{hit,2368}],goods_num = 960 };
get(7,226) ->
	#base_marry_heart{type = 7 ,lv = 226 ,attrs = [{dodge,2368}],goods_num = 960 };
get(8,226) ->
	#base_marry_heart{type = 8 ,lv = 226 ,attrs = [{att,7240},{def,7240},{hp_lim,72400}],goods_num = 3363 };
get(1,227) ->
	#base_marry_heart{type = 1 ,lv = 227 ,attrs = [{att,7280}],goods_num = 979 };
get(2,227) ->
	#base_marry_heart{type = 2 ,lv = 227 ,attrs = [{def,7280}],goods_num = 979 };
get(3,227) ->
	#base_marry_heart{type = 3 ,lv = 227 ,attrs = [{hp_lim,72800}],goods_num = 979 };
get(4,227) ->
	#base_marry_heart{type = 4 ,lv = 227 ,attrs = [{crit,2381}],goods_num = 979 };
get(5,227) ->
	#base_marry_heart{type = 5 ,lv = 227 ,attrs = [{ten,2381}],goods_num = 979 };
get(6,227) ->
	#base_marry_heart{type = 6 ,lv = 227 ,attrs = [{hit,2381}],goods_num = 979 };
get(7,227) ->
	#base_marry_heart{type = 7 ,lv = 227 ,attrs = [{dodge,2381}],goods_num = 979 };
get(8,227) ->
	#base_marry_heart{type = 8 ,lv = 227 ,attrs = [{att,7280},{def,7280},{hp_lim,72800}],goods_num = 3430 };
get(1,228) ->
	#base_marry_heart{type = 1 ,lv = 228 ,attrs = [{att,7320}],goods_num = 998 };
get(2,228) ->
	#base_marry_heart{type = 2 ,lv = 228 ,attrs = [{def,7320}],goods_num = 998 };
get(3,228) ->
	#base_marry_heart{type = 3 ,lv = 228 ,attrs = [{hp_lim,73200}],goods_num = 998 };
get(4,228) ->
	#base_marry_heart{type = 4 ,lv = 228 ,attrs = [{crit,2394}],goods_num = 998 };
get(5,228) ->
	#base_marry_heart{type = 5 ,lv = 228 ,attrs = [{ten,2394}],goods_num = 998 };
get(6,228) ->
	#base_marry_heart{type = 6 ,lv = 228 ,attrs = [{hit,2394}],goods_num = 998 };
get(7,228) ->
	#base_marry_heart{type = 7 ,lv = 228 ,attrs = [{dodge,2394}],goods_num = 998 };
get(8,228) ->
	#base_marry_heart{type = 8 ,lv = 228 ,attrs = [{att,7320},{def,7320},{hp_lim,73200}],goods_num = 3498 };
get(1,229) ->
	#base_marry_heart{type = 1 ,lv = 229 ,attrs = [{att,7360}],goods_num = 1017 };
get(2,229) ->
	#base_marry_heart{type = 2 ,lv = 229 ,attrs = [{def,7360}],goods_num = 1017 };
get(3,229) ->
	#base_marry_heart{type = 3 ,lv = 229 ,attrs = [{hp_lim,73600}],goods_num = 1017 };
get(4,229) ->
	#base_marry_heart{type = 4 ,lv = 229 ,attrs = [{crit,2407}],goods_num = 1017 };
get(5,229) ->
	#base_marry_heart{type = 5 ,lv = 229 ,attrs = [{ten,2407}],goods_num = 1017 };
get(6,229) ->
	#base_marry_heart{type = 6 ,lv = 229 ,attrs = [{hit,2407}],goods_num = 1017 };
get(7,229) ->
	#base_marry_heart{type = 7 ,lv = 229 ,attrs = [{dodge,2407}],goods_num = 1017 };
get(8,229) ->
	#base_marry_heart{type = 8 ,lv = 229 ,attrs = [{att,7360},{def,7360},{hp_lim,73600}],goods_num = 3567 };
get(1,230) ->
	#base_marry_heart{type = 1 ,lv = 230 ,attrs = [{att,7400}],goods_num = 1037 };
get(2,230) ->
	#base_marry_heart{type = 2 ,lv = 230 ,attrs = [{def,7400}],goods_num = 1037 };
get(3,230) ->
	#base_marry_heart{type = 3 ,lv = 230 ,attrs = [{hp_lim,74000}],goods_num = 1037 };
get(4,230) ->
	#base_marry_heart{type = 4 ,lv = 230 ,attrs = [{crit,2420}],goods_num = 1037 };
get(5,230) ->
	#base_marry_heart{type = 5 ,lv = 230 ,attrs = [{ten,2420}],goods_num = 1037 };
get(6,230) ->
	#base_marry_heart{type = 6 ,lv = 230 ,attrs = [{hit,2420}],goods_num = 1037 };
get(7,230) ->
	#base_marry_heart{type = 7 ,lv = 230 ,attrs = [{dodge,2420}],goods_num = 1037 };
get(8,230) ->
	#base_marry_heart{type = 8 ,lv = 230 ,attrs = [{att,7400},{def,7400},{hp_lim,74000}],goods_num = 3638 };
get(1,231) ->
	#base_marry_heart{type = 1 ,lv = 231 ,attrs = [{att,7440}],goods_num = 1057 };
get(2,231) ->
	#base_marry_heart{type = 2 ,lv = 231 ,attrs = [{def,7440}],goods_num = 1057 };
get(3,231) ->
	#base_marry_heart{type = 3 ,lv = 231 ,attrs = [{hp_lim,74400}],goods_num = 1057 };
get(4,231) ->
	#base_marry_heart{type = 4 ,lv = 231 ,attrs = [{crit,2433}],goods_num = 1057 };
get(5,231) ->
	#base_marry_heart{type = 5 ,lv = 231 ,attrs = [{ten,2433}],goods_num = 1057 };
get(6,231) ->
	#base_marry_heart{type = 6 ,lv = 231 ,attrs = [{hit,2433}],goods_num = 1057 };
get(7,231) ->
	#base_marry_heart{type = 7 ,lv = 231 ,attrs = [{dodge,2433}],goods_num = 1057 };
get(8,231) ->
	#base_marry_heart{type = 8 ,lv = 231 ,attrs = [{att,7440},{def,7440},{hp_lim,74400}],goods_num = 3710 };
get(1,232) ->
	#base_marry_heart{type = 1 ,lv = 232 ,attrs = [{att,7480}],goods_num = 1078 };
get(2,232) ->
	#base_marry_heart{type = 2 ,lv = 232 ,attrs = [{def,7480}],goods_num = 1078 };
get(3,232) ->
	#base_marry_heart{type = 3 ,lv = 232 ,attrs = [{hp_lim,74800}],goods_num = 1078 };
get(4,232) ->
	#base_marry_heart{type = 4 ,lv = 232 ,attrs = [{crit,2446}],goods_num = 1078 };
get(5,232) ->
	#base_marry_heart{type = 5 ,lv = 232 ,attrs = [{ten,2446}],goods_num = 1078 };
get(6,232) ->
	#base_marry_heart{type = 6 ,lv = 232 ,attrs = [{hit,2446}],goods_num = 1078 };
get(7,232) ->
	#base_marry_heart{type = 7 ,lv = 232 ,attrs = [{dodge,2446}],goods_num = 1078 };
get(8,232) ->
	#base_marry_heart{type = 8 ,lv = 232 ,attrs = [{att,7480},{def,7480},{hp_lim,74800}],goods_num = 3784 };
get(1,233) ->
	#base_marry_heart{type = 1 ,lv = 233 ,attrs = [{att,7520}],goods_num = 1099 };
get(2,233) ->
	#base_marry_heart{type = 2 ,lv = 233 ,attrs = [{def,7520}],goods_num = 1099 };
get(3,233) ->
	#base_marry_heart{type = 3 ,lv = 233 ,attrs = [{hp_lim,75200}],goods_num = 1099 };
get(4,233) ->
	#base_marry_heart{type = 4 ,lv = 233 ,attrs = [{crit,2459}],goods_num = 1099 };
get(5,233) ->
	#base_marry_heart{type = 5 ,lv = 233 ,attrs = [{ten,2459}],goods_num = 1099 };
get(6,233) ->
	#base_marry_heart{type = 6 ,lv = 233 ,attrs = [{hit,2459}],goods_num = 1099 };
get(7,233) ->
	#base_marry_heart{type = 7 ,lv = 233 ,attrs = [{dodge,2459}],goods_num = 1099 };
get(8,233) ->
	#base_marry_heart{type = 8 ,lv = 233 ,attrs = [{att,7520},{def,7520},{hp_lim,75200}],goods_num = 3859 };
get(1,234) ->
	#base_marry_heart{type = 1 ,lv = 234 ,attrs = [{att,7560}],goods_num = 1120 };
get(2,234) ->
	#base_marry_heart{type = 2 ,lv = 234 ,attrs = [{def,7560}],goods_num = 1120 };
get(3,234) ->
	#base_marry_heart{type = 3 ,lv = 234 ,attrs = [{hp_lim,75600}],goods_num = 1120 };
get(4,234) ->
	#base_marry_heart{type = 4 ,lv = 234 ,attrs = [{crit,2472}],goods_num = 1120 };
get(5,234) ->
	#base_marry_heart{type = 5 ,lv = 234 ,attrs = [{ten,2472}],goods_num = 1120 };
get(6,234) ->
	#base_marry_heart{type = 6 ,lv = 234 ,attrs = [{hit,2472}],goods_num = 1120 };
get(7,234) ->
	#base_marry_heart{type = 7 ,lv = 234 ,attrs = [{dodge,2472}],goods_num = 1120 };
get(8,234) ->
	#base_marry_heart{type = 8 ,lv = 234 ,attrs = [{att,7560},{def,7560},{hp_lim,75600}],goods_num = 3936 };
get(1,235) ->
	#base_marry_heart{type = 1 ,lv = 235 ,attrs = [{att,7600}],goods_num = 1142 };
get(2,235) ->
	#base_marry_heart{type = 2 ,lv = 235 ,attrs = [{def,7600}],goods_num = 1142 };
get(3,235) ->
	#base_marry_heart{type = 3 ,lv = 235 ,attrs = [{hp_lim,76000}],goods_num = 1142 };
get(4,235) ->
	#base_marry_heart{type = 4 ,lv = 235 ,attrs = [{crit,2485}],goods_num = 1142 };
get(5,235) ->
	#base_marry_heart{type = 5 ,lv = 235 ,attrs = [{ten,2485}],goods_num = 1142 };
get(6,235) ->
	#base_marry_heart{type = 6 ,lv = 235 ,attrs = [{hit,2485}],goods_num = 1142 };
get(7,235) ->
	#base_marry_heart{type = 7 ,lv = 235 ,attrs = [{dodge,2485}],goods_num = 1142 };
get(8,235) ->
	#base_marry_heart{type = 8 ,lv = 235 ,attrs = [{att,7600},{def,7600},{hp_lim,76000}],goods_num = 4014 };
get(1,236) ->
	#base_marry_heart{type = 1 ,lv = 236 ,attrs = [{att,7640}],goods_num = 1164 };
get(2,236) ->
	#base_marry_heart{type = 2 ,lv = 236 ,attrs = [{def,7640}],goods_num = 1164 };
get(3,236) ->
	#base_marry_heart{type = 3 ,lv = 236 ,attrs = [{hp_lim,76400}],goods_num = 1164 };
get(4,236) ->
	#base_marry_heart{type = 4 ,lv = 236 ,attrs = [{crit,2498}],goods_num = 1164 };
get(5,236) ->
	#base_marry_heart{type = 5 ,lv = 236 ,attrs = [{ten,2498}],goods_num = 1164 };
get(6,236) ->
	#base_marry_heart{type = 6 ,lv = 236 ,attrs = [{hit,2498}],goods_num = 1164 };
get(7,236) ->
	#base_marry_heart{type = 7 ,lv = 236 ,attrs = [{dodge,2498}],goods_num = 1164 };
get(8,236) ->
	#base_marry_heart{type = 8 ,lv = 236 ,attrs = [{att,7640},{def,7640},{hp_lim,76400}],goods_num = 4094 };
get(1,237) ->
	#base_marry_heart{type = 1 ,lv = 237 ,attrs = [{att,7680}],goods_num = 1187 };
get(2,237) ->
	#base_marry_heart{type = 2 ,lv = 237 ,attrs = [{def,7680}],goods_num = 1187 };
get(3,237) ->
	#base_marry_heart{type = 3 ,lv = 237 ,attrs = [{hp_lim,76800}],goods_num = 1187 };
get(4,237) ->
	#base_marry_heart{type = 4 ,lv = 237 ,attrs = [{crit,2511}],goods_num = 1187 };
get(5,237) ->
	#base_marry_heart{type = 5 ,lv = 237 ,attrs = [{ten,2511}],goods_num = 1187 };
get(6,237) ->
	#base_marry_heart{type = 6 ,lv = 237 ,attrs = [{hit,2511}],goods_num = 1187 };
get(7,237) ->
	#base_marry_heart{type = 7 ,lv = 237 ,attrs = [{dodge,2511}],goods_num = 1187 };
get(8,237) ->
	#base_marry_heart{type = 8 ,lv = 237 ,attrs = [{att,7680},{def,7680},{hp_lim,76800}],goods_num = 4175 };
get(1,238) ->
	#base_marry_heart{type = 1 ,lv = 238 ,attrs = [{att,7720}],goods_num = 1210 };
get(2,238) ->
	#base_marry_heart{type = 2 ,lv = 238 ,attrs = [{def,7720}],goods_num = 1210 };
get(3,238) ->
	#base_marry_heart{type = 3 ,lv = 238 ,attrs = [{hp_lim,77200}],goods_num = 1210 };
get(4,238) ->
	#base_marry_heart{type = 4 ,lv = 238 ,attrs = [{crit,2524}],goods_num = 1210 };
get(5,238) ->
	#base_marry_heart{type = 5 ,lv = 238 ,attrs = [{ten,2524}],goods_num = 1210 };
get(6,238) ->
	#base_marry_heart{type = 6 ,lv = 238 ,attrs = [{hit,2524}],goods_num = 1210 };
get(7,238) ->
	#base_marry_heart{type = 7 ,lv = 238 ,attrs = [{dodge,2524}],goods_num = 1210 };
get(8,238) ->
	#base_marry_heart{type = 8 ,lv = 238 ,attrs = [{att,7720},{def,7720},{hp_lim,77200}],goods_num = 4258 };
get(1,239) ->
	#base_marry_heart{type = 1 ,lv = 239 ,attrs = [{att,7760}],goods_num = 1234 };
get(2,239) ->
	#base_marry_heart{type = 2 ,lv = 239 ,attrs = [{def,7760}],goods_num = 1234 };
get(3,239) ->
	#base_marry_heart{type = 3 ,lv = 239 ,attrs = [{hp_lim,77600}],goods_num = 1234 };
get(4,239) ->
	#base_marry_heart{type = 4 ,lv = 239 ,attrs = [{crit,2537}],goods_num = 1234 };
get(5,239) ->
	#base_marry_heart{type = 5 ,lv = 239 ,attrs = [{ten,2537}],goods_num = 1234 };
get(6,239) ->
	#base_marry_heart{type = 6 ,lv = 239 ,attrs = [{hit,2537}],goods_num = 1234 };
get(7,239) ->
	#base_marry_heart{type = 7 ,lv = 239 ,attrs = [{dodge,2537}],goods_num = 1234 };
get(8,239) ->
	#base_marry_heart{type = 8 ,lv = 239 ,attrs = [{att,7760},{def,7760},{hp_lim,77600}],goods_num = 4343 };
get(1,240) ->
	#base_marry_heart{type = 1 ,lv = 240 ,attrs = [{att,7800}],goods_num = 1258 };
get(2,240) ->
	#base_marry_heart{type = 2 ,lv = 240 ,attrs = [{def,7800}],goods_num = 1258 };
get(3,240) ->
	#base_marry_heart{type = 3 ,lv = 240 ,attrs = [{hp_lim,78000}],goods_num = 1258 };
get(4,240) ->
	#base_marry_heart{type = 4 ,lv = 240 ,attrs = [{crit,2550}],goods_num = 1258 };
get(5,240) ->
	#base_marry_heart{type = 5 ,lv = 240 ,attrs = [{ten,2550}],goods_num = 1258 };
get(6,240) ->
	#base_marry_heart{type = 6 ,lv = 240 ,attrs = [{hit,2550}],goods_num = 1258 };
get(7,240) ->
	#base_marry_heart{type = 7 ,lv = 240 ,attrs = [{dodge,2550}],goods_num = 1258 };
get(8,240) ->
	#base_marry_heart{type = 8 ,lv = 240 ,attrs = [{att,7800},{def,7800},{hp_lim,78000}],goods_num = 4429 };
get(1,241) ->
	#base_marry_heart{type = 1 ,lv = 241 ,attrs = [{att,7840}],goods_num = 1283 };
get(2,241) ->
	#base_marry_heart{type = 2 ,lv = 241 ,attrs = [{def,7840}],goods_num = 1283 };
get(3,241) ->
	#base_marry_heart{type = 3 ,lv = 241 ,attrs = [{hp_lim,78400}],goods_num = 1283 };
get(4,241) ->
	#base_marry_heart{type = 4 ,lv = 241 ,attrs = [{crit,2563}],goods_num = 1283 };
get(5,241) ->
	#base_marry_heart{type = 5 ,lv = 241 ,attrs = [{ten,2563}],goods_num = 1283 };
get(6,241) ->
	#base_marry_heart{type = 6 ,lv = 241 ,attrs = [{hit,2563}],goods_num = 1283 };
get(7,241) ->
	#base_marry_heart{type = 7 ,lv = 241 ,attrs = [{dodge,2563}],goods_num = 1283 };
get(8,241) ->
	#base_marry_heart{type = 8 ,lv = 241 ,attrs = [{att,7840},{def,7840},{hp_lim,78400}],goods_num = 4517 };
get(1,242) ->
	#base_marry_heart{type = 1 ,lv = 242 ,attrs = [{att,7880}],goods_num = 1308 };
get(2,242) ->
	#base_marry_heart{type = 2 ,lv = 242 ,attrs = [{def,7880}],goods_num = 1308 };
get(3,242) ->
	#base_marry_heart{type = 3 ,lv = 242 ,attrs = [{hp_lim,78800}],goods_num = 1308 };
get(4,242) ->
	#base_marry_heart{type = 4 ,lv = 242 ,attrs = [{crit,2576}],goods_num = 1308 };
get(5,242) ->
	#base_marry_heart{type = 5 ,lv = 242 ,attrs = [{ten,2576}],goods_num = 1308 };
get(6,242) ->
	#base_marry_heart{type = 6 ,lv = 242 ,attrs = [{hit,2576}],goods_num = 1308 };
get(7,242) ->
	#base_marry_heart{type = 7 ,lv = 242 ,attrs = [{dodge,2576}],goods_num = 1308 };
get(8,242) ->
	#base_marry_heart{type = 8 ,lv = 242 ,attrs = [{att,7880},{def,7880},{hp_lim,78800}],goods_num = 4607 };
get(1,243) ->
	#base_marry_heart{type = 1 ,lv = 243 ,attrs = [{att,7920}],goods_num = 1334 };
get(2,243) ->
	#base_marry_heart{type = 2 ,lv = 243 ,attrs = [{def,7920}],goods_num = 1334 };
get(3,243) ->
	#base_marry_heart{type = 3 ,lv = 243 ,attrs = [{hp_lim,79200}],goods_num = 1334 };
get(4,243) ->
	#base_marry_heart{type = 4 ,lv = 243 ,attrs = [{crit,2589}],goods_num = 1334 };
get(5,243) ->
	#base_marry_heart{type = 5 ,lv = 243 ,attrs = [{ten,2589}],goods_num = 1334 };
get(6,243) ->
	#base_marry_heart{type = 6 ,lv = 243 ,attrs = [{hit,2589}],goods_num = 1334 };
get(7,243) ->
	#base_marry_heart{type = 7 ,lv = 243 ,attrs = [{dodge,2589}],goods_num = 1334 };
get(8,243) ->
	#base_marry_heart{type = 8 ,lv = 243 ,attrs = [{att,7920},{def,7920},{hp_lim,79200}],goods_num = 4699 };
get(1,244) ->
	#base_marry_heart{type = 1 ,lv = 244 ,attrs = [{att,7960}],goods_num = 1360 };
get(2,244) ->
	#base_marry_heart{type = 2 ,lv = 244 ,attrs = [{def,7960}],goods_num = 1360 };
get(3,244) ->
	#base_marry_heart{type = 3 ,lv = 244 ,attrs = [{hp_lim,79600}],goods_num = 1360 };
get(4,244) ->
	#base_marry_heart{type = 4 ,lv = 244 ,attrs = [{crit,2602}],goods_num = 1360 };
get(5,244) ->
	#base_marry_heart{type = 5 ,lv = 244 ,attrs = [{ten,2602}],goods_num = 1360 };
get(6,244) ->
	#base_marry_heart{type = 6 ,lv = 244 ,attrs = [{hit,2602}],goods_num = 1360 };
get(7,244) ->
	#base_marry_heart{type = 7 ,lv = 244 ,attrs = [{dodge,2602}],goods_num = 1360 };
get(8,244) ->
	#base_marry_heart{type = 8 ,lv = 244 ,attrs = [{att,7960},{def,7960},{hp_lim,79600}],goods_num = 4792 };
get(1,245) ->
	#base_marry_heart{type = 1 ,lv = 245 ,attrs = [{att,8000}],goods_num = 1387 };
get(2,245) ->
	#base_marry_heart{type = 2 ,lv = 245 ,attrs = [{def,8000}],goods_num = 1387 };
get(3,245) ->
	#base_marry_heart{type = 3 ,lv = 245 ,attrs = [{hp_lim,80000}],goods_num = 1387 };
get(4,245) ->
	#base_marry_heart{type = 4 ,lv = 245 ,attrs = [{crit,2615}],goods_num = 1387 };
get(5,245) ->
	#base_marry_heart{type = 5 ,lv = 245 ,attrs = [{ten,2615}],goods_num = 1387 };
get(6,245) ->
	#base_marry_heart{type = 6 ,lv = 245 ,attrs = [{hit,2615}],goods_num = 1387 };
get(7,245) ->
	#base_marry_heart{type = 7 ,lv = 245 ,attrs = [{dodge,2615}],goods_num = 1387 };
get(8,245) ->
	#base_marry_heart{type = 8 ,lv = 245 ,attrs = [{att,8000},{def,8000},{hp_lim,80000}],goods_num = 4887 };
get(1,246) ->
	#base_marry_heart{type = 1 ,lv = 246 ,attrs = [{att,8040}],goods_num = 1414 };
get(2,246) ->
	#base_marry_heart{type = 2 ,lv = 246 ,attrs = [{def,8040}],goods_num = 1414 };
get(3,246) ->
	#base_marry_heart{type = 3 ,lv = 246 ,attrs = [{hp_lim,80400}],goods_num = 1414 };
get(4,246) ->
	#base_marry_heart{type = 4 ,lv = 246 ,attrs = [{crit,2628}],goods_num = 1414 };
get(5,246) ->
	#base_marry_heart{type = 5 ,lv = 246 ,attrs = [{ten,2628}],goods_num = 1414 };
get(6,246) ->
	#base_marry_heart{type = 6 ,lv = 246 ,attrs = [{hit,2628}],goods_num = 1414 };
get(7,246) ->
	#base_marry_heart{type = 7 ,lv = 246 ,attrs = [{dodge,2628}],goods_num = 1414 };
get(8,246) ->
	#base_marry_heart{type = 8 ,lv = 246 ,attrs = [{att,8040},{def,8040},{hp_lim,80400}],goods_num = 4984 };
get(1,247) ->
	#base_marry_heart{type = 1 ,lv = 247 ,attrs = [{att,8080}],goods_num = 1442 };
get(2,247) ->
	#base_marry_heart{type = 2 ,lv = 247 ,attrs = [{def,8080}],goods_num = 1442 };
get(3,247) ->
	#base_marry_heart{type = 3 ,lv = 247 ,attrs = [{hp_lim,80800}],goods_num = 1442 };
get(4,247) ->
	#base_marry_heart{type = 4 ,lv = 247 ,attrs = [{crit,2641}],goods_num = 1442 };
get(5,247) ->
	#base_marry_heart{type = 5 ,lv = 247 ,attrs = [{ten,2641}],goods_num = 1442 };
get(6,247) ->
	#base_marry_heart{type = 6 ,lv = 247 ,attrs = [{hit,2641}],goods_num = 1442 };
get(7,247) ->
	#base_marry_heart{type = 7 ,lv = 247 ,attrs = [{dodge,2641}],goods_num = 1442 };
get(8,247) ->
	#base_marry_heart{type = 8 ,lv = 247 ,attrs = [{att,8080},{def,8080},{hp_lim,80800}],goods_num = 5083 };
get(1,248) ->
	#base_marry_heart{type = 1 ,lv = 248 ,attrs = [{att,8120}],goods_num = 1470 };
get(2,248) ->
	#base_marry_heart{type = 2 ,lv = 248 ,attrs = [{def,8120}],goods_num = 1470 };
get(3,248) ->
	#base_marry_heart{type = 3 ,lv = 248 ,attrs = [{hp_lim,81200}],goods_num = 1470 };
get(4,248) ->
	#base_marry_heart{type = 4 ,lv = 248 ,attrs = [{crit,2654}],goods_num = 1470 };
get(5,248) ->
	#base_marry_heart{type = 5 ,lv = 248 ,attrs = [{ten,2654}],goods_num = 1470 };
get(6,248) ->
	#base_marry_heart{type = 6 ,lv = 248 ,attrs = [{hit,2654}],goods_num = 1470 };
get(7,248) ->
	#base_marry_heart{type = 7 ,lv = 248 ,attrs = [{dodge,2654}],goods_num = 1470 };
get(8,248) ->
	#base_marry_heart{type = 8 ,lv = 248 ,attrs = [{att,8120},{def,8120},{hp_lim,81200}],goods_num = 5184 };
get(1,249) ->
	#base_marry_heart{type = 1 ,lv = 249 ,attrs = [{att,8160}],goods_num = 1499 };
get(2,249) ->
	#base_marry_heart{type = 2 ,lv = 249 ,attrs = [{def,8160}],goods_num = 1499 };
get(3,249) ->
	#base_marry_heart{type = 3 ,lv = 249 ,attrs = [{hp_lim,81600}],goods_num = 1499 };
get(4,249) ->
	#base_marry_heart{type = 4 ,lv = 249 ,attrs = [{crit,2667}],goods_num = 1499 };
get(5,249) ->
	#base_marry_heart{type = 5 ,lv = 249 ,attrs = [{ten,2667}],goods_num = 1499 };
get(6,249) ->
	#base_marry_heart{type = 6 ,lv = 249 ,attrs = [{hit,2667}],goods_num = 1499 };
get(7,249) ->
	#base_marry_heart{type = 7 ,lv = 249 ,attrs = [{dodge,2667}],goods_num = 1499 };
get(8,249) ->
	#base_marry_heart{type = 8 ,lv = 249 ,attrs = [{att,8160},{def,8160},{hp_lim,81600}],goods_num = 5287 };
get(1,250) ->
	#base_marry_heart{type = 1 ,lv = 250 ,attrs = [{att,8200}],goods_num = 1528 };
get(2,250) ->
	#base_marry_heart{type = 2 ,lv = 250 ,attrs = [{def,8200}],goods_num = 1528 };
get(3,250) ->
	#base_marry_heart{type = 3 ,lv = 250 ,attrs = [{hp_lim,82000}],goods_num = 1528 };
get(4,250) ->
	#base_marry_heart{type = 4 ,lv = 250 ,attrs = [{crit,2680}],goods_num = 1528 };
get(5,250) ->
	#base_marry_heart{type = 5 ,lv = 250 ,attrs = [{ten,2680}],goods_num = 1528 };
get(6,250) ->
	#base_marry_heart{type = 6 ,lv = 250 ,attrs = [{hit,2680}],goods_num = 1528 };
get(7,250) ->
	#base_marry_heart{type = 7 ,lv = 250 ,attrs = [{dodge,2680}],goods_num = 1528 };
get(8,250) ->
	#base_marry_heart{type = 8 ,lv = 250 ,attrs = [{att,8200},{def,8200},{hp_lim,82000}],goods_num = 5392 };
get(1,251) ->
	#base_marry_heart{type = 1 ,lv = 251 ,attrs = [{att,8240}],goods_num = 1558 };
get(2,251) ->
	#base_marry_heart{type = 2 ,lv = 251 ,attrs = [{def,8240}],goods_num = 1558 };
get(3,251) ->
	#base_marry_heart{type = 3 ,lv = 251 ,attrs = [{hp_lim,82400}],goods_num = 1558 };
get(4,251) ->
	#base_marry_heart{type = 4 ,lv = 251 ,attrs = [{crit,2693}],goods_num = 1558 };
get(5,251) ->
	#base_marry_heart{type = 5 ,lv = 251 ,attrs = [{ten,2693}],goods_num = 1558 };
get(6,251) ->
	#base_marry_heart{type = 6 ,lv = 251 ,attrs = [{hit,2693}],goods_num = 1558 };
get(7,251) ->
	#base_marry_heart{type = 7 ,lv = 251 ,attrs = [{dodge,2693}],goods_num = 1558 };
get(8,251) ->
	#base_marry_heart{type = 8 ,lv = 251 ,attrs = [{att,8240},{def,8240},{hp_lim,82400}],goods_num = 5499 };
get(1,252) ->
	#base_marry_heart{type = 1 ,lv = 252 ,attrs = [{att,8280}],goods_num = 1589 };
get(2,252) ->
	#base_marry_heart{type = 2 ,lv = 252 ,attrs = [{def,8280}],goods_num = 1589 };
get(3,252) ->
	#base_marry_heart{type = 3 ,lv = 252 ,attrs = [{hp_lim,82800}],goods_num = 1589 };
get(4,252) ->
	#base_marry_heart{type = 4 ,lv = 252 ,attrs = [{crit,2706}],goods_num = 1589 };
get(5,252) ->
	#base_marry_heart{type = 5 ,lv = 252 ,attrs = [{ten,2706}],goods_num = 1589 };
get(6,252) ->
	#base_marry_heart{type = 6 ,lv = 252 ,attrs = [{hit,2706}],goods_num = 1589 };
get(7,252) ->
	#base_marry_heart{type = 7 ,lv = 252 ,attrs = [{dodge,2706}],goods_num = 1589 };
get(8,252) ->
	#base_marry_heart{type = 8 ,lv = 252 ,attrs = [{att,8280},{def,8280},{hp_lim,82800}],goods_num = 5608 };
get(1,253) ->
	#base_marry_heart{type = 1 ,lv = 253 ,attrs = [{att,8320}],goods_num = 1620 };
get(2,253) ->
	#base_marry_heart{type = 2 ,lv = 253 ,attrs = [{def,8320}],goods_num = 1620 };
get(3,253) ->
	#base_marry_heart{type = 3 ,lv = 253 ,attrs = [{hp_lim,83200}],goods_num = 1620 };
get(4,253) ->
	#base_marry_heart{type = 4 ,lv = 253 ,attrs = [{crit,2719}],goods_num = 1620 };
get(5,253) ->
	#base_marry_heart{type = 5 ,lv = 253 ,attrs = [{ten,2719}],goods_num = 1620 };
get(6,253) ->
	#base_marry_heart{type = 6 ,lv = 253 ,attrs = [{hit,2719}],goods_num = 1620 };
get(7,253) ->
	#base_marry_heart{type = 7 ,lv = 253 ,attrs = [{dodge,2719}],goods_num = 1620 };
get(8,253) ->
	#base_marry_heart{type = 8 ,lv = 253 ,attrs = [{att,8320},{def,8320},{hp_lim,83200}],goods_num = 5720 };
get(1,254) ->
	#base_marry_heart{type = 1 ,lv = 254 ,attrs = [{att,8360}],goods_num = 1652 };
get(2,254) ->
	#base_marry_heart{type = 2 ,lv = 254 ,attrs = [{def,8360}],goods_num = 1652 };
get(3,254) ->
	#base_marry_heart{type = 3 ,lv = 254 ,attrs = [{hp_lim,83600}],goods_num = 1652 };
get(4,254) ->
	#base_marry_heart{type = 4 ,lv = 254 ,attrs = [{crit,2732}],goods_num = 1652 };
get(5,254) ->
	#base_marry_heart{type = 5 ,lv = 254 ,attrs = [{ten,2732}],goods_num = 1652 };
get(6,254) ->
	#base_marry_heart{type = 6 ,lv = 254 ,attrs = [{hit,2732}],goods_num = 1652 };
get(7,254) ->
	#base_marry_heart{type = 7 ,lv = 254 ,attrs = [{dodge,2732}],goods_num = 1652 };
get(8,254) ->
	#base_marry_heart{type = 8 ,lv = 254 ,attrs = [{att,8360},{def,8360},{hp_lim,83600}],goods_num = 5834 };
get(1,255) ->
	#base_marry_heart{type = 1 ,lv = 255 ,attrs = [{att,8400}],goods_num = 1685 };
get(2,255) ->
	#base_marry_heart{type = 2 ,lv = 255 ,attrs = [{def,8400}],goods_num = 1685 };
get(3,255) ->
	#base_marry_heart{type = 3 ,lv = 255 ,attrs = [{hp_lim,84000}],goods_num = 1685 };
get(4,255) ->
	#base_marry_heart{type = 4 ,lv = 255 ,attrs = [{crit,2745}],goods_num = 1685 };
get(5,255) ->
	#base_marry_heart{type = 5 ,lv = 255 ,attrs = [{ten,2745}],goods_num = 1685 };
get(6,255) ->
	#base_marry_heart{type = 6 ,lv = 255 ,attrs = [{hit,2745}],goods_num = 1685 };
get(7,255) ->
	#base_marry_heart{type = 7 ,lv = 255 ,attrs = [{dodge,2745}],goods_num = 1685 };
get(8,255) ->
	#base_marry_heart{type = 8 ,lv = 255 ,attrs = [{att,8400},{def,8400},{hp_lim,84000}],goods_num = 5950 };
get(1,256) ->
	#base_marry_heart{type = 1 ,lv = 256 ,attrs = [{att,8440}],goods_num = 1718 };
get(2,256) ->
	#base_marry_heart{type = 2 ,lv = 256 ,attrs = [{def,8440}],goods_num = 1718 };
get(3,256) ->
	#base_marry_heart{type = 3 ,lv = 256 ,attrs = [{hp_lim,84400}],goods_num = 1718 };
get(4,256) ->
	#base_marry_heart{type = 4 ,lv = 256 ,attrs = [{crit,2758}],goods_num = 1718 };
get(5,256) ->
	#base_marry_heart{type = 5 ,lv = 256 ,attrs = [{ten,2758}],goods_num = 1718 };
get(6,256) ->
	#base_marry_heart{type = 6 ,lv = 256 ,attrs = [{hit,2758}],goods_num = 1718 };
get(7,256) ->
	#base_marry_heart{type = 7 ,lv = 256 ,attrs = [{dodge,2758}],goods_num = 1718 };
get(8,256) ->
	#base_marry_heart{type = 8 ,lv = 256 ,attrs = [{att,8440},{def,8440},{hp_lim,84400}],goods_num = 6069 };
get(1,257) ->
	#base_marry_heart{type = 1 ,lv = 257 ,attrs = [{att,8480}],goods_num = 1752 };
get(2,257) ->
	#base_marry_heart{type = 2 ,lv = 257 ,attrs = [{def,8480}],goods_num = 1752 };
get(3,257) ->
	#base_marry_heart{type = 3 ,lv = 257 ,attrs = [{hp_lim,84800}],goods_num = 1752 };
get(4,257) ->
	#base_marry_heart{type = 4 ,lv = 257 ,attrs = [{crit,2771}],goods_num = 1752 };
get(5,257) ->
	#base_marry_heart{type = 5 ,lv = 257 ,attrs = [{ten,2771}],goods_num = 1752 };
get(6,257) ->
	#base_marry_heart{type = 6 ,lv = 257 ,attrs = [{hit,2771}],goods_num = 1752 };
get(7,257) ->
	#base_marry_heart{type = 7 ,lv = 257 ,attrs = [{dodge,2771}],goods_num = 1752 };
get(8,257) ->
	#base_marry_heart{type = 8 ,lv = 257 ,attrs = [{att,8480},{def,8480},{hp_lim,84800}],goods_num = 6190 };
get(1,258) ->
	#base_marry_heart{type = 1 ,lv = 258 ,attrs = [{att,8520}],goods_num = 1787 };
get(2,258) ->
	#base_marry_heart{type = 2 ,lv = 258 ,attrs = [{def,8520}],goods_num = 1787 };
get(3,258) ->
	#base_marry_heart{type = 3 ,lv = 258 ,attrs = [{hp_lim,85200}],goods_num = 1787 };
get(4,258) ->
	#base_marry_heart{type = 4 ,lv = 258 ,attrs = [{crit,2784}],goods_num = 1787 };
get(5,258) ->
	#base_marry_heart{type = 5 ,lv = 258 ,attrs = [{ten,2784}],goods_num = 1787 };
get(6,258) ->
	#base_marry_heart{type = 6 ,lv = 258 ,attrs = [{hit,2784}],goods_num = 1787 };
get(7,258) ->
	#base_marry_heart{type = 7 ,lv = 258 ,attrs = [{dodge,2784}],goods_num = 1787 };
get(8,258) ->
	#base_marry_heart{type = 8 ,lv = 258 ,attrs = [{att,8520},{def,8520},{hp_lim,85200}],goods_num = 6313 };
get(1,259) ->
	#base_marry_heart{type = 1 ,lv = 259 ,attrs = [{att,8560}],goods_num = 1822 };
get(2,259) ->
	#base_marry_heart{type = 2 ,lv = 259 ,attrs = [{def,8560}],goods_num = 1822 };
get(3,259) ->
	#base_marry_heart{type = 3 ,lv = 259 ,attrs = [{hp_lim,85600}],goods_num = 1822 };
get(4,259) ->
	#base_marry_heart{type = 4 ,lv = 259 ,attrs = [{crit,2797}],goods_num = 1822 };
get(5,259) ->
	#base_marry_heart{type = 5 ,lv = 259 ,attrs = [{ten,2797}],goods_num = 1822 };
get(6,259) ->
	#base_marry_heart{type = 6 ,lv = 259 ,attrs = [{hit,2797}],goods_num = 1822 };
get(7,259) ->
	#base_marry_heart{type = 7 ,lv = 259 ,attrs = [{dodge,2797}],goods_num = 1822 };
get(8,259) ->
	#base_marry_heart{type = 8 ,lv = 259 ,attrs = [{att,8560},{def,8560},{hp_lim,85600}],goods_num = 6439 };
get(1,260) ->
	#base_marry_heart{type = 1 ,lv = 260 ,attrs = [{att,8600}],goods_num = 1858 };
get(2,260) ->
	#base_marry_heart{type = 2 ,lv = 260 ,attrs = [{def,8600}],goods_num = 1858 };
get(3,260) ->
	#base_marry_heart{type = 3 ,lv = 260 ,attrs = [{hp_lim,86000}],goods_num = 1858 };
get(4,260) ->
	#base_marry_heart{type = 4 ,lv = 260 ,attrs = [{crit,2810}],goods_num = 1858 };
get(5,260) ->
	#base_marry_heart{type = 5 ,lv = 260 ,attrs = [{ten,2810}],goods_num = 1858 };
get(6,260) ->
	#base_marry_heart{type = 6 ,lv = 260 ,attrs = [{hit,2810}],goods_num = 1858 };
get(7,260) ->
	#base_marry_heart{type = 7 ,lv = 260 ,attrs = [{dodge,2810}],goods_num = 1858 };
get(8,260) ->
	#base_marry_heart{type = 8 ,lv = 260 ,attrs = [{att,8600},{def,8600},{hp_lim,86000}],goods_num = 6567 };
get(1,261) ->
	#base_marry_heart{type = 1 ,lv = 261 ,attrs = [{att,8640}],goods_num = 1895 };
get(2,261) ->
	#base_marry_heart{type = 2 ,lv = 261 ,attrs = [{def,8640}],goods_num = 1895 };
get(3,261) ->
	#base_marry_heart{type = 3 ,lv = 261 ,attrs = [{hp_lim,86400}],goods_num = 1895 };
get(4,261) ->
	#base_marry_heart{type = 4 ,lv = 261 ,attrs = [{crit,2823}],goods_num = 1895 };
get(5,261) ->
	#base_marry_heart{type = 5 ,lv = 261 ,attrs = [{ten,2823}],goods_num = 1895 };
get(6,261) ->
	#base_marry_heart{type = 6 ,lv = 261 ,attrs = [{hit,2823}],goods_num = 1895 };
get(7,261) ->
	#base_marry_heart{type = 7 ,lv = 261 ,attrs = [{dodge,2823}],goods_num = 1895 };
get(8,261) ->
	#base_marry_heart{type = 8 ,lv = 261 ,attrs = [{att,8640},{def,8640},{hp_lim,86400}],goods_num = 6698 };
get(1,262) ->
	#base_marry_heart{type = 1 ,lv = 262 ,attrs = [{att,8680}],goods_num = 1932 };
get(2,262) ->
	#base_marry_heart{type = 2 ,lv = 262 ,attrs = [{def,8680}],goods_num = 1932 };
get(3,262) ->
	#base_marry_heart{type = 3 ,lv = 262 ,attrs = [{hp_lim,86800}],goods_num = 1932 };
get(4,262) ->
	#base_marry_heart{type = 4 ,lv = 262 ,attrs = [{crit,2836}],goods_num = 1932 };
get(5,262) ->
	#base_marry_heart{type = 5 ,lv = 262 ,attrs = [{ten,2836}],goods_num = 1932 };
get(6,262) ->
	#base_marry_heart{type = 6 ,lv = 262 ,attrs = [{hit,2836}],goods_num = 1932 };
get(7,262) ->
	#base_marry_heart{type = 7 ,lv = 262 ,attrs = [{dodge,2836}],goods_num = 1932 };
get(8,262) ->
	#base_marry_heart{type = 8 ,lv = 262 ,attrs = [{att,8680},{def,8680},{hp_lim,86800}],goods_num = 6831 };
get(1,263) ->
	#base_marry_heart{type = 1 ,lv = 263 ,attrs = [{att,8720}],goods_num = 1970 };
get(2,263) ->
	#base_marry_heart{type = 2 ,lv = 263 ,attrs = [{def,8720}],goods_num = 1970 };
get(3,263) ->
	#base_marry_heart{type = 3 ,lv = 263 ,attrs = [{hp_lim,87200}],goods_num = 1970 };
get(4,263) ->
	#base_marry_heart{type = 4 ,lv = 263 ,attrs = [{crit,2849}],goods_num = 1970 };
get(5,263) ->
	#base_marry_heart{type = 5 ,lv = 263 ,attrs = [{ten,2849}],goods_num = 1970 };
get(6,263) ->
	#base_marry_heart{type = 6 ,lv = 263 ,attrs = [{hit,2849}],goods_num = 1970 };
get(7,263) ->
	#base_marry_heart{type = 7 ,lv = 263 ,attrs = [{dodge,2849}],goods_num = 1970 };
get(8,263) ->
	#base_marry_heart{type = 8 ,lv = 263 ,attrs = [{att,8720},{def,8720},{hp_lim,87200}],goods_num = 6967 };
get(1,264) ->
	#base_marry_heart{type = 1 ,lv = 264 ,attrs = [{att,8760}],goods_num = 2009 };
get(2,264) ->
	#base_marry_heart{type = 2 ,lv = 264 ,attrs = [{def,8760}],goods_num = 2009 };
get(3,264) ->
	#base_marry_heart{type = 3 ,lv = 264 ,attrs = [{hp_lim,87600}],goods_num = 2009 };
get(4,264) ->
	#base_marry_heart{type = 4 ,lv = 264 ,attrs = [{crit,2862}],goods_num = 2009 };
get(5,264) ->
	#base_marry_heart{type = 5 ,lv = 264 ,attrs = [{ten,2862}],goods_num = 2009 };
get(6,264) ->
	#base_marry_heart{type = 6 ,lv = 264 ,attrs = [{hit,2862}],goods_num = 2009 };
get(7,264) ->
	#base_marry_heart{type = 7 ,lv = 264 ,attrs = [{dodge,2862}],goods_num = 2009 };
get(8,264) ->
	#base_marry_heart{type = 8 ,lv = 264 ,attrs = [{att,8760},{def,8760},{hp_lim,87600}],goods_num = 7106 };
get(1,265) ->
	#base_marry_heart{type = 1 ,lv = 265 ,attrs = [{att,8800}],goods_num = 2049 };
get(2,265) ->
	#base_marry_heart{type = 2 ,lv = 265 ,attrs = [{def,8800}],goods_num = 2049 };
get(3,265) ->
	#base_marry_heart{type = 3 ,lv = 265 ,attrs = [{hp_lim,88000}],goods_num = 2049 };
get(4,265) ->
	#base_marry_heart{type = 4 ,lv = 265 ,attrs = [{crit,2875}],goods_num = 2049 };
get(5,265) ->
	#base_marry_heart{type = 5 ,lv = 265 ,attrs = [{ten,2875}],goods_num = 2049 };
get(6,265) ->
	#base_marry_heart{type = 6 ,lv = 265 ,attrs = [{hit,2875}],goods_num = 2049 };
get(7,265) ->
	#base_marry_heart{type = 7 ,lv = 265 ,attrs = [{dodge,2875}],goods_num = 2049 };
get(8,265) ->
	#base_marry_heart{type = 8 ,lv = 265 ,attrs = [{att,8800},{def,8800},{hp_lim,88000}],goods_num = 7248 };
get(1,266) ->
	#base_marry_heart{type = 1 ,lv = 266 ,attrs = [{att,8840}],goods_num = 2089 };
get(2,266) ->
	#base_marry_heart{type = 2 ,lv = 266 ,attrs = [{def,8840}],goods_num = 2089 };
get(3,266) ->
	#base_marry_heart{type = 3 ,lv = 266 ,attrs = [{hp_lim,88400}],goods_num = 2089 };
get(4,266) ->
	#base_marry_heart{type = 4 ,lv = 266 ,attrs = [{crit,2888}],goods_num = 2089 };
get(5,266) ->
	#base_marry_heart{type = 5 ,lv = 266 ,attrs = [{ten,2888}],goods_num = 2089 };
get(6,266) ->
	#base_marry_heart{type = 6 ,lv = 266 ,attrs = [{hit,2888}],goods_num = 2089 };
get(7,266) ->
	#base_marry_heart{type = 7 ,lv = 266 ,attrs = [{dodge,2888}],goods_num = 2089 };
get(8,266) ->
	#base_marry_heart{type = 8 ,lv = 266 ,attrs = [{att,8840},{def,8840},{hp_lim,88400}],goods_num = 7392 };
get(1,267) ->
	#base_marry_heart{type = 1 ,lv = 267 ,attrs = [{att,8880}],goods_num = 2130 };
get(2,267) ->
	#base_marry_heart{type = 2 ,lv = 267 ,attrs = [{def,8880}],goods_num = 2130 };
get(3,267) ->
	#base_marry_heart{type = 3 ,lv = 267 ,attrs = [{hp_lim,88800}],goods_num = 2130 };
get(4,267) ->
	#base_marry_heart{type = 4 ,lv = 267 ,attrs = [{crit,2901}],goods_num = 2130 };
get(5,267) ->
	#base_marry_heart{type = 5 ,lv = 267 ,attrs = [{ten,2901}],goods_num = 2130 };
get(6,267) ->
	#base_marry_heart{type = 6 ,lv = 267 ,attrs = [{hit,2901}],goods_num = 2130 };
get(7,267) ->
	#base_marry_heart{type = 7 ,lv = 267 ,attrs = [{dodge,2901}],goods_num = 2130 };
get(8,267) ->
	#base_marry_heart{type = 8 ,lv = 267 ,attrs = [{att,8880},{def,8880},{hp_lim,88800}],goods_num = 7539 };
get(1,268) ->
	#base_marry_heart{type = 1 ,lv = 268 ,attrs = [{att,8920}],goods_num = 2172 };
get(2,268) ->
	#base_marry_heart{type = 2 ,lv = 268 ,attrs = [{def,8920}],goods_num = 2172 };
get(3,268) ->
	#base_marry_heart{type = 3 ,lv = 268 ,attrs = [{hp_lim,89200}],goods_num = 2172 };
get(4,268) ->
	#base_marry_heart{type = 4 ,lv = 268 ,attrs = [{crit,2914}],goods_num = 2172 };
get(5,268) ->
	#base_marry_heart{type = 5 ,lv = 268 ,attrs = [{ten,2914}],goods_num = 2172 };
get(6,268) ->
	#base_marry_heart{type = 6 ,lv = 268 ,attrs = [{hit,2914}],goods_num = 2172 };
get(7,268) ->
	#base_marry_heart{type = 7 ,lv = 268 ,attrs = [{dodge,2914}],goods_num = 2172 };
get(8,268) ->
	#base_marry_heart{type = 8 ,lv = 268 ,attrs = [{att,8920},{def,8920},{hp_lim,89200}],goods_num = 7689 };
get(1,269) ->
	#base_marry_heart{type = 1 ,lv = 269 ,attrs = [{att,8960}],goods_num = 2215 };
get(2,269) ->
	#base_marry_heart{type = 2 ,lv = 269 ,attrs = [{def,8960}],goods_num = 2215 };
get(3,269) ->
	#base_marry_heart{type = 3 ,lv = 269 ,attrs = [{hp_lim,89600}],goods_num = 2215 };
get(4,269) ->
	#base_marry_heart{type = 4 ,lv = 269 ,attrs = [{crit,2927}],goods_num = 2215 };
get(5,269) ->
	#base_marry_heart{type = 5 ,lv = 269 ,attrs = [{ten,2927}],goods_num = 2215 };
get(6,269) ->
	#base_marry_heart{type = 6 ,lv = 269 ,attrs = [{hit,2927}],goods_num = 2215 };
get(7,269) ->
	#base_marry_heart{type = 7 ,lv = 269 ,attrs = [{dodge,2927}],goods_num = 2215 };
get(8,269) ->
	#base_marry_heart{type = 8 ,lv = 269 ,attrs = [{att,8960},{def,8960},{hp_lim,89600}],goods_num = 7842 };
get(1,270) ->
	#base_marry_heart{type = 1 ,lv = 270 ,attrs = [{att,9000}],goods_num = 2259 };
get(2,270) ->
	#base_marry_heart{type = 2 ,lv = 270 ,attrs = [{def,9000}],goods_num = 2259 };
get(3,270) ->
	#base_marry_heart{type = 3 ,lv = 270 ,attrs = [{hp_lim,90000}],goods_num = 2259 };
get(4,270) ->
	#base_marry_heart{type = 4 ,lv = 270 ,attrs = [{crit,2940}],goods_num = 2259 };
get(5,270) ->
	#base_marry_heart{type = 5 ,lv = 270 ,attrs = [{ten,2940}],goods_num = 2259 };
get(6,270) ->
	#base_marry_heart{type = 6 ,lv = 270 ,attrs = [{hit,2940}],goods_num = 2259 };
get(7,270) ->
	#base_marry_heart{type = 7 ,lv = 270 ,attrs = [{dodge,2940}],goods_num = 2259 };
get(8,270) ->
	#base_marry_heart{type = 8 ,lv = 270 ,attrs = [{att,9000},{def,9000},{hp_lim,90000}],goods_num = 7998 };
get(1,271) ->
	#base_marry_heart{type = 1 ,lv = 271 ,attrs = [{att,9040}],goods_num = 2304 };
get(2,271) ->
	#base_marry_heart{type = 2 ,lv = 271 ,attrs = [{def,9040}],goods_num = 2304 };
get(3,271) ->
	#base_marry_heart{type = 3 ,lv = 271 ,attrs = [{hp_lim,90400}],goods_num = 2304 };
get(4,271) ->
	#base_marry_heart{type = 4 ,lv = 271 ,attrs = [{crit,2953}],goods_num = 2304 };
get(5,271) ->
	#base_marry_heart{type = 5 ,lv = 271 ,attrs = [{ten,2953}],goods_num = 2304 };
get(6,271) ->
	#base_marry_heart{type = 6 ,lv = 271 ,attrs = [{hit,2953}],goods_num = 2304 };
get(7,271) ->
	#base_marry_heart{type = 7 ,lv = 271 ,attrs = [{dodge,2953}],goods_num = 2304 };
get(8,271) ->
	#base_marry_heart{type = 8 ,lv = 271 ,attrs = [{att,9040},{def,9040},{hp_lim,90400}],goods_num = 8157 };
get(1,272) ->
	#base_marry_heart{type = 1 ,lv = 272 ,attrs = [{att,9080}],goods_num = 2350 };
get(2,272) ->
	#base_marry_heart{type = 2 ,lv = 272 ,attrs = [{def,9080}],goods_num = 2350 };
get(3,272) ->
	#base_marry_heart{type = 3 ,lv = 272 ,attrs = [{hp_lim,90800}],goods_num = 2350 };
get(4,272) ->
	#base_marry_heart{type = 4 ,lv = 272 ,attrs = [{crit,2966}],goods_num = 2350 };
get(5,272) ->
	#base_marry_heart{type = 5 ,lv = 272 ,attrs = [{ten,2966}],goods_num = 2350 };
get(6,272) ->
	#base_marry_heart{type = 6 ,lv = 272 ,attrs = [{hit,2966}],goods_num = 2350 };
get(7,272) ->
	#base_marry_heart{type = 7 ,lv = 272 ,attrs = [{dodge,2966}],goods_num = 2350 };
get(8,272) ->
	#base_marry_heart{type = 8 ,lv = 272 ,attrs = [{att,9080},{def,9080},{hp_lim,90800}],goods_num = 8320 };
get(1,273) ->
	#base_marry_heart{type = 1 ,lv = 273 ,attrs = [{att,9120}],goods_num = 2397 };
get(2,273) ->
	#base_marry_heart{type = 2 ,lv = 273 ,attrs = [{def,9120}],goods_num = 2397 };
get(3,273) ->
	#base_marry_heart{type = 3 ,lv = 273 ,attrs = [{hp_lim,91200}],goods_num = 2397 };
get(4,273) ->
	#base_marry_heart{type = 4 ,lv = 273 ,attrs = [{crit,2979}],goods_num = 2397 };
get(5,273) ->
	#base_marry_heart{type = 5 ,lv = 273 ,attrs = [{ten,2979}],goods_num = 2397 };
get(6,273) ->
	#base_marry_heart{type = 6 ,lv = 273 ,attrs = [{hit,2979}],goods_num = 2397 };
get(7,273) ->
	#base_marry_heart{type = 7 ,lv = 273 ,attrs = [{dodge,2979}],goods_num = 2397 };
get(8,273) ->
	#base_marry_heart{type = 8 ,lv = 273 ,attrs = [{att,9120},{def,9120},{hp_lim,91200}],goods_num = 8486 };
get(1,274) ->
	#base_marry_heart{type = 1 ,lv = 274 ,attrs = [{att,9160}],goods_num = 2444 };
get(2,274) ->
	#base_marry_heart{type = 2 ,lv = 274 ,attrs = [{def,9160}],goods_num = 2444 };
get(3,274) ->
	#base_marry_heart{type = 3 ,lv = 274 ,attrs = [{hp_lim,91600}],goods_num = 2444 };
get(4,274) ->
	#base_marry_heart{type = 4 ,lv = 274 ,attrs = [{crit,2992}],goods_num = 2444 };
get(5,274) ->
	#base_marry_heart{type = 5 ,lv = 274 ,attrs = [{ten,2992}],goods_num = 2444 };
get(6,274) ->
	#base_marry_heart{type = 6 ,lv = 274 ,attrs = [{hit,2992}],goods_num = 2444 };
get(7,274) ->
	#base_marry_heart{type = 7 ,lv = 274 ,attrs = [{dodge,2992}],goods_num = 2444 };
get(8,274) ->
	#base_marry_heart{type = 8 ,lv = 274 ,attrs = [{att,9160},{def,9160},{hp_lim,91600}],goods_num = 8655 };
get(1,275) ->
	#base_marry_heart{type = 1 ,lv = 275 ,attrs = [{att,9200}],goods_num = 2492 };
get(2,275) ->
	#base_marry_heart{type = 2 ,lv = 275 ,attrs = [{def,9200}],goods_num = 2492 };
get(3,275) ->
	#base_marry_heart{type = 3 ,lv = 275 ,attrs = [{hp_lim,92000}],goods_num = 2492 };
get(4,275) ->
	#base_marry_heart{type = 4 ,lv = 275 ,attrs = [{crit,3005}],goods_num = 2492 };
get(5,275) ->
	#base_marry_heart{type = 5 ,lv = 275 ,attrs = [{ten,3005}],goods_num = 2492 };
get(6,275) ->
	#base_marry_heart{type = 6 ,lv = 275 ,attrs = [{hit,3005}],goods_num = 2492 };
get(7,275) ->
	#base_marry_heart{type = 7 ,lv = 275 ,attrs = [{dodge,3005}],goods_num = 2492 };
get(8,275) ->
	#base_marry_heart{type = 8 ,lv = 275 ,attrs = [{att,9200},{def,9200},{hp_lim,92000}],goods_num = 8828 };
get(1,276) ->
	#base_marry_heart{type = 1 ,lv = 276 ,attrs = [{att,9240}],goods_num = 2541 };
get(2,276) ->
	#base_marry_heart{type = 2 ,lv = 276 ,attrs = [{def,9240}],goods_num = 2541 };
get(3,276) ->
	#base_marry_heart{type = 3 ,lv = 276 ,attrs = [{hp_lim,92400}],goods_num = 2541 };
get(4,276) ->
	#base_marry_heart{type = 4 ,lv = 276 ,attrs = [{crit,3018}],goods_num = 2541 };
get(5,276) ->
	#base_marry_heart{type = 5 ,lv = 276 ,attrs = [{ten,3018}],goods_num = 2541 };
get(6,276) ->
	#base_marry_heart{type = 6 ,lv = 276 ,attrs = [{hit,3018}],goods_num = 2541 };
get(7,276) ->
	#base_marry_heart{type = 7 ,lv = 276 ,attrs = [{dodge,3018}],goods_num = 2541 };
get(8,276) ->
	#base_marry_heart{type = 8 ,lv = 276 ,attrs = [{att,9240},{def,9240},{hp_lim,92400}],goods_num = 9004 };
get(1,277) ->
	#base_marry_heart{type = 1 ,lv = 277 ,attrs = [{att,9280}],goods_num = 2591 };
get(2,277) ->
	#base_marry_heart{type = 2 ,lv = 277 ,attrs = [{def,9280}],goods_num = 2591 };
get(3,277) ->
	#base_marry_heart{type = 3 ,lv = 277 ,attrs = [{hp_lim,92800}],goods_num = 2591 };
get(4,277) ->
	#base_marry_heart{type = 4 ,lv = 277 ,attrs = [{crit,3031}],goods_num = 2591 };
get(5,277) ->
	#base_marry_heart{type = 5 ,lv = 277 ,attrs = [{ten,3031}],goods_num = 2591 };
get(6,277) ->
	#base_marry_heart{type = 6 ,lv = 277 ,attrs = [{hit,3031}],goods_num = 2591 };
get(7,277) ->
	#base_marry_heart{type = 7 ,lv = 277 ,attrs = [{dodge,3031}],goods_num = 2591 };
get(8,277) ->
	#base_marry_heart{type = 8 ,lv = 277 ,attrs = [{att,9280},{def,9280},{hp_lim,92800}],goods_num = 9184 };
get(1,278) ->
	#base_marry_heart{type = 1 ,lv = 278 ,attrs = [{att,9320}],goods_num = 2642 };
get(2,278) ->
	#base_marry_heart{type = 2 ,lv = 278 ,attrs = [{def,9320}],goods_num = 2642 };
get(3,278) ->
	#base_marry_heart{type = 3 ,lv = 278 ,attrs = [{hp_lim,93200}],goods_num = 2642 };
get(4,278) ->
	#base_marry_heart{type = 4 ,lv = 278 ,attrs = [{crit,3044}],goods_num = 2642 };
get(5,278) ->
	#base_marry_heart{type = 5 ,lv = 278 ,attrs = [{ten,3044}],goods_num = 2642 };
get(6,278) ->
	#base_marry_heart{type = 6 ,lv = 278 ,attrs = [{hit,3044}],goods_num = 2642 };
get(7,278) ->
	#base_marry_heart{type = 7 ,lv = 278 ,attrs = [{dodge,3044}],goods_num = 2642 };
get(8,278) ->
	#base_marry_heart{type = 8 ,lv = 278 ,attrs = [{att,9320},{def,9320},{hp_lim,93200}],goods_num = 9367 };
get(1,279) ->
	#base_marry_heart{type = 1 ,lv = 279 ,attrs = [{att,9360}],goods_num = 2694 };
get(2,279) ->
	#base_marry_heart{type = 2 ,lv = 279 ,attrs = [{def,9360}],goods_num = 2694 };
get(3,279) ->
	#base_marry_heart{type = 3 ,lv = 279 ,attrs = [{hp_lim,93600}],goods_num = 2694 };
get(4,279) ->
	#base_marry_heart{type = 4 ,lv = 279 ,attrs = [{crit,3057}],goods_num = 2694 };
get(5,279) ->
	#base_marry_heart{type = 5 ,lv = 279 ,attrs = [{ten,3057}],goods_num = 2694 };
get(6,279) ->
	#base_marry_heart{type = 6 ,lv = 279 ,attrs = [{hit,3057}],goods_num = 2694 };
get(7,279) ->
	#base_marry_heart{type = 7 ,lv = 279 ,attrs = [{dodge,3057}],goods_num = 2694 };
get(8,279) ->
	#base_marry_heart{type = 8 ,lv = 279 ,attrs = [{att,9360},{def,9360},{hp_lim,93600}],goods_num = 9554 };
get(1,280) ->
	#base_marry_heart{type = 1 ,lv = 280 ,attrs = [{att,9400}],goods_num = 2747 };
get(2,280) ->
	#base_marry_heart{type = 2 ,lv = 280 ,attrs = [{def,9400}],goods_num = 2747 };
get(3,280) ->
	#base_marry_heart{type = 3 ,lv = 280 ,attrs = [{hp_lim,94000}],goods_num = 2747 };
get(4,280) ->
	#base_marry_heart{type = 4 ,lv = 280 ,attrs = [{crit,3070}],goods_num = 2747 };
get(5,280) ->
	#base_marry_heart{type = 5 ,lv = 280 ,attrs = [{ten,3070}],goods_num = 2747 };
get(6,280) ->
	#base_marry_heart{type = 6 ,lv = 280 ,attrs = [{hit,3070}],goods_num = 2747 };
get(7,280) ->
	#base_marry_heart{type = 7 ,lv = 280 ,attrs = [{dodge,3070}],goods_num = 2747 };
get(8,280) ->
	#base_marry_heart{type = 8 ,lv = 280 ,attrs = [{att,9400},{def,9400},{hp_lim,94000}],goods_num = 9745 };
get(1,281) ->
	#base_marry_heart{type = 1 ,lv = 281 ,attrs = [{att,9440}],goods_num = 2801 };
get(2,281) ->
	#base_marry_heart{type = 2 ,lv = 281 ,attrs = [{def,9440}],goods_num = 2801 };
get(3,281) ->
	#base_marry_heart{type = 3 ,lv = 281 ,attrs = [{hp_lim,94400}],goods_num = 2801 };
get(4,281) ->
	#base_marry_heart{type = 4 ,lv = 281 ,attrs = [{crit,3083}],goods_num = 2801 };
get(5,281) ->
	#base_marry_heart{type = 5 ,lv = 281 ,attrs = [{ten,3083}],goods_num = 2801 };
get(6,281) ->
	#base_marry_heart{type = 6 ,lv = 281 ,attrs = [{hit,3083}],goods_num = 2801 };
get(7,281) ->
	#base_marry_heart{type = 7 ,lv = 281 ,attrs = [{dodge,3083}],goods_num = 2801 };
get(8,281) ->
	#base_marry_heart{type = 8 ,lv = 281 ,attrs = [{att,9440},{def,9440},{hp_lim,94400}],goods_num = 9939 };
get(1,282) ->
	#base_marry_heart{type = 1 ,lv = 282 ,attrs = [{att,9480}],goods_num = 2857 };
get(2,282) ->
	#base_marry_heart{type = 2 ,lv = 282 ,attrs = [{def,9480}],goods_num = 2857 };
get(3,282) ->
	#base_marry_heart{type = 3 ,lv = 282 ,attrs = [{hp_lim,94800}],goods_num = 2857 };
get(4,282) ->
	#base_marry_heart{type = 4 ,lv = 282 ,attrs = [{crit,3096}],goods_num = 2857 };
get(5,282) ->
	#base_marry_heart{type = 5 ,lv = 282 ,attrs = [{ten,3096}],goods_num = 2857 };
get(6,282) ->
	#base_marry_heart{type = 6 ,lv = 282 ,attrs = [{hit,3096}],goods_num = 2857 };
get(7,282) ->
	#base_marry_heart{type = 7 ,lv = 282 ,attrs = [{dodge,3096}],goods_num = 2857 };
get(8,282) ->
	#base_marry_heart{type = 8 ,lv = 282 ,attrs = [{att,9480},{def,9480},{hp_lim,94800}],goods_num = 10137 };
get(1,283) ->
	#base_marry_heart{type = 1 ,lv = 283 ,attrs = [{att,9520}],goods_num = 2914 };
get(2,283) ->
	#base_marry_heart{type = 2 ,lv = 283 ,attrs = [{def,9520}],goods_num = 2914 };
get(3,283) ->
	#base_marry_heart{type = 3 ,lv = 283 ,attrs = [{hp_lim,95200}],goods_num = 2914 };
get(4,283) ->
	#base_marry_heart{type = 4 ,lv = 283 ,attrs = [{crit,3109}],goods_num = 2914 };
get(5,283) ->
	#base_marry_heart{type = 5 ,lv = 283 ,attrs = [{ten,3109}],goods_num = 2914 };
get(6,283) ->
	#base_marry_heart{type = 6 ,lv = 283 ,attrs = [{hit,3109}],goods_num = 2914 };
get(7,283) ->
	#base_marry_heart{type = 7 ,lv = 283 ,attrs = [{dodge,3109}],goods_num = 2914 };
get(8,283) ->
	#base_marry_heart{type = 8 ,lv = 283 ,attrs = [{att,9520},{def,9520},{hp_lim,95200}],goods_num = 10339 };
get(1,284) ->
	#base_marry_heart{type = 1 ,lv = 284 ,attrs = [{att,9560}],goods_num = 2972 };
get(2,284) ->
	#base_marry_heart{type = 2 ,lv = 284 ,attrs = [{def,9560}],goods_num = 2972 };
get(3,284) ->
	#base_marry_heart{type = 3 ,lv = 284 ,attrs = [{hp_lim,95600}],goods_num = 2972 };
get(4,284) ->
	#base_marry_heart{type = 4 ,lv = 284 ,attrs = [{crit,3122}],goods_num = 2972 };
get(5,284) ->
	#base_marry_heart{type = 5 ,lv = 284 ,attrs = [{ten,3122}],goods_num = 2972 };
get(6,284) ->
	#base_marry_heart{type = 6 ,lv = 284 ,attrs = [{hit,3122}],goods_num = 2972 };
get(7,284) ->
	#base_marry_heart{type = 7 ,lv = 284 ,attrs = [{dodge,3122}],goods_num = 2972 };
get(8,284) ->
	#base_marry_heart{type = 8 ,lv = 284 ,attrs = [{att,9560},{def,9560},{hp_lim,95600}],goods_num = 10545 };
get(1,285) ->
	#base_marry_heart{type = 1 ,lv = 285 ,attrs = [{att,9600}],goods_num = 3031 };
get(2,285) ->
	#base_marry_heart{type = 2 ,lv = 285 ,attrs = [{def,9600}],goods_num = 3031 };
get(3,285) ->
	#base_marry_heart{type = 3 ,lv = 285 ,attrs = [{hp_lim,96000}],goods_num = 3031 };
get(4,285) ->
	#base_marry_heart{type = 4 ,lv = 285 ,attrs = [{crit,3135}],goods_num = 3031 };
get(5,285) ->
	#base_marry_heart{type = 5 ,lv = 285 ,attrs = [{ten,3135}],goods_num = 3031 };
get(6,285) ->
	#base_marry_heart{type = 6 ,lv = 285 ,attrs = [{hit,3135}],goods_num = 3031 };
get(7,285) ->
	#base_marry_heart{type = 7 ,lv = 285 ,attrs = [{dodge,3135}],goods_num = 3031 };
get(8,285) ->
	#base_marry_heart{type = 8 ,lv = 285 ,attrs = [{att,9600},{def,9600},{hp_lim,96000}],goods_num = 10755 };
get(1,286) ->
	#base_marry_heart{type = 1 ,lv = 286 ,attrs = [{att,9640}],goods_num = 3091 };
get(2,286) ->
	#base_marry_heart{type = 2 ,lv = 286 ,attrs = [{def,9640}],goods_num = 3091 };
get(3,286) ->
	#base_marry_heart{type = 3 ,lv = 286 ,attrs = [{hp_lim,96400}],goods_num = 3091 };
get(4,286) ->
	#base_marry_heart{type = 4 ,lv = 286 ,attrs = [{crit,3148}],goods_num = 3091 };
get(5,286) ->
	#base_marry_heart{type = 5 ,lv = 286 ,attrs = [{ten,3148}],goods_num = 3091 };
get(6,286) ->
	#base_marry_heart{type = 6 ,lv = 286 ,attrs = [{hit,3148}],goods_num = 3091 };
get(7,286) ->
	#base_marry_heart{type = 7 ,lv = 286 ,attrs = [{dodge,3148}],goods_num = 3091 };
get(8,286) ->
	#base_marry_heart{type = 8 ,lv = 286 ,attrs = [{att,9640},{def,9640},{hp_lim,96400}],goods_num = 10970 };
get(1,287) ->
	#base_marry_heart{type = 1 ,lv = 287 ,attrs = [{att,9680}],goods_num = 3152 };
get(2,287) ->
	#base_marry_heart{type = 2 ,lv = 287 ,attrs = [{def,9680}],goods_num = 3152 };
get(3,287) ->
	#base_marry_heart{type = 3 ,lv = 287 ,attrs = [{hp_lim,96800}],goods_num = 3152 };
get(4,287) ->
	#base_marry_heart{type = 4 ,lv = 287 ,attrs = [{crit,3161}],goods_num = 3152 };
get(5,287) ->
	#base_marry_heart{type = 5 ,lv = 287 ,attrs = [{ten,3161}],goods_num = 3152 };
get(6,287) ->
	#base_marry_heart{type = 6 ,lv = 287 ,attrs = [{hit,3161}],goods_num = 3152 };
get(7,287) ->
	#base_marry_heart{type = 7 ,lv = 287 ,attrs = [{dodge,3161}],goods_num = 3152 };
get(8,287) ->
	#base_marry_heart{type = 8 ,lv = 287 ,attrs = [{att,9680},{def,9680},{hp_lim,96800}],goods_num = 11189 };
get(1,288) ->
	#base_marry_heart{type = 1 ,lv = 288 ,attrs = [{att,9720}],goods_num = 3215 };
get(2,288) ->
	#base_marry_heart{type = 2 ,lv = 288 ,attrs = [{def,9720}],goods_num = 3215 };
get(3,288) ->
	#base_marry_heart{type = 3 ,lv = 288 ,attrs = [{hp_lim,97200}],goods_num = 3215 };
get(4,288) ->
	#base_marry_heart{type = 4 ,lv = 288 ,attrs = [{crit,3174}],goods_num = 3215 };
get(5,288) ->
	#base_marry_heart{type = 5 ,lv = 288 ,attrs = [{ten,3174}],goods_num = 3215 };
get(6,288) ->
	#base_marry_heart{type = 6 ,lv = 288 ,attrs = [{hit,3174}],goods_num = 3215 };
get(7,288) ->
	#base_marry_heart{type = 7 ,lv = 288 ,attrs = [{dodge,3174}],goods_num = 3215 };
get(8,288) ->
	#base_marry_heart{type = 8 ,lv = 288 ,attrs = [{att,9720},{def,9720},{hp_lim,97200}],goods_num = 11412 };
get(1,289) ->
	#base_marry_heart{type = 1 ,lv = 289 ,attrs = [{att,9760}],goods_num = 3279 };
get(2,289) ->
	#base_marry_heart{type = 2 ,lv = 289 ,attrs = [{def,9760}],goods_num = 3279 };
get(3,289) ->
	#base_marry_heart{type = 3 ,lv = 289 ,attrs = [{hp_lim,97600}],goods_num = 3279 };
get(4,289) ->
	#base_marry_heart{type = 4 ,lv = 289 ,attrs = [{crit,3187}],goods_num = 3279 };
get(5,289) ->
	#base_marry_heart{type = 5 ,lv = 289 ,attrs = [{ten,3187}],goods_num = 3279 };
get(6,289) ->
	#base_marry_heart{type = 6 ,lv = 289 ,attrs = [{hit,3187}],goods_num = 3279 };
get(7,289) ->
	#base_marry_heart{type = 7 ,lv = 289 ,attrs = [{dodge,3187}],goods_num = 3279 };
get(8,289) ->
	#base_marry_heart{type = 8 ,lv = 289 ,attrs = [{att,9760},{def,9760},{hp_lim,97600}],goods_num = 11640 };
get(1,290) ->
	#base_marry_heart{type = 1 ,lv = 290 ,attrs = [{att,9800}],goods_num = 3344 };
get(2,290) ->
	#base_marry_heart{type = 2 ,lv = 290 ,attrs = [{def,9800}],goods_num = 3344 };
get(3,290) ->
	#base_marry_heart{type = 3 ,lv = 290 ,attrs = [{hp_lim,98000}],goods_num = 3344 };
get(4,290) ->
	#base_marry_heart{type = 4 ,lv = 290 ,attrs = [{crit,3200}],goods_num = 3344 };
get(5,290) ->
	#base_marry_heart{type = 5 ,lv = 290 ,attrs = [{ten,3200}],goods_num = 3344 };
get(6,290) ->
	#base_marry_heart{type = 6 ,lv = 290 ,attrs = [{hit,3200}],goods_num = 3344 };
get(7,290) ->
	#base_marry_heart{type = 7 ,lv = 290 ,attrs = [{dodge,3200}],goods_num = 3344 };
get(8,290) ->
	#base_marry_heart{type = 8 ,lv = 290 ,attrs = [{att,9800},{def,9800},{hp_lim,98000}],goods_num = 11872 };
get(1,291) ->
	#base_marry_heart{type = 1 ,lv = 291 ,attrs = [{att,9840}],goods_num = 3410 };
get(2,291) ->
	#base_marry_heart{type = 2 ,lv = 291 ,attrs = [{def,9840}],goods_num = 3410 };
get(3,291) ->
	#base_marry_heart{type = 3 ,lv = 291 ,attrs = [{hp_lim,98400}],goods_num = 3410 };
get(4,291) ->
	#base_marry_heart{type = 4 ,lv = 291 ,attrs = [{crit,3213}],goods_num = 3410 };
get(5,291) ->
	#base_marry_heart{type = 5 ,lv = 291 ,attrs = [{ten,3213}],goods_num = 3410 };
get(6,291) ->
	#base_marry_heart{type = 6 ,lv = 291 ,attrs = [{hit,3213}],goods_num = 3410 };
get(7,291) ->
	#base_marry_heart{type = 7 ,lv = 291 ,attrs = [{dodge,3213}],goods_num = 3410 };
get(8,291) ->
	#base_marry_heart{type = 8 ,lv = 291 ,attrs = [{att,9840},{def,9840},{hp_lim,98400}],goods_num = 12109 };
get(1,292) ->
	#base_marry_heart{type = 1 ,lv = 292 ,attrs = [{att,9880}],goods_num = 3478 };
get(2,292) ->
	#base_marry_heart{type = 2 ,lv = 292 ,attrs = [{def,9880}],goods_num = 3478 };
get(3,292) ->
	#base_marry_heart{type = 3 ,lv = 292 ,attrs = [{hp_lim,98800}],goods_num = 3478 };
get(4,292) ->
	#base_marry_heart{type = 4 ,lv = 292 ,attrs = [{crit,3226}],goods_num = 3478 };
get(5,292) ->
	#base_marry_heart{type = 5 ,lv = 292 ,attrs = [{ten,3226}],goods_num = 3478 };
get(6,292) ->
	#base_marry_heart{type = 6 ,lv = 292 ,attrs = [{hit,3226}],goods_num = 3478 };
get(7,292) ->
	#base_marry_heart{type = 7 ,lv = 292 ,attrs = [{dodge,3226}],goods_num = 3478 };
get(8,292) ->
	#base_marry_heart{type = 8 ,lv = 292 ,attrs = [{att,9880},{def,9880},{hp_lim,98800}],goods_num = 12351 };
get(1,293) ->
	#base_marry_heart{type = 1 ,lv = 293 ,attrs = [{att,9920}],goods_num = 3547 };
get(2,293) ->
	#base_marry_heart{type = 2 ,lv = 293 ,attrs = [{def,9920}],goods_num = 3547 };
get(3,293) ->
	#base_marry_heart{type = 3 ,lv = 293 ,attrs = [{hp_lim,99200}],goods_num = 3547 };
get(4,293) ->
	#base_marry_heart{type = 4 ,lv = 293 ,attrs = [{crit,3239}],goods_num = 3547 };
get(5,293) ->
	#base_marry_heart{type = 5 ,lv = 293 ,attrs = [{ten,3239}],goods_num = 3547 };
get(6,293) ->
	#base_marry_heart{type = 6 ,lv = 293 ,attrs = [{hit,3239}],goods_num = 3547 };
get(7,293) ->
	#base_marry_heart{type = 7 ,lv = 293 ,attrs = [{dodge,3239}],goods_num = 3547 };
get(8,293) ->
	#base_marry_heart{type = 8 ,lv = 293 ,attrs = [{att,9920},{def,9920},{hp_lim,99200}],goods_num = 12598 };
get(1,294) ->
	#base_marry_heart{type = 1 ,lv = 294 ,attrs = [{att,9960}],goods_num = 3617 };
get(2,294) ->
	#base_marry_heart{type = 2 ,lv = 294 ,attrs = [{def,9960}],goods_num = 3617 };
get(3,294) ->
	#base_marry_heart{type = 3 ,lv = 294 ,attrs = [{hp_lim,99600}],goods_num = 3617 };
get(4,294) ->
	#base_marry_heart{type = 4 ,lv = 294 ,attrs = [{crit,3252}],goods_num = 3617 };
get(5,294) ->
	#base_marry_heart{type = 5 ,lv = 294 ,attrs = [{ten,3252}],goods_num = 3617 };
get(6,294) ->
	#base_marry_heart{type = 6 ,lv = 294 ,attrs = [{hit,3252}],goods_num = 3617 };
get(7,294) ->
	#base_marry_heart{type = 7 ,lv = 294 ,attrs = [{dodge,3252}],goods_num = 3617 };
get(8,294) ->
	#base_marry_heart{type = 8 ,lv = 294 ,attrs = [{att,9960},{def,9960},{hp_lim,99600}],goods_num = 12849 };
get(1,295) ->
	#base_marry_heart{type = 1 ,lv = 295 ,attrs = [{att,10000}],goods_num = 3689 };
get(2,295) ->
	#base_marry_heart{type = 2 ,lv = 295 ,attrs = [{def,10000}],goods_num = 3689 };
get(3,295) ->
	#base_marry_heart{type = 3 ,lv = 295 ,attrs = [{hp_lim,100000}],goods_num = 3689 };
get(4,295) ->
	#base_marry_heart{type = 4 ,lv = 295 ,attrs = [{crit,3265}],goods_num = 3689 };
get(5,295) ->
	#base_marry_heart{type = 5 ,lv = 295 ,attrs = [{ten,3265}],goods_num = 3689 };
get(6,295) ->
	#base_marry_heart{type = 6 ,lv = 295 ,attrs = [{hit,3265}],goods_num = 3689 };
get(7,295) ->
	#base_marry_heart{type = 7 ,lv = 295 ,attrs = [{dodge,3265}],goods_num = 3689 };
get(8,295) ->
	#base_marry_heart{type = 8 ,lv = 295 ,attrs = [{att,10000},{def,10000},{hp_lim,100000}],goods_num = 13105 };
get(1,296) ->
	#base_marry_heart{type = 1 ,lv = 296 ,attrs = [{att,10040}],goods_num = 3762 };
get(2,296) ->
	#base_marry_heart{type = 2 ,lv = 296 ,attrs = [{def,10040}],goods_num = 3762 };
get(3,296) ->
	#base_marry_heart{type = 3 ,lv = 296 ,attrs = [{hp_lim,100400}],goods_num = 3762 };
get(4,296) ->
	#base_marry_heart{type = 4 ,lv = 296 ,attrs = [{crit,3278}],goods_num = 3762 };
get(5,296) ->
	#base_marry_heart{type = 5 ,lv = 296 ,attrs = [{ten,3278}],goods_num = 3762 };
get(6,296) ->
	#base_marry_heart{type = 6 ,lv = 296 ,attrs = [{hit,3278}],goods_num = 3762 };
get(7,296) ->
	#base_marry_heart{type = 7 ,lv = 296 ,attrs = [{dodge,3278}],goods_num = 3762 };
get(8,296) ->
	#base_marry_heart{type = 8 ,lv = 296 ,attrs = [{att,10040},{def,10040},{hp_lim,100400}],goods_num = 13367 };
get(1,297) ->
	#base_marry_heart{type = 1 ,lv = 297 ,attrs = [{att,10080}],goods_num = 3837 };
get(2,297) ->
	#base_marry_heart{type = 2 ,lv = 297 ,attrs = [{def,10080}],goods_num = 3837 };
get(3,297) ->
	#base_marry_heart{type = 3 ,lv = 297 ,attrs = [{hp_lim,100800}],goods_num = 3837 };
get(4,297) ->
	#base_marry_heart{type = 4 ,lv = 297 ,attrs = [{crit,3291}],goods_num = 3837 };
get(5,297) ->
	#base_marry_heart{type = 5 ,lv = 297 ,attrs = [{ten,3291}],goods_num = 3837 };
get(6,297) ->
	#base_marry_heart{type = 6 ,lv = 297 ,attrs = [{hit,3291}],goods_num = 3837 };
get(7,297) ->
	#base_marry_heart{type = 7 ,lv = 297 ,attrs = [{dodge,3291}],goods_num = 3837 };
get(8,297) ->
	#base_marry_heart{type = 8 ,lv = 297 ,attrs = [{att,10080},{def,10080},{hp_lim,100800}],goods_num = 13634 };
get(1,298) ->
	#base_marry_heart{type = 1 ,lv = 298 ,attrs = [{att,10120}],goods_num = 3913 };
get(2,298) ->
	#base_marry_heart{type = 2 ,lv = 298 ,attrs = [{def,10120}],goods_num = 3913 };
get(3,298) ->
	#base_marry_heart{type = 3 ,lv = 298 ,attrs = [{hp_lim,101200}],goods_num = 3913 };
get(4,298) ->
	#base_marry_heart{type = 4 ,lv = 298 ,attrs = [{crit,3304}],goods_num = 3913 };
get(5,298) ->
	#base_marry_heart{type = 5 ,lv = 298 ,attrs = [{ten,3304}],goods_num = 3913 };
get(6,298) ->
	#base_marry_heart{type = 6 ,lv = 298 ,attrs = [{hit,3304}],goods_num = 3913 };
get(7,298) ->
	#base_marry_heart{type = 7 ,lv = 298 ,attrs = [{dodge,3304}],goods_num = 3913 };
get(8,298) ->
	#base_marry_heart{type = 8 ,lv = 298 ,attrs = [{att,10120},{def,10120},{hp_lim,101200}],goods_num = 13906 };
get(1,299) ->
	#base_marry_heart{type = 1 ,lv = 299 ,attrs = [{att,10160}],goods_num = 3991 };
get(2,299) ->
	#base_marry_heart{type = 2 ,lv = 299 ,attrs = [{def,10160}],goods_num = 3991 };
get(3,299) ->
	#base_marry_heart{type = 3 ,lv = 299 ,attrs = [{hp_lim,101600}],goods_num = 3991 };
get(4,299) ->
	#base_marry_heart{type = 4 ,lv = 299 ,attrs = [{crit,3317}],goods_num = 3991 };
get(5,299) ->
	#base_marry_heart{type = 5 ,lv = 299 ,attrs = [{ten,3317}],goods_num = 3991 };
get(6,299) ->
	#base_marry_heart{type = 6 ,lv = 299 ,attrs = [{hit,3317}],goods_num = 3991 };
get(7,299) ->
	#base_marry_heart{type = 7 ,lv = 299 ,attrs = [{dodge,3317}],goods_num = 3991 };
get(8,299) ->
	#base_marry_heart{type = 8 ,lv = 299 ,attrs = [{att,10160},{def,10160},{hp_lim,101600}],goods_num = 14184 };
get(1,300) ->
	#base_marry_heart{type = 1 ,lv = 300 ,attrs = [{att,10200}],goods_num = 4070 };
get(2,300) ->
	#base_marry_heart{type = 2 ,lv = 300 ,attrs = [{def,10200}],goods_num = 4070 };
get(3,300) ->
	#base_marry_heart{type = 3 ,lv = 300 ,attrs = [{hp_lim,102000}],goods_num = 4070 };
get(4,300) ->
	#base_marry_heart{type = 4 ,lv = 300 ,attrs = [{crit,3330}],goods_num = 4070 };
get(5,300) ->
	#base_marry_heart{type = 5 ,lv = 300 ,attrs = [{ten,3330}],goods_num = 4070 };
get(6,300) ->
	#base_marry_heart{type = 6 ,lv = 300 ,attrs = [{hit,3330}],goods_num = 4070 };
get(7,300) ->
	#base_marry_heart{type = 7 ,lv = 300 ,attrs = [{dodge,3330}],goods_num = 4070 };
get(8,300) ->
	#base_marry_heart{type = 8 ,lv = 300 ,attrs = [{att,10200},{def,10200},{hp_lim,102000}],goods_num = 14467 };
get(_,_) -> [].