-ifndef(BATTLE_HRL).
-define(BATTLE_HRL, 1).
-include("server.hrl").
-define(TEAM1, 1).      %%攻击方
-define(TEAM2, 2).      %%防御方

-define(ACTOR_ATT, 1).       %%攻击者
-define(ACTOR_DEF, 2).       %%被击选定目标
-define(ACTOR_OTHER, 0).     %%被群攻伤害目标

-define(STATE_NORMAL, 0).    %%正常状态
-define(STATE_CRIT, 1).      %%暴击状态
-define(STATE_DODGE, 2).     %%闪躲状态
-define(STATE_DIZZZY, 3).    %%晕眩状态
-define(STATE_SILENT, 4).    %%沉默状态
-define(STATE_GOD, 5).       %%免疫状态
-define(STATE_FIRING, 6).    %%灼烧状态
-define(STATE_FIRING_P, 7).  %%灼烧加成状态
-define(STATE_EASY, 8).      %%易伤状态
-define(STATE_EASY_P, 9).    %%易伤加成状态
-define(STATE_ADD_HURT, 10).  %%增伤加成状态


-define(HURT_TYPE_NORMAL, 0).   %%普通伤害
-define(HURT_TYPE_BUFF_INC, 1). %%buff加血
-define(HURT_TYPE_BUFF_DEC, 2). %%buff伤害
-define(HURT_TYPE_GOD_INC, 3).  %%神奇吸血

-define(EFF_POS_BACK, 1).%%击退
-define(EFF_POS_HOLDING, 2).%%拉人
-define(EFF_POS_SPRING, 3).%%冲刺

%%1加速 2减速  3反弹伤害 4法盾 5晕眩6冰冻7沉默8恐惧9缠绕10无敌11免疫特效12击退13拉人14禁止轻功15冲刺16感染17嘲讽 18吸血 19法师护盾 20伤害加深)
-define(EFF_SPEED_UP, 1).
-define(EFF_SPEED_DOWN, 2).
-define(EFF_FTSH, 3).
-define(EFF_SHIELD, 4).
-define(EFF_YUN, 5).
-define(EFF_FREEZE, 6).
-define(EFF_CM, 7).
-define(EFF_FEAR, 8).
-define(EFF_BIND, 9).
-define(EFF_GOD, 10).%%战士护盾
-define(EFF_IMMUNE, 11).
-define(EFF_BACK, 12).
-define(EFF_HOLDING, 13).
-define(EFF_FORBIT_JUMP, 14).
-define(EFF_SPRING, 15).
-define(EFF_INFECT, 16).
-define(EFF_SNEER, 17).
-define(EFF_SUCKBLOOD, 18).
-define(EFF_GOD2, 19).%%法师护盾
-define(EFF_DAMAGE_ADD, 20).


%% 攻击者状态结构
-record(attacker, {
    key = 0,              %%攻击者key
    sign = 0,              %%1怪物 2玩家
    is_shadow = 0,          %%是否镜像
    shadow_key = 0,          %%镜像key
    name = <<>>,           %%昵称
    lv = 0,                %%等级
    realm = 0,             %%阵营
    mid = 0,               %%怪物类型ID
    pid = 0,               %%玩家进程
    team = 0,              %%队伍进程
    group = 0,             %%分组
    eli_group = 0,          %%消消乐分组
    cbp = 0,               %%战斗力
    hp = 0,                %%气血
    hp_lim = 0,            %%气血上限
    scene = 0,
    copy = 0,
    x = 0,                %%坐标x
    y = 0,                %%坐标y
    owner_key = 0,         %%所属玩家key
    pk_status = 0,         %% pk模式
    hurt = 0,              %% 当次打击做成的伤害
    gkey = 0,
    gname = <<>>,
    node = none,
    sn = 0,
    figure = 0,
    vip = 0,
    convoy_rob = 0,                  %%劫镖次数
    att_area = 0,
    sid = {},
    field_boss_times = 0
}).

%%战斗其他参数
-record(bs_args, {
    skillid = 0,                %%技能id
    param1 = 0,                 %%战斗公式参数1 百分比
    param2 = 0,                 %%战斗公式参数2
    tx = 0,                     %%攻击目标坐标点x
    ty = 0,                     %%攻击目标坐标点y
    hurt_prop = 0,              %%伤害类型
    ice_hurt = 0,               %%破冰伤害
    hurt_inc = 0,              %%技能伤害加成
    eff_x = 0,                  %%效果目标坐标x
    eff_y = 0,                  %%效果目标坐标y
    %% --布尔值
    fix_hit = false,           %%固定命中
    fix_miss = false,           %%必然miss
    fix_target = false,         %%固定目标，不造成AOE
    fix_protect = false,        %%固定1血保护
    god_mode = false,               %%上帝无敌模式
    unyun = 0,                  %%抗击晕
    unctrl = 0,                  %%抗控制
    unbeat_back = 0,            %%抗击退
    unholding = 0,              %%抗拉
    unfreeze = 0,               %%抗冰冻
    uncm = 0,                  %%抗沉默
    zero_p_hurt = false,        %%不受物理伤害
    zero_m_hurt = false         %%不受魔法伤害
}).

-record(eff_args, {
    none = 0,                  %%不产生任何伤害
    dizzy = 0,                  %%晕眩次数,停手N回合
    be_dizzy_rate = 0,          %%使对方眩晕
    fire_add = 0,                %%灼烧加伤
    fire_add_round = 0,          %%灼烧加伤回合数
    fire_add_p = 0,              %%灼烧加伤百分比
    fire_add_p_round = 0,         %%灼烧加伤百分比 生效N回合
    easy_hurt = 0,                %%易伤值
    easy_hurt_round = 0,          %%易伤回合
    easy_hurt_p = 0,               %%易伤百分比
    easy_hurt_p_round = 0,         %%易伤百分比回合
    add_hurt_p = 0,                %%增伤百分比
    add_hurt_p_round = 0          %%增伤回合
}).

-record(bs, {
    key = none,
    sn = 0,
    pf = 0,
    node = none,
    x = 0,
    y = 0,
    is_move = 0,                %%是否移动位置
    name = none,
    pid = none,                 %%玩家进程
    actor = 0,                  %%战斗角色 1攻击方2攻击目标0群伤目标
    sign = 0,                   %%1人2怪
    is_shadow = 0,             %%是否镜像1是0否
    shadow_key = 0,             %%镜像key
    scene = 0,                  %%场景id
    copy = 0,                   %%副本进程
    lv = 0,                     %%等级
    career = 0,                 %%职业
    new_career = 0,                 %%转身职业
    team = none,                %%队伍进程
    group = 0,                  %%分组
    guild_key = 0,              %%帮派key
    guild_name = 0,              %%帮派名称
    realm = 0,                  %%阵营
    mid = 0,                   %%怪物Id
    kind = 0,                   %%怪物类型
    boss = 0,                   %%boss类型
    state = 0,                  %%普攻，暴击，闪避等
    state_list = [],            %%[普攻，暴击，闪避等]
    hurt_list = [],             %%伤害列表
    eff_list = [],              %%效果列表 [#eff{}]
    dieeff_list = [],           %%死亡触发效果列表[#eff{}]
    last_eff_list = [],         %%出手后触发效果列表[#eff{}]
    buff_list = [],             %%buff列表 [#skillbuff{}]
    hit_list = [],              %%攻击列表
    kill_list = [],             %%击杀列表
    der_list = [],              %%使用某些技能后的新增被击玩家列表 [#bs{}]
    skill = [],                %%技能列表 [{skillid,slv,state}]
    skill_effect = 0,       %%使用的技能效果
    passive_skill = [],             %%被动技能[{skillid,slv,type}]
    skill_cd = [],              %%技能cd  [{skillid,usetime}]
    new_skill_cd = [],          %%新使用的技能CD
    cbp = 0,                    %%战斗力
    rage = 0,                   %%怒气值
    time_mark = #time_mark{},  %%时间记录
    attacker = #attacker{},    %%攻击者信息
    bs_args = #bs_args{},      %%战斗参数
    obj_ref = #obj_ref{},      %%定时器
    pk = #pk{},                 %%pk状态
    eff_args = #eff_args{},    %%回合制效果参数
    evil = 0,                   %%是否妖神变身
    now = 0,                    %%当前时间戳 秒
    now2 = 0,                   %%当前时间戳 毫秒
    sync_time = 0,              %%数据同步时间
    %% 二级属性
    hp_lim = 0,
    hp = 0,
    is_restore_hp = 0,                    %%是否回血1是0否
    mp_lim = 0,
    mp = 0,
    mana_lim = 0,               %%法盾上限值
    mana = 0,                   %%法盾值
    sin = 0,                    %%神罚值
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
    pvp_inc = 0,%%PVP增伤
    pvp_dec = 0,%%PVP免伤
%%    pet_hurt = 100,
    pet_att_param = 1,%%宠物攻击系数

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
    element_hurt = 0, %% 元素伤害

    hp_lim_inc = 0,             %%气血增加百分比
    recover = 0,                %%秒回生命
    recover_hit = 0,            %%击中回血
    size = 0,                   %%体型
    cure = 0,                   %%治疗效果
    base_speed = 0,             %%基础速度
    speed = 0,                  %%移动速度
    att_speed = 1,              %%攻击速度
    att_area = 1,               %%攻击范围
    prepare = 0,               %%施法前摇
    t_att = 0,                 %%攻击次数
    t_def = 0,               %%被击防首次数
    is_view = 0,                     %%是否可见0全部可见,1技能隐身,2观战
    convoy_rob = 0,                  %%劫镖次数
    vip = 0,
    figure = 0,
    field_boss_times = 0,
    die_type = 0, %% 死亡类型
    war_sign = 0,  %% 阵营方
    type_id = 0,   %% 宠物类型ID
    pos = 0, %% 上阵位置
    star = 0 %% 星级
}).

-record(st_hatred, {
    sign = 0,
    key = 0,
    nickname = <<>>,
    lv = 0,
    gkey = 0,
    gname = <<>>,
    sn = 0,
    cbp = 0,
    pid = none,
    team_pid = 0,
    hurt = 0,
    node = none,
    field_boss_times = 0
}).

-endif.