%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 十一月 2017 14:27
%%%-------------------------------------------------------------------
-module(data_cross_scuffle_elite_exp).
-author("Administrator").

%% API
-export([get/1]).
get(Lv) when Lv >= 1 andalso Lv < 90 -> 100000;
get(Lv) when Lv >= 91 andalso Lv < 150 -> 200000;
get(Lv) when Lv >= 200 andalso Lv < 300 -> 300000;
get(_)->0.
