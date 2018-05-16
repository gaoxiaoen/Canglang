%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_prison
	%%% @Created : 2017-10-16 20:23:57
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_prison).
-include("red_bag.hrl").
-compile([export_all]).
get_evil_red_val() -> 1500.
get_prison_val() -> 15000.
get_protect_lv() -> 45.
get_kill_num_add_des() -> {500,10045}.
get_chivalry_add_des() -> {75000,10048}.
get_drop_coin() -> 0.05.
get_clean_evil_gold() -> 0.5.
get_dog_cost_gold() -> 100.
get_bribe_cost_gold() -> 20.
get_release_prison() -> {20,100}.
get_kill_add_evil() -> [{{0,1500},150},{{1500,7500},450},{{7500,99999},750}].
get_first_kill_protect_lv() -> {46,56}.
get_first_kill_protect_time() -> 1200.
get_time_del_evil() -> 100.
get_daily_pick_up() -> 10.
