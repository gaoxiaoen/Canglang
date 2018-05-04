%%----------------------------------------------------
%% @doc 竞技场系统
%%
%% <pre>
%% 竞技场系统头文件
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------

%% 操作结果
-define(arena_op_succ,       1). %% 成功 
-define(arena_op_fail,       0). %% 失败

%% 级别
-define(arena_lev_low,       1). %% 初级
-define(arena_lev_middle,    2). %% 中级
-define(arena_lev_hight,     3). %% 高级
-define(arena_lev_super,     4). %% 超高级
-define(arena_lev_angle,     5). %% 仙 

%% 战场区号
%% -define(arena_seq_1,         1). %% 一区
%% -define(arena_seq_2,         2). %% 二区
%% -define(arena_seq_3,         3). %% 三区
%% -define(arena_seq_4,         4). %% 四区

%% 地图ID
-define(arena_prepare_map_id,       30001). %% 准备区地图Id
-define(arena_match_map_id,         30002). %% 竞技场地图Id

-define(arena_timeout_idel,         120 * 1000). %% 开服空闲时间后开始竞技活动 
-define(arena_timeout_notice,       120 * 1000). %% 活动通知时间(毫秒)
-define(arena_timeout_prepare,      300 * 1000). %% 准备时间 (毫秒)
-define(arena_timeout_match_pre,    180 * 1000). %% 前期比赛时候(毫秒)
-define(arena_timeout_matching,     1320 * 1000). %% 比赛时间 (毫秒)
-define(arena_timeout_expire,       300 * 1000). %% 逗留在准备区超时 (毫秒)
-define(arena_timeout_stop_combat,  180 * 1000). %% 停止所有战斗

-define(arena_timeout_prepare_cross,      300 * 1000). %% 准备时间 (毫秒) 显示时间
-define(arena_timeout_prepare_cross_st,   300 * 1000). %% 准备时间 (毫秒) 真实时间
-define(arena_timeout_match_pre_cross,    180 * 1000). %% 前期比赛时候(毫秒)

%% 战区Id
%% -define(arena_id_low_1,             1). %% 初级战区一区 
%% -define(arena_id_middle_1,          2). %% 中级战区一区 
%% -define(arena_id_hight_1,           3). %% 高级战区一区 
%% -define(arena_id_super_1,           4). %% 超级战区一区 
%% -define(arena_id_angle_1,           5). %% 仙级战区一区 
%% -define(arena_id_god_1,             6). %% 神级战区一区 

-define(arena_prepare_pos,          {1500, 1300}). %% 准备区传送点 
-define(arena_relive_dragon,          {720, 1050}). %% 虎白队复活点 
-define(arena_relive_tiger,         {3000, 1050}). %% 表龙队复活点 
-define(arena_exit,           {10003, 1525, 3405}). %% 出口 

-define(arena_group_dragon,         1). %% 青龙 离火
-define(arena_group_tiger,          2). %% 白虎 玄水

-define(arena_score_multiple,       5). %% 积分位数

-define(arena_player_least,         2). %% 开始比赛最少玩家数量
-define(arena_player_least_lev,     2). %% 高级别最少玩家数量

%% 竞技场玩家状态
-define(arena_role_status_idel,     0). %% 没有战斗机会 
-define(arena_role_status_prepare,  1). %% 准备区
-define(arena_role_status_match,    2). %% 战区
-define(arena_role_status_leave,    3). %% 离开竞技场
-define(arena_role_status_logout,   4). %% 下线

-define(arena_buff_label, arena_encourage). %% 竞技场组队buff名称
-define(arena_buff_score, arena_buff_score). %% 竞技场双倍积分buff

-define(arena_series_kill,          5). %% 连续杀人数就插公告

-define(arena_begin_time,       68700). %% 时间(秒)19:05
-define(arena_begin_time1,       50280). %% 时间(秒)14:05
-define(arena_begin_time2,       68700). %% 时间(秒)19:05
-define(arena_date_seconds,       86400). %% 时间(秒)19:05

-define(arena_box_id,           29100). %% 竞技场礼盒ID

-define(arena_type_role,        1).     %% 竞技场fighter类型：角色
-define(arena_type_npc,         2).     %% 竞技场fighter类型：角色

%% 竞技类型
-define(arena_sign_up_local,    1).   %% 本服竞技
-define(arena_sign_up_cross,    2).   %% 跨服竞技

-define(ARENA_CALL(F, A), center:call(?MODULE, F, A)).
-define(ARENA_CALL(M, F, A), center:call(M, F, A)).
-define(ARENA_CAST(F, A), center:cast(?MODULE, F, A)).
-define(ARENA_CAST(M, F, A), center:cast(M, F, A)).

-define(ARENA_NCALL(S, M, F, A), c_mirror_group:call(node, S, M, F, A)).
-define(ARENA_NCAST(S, M, F, A), c_mirror_group:cast(node, S, M, F, A)).

%% 战区信息
-record(arena_zone, {
        arena_lev = 0           %% 战区级别
        ,pre_seq = 0            %% 当前准备区索引,指定目前进入的是那个准备区
        ,pre_role_size = 0      %% 当前准备区人数
        ,pre_list = []          %% 准备区列表[#arena_prep{}]
        ,role_list = []         %% 指定级别的角色列表[#arena_role{}]
        ,arena_list = []        %% 竞技场信息[ArenaOnline::#arena_online{}]
        ,last_win               %% 上一场优胜者#arena_lw{}
    }
).

%% 准备区
-record(arena_pre, {
        pre_seq = 0            %% 准备区列表号
        ,map_id = 0             %% 地图Id
        ,map_pid                %% 地图进程Id
    }
).

%% 竞技场信息
-record(arena_online, {
        arena_id = {0, 0}       %% 战区Id {ArenaLev, ArenaSeq}
        ,arena_pid = 0          %% 战区进程Id
    }
).

%% 竞技场角色信息
-record(arena_role, {
        role_id = {0, <<>>}     %% 角色id {RoleId, SrvId}
        ,role_pid               %% 角色进程id
        ,name = <<>>            %% 角色名称
        ,lev = 0                %% 角色级别
        ,career = 6             %% 角色职业
        ,pre_seq = 0            %% 准备序号
        ,pre_map_id = 0         %% 准备区地图id
        ,pre_map_pid            %% 准备区地图Pid
        ,arena_id = 0           %% 战区id{ArenaLev, ArenaSeq}
        ,arena_pid              %% 战区进程id
        ,group_id = 0           %% 分组Id[0:未分组 1:青龙 2:白虎]
        ,arena_lev = 0          %% 战区级别
        ,arena_seq = 0          %% 战区序号
        ,death = 0              %% 死记次数
        ,kill = 0               %% 斩杀次数 总杀人数
        ,kill_added = 0         %% 已加人数
        ,mask = 0               %% 是否蒙面[0:不蒙面 1:蒙面]
        ,score = 0              %% 总积分
        ,score_added = 0        %% 已加积分 总积分 - 已加积分 = 待加积分
        ,fight_capacity = 0     %% 战斗力
        ,status = 0             %% 玩家状态 0:死了游离 1:准备区 2:战区 3:离开竞技场 4:下线了
        ,has_buff = 0           %% 0:否 1:是
        ,buff_time = 0          %% 增加时间 
        ,op_buff = 0            %% 增加buff次数
        ,last_death_time = 0    %% 上次死亡时间
        ,series_kill = 0        %% 连续杀人数
        ,type = 1               %% 类型[1:角色 2:npc]
    }
).

%% 汇总信息
-record(arena_report, {
        trole_id = 0            %% 白虎队最高分者(杀人数)
        ,tsrv_id = <<>>         %% 白虎队最高分的人
        ,tname = <<>>           %% 名称
        ,trole_kill = 0         %% 白虎队单人最高杀人数
        ,tkill_sum = 0          %% 白虎队总杀人数
        ,talive = 0             %% 白虎队存活人数
        ,drole_id = 0           %% 青龙队最高分者
        ,dsrv_id = <<>>         %% 青龙队最高分者
        ,dname = <<>>           %% 名称
        ,drole_kill = 0         %% 青龙队单人最高杀人数
        ,dkill_sum = 0          %% 青龙队总杀人数
        ,dalive = 0             %% 青龙队存活人数
        ,time = 0               %% 竞技场时间
        ,week = 0               %% 第几周
        ,robot_alive_dragon = 0 %% 青龙机器人数量
        ,robot_alive_tiger = 0  %% 白虎机器人数量
        ,tiger_list = []        %% 白虎队全部成员
        ,dragon_list = []       %% 青龙队全部成员
    }
).

%% 结算参数
-record(arena_sp, {
        send_13317 = 0          %% 是否发送
        ,send_13304 = 0         %% 是否发送
        ,role_pid               %% 角色进程ID
    }
).

%% 上一场优胜者
-record(arena_lw, {
        role_id = 0             %% 角色ID
        ,srv_id = <<>>          %% 服务器标志符
        ,name = <<>>            %% 角色名称
        ,kill = 0               %% 杀人数
    }
).

%% 竞技场英雄榜
-record(arena_hero_rank, {
        low = []                %% 底级[#arena_hero_zone{}]
        ,middle = []            %% 中级[#arena_hero_zone{}]
        ,hight = []             %% 高级[#arena_hero_zone{}]
        ,super = []             %% 超级[#arena_hero_zone{}]
        ,angle = []             %% 仙级[#arena_hero_zone{}]
    }
).

%% 级别英雄榜(战区)
-record(arena_hero_zone, {
        winner = 0              %% 胜方[0:平局 1:青龙 2:白虎]
        ,arena_seq = 0          %% 战区
        ,hero_list = []         %% 角色列表[#arena_hero{}]
    }
).

%% 英雄
-record(arena_hero, {
        role_id = 0             %% 角色ID
        ,srv_id = <<>>          %% 服务器标志符dd
        ,name = <<>>            %% 角色名称
        ,career = 6             %% 职业
        ,lev = 0                %% 级别
        ,group_id = 0           %% 分组
        ,kill = 0               %% 杀人数
        ,death = 0              %% 死亡
        ,score = 0              %% 积分
        ,arena_lev = 0          %% 级别
        ,arena_seq = 0          %% 战区
        ,winner = 0             %% 是否为胜者
    }
).
