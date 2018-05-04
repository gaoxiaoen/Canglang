%%----------------------------------------------------
%% 仙道会相关数据结构定义
%% 
%% @author yankai@jieyou.cn
%%----------------------------------------------------

%% 仙道会个人战绩
-record(world_compete_mark, {
        id = {0, 0},        %% 角色ID
        name = <<>>,        %% 角色名称
        lev = 0,            %% 角色等级
        career = 0,
        sex = 0,
        looks = [],
        eqm = [],

        combat_count = 0,   %% 一次活动时间中的战斗次数
        win_count = 0,      %% 胜利场数
        loss_count = 0,     %% 失败场数
        draw_count = 0,     %% 平局场数
        ko_perfect_count = 0,       %% 完胜场数
        continuous_win_count = 0,   %% 连续胜利场数
        continuous_loss_count = 0,  %% 连续失败场数
        continuous_draw_count = 0,   %% 连续平局场数
        gain_lilian = 0,    %% 获得的历练数（排序用）
        win_rate = 0,       %% 胜率（排序用）
        
        %% 各种仙道会类型的数据
        win_count_11 = 0,
        combat_count_11 = 0,
        gain_lilian_11 = 0,
        win_count_22 = 0,
        combat_count_22 = 0,
        gain_lilian_22 = 0,
        win_count_33 = 0,
        combat_count_33 = 0,
        gain_lilian_33 = 0,

        %% 每日战绩
        win_count_today = 0,     %% 当天胜利场数
        role_power = 0,
        pet_power = 0,

        %% 打败过的最强对手战斗力
        win_top_power = 0,

        %% 更新的时间
        update_time = 0,

        %% 段位信息
        section_mark = 0,        %% 段位积分
        section_lev = 1        %% 段位等级
    }
).

%% 仙道会平台管理器
-record(world_compete_platform_mgr, {
        name,    %% 名称
        type,    %% 仙道会类型
        pid = 0
    }
).

%% 报名队伍
-record(sign_up_team, {
        id = [],                %% [{Rid, SrvId}]
        total_power = 0,
        match_count = 0,        %% 匹配次数
        match_latitude = 0,     %% 匹配波动值
        section_mark = 0,
        section_lev = 1,
        lineups = [],       %% 阵法 [阵法技能id]
        selected_lineup = 0     %% 选择的阵法id
    }
).

%% 报名队伍中的一个人
-record(sign_up_role, {
        id = {0, 0},        %% 角色id
        name = <<>>,        %% 名称
        career = 0,         %% 职业
        sex = 0,            %% 性别
        lev = 0,            %% 等级
        attr,               %% #attr{}
        looks = [],         %% 外观
        eqm = [],           %% 装备
        pet_power = 0,      %% 宠物战斗力
        lineups = [],       %% 阵法 [阵法技能id]

        status = 0,         %% 状态
        map_id = 0,
        map_pid = 0,         %% 战区地图pid
        enter_point = {0, 0},
        origin_teammate_ids = [],    %% 报名时的原始队友id [{Rid, SrvId}]，不包含自己

        section_mark = 0,
        section_lev = 1
    }
).

%% 仙道会段位信息
-record(world_compete_section_data, {
        lev = 1,            %% 等级
        mark = 0,           %% 最低段位积分要求
        next_mark = 0,      %% 进阶需要的积分
        base_lilian = 0,    %% 基础历练值
        day_lilian = 0,     %% 每日历练奖励
        day_attainment = 0, %% 每日阅历奖励
        day_item_rewards = [],   %% 每日物品奖励
        section_over_rewards = []   %% 赛季结束奖励 [{ItemBaseId, Bind, Quantity}]
    }
).

-define(LOCK_SCREEN_TIME, 1000 * 60 * 2).   %% 锁屏时间（毫秒）
-define(PREPARE_COMBAT_MAP_BASE_ID, 30004).   %% 准备区地图base id
-define(PREPARE_COMBAT_MAP_XY1, {600, 1050}).   %% 进入准备区地图坐标1
-define(PREPARE_COMBAT_MAP_XY2, {1800, 1050}).   %% 进入准备区地图坐标2

-define(WORLD_COMPETE_ROLE_STATUS_NORMAL, 0).   %% 没报名
-define(WORLD_COMPETE_ROLE_STATUS_SIGNUP, 1).   %% 已报名，等待匹配
-define(WORLD_COMPETE_ROLE_STATUS_MATCHED, 2).  %% 已匹配

-define(WORLD_COMPETE_TYPE_11, 11).  %% 1v1
-define(WORLD_COMPETE_TYPE_22, 22).  %% 2v2
-define(WORLD_COMPETE_TYPE_33, 33).  %% 3v3

-define(world_compete_period1, 1).      %% 活动时间段1
-define(world_compete_period2, 2).      %% 活动时间段2

-define(WORLD_COMPETE_GROUP_NEW, 1).        %% 仙道会分组：新秀
-define(WORLD_COMPETE_GROUP_JINGRUI, 2).    %% 仙道会分组：精锐
-define(WORLD_COMPETE_GROUP_LINGYUN, 3).    %% 仙道会分组：凌云
-define(WORLD_COMPETE_GROUP_WUSHUANG, 4).   %% 仙道会分组：无双
-define(WORLD_COMPETE_GROUP_JINGSHI, 5).    %% 仙道会分组：惊世
-define(WORLD_COMPETE_GROUP_DIANFENG, 6).   %% 仙道会分组：巅峰
-define(WORLD_COMPETE_GROUP_SHASHEN, 7).    %% 仙道会分组：杀神

-define(SIGN_UP_MAX_NUM, 4).            %% 每种仙道会比赛的最大报名数
