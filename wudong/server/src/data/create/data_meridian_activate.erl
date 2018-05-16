%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_meridian_activate
	%%% @Created : 2017-09-19 21:23:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_meridian_activate).
-export([type_list/0]).
-export([get/1]).
-include("common.hrl").
-include("meridian.hrl").

    type_list() ->
    [1,2,3,4,5,6,7,8,9].
get(1) -> 
   #base_meridian_activate{type = 1 ,lv_need = 0 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{att,20},{def,10},{hp_lim,200},{crit,4}],name = ?T("初识") }
;get(2) -> 
   #base_meridian_activate{type = 2 ,lv_need = 8 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{def,10},{ten,4},{hp_lim,200},{dodge,4}],name = ?T("聆音") }
;get(3) -> 
   #base_meridian_activate{type = 3 ,lv_need = 8 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{att,20},{hp_lim,200},{crit,4},{hit,4}],name = ?T("破望") }
;get(4) -> 
   #base_meridian_activate{type = 4 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{att,20},{def,10},{hp_lim,200},{hit,4}],name = ?T("知微") }
;get(5) -> 
   #base_meridian_activate{type = 5 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{def,10},{hp_lim,200},{ten,4},{dodge,4}],name = ?T("堪心") }
;get(6) -> 
   #base_meridian_activate{type = 6 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{att,20},{def,10},{hit,4},{crit,4}],name = ?T("登堂") }
;get(7) -> 
   #base_meridian_activate{type = 7 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{att,20},{hp_lim,200},{ten,4},{hit,4}],name = ?T("舍归") }
;get(8) -> 
   #base_meridian_activate{type = 8 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{ten,5},{dodge,5},{hit,5},{crit,5}],name = ?T("造化") }
;get(9) -> 
   #base_meridian_activate{type = 9 ,lv_need = 16 ,lv_max = 0 ,break_lv_max = 10 ,subtype_lv_max = 10 ,attrs = [{def,12},{hp_lim,240},{ten,5},{dodge,5}],name = ?T("飞升") }
;get(_) -> [].
