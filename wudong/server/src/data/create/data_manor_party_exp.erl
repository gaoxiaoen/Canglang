%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_party_exp
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_party_exp).
-export([max_lv/0]).
-export([get/1]).
-include("common.hrl").
-include("manor_war.hrl").

    max_lv() ->
    3.
  get(1) -> 100;
  get(2) -> 200;
  get(3) -> 300;
get(_) -> 0.