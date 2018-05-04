%%----------------------------------------------------
%% NPC相关数据结构定义
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------

%% npc特殊类型
-define(npc_special_type_common, 0).    %% 普通
-define(npc_special_type_fly, 1).       %% 飞行怪

%% npc功能类型
-define(npc_fun_type_common, 0).        %% 普通
-define(npc_fun_type_frenzy, 1).        %% 狂暴怪
-define(npc_fun_type_guard, 6).        %% 守卫洛水怪 
-define(npc_fun_type_marry, 7).        %% 结婚活动道具npc
-define(npc_fun_type_marry_tour, 8).   %% 结婚活动道具npc(婚轿类)
-define(npc_fun_type_guild_war_white, 9). %% 帮战里的白盟机器人
-define(npc_fun_type_guild_war_red, 10).  %% 帮战里的红盟机器人
-define(npc_fun_type_guild_arena, 11).  %% 新帮战守卫
-define(npc_fun_type_npc_store_dung, 12).  %% 副本神秘老人
-define(npc_fun_type_task_wanted, 13).  %% 悬赏任务怪
-define(npc_fun_type_wokou, 14).    %% 岛国倭寇
-define(npc_fun_type_guild_boss, 15).  %% 帮会boss
-define(npc_fun_type_guild_td, 16).    %% 帮会副本怪
-define(npc_fun_type_guard_counter, 17).    %% 洛水反击小怪
-define(npc_fun_type_guard_counter_boss, 18).   %% 洛水反击BOSS
-define(npc_fun_type_drugstore, 19).   %% 神药阁悬赏怪
-define(npc_fun_type_guild_monster, 20).    %% 帮会怪物
-define(npc_fun_type_campaign_npc, 22).    %% 春节活动npc巡游
-define(npc_fun_type_treasure_store, 23).    %% 珍宝阁悬赏怪

%% npc ai的类型
-define(npc_ai_type_common, 0).         %% 普通
-define(npc_ai_type_nopet, 1).         %% 不打宠物

%% NPC基础数据
-record(npc_base, {
        id              %% ID
        ,type           %% 类型(0:固定，无进程 1:活动，需创建进程)
        ,looks_type = 0 %% 外形类型(1:功能NPC，2:任务NPC，3:男小怪，4:女小怪，5:男BOSS，6:女BOSS，7:男世界BOSS，8:女世界BOSS，9:中性普通小怪，10:副本男小怪，11:副本女小怪，12:副本中性小怪)
        ,fun_type = 0       %% 功能类型，用于标示怪物属于那个功能模块(0:无类型)
        ,special_type = 0   %% 0:普通怪，1:飞行怪
        ,name = <<>>    %% 名称
        ,lev = 1        %% 等级
        ,career = 0     %% 职业
        ,nature = 0     %% 性质(0:中立 1:敌对 2:友善, 3:可采集)
        ,hp = 1         %% 血量
        ,mp = 99999     %% 魔量
        ,hp_max = 1     %% 血量上限
        ,mp_max = 99999 %% 魔量上限
        ,lock = 0       %% 是否抢怪(0:不锁定 1:锁定)
        ,attr           %% 战斗属性
        ,skill = []     %% 拥有的技能
        ,rewards = []   %% 杀死怪物后的默认奖励
        ,slave = []     %% 随从怪
        ,talk = []      %% 对白
        ,speed = 180    %% 移动速度
        ,prepare_time = 15          %% 出招时间 单位秒
        ,t_trace = 1500             %% 追踪触发时间间隔(单位:毫秒)
        ,t_patrol = {5000, 8000}    %% 巡逻时间间隔(单位:毫秒)
        ,guard_range = 300           %% 警戒范围(单位:像素)
        ,off_trace_range = 300       %% 脱离追踪距离
        ,impression_ratio = 0       %% 好感度提升参数
        ,attack_type = 0            %% ?attack_type_melee | ?attack_type_range
    }
).

%% NPC数据
-record(npc, {
        id                  %% 唯一编号
        ,pid = 0            %% 进程ID(对于固定NPC这个值为0)
        ,combat_pid = 0     %% 战斗管理进程

        ,status = 0         %% 状态(0:正常状态, 1:战斗中)
        ,type = 0           %% 类型(0:固定，无进程 1:活动，需创建进程)
        ,fun_type = 0       %% 功能类型，用于标示怪物属于那个功能模块(0:无类型)
        ,special_type = 0   %% 特殊类型(0:普通怪，1:飞行怪)
        ,disabled = <<>>    %% 是否禁用(空表示未禁止击杀，否则为禁止原因)
        ,base_id = 0        %% 基础ID
        ,base = #npc_base{} %% NPC基础数据
        ,name = <<>>        %% NPC名字
        ,hp = 1             %% 血量
        ,mp = 1             %% 魔量
        ,hp_max = 1         %% 血量上限
        ,mp_max = 1         %% 魔量上限
        ,lev = 1            %% 等级
        ,career = 1         %% 职业
        ,nature = 0         %% 性质(0:中立 1:敌对 2:友善, 3:可采集)
        ,speed = 180        %% 移动速度
        ,slave = []         %% 随从怪
        ,talk = []          %% 对白
        ,pos                %% 位置信息
        ,attr               %% 战斗属性
        ,guard_range        %% 警戒范围
        ,off_trace_range    %% 脱离追踪距离
        ,paths = []         %% 预设的移动路径
        ,path = []          %% 当前选择的行走路径
        ,target = 0         %% 当前追踪的目标
        ,def_xy = {0, 0}    %% NPC进入地图时的默认地点

        ,ai = {[], []}      %% NPC的ai列表、已使用的AI列表

        ,ts = 0             %% 进入某状态时的时间戳
        ,t_patrol = 0       %% 巡逻时间间隔
        ,t_trace            %% 追踪时间间隔
        ,owner = 0          %% npc是谁开出来的（目前针对狂暴怪）
    }
).

%% npc ai规则
-record(npc_ai_rule, {
    id          %% 唯一编号
    ,type = 0   %% 类型, 0:普通类型，不做特殊处理， 1：忽略宠物
    ,repeat     %% 是否可重复， 0不可重复， 1可重复
    ,prob       %% 触发概率
    ,condition  %% 条件 [{Target, Key, Rela, Value, Count} | ..]  
                %% {Target, Key, Rela, Value, Count} = {目标标识, 目标的属性, 关系符, 比较的值, 数量}  
    ,action     %% 行为 [{Target, Type, Param} | ...]
                %% {Target, Type, Param} = {目标标识, 行为的类别, 参数}
    }).

%% 战斗场景的基本信息， 用于参数传到npc ai模块
-record(combat_scene, {
        self_side,  %% 本方fighter 
        opp_side,   %% 对方fighter
        round       %% 回合数
    }).   

%% 主城的荣耀npc
-define(npc_special_honour, 1).

%% 特殊NPC
-record(npc_special, {
        npc_base_id,    %% 标识哪个NPC
        type,           %% 特殊的类型
        behaviour,      %% 特殊行为标识
        data           %% 特殊npc的数据
    }).

%% NPC好感度
-record(npc_impression, {
        role_id = 0,        %% 角色id
        srv_id = <<>>,      %% 角色server id
        npc_base_id = 0,    %% npc基础id
        impression = 0      %% 好感度
    }).


