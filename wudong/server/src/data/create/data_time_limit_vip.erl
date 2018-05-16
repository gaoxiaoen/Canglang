%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 一月 2018 13:28
%%%-------------------------------------------------------------------
-module(data_time_limit_vip).
-author("Administrator").
-include("vip.hrl").
%% API
-export([get/0]).
get() -> #base_time_limit_vip{
  open_lv = 18,
  close_lv = 40,
  att = [{att, 1040}, {def, 520}, {hp_lim, 10400}, {crit, 232}, {ten, 216}, {hit, 208}, {dodge, 200}],
  time = 120,
  re_time = 172800
}.