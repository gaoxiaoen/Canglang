%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_wash_ratio
	%%% @Created : 2017-06-21 16:44:14
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_wash_ratio).
-export([type_list/0]).
-export([get/1]).
-include("error_code.hrl").

    type_list() ->
    [att,def,hp_lim,crit,ten,hit,dodge].
get(att) ->[2000,1000];
get(def) ->[2000,1000];
get(hp_lim) ->[2000,1000];
get(crit) ->[2000,1000];
get(ten) ->[2000,1000];
get(hit) ->[2000,1000];
get(dodge) ->[2000,1000];
get(_Data) -> [].