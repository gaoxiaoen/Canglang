%%%-------------------------------------------------------------------
%%% @author jiangxiaowei
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% BUFF模块
%%% @end
%%% Created : 04. 十一月 2015 13:51
%%%-------------------------------------------------------------------
-module(mod_buff).

-include("mgeew.hrl").

%% API
-export([
         get_valid_buff/3,
         
         init_object_buff/3,
         get_object_buff/2,
         set_object_buff/3,
         erase_object_buff/2,
         
         add_object_buff/5,
         delete_object_buff/3,
         
         get_toc_buff_ids/1,
         get_toc_buff_ids/2,
         
         get_fight_buff/1,
         
         process_buff_add/3,
         process_buff_del/3,
         do_buff_trigger/3]).
-export([loop/2,
         loop_ms/2]).
-export([get_attr/2]).


%% @doc 获取Actor Buff
get_object_buff(ObjectId, ObjectType) ->
    case erlang:get({object_buff, ObjectId, ObjectType}) of
        undefined -> [];
        BuffList ->
            BuffList
    end.

set_object_buff(ObjectId, ObjectType, BuffList) ->
    erlang:put({object_buff, ObjectId, ObjectType}, BuffList).

erase_object_buff(ObjectId, ObjectType) ->
    erlang:erase({object_buff, ObjectId, ObjectType}).

%% @doc 删除BUFF
delete_object_buff(ObjectId, ObjectType, BuffId) ->
    ObjectBuffList = get_object_buff(ObjectId, ObjectType),
    case lists:keyfind(BuffId, #r_buff.buff_id, ObjectBuffList) of
        false -> ignore;
        Buff ->
            NewObjectBuffList = lists:keydelete(BuffId, #r_buff.buff_id, ObjectBuffList),
            set_object_buff(ObjectId, ObjectType, NewObjectBuffList),
            maybe_recalc_attr(ObjectId, ObjectType), %% 重算属性
            notify_del_buff(ObjectId, ObjectType, NewObjectBuffList, [Buff])
    end.

%% 初始化Buff，返回需要添加的BUFF
-spec 
init_object_buff(ObjectId, ObjectType, BuffList) -> NewBuffList when
    ObjectId :: role_id | pet_id | monster_id,
    ObjectType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER,
    BuffList :: [#r_buff{}],
    NewBuffList :: [#r_buff{}] | [].
init_object_buff(_ObjectId, _ObjectType, []) -> 
    [];
init_object_buff(ObjectId, ObjectType, BuffList) -> 
    Now2 = get_buff_now2(ObjectType),
    NewBuffList = get_valid_buff(BuffList,Now2,[]),
    set_object_buff(ObjectId, ObjectType, NewBuffList),
    NewBuffList.

%% 根据时间，获取有效的BUFF列表
get_valid_buff([],_Now2,NewBuffList) ->
    NewBuffList;
get_valid_buff([Buff|BuffList],Now2,NewBuffList) ->
    #r_buff{end_time = EndTime} = Buff,
    case EndTime of
        0 ->
            get_valid_buff(BuffList,Now2,[Buff|NewBuffList]);
        _ ->
            case Now2 >= EndTime of
                true -> %% 此BUFF已经失效
                    get_valid_buff(BuffList,Now2,NewBuffList);
                _ ->
                    get_valid_buff(BuffList,Now2,[Buff|NewBuffList])
            end
    end.

get_buff_now2(ActorType) ->
    case ActorType of
        ?ACTOR_TYPE_ROLE -> mgeew_role:get_now2();
        ?ACTOR_TYPE_PET -> mgeew_role:get_now2();
        ?ACTOR_TYPE_MONSTER -> mgeem_map:get_now2();
        _ ->common_tool:now2()
    end.

%% @doc 添加BUFF
%% 地图BUFF 为 ObjectId ＝ 0， ObjectType ＝ 0 的对象。
%% 玩家/宠物 BUFF字典存储在玩家进程, 接口由玩家进程调用
%% 怪物/地图 BUFF字典存储在地图进程, 接口由地图进程调用
add_object_buff(ObjectId, ObjectType, BuffList, SkillId, SkillLevel) ->
    ObjectBuffList = get_object_buff(ObjectId, ObjectType),
    Now2 = get_buff_now2(ObjectType),
    {NewObjectBuffList, AddBuffList, UpdateBuffList, DelBuffList} = do_add_object_buff(BuffList, ObjectBuffList, Now2, SkillId, SkillLevel),
    ?DEBUG("add buff, NewObjectBuffList=~w,addList:~w UpdateList:~w DelList:~w",[NewObjectBuffList,AddBuffList, UpdateBuffList, DelBuffList]),
    %% 更新内存
    set_object_buff(ObjectId, ObjectType, NewObjectBuffList),
    %% 通知客户端添加BUFF
    notify_add_buff(ObjectId, ObjectType, NewObjectBuffList, AddBuffList, UpdateBuffList, DelBuffList),
    %% 判定是否重算属性
    maybe_recalc_attr(ObjectId, ObjectType).

do_add_object_buff(BuffList, ObjectBuffList, Now2, SkillId, SkillLevel) ->
    do_add_object_buff(BuffList, ObjectBuffList, Now2, SkillId, SkillLevel, [], [], []).
do_add_object_buff([], ObjectBuffList, _Now2, _SkillId, _SkillLevel, AddBuffList, UpdateBuffList, DelBuffList) ->
    {ObjectBuffList, AddBuffList, UpdateBuffList, DelBuffList};
do_add_object_buff([BuffId|T], ObjectBuffList, Now2, SkillId, SkillLevel, AddBuffList, UpdateBuffList, DelBuffList) ->
    case catch do_add(BuffId, ObjectBuffList, Now2, SkillId, SkillLevel) of
        {create, NewObjectBuffList, NewBuff} ->
            do_add_object_buff(T, NewObjectBuffList, Now2, SkillId, SkillLevel, [NewBuff|AddBuffList], UpdateBuffList, DelBuffList);
        {cover, NewObjectBuffList, NewBuff} ->
            do_add_object_buff(T, NewObjectBuffList, Now2, SkillId, SkillLevel, AddBuffList, [NewBuff|UpdateBuffList], DelBuffList);
        {replace, NewObjectBuffList, OldBuff, NewBuff} ->
            do_add_object_buff(T, NewObjectBuffList, Now2, SkillId, SkillLevel, AddBuffList, [NewBuff|UpdateBuffList], [OldBuff|DelBuffList]);
        _Other ->
            ?ERROR_MSG("add buff fail:~w",[_Other]),
            do_add_object_buff(T, ObjectBuffList, Now2, SkillId, SkillLevel, AddBuffList, UpdateBuffList, DelBuffList)
    end.

%% 添加单个BUFF
%% BUFF覆盖逻辑
%% 相同的buff_id需要判断level，高的覆盖，如果level相同，即需要判断skill_level，高的覆盖
%% 相同的group_id需要判断level，高的覆盖，如果level相同，即需要判断skill_level，高的覆盖
do_add(BuffId, ObjectBuffList, Now2, SkillId, SkillLevel) ->
    [#r_buff_info{level=Level}=BuffCfg] = cfg_buff:find(BuffId),
    case lists:keyfind(BuffId, #r_buff.buff_id, ObjectBuffList) of
        false ->
            do_add2(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel);
        #r_buff{level=OldLevel,skill_level=OldSkillLevel}=OldBuff ->
            if Level > OldLevel ->
                   do_add_cover(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel, OldBuff);
               Level == OldLevel andalso SkillLevel >= OldSkillLevel  ->
                   do_add_cover(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel, OldBuff);
               true -> %% 不需要覆盖操作
                    {error,not_cover}
            end
    end.

do_add2(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel) ->
    #r_buff_info{group_id=GroupId,level=Level} = BuffCfg,
    case lists:keyfind(GroupId, #r_buff.group_id, ObjectBuffList) of
        false ->
            do_add_new(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel);
        #r_buff{level=OldLevel,skill_level=OldSkillLevel}=SameGroupBuff ->
            if Level > OldLevel -> 
                   do_add_replace(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel, SameGroupBuff);
               Level == OldLevel andalso SkillLevel > OldSkillLevel  ->
                   do_add_replace(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel, SameGroupBuff);
               true ->
                   {error,replace}
            end
    end.

%% @doc 添加新BUFF
do_add_new(#r_buff_info{buff_id = BuffId, type = Type, group_id = GroupId, level = BuffLevel, toc = Toc,
                        keep_type = KeepType,keep_interval = Interval,duration = Duration}, 
           ObjectBuffList, Now2, SkillId, SkillLevel) ->
    StartTime = Now2,
    case KeepType of
        ?BUFF_KEEP_TYPE_REAL_TIME ->
            EndTime = StartTime + Duration,
            case Interval =/= 0 of
                true -> NextTime = StartTime + Interval;
                _ -> NextTime = 0
            end;
        ?BUFF_KEEP_TYPE_FOREVER_TIME ->
            EndTime = 0,
            NextTime = 0;
        _ ->
            EndTime = StartTime + Duration,
            NextTime = 0
    end,
    NewBuff = #r_buff{buff_id = BuffId, type = Type, group_id = GroupId, level = BuffLevel, toc = Toc, 
                      skill_id=SkillId, skill_level=SkillLevel,
                      start_time=StartTime,end_time = EndTime,
                      remain_life = Duration,
                      next_time = NextTime,trigger_times = 0},
    {create, [NewBuff|ObjectBuffList], NewBuff}.

%% @doc BUFF替换
do_add_replace(BuffCfg, ObjectBuffList, Now2, SkillId, SkillLevel, SameGroupBuff) ->
    NewObjectBuffList = lists:keydelete(SameGroupBuff#r_buff.buff_id, #r_buff.buff_id, ObjectBuffList),
    {create, NewObjectBuffList1, NewBuff} = do_add_new(BuffCfg, NewObjectBuffList, Now2, SkillId, SkillLevel),
    {replace, NewObjectBuffList1, NewBuff, SameGroupBuff}.

%% @doc BUFF覆盖
do_add_cover(#r_buff_info{buff_id = BuffId,
                          keep_type=KeepType,keep_interval=Interval,
                          overlap=Overlap,
                          duration = Duration}, ObjectBuffList, Now2, SkillId, SkillLevel, OldBuff) ->
    #r_buff{start_time=OldStatTime,
            end_time=OldEndTime,
            remain_life=OldRemainLife,
            next_time=OldNextTime,
            trigger_times = OldTriggerTimes} = OldBuff,
    case Overlap of
        1 ->
            StartTime = OldStatTime,EndTime = OldEndTime,
            RemainLife = OldRemainLife + Duration,
            NextTime = OldNextTime, TriggerTimes = OldTriggerTimes;
        0 ->
            StartTime = Now2,
            case KeepType of
                ?BUFF_KEEP_TYPE_REAL_TIME ->
                    EndTime = StartTime + Duration,
                    case Interval =/= 0 of
                        true -> NextTime = StartTime + Interval;
                        _ -> NextTime = 0
                    end;
                ?BUFF_KEEP_TYPE_FOREVER_TIME ->
                    EndTime = 0,
                    NextTime = 0;
                _ ->
                    EndTime = StartTime + Duration,
                    NextTime = 0
            end,
            RemainLife = Duration,
            TriggerTimes = 0
    end,
    NewBuff = OldBuff#r_buff{start_time=StartTime,end_time = EndTime,
                             remain_life = RemainLife,
                             next_time = NextTime,trigger_times = TriggerTimes,
                             skill_id=SkillId, skill_level=SkillLevel},
    NewObjectBuffList = lists:keyreplace(BuffId, #r_buff.buff_id, ObjectBuffList, NewBuff),
    {cover, NewObjectBuffList, NewBuff}.

loop_ms(ActorId,ActorType) ->
    Now2 = get_buff_now2(ActorType),
    AddInterval = 200,
    do_loop(ActorId, ActorType, Now2, AddInterval),
    ok.

%% @doc BUFF循环
loop(ActorId, ActorType) ->
    Now2 = get_buff_now2(ActorType),
    AddInterval = 1000,
    do_loop(ActorId, ActorType, Now2, AddInterval).

do_loop(ActorId, ActorType, Now2, AddInterval) ->
    ObjectBuffList = get_object_buff(ActorId, ActorType),
    {NewObjectBuffList, DelBuffList, TriggerBuffList} = do_loop2(ObjectBuffList,Now2,AddInterval,[],[],[]),
    set_object_buff(ActorId, ActorType, NewObjectBuffList),
    case DelBuffList == [] of
        true -> ignore;
        false ->
            maybe_recalc_attr(ActorId, ActorType),
            notify_del_buff(ActorId, ActorType, NewObjectBuffList, DelBuffList)
    end,
    process_buff_trigger(ActorId, ActorType,TriggerBuffList),
    ok.

do_loop2([], _Now2, _AddInterval, NewBuffList, DelBuffList, TriggerBuffList) -> 
    {NewBuffList, DelBuffList, TriggerBuffList};
do_loop2([#r_buff{remain_life = RemainLife} = Buff|T], Now2, AddInterval, NewBuffList, DelBuffList, TriggerBuffList) when RemainLife =< 0 ->
    do_loop2(T, Now2, AddInterval, NewBuffList, [Buff|DelBuffList], TriggerBuffList);
do_loop2([Buff|T], Now2, AddInterval, NewBuffList, DelBuffList, TriggerBuffList) ->
    #r_buff{buff_id = BuffId,
                  remain_life = Life,
                  next_time = NextTime,
                  trigger_times = TriggerTimes} = Buff,
    [#r_buff_info{keep_interval=KeepInterval}] = cfg_buff:find(BuffId),
    case KeepInterval > 0 of
        true -> 
            case Now2 >= NextTime of
                true ->
                    NewNextTime = Now2 + KeepInterval,
                    NewBuff = Buff#r_buff{remain_life = Life - 1,next_time = NewNextTime,trigger_times = TriggerTimes + 1},
                    do_loop2(T,Now2, AddInterval, [NewBuff|NewBuffList],DelBuffList,[NewBuff|TriggerBuffList]);
                _ ->
                    do_loop2(T, Now2, AddInterval, [Buff#r_buff{remain_life = Life - AddInterval}|NewBuffList], DelBuffList,TriggerBuffList)
            end;
        _ ->
            do_loop2(T, Now2, AddInterval, [Buff#r_buff{remain_life = Life - AddInterval}|NewBuffList], DelBuffList,TriggerBuffList)
    end.


%% @doc 通知Buff 添加
notify_add_buff(ObjectId, ObjectType, ObjectBuffList, AddBuffList, UpdateBuffList, DelBuffList) ->
    {TocBuffIdList,FightBuffList} = get_sync_map_buff(ObjectBuffList),
    TocProtos =
    case get_toc_buffs(AddBuffList) of
        [] -> [];
        TocAddBuffList ->
            [#m_buff_add_toc{object_id = ObjectId, object_type = ObjectType, buffs = TocAddBuffList}]
    end,
    TocProtos1 =
    case get_toc_buffs(UpdateBuffList) of
        [] -> TocProtos;
        TocUpdateBuffLit ->
            [#m_buff_update_toc{object_id = ObjectId, object_type = ObjectType, buffs = TocUpdateBuffLit}|TocProtos]
    end,
    TocProtos2 =
    case get_toc_buff_ids(DelBuffList) of
        [] -> TocProtos1;
        TocDelBuffList ->
            [#m_buff_del_toc{object_id = ObjectId, object_type = ObjectType, buff_ids = TocDelBuffList}|TocProtos1]
    end,
    do_notify_buff_change(ObjectId, ObjectType, TocBuffIdList,FightBuffList, TocProtos2).

%% @doc 通知BUFF 删除
notify_del_buff(ObjectId, ObjectType, ObjectBuffList, DelBuffList) ->
    {TocBuffIdList,FightBuffList} = get_sync_map_buff(ObjectBuffList),
    TocProtos =
        case get_toc_buff_ids(DelBuffList) of
            [] -> [];
            TocDelBuffList ->
                [#m_buff_del_toc{object_id=ObjectId,object_type=ObjectType,buff_ids = TocDelBuffList}]
        end,
    do_notify_buff_change(ObjectId, ObjectType, TocBuffIdList,FightBuffList, TocProtos).

do_notify_buff_change(_ObjectId, _ObjectType, _TocBuffIdList,_FightBuffList, []) -> ignore;
do_notify_buff_change(ObjectId, ?ACTOR_TYPE_ROLE, TocBuffIdList, FightBuffList, TocProtos) ->
    common_misc:send_to_role_map(ObjectId, {mod, mod_map_role, {buff_sync, {ObjectId, ?ACTOR_TYPE_ROLE, TocBuffIdList, FightBuffList, TocProtos}}});
do_notify_buff_change(ObjectId, ?ACTOR_TYPE_PET, TocBuffIdList, FightBuffList, TocProtos) ->
    {ok,#r_role_world_state{role_id=RoleId}} = mgeew_role:get_role_world_state(),
    common_misc:send_to_role_map(RoleId, {mod, mod_map_role, {buff_sync, {ObjectId, ?ACTOR_TYPE_PET, TocBuffIdList, FightBuffList, TocProtos}}});
do_notify_buff_change(ObjectId, ?ACTOR_TYPE_MONSTER, TocBuffIdList, FightBuffList, TocProtos) ->
    case mod_map:get_actor_info(ObjectId, ?ACTOR_TYPE_MONSTER) of
        undefined -> ignroe;
        ActorInfo ->
            mod_map:set_actor_info(ObjectId, ?ACTOR_TYPE_MONSTER, ActorInfo#p_map_monster{buffs=TocBuffIdList}),
            MapActor = mod_map:get_map_actor(ObjectId, ?ACTOR_TYPE_MONSTER),
            mod_map:set_map_actor(ObjectId, ?ACTOR_TYPE_MONSTER, MapActor#r_map_actor{fight_buff=FightBuffList}),
            mod_map:broadcast_9slice(now, ObjectId, ?ACTOR_TYPE_MONSTER, TocProtos),
            {AddBuffIdList,DelBuffIdList} = 
                lists:foldl(
                  fun(BuffToc,{AccAddBuffIdList,AccDelBuffIdList}) ->
                          case BuffToc of
                              #m_buff_add_toc{buffs=BuffList} ->
                                  BuffIdList = [ BuffId || #p_actor_buff{buff_id = BuffId} <- BuffList],
                                  {BuffIdList ++ AccAddBuffIdList, AccDelBuffIdList};
                              #m_buff_del_toc{buff_ids=BuffIdList} ->
                                  {AccAddBuffIdList, BuffIdList ++ AccDelBuffIdList};
                              _ ->
                                  {AccAddBuffIdList,AccDelBuffIdList}
                          end
                  end,{[],[]},TocProtos),
            process_buff_add(ObjectId, ?ACTOR_TYPE_MONSTER, AddBuffIdList),
            process_buff_del(ObjectId, ?ACTOR_TYPE_MONSTER, DelBuffIdList),
            ok
    end.

%% 获取需要通知客户端BUFF
%% #r_buff.toc == 1
-spec 
get_toc_buffs(ObjectBuffList) -> TocBuffList when
    ObjectBuffList :: [#r_buff{}],
    TocBuffList :: [] | [#p_actor_buff{}].
get_toc_buffs(ObjectBuffList) ->
    get_toc_buffs2(ObjectBuffList,[]).
get_toc_buffs2([],TocBuffList) ->
    TocBuffList;
get_toc_buffs2([ #r_buff{buff_id = BuffId, remain_life = RLife, toc = 1} | ObjectBuffList],TocBuffList) ->
    get_toc_buffs2(ObjectBuffList,[#p_actor_buff{buff_id = BuffId, remain_life = RLife} | TocBuffList]);
get_toc_buffs2([ _Buff | ObjectBuffList],TocBuffList) ->
    get_toc_buffs2(ObjectBuffList,TocBuffList).

%% 获取角色通知客户端BuffIdList
get_toc_buff_ids(RoleId,?ACTOR_TYPE_ROLE) ->
    BuffList = get_object_buff(RoleId,?ACTOR_TYPE_ROLE),
    get_toc_buff_ids(BuffList);
get_toc_buff_ids(PetId,?ACTOR_TYPE_PET) ->
    BuffList = get_object_buff(PetId,?ACTOR_TYPE_PET),
    get_toc_buff_ids(BuffList);
get_toc_buff_ids(MonsterId,?ACTOR_TYPE_MONSTER) ->
    BuffList = get_object_buff(MonsterId,?ACTOR_TYPE_MONSTER),
    get_toc_buff_ids(BuffList);
get_toc_buff_ids(_ActorId,_ActorType) ->
    [].
%% 获取需要通知前端的BuffId列表
%% #r_buff.toc == 1
-spec
get_toc_buff_ids(ObjectBuffList) -> TocBuffIdList when
    ObjectBuffList :: [#r_buff{}],
    TocBuffIdList :: [integer()].
get_toc_buff_ids(ObjectBuffList) ->
    get_toc_buff_ids2(ObjectBuffList,[]).
get_toc_buff_ids2([],TocBuffIdList) ->
    TocBuffIdList;
get_toc_buff_ids2([#r_buff{buff_id = BuffId, toc = 1} | ObjectBuffList],TocBuffIdList) ->
    get_toc_buff_ids2(ObjectBuffList,[BuffId|TocBuffIdList]);
get_toc_buff_ids2([_Buff | ObjectBuffList],TocBuffIdList) ->
    get_toc_buff_ids2(ObjectBuffList,TocBuffIdList).

%% 获取战斗计算需要的相关buff列表
%% 战斗计算buff列表的定义为，#r_buff.type类型为
%%    BUFF_EFFECT_REDUCE_HURT
%%    BUFF_EFFECT_UNRIVALLED
-spec
get_fight_buff(ObjectBuffList) -> FightBuffList when
    ObjectBuffList :: [#r_buff{}],
    FightBuffList :: [] | [#r_buff{}].
get_fight_buff(ObjectBuffList) ->
    get_fight_buff2(ObjectBuffList,[]).

get_fight_buff2([],FightBuffList) ->
    FightBuffList;
get_fight_buff2([ #r_buff{type=?BUFF_EFFECT_REDUCE_HURT} = Buff | ObjectBuffList],FightBuffList) ->
    get_fight_buff2(ObjectBuffList,[Buff | FightBuffList]);
get_fight_buff2([ #r_buff{type=?BUFF_EFFECT_UNRIVALLED} = Buff | ObjectBuffList],FightBuffList) ->
    get_fight_buff2(ObjectBuffList,[Buff | FightBuffList]);
get_fight_buff2([ #r_buff{type=?BUFF_EFFECT_VIRTUAL} = Buff | ObjectBuffList],FightBuffList) ->
    get_fight_buff2(ObjectBuffList,[Buff | FightBuffList]);
get_fight_buff2([ _Buff | ObjectBuffList],FightBuffList) ->
    get_fight_buff2(ObjectBuffList,FightBuffList).

%% 获取需要同步到地图进程的Buff数据
-spec 
get_sync_map_buff(ObjectBuffList) -> {TocBuffIdList,FightBuffList} when
    ObjectBuffList :: [#r_buff{}],
    TocBuffIdList ::  [] | [integer()],
    FightBuffList :: [] | [#r_buff{}].
get_sync_map_buff(ObjectBuffList) ->
    get_sync_map_buff2(ObjectBuffList,[],[]).
get_sync_map_buff2([],TocBuffIdList,FightBuffList) ->
    {TocBuffIdList,FightBuffList};
get_sync_map_buff2([#r_buff{buff_id=BuffId,
                            type=Type,
                            toc=Toc} = Buff | ObjectBuffList],TocBuffIdList,FightBuffList) ->
    case Type == ?BUFF_EFFECT_REDUCE_HURT
         orelse Type == ?BUFF_EFFECT_UNRIVALLED
         orelse Type == ?BUFF_EFFECT_VIRTUAL of
        true ->
            NewFightBuffList = [Buff | FightBuffList];
        _ ->
            NewFightBuffList = FightBuffList
    end,
    case Toc == 1 of
        true ->
            NewTocBuffIdList = [BuffId | TocBuffIdList];
        _ ->
            NewTocBuffIdList = TocBuffIdList
    end,
    get_sync_map_buff2(ObjectBuffList,NewTocBuffIdList,NewFightBuffList).

maybe_recalc_attr(_, ?ACTOR_TYPE_MAP) -> ignore;
maybe_recalc_attr(ActorId, ActorType) ->
    mod_attr:generate_fight_attr(ActorId, ActorType, true).

%% 获取BUFF模块属性加成
get_attr(ActorId, ActorType) ->
    ObjectBuffList = get_object_buff(ActorId, ActorType),
    BuffKvList =
        lists:foldl(
        fun(Buff, AccIn) ->
            [AccIn|mod_buff_effect:get_buff_attr(Buff)]
        end, [], ObjectBuffList),
    mod_attr:kvlist_to_attr(lists:flatten(BuffKvList)).

%% 触发BUFF效果
%% TriggerBuffList [#r_buff{},..]
process_buff_trigger(_ActorId, _ActorType, []) ->
    ok;
process_buff_trigger(RoleId, ?ACTOR_TYPE_ROLE, TriggerBuffList) ->
    common_misc:send_to_role_map(RoleId, {mod, mod_map_role, {buff_trigger, {RoleId, ?ACTOR_TYPE_ROLE, TriggerBuffList}}}),
    ok;
process_buff_trigger(PetId, ?ACTOR_TYPE_PET, TriggerBuffList) ->
    {ok,#r_role_world_state{role_id=RoleId}} = mgeew_role:get_role_world_state(),
    common_misc:send_to_role_map(RoleId, {mod, mod_map_role, {buff_trigger, {PetId, ?ACTOR_TYPE_PET, TriggerBuffList}}}),
    ok;
process_buff_trigger(MonsterId, ?ACTOR_TYPE_MONSTER, TriggerBuffList) ->
    do_buff_trigger(MonsterId,?ACTOR_TYPE_MONSTER,TriggerBuffList),
    ok;
process_buff_trigger(_ActorId, _ActorType, _TriggerBuffList) ->
    ignore.

%% 此函必须在地图进程执行
do_buff_trigger(ActorId,ActorType,TriggerBuffList) ->
    AttackResultBuffList = do_buff_trigger2(TriggerBuffList,ActorId,ActorType,[]),
    case AttackResultBuffList of
        [] ->
            ignore;
        _ ->
            case mod_map:get_actor_info(ActorId, ActorType) of
                #p_map_role{hp=CurHp} -> next;
                #p_map_pet{hp=CurHp} -> next;
                #p_map_monster{hp=CurHp} -> next;
                _ -> CurHp = undefined
            end,
            case CurHp of
                undefined ->
                    ignore;
                _ ->
                    FightBuffToc = #m_fight_buff_toc{actor_id=ActorId,
                                                     actor_type=ActorType,
                                                     cur_hp=CurHp,
                                                     result_buff=AttackResultBuffList},
                    mod_map:broadcast_9slice(delay,ActorId,ActorType,FightBuffToc),
                    ok
            end
    end.

do_buff_trigger2([],_ActorId,_ActorType,AttackResultList) ->
    AttackResultList;
do_buff_trigger2([TriggerBuff|TriggerBuffList],ActorId,ActorType,AttackResultList) ->
    case mod_buff_effect:trigger(ActorId,ActorType,TriggerBuff) of
        undefined ->
            do_buff_trigger2(TriggerBuffList,ActorId,ActorType,AttackResultList);
        AttackResult ->
            do_buff_trigger2(TriggerBuffList,ActorId,ActorType,[AttackResult|AttackResultList])
    end.

%% 处理BUFF新增效果
process_buff_add(_ObjectId, _ObjectType, []) ->
    [];
process_buff_add(ObjectId, ObjectType, AddBuffIdList) ->
    [mod_buff_effect:add(ObjectId, ObjectType, BuffId) || BuffId <- AddBuffIdList].

%% 处理BUFF移除效果
process_buff_del(_ObjectId, _ObjectType, []) ->
    ok;
process_buff_del(ObjectId, ObjectType, DelBuffIdList) ->
    [mod_buff_effect:del(ObjectId, ObjectType, BuffId) || BuffId <- DelBuffIdList].