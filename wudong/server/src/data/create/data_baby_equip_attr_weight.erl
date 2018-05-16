%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_baby_equip_attr_weight
	%%% @Created : 2017-09-04 21:32:45
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_baby_equip_attr_weight).
-export([get/1]).
-export([all/0]).
-include("common.hrl").
-include("baby.hrl").
get(3) -> {2000,300}; 
get(4) -> {2000,300}; 
get(1) -> {2000,300}; 
get(6) -> {2000,300}; 
get(8) -> {2000,300}; 
get(7) -> {2000,300}; 
get(5) -> {2000,300}; 
get(_) -> {0,0}.

all() -> [3,4,1,6,8,7,5].