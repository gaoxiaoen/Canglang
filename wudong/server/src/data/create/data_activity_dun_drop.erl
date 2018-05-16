%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_activity_dun_drop
	%%% @Created : 2016-08-04 17:50:06
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_activity_dun_drop).
-export([get/1]).
-include("common.hrl").

get(Type)->
    case goods_exchange:is_activity() of
         true->get_goods(Type);
         false->[]
         end.

        
%% 强化副本.
get_goods(1)->[{29708,1}];
%% 洗炼副本.
get_goods(2)->[{29708,1}];
%% 宝石副本.
get_goods(3)->[{29708,1}];
%% 坐骑副本.
get_goods(4)->[{29708,1}];
%% 翅膀副本.
get_goods(5)->[{29708,1}];
%% 宠物副本.
get_goods(6)->[{29708,1}];
%% 组队副本.
get_goods(7)->[{29708,1}];
%% 女神守护.
get_goods(8)->[{29708,1}];
%% 挑战boss.
get_goods(9)->[];
%% 公会战.
get_goods(10)->[{29708,3}];
%% 战场.
get_goods(11)->[{29708,3}];
%% 跨服巅峰塔.
get_goods(12)->[{29708,3}];
%% 公会boss.
get_goods(13)->[{29708,3}];
get_goods(_) -> [].
