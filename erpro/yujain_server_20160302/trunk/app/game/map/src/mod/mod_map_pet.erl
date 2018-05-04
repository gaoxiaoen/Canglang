%%-------------------------------------------------------------------
%% File              :mod_map_pet.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-10-22
%% @doc
%%     地图宠物模块处理
%% @end
%%-------------------------------------------------------------------


-module(mod_map_pet).

-include("mgeem.hrl").



%% ====================================================================
%% API functions
%% ====================================================================
-export([handle/1,
         hook_pet_dead/1,
         role_offline/1,
         check_pet_display/2,
         role_map_enter_confirm/1]).

handle({pet_battle_pre,Info}) ->
    do_pet_battle_pre(Info);
handle({pet_battle,Info}) ->
    do_pet_battle(Info);

handle({pet_back,Info}) ->
    do_pet_back(Info);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 玩家下线，玩家携带的出战宠物处理
role_offline(_RoleId) ->
    
    ok.
%% 切换地图时，前端已经确认玩家进入新地图
role_map_enter_confirm(RoleId) ->
    PetId =  mod_map:get_map_role_pet_id(RoleId),
    #r_map_state{map_type=MapType} = mgeem_map:get_map_state(),
    case MapType == ?MAP_TYPE_NORMAL andalso PetId == 0 of
        true -> %% 需要自动出战斗宠物
            RoleWorldPId = mod_map:get_role_world_pid(RoleId),
            common_misc:send_to_role(RoleWorldPId, {mod,mod_pet,{auto_battle_pet,RoleId}});
        _ ->
            ignore
    end.

%% 宠物攻击
hook_pet_dead({_ActorId,_ActorType,PetId,RoleId}) ->
    do_pet_back({RoleId,PetId,?PET_BACK_TYPE_DEAD}),
    ok.

do_pet_battle_pre({RoleId,PetId}) ->
    case catch do_pet_battle_pre2(RoleId,PetId) of
        {error,OpCode} ->
            Msg = {error,RoleId,PetId,OpCode};
        ok ->
            Msg = {ok,RoleId,PetId}
    end,
    %% 返回玩家进程
    case mod_map:get_role_world_pid(RoleId) of
        undefined ->
            common_misc:send_to_role(RoleId, {mod,mod_pet,{pet_battle_reply,Msg}});
        WorldRolePId ->
            WorldRolePId ! {mod,mod_pet,{pet_battle_reply,Msg}}
    end.
do_pet_battle_pre2(RoleId,PetId) ->
     #r_map_state{map_type=MapType} = mgeem_map:get_map_state(),
    case MapType of
        ?MAP_TYPE_FB ->
            case is_dead_pet(RoleId, PetId) of
                true ->
                    erlang:throw({error,?_RC_PET_BATTLE_007});
                _ ->
                    next
            end;
        _ ->
            next
    end,
    ok.
  
%% 宠物出战处理
do_pet_battle({RoleId,PetId,MapActor,MapPet}) ->
    case catch do_pet_battle2(RoleId) of
        {ok,MapRoleInfo} ->
            do_pet_battle3(RoleId,PetId,MapActor,MapPet,MapRoleInfo);
        Error ->
            ?ERROR_MSG("pet battle error.RoleId=~w,Error=~w,MapActor=~w,MapPet=~w",[RoleId,Error,MapActor,MapPet])
    end.
do_pet_battle2(RoleId) ->
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRoleInfo=undefined,
            erlang:throw({error,role_not_in_this_map});
        MapRoleInfo ->
            next
    end,
    {ok,MapRoleInfo}.
            
do_pet_battle3(RoleId,PetId,MapActor,MapPet,MapRoleInfo) ->
    #p_map_role{pos=#p_pos{x=X,y=Y},group_id=GroupId} = MapRoleInfo,
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    RoleMapPos = #p_map_pos{x=X,y=Y,tx=Tx,ty=Ty},
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    PetMapPos = gen_pet_born_pos_by_role_pos(McmModule,RoleMapPos),
    #p_map_pos{x=PetX,y=PetY,tx=PetTx,ty=PetTy} = PetMapPos,
    NewMapPet = MapPet#p_map_pet{pos=#p_pos{x=PetX,y=PetY},group_id=GroupId},
    mod_map:set_actor_info(PetId, ?ACTOR_TYPE_PET, NewMapPet),
    mod_map:set_map_actor(PetId, ?ACTOR_TYPE_PET, MapActor),
    mod_map:set_map_role_pet(RoleId, MapActor#r_map_actor.ext),
    
    [#r_map_slice{slice_name=PetSliceName}] = McmModule:get_slice_name({PetTx,PetTy}),
    mod_map:ref_tile_pos(PetId,?ACTOR_TYPE_PET,PetTx,PetTy),
    mod_map:join_slice(PetSliceName, PetId, ?ACTOR_TYPE_PET),
    
    case MapRoleInfo#p_map_role.status of
        ?ACTOR_STATUS_ROLE_LOADING_MAP ->
            next;
        _ ->
            SendSelf = #m_map_slice_enter_toc{pets=[NewMapPet]},
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            BCRoleIdList = lists:delete(RoleId,RoleIdList),
            %%?ERROR_MSG("RoleIdList=~w,BCRoleIdList=~w,SendSelf=~w",[RoleIdList,BCRoleIdList,SendSelf]),
            mod_map:broadcast(BCRoleIdList, ?MAP, ?MAP_SLICE_ENTER, SendSelf)
    end,
    ok.

%% 宠物收回
do_pet_back({RoleId,PetId}) ->
    catch do_pet_back2(RoleId,PetId,?PET_BACK_TYPE_NORMAL);
do_pet_back({RoleId,PetId,BackType}) -> 
    catch do_pet_back2(RoleId,PetId,BackType).
do_pet_back2(RoleId,PetId,BackType) ->
    case mod_map:get_map_role_pet(RoleId) of
        undefined ->
            MapRolePet = undefined,
            erlang:throw(ignore);
        MapRolePet ->
            next
    end,
    case MapRolePet#r_map_role_pet.battle_id of
        PetId ->
            next;
        _ ->
            erlang:throw(ignore)
    end,
    #r_map_state{mcm_module=McmModule} = mgeem_map:get_map_state(),
    case mod_map:get_actor_info(PetId,?ACTOR_TYPE_PET) of
        undefined ->
            next;
        #p_map_pet{pos=#p_pos{x=PetX,y=PetY}} ->
            case BackType of
                ?PET_BACK_TYPE_DEAD ->
                    add_dead_pet(RoleId, PetId);
                _ ->
                    next
            end,
            {PetTx,PetTy} = mod_map_slice:to_tile_pos(PetX, PetY),
            [#r_map_slice{slice_name=PetSliceName}] = McmModule:get_slice_name({PetTx,PetTy}),
            mod_map:leave_slice(PetSliceName, PetId, ?ACTOR_TYPE_PET),
            mod_map:deref_tile_pos(PetId, ?ACTOR_TYPE_PET, PetTx, PetTy),
            next
    end,
    mod_map:erase_map_role_pet(RoleId),
    mod_map:erase_actor_info(PetId, ?ACTOR_TYPE_PET),
    mod_map:erase_map_actor(PetId, ?ACTOR_TYPE_PET),
    
    case BackType of
        ?PET_BACK_TYPE_DEAD -> %% 宠物死亡收加不需要广播，已经通过战斗结果广播
            erlang:throw(ok);
        _ ->
            next
    end,
    case mod_map:get_actor_info(RoleId,?ACTOR_TYPE_ROLE) of
        undefined ->
            X = 0,Y = 0, Flag = false;
        #p_map_role{pos=#p_pos{x=X,y=Y}}->
            Flag = true
    end,
    case Flag of
        true ->
            {Tx,Ty}=mod_map_slice:to_tile_pos(X,Y),
            SendSelf = #m_map_slice_quit_toc{actor_type=?ACTOR_TYPE_PET,del_ids=[PetId]},
            [#r_map_slice{slice_9_list=Slice9List}] = McmModule:get_slice_name({Tx,Ty}),
            RoleIdList = mod_map:get_slice_role_list(Slice9List),
            BCRoleIdList = lists:delete(RoleId,RoleIdList),
            mod_map:broadcast(BCRoleIdList, ?MAP, ?MAP_SLICE_QUIT, SendSelf);
        _ ->
            next
    end,
    ok.

%% 根据人物的坐标计算出，宠物出生，即宠物出战时的坐标
%% RoleMapRos 角色地图位置信息 #p_map_pos{}
%% return #p_map_pos{}
gen_pet_born_pos_by_role_pos(McmModule,RoleMapPos) ->
    #p_map_pos{tx=Tx,ty=Ty}=RoleMapPos,
    {NewTx,NewTy}=gen_pet_born_pos_by_role_pos2(do,McmModule,Tx,Ty,2,2,{}),
    {NewX,NewY} = mod_map_slice:to_pixel_pos(NewTx, NewTy),
    #p_map_pos{x=NewX,y=NewY,tx=NewTx,ty=NewTy}.

gen_pet_born_pos_by_role_pos2(done,_McmModule,_Tx,_Ty,_StepX,_StepY,{NewTx,NewTy}) ->
    {NewTx,NewTy};
gen_pet_born_pos_by_role_pos2(do,McmModule,Tx,Ty,StepX,StepY,{}) ->
    case McmModule:get_slice_name({Tx + StepX,Ty + StepY}) of
        [#r_map_slice{type=?MAP_REF_TYPE_WALK}] ->
            gen_pet_born_pos_by_role_pos2(done,McmModule,Tx,Ty,StepX,StepY,{Tx + StepX,Ty + StepY});
        [#r_map_slice{type=?MAP_REF_TYPE_NOT_WALK}] ->
            gen_pet_born_pos_by_role_pos2(done,McmModule,Tx,Ty,StepX,StepY,{Tx + StepX,Ty + StepY});
        _ ->
            if StepX =:= 2 andalso StepY =:= 2 ->
                   NewStepX = 2,NewStepY = -2;
               StepX =:= 2 andalso StepY =:= -2 ->
                   NewStepX = -2,NewStepY = -2;
               StepX =:= -2 andalso StepY =:= -2 ->
                   NewStepX = -2,NewStepY = 2;
               true ->
                   NewStepX = 0,NewStepY = 0
            end,
            gen_pet_born_pos_by_role_pos2(do,McmModule,Tx,Ty,NewStepX,NewStepY,{})
    end.

%% 判断这个宠物是否需要在此场景显示
%% return false or true
check_pet_display(MapType,DisplayType) ->
    case DisplayType of
        ?PET_DISPLAY_TYPE_NORMAL ->
            true;
        ?PET_DISPLAY_TYPE_FB ->
            case MapType of
                ?MAP_TYPE_FB ->
                    true;
                _ ->
                    false
            end;
        _ ->
            false
    end.

is_dead_pet(RoleId,PetId) ->
    case erlang:get({dead_pet,RoleId,PetId}) of
        undefined -> false;
        _ -> true
    end.
add_dead_pet(RoleId,PetId) ->
    erlang:put({dead_pet,RoleId,PetId},1).
        
            