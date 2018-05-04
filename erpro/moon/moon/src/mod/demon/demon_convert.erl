%%---------------------------------------------
%% 
%% @author qingxuan
%% @end
%%---------------------------------------------

-module(demon_convert).
-export([
    do/2
]).

-include("common.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("attr.hrl").
-include("demon.hrl").

do(to_fighter, #demon2{base_id = BaseId, name = Name, lev = Lev, attack_type = AttackType, skills = Skill, attr = DemonAttr = #demon_attr{hp_max = HpMax, mp_max = MpMax}}) ->
    % %% 获取所有技能
    Cskills = [combat_data_skill:get(SkillId) ||SkillId <- Skill, is_integer(SkillId) =:= true],
    % Cskills = convert_skill(skill:get_combat_skill_list(Npc)),
    % %% 分离主动技能和被动技能
    ActiveSkills = lists:filter(fun(#c_skill{passive_type=PassiveType}) -> PassiveType=:=?passive_type_none end, Cskills),
    PassiveSkills = lists:filter(fun(#c_skill{passive_type=PassiveType}) -> PassiveType=/=?passive_type_none end, Cskills),
    % ActiveSkills = [],
    % PassiveSkills = [],
    SecretAI = case BaseId > 100000 of 
        true -> BaseId; %% vip妖精
        _ -> BaseId + 100000 %% 一般妖精
    end,
    Fattr = do(to_fighter_attr, DemonAttr),
    F = #fighter{rid = 0, base_id = BaseId, type = ?fighter_type_npc, subtype = ?fighter_subtype_demon, name = Name, lev = Lev, hp = HpMax, hp_max = HpMax, mp = MpMax, mp_max = MpMax, attack_type = AttackType, attr = Fattr, attr_ext = #attr_ext{}, secret_ai = SecretAI},
    Fext = #fighter_ext_npc{skills = ActiveSkills, passive_skills = PassiveSkills},
    CF = #converted_fighter{fighter = F, fighter_ext = Fext},
    {ok, CF};

do(to_fighter_attr, 
        _DemonAttr = #demon_attr{
            hp_max = _HpMax, 
            mp_max = _MpMax,
            dmg = Dmg,
            critrate = Critrate,
            defence = Defence,
            tenacity = Tenacity,
            evasion = Evasion,
            hitrate = Hitrate,
            dmg_magic = DmgMagic
        }) ->
    #attr{
        dmg_min = Dmg,
        dmg_max = Dmg,
        critrate = Critrate,
        defence = Defence,
        tenacity = Tenacity,
        evasion = Evasion,
        hitrate = Hitrate,
        dmg_magic = DmgMagic
    }.
