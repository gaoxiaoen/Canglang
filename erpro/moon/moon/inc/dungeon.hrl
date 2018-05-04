%%----------------------------------------------------
%% 副本相关数据结构
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-define(dungeon_type_clear, 0).  %% 清除模式
-define(dungeon_type_expedition, 1).      %% 多人副本
-define(dungeon_type_hide, 2).      %% 隐藏副本
-define(dungeon_type_survive, 3).      %% 生存模式
-define(dungeon_type_time, 4).         %% 限时模式
-define(dungeon_type_story, 5).         %% 剧情模式

-define(dungeon_type_leisure, 8).         %% 休闲模式

%%副本目标
-define(goal_type_clear, 0).      %% 通关
-define(goal_type_round, 1).      %% 限制回合数
-define(goal_type_kill_count, 2).      %% 杀怪数
-define(goal_type_hurt, 3).      %% 限制伤害承受量
-define(goal_type_no_deamon, 4).      %% 不带契约兽
-define(goal_type_top_harm, 6).      %% 最高伤害

-define(dungeon_clear_time, 60). %%副本扫荡时间间隔，单位为秒
-define(clear_loss, 1).          %%副本扫荡立即完成每次消耗晶钻数量，单位为个

%% 副本进程状态
-record(dungeon, {
        id = 0                      %% 副本基础编号
        ,type = 0                   %% 副本类型
        ,args = []                  %% 不同类型副本相关数据

        ,name = <<>>                %% 副本名称
        ,owner = 0                  %% 副本所有者，组队情况下所有者为队长
        ,online_roles = []          %% 副本里的在线玩家     #dungeon_role
        ,offline_roles = []         %% 副本里掉线的玩家
        ,enter_roles = []           %% 曾经进入过的玩家
        ,cond_enter = []            %% 进入条件
        ,maps = []                  %% 该副本包含的地图列表[BaseId]
        ,enter_point = {0, 0, 0}    %% 副本的进入点{地图BaseId, X坐标, Y坐标}
        ,ts = 0
        ,extra = []                      %% 特殊字段，可用于不同副本的数据需求
        ,event_handler              %% 副本事件处理器

        ,combat_round = 0           %% 副本内所有战斗的总回合
        ,kill_count = 0             %% 杀怪数

        ,floor = 1                  %% 用于塔的跨层
        ,is_cross = false           %% 是否跨服
        ,combat_status              %% 战斗状态
        ,combat_pid                 %% 战斗pid
    }
).

%% 副本基础数据
-record(dungeon_base, {
        id                          %% 副本ID
        ,type = 0                   %% 类型
        ,show_type = 1              %% 显示类型(大副本 1 小副本 0)
        ,args = []
        ,name = <<>>                %% 副本名称
        ,cond_enter = []            %% 进入条件
        ,maps = []                  %% 该副本包含的地图列表[BaseId]
        ,enter_point = {0, 0, 0}    %% 副本的进入点{地图BaseId, X坐标, Y坐标}

        ,pay_limit = 0              %% 购买上限
        ,energy = 0                 %% 体力消耗
        ,pet_exp = 0                %% 宠物经验
        ,first_rewards = []
        ,clear_rewards = []         %% 通关的奖励
        ,cards_id = 0               %% 翻牌物品ID
        ,first_cards_rewards = undefined    %% 首次通关翻牌

        ,boss_id = []               %% 副本的boss_id
        ,random_event = []          %% 副本地图元素随机事件
    }
).

%% 副本地图数据
-record(dungeon_map_base, {
        id = 0              %% 地图id
        ,total_blue = 0
        ,total_purple = 0      
        ,blue_rewards = []
        ,purple_rewards = []
        ,last_normal_id = 0
        ,first_hard_id = 0
    }
).

%% 副本随机事件
-record(dungeon_random_event, {label, value, msg}). 

%% 副本在线玩家数据
-record(dungeon_role, {
        rid                 %% 玩家id
        ,pid = 0            %% 玩家pid
        ,conn_pid = 0
        ,name = <<>>        %% 玩家名称
        ,sex = 0            %% 玩家性别
        ,career = 1         %% 玩家职业
        ,clear_count = 1    %% 0表示首次通关

        ,top_harm = 0       %% 最高单次伤害
        ,total_hurt = 0     %% 承受的总伤害
        ,combat_round = 0   %% 回合
        ,has_demon = false  %% 是否带契约兽
        ,goals = 0         %% 副本目标
        ,star = 0               %% 星级 3, 2, 1
}).

%% 副本星星目标
-record(dungeon_goal, {
        id = 0              %% 目标id
        ,type = 0           %% 目标类型
        ,args = []           %% 参数
        ,star = 0           %% 星星数
}).

%% 副本挂机
-record(dungeon_auto_role, {
        rid                 %% 玩家id
        ,dungeon_id        %% 副本id
        ,auto_count         %% 挂机次数
        ,start_time         %% 开始挂机时间
        ,end_time           %% 挂机结束时间
}).

%% 副本挂机数据
-record(dungeon_auto_base, {
        id                  %% 副本id
        ,npcs = []          %% 副本里的怪
}).

%% 玩家当前的副本状态
-record(dungeon_ext, {
        id = 0         %%副本id
        ,type = 0       %%副本类型
    }).

%% 玩家当前的副本状态
-record(role_dungeon, {
        id
        ,best_star = 0
        ,reach_goals = 0         %%达成条件：二进制表示
        ,clear_count = 0
        ,enter_count = 0
        ,paid_count = 0
        ,last = 0
    }).
