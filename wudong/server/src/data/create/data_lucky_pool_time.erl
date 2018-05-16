%%%---------------------------------------
%%% @Author  : 苍狼工作室
%%% @Module  : data_lucky_pool_time
%%% @Created : 2016-05-07 16:59:50
%%% @Description:  自动生成
%%%---------------------------------------
-module(data_lucky_pool_time).
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("invade.hrl").

ids() ->
    [1, 2].
get(1) -> [{12, 0}, {12, 15}];
get(2) -> [{18, 0}, {18, 15}];
get(_) -> [].
