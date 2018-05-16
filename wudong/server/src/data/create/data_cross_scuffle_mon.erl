%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_scuffle_mon
	%%% @Created : 2017-09-11 20:24:19
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_scuffle_mon).
-export([id_list/0]).
-export([get/1]).
-export([get_cd/1]).
-export([get_buff_mon/1]).
-include("common.hrl").

    id_list() ->
    [1,2].
get(1) -> [{45002,10,25},{45003,11,28},{45004,13,26}]; 
get(2) -> [{45001,43,79}]; 
get(_) -> []. 
get_cd(1) -> 10; 
get_cd(2) -> 10; 
get_cd(_) -> []. 
get_buff_mon(1) -> [[{37601,500},{37602,500},{37603,500}],10,25]; 
get_buff_mon(2) -> [[{37601,500},{37604,500},{37605,500}],43,79]; 
get_buff_mon(_) -> []. 
