%%============================================
%% 场景相关数据结构定义
%%============================================
-ifndef(DUNGEON_HRL).
-define(DUNGEON_HRL, 1).
-include("server.hrl").
-include("scene.hrl").

-define(ETS_DUN_MB_POS, ets_dun_mb_pos).

-record(ets_dun_mb_pos, {
    pkey = 0,
    scene = 0,
    x = 0,
    y = 0,
    copy = 0
}).

%% 副本类型定义.
-define(DUNGEON_TYPE_NORMAL, 0).     %% 普通副本.
-define(DUNGEON_TYPE_GOD_WEAPON, 1).%%神器副本
-define(DUNGEON_TYPE_ARENA, 3).          %%竞技场
-define(DUNGEON_TYPE_EXP, 7).%%经验副本
-define(DUNGEON_TYPE_MATERIAL, 8).%%材料副本
-define(DUNGEON_TYPE_CROSS, 12).%%跨服组队副本
-define(DUNGEON_TYPE_TOWER, 13).%%九霄塔副本
-define(DUNGEON_TYPE_DAILY, 14).%%每日副本,剧情,神器,灵脉,仙器
-define(DUNGEON_TYPE_KINDOM_GUARD, 15).%%王城守卫
-define(DUNGEON_TYPE_GUILD_DEMON, 16). %%仙盟妖魔入侵
-define(DUNGEON_TYPE_VIP, 17).%% vip副本
-define(DUNGEON_TYPE_FUWEN_TOWER, 18). %% 符文塔副本
-define(DUNGEON_TYPE_GUARD, 19). %% 守护副本
-define(DUNGEON_TYPE_MARRY, 20). %% 爱情试炼
-define(DUNGEON_TYPE_CHANGE_CAREER, 21). %% 转职副本
-define(DUNGEON_TYPE_EQUIP, 22). %% 神装副本
-define(DUNGEON_TYPE_XIAN, 23). %% 仙装副本
-define(DUNGEON_TYPE_CROSS_GUARD, 24).%%跨服组队副本
-define(DUNGEON_TYPE_GODNESS, 25). %% 神祇副本
-define(DUNGEON_TYPE_ELITE_BOSS, 26). %% 精英bossVIP副本
-define(DUNGEON_TYPE_GUILD_FIGHT, 27). %% 公会对战副本
-define(DUNGEON_TYPE_ELEMENT, 28). %% 元素副本
-define(DUNGEON_TYPE_JIANDAO, 29). %% 剑道副本

-define(DUN_EXIT_CLICK_BUTTON, 1).  %% 1.玩家点击退出按钮,
-define(DUN_EXIT_NO_TIME, 2).       %% 2.副本时间结束.
-define(DUN_EXIT_PLAYER_LOGOUT, 3). %% 3.玩家下线.
-define(DUN_EXIT_OTHER, 4).         %% 4.异常退出.
-define(DUN_EXIT_JIESUAN, 5).       %% 5.副本结算退出.
-define(DUN_EXIT_SERVER_CLOSED, 6).  %% 6.服务器关闭

%%副本的传统入口，走12005
-define(DUNGEON_NORMAL_ENTRANCE,
    [?DUNGEON_TYPE_NORMAL,
        ?DUNGEON_TYPE_GOD_WEAPON,
        ?DUNGEON_TYPE_FUWEN_TOWER,
        ?DUNGEON_TYPE_MATERIAL,
        ?DUNGEON_TYPE_TOWER,
        ?DUNGEON_TYPE_EXP,
        ?DUNGEON_TYPE_DAILY,
        ?DUNGEON_TYPE_KINDOM_GUARD,
        ?DUNGEON_TYPE_GUILD_DEMON,
        ?DUNGEON_TYPE_VIP,
        ?DUNGEON_TYPE_GUARD,
        ?DUNGEON_TYPE_MARRY,
        ?DUNGEON_TYPE_CHANGE_CAREER,
        ?DUNGEON_TYPE_EQUIP,
        ?DUNGEON_TYPE_XIAN,
        ?DUNGEON_TYPE_GODNESS,
        ?DUNGEON_TYPE_ELITE_BOSS,
        ?DUNGEON_TYPE_ELEMENT,
        ?DUNGEON_TYPE_JIANDAO
    ]).


-define(DUNGEON_PASS, 1).

-define(DUNGEON_BOSS_TYPE, 3).


-define(DUNGEON_BOSS_DOUBLE_REWARD_GOLD, 50).

-define(DROP_TYPE_FIRST, 0).
-define(DROP_TYPE_PASS, 1).
-define(DROP_TYPE_RATIO, 2).
-define(DROP_TYPE_EXTRA, 3).

%%守护副本id
-define(DUNGEON_ID_GUARD, 30401).

%%副本加成记录
-record(dungeon_add, {
    world_add = [],                 %%世界等级加成[{玩家ID，加成系数}]
    exp_feedback = []               %%经验找回加成[{玩家ID，加成系数}]
}).

%% 玩家副本记录
-record(dungeon_record, {
    pkey = 0,                   %%玩家key
    dungeon_pid = 0,            %%副本进程
    dun_id = 0,                  %%副本id
    timeout = 0,                %%结束时间
    benefit = 0,                %%副本收益
    out = [0, 0, 0, 0]                  %%进入副本前场景[scene,copy,x,y]
}).

%%副本开启记录
-record(dungeon_history, {
    dungeon_id = 0,
    pid = 0,
    timeout = 0
}).

-define(DUN_MB_TYPE_NORMAL, 0).
-define(DUN_MB_TYPE_SYS, 1).

%%副本玩家信息
-record(dungeon_mb, {
    node = none,                %%节点信息
    pkey = 0,                   %%玩家key
    sn = 0,                     %%服号
    nickname = <<>>,            %%昵称
    pid = none,            %%玩家进程
    sid = none,
    join_time = 0,              %%进入时间
    scene = 0,                  %%玩家原来场景
    x = 0,                      %%坐标x
    y = 0,                      %%坐标y
    copy = 0,                   %%线路
    lv = 0,                      %%玩家等级
    career = 0,                %%职业
    sex = 0,                    %%性别
    vip = 0,
    power = 0,                  %%战力
    att = 0,                    %%攻击力
    avatar = "",
    type = 0,                   %%0正常玩家，1系统玩家
    leader = 0,                   %%是否队长（1是0否）
    shadow = {},
    fashion_cloth_id = 0,
    light_weaponid = 0,
    wing_id = 0,
    clothing_id = 0,
    weapon_id = 0,
    pet_type_id = 0,
    pet_figure = 0,
    pet_name = 0,
    relation = [],
    merge_exp_mul = 0,
    is_ready = 0
}).


%%副本场景信息
-record(dungeon_scene, {
    id = 0,                     %%场景id
    sid = 0,                    %%资源id
    enable = true,               %%是否可进
    condition = [],              %%进入条件
    begtime = 0,                %%开始时间
    timer_ref = 0                %%场景定时器
}).

%% 副本数据
-record(dungeon, {
    id = 0,                      %% 副本id
    sid = 0,                     %% 资源id
    name = [],                   %% 副本名称
    mon = [],                    %% [{r,[{mid,x,y}]}]  r=波数
    round_time = 0,              %% 每波限制时间秒
    time = 0,                    %% 限制时间秒
    count = 0,                   %% 进入限制次数
%%    point = [],                  %% 进入坐标点[x,y]
    out = [],                    %% 传出副本时场景和坐标[场景id, x, y]
    condition = [],              %% 副本进入条件
    scenes = [],                 %% 整个副本所有的场景 [{场景id, 是否激活}]  只有激活的场景才能进入
    type = 0,                    %% 副本类型[0普通副本,1剧情副本].
    lv = 0                        %% 副本等级
}).


-record(dun_cross, {
    key = 0,
    password = "",
    is_fast = 0,
    buff_id = 0
}).
-record(dun_cross_guard, {
    key = 0,
    password = "",
    is_fast = 0,
    buff_id = 0,
    box_count = 0,
    start_floor = 0,
    kill_floor = 0,
    cur_floor = 0,
    kill_floor_time = 0,  %%最后一波怪杀完时间
    mon_notice_ref = 0  %%怪物刷新计时器
}).

-record(dun_exp, {
    round_min = 0,
    round_max = 0,
    round_h = 0,
    round_acc = 0
}).

-record(dun_kindom, {
    start_floor = 0,
    kill_floor = 0,
    cur_floor = 0,
    kill_floor_time = 0,  %%最后一波怪杀完时间
    mon_notice_ref = 0  %%怪物刷新计时器
}).

-record(dun_demon, {  %%帮派妖魔入侵
    round_min = 0,
    round_max = 0,
    pass_num = [],  %%[{floor,passnum}]
    reduce = 0,
    add = 0
}).

-record(dun_arena, {
    type = 0, %%1玩家,0对手
    pkey = 0,
    nickname = <<>>,
    career = 0,
    sex = 0,
    avatar = <<>>,
    hp_lim = 0,
    cbp = 0
}).

-record(dun_god_weapon, {
    round = 0,
    round_max = 0,
    layer_h = 0,
    round_h = 0
}).

-record(dun_jiandao, {
    score = 0,
    mult = 0
}).


-record(dun_guard, {
    round = 0, %% 波数
    reward_list = [], %% 每日已获得奖励波数列表
    first_round = 0, %% 已获得首通奖励最高层数
    boss_hp = 0, %% 剩余血量
    start_floor = 0,
    kill_floor = 0,
    cur_floor = 0,
    kill_floor_time = 0  %%最后一波怪杀完时间
}).

-record(dun_problem, {
    id = 0,
    answer_list = [] %% [{Pkey, Answer}]
}).

%% 副本服务状态信息.
%% 基础副本信息存放在dungeon_state 最外层，特殊副本添加 类型副本状态记录字段
-record(st_dungeon, {
    dungeon_id = 0,              %% 副本开始场景资源id
    team = 0,                    %% 队伍进程id
    time = 0,                       %%副本时间
    begin_time = 0,                    %% 副本开始时间
    end_time = 0,                 %% 副本超时时间
    close_timer = undfined,            %% 副本超时定时器timerRef
    player_list = [],            %% [#dungeon_mb] 玩家列表.
    scene_list = [],             %% [{sceneid,true}]场景列表
    need_kill_num = 0,               %% 需要杀怪数
    cur_kill_num = 0,                %% 当前杀怪数
    kill_list = [],                    %%详细击杀统计[{monid,needkill,curkill}]
    condition_list = [],         %% 进入条件列表
    level = 1,                   %% 等级
    type = 0,                    %% 副本类型
    lv = 0,                         %%副本等级
    round = 0,                   %% 波数
    max_round = 0,                 %%最大波数
    next_round_timer = 0,        %%下一波 定时器
    round_time = 0,              %%下一波到达时间
    logout_type = ?DUN_EXIT_OTHER, %% 退出副本的方式[1退出按钮,2时间结束,3玩家下线,4异常退出].
    inited = false,              %% 副本资源是否已经创建完成
    is_pass = 0,              %% 是否通关，0否，1是
    is_reward = 0,              %%是否已经奖励
    exp = 0,                    %%获得的经验
    coin = 0,                   %%获得的银币
    goods_list = [],            %%获得的物品
    dun_cross = #dun_cross{},
    dun_cross_guard = #dun_cross_guard{},
    dun_kindom = #dun_kindom{},
    dun_exp = #dun_exp{},
    dun_demon = #dun_demon{},
    dun_god_weapon = #dun_god_weapon{},
    dun_jiandao = #dun_jiandao{},
    dun_guard = #dun_guard{},
    dun_arena = [],
    add = #dungeon_add{},                  %%各种加成数据
    mon = [],
    damage_list = [],           %%伤害列表[#st_hatred{}]
    first_pass = 0,          %%是否首通1是0否
    collect_list = [], %% 收集副本中的道具
    is_final = 0,
    answer = #dun_problem{}  %% 答题列表
}).

-record(turnover, {
    pos = 0,
    goods_id = 0,
    num = 0,
    state = 0,
    is_double = 1
}).

%%王城守卫副本信息
-record(base_kindom_dun, {
    floor = 0   %%波数
    , mon_list = []
    , goods_list = []
    , round_time = 0
    , box_list = []
}).

-record(base_guard_dun_gift, {
    floor = 0,  %%层数
    gift_id = 0  %%礼包id
}).


%%vip副本
-record(base_dun_vip, {
    dun_id = 0,         %% 副本id
    vip_lv = 0,         %% 所需vip等级
    count = 1,          %% 每日挑战次数
    pass_goods = [],    %% 通关奖励
    drop_goods = [],    %% 概率奖励
    show_goods = []     %% 展示奖励
}).


%%九霄塔
-record(st_dun_tower, {
    pkey = 0,
    dun_list = [],
    layer = 0,
    use_time = 0,
    click = 0,
    time = 0,
    is_change = 0
}).

-record(dun_tower, {
    dun_id = 0,
    star = 0,
    use_time = 0,
    time = 0
}).

-record(base_dun_tower, {
    layer = 0,
    dun_id = 0,
    pre_id = 0,
    next_id = 0,
    cbp = 0,
    star = 0,
    condition = [],
    star1_goods = {},
    star2_goods = {},
    star3_goods = {},
    sweep_goods = {}
}).

%%材料副本--进阶
-record(st_dun_material, {
    pkey = 0,
    dun_list = [],
    time = 0,
    is_change = 0
}).

-record(dun_material, {
    dun_id = 0,
    times = 0,
    sweep = 0
}).

%%经验副本
-record(st_dun_exp, {
    pkey = 0,
    round_highest = 0,
    round = 0,
    time = 0,
    is_change = 0
}).

%%每日副本
-record(st_dun_daily, {
    pkey = 0,
    dun_list = [],
    is_change = 0
}).

%%符文塔相关
-record(base_dun_fuwen_tower, {
    id = 0 %% 序号
    , layer = 0 %% 层数
    , name = ""
    , sub_layer = 0 %% 子层数
    , limit_lv = 0 %% 等级限制
    , dun_id = 0 %% 当前层副本ID
    , pre_dun_id = 0 %% 前1层副本ID
    , first_reward = [] %% 首通奖励
    , daily_reward = [] %% 每日通关
    , unlock_pos = 0 %% 解锁符文镶孔
    , unlock_fuwen_subtype = 0 %% 解锁符文类型
    , cbp_min = 0
}).

-record(st_dun_fuwen_tower, {
    pkey = 0
    , dun_list = []
    , layer_highest = 0 %% 历史通关最高塔关卡
    , sub_layer = 0 %% 当前挑战的子塔
    , unlock_pos = 0 %% 解锁镶孔
    , unlock_fuwen_subtype = [611, 612, 613] %% 解锁符文类型
    , op_time = 0
}).

-define(DUN_FUWEN_TOWER_MAX_LAYER, 1). %% 符文塔最大的层数

%%神器法宝
-record(st_dun_god_weapon, {
    pkey = 0,
    layer = 0,
    layer_h = 0,
    round = 0,
    round_h = 0,
    time = 0,
    is_change = 0
}).


-define(DUN_GUARD_RANK_LIMIT, 20).  %% 守护副本排行人数限制

-record(base_guard_dun, {
    floor = 0, %% 层数
    mon_list = [],%% 怪物列表
    reward_list = [], %% 奖励列表
    info = {0, 0} %% 推送信息 {怪物id,道路编号}
}).

%%守护副本信息
-record(st_dun_guard, {
    pkey = 0,
    round = 0, %% 当前波数
    round_max = 0, %% 最高层数
    reward_list = [], %% 每日已获得奖励波数列表
    first_round = 0, %% 已获得首通奖励最高层数
    change_time = 0,
    first_time = 0, %% 首次到达时间
    is_change = 0,
    is_sweep = 0, %% 是否已扫荡
    sweep_round = 0, %% 扫荡层数
    lv = 0, %% 玩家等级
    show_list = [] %% 通关展示列表
}).

%% 桃花岛（爱情试炼）
-record(st_dun_marry, {
    pkey = 0,
    pass = 0, %% 0未通关1通关
    saodang = 0, %% 今日是否扫荡 0不可以扫荡1可以扫荡 注：数据库中读出op_time不是今日，pass=1既可以扫荡
    is_reset = 0,
    op_time = 0
}).

-record(base_marry_problem, {
    id = 0,
    desc = "",
    a = "",
    b = "",
    c = "",
    d = "",
    result_list = []
}).

-define(DUN_MARRY_RESET_COST, data_version_different:get(11)). %% 重置花30元宝

-record(log_dungeon, {
    pkey = 0,
    nickname = <<>>,
    cbp = 0,
    dungeon_id = 0,
    dungeon_type = 0,
    dungeon_desc = <<>>,
    layer = 0,
    layer_desc = <<>>,
    sub_layer = 0,
    time = 0
}).


-record(st_dun_equip, {pkey = 0, times = 0, dun_list = [], time = 0, is_change = 0}).

-record(base_dun_equip, {dun_id = 0, pre_id = 0, next_id = 0, open_day = 0, pass_reward = {}, task_id = 0}).


%%跨服试炼副本信息
-record(base_cross_guard_dun, {
    floor = 0   %%波数
    , scene = 0
    , mon_list = []
    , goods_list = []
    , round_time = 0
    , box_list = []
}).

-endif.


%%神祇相关
-record(base_dun_godness, {
    id = 0 %% 序号
    , layer = 0 %% 层数
    , name = ""
    , type = 0 %% 1左2右
    , subtype = 0 %% 1神魂2神祇
    , limit_lv = 0 %% 等级限制
    , dun_id = 0 %% 当前层副本ID
    , first_reward = [] %% 首通奖励
    , daily_reward = [] %% 每日通关
    , cbp = 0
}).

-record(st_dun_godness, {
    pkey = 0
    , buy_num = [] %% 是否花云宝购买 [{layer,num}]
    , left_godsoul_num = [] %% 神魂副本挑战次数 [{layer, num}]
    , left_godness_num = [] %% 神祇副本挑战次数
    , right_godsoul_num = [] %% 神魂副本挑战次数
    , right_godness_num = [] %% 神祇副本挑战次数
    , left_pass_list = [] %% 通关列表 %% 每日重置 [{layer, dun_id}]
    , right_pass_list = [] %% 通关列表 %% 每日重置
    , log_dun_id_list = [] %% 历史通关记录 [dun_id]
    , op_time = 0
}).

-define(DUN_LEFT, 1).
-define(DUN_RIGHT, 2).
-define(DUN_GODSOUL, 1).
-define(DUN_GODNESS, 2).

-record(base_dun_elite_boss, {
    dun_id = 0,
    consume = [],
    must_reward = [],
    rand_reward = [],
    rand_num = 0,
    cost_gold = 0,
    vip_limit = 0
}).

-record(st_dun_elite_boss, {
    pkey = 0,
    challenge_num = 0,
    is_recv = 0, %% 每日令牌奖励领取
    buy_num = 0, %% 每日金令牌购买次数
    op_time = 0
}).

-record(st_dun_element, {
    pkey = 0
    , log_list = [] %% 通关的日志，永久保存
    , saodang_list = [] %% 每日清除
    , op_time = 0
}).

%% 元素副本
-record(base_dun_element, {
    dun_id = 0
    , is_boss = 0
    , race = 0
    , reward = []
    , lv_limit = 0
}).

-record(st_dun_jiandao, {
    pkey = 0
    , log_list = []
    , challenge_num = 0
    , buy_list = []
    , op_time = 0
}).

%% 剑道副本
-record(base_dun_jiandao, {
    dun_id = 0
    , type = 0
    , lv_limit = 0
    , score = 0
}).