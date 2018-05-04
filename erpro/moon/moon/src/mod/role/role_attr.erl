%%----------------------------------------------------
%% 升级数值属性
%% 
%% @author wpf(wpf0208@jieyou,cn)
%%----------------------------------------------------

-module(role_attr).
-export([
        calc_attr/1
        ,calc_attr_registered/1
        ,base_calc/1
        ,attr_ratio_add/1
        ,attr_trans_add/1
        ,trunc_attr/1
        ,do_attr/2

        ,get_hp_mp/4
        ,check_hp_mp/4
        ,trans_atrrs/1
        ,ver_parse/1

        ,push/2
    ]).

-include("common.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("ratio.hrl").
-include("pet.hrl").
-include("link.hrl").

-define(DEF_SPEED, 336).

%% @spec ver_parse(OldAttr) -> #attr{}
%% @doc属性版本转换
ver_parse({attr, Dmg_magic ,Dmg_ratio ,Def_magic ,Escape_rate ,Anti_escape ,Hit_ratio ,Injure_ratio ,Fight_capacity ,Js ,Aspd ,Dmg_min ,Dmg_max ,Defence ,Hitrate ,Evasion ,Critrate ,Tenacity ,Anti_attack ,Anti_stun ,Anti_taunt ,Anti_silent ,Anti_sleep ,Anti_stone ,Anti_poison ,Anti_seal ,Resist_metal ,Resist_wood ,Resist_water ,Resist_fire ,Resist_earth ,Dmg_wuxing ,Asb_metal ,Asb_wood ,Asb_water ,Asb_fire ,Asb_earth}) ->
    Ver = 1, %% 加入第一个版本号
    ver_parse({attr, Ver, Dmg_magic ,Dmg_ratio ,Def_magic ,Escape_rate ,Anti_escape ,Hit_ratio ,Injure_ratio ,Fight_capacity ,Js ,Aspd ,Dmg_min ,Dmg_max ,Defence ,Hitrate ,Evasion ,Critrate ,Tenacity ,Anti_attack ,Anti_stun ,Anti_taunt ,Anti_silent ,Anti_sleep ,Anti_stone ,Anti_poison ,Anti_seal ,Resist_metal ,Resist_wood ,Resist_water ,Resist_fire ,Resist_earth ,Dmg_wuxing ,Asb_metal ,Asb_wood ,Asb_water ,Asb_fire ,Asb_earth, 0, 0, 0, 0, 0, 0, 0});
ver_parse({attr, Dmg_magic ,Dmg_ratio ,Def_magic ,Escape_rate ,Anti_escape ,Hit_ratio ,Injure_ratio ,Fight_capacity ,Js ,Aspd ,Dmg_min ,Dmg_max ,Defence ,Hitrate ,Evasion ,Critrate ,Tenacity ,Anti_attack ,Anti_stun ,Anti_taunt ,Anti_silent ,Anti_sleep ,Anti_stone ,Anti_poison ,Anti_seal ,Resist_metal ,Resist_wood ,Resist_water ,Resist_fire ,Resist_earth ,Dmg_wuxing ,Asb_metal ,Asb_wood ,Asb_water ,Asb_fire ,Asb_earth, Enhance_stun,Enhance_taunt ,Enhance_silent ,Enhance_sleep ,Enhance_stone ,Enhance_poison ,Enhance_seal}) ->
    Ver = 1, %% 加入第一个版本号(针对发布服某个错误版本)
    ver_parse({attr, Ver, Dmg_magic ,Dmg_ratio ,Def_magic ,Escape_rate ,Anti_escape ,Hit_ratio ,Injure_ratio ,Fight_capacity ,Js ,Aspd ,Dmg_min ,Dmg_max ,Defence ,Hitrate ,Evasion ,Critrate ,Tenacity ,Anti_attack ,Anti_stun ,Anti_taunt ,Anti_silent ,Anti_sleep ,Anti_stone ,Anti_poison ,Anti_seal ,Resist_metal ,Resist_wood ,Resist_water ,Resist_fire ,Resist_earth ,Dmg_wuxing ,Asb_metal ,Asb_wood ,Asb_water ,Asb_fire ,Asb_earth, Enhance_stun,Enhance_taunt ,Enhance_silent ,Enhance_sleep ,Enhance_stone ,Enhance_poison ,Enhance_seal});
ver_parse(Attr = #attr{ver = ?attr_ver}) ->
    Attr.

%% @spec check_hp_mp(HpMax, MpMax, HpMax, MpMax) -> {Hp, Mp}
%% @doc 检查血和法力
check_hp_mp(HpMax, MpMax, HpMax, MpMax) ->
    {HpMax, MpMax};
check_hp_mp(Hp, Mp, HpMax, MpMax) ->
    {case Hp > HpMax of
        true -> HpMax;
        false -> Hp
    end,
    case Mp > MpMax of
        true -> MpMax;
        false -> Mp
    end}.

%% @spec calc_attr_registered(Role) -> NewRole
%% @doc 角色第一次注册后登陆计算
calc_attr_registered(Role = #role{lev = 0, pet = PetBag}) -> %% 注册后第一次登陆计算，血量值等于最大值
    Role0 = Role#role{lev = 1},
    ?DEBUG("初始角色[NAME:~s]计算前血量~w，法力~w， 速度:~w", [Role#role.name, Role#role.hp, Role#role.mp, Role#role.speed]),
    {BaseHpMax, BaseMpMax, BaseAttr} = role_attr:base_calc(Role0),
    RoleBase = Role0#role{
        hp_max = BaseHpMax, mp_max = BaseMpMax, speed = ?DEF_SPEED, attr = BaseAttr,
        ratio = #ratio{},
        pet = PetBag#pet_bag{exp_time = 100},
        hp = BaseHpMax, mp = BaseMpMax
    },
    RoleBase;
%    Role1 = apply_chain(RoleBase, [
%        fun eqm:calc/1,
%        fun buff:calc_ratio/1,
%        fun vip:calc_ratio/1,
%        fun skill:calc/1,
%        fun pet:calc/1,
%        fun channel:calc/1,
%        % fun achievement:calc/1,
%        fun medal:calc/1,
%        %% ----------------------------------
%        %% 结算加成比率
%        fun role_attr:attr_trans_add/1,
%        fun role_attr:attr_ratio_add/1
%    ]),
%    %% ----------------------------------
%    %% 额外属性附加
%    Role2 = apply_chain(Role1, [
%        fun eqm:calc_mount/1,
%        fun eqm:calc_embed/1,
%        fun world_compete_medal:calc/1,
% %%       fun eqm:calc_gs/1,
% %%       fun eqm:calc_fumo/1,
%        fun demon_api:calc/1
%    ]),
%    %% ----------------------------------
%    Role3 = buff:calc(Role2), %% （战力计算需剔除）
%    Role4 = #role{hp_max = HpMax, mp_max = MpMax} = role_attr:trunc_attr(Role3),
%    NewRole = eqm_api:calc_fight_capacity(Role4, Role2, Role1),%%(当前Role, 计算额外属性后的Role, 计算额外属性前的Role)
%    ?DEBUG("初始角色[NAME:~s]计算后血量~w，法力~w，速度:~w, 气血上限:~w, 法力上限:~w", [NewRole#role.name, NewRole#role.hp, NewRole#role.mp, NewRole#role.speed, NewRole#role.hp_max, NewRole#role.mp_max]),
%    NewRole#role{hp = HpMax, mp = MpMax};
calc_attr_registered(Role) -> Role.

%% @spec calc_attr(Role) -> NewRole
%% Role = tuple()
%% @doc 重新计算角色属性: 只根据等级和职业，包括基本属性和比率加成全部清空重新计算
calc_attr(Role = #role{hp = Hp}) when Hp < 0 ->
    calc_attr(Role#role{hp = 0});
calc_attr(Role = #role{mp = Mp}) when Mp < 0 ->
    calc_attr(Role#role{mp = 0});
calc_attr(Role = #role{hp = Hp, mp = Mp, hp_max = 1, mp_max = 1, pet = PetBag}) -> %% 登陆计算，血量法力按照保存值
    {BaseHpMax, BaseMpMax, BaseAttr} = role_attr:base_calc(Role),
    RoleBase = Role#role{
        hp_max = BaseHpMax, mp_max = BaseMpMax, speed = ?DEF_SPEED, attr = BaseAttr,
        ratio = #ratio{},
        pet = PetBag#pet_bag{exp_time = 100}
    },
    Role1 = apply_chain(RoleBase, [
        fun eqm:calc/1,
        fun dress:calc_attr/1,
        fun manor:calc/1,   %% 庄园魔药属性
        fun buff:calc_ratio/1,
        fun vip:calc_ratio/1,
        fun skill:calc/1,
        % fun pet:calc/1,
        fun channel:calc/1,
        % fun achievement:calc/1,
        fun medal:calc/1,
        fun medal_compete:calc/1,
        %% ----------------------------------
        %% 结算加成比率
        fun role_attr:attr_trans_add/1,
        fun role_attr:attr_ratio_add/1
    ]),
    %% ----------------------------------
    %% 额外属性附加
    Role2 = apply_chain(Role1, [
        fun eqm:calc_mount/1,
        fun eqm:calc_embed/1,
        fun world_compete_medal:calc/1,
        fun soul_world:calc/1,
        fun ascend:calc/1,
        fun item:calc_field_guide/1,
        fun demon_api:calc/1
    ]),
    %% ----------------------------------
    Role3 = buff:calc(Role2), %% BUFF属性相关附加（战力计算需剔除）
    Role4  = #role{hp_max = HpMax, mp_max = MpMax} = role_attr:trunc_attr(Role3),
    NewRole = eqm_api:calc_fight_capacity(Role4, Role2, Role1),%%(当前Role, 计算额外属性后的Role, 计算额外属性前的Role)
    {NewHp, NewMp} = check_hp_mp(Hp, Mp, HpMax, MpMax), %% 校验
    %% 计算气血包
    NRole = buff_effect:use_pool(NewRole#role{hp = NewHp, mp = NewMp}),
    %% ?DEBUG("角色[NAME:~s]登陆计算后血量~w，法力~w，速度:~w: 气血上限:~w 法力上限:~w", [NewRole#role.name, NRole#role.hp, NRole#role.mp, NRole#role.speed, NRole#role.hp_max, NRole#role.mp_max]),
    NRole;

%% 计算不在线玩家属性
calc_attr(Role = #role{pid = undefined, link = undefined, hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, pet = PetBag}) ->
    HpPer = Hp / HpMax,
    MpPer = Mp / MpMax,
    ?DEBUG("角色[NAME:~s]计算前血量~w，法力~w， 速度:~w", [Role#role.name, Hp, Mp, Role#role.speed]),
    {BaseHpMax, BaseMpMax, BaseAttr} = role_attr:base_calc(Role),
    RoleBase = Role#role{
        hp_max = BaseHpMax, mp_max = BaseMpMax, speed = ?DEF_SPEED, attr = BaseAttr,
        ratio = #ratio{},
        pet = PetBag#pet_bag{exp_time = 100}
    },
    Role1 = apply_chain(RoleBase, [
        fun eqm:calc/1,
        fun dress:calc_attr/1,
        fun manor:calc/1,   %% 庄园魔药属性
        fun buff:calc_ratio/1,
        fun vip:calc_ratio/1,
        fun skill:calc/1,
        %% fun pet:calc/1,
        fun channel:calc/1,
        % fun achievement:calc/1,
        fun medal:calc/1,
        fun medal_compete:calc/1,
        %% ----------------------------------
        fun role_attr:attr_trans_add/1,
        fun role_attr:attr_ratio_add/1
    ]),
    %% ----------------------------------
    %% 额外属性附加
    Role2 = apply_chain(Role1, [
        fun eqm:calc_mount/1,
        fun eqm:calc_embed/1,
%%        fun world_compete_medal:calc/1,
%%        fun eqm:calc_gs/1,
%%        fun eqm:calc_fumo/1,
        fun soul_world:calc/1,
        fun ascend:calc/1,
        fun item:calc_field_guide/1
%%        fun demon_api:calc/1,
%%        fun suit_collect:calc_attrs/1
    ]),
    %% ----------------------------------
    Role3 = buff:calc(Role2), %% BUFF属性相关附加（战力计算需剔除）
    Role4  = #role{hp_max = TmpHpMax, mp_max = TmpMpMax} = role_attr:trunc_attr(Role3),
    Role5 = eqm_api:calc_fight_capacity(Role4, Role2, Role1),%%(当前Role, 计算额外属性后的Role, 计算额外属性前的Role)
    {TmpHp, TmpMp} = get_hp_mp(HpPer, MpPer, TmpHpMax, TmpMpMax), %% 百分比修正
    {NewHp, NewMp} = check_hp_mp(TmpHp, TmpMp,TmpHpMax, TmpMpMax), %% 校验
    Role6 = buff_effect:use_pool(Role5#role{hp = NewHp, mp = NewMp}),
    Role6;



calc_attr(Role = #role{hp = Hp, mp = Mp, hp_max = HpMax, mp_max = MpMax, pet = PetBag}) ->
    HpPer = Hp / HpMax,
    MpPer = Mp / MpMax,

    {BaseHpMax, BaseMpMax, BaseAttr} = role_attr:base_calc(Role),
    RoleBase = Role#role{
        hp_max = BaseHpMax, mp_max = BaseMpMax, speed = ?DEF_SPEED, attr = BaseAttr,
        ratio = #ratio{},
        pet = PetBag#pet_bag{exp_time = 100}
    },

    Role1 = apply_chain(RoleBase, [
        fun eqm:calc/1,
        fun dress:calc_attr/1,
        fun manor:calc/1,   %% 庄园魔药属性
        fun buff:calc_ratio/1,
        fun vip:calc_ratio/1,
        fun skill:calc/1,
        fun pet:calc/1,
        fun channel:calc/1,
        % fun achievement:calc/1,
        fun medal:calc/1,
        fun medal_compete:calc/1,
        %% ----------------------------------
        fun role_attr:attr_trans_add/1,
        fun role_attr:attr_ratio_add/1
    ]),
    %% ----------------------------------
    %% 额外属性附加
    Role2 = apply_chain(Role1, [
        fun eqm:calc_mount/1,
        fun eqm:calc_embed/1,
%%        fun eqm:calc_gs/1,
%%        fun eqm:calc_fumo/1,
        fun soul_world:calc/1,
        fun ascend:calc/1,
        fun item:calc_field_guide/1,
        fun demon_api:calc/1,
        fun suit_collect:calc_attrs/1
    ]),
    %% ----------------------------------
    Role3 = buff:calc(Role2), %% BUFF属性相关附加（战力计算需剔除）
    Role4  = #role{hp_max = TmpHpMax, mp_max = TmpMpMax} = role_attr:trunc_attr(Role3),
    NewRole = eqm_api:calc_fight_capacity(Role4, Role2, Role1),%%(当前Role, 计算额外属性后的Role, 计算额外属性前的Role)
    {TmpHp, TmpMp} = get_hp_mp(HpPer, MpPer, TmpHpMax, TmpMpMax), %% 百分比修正
    {NewHp, NewMp} = check_hp_mp(TmpHp, TmpMp,TmpHpMax, TmpMpMax), %% 校验
    %% ?DEBUG("角色[NAME:~s]计算后血量~w，法力~w，速度:~w", [NewRole#role.name, NewHp, NewMp, NewRole#role.speed]),
    
    %% 气血上限变化监听 N当前气血上限
    %% NewRole1 = #role{attr = Attr} = role_listener:special_event(NewRole, {20007, NewRole#role.hp_max}),
    %% 功击力变化监听 N当前功击
    %% NewRole2 = role_listener:special_event(NewRole1, {20008, Attr#attr.dmg_max}),
    %% 计算气血包
    NRole = buff_effect:use_pool(NewRole#role{hp = NewHp, mp = NewMp}),
    NRole.

%% @spec base_calc(Role) -> Attr
%% @doc 计算基础属性值
base_calc(_Role = #role{career = Career, lev = Lev}) 
when Career >= 1 andalso Career =< 6 andalso Lev > 0 ->
    #attr_base{
        hp_max = Bhp, mp_max = Bmp, js = Bjs, dmg_min = Bdmin, dmg_max = Bdmax, aspd = Baspd,
        defence = Bdef, hitrate = Bhit, critrate = Bcrit, evasion = Beva, resist_metal = Brm,
        resist_wood = Brw, resist_water = Brwa, resist_fire = Brf, resist_earth = Bre,
        anti_stun = Bastu, anti_poison = BaPo, anti_sleep = Basl, anti_stone = Basto, anti_taunt = Bat
    } = role_attr_data:get_attr_base(Career),
    #attr_grow{hp_max = Ghp, mp_max = Gmp, js = Gjs, dmg = Gdmg, defence = Gdef, hitrate = Ghit,
        critrate = Gcrit, evasion = Geva, resist_all = ResistAll
    } = role_attr_data:get_attr_grow(Career),
    {
        Bhp + Ghp * Lev %% 血量上限基本值
        ,Bmp + Gmp * Lev %% 法力上限基本值
        ,#attr{
            js = Bjs + Gjs * Lev
            ,dmg_min = Bdmin + Gdmg * Lev %% 最小攻击
            ,dmg_max = Bdmax + Gdmg * Lev %% 最大攻击
            ,defence = Bdef + Gdef * Lev %% 防御值
            ,hitrate = Bhit + Ghit * Lev
            ,critrate = Bcrit + Gcrit * Lev
            ,evasion = Beva + Geva * Lev
            ,aspd = Baspd %% 攻击速度
            
            ,resist_metal = Brm+ResistAll   %% 金抗性
            ,resist_wood = Brw+ResistAll   %% 木抗性
            ,resist_water = Brwa+ResistAll  %% 水抗性
            ,resist_fire = Brf+ResistAll   %% 火抗性
            ,resist_earth = Bre+ResistAll   %% 土抗性
            ,dmg_wuxing = 0     %% 五行攻击，由职业决定

            ,anti_stun = Bastu
            ,anti_sleep = Basl
            ,anti_stone = Basto
            ,anti_taunt = Bat
            ,anti_poison = BaPo
     }}.

%% @spec attr_trans_add(Role) -> NewRole
%% @doc 合并转换属性(一级属性转换加成)
attr_trans_add(Role = #role{career = Career, attr = #attr{js = Js}}) ->
    AttrCvt = role_attr_data:get_attr_cvt(Career),
    attr_trans_add(Js, AttrCvt, Role).
attr_trans_add(Js, #attr_convert{js_mp = Chm}, Role = #role{mp_max = MpMax}) ->
    AddMp = Js * Chm,   %% 精神---转法力
    Role#role{
        mp_max = MpMax + AddMp
    };
attr_trans_add(_Js, _, Role) ->
    Role.

%% @spec attr_ratio_add(Role) -> NewRole
%% @doc 根据数值加成比率计算属性加成
%% 合并加成属性 #ratio{}中保存的是（1 + 加成比率）*100的值
attr_ratio_add(Role = #role{
        hp_max = HpMax,
        mp_max = MpMax,
        speed = Speed,
        attr = Attr = #attr{
            js = Js
            ,dmg_min = DmgMin, dmg_max = DmgMax, defence = Defence
            ,hitrate = Hit, evasion = Eva, critrate = Crit, tenacity = Tena
            ,resist_metal = RstMetal
            ,resist_wood = RstWood
            ,resist_water = RstWater
            ,resist_fire = RstFire
            ,resist_earth = RstEarth
        },
        ratio = #ratio{
            hp_max = Rhp, mp_max = Rmp, dmg = Rdmg, defence = Rdef,
            js = Rjs, speed = Rspeed, tenacity = RTena,
            hitrate = Rhit, evasion = Reva, critrate = Rcrit,
            resist_metal = Rrstmetal, resist_wood = Rrstwood,
            resist_water = Rrstwater, resist_fire = Rrstfire,
            resist_earth = Rrstearth}
    }) ->
    Role#role{
        hp_max = HpMax * Rhp / 100
        ,mp_max = MpMax * Rmp / 100
        ,speed = Speed * Rspeed / 100
        ,attr = Attr#attr{
            js = Js * Rjs / 100
            ,dmg_min = DmgMin * Rdmg / 100
            ,dmg_max = DmgMax * Rdmg / 100
            ,defence = Defence * Rdef / 100
            ,critrate = Crit * Rcrit / 100
            ,hitrate = Hit * Rhit / 100
            ,evasion = Eva * Reva / 100
            ,tenacity = Tena * RTena /100
            ,resist_metal = RstMetal * Rrstmetal / 100
            ,resist_wood = RstWood * Rrstwood / 100
            ,resist_water = RstWater * Rrstwater / 100
            ,resist_fire = RstFire * Rrstfire / 100
            ,resist_earth = RstEarth * Rrstearth / 100
        }}.

%% 对角色属性进行取整操作
trunc_attr(Role = #role{hp_max = HpMax, mp_max = MpMax, speed = Speed, attr = Attr}) ->
    #attr{js = Js, aspd = Aspd, dmg_magic = DmgMag, dmg_min = DmgMin, dmg_max = DmgMax, defence = Def, hitrate = Hit,
        critrate = Crit, evasion = Eva, tenacity = Tena,
        resist_metal = RM, resist_wood = RWo, resist_water = RWa,
        resist_fire = RF, resist_earth = RE, dmg_wuxing = DmgWx,
        anti_stun = Astu, anti_silent = Asi, anti_sleep = Asl,
        anti_stone = Asto, anti_taunt = At, anti_poison = Ap, anti_seal = As
    } = Attr,
    Role#role{
        hp_max = erlang:round(HpMax),
        mp_max = erlang:round(MpMax),
        speed = erlang:round(Speed),
        attr = Attr#attr{
            js = erlang:round(Js)
            ,aspd = erlang:round(Aspd)
            ,dmg_magic = erlang:round(DmgMag)
            ,dmg_min = erlang:round(DmgMin)
            ,dmg_max = erlang:round(DmgMax)
            ,defence = erlang:round(Def)
            ,hitrate = erlang:round(Hit)
            ,critrate = erlang:round(Crit)
            ,evasion = erlang:round(Eva)
            ,tenacity = erlang:round(Tena)
            ,resist_metal = erlang:round(RM)
            ,resist_wood = erlang:round(RWo)
            ,resist_water = erlang:round(RWa)
            ,resist_fire = erlang:round(RF)
            ,resist_earth = erlang:round(RE)
            ,dmg_wuxing = erlang:round(DmgWx)
            ,anti_stun = erlang:round(Astu)      %% 抗晕
            ,anti_taunt = erlang:round(At)     %% 抗嘲讽
            ,anti_silent = erlang:round(Asi)    %% 抗沉默/遗忘
            ,anti_sleep = erlang:round(Asl)     %% 抗睡眠
            ,anti_stone = erlang:round(Asto)     %% 抗石化
            ,anti_poison = erlang:round(Ap)    %% 抗毒
            ,anti_seal = erlang:round(As)      %% 抗封印
        }}.

%% *******************************
%% 以下是属性一层计算
%% 属性计算
do_attr([], Role) -> {ok, Role};
do_attr([H | T], Role) ->
    case do(H, Role) of
        {ok, NewRole} -> do_attr(T, NewRole);
        skip -> do_attr(T, Role);
        {false, Reason} -> {false, Reason}
    end.

%% 增加气血上限
do({hp_max, Val},  Role = #role{hp_max = V}) ->
    {ok, Role#role{hp_max = V + Val}};

%% 增加法术上限
do({mp_max, Val},  Role = #role{mp_max = V}) ->
    {ok, Role#role{mp_max = V + Val}};

%% 增加精神
do({js, Val},  Role = #role{attr = Attr = #attr{js = V}}) ->
    {ok, Role#role{attr = Attr#attr{js = V + Val}}};

%% 增加攻击力
do({dmg, Val},  Role = #role{attr = Attr = #attr{dmg_min = Min, dmg_max = Max}}) ->
    {ok, Role#role{attr = Attr#attr{dmg_min = Val + Min, dmg_max = Val + Max}}};

%% 增加防御
do({defence, Val}, Role = #role{attr = Attr = #attr{defence = V}}) ->
    {ok, Role#role{attr = Attr#attr{defence = Val + V}}};

%% 增加闪躲
do({evasion, Val}, Role = #role{attr = Attr = #attr{evasion = V}}) ->
    {ok, Role#role{attr = Attr#attr{evasion = Val + V}}};

%% 增加暴击
do({critrate, Val}, Role = #role{attr = Attr = #attr{critrate = V}}) ->
    {ok, Role#role{attr = Attr#attr{critrate = Val + V}}};

%% 增加命中
do({hitrate, Val}, Role = #role{attr = Attr = #attr{hitrate = V}}) ->
    {ok, Role#role{attr = Attr#attr{hitrate = Val + V}}};

%% 增加坚韧
do({tenacity, Val}, Role = #role{attr = Attr = #attr{tenacity = V}}) ->
    {ok, Role#role{attr = Attr#attr{tenacity = Val + V}}};

%% 增加敏捷
do({aspd, Val}, Role = #role{attr = Attr = #attr{aspd = V}}) ->
    {ok, Role#role{attr = Attr#attr{aspd = Val + V}}};

%% 增加反击率
do({anti_attack, Val}, Role = #role{attr = Attr = #attr{anti_attack = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_attack = Val + V}}};

%% 增加法术伤害
do({dmg_magic, Val}, Role = #role{attr = Attr = #attr{dmg_magic = V}}) ->
    {ok, Role#role{attr = Attr#attr{dmg_magic = Val + V}}};

%% 增加抗眩晕、抗睡眠、抗嘲讽、抗遗忘、抗石化、抗中毒、抗封印
do({anti_stun, Val}, Role = #role{attr = Attr = #attr{anti_stun = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_stun = Val + V}}};
do({anti_sleep, Val}, Role = #role{attr = Attr = #attr{anti_sleep = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_sleep = Val + V}}};
do({anti_taunt, Val}, Role = #role{attr = Attr = #attr{anti_taunt = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_taunt = Val + V}}};
do({anti_silent, Val}, Role = #role{attr = Attr = #attr{anti_silent = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_silent = Val + V}}};
do({anti_stone, Val}, Role = #role{attr = Attr = #attr{anti_stone = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_stone = Val + V}}};
do({anti_poison, Val}, Role = #role{attr = Attr = #attr{anti_poison = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_poison = Val + V}}};
do({anti_seal, Val}, Role = #role{attr = Attr = #attr{anti_seal = V}}) ->
    {ok, Role#role{attr = Attr#attr{anti_seal = Val + V}}};

%% 控制加强
do({enhance_stun, Val}, Role = #role{attr = Attr = #attr{enhance_stun = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_stun = Val + V}}};
do({enhance_sleep, Val}, Role = #role{attr = Attr = #attr{enhance_sleep = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_sleep = Val + V}}};
do({enhance_taunt, Val}, Role = #role{attr = Attr = #attr{enhance_taunt = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_taunt = Val + V}}};
do({enhance_silent, Val}, Role = #role{attr = Attr = #attr{enhance_silent = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_silent = Val + V}}};
do({enhance_stone, Val}, Role = #role{attr = Attr = #attr{enhance_stone = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_stone = Val + V}}};
do({enhance_poison, Val}, Role = #role{attr = Attr = #attr{enhance_poison = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_poison = Val + V}}};
do({enhance_seal, Val}, Role = #role{attr = Attr = #attr{enhance_seal = V}}) ->
    {ok, Role#role{attr = Attr#attr{enhance_seal = Val + V}}};

%% 增加抗性
do({resist_metal, Val}, Role = #role{attr = Attr = #attr{resist_metal = V}}) ->
    {ok, Role#role{attr = Attr#attr{resist_metal = Val + V}}};
do({resist_wood, Val}, Role = #role{attr = Attr = #attr{resist_wood = V}}) ->
    {ok, Role#role{attr = Attr#attr{resist_wood = Val + V}}};
do({resist_water, Val}, Role = #role{attr = Attr = #attr{resist_water = V}}) ->
    {ok, Role#role{attr = Attr#attr{resist_water = Val + V}}};
do({resist_fire, Val}, Role = #role{attr = Attr = #attr{resist_fire = V}}) ->
    {ok, Role#role{attr = Attr#attr{resist_fire = Val + V}}};
do({resist_earth, Val}, Role = #role{attr = Attr = #attr{resist_earth = V}}) ->
    {ok, Role#role{attr = Attr#attr{resist_earth = Val + V}}};
%% 增加全抗性
do({resist_all, Val}, Role = #role{attr = Attr = #attr{resist_metal = Vm,
            resist_earth = Ve
            ,resist_water = Vw
            ,resist_wood = Vwo
            ,resist_fire = Vf}}) ->
    {ok, Role#role{attr = Attr#attr{resist_metal = Vm + Val
                ,resist_earth = Ve + Val
                ,resist_water = Vw + Val
                ,resist_wood = Vwo + Val
                ,resist_fire = Vf + Val}}};

%% 增加气血上限比
do({hp_max_per, Val},  Role = #role{ratio = Ratio = #ratio{hp_max = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{hp_max = V + Val}}};

%% 增加法力上限比
do({mp_max_per, Val},  Role = #role{ratio = Ratio = #ratio{mp_max = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{mp_max = V + Val}}};

%% 增加精神比
do({js_per, Val}, Role = #role{ratio = Ratio = #ratio{js = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{js = V + Val}}};

%% 增加攻击比
do({dmg_per, Val}, Role = #role{ratio = Ratio = #ratio{dmg = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{dmg = V + Val}}};

%% 增加防御比
do({defence_per, Val}, Role = #role{ratio = Ratio = #ratio{defence = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{defence = V + Val}}};

%% 增加防御比
do({tenacity_per, Val}, Role = #role{ratio = Ratio = #ratio{tenacity = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{tenacity = V + Val}}};

%% 全抗比
do({resist_all_per, Val}, Role = #role{ratio = Ratio = #ratio{
        resist_metal = Vm
        ,resist_wood = Vw
        ,resist_water = Vwa
        ,resist_fire = Vf
        ,resist_earth = Ve
    }}) ->
    {ok, Role#role{ratio = Ratio#ratio{
                resist_metal = Vm + Val
                ,resist_wood = Vw + Val
                ,resist_water = Vwa + Val
                ,resist_fire = Vf + Val
                ,resist_earth = Ve + Val
            }}};

%% 增加抗眩晕
do({anti_stun_per, Val}, Role = #role{attr = Ratio = #ratio{anti_stun = V}}) ->
    {ok, Role#role{ratio = Ratio = #ratio{anti_stun = Val + V}}};
%% 增加抗睡眠
do({anti_sleep_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_sleep = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_sleep = Val + V}}};
%% 增加抗遗忘
do({anti_silent_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_silent = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_silent = Val + V}}};
%% 增加抗石化
do({anti_stone_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_stone = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_stone = Val + V}}};
%% 增加抗嘲讽
do({anti_taunt_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_taunt = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_taunt = Val + V}}};
%% 增加抗中毒
do({anti_poison_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_poison = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_poison = Val + V}}};
%% 增加抗封印
do({anti_seal_per, Val}, Role = #role{ratio = Ratio = #ratio{anti_seal = V}}) ->
    {ok, Role#role{ratio = Ratio#ratio{anti_seal = Val + V}}};

do({_A, _}, _Role) ->
    ?DEBUG("角色[ID:~w]属性计算跳过了一个属性类型：~w", [_Role#role.id, _A]),
    skip;
do(_A, _Role) ->
    {false, ?L(<<"不正确的属性类型">>)}.

%% 转换 数字 label 对应的 原子label 这数字label 在 item.hrl 有定义
trans_atrrs(DigitalLabelsTuples) ->
    trans_atrrs(DigitalLabelsTuples, []).

trans_atrrs([], LT) ->
    LT;
trans_atrrs([H | T], LT) ->
    trans_atrrs(T, [trans_attr(H) | LT]).

trans_attr({14, Val}) -> {js, Val};
trans_attr({15, Val}) -> {hp_max, Val};
trans_attr({16, Val}) -> {mp_max, Val};
trans_attr({17, Val}) -> {aspd, Val};
trans_attr({18, Val}) -> {dmg, Val};
trans_attr({21, Val}) -> {defence, Val};
trans_attr({22, Val}) -> {hitrate, Val};
trans_attr({23, Val}) -> {evasion, Val};
trans_attr({24, Val}) -> {critrate, Val};
trans_attr({25, Val}) -> {tenacity, Val};
trans_attr({29, Val}) -> {dmg_magic, Val};
trans_attr({30, Val}) -> {resist_all, Val};
trans_attr({31, Val}) -> {resist_metal, Val};
trans_attr({32, Val}) -> {resist_wood, Val};
trans_attr({33, Val}) -> {resist_water, Val};
trans_attr({34, Val}) -> {resist_fire, Val};
trans_attr({35, Val}) -> {resist_earth, Val};
trans_attr({60, Val}) -> {anti_stun, Val};
trans_attr({61, Val}) -> {anti_sleep, Val};
trans_attr({62, Val}) -> {anti_taunt, Val};
trans_attr({63, Val}) -> {anti_silent, Val};
trans_attr({64, Val}) -> {anti_stone, Val};
trans_attr({65, Val}) -> {anti_poison, Val};
trans_attr({66, Val}) -> {anti_seal, Val};
trans_attr(DLT) -> DLT.

push(#role{link = #link{conn_pid = ConnPid}}, KeyVals) ->
    push(ConnPid, KeyVals);
push(ConnPid, {Key, Val}) ->
    push(ConnPid, [{Key, Val}]);
push(ConnPid, KeyVals) ->
    Data = [ {attr_name_to_int(Key), Val} || {Key, Val} <- KeyVals],
    sys_conn:pack_send(ConnPid, 10005, Data).


attr_name_to_int(hp) -> 1;
attr_name_to_int(mp) -> 2;
attr_name_to_int(_) -> 0.

%% ------------------------------------
%% 内部函数
%% ------------------------------------

%% 按照百分比获取当前血量和法力值
get_hp_mp(HpPer, MpPer, HpMax, MpMax) ->
    {erlang:round(HpMax * HpPer), erlang:round(MpMax * MpPer)}.

apply_chain(Role, []) ->
    Role;
apply_chain(Role, [Fun|T]) ->
    apply_chain(Fun(Role), T).

%%----------------------------------------------------
%% 单元测试
%%----------------------------------------------------
-ifdef(debug).
-include_lib("eunit/include/eunit.hrl").

base_test_() ->
    %% 属性测试，只等级
    TestRoleAttr = fun() ->
            Role = role_api:role(),
            %% 真武---30级
            %% 基础值
            R0 = Role#role{
                career = ?career_zhenwu,
                lev = 30,
                hp = 1600, mp = 200,
                ratio = #ratio{hp_max = 105, mp_max = 100, dmg = 102, defence = 110, critrate = 103, hitrate = 110}
            },
            %% 整个计算
            R4 = calc_attr(R0), %%正式版本中需要去掉函数中的测试数据
            ?assertEqual(530, R4#role.hp),
            ?assertEqual(230, R4#role.mp),
            ?assertEqual(81, R4#role.attr#attr.dmg_max),
            ?assertEqual(77, R4#role.attr#attr.dmg_min),
            ?assertEqual(0, R4#role.attr#attr.defence),
            ?assertEqual(916, R4#role.attr#attr.hitrate),
            ?assertEqual(56, R4#role.attr#attr.evasion),
            ?assertEqual(50, R4#role.attr#attr.critrate),
            %% 刺客---30级
            R5 = Role#role{
                career = ?career_cike,
                lev = 30,
                hp = 1600, mp = 200,
                ratio = #ratio{hp_max = 105, mp_max = 100, dmg = 102, defence = 110, critrate = 103, hitrate = 110}},
            %% 整个计算
            R6 = calc_attr(R5), %%正式版本中需要去掉函数中的测试数据
            ?assertEqual(460, R6#role.hp),
            ?assertEqual(275, R6#role.mp),
            ?assertEqual(72, R6#role.attr#attr.dmg_max),
            ?assertEqual(69, R6#role.attr#attr.dmg_min),
            ?assertEqual(0, R6#role.attr#attr.defence),
            ?assertEqual(968, R6#role.attr#attr.hitrate),
            ?assertEqual(118, R6#role.attr#attr.evasion),
            ?assertEqual(80, R6#role.attr#attr.critrate),
            true
    end,
    %% 测试
    TestPushAttr = fun() ->
            true
    end,
    [
        ?_assert(TestRoleAttr())
        ,?_assert(TestPushAttr())
    ].
-endif.
