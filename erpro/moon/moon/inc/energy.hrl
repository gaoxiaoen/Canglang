%%----------------------------------------------------
%% 体力系统 
%%
%% @author ZSH
%%----------------------------------------------------

%% 距离凌晨的特定时间点的秒数
-define(time1, {12,0,0}).
-define(time2, {14,0,0}).
-define(time3, {18,0,0}).
-define(time4, {20,0,0}).

%-define(time1, {17,35,0}).
%-define(time2, {17,37,0}).
%-define(time3, {17,40,0}).
%-define(time4, {17,42,0}).

%% 领取在线体力ID
-define(online2, 1). %% 12~14点上线可以领
-define(online3, 2). %% 18~20这两个时间段上线即可领25点精力
-define(online_time, 7200). %% 在线时长 
-define(max_energy, 200).
-define(buy_add_energy, 100).   %% 每次购买体力数
-define(give_energy, 50).       %% 两个时间段送的体力

%%活跃度信息
-record(energy, {
    date                = 0,      %% unixtime 来表示日期
    buy_times           = 0,      %% 当日购买次数
    online_time         = 0,      %% 在线时长，在线满一小时赠送40点体力，第二天凌晨清0
    recover_time        = 0,      %% 每半个小时恢复5点的时刻，定时器开启时间
    next_time           = 0,      %% 下一次恢复的秒数,如果为0，说明当前没有定时器
    has_rcv_id          = []      %% 体力领取标志 [online1, online2, online3], 如果领了则记在列表中
}).


