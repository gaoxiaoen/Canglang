
%%============================================
%% 场景相关数据结构定义
%%============================================
-ifndef(SCENE_HRL).
-define(SCENE_HRL, 1).
-include("server.hrl").

-define(ETS_SCENE_ACC, ets_scene_acc).
-define(ETS_SCENE_PID, ets_scene_pid).

-define(PLAYER_KEY(Key), {scene_player, Key}).
-define(MON_KEY(Key), {scene_mon, Key}).
-define(TABLE_AREA_PLAYER(Id, Copy), {tap, Id, Copy}).
-define(TABLE_AREA_MON(Id, Copy), {tam, Id, Copy}).
-define(COPY_KEY_PLAYER(Copy), {ckp, Copy}).
-define(COPY_KEY_MON(Copy), {ckm, Copy}).
-define(MON_AI(SceneId, Copy), {mai, SceneId, Copy}).
-define(BLOCKED(SceneId, X, Y), {blocked, SceneId, X, Y}).
-define(SCENE_PID(SceneId, Copy), {scene_pid, SceneId, Copy}).

-define(SCENE_ID_MAIN, 10003).%%主城ID
-define(SCENE_ID_JJYJ, 10004).%%禁忌遗迹
-define(SCENE_ID_ARENA, 12001).%%竞技场场景ID
-define(SCENE_ID_CROSS_ARENA, 60402).%%跨服竞技场场景ID
-define(SCENE_ID_KINDOM_GUARD_ID, 14001).  %%王城守卫副本id
-define(SCENE_ID_SIX_DRAGON, 15001).  %%六龙等待场景
-define(SCENE_ID_SIX_DRAGON_FIGHT, 15002).  %%六龙战斗场景
-define(SCENE_ID_GUILD_WAR, 40001).%%工会战地图
-define(SCENE_ID_ANSWER, 30501).%%趣味答题地图
-define(SCENE_ID_HUNT, 30301).   %%百兽猎场地图
-define(SCENE_ID_BATTLEFIELD, 40002).   %%战场
-define(SCENE_ID_CROSS_BOSS_ONE, 60301).%%跨服boss第一层地图
-define(SCENE_ID_CROSS_BOSS_TWO, 60302).%%跨服boss第二层地图
-define(SCENE_ID_CROSS_BOSS_THREE, 60303).%%跨服boss第三层地图
-define(SCENE_ID_CROSS_BOSS_FOUR, 60304).%%跨服boss第四层地图
-define(SCENE_ID_CROSS_BOSS_FIVE, 60305).%%跨服boss第五层地图
-define(SCENE_ID_CROSS_ELITE, 60401).%%跨服精英地图
-define(SCENE_ID_CROSS_ELIMINATE, 60403).%%跨服消消乐
-define(SCENE_ID_PRISON, 10500).%%监狱场景id
-define(SCENE_ID_HOT_WELL, 15003).%%温泉场景id
-define(SCENE_ID_CROSS_SCUFFLE, 12004).%%乱斗场景id
-define(SCENE_ID_DUN_GUARD, 30401).  %%守护副本
-define(SCENE_ID_DUN_MARRY, 12005).  %%爱情试炼副本
-define(SCENE_ID_CROSS_WAR, 12006). %%攻城战场景
-define(SCENE_ID_CROSS_SCUFFLE_ELITE_READY, 12007).%%乱斗精英赛准备场景id
-define(SCENE_ID_CROSS_SCUFFLE_ELITE, 12014).%%乱斗精英赛场景id

-define(SCENE_ID_CROSS_1VN_READY, 41001).%% 跨服1vN资格赛准备场景
-define(SCENE_ID_CROSS_1VN_WAR, 41002).%% 跨服1vN资格赛战斗场景
-define(SCENE_ID_CROSS_1VN_FINAL_READY, 41003).%% 跨服1vN决赛准备场景
-define(SCENE_ID_CROSS_1VN_FINAL_WAR, 41004).%% 跨服1vN决赛战斗场景
-define(SCENE_ID_GUILD, 60901).%%仙盟领地场景id
-define(SCENE_ID_GUILD_FIGHT, 60902).%%仙盟对战场景ID


-define(SCENE_TYPE_NORMAL, 0).      %% 普通场景.
-define(SCENE_TYPE_DUNGEON, 1).     %% 副本场景.
-define(SCENE_TYPE_SAFE, 4).        %% 安全场景.
-define(SCENE_TYPE_GUILD_WAR, 5).    %% 仙盟战   11111
-define(SCENE_TYPE_HUNT, 7).         %%万兽猎场场景   1111
-define(SCENE_TYPE_BATTLEFIELD, 8).         %%战场场景   111
-define(SCENE_TYPE_CROSS_BATTLEFIELD, 9).     %% 跨服战场场景
-define(SCENE_TYPE_FIELD_BOSS, 10).        %% 野外Boss场景.
-define(SCENE_TYPE_CROSS_NORMAL, 11).     %% 跨服普通地图
-define(SCENE_TYPE_CROSS_BOSS, 12).     %% 跨服Boss
-define(SCENE_TYPE_CROSS_ELITE, 13).     %% 跨服elite 1vs1
-define(SCENE_TYPE_CROSS_FIELD_BOSS, 14).        %% 跨服野外Boss场景.
-define(SCENE_TYPE_CROSS_ANSWER, 16).        %% 答题场景
-define(SCENE_TYPE_CROSS_ARENA, 17).        %% 跨服竞技场
-define(SCENE_TYPE_CROSS_ELIMINATE, 18).        %% 跨服消消乐
-define(SCENE_TYPE_CROSS_WAR, 19).        %% 跨服攻城战
-define(SCENE_TYPE_MARRY, 20).        %% 结婚场景
-define(SCENE_TYPE_CROSS_DUN, 21).        %% 跨服副本
-define(SCENE_TYPE_CROSS_SIX_DRAGON, 23).        %% 六龙争霸报名场景
-define(SCENE_TYPE_CROSS_SIX_DRAGON_FIGHT, 24).        %% 六龙争霸战斗场景
-define(SCENE_TYPE_PRISON, 25).        %% 监狱场景
-define(SCENE_TYPE_HOT_WELL, 26).        %% 温泉场景
-define(SCENE_TYPE_CROSS_SCUFFLE, 27).        %%  乱斗场景
-define(SCENE_TYPE_CROSS_DARK_BLIBE, 28).       %%恶魔深渊
-define(SCENE_TYPE_CROSS_SCUFFLE_ELITE, 29).        %%  乱斗精英赛场景
-define(SCENE_TYPE_CROSS_SCUFFLE_READY, 30).        %%  乱斗精英赛准备场景
-define(SCENE_TYPE_CROSS_GUARD_DUN, 31).        %% 跨服试炼副本
-define(SCENE_TYPE_CROSS_1VN_READY, 32).        %% 跨服1vN资格赛准备场景
-define(SCENE_TYPE_CROSS_1VN_WAR, 33).          %% 跨服1vN资格赛战斗场景
-define(SCENE_TYPE_CROSS_1VN_FINAL_READY, 34).  %% 跨服1vN决赛准备场景
-define(SCENE_TYPE_CROSS_1VN_FINAL_WAR, 35).    %% 跨服1vN决赛战斗场景
-define(SCENE_TYPE_NEW_ELITE, 36). %% 精英boss场景
-define(SCENE_TYPE_CROSS_NEW_ELITE, 37). %% 精英boss跨服场景
-define(SCENE_TYPE_VIP_ELITE, 38). %% 精英bossVIP场景
-define(SCENE_TYPE_GUILD, 39). %%仙盟领地



%%区域跨服场景类型
-define(SCENE_TYPE_CROSS_AREA_LIST, [?SCENE_TYPE_CROSS_BATTLEFIELD, ?SCENE_TYPE_CROSS_NORMAL, ?SCENE_TYPE_CROSS_BOSS, ?SCENE_TYPE_CROSS_ELITE,
    ?SCENE_TYPE_HUNT, ?SCENE_TYPE_BATTLEFIELD, ?SCENE_TYPE_CROSS_FIELD_BOSS, ?SCENE_TYPE_CROSS_ANSWER,
    ?SCENE_TYPE_CROSS_ARENA, ?SCENE_TYPE_CROSS_SIX_DRAGON, ?SCENE_TYPE_CROSS_SIX_DRAGON_FIGHT, ?SCENE_TYPE_HOT_WELL, ?SCENE_TYPE_CROSS_DARK_BLIBE,
    ?SCENE_TYPE_CROSS_1VN_READY, ?SCENE_TYPE_CROSS_1VN_WAR, ?SCENE_TYPE_CROSS_1VN_FINAL_READY, ?SCENE_TYPE_CROSS_1VN_FINAL_WAR, ?SCENE_TYPE_CROSS_NEW_ELITE]).
%%全跨服场景类型
-define(SCENE_TYPE_CROSS_ALL_LIST, [?SCENE_TYPE_CROSS_ELIMINATE, ?SCENE_TYPE_CROSS_DUN, ?SCENE_TYPE_CROSS_GUARD_DUN, ?SCENE_TYPE_CROSS_SCUFFLE, ?SCENE_TYPE_CROSS_SCUFFLE_ELITE, ?SCENE_TYPE_CROSS_SCUFFLE_READY]).
-define(SCENE_TYPE_CROSS_WAR_AREA_LIST, [?SCENE_TYPE_CROSS_WAR]).
-define(SCENE_ID_NORMAL_CROSS_LIST, []).
%% 跨服1vn场景列表
-define(SCENE_TYPE_CROSS_1VN_LIST, [?SCENE_TYPE_CROSS_1VN_READY, ?SCENE_TYPE_CROSS_1VN_WAR, ?SCENE_TYPE_CROSS_1VN_FINAL_READY, ?SCENE_TYPE_CROSS_1VN_FINAL_WAR]).

%%可分线场景类型
-define(SCENE_TYPE_CAN_COPY, [?SCENE_TYPE_NORMAL, ?SCENE_TYPE_CROSS_SIX_DRAGON, ?SCENE_TYPE_HOT_WELL, ?SCENE_TYPE_CROSS_SCUFFLE_READY,?SCENE_TYPE_CROSS_1VN_READY,?SCENE_TYPE_CROSS_1VN_FINAL_READY]).

%%区域跨服类型
-define(SCENE_TYPE_CROSS_AREA, scene_type_cross_area).
-define(SCENE_TYPE_CROSS_WAR_AREA, scene_type_cross_war_area).
%%全跨服类型
-define(SCENE_TYPE_CROSS_All, scene_type_cross_all).


%%攻击倾向
-define(ATTACK_TENDENCY_PEACE, 0).  %%不攻击
-define(ATTACK_TENDENCY_MON, 1).     %%攻击怪物
-define(ATTACK_TENDENCY_PLAYER, 2).  %%攻击玩家
-define(ATTACK_TENDENCY_PLAYER_2_MON, 3).%%优先攻击玩家，再攻击怪物
-define(ATTACK_TENDENCY_MONAR, 4).%%领地战boss选取攻击目标
-define(ATTACK_TENDENCY_RANDOM, 5).  %%随机攻击

-define(MON_KIND_NORMAL, 0).      %%普通怪物   可选可攻
-define(MON_KIND_COLLECT, 1).     %%采集类型   可选不可攻
-define(MON_KIND_TRAP, 2).        %%陷阱类型   不可选不可攻
-define(MON_KIND_TREASURE_PET, 3).%%藏宝图宠物怪类型  可选可攻
-define(MON_KIND_FRIEND, 5).      %%友方怪物    可选不可攻
-define(MON_KIND_REMOVE_TRAP, 6). %%可消除陷阱  不可选不可攻
%%-define(MON_KIND_TREASURE_MON,7).     %%等级保护怪  条件可攻
-define(MON_KIND_TREASURE_MON, 7).%%藏宝图玩家怪类型 / 场景元素 不可选不可攻
-define(MON_KIND_INVADE_MON, 8).         %%魔物入侵怪物,可攻可选
-define(MON_KIND_INVADE_BOX, 9).         %%魔物入侵宝箱,可选不可攻
-define(MON_KIND_HUNT_MON, 10).         %%猎场怪物,可选可攻
-define(MON_KIND_HUNT_COLLECT, 11).         %%猎场采集物,可选不可攻
-define(MON_KIND_GRACE_COLLECT, 12).         %%神谕恩泽采集物,可选不可攻
-define(MON_KIND_BATTLEFIELD, 13).         %%战场采集物,可选不可攻
-define(MON_KIND_FIELD_BOSS_BOX, 15).         %%野外boss采集物,可选不可攻
-define(MON_KIND_ELIMINATE_COLLECT, 16).         %%消消乐采集怪,可选不可攻
-define(MON_KIND_ELIMINATE_MON, 17).         %%消消乐怪物,可选可攻
-define(MON_KIND_MARRY_SHOW_COLLECT, 18).         %%婚礼游行采集怪,可选不可攻
-define(MON_KIND_MARRY_COLLECT, 19).         %%婚礼晚宴采集怪,可选不可攻
-define(MON_KIND_MANOR, 24).         %%领地战旗帜,可攻击
-define(MON_KIND_MANOR_BOSS, 25).         %%领地战boss,可攻击
-define(MON_KIND_MANOR_PARTY_TABLE, 26).         %%领地战晚宴采集桌,可选课采集
-define(MON_KIND_MANOR_PARTY_VIEW, 27).         %%领地战晚宴饰品,不可选不可攻
-define(MON_KIND_KINDOM_GUARD, 28).         %%王城守卫,可选不可攻
-define(MON_KIND_CROSS_BATTLEFIELD_MON, 29).         %%跨服战场小怪
-define(MON_KIND_CROSS_BATTLEFIELD_BOX, 30).         %%跨服战场宝箱
-define(MON_KIND_KINDOM_GUARD_BOX, 31).         %%王城守卫宝箱
-define(MON_KIND_CROSS_BATTLEFIELD_BUFF, 32).         %%跨服战场buff,不可选不可攻
-define(MON_KIND_WORSHIP, 33).              %%王城膜拜怪
-define(MON_KIND_NORMAL_1, 34).              %%普通怪 不可选不可攻
-define(MON_KIND_GUARD, 35).              %%普通怪 不可选不可攻
-define(MON_KIND_MARRY_CAR, 36).            %%婚车 不可选不可攻
-define(MON_KIND_PARTY, 37).                %%晚宴可采集
-define(MON_KIND_CROSS_WAR_TOWER, 38).  %% 攻城战箭塔
-define(MON_KIND_CROSS_WAR_DOOR, 39).  %% 攻城战城门
-define(MON_KIND_CROSS_WAR_KING_GOLD, 40). %% 攻城战宝珠
-define(MON_KIND_CROSS_WAR_BOMB, 41). %% 攻城战炸弹
-define(MON_KIND_CROSS_WAR_KING_DOOR, 42).  %% 攻城战王城城门
-define(MON_KIND_CROSS_WAR_BANNER, 43).  %% 攻城战旗子
-define(MON_KIND_CROSS_SCUFFLE_ELITE_PARTY_DESK, 44).     %%精英赛晚宴采集桌,可选可采集
-define(MON_KIND_CROSS_BOSS_BOX, 45).         %%跨服boss宝箱
-define(MON_KIND_MARRY_BOX, 46).         %%桃花岛宝箱
-define(MON_KIND_CROSS_GUARD, 47).         %%跨服试炼副本剑像,可选不可攻
-define(MON_KIND_CROSS_GUARD_BOX, 48).         %%跨服试炼副本宝箱
-define(MON_KIND_PRISON, 50).         %%监狱怪
-define(MON_KIND_GUILD_BOSS, 51).         %%仙盟神兽
-define(MON_KIND_GUILD_FLAG_MON, 52).         %%旗帜怪物


-define(BOSS_TYPE_ELITE, 2).%%精英boss类型
-define(BOSS_TYPE_HUNT, 7).%%猎场boss类型
-define(BOSS_TYPE_FIELD, 8).%%野外boss类型
-define(BOSS_TYPE_CROSS, 9).%%跨服boss类型
-define(BOSS_ACT_FESTIVE, 10). %%节日首领

-define(ETS_SCENE_COPY, ets_scene_copy).


%%怪物分组
-define(GROUP_MAX, 250).    %%最大分组
-define(GROUP_NONE, 0).     %%无分组中立
-define(GROUP_CALLER, 1).   %%召唤者
-define(GROUP_DUNGEON, 9).  %%副本类分组

-define(AI_MON_TYPE, 1).


%%PK模式
-define(PK_TYPE_PEACE, 0).%%和平
-define(PK_TYPE_FIGHT, 1).%%全体
-define(PK_TYPE_TEAM, 2).%队伍
-define(PK_TYPE_GUILD, 3).%仙盟
-define(PK_TYPE_SERVER, 4).% 本服


%% ==============================
%% record 数据结构
%% ==============================

-record(ets_scene_acc, {
    pid = 0,
    scene_id = 0,
    copy = 0,
    time = 0,
    acc = 0
}).

-record(ets_scene_pid, {key = 0, pid = none}).

-record(scene_state, {
    sid = 0,
    copy = 0,
    timer = none,
    long_timer = none,
    self = none,
    worker = [],
    npc = [],
    manor_guild_name = <<>>,
    is_receive_msg = true,

    msg_count = []  %%消息统计 [{key, times, time}]
}).
%% 基础场景数据结构
-record(scene, {
    id = 0,                %%场景id
    sid = 0,                %%场景资源id
    name = <<>>,             %%场景名称
    type = 0,               %%场景类型
    x = 0,                  %%复活点x
    y = 0,                  %%复活点y
    elem = [],              %%场景元素
    require = [],           %%进入需求
    npc = [],               %%npc
    mon = [],               %%怪物
    door = [],               %%传送门
    flys = [],              %%跳跃点
    width = 0,               %%场景宽
    height = 0,              %%场景高
    pk_protect = [],         %%场景保护类型列表  1和平2队伍3仙盟4阵营 []自由pk
    pk_recover = 0,         %%pk模式自动恢复
    pk_change = 0,            %%自动切换pk模式 -1不切换
    pk_can_change = 0,      %%是否可以切换pk模式
    revive_type = 0,         %%复活类型 0不可复活 1可复活 2只可复活点复活 3只可复活药/元宝复活
    att_red_name = 0        %%是否可攻击红名玩家 0否1是
}).

%% 基础npc数据
-record(npc, {
    id = 0,                 %%ncp id
    func = 0,               %%功能
    icon = 0,               %%资源id
    image = 0,             %%头像
    name = <<>>,            %%名字
    talk = 0,               %%对话内容
    realm = 0               %%阵营
}).


%% 怪物数据结构
%% 注意：怪物数据与怪物基础数据字段名称必须保持一致
-record(mon, {
    %% -- 基础数据
    mid = 0,               %%怪物类型id
    name = <<>>,           %%怪物名称
    kind = 0,              %%怪物种类 参考定义宏
    patrol = 0,             %%是否巡逻0否1是
    type = 0,              %%怪物攻击类型 参考攻击倾向 宏定义
    boss = 0,              %% 0 普通怪物 1野外boss  2精英怪 3领主 4 玩家分身 5世界boss,6猎场boss
    is_att_by_mon = 0,      %%是否可被怪物攻击
    is_att_by_player = 0,   %%是否可被玩家攻击
    is_collect = 0,         %%是否可被采集
    icon = 0,              %%资源id
    lv = 0,               %%怪物等级
    hp_lim = 0,           %%默认血量
    hp_num = 0,           %%每次回血血量
    mp_lim = 0,           %%默认蓝量
    mp_num = 0,           %%每次回蓝量
    mana_lim = 0,           %%法盾值上限
    mana = 0,           %%法盾值
    %%属性
    speed = 0,              %%移动速度
    base_speed = 0,         %%移动速度
    att_speed = 0,          %%攻击速度
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
    pvp_inc = 0,
    pvp_dec = 0,

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

    crit_ratio = 0,%%人物暴击率
    hit_ratio = 0,%%人物命中率
    hurt_fix = 0,%%固定伤害

    hp_lim_inc = 0,         %%气血增加百分比
    recover = 0,            %%秒回生命
    recover_hit = 0,        %%击中回血
    size = 0,               %%体型
    cure = 0,               %%治疗效果
    %% --
    unyun = 0,              %%抗击晕
    unbeat_back = 0,        %%抗击退
    unholding = 0,          %%抗拉
    unfreeze = 0,           %%抗冰冻
    uncm = 0,               %%抗沉默
    unbleed = 0,            %%抗流血
    skill = [],             %%技能列表
    passive_skill = [],     %%被动技能
    skill_qte = [],         %%qte技能列表
    att_area = 0,           %%攻击范围
    guard_area = 0,         %%警戒范围
    trace_area = 0,         %%追踪范围
    beat_back = 0,          %%是否有击退效果
    d_x = 0,                %%默认出生x
    d_y = 0,                %%默认出生y
    retime = 1000,          %%重生时间
    exp = 0,                %%怪物经验
    drop_rule = 0,          %%掉落规则
    act_drop_rule = 0,      %%活动掉落规则
    drop_item = [],         %%固定掉落
    drop_kill = [],         %%首次击杀掉落
    path = [],              %%自动行走路径
    color = 0,              %%颜色属性
%%     ai_type = 0,            %%怪物ai类型0普通,1主动攻击怪
    ai = [],               %%怪物ai列表
    dieeff = [],            %%死亡效果
    collect_time = 0,      %%采集时间
    collect_num = 0,       %%可采集次数
    life = 0,           %%存活秒数
    %% ---- 动态数据
    key = 0,                %%怪物唯一id
    scene = 0,              %%场景
    copy = 0,               %%副本id或进程
    x = 0,
    y = 0,
    hp = 0,
    mp = 0,
    pid = 0,                %%怪物进程
    group = 0,             %%队伍
    owner_key = 0,          %%召唤者key
    owner_pid = 0,          %%召唤者进程
    trans = 0,             %%变身
    conjure = 0,           %%施法状态
    collect_count = 0,      %%已采集次数
    share_list = [],        %%共享怪物的进程列表
    shadow_key = 0,        %%分身所属key
    shadow_status = [],    %%玩家分身数据
%%     attack_tendency = 0,    %%攻击倾向 0随机 1怪物 2玩家
    obj_ref = #obj_ref{},   %%定时器
    time_mark = #time_mark{},%%时间记录
    sync_time = 0,          %% 更新时间
    buff_list = [],        %%buff列表
    eff_list = [],         %%效果列表
    skill_cd = [],         %%技能cd
    invade = [],             %%魔物入侵信息
    wave = 0,                %%所属怪物波数
    cross_scuff_elite_fight_num = 0,    %%乱斗精英轮数
    cl_auth = [],            %%采集权限列表[{pkey,state}]
    eliminate_group = 0,          %%消除id
    walk = [],
    pet_att_param = 1,           %%宠物攻击系数
    t_att = 0,                 %%攻击次数
    t_def = 0,               %%被击防首次数
    is_view = 0,                     %%是否可见0全部可见,1技能隐身,2观战
    guild_key = 0,               %%仙盟归属
    show_time = 0,              %%时间外显示
    att_lock = {0, 0},            %%攻击锁{上锁玩家key,上锁时间}
    party_key = 0,
    index = 0,               %%下表key
    war_pos = 0              %%出战位置
}).


%%战斗场景需同步相关属性
-record(batt_info, {
    skill = [],                 %% 技能列表
    skill_cd = [],              %% 技能cd
    speedup = [],               %% 加速记录
    hit_list = [],              %% 攻击者列表[{玩家id, 攻击的时间(ms)}..]
    buff_list = [],             %% buff列表
    obj_ref = #obj_ref{},       %% 定时器
    last_attack_target = [],    %%上一次攻击目标[key,pid,type]
    last_skill_id = 0,          %%上一次使用技能id
    time_mark = #time_mark{}    %%时间标记
}).


%% 场景宠物元素
-record(scene_pet, {
    type_id = 0,           %%类型id
    figure = 0,            %%外观
    name = "",             %%名字
    star = 0,               %%星级
    stage = 0,              %阶数
    att_param = 1,           %%攻击系数
    skill = []            %%技能
}).


%% 场景宝宝数据
-record(scene_baby, {
    type_id = 0,           %%类型id
    figure = 0,            %%外观
    name = "",             %%名字
    step = 0,              %%阶数
    lv = 0,                %%等级
    skill = []             %%技能
}).


%%场景玩家数据 （注意字段名称跟玩家结构保持一致)
-record(scene_player, {
    key = 0,                       %% 玩家key
    sn = 0,                        %% 服务器id
    sn_cur = 0,                    %% 当前服务器id
    sn_name = <<>>,                 %%服务器名
    pf = 0,                        %% 平台id
    nickname = [],                 %% 玩家名
    avatar = "",                   %% 头像
    lv = 1,                        %% 等级
    scene = 0,                     %% 场景id
    copy = 0,                      %% 副本id
    guild_key = 0,                 %% 仙盟id
    guild_name = [],               %% 仙盟名字
    guild_position = 0,            %% 仙盟职位
    war_team_key = 0,              %%战队key
    war_team_name = <<>>,          %%战队名称
    war_team_position = 0,         %%战队职位
    cross_scuffle_elite_rank = 0,  %% 乱斗精英赛最高名次
    node = none,                   %% 来自节点
    sid = {},                      %% 玩家发送消息进程
    pid = 0,                       %% 玩家进程
    hp = 0,                        %% 气血
    mp = 0,                        %% 魔法
    mana_lim = 0,                  %% 法盾值上限
    mana = 0,                      %% 法盾值
    sin = 0,                       %% 神罚值
    x = 0,                         %% X坐标
    y = 0,                         %% Y坐标
    move_time = 0,                  %%移动时间(魔宫)
    cbp = 0,                       %% 战斗力
    skill_effect = 0,       %%使用的技能效果
    passive_skill = [],     %%被动技能
    magic_weapon_skill = [],            %%法宝技能
    xian_skill = [],               %% 飞仙技能
    attribute = #attribute{},      %% 玩家属性
    scuffle_attribute = #attribute{},      %% 玩家属性
    scuffle_elite_attribute = #attribute{},      %% 玩家属性
    battle_info = #batt_info{},    %% 战斗动态数据
    team_leader = 0,               %% 是否队长
    team = 0,                      %% 组队进程id
    teamkey = 0,                  %% 队伍key
    pet = #scene_pet{},            %% 宠物数据
    baby = #scene_baby{},          %% 宝宝数据
    equip_figure = #equip_figure{},%% 装备
    wing_id = 0,                   %% 穿戴的翅膀
    baby_wing_id = 0,               %% 子女翅膀
    baby_mount_id = 0,               %% 子女坐骑
    baby_weapon_id = 0,               %% 子女武器
    fashion = #fashion_figure{},   %% 时装信息
    sprite_lv = 0,                   %%精灵等级
    light_weapon_id = 0,           %% 光武信息
    pet_weapon_id = 0,              %%妖灵信息
    cat_id = 0,              %%灵猫信息
    golden_body_id = 0,
    god_treasure_id = 0,
    jade_id = 0,
    career = 0,                    %% 职业
    new_career = 1,                %% 转生职业
    sex = 0,
    realm = 0,                     %% 国家，阵营
    group = 0,                     %% 战斗分组（目前为竞技场阵营）
    design = [],                   %% 称号列表
    mount_id = 0,              %% 坐骑形象
    vip = 0,                       %% vip类型
    vip_state = 0,                 %% vip_state
    halo_id = 0,                   %% 玩家光环id
    collect_pid = {0, 0},          %% 采集的怪物的{进程pid, mid}
    pk = #pk{},                   %% 场景pk数据
    evil = #pevil{},               %% 妖神变身
    sync_time = 0,                 %% 更新时间
    suit_id = 0,                   %% 当前装备全套的套装ID
    image = 0,                     %% 头像
    visible = 0,                   %% 是否可见 0:可见 1:不可见
    shadow_pid = none,             %% 分身进程
    show_pid = none,               %% 展示分身进程
    convoy_state = 0,              %% 护送状态，0无，（1~4）品质
    convoy_rob = 0,                  %%劫镖次数
    figure = 0,                   %%变身ID
    collect_flag = 0,                %% 采集标记
    combo = 0,                 %%连杀数
    bf_score = 0,                    %%战场积分
    scene_face = "",                 %%场景表情
    eliminate_group = 0,             %%消消乐分组
    crown = 0,                       %%城战皇冠标记
    cw_leader = 0,
    commom_mount_pkey = 0,            %%共骑者pkey
    main_mount_pkey = 0,            %%主骑者pkey
    commom_mount_state = 0,            %%状态 0.没有共乘 1.主乘 2共乘
    sword_pool_figure = 0,
    t_att = 0,                  %%攻击次数
    t_def = 0,                  %%被击防首次数
    is_view = 0,                %%是否可见0全部可见,1技能隐身,2观战模式
    magic_weapon_id = 0,        %%法宝形象
    god_weapon_id = 0,          %%十荒神器id
    god_weapon_skill = 0,       %%十荒神器技能
    att_lock = {0, 0},            %%攻击锁{上锁玩家key,上锁时间}
    footprint_id = 0,
    hot_well = #phot_well{},
    is_transport = 0,           %%是否传送中1是0否
    marry = #marry{},
    marry_ring_lv = 0,
    sit_state = 0,                 %%打坐状态1是0否
    show_golden_body = 0,           %%显示法身
    dvip_type = 0,                  %% 1钻石vip，2永久VIP
    xian_stage = 0,                  %% 仙阶
    field_boss_times = 0,
    jiandao_stage = 0,  %% 剑道阶数
    wear_element_list = [] %% 穿戴元素列表
}).


%% 怪物活动状态结构
-record(mon_act, {
    key_list = [],
    state = sleep,         %%怪物状态 sleep | trace | trace_ready |
    att = [],             %%攻击对象[key,pid,atttype] atttype 1怪物 2玩家
    unatt = [],           %%非攻击对象key列表 [key1,key2..] 发生跟随,不会攻击,非攻击对象需要从group or team 排除.
    attfix = [],           %%固定攻击对象,不随状态清除
    minfo = {},           %%怪物数据?MON
    klist = [],            %%伤害列表
    attlist = [],          %%攻击者列表
    clist = [],            %%采集列表
    eat_keys = [],          %%宴席采集玩家key列表
    self = none,           %%当前进程
    ready_ref = none,      %%施法前摇定时器
    ref = none,            %%怪物活动定时器
    tick = 0,              %%心跳次数
    wait = 0,              %%等待时间,毫秒
    first_att_key = [],    %%第一次攻击玩家key
    last_att_key = [],     %%最后攻击玩家key
    total_hurt = 0,       %%受到的总伤害值
    ready_skill = [],      %%施放准备技能数据
    last_skill = 0,        %%上一次使用的技能id
    once_skill = 0,        %%优先使用技能id,每次攻击后重置
    block_buff = 0,        %%打断后触发的buffid
    robot_ai = [],          %%机器人ai
    node = none,
    skill_times = 0,
    trace_hold = 0
}).

%%场景线路人数统计
-record(scene_copy, {
    scene_id = 0,
    copy_list = [],%%线路列表[{线路id,人数,时间戳}]
    cross_copy_list = [],
    default = false,
    copy_mb_count_list = []
}).
%%单线路具体数据
-record(scene_copy_count, {
    copy = 0,
    count = 0,
    time = 0,
    log_sn = []
}).

-record(ets_cross_out, {
    pkey = 0,
    scene = 0,
    copy = 0,
    x = 0,
    y = 0,
    pk = 0
}).

-endif.