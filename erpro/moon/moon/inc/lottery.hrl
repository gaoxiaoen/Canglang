%% **************************
%% 彩票系统数据结构
%% @author wpf(wprehard@qq.com)
%% **************************

%% 概率、机制等部分参考仙境寻宝的设定机制

%% 注意：当数据表有改动时，无论是否重启，都需要设置奖池的is_change标识位，玩家的抽奖信息表才能更新

%% 抽奖费用
-define(LUCKY_LOSS, 2000).
-define(LUCKY_TO_POOL, 1000).
-define(LUCKY_FREE, 2).
%% 虚拟奖品ID
-define(FIRST_PRIZE_ID, 30008). %% 匹配图标ID
-define(FIRST_PRIZE_NUM, 100000).  %% 10w铜币
-define(SECOND_PRIZE_ID, 30015).
-define(THIRD_PRIZE_ID, 30016).
%% 安慰奖500铜币奖品ID
-define(LAST_PRIZE_ID, 30000).
-define(LAST_PRIZE_NUM, 500).       %% 500铜币
%% 系统
-define(FLOAT_INTERVAL_TIMER, 43200). %% 头奖概率翻倍检查间隔
-define(LUCKY_CD, 2).   %% 抽奖CD间隔:秒
-define(LUCKY_LEV_MIN, 40). %% 角色等级限制
%% 限制分类
-define(LIMIT_ROLE, 1).
-define(LIMIT_GLOBAL, 2).

%% 奖池当前状态
-record(lottery_state, {
        bonus = 0           %% 当前头奖的累积奖金（铜币）
        ,is_change = 0      %% (暂时不用)标识:1-奖品列表有在线更新 0-无 下次停服更新后重置
        ,interval_free = 0  %% 概率区间（启动时计算）
        ,interval_pay = 0   %% 付费概率区间（启动时计算）
        ,rands = []         %% 浮动概率列表: [{Id, NowRand, Num} | ...]
                            %% NowRand:当前浮动概率 Num:当前定时内是开出次数
                            %% 暂用于头奖概率可浮动（每天定时器检查是否需要概率翻倍，奖品开出时重置）
        ,float_end = 0      %% 浮动概率结算时间戳(定时器中止时间): 启动时检测，抽中后重置
        ,last_time = 0      %% 头奖上次得奖时间
        ,info = []          %% 全服物品抽奖信息[#lottery_info{} | ...]
        ,last_first = 0     %% 上期头奖得主{rid, srvid, name, award_num}
        ,log = []           %% 最近珍品得主[#lottery_log{} | ...]
    }).

%% 抽奖日志
-record(lottery_log, {
        rid = 0             %% 角色ID
        ,srv_id = <<>>      %% 角色服务器标识
        ,name = <<>>        %% 角色名
        ,award_id = 0             %% 奖品ID
        ,award_num = 0            %% 奖励个数（如果是金币资产，则表明金额)
        ,ctime = 0          %% 时间
    }).

%% 彩票奖品的基础信息设定
-record(lottery_item, {
        base_id = 0             %% 奖品ID
        ,name = <<>>            %% 物品名称
        ,num = 0                %% 奖励数量
        ,is_notice = 0          %% 0：不公告 1：公告
        ,rand = 0               %% 概率分子
        ,limit = 0              %% 限制（1-玩家；2-全服）
        ,limit_time = {0, 0}    %% 单位时间内个数限制{X, Y}, X秒时间内只出Y个; Y等于0时表示此项限制无效
        ,limit_num = {0, 0}     %% {X,Y} 物品出X个后，需要再抽Y次才能出; Y等于0时表示此项限制无效
        ,must_num = 0           %% X次抽奖未出后必出; 等于0时表示此项限制无效
    }).

%% 抽奖玩家信息记录
-record(lottery, {
        free = 0               %% 免费次数
        ,last_time = 0         %% 上次抽奖时间
        ,last_award = []       %% 上次奖品
        ,free_info = []        %% 免费开奖限制信息记录[#lottery_info{} | ...]
        ,pay_info = []         %% 付费开奖限制信息记录[#lottery_info{} | ...]
    }).

%% 抽奖玩家的物品相关记录
-record(lottery_info, {
        base_id = 0            %% 奖品ID
        ,last_time = 0         %% 上次抽到时间 0标示未抽到
        ,time_info = {0, 0}    %% {X,Y}:X表示时间限制终点；Y标示目前已开出次数；超时后重置
        ,num_info = {0, 0}     %% {X,Y}:X表示已抽中个数；Y表示抽空次数；超次数后重置
        ,lucky_num = 0         %% 已抽奖X次
    }).

%% 晶钻转盘数据结构
-record(lottery_gold, {
        gold = 0    %% 奖励晶钻
        ,pro = 0    %% 概率值
    }).
