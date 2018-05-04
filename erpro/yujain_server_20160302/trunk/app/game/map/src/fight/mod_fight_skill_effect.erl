%%%-------------------------------------------------------------------
%%% @author jiangxiaowei
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 技能效果实现
%%% @end
%%% Created : 27. 十月 2015 14:47
%%%-------------------------------------------------------------------

-module(mod_fight_skill_effect).

-include("mgeem.hrl").

%% API
-export([do/3,do_self/2]).

%% @doc 对目标作用技能效果
-spec do(SkillInfo, ActorInfo, TargetInfo) -> {NewTarget, ResultUnitList} when
    SkillInfo :: #r_skill_info{}, ActorInfo :: #r_map_actor{}, TargetInfo :: #r_map_actor{},
    NewTarget :: #r_map_actor{}, ResultUnitList :: list(#p_attack_result_unit{}).
do(SkillInfo = #r_skill_info{target_effects = Effects}, ActorInfo, TargetInfo) ->
    EffectInfos = [begin [Effect] = cfg_skill_effect:find(EffectId), Effect end||EffectId <- Effects],
    SortList = lists:keysort(#r_skill_effect.type, EffectInfos),
    do_effect(lists:reverse(SortList), SkillInfo, ActorInfo, TargetInfo, []).

do_effect([], _SkillInfo, _ActorInfo, TargetInfo, EffectResult) ->
    {TargetInfo, lists:reverse(EffectResult)};
do_effect([Effect|T], SkillInfo, ActorInfo, TargetInfo, EffectResult) ->
    case effect(Effect, SkillInfo, ActorInfo, TargetInfo) of
        {NewActorInfo, NewTargetInfo, ignore} ->
            do_effect(T, SkillInfo, NewActorInfo, NewTargetInfo, EffectResult);
        {NewActorInfo, NewTargetInfo, Result} ->
            do_effect(T, SkillInfo, NewActorInfo, NewTargetInfo, [Result|EffectResult])
    end.

%% @doc 对自身作用技能效果
-spec do_self(SkillInfo,ActorInfo) -> {NewTarget, ResultUnitList} when
    SkillInfo :: #r_skill_info{}, ActorInfo :: #r_map_actor{}, 
    NewTarget :: #r_map_actor{}, ResultUnitList :: list(#p_attack_result_unit{}).
do_self(SkillInfo = #r_skill_info{self_effects = Effects},ActorInfo) ->
    EffectInfos = [begin [Effect] = cfg_skill_effect:find(EffectId), Effect end||EffectId <- Effects],
    SortList = lists:keysort(#r_skill_effect.type, EffectInfos),
    do_self_effect(lists:reverse(SortList), SkillInfo, ActorInfo, []).

do_self_effect([], _SkillInfo, ActorInfo, EffectResult) ->
    {ActorInfo,lists:reverse(EffectResult)};
do_self_effect([Effect = #r_skill_effect{type=?SKILL_EFFECT_TYPE_ADD_HP}|T],SkillInfo,ActorInfo,EffectResult) ->
    do_self_effect2(Effect,T,SkillInfo,ActorInfo,EffectResult);
do_self_effect([Effect = #r_skill_effect{type=?SKILL_EFFECT_TYPE_ADD_BUFF}|T],SkillInfo,ActorInfo,EffectResult) ->
    do_self_effect2(Effect,T,SkillInfo,ActorInfo,EffectResult);
do_self_effect([Effect = #r_skill_effect{type=?SKILL_EFFECT_TYPE_BORN_MONSTER}|T],SkillInfo,ActorInfo,EffectResult) ->
    do_self_effect2(Effect,T,SkillInfo,ActorInfo,EffectResult);
do_self_effect([_Effect | T],SkillInfo,ActorInfo,EffectResult) ->
    do_self_effect(T, SkillInfo, ActorInfo, EffectResult).

do_self_effect2(Effect,T,SkillInfo,ActorInfo,EffectResult) ->
    case effect(Effect, SkillInfo, ActorInfo, ActorInfo) of
        {_NewActorInfo, NewTargetInfo, ignore} ->
            do_self_effect(T, SkillInfo, NewTargetInfo, EffectResult);
        {_NewActorInfo, NewTargetInfo, Result} ->
            do_self_effect(T, SkillInfo, NewTargetInfo, [Result|EffectResult])
    end.

    
%%% ========================================================================
%%% 技能效果
%%% ========================================================================

%% 过滤死亡处理
effect(_Effect, #r_skill_info{target_type=SkillTargetType}, ActorInfo, #r_map_actor{attr = #p_fight_attr{hp = Hp}} = TargetInfo) 
  when Hp =< 0 andalso SkillTargetType =/= ?F_TARGET_TYPE_OVERLAP_SERIAL ->
    {ActorInfo, TargetInfo, ignore};
            
%% 物理攻击
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_BASE_PHY_ATTACK, a = A}, SkillInfo, ActorInfo, TargetInfo) ->
    #r_skill_info{contain_base_attack = CBA, calc_index = CI} = SkillInfo,
    #r_map_actor{attr = Attr, temp_attr=TempAttr} = ActorInfo,
    #r_map_actor{attr=TargetAttr,temp_attr=TargetTempAttr,fight_buff=TargetFightBuffList} = TargetInfo,
    ActorFightAttr = mod_attr:merge_fight_attr(Attr, TempAttr),
    TargetFightAttr = mod_attr:merge_fight_attr(TargetAttr, TargetTempAttr),
    #p_fight_attr{double_attack = DA, hit = Hit, phy_attack = PA, attack_skill = AS} = ActorFightAttr,
    #p_fight_attr{tough = T, miss = M, phy_defence = PD, phy_defence_skill = PDS} = TargetFightAttr,
    ReduceHurt = mod_fight_calculate:reduce_hurt(TargetFightBuffList),
    Hurt = mod_fight_calculate:hurt(CI, A, case CBA == 1 of true -> PA; false -> 0 end, AS, PD, PDS, ReduceHurt),
    {HurtType, RealHurt} = mod_fight_calculate:attack(Hurt, DA, Hit, T, M),
    case mod_fight_calculate:is_unrivalled(TargetFightBuffList) of
        true ->
            NewTargetFightAttr = TargetAttr,
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = ?HURT_TYPE_UNRIVALLED};
        _ ->
            NewTargetFightAttr = mod_fight_misc:reduce_hp(RealHurt, TargetAttr),
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = HurtType}
    end,
    {ActorInfo, TargetInfo#r_map_actor{attr = NewTargetFightAttr}, Result};

%% 魔法攻击
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_BASE_MAGIC_ATTACK, a = A}, SkillInfo, ActorInfo, TargetInfo) ->
    #r_skill_info{contain_base_attack = CBA, calc_index = CI} = SkillInfo,
    #r_map_actor{attr = Attr, temp_attr=TempAttr} = ActorInfo,
    #r_map_actor{attr=TargetAttr,temp_attr=TargetTempAttr,fight_buff=TargetFightBuffList} = TargetInfo,
    ActorFightAttr = mod_attr:merge_fight_attr(Attr, TempAttr),
    TargetFightAttr = mod_attr:merge_fight_attr(TargetAttr, TargetTempAttr),
    #p_fight_attr{double_attack = DA, hit = Hit, magic_attack = PA, attack_skill = AS} = ActorFightAttr,
    #p_fight_attr{tough = T, miss = M, magic_defence = PD, magic_defence_skill = PDS} = TargetFightAttr,
    ReduceHurt = mod_fight_calculate:reduce_hurt(TargetFightBuffList),
    Hurt = mod_fight_calculate:hurt(CI, A, case CBA == 1 of true -> PA; false -> 0 end, AS, PD, PDS,ReduceHurt),
    {HurtType, RealHurt} = mod_fight_calculate:attack(Hurt, DA, Hit, T, M),
    case mod_fight_calculate:is_unrivalled(TargetFightBuffList) of
        true ->
            NewTargetFightAttr = TargetAttr,
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = ?HURT_TYPE_UNRIVALLED};
        _ ->
            NewTargetFightAttr = mod_fight_misc:reduce_hp(RealHurt, TargetAttr),
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = HurtType}
    end,
    {ActorInfo, TargetInfo#r_map_actor{attr = NewTargetFightAttr}, Result};

%% 物理真实伤害
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ABSOLUTE_PHY_ATTACK, a = A}, SkillInfo, ActorInfo, TargetInfo) ->
    #r_skill_info{contain_base_attack = CBA} = SkillInfo,
    #r_map_actor{attr = Attr, temp_attr=TempAttr} = ActorInfo,
    #r_map_actor{attr=TargetAttr,temp_attr=TargetTempAttr,fight_buff=TargetFightBuffList} = TargetInfo,
    ActorFightAttr = mod_attr:merge_fight_attr(Attr, TempAttr),
    TargetFightAttr = mod_attr:merge_fight_attr(TargetAttr, TargetTempAttr),
    #p_fight_attr{double_attack = DA, hit = Hit, phy_attack = PA} = ActorFightAttr,
    #p_fight_attr{tough = T, miss = M} = TargetFightAttr,
    Hurt = case CBA == 1 of true -> PA + A; false -> A end,
    ReduceHurt = mod_fight_calculate:reduce_hurt(TargetFightBuffList),
    {HurtType, RealHurt} = mod_fight_calculate:attack(Hurt, DA, Hit, T, M, ReduceHurt),
    case mod_fight_calculate:is_unrivalled(TargetFightBuffList) of
        true ->
            NewTargetFightAttr = TargetAttr,
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = ?HURT_TYPE_UNRIVALLED};
        _ ->
            NewTargetFightAttr = mod_fight_misc:reduce_hp(RealHurt, TargetAttr),
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = HurtType}
    end,
    {ActorInfo, TargetInfo#r_map_actor{attr = NewTargetFightAttr}, Result};

%% 魔法真实伤害
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ABSOLUTE_MAGIC_ATTACK, a = A}, SkillInfo, ActorInfo, TargetInfo) ->
    #r_skill_info{contain_base_attack = CBA} = SkillInfo,
    #r_map_actor{attr = Attr, temp_attr=TempAttr} = ActorInfo,
    #r_map_actor{attr=TargetAttr,temp_attr=TargetTempAttr,fight_buff=TargetFightBuffList} = TargetInfo,
    ActorFightAttr = mod_attr:merge_fight_attr(Attr, TempAttr),
    TargetFightAttr = mod_attr:merge_fight_attr(TargetAttr, TargetTempAttr),
    #p_fight_attr{double_attack = DA, hit = Hit, magic_attack = PA} = ActorFightAttr,
    #p_fight_attr{tough = T, miss = M} = TargetFightAttr,
    Hurt = case CBA == 1 of true -> PA + A; false -> A end,
    ReduceHurt = mod_fight_calculate:reduce_hurt(TargetFightBuffList),
    {HurtType, RealHurt} = mod_fight_calculate:attack(Hurt, DA, Hit, T, M, ReduceHurt),
    case mod_fight_calculate:is_unrivalled(TargetFightBuffList) of
        true ->
            NewTargetFightAttr = TargetAttr,
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = ?HURT_TYPE_UNRIVALLED};
        _ ->
            NewTargetFightAttr = mod_fight_misc:reduce_hp(RealHurt, TargetAttr),
            Result = #p_attack_result_unit{result_type = ?EFFECT_REDUCE_HP, result_value = RealHurt, hurt_type = HurtType}
    end,
    {ActorInfo, TargetInfo#r_map_actor{attr = NewTargetFightAttr}, Result};

%% 加BUFF
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ADD_BUFF, a = BuffId}, 
       #r_skill_info{skill_id=SkillId},#r_map_actor{skill=SkillList} = ActorInfo,
       #r_map_actor{actor_id = RoleId, actor_type = ?ACTOR_TYPE_ROLE} = TargetInfo)  ->
    case mod_map:get_role_world_pid(RoleId) of
        undefined -> ignore;
        RoleWorldPId ->
            #p_actor_skill{level=SkillLevel} = lists:keyfind(SkillId, #p_actor_skill.skill_id, SkillList),
            RoleWorldPId ! {async_exec, fun mod_buff:add_object_buff/5, [RoleId, ?ACTOR_TYPE_ROLE, [BuffId],SkillId,SkillLevel]}
    end,
    {ActorInfo, TargetInfo, ignore};
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ADD_BUFF, a = BuffId}, 
       #r_skill_info{skill_id=SkillId},#r_map_actor{skill=SkillList} = ActorInfo,
       #r_map_actor{actor_id = TargetId, actor_type = ?ACTOR_TYPE_PET} = TargetInfo)  ->
    #p_map_pet{role_id = RoleId} = mod_map:get_actor_info(TargetId, ?ACTOR_TYPE_PET),
    case mod_map:get_role_world_pid(RoleId) of
        undefined -> ignore;
        RoleWorldPId ->
            #p_actor_skill{level=SkillLevel} = lists:keyfind(SkillId, #p_actor_skill.skill_id, SkillList),
            RoleWorldPId ! {async_exec, fun mod_buff:add_object_buff/5, [TargetId, ?ACTOR_TYPE_PET, [BuffId],SkillId,SkillLevel]}
    end,
    {ActorInfo, TargetInfo, ignore};
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ADD_BUFF, a = BuffId}, 
       #r_skill_info{skill_id=SkillId},#r_map_actor{skill=SkillList} = ActorInfo,
       #r_map_actor{actor_id = TargetId, actor_type = ?ACTOR_TYPE_MONSTER} = TargetInfo)  ->
    #p_actor_skill{level=SkillLevel} = lists:keyfind(SkillId, #p_actor_skill.skill_id, SkillList),
    self() ! {async_exec, fun mod_buff:add_object_buff/5, [TargetId, ?ACTOR_TYPE_MONSTER, [BuffId],SkillId,SkillLevel]},
    {ActorInfo, TargetInfo, ignore};

%% 加血
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_ADD_HP, a = V, b = R}, _SkillInfo, ActorInfo, TargetInfo) ->
    R1 = max(0, min(100, R)),
    #r_map_actor{attr = FightAttr} = TargetInfo,
    AddHp = erlang:trunc(V + R1 * FightAttr#p_fight_attr.max_hp / 100),
    NewFightAttr = mod_fight_misc:add_hp(AddHp, FightAttr),
    Result = #p_attack_result_unit{result_type = ?EFFECT_ADD_HP, result_value = AddHp},
    {ActorInfo, TargetInfo#r_map_actor{attr = NewFightAttr}, Result};

%% 召唤怪物
effect(#r_skill_effect{type = ?SKILL_EFFECT_TYPE_BORN_MONSTER, 
                       a = MonsterTypeIdA, b = NumberA, c = MonsterTypeIdB, d = NumberB, e=IsRandom}, _SkillInfo, 
       #r_map_actor{actor_id=ActorId,actor_type=ActorType,skill_state=ActorSkillState} = ActorInfo, TargetInfo) ->
    GroupId = mod_fight_misc:get_map_actor_groupid(ActorId,ActorType),
    case ActorSkillState of
        undefined ->
            TargetPosList = [];
        #p_actor_skill_state{effect_pos=TargetPosList} ->
            next
    end,
    case TargetPosList =/= [] of
        true ->
            effect_born_monster(GroupId,MonsterTypeIdA,NumberA,MonsterTypeIdB,NumberB,IsRandom,TargetPosList),
            ok;
        _ ->
            next
    end,
    {ActorInfo, TargetInfo, ignore};

%% 容错
effect(_SkillEffect, _SkillInfo, ActorInfo, TargetInfo) ->
    {ActorInfo, TargetInfo, ignore}.

%% 技能效果召唤怪物
effect_born_monster(GroupId,MonsterTypeIdA,NumberA,MonsterTypeIdB,NumberB,IsRandom,TargetPosList) ->
    case NumberA > 0 andalso cfg_monster:find(MonsterTypeIdA) of
        #r_monster_info{type_id=MonsterTypeIdA} ->
            BornMonsterIdListT = [ MonsterTypeIdA || IndexA <- lists:seq(1, NumberA), IndexA > 0];
        _ ->
            BornMonsterIdListT = []
    end,
    case NumberB > 0 andalso cfg_monster:find(MonsterTypeIdB) of
        #r_monster_info{type_id=MonsterTypeIdB} ->
            BornMonsterIdList = [ MonsterTypeIdB || IndexB <- lists:seq(1, NumberB), IndexB > 0] ++ BornMonsterIdListT;
        _ ->
            BornMonsterIdList = BornMonsterIdListT
    end,
    case IsRandom of
        1 ->
            #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
            Step = 2,
            PosList = lists:foldl(
                        fun(#p_pos{x=X,y=Y},AccPosList) ->
                                {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
                                TileList = [{A, B} || A <- lists:seq(Tx - Step, Tx + Step),
                                                      B <- lists:seq(Ty - Step, Ty + Step),
                                                      A > 0, B > 0,
                                                      mod_map:check_tile_pos(McmModule, A, B) == true],
                                [TileList | AccPosList]
                        end, [], TargetPosList),
            Len = erlang:length(PosList),
            effect_born_monster3(BornMonsterIdList,GroupId,PosList,Len,1);
        _ ->
            Len = erlang:length(TargetPosList),
            effect_born_monster2(BornMonsterIdList,GroupId,TargetPosList,Len,1)
    end,
    ok.
%% 中心点出生
effect_born_monster2([],_GroupId,_TargetPosList,_Len,_Index) -> ok;
effect_born_monster2([MonsterTypeId | BornMonsterIdList],GroupId,TargetPosList,Len,Index) ->
    Pos = lists:nth(Index, TargetPosList),
    MonsterParam = #r_monster_param{born_type=?MONSTER_BORN_TYPE_NOW,
                                    type_id = MonsterTypeId,
                                    reborn_type = ?MONSTER_REBORN_TYPE_NORMAL,
                                    dead_fun = undefined,
                                    group_id = GroupId,
                                    pos = Pos,
                                    dir=0},
    mod_map_monster:init_monster(MonsterParam),
    case Index + 1 > Len of
        true ->
            NewIndex = 1;
        _ ->
            NewIndex = Index + 1
    end,
    effect_born_monster2(BornMonsterIdList,GroupId,TargetPosList,Len,NewIndex).

%% 生成的怪物点是随机的
effect_born_monster3([],_GroupId,_PosList,_Len,_Index) -> ok;
effect_born_monster3([MonsterTypeId | BornMonsterIdList],GroupId,PosList,Len,Index) ->
    SubPosList = lists:nth(Index, PosList),
    SubLen = erlang:length(SubPosList),
    {Tx,Ty} = lists:nth(common_tool:random(1, SubLen),SubPosList),
    X = erlang:trunc(Tx * ?MAP_TILE_SIZE + common_tool:random(1, ?MAP_TILE_SIZE)),
    Y = erlang:trunc(Ty * ?MAP_TILE_SIZE + common_tool:random(1, ?MAP_TILE_SIZE)),
    MonsterParam = #r_monster_param{born_type=?MONSTER_BORN_TYPE_NOW,
                                    type_id = MonsterTypeId,
                                    reborn_type = ?MONSTER_REBORN_TYPE_NORMAL,
                                    dead_fun = undefined,
                                    group_id = GroupId,
                                    pos = #p_pos{x=X,y=Y},
                                    dir=0},
    mod_map_monster:init_monster(MonsterParam),
    case Index + 1 > Len of
        true ->
            NewIndex = 1;
        _ ->
            NewIndex = Index + 1
    end,
    effect_born_monster3(BornMonsterIdList,GroupId,PosList,Len,NewIndex).
