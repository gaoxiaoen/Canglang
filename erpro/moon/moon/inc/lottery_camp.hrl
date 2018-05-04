%% **************************
%% 活动转盘数据结构
%% @author abu
%% **************************

%% 奖池当前状态
-record(lottery_camp, {
        rands = []          %% 浮动概率列表: [{Id, NowRand, Num} | ...]
        ,rewards = []       %% 奖励物品列表
        ,use_item           %% 消耗的物品
        ,log = []           %% 最近珍品得主[#lottery_log{} | ...]
    }).

%% 抽奖日志
-record(lottery_camp_log, {
        rid = 0             %% 角色ID
        ,srv_id = <<>>      %% 角色服务器标识
        ,name = <<>>        %% 角色名
        ,award_id = 0       %% 奖品ID
        ,is_notice = 1      %% 是否极品
        ,ctime = 0          %% 时间
    }).

%% 彩票奖品的基础信息设定
-record(lottery_camp_item, {
        base_id = 0             %% 奖品ID
        ,name = <<>>            %% 物品名称
        ,num = 1                %% 奖励数量
        ,is_notice = 0          %% 0：不公告 1：公告
        ,rand = 0               %% 概率分子
        ,limit_count = 5        %% 限制必须抽多少次后才会出
    }).

%% 抽奖玩家信息记录
-record(lottery_role, {
        last_award = []       %% 上次奖品
        ,count = 0              %% 抽奖的次数， 抽到极品时清零
    }).



