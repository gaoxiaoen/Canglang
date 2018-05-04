%%%
%%%
%%% @doc
%%%     mod_move
%%% @end
%%% Created : 2010-10-25
%%%-------------------------------------------------------------------
-module(mod_move).

-include("mgeem.hrl").

-export([handle/1,
         do_skill_move/4,
         erase_skill_move/2]).

%% ====================================================================
%% API functions
%% ====================================================================
%%无论玩家使用何种方式走路，每经过一格都必须要发一次消息给服务端
handle({?MOVE,?MOVE_WALK,DataRecord,RoleId,PId,_Line}) -> 
    do_walk(?MOVE, ?MOVE_WALK,DataRecord,RoleId,PId);
handle({?MOVE,?MOVE_WALK_PATH,DataRecord,RoleId,PId,_Line}) ->
    do_walk_path(?MOVE,?MOVE_WALK_PATH,DataRecord,RoleId,PId);
handle({?MOVE,?MOVE_SYNC,DataRecord,RoleId,PId,_Line}) ->
    do_move_sync(?MOVE,?MOVE_SYNC,DataRecord,RoleId,PId);
handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w", [Info]).

do_walk(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_walk2(RoleId,DataRecord#m_move_walk_tos.actor_type,DataRecord) of
        {error,tx_ty_error,MapRoleInfo,OldMapPos} ->
            NewMapRoleInfo=MapRoleInfo#p_map_role{walk_pos=undefined},
            mod_map:set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, NewMapRoleInfo),
            MapActor = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
            mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapActor#r_map_actor{last_walk_path_time=0}),
            #p_map_pos{x=X,y=Y,tx=OldTx,ty=OldTy} = OldMapPos,
            SendSelf = #m_move_sync_toc{move_id=RoleId,pos=#p_pos{x=X,y=Y}},
            
			#r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
			[#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
			RoleIdList = mod_map:get_slice_role_list(Slice9List),
			%%BCRoleIdList = lists:delete(RoleId,RoleIdList),
			mod_map:broadcast(RoleIdList, ?MOVE,?MOVE_SYNC, SendSelf);
        {error,pet_tx_ty_error,MapPetInfo,OldMapPos} ->
            #p_map_pet{pet_id=PetId} = MapPetInfo,
            NewMapPetInfo=MapPetInfo#p_map_pet{walk_pos=undefined},
            mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, NewMapPetInfo),
            #p_map_pos{x=X,y=Y,tx=OldTx,ty=OldTy} = OldMapPos,
            SendSelf = #m_move_sync_toc{move_id=PetId,pos=#p_pos{x=X,y=Y}},
            #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            mod_map:broadcast(RoleIdList, ?MOVE,?MOVE_SYNC, SendSelf);
        {error,map_role_info_error} ->
            mod_map_role:kick_role(RoleId,map_role_info_error);
        {error,role_pos_error} ->
            mod_map_role:kick_role(RoleId,role_pos_error);
        {error,_Reason} ->
            ignore;
        {ok,role,NewMapPos,OldMapPos,MapRoleInfo} ->
            do_walk_role(Module,Method,DataRecord,NewMapPos,OldMapPos,RoleId,PId,MapRoleInfo);
        {ok,pet,MapPetInfo,NewMapPos} ->
            do_walk_pet(Module,Method,DataRecord,RoleId,PId,MapPetInfo,NewMapPos);
        _ ->
            ignore
    end.
do_walk2(RoleId,?ACTOR_TYPE_ROLE,DataRecord) ->
	#r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    #m_move_walk_tos{pos=#p_pos{x=X, y=Y}} = DataRecord,
	case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
		undefined ->
			MapRoleInfo = undefined,
			erlang:throw({error,map_role_info_error});
		MapRoleInfo ->
			next
	end,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    NewMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    
	#p_map_role{pos=#p_pos{x = OldX,y = OldY}} = MapRoleInfo,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
    OldMapPos = #p_map_pos{x=OldX,y=OldY,tx=OldTx,ty=OldTy},
    case get_skill_move(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MaxTile = 5;
        MoveDistance ->
            MaxTile = MoveDistance div ?MAP_TILE_SIZE + 1
    end,
    case erlang:abs(Tx - OldTx) > MaxTile 
        orelse erlang:abs(Ty - OldTy) > MaxTile of
        true ->
            erlang:throw({error,tx_ty_error,MapRoleInfo,OldMapPos});
        _ ->
            next
    end,
    case McmModule:get_slice_name({Tx,Ty}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            next;
        [#r_map_slice{type=?MAP_REF_TYPE_NOT_WALK}] ->
            next;
        _ ->
            erlang:throw({error,tx_ty_error,MapRoleInfo,OldMapPos})
    end,
    case McmModule:get_slice_name({OldTx,OldTy}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            next;
        [#r_map_slice{type=?MAP_REF_TYPE_NOT_WALK}] ->
            next;
        _ ->
            erlang:throw({error,old_tx_ty_error})
    end,
    {ok,role,NewMapPos,OldMapPos,MapRoleInfo};

do_walk2(RoleId,?ACTOR_TYPE_PET,DataRecord) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            erlang:throw({error,map_role_info_error});
        _MapRoleInfo ->
            next
    end,
    #m_move_walk_tos{pos=#p_pos{x=X,y=Y}} = DataRecord,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    NewMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    case mod_map:get_map_role_pet(RoleId) of
        #r_map_role_pet{battle_id=0} ->
            PetId = 0,
            erlang:throw({error,not_found_battle_pet});
        #r_map_role_pet{battle_id=PetId} ->
            next;
        _ ->
            PetId = 0,
            erlang:throw({error,not_found_battle_pet})
    end,
    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            MapPetInfo = undefined,
            erlang:throw({error,not_found_map_pet_info});
        MapPetInfo ->
            next
    end,
    case McmModule:get_slice_name({Tx,Ty}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            next;
        [#r_map_slice{type=?MAP_REF_TYPE_NOT_WALK}] ->
            next;
        _ ->
            #p_map_pet{pos=#p_pos{x=OldX,y=OldY}} = MapPetInfo,
            {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
            OldMapPos = #p_map_pos{x=OldX,y=OldY,tx=OldTx,ty=OldTy},
            erlang:throw({error,pet_tx_ty_error,MapPetInfo,OldMapPos})
    end,
    {ok,pet,MapPetInfo,NewMapPos};
do_walk2(_RoleId,_ActorType,_DataRecord) ->
    erlang:throw({error,unknow_message}).



do_walk_role(_Module,_Method,DataRecord,NewMapPos,OldMapPos,RoleId,_PId,MapRoleInfo) ->
    #p_map_pos{tx=Tx,ty=Ty,x=X,y=Y} = NewMapPos,
    #p_map_pos{tx=OldTx,ty=OldTy}=OldMapPos,
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
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
	%% 玩家位置变化
    case DataRecord#m_move_walk_tos.op_type of
        1 ->
            NewRoleMapInfo = MapRoleInfo#p_map_role{walk_pos=undefined};
        _ ->
            NewRoleMapInfo = MapRoleInfo
    end,
    mod_map:set_role_pos(RoleId,NewRoleMapInfo,OldMapPos,NewMapPos,false,IsChangeSlice),
	case IsChangeSlice of
		true ->
			mod_map_actor:do_change_slice_notify(RoleId, ?ACTOR_TYPE_ROLE, OldSlice9List, NewSlice9List),
			next;
		_ ->
			next
	end,
    %% 走跑完成，角色停止运动
    case DataRecord#m_move_walk_tos.op_type of
        1 ->
            LastWalkPathTime = 0,
            SendSelf = #m_move_sync_toc{move_id=RoleId,pos=#p_pos{x=X,y=Y}},
            RoleIdList = mod_map:get_slice_role_list(NewSlice9List),
            BCRoleIdList = lists:delete(RoleId,RoleIdList),
            mod_map:broadcast(BCRoleIdList, ?MOVE,?MOVE_SYNC, SendSelf);
        _ ->
            LastWalkPathTime = mgeem_map:get_now2(),
            next
    end,
    MapActor = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
    mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapActor#r_map_actor{last_walk_path_time=LastWalkPathTime}),
    ok.
%% 宠物走路
do_walk_pet(_Module,_Method,DataRecord,RoleId,_PId,MapPetInfo,NewMapPos) ->
    #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty} = NewMapPos,
    #p_map_pet{pet_id=PetId,pos=#p_pos{x=OldX,y=OldY}} = MapPetInfo,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX,OldY),
    case DataRecord#m_move_walk_tos.op_type of
        1 ->
            NewMapPetInfo = MapPetInfo#p_map_pet{pos=#p_pos{x=X,y=Y},walk_pos=undefined};
        _ ->
            NewMapPetInfo = MapPetInfo#p_map_pet{pos=#p_pos{x=X,y=Y}}
    end,
    
    mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, NewMapPetInfo),
    mod_map:deref_tile_pos(PetId,?ACTOR_TYPE_PET,OldTx,OldTy),
    mod_map:ref_tile_pos(PetId,?ACTOR_TYPE_PET,Tx,Ty),
    
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    %% Slice 变化处理
    [#r_map_slice{slice_name=NewSliceName,slice_9_list=NewSlice9List}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_name=OldSliceName,slice_9_list=_OldSlice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
    case OldSliceName =:= NewSliceName of
        true ->
            next;
        _ ->
            %% Slice Change
            mod_map:join_slice(NewSliceName, PetId, ?ACTOR_TYPE_PET),
            mod_map:leave_slice(OldSliceName, PetId, ?ACTOR_TYPE_PET),
            next
    end,

    case DataRecord#m_move_walk_tos.op_type of
        1 ->
            SendSelf = #m_move_sync_toc{move_id=RoleId,pos=#p_pos{x=X,y=Y}},
            RoleIdList = mod_map:get_slice_role_list(NewSlice9List),
            BCRoleIdList = lists:delete(RoleId,RoleIdList),
            mod_map:broadcast(BCRoleIdList, ?MOVE,?MOVE_SYNC, SendSelf);
        _ ->
            next
    end,
    ok.
do_walk_path(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_walk_path2(RoleId,DataRecord#m_move_walk_path_tos.actor_type) of
        {error,OpCode,Reason} ->
            do_walk_path_error(Module,Method,DataRecord,RoleId,PId,OpCode,Reason);
        {ok,role,MapRoleInfo,MapPos} ->
            do_walk_path_role(Module,Method,DataRecord,RoleId,PId,MapRoleInfo,MapPos);
        {ok,pet,MapPetInfo,MapPos} ->
            do_walk_path_pet(Module,Method,DataRecord,RoleId,PId,MapPetInfo,MapPos)
    end.
do_walk_path2(RoleId,?ACTOR_TYPE_ROLE) -> %% 人物走路
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
		undefined ->
			MapRoleInfo = undefined,
            erlang:throw({error,?_RC_MOVE_WALK_PATH_002,""});
		MapRoleInfo ->
			next
    end,
    #p_map_role{pos = #p_pos{x = X,y = Y}} = MapRoleInfo,
    {Tx,Ty} =mod_map_slice:to_tile_pos(X, Y),
    case erlang:get({ref,Tx,Ty}) of
        undefined ->
            erlang:throw({error,?_RC_MOVE_WALK_PATH_002,""});
        _ ->
            next
    end,
    MapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    {ok,role,MapRoleInfo,MapPos};
do_walk_path2(RoleId,?ACTOR_TYPE_PET) -> %% 宠物走路
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRoleInfo = undefined,
            erlang:throw({error,?_RC_MOVE_WALK_PATH_002,""});
        MapRoleInfo ->
            next
    end,
    #p_map_role{pos = #p_pos{x = X,y = Y}} = MapRoleInfo,
    {Tx,Ty} =mod_map_slice:to_tile_pos(X, Y),
    case erlang:get({ref,Tx,Ty}) of
        undefined ->
            erlang:throw({error,?_RC_MOVE_WALK_PATH_002,""});
        _ ->
            next
    end,
    MapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    case mod_map:get_map_role_pet(RoleId) of
        #r_map_role_pet{battle_id=0} ->
            PetId = 0,
            erlang:throw({error,?_RC_MOVE_WALK_PATH_003,""});
        #r_map_role_pet{battle_id=PetId} ->
            next;
        _ ->
            PetId = 0,
            erlang:throw({error,?_RC_MOVE_WALK_PATH_003,""})
    end,
    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            MapPetInfo = undefined,
            erlang:throw({error,?_RC_MOVE_WALK_PATH_003,""});
        MapPetInfo ->
            next
    end,
    {ok,pet,MapPetInfo,MapPos};
do_walk_path2(_RoleId,_ActorType) ->
    erlang:throw({error,?_RC_MOVE_WALK_PATH_000,""}).
    
do_walk_path_role(Module,Method,DataRecord,RoleId,_PId,MapRoleInfo,MapPos) ->
	#p_map_pos{tx = Tx,ty = Ty,x=X,y=Y} = MapPos,
    NewMapRoleInfo=MapRoleInfo#p_map_role{walk_pos=#p_pos{x=X,y=Y}},
    mod_map:set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, NewMapRoleInfo),
    MapActor = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
    Now2 = mgeem_map:get_now2(),
    mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapActor#r_map_actor{last_walk_path_time=Now2}),
	SendSelf = #m_move_walk_path_toc{op_code=0,
                                     move_id = RoleId,
									 pos = DataRecord#m_move_walk_path_tos.pos},
	#r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
	[#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
	RoleIdList = mod_map:get_slice_role_list(Slice9List),
	BCRoleIdList = lists:delete(RoleId,RoleIdList),
	mod_map:broadcast(BCRoleIdList, Module, Method, SendSelf),
	ok.
do_walk_path_pet(Module,Method,DataRecord,RoleId,_PId,MapPetInfo,MapPos) ->
    #p_map_pos{tx = Tx,ty = Ty,x=X,y=Y} = MapPos,
    #p_map_pet{pet_id=PetId,pos=#p_pos{x=OldX,y=OldY}} = MapPetInfo,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX,OldY),
    NewMapPetInfo=MapPetInfo#p_map_pet{pos=#p_pos{x=X,y=Y},walk_pos=#p_pos{x=X,y=Y}},
    mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, NewMapPetInfo),
    mod_map:deref_tile_pos(PetId,?ACTOR_TYPE_PET,OldTx,OldTy),
    mod_map:ref_tile_pos(PetId,?ACTOR_TYPE_PET,Tx,Ty),
    
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    %% Slice 变化处理
    [#r_map_slice{slice_name=NewSliceName,slice_9_list=NewSlice9List}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_name=OldSliceName,slice_9_list=_OldSlice9List}] = McmModule:get_slice_name({OldTx,OldTy}),
    case OldSliceName =:= NewSliceName of
        true ->
            next;
        _ ->
            %% Slice Change
            mod_map:join_slice(NewSliceName, PetId, ?ACTOR_TYPE_PET),
            mod_map:leave_slice(OldSliceName, PetId, ?ACTOR_TYPE_PET),
            next
    end,

    SendSelf = #m_move_walk_path_toc{op_code=0,
                                     move_id = PetId,
                                     pos = DataRecord#m_move_walk_path_tos.pos},
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    
    RoleIdList = mod_map:get_slice_role_list(NewSlice9List),
    BCRoleIdList = lists:delete(RoleId,RoleIdList),
    mod_map:broadcast(BCRoleIdList, Module, Method, SendSelf),
    ok.

do_walk_path_error(Module,Method,_DataRecord,_RoleId,PId,OpCode,_Reason) ->
    SendSelf = #m_move_walk_path_toc{op_code = OpCode},
    common_misc:unicast(PId, Module, Method, SendSelf).


%% 同步角色位置
do_move_sync(_Module,_Method,DataRecord,_RoleId,_PId) ->
    #m_move_sync_tos{actor_id=ActorId,actor_type=ActorType} = DataRecord,
    case catch do_move_sync2(ActorId,ActorType,DataRecord) of
        ok ->
            ok;
        _Error ->
            ignroe
    end.
do_move_sync2(MonsterId,?ACTOR_TYPE_MONSTER,DataRecord) ->
    case mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER) of
        undefined ->
            MapMonsterInfo = undefined,
            erlang:throw({error,not_found_monster});
        MapMonsterInfo ->
            next
    end,
    #m_move_sync_tos{pos = #p_pos{x=X,y=Y}} = DataRecord,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    case mod_map:check_tile_pos(Tx, Ty) of
        true ->
            next;
        _ ->
            erlang:throw({error,invalid_pos})
    end,
    case mod_map_monster:get_monster_state(MonsterId) of
        undefined ->
            MonsterState = undefined,
            erlang:throw({error,not_found_monster_state});
        MonsterState ->
            next
    end,
    #r_monster_state{status=MonsterStatus,pos=#p_pos{x=OldX,y=OldY}} = MonsterState,
    case MonsterStatus of
        ?MONSTER_STATUS_PATROL ->
            erlang:throw({error,invalid_monster_state});
        _ ->
            next
    end,
    {OldTx,OldTy} = mod_map_slice:to_tile_pos(OldX, OldY),
    mod_map:set_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER, MapMonsterInfo#p_map_monster{pos=#p_pos{x=X,y=Y}}),
    mod_map_monster:set_monster_state(MonsterId, MonsterState#r_monster_state{pos=#p_pos{x=X,y=Y}}),
    mod_map:deref_tile_pos(MonsterId,?ACTOR_TYPE_MONSTER,OldTx,OldTy),
    mod_map:ref_tile_pos(MonsterId,?ACTOR_TYPE_MONSTER,Tx,Ty),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_name=NewSliceName}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_name=OldSliceName}] = McmModule:get_slice_name({OldTx,OldTy}),
    case OldSliceName =:= NewSliceName of
        true ->
            next;
        _ ->
            mod_map:join_slice(NewSliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
            mod_map:leave_slice(OldSliceName, MonsterId, ?ACTOR_TYPE_MONSTER),
            next
    end,
    ok;
do_move_sync2(_ActorId,_ActorType,_DataRecord) ->
    
    ok.

%% 处理技能位移
do_skill_move(_ActorId,?ACTOR_TYPE_MONSTER,_MoveType,_MoveDistance) ->
    ok;
do_skill_move(RoleId,?ACTOR_TYPE_ROLE,1,MoveDistance) ->
    set_skill_move(RoleId,?ACTOR_TYPE_ROLE,MoveDistance);
do_skill_move(PetId,?ACTOR_TYPE_PET,1,MoveDistance) ->
    set_skill_move(PetId,?ACTOR_TYPE_PET,MoveDistance);
do_skill_move(ActorId,ActorType,_MoveType,_MoveDistance) ->
    erase_skill_move(ActorId,ActorType).

%% 技能位移数据
get_skill_move(ActorId,ActorType) ->
    erlang:get({skill_move,ActorId,ActorType}).
set_skill_move(ActorId,ActorType,MoveDistance) ->
    erlang:put({skill_move,ActorId,ActorType}, MoveDistance).
erase_skill_move(ActorId,ActorType) ->
    erlang:erase({skill_move,ActorId,ActorType}).
