%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 二月 2017 18:01
%%%-------------------------------------------------------------------
-module(data_more_exp_time).
-author("Administrator").

%% API
-export([ids/0]).
-export([get/1]).
-include("common.hrl").
-include("more_exp.hrl").

ids() ->
    [1].
get(1) ->
    #base_more_exp_time{id = 1, time = [{22, 00}, {24, 00}], reward = 5, lv = 1};
get(_) -> [].