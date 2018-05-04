%%----------------------------------------------------
%% 战斗行为配置
%% @author yeahoo2000@gmail.com
%% @author yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_script_skill).
-export([
        get/1,
        get_lineup/1,
        lineup_calc/2,
        %check_passive_multi_attack/2,
        heal/4,
        cast/3,
        talk/3,
        summon_pet/3,
        is_protected/1,
        anti_attack/3,
        %passive_activate/4,
        passive_activate/4,
        anger_calc_max/2,
        is_control_skill/1,
        convert/2,
        try_act_passive_after/3,
        undying_eff/2,
        use_shield/2
    ]
).
%% 提供给战斗技能调用战斗效果
-export([
   attack/3 
   ,attack/4
   ,protect/3
   ,defence/3
   ,escape/3
   ,use_item/3
   ,f/3
   ,is_hit/3
   ,heal_mp/4
   ,demon_attack/3
   ,anger_calc_effect/2
   ,anger_calc_buff_args/3
   ,feedback_dmg/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").


%%----------------------------------------------------
%% 特殊技能
%%----------------------------------------------------
f(by_scriptid, PassiveSkills, ScriptId) ->
    case lists:keyfind(ScriptId, #c_skill.script_id, PassiveSkills) of
        false ->
            undefined;
        F -> F
    end;
f(by_buffid, Buffs, BuffId) ->
    case lists:keyfind(BuffId, #c_buff.id, Buffs) of
        false -> undefined;
        B -> B
    end;
f(by_itembaseid, Items, ItemBaseId) ->
    case lists:keyfind(ItemBaseId, #c_item.base_id, Items) of
        false -> undefined;
        I -> I
    end.

%% 攻击处理
attack(Skill, Self, Target) ->
    attack(Skill, Self, Target, #action_effect_func{}).

attack(Skill = #c_skill{other_cost = OtherCost}, Self = #fighter{pid = Spid}, Target, ActionEffectFunc) ->
    OtherCostHp = combat_util:get_other_cost(hp, OtherCost),
    case OtherCostHp > 0 of
        true -> combat:update_fighter(Spid, [{hp_changed, -OtherCostHp}]);
        false -> ignore
    end,
    do_attack(Skill, Self, Target, ActionEffectFunc).

do_attack(
    Skill = #c_skill{attack_type = AttackType, buff_target = BuffTarget, target_num = TargetNum, other_cost = OtherCost},
    #fighter{pid = Spid, attr_ext = #attr_ext{buff_target_on_attack = EqmGsBuffTarget}},
    #fighter{id = Tid, pid = Tpid},
    ActionEffectFunc = #action_effect_func{dmg_mp = DmgMpFunc, restore_self_hp = RestoreSelfHpFunc, can_pet_protect = CanPetProtect}
) ->
    {_, Self = #fighter{name = _Sname, hp = Shp, hp_max = ShpMax, anger_max = SangerMax, is_nocrit = IsNoCrit, power_max = SpowerMax, is_undying = SisUndying}} = combat:f(by_pid, Spid),
    {_, Target = #fighter{name = _Tname, hp = Thp, mp = Tmp, mp_max = TmpMax, anger_max = TangerMax, is_defencing = IsDefencing, buff_round = TBuffRound, is_sleep = IsSleep}} = combat:f(by_pid, Tpid),
    Tpet = combat:f_pet(Tpid),
    OtherCostHp = combat_util:get_other_cost(hp, OtherCost),
    %%
    combat:add_to_hit_history(Spid, 1, 0),
    %%------------------------------------------------------
    %% 计算总伤害
    %%------------------------------------------------------
    %% 计算伤害
    %% 判断攻击是否击中
    CanHit = is_hit(Skill, Self, Target),
    CanCrit = IsNoCrit =:= ?false,
    %% 被动技能：减法伤
    DmgMagicReduce = passive_activate({target, reduce_magic_dmg}, Self, Target, {val, 0}),
    %% 被动技能：任何伤害都有附加效果(任何伤害都加暴击)
    {DmgSkill} = passive_activate({self, skill_enhance}, Self, Target, {Skill}),
    %%
    {TmpSelfDmgHp, IsCrit, IsHit} = dmg(DmgSkill, Self, Target, ActionEffectFunc#action_effect_func{dmg_can_crit = CanCrit, dmg_magic_reduce = DmgMagicReduce, dmg_can_hit = CanHit}),
    ?logv(TmpSelfDmgHp),
    %% 被动技能：附加伤害
    TmpSelfDmgHp2 = case TargetNum > 1 of
        true -> TmpSelfDmgHp;
        false -> 
            {TmpSelfDmgHp_} = passive_activate({target, raise_dmg}, Self, Target, {TmpSelfDmgHp}),
            TmpSelfDmgHp_
    end,
    %% buff效果: 加伤害
    %{TmpSelfDmgHp2, _} = buff_passive_effect(raise_dmg, self, Self, Target, {TmpSelfDmgHp1, IsHit}),

    %%------------------------------------------------------
    %% 计算伤害减免
    %%------------------------------------------------------
    %% 对方防御
    TmpSelfDmgHp3 = case IsDefencing of
        ?true -> round(TmpSelfDmgHp2 * 0.8);
        ?false -> TmpSelfDmgHp2
    end,

    %% 对方宠物技能：保护(减伤)
    {IsProtectedByPet, DmgHpReduceByPet, PetProtectCostMp, FeedbackDmgByPet} = case CanPetProtect of
        true -> combat_script_pet:protect_master(dmg_reduce, Target, Self, [TmpSelfDmgHp3, 0]);
        false -> {false, 0, 0, 0}
    end,
    SelfDmgHp = TmpSelfDmgHp3 - DmgHpReduceByPet,

    %% 被动技能：减伤或者吸收伤害
    {TmpTotalHpDmg, TmpTotalMpDmg1, _, IsMiss} = passive_activate({target, reduce_dmg}, Self, Target, {SelfDmgHp, 0, IsHit, _IsMiss=?false}),
    TmpTotalMpDmg2 = ?EXEC_FUNC(DmgMpFunc, 0, []),
    TotalMpDmg = TmpTotalMpDmg1 + TmpTotalMpDmg2,

    %% 保护者受到伤害 
    {IsProtected, TotalHpDmg1, ProtectorDmg, Protector4, IsProtectorDie} = case is_protected(Target) of
        {true, Protector, ProtectorRatio} ->
            #fighter{pid = ProtPid, hp = ProtectorHp, name = _ProtName} = Protector,
            combat:add_to_hit_history(ProtPid, 0, 1),
            ProtDmg = round(TmpTotalHpDmg * ProtectorRatio / 100),
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
            ?DEBUG("保护者[~s]受到了[~w]点伤害，剩余血量[~w]", [_ProtName, ProtDmg, NewProtectorHp]),
            {true, TmpTotalHpDmg - ProtDmg, ProtDmg, Protector3, IsDie};
        {false, _} -> {false, TmpTotalHpDmg, 0, undefined, ?false}
    end,

    %% 仙宠减伤被动技能触发
    {ThpDmgReduce, _TotalMpDmgReduce} = combat_script_pet:passive_activate(dmg_reduce, Self, Target, [{0, 0}, TotalHpDmg1]),
    RealHpDmg = TotalHpDmg1 - ThpDmgReduce,  %% RealHpDmg = 按攻击者攻击力和被攻击者防御算出来的理想伤害(没有算上盾的抵消)

    %% 护盾
    {IsShield, TotalHpDmg, ShieldReduce} = use_shield(Tpid, RealHpDmg),  %% TotalHpDmg = 角色实际受到的伤害（算上盾抵消的伤害）(可能会超过角色气血上限) 
    AttackDmgOutput = case IsShield of %% 攻击者实际攻击效果(包含对人的伤害和对盾的伤害，如果有盾，不能超出盾的容量)(反弹应该用这个作基数去算)
        true -> ShieldReduce;
        _ -> TotalHpDmg
    end,

    %% 伤害前执行
    passive_activate({target, before_dmg}, Self, Target, {TotalHpDmg}),
    {_, #fighter{is_undying = TisUndying}} = combat:f(by_pid, Tpid),

    %%------------------------------------------------------
    %% 计算伤害反馈
    %%------------------------------------------------------
    %% 被攻击者受到伤害
    NewThp0 = Thp - TotalHpDmg,
    %% 濒死状态/不死状态
    NewThp = case NewThp0 < 0 andalso TisUndying =:= ?true of
        true -> 1;  %% 濒死状态，最后气血总为1
        false -> NewThp0
    end,
    NewTmp = combat_util:check_range(Tmp - TotalMpDmg, 0, TmpMax),
    SkillSelfRestoreHp = ?EXEC_FUNC(RestoreSelfHpFunc, 0, [TotalHpDmg]),
    {_Dmg, BuffSelfRestoreHp} = buff_passive_effect(restore_after_hit, self, Self, Target, {TotalHpDmg, 0}),
    SelfRestoreHp = SkillSelfRestoreHp + BuffSelfRestoreHp,
    SkillPlay = case SelfRestoreHp > 0 of
        true -> Skill#c_skill{show_type = [{hp, 1}, {mp, 0}]};  %% 行动中播放加血
        false -> Skill
    end,
    combat:add_to_hit_history(Tpid, 0, 1),
    combat:save_master_dmg(Spid, TotalHpDmg, TotalMpDmg),
    combat:add_role_to_npc_dmg(Self, Target, TotalHpDmg),
    combat:add_npc_to_role_dmg(Self, Target, TotalHpDmg),
    combat:add_role_to_role_dmg(Self, Target, TotalHpDmg),
    combat:add_demon_to_npc_dmg(Self, Target, TotalHpDmg),
    %% ?DEBUG("[~s]受到了[~w,~w]点伤害，剩余血量和魔法[~w,~w]", [_Tname, TotalHpDmg, TotalMpDmg, NewThp, NewTmp]),
    if
        NewThp < 1 ->
            %% 修改相关血量和魔量
            combat:update_fighter(Tpid, [{hp, 0}, {mp, NewTmp}, {anger, 0}, {power, 0}, {is_die, ?true}]),

            NewShp = combat_util:check_range(Shp + SelfRestoreHp, 0, ShpMax),
            case Spid =/= Tpid of
                true ->
                    combat:update_fighter(Spid, [{hp, NewShp}]);
                false -> ignore
            end,
            IsSelfDie = combat_util:is_die(NewShp),

            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 宠物复活自己
            {IsTargetDie, IsPetReviveSelf, ReviveSelfSkill, HealHp} = case combat_script_pet:passive_activate(revive_self, Target, Target, [TotalHpDmg]) of
                {true, ReviveSelfSkill1, HealHp1} -> {?false, true, ReviveSelfSkill1, HealHp1};
                _ -> {?true, false, undefined, 0}
            end,

            %% 播放攻击动作
            IsHitOrMiss = case IsMiss of
                ?true -> ?combat_miss;
                ?false -> IsHit
            end,
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, SkillPlay, SelfRestoreHp - OtherCostHp, -TotalHpDmg, -TotalMpDmg, -TangerMax, IsCrit, IsHitOrMiss, IsSelfDie, IsTargetDie)),
            %% 判断夫妻/合体技能
            check_partner_skill(Self, Target, Skill, IsCrit, ?true, ?true),  
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
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false ->
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}]),
                            ?false
                    end,
                    combat:add_sub_play(combat:gen_sub_play(protect, Tpet, Target, -DmgHpReduceByPet, -PetProtectCostMp, IsTpetDie));
                true -> ignore
            end,

            %% 播放宠物复活自己的动作
            case IsPetReviveSelf of
                true -> combat:add_to_pet_revive(ReviveSelfSkill, Target, HealHp);
                false -> ignore
            end;
        true ->
            %% 修改对方血量和魔量
            combat:update_fighter(Tpid, [{hp, NewThp}, {mp, NewTmp}, {is_sleep, ?false}]),

            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 对方宠物被动技能
            combat_script_pet:passive_activate(buff_after_hit, Self, Target, [AttackType, TotalHpDmg]),

            %% 击中对方触发被动技能
            passive_activate({self, after_hit}, Self, Target, {AttackType, TotalHpDmg, IsHit}),

            %% 被击中触发被动技能
            passive_activate({target, be_hit}, Self, Target, {AttackType, TotalHpDmg, IsHit}),

            %% 被动技能：buff和怒气
            {AngerChanged, PowerChanged} = anger_passive_activate(buff_after_hit, Self, Target, [AttackType, TotalHpDmg]),

            %% 被动技能：被直接命中导致生命低于一定百分比时触发
            passive_activate({target, hp_below}, Self, Target, {}),

            NewShp0 = combat_util:check_range(Shp + SelfRestoreHp, 0, ShpMax),
            IsSelfDie = combat_util:is_die(NewShp0),

            %% 播放攻击动作
            IsHitOrMiss = case IsMiss of
                ?true -> ?combat_miss;
                ?false -> IsHit
            end,
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, SkillPlay, SelfRestoreHp - OtherCostHp, -TotalHpDmg, -TotalMpDmg, AngerChanged, IsCrit, IsHitOrMiss, IsSelfDie, ?false, PowerChanged)),
            %% 判断夫妻/合体技能
            check_partner_skill(Self, Target, Skill, IsCrit, ?true, ?false),  

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
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false -> 
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}]),
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
                    end,
                    case f(by_buffid, TBuffRound, 200051) of
                        undefined -> ignore;
                        SleepBuff1 -> combat:buff_del(SleepBuff1, Tpid)
                    end;
                _ -> ignore
            end,

            %% 判断被攻击者是否中技能附带的BUFF
            AllBuffTarget = BuffTarget ++ EqmGsBuffTarget,
            lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, AllBuffTarget),

            %% 被动技能：反弹伤害
            {_, Self1} = combat:f(by_pid, Spid),
            {IsFeedback, FeedbackDmg} = feedback_dmg(Self1, Target, [AttackType, AttackDmgOutput, IsHit, FeedbackDmgByPet]),
            ShpAfterFeedback0 = NewShp0 - FeedbackDmg,
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
                    %% ?DEBUG("[~s]被反弹了[~w]点伤害", [_Sname, FeedbackDmg]),
                    case IsFeedbackKilled of
                        ?true -> %% 如果被反伤杀死则对方不会再反击
                            combat:update_fighter(Spid, [{hp, 0}, {is_die, ?true}, {anger, 0}, {power, 0}]),
                            combat:add_sub_play(combat:gen_sub_play(feedback, Target, Self2, -FeedbackDmg, ?false, ?true));

                        ?false -> %% 没有被反伤杀死则继续判断反击
                            combat:add_sub_play(combat:gen_sub_play(feedback, Target, Self, -FeedbackDmg, ?false, ?false)),

                            %% 反击 
                            {IsAntiAtk, {AntiAtkDmg, AntiAtkCrit}, AntiAtkHit} = anti_attack(Skill, Self, Target, ActionEffectFunc),
                            case IsAntiAtk of
                                true ->
                                    NewShp1 = combat_util:check_range(ShpAfterFeedback - AntiAtkDmg, 0, ShpMax),
                                    NewShp = case NewShp1 =< 0 andalso SisUndying =:= ?true of
                                        true -> 1;
                                        false -> NewShp1
                                    end,
                                    IsSelfDie1 = combat_util:is_die(NewShp),
                                    %% ?DEBUG("[~s]反击[~s]，使其受到[~w]点伤害", [_Tname, _Sname, AntiAtkDmg]),
                                    combat:add_to_hit_history(Spid, 0, 1),
                                    {AntiAtkAngerChanged, AntiPowerChanged} = case IsSelfDie1 of
                                        ?true ->
                                            combat:update_fighter(Spid, [{hp, NewShp}, {anger, 0}, {power, 0}]),
                                            {-SangerMax, -SpowerMax};
                                        _ ->
                                            V = anger_calc(Spid, AntiAtkDmg),
                                            PV = combat_util:power_calc(Spid, AntiAtkDmg),
                                            combat:update_fighter(Spid, [{hp, NewShp}, {anger_changed, V}, {power_changed, PV}]),
                                            {V, PV}
                                    end,
                                    combat:add_sub_play(combat:gen_sub_play(anti_attack, Target, Self2, -AntiAtkDmg, AntiAtkAngerChanged, AntiAtkCrit, AntiAtkHit, IsSelfDie1, AntiPowerChanged));
                                false ->
                                    NewShp1 = combat_util:check_range(ShpAfterFeedback, 0, ShpMax),
                                    NewShp = case NewShp1 =< 0 andalso SisUndying =:= ?true of
                                        true -> 1;
                                        false -> NewShp1
                                    end,
                                    combat:update_fighter(Spid, [{hp, NewShp}])
                            end
                    end;
                false -> %% 没有反伤就直接判断反击 
                    {IsAntiAtk, {AntiAtkDmg, AntiAtkCrit}, AntiAtkHit} = anti_attack(Skill, Self2, Target, ActionEffectFunc),
                    case IsAntiAtk of
                        true ->
                            NewShp1 = combat_util:check_range(ShpAfterFeedback - AntiAtkDmg, 0, ShpMax),
                            NewShp = case NewShp1 =< 0 andalso SisUndying =:= ?true of
                                true -> 1;
                                false -> NewShp1
                            end,
                            IsSelfDie1 = combat_util:is_die(NewShp),
                            %% ?DEBUG("[~s]反击[~s]，使其受到[~w]点伤害", [_Tname, _Sname, AntiAtkDmg]),
                            combat:add_to_hit_history(Spid, 0, 1),
                            {AntiAtkAngerChanged, AntiPowerChanged} = case IsSelfDie1 of
                                ?true ->
                                    combat:update_fighter(Spid, [{hp, NewShp}, {anger, 0}, {power, 0}]),
                                    {-SangerMax, -SpowerMax};
                                _ ->
                                    V = anger_calc(Spid, AntiAtkDmg),
                                    PV = combat_util:power_calc(Spid, AntiAtkDmg),
                                    combat:update_fighter(Spid, [{hp, NewShp}, {anger_changed, V}, {power_changed, PV}]),
                                    {V, PV}
                            end,
                            combat:add_sub_play(combat:gen_sub_play(anti_attack, Target, Self2, -AntiAtkDmg, AntiAtkAngerChanged, AntiAtkCrit, AntiAtkHit, IsSelfDie1, AntiPowerChanged));
                        false ->
                            NewShp1 = combat_util:check_range(ShpAfterFeedback, 0, ShpMax),
                            NewShp = case NewShp1 =< 0 andalso SisUndying =:= ?true of
                                true -> 1;
                                false -> NewShp1
                            end,
                            combat:update_fighter(Spid, [{hp, NewShp}])
                    end
            end
    end,
    ok.

%% 精灵化形攻击
%% （一定命中）
demon_attack(Skill, #fighter{pid = Spid}, Target) ->
    {_, Self} = combat:f(by_pid, Spid),
    #fighter_ext_role{demon_shape_dmg = DemonShapeDmg, demon_shape_dmg_magic = DemonShapeDmgMagic, passive_skills = PassiveSkills} = combat:f_ext(by_pid, Spid),
    %% 震怒技能加成
    RateAdd= case f(by_scriptid, PassiveSkills, 10650) of
        #c_skill{args = [Val]} -> Val;
        _ -> 1 
    end,
    ?DEBUG("震怒加 ~w", [RateAdd]),
    do_demon_attack(Skill, Self, Target, #action_effect_func{}, [round(DemonShapeDmg * RateAdd / 100), round(DemonShapeDmgMagic * RateAdd / 100), demon]).

do_demon_attack(
    Skill = #c_skill{attack_type = AttackType, buff_target = BuffTarget},
    Self = #fighter{pid = Spid, attr_ext = #attr_ext{buff_target_on_attack = EqmGsBuffTarget}},
    #fighter{id = Tid, pid = Tpid},
    ActionEffectFunc,
    [DemonShapeDmg, DemonShapeDmgMagic, _ByWho]
) ->
    #fighter{name = _Sname, hp = Shp, hp_max = ShpMax, is_nocrit = IsNoCrit, attr = Attr} = Self,
    {_, Target = #fighter{name = _Tname, hp = Thp, is_defencing = IsDefencing, anger_max = TangerMax, buff_round = TBuffRound, is_sleep = IsSleep}} = combat:f(by_pid, Tpid),
    Tpet = combat:f_pet(Tpid),

    %%------------------------------------------------------
    %% 计算总伤害
    %%------------------------------------------------------
    CanHit = true,  %% 100% 命中
    CanCrit = IsNoCrit =:= ?false,
    %% 被动技能：减法伤
    DmgMagicReduce = passive_activate({target, reduce_magic_dmg}, Self, Target, {val, 0}),
    %% 被动技能：任何伤害都有附加效果(任何伤害都加暴击)
    {DmgSkill} = passive_activate({self, skill_enhance}, Self, Target, {Skill}),
    %%
    %% 计算伤害
    {TmpSelfDmgHp, IsCrit, IsHit} = dmg(DmgSkill, Self#fighter{attr = Attr#attr{dmg_min = DemonShapeDmg, dmg_max = DemonShapeDmg, dmg_magic = DemonShapeDmgMagic}}, Target, ActionEffectFunc#action_effect_func{dmg_can_crit = CanCrit, dmg_magic_reduce = DmgMagicReduce, dmg_can_hit = CanHit}),

    %%------------------------------------------------------
    %% 计算伤害减免
    %%------------------------------------------------------
    %% 对方防御
    TmpSelfDmgHp2 = case IsDefencing of
        ?true -> round(TmpSelfDmgHp * 0.8);
        ?false -> TmpSelfDmgHp
    end,

    %% 对方宠物技能：保护(减伤)
    {IsProtectedByPet, DmgHpReduceByPet, PetProtectCostMp, _FeedbackDmgByPet} = combat_script_pet:protect_master(dmg_reduce, Target, Self, [TmpSelfDmgHp2, 0]),
    SelfDmgHp = TmpSelfDmgHp2 - DmgHpReduceByPet,

    %% 被动技能：减伤或者吸收伤害
    {TmpTotalHpDmg, _, _, _IsMiss} = passive_activate({target, reduce_dmg}, Self, Target, {SelfDmgHp, 0, IsHit, _IsMiss=?false}),

    %% 保护者受到伤害 
    {IsProtected, TotalHpDmg, ProtectorDmg, Protector4, IsProtectorDie} = case is_protected(Target) of
        {true, Protector, ProtectorRatio} ->
            #fighter{pid = ProtPid, hp = ProtectorHp, name = _ProtName} = Protector,
            combat:add_to_hit_history(ProtPid, 0, 1),
            ProtDmg = round(TmpTotalHpDmg * ProtectorRatio / 100),
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
            ?DEBUG("保护者[~s]受到了[~w]点伤害，剩余血量[~w]", [_ProtName, ProtDmg, NewProtectorHp]),
            {true, TmpTotalHpDmg - ProtDmg, ProtDmg, Protector3, IsDie};
        {false, _} -> {false, TmpTotalHpDmg, 0, undefined, ?false}
    end,

    %% 伤害前执行
    passive_activate({target, before_dmg}, Self, Target, {TotalHpDmg}),
    {_, #fighter{is_undying = TisUndying}} = combat:f(by_pid, Tpid),

    %%------------------------------------------------------
    %% 计算伤害反馈
    %%------------------------------------------------------
    %% 被攻击者受到伤害
    NewThp0 = Thp - TotalHpDmg,
    %% 濒死状态/不死状态
    NewThp = case NewThp0 < 0 andalso TisUndying =:= ?true of
        true -> 1;  %% 濒死状态，最后气血总为1
        false -> NewThp0
    end,
    combat:save_master_dmg(Spid, TotalHpDmg, 0),
    combat:add_role_to_npc_dmg(Self, Target, TotalHpDmg),
    combat:add_role_to_role_dmg(Self, Target, TotalHpDmg),
    combat:add_demon_to_npc_dmg(Self, Target, TotalHpDmg),
    %% ?DEBUG("[~s]受到了[~w,~w]点伤害，剩余血量和魔法[~w,~w]", [_Tname, TotalHpDmg, TotalMpDmg, NewThp, NewTmp]),
    if
        NewThp < 1 ->
            %% 修改相关血量和魔量
            combat:update_fighter(Tpid, [{hp, 0}, {anger, 0}, {power, 0}, {is_die, ?true}]),

            case Spid =/= Tpid of
                true ->
                    NewShp = combat_util:check_range(Shp, 0, ShpMax),
                    combat:update_fighter(Spid, [{hp, NewShp}]);
                false -> ignore
            end,

            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 宠物复活自己
            {IsTargetDie, IsPetReviveSelf, ReviveSelfSkill, HealHp} = case combat_script_pet:passive_activate(revive_self, Target, Target, [TotalHpDmg]) of
                {true, ReviveSelfSkill1, HealHp1} -> {?false, true, ReviveSelfSkill1, HealHp1};
                _ -> {?true, false, undefined, 0}
            end,

            %% 播放攻击动作
            combat:add_sub_play(combat:gen_sub_play(demon_attack, Self, Target, Skill, 0, -TotalHpDmg, 0, -TangerMax, IsCrit, ?true, IsTargetDie)),
              
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
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false ->
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}]),
                            ?false
                    end,
                    combat:add_sub_play(combat:gen_sub_play(protect, Tpet, Target, -DmgHpReduceByPet, -PetProtectCostMp, IsTpetDie));
                true -> ignore
            end,

            %% 播放宠物复活自己的动作
            case IsPetReviveSelf of
                true -> combat:add_to_pet_revive(ReviveSelfSkill, Target, HealHp);
                false -> ignore
            end;
        true ->
            %% 修改对方血量和魔量
            combat:update_fighter(Tpid, [{hp, NewThp}, {is_sleep, ?false}]),

            %% 防御技能作为被动技能特效播放
            if
                IsDefencing =:= ?true ->
                    combat:add_to_show_passive_skills(Tid, ?skill_defence, ?show_passive_skills_hit);
                true -> ignore
            end,

            %% 对方宠物被动技能
            combat_script_pet:passive_activate(buff_after_hit, Self, Target, [AttackType, TotalHpDmg]),

            %% 击中对方触发被动技能
            passive_activate({self, after_hit}, Self, Target, {AttackType, TotalHpDmg, IsHit}),

            %% 被击中触发被动技能
            passive_activate({target, be_hit}, Self, Target, {AttackType, TotalHpDmg, IsHit}),

            %% 被动技能：buff和怒气
            {AngerChanged, PowerChanged} = case anger_passive_activate(buff_after_hit, Self, Target, [AttackType, TotalHpDmg]) of
                {AngerVal, PowerVal} -> {AngerVal, PowerVal};
                _ -> {0, 0}
            end,

            %% 被动技能：被直接命中导致生命低于一定百分比时触发
            passive_activate({target, hp_below}, Self, Target, {}),

            %% 播放攻击动作
            combat:add_sub_play(combat:gen_sub_play(demon_attack, Self, Target, Skill, 0, -TotalHpDmg, 0, AngerChanged, IsCrit, ?true, ?false, PowerChanged)),

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
                            combat:update_fighter(TpetPid, [{hp, 0}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}, {is_die, ?true}]),
                            ?true;
                        false -> 
                            combat:update_fighter(TpetPid, [{hp, TpetHp - DmgHpReduceByPet}, {mp, combat_script_pet:cost_mp_cal(Tpet, PetProtectCostMp)}]),
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

            %% 判断被攻击者是否中技能附带的BUFF
            lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffTarget ++ EqmGsBuffTarget)
    end,
    ok.


%% 治疗处理
heal(
    Skill = #c_skill{other_cost = OtherCost},
    Self = #fighter{pid = Spid, name = _Sname},
    #fighter{pid = Tpid},
    HealHp
) ->
    OtherCostHp = combat_util:get_other_cost(hp, OtherCost),
    case OtherCostHp > 0 of
        true -> combat:update_fighter(Spid, [{hp_changed, -OtherCostHp}]);
        false -> ignore
    end,
    {_, Target = #fighter{name = _Tname, hp = Thp, hp_max = ThpMax, is_die = IsTargetDie}} = combat:f(by_pid, Tpid),
    HealHp1 = combat_util:calc_heal(Target, HealHp),
    BaseHp = combat_util:check_range(Thp, 0, Thp),
    NewThp = combat_util:check_range(BaseHp + HealHp1, 0, ThpMax),
    %% ?DEBUG("[~s]被[~s]治疗了[~w]点，剩余血量[~w]", [_Tname, _Sname, RealHealHp, NewThp]),
    combat:update_fighter(Tpid, [{hp, NewThp}]),
    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, -OtherCostHp, HealHp1, 0, 0, ?false, ?true, IsTargetDie)),        
    ok.

%% 回蓝处理
heal_mp(
    Skill = #c_skill{other_cost = OtherCost},
    Self = #fighter{pid = Spid, name = _Sname},
    #fighter{pid = Tpid},
    HealMp
) ->
    OtherCostHp = combat_util:get_other_cost(hp, OtherCost),
    case OtherCostHp > 0 of
        true -> combat:update_fighter(Spid, [{hp_changed, -OtherCostHp}]);
        false -> ignore
    end,
    {_, Target = #fighter{name = _Tname, hp = Tmp, hp_max = TmpMax, is_die = IsTargetDie}} = combat:f(by_pid, Tpid),
    HealMp1 = combat_util:calc_heal(Target, HealMp),
    BaseMp = combat_util:check_range(Tmp, 0, Tmp),
    NewTmp = combat_util:check_range(BaseMp + HealMp1, 0, TmpMax),
    %% ?DEBUG("[~s]被[~s]治疗了[~w]点法力，剩余法力[~w]", [_Tname, _Sname, HealMp1, NewTmp]),
    combat:update_fighter(Tpid, [{mp, NewTmp}]),
    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, -OtherCostHp, 0, HealMp1, 0, ?false, ?true, IsTargetDie)),        
    ok.

%% 施法
cast(
    Skill = #c_skill{id = _Id, buff_target = BuffTarget},
    Self = #fighter{name = _Sname, is_silent = ?false},
    Target = #fighter{name = _Tname}
) ->
    case is_hit(Skill, Self, Target) of
        true ->
            ?log("[~s]对[~s]施放了Id=[~w]的法术", [_Sname, _Tname, _Id]),

            %% 判断被攻击者是否中技能附带的BUFF
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?true, ?false)),
            lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffTarget);
        false ->
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?false, ?false))
            %%?DEBUG("[~s]对[~s]施放了Id=[~w]的法术，但是没有命中", [_Tname, _Sname, _Id])
    end,
    ok;
cast(_Skill, _Self = #fighter{name = _Sname}, _Target) ->
    %% ?DEBUG("[~s]处于沉默状态，无法施放法术", [_Sname]),
    ok.

%% 说话
talk(Skill, Self, Target) ->
    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?true, ?false)),
    ok.

%% 逃跑处理
escape(Skill, 
    #fighter{name = _Name, pid = Spid}, 
    _Target
) ->
    {_, Self = #fighter{attr = #attr{escape_rate = EscapeRate}}} = combat:f(by_pid, Spid),
    IsHit = case util:rand(1, 100) =< EscapeRate of
        false -> ?false;
        true ->
            %% ?DEBUG("[~s]已经逃离战场", [_Name]),
            combat:update_fighter(Spid, [{is_escape, ?true}]),
            case combat:f_pet(Spid) of
                #fighter{pid = SpetPid, type = ?fighter_type_pet}-> combat:update_fighter(SpetPid, [{is_escape, ?true}]);
                _ -> ignore
            end,
            combat:escape_with_story_npcs(Self),
            combat:escape_with_demon(Self),
            ?true
    end,
    combat:add_sub_play(combat:gen_sub_play(attack, Self, Self, Skill, 0, 0, 0, 0, ?false, IsHit, ?false)),
    ok.

%% 防御
defence(_Skill, 
    #fighter{name = _Sname, pid = Spid},
    _Target
) ->
    %% ?DEBUG("[~s]采取了防御", [_Sname]),
    combat:update_fighter(Spid, [{is_defencing, ?true}]),
    ok.

%% 保护
protect(_, #fighter{pid = Spid, name = _Sname}, #fighter{pid = Tpid, name = _Tname}) ->
    if 
        Spid =:= Tpid -> %% 不能对自己使用保护
            %% ?DEBUG("[~s]不能对自己施加保护", [_Sname]),
            ignore;
        true ->
            %% ?DEBUG("[~s]对[~s]采取了保护", [_Sname, _Tname]),
            combat:update_fighter(Tpid, [{protector_pid, {Spid, 60}}])
    end,
    ok.

%% 使用物品
use_item(#c_skill{special = Special}, Self = #fighter{name = _Name, pid = Spid}, Target) ->
    case lists:keyfind(0, 1, Special) of
        {0, ItemBaseId} ->
            %% ?DEBUG("[~s]使用了物品[~w]", [_Name, ItemBaseId]),
            case combat:f_ext(by_pid, Spid) of
                #fighter_ext_role{items = Items} ->
                    case f(by_itembaseid, Items, ItemBaseId) of
                        undefined -> ?ERR("无法使用不存在的物品[~w]", [ItemBaseId]);
                        Item = #c_item{action = Action} ->
                            combat:add_to_item_use_history(Spid, ItemBaseId),
                            case Action of
                                undefined -> 
                                    %% ?DEBUG("物品[~w]没有定义使用效果", [ItemBaseId]),
                                    ok;
                                _ -> Action(Item, Self, Target)
                            end
                    end;
                _ -> ignore
            end;
        _ -> ignore
    end,
    ok.

%% 抓宠
catch_pet(Skill, Self = #fighter{pid = Spid, name = _Sname}, Target = #fighter{name = _Tname, pid = Tpid}) ->
    case util:rand(1, 100) =< 100 of %% 80 of
        true ->
            case combat:f(by_pid, Spid) of
                {_, Self1} ->
                    case combat:f(by_pid, Tpid) of
                        {_, Target1} ->
                            Fext = #fighter_ext_role{pet_num = PetNum} = combat:f_ext(by_pid, Spid),
                            #fighter_ext_npc{npc_base_id = NpcBaseId} = combat:f_ext(by_pid, Tpid),
                            combat:u_ext(Fext#fighter_ext_role{pet_num = PetNum + 1}),
                            combat:update_fighter(Tpid, [{is_die, ?true}]),
                            combat:add_to_catch_pet_history(Spid, NpcBaseId),
                            combat:add_sub_play(combat:gen_sub_play(attack, Self1, Target1, Skill, 0, 0, 0, 0, ?false, ?true, ?true));
                        %% ?DEBUG("[~s]抓取[~s]成功", [_Sname, _Tname]);
                        true ->
                            %% ?DEBUG("[~s]抓取[~s]失败，根据Tpid=~w找不到目标", [_Sname, _Tname, Tpid]),
                            ignore
                    end;
                _ ->
                    ?ERR("[~s]抓取[~s]失败，根据Spid=~w找不到目标", [_Sname, _Tname, Spid]),
                    ignore
            end;
        false ->
            ?ERR("[~s]抓取[~s]失败", [_Sname, _Tname]),
            combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, 0, 0, 0, ?false, ?false, ?false))           
    end,
    ok.

%% 召唤宠物(切换宠物)
summon_pet(Skill = #c_skill{special = Special}, Self = #fighter{name = _Name, pid = Spid}, _Target) ->
    case lists:keyfind(1, 1, Special) of
        {1, PetId} ->
            case combat:f_ext(by_pid, Spid) of
                Fext = #fighter_ext_role{active_pet = ActivePet, backup_pets = BackupPets} ->
                    case lists:keyfind(PetId, #c_pet.id, BackupPets) of
                        NewActivePet when is_record(NewActivePet, c_pet) ->
                            %% 收回当前出战宠物，切换成选择的宠物
                            BL = case ActivePet of
                                undefined -> lists:keydelete(PetId, #c_pet.id, BackupPets);
                                _ ->
                                    ActivePet1 = ActivePet#c_pet{can_summon = ?false},
                                    BackupPets1 = lists:keydelete(PetId, #c_pet.id, BackupPets),
                                    [ActivePet1|BackupPets1]
                            end,
                            Fext1 = Fext#fighter_ext_role{active_pet = NewActivePet, backup_pets = BL},
                            combat:u_ext(Fext1),
                            {Fpet, FpetExt} = combat:switch_pet(NewActivePet),
                            %% 生成播报
                            combat:add_sub_play(combat:gen_sub_play(attack, Self, Self, Skill, 0, 0, 0, 0, ?false, ?true, ?false)),
                            combat:add_sub_play(combat:gen_summon_sub_play(NewActivePet, Fpet, FpetExt));
                        _ -> ?ERR("[~s]召唤宠物失败", [_Name])
                    end;
                _ -> ?ERR("[~s]召唤宠物失败", [_Name])
            end;
        _ -> ignore
    end,
    ok.

%%----------------------------------------------------
%% 命中计算函数
%%----------------------------------------------------
is_hit(   %% 辅助技能，命中100%
    #c_skill{skill_type = ?skill_type_assist},
    _Self,
    _Target) ->
    true;
is_hit(
    #c_skill{hitrate_ratio = SkHitRatio, hitrate_low = SkHitRateMin, hitrate_max = SkHitRateMax, hitrate_reduce = SkHitRateReduce},
    #fighter{attr = #attr{hitrate = HitRate}},
    #fighter{attr = #attr{evasion = Evasion}}
) ->
    H1 = Evasion - (HitRate - SkHitRateReduce),
    H2 = case H1 >= 300 of
        true ->
            500 + 100 * 300 / H1;
        false ->
            900 - H1
    end,
    Hr = H2 * SkHitRatio / 1000, 
    FinalHitRate = util:check_range(Hr, SkHitRateMin, SkHitRateMax),
    util:rand(1, 10000) < FinalHitRate * 10;
is_hit(
    #c_pet_skill{},
    #fighter{attr = #attr{hitrate = HitRate}},
    #fighter{attr = #attr{evasion = Evasion}}
) ->
    Hr = (900 + HitRate - Evasion),
    util:rand(1, 10000) < Hr * 10.


%%----------------------------------------------------
%% 反击计算函数
%%----------------------------------------------------
anti_attack(Skill, Self, Target) -> anti_attack(Skill, Self, Target, #action_effect_func{}).
anti_attack(
    Skill, 
    Self, 
    #fighter{pid = Tpid}, 
    #action_effect_func{anti_attack_before = AntiAttackBefore}
) ->
    AttackType = case Skill of
        #c_skill{attack_type = AttackType1} -> AttackType1;
        #c_pet_skill{attack_type = AttackType2} -> AttackType2;
        _ -> ?attack_type_range
    end,
    case combat:f(by_pid, Tpid) of
        {_, #fighter{is_stun = IsStun, is_sleep = IsSleep, is_stone = IsStone, career = Career}} when (IsStun =:= ?true) orelse (IsSleep =:= ?true) orelse (IsStone =:= ?true) orelse (AttackType =:= ?attack_type_range) orelse (Career =:= ?career_xianzhe) orelse (Career =:= ?career_feiyu) ->
            {false, {0, ?false}, ?false};
        {_, Target = #fighter{is_nocrit = IsNoCrit, attr = #attr{anti_attack = AntiRate}}} ->
            RealAntiRate = ?EXEC_FUNC(AntiAttackBefore, AntiRate, [AntiRate]),
            case util:rand(1, 100) =< RealAntiRate of
                true -> 
                    CanHit = is_hit(Skill, Target, Self),
                    DmgCanCrit = case IsNoCrit of
                        ?true -> false;
                        _ -> true
                    end,
                    {Dmg, IsCrit, IsHit} = dmg(#c_skill{}, Target, Self, #action_effect_func{dmg_can_crit = DmgCanCrit, dmg_can_hit = CanHit}),
                    {true, {Dmg, IsCrit}, IsHit};
                false -> {false, {0, ?false}, ?false}
            end;
        _ -> {false, {0, ?false}, ?false}
    end.


%%----------------------------------------------------
%% 保护计算函数
%%----------------------------------------------------
is_protected(#fighter{protector_pid = undefined}) -> {false, undefined};
is_protected(#fighter{protector_pid = {ProtectorPid, ProtectorRatio}}) ->
    case combat:f(by_pid, ProtectorPid) of
        {_, Protector = #fighter{is_taunt = ?false, is_die = ?false, is_stun = ?false, is_sleep = ?false, is_stone = ?false}} ->
            {true, Protector, ProtectorRatio};
        _ ->
            {false, undefined}
    end.

%%----------------------------------------------------
%% 伤害计算函数
%%----------------------------------------------------
dmg(
    #c_skill{dmg_magic = SkDmgMagic, dmg_ratio = SkDmgRatio, elem_type = ElemType, crit_dmg_ratio = CritDmgRatio, critrate_ratio = CritrateRatio},
    #fighter{lev = Lv, super_crit = IsSuperCrit, attr = #attr{dmg_min = _DmgMin, dmg_max = DmgMax, dmg_magic = DmgMagic, critrate = Crit}},
    #fighter{attr = Tattr = #attr{tenacity = Ten, injure_ratio = InjureRatio}, is_stone = IsStone, stone_dmg_reduce_ratio = StoneDmgReduceRatio},
    #action_effect_func{dmg_adjust = _DmgAdjust, dmg_before_crit = DmgBeforeCrit, dmg_after_crit = DmgAfterCrit, dmg_can_crit = DmgCanCrit, dmg_hp = DmgHpFunc, dmg_hp_max = DmgHpMaxFunc, dmg_magic_reduce = DmgMagicReduce, dmg_can_hit = CanHit, dmg_after_hit = DmgAfterHitFunc}
) ->
    {Ac, Absorb} = case ElemType of
        ?elem_type_metal -> {Tattr#attr.resist_metal, Tattr#attr.asb_metal};
        ?elem_type_wood -> {Tattr#attr.resist_wood, Tattr#attr.asb_wood};
        ?elem_type_water -> {Tattr#attr.resist_water, Tattr#attr.asb_water};
        ?elem_type_fire -> {Tattr#attr.resist_fire, Tattr#attr.asb_fire};
        ?elem_type_earth -> {Tattr#attr.resist_earth, Tattr#attr.asb_earth};
        _ -> {Tattr#attr.defence, 0}
    end,
    Ar = Ac / (Ac + 60 * Lv + 2000),
    MH = util:check_range(DmgMagic + SkDmgMagic - Absorb, 0, DmgMagic + SkDmgMagic - Absorb),
    MH1 = case DmgMagicReduce of
        {val, ReduceVal} -> util:check_range(MH - ReduceVal, 0, MH);
        {ratio, ReduceRatio} -> util:check_range(MH * (100 - ReduceRatio)/100, 0, MH);
        _ -> MH
    end,
    %DmgMin1 = util:check_range(DmgMin, 0, DmgMin),
    %DmgMax1 = util:check_range(DmgMax, DmgMin1, DmgMax),
    %{RealDmgMin, RealDmgMax} = case DmgAdjust of
    %    undefined -> {DmgMin1, DmgMax1};
    %    _ -> {DmgAdjust([DmgMin1]), DmgAdjust([DmgMax1])}
    %end,
    %Ap = util:rand(RealDmgMin, RealDmgMax),
    Ap = DmgMax,
    TmpDmg = Ap * (SkDmgRatio/100) * (1 - Ar) + MH1,
    TmpDmg2 = ?EXEC_FUNC(DmgBeforeCrit, TmpDmg, [TmpDmg]),
    TmpDmg3 = round(TmpDmg2 * InjureRatio / 100),
    TmpDmg4 = case IsStone of
        ?true -> TmpDmg3 * (100 - StoneDmgReduceRatio) / 100;
        ?false -> TmpDmg3
    end,
    SuperCritDmgMult = IsSuperCrit * 1.5, 
    {Dmg, IsCrit} = case DmgCanCrit of
        true ->
            CritEff = Crit * CritrateRatio / 100,
            FinalCritRate = if
                CritEff - Ten > 700 ->
                    700 + 100 * (CritEff-Ten-700)/(CritEff-Ten-700+1000);
                CritEff - Ten < 100 ->
                    100 - 100*(100-(CritEff-Ten))/(100-(CritEff-Ten)+1000);
                true ->
                    util:check_range(CritEff - Ten, 0, 700)
            end,
            
            case util:rand(1, 10000) =< FinalCritRate * 10 of
                true -> %% 暴击
                    TmpDmg5 = TmpDmg4 * (CritDmgRatio/100 + SuperCritDmgMult),
                    IsCrit0 = IsSuperCrit bor ?true,
                    {?EXEC_FUNC(DmgAfterCrit, TmpDmg5, [TmpDmg5, IsCrit0]), IsCrit0};
                false -> %% 非暴击
                    TmpDmg5 = TmpDmg4 * (1 + SuperCritDmgMult),
                    IsCrit0 = IsSuperCrit bor ?false,
                    {?EXEC_FUNC(DmgAfterCrit, TmpDmg5, [TmpDmg5, IsCrit0]), IsCrit0}
            end;
        false ->
            TmpDmg5 = TmpDmg4 * (1 + SuperCritDmgMult),
            IsCrit0 = IsSuperCrit bor ?false,
            {?EXEC_FUNC(DmgAfterCrit, TmpDmg5, [TmpDmg5, IsCrit0]), IsCrit0}
    end,
    Dmg1 = ?EXEC_FUNC(DmgHpFunc, Dmg, [IsCrit]),
    Dmg2 = ?EXEC_FUNC(DmgHpMaxFunc, Dmg1, [Dmg1, IsCrit]),
    Dmg3 = if
        Dmg2 >=0 andalso Dmg2 < 1 -> 1;
        true -> Dmg2
    end,
    {DmgAfterHit, IsHit} = case CanHit of
        true -> {Dmg3, ?true};   %% 命中, 100%伤害
        false -> {Dmg3 / 2, ?false}  %% 格档，伤害减半
    end,
    FinalDmg = ?EXEC_FUNC(DmgAfterHitFunc, DmgAfterHit, [DmgAfterHit, IsHit]),
    {round(FinalDmg), IsCrit, IsHit}.

%% @spec check_passive_multi_attack(Self, Target) -> {true, integer()} | {false, 0}
%% Self = #fighter{}
%% Target = #fighter{}
%% @doc 被动追击判断，返回增加的连击数
% check_passive_multi_attack(Self = #fighter{pid = Pid}, Target) ->
%     PassiveSkills = case combat:f_ext(by_pid, Pid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         #fighter_ext_npc{passive_skills = L} -> L;
%         #fighter_ext_pet{passive_skills = L} -> L;
%         _ -> []
%     end,
%     case f(by_scriptid, PassiveSkills, 10510) of 
%         undefined -> {false, 0};
%         F_10510 -> script_10510(F_10510, Self, Target, [])
%     end.


%%----------------------------------------------------
%% 是否控制技能
%%----------------------------------------------------
is_control_skill(#c_skill{buff_target = BuffTarget}) ->
    do_check_control_skill(BuffTarget);
is_control_skill(_) -> false.
do_check_control_skill([]) -> false;
do_check_control_skill([#c_buff{id = BuffId}|T]) ->
    case lists:member(BuffId, [200040, 200050, 200060, 200070, 200080, 200090]) of
        true -> true;
        _ -> do_check_control_skill(T)
    end.

%% --------------------------------------------------
%% 判断是否(合体/夫妻)技能
%% --------------------------------------------------
check_partner_skill(#fighter{partner = PartnerId, group = Group}, Target, Skill = #c_skill{skill_type = ?skill_type_partner, target = enemy}, IsCrit, IsHit, IsDie) ->
    case combat:f(by_rid, Group, PartnerId) of
        false -> skip;
        F = #fighter{is_die = ?false, is_stun = ?false, is_taunt = ?false, is_silent = ?false, is_sleep = ?false, is_stone = ?false, is_escape = ?false} ->
            combat:add_sub_play(combat:gen_sub_play(attack, F, Target, Skill, 0, 0, 0, 0, IsCrit, IsHit, IsDie));
        _ -> skip
    end;
check_partner_skill(_, _, _, _, _, _) -> skip.

%%----------------------------------------------------
%% 技能脚本（模板）数据
%%----------------------------------------------------

%% @spec get(Skill) -> #c_skill{}
%% Skill = #c_skill{}
%% @doc 获取转化好的技能
get(TmpSkill = #c_skill{script_id = Id, args = Args, buff_self = BuffParamList1, buff_target = BuffParamList2}) ->
    %% 转换BUFF
    BuffSelf = combat_script_buff:convert_buff(BuffParamList1),
    BuffTarget = combat_script_buff:convert_buff(BuffParamList2),
    Skill = TmpSkill#c_skill{buff_self = BuffSelf, buff_target = BuffTarget},

    %% 转换技能
    case Id of
        %%----------------------------------------------
        %% 主动技能
        %%----------------------------------------------
        10000 -> %% 近身攻击
            Skill#c_skill{attack = fun attack/3};
        10010 -> %% 远程攻击
            Skill#c_skill{attack = fun attack/3};
        %10020 -> %% 逃跑
        %    Skill#c_skill{attack = fun escape/3};
        %10030 -> %% 保护
        %    Skill#c_skill{attack = fun protect/3};
        %10040 -> %% 防御
        %    Skill#c_skill{attack = fun defence/3};
        %10050 -> %% 使用物品
        %    Skill#c_skill{target = any, attack = fun use_item/3};
        10060 -> %% 纯施法
            Skill#c_skill{attack = fun cast/3};
        10070 -> %% 抓宠物
            Skill#c_skill{attack = fun catch_pet/3};
        10080 -> %% 召唤宠物
            Skill#c_skill{attack = fun summon_pet/3};
        10220 -> 
            Skill#c_skill{attack = fun script_10220/3};
        10230 -> %% 延迟发动
            case Args of
                [DelayRound] when DelayRound > 0 -> Skill#c_skill{delay_round = DelayRound, delay_eff = [{act_first, ?true}], attack = fun script_10230/3};
                _ -> Skill#c_skill{attack = fun attack/3}
            end;
        10240 -> %% 吸血
            Skill#c_skill{show_type = [{hp, 1}, {mp, 0}]};  %% 指定客户端的播放效果顺序

        %%----------------------------------------------
        %% 被动技能
        %%----------------------------------------------
        10500 -> %% 厄难毒体
            Skill#c_skill{passive_type = ?passive_type_defence};
        10510 -> %% 双星连发
            Skill#c_skill{passive_type = ?passive_type_attack};
        10520 -> %% 百步穿杨
            Skill#c_skill{passive_type = ?passive_type_attack};
        10530 -> %% 元灵之甲
            Skill#c_skill{passive_type = ?passive_type_hp_below};
        10550 -> %% 斗气护体
            Skill#c_skill{passive_type = ?passive_type_defence};
        10560 -> %% 屹立不倒
            Skill#c_skill{passive_type = ?passive_type_hp_below};
        10570 ->
            Skill#c_skill{passive_type = ?passive_type_defence};
        10580 ->
            Skill#c_skill{passive_type = ?passive_type_defence};
        10600 -> %% 精灵化形攻击
            Skill#c_skill{passive_type = ?passive_type_before_attack};
        10610 -> %% 法宝攻击
            Skill#c_skill{passive_type = ?passive_type_before_attack};
        10620 -> %% 法宝防御
            Skill#c_skill{passive_type = ?passive_type_defence};
        10630 -> %% 法宝加buff
            Skill#c_skill{passive_type = ?passive_type_attack};
        10710 -> %% 玄天
            Skill#c_skill{passive_type = ?passive_type_defence};
        10720 -> %% 逆天
            Skill#c_skill{passive_type = ?passive_type_defence};

        %%---------------------------------------------
        %% 怒气技能
        %%---------------------------------------------
        10800 -> %% 怒气技能 - 触发时加血
            Skill#c_skill{skill_type = ?skill_type_anger};
        10810 -> %% 怒气技能 - 触发时加血（百分比）
            Skill#c_skill{skill_type = ?skill_type_anger};
        10820 -> %% 怒气技能 - 触发时施加BUFF
            Skill#c_skill{skill_type = ?skill_type_anger};
        10830 -> %% 怒气被动技能 - 怒气增加时触发
            Skill#c_skill{skill_type = ?skill_type_anger_passive, passive_type = ?passive_type_defence};
        _ ->
            Skill
    end.


%% @spec get_lineup(Skill) -> #c_lineup{}
%% Skill = #c_skill{args = Args}
%% Args = [{atom(), integer()}] or [{integer(), integer()}]
%% @doc 获取转化好的阵法
get_lineup(#c_skill{id = Id, script_id = ScriptId, args = Args}) ->
    Lineup = #c_lineup{id = Id, script_id = ScriptId, args = Args},
    case ScriptId of
        %% -----------------------------------------
        %% 角色阵法
        %% -----------------------------------------
        20000 -> %% 属性加成
            Lineup#c_lineup{eff = fun script_20000/2};
        %% -----------------------------------------
        %% 宠物阵法
        %% -----------------------------------------
        30000 -> %% 属性加成
            Lineup#c_lineup{eff = fun script_30000/2};     
        _ ->
            Lineup
    end.

%% @spec lineup_cal(CFList, LineupId, L) -> [#converted_fighter{}]
%% CFList = [#converted_fighter{}] 原始的参战者数据
%% LineupId = integer() 队长的阵法ID
%% L = 结果集
%% @doc 根据阵法ID返回计算好的参战者数据
lineup_calc(FighterList, LineupId) ->
    lineup_calc(FighterList, LineupId, length(FighterList), []).
lineup_calc([], _, _, L) -> lists:reverse(L);
lineup_calc([CF = #converted_fighter{fighter = #fighter{type = ?fighter_type_role}, fighter_ext = Fext}|T], LineupId, Num, L) ->
    CF1 = CF#converted_fighter{fighter_ext = Fext#fighter_ext_role{lineup_id = LineupId}},
    CF2 = case combat_data_skill:get(LineupId) of
        undefined -> CF1;
        LineupSkill ->
            Lineup = combat_script_skill:get_lineup(LineupSkill),
            case Lineup of
                #c_lineup{eff = undefined} -> CF1;
                #c_lineup{eff = LineupEff, args = Args} ->
                    Args1 = lineup_calc_args(Args, Num),
                    LineupEff(Lineup#c_lineup{args = Args1}, CF1);
                _ -> CF1
            end
    end,
    lineup_calc(T, LineupId, Num, [CF2|L]);
lineup_calc([CF|T], LineupId, Num, L) ->
    lineup_calc(T, LineupId, Num, [CF|L]).

%% 根据人数重新计算阵法参数
lineup_calc_args(Args, 2) ->
    [{Key, Val * 0.6} || {Key, Val} <- Args];
lineup_calc_args(Args, _) -> Args.

%% 守护技能转换成#c_skill
convert(to_c_skill, {c_skill, CSkillId, TargetNum, Cd, Args, BuffParamList1}) ->
    case combat_data_skill:get(CSkillId) of
        undefined -> undefined;
        Cskill ->
            BuffSelf = combat_script_buff:convert_buff(BuffParamList1),
            Cskill#c_skill{target_num = TargetNum, cd = Cd, args = Args, buff_self = BuffSelf}
    end;
convert(_, _) -> undefined.


%%------------------------------------------------------
%% 技能脚本具体实现
%%------------------------------------------------------
%% (不知道为什么在get()里面使用F=fun()...end, #c_skill{attack=F/3}这种形式在role_convert那里会报badarith错误)

script_10220(Skill = #c_skill{args = [Param1]}, Self, Target) ->
    attack(Skill, Self, Target, #action_effect_func{dmg_mp = fun(_) -> Param1 end}).

script_10230(Skill, Self, Target) ->
    attack(Skill, Self, Target).


%%------------------------------------------------------------------------------
%% 以下是buff效果
%%------------------------------------------------------------------------------
buff_passive_effect(
        Event, 
        self,   %% 检查攻击方的buff
        Self = #fighter{buff_hit = SBuffHit, buff_round = SBuffRound, buff_atk = SBuffAtk}, 
        Target = #fighter{buff_hit = _TBuffHit, buff_round = _TBuffRound, buff_atk = _TBuffAtk},  
        Args) ->
    do_buff_effect(SBuffHit++SBuffRound++SBuffAtk, Self, Target, Event, Args);
buff_passive_effect(
        Event, 
        target,   %% 检查被攻击方的buff
        Self = #fighter{buff_hit = _SBuffHit, buff_round = _SBuffRound, buff_atk = _SBuffAtk}, 
        Target = #fighter{buff_hit = TBuffHit, buff_round = TBuffRound, buff_atk = TBuffAtk},  
        Args) ->
    do_buff_effect(TBuffHit++TBuffRound++TBuffAtk, Self, Target, Event, Args).

do_buff_effect([], _Self, _Target, _Event, Args) ->
    Args;
do_buff_effect([Buff|T], Self, Target, Event, Args) ->
    case Buff#c_buff.eff_passive of
        undefined ->
            do_buff_effect(T, Self, Target, Event, Args);
        ActFun ->
            case catch ActFun(Event, Args, Buff, Self, Target) of
                {'EXIT', _Reason} ->
                    ?ERR("~p:eff_passive error: ~p", [Buff, _Reason]),
                    do_buff_effect(T, Self, Target, Event, Args);
                NewArgs ->
                    do_buff_effect(T, Self, Target, Event, NewArgs)
            end
    end.


%%------------------------------------------------------------------------------
%% 以下是被动技能
%% 第一个#fighter{} 是 Attacker : 攻击者
%% 第二个#fighter{} 是 Defencer : 被攻击者
%% (根据被动技能性质，把他们转变为相应的Self和Target，这样好理解一点)
%%------------------------------------------------------------------------------

%% State :
%%  reduce_dmg              - 减少或者吸收伤害
%%  reduce_magic_dmg        - 减少魔法伤害
%%  hp_below                - 血量低于某个限度时
%%  raise_dmg               - 增加伤害
%%  be_hit                  - 被击中时
%%  feedback_dmg            - 反弹
%%  demon_attack            - 精灵攻击
%%  buff_target_on_attack   - 击中对方时
%%  after_hit               - 击中对方后
%%  skill_enhance           - 任何攻击技能附加增强效果
%%
%% 攻击者-被动技能
passive_activate({self, State}, Self = #fighter{pid = Spid}, Target = #fighter{pid = _Tpid}, Args) ->
    PassiveSkills = case combat:f_ext(by_pid, Spid) of
        #fighter_ext_role{passive_skills = L} -> L;
        #fighter_ext_npc{passive_skills = L} -> L;
        #fighter_ext_pet{passive_skills = L} -> L;
        _ -> []
    end,   
    do_passive(PassiveSkills, Self, Target, State, Args);

%% 受攻击-被动技能
passive_activate({target, State}, Self = #fighter{pid = _Spid}, Target = #fighter{pid = Tpid, is_nopassive = ?false}, Args) ->
    PassiveSkills = case combat:f_ext(by_pid, Tpid) of
        #fighter_ext_role{passive_skills = L} -> L;
        #fighter_ext_npc{passive_skills = L} -> L;
        #fighter_ext_pet{passive_skills = L} -> L;
        _ -> []
    end,   
    do_passive(PassiveSkills, Self, Target, State, Args).

do_passive([], _Self, _Target, _State, Args) ->
    Args;
do_passive([PassiveSkill|T], Self, Target, State, Args) when is_record(PassiveSkill, c_skill) ->
    case PassiveSkill#c_skill.script of
        undefined -> 
            do_passive(T, Self, Target, State, Args);
        ScriptMod -> 
            case catch ScriptMod:handle_passive(State, Args, PassiveSkill, Self, Target) of
                {'EXIT', {undef, _}} ->
                    do_passive(T, Self, Target, State, Args);
                {'EXIT', _Reason} ->
                    ?ERR("~p:handle_passive error: ~p", [ScriptMod, _Reason]),
                    ?log("~p:handle_passive error: ~p", [ScriptMod, _Reason]),
                    do_passive(T, Self, Target, State, Args);
                NewArgs ->
                    do_passive(T, Self, Target, State, NewArgs)
            end
    end;
do_passive([#c_pet_skill{}|T], Self, Target, State, Args) ->
    %% 宠物被动技能处理暂不处理
    do_passive(T, Self, Target, State, Args);
do_passive([_Unknown|T], Self, Target, State, Args) ->
    ?ERR(_Unknown),
    do_passive(T, Self, Target, State, Args).



%% passive_activate(reduce_dmg, Self, Target, Args) -> {NewDmgHp, NewDmgMp}
%% 被动技能触发：减少或者吸收伤害
% passive_activate(reduce_dmg, #fighter{pid = Spid}, #fighter{pid = Tpid, is_nopassive = ?false}, [DmgHp]) ->
%     TPassiveSkills = case combat:f_ext(by_pid, Tpid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         #fighter_ext_npc{passive_skills = L} -> L;
%         #fighter_ext_pet{passive_skills = L} -> L;
%         _ -> []
%     end,
%     {_, Self} = combat:f(by_pid, Spid),
%     {_, Target} = combat:f(by_pid, Tpid),
%     do_passive_activate(reduce_dmg, TPassiveSkills, Self, Target, [DmgHp, 0]);
% passive_activate(reduce_dmg, _, _, [DmgHp]) -> {DmgHp, 0};

%% 减少魔法伤害
% passive_activate(reduce_magic_dmg, #fighter{pid = Spid}, #fighter{pid = Tpid, is_nopassive = ?false}, Args) ->
%     TPassiveSkills = case combat:f_ext(by_pid, Tpid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         #fighter_ext_npc{passive_skills = L} -> L;
%         #fighter_ext_pet{passive_skills = L} -> L;
%         _ -> []
%     end,
%     {_, Self} = combat:f(by_pid, Spid),
%     {_, Target} = combat:f(by_pid, Tpid),
%     case f(by_scriptid, TPassiveSkills, 10570) of
%         undefined -> {val, 0};
%         F_10570 -> script_10570(F_10570, Self, Target, Args)
%     end;
% passive_activate(reduce_magic_dmg, _, _, _) -> {val, 0};

%% passive_activate(hp_below, Self, Target, Args) -> ok
%% 被动技能触发：血量低于某个限度时触发一些BUFF
% passive_activate(hp_below, #fighter{pid = Spid}, #fighter{pid = Tpid, is_nopassive = ?false}, _) ->
%     TPassiveSkills = case combat:f_ext(by_pid, Tpid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         #fighter_ext_npc{passive_skills = L} -> L;
%         #fighter_ext_pet{passive_skills = L} -> L;
%         _ -> []
%     end,
%     case f(by_scriptid, TPassiveSkills, 10560) of
%         undefined -> ignore;
%         F_10560 -> 
%             {_, Self} = combat:f(by_pid, Spid),
%             {_, Target} = combat:f(by_pid, Tpid), 
%             script_10560(F_10560, Self, Target, [])
%     end,
%     ok;
% passive_activate(hp_below, _, _, _) -> ok;

%% passive_activate(raise_dmg, Self, Target, Args) -> NewDmgHp
%% 被动技能触发：增加伤害
% passive_activate(raise_dmg, #fighter{pid = Spid, is_nopassive = ?false}, #fighter{pid = Tpid}, [DmgHp]) ->
%     SPassiveSkills = case combat:f_ext(by_pid, Spid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         #fighter_ext_npc{passive_skills = L} -> L;
%         #fighter_ext_pet{passive_skills = L} -> L;
%         _ -> []
%     end,
%     {_, Self} = combat:f(by_pid, Spid),
%     {_, Target} = combat:f(by_pid, Tpid),
%     do_passive_activate(raise_dmg, SPassiveSkills, Self, Target, [DmgHp]);
% passive_activate(raise_dmg, _, _, [DmgHp]) -> DmgHp;

%% anger_passive_activate(buff_after_hit, Self, Target, Args) -> [{anger_changed, Val}...]
%% 被动技能触发：被击中就添加buff
anger_passive_activate(buff_after_hit, _Self = #fighter{pid = _Spid, name = _Sname}, _Target = #fighter{pid = Tpid}, [_AttackType, HpDmg]) ->
    {Skills, _TPassiveSkills, TAngerSkills, TAngerPassiveSkills} = case combat:f_ext(by_pid, Tpid) of
        #fighter_ext_role{skills = L0, passive_skills = L1, anger_skills = L2, anger_passive_skills = L3} -> {L0, L1, L2, L3};
        #fighter_ext_npc{skills = L0, passive_skills = L} -> {L0, L, [], []};
        #fighter_ext_pet{skills = L0, passive_skills = L} -> {L0, L, [], []};
        _ -> {[], [], [], []}
    end,
    {_, #fighter{hp_max = HpMax, anger_max = AngerMax}} = combat:f(by_pid, Tpid),
    {AngerChanged, Updates1} = case TAngerSkills of
        [_|_] ->
            AngerVal = anger_calc(TAngerPassiveSkills, AngerMax, HpDmg, HpMax),
            %% ?DEBUG("[~s]的怒气值增加了:~w", [_Sname, AngerVal]),
            {AngerVal, [{anger_changed, AngerVal}]} ;
        [] -> {0, []}
    end,
    {Updates2, PowerChanged} = case lists:keyfind(10700, #c_skill.script_id, Skills) of
        #c_skill{} ->
            PV = combat_util:power_calc(HpMax, HpDmg),
            {[{power_changed, PV} | Updates1], PV};
        _ ->
            {Updates1, 0}
    end,
    case Updates2 of
        [_ | _] ->
            combat:update_fighter(Tpid, Updates2);
        _ -> ok
    end,
    {AngerChanged, PowerChanged};
anger_passive_activate(buff_after_hit, _, _, _) -> {0, 0}.

%% feedback_dmg(Self, Target, Args) -> {true, 100000}.
%% 被动技能触发：反弹伤害
feedback_dmg(#fighter{pid = Spid, is_nopassive = ?false}, #fighter{pid = Tpid, buff_hit = Buffs, type = TType}, [AttackType, DmgHp, IsHit, FeedbackDmgByPet]) ->
    {_, Self} = combat:f(by_pid, Spid),
    {_, Target} = combat:f(by_pid, Tpid),
    %% 被动技能：反弹伤害
    case AttackType =:= ?attack_type_melee orelse AttackType =:= ?attack_type_range of %% 13/10/30 改为远程攻击也反伤 liuqingxuan
        true ->
            %% 计算BUFF的反弹
            FeedbackDmg1 = case f(by_buffid, Buffs, 101250) of
                undefined -> 0;
                Buff = #c_buff{calc = DmgCalc} -> 
                    case DmgCalc(Buff, Self, Target, [DmgHp]) of
                        Dmg1 when Dmg1 >0 -> Dmg1;
                        _ -> 0
                    end
            end,
            %% 计算技能的反弹
            FeedbackDmg2 = case TType of
                ?fighter_type_pet -> %% 仙宠反射技能处理
                    TPassiveSkills = case combat:f_ext(by_pid, Tpid) of
                        #fighter_ext_role{passive_skills = L} -> L;
                        #fighter_ext_npc{passive_skills = L} -> L;
                        #fighter_ext_pet{passive_skills = L} -> L;
                        _ -> []
                    end,
                    combat_script_pet:pet_feedback_dmg(TPassiveSkills, Self, Target, DmgHp);
                _ ->
                    {_Dmg, _IsHit, FeedbackDmg_} = passive_activate({target, feedback_dmg}, Self, Target, {DmgHp, IsHit, 0}),
                    erlang:max(0, FeedbackDmg_)
            end,
            %% buff反弹(护盾)
            {_, _, FeedbackDmg3} = buff_passive_effect(feedback_dmg, target, Self, Target, {DmgHp, IsHit, 0}),
            %% 
            FeedbackDmg = FeedbackDmg1 + FeedbackDmg2 + FeedbackDmgByPet + FeedbackDmg3,
            case FeedbackDmg > 0 of
                true -> {true, FeedbackDmg};
                false -> {false, 0}
            end;
        false -> {false, 0}
    end;
feedback_dmg( _, _, _) -> {false, 0}.

%% 被动技能触发：精灵化形攻击
% passive_activate(demon_attack, Self = #fighter{pid = Spid, type = ?fighter_type_role, is_clone = ?false}, Target, [#c_skill{times = Times, target = enemy, script_id = ScriptId}]) when Times>0 andalso ScriptId =/= 10060 andalso ScriptId =/= 10070 ->
%     PassiveSkills = case combat:f_ext(by_pid, Spid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         _ -> []
%     end,
%     case f(by_scriptid, PassiveSkills, 10600) of
%         undefined -> ok;
%         F_10600 -> script_10600(F_10600, Self, Target, [])
%     end;
% passive_activate(demon_attack, _, _, _) -> ok;

%% 被动技能触发：攻击时对目标施加buff
% passive_activate(buff_target_on_attack, #fighter{pid = Spid}, #fighter{pid = Tpid}, Args) ->
%     PassiveSkills = case combat:f_ext(by_pid, Spid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         _ -> []
%     end,
%     do_passive_activate(buff_target_on_attack, PassiveSkills, Spid, Tpid, Args);
% passive_activate(buff_target_on_attack, _, _, _) -> [].


%do_passive_activate(raise_dmg, [], _, _, [DmgHp]) -> DmgHp;
%do_passive_activate(reduce_dmg, [], _, _, [DmgHp, DmgMp]) -> {DmgHp, DmgMp};
%do_passive_activate(buff_target_on_attack, [], _, _, _) -> [];
%do_passive_activate(_, [], _, _, _) -> ok;
%% 被命中触发buff类
% do_passive_activate(buff_after_hit, [Skill = #c_skill{script_id = 10500}|T], Spid, Tpid, [AttackType]) ->
%     {_, Self = #fighter{type = Stype}} = combat:f(by_pid, Spid),
%     {_, Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
%     case IsNoPassive of
%         ?true -> ignore;
%         _ ->
%             case Stype=:=?fighter_type_role andalso combat:is_skill_in_cooldown(Tid, Skill)=:=true of
%                 true -> ignore;
%                 false -> script_10500(Skill, Self, Target, [AttackType])
%             end
%     end,
%     do_passive_activate(buff_after_hit, T, Spid, Tpid, [AttackType]);
% do_passive_activate(buff_after_hit, [Skill = #c_skill{script_id = 10710}|T], Spid, Tpid, [AttackType]) ->
%     {_, Self = #fighter{}} = combat:f(by_pid, Spid),
%     {_, Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
%     case IsNoPassive of
%         ?true -> ignore;
%         _ ->
%             case combat:is_skill_in_cooldown(Tid, Skill) of
%                 true -> ignore;
%                 false -> script_10710(Skill, Self, Target, [AttackType])
%             end
%     end,
%     do_passive_activate(buff_after_hit, T, Spid, Tpid, [AttackType]);
% do_passive_activate(buff_after_hit, [Skill = #c_skill{script_id = 10720}|T], Spid, Tpid, [AttackType]) ->
%     {_, Self = #fighter{}} = combat:f(by_pid, Spid),
%     {_, Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
%     case IsNoPassive of
%         ?true -> ignore;
%         _ ->
%             case combat:is_skill_in_cooldown(Tid, Skill) of
%                 true -> ignore;
%                 false -> script_10720(Skill, Self, Target, [AttackType])
%             end
%     end,
%     do_passive_activate(buff_after_hit, T, Spid, Tpid, [AttackType]);
%% 命中对对方施加buff -> list()
% do_passive_activate(buff_target_on_attack, [Skill = #c_skill{script_id = 10630}|_T], Spid, Tpid, Args) ->
%     {_, Self = #fighter{type = Stype}} = combat:f(by_pid, Spid),
%     {_, Target = #fighter{id = Tid, is_nopassive = IsNoPassive}} = combat:f(by_pid, Tpid),
%     case IsNoPassive of
%         ?true -> [];
%         _ ->
%             case Stype=:=?fighter_type_role andalso combat:is_skill_in_cooldown(Tid, Skill)=:=true of
%                 true -> [];
%                 false -> script_10630(Skill, Self, Target, Args)
%             end
%     end;
%% 命中增加伤害
% do_passive_activate(raise_dmg, [Skill = #c_skill{script_id = 10520} | T], Self, Target, [DmgHp]) ->
%     NewDmgHp = script_10520(Skill, Self, Target, [DmgHp]),
%     do_passive_activate(raise_dmg, T, Self, Target, [NewDmgHp]);
%% 被攻击时触发抵御某系伤害
% do_passive_activate(reduce_dmg, [Skill = #c_skill{script_id = 10530} | T], Self, Target, [DmgHp, DmgMp]) ->
%     {NewDmgHp, NewDmgMp} = script_10530(Skill, Self, Target, [DmgHp, DmgMp]),
%     do_passive_activate(reduce_dmg, T, Self, Target, [NewDmgHp, NewDmgMp]);
%% 被攻击时触发减免部分伤害（不区分类型）
% do_passive_activate(reduce_dmg, [Skill = #c_skill{script_id = 10580} | T], Self, Target, [DmgHp, DmgMp]) ->
%     {NewDmgHp, NewDmgMp} = script_10580(Skill, Self, Target, [DmgHp, DmgMp]),
%     do_passive_activate(reduce_dmg, T, Self, Target, [NewDmgHp, NewDmgMp]);
% do_passive_activate(reduce_dmg, [Skill = #c_skill{script_id = 10620} | T], Self, Target, [DmgHp, DmgMp]) ->
%     {NewDmgHp, NewDmgMp} = script_10620(Skill, Self, Target, [DmgHp, DmgMp]),
%     do_passive_activate(reduce_dmg, T, Self, Target, [NewDmgHp, NewDmgMp]);
%do_passive_activate(Type, [_|T], Spid, Tpid, Args) -> do_passive_activate(Type, T, Spid, Tpid, Args).


%% 被攻击时一定几率触发BUFF
% script_10500(#c_skill{id = SkillId, name = _SkillName, buff_self = BuffSelf, buff_target = BuffTarget, args = [HitRate]}, 
%     Target = #fighter{pid = Tpid, name = _Tname}, Self = #fighter{id = Sid, name = _Sname}, [_AttackType]
% ) ->
%     case util:rand(1, 1000) =< HitRate * 10 of
%         true ->
%             erlang:put({script_10500, Tpid}, false),
%             %%?DEBUG("尝试给[~s]添加BUFF", [_Sname]),
%             lists:foreach(fun(Buff) -> 
%                         case combat_script_buff:do_add_buff(Buff, Self, Self) of
%                             true -> erlang:put({script_10500, Tpid}, true);
%                             false -> ignore
%                         end
%                 end, BuffSelf),
%             %% ?DEBUG("尝试给[~s]添加BUFF", [_Tname]),
%             lists:foreach(fun(Buff) -> 
%                         case combat_script_buff:do_add_buff(Buff, Self, Target) of
%                             true -> erlang:put({script_10500, Tpid}, true);
%                             false -> ignore
%                         end
%                 end, BuffTarget),
%             case erlang:get({script_10500, Tpid}) of
%                 true -> 
%                     %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%                     %% combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill));
%                     combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit);
%                 false -> ignore
%             end,
%             put({script_10500, Tpid}, undefined),
%             combat:add_to_skill_cooldown(Sid, SkillId);
%         false -> ignore
%     end.

%% 玄天之魂和逆天之魂触发概率特殊处理
%% 玄天触发率=技能等级^0.3*（0.6-气血百分比）*0.65
% script_10710(Skill = #c_skill{id = Id}, Target, Self = #fighter{hp = Hp, hp_max = HpMax}, Arg) ->
%     HitRate = round(math:pow(Id rem 900, 0.3) * (0.6 - Hp / HpMax) * 65),
%     %% ?DEBUG("天命玄天技能触发概率 ~w", [HitRate]),
%     script_10500(Skill#c_skill{args = [HitRate]}, Target, Self, Arg).
% %% 逆天触发率=技能等级^0.3*（0.6-气血百分比）
% script_10720(Skill = #c_skill{id = Id}, Target, Self = #fighter{hp = Hp, hp_max = HpMax}, Arg) ->
%     HitRate = round(math:pow(Id rem 901, 0.3) * (0.6 - Hp / HpMax) * 100),
%     %% ?DEBUG("天命逆天技能触发概率 ~w", [HitRate]),
%     script_10500(Skill#c_skill{args = [HitRate]}, Target, Self, Arg).

%% 命中目标时一定几率触发追击
% script_10510(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, AddTimes]}, #fighter{id = Sid, name = _Sname}, _Target, _Args) ->
%     case util:rand(1, 100) =< HitRate of
%         true -> 
%             %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
%             {true, AddTimes};
%         false -> {false, 0}
%     end.

%% 命中目标时一定几率额外附加一定伤害
% script_10520(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, BaseVal, AddVal]}, #fighter{id = Sid, name = _Sname}, _Target, [Dmg]) ->
%     case util:rand(1, 100) =< HitRate of
%         true ->
%             %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
%             round(Dmg * (1 + BaseVal / 100)) + AddVal;
%         false -> Dmg
%     end.

%% 当自身气血低于[气血百分比]%时，[触发几率]%几率以法力抵消伤害，1法力=N点气血
% script_10530(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, HpRatio, BaseVal]}, _Target,
%     #fighter{id = Sid, name = _Sname, hp_max = ShpMax, hp = Shp, mp = Tmp}, [DmgHp, DmgMp]) ->
%     case (Shp * 100) =< (HpRatio * ShpMax) of
%         true ->
%             case util:rand(1, 100) =< HitRate of
%                 true -> 
%                     %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%                     %%combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill)),
%                     combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%                     HpDmg = round(DmgHp - (Tmp - DmgMp) * BaseVal),
%                     case HpDmg <0 of 
%                         true -> {0, round(DmgHp/BaseVal) + DmgMp};
%                         false -> {HpDmg, round((DmgHp - HpDmg)/BaseVal) + DmgMp}
%                     end;
%                 false -> {DmgHp, DmgMp}
%             end;
%         false -> {DmgHp, DmgMp}
%     end;

%% 受到伤害时[触发几率]%的几率减免受到[伤害属性类别]伤害的[减免百分比]%
% script_10530(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, AttackType, ReduceRatio, ReduceVal]}, #fighter{career = Career}, #fighter{id = Sid, name = _Sname}, [DmgHp, DmgMp]) ->
%     case AttackType =:= Career of
%         true ->
%             case util:rand(1, 1000) =< HitRate * 10 of
%                 true -> 
%                     %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%                     %%combat:add_sub_play(combat:gen_sub_play(passive, Self, Self, Skill)),
%                     combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%                     V =  case DmgHp - ReduceVal > 0 of
%                         true -> DmgHp - ReduceVal;
%                         false -> 1
%                     end,
%                     HpDmg = round(V - ReduceRatio * V / 100),
%                     case HpDmg < 0 of
%                         true -> {1, DmgMp};
%                         false -> {HpDmg, DmgMp}
%                     end;
%                 false -> {DmgHp, DmgMp}
%             end;
%         false -> {DmgHp, DmgMp}
%     end.

%% [触发几率]%几率反弹受到伤害的[反弹伤害的百分比]%
% script_10550(#c_skill{name = _SkillName, args = [HitRate, BaseVal]}, _Target, _Self = #fighter{name = _Sname}, [Dmg]) ->
%     case util:rand(1, 100) =< HitRate of
%         true ->
%             %% ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             round(Dmg * BaseVal/100);
%         false -> 0
%     end.

%% 当自身气血低于[气血百分比]%时，触发BUFF
% script_10560(#c_skill{id = SkillId, name = _SkillName, args = [HpRatio], buff_self = BuffSelf}, _Target, Self = #fighter{id = Sid, pid = Pid, name = _Sname, hp_max = ThpMax, hp = Thp}, _Args) ->
%     if
%         (Thp * 100) =< (HpRatio * ThpMax) ->
%             case combat:check_skill_limit(Pid, SkillId, 1) of
%                 true ->
%                     %% ?DEBUG("[~s]的被动技能[~s]触发，尝试添加BUFF", [_Sname, _SkillName]),
%                     combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%                     %% 对自己施加BUFF
%                     lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Self) end, BuffSelf);
%                 false ->
%                     %%?DEBUG("[~s]的被动技能[~s]触发次数达到上限[~w]，不能再触发", [_Sname, _SkillName, 1])
%                     ok
%             end;
%         true -> ignore
%     end.

%% 受到伤害时[触发几率]%几率减免受到的法术伤害的[减免百分比]% -> {ratio, Val} | {val, Val}
% script_10570(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, ReduceRatio, ReduceVal]}, _Target, _Self = #fighter{id = Sid, name = _Sname}, _Args) ->
%     case util:rand(1, 100) =< HitRate of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%             case ReduceRatio > 0 of
%                 true -> {ratio, ReduceRatio};
%                 false -> {val, ReduceVal}
%             end;
%         false -> {val, 0}
%     end.

%% 受到伤害时[触发几率]%几率减免受到的伤害的[减免百分比]%
% script_10580(#c_skill{id = SkillId, name = _SkillName, args = [HitRate, ReduceRatio, ReduceVal]}, _Target, _Self = #fighter{id = Sid, name = _Sname}, [DmgHp, DmgMp]) ->
%     DmgHp1 = case util:rand(1, 100) =< HitRate of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%             case ReduceRatio > 0 of
%                 true -> util:check_range(round(DmgHp * (100 - ReduceRatio)/100), 0, DmgHp);
%                 false -> util:check_range(round(DmgHp - ReduceVal), 0, DmgHp)
%             end;
%         false -> DmgHp
%     end,
%     {DmgHp1, DmgMp}.

%% 角色攻击动作前触发精灵守护化形攻击
% script_10600(Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate]}, Self = #fighter{id = Sid, name = _Sname, pid = Spid}, Target, _Args) ->
%     %% 灵动技能加概率
%     PassiveSkills = case combat:f_ext(by_pid, Spid) of
%         #fighter_ext_role{passive_skills = L} -> L;
%         _ -> []
%     end,
%     RateAdd= case f(by_scriptid, PassiveSkills, 10640) of
%         #c_skill{args = [Val]} -> Val;
%         _ -> 0 
%     end,
%     ?DEBUG("灵动加 ~w", [RateAdd]),
%     case util:rand(1, 100) =< round(Rate * (1 + RateAdd / 100)) of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
%             demon_attack(Skill, Self, Target);
%         false -> ok
%     end.

%% [触发几率]%几率附加角色攻击的[攻击百分比]%攻击玩家攻击的目标
% script_10610(Skill = #c_skill{id = SkillId, name = _SkillName, args = [Rate, DmgRatio]}, Self = #fighter{id = Sid, name = _Sname, attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}, Target, _Args) ->
%     case util:rand(1, 100) =< Rate of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
%             TalismanDmg = round((DmgMin + DmgMax)/2 * DmgRatio / 100),
%             talisman_attack(Skill, Self, Target, TalismanDmg);
%         false -> ok
%     end.

%% 玩家受到伤害时[触发几率]%几率减免受到的伤害的[减免百分比]%
% script_10620(#c_skill{id = SkillId, name = _SkillName, args = [Rate, ReduceRatio]}, _Target, #fighter{id = Sid, name = _Sname}, [DmgHp, DmgMp]) ->
%     DmgHp1 = case util:rand(1, 100) =< Rate of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_hit),
%             case ReduceRatio > 0 of
%                 true -> util:check_range(round(DmgHp * (100 - ReduceRatio)/100), 0, DmgHp);
%                 false -> DmgHp
%             end;
%         false -> DmgHp
%     end,
%     {DmgHp1, DmgMp}.

%% [触发几率]%几率为玩家攻击的目标附加BUFF
% script_10630(#c_skill{id = SkillId, name = _SkillName, args = [Rate], buff_target = BuffTarget}, #fighter{id = Sid, name = _Sname}, _Target, _Args) ->
%     case util:rand(1, 100) =< Rate of
%         true ->
%             ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
%             combat:add_to_show_passive_skills(Sid, SkillId, ?show_passive_skills_before),
%             BuffTarget;
%         false -> []
%     end.

%%--------------------------------------------------
%% 怒气技能脚本
%%--------------------------------------------------
%% 计算这次攻击获取到的怒气值
anger_calc(AngerPassiveSkills, _AngerMax, HpDmg, HpMax) ->
    Anger = if
        HpDmg < (HpMax * 0.02) andalso HpDmg < 500 -> ?MAX_ANGER * 0.03;
        HpDmg < (HpMax * 0.02) andalso HpDmg >= 500 -> ?MAX_ANGER * 0.12;
        HpDmg >= (HpMax * 0.02) andalso HpDmg < (HpMax * 0.1) -> ?MAX_ANGER * 0.12;
        HpDmg >= (HpMax * 0.1) andalso HpDmg < (HpMax * 0.15) -> ?MAX_ANGER * 0.17;
        HpDmg >= (HpMax * 0.15) andalso HpDmg < (HpMax * 0.2) -> ?MAX_ANGER * 0.25;
        HpDmg >= (HpMax * 0.2) andalso HpDmg < (HpMax * 0.3) -> ?MAX_ANGER * 0.3;
        HpDmg >= (HpMax * 0.3) andalso HpDmg < (HpMax * 0.4) -> ?MAX_ANGER * 0.45;
        HpDmg >= (HpMax * 0.4) andalso HpDmg < (HpMax * 0.5) -> ?MAX_ANGER * 0.7;
        HpDmg >= (HpMax * 0.5) -> ?MAX_ANGER;
        true -> 0
    end,
    Rate = anger_calc_speed(AngerPassiveSkills),
    round(Anger * Rate).
anger_calc(Pid, HpDmg) ->
    case combat:f(by_pid, Pid) of
        {_, #fighter{hp_max = HpMax, anger_max = AngerMax, type = ?fighter_type_role}} ->
            AngerPassiveSkills = case combat:f_ext(by_pid, Pid) of
                #fighter_ext_role{anger_passive_skills = L1} -> L1;
                _ -> []
            end,
            anger_calc(AngerPassiveSkills, AngerMax, HpDmg, HpMax);
        _ -> 0
    end.

%% 计算怒气值上限
anger_calc_max(BaseAngerMax, AngerPassiveSkills) ->
    case f(by_scriptid, AngerPassiveSkills, 10830) of
        #c_skill{args = [Val, _]} -> BaseAngerMax + Val;
        _ -> BaseAngerMax
    end.

%% 计算怒气值累加速度
anger_calc_speed(AngerPassiveSkills) ->
    case f(by_scriptid, AngerPassiveSkills, 10830) of
        #c_skill{args = [_, Val]} -> 1 + Val/100;
        _ -> 1
    end.

%% 重新计算怒气相关buff参数
anger_calc_buff_args(Buff = #c_buff{recalc_args = RecalcArgs, args = Args}, Caster, Target) ->
    case RecalcArgs of
        undefined -> Args;
        _ -> RecalcArgs(Buff, Caster, Target)
    end.

%% 重新计算怒气值相关效果加成
anger_calc_effect(Val, #fighter{anger = Anger}) ->
    Val * ((Anger-?MAX_ANGER)/2+100)/100.

%% 怒气技能：治疗血气
% script_10800(Skill = #c_skill{args = [HealHp]}, Self, _Target) ->
%     HealHp1 = anger_calc_effect(HealHp, Self),
%     heal(Skill, Self, Self, HealHp1).

%% 怒气技能：治疗百分比血气
% script_10810(Skill = #c_skill{args = [HpRatio]}, Self = #fighter{hp_max = HpMax}, _Target) ->
%     HealHp = round(HpMax * HpRatio / 100),
%     HealHp1 = anger_calc_effect(HealHp, Self),
%     heal(Skill, Self, Self, HealHp1).

%% 怒气技能：触发BUFF
% script_10820(Skill = #c_skill{buff_target = BuffTarget}, Self, Target) ->
%     %%combat:add_to_show_passive_skills(SkillId, Sid, ?show_passive_skills_before),
%     %% 对自己施加BUFF
%     %%lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Self) end, BuffSelf).
%     %% 重新计算参数
%     NewBuffTarget = [Buff#c_buff{args = anger_calc_buff_args(Buff, Self, Target)} || Buff <- BuffTarget],
%     NewSkill = Skill#c_skill{buff_target=NewBuffTarget},
%     cast(NewSkill, Self, Target).
            

%% 怒气被动技能：增加怒气累加速度
%% script_10830(Skill, Self, Target, Args) -> ok.


%%--------------------------------------------------
%% 阵法的脚本 {aspd, 5}
%%--------------------------------------------------
u([], F) -> F;
u([{Key, Val}|T], F) when is_record(F, fighter) ->
    NF = case Key of
        dmg_per -> %% 攻击比
            #fighter{attr = Attr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}} = F,
            DmgMin1 = round(DmgMin * (1 + Val/1000)),
            DmgMax1 = round(DmgMax * (1 + Val/1000)),
            F#fighter{attr = Attr#attr{dmg_min = DmgMin1, dmg_max = DmgMax1}};
        hp_max_per -> %% 血气比
            #fighter{hp = Hp, hp_max = HpMax} = F,
            Hp1 = round(Hp * (1 + Val/1000)),
            HpMax1 = round(HpMax * (1 + Val/1000)),
            F#fighter{hp = Hp1, hp_max = HpMax1};
        aspd -> %% 攻速/敏捷
            #fighter{attr = Attr = #attr{aspd = Aspd}} = F,
            F#fighter{attr = Attr#attr{aspd = Aspd + Val}};
        critrate -> %% 暴击率
            #fighter{attr = Attr = #attr{critrate = CritRate}} = F,
            F#fighter{attr = Attr#attr{critrate = round(CritRate * (1 + Val/1000))}};
        defence -> %% 防御值
            #fighter{attr = Attr = #attr{defence = Defence}} = F,
            F#fighter{attr = Attr#attr{defence = Defence + Val}};
        defence_per -> %% 防御比
            #fighter{attr = Attr = #attr{defence = Defence}} = F,
            F#fighter{attr = Attr#attr{defence = round(Defence * (1 + Val/1000))}};
        hitrate -> %% 命中率
            #fighter{attr = Attr = #attr{hitrate = HitRate}} = F,
            F#fighter{attr = Attr#attr{hitrate = round(HitRate * (1 + Val/1000))}};
        rst_all_per -> %% 全抗比
            #fighter{attr = Attr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood, resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResistEarth}} = F,
            ResistMetal1 = round(ResistMetal * (1 + Val/1000)),
            ResistWood1 = round(ResistWood * (1 + Val/1000)),
            ResistWater1 = round(ResistWater * (1 + Val/1000)),
            ResistFire1 = round(ResistFire * (1 + Val/1000)),
            ResistEarth1 = round(ResistEarth * (1 + Val/1000)),
            F#fighter{attr = Attr#attr{resist_metal = ResistMetal1, resist_wood = ResistWood1, resist_water = ResistWater1, resist_fire = ResistFire1, resist_earth = ResistEarth1}};
        _Other ->
            ?ERR("未匹配的属性值:~w", [_Other]),
            F
    end,
    u(T, NF);
u([{Key, Val}|T], F) when is_record(F, c_pet) ->
    #c_pet{skills = Skills} = F,
    case lists:keyfind(Key, #c_pet_skill.id, Skills) of
        false -> u(T, F);
        Skill = #c_pet_skill{args = [X|Y]}->
            X1 = X + Val/10,
            NF = F#c_pet{skills = [Skill#c_pet_skill{args = [X1|Y]} | lists:keydelete(Key, #c_pet_skill.id, Skills)]},
            u(T, NF)
    end.


%% 加角色属性的阵法
script_20000(#c_lineup{args = Args}, Self = #converted_fighter{fighter = F}) -> 
    case Args of
        [_|_] ->
            NF = u(Args, F),
            Self#converted_fighter{fighter = NF};
        _ -> Self
    end.

%% 加宠物技能触发率的阵法
script_30000(#c_lineup{args = Args}, Self = #converted_fighter{fighter = #fighter{type = Type}, fighter_ext = Fext}) ->
    case Type of
        ?fighter_type_role -> 
            #fighter_ext_role{active_pet = ActivePet, backup_pets = BackupPets} = Fext,
            case Args of
                [_|_] ->
                    ActivePet1 = case ActivePet of
                        undefined -> undefined;
                        _ -> u(Args, ActivePet)
                    end,
                    BackupPets1 = case BackupPets of
                        [_|_] ->
                            [u(Args, BackupPet) || BackupPet <- BackupPets];
                        _ -> BackupPets
                    end,
                    Self#converted_fighter{fighter_ext = Fext#fighter_ext_role{active_pet = ActivePet1, backup_pets = BackupPets1}};
                _ -> Self
            end;
        _ -> Self
    end.

%% 护盾
%% -> {bool(), int(), int()}    {是否使用了护盾, 抵消护盾后的伤害, 护盾消耗量}
use_shield(Tpid, Dmg) ->
    {_, F = #fighter{shield = Shield, buff_atk = _BuffAtk, buff_hit = _BuffHit, buff_round = _BuffRound}} = combat:f(by_pid, Tpid),
    case Shield > 0 of
        false ->
            {false, Dmg, 0};
        true -> 
            Remain = Shield - Dmg,
            ShieldReduce = case Remain > 0 of
                true ->
                    combat:update_fighter(Tpid, [{shield, Remain}]),
                    Dmg;
                _ ->
                    %[ combat:buff_del(Buff, Tpid) || Buff <- BuffAtk++BuffHit++BuffRound, Buff#c_buff.id =:= 101400 ],
                    combat:buff_clear_duration(F, 101400),
                    Shield
            end,
            {true, erlang:max(0, Dmg - Shield), ShieldReduce}
    end.

%% 尝试激活被动技能，返回成功激活的被动技能
%% -> [#c_skill{}]
try_act_passive_after(ActiveSkill, Self = #fighter{pid = Pid}, Target) ->
    PassiveSkills = case combat:f_ext(by_pid, Pid) of
        #fighter_ext_role{passive_skills = L} -> L;
        #fighter_ext_npc{passive_skills = L} -> L;
        #fighter_ext_pet{passive_skills = L} -> L;
        _ -> []
    end,   
    try_act_passive_after(ActiveSkill, PassiveSkills, Self, Target, []).

try_act_passive_after(_ActiveSkill, [], _Self, _Target, Acc) ->
    Acc;
try_act_passive_after(ActiveSkill, [PassiveSkill|T], Self = #fighter{id = Sid}, Target, Acc) ->
    Acc1 = case PassiveSkill#c_skill.script of
        undefined -> Acc;
        ScriptMod -> 
            case catch ScriptMod:try_act_passive_after(ActiveSkill, PassiveSkill, Self, Target) of
                {'EXIT', {undef, _}} ->
                    ?DEBUG("~p没有定义try_act_passive_after脚本", [ScriptMod]),
                    Acc;
                {'EXIT', _Reason} ->
                    ?ERR("~p:try_act_passive_after error: ~w", [ScriptMod, _Reason]),
                    ?log("~p:try_act_passive_after error: ~w", [ScriptMod, _Reason]),
                    Acc;
                true ->
                    combat:add_to_show_passive_skills(Sid, PassiveSkill#c_skill.id, ?show_passive_skills_hit),
                    [PassiveSkill|Acc];
                _ ->
                    Acc
            end
    end,
    try_act_passive_after(ActiveSkill, T, Self, Target, Acc1).

%% -> {Dmg, NewHp}
undying_eff(Dmg, #fighter{is_undying = IsUndying, hp = Hp}) ->
    NewHp = Hp - Dmg,
    case NewHp =< 0 andalso IsUndying =:= ?true of
        true -> {Hp - 1, 1};  %% 濒死状态，最后气血总为1
        false -> {Dmg, NewHp}
    end.

