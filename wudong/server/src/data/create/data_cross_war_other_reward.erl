%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_cross_war_other_reward
	%%% @Created : 2018-01-30 14:27:16
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_cross_war_other_reward).
-export([get_att_success_reward/0, get_att_fail_reward/0, get_def_success_reward/0, get_def_fail_reward/0,get_king_reward/0, get_king_couple_reward/0,get_war_reward/0,get_door_reward/0, get_king_guild_reward/0, get_king_gold_reward/0,get_king_con_mult/0]).
-include("common.hrl").

 %% 攻击方胜利奖励
get_att_success_reward()->[{1015001,6},{10106,50},{2003000,20}].

 %% 防御方胜利奖励
get_def_success_reward()->[{1015001,6},{10106,50},{2003000,20}].

 %% 攻击方胜利奖励
get_att_fail_reward()->[{1015001,4},{10101,30000},{2005000,10}].

 %% 防御方胜利奖励
get_def_fail_reward()->[{1015001,4},{10101,30000},{2005000,10}].

 %% 城主奖励
get_king_reward()->[{6603064,1},{8001054,10},{10106,100}].

 %% 城主夫人奖励
get_king_couple_reward()->[{6603064,1},{8001054,10},{10106,100}].

 %% 战场奖励
get_war_reward()->[{6603064,1},{8001054,10},{10106,100}].

 %% 城主仙盟奖励
get_king_guild_reward()->[{10106,50},{8001057,5},{8001002,5}].

 %% 城门摧毁奖励
get_door_reward()->[{8001187,1}].

 %% 王城宝珠奖励
get_king_gold_reward()->[{8001188,1}].

 %% 城主仙盟积分倍率奖励
get_king_con_mult()->1.5.
