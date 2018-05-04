%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-17
%% Description: 地图角色处理
-module(mod_map_role).

-include("mgeem.hrl").

-export([
         handle/1,
         kick_role/2,
         do_role_offline/3,
         do_map_enter/2,
         get_role_gateway_pid/1,
         auto_recovery_mp/0
        ]).

handle({pre_role_map,Info}) ->
    do_pre_role_map(Info);
handle({pre_role_map,RoleId,Info}) ->
    do_pre_role_map(RoleId,Info);

handle({?MAP,?MAP_ENTER,DataRecord,RoleId,PId,_Line}) ->
    do_role_map_enter(?MAP,?MAP_ENTER,DataRecord,RoleId,PId);

handle({?MAP,?MAP_ENTER_CONFIRM,DataRecord,RoleId,PId,_Line}) ->
    do_role_map_enter_confirm(?MAP,?MAP_ENTER_CONFIRM,DataRecord,RoleId,PId);

handle({?MAP,?MAP_CHANGE_MAP,DataRecord,RoleId,PId,_Line}) ->
    do_role_change_map(?MAP,?MAP_CHANGE_MAP,DataRecord,RoleId,PId);

handle({?ROLE, ?ROLE_RELIVE, DataRecord, RoleId, PId, _Line}) ->
    do_role_relive(?ROLE, ?ROLE_RELIVE, DataRecord, RoleId, PId);

handle({role_first_map_enter,Info}) ->
    do_role_first_map_enter(Info);
handle({map_enter,Info}) ->
    do_map_enter(Info);

handle({role_change_map,Info}) ->
    do_role_change_map(Info);

handle({update_map_role_info,Info}) ->
	do_update_map_role_info(Info);

handle({fight_attr_sync, ActorId, ActorType, FightAttr}) ->
    do_update_fight_attr(ActorId, ActorType, FightAttr);

handle({update_fight_attr,Info}) ->
    do_update_fight_attr(Info);

handle({buff_sync, Info}) ->
    do_buff_sync(Info);
handle({buff_trigger, Info}) ->
    do_buff_trigger(Info);

handle({func, Fun, Args}) ->
    Ret = (catch apply(Fun,Args)),
    ?ERROR_MSG("~w",[Ret]),
    ok;
handle(Info) ->
	?ERROR_MSG("receive unknown message,Info=~w",[Info]).

get_role_gateway_pid(RoleId) ->
    erlang:get({role_id_to_pid,RoleId}).
set_role_gateway_pid(RoleId,RoleGatewayPId) ->
    erlang:put({role_id_to_pid,RoleId}, RoleGatewayPId).
erase_role_gateway_pid(RoleId) ->
    erlang:erase({role_id_to_pid,RoleId}).

%% 玩家下线
do_role_offline(RoleId,RolePId,_Reason)->
    case erlang:erase({pid_to_role_id,RolePId}) of
        undefined ->
            next;
        RoleId ->
            do_role_offline2(RoleId,RolePId)
    end.
do_role_offline2(RoleId,RolePId) ->
    hook_map_role:role_offline(RoleId),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    mod_map:del_in_map_role(RoleId),
    erlang:erase({role_msg_queue,RolePId}),
    erase_role_gateway_pid(RoleId),
    mod_map:erase_role_change_map(RoleId),
    mod_map:erase_change_map_quit(RoleId),
    %% 出战宠物下线处理
    case mod_map:get_map_role_pet(RoleId) of
        undefined ->
            PetId = 0;
        #r_map_role_pet{battle_id=0} ->
            PetId = 0;
        #r_map_role_pet{battle_id=PetId} ->
            next
    end,
    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            next;
        #p_map_pet{pos=#p_pos{x=PetX,y=PetY}} ->
            {PetTx,PetTy} = mod_map_slice:to_tile_pos(PetX,PetY),
            [#r_map_slice{slice_name=PetSliceName}] = McmModule:get_slice_name({PetTx,PetTy}),
            mod_map:leave_slice(PetSliceName, PetId, ?ACTOR_TYPE_PET),
            mod_map:deref_tile_pos(PetId, ?ACTOR_TYPE_PET, PetTx, PetTy),
            mod_map:erase_actor_info(PetId, ?ACTOR_TYPE_PET),
            mod_map:erase_map_actor(PetId, ?ACTOR_TYPE_PET),
            mod_move:erase_skill_move(PetId, ?ACTOR_TYPE_PET)
    end,
    mod_map:erase_map_role_pet(RoleId),
    %% 角色数据下线处理
    mod_move:erase_skill_move(RoleId, ?ACTOR_TYPE_ROLE),
	case mod_map:get_actor_info(RoleId,?ACTOR_TYPE_ROLE) of
        undefined ->
            next;
        #p_map_role{pos = #p_pos{x=X,y=Y}} ->
            {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
             mod_map:deref_tile_pos(RoleId, ?ACTOR_TYPE_ROLE, Tx, Ty),
			 [#r_map_slice{slice_name=SliceName,slice_9_list=OldSlice9List}] = McmModule:get_slice_name({Tx,Ty}),
			 mod_map:leave_slice(SliceName, RoleId, ?ACTOR_TYPE_ROLE),
			 mod_map_actor:do_quit_slice_notify(RoleId, ?ACTOR_TYPE_ROLE, OldSlice9List)
    end,
	mod_map:erase_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    ok.

%% 玩家进入副本地图，即可以发生战斗的地图，每秒需自动恢复相应的魔法值
auto_recovery_mp() ->
    Now = mgeem_map:get_now2(),
    RoleIdList = mod_map:get_in_map_role(),
    case auto_recovery_mp2(RoleIdList,Now,[]) of
        [] ->
            ignore;
        AttrChangeList ->
            lists:foreach(
              fun({RoleId,AttrList}) -> 
                      AttrChangeToc = #m_role_attr_change_toc{op_type=0,attr_list=AttrList},
                      mod_map:broadcast_now([RoleId], ?ROLE, ?ROLE_ATTR_CHANGE, AttrChangeToc)
              end, AttrChangeList)
    end,
    ok.
%% return AttrChangeList=[{RoleId,AttList},...]
auto_recovery_mp2([],_Now,PAttrList) -> 
    PAttrList;
auto_recovery_mp2([RoleId | RoleIdList],Now,AttrChangeList) ->
    case catch auto_recovery_mp3(RoleId,Now) of
        {ok,undefined} ->
            auto_recovery_mp2(RoleIdList,Now,AttrChangeList);
        {ok,RolePAttr} ->
            auto_recovery_mp2(RoleIdList,Now,[{RoleId,[RolePAttr]}|AttrChangeList]);
        {ok,RolePAttr,PetPAttr} ->
            auto_recovery_mp2(RoleIdList,Now,[{RoleId,[RolePAttr,PetPAttr]}|AttrChangeList]);
        _ ->
            auto_recovery_mp2(RoleIdList,Now,AttrChangeList)
    end.
auto_recovery_mp3(RoleId,Now) ->
    case mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRole = undefined,
            erlang:throw({error,not_found_role_map_actor});
        MapRole ->
            next
    end,
    case catch auto_recovery_mp4(RoleId,?ACTOR_TYPE_ROLE,Now,MapRole) of
        {ok,RolePAttr} ->
            next;
        _ ->
            RolePAttr = undefined
    end,
    %% 处理宠物
    case mod_map:get_map_role_pet_id(RoleId) of
        0 ->
            PetId = 0,
            erlang:throw({ok,RolePAttr});
        PetId ->
            next
    end,
    case mod_map:get_map_actor(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            MapPet = undefined,
            erlang:throw({ok,RolePAttr});
        MapPet ->
            next
    end,
    case catch auto_recovery_mp4(PetId,?ACTOR_TYPE_PET,Now,MapPet) of
        {ok,PetPAttr} ->
            erlang:throw({ok,RolePAttr,PetPAttr});
        _ ->
            next
    end,
    {ok,RolePAttr}.
auto_recovery_mp4(ActorId,ActorType,Now,MapActor) ->
    #r_map_actor{add_mp_time=AddMpTime,attr=#p_fight_attr{hp=Hp,max_mp=MaxMp,mp=Mp}=Attr} = MapActor,
    case AddMpTime > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,add_mp_time_zero})
    end,
    Interval = cfg_common:find(auto_recovery_mp_interval) * 1000,
    case Now >= AddMpTime + Interval of
        true ->
            next;
        _ ->
            erlang:throw({error,no_time})
    end,
    case Hp > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,role_dead})
    end,
    case MaxMp == Mp of
        true ->
            mod_map:set_map_actor(ActorId,ActorType, MapActor#r_map_actor{add_mp_time=0}),
            erlang:throw({error,max_mp_eq_cur_mp});
        _ ->
            next
    end,
    AddMp = cfg_common:find(auto_recovery_mp_value),
    CurMp = erlang:min(MaxMp, Mp + AddMp),
    NewAttr = Attr#p_fight_attr{mp=CurMp},
    case MaxMp == CurMp of
        true -> NewAddMpTime = 0;
        _ -> NewAddMpTime = Now
    end,
    mod_map:set_map_actor(ActorId,ActorType, MapActor#r_map_actor{add_mp_time=NewAddMpTime,attr=NewAttr}),
    {ok,#p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MP,int_value=CurMp}}.

%% 地图消息路由预前处理
do_pre_role_map({mod,Module,Info}) ->
    Module:handle(Info).
do_pre_role_map(RoleId,{mod,Module,Info}) ->
    %% 判断当前玩家在地图的状态是否正常
    case get_role_gateway_pid(RoleId) of
        undefined ->
            common_misc:send_to_role_map(RoleId, {mod,Module,Info});
        _ ->
            Module:handle(Info)
    end.
    
%% 第一次进入地图 
do_role_first_map_enter({RoleId,PId,Gateway,MapParam,ClientIP}) ->
    case catch do_role_first_map_enter2(RoleId,MapParam) of
        {error,Reason} -> %% 进入地图出错，踢玩家下线
            ?ERROR_MSG("~ts,RoleId=~w,Error=~w",[?_LANG_MAP_001,RoleId,Reason]),
            PId ! {enter_map_failed,first_enter_map_error},
            kick_role(RoleId, first_enter_map_error);
        {ok,MapRoleInfo,MapPos} ->
            do_role_first_map_enter3(RoleId,PId,Gateway,MapParam,ClientIP,
                                     MapRoleInfo,MapPos)
    end.
do_role_first_map_enter2(_RoleId,MapParam) ->
    #r_map_state{map_id = MapId,mcm_module=McmModule} = mgeem_map:get_map_state(),
    #r_map_param{map_role = MapRoleInfo} = MapParam,
    [#r_map_info{level = MinLevel}] = McmModule:get_map_info(MapId),
    case MapRoleInfo  of
        undefined ->
            erlang:throw({error,map_role_info_not_found});
        _ ->
            next
    end,
    #p_map_role{level = RoleLevel} = MapRoleInfo,
    case RoleLevel >= MinLevel of
        true ->
            next;
        _ ->
            erlang:throw({error,map_min_level})
    end,
    #p_map_role{pos = #p_pos{x = X, y = Y}} = MapRoleInfo,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    case erlang:get({ref,Tx,Ty}) of
        undefined ->
            erlang:throw({error,map_pos_not_valid});
        _ ->
            next
    end,
    MapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    {ok,MapRoleInfo,MapPos}.
do_role_first_map_enter3(RoleId,PId,_Gateway,MapParam,_ClientIP,
                         _MapRoleInfo,MapPos) ->    
    do_map_enter({role,?MAP_ENTER_TYPE_FIRST,RoleId,PId,MapParam,MapPos}),
    #r_map_param{role_pid = RoleWorldPId} = MapParam,
    RoleWorldPId ! {role_online},
    hook_map_role:role_online(RoleId),
    ok.
do_role_map_enter(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_role_map_enter2(RoleId,DataRecord) of
        {error,OpCode,Reason} ->
            do_role_map_enter_error(Module,Method,DataRecord,RoleId,PId,OpCode,Reason);
        {ok,MapRoleInfo,DestMapInfo,DestMapId,DestMapPos,RoleChangeMapInfo} ->
            do_role_map_enter3(Module,Method,DataRecord,RoleId,PId,
                               MapRoleInfo,DestMapInfo,DestMapId,DestMapPos,RoleChangeMapInfo)
    end.
do_role_map_enter2(RoleId,DataRecord) ->
	case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
		undefined ->
			MapRoleInfo = undefined,
			erlang:throw({error,?_RC_MAP_ENTER_000,""});
		MapRoleInfo ->
			next
	end,
	#r_map_state{map_id=CurMapId,mcm_module=McmModule} = mgeem_map:get_map_state(),
	
    #p_map_role{level = RoleLevel,pos=#p_pos{x = X,y = Y}} = MapRoleInfo,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    #m_map_enter_tos{map_id = DestMapId} = DataRecord,
	case McmModule:get_map_jump({CurMapId,Tx,Ty}) of
		[#r_map_res{res_type=?MAP_ELEMENT_JUMP_POINT}] -> %% 站在跳转点
            DestMapName = common_map:get_common_map_name(DestMapId),
            DestMapPId = erlang:whereis(DestMapName),
            ChangeMapType = ?MAP_CHANGE_TYPE_NORMAL,
            [{DestX,DestY}] = cfg_map:get_map_bron_point(DestMapId),
            {DestTx,DestTy} = mod_map_slice:to_tile_pos(DestX,DestY),
            RoleChangeMapInfo = #r_role_change_map{map_id=DestMapId,
                                                   map_process_name=DestMapName,
                                                   map_pid=DestMapPId,
                                                   tx=DestTx,ty=DestTy,
                                                   x=DestX,y=DestY,
                                                   group_id=0,
                                                   change_type = ChangeMapType};
        _ ->
            case mod_map:get_role_change_map(RoleId) of
                undefined ->
                    DestMapId = 0,
                    RoleChangeMapInfo = undefined,
                    erlang:throw({error,?_RC_MAP_ENTER_005,""});
                #r_role_change_map{map_id=DestMapId}=RoleChangeMapInfo ->
                    mod_map:erase_role_change_map(RoleId),
                    next
            end
    end,
    case cfg_map:get_map_info(DestMapId) of
        [#r_map_info{level = DestMinLevel} = DestMapInfo] ->
            next;
        _ ->
            DestMinLevel = 0,DestMapInfo = undefined,
            erlang:throw({error,?_RC_MAP_ENTER_003,""})
    end,
    
    %% 地图条件限制
    case CurMapId =:= DestMapId of
        true ->
            next;
        _ ->
            case RoleLevel >= DestMinLevel of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_MAP_ENTER_001,""})
            end,
            next
    end,
    case DestMapInfo#r_map_info.map_type of
        ?MAP_TYPE_NORMAL ->
            next;
        ?MAP_TYPE_FB ->
            next;
        _ ->
            erlang:throw({error,?_RC_MAP_ENTER_004,""})
    end,
    DestMapPos = #p_map_pos{x=RoleChangeMapInfo#r_role_change_map.x,
                            y=RoleChangeMapInfo#r_role_change_map.y,
                            tx=RoleChangeMapInfo#r_role_change_map.tx,
                            ty=RoleChangeMapInfo#r_role_change_map.ty},
    {ok,MapRoleInfo,DestMapInfo,DestMapId,DestMapPos,RoleChangeMapInfo}.
do_role_map_enter3(Module,Method,DataRecord,RoleId,PId,
                   MapRoleInfo,_DestMapInfo,DestMapId,DestMapPos,RoleChangeMapInfo) ->
    #r_role_change_map{map_process_name=DestMapProcessName,
                       group_id = GroupId,
                       change_type=ChangeMapType} = RoleChangeMapInfo,
    case erlang:whereis(DestMapProcessName) of
        undefined ->
            ?ERROR_MSG(?_LANG_MAP_002, [DestMapId]),
            do_role_map_enter_error(Module,Method,DataRecord,RoleId,PId,?_RC_MAP_ENTER_006,"");
        DestMapPId ->
            ExtInfo = [{change_map_type,ChangeMapType}],
            MapActors = [mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE)],
            case mod_map:get_map_role_pet(RoleId) of
                #r_map_role_pet{battle_id=0} ->
                    MapPetInfo = undefined,
                    NewMapActors = MapActors;
                #r_map_role_pet{battle_id=PetId} ->
                    CurMapPetInfo = mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET),
                    MapPetInfo = CurMapPetInfo#p_map_pet{group_id = GroupId},
                    NewMapActors = [ mod_map:get_map_actor(PetId, ?ACTOR_TYPE_PET)|MapActors];
                _ ->
                    MapPetInfo = undefined,
                    NewMapActors = MapActors
            end,
            #p_map_role{faction_id=FactionId,pos=#p_pos{x=OldX,y=OldY}} = MapRoleInfo,
            NewMapRoleInfo = MapRoleInfo#p_map_role{group_id=GroupId},
            RoleMapParam = #r_map_param{role_id = RoleId,
                                        role_pid = mod_map:get_role_world_pid(RoleId),
                                        faction_id = FactionId,
                                        map_role = NewMapRoleInfo,
                                        map_pet = MapPetInfo,
                                        map_actors= NewMapActors,
                                        ext_info = ExtInfo},
            {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
            %% 退出地图操作
            do_map_quit({RoleId,role,DestMapId,OldTx,OldTy,?MAP_QUIT_TYPE_NORMAL}),
            Param = {map_enter,{role,?MAP_ENTER_TYPE_NORMAL,RoleId,PId,RoleMapParam,DestMapPos}},
            DestMapPId ! {mod,mod_map_role,Param}
    end.

do_role_map_enter_error(Module,Method,_DataRecord,_RoleId,PId,OpCode,Reason) ->
    SendSelf = #m_map_enter_toc{op_code = OpCode,op_reason = Reason},
    ?ERROR_MSG("~ts,SendSelf=~w",[?_LANG_MAP_003,SendSelf]),
    common_misc:unicast(PId, Module, Method, SendSelf).


do_map_enter(RoleId,RoleChangeMapInfo) ->
    #r_role_change_map{map_id=DestMapId,
                       map_pid=DestMapPId,
                       tx=DestTx,ty=DestTy,x=DestX,y=DestY,
                       change_type=ChangeMapType,
                       group_id=GroupId,
                       take_data=TakeData} = RoleChangeMapInfo,
    MapRoleInfo = mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    #p_map_role{faction_id=FactionId,pos=#p_pos{x=OldX,y=OldY}} = MapRoleInfo,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
    case TakeData of
        undefined ->
            ExtInfo = [{change_map_type,ChangeMapType}];
        [] ->
            ExtInfo = [{change_map_type,ChangeMapType}];
        _ ->
            ExtInfo = [{change_map_type,ChangeMapType}|TakeData]
    end,
    EnterFbMaxAnger = cfg_common:find(enter_fb_max_anger),
    case ChangeMapType of
        ?MAP_CHANGE_TYPE_ENTER_FB ->
            MapRoleActorT = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
            #r_map_actor{attr=#p_fight_attr{anger=RoleAnger}=RoleFightAttrT} = MapRoleActorT,
            case RoleAnger > EnterFbMaxAnger of
                true ->
                    RoleFightAttr = RoleFightAttrT#p_fight_attr{anger=EnterFbMaxAnger},
                    MapRoleActor = MapRoleActorT#r_map_actor{attr=RoleFightAttr};
                _ ->
                    MapRoleActor = MapRoleActorT
            end;
        _ ->
            MapRoleActor = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE)
    end,
    case mod_map:get_map_role_pet(RoleId) of
        #r_map_role_pet{battle_id=0} ->
            MapPetInfo = undefined,
            MapActors = [MapRoleActor];
        #r_map_role_pet{battle_id=PetId} ->
            CurMapPetInfo = mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET),
            MapPetInfo = CurMapPetInfo#p_map_pet{group_id=GroupId},
            MapPetActorT = mod_map:get_map_actor(PetId, ?ACTOR_TYPE_PET),
            case ChangeMapType of
                ?MAP_CHANGE_TYPE_ENTER_FB ->
                    #r_map_actor{attr=#p_fight_attr{anger=PetAnger}=PetFightAttrT} = MapPetActorT,
                    case PetAnger > EnterFbMaxAnger of
                        true ->
                            PetFightAttr = PetFightAttrT#p_fight_attr{anger=EnterFbMaxAnger},
                            MapPetActor = MapPetActorT#r_map_actor{attr=PetFightAttr};
                        _ ->
                            MapPetActor = MapPetActorT
                    end;
                _ ->
                    MapPetActor = MapPetActorT
            end,
            MapActors = [MapRoleActor,MapPetActor];
        _ ->
            MapPetInfo = undefined,
            MapActors = [MapRoleActor]
    end,
    NewMapRoleInfo = MapRoleInfo#p_map_role{group_id=GroupId},
    RoleWorldPId = mod_map:get_role_world_pid(RoleId),
    RoleGatewayPId = get_role_gateway_pid(RoleId),
    RoleMapParam = #r_map_param{role_id = RoleId,
                                role_pid = RoleWorldPId,
                                faction_id = FactionId,
                                map_role = NewMapRoleInfo,
                                map_pet = MapPetInfo,
                                map_actors= MapActors,
                                ext_info = ExtInfo},
    DestMapPos = #p_map_pos{x=DestX,y=DestY,tx=DestTx,ty=DestTy},
    %% 退出地图操作
    do_map_quit({RoleId,role,DestMapId,OldTx,OldTy,?MAP_QUIT_TYPE_NORMAL}),
    Param = {map_enter,{role,?MAP_ENTER_TYPE_NORMAL,RoleId,RoleGatewayPId,RoleMapParam,DestMapPos}},
    DestMapPId ! {mod,mod_map_role,Param},
    ok.

%% 进入地图
%% EnterType 进入类型 0切换地图 1第一次进入地图
-spec
do_map_enter({role,EnterType,RoleId,RolePId,MapParam,MapPos}) -> ok when
    EnterType :: ?MAP_ENTER_TYPE_NORMAL | ?MAP_ENTER_TYPE_FIRST,
    RoleId :: integer(),
    RolePId :: pid(),
    MapParam :: #r_map_param{},
    MapPos :: #p_map_pos{}.
do_map_enter({role,_EnterType,RoleId,RolePId,MapParam,MapPos}) ->
    #p_map_pos{tx=Tx,ty=Ty,x=X,y=Y} = MapPos,
    #r_map_state{map_id=MapId,mcm_module=McmModule} = mgeem_map:get_map_state(),
    #r_map_param{role_pid = RoleWorldPId,
                 map_role = MapRoleInfo, 
                 map_pet = MapPetInfo,
                 map_actors = MapActors,
                 ext_info = ExtInfo} = MapParam,
    case lists:keyfind(change_map_type, 1, ExtInfo) of
        false ->
            _ChangeMapType = ?MAP_CHANGE_TYPE_NORMAL;
        {_,_ChangeMapType} ->
            next
    end,
    NewMapRoleInfo = MapRoleInfo#p_map_role{status=?ACTOR_STATUS_ROLE_LOADING_MAP,
                                            skill_state=undefined},
    mod_map:init_role_world_pid(RoleId, RoleWorldPId),
    mod_map:init_actor_info(RoleId, ?ACTOR_TYPE_ROLE, NewMapRoleInfo),
    [ mod_map:init_map_actor(ActorId, ActorType, MapActor)
     || #r_map_actor{actor_id=ActorId,actor_type=ActorType}=MapActor <- MapActors],
    
    %% 自动恢复魔法值
    MapRole = lists:keyfind(?ACTOR_TYPE_ROLE, #r_map_actor.actor_type, MapActors),
    #r_map_actor{attr=#p_fight_attr{max_mp=RoleMaxMp,mp=RoleMp}}=MapRole,
    Now = mgeem_map:get_now2(),
    case RoleMaxMp > RoleMp of
        true -> RoleAddMpTime = Now;
        _ -> RoleAddMpTime = 0
    end,
    mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapRole#r_map_actor{add_mp_time=RoleAddMpTime,
                                                                        last_walk_path_time=0,
                                                                        skill_state=undefined}),
    
    [#r_map_slice{slice_name=SliceName}] = McmModule:get_slice_name({Tx,Ty}),
    case MapPetInfo of
        undefined ->
            next;
        #p_map_pet{pet_id=PetId} ->
            NewMapPetInfo = MapPetInfo#p_map_pet{pos=#p_pos{x=X,y=Y},walk_pos=undefined,
                                                 skill_state=undefined},
            mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, NewMapPetInfo),
            PetMapActor = lists:keyfind(?ACTOR_TYPE_PET, #r_map_actor.actor_type, MapActors),
            #r_map_actor{attr=#p_fight_attr{max_mp=PetMaxMp,mp=PetMp}}=PetMapActor,
            case PetMaxMp > PetMp of
                true -> PetAddMpTime = Now;
                _ -> PetAddMpTime = 0
            end,
            mod_map:set_map_actor(PetId, ?ACTOR_TYPE_PET, PetMapActor#r_map_actor{add_mp_time=PetAddMpTime,
                                                                                  skill_state=undefined}),
            mod_map:set_map_role_pet(RoleId, PetMapActor#r_map_actor.ext),
            mod_map:ref_tile_pos(PetId,?ACTOR_TYPE_PET,Tx,Ty),
            mod_map:join_slice(SliceName, PetId, ?ACTOR_TYPE_PET),
            next
    end,
    
    
    %% 进程字典信息初始化
    mod_map:add_in_map_role(RoleId),
    erlang:put({pid_to_role_id, RolePId}, RoleId),
    set_role_gateway_pid(RoleId, RolePId),
	%% Map Slice操作
    mod_map:set_role_pos(RoleId,NewMapRoleInfo,undefined,MapPos,true,false),
	mod_map:join_slice(SliceName, RoleId, ?ACTOR_TYPE_ROLE),
    %% 返回跳转信息
    LastMapRoleInfo = mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    SendSelf = #m_map_enter_toc{op_code = 0,
                                op_reason = "",
                                pos = LastMapRoleInfo#p_map_role.pos,
                                map_id = MapId
                               },
    common_misc:unicast(RolePId, ?MAP, ?MAP_ENTER, SendSelf),
	RolePId ! {sure_enter_map, erlang:self()},
    hook_map_role:role_map_enter(RoleId,ExtInfo),
    ok;
do_map_enter(Info) ->
    ?ERROR_MSG("~ts,Info=~w",[?_LANG_MAP_004,Info]),
    ok.

%% 确认直接地图，可以接受地图广播消息
do_role_map_enter_confirm(_Module,_Method,_DataRecord,RoleId,PId) ->
    case catch do_role_map_enter_confirm2(RoleId) of
        {ok,MapRoleInfo} ->
            do_role_map_enter_confirm3(RoleId,PId,MapRoleInfo);
        Error ->
            ?ERROR_MSG("role map enter confirm.RoleId=~w,Error=~w",[RoleId,Error])
    end.
do_role_map_enter_confirm2(RoleId) ->
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRoleInfo = undefined,
            erlang:throw({error,not_found_p_map_role});
        MapRoleInfo ->
            next
    end,
    case MapRoleInfo#p_map_role.status of
        ?ACTOR_STATUS_ROLE_LOADING_MAP ->
            next;
        _ ->
            erlang:throw({error,role_status_error})
    end,
    {ok,MapRoleInfo}.
do_role_map_enter_confirm3(RoleId,PId,MapRoleInfo) ->
    #p_map_role{pos=#p_pos{x=X,y=Y}} = MapRoleInfo,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    #r_map_state{map_type=MapType,mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    TileRoleIdList = lists:delete(RoleId,mod_map:get_slice_role_list(Slice9List)),
    MapRoleInfoList = 
        lists:foldl(
          fun(PRoleId,AccMapRoleInfoList) -> 
                  case mod_map:get_actor_info(PRoleId, ?ACTOR_TYPE_ROLE) of
                      undefined ->
                          AccMapRoleInfoList;
                      #p_map_role{status=?ACTOR_STATUS_ROLE_LOADING_MAP} ->
                          AccMapRoleInfoList;
                      PMapRoleInfo ->
                          [PMapRoleInfo|AccMapRoleInfoList]
                  end
          end, [], TileRoleIdList),
    MapPetInfoList = 
        lists:foldl(
          fun(#p_map_role{role_id=PRoleId},AccMapPetInfoList) -> 
                  case mod_map:get_map_role_pet(PRoleId) of
                      #r_map_role_pet{battle_id=0} ->
                          AccMapPetInfoList;
                      #r_map_role_pet{battle_id=PPetId,display_type=DisplayType} ->
                          case mod_map_pet:check_pet_display(MapType, DisplayType) of
                              true ->
                                  case mod_map:get_actor_info(PPetId, ?ACTOR_TYPE_PET) of
                                      undefined ->
                                          AccMapPetInfoList;
                                      PMapPetInfo ->
                                          [PMapPetInfo | AccMapPetInfoList]
                                  end;
                              _ ->
                                  AccMapPetInfoList
                          end;
                      _ ->
                          AccMapPetInfoList
                  end
          end, [], MapRoleInfoList),
    case MapType of
        ?MAP_TYPE_FB ->
            TileMonsterIdList = mod_map:get_slice_actor_list(Slice9List,?ACTOR_TYPE_MONSTER),
            MapMonsterInfoList = 
                lists:foldl(
                  fun(PMonsterId,AccMapMonsterInfoList) -> 
                          case mod_map:get_actor_info(PMonsterId, ?ACTOR_TYPE_MONSTER) of
                              undefined ->
                                  AccMapMonsterInfoList;
                              PMapMonsterInfo ->
                                  [PMapMonsterInfo|AccMapMonsterInfoList]
                          end
                  end, [], TileMonsterIdList);
        _ ->
            MapMonsterInfoList = []
    end,
    case MapType of
        ?MAP_TYPE_NORMAL ->
            EnterAvatarIdList = mod_map:get_slice_actor_list(Slice9List,?ACTOR_TYPE_AVATAR),
            MapAvatarInfoList = 
                lists:foldl(
                   fun(NewAvatarId,AccMapAvatarInfoList) -> 
                           case mod_map:get_actor_info(NewAvatarId, ?ACTOR_TYPE_AVATAR) of
                               undefined ->
                                   AccMapAvatarInfoList;
                               NewMapAvatarInfo ->
                                   [ NewMapAvatarInfo | AccMapAvatarInfoList]
                           end
                   end, [], EnterAvatarIdList);
        _ ->
            MapAvatarInfoList = []
    end,
    
    mod_map:set_actor_info(RoleId,?ACTOR_TYPE_ROLE,MapRoleInfo#p_map_role{status=?ACTOR_STATUS_NORMAL}),
    SendSelf = #m_map_slice_enter_toc{roles=MapRoleInfoList,
                                      pets=MapPetInfoList,
                                      monsters=MapMonsterInfoList,
                                      avatars=MapAvatarInfoList},
    common_misc:unicast(PId, ?MAP, ?MAP_SLICE_ENTER, SendSelf),
    hook_map_role:role_map_enter_confirm(RoleId),
    %% 广播
    mod_map_actor:do_enter_slice_notify(RoleId, ?ACTOR_TYPE_ROLE, Slice9List),
    ok.

%% 切换地图
do_role_change_map(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_role_change_map2(RoleId,DataRecord) of
        {ok,DestMapId,DestMapProcessName,DestMapPId,DestX,DestY} ->
            do_role_change_map3(Module,Method,DataRecord,RoleId,PId,
                                DestMapId,DestMapProcessName,DestMapPId,DestX,DestY);
        {error,OpCode} ->
            do_role_change_map_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_role_change_map2(RoleId,DataRecord) ->
    #r_map_state{map_id=MapId,mcm_module=McmModule} = mgeem_map:get_map_state(),
    #m_map_change_map_tos{map_id=DestMapId} = DataRecord,
    case cfg_map:get_map_info(DestMapId) of
        [#r_map_info{level=MinLevel,mcm_module=DestMcmModule}] ->
            next;
        _ ->
            MinLevel=0,DestMcmModule=undefined,
            erlang:throw({error,?_RC_MAP_CHANGE_MAP_001})
    end,
    DestMapProcessName= common_map:get_common_map_name(DestMapId),
    case erlang:whereis(DestMapProcessName) of
        DestMapPId when erlang:is_pid(DestMapPId) ->
            next;
        _ ->
            DestMapPId = undefined,
            erlang:throw({error,?_RC_MAP_CHANGE_MAP_002})
    end,
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        #p_map_role{level = RoleLevel,pos=RolePos} ->
            next;
        _ ->
            RoleLevel = -1,RolePos = undefined
    end,
    case RoleLevel >= MinLevel of
        true ->
            next;
        _ ->
           erlang:throw({error,?_RC_MAP_CHANGE_MAP_003})
    end,
    case DestMapId of
        MapId -> %% 同地图跳转，即判断当前是不是在此地图的出生点，如果不是即可以处理同地图跳转到出生点
            [{BornX,BornY}] = McmModule:get_map_bron_point(MapId),
            case erlang:abs(BornX - RolePos#p_pos.x) < 400 
                andalso erlang:abs(BornY - RolePos#p_pos.y) < 400 of
                true ->
                    erlang:throw({error,?_RC_MAP_CHANGE_MAP_003});
                _ ->
                    next
            end;
        _ ->
            case DestMcmModule:get_map_bron_point(DestMapId) of
                [{BornX,BornY}] ->
                    next;
                _ ->
                    BornX = 0,BornY = 0,
                    erlang:throw({error,?_RC_MAP_CHANGE_MAP_004})
            end
    end,
    {ok,DestMapId,DestMapProcessName,DestMapPId,BornX,BornY}.
do_role_change_map3(Module,Method,_DataRecord,RoleId,PId,
                    DestMapId,DestMapProcessName,DestMapPId,DestX,DestY) ->
    {DestTx, DestTy} = mod_map_slice:to_tile_pos(DestX,DestY),
    DestMapProcessName= common_map:get_common_map_name(DestMapId),
    RoleChangeMapInfo = #r_role_change_map{role_id=RoleId,
                                           map_id=DestMapId,
                                           map_process_name=DestMapProcessName,
                                           map_pid=DestMapPId,
                                           tx=DestTx,ty=DestTy,x=DestX,y=DestY,
                                           change_type=?MAP_CHANGE_TYPE_NORMAL},
    mod_map:set_role_change_map(RoleId, RoleChangeMapInfo),
    SendSelf = #m_map_change_map_toc{op_code=0,map_id=DestMapId,x=DestX,y=DestY},
    ?DEBUG("do role change map succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.
do_role_change_map_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_map_change_map_toc{op_code=OpCode},
    ?DEBUG("do role change map fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    ok.

%% 跳转地图，前端收到m_map_change_map_toc->发送m_map_enter_tos->跳转地图
do_role_change_map({RoleId,RoleChangeMapInfo}) ->
    #r_role_change_map{map_id=DestMapId,x=DestX,y=DestY} = RoleChangeMapInfo,
    mod_map:set_role_change_map(RoleId, RoleChangeMapInfo),
    SendSelf = #m_map_change_map_toc{op_code=0,map_id=DestMapId,x=DestX,y=DestY},
    common_misc:unicast({role,RoleId}, ?MAP, ?MAP_CHANGE_MAP,SendSelf),
    ok.

do_map_quit({RoleId,role,DestMapId,OldTx,OldTy,QuitMapType}) ->
    hook_map_role:role_map_quit(RoleId),
    mod_map:set_change_map_quit(RoleId, DestMapId),
    case get_role_gateway_pid(RoleId) of
        undefined ->
            ignore;
        RolePId ->
            erlang:erase({role_msg_queue,RolePId}),
            erlang:erase({pid_to_role_id,RolePId})
    end,
    mod_map:del_in_map_role(RoleId),
    erase_role_gateway_pid(RoleId),
    mod_map:erase_role_change_map(RoleId),
    mod_map:erase_change_map_quit(RoleId),
	%% Map Slice操作
	mod_map:deref_tile_pos(RoleId, ?ACTOR_TYPE_ROLE, OldTx, OldTy),
	#r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
	[#r_map_slice{slice_name=SliceName,slice_9_list=OldSlice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
	mod_map:leave_slice(SliceName, RoleId, ?ACTOR_TYPE_ROLE),
	mod_map_actor:do_quit_slice_notify(RoleId, ?ACTOR_TYPE_ROLE, OldSlice9List),
    %% 宠物处理
    case mod_map:get_map_role_pet(RoleId) of
        undefined ->
            PetId = 0;
        #r_map_role_pet{battle_id=0} ->
            PetId = 0;
        #r_map_role_pet{battle_id=PetId} ->
            next
    end,
    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            next;
        #p_map_pet{pos=#p_pos{x=PetX,y=PetY}} ->
            {PetTx,PetTy} = mod_map_slice:to_tile_pos(PetX,PetY),
            [#r_map_slice{slice_name=PetSliceName}] = McmModule:get_slice_name({PetTx,PetTy}),
            mod_map:leave_slice(PetSliceName, PetId, ?ACTOR_TYPE_PET),
            mod_map:deref_tile_pos(PetId, ?ACTOR_TYPE_PET, PetTx, PetTy),
            mod_map:erase_actor_info(PetId, ?ACTOR_TYPE_PET),
            mod_map:erase_map_actor(PetId, ?ACTOR_TYPE_PET),
            mod_move:erase_skill_move(PetId, ?ACTOR_TYPE_PET)
    end,
    mod_map:erase_map_role_pet(RoleId),
    %% 角色处理
    mod_map:erase_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    mod_map:erase_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
    mod_move:erase_skill_move(RoleId, ?ACTOR_TYPE_ROLE),
    mod_map:erase_role_world_pid(RoleId),

    case QuitMapType of
        ?MAP_QUIT_TYPE_ROLE_LOGOUT_GAME -> %%玩家退出游戏处理，暂时不需要
            ignore;
        _ ->
            next
    end,
    ok;
do_map_quit(Info) ->
    ?ERROR_MSG("~ts,Info=~w",[?_LANG_MAP_005,Info]),
    ok.            
        


%% 登录或跳转地图异常，踢掉玩家
kick_role(RoleId,Reason) ->
    RoleProcessName = common_misc:get_role_gateway_process_name(RoleId),
    case erlang:whereis(RoleProcessName) of
        undefined ->
            ignore;
        PId ->
            PId ! {error_exit, Reason}
    end.

%% 玩家国家Id变化处理
%% AttrList = [{#p_map_role.faction_id,NewValue},..]
do_update_map_role_info({RoleId,AttrList}) ->
	case catch do_update_map_role_info2(RoleId) of
		{error,Reason} ->
			?ERROR_MSG("~ts,RoleId=~w,Reason=~w,map_state=~w",[?_LANG_MAP_006,RoleId,Reason,mgeem_map:get_map_state()]);
		{ok,MapRoleInfo} ->
			do_update_map_role_info3(RoleId,AttrList,MapRoleInfo)
	end.
do_update_map_role_info2(RoleId) ->
	case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRoleInfo = undefined,
            erlang:throw({error,not_found_map_role_info});
        MapRoleInfo ->
            next
    end,
	{ok,MapRoleInfo}.
do_update_map_role_info3(RoleId,AttrList,MapRoleInfo) ->
	NewMapRoleInfo = 
		lists:foldl(
		  fun({FieldIndex,NewValue},AccMapRoleInfo) -> 
				  setelement(FieldIndex, AccMapRoleInfo, NewValue)
		  end, MapRoleInfo, AttrList),
    mod_map:set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, NewMapRoleInfo),
	ok.
%% AttrList = [{#p_fight_attr.hp,Value},...]
do_update_fight_attr_final(ActorId,ActorType,AttrList) ->
    case mod_map:get_map_actor(ActorId, ActorType) of
       #r_map_actor{attr = Attr} = MapActor ->
            NewAttr = lists:foldl(fun({Index,NewValue},AccAttr) ->  erlang:setelement(Index, AccAttr, NewValue) end, Attr, AttrList),
            NewMapActor = MapActor#r_map_actor{attr = NewAttr},
            mod_map:set_map_actor(ActorId, ActorType, NewMapActor),
            mod_fight_misc:update_actor_info_attr(ActorId, ActorType, NewAttr),
            TocAttrList = [#p_attr{uid=ActorId,attr_code=Index,int_value=NewValue} || {Index,NewValue} <- AttrList],
            AttrChangeToc = #m_role_attr_change_toc{op_type=0,attr_list=TocAttrList},
            mod_map:broadcast_9slice(delay, ActorId, ActorType, AttrChangeToc);
        _ ->
            ignore
    end.
%% 更新战斗属性
do_update_fight_attr({sync,RoleId,AttrList}) ->
    do_update_fight_attr_final(RoleId,?ACTOR_TYPE_ROLE,AttrList);
do_update_fight_attr({sync_hp_mp,RoleId,RoleHp,RoleMp,RoleAnger}) ->
    AttrList = [{#p_fight_attr.hp,RoleHp},{#p_fight_attr.mp,RoleMp},{#p_fight_attr.anger,RoleAnger}],
    do_update_fight_attr_final(RoleId,?ACTOR_TYPE_ROLE,AttrList);
do_update_fight_attr({sync_hp_mp,RoleId,RoleHp,RoleMp,RoleAnger,PetId,PetHp,PetMp,PetAnger}) ->
    case mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE) of
        MapActor = #r_map_actor{attr = Attr} ->
            NewMapActor = MapActor#r_map_actor{attr = Attr#p_fight_attr{hp=RoleHp,mp=RoleMp,anger=RoleAnger}},
            mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, NewMapActor),
            MapRoleInfo = mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
            mod_map:set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, MapRoleInfo#p_map_role{hp=RoleHp}),
            %% 宠物
            case mod_map:get_map_actor(PetId, ?ACTOR_TYPE_PET) of
                MapPetActor = #r_map_actor{attr = PetAttr} ->
                    NewMapPetActor = MapPetActor#r_map_actor{attr = PetAttr#p_fight_attr{hp=PetHp,mp=PetMp,anger=PetAnger}},
                    mod_map:set_map_actor(PetId, ?ACTOR_TYPE_PET, NewMapPetActor),
                    MapPetInfo = mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET),
                    mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, MapPetInfo#p_map_pet{hp=PetHp}),
                    AttrList = [#p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_HP,int_value=RoleHp},
                                #p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_MP,int_value=RoleMp},
                                #p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_ANGER,int_value=RoleAnger},
                                #p_attr{uid=PetId,attr_code=?FIGHT_ATTR_HP,int_value=PetHp},
                                #p_attr{uid=PetId,attr_code=?FIGHT_ATTR_MP,int_value=PetMp},
                                #p_attr{uid=PetId,attr_code=?FIGHT_ATTR_ANGER,int_value=PetAnger}];
                _ ->
                    AttrList = [#p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_HP,int_value=RoleHp},
                                #p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_MP,int_value=RoleMp},
                                #p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_ANGER,int_value=RoleAnger}]
            end,
            AttrChangeToc = #m_role_attr_change_toc{op_type=0,attr_list=AttrList},
            mod_map:broadcast_9slice(delay, RoleId, ?ACTOR_TYPE_ROLE, AttrChangeToc);
        _ ->
            ignore
    end,
    ok.
do_update_fight_attr(ActorId, ActorType, #p_fight_attr{max_hp=MaxHp,hp=Hp,
                                                       max_mp=MaxMp,mp=Mp,
                                                       max_anger=MaxAnger,anger=Anger} = FightAttr) ->
    case mod_map:get_map_actor(ActorId, ActorType) of
        #r_map_actor{attr=#p_fight_attr{hp=OldHp,mp=OldMp,anger=OldAnger}}=MapActor ->
            CurHp = erlang:min(Hp, OldHp),
            CurMp = erlang:min(Mp, OldMp),
            CurAnger = erlang:min(Anger, OldAnger),
            NewMapActor = MapActor#r_map_actor{attr = FightAttr#p_fight_attr{hp = CurHp,mp = CurMp,anger = CurAnger}},
            mod_map:set_map_actor(ActorId, ActorType, NewMapActor),
            BCAttrList = [#p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MAX_HP,int_value=MaxHp},
                          #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_HP,int_value=CurHp},
                          #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MAX_MP,int_value=MaxMp},
                          #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MP,int_value=CurMp},
                          #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MAX_ANGER,int_value=MaxAnger},
                          #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_ANGER,int_value=CurAnger}],
            BCToc = #m_role_attr_change_toc{op_type=0,attr_list=BCAttrList},
            mod_map:broadcast_9slice(now, ActorId, ActorType, BCToc),
            
            case ActorType of
                ?ACTOR_TYPE_ROLE ->
                    RoleId = ActorId;
                ?ACTOR_TYPE_PET ->
                    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET) of
                        #p_map_pet{role_id=RoleId} -> next;
                        _ -> RoleId = 0
                    end;
                _ ->
                    RoleId = 0
            end,
            case RoleId =/= 0 of
                true ->
                    AttrList = [#p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MAX_MP,int_value=MaxMp},
                                #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MP,int_value=CurMp},
                                #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_MAX_ANGER,int_value=MaxAnger},
                                #p_attr{uid=ActorId,attr_code=?FIGHT_ATTR_ANGER,int_value=CurAnger}],
                    Toc = #m_role_attr_change_toc{op_type=0,attr_list=AttrList},
                    PId = mod_map_role:get_role_gateway_pid(RoleId),
                    common_misc:unicast(PId, ?ROLE, ?ROLE_ATTR_CHANGE, Toc);
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end.

do_buff_sync({ActorId, ActorType, TocBuffIdList, FightBuffList, TocProtos}) ->
    case mod_map:get_actor_info(ActorId, ActorType) of
        #p_map_role{role_id=ActorId}=ActorInfo ->
            mod_map:set_actor_info(ActorId, ActorType, ActorInfo#p_map_role{buffs=TocBuffIdList});
        #p_map_pet{pet_id=ActorId} = ActorInfo ->
            mod_map:set_actor_info(ActorId, ActorType, ActorInfo#p_map_pet{buffs=TocBuffIdList});
        _ ->
            ignore
    end,
    case mod_map:get_map_actor(ActorId, ActorType) of
        undefined ->
            ignore;
        MapActor ->
            mod_map:set_map_actor(ActorId, ActorType, MapActor#r_map_actor{fight_buff=FightBuffList})
    end,
    mod_map:broadcast_9slice(now, ActorId, ActorType, TocProtos),
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
    mod_buff:process_buff_add(ActorId, ActorType, AddBuffIdList),
    mod_buff:process_buff_del(ActorId, ActorType, DelBuffIdList),
    ok.

do_buff_trigger({ActorId, ActorType, TriggerBuffList}) ->
    mod_buff:do_buff_trigger(ActorId, ActorType, TriggerBuffList).
    

-define(role_relive_type_origin,0).      %% 原地复活
-define(role_relive_type_born,1).        %% 出生点复活

do_role_relive(Module,Method,DataRecord,RoleId,PId) ->
    #m_role_relive_tos{type=Type} = DataRecord,
    case catch do_role_relive2(Type,RoleId) of
        {ok,MapRole,NewHp} ->
            do_role_relive3(Type,RoleId,PId,MapRole,NewHp);
        {error,OpCode} ->
            SendSelf = #m_role_relive_toc{op_code = OpCode},
            common_misc:unicast(PId, Module, Method, SendSelf)
    end.
do_role_relive2(Type,RoleId) ->
    case Type of
        ?role_relive_type_origin ->
            next;
        ?role_relive_type_born ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_RELIVE_000})
    end,
    case mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRole = undefined,
            erlang:throw({error,?_RC_ROLE_RELIVE_001});
        MapRole ->
            next
    end,
    #r_map_actor{attr=Attr} = MapRole,
    #p_fight_attr{max_hp=MaxHp,hp=Hp}=Attr,
    case Hp =< 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_ROLE_RELIVE_002})
    end,
    NewHp = erlang:trunc(MaxHp * 0.5),
    NewAttr = Attr#p_fight_attr{hp=NewHp},
    NewMapRole = MapRole#r_map_actor{attr=NewAttr},
    {ok,NewMapRole,NewHp}.
do_role_relive3(?role_relive_type_origin,RoleId,_PId,MapRole,Hp) ->
    mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapRole),
    MapRoleInfo = mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    mod_map:set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, MapRoleInfo#p_map_role{hp=Hp}),
    #r_map_actor{attr=#p_fight_attr{mp=Mp,anger=Anger}}=MapRole,
    common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {role_relive,RoleId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}}}),
    SendSelf = #m_role_relive_toc{op_code= 0,role_id = RoleId,hp=Hp},
    mod_map:broadcast_9slice(now, RoleId, ?ACTOR_TYPE_ROLE, SendSelf);
do_role_relive3(?role_relive_type_born,RoleId,PId,MapRole,Hp) ->
    #r_map_state{map_id=MapId,mcm_module=McmModule} = mgeem_map:get_map_state(),
    [{X,Y}] = cfg_map:get_map_bron_point(MapId),
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapRole),
    MapRoleInfo = mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE),
    #p_map_role{pos=#p_pos{x=OldX,y=OldY}} = MapRoleInfo,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
    
    NewMapRoleInfo = MapRoleInfo#p_map_role{hp=Hp},
    %% 同步玩家进程血量变化
    #r_map_actor{attr=#p_fight_attr{mp=Mp,anger=Anger}}=MapRole,
    common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {role_relive,RoleId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}}}),
    
    %% 地图广播
    %% Slice 变化处理
    [#r_map_slice{slice_name=NewSliceName,slice_9_list=NewSlice9List}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_name=OldSliceName,slice_9_list=OldSlice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
    case OldSliceName =:= NewSliceName of
        true ->
            IsChangeSlice = false,
            next;
        _ ->
            IsChangeSlice = true,
            %% Slice Change
            mod_map:join_slice(NewSliceName, RoleId, ?ACTOR_TYPE_ROLE),
            mod_map:leave_slice(OldSliceName, RoleId, ?ACTOR_TYPE_ROLE),
            next
    end,
    OldMapPos = #p_map_pos{x=OldX,y=OldY,tx=OldTx,ty=OldTy},
    NewMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    mod_map:set_role_pos(RoleId,NewMapRoleInfo,OldMapPos,NewMapPos,false,IsChangeSlice),
    %% 本人复活消息
    SendSelf = #m_role_relive_toc{op_code= 0,role_id = RoleId,hp=Hp},
    common_misc:unicast(PId, ?ROLE, ?ROLE_RELIVE, SendSelf),
    %% 本人同地图切换位置信息
    MoveSyncToc = #m_move_sync_toc{move_id=RoleId,pos=#p_pos{x=X,y=Y}},
    common_misc:unicast(PId, ?MOVE, ?MOVE_SYNC, MoveSyncToc),
    
    %% 重复的slice中广播角色复活
    case IsChangeSlice of
        true ->
            mod_map_actor:do_change_slice_notify(RoleId, ?ACTOR_TYPE_ROLE, OldSlice9List, NewSlice9List);
        _ ->
            next
    end,
    SameSliceList = [ SameSlice9 || SameSlice9 <- OldSlice9List,lists:member(SameSlice9, NewSlice9List) =:= true],
    SameRoleIdList = lists:delete(RoleId, mod_map:get_slice_role_list(SameSliceList)),
    mod_map:broadcast(SameRoleIdList,?ROLE,?ROLE_RELIVE,SendSelf),
    ok.