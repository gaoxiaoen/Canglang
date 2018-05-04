%%----------------------------------------------------
%% 帮会副本(塔防)数据结构定义
%% @author shawn 
%%----------------------------------------------------

-define(GUILD_TD_MAX_LEV, 25).
-define(GUILD_TD_DEFAULT_X, 314).   %% 默认副本点的X
-define(GUILD_TD_DEFAULT_Y, 450).   %% 默认副本点的Y

-define(GUILD_TD_MAP_ID, 1037).         %% 军团副本地图ID
-define(GUILD_TD_EXIT_MAP_ID, 1405).    %% 军团副本退出副认地图
-define(GUILD_TD_EXIT_X, 1374).
-define(GUILD_TD_EXIT_Y, 505).

-define(GUILD_TD_NOT_EXIST, 0). %% 不存在帮会 
-define(GUILD_TD_HAS_OPEN, 1). %% 已经开启

-define(GUILD_TD_KEEP_TIME, 15 * 60 * 1000). %% 持续时间 毫秒 
-define(GUILD_TD_TIME_IDEL, 6 * 1000). %% 空闲状态 毫秒
-define(GUILD_TD_TIME_PRE_START, 1 * 20 * 1000). %% 准备时间 毫秒
-define(GUILD_TD_TIME_PRE_STOP, 30 * 1000). %% 清理副本时间
-define(GUILD_TD_leave_guild_td, {10003, 2832, 1002}).

-define(GUILD_TD_STATE_READY, 0).  %% 准备期
-define(GUILD_TD_STATE_RUN, 1).  %% 正在进行中

%% 各种开启模式的当天时间秒数
-define( GUILD_TD_MODE_1, 36000).		%% 10点
-define( GUILD_TD_MODE_2, 37800).		
-define( GUILD_TD_MODE_3, 39600).	
-define( GUILD_TD_MODE_4, 41400).
-define( GUILD_TD_MODE_5, 43200).
-define( GUILD_TD_MODE_6, 45000).
-define( GUILD_TD_MODE_7, 46800).
-define( GUILD_TD_MODE_8, 48600).
-define( GUILD_TD_MODE_9, 50400).
-define( GUILD_TD_MODE_10, 52200).
-define( GUILD_TD_MODE_11, 54000).
-define( GUILD_TD_MODE_12, 55800).
-define( GUILD_TD_MODE_13, 57600).
-define( GUILD_TD_MODE_14, 59400).
-define( GUILD_TD_MODE_15, 61200).
-define( GUILD_TD_MODE_16, 63000).
-define( GUILD_TD_MODE_17, 64800).
-define( GUILD_TD_MODE_18, 66600).
-define( GUILD_TD_MODE_19, 68400).
-define( GUILD_TD_MODE_20, 70200).
-define( GUILD_TD_MODE_21, 72000).
-define( GUILD_TD_MODE_22, 73800).
-define( GUILD_TD_MODE_23, 75600).
-define( GUILD_TD_MODE_24, 77400).
-define( GUILD_TD_MODE_25, 79200).		%% 22:00

%% 开始模式
-define(GUILD_TD_START_1, 1).   %% 从第一波开始
-define(GUILD_TD_START_5, 5).   %% 从第五波开始
-define(GUILD_TD_START_10, 10). %% 从第十波开始

%% 副本进程数据结构
-record(guild_td,
    {
        guild_id = {0, <<>>} 
        ,guild_pid = 0
        ,enter_point 
        ,guild_lev = 0
        ,guild_name = <<>>
        ,map_pid = 0
        ,map_id = 0
        ,all_kill_npc = 0 %% 总杀小怪数
        ,all_kill_boss = 0 %% 总杀boss数
        ,hp = 10 %% 结界耐久 

        ,td_lev = 0     %% 波数
        ,surplus_npc = 0 %% 当前剩余怪数
        ,kill = 0 %% 当前波击杀怪数 
        ,summary_npc = 0 %% 当前波总怪数

        ,online_role = []
        ,enter_role = []

        ,ts = 0 %% 开始时间
        ,end_time = 0 %% 终止时间 
        ,start_lev = 1  %% 开始波数
    }
).

%% 
-record(role_td,
    {
        id 
        ,pid = 0
        ,name = <<>>
        ,lev = 0
        ,fight = 0
        ,position = 0
        ,kill_npc = 0
        ,kill_boss = 0
    }
).
