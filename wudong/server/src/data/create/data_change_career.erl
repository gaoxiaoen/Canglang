%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_change_career
	%%% @Created : 2018-03-26 19:26:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_change_career).
-export([get/1]).
-export([get_reward/1]).
-include("server.hrl").
  get(0) -> [{att,0},{def,0},{hp_lim,0}];
  get(2) -> [{att,800},{def,400},{hp_lim,8000}];
  get(3) -> [{att,2000},{def,1000},{hp_lim,20000}];
  get(4) -> [{att,2000},{def,1000},{hp_lim,20000}];
get(_) -> [].
  get_reward(0) -> [{10101,100}];
  get_reward(2) -> [{10101,100}];
  get_reward(3) -> [{10101,100}];
  get_reward(4) -> [{10101,100}];
get_reward(_) -> [].
