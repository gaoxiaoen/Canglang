%%===================================
%% 全局record 状态记录定义
%%===================================
-ifndef(SERVER_HRL).
-define(SERVER_HRL, 1).


%%镜像ID
-define(SHADOW_ID, 10001).
-define(ETS_REVIVE, ets_revive).
-define(ETS_SHADOW, ets_shadow).
-define(BASE_SPEED, 200).%%玩家基础速度


-define(CROSS_NODE_TYPE_NORMAL, 0).%%普通服跨服节点
-define(CROSS_NODE_TYPE_AREA, 1).%%区域跨服节点
-define(CROSS_NODE_TYPE_WAR, 2).%%城战跨服节点

-define(VIEW_MODE_ALL, 0).
-define(VIEW_MODE_HIDE, 1).

%%匹配状态
-define(MATCH_STATE_NO, 0).
-define(MATCH_STATE_ELIMINATE, 1).
-define(MATCH_STATE_1V1, 2).
-define(MATCH_STATE_CROSS_DUNGEON, 3).
-define(MATCH_STATE_CROSS_SCUFFLE, 4).
-define(MATCH_STATE_CROSS_SCUFFLE_ELITE, 5).
-define(MATCH_STATE_CROSS_DUNGEON_GUARD, 6).


-define(INVITE_CODE, invitecode).%% 邀请码MD5拼接

-define(PLAYER_LV_LIMIT, data_version_different:get(13)).

%% ----------------------------------
%% 全局record
%% ----------------------------------
%%连接客户端
-record(client, {
    socket = none,      % socket
    ip = none,          % ip元组
    pid = none,         % 玩家进程
    login = 0,          % 是否登录
    accname = none,     % 账户名
    pf = none,          %平台
    timeout = 0,        % 超时次数
    req_count = 0,      % 请求次数
    req_list = [],      % 请求列表
    req_time = 0        % 请求时间
}).

%%在线
-record(ets_online, {
    key = none,         % 玩家key
    pid = 0,            % 玩家进程
    sid = {},           % 发送进程
    lv = 0              % 玩家等级
}).

%%跨服节点列表
-record(ets_kf_nodes, {
    key = 0,
    sn = 0,             %%服号
    sn_name = <<>>,     %%服名
    node = none,        %%节点
    open_time = 0,      %%开服时间
    is_debug = 0,       %%是否开发模式
    world_lv = 0,
    p_max_lv = 0,       %%玩家最高等级
    type = 0,          %%0普通服节点,1跨服节点,2城战
    area_node = none,
    cbp = 0,
    cbp_len = 0,
    language = 0        %%语言版本cn,tw
}).

-record(ets_cross_node, {
    sn = 0,
    node_area = none,
    node_area_time = 0,
    node_war = none,
    node_war_time = 0,
    is_change = 1
}).

%%合服服务器
-record(ets_kf_merge_sn, {
    sn = 0,
    new_sn = 0
}).

%%跨服城战分组信息
-record(ets_war_nodes, {
    sn = 0,             %%服号
    day = 0,
    time = 0
}).

-record(ets_sn_name, {sn, name}).

%%跨服玩家数据表
-record(ets_kf_player, {
    key = {},
    player = [],
    goodslist = []
}).

%% @doc 玩家属性记录
-record(attribute, {
    hp_lim = 0,
    mp_lim = 0,
    att = 0,     %%攻击
    def = 0,    %%防御
    hit = 0,     %%命中
    dodge = 0,   %%闪躲
    crit = 0,    %%暴击
    ten = 0,     %%坚韧
    crit_inc = 0,%%暴击伤害
    crit_dec = 0,%%暴击免伤
    hurt_inc = 0,%%伤害加成
    hurt_dec = 0,%%伤害减免
    crit_ratio = 0,%%人物暴击率
    hit_ratio = 0,%%人物命中率
    hurt_fix = 0,%%固定伤害
    pvp_inc = 0, %%PVP增伤
    pvp_dec = 0,%%PVP免伤

    hp_lim_inc = 0,     %%气血增加百分比
    recover = 0,        %%秒回生命
    recover_hit = 0,    %%击中回血
    size = 0,           %%体型
    cure = 0,           %%治疗效果
    base_speed = 0,     %%基础速度
    speed = 0,          %%移动速度
    att_speed = 0,      %%攻击速度
    att_area = 0,       %%攻击范围
    prepare = 0,        %%施法前摇
    pet_att = 0,        %%宠物攻击

    exp_add = 0, %% 经验获得
    att_add_percent = 0, %%攻击百分比
    def_add_percent = 0, %%防御百分比

    fire_att = 0, %% 火系元素攻击
    fire_def = 0, %% 火系元素防御
    wood_att = 0, %% 木系元素攻击
    wood_def = 0, %% 木系元素防御
    wind_att = 0, %% 风系元素攻击
    wind_def = 0, %% 风系元素防御
    water_att = 0, %% 水系元素攻击
    water_def = 0, %% 水系元素防御
    light_att = 0, %% 光系元素攻击
    light_def = 0, %% 光系元素防御
    dark_att = 0, %% 暗系元素攻击
    dark_def = 0, %% 暗系元素防御

    fire_hurt_inc = 0, %%火系元素伤害加成
    fire_hurt_dec = 0, %%火系元素伤害减免
    wood_hurt_inc = 0, %%木系元素伤害加成
    wood_hurt_dec = 0, %%木系元素伤害减免
    wind_hurt_inc = 0, %%风系元素伤害加成
    wind_hurt_dec = 0, %%风系元素伤害减免
    water_hurt_inc = 0, %%水系元素伤害加成
    water_hurt_dec = 0, %%水系元素伤害减免
    light_hurt_inc = 0, %%光系元素伤害加成
    light_hurt_dec = 0, %%光系元素伤害减免
    dark_hurt_inc = 0, %%暗系元素伤害加成
    dark_hurt_dec = 0 %%暗系元素伤害减免
}).

%% 充值记录状态
-record(st_recharge, {
    total_fee = 0,
    total_gold = 0,
    products = []
}).

%% 时间记录
-record(time_mark, {
    ldt = 0,                    %%last_die_time 最后死亡时间
    lat = 0,                     %%last_attack_time 上一次出手时间
    ast = 0,                    %%attack_state_time进入战斗状态的时间
    umt = 0,                    %%unmove_time禁止移动时间
    uat = 0,                    %%unattack_time 禁止攻击时间
    uct = 0,                    %%unconjure_time 禁止施法时间
    uft = 0,                    %%unfaint_time 免疫硬直时间
    rmt = 0,                    %%restoer_mp_time 随时间回复mp时间
    rmh = 0,                    %%restore_mp_hit 随被击回复mp时间
    godt = 0,                    %%无敌时间
    bbt = 0,                    %%被击退时间
    lbt = 0                       %%上一次被攻击时间last_battle_time
}).

%% pk状态
-record(pk, {
    pk = 0,        %%pk状态    0和平 1pk 查看scene.hrl 宏定义
    pk_old = 0,     %%上一次pk状态
    value = 0,      %%pk值
    chivalry = 0,    %%侠义值
    change_time = 0, %%转换时间
    kill_count = 0, %%击杀数
    protect_time = 0, %%保护到时时间
    online_time = 0,  %%累计挂机时间
    calc_time = 0     %%最后计算挂机时间
}).

%% 妖神
-record(pevil, {
    evil = 0,       %是否变身 0否1是
    evil_time = 0     %妖神到期时间
}).


%%单位定时器
-record(obj_ref, {
    ref_mana = [],           %%法盾定时器
    ref_effect = none,          %%效果定时器
    ref_hp_list = []            %%血量变化定时器列表[{key,ref}]
}).

%%仙盟记录
-record(st_guild, {
    guild_key = 0,      %%仙盟key
    guild_name = <<>>,  %%仙盟名称
    guild_position = 0    %%仙盟职位
}).

%%乱斗精英赛战队记录
-record(st_war_team, {
    war_team_key = 0,      %%战队key
    war_team_name = <<>>,  %%战队名称
    war_team_position = 2 %%战队职位
%%     wat_team_num = 0       %%战队人数
}).

%%出战宠物信息
-record(fpet, {
    type_id = 0,  %%类型id 没有出战宠物时为0
    name = "",  %%名字
    figure = 0,  %%外观
    star = 0,      %%星级
    stage = 0,      %%阶数
    att_param = 1,  %%攻击系数
    skill = []   %%宠物技能[{cell,skillid}]
}).


%%宝宝
-record(fbaby, {
    type_id = 0, %%类型i
    name = "",   %%名字
    figure = 0,  %%外观
    step = 0,    %%阶级
    lv = 0,      %%等级
    att = [],    %%总属性
    skill = []   %%宠物技能[{cell,skillid}]
}).


%%穿戴装备形象
-record(equip_figure, {
    weapon_id = 0,
    clothing_id = 0
}).

%%穿戴的时装形象
-record(fashion_figure, {
    fashion_cloth_id = 0,%%时装id
    fashion_bubble_id = 0,%%气泡
    fashion_head_id = 0,%%头像
    fashion_decoration_id = 0 %%挂饰
}).

%%玩法记录
-record(play_point, {
    type = 0,
    sub_id = 0,
    sub_name = "",
    current_times = 0,
    max_times = 0
}).

%%镜像信息
-record(st_shadow, {
    shadow_id = 0,   %%镜像id属性类型(0继承玩家自身属性，其他值为怪物ID，继承怪物属性)
    att_per = 1,       %%继承的攻击百分比
    hp_per = 1,         %%继承的气血百分比
    def_p_per = 1,
    def_m_per = 1
}).

%%结婚信息
-record(marry, {
    mkey = 0,   %%婚姻key
    marry_type = 0,%%标记类型1,2,3
    couple_key = 0,      %%配偶key
    couple_name = <<>>,    %%配偶昵称
    couple_sex = 0,
    cruise_state = 0        %%巡游状态0否 1男2女

}).

%%乱斗精英赛记录信息
-record(cross_scuffle_elite_info, {
    role_list = [], %% 使用角色列表 [{role,count}]
    att = 0,        %% 造成伤害
    der = 0,        %% 承受伤害
    rank = 0,       %% 最高名次
    count = 0       %% 战斗场次
}).

-record(common_riding, {
    state = 0, %% 0没有开启共同乘坐，1.是主骑者 2.非主骑者
    main_pkey = 0, %% 主骑者pkey
    common_pkey = 0,%%另外一人的pkey
    common_pid = 0 %%另外一人的pid
}).

%%温泉
-record(phot_well, {
    state = 0,  %%状态 0没1在双修
    pkey = 0    %%双修对方key
}).


-record(dvip, {
    vip_type = 0,
    time = 0
}).


%% 玩家记录
-record(player, {
    key = 0,
    sn = 0,
    sn_cur = 0,
    sn_name = <<>>,
    pf = 0,
    game_id = 0,
    game_channel_id = 0,
    accname = none,
    nickname = none,
    last_login_time = 0,

    last_login_ip = none,
    online_time = 0, %%
    total_online_time = 0,
    login_days = 0,%%游戏登陆天数
    logout_time = 0,

    return_time = 0, %% 回归时间
    continue_end_time = 0, %% 回归有效时间

    reg_time = 0,
    reg_ip = "",
    opentime = 0,                   %%开服时间
    sync_time = 0,                  %%场景同步数据时间
    att_time = 0,                   %%攻击时间
    enter_sid_time = 0,              %%

    sid = [],
    pid = none,
    node = none,
    socket = none,
    gm = 0,                         %%0普通1新手指导员
    career = 0,
    new_career = 0,                 %% 转生职业
    realm = 0,
    sex = 0,                        %%性别
    lv = 0,
    exp = 0,
    exp_lim = 0,
    hp = 0,                         %%血量
    mp = 0,                         %%魔法
    sin = 0,                        %%怒气值
    gold = 0,                       %%元宝
    bgold = 0,                      %%绑定元宝
    coin = 0,                       %%银币
    bcoin = 0,                      %%绑定银币
    repute = 0,                     %%声望
    honor = 0,                      %%荣誉
    arena_pt = 0,                   %%竞技积分
    exploit_pri = 0,                %%个人功勋
    smelt_value = 0,                %%熔炼值
    xinghun = 0,                    %%星魂值
    reiki = 0,                      %%十荒神器器灵
    sweet = 0,                      %%甜蜜度
    act_gold = 0,                   %%活动金币
    fairy_crystal = 0,              %%仙晶
    xingyun_pt = 0,                 %%星运积分
    vip_lv = 0,                     %%vip等级
    vip_state = 0,                  %%vip等级
    manor_pt = 0,                   %%家园积分
    equip_part = 0,                 %%装备碎片
    sd_pt = 0,                      %%六龙历练
    scene = 0,                      %%场景id
    scene_old = 0,                  %%上一场景id
    copy = 0,                       %%副本进程 / 线路
    copy_old = 0,                   %%上一副本进程 /线路
    x = 0,                          %%坐标x
    x_old = 0,                      %%上一场景坐标x
    y = 0,                          %%坐标y
    y_old = 0,                      %%上一场景坐标y
    payed = 0,                      %%充值总金额
    conjure = 0,                    %%施法状态 > 0 则进入施法
    cbp = 0,                        %%combatpower 战斗力
    highest_cbp = 0,                %%combatpower 战斗力
%%    cbp_list = [],                    %%各个子战力列表，用于玩家属性对比
%%    pet_attr_comp = [],                %%宠物相关属性，用于离线玩家属性对比
%%    mount_attr_comp = [],            %%坐骑相关属性，用于离线玩家属性对比
    skill_serial = 0,                %%第几套技能0.玩家默认技能 1.玩家变声技能
    skill = [],                     %%技能列表 [{skillid,lv,state}]
    skill_effect = 0,               %%技能效果 0默认,1飞仙
    scuffle_skill = [],                     %%乱斗技能列表 [skillid...]
    xian_skill = [],                %%飞仙技能列表[skillid ... ]
    passive_skill = [],             %%外观.宠物被动技能 [{skillid,lv,type}]
    scuffle_passive_skill = [],             %%被动技能
    magic_weapon_skill = [],                  %%法宝主动技能[{skillid,lv}]
    godness_skill = [],              %%神祇技能（包括神祇技能及神魂套装技能）
    qte = {0, 0},                   %%{qteid,expiretime}
    team_key = 0,                   %%队伍key
    team = 0,                       %%队伍进程
    team_num = 0,                   %%队伍人数
    team_leader = 0,                %%是否队长，1是0否
    attribute = #attribute{},       %%动态属性
    scuffle_attribute = #attribute{},       %%乱斗动态属性
    scuffle_state = false,
    scuffle_elite_attribute = #attribute{}, %%乱斗精英赛动态属性
    scuffle_elite_state = false,
    time_mark = #time_mark{},      %%时间记录
    buff_list = [],                 %%buff列表
    design = [],                    %%已佩戴的称号
    guild = #st_guild{},           %%仙盟
    war_team = #st_war_team{},     %%乱斗精英赛战队
    cross_scuffle_elite = #cross_scuffle_elite_info{},       %% 乱斗精英赛记录
    pk = #pk{},                     %%pk状态
    old_scene_pk = 0,               %%上一次切换场景时的pk状态
    evil = #pevil{},                %%妖神变身
    mount_id = 0,                   %%坐骑形象
    fashion = #fashion_figure{},   %%时装
    sprite_lv = 0,                  %%精灵等级
    light_weaponid = 0,             %%光武
    pet_weaponid = 0,               %%妖灵
    cat_id = 0,                      %%灵猫id
    golden_body_id = 0,              %%法身id
    god_treasure_id = 0,              %%仙宝id
    jade_id = 0,                     %%玉佩id
    wing_id = 0,                    %%翅膀id
    baby_wing_id = 0,               %% 子女翅膀id
    baby_mount_id = 0,               %% 子女坐骑id
    baby_weapon_id = 0,               %% 子女武器id
    equip_figure = #equip_figure{}, %%装备形象
    max_stren_lv = 0,               %%历史最大强化等级
    max_stone_lv = 0,               %%历史最大镶嵌等级
    soul_lv = 0,                   %%武魂最大等级
    suit_pet_star = [],             %%宠物融合星级套装
    weared_equip = [],              %%玩家身上穿的装备
    baby_equip = [],                %%子女装备
    achieve_view = [0, 0, 0, []],   %%成就信息
    attr_dan = [],                  %%玩家身上的属性丹
    convoy_state = 0,               %%护送状态，0无，其他值代表不同的护送
    convoy_rob = 0,                 %%今日抢劫次数
    shadow = #st_shadow{},         %%镜像信息
    pet = #fpet{},                 %%出战宠物信息
    baby = #fbaby{},               %%玩家子女信息
    marry = #marry{},              %%结婚信息
    scene_face = "",                %%场景表情
    drop_bind = 1,                  %%掉落是否绑定 0否1是
    merge_exp_mul = 0,              %%合服经验倍数
    charm = 0,                        %%玩家魅力值
    common_riding = #common_riding{},%%玩家共同乘坐
    hot_well = #phot_well{},         %%温泉
    %%--
    phone_id = none,
    os = none,
    location = none,                %%所在地
    avatar = "",                    %%头像地址
    figure = 0,                     %%变身ID
    group = 0,                       %%战斗分组
    combo = 0,                  %%连杀数
    bf_score = 0,                     %%战场积分
    cross_bf_layer = 0,                 %%跨服战场层数
    eliminate_group = 0,                %%消消乐分组
    crown = 0,                       %%城战皇冠标记
    gun_carrier = 0,                %%城战炮车标记
    cw_leader = 0,                   %%%%城战盟主标记 1防守盟主,2进攻盟主
    sword_pool_figure = 0,            %%剑池形象
    cross_dun_state = 0,            %%跨服房间状态
    cross_dun_guard_state = 0,      %%跨服试炼房间状态
    is_view = 0,                    %%是否可见0全部可见,1隐身
    magic_weapon_id = 0,            %%法宝形象
    god_weapon_id = 0,              %%十荒神器id
    god_weapon_skill = 0,            %%十荒神器技能
    is_interior = 0,                    %%是否内部号
    match_state = 0,                 %%活动匹配状态1匹配中 0否 1消消乐 21v1 3跨服副本 4乱斗 5乱斗精英 6跨服试炼副本
    footprint_id = 0,
    world_lv = 0,                    %%世界等级
    world_lv_add = 0,                    %%世界等级经验加成系数
    acc_damage = 0,                  %%死亡前伤害统计
    marry_ring_lv = 0,               %% 结婚戒指等级
    marry_ring_type = 0,               %% 结婚戒指类型
    sit_state = 0,                       %%打坐状态1是0否
    show_golden_body = 1,                 %%显示法身
    d_vip = #dvip{},                 %% 钻石转盘
    ref_43099 = null,                 %% 43099定时器
    login_flag = "",                  %% 登陆标识，由客户端传送给服务端
    xian_stage = 0,                    %% 仙阶
    jiandao_stage = 0,                   %% 剑道阶数
    wear_element_list = []            %% 穿戴的元素Race列表
}).






-record(st_revive, {
    pkey = 0,
    times = 0,
    time = 0
}).

-define(ETS_MERGE_SN, ets_merge_sn).  %%已合服ets

%%已合服服号
-record(merge_sn, {
    sn = 0
}).

-record(ets_back, {
    scene = 0,
    copy = 0,
    x = 0,
    y = 0,
    pk = 0,
    figure = 0,
    group = 0
}).

%%守护副本
-record(ets_rank_dun_guard, {
    pkey = 0,
    rank = 0,
    nickname = [],
    floor = 0,
    pass_time = 0
}).


%% 永久掩码
-record(player_mask, {
    player_id = 0,          %% 玩家id
    list = [],              %% 掩码列表
    mask_dict = dict:new(), %% 玩家掩码
    is_change = 0
}
).

-record(st_change_career, {
    pkey = 0,
    new_career = 0,   %% 当前职业
    is_career = 0 %% 是否可转职
}).


-record(ets_gold_silver_tower, {
    act_id = 0
    , buy_list = [] %%[{nickname,goods_id, goods_num}]
    , db_flag = 0 %% 用于标记数据库写入
}).
-define(ETS_GOLD_SILVER_TOWER, ets_gold_silver_tower).

-record(ets_area_group, {
    activity_name = none
    , id_list = [] %%服务器组id列表
    , group_list = 0 %% [{服务器号1,分组}.{服务器号2,分组}}]
}).
-define(ETS_AREA_GROUP, ets_area_group).


-record(ets_cbp, {
    pkey = 0,
    cbp = 0,
    cbp_list = [],
    is_change = 0
}).
-endif.