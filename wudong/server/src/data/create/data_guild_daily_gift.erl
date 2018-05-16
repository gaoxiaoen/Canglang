%%%---------------------------------------
	%%% @Author  : 苍狼工作室
	%%% @Module  : data_guild_daily_gift
	%%% @Created : 2017-06-19 20:41:30
	%%% @Description:  自动生成
	%%%---------------------------------------
-module(data_guild_daily_gift).
-export([get/1]).
-include("common.hrl").
-include("guild.hrl").
get(1)->#base_guild_daily_gift{lv=1,goods_list=[{2003000,1}]};
get(2)->#base_guild_daily_gift{lv=2,goods_list=[{2003000,1},{1016001,1}]};
get(3)->#base_guild_daily_gift{lv=3,goods_list=[{2003000,1},{1016001,1},{2005000,1}]};
get(4)->#base_guild_daily_gift{lv=4,goods_list=[{2003000,2},{1016001,1},{2005000,1}]};
get(5)->#base_guild_daily_gift{lv=5,goods_list=[{2003000,3},{1016001,1},{2005000,1}]};
get(6)->#base_guild_daily_gift{lv=6,goods_list=[{2003000,3},{1016001,1},{2005000,2}]};
get(7)->#base_guild_daily_gift{lv=7,goods_list=[{2003000,3},{1016001,1},{2005000,3}]};
get(8)->#base_guild_daily_gift{lv=8,goods_list=[{2003000,3},{1016001,1},{2005000,3}]};
get(9)->#base_guild_daily_gift{lv=9,goods_list=[{2003000,3},{1016001,2},{2005000,3}]};
get(10)->#base_guild_daily_gift{lv=10,goods_list=[{2003000,3},{1016001,2},{2005000,4}]};
get(_) -> [].
