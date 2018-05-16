%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_taobao_config
	%%% @Created : 2016-06-13 14:48:24
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_taobao_config).
-export([get/1]).
-export([get_all_type/0]).
-include("taobao.hrl").
get(1)-> #base_taobao_config{type = 1,gold = 20,bind_gold = 0,cd_time = 3600,max_times = 5};
get(2)-> #base_taobao_config{type = 2,gold = 190,bind_gold = 0,cd_time = 259200,max_times = 1};
get(3)-> #base_taobao_config{type = 3,gold = 900,bind_gold = 0,cd_time = 604800,max_times = 1};
get(_) -> throw({false,44444}).


get_all_type()-> [1,2,3].
