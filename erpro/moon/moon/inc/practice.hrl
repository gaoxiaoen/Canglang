
%% macro
-define(practice_status_idel, 0).
-define(practice_status_start, 1).
-define(practice_status_stop, 2).

-define(practice_count, 1).  %% 每天可试练的次数

%% 试练结构
-record(practice, {
            hall_id         %% 大厅id
            ,hall_pid       %% 大厅pid
            ,map_id         %% 准备区地图ID
            ,map_pid        %% 准备区地图pid
            ,is_center = 0  %% 是否中央服跨服进程1-是0-否
            ,state_change_time = 0      %% 状态改变的时间点
            ,time_interval = 0          %% 状态持续的时间
            ,combats = []               %% 正在发生的战斗
            ,ranks = []                 %% 当前的排名
            ,last_ranks = []            %% 上一场的排名
            ,last_champion = false      %% 上一场的冠军
    }).

%% 试练玩家结构
-record(practice_role, {
            id              %% 玩家id
            ,pid            %% 玩家角色PID
            ,name           %% 玩家名字
            ,score          %% 积分
            ,career         %% 职业
            ,lev            %% 等级
            ,sex            %% 性别
            ,guild_name     %% 帮会名字
            ,vip_type       %% vip类型
            ,looks = []     %% 外观
    }).

%% 试练战斗结构
-record(practice_combat, {
            roles = []      %% 进入战斗的角色
            ,rank           %% 排名
            ,combat_pid     %% 战斗进程，用于标识这一场战斗
            ,score          %% 积分
            ,round          %5 回合
            ,room_no        %% 房间号
            ,wave           %% 波数
    }).

%% 试练波数数据
-record(practice_round_data, {
            round           %% 波数
            ,npc_base_id    %% 主怪的id
            ,score          %% 分数
            ,rewards = []   %% 物品奖励
    }).

