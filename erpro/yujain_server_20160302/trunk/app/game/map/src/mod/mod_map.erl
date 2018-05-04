%% Author: caochuncheng2002@gmail.com
%% Created: 2013-5-16
%% Description: 地图模块API
-module(mod_map).

-include("mgeem.hrl").

-export([
		 init_game_maps/0,
		 init_in_map_role/0,
		 init_map_tile/1,
		 init_map_slice/1,
		 
		 join_slice/3,
		 leave_slice/3,
		 
		 get_slice_role/1,
		 get_slice_role_list/1,
         
         get_slice_actor/2,
         get_slice_actor_list/2
        
		 ]).

-export([
         get_in_map_role/0,
         add_in_map_role/1,
         del_in_map_role/1,
         
         init_role_world_pid/2,
         get_role_world_pid/1,
         erase_role_world_pid/1,
         
         init_actor_info/3,
         get_actor_info/2, 
         set_actor_info/3, 
         erase_actor_info/2,
         
         get_actor_pos/2,
         
         init_map_actor/3,
         get_map_actor/2, 
         set_map_actor/3, 
         erase_map_actor/2,
         
         set_role_pos/6,
         
         check_tile_pos/2,
         check_tile_pos/3,
         deref_tile_pos/4,
         ref_tile_pos/4,
         get_tile_pos/3,
         get_tile_pos/2,

         get_map_role_pet/1,
         set_map_role_pet/2,
         erase_map_role_pet/1,
         get_map_role_pet_id/1,
         
         get_role_change_map/1,
         set_role_change_map/2,
         erase_role_change_map/1,
         
         set_change_map_quit/2,
         is_change_map_quit/1,
         erase_change_map_quit/1
        
        ]).

-export([
         broadcast_merge_slice/5,
         broadcast_merge_slice/4,
         broadcast_now/2,
         broadcast_now/4,
         broadcast/2,
         broadcast/4,
         broadcast_9slice/4,
         flush_all_role_msg_queue/0,
         update_role_msg_queue/2
         ]).

%% 初始化游戏地图
init_game_maps()->
    MapIdList = cfg_map:get_all_map_id(),
    init_game_maps2(MapIdList),
    FbIdList = cfg_fb:init_fb_maps(),
    init_other_map(FbIdList),
    ok.
init_game_maps2([]) ->
    ok;
init_game_maps2([MapId|MapIdList]) ->
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{map_type=?MAP_TYPE_NORMAL}=MapInfo] ->
            case init_game_maps3(MapId,MapInfo) of
                ok ->
                    init_game_maps2(MapIdList);
                _ ->
                    erlang:throw(init_map_error)
            end;
        _ ->
            init_game_maps2(MapIdList)
    end.
init_game_maps3(MapId,MapInfo) ->
    MapProcessName = common_map:get_common_map_name(MapId),
    case supervisor:start_child(mgeem_map_sup, [{MapProcessName,MapId}]) of
        {ok, _MapPid} ->
            ok;
        {error, {already_started, _}} -> 
            ok;
        {error, Reason} ->
            ?ERROR_MSG("~ts ~w ~ts,MapProcessName=~w,MapInfo=~w,Error=~w", [?_LANG_MAP_007,MapId,?_LANG_FAILURE,MapProcessName,MapInfo,Reason]),
            error
    end.
%% 初始化其它地图进程
init_other_map([]) ->
    ok;
init_other_map([FbId|FbIdList]) -> 
    case cfg_fb:find(FbId) of 
        #r_fb_info{map_id=MapId,create_map_process_type=?FB_CREATE_MAP_PROCESS_TYPE_YES} ->
            next;
        _ ->
            MapId = 0,
            erlang:throw(init_map_error)
    end,
    case cfg_map:get_map_info(MapId) of
        [#r_map_info{map_type=?MAP_TYPE_FB}=MapInfo] ->
            next;
        _ ->
            MapInfo = undefined,
            erlang:throw(init_map_error)
    end,
    MapProcessName = common_map:get_fb_alive_map_name(FbId),
    case supervisor:start_child(mgeem_map_sup, [{MapProcessName,MapId,FbId}]) of
        {ok, _MapPid} ->
            ok;
        {error, {already_started, _}} -> 
            ok;
        {error, Reason} ->
            ?ERROR_MSG("~ts ~w ~ts,MapProcessName=~w,MapInfo=~w,Error=~w", [?_LANG_MAP_007,MapId,?_LANG_FAILURE,MapProcessName,MapInfo,Reason]),
            erlang:throw(init_map_error)
    end,
    init_other_map(FbIdList).

init_in_map_role() ->
    erlang:put(in_map_role, []).
get_in_map_role() ->
    erlang:get(in_map_role).
add_in_map_role(RoleId) ->
    List = get_in_map_role(),
    case lists:member(RoleId, List) of
        true ->
            ignore;
        _ ->
            erlang:put(in_map_role, [RoleId|List])
    end.
del_in_map_role(RoleId) ->
    List = get_in_map_role(),
    erlang:put(in_map_role, lists:delete(RoleId, List)).

%% 玩家世界进程PId
init_role_world_pid(RoleId,PId) ->
    erlang:put({role_world_pid, RoleId},PId).
get_role_world_pid(RoleId) ->
    erlang:get({role_world_pid, RoleId}).
erase_role_world_pid(RoleId) ->
    erlang:erase({role_world_pid, RoleId}).

%% 地图Actor信息
-spec init_actor_info(ActorId,ActorType,ActorInfo) -> ok when
          ActorId :: role_id | pet_id | monster_id | avatar_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR,
          ActorInfo :: #p_map_role{} | #p_map_pet{} | #p_map_monster{} | #p_map_avatar{}.
init_actor_info(ActorId,?ACTOR_TYPE_ROLE,ActorInfo) ->
    erlang:put({role_info, ActorId},ActorInfo);
init_actor_info(ActorId,?ACTOR_TYPE_PET,ActorInfo) ->
    erlang:put({pet_info, ActorId},ActorInfo);
init_actor_info(ActorId,?ACTOR_TYPE_MONSTER,ActorInfo) ->
    erlang:put({monster_info, ActorId},ActorInfo);
init_actor_info(ActorId,?ACTOR_TYPE_AVATAR,ActorInfo) ->
    erlang:put({avatar_info, ActorId},ActorInfo);
init_actor_info(ActorId, ActorType, ActorInfo) -> 
    ?ERROR_MSG("init_actor_info,Error=~w",[{ActorId, ActorType, ActorInfo}]).

-spec get_actor_info(ActorId,ActorType) -> ok when
          ActorId :: role_id | pet_id | monster_id | avatar_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR.
get_actor_info(ActorId,?ACTOR_TYPE_ROLE) ->
    erlang:get({role_info, ActorId});
get_actor_info(ActorId,?ACTOR_TYPE_PET) ->
    erlang:get({pet_info, ActorId});
get_actor_info(ActorId,?ACTOR_TYPE_MONSTER) ->
    erlang:get({monster_info, ActorId});
get_actor_info(ActorId,?ACTOR_TYPE_AVATAR) ->
    erlang:get({avatar_info, ActorId});
get_actor_info(_ActorId,_ActorType) ->
    undefined.

-spec set_actor_info(ActorId,ActorType,ActorInfo) -> ok when
          ActorId :: role_id | pet_id | monster_id | avatar_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR,
          ActorInfo :: #p_map_role{} | #p_map_pet{} | #p_map_monster{} | #p_map_avatar{}.
set_actor_info(ActorId,?ACTOR_TYPE_ROLE,ActorInfo) ->
    erlang:put({role_info, ActorId},ActorInfo);
set_actor_info(ActorId,?ACTOR_TYPE_PET,ActorInfo) ->
    erlang:put({pet_info, ActorId},ActorInfo);
set_actor_info(ActorId,?ACTOR_TYPE_MONSTER,ActorInfo) ->
    erlang:put({monster_info, ActorId},ActorInfo);
set_actor_info(ActorId,?ACTOR_TYPE_AVATAR,ActorInfo) ->
    erlang:put({avatar_info, ActorId},ActorInfo);
set_actor_info(ActorId, ActorType, ActorInfo) -> 
    ?ERROR_MSG("set_actor_info,Error=~w",[{ActorId, ActorType, ActorInfo}]).

-spec erase_actor_info(ActorId,ActorType) ->ok when
          ActorId :: role_id | pet_id | monster_id | avatar_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR.
erase_actor_info(ActorId,?ACTOR_TYPE_ROLE) ->
    erlang:erase({role_info,ActorId});
erase_actor_info(ActorId,?ACTOR_TYPE_PET) ->
    erlang:erase({pet_info,ActorId});
erase_actor_info(ActorId,?ACTOR_TYPE_MONSTER) ->
    erlang:erase({monster_info,ActorId});
erase_actor_info(ActorId,?ACTOR_TYPE_AVATAR) ->
    erlang:erase({avatar_info,ActorId});
erase_actor_info(_ActorId,_ActorType) ->
    ingroe.

%% 获取Actor位置信息
-spec 
get_actor_pos(ActorId,ActorType) -> undefined | #p_pos{} when
    ActorId :: role_id | pet_id | monster_id | avatar_id,
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR.
get_actor_pos(ActorId,ActorType) ->
    case get_actor_info(ActorId, ActorType) of
        #p_map_role{pos=Pos} ->Pos;
        #p_map_pet{pos=Pos} ->Pos;
        #p_map_monster{pos=Pos} ->Pos;
        #p_map_avatar{pos=Pos} ->Pos;
        _ -> undefined
    end.
        



%% 地图Actor属性
init_map_actor(ActorId,?ACTOR_TYPE_ROLE,ActorAttr) ->
    erlang:put({map_role_actor, ActorId},ActorAttr);
init_map_actor(ActorId,?ACTOR_TYPE_PET,ActorAttr) ->
    erlang:put({map_pet_actor, ActorId},ActorAttr);
init_map_actor(ActorId,?ACTOR_TYPE_MONSTER,ActorAttr) ->
    erlang:put({map_monster_actor, ActorId},ActorAttr);
init_map_actor(ActorId, ActorType, ActorAttr) -> 
    ?ERROR_MSG("init_map_actor,Error=~w",[{ActorId, ActorType, ActorAttr}]).

get_map_actor(ActorId,?ACTOR_TYPE_ROLE) ->
    erlang:get({map_role_actor, ActorId});
get_map_actor(ActorId,?ACTOR_TYPE_PET) ->
    erlang:get({map_pet_actor, ActorId});
get_map_actor(ActorId,?ACTOR_TYPE_MONSTER) ->
    erlang:get({map_monster_actor, ActorId});
get_map_actor(_ActorId,_ActorType) ->
    undefined.

set_map_actor(ActorId,?ACTOR_TYPE_ROLE,MapActor) ->
    erlang:put({map_role_actor, ActorId},MapActor);
set_map_actor(ActorId,?ACTOR_TYPE_PET,MapActor) ->
    erlang:put({map_pet_actor, ActorId},MapActor);
set_map_actor(ActorId,?ACTOR_TYPE_MONSTER,MapActor) ->
    erlang:put({map_monster_actor, ActorId},MapActor);
set_map_actor(ActorId, ActorType, MapActor) -> 
    ?ERROR_MSG("set_map_actor,Error=~w",[{ActorId, ActorType, MapActor}]).

erase_map_actor(ActorId,?ACTOR_TYPE_ROLE) ->
    erlang:erase({map_role_actor,ActorId});
erase_map_actor(ActorId,?ACTOR_TYPE_PET) ->
    erlang:erase({map_pet_actor,ActorId});
erase_map_actor(ActorId,?ACTOR_TYPE_MONSTER) ->
    erlang:erase({map_monster_actor,ActorId});
erase_map_actor(_ActorId,_ActorType) ->
    ingroe.

%% 玩家位置变化处理
-spec 
set_role_pos(RoleId,MapRoleInfo,OldMapPos,NewMapPos,IsChangeMap,IsChangeSlice) -> ok when
    RoleId :: integer,
    MapRoleInfo :: #p_map_role{},
    OldMapPos :: #p_map_pos{},
    NewMapPos :: #p_map_pos{},
    IsChangeMap :: true | false,
    IsChangeSlice :: true | false.
set_role_pos(RoleId,MapRoleInfo,OldMapPos,NewMapPos,IsChangeMap,IsChangeSlice) ->
    #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty} = NewMapPos,
    case OldMapPos of
        undefined ->
            next;
        _ ->
            #p_map_pos{tx=OldTx,ty=OldTy}=OldMapPos,
            deref_tile_pos(RoleId, ?ACTOR_TYPE_ROLE, OldTx, OldTy)
    end,
    ref_tile_pos(RoleId, ?ACTOR_TYPE_ROLE, Tx, Ty), 
    NewPos = #p_pos{x=X, y=Y},
    #p_map_role{group_id=GroupId} = MapRoleInfo,
    NewRoleMapInfo = MapRoleInfo#p_map_role{pos=NewPos},
    set_actor_info(RoleId, ?ACTOR_TYPE_ROLE, NewRoleMapInfo),
    %% 当位置变化发生slice变化时，需要持久化数据
    case IsChangeSlice == true orelse IsChangeMap == true of
        true ->
            #r_map_state{map_id=MapId,map_process_name=MapProcessName} = mgeem_map:get_map_state(),
            %% 如果当前地图是游戏服地图即可以直接修改ets进行相应数据的同步
            %% 如果当前地图是跨服地图，即需要通过消息通信来同步信息
            case mgeem_map:is_kf_map() of
                true ->
                    UpdateInfo = {sync_map_change_data,[{role_pos,RoleId,IsChangeMap,MapId,MapProcessName,GroupId,NewPos}]},
                    case mod_map:get_role_world_pid(RoleId) of
                        undefined ->
                            ignore;
                        RoleWorldPId ->
                            RoleWorldPId ! {mod,mod_role_bi,UpdateInfo}
                    end,
                    ok;
                _ ->
                    common_transaction:t(
                      fun() ->
                              {ok,RolePos} = mod_role:get_role_pos(RoleId),
                              #r_role_pos{map_id=LastMapId,pos=LastPos,map_process_name=LastMapProcessName,group_id=LastGroupId} = RolePos,
                              case IsChangeMap of
                                  true ->
                                      NewRolePos = RolePos#r_role_pos{map_id = MapId,
                                                                      pos=NewPos,
                                                                      map_process_name=MapProcessName,
                                                                      group_id=GroupId,
                                                                      last_map_id=LastMapId,
                                                                      last_pos=LastPos,
                                                                      last_map_process_name = LastMapProcessName,
                                                                      last_group_id=LastGroupId};
                                  _ ->
                                      NewRolePos = RolePos#r_role_pos{pos=NewPos}
                              end,
                              mod_role:t_set_role_pos(RoleId,NewRolePos),
                              ok
                      end)
            end;
        _ ->
            next
    end,
    ok.

%% 检查此地图格子是否有效
%% 服务端寻路检查使用，格子类型为不可行走的即不可以寻路
-spec check_tile_pos(Tx,Ty) -> true | false when
          Tx :: integer,
          Ty :: integer.
check_tile_pos(Tx,Ty) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    case McmModule:get_slice_name({Tx,Ty}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            true;
        _ ->
            false
    end.
check_tile_pos(McmModule,Tx,Ty) ->
    case McmModule:get_slice_name({Tx,Ty}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            true;
        _ ->
            false
    end.
%%为格子打上标记以便标示是否已经有人站在一个格子上了 
deref_tile_pos(ActorId,ActorType,Tx,Ty) -> 
    case erlang:get({ref, Tx, Ty}) of 
        [] -> 
            ignore; 
        undefined -> 
            ignore; 
        List -> 
            NewList = lists:delete({ActorType, ActorId}, List), 
            erlang:put({ref, Tx, Ty}, NewList)
    end. 
ref_tile_pos(ActorId,ActorType,Tx,Ty) -> 
    case erlang:get({ref,Tx,Ty}) of 
        undefined -> 
             erlang:put({ref, Tx, Ty}, [{ActorType,ActorId}]); 
        List -> 
            case lists:member({ActorType, ActorId}, List) of 
                true -> 
                    NewList = List; 
                false -> 
                    NewList = [{ActorType, ActorId}|List] 
            end, 
            erlang:put({ref, Tx, Ty}, NewList) 
    end.

get_tile_pos(ActorType,Tx,Ty) ->
    case erlang:get({ref,Tx,Ty}) of 
        undefined -> 
            [];
        List ->
            [PActorId || {PActorType,PActorId} <- List, PActorType =:= ActorType]
    end.

get_tile_pos(Tx, Ty) ->
    case erlang:get({ref, Tx, Ty}) of
        undefined ->
            [];
        List ->
            List
    end.

%% 获取玩家出战宠物信息
%% return undefined | #r_map_role_pet{}
get_map_role_pet(RoleId) ->
    erlang:get({map_role_pet,RoleId}).
set_map_role_pet(RoleId,MapRolePet) ->
    erlang:put({map_role_pet,RoleId}, MapRolePet).
erase_map_role_pet(RoleId) ->
    erlang:erase({map_role_pet,RoleId}).

%% 获取玩家出战宠物ID
get_map_role_pet_id(RoleId) ->
    case get_map_role_pet(RoleId) of
        #r_map_role_pet{battle_id = PetId} -> PetId;
        _ -> 0
    end.

%% 玩家切换地图时数据
get_role_change_map(RoleId) ->
    erlang:get({role_change_map,RoleId}).
-spec
set_role_change_map(RoleId,RoleChangeMapInfo) -> term() when
    RoleId :: integer,
    RoleChangeMapInfo :: #r_role_change_map{}.
set_role_change_map(RoleId,RoleChangeMapInfo) ->
    erlang:put({role_change_map,RoleId}, RoleChangeMapInfo).
erase_role_change_map(RoleId) ->
    erlang:erase({role_change_map,RoleId}).

set_change_map_quit(RoleId, DestMapId) ->
    erlang:put({change_map_quit, RoleId}, DestMapId).
is_change_map_quit(RoleId) ->
    case erlang:get({change_map_quit, RoleId}) of
        undefined ->
            false;
        DestMapId ->
            {true, DestMapId}
    end.
erase_change_map_quit(RoleId) ->
    erlang:erase({change_map_quit, RoleId}).

%% 地图广播，合并区域广播，即两点之间的可见区域广播
-spec
broadcast_merge_slice(Type,ActorId,ActorType,TargetPos,Record) -> ignore | ok when
    Type :: now | delay| term(),
    ActorId :: role_id | pet_id | monster_id | avatar_id,
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR,
    TargetPos :: #p_pos{},
    Record :: toc_record | [toc_record].
broadcast_merge_slice(Type,ActorId,ActorType,TargetPos,Record) ->
    case get_actor_pos(ActorId, ActorType) of
        undefined ->
            ignroe;
        Pos ->
            broadcast_merge_slice(Type,Pos,TargetPos,Record)
    end.
broadcast_merge_slice(Type,#p_pos{x=X,y=Y},#p_pos{x=DestX,y=DestY},Record) ->
    {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
    {DestTx, DestTy} = mod_map_slice:to_tile_pos(DestX, DestY),
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    [#r_map_slice{slice_16_list=Slice16List}] = McmModule:get_slice_name({DestTx, DestTy}),
    SliceList = lists:foldl(
                  fun(SliceName,AccSliceList) -> 
                          case lists:member(SliceName,AccSliceList) of
                              true ->
                                  AccSliceList;
                              _ ->
                                  [SliceName | AccSliceList]
                          end
                  end,Slice16List,Slice9List),
    RoleIdList = mod_map:get_slice_role_list(SliceList),
    case Type of
        now ->
            broadcast_now(RoleIdList,Record);
        _ ->
            broadcast(RoleIdList,Record)
    end,
    ok. 
%% 地图九宫格广播消息
-spec 
broadcast_9slice(Type,ActorId,ActorType,Record) -> ignore | ok when
    Type :: now | delay| term(),
    ActorId :: role_id | pet_id | monster_id | avatar_id,
    ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER | ?ACTOR_TYPE_AVATAR,
    Record :: term() | [term(),...].
broadcast_9slice(now,ActorId,ActorType,Record) ->
    case get_actor_pos(ActorId, ActorType) of
        undefined ->
            ignroe;
        #p_pos{x=X,y=Y} ->
            {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
            RoleIdList = get_9slice_roles(Tx,Ty),
            broadcast_now(RoleIdList,Record)
    end;
broadcast_9slice(_,ActorId,ActorType,Record) ->
    case get_actor_pos(ActorId, ActorType) of
        undefined ->
            ignroe;
        #p_pos{x=X,y=Y} ->
            {Tx, Ty} = mod_map_slice:to_tile_pos(X, Y),
            RoleIdList = get_9slice_roles(Tx,Ty),
            broadcast(RoleIdList,Record)
    end.

get_9slice_roles(Tx,Ty) ->
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
    mod_map:get_slice_role_list(Slice9List).

%% 立即广播
broadcast_now([],_DataRecordList) ->
    ignroe;
broadcast_now(RoleIdList,DataRecordList) when erlang:is_list(DataRecordList) ->
    [broadcast_now(RoleIdList, DataRecord) || DataRecord <- DataRecordList];
broadcast_now(RoleIdList,DataRecord) ->
    broadcast_now(RoleIdList,0,0,DataRecord).

broadcast_now([],_Module,_Method,_DataRecord) ->
    ignore;
broadcast_now([RoleId|RoleIdList],Module,Method,DataRecord) ->
    case mod_map_role:get_role_gateway_pid(RoleId) of
        undefined ->
            ignore;
        RolePId ->
            case Module == 0 andalso Method == 0 of
                true -> RolePId ! {message, DataRecord};
                false -> RolePId ! {message, Module, Method, DataRecord}
            end
    end,
    broadcast_now(RoleIdList,Module,Method,DataRecord).

%% 地图广播接口，地图大循环处理发送
broadcast([],_DataRecordList) ->
    ignroe;
broadcast(RoleIdList,DataRecordList) when is_list(DataRecordList) ->
    [broadcast(RoleIdList, DataRecord) || DataRecord <- DataRecordList];
broadcast(RoleIdList,DataRecord) ->
    broadcast(RoleIdList,0,0,DataRecord).

broadcast([],_Module,_Method,_DataRecord) ->
    ignore;
broadcast([RoleId|RoleIdList],Module,Method,DataRecord) ->
    case mod_map_role:get_role_gateway_pid(RoleId) of
        undefined ->
            ignore;
        RolePId ->
            MsgRecord = #r_unicast{module = Module, 
                                   method = Method, 
                                   role_id = RoleId, 
                                   record = DataRecord},
            update_role_msg_queue(RolePId,MsgRecord)
    end,
    broadcast(RoleIdList,Module,Method,DataRecord).

update_role_msg_queue(RolePId,MsgRecord) ->
    case erlang:get({role_msg_queue, RolePId}) of
        undefined ->
            MsgList = [];
        MsgList ->
            next
    end,
    erlang:put({role_msg_queue, RolePId}, [MsgRecord | MsgList]).

flush_all_role_msg_queue() ->
    AllMapRoleIdList = mod_map:get_in_map_role(),
    flush_all_role_msg_queue2(AllMapRoleIdList).

flush_all_role_msg_queue2([]) ->
    ignore;
flush_all_role_msg_queue2([RoleId|AllMapRoleIdList]) ->
    case mod_map_role:get_role_gateway_pid(RoleId) of
        undefined ->
            ignore;
        RolePId ->                      
            case erlang:get({role_msg_queue, RolePId}) of
				undefined ->
					ignore;
                [] ->
                    ignore;
                MsgList ->               
                    RolePId ! {messages, lists:reverse(MsgList)},
                    erlang:erase({role_msg_queue, RolePId})
            end
    end,
    flush_all_role_msg_queue2(AllMapRoleIdList).

%% 初始化地图格子
init_map_tile(MapId) ->
	[#r_map_info{mcm_module=McmModule}] = cfg_map:get_map_info(MapId),
	RefList = McmModule:get_map_ref(MapId),
	lists:foreach(
	  fun(#r_map_ref{tx = Tx,ty = Ty,type = _RefType}) -> 
			  erlang:put({ref,Tx,Ty}, [])
	  end, RefList),
	ok.

%% 初始化地图九宫格
%% 每一个slice对应的九宫格
init_map_slice(MapId) ->
	[#r_map_info{width=Width,height=Height}] = cfg_map:get_map_info(MapId),
	MaxSliceX = common_tool:ceil(Width/?MAP_SLICE_WIDTH) - 1,
    MaxSliceY = common_tool:ceil(Height/?MAP_SLICE_HEIGHT) - 1,
	%%为每个slice创建一个进程字典
	lists:foreach(
	  fun(SliceX) ->
			  lists:foreach(
				fun(SliceY) ->
						SliceName = mod_map_slice:gen_slice_name(SliceX, SliceY),
						erlang:put({map_slice_role, SliceName}, [])
				end, lists:seq(0, MaxSliceY))
	  end, lists:seq(0, MaxSliceX)),
	ok.

%% 加入Slice
-spec join_slice(SliceName,ActorId,ActorType) -> ok when
          SliceName :: string,
          ActorId :: role_id | monster_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_MONSTER.

join_slice(SliceName,RoleId,?ACTOR_TYPE_ROLE) -> 
    case erlang:get({map_slice_role,SliceName}) of 
        undefined -> 
            erlang:put({map_slice_role,SliceName},[RoleId]); 
        List -> 
            erlang:put({map_slice_role,SliceName},[RoleId|List]) 
    end;
join_slice(SliceName,PetId,?ACTOR_TYPE_PET) -> 
    case erlang:get({map_slice_pet,SliceName}) of 
        undefined -> 
            erlang:put({map_slice_pet,SliceName},[PetId]); 
        List -> 
            erlang:put({map_slice_pet,SliceName},[PetId|List]) 
    end;
join_slice(SliceName,MonsterId,?ACTOR_TYPE_MONSTER) -> 
    case erlang:get({map_slice_monster,SliceName}) of 
        undefined -> 
            erlang:put({map_slice_monster,SliceName},[MonsterId]); 
        List -> 
            erlang:put({map_slice_monster,SliceName},[MonsterId|List]) 
    end;
join_slice(SliceName,AvatarId,?ACTOR_TYPE_AVATAR) -> 
    case erlang:get({map_slice_avatar,SliceName}) of 
        undefined -> 
            erlang:put({map_slice_avatar,SliceName},[AvatarId]); 
        List -> 
            erlang:put({map_slice_avatar,SliceName},[AvatarId|List]) 
    end;
join_slice(_SliceName,_ActorId,_ActorType) ->
    ok.
%% 离开Slice
-spec leave_slice(SliceName,ActorId,ActorType) -> ok when
          SliceName :: string,
          ActorId :: role_id | monster_id,
          ActorType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_MONSTER.

leave_slice(SliceName,RoleId,?ACTOR_TYPE_ROLE) -> 
    case erlang:get({map_slice_role,SliceName}) of 
        undefined -> 
            ?ERROR_MSG("role leave slice error,SilceName=~s,RoleId=~w ",[SliceName,RoleId]); 
        List -> 
            erlang:put({map_slice_role,SliceName},erase_list_member(RoleId,List)) 
    end;
leave_slice(SliceName,PetId,?ACTOR_TYPE_PET) -> 
    case erlang:get({map_slice_pet,SliceName}) of 
        undefined -> 
            ?ERROR_MSG("pet leave slice error,SilceName=~s,PetId=~w ",[SliceName,PetId]); 
        List -> 
            erlang:put({map_slice_pet,SliceName},erase_list_member(PetId,List)) 
    end;
leave_slice(SliceName,MonsterId,?ACTOR_TYPE_MONSTER) -> 
    case erlang:get({map_slice_monster,SliceName}) of 
        undefined -> 
            ?ERROR_MSG("monster leave slice error,SilceName=~s,MonsterId=~w ",[SliceName,MonsterId]); 
        List -> 
            erlang:put({map_slice_monster,SliceName},erase_list_member(MonsterId,List)) 
    end;
leave_slice(SliceName,AvatarId,?ACTOR_TYPE_AVATAR) -> 
    case erlang:get({map_slice_avatar,SliceName}) of 
        undefined -> 
            ?ERROR_MSG("avatar leave slice error,SilceName=~s,AvatarId=~w ",[SliceName,AvatarId]); 
        List -> 
            erlang:put({map_slice_avatar,SliceName},erase_list_member(AvatarId,List)) 
    end;
leave_slice(_SliceName,_ActorId,_ActorType) ->
    ok.

%% 强制删除列表元素，会干净的删除列表元素
erase_list_member(Elem,List) ->
	NewList = lists:delete(Elem, List), 
	case lists:member(Elem, NewList) of 
		false -> 
			NewList; 
		_ -> 
			erase_list_member(Elem, NewList) 
	end.

%% 返回slice所有玩家RoleId列表
get_slice_role(SliceName) ->
	get_slice_actor(SliceName,?ACTOR_TYPE_ROLE).

get_slice_role_list(SliceNameList) ->
	get_slice_actor_list(SliceNameList,?ACTOR_TYPE_ROLE).

%% 返回slice所有Actor Id列表
get_slice_actor(SliceName,?ACTOR_TYPE_ROLE) ->
    erlang:get({map_slice_role,SliceName});
get_slice_actor(SliceName,?ACTOR_TYPE_PET) ->
    erlang:get({map_slice_pet,SliceName});
get_slice_actor(SliceName,?ACTOR_TYPE_MONSTER) ->
    erlang:get({map_slice_monster,SliceName});
get_slice_actor(SliceName,?ACTOR_TYPE_AVATAR) ->
    erlang:get({map_slice_avatar,SliceName});
get_slice_actor(_SliceName,_ActorType) ->
    [].
%% 返回slice列表中的所有Actor Id列表
get_slice_actor_list([],_ActorType) ->
    [];
get_slice_actor_list(SliceNameList,?ACTOR_TYPE_ROLE) ->
    get_slice_actor_list(SliceNameList,?ACTOR_TYPE_ROLE,[]);
get_slice_actor_list(SliceNameList,?ACTOR_TYPE_PET) ->
    get_slice_actor_list(SliceNameList,?ACTOR_TYPE_PET,[]);
get_slice_actor_list(SliceNameList,?ACTOR_TYPE_MONSTER) ->
    get_slice_actor_list(SliceNameList,?ACTOR_TYPE_MONSTER,[]);
get_slice_actor_list(SliceNameList,?ACTOR_TYPE_AVATAR) ->
    get_slice_actor_list(SliceNameList,?ACTOR_TYPE_AVATAR,[]);
get_slice_actor_list(_SliceNameList,_ActorType) ->
    [].

get_slice_actor_list([],_ActorType,ActorIdList) ->
    ActorIdList;
get_slice_actor_list([SliceName|SliceNameList],ActorType,ActorIdList) ->
    case get_slice_actor(SliceName,ActorType) of
        undefined ->
            get_slice_actor_list(SliceNameList,ActorType,ActorIdList);
        AddActorIdList ->
            get_slice_actor_list(SliceNameList,ActorType,AddActorIdList ++ ActorIdList)
    end.
