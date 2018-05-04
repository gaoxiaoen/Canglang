%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-17
%% Description: 地图场景对象处理


-module(mod_map_actor).

-include("mgeem.hrl").

-export([
		 do_enter_slice_notify/3,
		 do_quit_slice_notify/3,
		 do_change_slice_notify/4,
         
         do_dead_slice_notify/2,
		 do_dead_slice_notify/3,
         
         handle/1
         ]).

handle({?MAP,?MAP_UPDATE_MAPINFO,DataRecord,RoleId,PId,_Line}) ->
    do_update_actor_map_info(?MAP,?MAP_UPDATE_MAPINFO,DataRecord,RoleId,PId);

handle({?MAP,?MAP_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_map_query(?MAP,?MAP_QUERY,DataRecord,RoleId,PId);

handle(Info) ->
	?ERROR_MSG("receive unknown message,Info=~w",[Info]).


do_update_actor_map_info(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_update_actor_map_info2(RoleId, DataRecord) of
        {error,_Reason} ->
            ignore;
        {ok,SendSelf} ->
            common_misc:unicast(PId, Module, Method, SendSelf)
    end.
do_update_actor_map_info2(_RoleId, DataRecord) ->
    #m_map_update_mapinfo_tos{actor_id= ActorId,actor_type= ActorType} = DataRecord,
    case ActorType of
        ?ACTOR_TYPE_ROLE ->
            case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_ROLE) of
                undefined ->
                    erlang:throw({error,not_found_map_role_info});
                MapRoleInfo ->
                    SendSelf = #m_map_update_mapinfo_toc{
                                                         actor_id=ActorId,
                                                         actor_type=ActorType,
                                                         role_info=MapRoleInfo
                                                        },
                    erlang:throw({ok,SendSelf})
            end;
        _ ->
            erlang:throw({error,actor_type_valid})
    end,
    {error,ignore}.

-define(map_query_op_type_slice,1).           %% 1当前slice
-define(map_query_op_type_slice_9,2).         %% 2当前9 slice

%% 地图元素查询
do_map_query(Module,Method,DataRecord,RoleId,PId) ->
	case catch do_map_query2(RoleId,DataRecord) of
		{error,OpCode} ->
			do_map_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
		{ok,MapRoleInfoList,MapPetInfoList,MapMonsterInfoList} ->
			do_map_query3(Module,Method,DataRecord,RoleId,PId,
                          MapRoleInfoList,MapPetInfoList,MapMonsterInfoList)
	end.
do_map_query2(RoleId,DataRecord) ->
	#m_map_query_tos{op_type=OpType,actor_type=ActorType}=DataRecord,
	case OpType of
		?map_query_op_type_slice ->
			next;
		?map_query_op_type_slice_9 ->
			next;
		_ ->
			erlang:throw({error,?_RC_MAP_QUERY_001})
	end,
	case ActorType of
		0 ->
			next;
		?ACTOR_TYPE_ROLE ->
			next;
        ?ACTOR_TYPE_MONSTER ->
            next;
		_ ->
			erlang:throw({error,?_RC_MAP_QUERY_001})
	end,
	case mod_map:get_actor_info(RoleId,?ACTOR_TYPE_ROLE) of
		undefined ->
			X = 0,Y=0,
			erlang:throw({error,?_RC_MAP_QUERY_002});
		#p_map_role{pos=#p_pos{x=X,y=Y}} ->
			next
	end,
    {Tx,Ty}=mod_map_slice:to_tile_pos(X, Y),
	#r_map_state{map_type=MapType,mcm_module=McmModule}=mgeem_map:get_map_state(),
	[#r_map_slice{slice_name=SliceName,slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    case OpType of
        ?map_query_op_type_slice ->
            SliceList = [SliceName];
        ?map_query_op_type_slice_9 ->
            SliceList = Slice9List;
        _ ->
            SliceList = []
    end,
	case ActorType of
		0 ->
			{MapRoleInfoList,MapPetInfoList}=get_map_role_by_slice(SliceList,MapType),
            MapMonsterInfoList = get_map_monster_by_slice(SliceList,MapType),
			next;
		?ACTOR_TYPE_ROLE ->
			{MapRoleInfoList,MapPetInfoList}=get_map_role_by_slice(SliceList,MapType),
            MapMonsterInfoList=[],
            next;
        ?ACTOR_TYPE_MONSTER ->
            MapRoleInfoList=[],MapPetInfoList=[],
            MapMonsterInfoList = get_map_monster_by_slice(SliceList,MapType),
            next
	end,
	{ok,MapRoleInfoList,MapPetInfoList,MapMonsterInfoList}.
get_map_role_by_slice(SliceList,MapType) ->
    MapRoleInfoList = 
        lists:foldl(
          fun(PRoleId,AccMapRoleInfoList) -> 
                  case mod_map:get_actor_info(PRoleId, ?ACTOR_TYPE_ROLE) of
                      undefined ->
                          AccMapRoleInfoList;
                      #p_map_role{status=?ACTOR_STATUS_ROLE_LOADING_MAP} ->
                          AccMapRoleInfoList;
                      MapRoleInfo ->
                          [MapRoleInfo|AccMapRoleInfoList]
                  end
          end, [], mod_map:get_slice_actor_list(SliceList,?ACTOR_TYPE_ROLE)),
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
    {MapRoleInfoList,MapPetInfoList}.
get_map_monster_by_slice(SliceList,MapType) ->
    case MapType of
        ?MAP_TYPE_FB ->
            MonsterIdList = mod_map:get_slice_actor_list(SliceList,?ACTOR_TYPE_MONSTER),
            lists:foldl(
               fun(NewMonsterId,AccMapMonsterInfoList) -> 
                       case mod_map:get_actor_info(NewMonsterId, ?ACTOR_TYPE_MONSTER) of
                           undefined ->
                               AccMapMonsterInfoList;
                           NewMapMonsterInfo ->
                               [ NewMapMonsterInfo | AccMapMonsterInfoList]
                       end
               end, [], MonsterIdList);
        _ ->
            []
    end.

do_map_query3(Module,Method,DataRecord,_RoleId,PId,
              MapRoleInfoList,MapPetInfoList,MapMonsterInfoList) ->
	SendSelf = #m_map_query_toc{op_type=DataRecord#m_map_query_tos.op_type,
								actor_type=DataRecord#m_map_query_tos.actor_type,
								op_code=0,
								roles=MapRoleInfoList,
                                pets=MapPetInfoList,
                                monsters=MapMonsterInfoList},
    ?DEBUG("do map query succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
	ok.
do_map_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
	SendSelf = #m_map_query_toc{op_type=DataRecord#m_map_query_tos.op_type,
								actor_type=DataRecord#m_map_query_tos.actor_type,
								op_code=OpCode},
	?DEBUG("do map query fail,SendSelf=~w",[SendSelf]),
	common_misc:unicast(PId,Module,Method,SendSelf),
	ok.

%% 地图元素进入九宫广播处理
do_enter_slice_notify(ActorId,ActorType,NewSlice9List) ->
	case ActorType of
		?ACTOR_TYPE_ROLE ->
            EnterRoleIdList = lists:delete(ActorId, mod_map:get_slice_role_list(NewSlice9List)),
            case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_ROLE) of
                undefined ->
                    EnterBCSelf = undefined;
                #p_map_role{status=?ACTOR_STATUS_ROLE_LOADING_MAP} ->
                    EnterBCSelf = undefined;
                NewMapRoleInfo ->
                    case mod_map:get_map_role_pet(ActorId) of
                        #r_map_role_pet{battle_id=0} ->
                            EnterBCSelf = #m_map_slice_enter_toc{roles = [NewMapRoleInfo]};
                        #r_map_role_pet{battle_id=PetId,display_type=DisplayType} ->
                            #r_map_state{map_type = MapType} = mgeem_map:get_map_state(),
                            case mod_map_pet:check_pet_display(MapType, DisplayType) of
                                true ->
                                    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
                                        undefined ->
                                            EnterBCSelf = #m_map_slice_enter_toc{roles = [NewMapRoleInfo]};
                                        NewMapPetInfo ->
                                            EnterBCSelf = #m_map_slice_enter_toc{roles = [NewMapRoleInfo],pets = [NewMapPetInfo]}
                                    end;
                                _ ->
                                    EnterBCSelf = #m_map_slice_enter_toc{roles = [NewMapRoleInfo]}
                            end;
                        _ ->
                            EnterBCSelf = #m_map_slice_enter_toc{roles = [NewMapRoleInfo]}
                    end
            end;
        ?ACTOR_TYPE_MONSTER ->
            EnterRoleIdList = mod_map:get_slice_role_list(NewSlice9List),
            case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_MONSTER) of
                undefined ->
                    EnterBCSelf = undefined;
                NewMapMonsterInfo ->
                    EnterBCSelf = #m_map_slice_enter_toc{monsters = [NewMapMonsterInfo]}
            end;
        ?ACTOR_TYPE_AVATAR ->
            EnterRoleIdList = mod_map:get_slice_role_list(NewSlice9List),
            case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_AVATAR) of
                undefined ->
                    EnterBCSelf = undefined;
                NewMapAvatarInfo ->
                    EnterBCSelf = #m_map_slice_enter_toc{avatars = [NewMapAvatarInfo]}
            end;
		_ ->
            EnterRoleIdList = [],
			EnterBCSelf = undefined
	end,
	case EnterBCSelf of
		undefined ->
			next;
		_ ->
			mod_map:broadcast(EnterRoleIdList,?MAP,?MAP_SLICE_ENTER,EnterBCSelf)
	end,
	ok.
            
 
%% 地图元素退出九宫格广播处理
do_quit_slice_notify(ActorId,ActorType,OldSlice9List) ->
	case ActorType of
		?ACTOR_TYPE_ROLE ->  %% 人物退出时，宠物必须退出
            QuitRoleIdList = lists:delete(ActorId, mod_map:get_slice_role_list(OldSlice9List)),
            case mod_map:get_map_role_pet(ActorId) of
                undefined ->
                    DelPets=[];
                #r_map_role_pet{battle_id=0} ->
                    DelPets=[];
                #r_map_role_pet{battle_id=PetId} ->
                    DelPets=[PetId]
            end,
			QuitBCSelf = #m_map_slice_enter_toc{del_roles=[ActorId],del_pets=DelPets};
        ?ACTOR_TYPE_MONSTER ->
            QuitRoleIdList = mod_map:get_slice_role_list(OldSlice9List),
            QuitBCSelf = #m_map_slice_enter_toc{del_monsters=[ActorId]};
        ?ACTOR_TYPE_AVATAR ->
            QuitRoleIdList = mod_map:get_slice_role_list(OldSlice9List),
            QuitBCSelf = #m_map_slice_enter_toc{del_avatars=[ActorId]};
		_ ->
            QuitRoleIdList = [],
			QuitBCSelf = undefined
	end,
	case QuitBCSelf of
		undefined ->
			next;
		_ ->
			mod_map:broadcast(QuitRoleIdList,?MAP,?MAP_SLICE_ENTER,QuitBCSelf)
	end,
	ok.

%% 角色死亡通知
do_dead_slice_notify(ActorId,?ACTOR_TYPE_ROLE) ->
    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_ROLE) of
        #p_map_role{pos=#p_pos{x=X,y=Y}} ->
            do_dead_slice_notify2(ActorId,?ACTOR_TYPE_ROLE,X,Y);
        _ ->
            next
    end;
do_dead_slice_notify(ActorId,?ACTOR_TYPE_PET) ->
    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_PET) of
        #p_map_pet{pos=#p_pos{x=X,y=Y}} ->
            do_dead_slice_notify2(ActorId,?ACTOR_TYPE_PET,X,Y);
        _ ->
            ignore
    end;
do_dead_slice_notify(ActorId,?ACTOR_TYPE_MONSTER) ->
    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_MONSTER) of
        #p_map_monster{pos=#p_pos{x=X,y=Y}} ->
            do_dead_slice_notify2(ActorId,?ACTOR_TYPE_MONSTER,X,Y);
        _ ->
            ignore
    end;
do_dead_slice_notify(ActorId,?ACTOR_TYPE_AVATAR) ->
    case mod_map:get_actor_info(ActorId, ?ACTOR_TYPE_AVATAR) of
        #p_map_avatar{pos=#p_pos{x=X,y=Y}} ->
            do_dead_slice_notify2(ActorId,?ACTOR_TYPE_AVATAR,X,Y);
        _ ->
            ignore
    end;
do_dead_slice_notify(_ActorId,_ActorType) ->
    ignore.
do_dead_slice_notify2(ActorId,ActorType,X,Y) ->
    {Tx,Ty} = mod_map_slice:to_tile_pos(X,Y),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    do_dead_slice_notify(ActorId,ActorType,Slice9List).
do_dead_slice_notify(ActorId,ActorType,Slice9List) ->
    RoleIdList = mod_map:get_slice_role_list(Slice9List),
    BCSelf = #m_map_actor_dead_toc{actor_id=ActorId,actor_type=ActorType},
    mod_map:broadcast(RoleIdList,?MAP,?MAP_ACTOR_DEAD,BCSelf),
    ok.

%% 地图元素九宫格变化广播处理
do_change_slice_notify(ActorId,ActorType,OldSlice9List,NewSlice9List) ->
	%% 把玩家看到的新玩家和看不到的玩家消息通知给前端
	case ActorType of
		?ACTOR_TYPE_ROLE -> 
            #r_map_state{map_type = MapType} = mgeem_map:get_map_state(),
			AddSlice9List = [ NewSlice || NewSlice <- NewSlice9List,lists:member(NewSlice, OldSlice9List) =:= false],
			DelSlice9List = [ OldSlice || OldSlice <- OldSlice9List,lists:member(OldSlice, NewSlice9List) =:= false],
			EnterRoleIdList = lists:delete(ActorId, mod_map:get_slice_role_list(AddSlice9List)),
			QuitRoleIdList = lists:delete(ActorId, mod_map:get_slice_role_list(DelSlice9List)),
			MapRoleInfoList = 
				lists:foldl(
				  fun(NewRoleId,AccMapRoleInfoList) -> 
                          case mod_map:get_actor_info(NewRoleId, ?ACTOR_TYPE_ROLE) of
                              undefined ->
                                  AccMapRoleInfoList;
                              #p_map_role{status=?ACTOR_STATUS_ROLE_LOADING_MAP} ->
                                  AccMapRoleInfoList;
                              NewMapRoleInfo ->
                                  [ NewMapRoleInfo | AccMapRoleInfoList]
                          end
				  end, [], EnterRoleIdList),
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
            
            QuitPetIdList = 
                lists:foldl(
                 fun(QuitRoleId,AccQuitPetIdList) ->
                          case mod_map:get_map_role_pet(QuitRoleId) of
                              #r_map_role_pet{battle_id=0} ->
                                  AccQuitPetIdList;
                              #r_map_role_pet{battle_id=PPetId,display_type=DisplayType} ->
                                  case mod_map_pet:check_pet_display(MapType, DisplayType) of
                                      true ->
                                          [PPetId|AccQuitPetIdList];
                                      _ ->
                                          next
                                  end;
                              _ ->
                                  AccQuitPetIdList
                          end
                  end, [], QuitRoleIdList),
            case MapType of
                ?MAP_TYPE_FB ->
                    EnterMonsterIdList = mod_map:get_slice_actor_list(AddSlice9List,?ACTOR_TYPE_MONSTER),
                    MapMonsterInfoList = 
                        lists:foldl(
                           fun(NewMonsterId,AccMapMonsterInfoList) -> 
                                   case mod_map:get_actor_info(NewMonsterId, ?ACTOR_TYPE_MONSTER) of
                                       undefined ->
                                           AccMapMonsterInfoList;
                                       NewMapMonsterInfo ->
                                           [ NewMapMonsterInfo | AccMapMonsterInfoList]
                                   end
                           end, [], EnterMonsterIdList),
                    QuitMonsterIdList = mod_map:get_slice_actor_list(DelSlice9List,?ACTOR_TYPE_MONSTER);
                _ ->
                    MapMonsterInfoList = [],
                    QuitMonsterIdList = []
            end,
            case MapType of
                ?MAP_TYPE_NORMAL ->
                    EnterAvatarIdList = mod_map:get_slice_actor_list(AddSlice9List,?ACTOR_TYPE_AVATAR),
                    MapAvatarInfoList = 
                        lists:foldl(
                           fun(NewAvatarId,AccMapAvatarInfoList) -> 
                                   case mod_map:get_actor_info(NewAvatarId, ?ACTOR_TYPE_AVATAR) of
                                       undefined ->
                                           AccMapAvatarInfoList;
                                       NewMapAvatarInfo ->
                                           [ NewMapAvatarInfo | AccMapAvatarInfoList]
                                   end
                           end, [], EnterAvatarIdList),
                    QuitAvatarIdList = mod_map:get_slice_actor_list(DelSlice9List,?ACTOR_TYPE_AVATAR);
                _ ->
                    MapAvatarInfoList = [],
                    QuitAvatarIdList = []
            end,
			SendSelf = #m_map_slice_enter_toc{del_roles=QuitRoleIdList,
											  roles = MapRoleInfoList, %%lists:sublist(MapRoleInfoList,?MAX_SLICE_BROADCAST_ROLE),
                                              pets = MapPetInfoList,
                                              del_pets=QuitPetIdList,
                                              monsters=MapMonsterInfoList,
                                              del_monsters=QuitMonsterIdList,
                                              avatars=MapAvatarInfoList,
                                              del_avatars=QuitAvatarIdList},
            mod_map:broadcast([ActorId],?MAP,?MAP_SLICE_ENTER,SendSelf);
		_ ->
			next
	end,
    %% 元素退出的Slice列表
    QuitSliceList = [ QuitSlice9 || QuitSlice9 <- OldSlice9List,lists:member(QuitSlice9, NewSlice9List) =:= false],
    do_quit_slice_notify(ActorId,ActorType,QuitSliceList),
    
	%% 元素进入的Slice列表
	EnterSliceList = [ EnterSlice9 || EnterSlice9 <- NewSlice9List,lists:member(EnterSlice9, OldSlice9List) =:= false],
	do_enter_slice_notify(ActorId,ActorType,EnterSliceList),
	ok.

            