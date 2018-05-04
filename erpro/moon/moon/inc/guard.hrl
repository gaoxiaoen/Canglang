%%----------------------------------------------------
%% 守卫洛水(塔防)数据结构定义
%% @author shawn 
%%----------------------------------------------------

-define(GUARD_MAP_ID, 10003).
-define(GUARD_MAX_LEV, 30).

-define(GUARD_KEEP_TIME, 30 * 60 * 1000). %% 持续时间 毫秒 
-define(GUARD_TIME_IDEL, 4 * 1000). %% 空闲状态 毫秒
-define(GUARD_TIME_PRE_START, 3 * 60 * 1000). %% 准备时间 毫秒
-define(GUARD_TIME_PRE_STOP, 6 * 1000). %% 清理副本时间

-define(GUARD_SYNC_TIME, 10 * 1000). %% 同步时间 毫秒

-define(GUARD_STATE_OVER, 0).
-define(GUARD_STATE_READY, 1).
-define(GUARD_STATE_RUN, 2).

-define(guard_trans_map, {10003, 3360, 2370}).
-define(guard_trans_npc, {10003, 600, 690}).

-define(GUARD_START_TIME, 20 * 3600).

-define(GUARD_START_DAY, [2, 4, 6]).

-define(guardbuff, guard_honor).

-define(guard_counter_elem_wait, 40).

-define(guard_mode_atk, 1). %% 洛水反击
-define(guard_mode_dfd, 0). %% 洛水守卫

-define(guard_counter_boss_hp, 60000000).

%% 副本进程数据结构
-record(guard,
    {
        hp = 99 %% 结界耐久 

        ,td_lev = 0 %% 波数
        ,surplus_npc = 0 %% 当前剩余怪数
        ,kill = 0 %% 当前波击杀怪数 
        ,summary_npc = 0 %% 当前波总怪数

        ,npc_nums = 0 %% 当前场景怪的数量

        ,join_role = []
        ,map_pid = 0 %% 洛水PID 

        ,ts = 0 %% 开始时间
        ,end_time = 0 %% 终止时间 
    }
).

%% 洛水反击巨龙
-record(guard_super_boss,
    {
        hp = 0
        ,mp = 0
        ,hp_max = 0
        ,mp_max = 0
        ,is_die = 0
        ,kill_time = 0
    }
).

%% 
-record(role_guard,
    {
        id 
        ,rid
        ,srv_id
        ,name = <<>>
        ,career = 0
        ,lev = 0
        ,sex = 0
        ,guild_name = <<>>
        ,looks = []
        ,eqm = []
        ,kill_npc = 0
        ,kill_boss = 0
        ,point = 0
        ,all_point = 0
    }
).

%% 洛水反击
-record(guard_counter_role,
    {
        id = {0, <<>>}
        ,rid = 0
        ,srv_id = <<>>
        ,pid
        ,name = <<>>
        ,guild_name = <<>>
        ,career = 0
        ,lev = 0
        ,sex = 0
        ,looks = []
        ,eqm = []
        ,dead_time = 0
        ,is_die = 0 
        ,kill_npc = 0
        ,point = 0
        ,all_point = 0
    }
).

-record(guard_counter_clicker,
    {
        id = {0, <<>>}
        ,pid
        ,elem_id = 0
        ,click_time = 0
    }
).

-record(rank_guard,
    {
        id
        ,name = <<>>
        ,career = 9
        ,lev = 0
        ,point = 0
    }
).
