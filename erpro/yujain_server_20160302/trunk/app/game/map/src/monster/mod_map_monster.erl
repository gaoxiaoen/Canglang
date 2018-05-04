%%-------------------------------------------------------------------
%% File              :mod_map_monster.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-10-26
%% @doc
%%     怪物模块
%% @end
%%-------------------------------------------------------------------


-module(mod_map_monster).

-include("mgeem.hrl").

-define(monster_walk_type,patrol_pos).
-define(monster_walk_type_fight,fight_patrol_pos).

-define(monster_fight_type_base,be_attacked).
-define(monster_fight_type_ai,fight_ai).

-export([
         handle/1,
         loop/0,
         loop_ms/0,
         hook_be_attacked/1
        ]).

-export([
         set_monster_skill_delay/1,
         erase_monster_skill_delay/1,
         set_monster_effect_status/2,
         erase_monster_effect_status/1,
         
         get_monster_state/1,
         set_monster_state/2,
         erase_monster_state/1,
         
         init_monster_id_list/0,
         get_monster_id_list/0,
         del_monster_id_from_list/1,
         add_monster_id_to_list/1,
         init_monster/1
        ]).

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

loop() ->
    MonsterIdList = get_monster_id_list(),
    loop_monster_buff(MonsterIdList),
    auto_recovery_mp(MonsterIdList),
    ok.
loop_monster_buff([]) ->
    ok;
loop_monster_buff([MonsterId|MonsterIdList]) ->
    ?TRY_CATCH(mod_buff:loop(MonsterId, ?ACTOR_TYPE_MONSTER), ErrBuff),
    loop_monster_buff(MonsterIdList).

%% 自动恢复怪物魔法值
auto_recovery_mp([]) ->
    ok;
auto_recovery_mp(MonsterIdList) ->
    Now = mgeem_map:get_now(),
    case Now rem 3 of
        0 -> %% 每3秒杀恢复魔法值
            auto_recovery_mp2(MonsterIdList);
        _ ->
            ignroe
    end.
auto_recovery_mp2([]) ->
    ok;
auto_recovery_mp2([MonsterId|MonsterIdList]) ->
    catch auto_recovery_mp3(MonsterId),
    auto_recovery_mp(MonsterIdList).

auto_recovery_mp3(MonsterId) ->
    case mod_map:get_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER) of
        undefined ->
            MapMonster = undefined,
            erlang:throw({error,not_found_monster});
        MapMonster ->
            next
    end,
    #r_map_actor{attr=#p_fight_attr{hp=Hp,max_mp=MaxMp,mp=Mp}=Attr} = MapMonster,
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,role_dead})
    end,
    case MaxMp == Mp of
        true ->
            erlang:throw({error,max_mp});
        _ ->
            next
    end,
    NewAttr = Attr#p_fight_attr{mp=Mp + 3},
    mod_map:set_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonster#r_map_actor{attr=NewAttr}),
    ok.

%% 地图每200毫秒循环调用
loop_ms() ->
    #r_map_state{map_id=_MapId,map_type=MapType} = mgeem_map:get_map_state(),
    case MapType of
        ?MAP_TYPE_FB ->
            MonsterIdList = get_monster_id_list(),
            Now = mgeem_map:get_now2(),
            loop_ms2(MonsterIdList,Now);
        _ ->
            ignroe
    end.
loop_ms2([],_Now) ->
    ok;
loop_ms2([MonsterId|MonsterIdList],Now) ->
    case get_monster_state(MonsterId) of
        undefined ->
            del_monster_data(MonsterId);
        #r_monster_state{next_tick = NextTick,next_action = NextAction} = MonsterState ->
            case Now >= NextTick of
                true ->
                    case NextAction of
                        loop ->
                            do_monster_loop(MonsterState);
                        _ ->
                            ignore
                    end;
                _ ->
                    ignore
            end
    end,
    loop_ms2(MonsterIdList,Now).


%% 怪物被攻击
-spec hook_be_attacked({SrcActorId,SrcActorType,MonsterId,ReduceHp}) -> ok when
          SrcActorId :: role_id | pet_id | monster_id,
          SrcActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
          MonsterId :: monster_id,
          ReduceHp :: reduce_hp.
hook_be_attacked({ActorId,?ACTOR_TYPE_ROLE,MonsterId,ReduceHp}) ->
    hook_be_attacked(ActorId,ActorId,?ACTOR_TYPE_ROLE,MonsterId,ReduceHp);
hook_be_attacked({ActorId,?ACTOR_TYPE_PET,MonsterId,ReduceHp}) ->
    #p_map_pet{role_id=RoleId} = mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET),
    hook_be_attacked(RoleId,ActorId,?ACTOR_TYPE_PET,MonsterId,ReduceHp);
hook_be_attacked({ActorId,?ACTOR_TYPE_MONSTER,MonsterId,ReduceHp}) ->
    hook_be_attacked(0,ActorId,?ACTOR_TYPE_MONSTER,MonsterId,ReduceHp);
hook_be_attacked(Info) ->
    ?ERROR_MSG("monster be attack receive unknown info=~w.",[Info]),
    ok.
hook_be_attacked(RoleId,ActorId,ActorType,MonsterId,ReduceHp) ->
    case catch hook_be_attacked2(RoleId,ActorId,ActorType,MonsterId,ReduceHp) of
        ignore ->
            ignore;
        {dead,MonsterState} ->
            do_monster_dead(RoleId,ActorId,ActorType,MonsterState);
        {next,MonsterState} ->
            #r_monster_state{status=MonsterStatus} = MonsterState,
            hook_be_attacked3(MonsterStatus,ActorId,ActorType,MonsterId,MonsterState)
    end.
hook_be_attacked2(_RoleId,ActorId,ActorType,MonsterId,ReduceHp) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{group_id=SrcGroupId} -> next;
        #p_map_pet{group_id=SrcGroupId} -> next;
        #p_map_monster{group_id=SrcGroupId} -> next;
        _ ->
            SrcGroupId = 0
    end,
    case mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER) of
        #p_map_monster{group_id=MonsterGroupId,hp=MonsterHp} ->
            next;
        _ ->
            MonsterGroupId = 0, MonsterHp = 0,
            erlang:throw(ignore)
    end,
    %% 同一个阵营相互不能攻击
    case SrcGroupId == MonsterGroupId of
        true -> 
            erlang:throw(ignore);
        _ ->
            next
    end,
    MonsterState = get_monster_state(MonsterId),
    #r_monster_state{status=MonsterStatus,
                     is_skill_delay=IsSkillDelay,
                     effect_status=EffectStatus,
                     enemy_list=EnemyList} = MonsterState,
    %% 怪物已经死亡，不需要处理
    case MonsterStatus of
        ?MONSTER_STATUS_DEAD ->
            erlang:throw(ignore); 
        _ ->
            next
    end,
    %% 将当前的攻击者添加仇恨列表
    NewEnemyList = add_monster_enemy(EnemyList, ActorId, ActorType, ReduceHp),
    NewMonsterState = MonsterState#r_monster_state{enemy_list=NewEnemyList},
    set_monster_state(MonsterId,NewMonsterState),
    %% 本次攻击怪物血量为0，即怪物死亡
    case MonsterHp > 0 of
        true ->
            next;
        _ ->
            erlang:throw({dead,NewMonsterState})
    end,
    case IsSkillDelay == ?MONSTER_SKILL_DELAY_YES
         orelse EffectStatus == ?MONSTER_EFFECT_STATUS_FANIT of
        true ->
            erlang:throw(ignore); 
        _ ->
            next
    end,
    {next,NewMonsterState}.
hook_be_attacked3(?MONSTER_STATUS_FIGHT,ActorId,ActorType,MonsterId,MonsterState) ->
    #r_monster_state{id=MonsterId,next_data=NextData} = MonsterState,
    Now2 = mgeem_map:get_now2(),
    case NextData of
        {?monster_fight_type_base,_PActorId,_PActorType} ->
            NewNextData = NextData;
        _ ->
            NewNextData = {?monster_fight_type_base,ActorId,ActorType}
    end,
    NewMonsterState = MonsterState#r_monster_state{next_data=NewNextData,next_action=loop,be_attack_time=Now2},
    set_monster_state(MonsterId, NewMonsterState);
%% 在[巡逻]状态下补攻击
hook_be_attacked3(?MONSTER_STATUS_PATROL,ActorId,ActorType,MonsterId,MonsterState) ->
    #r_monster_state{id=MonsterId,
                     pos=MonsterPos,
                     type_id=TypeId,
                     ai_data=OldAiData,
                     next_data=NextData} = MonsterState,
    #r_monster_info{ai_id=AiId} = cfg_monster:find(TypeId),
    #r_map_actor{attr=MonsterAttr} = mod_map:get_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER),
    case NextData of
        {?monster_walk_type_fight,_,_} ->
            AiData = OldAiData;
        _ ->
            AiData = mod_monster_ai:reset_ai_data(OldAiData)
    end,
    case mod_monster_ai:get_ai_trigger_be_attacked(MonsterId,AiId, AiData, MonsterAttr) of
        {undefined,NewAiData} ->
            NewNextData = {?monster_fight_type_base,ActorId,ActorType};
        {AiTrigger,NewAiData} ->
            NewNextData = {?monster_fight_type_ai,ActorId,ActorType,AiTrigger}
    end,
    Now2 = mgeem_map:get_now2(),
    %% 即同步当前位置，并进入[战斗]状态
    case NextData of
        {?monster_walk_type,#p_map_pos{x=X,y=Y,tx=Tx,ty=Ty}=NewMapPos,_WalkData} -> %% 停止当前怪物走路，进入[战斗]状态
            #p_pos{x=OldX,y=OldY} = MonsterPos,
            {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX,OldY),
            NewPos = #p_pos{x=X,y=Y},
            MapMonsterInfo = mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
            mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonsterInfo#p_map_monster{pos=NewPos,walk_pos=undefined}),
            NewMonsterState = MonsterState#r_monster_state{status=?MONSTER_STATUS_FIGHT,
                                                           be_attack_time=Now2,
                                                           pos=NewPos,
                                                           dest_pos=undefined,
                                                           walk_list=[],
                                                           ai_data=NewAiData,
                                                           fight_time=Now2},
            update_next_tick(MonsterId,Now2 + ?MONSTER_WORK_TICK_MIN,loop,NewNextData,NewMonsterState),
            change_monster_walk_pos(MonsterId,#p_map_pos{x=OldX,y=OldY,tx=OldTx,ty=OldTy},NewMapPos),
            %% 在[巡逻]状态被攻击，需要广播给前端让怪物同步位置
            Toc = #m_move_sync_toc{move_id=MonsterId,pos=NewPos},
            #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            mod_map:broadcast(RoleIdList, ?MOVE, ?MOVE_SYNC, Toc),
            ok;
        {?monster_walk_type_fight,#p_map_pos{x=_X,y=_Y}=_NewMapPos,_WalkData} ->
            %% 即可以预先判断当前需要使用的技能，是否有足够的距离可以功能到目标，如果距离不够，即继续寻路
            set_monster_state(MonsterId, MonsterState);
        _ ->
            NewMonsterState = MonsterState#r_monster_state{status=?MONSTER_STATUS_FIGHT,
                                                           be_attack_time=Now2,
                                                           ai_data=NewAiData,
                                                           fight_time=Now2},
            update_next_tick(MonsterId,Now2 + ?MONSTER_WORK_TICK_MIN,loop,NewNextData,NewMonsterState)
    end;
%% 停顿，不操作任何怪物AI，等待唤醒
hook_be_attacked3(?MONSTER_STATUS_PAUSE,_ActorId,_ActorType,MonsterId,MonsterState) ->
    Now2 = mgeem_map:get_now2(),
    set_monster_state(MonsterId, MonsterState#r_monster_state{be_attack_time=Now2});
hook_be_attacked3(_MonsterStatus,ActorId,ActorType,MonsterId,MonsterState) ->
     #r_monster_state{id=MonsterId,
                     type_id=TypeId,
                     ai_data=OldAiData} = MonsterState,
    #r_monster_info{ai_id=AiId} = cfg_monster:find(TypeId),
    #r_map_actor{attr=MonsterAttr} = mod_map:get_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER),
    AiData = mod_monster_ai:reset_ai_data(OldAiData),
    case mod_monster_ai:get_ai_trigger_be_attacked(MonsterId,AiId, AiData, MonsterAttr) of
        {undefined,NewAiData} ->
            NewNextData = {?monster_fight_type_base,ActorId,ActorType};
        {AiTrigger,NewAiData} ->
            NewNextData = {?monster_fight_type_ai,ActorId,ActorType,AiTrigger}
    end,
    Now2 = mgeem_map:get_now2(),
    NewMonsterState = MonsterState#r_monster_state{status=?MONSTER_STATUS_FIGHT,
                                                   be_attack_time=Now2,
                                                   fight_time=Now2,
                                                   ai_data=NewAiData},
    update_next_tick(MonsterId,Now2 + ?MONSTER_WORK_TICK_MIN,loop,NewNextData,NewMonsterState),
    ok.


%% 1.born 怪物在地图出生，出生之后进入 guard 状态
%% 2.guard 怪物警戒状态  --> fight | patrol | hold 
%% 3.fight 主动怪搜索到怪物进入战斗状态  怪物被攻击进入战斗状态 
%% 4.patrol 怪物巡逻 
%% 5.hold 被晕眩 or 低级怪物只能被打
%% 6.怪物在 fight战斗状态中，会触发相应的战斗AI
-spec do_monster_loop(MonsterState) -> ok when
          MonsterState :: #r_monster_state{}.
do_monster_loop(MonsterState) ->
    #r_monster_state{id = MonsterId,
                     status=Status,
                     reborn_type=RebornType,
                     is_skill_delay=IsSkillDelay,
                     effect_status=EffectStatus,
                     fight_time=FightTime,
                     ai_data=AiData} = MonsterState,
    case erlang:length(mod_map:get_in_map_role()) > 0 of
        true ->
            HasRole = 1;
        _ ->
            HasRole = 0
    end,
    if IsSkillDelay == ?MONSTER_SKILL_DELAY_YES
       orelse EffectStatus == ?MONSTER_EFFECT_STATUS_FANIT ->
           do_monster_pause(MonsterState);
       Status == ?MONSTER_STATUS_BORN -> %% 出生
           do_monster_born(MonsterState);
       Status == ?MONSTER_STATUS_GUARD andalso HasRole == 1 -> %% 警戒
           do_monster_guard(MonsterState);
       Status == ?MONSTER_STATUS_FIGHT andalso HasRole == 1 -> %% 战斗
           do_monster_fight(MonsterState);
       Status == ?MONSTER_STATUS_PATROL andalso HasRole == 1 -> %% 巡逻
           do_monster_patrol(MonsterState);
       Status == ?MONSTER_STATUS_HOLD andalso HasRole == 1 -> %% 保持状态  啥都不做
           do_monster_hold(MonsterState);
       Status == ?MONSTER_STATUS_FLEE andalso HasRole == 1 -> %% 返回到出生点
           do_monster_flee(MonsterState);
       Status == ?MONSTER_STATUS_DEAD andalso RebornType == ?MONSTER_REBORN_TYPE_REVIVE -> %% 死亡状态下，重生
           do_monster_born(MonsterState);
       Status == ?MONSTER_STATUS_PAUSE andalso HasRole == 1 -> %% 停顿，只需设置下次检查时间，其它操作不变
           do_monster_pause(MonsterState);
       true ->
           case HasRole of
               0 ->
                   case FightTime > 0 of
                       true ->
                           set_monster_state(MonsterId, MonsterState#r_monster_state{fight_time=0,
                                                                                     be_attack_time=0,
                                                                                     ai_data=mod_monster_ai:reset_ai_data(AiData)});
                       _ ->
                           next
                   end;
               _ ->
                   ?ERROR_MSG("unknow map monster info.Status=~w,MapMonster=~w",[Status,MonsterState])
           end
    end.

%% 初始化怪物数据，并出生怪物
-spec init_monster(MonsterParam) -> ok when
          MonsterParam :: #r_monster_param{}.
init_monster(MonsterParam) ->
    case cfg_monster:find(MonsterParam#r_monster_param.type_id) of
        undefined ->
            ?ERROR_MSG("~ts,MonsterParam=~w",[?_LANG_LOCAL_035,MonsterParam]);
        MonsterInfo ->
            init_monster2(MonsterParam,MonsterInfo) 
    end.
init_monster2(MonsterParam,_MonsterInfo)  ->
    #r_monster_param{born_type=BornType,
                     type_id=TypeId,
                     group_id=GroupId,
                     reborn_type=RebornType,
                     dead_fun=DeadFun,
                     pos=Pos,
                     dir=Dir
                    }=MonsterParam,
    Now = mgeem_map:get_now2(),
    MonsterId = get_max_monster_id(),
    MonsterState = #r_monster_state{id=MonsterId, 
                                    type_id=TypeId, 
                                    create_time = Now, 
                                    reborn_type=RebornType,
                                    last_status = ?MONSTER_STATUS_BORN, 
                                    status=?MONSTER_STATUS_BORN, 
                                    dead_time = 0, 
                                    dead_fun=DeadFun, 
                                    next_tick=Now + ?MONSTER_WORK_TICK_MIN,
                                    next_action=loop,
                                    next_data=undefined, 
                                    group_id=GroupId,
                                    base_skill=undefined,
                                    born_pos=Pos,
                                    born_dir=Dir,
                                    pos=Pos, 
                                    dir=Dir, 
                                    ai_data=[],
                                    enemy_list=[]
                                   },
    add_monster_id_to_list(MonsterId),
    set_monster_state(MonsterId, MonsterState),
    case BornType of
        ?MONSTER_BORN_TYPE_NOW ->
            do_monster_born(MonsterState);
        _ ->
            next
    end,
    ok.

%% 怪物出生
%% 怪物出生之后，进入[警戒]状态
do_monster_born(MonsterState) ->
    #r_monster_state{id=MonsterId,type_id=MonsterTypeId} = MonsterState,
    #r_map_state{map_id=MapId, mcm_module=McmModule} = mgeem_map:get_map_state(),
    MonsterInfo = cfg_monster:find(MonsterTypeId),
    #r_monster_info{name=MonsterName,
                    attr=MonsterAttr,
                    ai_id=AiId,
                    base_skill={BaseSkillId,BaseLevel}} = MonsterInfo,
    #p_fight_attr{max_hp=MaxHp,move_speed=MoveSpeed} = MonsterAttr,
    case cfg_monster_ai:find(AiId) of
        undefined ->
            SkillList = [#p_actor_skill{skill_id=BaseSkillId,level=BaseLevel}];
        #r_ai{ai_list=AiList} ->
            SkillList = 
                lists:foldl(fun(#r_ai_trigger{event_type=EventType,event_val_1=EventVal1,event_val_2=EventVal2},AccSkillList) -> 
                                    case EventType =:= ?MONSTER_AI_EVENT_TYPE_SKILL 
                                         andalso lists:keyfind(EventVal1, #p_actor_skill.skill_id, AccSkillList) =:= false of
                                        true ->
                                            [#p_actor_skill{skill_id=EventVal1,level=EventVal2} | AccSkillList];
                                        _ ->
                                            AccSkillList
                                    end
                            end, [#p_actor_skill{skill_id=BaseSkillId,level=BaseLevel}],AiList)
    end,
    #r_monster_state{status=MonsterStatus,
                     group_id=GroupId,
                     pos=MonsterPos,
                     dir=MonsterDir} = MonsterState,
    %% 如果怪物有技能需要在初始化时添加在r_map_actor结构中，技能战斗模块会使用此信息
    MapMonsterActor = #r_map_actor{actor_id=MonsterId,
                                   actor_type=?ACTOR_TYPE_MONSTER,
                                   attr=MonsterAttr,
                                   skill=SkillList,
                                   ext=undefined},
    MapMonster = #p_map_monster{monster_id=MonsterId,
                                monster_name=MonsterName,
                                type_id=MonsterTypeId,
                                group_id=GroupId,
                                map_id=MapId,
                                status=MonsterStatus,
                                pos=MonsterPos,
                                dir=MonsterDir,
                                move_speed=MoveSpeed,
                                max_hp=MaxHp,
                                hp=MaxHp},
    mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonster),
    mod_map:set_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonsterActor),
    %% 设置怪物下一次动作[警戒]
    NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                   status=?MONSTER_STATUS_GUARD,
                                                   base_skill={BaseSkillId,BaseLevel}},
    NewTick = mgeem_map:get_now2() + ?MONSTER_WORK_TICK_NORMAL,
    update_next_tick(MonsterId, NewTick, loop,undefined, NewMonsterState),
    #p_pos{x=X,y=Y} = MonsterPos,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    %% 怪物进入地图
    mod_map:ref_tile_pos(MonsterId, ?ACTOR_TYPE_MONSTER, Tx, Ty),
    [#r_map_slice{slice_name=SliceName,slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    mod_map:join_slice(SliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
    %% 广播
    mod_map_actor:do_enter_slice_notify(MonsterId, ?ACTOR_TYPE_MONSTER, Slice9List),
    ok.

%% 怪物死亡，通知客户端，如果是需要重生的，进程数据需要处理之后保持，并进入[出生]状态
%% RoleId 最后杀死怪物的玩家，如果ActorId是宠物RoleId为宠物所属玩家id，RoleId=0表示是友方怪物打死的
%% 需要计算最终那一些人获取怪物死亡奖励，并发送给各自玩家进程处理
%% 注：如果玩家掉线，即不获得奖励
do_monster_dead(RoleId,ActorId,ActorType,MonsterState) ->
    #r_map_state{map_id=MapId, mcm_module=McmModule} = mgeem_map:get_map_state(),
    #r_monster_state{id=MonsterId,
                     type_id=TypeId,
                     status=MonsterStatus,
                     reborn_type=RebornType,
                     born_pos=BornPos,
                     born_dir=BornDir,
                     pos=#p_pos{x=X,y=Y}} = MonsterState,
    case RebornType of
        ?MONSTER_REBORN_TYPE_REVIVE ->
            Now = mgeem_map:get_now2(),
            NewMonsterId = get_max_monster_id(),
            NewMonsterState = MonsterState#r_monster_state{id = NewMonsterId,
                                                           status = ?MONSTER_STATUS_DEAD,
                                                           last_status= MonsterStatus,
                                                           dead_time = Now,
                                                           next_tick= Now + ?MONSTER_WORK_TICK_NORMAL * 2,
                                                           is_skill_delay=?MONSTER_SKILL_DELAY_NO,
                                                           effect_status=0, 
                                                           next_action=loop, 
                                                           next_data=undefined,
                                                           pos=BornPos, 
                                                           dir=BornDir, 
                                                           ai_data=[],
                                                           dest_pos=undefined, 
                                                           walk_list=[], 
                                                           fight_time=0, 
                                                           be_attack_time=0, 
                                                           last_target_time=0,
                                                           enemy_list=[]},
            add_monster_id_to_list(NewMonsterId),
            set_monster_state(NewMonsterId, NewMonsterState),
            next;
        _ ->
            next
    end,
    mod_fight:erase_common_cd(MonsterId, ?ACTOR_TYPE_MONSTER),
    mod_fight:erase_skill_cd_list(MonsterId, ?ACTOR_TYPE_MONSTER),
    erase_monster_state(MonsterId),
    del_monster_id_from_list(MonsterId),
    mod_map:erase_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
    case mod_map:erase_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER) of
        undefined ->
            next;
        #r_map_actor{skill_delay=SkillDelay} ->
            case SkillDelay of
                {_SkillId, Timeref, _DelayType} ->
                    erlang:cancel_timer(Timeref);
                _ ->
                    next
            end
    end,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    %% 怪物进入地图
    mod_map:deref_tile_pos(MonsterId, ?ACTOR_TYPE_MONSTER, Tx, Ty),
    [#r_map_slice{slice_name=SliceName}] = McmModule:get_slice_name({Tx,Ty}),
    mod_map:leave_slice(SliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
    %% 广播
    %%mod_map_actor:do_dead_slice_notify(MonsterId, ?ACTOR_TYPE_MONSTER, Slice9List),

    %% Monster Hook
    hook_map_monster:monster_dead(TypeId,MapId,RoleId,ActorId,ActorType),
    ok.
%% 怪物进入[警戒]状态，如果是主动怪物，需要获取周围可攻击角色，并进入攻击状态，执行攻击
%% 如果不是主动怪，做巡逻或者移动ai
%% 如果配置怪物不移动，即怪物原地攻击
do_monster_guard(MonsterState) ->
    case catch do_monster_guard2(MonsterState) of
        ok ->
            ok;
        next ->
            do_monster_guard3(MonsterState)
    end.
do_monster_guard2(MonsterState) ->
    #r_monster_state{id=MonsterId,
                     type_id=TypeId,
                     pos = MonsterPos,
                     group_id=GroupId,
                     status=MonsterStatus,
                     ai_data=AiData} = MonsterState,
    #r_monster_info{ai_attack_type=AiAttackType,
                    ai_move_type=AiMoveType,
                    guard_radius=GuardRadius,
                    trace_radius=_TraceRadius} = cfg_monster:find(TypeId),
    case AiAttackType of
        ?MONSTER_AI_ATTACK_TYPE_PASSIVE -> %% 主动攻击
            %% 搜索周围是否敌方，获取目标，并进入[战斗]状态
            case get_attack_target_by_guard_radius(GroupId,MonsterPos,GuardRadius) of
                undefined -> %% 当前没有搜索到可能攻击的目标,计算一个概率，是否需要切换到[巡逻]状态
                    erlang:throw(next);
                {ActorId,ActorType} ->
                    NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                                   status=?MONSTER_STATUS_FIGHT,
                                                                   fight_time=mgeem_map:get_now2(),
                                                                   ai_data=mod_monster_ai:reset_ai_data(AiData)},
                    set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,{?monster_fight_type_base,ActorId,ActorType},NewMonsterState),
                    erlang:throw(ok)
            end;
        _ ->
            next
    end,
    case AiMoveType of
        ?MONSTER_AI_MOVE_TYPE_CAN ->
            erlang:throw(next);
        _ -> %% 进入[保持]状态
            NextMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                            status=?MONSTER_STATUS_HOLD},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MAX,loop,undefined,NextMonsterState)
    end,
    ok.
%% 怪物当前没有搜索到可以攻击的目标
%% 计算一个概率，是否需要切换到[巡逻]状态
do_monster_guard3(MonsterState) ->
    #r_monster_state{id=MonsterId,type_id=TypeId,
                     status=MonsterStatus,
                     born_pos=BornPos,pos = MonsterPos} = MonsterState,
    #r_monster_info{trace_radius=TraceRadius,type=MonsterType} = cfg_monster:find(TypeId),
    case MonsterType of
        ?MONSTER_TYPE_BOSS ->
            AddTick = ?MONSTER_WORK_TICK_MIN;
        ?MONSTER_TYPE_ELITE ->
            AddTick = ?MONSTER_WORK_TICK_MIN * 2;
        _ ->
            AddTick = ?MONSTER_WORK_TICK_MIN * 2 
    end,
    #p_pos{x=X,y=Y} = MonsterPos,
    #p_pos{x=BornX,y=BornY} = BornPos,
    case erlang:abs(X - BornX) =< TraceRadius andalso erlang:abs(Y - BornY) =< TraceRadius of
        true ->
            case common_tool:random(1, 10000) > 9500 of
                true -> %% 进入[巡逻]状态
                    case get_guard_random_pos(MonsterPos) of
                        undefined ->
                            set_next_tick(MonsterId,AddTick,loop,undefined,MonsterState);
                        {#p_map_pos{tx=CurTx,ty=CurTy}=CurMapPos,#p_map_pos{tx=DestTx,ty=DestTy}=DestMapPos} ->
                            case mod_walk:get_walk_path(#p_map_tile{tx=CurTx,ty=CurTy},#p_map_tile{tx=DestTx,ty=DestTy}) of
                                undefined -> %% 无法寻出路径，不需要移动，继续[警戒]状态
                                    set_next_tick(MonsterId,AddTick,loop,undefined,MonsterState);
                                WalkPath ->
                                    do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPath) 
                            end
                    end;
                _ ->
                    set_next_tick(MonsterId,AddTick,loop,undefined,MonsterState)
            end;
        _ ->
            NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,status=?MONSTER_STATUS_FLEE},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN * 2,loop,undefined,NewMonsterState)
    end,
    ok.

do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPathList) ->
    do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPathList,?monster_walk_type,undefined).
%% 怪物走路处理，即传入当次怪物走路的目标点和寻走的路径列表，并设置怪物进入[巡逻]状态
-spec
do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPathList,WalkType,WalkData)  -> ok when
    MonsterId :: integer,
    MonsterState :: #r_monster_state{},
    CurMapPos :: #p_map_pos{},
    DestMapPos :: #p_map_pos{},
    WalkPathList :: [#p_map_tile{}],
    WalkType :: ?monster_walk_type | ?monster_walk_type_fight,
    WalkData :: undefined | {actor_id,actor_type}.
do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPathList,WalkType,WalkData) ->
    #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty} = CurMapPos,
    #p_map_pos{x=DestX,y=DestY} = DestMapPos,
    #p_map_monster{move_speed=MoveSpeed} = MonsterInfo = mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
    mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, MonsterInfo#p_map_monster{walk_pos=#p_pos{x=DestX,y=DestY}}),
    Len = erlang:length(WalkPathList),
    case Len > ?MONSTER_WORK_MIN_TILE of
        true ->
            NextMapTile = lists:nth(?MONSTER_WORK_MIN_TILE, WalkPathList),
            NewWalkPathList = lists:sublist(WalkPathList, ?MONSTER_WORK_MIN_TILE + 1,Len - ?MONSTER_WORK_MIN_TILE);
        _ ->
            NextMapTile = lists:nth(Len, WalkPathList),
            NewWalkPathList = []
    end,
    #p_map_tile{tx=NextTx,ty=NextTy} = NextMapTile,
    {NextX,NextY} = mod_map_slice:to_pixel_pos(NextTx, NextTy),
    NextMapPos = #p_map_pos{x=NextX,y=NextY,tx=NextTx,ty=NextTy},
    Now = mgeem_map:get_now2(),
    AddTick = calc_move_time_interval(X,Y,NextX,NextY,MoveSpeed),
    NewMonsterState = MonsterState#r_monster_state{last_status=MonsterState#r_monster_state.status,
                                                   status=?MONSTER_STATUS_PATROL,
                                                   dest_pos=DestMapPos, 
                                                   walk_list=NewWalkPathList},
    NextData = {WalkType,NextMapPos,WalkData},
    update_next_tick(MonsterId, Now + AddTick, loop, NextData, NewMonsterState),
    
    %% 广播怪物走路
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    SendSelf = #m_move_walk_path_toc{op_code=0,
                                     move_id = MonsterId,
                                     pos = #p_pos{x=DestX,y=DestY}},
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    RoleIdList = mod_map:get_slice_role_list(Slice9List),
    mod_map:broadcast(RoleIdList, ?MOVE, ?MOVE_WALK_PATH, SendSelf),
    ok.

%% 怪物位置变化处理
-spec 
change_monster_walk_pos(MonsterId,OldMapPos,NewMapPos) -> ok when
    MonsterId :: integer,
    OldMapPos :: #p_map_pos{},
    NewMapPos :: #p_map_pos{}.
change_monster_walk_pos(MonsterId,OldMapPos,NewMapPos) ->
    #p_map_pos{tx=Tx,ty=Ty} = NewMapPos,
    #p_map_pos{tx=OldTx,ty=OldTy} = OldMapPos,
    mod_map:deref_tile_pos(MonsterId,?ACTOR_TYPE_MONSTER,OldTx,OldTy),
    mod_map:ref_tile_pos(MonsterId,?ACTOR_TYPE_MONSTER,Tx,Ty),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_name=NewSliceName,slice_9_list=NewSlice9List}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_name=OldSliceName,slice_9_list=OldSlice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
    case OldSliceName =:= NewSliceName of
        true ->
            IsChangeSlice = false,
            next;
        _ ->
            IsChangeSlice = true,
            %% Slice Change
            mod_map:join_slice(NewSliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
            mod_map:leave_slice(OldSliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
            next
    end,
    case IsChangeSlice =:= true of
        true ->
            mod_map_actor:do_change_slice_notify(MonsterId, ?ACTOR_TYPE_MONSTER, OldSlice9List, NewSlice9List),
            next;
        _ ->
            next
    end,
    ok.
%% 怪物进入[巡逻]状态
do_monster_patrol(MonsterState) ->
    catch do_monster_patrol2(MonsterState).
do_monster_patrol2(MonsterState) ->
    #r_monster_state{id=MonsterId,
                     status=MonsterStatus,
                     pos=MonsterPos,
                     next_data=NextData} = MonsterState,
    case NextData of 
        {_,_,_} ->
            do_monster_patrol3(MonsterState);
        _ ->
            %%进入[巡逻]状态时，消息出错，直接转为[警戒]状态
            NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                           status=?MONSTER_STATUS_GUARD,
                                                           dest_pos=undefined, 
                                                           walk_list=[]},
            #p_map_monster{walk_pos=WalkPos} = MapMonsterInfo = mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
            case WalkPos of
                undefined ->
                    ignore;
                _ ->
                    mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonsterInfo#p_map_monster{walk_pos=undefined})
            end,
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,undefined,NewMonsterState),
            #p_pos{x=X,y=Y} = MonsterPos,
            {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
            SendSelf = #m_move_walk_path_toc{op_code=0,
                                             move_id = MonsterId,
                                             pos = MonsterPos},
            #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            mod_map:broadcast(RoleIdList, ?MOVE, ?MOVE_WALK_PATH, SendSelf),
            erlang:throw(ok)
    end.
do_monster_patrol3(MonsterState) ->
    #r_monster_state{id=MonsterId,
                     type_id=MonsterTypeId,
                     status=MonsterStatus,
                     pos=MonsterPos,
                     dest_pos=DestMapPos,
                     walk_list=WalkPathList,
                     next_data=NextData,
                     base_skill={BaseSkillId,_}} = MonsterState,
    MapMonsterInfo= mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
    #p_map_monster{move_speed=MoveSpeed}=MapMonsterInfo,
    
    {WalkType,#p_map_pos{x=X,y=Y,tx=Tx,ty=Ty}=NewMapPos,WalkData} = NextData,
    
    #p_pos{x=OldX,y=OldY} = MonsterPos,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX,OldY),
    NewPos = #p_pos{x=X,y=Y},
    case WalkPathList of
        [] ->
            WalkPos = undefined;
        _ ->
            WalkPos = MapMonsterInfo#p_map_monster.walk_pos
    end,
    NewMapMonsterInfo = MapMonsterInfo#p_map_monster{pos=NewPos,walk_pos=WalkPos},
    mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, NewMapMonsterInfo),
    change_monster_walk_pos(MonsterId,#p_map_pos{x=OldX,y=OldY,tx=OldTx,ty=OldTy},NewMapPos),
    case WalkPathList of
        [] -> %% 本次寻路完成，如果是[战斗]追击过程，判断是否需要立即调整追击目录
            case WalkType of
                ?monster_walk_type_fight -> %% 检查当前是否可以攻击到目标
                    {ActorIdA,ActorTypeA} = WalkData,
                    NextDataA = {?monster_fight_type_base,ActorIdA,ActorTypeA},
                    NewMonsterStatus = ?MONSTER_STATUS_FIGHT;
                _ ->
                    NextDataA = undefined,
                    NewMonsterStatus = ?MONSTER_STATUS_GUARD
            end,
            MonsterStateA = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                         status=NewMonsterStatus,
                                                         dest_pos=undefined,
                                                         pos=NewPos,
                                                         walk_list=[]},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextDataA,MonsterStateA),
            erlang:throw(ok);
        _ ->
            next
    end,
    %% 走路过程中，同步怪物位置
    Len = erlang:length(WalkPathList),
    %% 当路径剩下少于 ?MONSTER_WORK_MIN_TILE 时，如果是追击需要处理是否需要再次追击
    case Len =< ?MONSTER_WORK_MIN_TILE
         andalso WalkType == ?monster_walk_type_fight 
         andalso WalkData =/= undefined of
        true ->
            {ActorId,ActorType} = WalkData,
            case mod_map:get_actor_info(ActorId, ActorType) of
                undefined -> 
                    ActorInfo = undefined,
                    IsPursueAndAttackT = false;
                ActorInfo ->
                    IsPursueAndAttackT = true
            end;
        _ ->
            ActorId = 0,ActorType = 0,
            ActorInfo = undefined,
            IsPursueAndAttackT = false
    end,
    case IsPursueAndAttackT of
        true ->
            case ActorInfo of
                #p_map_role{pos=#p_pos{x=ActorX,y=ActorY}} -> next;
                #p_map_pet{pos=#p_pos{x=ActorX,y=ActorY}} -> next;
                #p_map_monster{pos=#p_pos{x=ActorX,y=ActorY}} -> next
            end,
            [#r_skill_info{distance = SkillDistance}] = cfg_skill:find(BaseSkillId),
            OffsetSkillDistance = SkillDistance - 25,
            case erlang:abs(X - ActorX) =< OffsetSkillDistance  
                andalso erlang:abs(Y - ActorY) =< OffsetSkillDistance of
                true ->
                    IsPursueAndAttack = false;
                _ ->
                    IsPursueAndAttack = true
            end;
        _ ->
            ActorX=0,ActorY=0,SkillDistance=0,
            IsPursueAndAttack = false
    end,
    case IsPursueAndAttack of
        false ->
            case Len > ?MONSTER_WORK_MIN_TILE of
                true ->
                    NextMapTile = lists:nth(?MONSTER_WORK_MIN_TILE, WalkPathList),
                    NewWalkPathList = lists:sublist(WalkPathList, ?MONSTER_WORK_MIN_TILE + 1,Len - ?MONSTER_WORK_MIN_TILE);
                _ ->
                    NextMapTile = lists:nth(Len, WalkPathList),
                    NewWalkPathList = []
            end,
            case NewWalkPathList of
                [] ->
                    NextMapPos = DestMapPos,
                    #p_map_pos{x=NextX,y=NextY} = NextMapPos;
                _ ->
                    #p_map_tile{tx=NextTx,ty=NextTy} = NextMapTile,
                    {NextX,NextY} = mod_map_slice:to_pixel_pos(NextTx, NextTy),
                    NextMapPos = #p_map_pos{x=NextX,y=NextY,tx=NextTx,ty=NextTy}
            end,
            AddTick = calc_move_time_interval(X,Y,NextX,NextY,MoveSpeed),
            MonsterStateB = MonsterState#r_monster_state{status=?MONSTER_STATUS_PATROL,
                                                         pos=NewPos,
                                                         dest_pos=DestMapPos, 
                                                         walk_list=NewWalkPathList},
            NewNextData = {WalkType,NextMapPos,WalkData},
            update_next_tick(MonsterId, mgeem_map:get_now2() + AddTick, loop, NewNextData, MonsterStateB),
            erlang:throw(ok);
        _ ->
            next
    end,
    %% 重新追击，即重新寻路追击
    {ActorTx,ActorTy} = mod_map_slice:to_tile_pos(ActorX,ActorY),
    ActorMapPos= #p_map_pos{x=ActorX,y=ActorY,tx=ActorTx,ty=ActorTy},
    #r_monster_info{attack_mode=MonsterAttackMode,type=MonsterType} = cfg_monster:find(MonsterTypeId),
    case calc_target_pos_around_random_pos(MonsterType,MonsterAttackMode,NewMapPos,ActorMapPos,SkillDistance) of
        {TargetMapPos,TargetWalkPathList} ->
            MonsterStateC = MonsterState#r_monster_state{pos=NewPos},
            do_monster_walk(MonsterId,MonsterStateC,NewMapPos,TargetMapPos,TargetWalkPathList,?monster_walk_type_fight,{ActorId,ActorType}),
            erlang:throw(ok);
        TargetMapPos ->
            next
    end,
    #p_map_pos{tx=TargetTx,ty=TargetTy} = TargetMapPos,
    case mod_walk:get_walk_path(#p_map_tile{tx=Tx,ty=Ty},#p_map_tile{tx=TargetTx,ty=TargetTy}) of
        undefined -> %% 无法继续追击，直接进入[战斗]状态，进行调整处理
            MonsterStateD = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                         pos=NewPos,
                                                         status=?MONSTER_STATUS_FIGHT},
            mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, NewMapMonsterInfo#p_map_monster{walk_pos=undefined}),
            %% 寻路出错，需要强制同步位置
            {Tx,Ty} = mod_map_slice:to_tile_pos(NewPos#p_pos.x,NewPos#p_pos.y),
            SendSelf = #m_move_sync_toc{move_id = MonsterId,pos = NewPos},
            #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            mod_map:broadcast(RoleIdList, ?MOVE, ?MOVE_SYNC, SendSelf),
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,{?monster_fight_type_base,ActorId,ActorType},MonsterStateD);
        NewTargetWalkPathList -> %% 进入[巡逻]状态
            MonsterStateE = MonsterState#r_monster_state{pos=NewPos},
            do_monster_walk(MonsterId,MonsterStateE,NewMapPos,TargetMapPos,NewTargetWalkPathList,?monster_walk_type_fight,{ActorId,ActorType})
    end,
    ok.


%% 怪物进入[战斗]状态 攻击目标，如果没有目标即退出战斗状态，进入[警戒]状态
%% 判断是否进入攻击距离，如果不够距离需要追击[巡逻]寻路，如果当前位置已经远离离出生点超超过追击半径，即返回出生点
do_monster_fight(MonsterState) ->
    #r_monster_state{id=MonsterId,next_data=NextData} = MonsterState,
    case catch do_monster_fight2(MonsterState) of
        ok ->
            ok;
        {keep,AddTick} ->
            set_next_tick(MonsterId,AddTick,loop,NextData,MonsterState);
        {track_attack,ActorId,ActorType,ActorInfo} ->
            do_monster_fight4(MonsterState,ActorId,ActorType,ActorInfo);
        {next,Now2,ActorId,ActorType,ActorInfo,SkillId,NewAiData} ->
            do_monster_fight3(MonsterState,ActorId,ActorType,ActorInfo,Now2,SkillId,NewAiData)
    end.
do_monster_fight2(MonsterState) ->
    #r_monster_state{id=MonsterId,
                     type_id=TypeId,
                     status=MonsterStatus,
                     group_id=GroupId,
                     pos = MonsterPos,
                     next_data=NextData,
                     enemy_list=EnemyList,
                     be_attack_time=BeAttackTime,
                     fight_time=FightTime,
                     last_target_time=LastTargetTime,
                     ai_data=AiData,
                     base_skill={BaseSkillId,_BaseSkillLevel}} = MonsterState,
    #r_monster_info{guard_radius=GuardRadius,
                    trace_radius=TraceRadius,
                    type=MonsterType,
                    ai_id=AiId} = cfg_monster:find(TypeId),
    #r_map_actor{attr=MonsterAttr,skill_delay=SkillDelay} = mod_map:get_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER),
    Now2 = mgeem_map:get_now2(),
    %% 判断当前怪物是否冷唱技能
    %% {_DelaySkillId,_DelayTimerRef,_DelayType} = SkillDealy
    case SkillDelay of 
        undefined ->
            next;
        _ ->
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,MonsterState),
            erlang:throw(ok)
    end,
    %% 怪物受攻击状态时间未过，无法攻击
    case MonsterType of
        ?MONSTER_TYPE_NORMAL ->
            case Now2 - BeAttackTime > ?MONSTER_ATTACK_INTERVAL of
                true ->
                    next;
                _ -> 
                    erlang:throw({keep,Now2 - BeAttackTime})
            end;
        _ ->
            next
    end,
    %% 怪物技能间隔时间
    SkillCommonCD = mod_fight:get_common_cd(MonsterId, ?ACTOR_TYPE_MONSTER),
    case Now2 >  SkillCommonCD of
        true ->
            next;
        _ ->
            erlang:throw({keep,SkillCommonCD - Now2})
    end,
    %% 获取当前怪物可以触的技能
    case NextData of
        {?monster_fight_type_ai,_,_,#r_ai_trigger{event_type=?MONSTER_AI_EVENT_TYPE_SKILL,
                                                                event_val_1=SkillId}} ->
            NewAiData=AiData;
        {?monster_fight_type_ai,_,_,_} ->
            NewAiData=AiData,
            SkillId = BaseSkillId;
        _ ->
            case mod_monster_ai:get_ai_trigger_attack(AiId,MonsterId,FightTime,AiData,MonsterAttr) of
                {undefined,NewAiData} ->
                    SkillId = BaseSkillId;
                {#r_ai_trigger{event_type=?MONSTER_AI_EVENT_TYPE_SKILL,
                               event_val_1=SkillId},NewAiData} ->
                    next;
                {_,NewAiData} ->
                    SkillId = BaseSkillId
            end
    end,
    %% 怪物技能冷却时间
    SkillCD = mod_fight:get_skill_cd_time(MonsterId, ?ACTOR_TYPE_MONSTER, SkillId),
    case Now2 > SkillCD of
        true ->
            next;
        _ ->
            erlang:throw({keep,SkillCD - Now2})
    end,
    %% 攻击目录信息获取
    case NextData of
        {?monster_fight_type_ai,ActorId,ActorType,_} ->
            case mod_map:get_actor_info(ActorId,ActorType) of
                undefined ->
                    ActorInfo=undefined;
                ActorInfo ->
                    next
            end;
        {?monster_fight_type_base,ActorId,ActorType} ->
            case mod_map:get_actor_info(ActorId,ActorType) of
                undefined ->
                    ActorInfo=undefined;
                ActorInfo ->
                    next
            end;
        _ ->
            case get_enemy_actor(EnemyList, MonsterPos) of
                undefined -> %% 查找不到有效的攻击目标，进入[警戒]状态
                    ActorId=0,ActorType=0,ActorInfo=undefined;
                {ActorId,ActorType,ActorInfo} ->
                    next
            end
    end,
    %% 攻击目标是否死亡
    case ActorInfo of
        #p_map_role{hp=Hp,pos=Pos} -> next;
        #p_map_pet{hp=Hp,pos=Pos} -> next;
        #p_map_monster{hp=Hp,pos=Pos} -> next;
        undefined -> Hp=0,Pos=undefined;
        _ -> Hp = 0,Pos=undefined
    end,
    %% 是否切换攻击目标
    case Hp > 0 of
        true ->
            case MonsterType of
                ?MONSTER_TYPE_BOSS ->
                    AttackChangeTargetInterval = ?MONSTER_ATTACK_CHANGE_TARGET_BOSS;
                ?MONSTER_TYPE_ELITE ->
                    AttackChangeTargetInterval = ?MONSTER_ATTACK_CHANGE_TARGET_BOSS;
                _ ->
                    AttackChangeTargetInterval = ?MONSTER_ATTACK_CHANGE_TARGET
            end,
            case LastTargetTime =/= 0 andalso Now2 - LastTargetTime > AttackChangeTargetInterval of
                true ->
                    IsChangeTarget = true;
                _ ->
                    IsChangeTarget = false
            end;
        _ ->
            IsChangeTarget = true
    end,
    %% 目标当前状态不能成为攻击目标
    case mod_map:get_map_actor(ActorId, ActorType) of
        #r_map_actor{fight_buff=FightBuffList} ->
            IsVirtual =  mod_fight_calculate:is_virtual(FightBuffList);
        _ ->
            IsVirtual = false
    end,
    %% 当前怪物与攻击目标的距离
    case Hp > 0 of
        true ->
            Distance = mod_map_slice:calc_ab_distance(MonsterPos, Pos);
        _ ->
            Distance = 0
    end,
    %% 当切换攻击目标时，搜索新目标
    case IsVirtual == true orelse Hp =< 0 orelse (IsChangeTarget == true andalso SkillId == BaseSkillId) of
        true ->
            %% 搜索周围是否敌方，获取目标，进入[警戒]状态
            case get_attack_target_by_guard_radius(GroupId,MonsterPos,GuardRadius) of
                undefined ->
                    %% 目标已经出了怪物的视野，需要判断是否超过追踪距离，如果不超过即继续追击，如果超过，即进入[警戒]状态
                    case  Hp > 0 andalso IsVirtual == false andalso Distance =< TraceRadius of
                        true ->
                            next;
                        _ ->
                            NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                                           status=?MONSTER_STATUS_GUARD,
                                                                           fight_time=0,
                                                                           last_target_time=0,
                                                                           ai_data=mod_monster_ai:reset_ai_data(AiData)},
                            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,undefined,NewMonsterState),
                            erlang:throw(ok)
                    end;
                {NewActorId,NewActorType} ->
                    case NewActorId == ActorId andalso NewActorType == ActorType of
                        true ->
                            next;
                        _ ->
                            NewMonsterState = MonsterState#r_monster_state{last_target_time=Now2},
                            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,{?monster_fight_type_base,NewActorId,NewActorType},NewMonsterState),
                            erlang:throw(ok)
                    end
            end;
        _ ->
            next
    end,
    %% 判断当前的攻击距离，是否可以发起攻击
    [#r_skill_info{target_type=SkillTargetType,distance=SkillDistance}] = cfg_skill:find(SkillId),
    case SkillTargetType == ?F_TARGET_TYPE_SELF
         orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND
         orelse SkillTargetType == ?F_TARGET_TYPE_ADD_HP_CHAIN
         orelse SkillTargetType == ?F_TARGET_TYPE_SELF_AROUND_TRAP of
        true ->
            next;
        _ ->
            case Distance =< SkillDistance of
                true ->
                    next;
                _ -> %% 追击攻击目标
                    erlang:throw({track_attack,ActorId,ActorType,ActorInfo})
            end
    end,
    {next,Now2,ActorId,ActorType,ActorInfo,SkillId,NewAiData}.
do_monster_fight3(MonsterState,ActorId,ActorType,ActorInfo,Now2,SkillId,NewAiData) ->
    #r_monster_state{id=MonsterId,
                     last_target_time=LastTargetTime} = MonsterState,
    case LastTargetTime =:= 0 of
        true ->
            NewLastTargetTime = Now2;
        _ ->
            NewLastTargetTime = LastTargetTime
    end,
    case ActorType of
        ?ACTOR_TYPE_ROLE ->
            #p_map_role{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo;
        ?ACTOR_TYPE_PET ->
            #p_map_pet{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo;
        ?ACTOR_TYPE_MONSTER ->
            #p_map_monster{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo
    end,
    [#r_skill_info{target_type=SkillTargetType}] = cfg_skill:find(SkillId),
    NewMonsterState = MonsterState#r_monster_state{last_target_time=NewLastTargetTime,
                                                   ai_data=NewAiData},
    set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,{?monster_fight_type_base,ActorId,ActorType},NewMonsterState),
    %% 触发技能处理
    case SkillTargetType of
        ?F_TARGET_TYPE_SELF ->
            TargetId = 0,TargetType = 0,TargetPos=#p_pos{x=0,y=0};
        ?F_TARGET_TYPE_SELF_AROUND ->
            TargetId = 0,TargetType = 0,TargetPos=#p_pos{x=0,y=0};
        ?F_TARGET_TYPE_ADD_HP_CHAIN ->
            TargetId = 0,TargetType = 0,TargetPos=#p_pos{x=0,y=0};
        ?F_TARGET_TYPE_SELF_AROUND_TRAP ->
            TargetId = 0,TargetType = 0,TargetPos=#p_pos{x=0,y=0};
        ?F_TARGET_TYPE_OTHER_AROUND_TRAP ->
            TargetId = 0,TargetType = 0,TargetPos=#p_pos{x=DestX,y=DestY};
        _ ->
            TargetId = ActorId,TargetType =ActorType,TargetPos=#p_pos{x=DestX,y=DestY}
    end,
    mod_fight:apply_skill(SkillId, 0, MonsterId, ?ACTOR_TYPE_MONSTER, TargetId,TargetType,TargetPos),
    ok.
%% 跟踪攻击目标
do_monster_fight4(MonsterState,ActorId,ActorType,ActorInfo) ->
    #r_monster_state{id=MonsterId,
                     type_id=MonsterTypeId,
                     status=MonsterStatus,
                     pos=MonsterPos,
                     ai_data=AiData,
                     base_skill={SkillId,_SkillLevel}} = MonsterState,
    case ActorType of
        ?ACTOR_TYPE_ROLE ->
            #p_map_role{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo;
        ?ACTOR_TYPE_PET ->
            #p_map_pet{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo;
        ?ACTOR_TYPE_MONSTER ->
            #p_map_monster{pos=#p_pos{x=DestX,y=DestY}} = ActorInfo
    end,
    #p_pos{x=X,y=Y} = MonsterPos,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    {DestTx,DestTy} = mod_map_slice:to_tile_pos(DestX,DestY),
    CurMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    DestMapPos= #p_map_pos{x=DestX,y=DestY,tx=DestTx,ty=DestTy},
    [#r_skill_info{distance=SkillDistance}] = cfg_skill:find(SkillId),
     #r_monster_info{attack_mode=MonsterAttackMode,type=MonsterType} = cfg_monster:find(MonsterTypeId),
    case calc_target_pos_around_random_pos(MonsterType,MonsterAttackMode,CurMapPos,DestMapPos,SkillDistance) of
        {TargetMapPos,WalkPathList} ->
            do_monster_walk(MonsterId,MonsterState,CurMapPos,TargetMapPos,WalkPathList,?monster_walk_type_fight,{ActorId,ActorType});
        TargetMapPos ->
            #p_map_pos{tx=TargetTx,ty=TargetTy} = TargetMapPos,
            case mod_walk:get_walk_path(#p_map_tile{tx=Tx,ty=Ty},#p_map_tile{tx=TargetTx,ty=TargetTy}) of
                undefined -> %% 无法寻出路径，不需要移动，继续[警戒]状态
                    NewMonsterState = MonsterState#r_monster_state{last_status=MonsterStatus,
                                                                   fight_time=0,
                                                                   last_target_time=0,
                                                                   status=?MONSTER_STATUS_GUARD,
                                                                   ai_data=mod_monster_ai:reset_ai_data(AiData)},
                    set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,undefined,NewMonsterState);
                WalkPathList -> %% 进入[巡逻]状态
                    do_monster_walk(MonsterId,MonsterState,CurMapPos,TargetMapPos,WalkPathList,?monster_walk_type_fight,{ActorId,ActorType})
            end
    end,
    ok.
%% 怪物进入[保持]状态  啥都不做
do_monster_hold(MonsterState) ->
    #r_monster_state{id=MonsterId,type_id=TypeId} = MonsterState,
    #r_monster_info{type=MonsterType} = cfg_monster:find(TypeId),
    case MonsterType of
        ?MONSTER_TYPE_NORMAL ->
            AddTick = ?MONSTER_WORK_TICK_MAX;
        _ ->
            AddTick = ?MONSTER_WORK_TICK_NORMAL
    end,
    set_next_tick(MonsterId,AddTick,loop,undefined,MonsterState),
    ok.
%% 怪物[返回]到出生点，即怪物追击目标时，距离出生点在远，即需要放弃目标，返回出生点
%% 直接返回，中间不寻路，减少压力，即相当于逃跑，但中是不按原路返回
do_monster_flee(MonsterState) ->
    #r_monster_state{id=MonsterId,
                     born_pos=BornPos,
                     pos=Pos} = MonsterState,
    #p_pos{x=X,y=Y} = Pos,{Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    #p_pos{x=DestX,y=DestY} = BornPos,{DestTx,DestTy} = mod_map_slice:to_tile_pos(DestX, DestY),
    case mod_walk:get_walk_path(#p_map_tile{tx=Tx,ty=Ty},#p_map_tile{tx=DestTx,ty=DestTy}) of
        undefined -> %% 无法寻出路径，不需要移动，继续[警戒]状态
            NewMonsterState = MonsterState#r_monster_state{last_status=MonsterState#r_monster_state.status,
                                                           status=?MONSTER_STATUS_GUARD},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_NORMAL,loop,undefined,NewMonsterState);
        WalkPathList -> %% 进入[巡逻]状态
            CurMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
            DestMapPos= #p_map_pos{x=DestX,y=DestY,tx=DestTx,ty=DestTy},
            do_monster_walk(MonsterId,MonsterState,CurMapPos,DestMapPos,WalkPathList) 
    end,
    ok.

%% 停顿，只需设置下次检查时间，其它操作不变
do_monster_pause(MonsterState) ->
    #r_monster_state{id=MonsterId,next_data=NextData} = MonsterState,
    set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,MonsterState),
    ok.
%% 怪物延迟释放技能
set_monster_skill_delay(MonsterId) ->
    case get_monster_state(MonsterId) of
        undefined ->
            ignore;
         #r_monster_state{next_data=NextData}=MonsterState ->
            NewMonsterState = MonsterState#r_monster_state{is_skill_delay = ?MONSTER_SKILL_DELAY_YES},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,NewMonsterState)   
    end.
erase_monster_skill_delay(MonsterId) ->
    case get_monster_state(MonsterId) of
        undefined ->
            ignore;
         #r_monster_state{next_data=NextData}=MonsterState ->
            NewMonsterState = MonsterState#r_monster_state{is_skill_delay = ?MONSTER_SKILL_DELAY_NO},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,NewMonsterState)   
    end.

set_monster_effect_status(MonsterId,EffectStatus) ->
    case get_monster_state(MonsterId) of
        undefined ->
            ignore;
         #r_monster_state{next_data=NextData}=MonsterState ->
            NewMonsterState = MonsterState#r_monster_state{effect_status = EffectStatus},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,NewMonsterState)   
    end.
erase_monster_effect_status(MonsterId) ->
    case get_monster_state(MonsterId) of
        undefined ->
            ignore;
         #r_monster_state{next_data=NextData}=MonsterState ->
            NewMonsterState = MonsterState#r_monster_state{effect_status = 0},
            set_next_tick(MonsterId,?MONSTER_WORK_TICK_MIN,loop,NextData,NewMonsterState)   
    end.

%%-------------------------------------------------------------------
%%
%% local function
%%
%%-------------------------------------------------------------------


%% 增加攻击者进入怪物仇恨列表
-spec add_monster_enemy(EnemyList,ActorId,ActorType,ReduceHp) -> NewEnemyList when
          EnemyList :: list,
          ActorId :: role_id | pet_id | monster_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
          ReduceHp :: integer,
          NewEnemyList :: list.
add_monster_enemy([],ActorId,ActorType,ReduceHp) ->
    MonsterEnemy = #r_enemy{key={ActorId,ActorType},
                            last_attack_time=mgeem_map:get_now(),
                            total_hurt=ReduceHp},
    [MonsterEnemy];
add_monster_enemy(EnemyList,ActorId,ActorType,ReduceHp) ->
    Now = mgeem_map:get_now(),
    case lists:keyfind({ActorId,ActorType}, #r_enemy.key, EnemyList) of
        false ->
            MonsterEnemy = #r_enemy{key={ActorId,ActorType},
                            last_attack_time=Now,
                            total_hurt=ReduceHp},
            [MonsterEnemy|EnemyList];
        #r_enemy{total_hurt=OldReduceHp} ->
            MonsterEnemy = #r_enemy{key={ActorId,ActorType},
                            last_attack_time=Now,
                            total_hurt=OldReduceHp + ReduceHp},
            [MonsterEnemy|lists:keydelete({ActorId,ActorType}, #r_enemy.key, EnemyList)]
    end.
%% 根据逻辑获取当前的攻击目标
%% return {ActorId,ActorType,ActorInfo}| undefined
-spec
get_enemy_actor(EnemyList,MonsterPos) -> {ActorId,ActorType,ActorInfo}| undefined when
    EnemyList :: [#r_enemy{}],
    MonsterPos :: #p_pos{},
    ActorId :: role_id | pet_id | monster_id,
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
    ActorInfo :: #p_map_role{} | #p_map_pet{} | #p_map_monster{}.
get_enemy_actor([],_MonsterPos) ->
    undefined;
get_enemy_actor(EnemyList,MonsterPos) ->
    %% 按最后攻击时间排序，和扣血量处理
    SortEnemyList = 
        lists:sort(
          fun(EnemyA,EnemyB) -> 
                  case EnemyA#r_enemy.last_attack_time > EnemyB#r_enemy.last_attack_time of
                      true ->
                          true;
                      _ ->
                          EnemyA#r_enemy.total_hurt > EnemyB#r_enemy.total_hurt
                  end
          end, EnemyList),
    get_enemy_actor2(do,SortEnemyList,undefined,MonsterPos,undefined).
get_enemy_actor2(do,[],undefined,_MonsterPos,SpareTire) ->
    SpareTire;
get_enemy_actor2(do,[],Result,_MonsterPos,_SpareTire) ->
    Result;
get_enemy_actor2(done,_SortEnemyList,Result,_MonsterPos,_SpareTire) ->
    Result;
get_enemy_actor2(do,[#r_enemy{key={ActorId,ActorType}}|SortEnemyList],Result,MonsterPos,SpareTire) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{pos=#p_pos{x=X,y=Y},hp=Hp}=ActorInfo ->
            next;
        #p_map_pet{pos=#p_pos{x=X,y=Y},hp=Hp}=ActorInfo ->
            next;
        #p_map_monster{pos=#p_pos{x=X,y=Y},hp=Hp}=ActorInfo ->
            next;
        _ ->
            X=undefined,Y=undefined,ActorInfo=undefined,Hp=0
    end,
    case Hp > 0 of
        true ->
            case ActorInfo of
                undefined ->
                    get_enemy_actor2(do,SortEnemyList,Result,MonsterPos,SpareTire);
                _ ->
                    #r_map_actor{fight_buff=FightBuffList} = mod_map:get_map_actor(ActorId, ActorType),
                    case mod_fight_calculate:is_virtual(FightBuffList) of
                        true ->
                            get_enemy_actor2(do,SortEnemyList,Result,MonsterPos,SpareTire);
                        _ ->
                            case erlang:abs(X - MonsterPos#p_pos.x) > ?MONSTER_MAX_ENEMY_DISTANCE
                                 andalso erlang:abs(Y - MonsterPos#p_pos.y) > ?MONSTER_MAX_ENEMY_DISTANCE of
                                true ->
                                    get_enemy_actor2(do,SortEnemyList,Result,MonsterPos,{ActorId, ActorType,ActorInfo});
                                _ ->
                                    get_enemy_actor2(done,SortEnemyList,{ActorId, ActorType,ActorInfo},MonsterPos,SpareTire)
                            end
                    end
            end;
        _ ->
            get_enemy_actor2(do,SortEnemyList,Result,MonsterPos,SpareTire)
    end.

%% 根据当前点计算出目标点周围的随机点
%% 一般用一近战怪物攻击目标时，获取目标周围的随机点，体现出多不同角度攻击目标的游戏表现
%% Distance 最远距离单位CM
-spec
calc_target_pos_around_random_pos(MonsterType,MonsterAttackMode,CurPos,TargetPos,Distance) -> Pos | {Pos,WalkPathList} when
    MonsterType :: ?MONSTER_TYPE_NORMAL | ?MONSTER_TYPE_ELITE | ?MONSTER_TYPE_BOSS,
    MonsterAttackMode :: ?MONSTER_ATTACK_MODE_PHY | ?MONSTER_ATTACK_MODE_MAGIC,
    CurPos :: #p_map_pos{},
    TargetPos :: #p_map_pos{},
    Distance :: integer,
    Pos :: #p_map_pos{},
    WalkPathList :: [#p_map_tile{}].
calc_target_pos_around_random_pos(?MONSTER_TYPE_BOSS,_MonsterAttackMode,CurPos,TargetPos,Distance) ->
    calc_target_pos_around_random_pos(?MONSTER_ATTACK_MODE_MAGIC,CurPos,TargetPos,Distance);
calc_target_pos_around_random_pos(?MONSTER_TYPE_ELITE,_MonsterAttackMode,CurPos,TargetPos,Distance) ->
    calc_target_pos_around_random_pos(?MONSTER_ATTACK_MODE_MAGIC,CurPos,TargetPos,Distance);
calc_target_pos_around_random_pos(_MonsterType,MonsterAttackMode,CurPos,TargetPos,Distance) ->
    calc_target_pos_around_random_pos(MonsterAttackMode,CurPos,TargetPos,Distance).
   
calc_target_pos_around_random_pos(?MONSTER_ATTACK_MODE_MAGIC,CurPos,TargetPos,Distance) ->                                                                                                        
    #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty} = CurPos,
    #p_map_pos{x=DestX,y=DestY,tx=DestTx,ty=DestTy} = TargetPos,
    Dir = mod_map_slice:calc_direction_by_pos(#p_pos{x=X,y=Y},#p_pos{x=DestX,y=DestY}),
    AB = erlang:trunc(math:sqrt((DestX - X) * (DestX - X) + (DestY - Y) * (DestY - Y))),
    OffsetDistance = 50,
    CurDistance = erlang:max(OffsetDistance, AB - Distance + OffsetDistance),
    RandomX = erlang:trunc(X + ((DestX - X) / AB) * CurDistance),
    RandomY = erlang:trunc(Y + ((DestY - Y) / AB) * CurDistance),
    {RandomTx,RandomTy} = mod_map_slice:to_tile_pos(RandomX, RandomY),
    case mod_map:check_tile_pos(RandomTx,RandomTy) of
        true ->
            NewX = RandomX,NewY = RandomY,NewTx = RandomTx,NewTy = RandomTy;
        _ ->
            NewX = DestX,NewY = DestY,NewTx = DestTx,NewTy = DestTy
    end,
    %% 只做直接寻路处理
    case mod_walk:get_straight_line_path(#p_map_tile{tx=Tx,ty=Ty,dir=Dir}, #p_map_tile{tx=NewTx,ty=NewTy,dir=Dir}, []) of
        false ->
            Step = erlang:trunc(Distance div ?MAP_TILE_SIZE),
            calc_target_pos_around_random_pos2(TargetPos,Dir,Step);
        {ok,PathList} ->
            WalkPathList = [#p_map_tile{tx=PTx,ty=PTy,dir=PDir} || {PTx,PTy,PDir} <- PathList],
            {#p_map_pos{x=NewX,y=NewY,tx=NewTx,ty=NewTy},WalkPathList}
    end;
calc_target_pos_around_random_pos(?MONSTER_ATTACK_MODE_PHY,CurPos,TargetPos,Distance) ->
    #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty} = CurPos,
    #p_map_pos{x=DestX,y=DestY,tx=DestTx,ty=DestTy} = TargetPos,
    Dir = mod_map_slice:calc_direction_by_pos(#p_pos{x=X,y=Y},#p_pos{x=DestX,y=DestY}),
    {RandomX,RandomY} = random_target_pos(DestX,DestY,Dir,Distance),
    {RandomTx,RandomTy} = mod_map_slice:to_tile_pos(RandomX, RandomY),
    case mod_map:check_tile_pos(RandomTx,RandomTy) of
        true ->
            NewX = RandomX,NewY = RandomY,NewTx = RandomTx,NewTy = RandomTy;
        _ ->
            NewX = DestX,NewY = DestY,NewTx = DestTx,NewTy = DestTy
    end,
    %% 只做直接寻路处理
    case mod_walk:get_straight_line_path(#p_map_tile{tx=Tx,ty=Ty,dir=Dir}, #p_map_tile{tx=NewTx,ty=NewTy,dir=Dir}, []) of
        false ->
            Step = erlang:trunc(Distance div ?MAP_TILE_SIZE),
            calc_target_pos_around_random_pos2(TargetPos,Dir,Step);
        {ok,PathList} ->
            WalkPathList = [#p_map_tile{tx=PTx,ty=PTy,dir=PDir} || {PTx,PTy,PDir} <- PathList],
            {#p_map_pos{x=NewX,y=NewY,tx=NewTx,ty=NewTy},WalkPathList}
    end.
calc_target_pos_around_random_pos2(TargetPos,Dir,Step) ->
    #p_map_pos{tx=DestTx,ty=DestTy} = TargetPos,
    if Dir == 1 orelse Dir == 8 ->
           PosList = lists:flatten([[{PDestTx,PDestTy} 
                                    || PDestTy <- lists:seq(DestTy - Step, DestTy)] 
                                   || PDestTx <- lists:seq(DestTx - Step, DestTx + Step)]);
       Dir == 2 orelse Dir == 3 ->
           PosList = lists:flatten([[{PDestTx,PDestTy} 
                                    || PDestTy <- lists:seq(DestTy - Step, DestTy + Step)] 
                                   || PDestTx <- lists:seq(DestTx - Step, DestTx)]);
       Dir == 4 orelse Dir == 5 ->
           PosList = lists:flatten([[{PDestTx,PDestTy} 
                                    || PDestTy <- lists:seq(DestTy, DestTy + Step)] 
                                   || PDestTx <- lists:seq(DestTx - Step, DestTx + Step)]);
       Dir == 6 orelse Dir == 7 ->
           PosList = lists:flatten([[{PDestTx,PDestTy} 
                                    || PDestTy <- lists:seq(DestTy - Step, DestTy + Step)] 
                                   || PDestTx <- lists:seq(DestTx, DestTx + Step)]);
       true ->
           PosList =[{DestTx + Step,DestTy},{DestTx + Step,DestTy + Step},{DestTx + Step,DestTy - Step},
                     {DestTx - Step,DestTy},{DestTx - Step,DestTy - Step},{DestTx -Step,DestTy - Step},
                     {DestTx,DestTy + Step},{DestTx,DestTy - Step}]
    end,
    PosList2 = [{PTx,PTy} || {PTx,PTy} <- PosList, mod_map:check_tile_pos(PTx,PTy) =:= true],
    case PosList2 of
        [] -> 
            TargetPos;
        _ ->
            {NewTx,NewTy} = lists:nth(common_tool:random(1,erlang:length(PosList2)),PosList2),
            {NewX,NewY} = mod_map_slice:to_pixel_pos(NewTx,NewTy),
            #p_map_pos{x=NewX,y=NewY,tx=NewTx,ty=NewTy}
    end.
%% 根据结束点相对于开始点的方向，计算出距离结束点一段距离内的随机点
-spec 
random_target_pos(DestX,DestY,Dir,Distance) -> {TargetX,TargetY} when
    DestX :: integer(),
    DestY :: integer(),
    Dir :: 1|2|3|4|5|6|7|8,
    Distance :: integer(),
    TargetX :: integer(),
    TargetY :: integer().
random_target_pos(DestX,DestY,Dir,Distance) ->
    Random =  common_tool:random(1, 10000),
    Offset = 0.6,
    if Dir == 1 orelse Dir == 2 ->
           StartX =  erlang:trunc(DestX - Distance * Offset),
           StartY =  erlang:trunc(DestY - Distance * Offset),
           if Random > 6600 ->
                  Ax = erlang:trunc(DestX - Distance * 0.625),
                  Ay = erlang:trunc(DestY - Distance * 0.625),
                  TargetX = common_tool:random(Ax,StartX),
                  TargetY = common_tool:random(Ay,StartY);
               Random > 3300 ->
                  Ax = erlang:trunc(DestX - Distance * 0.875),
                  Ay = erlang:trunc(DestY - Distance * 0.125),
                  TargetX = common_tool:random(Ax,StartX),
                  TargetY = common_tool:random(Ay,DestY);
              true ->
                  Ax = erlang:trunc(DestX - Distance * 0.125),
                  Ay = erlang:trunc(DestY - Distance * 0.875),
                  TargetX = common_tool:random(Ax,DestX),
                  TargetY = common_tool:random(Ay,StartY)
           end;
       Dir == 3 orelse Dir == 4 ->
           StartX =  erlang:trunc(DestX - Distance * Offset),
           StartY =  erlang:trunc(DestY + Distance * Offset),
           if Random > 6600 ->
                  Ax = erlang:trunc(DestX - Distance * 0.625),
                  Ay = erlang:trunc(DestY + Distance * 0.625),
                  TargetX = common_tool:random(Ax,StartX),
                  TargetY = common_tool:random(StartY,Ay);
              Random > 3300 ->
                  Ax = erlang:trunc(DestX - Distance * 0.875),
                  Ay = erlang:trunc(DestY + Distance * 0.125),
                  TargetX = common_tool:random(Ax,StartX),
                  TargetY = common_tool:random(DestY,Ay);
              true ->
                  Ax = erlang:trunc(DestX - Distance * 0.125),
                  Ay = erlang:trunc(DestY + Distance * 0.875),
                  TargetX = common_tool:random(Ax,DestX),
                  TargetY = common_tool:random(StartY,Ay)
           end;
       Dir == 5 orelse Dir == 6 ->
           StartX =  erlang:trunc(DestX + Distance * Offset),
           StartY =  erlang:trunc(DestY + Distance * Offset),
           if Random > 6600 ->
                  Ax = erlang:trunc(DestX + Distance * 0.625),
                  Ay = erlang:trunc(DestY + Distance * 0.625),
                  TargetX = common_tool:random(StartX,Ax),
                  TargetY = common_tool:random(StartY,Ay);
              Random > 3300 ->
                  Ax = erlang:trunc(DestX + Distance * 0.875),
                  Ay = erlang:trunc(DestY + Distance * 0.125),
                  TargetX = common_tool:random(StartX, Ax),
                  TargetY = common_tool:random(DestY, Ay);
              true ->
                  Ax = erlang:trunc(DestX + Distance * 0.125),
                  Ay = erlang:trunc(DestY + Distance * 0.875),
                  TargetX = common_tool:random(DestX, Ax),
                  TargetY = common_tool:random(StartY, Ay)
           end;
       true ->
           StartX =  erlang:trunc(DestX + Distance * Offset),
           StartY =  erlang:trunc(DestY - Distance * Offset),
           if Random > 6600 ->
                  Ax = erlang:trunc(DestX + Distance * 0.625),
                  Ay = erlang:trunc(DestY - Distance * 0.625),
                  TargetX = common_tool:random(StartX,Ax),
                  TargetY = common_tool:random(Ay,StartY);
              Random > 3300 ->
                  Ax = erlang:trunc(DestX + Distance * 0.875),
                  Ay = erlang:trunc(DestY - Distance * 0.125),
                  TargetX = common_tool:random(StartX,Ax),
                  TargetY = common_tool:random(Ay,DestY);
              true ->
                  Ax = erlang:trunc(DestX + Distance * 0.125),
                  Ay = erlang:trunc(DestY - Distance * 0.875),
                  TargetX = common_tool:random(DestX,Ax),
                  TargetY = common_tool:random(Ay,StartY)
           end
    end,
    {TargetX,TargetY}.

%% 计算从一个点移动到另一个点，需要的时间间隔
%% 返回的时间间隔单位为:毫秒[millisecond]
-spec
calc_move_time_interval(StartX,StartY,EndX,EndY,MoveSpeed) -> Interval when
    StartX :: integer,
    StartY :: integer,
    EndX :: integer,
    EndY :: integer,
    MoveSpeed :: integer,
    Interval :: integer.
calc_move_time_interval(StartX,StartY,EndX,EndY,MoveSpeed) ->
    common_tool:ceil((erlang:abs(StartX - EndX) + erlang:abs(StartY - EndY))  / MoveSpeed * 1000) + 200.

%% 根据当前的位置，获取移动的目标点
-spec get_guard_random_pos(Pos) -> TargetPos | undefined when
          Pos :: #p_pos{},
          TargetPos :: #p_map_pos{}.
get_guard_random_pos(Pos) ->
    #p_pos{x=X,y=Y} = Pos,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    Random = common_tool:random(1, 10000),
    MinTile = 1,
    MaxTile = 2,
    if Random > 7500 ->
           DirX = 0 - common_tool:random(MinTile,MaxTile),
           DirY = 0 - common_tool:random(MinTile,MaxTile);
       Random > 5000 ->
           DirX = 0 -common_tool:random(MinTile,MaxTile),
           DirY = common_tool:random(MinTile,MaxTile);
       Random > 2500 ->
           DirX = common_tool:random(MinTile,MaxTile),
           DirY = 0 - common_tool:random(MinTile,MaxTile);
       true ->
           DirX = common_tool:random(MinTile,MaxTile),
           DirY = common_tool:random(MinTile,MaxTile)
    end,
    case mod_map:check_tile_pos(Tx+DirX,Ty+DirY) of
        true ->
            {NewX,NewY}=mod_map_slice:to_pixel_pos(Tx+DirX,Ty+DirY),
            {#p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
             #p_map_pos{x=NewX,y=NewY,tx=Tx+DirX,ty=Ty+DirY}};
        _ ->
            undefined
    end.

%% 根据怪物配置的警戒范围搜索敌方目标
%% 优化级为 距离--->玩家--->宠物--->敌方怪物
%% return undefined | {ActorId,ActorType}
-spec get_attack_target_by_guard_radius(GroupId,Pos,GuardRadius) -> Result when
          GroupId :: integer,
          Pos :: #p_pos{},
          GuardRadius :: integer,
          Result :: undefined | {actor_id,actor_type}.
get_attack_target_by_guard_radius(GroupId,Pos,GuardRadius) ->
    #p_pos{x=X,y=Y} = Pos,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    RoleIdList = mod_map:get_slice_actor_list(Slice9List, ?ACTOR_TYPE_ROLE),
    PetIdList = mod_map:get_slice_actor_list(Slice9List, ?ACTOR_TYPE_PET),
    MonsterIdList = mod_map:get_slice_actor_list(Slice9List, ?ACTOR_TYPE_MONSTER),
    ActorList = [{?ACTOR_TYPE_ROLE,RoleId} || RoleId <- RoleIdList] ++ 
                    [{?ACTOR_TYPE_PET,PetId}|| PetId <- PetIdList] ++ 
                    [{?ACTOR_TYPE_MONSTER,MonsterId} || MonsterId <- MonsterIdList],
    EnemyList = get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,[]),
    SortEnemyList = 
        lists:sort(
          fun({_AActorId,AActorType,ADirX,ADirY},{_BActorId,BActorType,BDirX,BDirY}) ->
                  case ADirX < BDirX of
                      true -> true;
                      _ ->
                          case ADirY < BDirY of
                              true -> true;
                              _ ->
                                  AActorType < BActorType
                          end
                  end
          end, EnemyList),
    case SortEnemyList of
        [] ->
            undefined;
        _ ->
            Len = erlang:length(SortEnemyList),
            {ActorId,ActorType,_DirX,_DirY}=lists:nth(common_tool:random(1, Len),SortEnemyList),
            {ActorId,ActorType}
    end.
get_attack_target_by_guard_radius2([],_GroupId,_Pos,_GuardRadius,EnemyList) ->
    EnemyList;
get_attack_target_by_guard_radius2([{ActorType,ActorId} | ActorList],GroupId,#p_pos{x=X,y=Y}=Pos,GuardRadius,EnemyList) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{group_id=PGroupId,pos=#p_pos{x=PX,y=PY},hp=Hp} -> next;
        #p_map_pet{group_id=PGroupId,pos=#p_pos{x=PX,y=PY},hp=Hp} -> next;
        #p_map_monster{group_id=PGroupId,pos=#p_pos{x=PX,y=PY},hp=Hp} -> next;
        _ -> PGroupId=undefined,PX=0,PY=0,Hp=0
    end,
    case Hp > 0 of
        true ->
            case PGroupId of
                undefined ->
                    get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,EnemyList);
                GroupId ->
                    get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,EnemyList);
                _ ->
                    DirX = erlang:abs(X-PX), DirY = erlang:abs(Y-PY),
                    case DirX < GuardRadius andalso DirY < GuardRadius of
                        true ->
                            get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,
                                                               [{ActorId,ActorType,DirX,DirY}|EnemyList]);
                        _ ->
                            get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,EnemyList)
                    end
            end;
        _ ->
            get_attack_target_by_guard_radius2(ActorList,GroupId,Pos,GuardRadius,EnemyList)
    end.


%%-------------------------------------------------------------------
%%
%% dict function
%%
%%-------------------------------------------------------------------
%% 删除怪物数据，一般用于当发现monster_state数据不存在时，清除相应的数据
del_monster_data(MonsterId) ->
    del_monster_id_from_list(MonsterId),
    mod_map:erase_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER),
    mod_map:erase_map_actor(MonsterId, ?ACTOR_TYPE_MONSTER),
    ok.
%% 怪物下一步动作处理
%% set_next_tick(MonsterId,AddTick,NextAction,NextData) ->
%%     case get_monster_state(MonsterId) of
%%         undefined ->
%%             del_monster_data(MonsterId);
%%         MonsterState ->
%%             set_next_tick(MonsterId,AddTick,NextAction,NextData,MonsterState)
%%     end.
set_next_tick(MonsterId,AddTick,NextAction,NextData,MonsterState) ->
    Now = mgeem_map:get_now2(),
    #r_monster_state{next_tick=LastTick} = MonsterState,
    case Now - LastTick < ?MONSTER_WORK_TICK_MIN  of
        true ->
            NewTick = LastTick + AddTick;
        _ ->
            NewTick = Now + AddTick
    end,
    set_monster_state(MonsterId, MonsterState#r_monster_state{next_tick=NewTick,next_action=NextAction,next_data=NextData}).

%% update_next_tick(MonsterId,NewTick,NextAction,NextData) ->
%%     MonsterState = get_monster_state(MonsterId),
%%     set_monster_state(MonsterId,MonsterState#r_monster_state{next_tick=NewTick,next_action=NextAction,next_data=NextData}).
%% 
update_next_tick(MonsterId,NewTick,NextAction,NextData,MonsterState) ->
    set_monster_state(MonsterId,MonsterState#r_monster_state{next_tick=NewTick,next_action=NextAction,next_data=NextData}).
%% 怪物状态
get_monster_state(MonsterId) ->
    erlang:get({map_monster_state,MonsterId}).
set_monster_state(MonsterId,MonsterState) ->
    erlang:put({map_monster_state,MonsterId}, MonsterState).
erase_monster_state(MonsterId) ->
    erlang:erase({map_monster_state,MonsterId}).

%% 生成本地图怪物id，从1开始
get_max_monster_id() ->
    case get(max_monster_id) of
        undefined ->
            MaxId = 10000;
        Id ->
            MaxId = Id + 1
    end,
    put(max_monster_id,MaxId),
    MaxId.

%% 当前地图的怪物id 列表
init_monster_id_list() ->
    erlang:put(map_monster_id_list,[]).
get_monster_id_list() ->
    erlang:get(map_monster_id_list).
del_monster_id_from_list(MonsterId)->
    erlang:put(map_monster_id_list, lists:delete(MonsterId, get_monster_id_list())).
add_monster_id_to_list(MonsterId)->
    erlang:put(map_monster_id_list, [MonsterId|get_monster_id_list()]).