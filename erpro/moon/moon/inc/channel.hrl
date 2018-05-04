%% **************************
%% 元神数据
%% @author wpf(wprehard@qq.com)
%% **************************

-define(MAX_CHANNEL_LEV, 70).

%% 加速方式
-define(CHANNEL_UP_ITEM, 0).    %% 丹药消耗
-define(CHANNEL_UP_GOLD, 1).    %% 晶钻消耗
-define(CHANNEL_UP_BAG, 2).     %% 背包双击物品使用方式

-define(channels, [
        1   %% 生命之魂
        ,2  %% 攻击之拳
        ,3  %% 防御之骨
        ,4  %% 暴怒之肘
        ,5  %% 坚韧之心
        ,6  %% 精准之眼
        ,7  %% 格挡之臂
        ,8  %% 抗性之血
    ]).

%% 角色元神
-record(channels, {
        flag = 0        %% 目前升级次数, 每升5次来一次CD
        ,time = 0       %% CD时间戳, 0没有Cd
        ,cd_time = 0    %% 最近升级的CD时间
        ,list = []      %% 元神列表 [#role_channel{} | ...]
    }).

%% 单个元神数据
-record(role_channel, {
        id = 0          %% 元神ID
        ,lev = 0        %% 等级
        ,time = 0       %% 修炼结束时间unix戳
        ,state = 0      %% 强化等级
    }).

%% 元神的基础数据结构
-record(channel, {
        id = 0              %% 元神ID
        ,lev = 0            %% 元神等级
        ,cond_lev = 0       %% 角色等级要求
        ,cond_before = {}   %% 前置条件:{ChannelId, Lev}
        ,cost_spirit = 0    %% 灵力消耗
        ,cost_time = 0      %% 修炼消耗时间
        ,attr = {}          %% 附加属性
    }).
