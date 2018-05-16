%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_meridian_break
	%%% @Created : 2017-09-19 21:23:49
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_meridian_break).
-export([get_max_break_lv/0]).
-export([get/2]).
-include("common.hrl").
-include("meridian.hrl").
get_max_break_lv() -> 10.
get(1,1) -> 
   #base_meridian_break{type = 1 ,break_lv = 1 ,plv = 1 ,ratio = 100 ,cd = 60 ,goods = {6002001,1} ,attr_per = 5 ,lv_total = 7 }
;get(1,2) -> 
   #base_meridian_break{type = 1 ,break_lv = 2 ,plv = 1 ,ratio = 66 ,cd = 60 ,goods = {6002001,2} ,attr_per = 10 ,lv_total = 15 }
;get(1,3) -> 
   #base_meridian_break{type = 1 ,break_lv = 3 ,plv = 1 ,ratio = 40 ,cd = 60 ,goods = {6002001,4} ,attr_per = 15 ,lv_total = 23 }
;get(1,4) -> 
   #base_meridian_break{type = 1 ,break_lv = 4 ,plv = 85 ,ratio = 20 ,cd = 60 ,goods = {6002001,4} ,attr_per = 20 ,lv_total = 31 }
;get(1,5) -> 
   #base_meridian_break{type = 1 ,break_lv = 5 ,plv = 90 ,ratio = 15 ,cd = 60 ,goods = {6002001,6} ,attr_per = 25 ,lv_total = 39 }
;get(1,6) -> 
   #base_meridian_break{type = 1 ,break_lv = 6 ,plv = 95 ,ratio = 12 ,cd = 60 ,goods = {6002001,6} ,attr_per = 30 ,lv_total = 47 }
;get(1,7) -> 
   #base_meridian_break{type = 1 ,break_lv = 7 ,plv = 100 ,ratio = 10 ,cd = 60 ,goods = {6002001,8} ,attr_per = 35 ,lv_total = 55 }
;get(1,8) -> 
   #base_meridian_break{type = 1 ,break_lv = 8 ,plv = 105 ,ratio = 10 ,cd = 60 ,goods = {6002001,8} ,attr_per = 40 ,lv_total = 63 }
;get(1,9) -> 
   #base_meridian_break{type = 1 ,break_lv = 9 ,plv = 110 ,ratio = 10 ,cd = 60 ,goods = {6002001,10} ,attr_per = 45 ,lv_total = 71 }
;get(1,10) -> 
   #base_meridian_break{type = 1 ,break_lv = 10 ,plv = 115 ,ratio = 10 ,cd = 60 ,goods = {6002001,10} ,attr_per = 50 ,lv_total = 79 }
;get(2,1) -> 
   #base_meridian_break{type = 2 ,break_lv = 1 ,plv = 1 ,ratio = 100 ,cd = 60 ,goods = {6002002,1} ,attr_per = 5 ,lv_total = 7 }
;get(2,2) -> 
   #base_meridian_break{type = 2 ,break_lv = 2 ,plv = 1 ,ratio = 66 ,cd = 60 ,goods = {6002002,2} ,attr_per = 10 ,lv_total = 15 }
;get(2,3) -> 
   #base_meridian_break{type = 2 ,break_lv = 3 ,plv = 85 ,ratio = 40 ,cd = 60 ,goods = {6002002,4} ,attr_per = 15 ,lv_total = 23 }
;get(2,4) -> 
   #base_meridian_break{type = 2 ,break_lv = 4 ,plv = 90 ,ratio = 20 ,cd = 60 ,goods = {6002002,4} ,attr_per = 20 ,lv_total = 31 }
;get(2,5) -> 
   #base_meridian_break{type = 2 ,break_lv = 5 ,plv = 95 ,ratio = 15 ,cd = 60 ,goods = {6002002,6} ,attr_per = 25 ,lv_total = 39 }
;get(2,6) -> 
   #base_meridian_break{type = 2 ,break_lv = 6 ,plv = 100 ,ratio = 12 ,cd = 60 ,goods = {6002002,6} ,attr_per = 30 ,lv_total = 47 }
;get(2,7) -> 
   #base_meridian_break{type = 2 ,break_lv = 7 ,plv = 105 ,ratio = 10 ,cd = 60 ,goods = {6002002,8} ,attr_per = 35 ,lv_total = 55 }
;get(2,8) -> 
   #base_meridian_break{type = 2 ,break_lv = 8 ,plv = 110 ,ratio = 10 ,cd = 60 ,goods = {6002002,8} ,attr_per = 40 ,lv_total = 63 }
;get(2,9) -> 
   #base_meridian_break{type = 2 ,break_lv = 9 ,plv = 115 ,ratio = 10 ,cd = 60 ,goods = {6002002,10} ,attr_per = 45 ,lv_total = 71 }
;get(2,10) -> 
   #base_meridian_break{type = 2 ,break_lv = 10 ,plv = 120 ,ratio = 10 ,cd = 60 ,goods = {6002002,10} ,attr_per = 50 ,lv_total = 79 }
;get(3,1) -> 
   #base_meridian_break{type = 3 ,break_lv = 1 ,plv = 1 ,ratio = 100 ,cd = 60 ,goods = {6002003,1} ,attr_per = 5 ,lv_total = 7 }
;get(3,2) -> 
   #base_meridian_break{type = 3 ,break_lv = 2 ,plv = 85 ,ratio = 66 ,cd = 60 ,goods = {6002003,2} ,attr_per = 10 ,lv_total = 15 }
;get(3,3) -> 
   #base_meridian_break{type = 3 ,break_lv = 3 ,plv = 90 ,ratio = 40 ,cd = 60 ,goods = {6002003,4} ,attr_per = 15 ,lv_total = 23 }
;get(3,4) -> 
   #base_meridian_break{type = 3 ,break_lv = 4 ,plv = 95 ,ratio = 20 ,cd = 60 ,goods = {6002003,4} ,attr_per = 20 ,lv_total = 31 }
;get(3,5) -> 
   #base_meridian_break{type = 3 ,break_lv = 5 ,plv = 100 ,ratio = 15 ,cd = 60 ,goods = {6002003,6} ,attr_per = 25 ,lv_total = 39 }
;get(3,6) -> 
   #base_meridian_break{type = 3 ,break_lv = 6 ,plv = 105 ,ratio = 12 ,cd = 60 ,goods = {6002003,6} ,attr_per = 30 ,lv_total = 47 }
;get(3,7) -> 
   #base_meridian_break{type = 3 ,break_lv = 7 ,plv = 110 ,ratio = 10 ,cd = 60 ,goods = {6002003,8} ,attr_per = 35 ,lv_total = 55 }
;get(3,8) -> 
   #base_meridian_break{type = 3 ,break_lv = 8 ,plv = 115 ,ratio = 10 ,cd = 60 ,goods = {6002003,8} ,attr_per = 40 ,lv_total = 63 }
;get(3,9) -> 
   #base_meridian_break{type = 3 ,break_lv = 9 ,plv = 120 ,ratio = 10 ,cd = 60 ,goods = {6002003,10} ,attr_per = 45 ,lv_total = 71 }
;get(3,10) -> 
   #base_meridian_break{type = 3 ,break_lv = 10 ,plv = 125 ,ratio = 10 ,cd = 60 ,goods = {6002003,10} ,attr_per = 50 ,lv_total = 79 }
;get(4,1) -> 
   #base_meridian_break{type = 4 ,break_lv = 1 ,plv = 85 ,ratio = 100 ,cd = 60 ,goods = {6002004,1} ,attr_per = 5 ,lv_total = 7 }
;get(4,2) -> 
   #base_meridian_break{type = 4 ,break_lv = 2 ,plv = 90 ,ratio = 66 ,cd = 60 ,goods = {6002004,2} ,attr_per = 10 ,lv_total = 15 }
;get(4,3) -> 
   #base_meridian_break{type = 4 ,break_lv = 3 ,plv = 95 ,ratio = 40 ,cd = 60 ,goods = {6002004,4} ,attr_per = 15 ,lv_total = 23 }
;get(4,4) -> 
   #base_meridian_break{type = 4 ,break_lv = 4 ,plv = 100 ,ratio = 20 ,cd = 60 ,goods = {6002004,4} ,attr_per = 20 ,lv_total = 31 }
;get(4,5) -> 
   #base_meridian_break{type = 4 ,break_lv = 5 ,plv = 105 ,ratio = 15 ,cd = 60 ,goods = {6002004,6} ,attr_per = 25 ,lv_total = 39 }
;get(4,6) -> 
   #base_meridian_break{type = 4 ,break_lv = 6 ,plv = 110 ,ratio = 12 ,cd = 60 ,goods = {6002004,6} ,attr_per = 30 ,lv_total = 47 }
;get(4,7) -> 
   #base_meridian_break{type = 4 ,break_lv = 7 ,plv = 115 ,ratio = 10 ,cd = 60 ,goods = {6002004,8} ,attr_per = 35 ,lv_total = 55 }
;get(4,8) -> 
   #base_meridian_break{type = 4 ,break_lv = 8 ,plv = 120 ,ratio = 10 ,cd = 60 ,goods = {6002004,8} ,attr_per = 40 ,lv_total = 63 }
;get(4,9) -> 
   #base_meridian_break{type = 4 ,break_lv = 9 ,plv = 125 ,ratio = 10 ,cd = 60 ,goods = {6002004,10} ,attr_per = 45 ,lv_total = 71 }
;get(4,10) -> 
   #base_meridian_break{type = 4 ,break_lv = 10 ,plv = 130 ,ratio = 10 ,cd = 60 ,goods = {6002004,10} ,attr_per = 50 ,lv_total = 79 }
;get(5,1) -> 
   #base_meridian_break{type = 5 ,break_lv = 1 ,plv = 90 ,ratio = 100 ,cd = 60 ,goods = {6002005,1} ,attr_per = 5 ,lv_total = 7 }
;get(5,2) -> 
   #base_meridian_break{type = 5 ,break_lv = 2 ,plv = 95 ,ratio = 66 ,cd = 60 ,goods = {6002005,2} ,attr_per = 10 ,lv_total = 15 }
;get(5,3) -> 
   #base_meridian_break{type = 5 ,break_lv = 3 ,plv = 100 ,ratio = 40 ,cd = 60 ,goods = {6002005,4} ,attr_per = 15 ,lv_total = 23 }
;get(5,4) -> 
   #base_meridian_break{type = 5 ,break_lv = 4 ,plv = 105 ,ratio = 20 ,cd = 60 ,goods = {6002005,4} ,attr_per = 20 ,lv_total = 31 }
;get(5,5) -> 
   #base_meridian_break{type = 5 ,break_lv = 5 ,plv = 110 ,ratio = 15 ,cd = 60 ,goods = {6002005,6} ,attr_per = 25 ,lv_total = 39 }
;get(5,6) -> 
   #base_meridian_break{type = 5 ,break_lv = 6 ,plv = 115 ,ratio = 12 ,cd = 60 ,goods = {6002005,6} ,attr_per = 30 ,lv_total = 47 }
;get(5,7) -> 
   #base_meridian_break{type = 5 ,break_lv = 7 ,plv = 120 ,ratio = 10 ,cd = 60 ,goods = {6002005,8} ,attr_per = 35 ,lv_total = 55 }
;get(5,8) -> 
   #base_meridian_break{type = 5 ,break_lv = 8 ,plv = 125 ,ratio = 10 ,cd = 60 ,goods = {6002005,8} ,attr_per = 40 ,lv_total = 63 }
;get(5,9) -> 
   #base_meridian_break{type = 5 ,break_lv = 9 ,plv = 130 ,ratio = 10 ,cd = 60 ,goods = {6002005,10} ,attr_per = 45 ,lv_total = 71 }
;get(5,10) -> 
   #base_meridian_break{type = 5 ,break_lv = 10 ,plv = 135 ,ratio = 10 ,cd = 60 ,goods = {6002005,10} ,attr_per = 50 ,lv_total = 79 }
;get(6,1) -> 
   #base_meridian_break{type = 6 ,break_lv = 1 ,plv = 95 ,ratio = 100 ,cd = 60 ,goods = {6002006,1} ,attr_per = 5 ,lv_total = 7 }
;get(6,2) -> 
   #base_meridian_break{type = 6 ,break_lv = 2 ,plv = 100 ,ratio = 66 ,cd = 60 ,goods = {6002006,2} ,attr_per = 10 ,lv_total = 15 }
;get(6,3) -> 
   #base_meridian_break{type = 6 ,break_lv = 3 ,plv = 105 ,ratio = 40 ,cd = 60 ,goods = {6002006,4} ,attr_per = 15 ,lv_total = 23 }
;get(6,4) -> 
   #base_meridian_break{type = 6 ,break_lv = 4 ,plv = 110 ,ratio = 20 ,cd = 60 ,goods = {6002006,4} ,attr_per = 20 ,lv_total = 31 }
;get(6,5) -> 
   #base_meridian_break{type = 6 ,break_lv = 5 ,plv = 115 ,ratio = 15 ,cd = 60 ,goods = {6002006,6} ,attr_per = 25 ,lv_total = 39 }
;get(6,6) -> 
   #base_meridian_break{type = 6 ,break_lv = 6 ,plv = 120 ,ratio = 12 ,cd = 60 ,goods = {6002006,6} ,attr_per = 30 ,lv_total = 47 }
;get(6,7) -> 
   #base_meridian_break{type = 6 ,break_lv = 7 ,plv = 125 ,ratio = 10 ,cd = 60 ,goods = {6002006,8} ,attr_per = 35 ,lv_total = 55 }
;get(6,8) -> 
   #base_meridian_break{type = 6 ,break_lv = 8 ,plv = 130 ,ratio = 10 ,cd = 60 ,goods = {6002006,8} ,attr_per = 40 ,lv_total = 63 }
;get(6,9) -> 
   #base_meridian_break{type = 6 ,break_lv = 9 ,plv = 135 ,ratio = 10 ,cd = 60 ,goods = {6002006,10} ,attr_per = 45 ,lv_total = 71 }
;get(6,10) -> 
   #base_meridian_break{type = 6 ,break_lv = 10 ,plv = 140 ,ratio = 10 ,cd = 60 ,goods = {6002006,10} ,attr_per = 50 ,lv_total = 79 }
;get(7,1) -> 
   #base_meridian_break{type = 7 ,break_lv = 1 ,plv = 100 ,ratio = 100 ,cd = 60 ,goods = {6002007,1} ,attr_per = 5 ,lv_total = 7 }
;get(7,2) -> 
   #base_meridian_break{type = 7 ,break_lv = 2 ,plv = 105 ,ratio = 66 ,cd = 60 ,goods = {6002007,2} ,attr_per = 10 ,lv_total = 15 }
;get(7,3) -> 
   #base_meridian_break{type = 7 ,break_lv = 3 ,plv = 110 ,ratio = 40 ,cd = 60 ,goods = {6002007,4} ,attr_per = 15 ,lv_total = 23 }
;get(7,4) -> 
   #base_meridian_break{type = 7 ,break_lv = 4 ,plv = 115 ,ratio = 20 ,cd = 60 ,goods = {6002007,4} ,attr_per = 20 ,lv_total = 31 }
;get(7,5) -> 
   #base_meridian_break{type = 7 ,break_lv = 5 ,plv = 120 ,ratio = 15 ,cd = 60 ,goods = {6002007,6} ,attr_per = 25 ,lv_total = 39 }
;get(7,6) -> 
   #base_meridian_break{type = 7 ,break_lv = 6 ,plv = 125 ,ratio = 12 ,cd = 60 ,goods = {6002007,6} ,attr_per = 30 ,lv_total = 47 }
;get(7,7) -> 
   #base_meridian_break{type = 7 ,break_lv = 7 ,plv = 130 ,ratio = 10 ,cd = 60 ,goods = {6002007,8} ,attr_per = 35 ,lv_total = 55 }
;get(7,8) -> 
   #base_meridian_break{type = 7 ,break_lv = 8 ,plv = 135 ,ratio = 10 ,cd = 60 ,goods = {6002007,8} ,attr_per = 40 ,lv_total = 63 }
;get(7,9) -> 
   #base_meridian_break{type = 7 ,break_lv = 9 ,plv = 140 ,ratio = 10 ,cd = 60 ,goods = {6002007,10} ,attr_per = 45 ,lv_total = 71 }
;get(7,10) -> 
   #base_meridian_break{type = 7 ,break_lv = 10 ,plv = 145 ,ratio = 10 ,cd = 60 ,goods = {6002007,10} ,attr_per = 50 ,lv_total = 79 }
;get(8,1) -> 
   #base_meridian_break{type = 8 ,break_lv = 1 ,plv = 105 ,ratio = 100 ,cd = 60 ,goods = {6002008,1} ,attr_per = 5 ,lv_total = 7 }
;get(8,2) -> 
   #base_meridian_break{type = 8 ,break_lv = 2 ,plv = 110 ,ratio = 66 ,cd = 60 ,goods = {6002008,2} ,attr_per = 10 ,lv_total = 15 }
;get(8,3) -> 
   #base_meridian_break{type = 8 ,break_lv = 3 ,plv = 115 ,ratio = 40 ,cd = 60 ,goods = {6002008,4} ,attr_per = 15 ,lv_total = 23 }
;get(8,4) -> 
   #base_meridian_break{type = 8 ,break_lv = 4 ,plv = 120 ,ratio = 20 ,cd = 60 ,goods = {6002008,4} ,attr_per = 20 ,lv_total = 31 }
;get(8,5) -> 
   #base_meridian_break{type = 8 ,break_lv = 5 ,plv = 125 ,ratio = 15 ,cd = 60 ,goods = {6002008,6} ,attr_per = 25 ,lv_total = 39 }
;get(8,6) -> 
   #base_meridian_break{type = 8 ,break_lv = 6 ,plv = 130 ,ratio = 12 ,cd = 60 ,goods = {6002008,6} ,attr_per = 30 ,lv_total = 47 }
;get(8,7) -> 
   #base_meridian_break{type = 8 ,break_lv = 7 ,plv = 135 ,ratio = 10 ,cd = 60 ,goods = {6002008,8} ,attr_per = 35 ,lv_total = 55 }
;get(8,8) -> 
   #base_meridian_break{type = 8 ,break_lv = 8 ,plv = 140 ,ratio = 10 ,cd = 60 ,goods = {6002008,8} ,attr_per = 40 ,lv_total = 63 }
;get(8,9) -> 
   #base_meridian_break{type = 8 ,break_lv = 9 ,plv = 145 ,ratio = 10 ,cd = 60 ,goods = {6002008,10} ,attr_per = 45 ,lv_total = 71 }
;get(8,10) -> 
   #base_meridian_break{type = 8 ,break_lv = 10 ,plv = 150 ,ratio = 10 ,cd = 60 ,goods = {6002008,10} ,attr_per = 50 ,lv_total = 79 }
;get(9,1) -> 
   #base_meridian_break{type = 9 ,break_lv = 1 ,plv = 110 ,ratio = 100 ,cd = 60 ,goods = {6002009,1} ,attr_per = 5 ,lv_total = 7 }
;get(9,2) -> 
   #base_meridian_break{type = 9 ,break_lv = 2 ,plv = 115 ,ratio = 66 ,cd = 60 ,goods = {6002009,2} ,attr_per = 10 ,lv_total = 15 }
;get(9,3) -> 
   #base_meridian_break{type = 9 ,break_lv = 3 ,plv = 120 ,ratio = 40 ,cd = 60 ,goods = {6002009,4} ,attr_per = 15 ,lv_total = 23 }
;get(9,4) -> 
   #base_meridian_break{type = 9 ,break_lv = 4 ,plv = 125 ,ratio = 20 ,cd = 60 ,goods = {6002009,4} ,attr_per = 20 ,lv_total = 31 }
;get(9,5) -> 
   #base_meridian_break{type = 9 ,break_lv = 5 ,plv = 130 ,ratio = 15 ,cd = 60 ,goods = {6002009,6} ,attr_per = 25 ,lv_total = 39 }
;get(9,6) -> 
   #base_meridian_break{type = 9 ,break_lv = 6 ,plv = 135 ,ratio = 12 ,cd = 60 ,goods = {6002009,6} ,attr_per = 30 ,lv_total = 47 }
;get(9,7) -> 
   #base_meridian_break{type = 9 ,break_lv = 7 ,plv = 140 ,ratio = 10 ,cd = 60 ,goods = {6002009,8} ,attr_per = 35 ,lv_total = 55 }
;get(9,8) -> 
   #base_meridian_break{type = 9 ,break_lv = 8 ,plv = 145 ,ratio = 10 ,cd = 60 ,goods = {6002009,8} ,attr_per = 40 ,lv_total = 63 }
;get(9,9) -> 
   #base_meridian_break{type = 9 ,break_lv = 9 ,plv = 150 ,ratio = 10 ,cd = 60 ,goods = {6002009,10} ,attr_per = 45 ,lv_total = 71 }
;get(9,10) -> 
   #base_meridian_break{type = 9 ,break_lv = 10 ,plv = 155 ,ratio = 10 ,cd = 60 ,goods = {6002009,10} ,attr_per = 50 ,lv_total = 79 }
;get(_,_) -> [].
