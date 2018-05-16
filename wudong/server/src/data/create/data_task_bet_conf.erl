%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_task_bet_conf
	%%% @Created : 2017-05-15 18:07:46
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_task_bet_conf).
-export([id_list/0]).
-export([get_ratio/1]).
-export([get_reward/1]).
-include("common.hrl").
id_list() ->[1,2,3].
get_ratio(1) ->40;
get_ratio(2) ->50;
get_ratio(3) ->10;
get_ratio(_) -> 0.
get_reward(1) ->20;
get_reward(2) ->30;
get_reward(3) ->50;
get_reward(_) -> 0.
