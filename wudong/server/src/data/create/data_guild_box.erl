%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_box
	%%% @Created : 2017-12-13 23:11:21
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_box).
-export([get_max/0]).
-export([get/1]).
-include("guild.hrl").

    get_max() -> 5.
get(1) ->
   #base_guild_box{base_id = 1 ,reward_list = [{10106,150,5},{8002401,8,10},{1025001,8,10},{2003000,20,10},{8001050,30,10}] ,cd_time = 3600 ,other_reward = 10 };
get(2) ->
   #base_guild_box{base_id = 2 ,reward_list = [{10106,200,5},{8002401,12,10},{1025001,16,10},{2003000,28,10},{8001050,36,10}] ,cd_time = 3600 ,other_reward = 10 };
get(3) ->
   #base_guild_box{base_id = 3 ,reward_list = [{10106,250,5},{8002401,16,10},{1025001,16,10},{2003000,30,10},{8001050,40,10}] ,cd_time = 5400 ,other_reward = 15 };
get(4) ->
   #base_guild_box{base_id = 4 ,reward_list = [{10106,300,5},{8002403,10,10},{2014001,2,5},{2003000,60,10},{8001050,60,10}] ,cd_time = 7200 ,other_reward = 20 };
get(5) ->
   #base_guild_box{base_id = 5 ,reward_list = [{10106,500,5},{8002404,10,10},{2014001,4,5},{2003000,80,10},{8001050,100,10}] ,cd_time = 7200 ,other_reward = 20 };
get(_) -> #base_guild_box{}.