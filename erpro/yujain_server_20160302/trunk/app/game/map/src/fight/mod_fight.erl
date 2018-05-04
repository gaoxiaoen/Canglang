%%%-------------------------------------------------------------------
%%% @author jiangxiaowei
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 攻击流程
%%% @end
%%% Created : 26. 十月 2015 13:39
%%%-------------------------------------------------------------------
-module(mod_fight).

-include("mgeem.hrl").

%% API
-export([apply_skill/7, 
         get_common_cd/2,
         erase_common_cd/2, 
         get_skill_cd_time/3,
         erase_skill_cd_list/2, 
         break_chant/2]).

-export([handle/1]).

-define(BREAK(Reason, ErrorCode), erlang:throw({break, Reason, ErrorCode})).

%% ====================================================================
%% Protocol Handler
%% ====================================================================

handle({?FIGHT,?FIGHT_ATTACK, DataRecord, RoleId, _PId,_Line}) ->
    do_fight_attack(DataRecord,RoleId);
handle({skill_delay, Info}) ->
    do_apply_skill_delay_end(Info);
handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w", [Info]).

%% @hidden 玩家／宠物释放技能
do_fight_attack(#m_fight_attack_tos{
                    skill_id = SkillId,
                    step = Step,
                    src_id = ActorId,
                    src_type = ActorType,
                    target_id = TargetId,
                    target_type = TargetType,
                    target_pos = TargetPos} = DataRecord, RoleId) ->
    case mgeem_map:get_map_type() == ?MAP_TYPE_FB andalso (ActorId == RoleId orelse ActorId == mod_map:get_map_role_pet_id(RoleId)) of
        true ->
            apply_skill(SkillId, Step, ActorId, ActorType, TargetId, TargetType, TargetPos);
        false ->
            ?ERROR_MSG("fight attack message illegal， roleId:~w, param:~w",[RoleId, DataRecord])
    end.

%% ====================================================================
%% API Functions
%% ====================================================================

%% @doc 释放技能
-spec apply_skill(SkillId, Step, ActorId, ActorType, TargetId, TargetType, TargetPos) -> ok when
    SkillId :: integer(),
    Step :: integer(),
    ActorId :: integer(),
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_PET,
    TargetId :: integer(),
    TargetType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_PET,
    TargetPos :: #p_pos{}.
apply_skill(SkillId, Step, ActorId, ActorType, PTargetId, PTargetType, PTargetPos) ->
    case catch check_apply_skill(SkillId, ActorId, ActorType, PTargetId, PTargetType, PTargetPos) of
        {delay, DelayType, ApplySkillInfo, ActorInfo, TargetId, TargetType, TargetPos} ->
            do_apply_skill_delay(ApplySkillInfo, Step, ActorInfo, TargetId, TargetType, TargetPos, DelayType);
        {ok, ApplySkillInfo,ActorInfo,TargetId,TargetType,TargetPos,TargetInfo} ->
            do_apply_skill(ApplySkillInfo, Step, ActorInfo,TargetId,TargetType,TargetPos,TargetInfo);
        {break, Reason, ErrorCode} ->
            do_apply_skill_error(SkillId, Step, ActorId, ActorType, Reason, ErrorCode);
        Other ->
            do_apply_skill_error(SkillId, Step, ActorId, ActorType, Other, ?_RC_FIGHT_ATTACK_000)
    end.
%% @doc 技能消耗
do_skill_consume(TotalConsumeMp, #r_skill_info{skill_id = SkillId, cd = CDTime, common_cd = CommonCD,consume_anger=ConsumeAnger},
                 ActorInfo = #r_map_actor{actor_id = ActorId, actor_type = ActorType,add_mp_time=AddMpTime, attr = ActorAttr}) ->
    Now = mgeem_map:get_now2(),

    %% 技能公共CD
    set_common_cd(ActorId, ActorType, Now + CommonCD),
    
    %% 技能进入CD
    set_skill_cd_time(ActorId, ActorType, SkillId, Now + CDTime),
    %% 技能消耗怒气
    NewActorFightAttr = mod_fight_misc:reduce_anger(ConsumeAnger, ActorAttr),
    #p_fight_attr{max_mp=MaxMp} = NewActorFightAttr,
    %% 技能消耗魔法
    NewActorFightAttr2 = mod_fight_misc:reduce_mp(TotalConsumeMp, NewActorFightAttr),
    #p_fight_attr{mp=CurMp} = NewActorFightAttr2,
    case AddMpTime == 0 andalso MaxMp > CurMp of
        true ->
            NewAddMpTime = mgeem_map:get_now2();
        _ ->
            NewAddMpTime = AddMpTime
    end,
    NewActorInfo = ActorInfo#r_map_actor{add_mp_time=NewAddMpTime,attr = NewActorFightAttr2},
    mod_map:set_map_actor(ActorId, ActorType, NewActorInfo),
    NewActorInfo.

%% @doc 技能延迟释放
do_apply_skill_delay(ApplySkillInfo,Step,ActorInfo,TargetId,TargetType,TargetPos,DelayType) ->
    #r_skill_info{skill_id=SkillId,target_type=SkillTargetType,chant_time=ChantTime,delay_time=DelayTime} = ApplySkillInfo,
    #r_map_actor{actor_id = ActorId, actor_type = ActorType, skill=ActorSkillList, skill_state=OldActorSkillState} = ActorInfo,
    #p_actor_skill{level=SkillLevel} = lists:keyfind(SkillId, #p_actor_skill.skill_id, ActorSkillList),
    case OldActorSkillState of
        undefined ->
            EffectPosList = get_skill_delay_effect_pos(SkillTargetType, ApplySkillInfo, ActorInfo, TargetPos);
        #p_actor_skill_state{effect_pos=EffectPosList} ->
            next
    end,
    Now2 = mgeem_map:get_now2(),
    case DelayType of
        ?SKILL_ATTACK_DELAY_TYPE_CHANT ->
            ActorSkillState=#p_actor_skill_state{skill_id=SkillId,level=SkillLevel,start_time=Now2,state=1,effect_pos=EffectPosList},
            NewActorInfo = ActorInfo,
            SkillDelayToc = #m_fight_chant_toc{actor_id = ActorId, actor_type = ActorType, skill_id = SkillId, state = 1,effect_pos=EffectPosList},
            AttrChangeList = [];
        ?SKILL_ATTACK_DELAY_TYPE_DELAY ->
            %% 扣蓝
            ConsumeMp = mod_fight_misc:calc_skill_consume_mp(SkillId, SkillLevel, ApplySkillInfo),
            NewActorInfo = do_skill_consume(ConsumeMp, ApplySkillInfo, ActorInfo),
            #r_map_actor{attr=#p_fight_attr{mp=CurMp,anger=CurAnger}} = NewActorInfo,
            case ChantTime > 0 of
                true -> DelayState = 2;
                _ -> DelayState = 1
            end,
            ActorSkillState=#p_actor_skill_state{skill_id=SkillId,level=SkillLevel,start_time=Now2,state=DelayState,effect_pos=EffectPosList},
            SkillDelayToc = #m_fight_action_toc{actor_id = ActorId, actor_type = ActorType, 
                                                skill_id = SkillId, state = DelayState,
                                                target_pos = TargetPos,effect_pos=EffectPosList},
            AttrChangeList = [#p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MP,int_value=CurMp},
                              #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_ANGER,int_value=CurAnger}]
    end,
%%     ?ERROR_MSG("SkillDelayToc=~w",[SkillDelayToc]),
    mod_map:broadcast_9slice(now, ActorId, ActorType, SkillDelayToc),
    case AttrChangeList of
        [] ->
            ignore;
        _ ->
            case ActorType of
                ?ACTOR_TYPE_ROLE -> RoleId = ActorId;
                ?ACTOR_TYPE_PET -> 
                    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET) of
                        #p_map_pet{role_id=RoleId} -> next;
                        _ -> RoleId = 0
                    end;
                _ -> RoleId = 0
            end,
            case mod_map_role:get_role_gateway_pid(RoleId) of
                undefined ->
                    ignore;
                GatewayPId ->
                    AttrChangeToc = #m_role_attr_change_toc{op_type=0,attr_list=AttrChangeList},
                    common_misc:unicast(GatewayPId, ?ROLE, ?ROLE_ATTR_CHANGE, AttrChangeToc)
            end
    end,
    Msg =  {mod, mod_fight, {skill_delay, {ApplySkillInfo, Step, ActorId, ActorType, TargetId, TargetType, TargetPos, DelayType}}},
    case DelayType of
        ?SKILL_ATTACK_DELAY_TYPE_CHANT ->
            AfterTime = ChantTime;
        ?SKILL_ATTACK_DELAY_TYPE_DELAY ->
            AfterTime = DelayTime
    end,
    Timeref = erlang:send_after(AfterTime, self(), Msg),
    mod_map:set_map_actor(ActorId, ActorType, NewActorInfo#r_map_actor{skill_delay = {SkillId, Timeref, DelayType},
                                                                       skill_state = ActorSkillState}),
    mod_fight_misc:update_actor_info_skill_state(ActorId, ActorType, ActorSkillState),
    after_skill_delay(ActorId, ActorType, DelayType),
    ok.

%% 获取技能命中的区域点
-spec
get_skill_delay_effect_pos(SkillTargetType,ApplySkillInfo,ActorInfo,TargetPos) -> EffectPosList when
    SkillTargetType :: ?F_TARGET_TYPE_SELF_AROUND_TRAP | ?F_TARGET_TYPE_OTHER_AROUND_TRAP | atom,
    ApplySkillInfo :: #r_skill_info{},
    ActorInfo :: #r_map_actor{},
    TargetPos :: #p_pos{},
    EffectPosList :: [] | [#p_pos{}].
get_skill_delay_effect_pos(?F_TARGET_TYPE_SELF_AROUND_TRAP,ApplySkillInfo,ActorInfo,_TargetPos) ->
    #r_skill_info{target_w=TargetW,target_h=TargetH,target_number=TargetNumber} = ApplySkillInfo,
    #r_map_actor{actor_id=ActorId,actor_type=ActorType} = ActorInfo,
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{pos=#p_pos{x=X,y=Y}} -> next;
        #p_map_pet{pos=#p_pos{x=X,y=Y}} -> next;
        #p_map_monster{pos=#p_pos{x=X,y=Y}} -> next;
        _ -> X=undefined,Y=undefined
    end,
    case X of
        undefined ->
            [];
        _ ->
            mod_map_slice:get_random_pos_by_midpoint(X,Y,TargetW,100,TargetH,TargetNumber)
    end;
get_skill_delay_effect_pos(?F_TARGET_TYPE_OTHER_AROUND_TRAP,ApplySkillInfo,_ActorInfo,TargetPos) ->
    #r_skill_info{target_w=TargetW,target_h=TargetH,target_number=TargetNumber} = ApplySkillInfo,
    #p_pos{x=X,y=Y} = TargetPos,
    mod_map_slice:get_random_pos_by_midpoint(X,Y,TargetW,0,TargetH,TargetNumber);
get_skill_delay_effect_pos(_SkillTargetType,_ApplySkillInfo,_ActorInfo,_TargetPos) ->
    [].

%% @doc 技能延迟释放被打断
break_chant(ActorId, ActorType) ->
    case mod_map:get_map_actor(ActorId, ActorType) of
        #r_map_actor{skill_delay = {SkillId, Timeref, ?SKILL_ATTACK_DELAY_TYPE_CHANT}} = ActorInfo->
            erlang:cancel_timer(Timeref),
            ChantToc = #m_fight_chant_toc{actor_id = ActorId, actor_type = ActorType, skill_id = SkillId, state = 2,effect_pos=[]},
            mod_map:broadcast_9slice(now, ActorId, ActorType, ChantToc),
            NewActorInfo = ActorInfo#r_map_actor{skill_delay = undefined,skill_state = undefined},
            mod_map:set_map_actor(ActorId, ActorType, NewActorInfo),
            mod_fight_misc:update_actor_info_skill_state(ActorId, ActorType, undefined),
            after_skill_delay_end(ActorId, ActorType, ?SKILL_ATTACK_DELAY_TYPE_CHANT);
        _ ->
            ok
    end.

after_skill_delay(ActorId, ?ACTOR_TYPE_MONSTER,_DelayType) -> %% 怪物开始技能吟唱
    mod_map_monster:set_monster_skill_delay(ActorId),
    ok;
after_skill_delay(_AcotrId, _ActorType,_DelayType) ->
    ok.


after_skill_delay_end(ActorId, ?ACTOR_TYPE_MONSTER, _DelayType) -> %% 打断怪物技能吟唱
    mod_map_monster:erase_monster_skill_delay(ActorId),
    ok;
after_skill_delay_end(_AcotrId, _ActorType,_DelayType) ->
    ok.

%% @doc 延迟释放技能
do_apply_skill_delay_end(Info) ->
    case catch do_apply_skill_delay_end2(Info) of
        {ok,chant_to_delay} ->
            do_apply_skill_delay_end3(Info);
        ok -> ok;
        ?BREAK_MSG(Reason) ->
            ?DEBUG("skill delay end break:~w",[Reason]);
        Other ->
            ?ERROR_MSG("skill delay end error:~w",[Other])
    end.
do_apply_skill_delay_end2({ApplySkillInfo,Step,ActorId,ActorType,TargetId,TargetType,TargetPos,DelayType}) ->
    #r_skill_info{skill_id=SkillId,delay_time=DelayTime,target_type=SkillTargetType} = ApplySkillInfo,
    case DelayType of
        ?SKILL_ATTACK_DELAY_TYPE_CHANT ->
            case DelayTime > 0 of
                true -> %% 吟唱技能，吟唱结束之后，进入技能动作时间，之后才计算伤害
                    erlang:throw({ok,chant_to_delay});
                _ ->
                    SkillChantToc = #m_fight_chant_toc{actor_id = ActorId, actor_type = ActorType, skill_id = SkillId, state = 0, effect_pos=[]},
                    mod_map:broadcast_9slice(now, ActorId, ActorType, SkillChantToc)
            end;
        _ ->
            next
    end,
    after_skill_delay_end(ActorId, ActorType,DelayType),
    %% 更新状态
    ActorInfo = mod_map:get_map_actor(ActorId, ActorType),
    ?BREAK_IF_NOT(is_record(ActorInfo, r_map_actor), {bad_actor, ActorId, ActorType, ActorInfo}),
    NewActorInfo = ActorInfo#r_map_actor{skill_delay = undefined},
    mod_map:set_map_actor(ActorId, ActorType, NewActorInfo),
    mod_fight_misc:update_actor_info_skill_state(ActorId, ActorType, undefined),
    %% 发起攻击
    ?BREAK_IF_NOT(ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0, actor_dead),
    if SkillTargetType == ?F_TARGET_TYPE_OTHER_AROUND_TRAP ->
           TargetInfo = undefined;
       true ->
           TargetInfo = mod_map:get_map_actor(TargetId, TargetType),
           ?BREAK_IF_NOT(is_record(TargetInfo, r_map_actor), {bad_target, TargetId, TargetType, TargetInfo})
    end,
    do_apply_skill(ApplySkillInfo,Step,NewActorInfo,TargetId,TargetType,TargetPos,TargetInfo,DelayType),
    ok.

%% 吟唱技能，吟唱结束之后，进入技能动作时间，之后才计算伤害
do_apply_skill_delay_end3({ApplySkillInfo,Step,ActorId,ActorType,TargetId,TargetType,TargetPos,?SKILL_ATTACK_DELAY_TYPE_CHANT}) ->
    after_skill_delay_end(ActorId, ActorType,?SKILL_ATTACK_DELAY_TYPE_CHANT),
    case mod_map:get_map_actor(ActorId, ActorType) of
        undefined ->
            ?ERROR_MSG("skill chant to delay error.ApplySkillInfo=~w, ActorId=~w, ActorType=~w",[ApplySkillInfo, ActorId, ActorType]),
            next;
        ActorInfo ->
            NewActorInfo = ActorInfo#r_map_actor{skill_delay = undefined},
            mod_map:set_map_actor(ActorId, ActorType, NewActorInfo),
            do_apply_skill_delay(ApplySkillInfo,Step,NewActorInfo,TargetId, TargetType, TargetPos,?SKILL_ATTACK_DELAY_TYPE_DELAY)
    end,
    ok.

%% @doc 普通释放技能
do_apply_skill(ApplySkillInfo,Step,NewActorInfo,TargetId,TargetType,TargetPos,TargetInfo) ->
    do_apply_skill(ApplySkillInfo,Step,NewActorInfo,TargetId,TargetType,TargetPos,TargetInfo,?SKILL_ATTACK_DELAY_TYPE_NONE).
do_apply_skill(ApplySkillInfo,Step,ActorInfo,TargetId,TargetType,TargetPos,TargetInfo,DelayType) ->
    #r_skill_info{skill_id = SkillId,
                  distance=SkillDistance,
                  move_type=MoveType,
                  target_type=SkillTargetType} = ApplySkillInfo,
    #r_map_actor{actor_id = ActorId,
                 actor_type = ActorType,
                 skill = ActorSkillList} = ActorInfo,
    
    #p_actor_skill{level=SkillLevel} = lists:keyfind(SkillId, #p_actor_skill.skill_id, ActorSkillList),
    %% 对自身进行技能效果计算
    {ActorInfo2,SelfAttackResultUnitList} = mod_fight_skill_effect:do_self(ApplySkillInfo, ActorInfo),
    case DelayType of
        ?SKILL_ATTACK_DELAY_TYPE_DELAY ->
            NewActorInfo = ActorInfo2,
            AttrChangeList = [];
        _ ->
            %% 扣蓝
            ConsumeMp = mod_fight_misc:calc_skill_consume_mp(SkillId, SkillLevel, ApplySkillInfo),
            NewActorInfo = do_skill_consume(ConsumeMp, ApplySkillInfo, ActorInfo2),
            #r_map_actor{attr=#p_fight_attr{mp=CurMp,anger=CurAnger}} = NewActorInfo,
            AttrChangeList = [#p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MP,int_value=CurMp},
                              #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_ANGER,int_value=CurAnger}]
    end,
    
    %% 获取攻击目标集合
    TargetInfos = get_skill_targets(ApplySkillInfo, NewActorInfo, TargetInfo, TargetPos),
    mod_map:set_map_actor(ActorId, ActorType, NewActorInfo#r_map_actor{skill_state=undefined}),
    
    %% 对目标进行技能效果计算
    {AttackResultT, OutTargets} = do_apply_skill(ApplySkillInfo, NewActorInfo, TargetInfos),
    AttackResult = lists:reverse(AttackResultT),
%%     ?ERROR_MSG("AttackResult=~w,OutTargets=~w",[AttackResult,OutTargets]),
    case SelfAttackResultUnitList  of
        [] ->
            NewAttackResult = AttackResult;
        _ ->
            case lists:keyfind(ActorId, #p_attack_result.dest_id, AttackResult) of
                false ->
                    #r_map_actor{attr=#p_fight_attr{hp=Hp,mp=Mp,anger=Anger}} = NewActorInfo,
                    NewAttackResult = [#p_attack_result{dest_id=ActorId,dest_type=ActorType,
                                                        cur_hp=Hp,cur_mp=Mp,cur_angle=Anger,
                                                        unit_list=SelfAttackResultUnitList} | AttackResult];
                #p_attack_result{unit_list=SelfUnitList} =SelfAttackResult ->
                    NewAttackResult = [SelfAttackResult#p_attack_result{unit_list = SelfAttackResultUnitList++SelfUnitList} | 
                                           lists:keydelete(ActorId, #p_attack_result.dest_id, AttackResult)]
            end
    end,
    case DelayType of
        ?SKILL_ATTACK_DELAY_TYPE_DELAY -> ResultType = 1;
        _ -> ResultType = 0
    end,
    %% 释放技能广播
    ApplySkillToc = #m_fight_attack_toc{skill_id = SkillId,
                                        level = SkillLevel,
                                        step = Step,
                                        src_id = ActorId,
                                        src_type = ActorType,
                                        target_id = TargetId,
                                        target_type = TargetType,
                                        target_pos = TargetPos,
                                        result_type = ResultType,
                                        result = NewAttackResult},
    if SkillTargetType == ?F_TARGET_TYPE_SELF
       orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND
       orelse SkillTargetType == ?F_TARGET_TYPE_ADD_HP_CHAIN
       orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND_TRAP ->
           mod_map:broadcast_9slice(now, ActorId, ActorType, ApplySkillToc);
       true -> %% 合并技能区域广播
           mod_map:broadcast_merge_slice(now, ActorId, ActorType, TargetPos, ApplySkillToc)
    end,
    case AttrChangeList of
        [] ->
            ignore;
        _ ->
            case ActorType of
                ?ACTOR_TYPE_ROLE -> RoleId = ActorId;
                ?ACTOR_TYPE_PET -> 
                    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET) of
                        #p_map_pet{role_id=RoleId} -> next;
                        _ -> RoleId = 0
                    end;
                _ -> RoleId = 0
            end,
            case mod_map_role:get_role_gateway_pid(RoleId) of
                undefined ->
                    ignore;
                GatewayPId ->
                    AttrChangeToc = #m_role_attr_change_toc{op_type=0,attr_list=AttrChangeList},
                    common_misc:unicast(GatewayPId, ?ROLE, ?ROLE_ATTR_CHANGE, AttrChangeToc)
            end
    end,
    %% 更新targets的内存属性
    [process_update_map_actor(NewActorInfo, UpdateTarget#r_map_actor{temp_attr = undefined})||UpdateTarget<-OutTargets],
    %% 处理技能位移
    mod_move:do_skill_move(ActorId, ActorType, MoveType, SkillDistance),
    ok.

%% @doc 释放技能错误
do_apply_skill_error(SkillId, Step, ActorId, ?ACTOR_TYPE_ROLE, Reason, ErrorCode) -> %% 玩家技能出错通知客户端
    ApplySkillToc = #m_fight_attack_toc{op_code = ErrorCode, skill_id = SkillId, step = Step,
                                        src_id = ActorId,src_type = ?ACTOR_TYPE_ROLE},
    case mod_map_role:get_role_gateway_pid(ActorId) of
        undefined -> ignore;
        PId -> 
            ?ERROR_MSG("role apply skill fail.ApplySkillToc=~w,Reason=~w",[ApplySkillToc,Reason]),
            common_misc:unicast(PId, ?FIGHT, ?FIGHT_ATTACK, ApplySkillToc)
    end;
do_apply_skill_error(SkillId, Step, ActorId, ?ACTOR_TYPE_PET, Reason, ErrorCode) -> %% 宠物技能出错通知客户端
    ApplySkillToc = #m_fight_attack_toc{op_code = ErrorCode, skill_id = SkillId, step = Step,
                                        src_id = ActorId,src_type = ?ACTOR_TYPE_PET},
    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET) of
        #p_map_pet{role_id=RoleId} ->
            case mod_map_role:get_role_gateway_pid(RoleId) of
                undefined -> ignore;
                PId -> 
                    ?ERROR_MSG("pet apply skill fail.ApplySkillToc=~w,Reason=~w",[ApplySkillToc,Reason]),
                    common_misc:unicast(PId, ?FIGHT, ?FIGHT_ATTACK, ApplySkillToc)
            end;
        _ ->
            ignroe
    end;
do_apply_skill_error(SkillId, _Step, ActorId, ?ACTOR_TYPE_MONSTER, Reason, ErrorCode) -> %% 宠物技能出错通知客户端
    ?ERROR_MSG("monster apply skill fail.ActorId=~w,SkillId=~w,ErrorCode=~w,Reason=~w",[ActorId,SkillId,ErrorCode,Reason]);
do_apply_skill_error(SkillId, _Step, ActorId, ActorType, Reason, ErrorCode) ->
    ?ERROR_MSG("do_apply_skill_error, ActorId:~p, ActorType:~p SkillId:~p Reason:~p, ErrorCode:~p",
               [ActorId, ActorType, SkillId, Reason, ErrorCode]).

%% @hidden
%% @doc 对目标进行技能释放
do_apply_skill(ApplySkillInfo, ActorInfo, TargetInfos) ->
    do_apply_skill1(ApplySkillInfo, ActorInfo, TargetInfos, [], []).

do_apply_skill1(_ApplySkillInfo, _ActorInfo, [], AttackResult, OutTargets) -> {AttackResult, OutTargets};
do_apply_skill1(ApplySkillInfo, ActorInfo, [TargetInfo|T], AttackResult, OutTargets) ->
    case lists:keyfind(TargetInfo#r_map_actor.actor_id, #r_map_actor.actor_id, OutTargets) of
        false ->
            DoTargetInfo = TargetInfo;
        DoTargetInfo ->
            next
    end,
    {NewTarget, ResultUnitList} = mod_fight_skill_effect:do(ApplySkillInfo, ActorInfo, DoTargetInfo),
    #r_map_actor{actor_id=TargetActorId,actor_type=TargetActorType,attr=TargetFightAttr} = NewTarget,
    #p_fight_attr{hp=CurHp,mp=CurMp,anger=CurAnger} = TargetFightAttr,
    NewResult = #p_attack_result{dest_id = TargetActorId,
                                 dest_type = TargetActorType,
                                 cur_hp = CurHp,
                                 cur_mp = CurMp,
                                 cur_angle = CurAnger,
                                 unit_list = ResultUnitList},
    mod_map:set_map_actor(TargetActorId, TargetActorType, NewTarget),
    case lists:keyfind(TargetActorId, #r_map_actor.actor_id, OutTargets) of
        false ->
            NewOutTargets = [NewTarget|OutTargets];
        DoTargetInfo ->
            NewOutTargets = lists:keyreplace(TargetActorId, #r_map_actor.actor_id, OutTargets, NewTarget)
    end,
    do_apply_skill1(ApplySkillInfo, ActorInfo, T, [NewResult|AttackResult], NewOutTargets).

%% @hidden
%% @doc 同步地图对象信息
process_update_map_actor(Actor, Target = #r_map_actor{actor_id = TargetId, actor_type = TargetType, attr = FightAttr}) ->
    maybe_dead_broadcast(Actor, Target),
    mod_fight_misc:update_actor_info_attr(TargetId, TargetType, FightAttr), %% 更新actor_info血量
    mod_map:set_map_actor(TargetId, TargetType, Target),
    do_process_update_map_actor(Actor, Target).

do_process_update_map_actor(_Actor, #r_map_actor{actor_id = RoleId, actor_type = ?ACTOR_TYPE_ROLE, attr = FightAttr}) ->
    #p_fight_attr{hp = Hp, mp = Mp, anger = Anger} = FightAttr, %% 同步变化给玩家进程
    common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {RoleId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}}});
do_process_update_map_actor(_Actor = #r_map_actor{actor_id = ActorId, actor_type = ActorType}, 
                            #r_map_actor{actor_id = PetId, actor_type = ?ACTOR_TYPE_PET, attr = FightAttr}) ->
    #p_map_pet{role_id = RoleId} = mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET),
    #p_fight_attr{hp = Hp, mp = Mp, anger = Anger} = FightAttr, %% 同步变化给玩家进程
    case Hp =< 0 of
        true ->
            mod_map_pet:hook_pet_dead({ActorId,ActorType,PetId,RoleId});
        _ ->
            ignore
    end,
    common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {PetId, ?ACTOR_TYPE_PET, Hp, Mp, Anger}}}),
    ok;
do_process_update_map_actor(_Actor = #r_map_actor{actor_id = ActorId, actor_type = ActorType},
                         _Target = #r_map_actor{actor_id = TargetId, actor_type = ?ACTOR_TYPE_MONSTER, attr = _FightAttr}) ->
    mod_map_monster:hook_be_attacked({ActorId,ActorType,TargetId,0}),
    ok.

%% 广播死亡
maybe_dead_broadcast(Actor,Target = #r_map_actor{attr = #p_fight_attr{hp = 0}}) ->
%%     DeadToc = #m_map_actor_dead_toc{killer_id = ActorId, killer_type = ActorType, actor_id = TargetId, actor_type = TargetType},
%%     mod_map:broadcast_9slice(now, ActorId, ActorType, DeadToc),
    process_dead(Actor, Target);
maybe_dead_broadcast(_Actor, _Target) -> ignore.

%% 死亡处理
process_dead(#r_map_actor{actor_id = ActorId, actor_type = ActorType}, #r_map_actor{actor_id = TargetId, actor_type = ?ACTOR_TYPE_ROLE}) ->
    hook_map_role:role_dead(ActorId, ActorType, TargetId);
process_dead(_, _) ->
    ok.

%% @doc 释放技能检查（距离，是否主动技能，职业限制，Actor是否存在此技能）
check_apply_skill(SkillId, ActorId, ActorType, PTargetId, PTargetType, PTargetPos) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    %% 获取技能信息
    ApplySkillInfo = #r_skill_info{chant_time = ChantTime,
                                   delay_time=DelayTime,
                                   consume_anger=ConsumeAnger,
                                   distance = SkillDistance,
                                   target_type = SkillTargetType} =
    case cfg_skill:find(SkillId) of
        [SkillInfo] -> SkillInfo;
        _ ->
            ?BREAK({unknown_skill, SkillId}, ?_RC_FIGHT_ATTACK_004)
    end,
    case SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND_TRAP
         orelse SkillTargetType == ?F_TARGET_TYPE_OTHER_AROUND_TRAP of
        true ->
            case chant_time > 0 orelse delay_time > 0 of
                true ->
                    next;
                _ ->
                    ?BREAK({skill_config_error, SkillId}, ?_RC_FIGHT_ATTACK_013)
             end;
        _ ->
            next
    end,
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{pos=TargetPosT} -> next;
        #p_map_pet{pos=TargetPosT} -> next;
        #p_map_monster{pos=TargetPosT} -> next;
        _ ->
            TargetPosT = undefined,
            ?BREAK({unknown_actor_info, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_005)
    end,
    if SkillTargetType == ?F_TARGET_TYPE_SELF 
       orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND
       orelse SkillTargetType == ?F_TARGET_TYPE_ADD_HP_CHAIN
       orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND_TRAP ->
           %% 目标施法者自身位置
           TargetId = ActorId,TargetType = ActorType,TargetPos = TargetPosT;
       SkillTargetType == ?F_TARGET_TYPE_OTHER_AROUND_TRAP ->
           %% 地图上某一位置
           TargetId = ActorId,TargetType = ActorType,
           case PTargetPos of
               #p_pos{x=PTargetX,y=PTargetY} ->
                   {PTargetTx,PTargetTy} = mod_map_slice:to_tile_pos(PTargetX, PTargetY),
                   case McmModule:get_slice_name({PTargetTx,PTargetTy}) of
                       [#r_map_slice{}] ->
                           next;
                       _ ->
                           ?BREAK({target_pos_error, SkillId,PTargetPos}, ?_RC_FIGHT_ATTACK_016)
                   end;
               _ ->
                   ?BREAK({target_pos_error, SkillId,PTargetPos}, ?_RC_FIGHT_ATTACK_016)
           end,
           TargetPos = PTargetPos;
       true ->
           %% 地图某一角色位置
           TargetId = PTargetId, TargetType = PTargetType, TargetPos = PTargetPos,
           %% 使用当前服务端位置
           case mod_map:get_actor_info(TargetId, TargetType) of
               #p_map_role{pos=TargetPos} -> next;
               #p_map_pet{pos=TargetPos} -> next;
               #p_map_monster{pos=TargetPos} -> next;
               _ -> TargetPos = PTargetPos
           end,
           %% 目标当前状态不能成为攻击目标
           case mod_map:get_map_actor(TargetId, TargetType) of
               #r_map_actor{fight_buff=TargetFightBuffList} ->
                   case mod_fight_calculate:is_virtual(TargetFightBuffList) of
                       true ->
                           ?BREAK({unknown_map_actor, {TargetId, TargetType}}, ?_RC_FIGHT_ATTACK_012);
                       _ ->
                           next
                   end;
               _ ->
                   next
           end
    end,
    case mod_map:get_map_actor(ActorId, ActorType) of
        undefined ->
            ActorInfo = undefined,
            ?BREAK({unknown_map_actor, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_005);
        ActorInfo -> 
            next
    end,
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{pos=ActorPos} -> next;
        #p_map_pet{pos=ActorPos} -> next;
        #p_map_monster{pos=ActorPos} -> next;
        _ ->
            ActorPos = undefined,
            ?BREAK({unknown_actor_info, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_003)
    end,
    #p_pos{x=X,y=Y} = ActorPos,
    #p_pos{x=TargetX,y=TargetY} = TargetPos,
    case TargetType of
        ?ACTOR_TYPE_MONSTER ->
            case mod_map:get_actor_info(TargetId, TargetType) of
                #p_map_monster{type_id=MonsterTypeId} ->
                    #r_monster_info{body_radius=BodyRadius} = cfg_monster:find(MonsterTypeId);
                _ ->
                    BodyRadius = 0
            end;
        _ ->
            BodyRadius = 0
    end,
    case SkillTargetType == ?F_TARGET_TYPE_SELF
         orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND
         orelse SkillTargetType == ?F_TARGET_TYPE_ADD_HP_CHAIN
         orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND_TRAP of
        true ->
            next;
        _ ->
            ActorDistance = mod_map_slice:calc_ab_distance(X, Y, TargetX, TargetY),
            case (SkillDistance + BodyRadius) >= ActorDistance of
                true ->
                    next;
                _ ->
                    ?BREAK({unknown_actor_info, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_003)
            end
    end,

    #r_map_actor{skill = SkillList, attr = ActorFightAttr,skill_delay = SkillDelay} = ActorInfo,
    %% 判定是当前状态是否可以释放技能，吟唱，延迟释放
    case SkillDelay of
       undefined ->
            ignroe;
        _ ->
            ?BREAK({skill_delay, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_010)
    end,
    
    %% 检查技能是否存在
    #p_actor_skill{level = SkillLevel} =
    case lists:keyfind(SkillId, #p_actor_skill.skill_id, SkillList) of
        false ->
            ?BREAK({no_skill, {ActorId, ActorType, SkillList, SkillId}}, ?_RC_FIGHT_ATTACK_006);
        RoleSkill ->
            RoleSkill
    end,

    Now = mgeem_map:get_now2(),
    %% 检查技能公共CD
    case Now + 300 > get_common_cd(ActorId, ActorType) of
        true ->
            ignore;
        false ->
            ?BREAK({bad_skill_common_cd, {ActorId, ActorType, SkillId, Now, get_common_cd(ActorId, ActorType)}}, ?_RC_FIGHT_ATTACK_008)
    end,

    %% 检查技能CD (网络延迟允许误差 500ms)
    case Now + 300 > get_skill_cd_time(ActorId, ActorType, SkillId) of
        true ->
            ignore;
        false ->
            ?BREAK({bad_skill_cd, {ActorId, ActorType, SkillId}, Now, get_skill_cd_time(ActorId, ActorType, SkillId)}, ?_RC_FIGHT_ATTACK_001)
    end,
    #p_fight_attr{anger=Anger,mp=Mp} = ActorFightAttr,
    %% 检查怒气消耗
    case ConsumeAnger == 0 orelse Anger >= ConsumeAnger of
        true ->
            next;
        _ ->
            ?BREAK({no_anger, {ActorId, ActorType, SkillId, SkillLevel}}, ?_RC_FIGHT_ATTACK_011)
    end,
    %% 检查魔法消耗
    TotalConsumeMp = mod_fight_misc:calc_skill_consume_mp(SkillId, SkillLevel, ApplySkillInfo),
    case TotalConsumeMp > Mp of
        true ->
            ?BREAK({no_mp, {ActorId, ActorType, SkillId, SkillLevel}}, ?_RC_FIGHT_ATTACK_007);
        false ->
            ignore
    end,
    %% TODO 如果是选择区域为目标需要在些增加判断逻辑
    if SkillTargetType == ?F_TARGET_TYPE_OTHER_AROUND_TRAP ->
           %% 地图上某一位置
           TargetInfo = undefined;
       true ->
            case mod_map:get_map_actor(TargetId, TargetType) of
                undefined ->
                    TargetInfo = undefined,
                    ?BREAK({unknown_actor, {ActorId, ActorType}}, ?_RC_FIGHT_ATTACK_005);
                TargetInfo -> next
            end
    end,
    case ChantTime > 0 of
        true -> %% 吟唱技能
           erlang:throw({delay,?SKILL_ATTACK_DELAY_TYPE_CHANT,ApplySkillInfo,ActorInfo,TargetId,TargetType,TargetPos});
        _ ->
            next
    end,
    case DelayTime > 0 of
        true -> %% 延迟释放技能
            erlang:throw({delay,?SKILL_ATTACK_DELAY_TYPE_DELAY,ApplySkillInfo,ActorInfo,TargetId,TargetType,TargetPos});
        _ ->
            next
    end,
    {ok,ApplySkillInfo,ActorInfo,TargetId,TargetType,TargetPos,TargetInfo}.

%% @doc 获取技能CD列表
get_skill_cd_list(ActorId, ActorType) ->
    case erlang:get({actor_skill_cd, ActorId, ActorType}) of
        undefined -> [];
        List -> List
    end.

%% @doc 设置技能CD列表
set_skill_cd_list(ActorId, ActorType, List) ->
    erlang:put({actor_skill_cd, ActorId, ActorType}, List).

%% @doc 移除技能CD列表
erase_skill_cd_list(ActorId, ActorType) ->
    erlang:erase({actor_skill_cd, ActorId, ActorType}).

%% @doc 获取技能下一次CD时间
get_skill_cd_time(ActorId, ActorType, SkillId) ->
    CDList = get_skill_cd_list(ActorId, ActorType),
    case lists:keyfind(SkillId, 1, CDList) of
        false -> 0;
        {_, NextTime} -> NextTime
    end.

%% @doc 设置技能下一次CD时间
set_skill_cd_time(ActorId, ActorType, SkillId, NextTime) ->
    CDList = get_skill_cd_list(ActorId, ActorType),
    NewCDList = lists:keystore(SkillId, 1, CDList, {SkillId, NextTime}),
    set_skill_cd_list(ActorId, ActorType, NewCDList).


%% @doc 获取公共CD
get_common_cd(ActorId, ActorType) ->
    case erlang:get({actor_common_cd, ActorId, ActorType}) of
        undefined -> 0;
        NextTime -> NextTime
    end.

%% @doc 设置公共CD
set_common_cd(ActorId, ActorType, NextTime) ->
    erlang:put({actor_common_cd, ActorId, ActorType}, NextTime).

%% @doc 移除公共CD
erase_common_cd(ActorId, ActorType) ->
    erlang:erase({actor_common_cd, ActorId, ActorType}).

%% @hidden
%% @doc 获取技能影响目标
%% 自身
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_SELF, target_kind = TargetKind}, ActorInfo, _TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 -> %% 自身
    case TargetKind == ?F_TARGET_KIND_FRIEND of
        true ->
            [ActorInfo];
        false ->
            ?BREAK({unknown_target, ActorInfo}, ?_RC_FIGHT_ATTACK_002)
    end;

%% 自身和自身周围
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_SELF_AROUND, target_w = Area, target_number = TargetNum, target_kind = TargetKind},
                  ActorInfo, _TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 -> %% 自身和自身周围
    SkillPos = mod_fight_misc:get_map_actor_pos(ActorInfo),
    case TargetKind of
        ?F_TARGET_KIND_FRIEND ->
            find_targets_by_skill(?F_TARGET_TYPE_SELF_AROUND, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [ActorInfo]);
        _ ->
            find_targets_by_skill(?F_TARGET_TYPE_SELF_AROUND, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [])
    end;

%% 目标
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_OTHER, target_kind = TargetKind}, ActorInfo,
                  #r_map_actor{actor_id = TargetId, actor_type = TargetType} = TargetInfo, _TargetPos)
    when TargetInfo#r_map_actor.attr#p_fight_attr.hp > 0 -> %% 目标
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    TargetGroupId = mod_fight_misc:get_map_actor_groupid(TargetInfo),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            [TargetInfo];
        false ->
            ?BREAK({unknown_target, {TargetId, TargetType}}, ?_RC_FIGHT_ATTACK_002)
    end;

%% 目标和目标周围
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_OTHER_AROUND, target_w = Area, target_number = TargetNum, target_kind = TargetKind},
                  ActorInfo, #r_map_actor{actor_id = TargetId, actor_type = TargetType} = TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    TargetGroupId = mod_fight_misc:get_map_actor_groupid(TargetId, TargetType),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            SkillPos = mod_fight_misc:get_map_actor_pos(TargetInfo),
            find_targets_by_skill(?F_TARGET_TYPE_OTHER_AROUND, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [TargetInfo]);
        false ->
            ?BREAK({unknown_target, {TargetId, TargetType}}, ?_RC_FIGHT_ATTACK_002)
    end;

%% 目标和目标周围连续（目标不可重复） 【闪电链技能】
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_SERIAL, target_w = Area, target_number = TargetNum, target_kind = TargetKind},
                  ActorInfo, #r_map_actor{actor_id = TargetId, actor_type = TargetType} = TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    TargetGroupId = mod_fight_misc:get_map_actor_groupid(TargetId, TargetType),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            SkillPos = mod_fight_misc:get_map_actor_pos(TargetInfo),
            find_targets_by_skill(?F_TARGET_TYPE_SERIAL, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [TargetInfo]);
        false ->
            ?BREAK({unknown_target, {TargetId, TargetType}}, ?_RC_FIGHT_ATTACK_002)
    end;
%% 选择目标的连续目标（目标可重复）【六连斩】
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_OVERLAP_SERIAL, target_w = Area, target_number = TargetNum, target_kind = TargetKind}, 
                  ActorInfo, #r_map_actor{actor_id = TargetId, actor_type = TargetType} = TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    TargetGroupId = mod_fight_misc:get_map_actor_groupid(TargetId, TargetType),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            SkillPos = mod_fight_misc:get_map_actor_pos(TargetInfo),
            find_targets_by_skill(?F_TARGET_TYPE_OVERLAP_SERIAL, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [TargetInfo]);
        false ->
            ?BREAK({unknown_target, {TargetId, TargetType}}, ?_RC_FIGHT_ATTACK_002)
    end;

%% 治疗链加血专用（目标不重复）【治疗链技能】
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_ADD_HP_CHAIN, target_w = Area, target_number = TargetNum, target_kind = TargetKind}, 
                  ActorInfo, _TargetInfo, _TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 -> %% 自身和自身周围
    SkillPos = mod_fight_misc:get_map_actor_pos(ActorInfo),
    case TargetKind of
        ?F_TARGET_KIND_FRIEND ->
            find_targets_by_skill(?F_TARGET_TYPE_ADD_HP_CHAIN, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [ActorInfo]);
        _ ->
            find_targets_by_skill(?F_TARGET_TYPE_ADD_HP_CHAIN, ActorInfo, TargetKind, SkillPos, Area, TargetNum - 1, [])
    end;
%% 以施法者为中心的一定范围随机多个区域的所有目标
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_SELF_AROUND_TRAP, target_h = Area, target_number = TargetNum, target_kind = TargetKind}, 
                  ActorInfo, _TargetInfo, TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
    find_targets_by_skill(?F_TARGET_TYPE_SELF_AROUND_TRAP, ActorInfo, TargetKind, TargetPos, Area, TargetNum, []);
%% 以目标为中心的一定范围随机多个区域的所有目标
get_skill_targets(#r_skill_info{target_type = ?F_TARGET_TYPE_OTHER_AROUND_TRAP, target_h = Area, target_number = TargetNum, target_kind = TargetKind}, 
                  ActorInfo, _TargetInfo, TargetPos)
    when ActorInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
    find_targets_by_skill(?F_TARGET_TYPE_OTHER_AROUND_TRAP, ActorInfo, TargetKind, TargetPos, Area, TargetNum, []);
get_skill_targets(_ApplySkill, _Actor, _Target, _TargetPos) ->
    [].


%% 根据技能目标类型的不同规则选取不同的目标

%% 以目标为中心的一定范围随机多个区域的所有目标
find_targets_by_skill(?F_TARGET_TYPE_OTHER_AROUND_TRAP, ActorInfo, TargetKind, _TargetPos, Area, _TargetNum, _ExcludeTargets) ->
    Radius = Area div ?MAP_TILE_SIZE + 2,
    case ActorInfo of
        #r_map_actor{skill_state=#p_actor_skill_state{effect_pos=TargetPosList}} -> next;
        _ -> TargetPosList = []
    end,
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    lists:foldl(
      fun(TargetPos,AccTargetInfoList) ->
              ActorList = get_target_actor_by_square(TargetPos, Radius, Radius),
              NewTargetList = filter_targets(ActorGroupId, TargetKind, ActorList), %% 阵营过滤
              find_targets([], -1, NewTargetList, TargetPos, Area) ++ AccTargetInfoList
      end, [], TargetPosList);
%% 以施法者为中心的一定范围随机多个区域的所有目标
find_targets_by_skill(?F_TARGET_TYPE_SELF_AROUND_TRAP, ActorInfo, TargetKind, _TargetPos, Area, _TargetNum, _ExcludeTargets) ->
    Radius = Area div ?MAP_TILE_SIZE + 2,
    case ActorInfo of
        #r_map_actor{skill_state=#p_actor_skill_state{effect_pos=TargetPosList}} -> next;
        _ -> TargetPosList = []
    end,
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    lists:foldl(
      fun(TargetPos,AccTargetInfoList) ->
              ActorList = get_target_actor_by_square(TargetPos, Radius, Radius),
              NewTargetList = filter_targets(ActorGroupId, TargetKind, ActorList), %% 阵营过滤
              find_targets([], -1, NewTargetList, TargetPos, Area) ++ AccTargetInfoList
      end, [], TargetPosList);
%% 选择目标的连续目标（目标可重复）【六连斩】有顺序要求
find_targets_by_skill(?F_TARGET_TYPE_OVERLAP_SERIAL, ActorInfo, TargetKind, TargetPos, Area, TargetNum, ExcludeTargets) ->
    Radius = Area div ?MAP_TILE_SIZE + 2,
    ActorListT = get_target_actor_by_square(TargetPos, Radius, Radius),
    IncludeObjects = [{Type,Id}||#r_map_actor{actor_id = Id, actor_type = Type} <- ExcludeTargets,lists:member({Type,Id}, ActorListT) == false],
    ActorList = IncludeObjects ++ ActorListT,
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    NewTargetList = filter_targets(ActorGroupId, TargetKind, ActorList), %% 阵营过滤
    find_targets_overlap(TargetNum, NewTargetList, TargetPos, Area);
%% 治疗链加血专用（目标不重复）【治疗链技能】有顺序要求，先血量最少的
find_targets_by_skill(?F_TARGET_TYPE_ADD_HP_CHAIN, ActorInfo, TargetKind, TargetPos, Area, TargetNum, ExcludeTargets) ->
    Radius = Area div ?MAP_TILE_SIZE + 2,
    ActorListT = get_target_actor_by_square(TargetPos, Radius, Radius),
    IncludeObjects = [{Type,Id}||#r_map_actor{actor_id = Id, actor_type = Type} <- ExcludeTargets,lists:member({Type,Id}, ActorListT) == false],
    ActorList = IncludeObjects ++ ActorListT,
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    NewTargetList = filter_targets_by_min_hp(ActorGroupId, TargetKind, ActorList),
    find_targets([], TargetNum, NewTargetList, TargetPos, Area);

%% 目标和目标周围连续（目标不可重复） 【闪电链技能】有顺序要求
find_targets_by_skill(?F_TARGET_TYPE_SERIAL, ActorInfo, TargetKind, TargetPos, Area, TargetNum, ExcludeTargets) ->
    ExcludeObjects = [{Id,Type}||#r_map_actor{actor_id = Id, actor_type = Type} <- ExcludeTargets],
    Radius = Area div ?MAP_TILE_SIZE + 2,
    ActorList = get_target_actor_by_square(TargetPos, Radius, Radius),
    ShuffList = common_tool:shuff_list(ActorList), %% 将目标列表打乱，具有一定随机性
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    NewTargetList = filter_targets(ActorGroupId, TargetKind, ShuffList), %% 阵营过滤
    ExcludeTargets ++ find_targets(ExcludeObjects, TargetNum, NewTargetList, TargetPos, Area);
%% @doc 根据技能和释放坐标 获取目标对象
find_targets_by_skill(TargetType, ActorInfo, TargetKind, TargetPos, Area, TargetNum, ExcludeTargets) ->
    ExcludeObjects = [{Id,Type}||#r_map_actor{actor_id = Id, actor_type = Type} <- ExcludeTargets],
    case TargetType == ?F_TARGET_TYPE_SELF_AROUND andalso TargetKind == ?F_TARGET_KIND_ENEMY of
        true ->
            Radius = Area div ?MAP_TILE_SIZE + 5;
        _ ->
            Radius = Area div ?MAP_TILE_SIZE + 2
    end,
    ActorList = get_target_actor_by_square(TargetPos, Radius, Radius),
    ActorGroupId = mod_fight_misc:get_map_actor_groupid(ActorInfo),
    NewTargetList = filter_targets(ActorGroupId, TargetKind, ActorList), %% 阵营过滤
    ExcludeTargets ++ find_targets(ExcludeObjects, TargetNum, NewTargetList, TargetPos, Area).

%% 以一个中心点，获取中心点正方形的所有地图对象，玩家，宠物 ，怪物
%% 此计算方式，不需要计算角度问题
-spec 
get_target_actor_by_square(TargetPos,HalfW,HalfH) -> ActorList when
    TargetPos :: #p_pos{},
    HalfW :: integer(),
    HalfH :: integer(),
    ActorList :: [] | [{ActorType,ActorId}],
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
    ActorId :: role_id | pet_id | monster_id | integer().
get_target_actor_by_square(TargetPos,HalfW,HalfH) ->
    #p_pos{x = X, y = Y} = TargetPos,
    {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
    TileList = [{A, B} || A <- lists:seq(Tx - HalfW, Tx + HalfW), B <- lists:seq(Ty - HalfH, Ty + HalfH), A > 0, B > 0],
    lists:flatten([mod_map:get_tile_pos(A, B)||{A, B} <- TileList]).

%% @doc 根据技能作用目标类型 进行过滤
filter_targets(ActorGroupId, TargetKind, ObjectList) ->
    do_filter_targets(ObjectList, ActorGroupId, TargetKind, []).

do_filter_targets([], _ActorGroupId, _TargetKind, ObjectList) -> ObjectList;
do_filter_targets([#r_map_actor{actor_id = ObjectID, actor_type = ObjectType}|T], ActorGroupId, TargetKind, ObjectList) ->
    TargetGroupId =  mod_fight_misc:get_map_actor_groupid(ObjectID, ObjectType),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            do_filter_targets(T, ActorGroupId, TargetKind, [{ObjectID, ObjectType}|ObjectList]);
        false ->
            do_filter_targets(T, ActorGroupId, TargetKind, ObjectList)
    end;
do_filter_targets([{ObjectType,ObjectID}|T], ActorGroupId, TargetKind, ObjectList) ->
    TargetGroupId =  mod_fight_misc:get_map_actor_groupid(ObjectID, ObjectType),
    case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
        true ->
            do_filter_targets(T, ActorGroupId, TargetKind, [{ObjectID, ObjectType}|ObjectList]);
        false ->
            do_filter_targets(T, ActorGroupId, TargetKind, ObjectList)
    end.

%%check_kind(ActorGroupId, TargetGroupId, SkillKind) ->
%%    (SkillKind == ?F_TARGET_KIND_FRIEND andalso ActorGroupId == TargetGroupId) orelse (SkillKind == ?F_TARGET_KIND_ENEMY andalso ActorGroupId /= TargetGroupId).
check_kind(ActorGroupId, TargetGroupId, ?F_TARGET_KIND_FRIEND) -> 
    ActorGroupId == TargetGroupId;
check_kind(ActorGroupId, TargetGroupId, ?F_TARGET_KIND_ENEMY) -> 
    ActorGroupId =/= TargetGroupId;
check_kind(_, _, _) ->
    false.


%% @hidden
%% @doc 取可攻击目标
find_targets(ExcludeObjects, TargetNum,  SearchObjects, TargetPos, Radius) ->
    do_find_targets(ExcludeObjects, TargetNum, SearchObjects, TargetPos, Radius, []).
do_find_targets(_ExcludeObjects, 0, _SearchObjects, _TargetPos, _Radius, OutObjects) -> OutObjects;
do_find_targets(_ExcludeObjects, _TargetNum, [], _TargetPos, _Radius, OutObjects) -> OutObjects;
do_find_targets(ExcludeObjects, TargetNum, [{TargetId, TargetType}|T], #p_pos{x=TargetX,y=TargetY}=TargetPos, Radius, OutObjects) ->
    case lists:member({TargetId, TargetType}, ExcludeObjects) of
        false ->
            case mod_map:get_map_actor(TargetId, TargetType) of
                TargetInfo when TargetInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
                    case mod_fight_calculate:is_virtual(TargetInfo#r_map_actor.fight_buff) of
                        true ->
                            do_find_targets(ExcludeObjects, TargetNum, T, TargetPos, Radius, OutObjects);
                         _ ->
                             case mod_map:get_actor_info(TargetId, TargetType) of
                                 #p_map_role{pos=#p_pos{x=X,y=Y},walk_pos=WalkPos} -> next, BodyRadius = 0;
                                 #p_map_pet{pos=#p_pos{x=X,y=Y}} -> WalkPos = undefined, BodyRadius = 0;
                                 #p_map_monster{type_id=MonsterTypeId,pos=#p_pos{x=X,y=Y}} -> 
                                     WalkPos = undefined,
                                     #r_monster_info{body_radius=BodyRadius} = cfg_monster:find(MonsterTypeId);
                                 _ -> X = undefined, Y = undefined, WalkPos = undefined,BodyRadius = 0
                             end,
                             
                             case X of
                                 undefined ->
                                     do_find_targets(ExcludeObjects, TargetNum, T, TargetPos, Radius, OutObjects);
                                 _ ->
                                    #r_map_actor{last_walk_path_time=LastWalkPathTime} = TargetInfo,
                                    case LastWalkPathTime > 0 andalso WalkPos =/= undefined of
                                        true ->
                                            case Radius >= mod_map_slice:calc_ab_distance(X, Y, WalkPos#p_pos.x, WalkPos#p_pos.y) of
                                                true ->
                                                    AddDistance = 0;
                                                _ ->
                                                    Now = mgeem_map:get_now2(),
                                                    AddDistance = erlang:trunc((Now - LastWalkPathTime + 200) * 400 / 1000)
                                            end;
                                        _ ->
                                            AddDistance = 0
                                    end,
                                    ActorDistance = mod_map_slice:calc_ab_distance(X, Y, TargetX, TargetY) + AddDistance,
                                    case Radius + BodyRadius >= ActorDistance of
                                        true ->
                                            do_find_targets(ExcludeObjects, TargetNum - 1, T, TargetPos, Radius, [TargetInfo|OutObjects]);
                                        _ ->
                                            do_find_targets(ExcludeObjects, TargetNum, T, TargetPos, Radius, OutObjects)
                                    end
                             end
                    end;
                _ -> % 死亡目标过滤
                    do_find_targets(ExcludeObjects, TargetNum, T, TargetPos, Radius, OutObjects)
            end;
        true ->
            do_find_targets(ExcludeObjects, TargetNum, T, TargetPos, Radius, OutObjects)
    end.

find_targets_overlap(TargetNum, SearchObjects, TargetPos, Radius) ->
    do_find_targets_overlap(TargetNum,SearchObjects,TargetPos,Radius,[],[]).
    
do_find_targets_overlap(0, _SearchObjects, _TargetPos,_Radius, _NewSearchObjects, OutObjects) -> OutObjects;
do_find_targets_overlap(TargetNum, [], TargetPos, Radius, NewSearchObjects, OutObjects) -> 
    case TargetNum > 0 of
        true ->
            ResetSearchObjects = common_tool:shuff_list(NewSearchObjects),
            do_find_targets_overlap(TargetNum, ResetSearchObjects, TargetPos, Radius, [], OutObjects);
        _ ->
            OutObjects
    end;
do_find_targets_overlap(TargetNum, [{TargetId, TargetType}|T], #p_pos{x=TargetX,y=TargetY}=TargetPos, Radius, NewSearchObjects,  OutObjects) ->
    case mod_map:get_map_actor(TargetId, TargetType) of
        TargetInfo when TargetInfo#r_map_actor.attr#p_fight_attr.hp > 0 ->
            case mod_fight_calculate:is_virtual(TargetInfo#r_map_actor.fight_buff) of
                true ->
                    do_find_targets_overlap(TargetNum, T, TargetPos, Radius, NewSearchObjects, OutObjects);
                _ ->
                    case mod_map:get_actor_info(TargetId, TargetType) of
                         #p_map_role{pos=#p_pos{x=X,y=Y}} -> next;
                         #p_map_pet{pos=#p_pos{x=X,y=Y}} -> next;
                         #p_map_monster{pos=#p_pos{x=X,y=Y}} -> next;
                         _ -> X = undefined, Y = undefined
                     end,
                     case X of
                         undefined ->
                             do_find_targets_overlap(TargetNum, T, TargetPos, Radius, NewSearchObjects, OutObjects);
                         _ ->
                             ActorDistance = mod_map_slice:calc_ab_distance(X, Y, TargetX, TargetY),
                             case Radius >= ActorDistance of
                                 true ->
                                     do_find_targets_overlap(TargetNum - 1, T, TargetPos, Radius, [TargetInfo | NewSearchObjects],  [TargetInfo|OutObjects]);
                                 _ ->
                                     do_find_targets_overlap(TargetNum, T, TargetPos, Radius, NewSearchObjects,  OutObjects)
                             end
                     end
            end;
        _ -> % 死亡目标过滤
            do_find_targets_overlap(TargetNum, T, TargetPos, Radius, NewSearchObjects,  OutObjects)
    end;
do_find_targets_overlap(TargetNum, [#r_map_actor{}=TargetInfo|T], TargetPos, Radius, NewSearchObjects,  OutObjects) ->
    do_find_targets_overlap(TargetNum - 1, T, TargetPos, Radius, [TargetInfo | NewSearchObjects],  [TargetInfo|OutObjects]).

%% 根据最小血量获取目标
filter_targets_by_min_hp(ActorGroupId, TargetKind, ActorList) ->
    NewActorList = do_filter_targets_by_min_hp(ActorList, ActorGroupId, TargetKind, []),
    SortActorList = lists:sort(
                       fun({_,ActorTypeA,HurtHpA},{_,ActorTypeB,HurtHpB}) -> 
                               case ActorTypeA < ActorTypeB of
                                   true ->
                                       HurtHpA < HurtHpB;
                                   _ ->
                                       HurtHpA < HurtHpB
                               end
                       end, NewActorList),
   [{ActorId,ActorType} || {ActorId,ActorType,_} <- SortActorList].
do_filter_targets_by_min_hp([], _ActorGroupId, _TargetKind, NewActorList) ->
    NewActorList;
do_filter_targets_by_min_hp([{ActorType,ActorId}|T], ActorGroupId, TargetKind, NewActorList) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{group_id = TargetGroupId,hp=Hp,max_hp=MaxHp} -> HurtHp = erlang:max(0, MaxHp - Hp);
        #p_map_monster{group_id = TargetGroupId,hp=Hp,max_hp=MaxHp} -> HurtHp = erlang:max(0, MaxHp - Hp);
        #p_map_pet{group_id = TargetGroupId,hp=Hp,max_hp=MaxHp} -> HurtHp = erlang:max(0, MaxHp - Hp)
    end,
    case Hp > 0 of
        true ->
            case check_kind(ActorGroupId, TargetGroupId, TargetKind) of
                true ->
                    do_filter_targets_by_min_hp(T, ActorGroupId, TargetKind, [{ActorId, ActorType, HurtHp}|NewActorList]);
                false ->
                    do_filter_targets_by_min_hp(T, ActorGroupId, TargetKind, NewActorList)
            end;
        _ ->
            do_filter_targets_by_min_hp(T, ActorGroupId, TargetKind, NewActorList)
    end.
