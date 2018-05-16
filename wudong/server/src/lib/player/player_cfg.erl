%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 上午10:26
%%%-------------------------------------------------------------------
-module(player_cfg).
-author("fancy").
-include("common.hrl").
%% API
-export([
    get_grow_attribute/1 ,
    attribute1to2/2
]).

%%等级成长对应力量体质
get_grow_attribute(Lv) ->
	{1 * Lv,1 * Lv}.

%%[att,hp_lim,def]
attribute1to2(Forza ,Thew) ->
	{100 + Forza * 3,1000 + Forza * 60 ,200 + Thew * 6}.
   
