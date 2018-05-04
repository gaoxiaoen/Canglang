%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@ijunhai.com
%%% @copyright (C) 2015, 君海网络
%%% @doc
%%% 属性计算相关
%%% @end
%%% Created : 19. 十月 2015 9:52
%%%-------------------------------------------------------------------
-module(mod_attr).

%%-include("common.hrl").
-include("mgeew.hrl").
%% API
-export([generate_fight_attr/3,
         calc_fight_attr/1,
         full/1]).
-export([merge_fight_attrlist/1, merge_fight_attr/2, expand_fight_attr/2, trunc/1, kvlist_to_attr/1]).

%% =================================================================================
%% API Implement
%% =================================================================================

%% @doc 满状态
full(P = #p_fight_attr{max_hp = MaxHp, max_mp = MaxMp}) ->
    P#p_fight_attr{hp = MaxHp, mp = MaxMp}.

%% @doc 同步属性
-spec maybe_sync(AttrRecord, NeedSync) -> ok when
    AttrRecord :: #p_role_attr{},
    NeedSync :: true | false.
maybe_sync(_, false) -> ignore;
maybe_sync(#p_role_attr{role_id = RoleId, attr = FightAttr}, FightAttr) -> %% 玩家属性同步
    common_misc:send_to_role_map(RoleId, {mod, mod_map_role, {fight_attr_sync, RoleId, ?ACTOR_TYPE_ROLE, FightAttr}});
maybe_sync(#r_pet{pet_id = PetId,role_id=RoleId, attr = FightAttr}, FightAttr) -> %% 宠物属性同步
    common_misc:send_to_role_map(RoleId, {mod, mod_map_role, {fight_attr_sync, PetId, ?ACTOR_TYPE_PET, FightAttr}});
maybe_sync(_, _) -> ignore.

%% @doc 构造战斗属性
-spec generate_fight_attr(ActorId, ActorType, NeedSync) -> NewAttrRecord when
    ActorId :: role_id | pet_id | integer(),
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET,
    NeedSync :: true | false,
    NewAttrRecord :: #p_role_attr{} | #r_pet{} | undefined.
%% 玩家 (玩家进程调用)
generate_fight_attr(RoleId, ?ACTOR_TYPE_ROLE, NeedSync) ->
    {ok, RoleAttr = #p_role_attr{role_id = RoleId, power = Power,
                            magic = Magic, body = Body, spirit = Spirit, agile = Agile, attr = OldAttr}} = mod_role:get_role_attr(RoleId),
    #p_fight_attr{hp = OldHp, mp = OldMp, anger = OldAnger} = OldAttr,
    {ok,#p_role_base{category = Category}} = mod_role:get_role_base(RoleId),
    %% 职业初始战斗属性
    InitFightAttr = cfg_role_attr:init_attr(Category),
    %% 玩家基础属性
    BaseAttr = #r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile},
    %% ======================================================================================
    %% 各模块提供的基础属性在此处添加接口, 返回{#r_base_attr{}, #p_fight_attr{}}
    %% 例如: EquipBaseAttr = mod_equip:get_attr()
    %% ======================================================================================
    %% BUFF 模块属性
    {BuffBaseAttr, BuffFightAttr} = mod_buff:get_attr(RoleId, ?ACTOR_TYPE_ROLE),

    %% 合并一级属性
    FinalBaseAttr = merge_base_attrlist([BaseAttr, BuffBaseAttr]),

    %% 转换基础属性到战斗属性
    FightAttr = convert_fight_attr(FinalBaseAttr, Category),

    %% 合并二级属性
    FinalFightAttr = merge_fight_attrlist([InitFightAttr, FightAttr, BuffFightAttr]),

    %% 属性取整
    NewFightAttr = #p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger} = mod_attr:trunc(FinalFightAttr),

    %% 当前血量／蓝量／怒气 保留
    NewFightAttr1 = NewFightAttr#p_fight_attr{hp = min(OldHp, MaxHp),
                                              mp = min(OldMp, MaxMp),
                                              anger = min(OldAnger, MaxAnger)},

    NewRoleAttr = RoleAttr#p_role_attr{attr = NewFightAttr1},

    %% 同步属性
    maybe_sync(NewRoleAttr, NeedSync),

    mod_role:set_role_attr(RoleId, NewRoleAttr),

    NewRoleAttr;

%% 宠物
generate_fight_attr(PetId, ?ACTOR_TYPE_PET, NeedSync) ->
    {ok,Pet} =  mod_pet_data:get_pet(PetId),
    #r_pet{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile,
           attr=#p_fight_attr{hp=OldHp,mp=OldMp,anger=OldAnger}} = Pet,
    %% 宠物基础属性
    BaseAttr = #r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile},
    %% 宠物BUFF属性
    {BuffBaseAttr, BuffFightAttr} = mod_buff:get_attr(PetId, ?ACTOR_TYPE_PET),
     %% 合并一级属性
    FinalBaseAttr = merge_base_attrlist([BaseAttr, BuffBaseAttr]),
    %% 转换基础属性到战斗属性
    FightAttr = convert_fight_attr_pet(Pet,FinalBaseAttr),
    %% 合并二级属性
    FinalFightAttr = merge_fight_attrlist([FightAttr, BuffFightAttr]),
     %% 属性取整
    NewFightAttr = mod_attr:trunc(FinalFightAttr),
    #p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger} =  NewFightAttr,
    %% 当前血量／蓝量／怒气 保留
    NewFightAttr2 = NewFightAttr#p_fight_attr{hp = min(OldHp, MaxHp),
                                              mp = min(OldMp, MaxMp),
                                              anger = min(OldAnger, MaxAnger)},
    NewPet = Pet#r_pet{attr = NewFightAttr2},
    %% 同步属性
    maybe_sync(NewPet, NeedSync),
    
    mod_pet_data:set_pet(PetId, NewPet),
    NewPet;
%% 怪物(只考虑战斗属性和BUFF)
generate_fight_attr(_, _, _) ->
    undefined.

%% 计算战斗属性，包括BUFF
-spec 
calc_fight_attr(Info) -> Result when
    Info :: {?ACTOR_TYPE_ROLE,Category,#p_role_attr{}} | {?ACTOR_TYPE_PET,#p_pet{}},
    Category :: category_type(),
    Result :: #p_role_attr{} | #p_pet{} | undefined.
calc_fight_attr({?ACTOR_TYPE_ROLE,Category,RoleAttr}) ->
    #p_role_attr{role_id = RoleId, 
                 power = Power,magic = Magic, body = Body, spirit = Spirit, agile = Agile,
                 attr = OldAttr} = RoleAttr,
    #p_fight_attr{hp = OldHp, mp = OldMp, anger = OldAnger} = OldAttr,
    %% 职业初始战斗属性
    InitFightAttr = cfg_role_attr:init_attr(Category),
    %% 玩家基础属性
    BaseAttr = #r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile},
    %% BUFF 模块属性
    {BuffBaseAttr, BuffFightAttr} = mod_buff:get_attr(RoleId, ?ACTOR_TYPE_ROLE),

    %% 合并一级属性
    FinalBaseAttr = merge_base_attrlist([BaseAttr, BuffBaseAttr]),

    %% 转换基础属性到战斗属性
    FightAttr = convert_fight_attr(FinalBaseAttr, Category),

    %% 合并二级属性
    FinalFightAttr = merge_fight_attrlist([InitFightAttr, FightAttr, BuffFightAttr]),

    %% 属性取整
    NewFightAttr = #p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger} = mod_attr:trunc(FinalFightAttr),

    %% 当前血量／蓝量／怒气 保留
    NewFightAttr2 = NewFightAttr#p_fight_attr{hp = min(OldHp, MaxHp),
                                              mp = min(OldMp, MaxMp),
                                              anger = min(OldAnger, MaxAnger)},

    RoleAttr#p_role_attr{attr = NewFightAttr2};
calc_fight_attr({?ACTOR_TYPE_PET,Pet}) ->
    #r_pet{pet_id = PetId,
           power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile,
           attr=#p_fight_attr{hp=OldHp,mp=OldMp,anger=OldAnger}} = Pet,
    %% 宠物基础属性
    BaseAttr = #r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile},
    %% 宠物BUFF属性
    {BuffBaseAttr, BuffFightAttr} = mod_buff:get_attr(PetId, ?ACTOR_TYPE_PET),
     %% 合并一级属性
    FinalBaseAttr = merge_base_attrlist([BaseAttr, BuffBaseAttr]),
    %% 转换基础属性到战斗属性
    FightAttr = convert_fight_attr_pet(Pet,FinalBaseAttr),
    %% 合并二级属性
    FinalFightAttr = merge_fight_attrlist([FightAttr, BuffFightAttr]),
     %% 属性取整
    NewFightAttr = mod_attr:trunc(FinalFightAttr),
    #p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger} =  NewFightAttr,
    %% 当前血量／蓝量／怒气 保留
    NewFightAttr2 = NewFightAttr#p_fight_attr{hp = min(OldHp, MaxHp),
                                              mp = min(OldMp, MaxMp),
                                              anger = min(OldAnger, MaxAnger)},
    Pet#r_pet{attr = NewFightAttr2};
calc_fight_attr(_Info) ->
    undefined.

%% @doc 换算基础属性到战斗属性
-spec convert_fight_attr(BaseAttr, Category) -> FightAttr when
    BaseAttr :: #r_base_attr{}, Category :: integer(), FightAttr :: #p_fight_attr{}.
convert_fight_attr(#r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = Agile}, Category) ->
    %% 获取基础属性换算公式
    PC = cfg_role_attr:base_to_fight({Category, ?BASE_ATTR_POWER}),
    MC = cfg_role_attr:base_to_fight({Category, ?BASE_ATTR_MAGIC}),
    BC = cfg_role_attr:base_to_fight({Category, ?BASE_ATTR_BODY}),
    SC = cfg_role_attr:base_to_fight({Category, ?BASE_ATTR_SPIRIT}),
    AC = cfg_role_attr:base_to_fight({Category, ?BASE_ATTR_AGILE}),
    %% 基础属性换算战斗属性
    PFA = expand_fight_attr(PC, Power),
    MFA = expand_fight_attr(MC, Magic),
    BFA = expand_fight_attr(BC, Body),
    SFA = expand_fight_attr(SC, Spirit),
    AFA = expand_fight_attr(AC, Agile),
    %% 合并属性
    merge_fight_attrlist([PFA, MFA, BFA, SFA, AFA]).

%% 宠物基础属性到战斗属性计算
-spec 
convert_fight_attr_pet(Pet,BaseAttr) -> FightAttr when
    Pet :: #r_pet{},
    BaseAttr :: #r_base_attr{},
    FightAttr :: #p_fight_attr{}.
convert_fight_attr_pet(Pet,BaseAttr) ->
    #r_base_attr{power = Power, magic = Magic, body = Body, spirit = Spirit, agile = _Agile} = BaseAttr,
    #r_pet{inborn=Inborn,level=Level,
           hp_aptitude=HpAptitude,
           mp_aptitude=MpAptitude,
           phy_attack_aptitude=PhyAttackAptitude,
           magic_attack_aptitude=MagicAttackAptitude,
           phy_defence_aptitude=PhyDefenceAptitude,
           magic_defence_aptitude=MagicDefenceAptitude,
           miss_aptitude=_MissAptitude} = Pet,
    CalcInborn = Inborn / 100,
    HP = erlang:trunc(Level * HpAptitude * 0.01 + Body * CalcInborn * 10),
    MP = erlang:trunc(Level * MpAptitude * 0.01 + Magic * CalcInborn * 10),
    PhyAttack = erlang:trunc(Level * PhyAttackAptitude * 0.01 + Power * CalcInborn * 2),
    MagicAttack = erlang:trunc(Level * MagicAttackAptitude * 0.01 + Magic * CalcInborn * 2),
    PhyDefence = erlang:trunc(Level * PhyDefenceAptitude * 0.01 + Body * CalcInborn * 2),
    MagicDefence = erlang:trunc(Level * MagicDefenceAptitude * 0.01 + Spirit * CalcInborn * 2),
    MaxAnger = cfg_common:find(max_anger),
    #p_fight_attr{max_hp=HP,
                  hp=HP,
                  max_mp=MP,
                  mp=MP,
                  max_anger=MaxAnger,
                  anger=0,
                  phy_attack=PhyAttack,
                  magic_attack=MagicAttack,
                  phy_defence=PhyDefence,
                  magic_defence=MagicDefence,
                  hit=0,
                  miss=0,
                  double_attack=0,
                  tough=0,
                  seal=0,
                  anti_seal=0,
                  cure_effect=0,
                  attack_skill=0,
                  phy_defence_skill=0,
                  magic_defence_skill=0,
                  seal_skill=0,
                  move_speed=0}.
    

%% @doc 合并基础属性列表
-spec merge_base_attrlist(BaseAttrList) -> #r_base_attr{} when
    BaseAttrList :: list(#r_base_attr{}).
merge_base_attrlist(BaseAttrList) ->
    do_merge_base_attrlist(BaseAttrList, #r_base_attr{}).

%% @hidden
do_merge_base_attrlist([], InBaseAttr) -> InBaseAttr;
do_merge_base_attrlist([BaseAttr|T], InBaseAttr) ->
    do_merge_base_attrlist(T, merge_base_attr(BaseAttr, InBaseAttr)).

%% @doc 合并基础属性
-spec merge_base_attr(BaseAttr1, BaseAttr2) -> BaseAttr3 when
    BaseAttr1 :: #r_base_attr{}, BaseAttr2 :: #r_base_attr{}, BaseAttr3 :: #r_base_attr{}.
merge_base_attr(#r_base_attr{power = Power1, magic = Magic1, body = Body1, spirit = Spirit1, agile = Agile1},
                #r_base_attr{power = Power2, magic = Magic2, body = Body2, spirit = Spirit2, agile = Agile2}) ->
    #r_base_attr{
        power = Power1 + Power2,
        magic = Magic1 + Magic2,
        body = Body1 + Body2,
        spirit = Spirit1 + Spirit2,
        agile = Agile1 + Agile2
    }.

%% @doc 合并战斗属性列表
-spec merge_fight_attrlist(FightAttrList) -> #p_fight_attr{} when
    FightAttrList :: list(#p_fight_attr{}).
merge_fight_attrlist(FightAttrList) ->
    do_merge_fight_attrlist(FightAttrList, #p_fight_attr{}).

%% @hidden
do_merge_fight_attrlist([], InFightAttr) -> InFightAttr;
do_merge_fight_attrlist([FightAttr|T], InFightAttr) ->
    do_merge_fight_attrlist(T, merge_fight_attr(FightAttr, InFightAttr)).

%% @doc 合并战斗属性
-spec merge_fight_attr(FightAttr1, FightAttr2) -> FightAttr3 when
    FightAttr1 :: #p_fight_attr{}, FightAttr2 :: #p_fight_attr{}, FightAttr3 :: #p_fight_attr{}.
merge_fight_attr(undefined, #p_fight_attr{} = A) -> A;
merge_fight_attr(#p_fight_attr{} = A, undefined) -> A;
merge_fight_attr(#p_fight_attr{max_hp = MaxHp1, max_mp = MaxMp1, max_anger = MaxAnger1, phy_attack = PhyAttack1, magic_attack = MagicAttack1,
                               phy_defence = PhyDefence1, magic_defence = MagicDefence1, hit = Hit1, miss = Miss1, double_attack = DoubleAttack1,
                               tough = Tough1, seal = Seal1, anti_seal = AntiSeal1, cure_effect = CureEffect1, attack_skill = AttackSkill1,
                               phy_defence_skill = PDS1, magic_defence_skill = MDS1, seal_skill = SealSkill1},
                 #p_fight_attr{max_hp = MaxHp2, max_mp = MaxMp2, max_anger = MaxAnger2, phy_attack = PhyAttack2, magic_attack = MagicAttack2,
                               phy_defence = PhyDefence2, magic_defence = MagicDefence2, hit = Hit2, miss = Miss2, double_attack = DoubleAttack2,
                               tough = Tough2, seal = Seal2, anti_seal = AntiSeal2, cure_effect = CureEffect2, attack_skill = AttackSkill2,
                               phy_defence_skill = PDS2, magic_defence_skill = MDS2, seal_skill = SealSkill2}) ->
    #p_fight_attr{
        max_hp = max(0, MaxHp1 + MaxHp2),
        max_mp = max(0, MaxMp1 + MaxMp2),
        max_anger = max(0, MaxAnger1 + MaxAnger2),
        phy_attack = max(0, PhyAttack1 + PhyAttack2),
        magic_attack = max(0, MagicAttack1 + MagicAttack2),
        phy_defence = max(0, PhyDefence1 + PhyDefence2),
        magic_defence = max(0, MagicDefence1 + MagicDefence2),
        hit = max(0, Hit1 + Hit2),
        miss = max(0, Miss1 + Miss2),
        double_attack = max(0, DoubleAttack1 + DoubleAttack2),
        tough = max(0, Tough1 + Tough2),
        seal = max(0, Seal1 + Seal2),
        anti_seal = max(0, AntiSeal1 + AntiSeal2),
        cure_effect = max(0, CureEffect1 + CureEffect2),
        attack_skill = max(0, AttackSkill1 + AttackSkill2),
        phy_defence_skill = max(0, PDS1 + PDS2),
        magic_defence_skill = max(0, MDS1 + MDS2),
        seal_skill = max(0, SealSkill1 + SealSkill2)
    }.

%% @doc 战斗属性放大
-spec expand_fight_attr(FightAttr, Coef) -> ExpandFightAttr when
    FightAttr :: #p_fight_attr{}, Coef :: number(), ExpandFightAttr :: #p_fight_attr{}.
expand_fight_attr(#p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger, phy_attack = PhyAttack, magic_attack = MagicAttack,
                                phy_defence = PhyDefence, magic_defence = MagicDefence, hit = Hit, miss = Miss, double_attack = DoubleAttack,
                                tough = Tough, seal = Seal, anti_seal = AntiSeal, cure_effect = CureEffect, attack_skill = AttackSkill,
                                phy_defence_skill = PDS, magic_defence_skill = MDS, seal_skill = SealSkill}, Coef) ->
    #p_fight_attr{
        max_hp = MaxHp * Coef,
        max_mp = MaxMp * Coef,
        max_anger = MaxAnger * Coef,
        phy_attack = PhyAttack * Coef,
        magic_attack = MagicAttack * Coef,
        phy_defence = PhyDefence * Coef,
        magic_defence = MagicDefence * Coef,
        hit = Hit * Coef,
        miss = Miss * Coef,
        double_attack = DoubleAttack * Coef,
        tough = Tough * Coef,
        seal = Seal * Coef,
        anti_seal = AntiSeal * Coef,
        cure_effect = CureEffect * Coef,
        attack_skill = AttackSkill * Coef,
        phy_defence_skill = PDS * Coef,
        magic_defence_skill = MDS * Coef,
        seal_skill = SealSkill * Coef
    }.

%% @doc 战斗属性取整
-spec trunc(FightAttr) -> TruncFightAttr when
    FightAttr :: #p_fight_attr{}, TruncFightAttr :: #p_fight_attr{}.
trunc(#p_fight_attr{max_hp = MaxHp, max_mp = MaxMp, max_anger = MaxAnger, phy_attack = PhyAttack, magic_attack = MagicAttack,
                    phy_defence = PhyDefence, magic_defence = MagicDefence, hit = Hit, miss = Miss, double_attack = DoubleAttack,
                    tough = Tough, seal = Seal, anti_seal = AntiSeal, cure_effect = CureEffect, attack_skill = AttackSkill,
                    phy_defence_skill = PDS, magic_defence_skill = MDS, seal_skill = SealSkill}) ->
    #p_fight_attr{
        max_hp = erlang:trunc(MaxHp),
        max_mp = erlang:trunc(MaxMp),
        max_anger = erlang:trunc(MaxAnger),
        phy_attack = erlang:trunc(PhyAttack),
        magic_attack = erlang:trunc(MagicAttack),
        phy_defence = erlang:trunc(PhyDefence),
        magic_defence = erlang:trunc(MagicDefence),
        hit = erlang:trunc(Hit),
        miss = erlang:trunc(Miss),
        double_attack = erlang:trunc(DoubleAttack),
        tough = erlang:trunc(Tough),
        seal = erlang:trunc(Seal),
        anti_seal = erlang:trunc(AntiSeal),
        cure_effect = erlang:trunc(CureEffect),
        attack_skill = erlang:trunc(AttackSkill),
        phy_defence_skill = erlang:trunc(PDS),
        magic_defence_skill = erlang:trunc(MDS),
        seal_skill = erlang:trunc(SealSkill)
    }.

%% @doc 属性KV 列表转换为结构
-spec kvlist_to_attr(KvList :: list({K::integer(), V::integer()})) -> {#r_base_attr{}, #p_fight_attr{}}.
kvlist_to_attr(KvList) ->
    kvlist_to_attr(KvList, #r_base_attr{}, #p_fight_attr{}).

kvlist_to_attr([], BaseAttr, FightAttr) -> {BaseAttr, FightAttr};
%% 一级属性
kvlist_to_attr([{?ATTR_POWER, V1}|T], BaseAttr = #r_base_attr{power = V2}, FightAttr) -> %% 力量
    kvlist_to_attr(T, BaseAttr#r_base_attr{power = V1 + V2}, FightAttr);
kvlist_to_attr([{?ATTR_MAGIC, V1}|T], BaseAttr = #r_base_attr{magic = V2}, FightAttr) -> %% 魔力
    kvlist_to_attr(T, BaseAttr#r_base_attr{magic = V1 + V2}, FightAttr);
kvlist_to_attr([{?ATTR_BODY, V1}|T], BaseAttr = #r_base_attr{body = V2}, FightAttr) -> %% 体质
    kvlist_to_attr(T, BaseAttr#r_base_attr{body = V1 + V2}, FightAttr);
kvlist_to_attr([{?ATTR_SPIRIT, V1}|T], BaseAttr = #r_base_attr{spirit = V2}, FightAttr) -> %% 念力
    kvlist_to_attr(T, BaseAttr#r_base_attr{spirit = V1 + V2}, FightAttr);
kvlist_to_attr([{?ATTR_AGILE, V1}|T], BaseAttr = #r_base_attr{agile = V2}, FightAttr) -> %% 敏捷
    kvlist_to_attr(T, BaseAttr#r_base_attr{agile = V1 + V2}, FightAttr);
%% 二级属性
kvlist_to_attr([{?ATTR_MAX_HP, V1}|T], BaseAttr, FightAttr = #p_fight_attr{max_hp = V2}) -> %%最大生命上限
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{max_hp = V1 + V2});
kvlist_to_attr([{?ATTR_MAX_MP, V1}|T], BaseAttr, FightAttr = #p_fight_attr{max_mp = V2}) -> %%最大魔法上限
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{max_mp = V1 + V2});
kvlist_to_attr([{?ATTR_MAX_ANGER, V1}|T], BaseAttr, FightAttr = #p_fight_attr{max_anger = V2}) -> %%最大怒气
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{max_anger = V1 + V2});
kvlist_to_attr([{?ATTR_PHY_ATTACK, V1}|T], BaseAttr, FightAttr = #p_fight_attr{phy_attack = V2}) -> %%物理攻击力
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{phy_attack = V1 + V2});
kvlist_to_attr([{?ATTR_MAGIC_ATTACK, V1}|T], BaseAttr, FightAttr = #p_fight_attr{magic_attack = V2}) -> %%魔法攻击力
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{magic_attack = V1 + V2});
kvlist_to_attr([{?ATTR_PHY_DEFENCE, V1}|T], BaseAttr, FightAttr = #p_fight_attr{phy_defence = V2}) -> %%物理防御
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{phy_defence = V1 + V2});
kvlist_to_attr([{?ATTR_MAGIC_DEFENCE, V1}|T], BaseAttr, FightAttr = #p_fight_attr{magic_defence = V2}) ->  %%魔法防御
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{magic_defence = V1 + V2});
kvlist_to_attr([{?ATTR_HIT, V1}|T], BaseAttr, FightAttr = #p_fight_attr{hit = V2}) -> %%命中
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{hit = V1 + V2});
kvlist_to_attr([{?ATTR_MISS, V1}|T], BaseAttr, FightAttr = #p_fight_attr{miss = V2}) -> %%闪避
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{miss = V1 + V2});
kvlist_to_attr([{?ATTR_DOUBLE_ATTACK, V1}|T], BaseAttr, FightAttr = #p_fight_attr{double_attack = V2}) -> %%暴击
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{double_attack = V1 + V2});
kvlist_to_attr([{?ATTR_TOUGH, V1}|T], BaseAttr, FightAttr = #p_fight_attr{tough = V2}) -> %%坚韧
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{tough = V1 + V2});
kvlist_to_attr([{?ATTR_SEAL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{seal = V2}) -> %%封印
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{seal = V1 + V2});
kvlist_to_attr([{?ATTR_ANTI_SEAL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{anti_seal = V2}) -> %%抗封
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{anti_seal = V1 + V2});
kvlist_to_attr([{?ATTR_CURE_EFFECT, V1}|T], BaseAttr, FightAttr = #p_fight_attr{cure_effect = V2}) -> %%治疗强度
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{cure_effect = V1 + V2});
kvlist_to_attr([{?ATTR_ATTACK_SKILL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{attack_skill = V2}) -> %%物法修炼，功击修炼
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{attack_skill = V1 + V2});
kvlist_to_attr([{?ATTR_PHY_DEFENCE_SKILL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{phy_defence_skill = V2}) -> %%物防修炼
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{phy_defence_skill = V1 + V2});
kvlist_to_attr([{?ATTR_MAGIC_DEFENCE_SKILL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{magic_defence_skill = V2}) -> %%魔防修炼
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{magic_defence_skill = V1 + V2});
kvlist_to_attr([{?ATTR_SEAL_SKILL, V1}|T], BaseAttr, FightAttr = #p_fight_attr{seal_skill = V2}) -> %%抗封修炼
    kvlist_to_attr(T, BaseAttr, FightAttr#p_fight_attr{seal_skill = V1 + V2});
%% 容错
kvlist_to_attr([_Other|T], BaseAttr, FightAttr) ->
    ?ERROR_MSG("unknown attr:~w",[_Other]),
    kvlist_to_attr(T, BaseAttr, FightAttr).

