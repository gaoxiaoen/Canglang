%%%---------------------------------------
%%% @Author  : 苍狼工作室
%%% @Module  : data_lucky_pool_ex
%%% @Created : 2016-05-07 16:59:50
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_lucky_pool_ex).
-export([get/1]).
-include("common.hrl").
-include("invade.hrl").
get(10) -> 1;
get(20) -> 2;
get(30) -> 3;
get(40) -> 4;
get(_) -> 0.
