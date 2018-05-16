%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_star_luck_lv_open
	%%% @Created : 2016-06-06 10:04:25
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_star_luck_lv_open).
-export([get/1]).
-include("star_luck.hrl").
  get(1) -> #base_star_lv_open{open_num=1,lv=48};
  get(2) -> #base_star_lv_open{open_num=2,lv=48};
  get(3) -> #base_star_lv_open{open_num=3,lv=48};
  get(4) -> #base_star_lv_open{open_num=4,lv=51};
  get(5) -> #base_star_lv_open{open_num=5,lv=61};
  get(6) -> #base_star_lv_open{open_num=6,lv=71};
  get(7) -> #base_star_lv_open{open_num=7,lv=81};
  get(8) -> #base_star_lv_open{open_num=8,lv=91};
get(_) -> [].
