%%----------------------------------------------------
%% 战斗宠物脚本
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_script_pet).
-export([
        get/1,
        pre_action/1,
        pet_feedback_dmg/4,
        protect_master/4,
        pet_attack/3,
        check_passive_multi_attack/2,
        passive_activate/4,
        revive_master/2,
        cost_mp_cal/2,
        convert/2,
        get_normal_skill_id/1
    ]
).
-include("common.hrl").
-include("skill.hrl").
-include("pet.hrl").
-include("combat.hrl").
-include("attr.hrl").
%%

get(Pet = #pet{id = Id, name = Name, skill = Skills, lev = Lev, attr = Attr, happy_val = HappyVal, type = Type, fight_capacity = FightCapacity}) ->
    CpetSkills = [CpetSkill || CpetSkill <- [convert(to_cpet_skill, {SkillId, AddtArgs}) || {SkillId, _Exp, _, AddtArgs} <- Skills], CpetSkill =/= undefined],
    CpetSkills2 = [convert(to_cpet_skill, {get_normal_skill_id(Pet), []}) | CpetSkills], %% 每种宠物都有一个默认的普通攻击技能
    #c_pet{id = Id, base_id = pet_api:get_base_id(Pet), name = Name, skills = CpetSkills2, attr = Attr, lev = Lev, happy_val = HappyVal, type = Type, fight_capacity = FightCapacity}.

convert(to_cpet_skill, {SkillId, AddtArgs}) ->
    if
        SkillId =:= ?skill_common 
        orelse SkillId =:= ?pet_101_normal_skill 
        orelse SkillId =:= ?pet_102_normal_skill 
        orelse SkillId =:= ?pet_103_normal_skill ->
            #c_pet_skill{id = SkillId, attack_type = ?attack_type_melee, passive_type = ?passive_type_attack_dmg_hp, action = fun script_10000/4};
        true ->
            case pet_data_skill:get(SkillId) of
                {ok, #pet_skill{type = ?pet_skill_type_buff}} -> %% 过滤增加反击值的技能
                    undefined;
                {ok, #pet_skill{script_id = ScriptId, cd = Cooldown, args = Args, n_args = Nargs, cost = Cost, buff_self = BuffParamList1, buff_target = BuffParamList2}} ->
                    CostMp = case lists:keyfind(mp, 1, Cost) of
                        {mp, Mp} -> Mp;
                        _ -> 0
                    end,
                    Args1 = calc_final_args(Args, AddtArgs),
                    BuffSelf = combat_script_buff:convert_buff(BuffParamList1),
                    BuffTarget = combat_script_buff:convert_buff(BuffParamList2),
                    TalentArgs = case AddtArgs of
                        [_|_] ->
                            case lists:keyfind(?pet_skill_args_talent, 1, AddtArgs) of
                                {?pet_skill_args_talent, Star} ->
                                    case lists:keyfind(Star, 1, Nargs) of
                                        {Star, TA} -> TA;
                                        _ -> []
                                    end;
                                _ -> []
                            end;
                        _ -> []
                    end,
                    TmpSkill = #c_pet_skill{id = SkillId, script_id= ScriptId, args = Args1, talent_args = TalentArgs, cost_mp = CostMp, cd = Cooldown, buff_self = BuffSelf, buff_target = BuffTarget},
                    %% 注意：passive_type = ?passive_type_pre_action的，返回格式是：{true, XX} | true | 其他
                    case ScriptId of                       
                        110000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_attack, action = fun script_110000/4};
                        120000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_die, action = fun script_120000/4};
                        130000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_pre_action, action = fun script_130000/4};
                        131000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_pre_action, action = fun script_131000/4};
                        140000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_defence, action = fun script_140000/4};
                        200000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_pre_action, action = fun script_200000/4};
                        210000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_attack_buff, action = fun script_210000/4};
                        211000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_attack_buff, action = fun script_211000/4};
                        220000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_attack_dmg_mp, action = fun script_220000/4};
                        300000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_defence, action = fun script_300000/4};
                        360000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_defence, action = fun script_360000/4};
                        400000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_attack, action = fun script_400000/4};
                        410000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_defence, action = fun script_410000/4};
                        420000 -> TmpSkill#c_pet_skill{passive_type = ?passive_type_defence, action = fun script_420000/4};
                        _ -> 
                            %%?ERR("不支持的战斗宠物技能:~w", [ScriptId]),
                            undefined
                    end;
                {false, Why} -> 
                    ?ERR("转换成战斗宠物技能[SkillId=~w]时错误:~s", [SkillId, Why]),
                    undefined
            end
    end;
%% 守护技能转换成#c_skill
convert(to_cpet_skill, {pet_skill, PetSkillId, Args, BuffParamList1, BuffParamList2, Cd}) ->
    case convert(to_cpet_skill, {PetSkillId, []}) of
        undefined -> undefined;
        CpetSkill ->
            BuffSelf = combat_script_buff:convert_buff(BuffParamList1),
            BuffTarget = combat_script_buff:convert_buff(BuffParamList2),
            CpetSkill#c_pet_skill{args = Args, buff_self = BuffSelf, buff_target = BuffTarget, cd = Cd}
    end;
convert(_, _) -> undefined.
    

f(by_scriptid, PassiveSkills, ScriptId) ->
    case lists:keyfind(ScriptId, #c_pet_skill.script_id, PassiveSkills) of
        false ->
            undefined;
        F -> F
    end;
f(by_buffid, Buffs, BuffId) ->
    case lists:keyfind(BuffId, #c_buff.id, Buffs) of
        false -> undefined;
        B -> B
    end.

add_buffs(Buffs, Self, Target) ->
    do_add_buffs(Buffs, Self, Target, false).
do_add_buffs([], _, _, Result) -> Result;
do_add_buffs([Buff|T], Self, Target, Result) ->
    case combat_script_buff:do_add_buff(Buff, Self, Target) of
        true ->
            do_add_buffs(T, Self, Target, true);
        false -> do_add_buffs(T, Self, Target, Result)
    end.

%%----------------------------------------------------------------
%% 宠物攻击
%%----------------------------------------------------------------
pet_attack(PetFighter=#fighter{type = ?fighter_type_pet, pid = Spid, name = _Sname}, #fighter{pid = Tpid}, Params) ->
    {_, Self = #fighter{name = _Sname, hp = Shp, hp_max = ShpMax, is_nopassive = IsNoPassive, is_undying = SisUndying}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{id = Tid, name = _Tname, hp = Thp, mp = Tmp, mp_max = TmpMax, anger_max = TangerMax, is_defencing = IsDefencing, is_sleep = IsSleep, buff_round = TBuffRound, is_undying = IsUndying}} = combat:f(by_pid, Tpid),
    Tpet = combat:f_pet(Tpid),
    Skill = #c_pet_skill{attack_type = AttackType} = convert(to_cpet_skill, {get_normal_skill_id(PetFighter), []}),
    AdditionAtkCostMp = case Params of
        [AddAtkCostMp] -> AddAtkCostMp;
        _ -> 0
    end,
    %% 判断攻击是否击中
    CanHit = is_hit(Self, Target),

    %%------------------------------------------------------
    %% 计算总伤害
    %%------------------------------------------------------ 
    {DmgHp, DmgMp, TotalCostMp1, IsCrit, IsHit} = attack_dmg_cal(Self, Target, CanHit),

    %%------------------------------------------------------
    %% 计算伤害减免
    %%------------------------------------------------------ 
    %% 对方防御
    {DmgHp2, DmgMp2} = case IsDefencing of
        ?true -> {round(DmgHp * 0.8), round(DmgMp * 0.8)};
        ?false -> {DmgHp, DmgMp}
    end,
    %% 对方宠物技能：保护(减伤)
    {IsProtectedByPet, DmgHpReduceByPet, PetProtectCostMp, FeedbackDmgByPet} = protect_master(dmg_reduce, Target, Self, [DmgHp2, DmgMp2]),
    DmgHp3 = DmgHp2 - DmgHpReduceByPet,
    TotalMpDmg = DmgMp,
    %% 保护者受到伤害
    {IsProtected, ThpDmg1, ProtectorDmg, Protector4, IsProtectorDie} = case combat_script_skill:is_protected(Target) of
        {true, Protector, ProtectorRatio} ->
            #fighter{pid = ProtPid, hp = ProtectorHp, name = _ProtName} = Protector,
            combat:add_to_hit_history(ProtPid, 0, 1),
            ProtDmg = round(DmgHp3 * ProtectorRatio / 100),
            NewProtectorHp = ProtectorHp - ProtDmg,
            {IsDie, Protector3} = if
                NewProtectorHp < 1 ->
                    Protector2 = Protector#fighter{hp = 0, is_die = ?true},
                    combat:update_fighter(ProtPid, [{hp, 0}, {is_die, ?true}]),
                    {?true, Protector2};
                true ->
                    Protector2 = Protector#fighter{hp = NewProtectorHp},
                    combat:update_fighter(ProtPid, [{hp, NewProtectorHp}]),
                    {?false, Protector2}
            end,
            %%?DEBUG("保护者[~s]受到了[~w]点伤害，剩余血量[~w]", [_ProtName, ProtDmg, NewProtectorHp]),
            {true, DmgHp3 - ProtDmg,  ProtDmg, Protector3, IsDie};
        {false, _} -> {false, DmgHp3, 0, undefined, ?false}
    end,
    %% 减伤被动技能触发
    {ThpDmgReduce, _TotalMpDmgReduce} = passive_activate(dmg_reduce, Self, Target, [{0, 0}, ThpDmg1]),

%    %% 被攻击者受到伤害
%    ThpDmg = ThpDmg1 - ThpDmgReduce,
%    NewTmp = Tmp - TotalMpDmg,

    %% 
    RealHpDmg = ThpDmg1 - ThpDmgReduce,  %% RealHpDmg = 按攻击者攻击力和被攻击者防御算出来的理想伤害(没有算上盾的抵消)

    %% 护盾
    {IsShield, TotalHpDmg, ShieldReduce} = combat_script_skill:use_shield(Tpid, RealHpDmg),  %% TotalHpDmg = 角色实际受到的伤害（算上盾抵消的伤害）(可能会超过角色气血上限) 
    AttackDmgOutput = case IsShield of %% 攻击者实际攻击效果(包含对人的伤害和对盾的伤害，如果有盾，不能超出盾的容量)(反弹应该用这个作基数去算)
        true -> ShieldReduce;
        _ -> TotalHpDmg
    end,

    NewThp0 = Thp - TotalHpDmg,
    %% 濒死状态/不死状态
    NewThp = case NewThp0 < 0 andalso IsUndying =:= ?true of
        true -> 1;  %% 濒死状态，最后气血总为1
        false -> NewThp0
    end,
    NewTmp = combat_util:check_range(Tmp - TotalMpDmg, 0, TmpMax),

    combat:add_to_hit_history(Tpid, 0, 1),
    combat:add_role_to_npc_dmg(Self, Target, TotalHpDmg),
    combat:add_role_to_role_dmg(Self, Target, TotalHpDmg),
    %%?DEBUG("[~s]受到了[~w,~w]点伤害，剩余血量和魔法[~w,~w]", [_Tname, TotalHpDmg, TotalMpDmg, NewThp, NewTmp]),
    {TotalCostMpFinal, HpChangeFinal} = 
        if
        NewThp < 1 ->
            %% 修改相关血量和魔量
            combat:update_fighter(Tpid, [{hp, 0}, {mp, NewTmp}, {anger, 0}, {power, 0}, {is_die, ?true}]),
            
            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 宠物复活自己
            {IsTargetDie, IsPetReviveSelf, ReviveSelfSkill, HealHp} = case passive_activate(revive_self, Target, Target, [TotalHpDmg]) of
                {true, ReviveSelfSkill1, HealHp1} -> {?false, true, ReviveSelfSkill1, HealHp1};
                _ -> {?true, false, undefined, 0}
            end,

            %% 吸血技能触发
            {SuckHp, SuckMpCost} = attack_suck_hp(Self, Target, TotalHpDmg),

            %% 播放攻击动作
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill#c_pet_skill{cost_mp = TotalCostMp1 + AdditionAtkCostMp + SuckMpCost}, SuckHp, -TotalHpDmg, -TotalMpDmg, -TangerMax, IsCrit, IsHit, IsTargetDie)),

            %% 播放保护动作
            if 
                IsProtected =:= true ->
                    combat:add_sub_play(combat:gen_sub_play(protect, Protector4, Target, -ProtectorDmg, 0, IsProtectorDie));
                true -> ignore
            end,

            %% 播放宠物保护动作
            if
                IsProtectedByPet =:= true ->
                    #fighter{pid = TpetPid, hp = TpetHp} = Tpet,
                    IsTpetDie = case TpetHp - DmgHpReduceByPet =< 0 of
                        true ->
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false ->
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, cost_mp_cal(Tpet, PetProtectCostMp)}]),
                            ?false
                    end,
                    combat:add_sub_play(combat:gen_sub_play(protect, Tpet, Target, -DmgHpReduceByPet, -PetProtectCostMp, IsTpetDie));
                true -> ignore
            end,

            %% 播放宠物复活自己的动作
            case IsPetReviveSelf of
                true -> combat:add_to_pet_revive(ReviveSelfSkill, Target, HealHp);
                false -> ignore
            end,

            {TotalCostMp1 + AdditionAtkCostMp + SuckMpCost, SuckHp};
        true ->
            %% 修改对方血量和魔量
            combat:update_fighter(Tpid, [{hp, NewThp}, {mp, NewTmp}, {is_sleep, ?false}]),

            %% 判断对方是否中被动技能附带的buff
            {_, TotalCostMp2} = case IsNoPassive of
                ?false -> attack_buff_cal(Self, Target, [TotalHpDmg, TotalMpDmg]);
                _ -> {false, 0}
            end,

            %% 吸血技能触发
            {SuckHp, SuckMpCost} = attack_suck_hp(Self, Target, TotalHpDmg),

            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 对方宠物被动技能：buff
            passive_activate(buff_after_hit, Self, Target, [AttackType, TotalHpDmg]),
            PowerChanged = calc_power_after_hit(Self, Target, TotalHpDmg),

            %% 播放攻击动作
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill#c_pet_skill{cost_mp = TotalCostMp1+TotalCostMp2+AdditionAtkCostMp + SuckMpCost}, SuckHp, -TotalHpDmg, -TotalMpDmg, 0, IsCrit, IsHit, ?false, PowerChanged)),

            %% 播放保护动作
            if 
                IsProtected =:= true ->
                    combat:add_sub_play(combat:gen_sub_play(protect, Protector4, Target, -ProtectorDmg, 0, IsProtectorDie));
                true -> ignore
            end,

            %% 播放宠物保护动作
            if
                IsProtectedByPet =:= true ->
                    #fighter{pid = TpetPid, hp = TpetHp} = Tpet,
                    IsTpetDie = case TpetHp - DmgHpReduceByPet =< 0 of
                        true ->
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false ->
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, cost_mp_cal(Tpet, PetProtectCostMp)}]),
                            ?false
                    end,
                    combat:add_sub_play(combat:gen_sub_play(protect, Tpet, Target, -DmgHpReduceByPet, -PetProtectCostMp, IsTpetDie));
                true -> ignore
            end,

            %% 伤害会让睡眠状态解除
            case IsSleep of
                ?true -> 
                    case f(by_buffid, TBuffRound, 200050) of
                        undefined -> ignore;
                        SleepBuff -> combat:buff_del(SleepBuff, Tpid)
                    end;
                _ -> ignore
            end,

            %% 被动技能：反弹伤害
            {_, Self1} = combat:f(by_pid, Spid),
            {IsFeedback, FeedbackDmg} = combat_script_skill:feedback_dmg(Self1, Target, [AttackType, AttackDmgOutput, IsHit, FeedbackDmgByPet]),
            ShpAfterFeedback0 = Shp - FeedbackDmg,
            {IsFeedbackKilled, ShpAfterFeedback} = case ShpAfterFeedback0 > 0 of 
                true -> {?false, ShpAfterFeedback0};
                false ->
                    case SisUndying =:= ?true of
                        true -> {?false, 1};
                        false -> {?true, ShpAfterFeedback0}
                    end
            end,
            {_, Self2} = combat:f(by_pid, Spid),
            case IsFeedback of
                true -> %% 有反伤则先判断反伤再判断反击
                    case IsFeedbackKilled of
                        ?true -> %% 如果被反伤杀死则对方不会再反击
                            combat:update_fighter(Spid, [{hp, 0}, {is_die, ?true}]),
                            combat:add_sub_play(combat:gen_sub_play(feedback, Target, Self2, -FeedbackDmg, ?false, ?true));

                        ?false -> %% 没有被反伤杀死则继续判断反击
                            combat:add_sub_play(combat:gen_sub_play(feedback, Target, Self2, -FeedbackDmg, ?false, ?false)),

                            %% 反击 
                            {IsAntiAtk, {AntiAtkDmg, AntiAtkCrit}, AntiAtkHit} = combat_script_skill:anti_attack(Skill, Self2, Target),
                            case IsAntiAtk of
                                true ->
                                    NewShp = combat_util:check_range(ShpAfterFeedback - AntiAtkDmg - FeedbackDmg, 0, ShpMax),
                                    IsSelfDie = combat_util:is_die(NewShp),
                                    %% ?DEBUG("[~s]反击[~s]，使其受到[~w]点伤害", [_Tname, _Sname, AntiAtkDmg]),
                                    combat:update_fighter(Spid, [{hp, NewShp}, {is_die, IsSelfDie}]),
                                    combat:add_sub_play(combat:gen_sub_play(anti_attack, Target, Self2, -AntiAtkDmg, 0, AntiAtkCrit, AntiAtkHit, IsSelfDie));
                                false ->
                                    combat:update_fighter(Spid, [{hp, ShpAfterFeedback - FeedbackDmg}])
                            end
                    end;
                false -> %% 没有反伤就直接判断反击 
                    {IsAntiAtk, {AntiAtkDmg, AntiAtkCrit}, AntiAtkHit} = combat_script_skill:anti_attack(Skill, Self2, Target),
                    case IsAntiAtk of
                        true ->
                            NewShp = combat_util:check_range(ShpAfterFeedback - AntiAtkDmg, 0, ShpMax),
                            IsSelfDie = combat_util:is_die(NewShp),
                            %% ?DEBUG("[~s]反击[~s]，使其受到[~w]点伤害", [_Tname, _Sname, AntiAtkDmg]),
                            combat:update_fighter(Spid, [{hp, NewShp}, {is_die, IsSelfDie}]),
                            combat:add_sub_play(combat:gen_sub_play(anti_attack, Target, Self2, -AntiAtkDmg, 0, AntiAtkCrit, AntiAtkHit, IsSelfDie));
                        false ->
                            NewShp = combat_util:check_range(ShpAfterFeedback - FeedbackDmg, 0, ShpMax),
                            combat:update_fighter(Spid, [{hp, NewShp}])
                    end
            end,

            %% ?DEBUG("TotalCostMp2=~w", [TotalCostMp2]),
            {TotalCostMp1 + TotalCostMp2 + AdditionAtkCostMp + SuckMpCost, SuckHp}

    end,
    {_, Self3} = combat:f(by_pid, Spid),
    combat:update_fighter(Spid, [{mp, cost_mp_cal(Self3, TotalCostMpFinal)}, {hp_changed, HpChangeFinal}]).



%% 宠物攻击，给对方造成伤害和魔法损耗
%% attack_dmg_cal(Self, Target, CanHit) -> {总伤害, 总消魔, 总共花费自身魔法, 是否暴击, 是否命中}
attack_dmg_cal(Self = #fighter{pid = Pid}, Target, CanHit) ->
    case combat:f_ext(by_pid, Pid) of
        #fighter_ext_pet{passive_skills = Skills} ->
            DmgHpSkills = lists:filter(fun(#c_pet_skill{passive_type = PassiveType}) -> PassiveType =:= ?passive_type_attack_dmg_hp end, 
                Skills),
            DmgMpSkills = lists:filter(fun(#c_pet_skill{passive_type = PassiveType}) -> PassiveType =:= ?passive_type_attack_dmg_mp end, 
                Skills),
            %% 伤害技能合计
            {TotalDmgHp, TotalCostMp1, IsCrit} = sum_dmg({0, 0, ?false}, DmgHpSkills, Self, Target),
            {TotalDmgMp, TotalCostMp2, _} = sum_dmg({0, 0, ?false}, DmgMpSkills, Self, Target),
            %% 返回总得伤害数
            {IsHit, HpDmgMult} = case CanHit of
                true -> {?true, 1};
                false -> {?false, 0.5}
            end,
            {round(TotalDmgHp*HpDmgMult), TotalDmgMp, TotalCostMp1 + TotalCostMp2, IsCrit, IsHit};
        _ -> {0, 0, 0, ?false, ?true}
    end.

%% 判断仙宠吸血技能触发
attack_suck_hp(Self = #fighter{pid = Spid}, Target, ThpDmg) ->
    case combat:f_ext(by_pid, Spid) of
        #fighter_ext_pet{passive_skills = PassiveSkills} ->
            case f(by_scriptid, PassiveSkills, 400000) of 
                undefined -> 
                    {0, 0};
                F_400000 -> 
                    case skill_check(F_400000, Self, Target) of
                        {true, _} ->
                            case script_400000(F_400000, Self, Target, [ThpDmg]) of
                                {_, H, C} -> {H, C};
                                _ -> {0, 0}
                            end;
                        {false, _Reason} -> 
                            ?log("宠物吸血 ~s", [_Reason]),
                            {0, 0}
                    end
            end;
        _ ->
            {0, 0}
    end.

%% 宠物攻击，给对方施加BUFF
%% attack_buff_cal(Self, Target, Params) -> {是否有施加BUFF, 总共花费自身魔法}
attack_buff_cal(Self = #fighter{pid = Pid}, Target, Params) ->
    case combat:f_ext(by_pid, Pid) of
        #fighter_ext_pet{passive_skills = Skills} ->
            %% BUFF技能合计
            BuffSkills = lists:filter(fun(#c_pet_skill{passive_type = PassiveType}) -> PassiveType =:= ?passive_type_attack_buff end,
                Skills),
            attack_buff_cal(Self, Target, Params, BuffSkills, {false, 0});
        _ -> {false, 0}
    end.
attack_buff_cal(_Self, _Target, _Params, [], {Result, TotalCostMp}) -> {Result, TotalCostMp};
attack_buff_cal(Self, Target, Params, [BuffSkill = #c_pet_skill{action = Action, cost_mp = CostMp}|T], {Result, TotalCostMp}) ->
    case skill_check(BuffSkill, Self, Target) of
        {true, _} ->
            case catch Action(BuffSkill, Self, Target, Params) of
                ok -> attack_buff_cal(Self#fighter{mp = cost_mp_cal(Self, BuffSkill)}, Target, Params, T, {true, TotalCostMp + CostMp});
                _ -> attack_buff_cal(Self, Target, Params, T, {Result, TotalCostMp})
            end;
        {false, _Reason} ->
            ?log("宠物攻击给对方加buff ~s", [_Reason]),
            attack_buff_cal(Self, Target, Params, T, {Result, TotalCostMp})
    end.

%% @spec protect_master(Type, Master, Target, Args) -> 
%% Type = dmg_reduce 时 {true | false, 损失的HP = integer(), 消耗的MP = integer(), 反弹的伤害}
%% Master = #fighter{}
%% Target = #fighter{}
%% Args = [number()]
%% @doc 宠物在主人被攻击时保护
protect_master(dmg_reduce, Master = #fighter{type = ?fighter_type_role, pid = MasterPid}, Target, [DmgHp, _DmgMp]) ->
    Pet = combat:f_pet(MasterPid),
    case Pet of
        #fighter{pid = Pid, hp = Hp, type = ?fighter_type_pet, is_nopassive = ?false, is_taunt = ?false, is_stone = ?false, is_stun = ?false, is_sleep = ?false, is_die = ?false, is_escape = ?false} when Hp >= 1 ->
            #fighter_ext_pet{passive_skills = Skills} = combat:f_ext(by_pid, Pid),
            case lists:keyfind(140000, #c_pet_skill.script_id, Skills) of
                Skill = #c_pet_skill{action = Action} when Action =/= undefined -> 
                    case skill_check(Skill, Pet, Master) of
                        {true, _} -> 
                            case catch Action(Skill, Master, Target, [DmgHp]) of
                                Result = {_, _, _, _} -> Result;
                                _ -> {false, 0, 0, 0}
                            end;
                        {false, _Reason} -> 
                            ?log("护主 ~s", [_Reason]),
                            {false, 0, 0, 0}
                    end;
                _ -> {false, 0, 0, 0}
            end;
        _ -> {false, 0, 0, 0}
    end;
protect_master(dmg_reduce, _Master, _Target, _Params) ->
    {false, 0, 0, 0}.
            
%% 伤害统计
sum_dmg({TotalDmg, TotalCostMp, IsCrit}, [], _Self, _Target) -> {TotalDmg, TotalCostMp, IsCrit};
sum_dmg({TotalDmg, TotalCostMp, IsCrit}, [DmgSkill = #c_pet_skill{action = Action, cost_mp = CostMp}|T], Self, Target) ->
    case skill_check(DmgSkill, Self, Target) of
        {true, _} ->
            case catch Action(DmgSkill, Self, Target, []) of
                {Val, ?true} ->
                    sum_dmg({TotalDmg + Val, TotalCostMp + CostMp, ?true}, T, Self, Target);
                {Val, ?false} ->
                    sum_dmg({TotalDmg + Val, TotalCostMp + CostMp, IsCrit}, T, Self, Target);
                _ ->
                    sum_dmg({TotalDmg, TotalCostMp, IsCrit}, T, Self, Target)
            end;
        {false, _Reason} -> 
            ?log("伤害统计 ~s", [_Reason]),
            sum_dmg({TotalDmg, TotalCostMp, IsCrit}, T, Self, Target)
    end.
    

%% 宠物在回合选招后先判断一次行动
pre_action(Master = #fighter{pid = MasterPid}) ->
    Pet = combat:f_pet(MasterPid),
    put({pet_pre_action, heal_hp}, 0),
    put({pet_pre_action, heal_mp}, 0),
    case Pet of
        #fighter{type = ?fighter_type_pet, pid = Pid, is_die = ?false, is_escape = ?false, is_stone = ?false, is_sleep = ?false, is_silent = ?false, is_stun = ?false, is_nopassive = ?false, is_taunt = ?false} ->
            #fighter_ext_pet{passive_skills = Skills} = combat:f_ext(by_pid, Pid),
            %% 触发自动加血、加魔法、加buff动作
            do_pre_action(0, 0, 0, {false, 0}, Skills, Pet, Master);
        _ -> ignore
    end.

do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, [], #fighter{pid = Pid}, Master) -> 
    if
        HasAction =:= true ->
            Skill = convert(to_cpet_skill, {?skill_common, []}),
            {_, Pet} = combat:f(by_pid, Pid),
            combat:update_fighter(Pid, [{mp, cost_mp_cal(Pet, TotalCostMp)}, {hp_changed, PetHp}]),
            combat:add_sub_play(combat:gen_sub_play(attack, Pet, Master, Skill#c_pet_skill{attack_type = ?attack_type_pet, cost_mp = TotalCostMp}, PetHp, Hp, Mp, 0, ?false, ?true, ?false)),
            combat:commit_play();
        true -> ignore
    end;
do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, [Skill = #c_pet_skill{cost_mp = CostMp, passive_type = PassiveType, action = Action}|T], Pet, Master) ->
    if
        PassiveType =:= ?passive_type_pre_action ->
            case Action of
                undefined -> do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master);
                _ ->
                    case skill_check(Skill, Pet, Master) of
                        {true, _} ->
                            case catch Action(Skill, Pet, Master, []) of
                                {true, HealHp, HealMp, HealPetHp} ->
                                    if 
                                        HealHp > 0 orelse HealMp > 0 orelse HealPetHp > 0 ->
                                            do_pre_action(Hp + HealHp, Mp + HealMp, PetHp + HealPetHp, {true, TotalCostMp + CostMp}, T, Pet, Master);
                                        true -> 
                                            do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master)
                                    end;
                                true ->
                                    do_pre_action(Hp, Mp, PetHp, {true, TotalCostMp + CostMp}, T, Pet, Master);
                                false ->
                                    do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master);
                                {false, _, _, _} ->
                                    do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master);
                                _Err ->
                                    ?ERR("宠物pre_action出错:~w\nSkill=~w", [_Err, Skill]),
                                    do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master)
                            end;
                        {false, _Reason} -> 
                            ?log("前置动作: ~s", [_Reason]),
                            do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master)
                    end
            end;
        true -> do_pre_action(Hp, Mp, PetHp, {HasAction, TotalCostMp}, T, Pet, Master)
    end.

%% @spec revive_master(MasterPid, CurrentRound) -> true | false
%% MasterPid = pid(), 主人pid
%% CurrentRound = integer(), 当前回合数
%% @doc 复活主人
revive_master(MasterPid, CurrentRound) ->
    case combat:f(by_pid, MasterPid) of
        {_, Master} = {_, #fighter{type = ?fighter_type_role, is_escape = ?false, is_die = ?true}} ->
            case combat:f_pet(MasterPid) of
                Pet = #fighter{type = ?fighter_type_pet, id = Id, pid = Pid, is_nopassive = ?false, is_die = ?false, is_escape = ?false, is_stone = ?false, is_sleep = ?false, is_silent = ?false, is_stun = ?false, is_taunt = ?false} ->
                    #fighter_ext_pet{passive_skills = PassiveSkills} = combat:f_ext(by_pid, Pid),
                    case f(by_scriptid, PassiveSkills, 120000) of
                        undefined -> false;
                        F_120000 = #c_pet_skill{id = SkillId}->
                            case combat:is_skill_in_cooldown(Id, F_120000, CurrentRound) of
                                true -> false;
                                false ->
                                    case skill_check(F_120000, Pet, Master) of
                                        {true, _} ->
                                            case script_120000(F_120000, Pet, Master, []) of
                                                true ->
                                                    combat:add_to_skill_cooldown(Id, SkillId, CurrentRound),
                                                    combat:commit_play(),
                                                    true;
                                                _ -> false
                                            end;
                                        {false, _Reason} ->
                                            ?log("复活error: ~s", [_Reason]),
                                            false
                                    end
                            end
                    end;
                _ -> false
            end;
        _ -> false
    end.

%% @spec pet_feedback_dmg(Skills, DmgHp) -> FeedbackDmg
%% Skills = [#c_pet_skill{}]
%% Self = Target = #fighter{}
%% DmgHp = FeedbackDmg = integer()
%% @doc 反射伤害计算
pet_feedback_dmg(TPassiveSkills, Self, Target , DmgHp) ->
    case f(by_scriptid, TPassiveSkills, 420000) of
        PetSkill = #c_pet_skill{action = Script420000} when Script420000 =/= undefined ->
            case Script420000(PetSkill, Self, Target, [DmgHp]) of
                Dmg2 when Dmg2 > 0 -> Dmg2;
                _ -> 0
            end;
        _ -> 0
    end.

%%----------------------------------------------------
%% 伤害计算函数
%%----------------------------------------------------
dmg(
    #fighter{type = ?fighter_type_pet, is_nocrit = IsNoCrit, attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax, dmg_magic = DmgMagic, critrate = Crit}},
    #fighter{lev = Lev, attr = #attr{defence = Defence, tenacity = Tenacity, injure_ratio = InjureRatio}, is_stone = IsStone, stone_dmg_reduce_ratio = StoneDmgReduceRatio}
) ->
    Ar = Defence / (Defence + Lev * 60 + 2000),
    DmgMin1 = combat_util:check_range(DmgMin, 0, DmgMin),
    DmgMax1 = combat_util:check_range(DmgMax, DmgMin1, DmgMax),
    Ap = util:rand(DmgMin1, DmgMax1),
    TmpDmg1 = Ap * (1 - Ar) + DmgMagic,
    TmpDmg2 = round(TmpDmg1 * InjureRatio / 100),
    TmpDmg3 = case IsStone of
        ?true -> TmpDmg2 * (100 - StoneDmgReduceRatio) / 100;
        ?false -> TmpDmg2
    end,
    Crit1 = case IsNoCrit of
        ?true -> 0;
        _ -> Crit
    end,
    FinalCrit = util:check_range(Crit1 - Tenacity, 0, 800),
    case util:rand(1, 1000) =< FinalCrit of
        true -> %% 暴击
            {round(TmpDmg3 * 1.5), ?true};
        false -> %% 非暴击
            {round(TmpDmg3), ?false}
    end.


%%----------------------------------------------------
%% 命中计算函数
%%----------------------------------------------------
is_hit(
    #fighter{type = ?fighter_type_pet, attr = #attr{hitrate = HitRate}},
    #fighter{attr = #attr{evasion = Evasion}}
) ->
    Hr = (900 + HitRate - Evasion),
    util:rand(1, 10000) < Hr * 10.


%%----------------------------------------------------
%% 检测技能是否能施放
%%----------------------------------------------------
skill_check(Skill, Self, Target) ->
    skill_check_on_cost({true, <<>>}, Skill, Self, Target).

skill_check_on_cost({true, _Why}, #c_pet_skill{cost_mp = CostMp}, #fighter{mp = Mp}, _Target) ->
    case Mp - CostMp >= 0 of
        true -> {true, <<>>};
        false -> {false, ?L(<<"魔量太低无法施放该技能">>)}
    end;
skill_check_on_cost(PrevCheck, _Skill, _Self, _Target) -> PrevCheck.


%%---------------------------------------------------
%% 计算魔法消耗后的魔法量
%%---------------------------------------------------
cost_mp_cal(F, #c_pet_skill{cost_mp = CostMp}) when is_record(F, fighter) ->
    cost_mp_cal(F, CostMp);
cost_mp_cal(#fighter{mp = Mp, mp_max = MpMax}, CostMp) when is_integer(CostMp) ->
    combat_util:check_range(Mp - CostMp, 0, MpMax);
cost_mp_cal(_, _) -> 0.

%% @spec check_passive_multi_attack(Self, Target) -> {true, AdditionAttackTimes, CostMp} | {false, 0, 0}
%% Self = #fighter{}
%% Target = #fighter{}
%% AdditionAttackTimes = integer() 增加的攻击次数
%% CostMp = integer() 消耗的魔法
%% @doc 被动追击判断，返回增加的连击数
check_passive_multi_attack(#fighter{type = ?fighter_type_pet, pid = Pid}, Target) ->
    case combat:f(by_pid, Pid) of
        {_, Self = #fighter{is_nopassive = ?false, is_taunt = ?false, is_stone = ?false, is_stun = ?false, is_sleep = ?false, is_die = ?false, is_escape = ?false}} ->
            #fighter_ext_pet{passive_skills = PassiveSkills} = combat:f_ext(by_pid, Pid),
            case f(by_scriptid, PassiveSkills, 110000) of 
                undefined -> {false, 0, 0};
                F_110000 -> 
                    case skill_check(F_110000, Self, Target) of
                        {true, _} ->
                            script_110000(F_110000, Self, Target, []);
                        {false, _Reason} -> 
                            ?log("被动追击 ~s", [_Reason]),
                            {false, 0, 0}
                    end
            end;
        _ -> {false, 0, 0}
    end;
check_passive_multi_attack(_Self, _Target) ->
    {false, 0, 0}.


%%-----------------------------------------------------------------
%% 被动技能触发
%%-----------------------------------------------------------------
%% passive_activate(Type, Self, Target, Args) -> ok
%% 被动技能触发：被击中就添加buff
passive_activate(buff_after_hit, #fighter{pid = Spid, name = _Sname}, #fighter{pid = Tpid, type = ?fighter_type_pet, is_nopassive = ?false}, Args) -> 
    {TPassiveSkills, _TAngerSkills, _TAngerPassiveSkills} = case combat:f_ext(by_pid, Tpid) of
        #fighter_ext_pet{passive_skills = L} -> {L, [], []};
        _ -> {[], [], []}
    end,
    do_passive_activate(buff_after_hit, TPassiveSkills, Spid, Tpid, Args),
    ok;

%% 被动技能触发,被击中减少伤害
passive_activate(dmg_reduce, #fighter{pid = Spid, name = _Sname}, #fighter{pid = Tpid, type = ?fighter_type_pet, is_nopassive = ?false}, Args) -> 
    TPassiveSkills = case combat:f_ext(by_pid, Tpid) of
        #fighter_ext_pet{passive_skills = L} -> L;
        _ -> [] 
    end,
    do_passive_activate(dmg_reduce, TPassiveSkills, Spid, Tpid, Args);
passive_activate(dmg_reduce, _Self, _Target, _Args) -> 
    {0, 0};

%% 被动技能触发：被杀死复活
passive_activate(revive_self, Self = #fighter{id = Sid, pid = Spid, type = ?fighter_type_pet}, _Target, [DmgHp]) -> 
    case combat:f(by_pid, Spid) of
        {_, #fighter{is_die = ?true, hp = Hp, is_nopassive = ?false}} when Hp < 1 ->
            PassiveSkills = case combat:f_ext(by_pid, Spid) of
                #fighter_ext_pet{passive_skills = L} -> L;
                _ -> []
            end,
            case lists:keyfind(360000, #c_pet_skill.script_id, PassiveSkills) of
                Skill = #c_pet_skill{id = SkillId, action = Action} when Action =/= undefined ->
                    case combat:is_skill_in_cooldown(Sid, Skill) of
                        false ->
                            case combat:f_master(Spid) of
                                #fighter{type = ?fighter_type_role, is_die = ?false} ->
                                    case catch Action(Skill, Self, Self, [DmgHp]) of
                                        Result = {_, _, _} ->
                                            combat:add_to_skill_cooldown(Sid, SkillId, erlang:get(current_round)),
                                            Result;
                                        _ -> {false, undefined, 0}
                                    end;
                                _ -> {false, undefined, 0}
                            end;
                        _ -> {false, undefined, 0}
                    end;
                _ -> {false, undefined, 0}
            end;
        _ -> {false, undefined, 0}
    end;
passive_activate(revive_self, _Self, _Target, _Args) ->
    {false, undefined, 0};
passive_activate(_Type, _Self, _Target, _Args) -> 
    ok.


do_passive_activate(buff_after_hit, [], _, _, _) -> ok;
%% 命中触发buff类
do_passive_activate(buff_after_hit, [Skill = #c_pet_skill{id = SkillId, script_id = 300000}|T], Spid, Tpid, Args) ->
    case combat:f(by_pid, Tpid) of
        {_, #fighter{is_nopassive = ?true}} -> ignore;
        {_, Target = #fighter{id = Tid}} ->
            case combat:is_skill_in_cooldown(Tid, Skill) of
                true -> ignore;
                false ->
                    combat:add_to_skill_cooldown(Tid, SkillId, erlang:get(current_round)),
                    script_300000(Skill, Target, Target, Args)
            end
    end,
    do_passive_activate(buff_after_hit, T, Spid, Tpid, Args);
%% 命中减伤
do_passive_activate(dmg_reduce, [], _, _, [{DmgReduce, MpCost} | _]) -> {DmgReduce, MpCost};
do_passive_activate(dmg_reduce, [Skill = #c_pet_skill{id = SkillId, script_id = 410000}|T], Spid, Tpid, [{DmgReduce, MpCost}, TotalHpDmg]) ->
    {Reduce, Cost} = case combat:f(by_pid, Tpid) of
        {_, #fighter{is_nopassive = ?true}} -> {0, 0};
        {_, Target = #fighter{id = Tid}} ->
            case combat:is_skill_in_cooldown(Tid, Skill) of
                true -> 
                    {0, 0};
                false ->
                    combat:add_to_skill_cooldown(Tid, SkillId, erlang:get(current_round)),
                    case skill_check(Skill, Target, Target) of
                        {true, _} ->
                            script_410000(Skill, Target, Target, [TotalHpDmg]);
                        {false, _Reason} ->
                            ?log("命中减伤: ~s", [_Reason]),
                            {0, 0}
                    end
            end
    end,
    do_passive_activate(dmg_reduce, T, Spid, Tpid, [{DmgReduce + Reduce, MpCost + Cost}, TotalHpDmg]);

do_passive_activate(Type, [_|T], Spid, Tpid, Args) -> do_passive_activate(Type, T, Spid, Tpid, Args).

calc_power_after_hit(#fighter{}, #fighter{pid = Tpid}, HpDmg) -> 
    Skills = case combat:f_ext(by_pid, Tpid) of
        #fighter_ext_role{skills = L1} -> L1;
        _ -> [] 
    end,
    {_, #fighter{hp_max = HpMax}} = combat:f(by_pid, Tpid),
    case lists:keyfind(10700, #c_skill.script_id, Skills) of
        #c_skill{} ->
            PV = combat_util:power_calc(HpMax, HpDmg),
            combat:update_fighter(Tpid, [{power_changed, PV}]),
            PV;
        _ ->
            0
    end.

%%---------------------------------------------------------------
%% 参数调整
%%---------------------------------------------------------------
%% 从附加参数列表中获取概率参数
get_addt_rate(AddtArgs) when is_list(AddtArgs) ->
    case lists:keyfind(?pet_skill_args_rate, 1, AddtArgs) of
        {_, R} when is_integer(R) -> R;
        _ -> 0
    end.

%% 从附加参数列表中获取数值
get_addt_effect(AddtArgs) when is_list(AddtArgs) ->
    case lists:keyfind(?pet_skill_args_effect, 1, AddtArgs) of
        {_, R} when is_integer(R) -> R;
        _ -> 0
    end.

%% 计算最终参数列表 -> [integer()...]
calc_final_args(Args, AddtArgs) ->
    A = get_addt_rate(AddtArgs),
    B = get_addt_effect(AddtArgs),
    case Args of
        [X, Y | T] -> [X+A, Y+B | T];
        [X|T] -> [X+A | T];
        _ -> Args
    end.


%%---------------------------------------------------------------
%% 脚本实现
%% 参数说明：
%%     Skill: #c_pet_skill{}，宠物技能
%%     Self: #fighter{}，宠物自身
%%     Target: #fighter{}，目标
%%     Params: list()，额外的参数
%%---------------------------------------------------------------

%% 普通攻击 -> {伤害量，是否暴击}
script_10000(_Skill, Self, Target, _Params) ->
    dmg(Self, Target).

%% x%几率触发追击
script_110000(#c_pet_skill{id = SkillId, cost_mp = CostMp, args = [X], talent_args = _}, #fighter{id = Sid}, _Target, _Params) ->
    case util:rand(1, 100) =< X of
        true ->
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            {true, 1, CostMp};
        false -> {false, 0, 0}
    end.

%% x%几率复活主人，并回复主人y点气血 -> true | false
script_120000(Skill = #c_pet_skill{id = SkillId, args = [X, Y], talent_args = _}, Self = #fighter{id = Sid, pid = Spid}, _Target, _) ->
    case util:rand(1, 100) =< X of
        true ->
            ?log("复活 ~p", [Sid]),
            Master = #fighter{pid = MasterPid, type = ?fighter_type_role, hp = Hp, hp_max = HpMax} = combat:f_master(Spid),
            BaseHp = combat_util:check_range(Hp, 0, Hp),
            NewHp = combat_util:check_range(BaseHp + Y, 0, round(HpMax * 0.3)), %% 设定回复气血的上限
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            combat:update_fighter(Spid, [{mp, cost_mp_cal(Self, Skill)}]),
            combat:update_fighter(MasterPid, [{hp, NewHp}, {is_die, ?false}]),
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Master, Skill#c_pet_skill{attack_type=?attack_type_pet}, 0, NewHp, 0, 0, ?false, ?true, ?false)),
            true;
        false -> false
    end.

%% x%几率给主人增加y点气血
%% @return {结果, 回复的气血，回复的魔法, 自己恢复的气血}
script_130000(#c_pet_skill{id = SkillId, args = [X, Y], talent_args = _}, #fighter{id = Sid, pid = Spid}, _Target, _) -> 
    case util:rand(1, 100) =< X of
        true ->
            Master = #fighter{pid = MasterPid, name = _Sname, hp = Shp, hp_max = ShpMax} = combat:f_master(Spid),
            BaseHp = combat_util:check_range(Shp, 0, Shp),
            HealHp = combat_util:calc_heal(Master, Y),
            NewShp = combat_util:check_range(BaseHp + HealHp, 0, ShpMax),
            %%?DEBUG("[~s]被宠物治疗了[~w]点，剩余血量[~w]", [_Sname, Y, NewShp]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            combat:update_fighter(MasterPid, [{hp, NewShp}]),
            {true, HealHp, 0, 0};
        false -> {false, 0, 0, 0}
    end.

%% x%几率给主人增加y点法力
%% @return {结果, 回复的气血，回复的魔法}
script_131000(#c_pet_skill{id = SkillId, args = [X, Y]}, #fighter{id = Sid, pid = Spid}, _Target, _) -> 
    case util:rand(1, 100) =< X of
        true -> 
            #fighter{pid = MasterPid, name = _Sname, mp = Smp, mp_max = SmpMax} = combat:f_master(Spid),
            BaseMp = combat_util:check_range(Smp, 0, Smp),
            NewSmp = combat_util:check_range(BaseMp + Y, 0, SmpMax),
            %%?DEBUG("[~s]被宠物回复了[~w]点，剩余法力[~w]", [_Sname, Y, NewSmp]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            combat:update_fighter(MasterPid, [{mp, NewSmp}]),
            {true, 0, Y, 0};
        false -> {false, 0, 0, 0}
    end.

%% 主人受到敌人攻击时，x%几率保护主人，抵挡y%的伤害
script_140000(#c_pet_skill{id = SkillId, cost_mp = CostMp, args = [X, Y], talent_args = _}, _Self = #fighter{id = _Sid, pid = Spid}, _Target, [Dmg]) -> 
    case util:rand(1, 100) =< X of
        true ->
            case combat:f_pet(Spid) of
                #fighter{id = PetId} ->
                    combat:add_to_show_passive_skills(PetId, SkillId, ?show_passive_skills_before);
                _ -> ignore
            end,
            {true, round(Dmg * Y / 100), CostMp, 0};
        false -> {false, 0, 0, 0}
    end.

%% x%几率给主人上BUFF
script_200000(#c_pet_skill{id = SkillId, args = [X], buff_target = BuffTarget, talent_args = _}, Self = #fighter{id = Sid, pid = Spid}, _Target, _) ->
    case util:rand(1, 100) =< X of
        true ->
            Master = combat:f_master(Spid),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            add_buffs(BuffTarget, Self, Master);
        false -> false
    end.

%% x%几率在攻击时给目标上BUFF（跟宠物的属性或者造成的伤害不挂钩）
script_210000(#c_pet_skill{id = SkillId, args = [X], buff_target = BuffTarget, talent_args = _}, Self = #fighter{id = Sid}, Target, _Params) ->
    case util:rand(1, 100) =< X of
        true ->
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            lists:foreach(fun(Buff = #c_buff{id = _BuffId, duration = _Duration}) ->
                    combat_script_buff:do_add_buff(Buff, Self, Target)
                end, BuffTarget);
        false -> ignore
    end.


%% x%几率在攻击时给目标上BUFF（跟宠物造成的伤害挂钩）
script_211000(#c_pet_skill{id = SkillId, args = [X], buff_target = BuffTarget}, Self = #fighter{id = Sid}, Target, [DmgHp, _DmgMp]) ->
    case util:rand(1, 100) =< X of
        true -> 
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            BuffTarget1 = [Buff#c_buff{args = [round(DmgHp * H / 100)|T]} || Buff = #c_buff{args = [H|T]} <- BuffTarget],
            lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffTarget1);
        false -> false
    end.

%% 攻击时x%几率在攻击敌人时使敌人减少y点法力
script_220000(#c_pet_skill{id = SkillId, args = [X, Y]}, _Self = #fighter{id = Sid}, _Target, _Params) -> 
    case util:rand(1, 100) =< X of
        true -> 
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            {round(Y), ?false};
        false -> {0, ?false}
    end.

%% x%几率在被攻击时给自己上BUFF
script_300000(#c_pet_skill{id = SkillId, args = [X], buff_self = BuffSelf}, Self = #fighter{id = Sid}, Target = #fighter{name = _Name}, _Params) ->
    case util:rand(1, 100) =< X of
        true ->
            %% ?DEBUG("[~s]的被动技能[Id=~w]触发", [_Name, SkillId]),
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
            lists:foreach(fun(Buff) ->
                        combat_script_buff:do_add_buff(Buff, Self, Target)
                end, BuffSelf);
        false -> false
    end.

%% 当气血高于[气血百分比]%时，宠物被一刀杀死有[触发几率]%几率回复宠物自身气血[气血百分比]%
script_360000(Skill = #c_pet_skill{id = _SkillId, args = [X, Y, Z]}, #fighter{id = _Sid, name = _Name, pid = Pid, hp = Hp, hp_max = HpMax}, _Target, [DmgHp]) ->
    case X =< Hp * 100/HpMax andalso DmgHp >= Hp of
        true ->
            case util:rand(1, 100) =< Y of
                true ->
                    %% ?DEBUG("[~s]的被动技能[Id=~w]触发", [_Name, _SkillId]),
                    %% combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
                    HealHp = round(HpMax * Z / 100),
                    combat:update_fighter(Pid, [{is_die, ?false}]),
                    %% combat:add_sub_play(combat:gen_sub_play(attack, Self, Self, Skill, 0, HealHp, 0, 0, ?false, ?true, ?false));
                    {true, Skill, HealHp};
                false -> {false, undefined, 0}
            end;
        false -> {false, undefined, 0}
    end.

%% x%几率触发把输出按比例回血（吸血）
script_400000(#c_pet_skill{id = SkillId, cost_mp = CostMp, args = [X, Y], talent_args = _}, #fighter{id = Sid}, _Target, [TotalHpDmg]) ->
    case util:rand(1, 100) =< X of
        true ->
            combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
            {true, round(TotalHpDmg * Y / 100), CostMp};
        false -> {false, 0, 0}
    end.

%% x%几率格挡受到伤害的y%点伤害（格挡）
script_410000(#c_pet_skill{id = SkillId, cost_mp = CostMp, args = [X, Y], talent_args = _}, #fighter{id = _Sid}, #fighter{id = Tid}, [TotalHpDmg]) ->
    case util:rand(1, 100) =< X of
        true ->
            combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
            {round(TotalHpDmg * Y / 100), CostMp};
        false -> {0, 0}
    end.

%% x%几率反震受到伤害的y%点给对方(反震)
script_420000(#c_pet_skill{id = SkillId, args = [X, Y], talent_args = _}, #fighter{id = _Sid}, #fighter{id = Tid}, [TotalHpDmg]) ->
    case util:rand(1, 100) =< X of
        true ->
            combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
            round(TotalHpDmg * Y / 100);
        false -> 0
    end.

%% 宠物的普攻技能id
get_normal_skill_id(#pet{base_id = 101}) -> ?pet_101_normal_skill;
get_normal_skill_id(#pet{base_id = 102}) -> ?pet_102_normal_skill;
get_normal_skill_id(#pet{base_id = 103}) -> ?pet_103_normal_skill;
get_normal_skill_id(#fighter{base_id = 101}) -> ?pet_101_normal_skill;
get_normal_skill_id(#fighter{base_id = 102}) -> ?pet_102_normal_skill;
get_normal_skill_id(#fighter{base_id = 103}) -> ?pet_103_normal_skill;
get_normal_skill_id(_) -> ?skill_common.
