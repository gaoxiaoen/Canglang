%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_channel_limit
	%%% @Created : 2018-03-08 15:04:04
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_channel_limit).
-export([get/1]).
-include("market.hrl").
-include("common.hrl").
get(0)->true;
get(_) -> false.
