%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_manor_exp
	%%% @Created : 2017-06-12 19:44:23
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_manor_exp).
-export([max_lv/0]).
-export([get/1]).
-include("common.hrl").
-include("guild_manor.hrl").

    max_lv() ->
    10.
  get(1) -> 600;
  get(2) -> 1200;
  get(3) -> 2400;
  get(4) -> 3600;
  get(5) -> 4800;
  get(6) -> 6000;
  get(7) -> 7200;
  get(8) -> 8400;
  get(9) -> 9600;
  get(10) -> 0;
get(_) -> 99999999999.