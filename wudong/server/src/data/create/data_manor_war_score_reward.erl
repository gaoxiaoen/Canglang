%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_manor_war_score_reward
	%%% @Created : 2017-07-24 17:09:43
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_manor_war_score_reward).
-export([get/1]).
-export([get_des/1]).
-include("common.hrl").
-include("manor_war.hrl").
  get(Rank) when Rank>=1 andalso Rank=<1  -> [{1021000,1200},{8001054,10},{2003000,20}];
  get(Rank) when Rank>=2 andalso Rank=<2  -> [{1021000,1100},{8001054,9},{2003000,18}];
  get(Rank) when Rank>=3 andalso Rank=<3  -> [{1021000,1000},{8001054,8},{2003000,16}];
  get(Rank) when Rank>=4 andalso Rank=<10  -> [{1021000,900},{8001054,7},{2003000,14}];
  get(Rank) when Rank>=11 andalso Rank=<20  -> [{1021000,800},{8001054,6},{2003000,12}];
  get(Rank) when Rank>=21 andalso Rank=<50  -> [{1021000,700},{8001054,5},{2003000,10}];
  get(Rank) when Rank>=51 andalso Rank=<10000  -> [{1021000,600},{8001054,5},{2003000,8}];
get(_) -> [].
  get_des(Rank) when Rank>=1 andalso Rank=<1  -> 10019;
  get_des(Rank) when Rank>=2 andalso Rank=<2  -> 0;
  get_des(Rank) when Rank>=3 andalso Rank=<3  -> 0;
  get_des(Rank) when Rank>=4 andalso Rank=<10  -> 0;
  get_des(Rank) when Rank>=11 andalso Rank=<20  -> 0;
  get_des(Rank) when Rank>=21 andalso Rank=<50  -> 0;
  get_des(Rank) when Rank>=51 andalso Rank=<10000  -> 0;
get_des(_) -> 0.