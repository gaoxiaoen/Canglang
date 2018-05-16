%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_init_attr_value
	%%% @Created : 2016-09-13 15:34:41
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_init_attr_value).
-export([get/1]).
-include("error_code.hrl").
get({Lv,1,att}) when Lv >=1 andalso  Lv =< 99 -> 
				{1,62};
get({Lv,1,hp_lim}) when Lv >=1 andalso  Lv =< 99 -> 
				{1,937};
get({Lv,1,def}) when Lv >=1 andalso  Lv =< 99 -> 
				{1,62};
get({Lv,2,att}) when Lv >=1 andalso  Lv =< 99 -> 
				{63,125};
get({Lv,2,hp_lim}) when Lv >=1 andalso  Lv =< 99 -> 
				{938,1875};
get({Lv,2,def}) when Lv >=1 andalso  Lv =< 99 -> 
				{63,125};
get({Lv,3,att}) when Lv >=1 andalso  Lv =< 99 -> 
				{126,250};
get({Lv,3,hp_lim}) when Lv >=1 andalso  Lv =< 99 -> 
				{1876,3750};
get({Lv,3,def}) when Lv >=1 andalso  Lv =< 99 -> 
				{126,250};
get({Lv,4,att}) when Lv >=1 andalso  Lv =< 99 -> 
				{251,500};
get({Lv,4,hp_lim}) when Lv >=1 andalso  Lv =< 99 -> 
				{3751,7500};
get({Lv,4,def}) when Lv >=1 andalso  Lv =< 99 -> 
				{251,500};
get(_Data) -> throw({false,0}).