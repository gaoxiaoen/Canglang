%%----------------------------------------------------
%% @doc 世界boss模块
%%
%% <pre>
%% 世界boss模块
%% </pre> 
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------

%% boss信息(动态)
-record(boss, {
        npc_id = 0         %% NpcBaseId
        ,pid                %% 进程ID
        ,npc_name = <<>>    %% Npc名称
        ,npc_lev = 0        %% Npc等级
        ,kill_time = 0      %% 被杀时间 
        ,relive_time = 0    %% 重生时间
        ,status = 0         %% 状态[0:活跃 非0:距离下次一刷新剩余时间]
        ,map_id = 0         %% 地图Id
        ,map_name = <<>>    %% 地图名称
        ,pos = {0, 0}       %% 重生位置
        ,killer = []        %% 杀手列表
        ,randomer           %% 随机中的人
    }
).

%% boss基础信息
-record(boss_base, {
        npc_id = 0          %% NpcBaseId 
        ,npc_lev = 0        %% Npc等级
        ,npc_name = <<>>    %% Npc名称
        ,map_id = 0         %% 场景Id
        ,map_name = <<>>    %% 场景名称
        ,interval = 0       %% 刷新间隔时间
        ,pos_list = []      %% 座标列表
    }
).

%% boss级别信息
-record(boss_lev_state, {
        lev = 0             %% 级别
        ,map_id = 0         %% 地图ID
        ,map_name = <<>>    %% 地图名称
        ,interval = 0       %% 刷新间隔时间
        ,kill_time = 0      %% 死亡时间
        ,kill_num = 0       %% 死亡数量
    }
).
%%-----------------------------------------------------------
%% 新世界boss
%%-----------------------------------------------------------
-record(boss_unlock, {
        npc_id = 0          %% NpcBaseId
        ,npc_name = <<>>    %% Npc名称
        ,lev = 0            %% Npc等级
        ,map_id = 0         %% 地图ID
        ,map_name = <<>>    %% 地图名称
        ,team_list = []     %% 杀手队伍列表[[{RoleId, SrvId, RoleName}]]
        ,kill_time = 0      %% 死亡时间
        ,relive_time = 0    %% 重生时间
        ,m_ref = undefined  %% 监控器引用
        ,status = 0         %% 状态[0:活跃 非0:距离下次一刷新剩余时间]
        ,pos = {0, 0}       %% 坐标
    }
).

-record(boss_unlock_group, {
        lev = 0             %% 级别
        ,map_id = 0         %% 地图ID
        ,map_name = <<>>    %% 地图名称
        ,interval = 0       %% 刷新间隔时间
        ,kill_time = 0      %% 死亡时间
        ,relive_time = 0    %% 重生时间
    }
).

%%-----------------------------------------------------------
%% 超级世界boss相关
%%-----------------------------------------------------------
-define(AREA_ROLE_MAX, 50).    %% 每个战斗区域容纳的人数上限

%% 世界boss信息
-record(super_boss, {
        hp = 0
        ,hp_max = 0
        ,is_die = 0
        ,npc_base_id = 0    %% NpcBaseId
        ,is_ultimate = 0
    }
).

-record(super_boss_scene, {
        map_id = 0
        ,pos = {0, 0}       %% 出现位置 {X,Y}
        ,enter_point = {0, 0}   %% 进入点 {X,Y}
        ,exit_map_id = 0
        ,exit_point = {0, 0}   %% 出口点 {X,Y}
    }
).

-record(super_boss_role, {
        rid = {0, 0},
        boss_pid = 0,
        enter_time = 0,
        total_dmg = 0,
        prev_dmg = 0,
        reward = 0,
        is_critical = false     %%是否暴击
    }
).

%% 超级boss战斗区域
-record(super_boss_area, {
        map_id = 0,
        map_pid = 0,
        roles = [],
        role_num = 0       %% 当前区域玩家数量
    }
).

%% 超级boss战斗区域角色
-record(super_boss_area_role, {
        rid = {0, 0},   %% {role_id, srv_id}
        pid = 0,
        conn_pid = 0,
        name = <<>>,
        career = 0,
        guild_name = <<>>,
        lev = 1,
        sex = 0,
        looks = [],
        eqm = [],
        map_id = 0,
        dead_time = 0       %% 死亡时间
    }
).

%% 世界boss战概要
-record(super_boss_summary, {
        id = 0,
        start_time = 0,
        boss_count = 0,
        killed_boss_count = 0,
        kill_count = 0,
        reward_count = 0,
        next_count = 0
    }
).

%% 每个世界boss的战况
-record(super_boss_info, {
        summary_id = 0,
        npc_base_id = 0,
        invaid_map_id = 0,
        kill_count = 0,
        last_rid = {0, <<>>},      %%最后一击，同时表明boss是否死亡
        best_rid = {0, <<>>}
    }
).


%% 超级boss战排行榜
-record(super_boss_rank, {
        summary_id = 0,
        rid = {0, <<>>},
        best_dmg = 0,
        total_dmg = 0,
        name = <<>>,
        career = 0,
        guild_name = <<>>,
        lev = 0,
        sex = 0,
        looks = [],
        eqm = []
    }
).

%% ------------------------------------
%% 跨服boss系统
%% ------------------------------------

%% micro
-define(DEF_C_BOSS_COUNT, 2). %% 默认每天可参加次数
-define(CROSS_BOSS_RANK_TYPE_1, 1). %% 天位挑战排行榜类型
-define(DEF_RANK_COUNT, 30). %% 排行榜个数
-define(DEF_RANK_PAGES, 10). %% 排行榜页数

%% 跨服boss系统数据
-record(cross_boss_state, {
        maps = []       %% 准备区地图映射关系
        ,halls = []      %% 准备区大厅映射关系[#cross_boss_mapping_hall{}|...]
        ,ts = 0         %% 状态机切换时间戳
        ,t_cd = 0       %% 当前状态持续时间(秒)
    }).

%% 分区映射关系
-record(cross_boss_map, {
        fight_lev = 0   %% 战力区间
        ,map_id = 0     %% 准备区地图ID
        ,map_pid = 0
        ,hall_id = 0    %% 大厅ID
        ,count = 0      %% 目前人数
    }).
-record(cross_boss_mapping_hall, {
        fight_lev = 0   %% 战力区间
        ,hall_id = 0
        ,hall_pid = 0
        ,maps = []      %% [MapId | ...]
    }).

%% 跨服挑战次数记录
-record(cross_boss_role_count, {
        role_id = 0     %% 玩家ID
        ,count = 0      %% 剩余挑战次数
        ,buy_cnt = 0    %% 购买次数
        ,last = 0       %% 上次挑战时间
        ,boss = []      %% 当天已经挑战的boss列表
    }).

%% 跨服boss已经发起的战斗
-record(cross_boss_combat, {
        combat_pid = 0      %% 战斗进程PID
        ,boss_id = 0        %% boss的ID
        ,hall_id = 0        %% 大厅ID
        ,room_no = 0        %% 房间ID
        ,round = 0          %% 参战回合数
        ,roles = []         %% 参战角色[#cross_boss_role{} | ...]
    }).

%% 跨服boss参战角色记录信息
-record(cross_boss_role, {
        id              %% 玩家id
        ,name           %% 玩家名字
        ,career         %% 职业
        ,lev            %% 等级
        ,sex            %% 性别
        ,guild_name     %% 帮会名字
        ,vip_type       %% vip类型
        ,fight          %% 战斗力
        ,looks = []     %% 外观
    }).

%% 跨服boss挑战榜单结构
-record(cross_boss_rank, {
        roles = []      %% 玩家信息[#cross_boss_role{} | ...]
        ,boss_id = 0    %% 挑战的BossID
        ,round = 0      %% 挑战回合数
    }).
