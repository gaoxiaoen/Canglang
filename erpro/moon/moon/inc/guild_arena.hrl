%%----------------------------------------------------
%% @doc 新帮战配置数据
%% 
%% @author Jangee@qq.com
%% @end
%%----------------------------------------------------
-ifdef(debug).
-define(guild_arena_member_need, 1).  %% 帮派参战在线人数要求
-else.
-define(guild_arena_member_need, 1).  %% 帮派参战在线人数要求
-endif.

-define(CENTER_CALL(F, A), center:call(?MODULE, F, A)).
-define(CENTER_CALL(M, F, A), center:call(M, F, A)).
-define(CENTER_CAST(F, A), center:cast(?MODULE, F, A)).
-define(CENTER_CAST(M, F, A), center:cast(M, F, A)).
-define(CENTER_NCALL(S, M, F, A), c_mirror_group:call(node, S, M, F, A)).
-define(CENTER_NCAST(S, M, F, A), c_mirror_group:cast(node, S, M, F, A)).
-define(CENTER_CAST_ALL(M, F, A), c_mirror_group:cast(all, M, F, A)).

-define(guild_arena_sign_time, {19, 40, 0}).  %% 帮战开始准备时间
-define(guild_arena_sign_timeout, 19 * 60000).  %% 帮派报名只能在 19分钟内
-define(guild_arena_join_timeout, 180000).      %% 角色加入战区只能在3两分钟内
-define(guild_arena_interval, 3600 * 24 * 2).  %% 帮战开启时间间隔目前每隔两天一次
-define(guild_arena_round_interval, 60000 * 30).  %% 每轮时间 8分钟
-define(guild_arena_rest_interval, 60000).  %% 中场休息1分钟
-define(guild_arena_stay_interval, 20000).  %% 战区结束后可以停留20秒
-define(guild_arena_max_round_num, 3).  %% 最多3轮战斗
-define(guild_arena_level, 5).  %% 帮派参战等级要求
-define(guild_arena_area_guild_num, 10). %%预设每个战区的帮派数
-define(guild_arena_protect_time, 10). %%复活后有10秒的保护时间
-define(guild_arena_area_map, 33101).    %% 战区地图
%-define(guild_arena_map_enter_point, {{1980, 2220}, {2820, 2720}}).
-define(guild_arena_map_enter_point, [{360, 2370}, {480, 2220}, {660, 2100}, {900, 1920}, {1140, 1770}, {1440, 1650}, {1320, 1320}, {1200, 1440}, {1680, 1320}, {1560, 1140}, {2160, 1230}, {2160, 1470}, {2460, 1320}, {2520, 1320}, {2400, 1620}, {2700, 1530}, {2940, 1500}, {2760, 1740}, {3300, 1410}, {3000, 1290}, {3540, 1620}, {3540, 1800}, {3540, 2070}, {3840, 1980}, {3960, 1890}, {3660, 2280}, {3900, 2220}, {3780, 2490}, {4020, 2370}, {4140, 2250}, {3780, 2670}, {3900, 2670}, {3960, 2670}, {4200, 2640}, {4320, 2730}, {3780, 2910}, {4020, 2940}, {4200, 2970}, {3660, 3090}, {3840, 3150}, {4080, 3210}, {4320, 3210}, {3780, 3420}, {4020, 3450}, {4260, 3480}, {4440, 3480}, {3720, 3630}, {3840, 3780}, {4140, 3900}, {4140, 3750}, {3300, 3690}, {3480, 3900}, {3540, 3990}, {3540, 4020}, {2880, 3810}, {2940, 3930}, {2820, 4020}, {2520, 3630}, {2400, 3810}, {2580, 4050}, {2340, 4020}, {2820, 3480}, {2460, 3240}, {2100, 3360}, {1860, 3690}, {1980, 3510}, {1800, 3840}, {1860, 4050}, {1380, 3930}, {1500, 4110}, {1560, 3690}, {1500, 3510}, {1260, 3600}, {1080, 3750}, {840, 3510}, {1080, 3390}, {1380, 3210}, {1080, 3030}, {900, 3150}, {600, 3240}, {540, 2850}, {780, 2850}, {1140, 2790}, {1260, 2610}, {1080, 2520}, {840, 2460}, {660, 2310}, {1080, 2130}, {1260, 2250}, {1440, 2070}, {780, 1620}, {900, 1290}, {3540, 1230}, {3000, 2370}, {2400, 2340}, {1920, 2520}, {2220, 2820}, {2580, 2880}, {2880, 2790}, {2460, 2610}]).
-define(guild_arena_ready_map, 33102).
%% 1080 600
-define(guild_arena_ready_map_enter_point, {{1040, 560}, {1120, 640}}).
-define(leave_guild_arena_point, {10003, 2832, 1002}).
-define(guild_arena_role_max_die, 5). %% 个人每轮最多死亡次数
-define(guild_arena_total_time, 30 * 60). %% 整个活动大概要30分钟
-define(guild_arena_stone_score, 30). %% 每次采集仙石获得积分
-define(guild_arena_list_size, 11). %% 活动各种列表每页显示多少条
-define(guild_arena_panel_size, 5). %% 活动各种小面板列表每页显示多少条
-define(guild_arena_state_idle, 0). %% 活动状态ID
-define(guild_arena_state_sign, 1). %% 活动状态ID
-define(guild_arena_state_ready, 2). %% 活动状态ID
-define(guild_arena_state_round, 3). %% 活动状态ID
-define(guild_arena_state_rest, 4). %% 活动状态ID
-define(guild_arena_state_finish, 5). %% 活动状态ID
-define(guild_arena_stone_base_id1, 60280). %% 仙石ID1
-define(guild_arena_stone_base_id2, 60281). %% 仙石ID2
-define(guild_arena_collect_timeout, 6). %% 仙石采集服务端需要4秒
-define(guild_arena_area_blocks, [602861, 602862, 602871, 602852, 602851]). %% 战区障碍物
-define(guild_arena_round_score, 100). %% 每一轮胜利者再奖励积分
-define(guild_arena_round_win, 1). %% 每轮胜利标识
-define(guild_arena_round_lost, 2). %% 每轮失败标识
-define(guild_arena_finish_win, 3). %% 最后一轮胜利标识
-define(guild_arena_finish_lost, 4). %% 最后一轮失败标识
-define(guild_arena_reward_guild_no1, [{29114, 1, 3}, {25021, 1, 10}]).
-define(guild_arena_reward_guild_no2, [{29115, 1, 3}, {25021, 1, 6}]).
-define(guild_arena_reward_guild_no3, [{25021, 1, 6}]).
-define(guild_arena_reward_role_no1, [{29118, 1, 2}]).
-define(guild_arena_reward_role_no2, [{29118, 1, 1}, {29119, 1, 1}]).
-define(guild_arena_reward_role_no3, [{29119, 1, 2}]).
-define(guild_arena_reward_role_join, [{29119, 1, 1}]).

-define(guild_arena_winner_buffer, guild_war_winer). %% 帮战胜利帮会的buff(目前采用阵营战同一套buff)
-define(guild_arena_cross_winner_buffer, guild_arena_cross). %% 跨服帮战buff 
-define(guild_arena_cross_join_buffer, guild_arena_cross_join). %% 跨服帮战buff 

%% 参战帮派记录
-record(arena_guild,
    {
        id,
        name,
        lev,
        chief, %% 帮主
        member_num, %% 帮派成员数
        members = [],
        join_num = 0, %% 参战人成员数
        kill = 0, %% 杀敌次数
        lost = 0, %% 失败次数
        stone = 0, %% 仙石积分
        die = 0,  %% 本轮死亡次数
        aid = 0, %% 战区ID
        fc = 0, %% 战斗力
        score = 0, %% 积分
        round_score = {0, 0, 0}, %% 每一轮的积分分别记录
        sum_score = 0, %% 总积分
        sum_stone = 0, %% 总仙石积分
        sum_kill = 0, %% 总杀敌次数
        sum_lost = 0, %% 总失败次数
        map           %% 帮派准备区
    }).

%% 参战玩家个人记录
-record(guild_arena_role,
    {
        id,
        pid,
        name,
        lev,
        gid,
        career,
        guild_name = [],
        position = 0, %% 职位
        kill = 0, %% 杀敌次数
        lost = 0, %% 失败次数
        stone = 0, %% 仙石积分
        die = 0,  %% 本轮死亡次数
        aid = 0, %% 战区ID
        offline = 0, %% 是否离线
        fc = 0, %% 战斗力
        is_fighting = 0, %% 是否在战斗中
        score = 0, %% 积分
        sum_score = 0, %% 总积分
        sum_stone = 0, %% 总仙石积分
        sum_kill = 0, %% 总杀敌次数
        sum_lost = 0, %% 总失败次数
        last_death = 0, %% 最后一次被杀时间
        is_camp_adm_time %% 是否后台活动时间 true | false
    }).

%% 战区记录
-record(arena_area,
    {
        id,
        map,
        winner = 0,
        id_name,   %% 广播或邮件里用到的分区号
        stone = 0, %% 仙石总数
        guild_num = 0, %% 本战区帮派数
        guild_die = 0, %% 本战区被干掉帮派数
        gids = [],  %% 帮派ID列表
        guild_rank = [], %% 帮派排名
        guild_points = [], %% 帮派进入点列表
        enters = [], %% 初始进入点分配
        area_pid = 0    %% 跨服战区进程
    }).

%% 跨服玩家个人记录
-record(guild_arena_role_cross,
    {
        id,
        name,
        lev,
        gid,
        career,
        fc,
        guild_name = <<>>,
        position = 0, %% 职位
        current_score = 0, %% 当轮积分
        round_score = 0,    %% 三轮积分
        total_score = 0     %% 总积分
    }).

%% 跨服帮派记录
-record(guild_arena_guild_cross,
    {
        id,
        name,
        lev,
        chief, %% 帮主
        member_num = 0, %% 帮派成员数
        current_score = 0, %% 当轮积分
        round_score = 0,    %% 三轮积分
        total_score = 0     %% 总积分
    }).
