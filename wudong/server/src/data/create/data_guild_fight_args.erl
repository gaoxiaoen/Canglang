%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_fight_args
	%%% @Created : 2018-03-06 00:01:55
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_fight_args).
-export([get_challenge_cd_time/0]).
-export([get_fight_max_win_num/0]).
-export([get_def_max_reward/0]).
-export([get_win_percent/0]).
-export([get_guild_max_num/0]).
-export([get_x_y/0]).
-export([get_mon_xy/0]).
-include("guild_fight.hrl").
get_challenge_cd_time() -> 180.
get_fight_max_win_num() -> 5.
get_def_max_reward() -> 10.
get_win_percent() -> 90.
get_guild_max_num() -> 4.
get_x_y() -> {21,51,35,76}.
get_mon_xy() -> {38,58}.
