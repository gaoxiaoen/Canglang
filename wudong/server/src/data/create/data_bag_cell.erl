%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_bag_cell
	%%% @Created : 2018-03-26 19:54:00
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_bag_cell).
-export([get/1]).
  get(Lv) when Lv >= 1 andalso Lv =< 50-> 110;
  get(Lv) when Lv >= 51 andalso Lv =< 80-> 143;
  get(Lv) when Lv >= 81 andalso Lv =< 90-> 176;
  get(Lv) when Lv >= 91 andalso Lv =< 110-> 209;
  get(Lv) when Lv >= 111 andalso Lv =< 130-> 242;
  get(Lv) when Lv >= 131 andalso Lv =< 150-> 275;
  get(Lv) when Lv >= 151 andalso Lv =< 170-> 308;
  get(Lv) when Lv >= 171 andalso Lv =< 190-> 341;
  get(Lv) when Lv >= 191 andalso Lv =< 210-> 374;
  get(Lv) when Lv >= 211 andalso Lv =< 250-> 407;
  get(Lv) when Lv >= 251 andalso Lv =< 999-> 440;
get(_) -> 0.
