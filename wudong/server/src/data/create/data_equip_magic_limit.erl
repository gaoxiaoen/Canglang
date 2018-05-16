%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_equip_magic_limit
	%%% @Created : 2018-05-02 16:53:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_equip_magic_limit).
-export([get/1]).
-include("error_code.hrl").
get(0) -> 10 ;
get(1) -> 15 ;
get(2) -> 20 ;
get(3) -> 30 ;
get(4) -> 40 ;
get(5) -> 150 ;
get(_) -> 0.
