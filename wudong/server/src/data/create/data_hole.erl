%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_hole
	%%% @Created : 2016-03-31 19:23:08
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_hole).
-export([get/1]).
  get(Lv) when Lv > 1500 -> 10006;
  get(Lv) when Lv > 1200 -> 10005;
  get(Lv) when Lv > 900 -> 10004;
  get(Lv) when Lv > 600 -> 10003;
  get(Lv) when Lv > 300 -> 10002;
get(_) -> 0.
