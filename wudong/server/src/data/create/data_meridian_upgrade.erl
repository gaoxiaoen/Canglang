%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_meridian_upgrade
	%%% @Created : 2017-09-19 21:23:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_meridian_upgrade).
-export([get_max_subtype/0]).
-export([get_max_lv/0]).
-export([get/3]).
-include("common.hrl").
-include("meridian.hrl").
get_max_subtype() -> 7.
get_max_lv() -> 10.
get(1,1,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 1 ,attrs = [{att,20}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,2,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 1 ,attrs = [{def,10}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,3,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 1 ,attrs = [{hp_lim,200}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,4,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 1 ,attrs = [{crit,4}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,5,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 1 ,attrs = [{att,20}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,6,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 1 ,attrs = [{def,10}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,7,1) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 1 ,attrs = [{hp_lim,200}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 20 }
;get(1,1,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 2 ,attrs = [{att,60}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,2,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 2 ,attrs = [{def,30}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,3,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 2 ,attrs = [{hp_lim,600}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,4,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 2 ,attrs = [{crit,12}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,5,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 2 ,attrs = [{att,60}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,6,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 2 ,attrs = [{def,30}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,7,2) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 2 ,attrs = [{hp_lim,600}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(1,1,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 3 ,attrs = [{att,120}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,2,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 3 ,attrs = [{def,60}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,3,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 3 ,attrs = [{hp_lim,1200}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,4,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 3 ,attrs = [{crit,24}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,5,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 3 ,attrs = [{att,120}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,6,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 3 ,attrs = [{def,60}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,7,3) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 3 ,attrs = [{hp_lim,1200}],plv = 1 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(1,1,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 4 ,attrs = [{att,200}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,2,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 4 ,attrs = [{def,100}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,3,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 4 ,attrs = [{hp_lim,2000}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,4,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 4 ,attrs = [{crit,40}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,5,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 4 ,attrs = [{att,200}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,6,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 4 ,attrs = [{def,100}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,7,4) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 4 ,attrs = [{hp_lim,2000}],plv = 85 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(1,1,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 5 ,attrs = [{att,300}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,2,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 5 ,attrs = [{def,150}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,3,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 5 ,attrs = [{hp_lim,3000}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,4,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 5 ,attrs = [{crit,60}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,5,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 5 ,attrs = [{att,300}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,6,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 5 ,attrs = [{def,150}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,7,5) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 5 ,attrs = [{hp_lim,3000}],plv = 90 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(1,1,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 6 ,attrs = [{att,420}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,2,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 6 ,attrs = [{def,210}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,3,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 6 ,attrs = [{hp_lim,4200}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,4,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 6 ,attrs = [{crit,84}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,5,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 6 ,attrs = [{att,420}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,6,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 6 ,attrs = [{def,210}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,7,6) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 6 ,attrs = [{hp_lim,4200}],plv = 95 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(1,1,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 7 ,attrs = [{att,560}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,2,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 7 ,attrs = [{def,280}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,3,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 7 ,attrs = [{hp_lim,5600}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,4,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 7 ,attrs = [{crit,112}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,5,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 7 ,attrs = [{att,560}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,6,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 7 ,attrs = [{def,280}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,7,7) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 7 ,attrs = [{hp_lim,5600}],plv = 100 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(1,1,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 8 ,attrs = [{att,720}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,2,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 8 ,attrs = [{def,360}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,3,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 8 ,attrs = [{hp_lim,7200}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,4,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 8 ,attrs = [{crit,144}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,5,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 8 ,attrs = [{att,720}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,6,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 8 ,attrs = [{def,360}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,7,8) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 8 ,attrs = [{hp_lim,7200}],plv = 105 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(1,1,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 9 ,attrs = [{att,900}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,2,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 9 ,attrs = [{def,450}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,3,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 9 ,attrs = [{hp_lim,9000}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,4,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 9 ,attrs = [{crit,180}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,5,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 9 ,attrs = [{att,900}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,6,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 9 ,attrs = [{def,450}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,7,9) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 9 ,attrs = [{hp_lim,9000}],plv = 110 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(1,1,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 1 ,lv = 10 ,attrs = [{att,1100}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,2,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 2 ,lv = 10 ,attrs = [{def,550}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,3,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 3 ,lv = 10 ,attrs = [{hp_lim,11000}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,4,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 4 ,lv = 10 ,attrs = [{crit,220}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,5,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 5 ,lv = 10 ,attrs = [{att,1100}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,6,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 6 ,lv = 10 ,attrs = [{def,550}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(1,7,10) -> 
   #base_meridian_upgrade{type = 1 ,subtype = 7 ,lv = 10 ,attrs = [{hp_lim,11000}],plv = 115 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(2,1,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 1 ,attrs = [{def,15}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,2,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 1 ,attrs = [{hp_lim,300}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,3,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 1 ,attrs = [{ten,6}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,4,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 1 ,attrs = [{dodge,6}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,5,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 1 ,attrs = [{hp_lim,300}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,6,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 1 ,attrs = [{ten,6}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,7,1) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 1 ,attrs = [{dodge,6}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 30 }
;get(2,1,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 2 ,attrs = [{def,45}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,2,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 2 ,attrs = [{hp_lim,900}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,3,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 2 ,attrs = [{ten,18}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,4,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 2 ,attrs = [{dodge,18}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,5,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 2 ,attrs = [{hp_lim,900}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,6,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 2 ,attrs = [{ten,18}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,7,2) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 2 ,attrs = [{dodge,18}],plv = 1 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(2,1,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 3 ,attrs = [{def,90}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,2,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 3 ,attrs = [{hp_lim,1800}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,3,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 3 ,attrs = [{ten,36}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,4,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 3 ,attrs = [{dodge,36}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,5,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 3 ,attrs = [{hp_lim,1800}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,6,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 3 ,attrs = [{ten,36}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,7,3) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 3 ,attrs = [{dodge,36}],plv = 85 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(2,1,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 4 ,attrs = [{def,150}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,2,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 4 ,attrs = [{hp_lim,3000}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,3,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 4 ,attrs = [{ten,60}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,4,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 4 ,attrs = [{dodge,60}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,5,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 4 ,attrs = [{hp_lim,3000}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,6,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 4 ,attrs = [{ten,60}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,7,4) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 4 ,attrs = [{dodge,60}],plv = 90 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(2,1,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 5 ,attrs = [{def,225}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,2,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 5 ,attrs = [{hp_lim,4500}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,3,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 5 ,attrs = [{ten,90}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,4,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 5 ,attrs = [{dodge,90}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,5,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 5 ,attrs = [{hp_lim,4500}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,6,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 5 ,attrs = [{ten,90}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,7,5) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 5 ,attrs = [{dodge,90}],plv = 95 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(2,1,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 6 ,attrs = [{def,315}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,2,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 6 ,attrs = [{hp_lim,6300}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,3,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 6 ,attrs = [{ten,126}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,4,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 6 ,attrs = [{dodge,126}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,5,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 6 ,attrs = [{hp_lim,6300}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,6,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 6 ,attrs = [{ten,126}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,7,6) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 6 ,attrs = [{dodge,126}],plv = 100 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(2,1,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 7 ,attrs = [{def,420}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,2,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 7 ,attrs = [{hp_lim,8400}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,3,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 7 ,attrs = [{ten,168}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,4,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 7 ,attrs = [{dodge,168}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,5,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 7 ,attrs = [{hp_lim,8400}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,6,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 7 ,attrs = [{ten,168}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,7,7) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 7 ,attrs = [{dodge,168}],plv = 105 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(2,1,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 8 ,attrs = [{def,540}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,2,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 8 ,attrs = [{hp_lim,10800}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,3,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 8 ,attrs = [{ten,216}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,4,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 8 ,attrs = [{dodge,216}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,5,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 8 ,attrs = [{hp_lim,10800}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,6,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 8 ,attrs = [{ten,216}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,7,8) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 8 ,attrs = [{dodge,216}],plv = 110 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(2,1,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 9 ,attrs = [{def,675}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,2,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 9 ,attrs = [{hp_lim,13500}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,3,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 9 ,attrs = [{ten,270}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,4,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 9 ,attrs = [{dodge,270}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,5,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 9 ,attrs = [{hp_lim,13500}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,6,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 9 ,attrs = [{ten,270}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,7,9) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 9 ,attrs = [{dodge,270}],plv = 115 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(2,1,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 1 ,lv = 10 ,attrs = [{def,825}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,2,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 2 ,lv = 10 ,attrs = [{hp_lim,16500}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,3,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 3 ,lv = 10 ,attrs = [{ten,330}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,4,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 4 ,lv = 10 ,attrs = [{dodge,330}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,5,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 5 ,lv = 10 ,attrs = [{hp_lim,16500}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,6,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 6 ,lv = 10 ,attrs = [{ten,330}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(2,7,10) -> 
   #base_meridian_upgrade{type = 2 ,subtype = 7 ,lv = 10 ,attrs = [{dodge,330}],plv = 120 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(3,1,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 1 ,attrs = [{att,40}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,2,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 1 ,attrs = [{hp_lim,400}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,3,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 1 ,attrs = [{crit,8}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,4,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 1 ,attrs = [{hit,8}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,5,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 1 ,attrs = [{att,40}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,6,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 1 ,attrs = [{hit,8}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,7,1) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 1 ,attrs = [{hp_lim,400}],plv = 1 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 40 }
;get(3,1,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 2 ,attrs = [{att,120}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,2,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 2 ,attrs = [{hp_lim,1200}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,3,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 2 ,attrs = [{crit,24}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,4,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 2 ,attrs = [{hit,24}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,5,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 2 ,attrs = [{att,120}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,6,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 2 ,attrs = [{hit,24}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,7,2) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 2 ,attrs = [{hp_lim,1200}],plv = 85 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(3,1,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 3 ,attrs = [{att,240}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,2,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 3 ,attrs = [{hp_lim,2400}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,3,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 3 ,attrs = [{crit,48}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,4,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 3 ,attrs = [{hit,48}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,5,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 3 ,attrs = [{att,240}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,6,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 3 ,attrs = [{hit,48}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,7,3) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 3 ,attrs = [{hp_lim,2400}],plv = 90 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(3,1,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 4 ,attrs = [{att,400}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,2,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 4 ,attrs = [{hp_lim,4000}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,3,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 4 ,attrs = [{crit,80}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,4,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 4 ,attrs = [{hit,80}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,5,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 4 ,attrs = [{att,400}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,6,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 4 ,attrs = [{hit,80}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,7,4) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 4 ,attrs = [{hp_lim,4000}],plv = 95 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(3,1,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 5 ,attrs = [{att,600}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,2,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 5 ,attrs = [{hp_lim,6000}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,3,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 5 ,attrs = [{crit,120}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,4,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 5 ,attrs = [{hit,120}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,5,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 5 ,attrs = [{att,600}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,6,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 5 ,attrs = [{hit,120}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,7,5) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 5 ,attrs = [{hp_lim,6000}],plv = 100 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(3,1,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 6 ,attrs = [{att,840}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,2,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 6 ,attrs = [{hp_lim,8400}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,3,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 6 ,attrs = [{crit,168}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,4,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 6 ,attrs = [{hit,168}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,5,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 6 ,attrs = [{att,840}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,6,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 6 ,attrs = [{hit,168}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,7,6) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 6 ,attrs = [{hp_lim,8400}],plv = 105 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(3,1,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 7 ,attrs = [{att,1120}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,2,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 7 ,attrs = [{hp_lim,11200}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,3,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 7 ,attrs = [{crit,224}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,4,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 7 ,attrs = [{hit,224}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,5,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 7 ,attrs = [{att,1120}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,6,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 7 ,attrs = [{hit,224}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,7,7) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 7 ,attrs = [{hp_lim,11200}],plv = 110 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(3,1,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 8 ,attrs = [{att,1440}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,2,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 8 ,attrs = [{hp_lim,14400}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,3,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 8 ,attrs = [{crit,288}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,4,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 8 ,attrs = [{hit,288}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,5,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 8 ,attrs = [{att,1440}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,6,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 8 ,attrs = [{hit,288}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,7,8) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 8 ,attrs = [{hp_lim,14400}],plv = 115 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(3,1,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 9 ,attrs = [{att,1800}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,2,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 9 ,attrs = [{hp_lim,18000}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,3,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 9 ,attrs = [{crit,360}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,4,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 9 ,attrs = [{hit,360}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,5,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 9 ,attrs = [{att,1800}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,6,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 9 ,attrs = [{hit,360}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,7,9) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 9 ,attrs = [{hp_lim,18000}],plv = 120 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(3,1,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 1 ,lv = 10 ,attrs = [{att,2200}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,2,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 2 ,lv = 10 ,attrs = [{hp_lim,22000}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,3,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 3 ,lv = 10 ,attrs = [{crit,440}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,4,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 4 ,lv = 10 ,attrs = [{hit,440}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,5,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 5 ,lv = 10 ,attrs = [{att,2200}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,6,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 6 ,lv = 10 ,attrs = [{hit,440}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(3,7,10) -> 
   #base_meridian_upgrade{type = 3 ,subtype = 7 ,lv = 10 ,attrs = [{hp_lim,22000}],plv = 125 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,1,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 1 ,attrs = [{att,50}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,2,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 1 ,attrs = [{def,25}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,3,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 1 ,attrs = [{hp_lim,500}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,4,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 1 ,attrs = [{hit,10}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,5,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 1 ,attrs = [{hp_lim,500}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,6,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 1 ,attrs = [{att,50}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,7,1) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 1 ,attrs = [{def,25}],plv = 85 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 50 }
;get(4,1,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 2 ,attrs = [{att,150}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,2,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 2 ,attrs = [{def,75}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,3,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 2 ,attrs = [{hp_lim,1500}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,4,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 2 ,attrs = [{hit,30}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,5,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 2 ,attrs = [{hp_lim,1500}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,6,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 2 ,attrs = [{att,150}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,7,2) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 2 ,attrs = [{def,75}],plv = 90 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(4,1,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 3 ,attrs = [{att,300}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,2,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 3 ,attrs = [{def,150}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,3,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 3 ,attrs = [{hp_lim,3000}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,4,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 3 ,attrs = [{hit,60}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,5,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 3 ,attrs = [{hp_lim,3000}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,6,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 3 ,attrs = [{att,300}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,7,3) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 3 ,attrs = [{def,150}],plv = 95 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 150 }
;get(4,1,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 4 ,attrs = [{att,500}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,2,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 4 ,attrs = [{def,250}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,3,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 4 ,attrs = [{hp_lim,5000}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,4,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 4 ,attrs = [{hit,100}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,5,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 4 ,attrs = [{hp_lim,5000}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,6,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 4 ,attrs = [{att,500}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,7,4) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 4 ,attrs = [{def,250}],plv = 100 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(4,1,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 5 ,attrs = [{att,750}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,2,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 5 ,attrs = [{def,375}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,3,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 5 ,attrs = [{hp_lim,7500}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,4,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 5 ,attrs = [{hit,150}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,5,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 5 ,attrs = [{hp_lim,7500}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,6,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 5 ,attrs = [{att,750}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,7,5) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 5 ,attrs = [{def,375}],plv = 105 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 250 }
;get(4,1,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 6 ,attrs = [{att,1050}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,2,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 6 ,attrs = [{def,525}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,3,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 6 ,attrs = [{hp_lim,10500}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,4,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 6 ,attrs = [{hit,210}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,5,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 6 ,attrs = [{hp_lim,10500}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,6,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 6 ,attrs = [{att,1050}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,7,6) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 6 ,attrs = [{def,525}],plv = 110 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(4,1,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 7 ,attrs = [{att,1400}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,2,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 7 ,attrs = [{def,700}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,3,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 7 ,attrs = [{hp_lim,14000}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,4,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 7 ,attrs = [{hit,280}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,5,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 7 ,attrs = [{hp_lim,14000}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,6,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 7 ,attrs = [{att,1400}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,7,7) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 7 ,attrs = [{def,700}],plv = 115 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(4,1,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 8 ,attrs = [{att,1800}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,2,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 8 ,attrs = [{def,900}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,3,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 8 ,attrs = [{hp_lim,18000}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,4,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 8 ,attrs = [{hit,360}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,5,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 8 ,attrs = [{hp_lim,18000}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,6,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 8 ,attrs = [{att,1800}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,7,8) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 8 ,attrs = [{def,900}],plv = 120 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(4,1,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 9 ,attrs = [{att,2250}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,2,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 9 ,attrs = [{def,1125}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,3,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 9 ,attrs = [{hp_lim,22500}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,4,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 9 ,attrs = [{hit,450}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,5,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 9 ,attrs = [{hp_lim,22500}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,6,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 9 ,attrs = [{att,2250}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,7,9) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 9 ,attrs = [{def,1125}],plv = 125 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(4,1,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 1 ,lv = 10 ,attrs = [{att,2750}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,2,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 2 ,lv = 10 ,attrs = [{def,1375}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,3,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 3 ,lv = 10 ,attrs = [{hp_lim,27500}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,4,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 4 ,lv = 10 ,attrs = [{hit,550}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,5,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 5 ,lv = 10 ,attrs = [{hp_lim,27500}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,6,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 6 ,lv = 10 ,attrs = [{att,2750}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(4,7,10) -> 
   #base_meridian_upgrade{type = 4 ,subtype = 7 ,lv = 10 ,attrs = [{def,1375}],plv = 130 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(5,1,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 1 ,attrs = [{def,30}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,2,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 1 ,attrs = [{hp_lim,600}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,3,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 1 ,attrs = [{ten,12}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,4,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 1 ,attrs = [{dodge,12}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,5,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 1 ,attrs = [{def,30}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,6,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 1 ,attrs = [{hp_lim,600}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,7,1) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 1 ,attrs = [{dodge,12}],plv = 90 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 60 }
;get(5,1,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 2 ,attrs = [{def,90}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,2,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 2 ,attrs = [{hp_lim,1800}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,3,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 2 ,attrs = [{ten,36}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,4,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 2 ,attrs = [{dodge,36}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,5,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 2 ,attrs = [{def,90}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,6,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 2 ,attrs = [{hp_lim,1800}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,7,2) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 2 ,attrs = [{dodge,36}],plv = 95 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 120 }
;get(5,1,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 3 ,attrs = [{def,180}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,2,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 3 ,attrs = [{hp_lim,3600}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,3,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 3 ,attrs = [{ten,72}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,4,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 3 ,attrs = [{dodge,72}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,5,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 3 ,attrs = [{def,180}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,6,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 3 ,attrs = [{hp_lim,3600}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,7,3) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 3 ,attrs = [{dodge,72}],plv = 100 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(5,1,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 4 ,attrs = [{def,300}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,2,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 4 ,attrs = [{hp_lim,6000}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,3,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 4 ,attrs = [{ten,120}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,4,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 4 ,attrs = [{dodge,120}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,5,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 4 ,attrs = [{def,300}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,6,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 4 ,attrs = [{hp_lim,6000}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,7,4) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 4 ,attrs = [{dodge,120}],plv = 105 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(5,1,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 5 ,attrs = [{def,450}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,2,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 5 ,attrs = [{hp_lim,9000}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,3,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 5 ,attrs = [{ten,180}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,4,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 5 ,attrs = [{dodge,180}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,5,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 5 ,attrs = [{def,450}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,6,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 5 ,attrs = [{hp_lim,9000}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,7,5) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 5 ,attrs = [{dodge,180}],plv = 110 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(5,1,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 6 ,attrs = [{def,630}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,2,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 6 ,attrs = [{hp_lim,12600}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,3,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 6 ,attrs = [{ten,252}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,4,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 6 ,attrs = [{dodge,252}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,5,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 6 ,attrs = [{def,630}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,6,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 6 ,attrs = [{hp_lim,12600}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,7,6) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 6 ,attrs = [{dodge,252}],plv = 115 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(5,1,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 7 ,attrs = [{def,840}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,2,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 7 ,attrs = [{hp_lim,16800}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,3,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 7 ,attrs = [{ten,336}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,4,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 7 ,attrs = [{dodge,336}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,5,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 7 ,attrs = [{def,840}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,6,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 7 ,attrs = [{hp_lim,16800}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,7,7) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 7 ,attrs = [{dodge,336}],plv = 120 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(5,1,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 8 ,attrs = [{def,1080}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,2,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 8 ,attrs = [{hp_lim,21600}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,3,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 8 ,attrs = [{ten,432}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,4,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 8 ,attrs = [{dodge,432}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,5,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 8 ,attrs = [{def,1080}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,6,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 8 ,attrs = [{hp_lim,21600}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,7,8) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 8 ,attrs = [{dodge,432}],plv = 125 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(5,1,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 9 ,attrs = [{def,1350}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,2,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 9 ,attrs = [{hp_lim,27000}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,3,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 9 ,attrs = [{ten,540}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,4,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 9 ,attrs = [{dodge,540}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,5,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 9 ,attrs = [{def,1350}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,6,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 9 ,attrs = [{hp_lim,27000}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,7,9) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 9 ,attrs = [{dodge,540}],plv = 130 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(5,1,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 1 ,lv = 10 ,attrs = [{def,1650}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,2,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 2 ,lv = 10 ,attrs = [{hp_lim,33000}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,3,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 3 ,lv = 10 ,attrs = [{ten,660}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,4,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 4 ,lv = 10 ,attrs = [{dodge,660}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,5,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 5 ,lv = 10 ,attrs = [{def,1650}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,6,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 6 ,lv = 10 ,attrs = [{hp_lim,33000}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(5,7,10) -> 
   #base_meridian_upgrade{type = 5 ,subtype = 7 ,lv = 10 ,attrs = [{dodge,660}],plv = 135 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(6,1,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 1 ,attrs = [{att,70}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,2,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 1 ,attrs = [{hit,14}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,3,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 1 ,attrs = [{crit,14}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,4,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 1 ,attrs = [{def,35}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,5,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 1 ,attrs = [{def,35}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,6,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 1 ,attrs = [{def,35}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,7,1) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 1 ,attrs = [{att,70}],plv = 95 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 70 }
;get(6,1,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 2 ,attrs = [{att,210}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,2,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 2 ,attrs = [{hit,42}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,3,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 2 ,attrs = [{crit,42}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,4,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 2 ,attrs = [{def,105}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,5,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 2 ,attrs = [{def,105}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,6,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 2 ,attrs = [{def,105}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,7,2) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 2 ,attrs = [{att,210}],plv = 100 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 140 }
;get(6,1,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 3 ,attrs = [{att,420}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,2,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 3 ,attrs = [{hit,84}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,3,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 3 ,attrs = [{crit,84}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,4,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 3 ,attrs = [{def,210}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,5,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 3 ,attrs = [{def,210}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,6,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 3 ,attrs = [{def,210}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,7,3) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 3 ,attrs = [{att,420}],plv = 105 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 210 }
;get(6,1,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 4 ,attrs = [{att,700}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,2,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 4 ,attrs = [{hit,140}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,3,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 4 ,attrs = [{crit,140}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,4,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 4 ,attrs = [{def,350}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,5,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 4 ,attrs = [{def,350}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,6,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 4 ,attrs = [{def,350}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,7,4) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 4 ,attrs = [{att,700}],plv = 110 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 280 }
;get(6,1,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 5 ,attrs = [{att,1050}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,2,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 5 ,attrs = [{hit,210}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,3,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 5 ,attrs = [{crit,210}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,4,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 5 ,attrs = [{def,525}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,5,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 5 ,attrs = [{def,525}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,6,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 5 ,attrs = [{def,525}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,7,5) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 5 ,attrs = [{att,1050}],plv = 115 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 350 }
;get(6,1,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 6 ,attrs = [{att,1470}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,2,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 6 ,attrs = [{hit,294}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,3,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 6 ,attrs = [{crit,294}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,4,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 6 ,attrs = [{def,735}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,5,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 6 ,attrs = [{def,735}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,6,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 6 ,attrs = [{def,735}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,7,6) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 6 ,attrs = [{att,1470}],plv = 120 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 420 }
;get(6,1,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 7 ,attrs = [{att,1960}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,2,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 7 ,attrs = [{hit,392}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,3,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 7 ,attrs = [{crit,392}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,4,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 7 ,attrs = [{def,980}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,5,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 7 ,attrs = [{def,980}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,6,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 7 ,attrs = [{def,980}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,7,7) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 7 ,attrs = [{att,1960}],plv = 125 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 490 }
;get(6,1,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 8 ,attrs = [{att,2520}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,2,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 8 ,attrs = [{hit,504}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,3,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 8 ,attrs = [{crit,504}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,4,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 8 ,attrs = [{def,1260}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,5,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 8 ,attrs = [{def,1260}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,6,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 8 ,attrs = [{def,1260}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,7,8) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 8 ,attrs = [{att,2520}],plv = 130 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(6,1,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 9 ,attrs = [{att,3150}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,2,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 9 ,attrs = [{hit,630}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,3,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 9 ,attrs = [{crit,630}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,4,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 9 ,attrs = [{def,1575}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,5,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 9 ,attrs = [{def,1575}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,6,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 9 ,attrs = [{def,1575}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,7,9) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 9 ,attrs = [{att,3150}],plv = 135 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(6,1,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 1 ,lv = 10 ,attrs = [{att,3850}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,2,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 2 ,lv = 10 ,attrs = [{hit,770}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,3,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 3 ,lv = 10 ,attrs = [{crit,770}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,4,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 4 ,lv = 10 ,attrs = [{def,1925}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,5,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 5 ,lv = 10 ,attrs = [{def,1925}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,6,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 6 ,lv = 10 ,attrs = [{def,1925}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(6,7,10) -> 
   #base_meridian_upgrade{type = 6 ,subtype = 7 ,lv = 10 ,attrs = [{att,3850}],plv = 140 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(7,1,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 1 ,attrs = [{att,80}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,2,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 1 ,attrs = [{hp_lim,800}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,3,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 1 ,attrs = [{ten,16}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,4,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 1 ,attrs = [{hit,16}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,5,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 1 ,attrs = [{hp_lim,800}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,6,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 1 ,attrs = [{att,80}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,7,1) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 1 ,attrs = [{ten,16}],plv = 100 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 80 }
;get(7,1,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 2 ,attrs = [{att,240}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,2,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 2 ,attrs = [{hp_lim,2400}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,3,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 2 ,attrs = [{ten,48}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,4,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 2 ,attrs = [{hit,48}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,5,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 2 ,attrs = [{hp_lim,2400}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,6,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 2 ,attrs = [{att,240}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,7,2) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 2 ,attrs = [{ten,48}],plv = 105 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 160 }
;get(7,1,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 3 ,attrs = [{att,480}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,2,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 3 ,attrs = [{hp_lim,4800}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,3,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 3 ,attrs = [{ten,96}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,4,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 3 ,attrs = [{hit,96}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,5,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 3 ,attrs = [{hp_lim,4800}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,6,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 3 ,attrs = [{att,480}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,7,3) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 3 ,attrs = [{ten,96}],plv = 110 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 240 }
;get(7,1,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 4 ,attrs = [{att,800}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,2,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 4 ,attrs = [{hp_lim,8000}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,3,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 4 ,attrs = [{ten,160}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,4,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 4 ,attrs = [{hit,160}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,5,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 4 ,attrs = [{hp_lim,8000}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,6,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 4 ,attrs = [{att,800}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,7,4) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 4 ,attrs = [{ten,160}],plv = 115 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 320 }
;get(7,1,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 5 ,attrs = [{att,1200}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,2,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 5 ,attrs = [{hp_lim,12000}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,3,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 5 ,attrs = [{ten,240}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,4,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 5 ,attrs = [{hit,240}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,5,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 5 ,attrs = [{hp_lim,12000}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,6,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 5 ,attrs = [{att,1200}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,7,5) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 5 ,attrs = [{ten,240}],plv = 120 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(7,1,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 6 ,attrs = [{att,1680}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,2,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 6 ,attrs = [{hp_lim,16800}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,3,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 6 ,attrs = [{ten,336}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,4,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 6 ,attrs = [{hit,336}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,5,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 6 ,attrs = [{hp_lim,16800}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,6,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 6 ,attrs = [{att,1680}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,7,6) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 6 ,attrs = [{ten,336}],plv = 125 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 480 }
;get(7,1,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 7 ,attrs = [{att,2240}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,2,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 7 ,attrs = [{hp_lim,22400}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,3,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 7 ,attrs = [{ten,448}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,4,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 7 ,attrs = [{hit,448}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,5,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 7 ,attrs = [{hp_lim,22400}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,6,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 7 ,attrs = [{att,2240}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,7,7) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 7 ,attrs = [{ten,448}],plv = 130 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 560 }
;get(7,1,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 8 ,attrs = [{att,2880}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,2,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 8 ,attrs = [{hp_lim,28800}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,3,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 8 ,attrs = [{ten,576}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,4,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 8 ,attrs = [{hit,576}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,5,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 8 ,attrs = [{hp_lim,28800}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,6,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 8 ,attrs = [{att,2880}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,7,8) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 8 ,attrs = [{ten,576}],plv = 135 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 640 }
;get(7,1,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 9 ,attrs = [{att,3600}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,2,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 9 ,attrs = [{hp_lim,36000}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,3,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 9 ,attrs = [{ten,720}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,4,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 9 ,attrs = [{hit,720}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,5,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 9 ,attrs = [{hp_lim,36000}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,6,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 9 ,attrs = [{att,3600}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,7,9) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 9 ,attrs = [{ten,720}],plv = 140 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(7,1,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 1 ,lv = 10 ,attrs = [{att,4400}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,2,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 2 ,lv = 10 ,attrs = [{hp_lim,44000}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,3,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 3 ,lv = 10 ,attrs = [{ten,880}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,4,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 4 ,lv = 10 ,attrs = [{hit,880}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,5,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 5 ,lv = 10 ,attrs = [{hp_lim,44000}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,6,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 6 ,lv = 10 ,attrs = [{att,4400}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(7,7,10) -> 
   #base_meridian_upgrade{type = 7 ,subtype = 7 ,lv = 10 ,attrs = [{ten,880}],plv = 145 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(8,1,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 1 ,attrs = [{crit,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,2,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 1 ,attrs = [{ten,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,3,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 1 ,attrs = [{hit,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,4,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 1 ,attrs = [{dodge,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,5,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 1 ,attrs = [{dodge,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,6,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 1 ,attrs = [{ten,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,7,1) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 1 ,attrs = [{crit,18}],plv = 105 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 90 }
;get(8,1,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 2 ,attrs = [{crit,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,2,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 2 ,attrs = [{ten,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,3,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 2 ,attrs = [{hit,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,4,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 2 ,attrs = [{dodge,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,5,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 2 ,attrs = [{dodge,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,6,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 2 ,attrs = [{ten,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,7,2) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 2 ,attrs = [{crit,54}],plv = 110 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 180 }
;get(8,1,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 3 ,attrs = [{crit,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,2,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 3 ,attrs = [{ten,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,3,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 3 ,attrs = [{hit,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,4,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 3 ,attrs = [{dodge,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,5,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 3 ,attrs = [{dodge,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,6,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 3 ,attrs = [{ten,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,7,3) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 3 ,attrs = [{crit,108}],plv = 115 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 270 }
;get(8,1,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 4 ,attrs = [{crit,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,2,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 4 ,attrs = [{ten,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,3,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 4 ,attrs = [{hit,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,4,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 4 ,attrs = [{dodge,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,5,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 4 ,attrs = [{dodge,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,6,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 4 ,attrs = [{ten,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,7,4) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 4 ,attrs = [{crit,180}],plv = 120 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 360 }
;get(8,1,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 5 ,attrs = [{crit,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,2,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 5 ,attrs = [{ten,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,3,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 5 ,attrs = [{hit,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,4,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 5 ,attrs = [{dodge,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,5,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 5 ,attrs = [{dodge,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,6,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 5 ,attrs = [{ten,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,7,5) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 5 ,attrs = [{crit,270}],plv = 125 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 450 }
;get(8,1,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 6 ,attrs = [{crit,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,2,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 6 ,attrs = [{ten,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,3,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 6 ,attrs = [{hit,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,4,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 6 ,attrs = [{dodge,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,5,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 6 ,attrs = [{dodge,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,6,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 6 ,attrs = [{ten,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,7,6) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 6 ,attrs = [{crit,378}],plv = 130 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 540 }
;get(8,1,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 7 ,attrs = [{crit,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,2,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 7 ,attrs = [{ten,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,3,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 7 ,attrs = [{hit,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,4,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 7 ,attrs = [{dodge,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,5,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 7 ,attrs = [{dodge,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,6,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 7 ,attrs = [{ten,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,7,7) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 7 ,attrs = [{crit,504}],plv = 135 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 630 }
;get(8,1,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 8 ,attrs = [{crit,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,2,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 8 ,attrs = [{ten,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,3,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 8 ,attrs = [{hit,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,4,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 8 ,attrs = [{dodge,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,5,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 8 ,attrs = [{dodge,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,6,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 8 ,attrs = [{ten,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,7,8) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 8 ,attrs = [{crit,648}],plv = 140 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 720 }
;get(8,1,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 9 ,attrs = [{crit,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,2,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 9 ,attrs = [{ten,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,3,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 9 ,attrs = [{hit,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,4,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 9 ,attrs = [{dodge,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,5,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 9 ,attrs = [{dodge,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,6,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 9 ,attrs = [{ten,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,7,9) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 9 ,attrs = [{crit,810}],plv = 145 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 810 }
;get(8,1,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 1 ,lv = 10 ,attrs = [{crit,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,2,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 2 ,lv = 10 ,attrs = [{ten,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,3,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 3 ,lv = 10 ,attrs = [{hit,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,4,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 4 ,lv = 10 ,attrs = [{dodge,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,5,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 5 ,lv = 10 ,attrs = [{dodge,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,6,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 6 ,lv = 10 ,attrs = [{ten,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(8,7,10) -> 
   #base_meridian_upgrade{type = 8 ,subtype = 7 ,lv = 10 ,attrs = [{crit,990}],plv = 150 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,1,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 1 ,attrs = [{att,100}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,2,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 1 ,attrs = [{def,50}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,3,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 1 ,attrs = [{crit,20}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,4,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 1 ,attrs = [{hit,20}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,5,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 1 ,attrs = [{def,50}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,6,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 1 ,attrs = [{crit,20}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,7,1) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 1 ,attrs = [{att,100}],plv = 110 ,break_lv = 0 ,ratio = 100 ,cd = 60 ,cost_num = 100 }
;get(9,1,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 2 ,attrs = [{att,300}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,2,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 2 ,attrs = [{def,150}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,3,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 2 ,attrs = [{crit,60}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,4,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 2 ,attrs = [{hit,60}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,5,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 2 ,attrs = [{def,150}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,6,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 2 ,attrs = [{crit,60}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,7,2) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 2 ,attrs = [{att,300}],plv = 115 ,break_lv = 1 ,ratio = 100 ,cd = 60 ,cost_num = 200 }
;get(9,1,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 3 ,attrs = [{att,600}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,2,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 3 ,attrs = [{def,300}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,3,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 3 ,attrs = [{crit,120}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,4,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 3 ,attrs = [{hit,120}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,5,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 3 ,attrs = [{def,300}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,6,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 3 ,attrs = [{crit,120}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,7,3) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 3 ,attrs = [{att,600}],plv = 120 ,break_lv = 2 ,ratio = 100 ,cd = 60 ,cost_num = 300 }
;get(9,1,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 4 ,attrs = [{att,1000}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,2,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 4 ,attrs = [{def,500}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,3,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 4 ,attrs = [{crit,200}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,4,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 4 ,attrs = [{hit,200}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,5,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 4 ,attrs = [{def,500}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,6,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 4 ,attrs = [{crit,200}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,7,4) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 4 ,attrs = [{att,1000}],plv = 125 ,break_lv = 3 ,ratio = 100 ,cd = 60 ,cost_num = 400 }
;get(9,1,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 5 ,attrs = [{att,1500}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,2,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 5 ,attrs = [{def,750}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,3,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 5 ,attrs = [{crit,300}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,4,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 5 ,attrs = [{hit,300}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,5,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 5 ,attrs = [{def,750}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,6,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 5 ,attrs = [{crit,300}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,7,5) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 5 ,attrs = [{att,1500}],plv = 130 ,break_lv = 4 ,ratio = 100 ,cd = 60 ,cost_num = 500 }
;get(9,1,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 6 ,attrs = [{att,2100}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,2,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 6 ,attrs = [{def,1050}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,3,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 6 ,attrs = [{crit,420}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,4,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 6 ,attrs = [{hit,420}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,5,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 6 ,attrs = [{def,1050}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,6,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 6 ,attrs = [{crit,420}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,7,6) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 6 ,attrs = [{att,2100}],plv = 135 ,break_lv = 5 ,ratio = 100 ,cd = 60 ,cost_num = 600 }
;get(9,1,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 7 ,attrs = [{att,2800}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,2,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 7 ,attrs = [{def,1400}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,3,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 7 ,attrs = [{crit,560}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,4,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 7 ,attrs = [{hit,560}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,5,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 7 ,attrs = [{def,1400}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,6,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 7 ,attrs = [{crit,560}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,7,7) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 7 ,attrs = [{att,2800}],plv = 140 ,break_lv = 6 ,ratio = 100 ,cd = 60 ,cost_num = 700 }
;get(9,1,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 8 ,attrs = [{att,3600}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,2,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 8 ,attrs = [{def,1800}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,3,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 8 ,attrs = [{crit,720}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,4,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 8 ,attrs = [{hit,720}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,5,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 8 ,attrs = [{def,1800}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,6,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 8 ,attrs = [{crit,720}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,7,8) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 8 ,attrs = [{att,3600}],plv = 145 ,break_lv = 7 ,ratio = 100 ,cd = 60 ,cost_num = 800 }
;get(9,1,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 9 ,attrs = [{att,4500}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,2,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 9 ,attrs = [{def,2250}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,3,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 9 ,attrs = [{crit,900}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,4,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 9 ,attrs = [{hit,900}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,5,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 9 ,attrs = [{def,2250}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,6,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 9 ,attrs = [{crit,900}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,7,9) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 9 ,attrs = [{att,4500}],plv = 150 ,break_lv = 8 ,ratio = 100 ,cd = 60 ,cost_num = 900 }
;get(9,1,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 1 ,lv = 10 ,attrs = [{att,5500}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,2,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 2 ,lv = 10 ,attrs = [{def,2750}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,3,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 3 ,lv = 10 ,attrs = [{crit,1100}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,4,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 4 ,lv = 10 ,attrs = [{hit,1100}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,5,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 5 ,lv = 10 ,attrs = [{def,2750}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,6,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 6 ,lv = 10 ,attrs = [{crit,1100}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(9,7,10) -> 
   #base_meridian_upgrade{type = 9 ,subtype = 7 ,lv = 10 ,attrs = [{att,5500}],plv = 155 ,break_lv = 9 ,ratio = 100 ,cd = 60 ,cost_num = 1000 }
;get(_,_,_) -> [].
