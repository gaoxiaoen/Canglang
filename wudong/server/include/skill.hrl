-define(COMBO_SKILL_IDS, [11, 12, 13, 14, 15, 21, 22, 23, 24, 25]).  %%连击技能id
-define(COMBO_SKILL_CAREER1, [11, 12, 13, 14, 15]).
-define(COMBO_SKILL_CAREER2, [21, 22, 23, 24, 25]).

-include("battle.hrl").
-define(SKILL_TYPE_BATTLE, 1).    %%战斗技能
-define(SKILL_TYPE_QTE, 2).       %%qte技能
-define(SKILL_TYPE_POS, 3).       %%位移技能
-define(SKILL_TYPE_COM, 4).       %%通用技能
-define(SKILL_TYPE_ATTR, 5).
-define(SKILL_TYPE_PASSIVE, 6).      %%被动技能
-define(SKILL_TYPE_MAGIC_WEAPON, 7).      %%法宝技能

-define(TARGET_ATT, 0).          %%技能目标攻击方
-define(TARGET_DEF, 1).         %%技能目标受击方
-define(TARGET_ACTOR_DEF, 2).         %%技能目标主选
-define(TARGET_MON, 3).         %%技能目标非boss
-define(TARGET_TEAM, 4).        %%作用于队友

-define(PASSIVE_SKILL_TYPE_MOUNT, 1).%%坐骑
-define(PASSIVE_SKILL_TYPE_WING, 2).%%仙羽
-define(PASSIVE_SKILL_TYPE_MAGIC_WEAPON, 3).%%法宝
-define(PASSIVE_SKILL_TYPE_LIGHT_WEAPON, 4).%%神兵
-define(PASSIVE_SKILL_TYPE_PET_WEAPON, 5).%%宠物
-define(PASSIVE_SKILL_TYPE_SCUFFLE, 6).%%乱斗
-define(PASSIVE_SKILL_TYPE_CAT, 7).%%灵猫技能
-define(PASSIVE_SKILL_TYPE_GOLDEN_BODY, 8).%%金身
-define(PASSIVE_SKILL_TYPE_FOOTPRINT, 9).%%足迹

-define(PASSIVE_SKILL_TYPE_BABY_WING, 10).%%子女仙羽
-define(PASSIVE_SKILL_TYPE_DVIP, 11).%%钻石vip
-define(PASSIVE_SKILL_TYPE_BABY_MOUNT, 12).%%子女坐骑
-define(PASSIVE_SKILL_TYPE_BABY_WEAPON, 13).%%子女武器
-define(PASSIVE_SKILL_TYPE_FEIXIAN, 14). %%飞仙
-define(PASSIVE_SKILL_TYPE_JADE, 15). %%玉佩
-define(PASSIVE_SKILL_TYPE_GOD_TREASURE, 16). %%仙宝
-define(PASSIVE_SKILL_TYPE_FASHION_SUIT, 17). %%套装
-define(PASSIVE_SKILL_TYPE_GODSOUL_SUIT, 18). %%神魂套装
-define(PASSIVE_SKILL_TYPE_JIANDAO, 19). %%剑道


-define(SKILL_MOD_SINGLE, 1).
-define(SKILL_MOD_ALL, 2).
-define(SKILL_MOD_SELF, 3).
-define(SKILL_MOD_TEAM, 4).

-define(SKILL_EVIL_LIST, [1401001, 1402001, 1403001]).  %%妖神技能
-include("server.hrl").

-record(st_skill, {
    pkey = 0,
    skill_effect = 0,
    skill_battle_list = [],
    skill_passive_list = [],
    attribute = #attribute{},
    is_change = 0
}).

-record(skill, {
    skillid = 0,
    next_skillid = 0,
    icon = 0,
    mp = 0,                %%魔法消耗
    lv = 0,                %%当前等级
    needlv = 0,            %%需要等级
    uplv = [],             %%[初始升级等级,等级间隔]
    hurt_prop = 1,         %%1物理伤害 2魔法伤害
    att_area = 0,          %%攻击范围
    area = 1,              %%伤害范围
    career = 0,            %%职业
    hurtnum = 0,           %%伤害数
    stack = 0,             %%叠加层数
    type = 0,             %%1战斗技能2qte技能3位移技能4通用技能5宠物技能,6被动技能
    subtype = 0,           %%0主动技能1被动技能,2被击触发
    mod = 0,               %%1单体，2群攻
    param = 1,            %%参数
    param2 = 0,           %%参数2
    efflist = [],          %%效果列表
    bufflist = [],         %%buff列表
    fixhitlv = 0,          %%固定命中等级
    aim = 0,             %%技能命中
    cim = 0,             %%技能暴击
    ratio = 0,             %%qte 概率 | qte 权重
    cbp = 0,               %%战力 技能战力+属性战力
    skill_cbp = 0,          %%技能战力
    cbp_factor = 0,        %%技能战斗力系数
    faint = 0,             %%技能硬直
    cd = 0,                %%cd 时间
    cost = 0,             %%升级消耗银币
    goods = {},
    exp = 0,
    yctime = 0,            %%吟唱时间
    singRes = 0,           %%吟唱效果id
    effectTarget = 0,       %%效果目标
    passive_type = 0,     %%被动技能类型 1坐骑,2翅膀,3神魂套装
    attrs = [],
    attrs_percent = 0,    %%属性加成百分比
    att_type = 0          %% 攻击类型1单体2横排3竖排4全体

}).

-record(buff, {
    buffid = 0,
    type = 0,              %%buff类型0中性1增益2减益,3控制
    subtype = 0,           %%buff子类型 0普通1经验2护盾
    time = 0,              %%持续时间
    stack = 0,              %%最大叠加层
    start_eff = [],         %%使用效果列表
    efflist = [],           %%持续效果列表
    end_eff = [],           %%结束效果列表
    clashlist = [],         %%冲突列表
    coverlist = [],         %%覆盖列表
    param = 1,              %%等级加成系数
    stack_type = 0,         %%buff叠加类型
    time_max = 0,       %%相同buff叠加，时效延长，并且有最大值
    eff_scene = [],          %%生效的场景类型列表,[]为没限制
    un_eff_scene = [],          %%不生效的场景类型列表
    eff_sign = 0,           %%生效主体0全部,1玩家2怪物
    is_cover = 0,              %%覆盖同类1覆盖0否
    is_clean = 0        %%是否死亡清理

}).


%%技能buff单元
-record(skillbuff, {
    buffid = 0,             %%buffid
    skillid = 0,            %%技能id
    skilllv = 0,            %%技能等级
    stack = 1,              %%当前叠加层
    stack_lim = 0,          %%最高叠加层
    param = 1,        %加成系数
    time = 0,              %%buff超时时间
    type = 0,              %%buff类型0中性1增益2减益
    subtype = 0,
    attacker = #attacker{},
    is_clean = 0        %%是否死亡清理
}).

%% 效果单元
-record(eff, {
    key = 0,                %% {skillid,effid}
    effid = 0,              %% 效果id
    target = 0,             %% 效果目标 0自己1其他人2主选目标3小怪
    args = [],              %% 传入参数
    v = 1,                  %% 参数加成系数
    attacker = #attacker{}
}).

-record(st_buff, {
    pkey = 0,
    buff_list = [],
    is_change = 0
}).

-record(buff_cd, {
    buff_id = 0,
    time = 0
}


).
