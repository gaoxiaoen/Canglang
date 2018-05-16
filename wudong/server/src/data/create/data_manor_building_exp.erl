%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_building_exp
	%%% @Created : 2017-06-12 19:44:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_building_exp).
-export([max_lv/0]).
-export([get/1]).
-include("common.hrl").
-include("guild_manor.hrl").

    max_lv() ->
    10.
  get(1) -> 500;
  get(2) -> 1000;
  get(3) -> 2000;
  get(4) -> 3000;
  get(5) -> 4000;
  get(6) -> 5000;
  get(7) -> 6000;
  get(8) -> 7000;
  get(9) -> 8000;
  get(10) -> 0;
get(_) -> 99999999999.