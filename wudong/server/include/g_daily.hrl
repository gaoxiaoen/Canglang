%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, junhai
%%% @doc
%%%
%%% @end
%%% Created : 10. 三月 2015 14:54
%%%-------------------------------------------------------------------
-author("fzl").

%%--------所有全局计数类型定义------------
-define(G_DAILY_ACT_RANK(TYPE), 1000 + Type * 10).  %%冲榜抢购
-define(G_DAILY_MARRY, 1).

-define(G_DAILY_ETS, global_daily_ets).  %%全局日常计数器ets

-record(g_daily, {
    type = 0,  %%类型
    count = 0,  %%当天计数
    time = 0
}).

-define(G_FOREVER_ETS, global_forever_ets).  %%全局永久计数器ets

-record(g_forever, {
    type = 0,  %%类型
    count = 0,  %%永久计数
    time = 0   %%上次更改时间
}).

-define(G_FOREVER_TYPE_INVEST, 1).  %%全局计数投资类型
-define(G_FOREVER_TYPE_LUCKY_POOL, 2).  %%全局计数幸运奖池
-define(G_FOREVER_TYPE_CROSS_WAR, 3).  %%全局计数跨服城战分区时间
-define(G_FOREVER_HK_GIFT(Id), 200000 + Id).%%繁体FB活动奖励
