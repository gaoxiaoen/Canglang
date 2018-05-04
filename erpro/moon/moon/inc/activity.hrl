%%----------------------------------------------------
%% 活跃度系统 
%%
%% @author Shawn
%%----------------------------------------------------

-define(ACT_ONLINE_TIME, 3 * 60 * 60). %% 累计在线时间

%%活跃度信息
-record(activity, {
    id                  = 0,      %%记录ID
    rid                 = 0,      %%角色ID
    srvid               = <<"">>, %%srvid
    date                = 0,      %%unixtime 来表示日期
    award_detail        = [],     %%活跃度奖励明细
    summary             = 0,      %%目前拥有的活跃
    sum_limit           = 0,      %%活跃度上限
    online_award        = {0, 0}, %% 在线奖励
    use_detail          = [],     %%兑换情况
    assistant           = [],     %%辅助字段，记录持续信息[{online_time, 3}, {dungeon, 2}]
    reg_time            = 0       %% 注册时间
}).

%%活跃度奖励
%% {Id, Label, Point, Times}
-define(ACTIVITY_AWARD, [
        {1, act_shimen, 4, 10},         %% 完成师门
        {3, act_guild, 4, 5},          %% 完成帮会
        {4, act_richang, 10, 1},        %% 完成日常
        {6, act_xianchong, 0, 2},        %% 仙宠任务
        {7, act_arena, 100, 1},          %% 竞技场任务
        {14, act_dungeon25, 20, 1},      %% 完成25副本 
        {15, act_dungeon35, 20, 1},      %% 完成35副本
        {16, act_dungeon45, 20, 1},      %% 完成45副本
        {54, act_dungeon55, 20, 1},      %% 完成55副本
        {55, act_dungeon65, 20, 1},      %% 完成65副本
        {26, act_shop_buy, 30, 1},       %% 商场购买一件物品
        {27, act_online, 10, 1},        %% 在线3小时
        {52, act_coin, 0, 2},            %% 金币任务
        {53, act_yueli, 0, 2},           %% 阅历任务
        {56, act_guild_pra, 0, 1},       %% 帮会试炼任务
        {57, act_xiuxing, 0, 10},        %% 修行任务
    %% ---------- 扣除精力值,完成时记录次数
        {5, act_yunbiao, 0, 3},           %% 运镖
        {51, act_graph, 0, 2},            %% 宝图
        {17, act_coin_dungeon, 0, 2}      %% 打钱副本
    ]
).


%%活跃度消耗
%% {Type, Use, UseTime}
-define(ACTIVITY_USE, [
        {5, act_yunbiao, 20, 3},
        {51, act_graph, 10, 2},
        {17, act_coin_dungeon, 0, 2}
    ]
).

%% 在线奖励
-define(ONLINE_AWARD,[
        {1,  item, [24120, 1, 1], 60},
        {2,  item, [24122, 1, 1], 3*60},
        {3,  item, [23000, 1, 10], 5*60},
        {4,  item, [24120, 1, 1], 10*60},
        {5,  item, [24122, 1, 1] , 15*60},
        {6,  item, [21000, 1, 3] , 20*60},
        {7,  item, [21010, 1, 5] , 25*60},
        {8,  item, [32000, 1, 3] , 30*60},
        {9,  item, [22010, 1, 3], 35*60},
        {10, item, [30210, 1, 10], 40*60},
        {11, gold_bind, 100, 50*60},
        {12, gold_bind, 200, 60*60}
    ]
).


