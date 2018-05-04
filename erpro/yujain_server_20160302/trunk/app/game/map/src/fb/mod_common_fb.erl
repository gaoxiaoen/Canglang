%%-------------------------------------------------------------------
%% File              :mod_common_fb.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-11
%% @doc
%%     副本公共模块
%% @end
%%-------------------------------------------------------------------


-module(mod_common_fb).

-include("mgeem.hrl").


-export([handle/1,
         init/1,
         loop/0,
         role_map_enter/2,
         role_online/1,
         role_offline/1
         ]).

%% msg router handle function

handle({role_fb_enter,Info}) ->
    do_fb_enter(Info);

handle({role_fb_quit,{Module,?FB_QUIT,DataRecord,RoleId,PId}}) ->
    do_fb_quit(Module,?FB_QUIT,DataRecord,RoleId,PId);

handle({?FB,?FB_MONSTER,DataRecord,RoleId,PId,_Line}) ->
    do_fb_monster(?FB,?FB_MONSTER,DataRecord,RoleId,PId);

handle({close_fb_notify,Info}) ->
    do_close_fb_notify(Info);
handle({close_fb}) ->
    do_close_fb();

handle({kill_process}) ->
    erlang:exit(erlang:self(), fb_map_process_close);

handle(Info) ->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 地图创建初始化副本数据
init(FbId) ->
    case cfg_fb:find(FbId) of
        undefined ->
            ignore;
        _ ->
            FbDict = #r_fb_dict{fb_id=FbId},
            set_fb_dict(FbDict),
            init_fb_monster(FbId)
    end,    
    ok.
init_fb_monster(FbId) ->
    case cfg_fb_monster:find(FbId) of
        undefined ->
            ignore;
        #r_fb_monster{born_type=BornType,
                      wait_interval=WaitInterval,
                      born_interval=BornInterval,
                      monster_level=MonsterLevel} ->
            case BornType of
                ?FB_BORN_TYPE_NONE -> OrderId = 0;
                ?FB_BORN_TYPE_BATCH_1 -> OrderId = 1;
                ?FB_BORN_TYPE_BATCH_2 -> OrderId = 1;
                ?FB_BORN_TYPE_BATCH_3 -> OrderId = 1;
                ?FB_BORN_TYPE_BATCH_4 -> OrderId = 1;
                _ -> OrderId = 0
            end,
            NowSeconds = common_tool:now(),
            FbMonsterDict = #r_fb_monster_dict{born_type=BornType,
                                               born_interval=BornInterval,
                                               born_time=NowSeconds + WaitInterval,
                                               monster_level=MonsterLevel,
                                               order_id=OrderId,
                                               born_status=?FB_MONSTER_BORN_STATUS_INIT},
            set_fb_monster_dict(FbMonsterDict)
    end.
            
%% 地图每秒循环
loop() ->
    #r_map_state{fb_id=FbId,status=MapStatus} = MapState = mgeem_map:get_map_state(),
    case cfg_fb:find(FbId) of
        undefined ->
            ignore;
        FbInfo -> %% 副本进程
            NowSeconds = mgeem_map:get_now(),
            if MapStatus == ?MAP_PROCESS_STATUS_RUNNING ->
                   catch loop_monster(FbId,NowSeconds),
                   catch loop2(FbInfo,NowSeconds,MapState);
               MapStatus == ?MAP_PROCESS_STATUS_COUNTDOWN ->
                   catch loop2(FbInfo,NowSeconds,MapState);
               true ->
                    next
            end
    end.
%% 副本循环，即当每一个玩家进入地图之后开始每秒循环处理
loop2(FbInfo,NowSeconds,MapState) ->
    %% 检查副本是否到关闭时间了，然后踢人并关闭副本
    #r_map_state{status=MapStatus} = MapState,
    FbDict = get_fb_dict(),
    #r_map_state{create_time=CreateTime} = MapState,
    #r_fb_dict{fb_id=FbId,fb_roles=FbRoleDictList} = FbDict,
    #r_fb_info{max_time=MaxTime, protect_time=ProtectTime,countdown=Countdown} = FbInfo,
    case get_fb_monster_dict() of
        undefined ->
            BornStatus = ?FB_MONSTER_BORN_STATUS_DONE; 
        #r_fb_monster_dict{born_status=?FB_MONSTER_BORN_STATUS_DONE} ->
            BornStatus = ?FB_MONSTER_BORN_STATUS_DONE;
        #r_fb_monster_dict{born_status=BornStatus} ->
            next
    end,
    %% 副本结束，踢人，关闭
    case MaxTime =/= 0 
         andalso MapStatus == ?MAP_PROCESS_STATUS_RUNNING
         andalso BornStatus == ?FB_MONSTER_BORN_STATUS_DONE 
         andalso [] == mod_map_monster:get_monster_id_list() of
        true ->
            case Countdown > 0 of
                true -> %% 副本结束，延迟3秒通知前端，再延迟Countdown秒自动结束副本
                    erlang:send_after(3000, erlang:self(), {mod,mod_common_fb,{close_fb_notify,{FbId,Countdown}}}),
                    mgeem_map:set_map_state(MapState#r_map_state{status=?MAP_PROCESS_STATUS_COUNTDOWN});
                _ ->
                    do_kick_role(FbDict)
            end,
            erlang:throw({ok});
        _ ->
            next
    end,
    %%副本时间到，需要关闭副本
    case MaxTime =/= 0 andalso NowSeconds - CreateTime > MaxTime of
        true -> 
            do_kick_role(FbDict),
            erlang:throw({ok});
        _ ->
            next
    end,
    %% 判断当前地图是否有玩家
    case MaxTime =/= 0  andalso mod_map:get_in_map_role() == [] of
        true ->
            %% 判断当前副本是不是还有离线的玩家
            case lists:foldl(
                   fun(#r_fb_role_dict{offline_time=OfflineTime},AccCheck) -> 
                           case AccCheck == true
                               andalso OfflineTime =/= 0 
                               andalso NowSeconds - OfflineTime < ProtectTime of
                               true ->
                                   false;
                               _ ->
                                   AccCheck
                           end
                   end, true, FbRoleDictList) of
                true ->  %% 可以关闭副本
                    mgeem_map:set_map_state(MapState#r_map_state{status=?MAP_PROCESS_STATUS_CLOSE});
                _ ->
                    next
            end;
        _ ->
            next
    end,
    ok.
do_close_fb_notify({FbId,Countdown}) ->
    RoleIdList = mod_map:get_in_map_role(),
    SendSelf = #m_fb_done_toc{fb_id=FbId,status=0,countdown=Countdown},
    mod_map:broadcast(RoleIdList, ?FB, ?FB_DONE, SendSelf),
    Msg = {mod,mod_common_fb,{close_fb}},
    erlang:send_after(Countdown * 1000, erlang:self(), Msg),
    ok.
do_close_fb() ->
    FbDict = get_fb_dict(),
    do_kick_role(FbDict),
    ok.
%% 副本怪物逻辑处理
loop_monster(FbId,NowSeconds) ->
    case cfg_fb_monster:find(FbId) of
        undefined ->
            FbMonsterInfo = undefined,
            erlang:throw(ignore);
        FbMonsterInfo ->
            next
    end,
    case get_fb_monster_dict() of
        undefined ->
            FbMonsterDict = undefined,
            erlang:throw(ignore);
        #r_fb_monster_dict{born_status=?FB_MONSTER_BORN_STATUS_DONE} ->
            FbMonsterDict = undefined,
            erlang:throw(ignore);
        FbMonsterDict ->
            next
    end,
    #r_fb_monster_dict{born_type=BornType,born_time=BornTime} = FbMonsterDict,
    MonsterIdList = mod_map_monster:get_monster_id_list(),
    case BornType == ?FB_BORN_TYPE_BATCH_1
         orelse BornType == ?FB_BORN_TYPE_BATCH_2 of
        true ->
            case MonsterIdList of
                [] ->
                    next;
                _ ->
                    erlang:throw(ignore)
            end;
        _ ->
            next
    end,
    #r_fb_dict{monster_level=MonsterLevel} = get_fb_dict(),
    case BornTime =/= 0 andalso NowSeconds > BornTime of
        true ->  %% 出生怪物
            #r_fb_monster{monsters=MonsterList} = FbMonsterInfo,
            loop_monster2(FbId,NowSeconds,FbMonsterDict,MonsterLevel,MonsterList);
        _ ->
            case BornType == ?FB_BORN_TYPE_BATCH_4 andalso MonsterIdList == [] of
                true ->
                    #r_fb_monster{monsters=MonsterList} = FbMonsterInfo,
                    loop_monster2(FbId,NowSeconds,FbMonsterDict,MonsterLevel,MonsterList);
                _ ->
                    next
            end
    end,
    ok.
loop_monster2(FbId,NowSeconds,FbMonsterDict,MonsterLevel,MonsterList) ->
    #r_fb_monster_dict{born_type=BornType,
                       born_interval=BornInterval,
                       monster_level=PMonsterLevel,
                       order_id=OrderId} = FbMonsterDict,
    case PMonsterLevel == 0 of
        true ->
            Level = MonsterLevel;
        _ ->
            Level = PMonsterLevel
    end,
    case lists:keyfind(OrderId, #r_fb_monster_sub.order_id, MonsterList) of
        false ->
            Monsters = [],
            set_fb_monster_dict(FbMonsterDict#r_fb_monster_dict{born_time=0}),
            erlang:throw(ignore);
        #r_fb_monster_sub{monsters=Monsters} ->
            next
    end,
    %% 怪物出生
    case FbId of
        30001 ->
            RebornType = ?MONSTER_REBORN_TYPE_REVIVE;
        _ ->
            RebornType = ?MONSTER_REBORN_TYPE_NORMAL
    end,
    [begin 
         #r_monster_info{type_id=TypeId} = cfg_monster:find(TypeCode,Level),
         MonsterParam = #r_monster_param{type_id = TypeId,
                                         reborn_type = RebornType,
                                         dead_fun = undefined,
                                         group_id = -1,
                                         pos = #p_pos{x=X,y=Y},
                                         dir=Dir},
         mod_map_monster:init_monster(MonsterParam),
         ok
     end
    || #r_fb_monster_item{type_code=TypeCode,x=X,y=Y,dir=Dir} <- lists:reverse(Monsters)],
    case BornType of
        ?FB_BORN_TYPE_NONE -> %% 直接出生
            set_fb_monster_dict(FbMonsterDict#r_fb_monster_dict{born_time=0,born_status=?FB_MONSTER_BORN_STATUS_DONE}),
            erlang:throw(ignore); 
        _ -> 
            next
    end,
    BornTime = NowSeconds + BornInterval,
    case lists:keyfind(OrderId + 1, #r_fb_monster_sub.order_id, MonsterList) of
        false ->
            BornStatus = ?FB_MONSTER_BORN_STATUS_DONE;
        _ ->
            BornStatus = ?FB_MONSTER_BORN_STATUS_IN
    end,
    NewFbMonsterDict = FbMonsterDict#r_fb_monster_dict{born_time=BornTime,order_id=OrderId + 1,born_status=BornStatus},
    set_fb_monster_dict(NewFbMonsterDict),
    ok.
%% 踢玩家离线，并关闭副本
do_kick_role(FbDict) ->
    case mod_map:get_in_map_role() of
        [] ->
            next;
        RoleIdList ->
            #r_fb_dict{fb_id=FbId,fb_roles=FbRoleDictList} = FbDict,
            #r_fb_info{create_avatar=CreateAvatar} = cfg_fb:find(FbId),
            do_kick_role(RoleIdList,CreateAvatar,FbRoleDictList)
    end,
    MapState = mgeem_map:get_map_state(),
    mgeem_map:set_map_state(MapState#r_map_state{status=?MAP_PROCESS_STATUS_CLOSE}),
    ok.
do_kick_role([],_CreateAvatar,_FbRoleDictList) ->
    ok;
do_kick_role([RoleId | RoleIdList],CreateAvatar,FbRoleDictList) ->
    FbRoleDict = lists:keyfind(RoleId, #r_fb_role_dict.role_id, FbRoleDictList),
    #r_fb_role_dict{from_map_id=FromMapId,
                    from_map_process_name=FromMapProcessName,
                    from_map_pid=FromMapPId,
                    from_pos=#p_pos{x=X, y=Y}} = FbRoleDict,
    
    %% 删除镜像
    case CreateAvatar of
        ?FB_CREATE_AVATAR_YES ->
            AvatarId = common_misc:get_map_avatar_id_by_id(RoleId),
            FromMapPId ! {mod,mod_map_avatar,{del_avatar,AvatarId}};
        _ ->
            next
    end,
    
     %% 玩家死亡状态下退出副本，需要处理血量和魔法值
    #r_map_actor{attr = Attr} = MapRole = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
    #p_fight_attr{max_hp=MaxHp,hp=OldHp,mp=Mp,anger=Anger} = Attr,
    PId = mod_map_role:get_role_gateway_pid(RoleId),
    case OldHp > 0 of
        true ->
            next;
        _ ->
            Hp = erlang:trunc(MaxHp * 0.5),
            NewAttr = Attr#p_fight_attr{hp=Hp},
            mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapRole#r_map_actor{attr=NewAttr}),
            mod_fight_misc:update_actor_info_attr(RoleId, ?ACTOR_TYPE_ROLE, NewAttr),
            %% 本人复活消息
            RoleReliveToc = #m_role_relive_toc{op_code= 0,role_id = RoleId,hp=Hp},
            common_misc:unicast(PId, ?ROLE, ?ROLE_RELIVE, RoleReliveToc),
            common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {role_relive,RoleId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}}}),
            next
    end,
    SendSelf = #m_fb_quit_toc{op_code=0},
    common_misc:unicast(PId,?FB,?FB_QUIT,SendSelf),
    %% 切换地图
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    RoleChangeMapInfo = #r_role_change_map{role_id=RoleId,
                                           map_id=FromMapId,
                                           map_process_name=FromMapProcessName,
                                           map_pid=FromMapPId, 
                                           tx=Tx,ty=Ty,x=X,y=Y,
                                           change_type=?MAP_CHANGE_TYPE_QUIT_FB,
                                           group_id = 0,
                                           take_data=[]},
    mod_map_role:do_map_enter(RoleId, RoleChangeMapInfo),
    mgeew_packet_logger:set_statistic_action(RoleId, clean),
    do_kick_role(RoleIdList,CreateAvatar,FbRoleDictList).
%% 玩家上线
role_online(RoleId) ->
    case get_fb_dict() of
        undefined ->
            next;
        #r_fb_dict{fb_id=FbId,fb_roles=FbRoleDictList} = FbDict ->
            case lists:keyfind(RoleId, #r_fb_role_dict.role_id, FbRoleDictList) of
                false ->
                    next;
                FbRoleDict ->
                    NewFbRoleDict = FbRoleDict#r_fb_role_dict{offline_time=0},
                    NewFbRoleDictList = [NewFbRoleDict | lists:keydelete(RoleId, #r_fb_role_dict.role_id, FbRoleDictList)],
                    set_fb_dict(FbDict#r_fb_dict{fb_roles=NewFbRoleDictList}),
                    %% 发送消息通知前端，当前是在那一个副本
                    case mod_map:get_role_world_pid(RoleId) of
                        undefined ->
                            common_misc:send_to_role(RoleId, {mod,mod_fb,{fb_role_online,{ok,RoleId,FbId}}});
                        WorldRolePId ->
                            WorldRolePId ! {mod,mod_fb,{fb_role_online,{ok,RoleId,FbId}}}
                    end,
                    next
            end
    end,  
    ok.
%% 有玩家在副本过程中离线了
role_offline(RoleId) ->
    case get_fb_dict() of
        undefined ->
            next;
        #r_fb_dict{fb_roles=FbRoleDictList} = FbDict ->
            case lists:keyfind(RoleId, #r_fb_role_dict.role_id, FbRoleDictList) of
                false ->
                    next;
                FbRoleDict ->
                    NowSeconds = mgeem_map:get_now(),
                    NewFbRoleDict = FbRoleDict#r_fb_role_dict{offline_time=NowSeconds},
                    NewFbRoleDictList = [NewFbRoleDict | lists:keydelete(RoleId, #r_fb_role_dict.role_id, FbRoleDictList)],
                    set_fb_dict(FbDict#r_fb_dict{fb_roles=NewFbRoleDictList})
            end
    end,    
    ok.
%% 查询副本怪物位置信息接口处理
do_fb_monster(Module,Method,_DataRecord,_RoleId,PId) ->
    case catch do_fb_monster2() of
        {ok,PosList} ->
            SendSelf = #m_fb_monster_toc{op_code=0,pos_list=PosList};
        {error,OpCode} ->
            SendSelf = #m_fb_monster_toc{op_code=OpCode}
    end,
    common_misc:unicast(PId, Module, Method, SendSelf),
    ok.
do_fb_monster2() ->
    #r_map_state{map_type=MapType} = mgeem_map:get_map_state(),
    case MapType of
        ?MAP_TYPE_FB ->
            next;
        _ ->
            erlang:throw({error,?_RC_FB_MONSTER_000})
    end,
    %% TODO需要判断当前副本怪物状态，是否已经清除所有怪物
    case mod_map_monster:get_monster_id_list() of
        [] ->
            MonsterIdList = [],
            erlang:throw({ok,[]});
        MonsterIdList ->
            next
    end,
    PosList = 
        lists:foldl(
          fun(MonsterId,AccPosList) -> 
                  case mod_map:get_actor_info(MonsterId, ?ACTOR_TYPE_MONSTER) of
                      #p_map_monster{pos=Pos} ->
                          [Pos | AccPosList];
                      _ ->
                          AccPosList
                  end
          end, [], MonsterIdList),
    {ok,PosList}.
%% 进入副本地图
do_fb_enter({RoleId,FbId}) ->
    case catch do_fb_enter2(RoleId,FbId) of
        {ok,RoleChangeMapInfo} ->
            do_fb_enter3(RoleId,FbId,RoleChangeMapInfo);
        {error,OpCode} ->
            do_fb_enter_error(RoleId,FbId,OpCode)
    end.
do_fb_enter2(RoleId,FbId) ->
    #r_map_state{map_type=MapType,
                 map_id=FromMapId,
                 map_pid=FromMapPId,
                 map_process_name=FromMapProcessName} = mgeem_map:get_map_state(),
    case MapType of
        ?MAP_TYPE_FB ->
            erlang:throw({error,?_RC_FB_ENTER_009});
        _ ->
            next
    end,
    #r_fb_info{map_id=DestMapId,
               fb_module=FbModule,
               create_map_process_type=CreateMapProcessType,
               create_avatar=CreateAvatar} = cfg_fb:find(FbId),
    case cfg_map:get_map_info(DestMapId) of
        [DestMapInfo] ->
            next;
        _ ->
            DestMapInfo=undefined,
            erlang:throw({error,?_RC_FB_ENTER_007})
    end,
    #r_map_info{mcm_module=McmModule} = DestMapInfo,
    case McmModule:get_map_bron_point(DestMapId) of
        [{DestX,DestY}] ->
            next;
        _ ->
            DestX = 0,DestY = 0,
            erlang:throw({error,?_RC_FB_ENTER_008})
    end,
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            MapRoleInfo = undefined,
            erlang:throw({error,?_RC_FB_ENTER_000});
        MapRoleInfo ->
            next
    end,
    DestMapProcessName = FbModule:get_fb_map_name(FbId),
    case FbModule of
        mod_map_battlefield_fb ->
            next;
        _ ->
            case CreateMapProcessType of
                ?FB_CREATE_MAP_PROCESS_TYPE_YES ->
                    case erlang:whereis(DestMapProcessName) of
                        undefined ->
                            erlang:throw({error,?_RC_FB_ENTER_000});
                        _ ->
                            next
                    end;
                _ ->
                    case erlang:whereis(DestMapProcessName) of
                        undefined ->
                            next;
                        _ ->
                            erlang:throw({error,?_RC_FB_ENTER_000})
                    end
            end
    end,
    #p_map_role{role_name=RoleName,
                family_id=FamilyId,
                family_name=FamilyName,
                skin=Skin,
                pos=Pos} = MapRoleInfo,
    %% 处理入口镜像
    case CreateAvatar of
        ?FB_CREATE_AVATAR_YES ->
            MapAvatarInfo = #p_map_avatar{avatar_id=common_misc:get_map_avatar_id_by_id(RoleId),
                                          role_id=RoleId,
                                          role_name=RoleName,
                                          family_id=FamilyId,
                                          family_name=FamilyName,
                                          pos=Pos,
                                          skin=Skin};
        _ ->
            MapAvatarInfo = undefined
    end,
    %% TODO 是否组队进入 
    case FbModule of
        mod_map_battlefield_fb ->
            case erlang:whereis(DestMapProcessName) of
                DestMapPId when erlang:is_pid(DestMapPId) ->
                    next;
                _ ->
                    %% 创建副本地图
                    case supervisor:start_child(mgeem_map_sup, [{DestMapProcessName,DestMapId,FbId}]) of
                        {ok, DestMapPId} ->
                            ok;
                        {error, Reason} ->
                            DestMapPId = undefined,
                            ?ERROR_MSG("~ts ~w ~ts,MapProcessName=~w,RoleId=~w,FbId=~w,Error=~w", 
                                       [?_LANG_MAP_007,DestMapId,?_LANG_FAILURE,DestMapProcessName,RoleId,FbId,Reason]),
                            erlang:throw({error,?_RC_FB_ENTER_006})
                    end
            end;
        _ ->
            case CreateMapProcessType of
                ?FB_CREATE_MAP_PROCESS_TYPE_YES ->
                    case erlang:whereis(DestMapProcessName) of
                        DestMapPId when erlang:is_pid(DestMapPId) ->
                            next;
                        _ ->
                            DestMapPId = undefined,
                            erlang:throw({error,?_RC_FB_ENTER_006})
                    end;
                _ ->
                    %% 创建副本地图
                    case supervisor:start_child(mgeem_map_sup, [{DestMapProcessName,DestMapId,FbId}]) of
                        {ok, DestMapPId} ->
                            ok;
                        {error, Reason} ->
                            DestMapPId = undefined,
                            ?ERROR_MSG("~ts ~w ~ts,MapProcessName=~w,RoleId=~w,FbId=~w,Error=~w", 
                                       [?_LANG_MAP_007,DestMapId,?_LANG_FAILURE,DestMapProcessName,RoleId,FbId,Reason]),
                            erlang:throw({error,?_RC_FB_ENTER_006})
                    end
            end
    end,
    {DestTx,DestTy} = mod_map_slice:to_tile_pos(DestX,DestY),
    FbRoleDict = #r_fb_role_dict{role_id=RoleId,
                                 from_map_id=FromMapId,
                                 from_map_pid=FromMapPId,
                                 from_map_process_name=FromMapProcessName,
                                 from_pos=Pos},
    MonsterLevel = 1,
    TakeData = [{create_avatar,MapAvatarInfo},
                {fb_id,FbId},
                {fb_role_dict,FbRoleDict},
                {fb_monster_level,MonsterLevel}],
    %% 测试时使用，即进入副本分阵营
    case FbId of
        30001 ->
            GroupId = MapRoleInfo#p_map_role.category;
        30002 ->
            GroupId = 1;
        30003 ->
            GroupId = 1;
        _ ->
            GroupId = 0
    end,
    RoleChangeMapInfo = #r_role_change_map{role_id=RoleId,
                                           map_id=DestMapId,
                                           map_process_name=DestMapProcessName,
                                           map_pid=DestMapPId, 
                                           tx=DestTx,ty=DestTy,x=DestX,y=DestY,
                                           change_type=?MAP_CHANGE_TYPE_ENTER_FB,
                                           group_id=GroupId,
                                           take_data=TakeData},
    
    {ok,RoleChangeMapInfo}.
do_fb_enter3(RoleId,FbId,RoleChangeMapInfo) ->
    %% 返回玩家进程
    case mod_map:get_role_world_pid(RoleId) of
        undefined ->
            common_misc:send_to_role(RoleId, {mod,mod_fb,{fb_enter_reply,{ok,RoleId,FbId}}});
        WorldRolePId ->
            WorldRolePId ! {mod,mod_fb,{fb_enter_reply,{ok,RoleId,FbId}}}
    end,
    %% 跳转进入副本
    mod_map_role:do_map_enter(RoleId, RoleChangeMapInfo),
    ok.

%% 在副本地图进程处理副本相关数据
role_map_enter(RoleId,ExtInfo) ->
    #r_map_state{fb_id=FbId} = MapState = mgeem_map:get_map_state(),
    catch role_map_enter2(RoleId,ExtInfo,MapState),
    case mod_map:get_actor_info(RoleId, ?ACTOR_TYPE_ROLE) of
        undefined ->
            AttrList = [];
        #p_map_role{group_id=GroupId} ->
            #r_map_actor{attr=#p_fight_attr{anger=Anger}} = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
            AttrList = [#p_attr{uid=RoleId,attr_code=?MAP_ROLE_GROUP_ID,int_value=GroupId},
                        #p_attr{uid=RoleId,attr_code=?FIGHT_ATTR_ANGER,int_value=Anger}]
    end,
    PetId = mod_map:get_map_role_pet_id(RoleId),
    case mod_map:get_actor_info(PetId, ?ACTOR_TYPE_PET) of
        undefined ->
            NewAttrList = AttrList;
        #p_map_pet{group_id=PetGroupId} ->
            #r_map_actor{attr=#p_fight_attr{anger=PetAnger}} = mod_map:get_map_actor(PetId, ?ACTOR_TYPE_PET),
            NewAttrList = [#p_attr{uid=PetId,attr_code=?MAP_ROLE_GROUP_ID,int_value=PetGroupId},
                           #p_attr{uid=PetId,attr_code=?FIGHT_ATTR_ANGER,int_value=PetAnger} | AttrList]
    end,
    case NewAttrList of
        [] ->
            ignore;
        _ ->
            SendSelf = #m_role_attr_change_toc{op_type=0,attr_list=NewAttrList},
            RoleGatewayPId = mod_map_role:get_role_gateway_pid(RoleId),
            common_misc:unicast(RoleGatewayPId, ?ROLE, ?ROLE_ATTR_CHANGE, SendSelf)
    end,
    #r_fb_info{fb_module=FbModule} = cfg_fb:find(FbId),
    FbModule:role_map_enter(RoleId,FbId),
    ok.
role_map_enter2(RoleId,ExtInfo,MapState) ->
    #r_map_state{map_type=MapType,fb_id=FbId,status=Status} = MapState,
    case MapType == ?MAP_TYPE_FB andalso FbId =/= 0  of
        true ->
            next;
        _ ->
            erlang:throw({ignore})
    end,
    case lists:keyfind(fb_id, 1, ExtInfo) of
        {fb_id,FbId} ->
            next;
        _ ->
            erlang:throw({ignore})
    end,
    case lists:keyfind(fb_role_dict, 1, ExtInfo) of
        {fb_role_dict,FbRole} ->
            next;
        _ ->
            FbRole = undefined,
            erlang:throw({ignore})
    end,
    #r_fb_dict{fb_roles=FbRoles,monster_level=PMonsterLevel} = FbDict = get_fb_dict(),
    case lists:keyfind(RoleId, #r_fb_role_dict.role_id, FbRoles) of
        false ->
            NewFbRoles = [FbRole|FbRoles];
        _ ->
            NewFbRoles = [FbRole|lists:keydelete(RoleId, #r_fb_role_dict.role_id, FbRoles)]
    end,
    case lists:keyfind(fb_monster_level, 1, ExtInfo) of
        {fb_monster_level,FbMonsterLevel} ->
            next;
        _ ->
            FbMonsterLevel = 0
    end,
    case PMonsterLevel == 0 andalso FbMonsterLevel =/= 0 of
        true ->
            set_fb_dict(FbDict#r_fb_dict{fb_roles=NewFbRoles,monster_level=FbMonsterLevel});
        _ ->
            set_fb_dict(FbDict#r_fb_dict{fb_roles=NewFbRoles})
    end,
    #r_fb_role_dict{from_map_pid=FromMapPId} = FbRole,
    %% 副本地图入口生成镜像
    case lists:keyfind(create_avatar, 1, ExtInfo) of
        {create_avatar,undefined} ->
            next;
        {create_avatar,MapAvatarInfo} ->
            FromMapPId ! {mod,mod_map_avatar,{init_avatar,MapAvatarInfo}};
        _ ->
            next
    end,
    %% 地图进程开始运行
    case Status of
        ?MAP_PROCESS_STATUS_INIT ->
            NewMapState = MapState#r_map_state{status=?MAP_PROCESS_STATUS_RUNNING},
            mgeem_map:set_map_state(NewMapState);
        _ ->
            next
    end,
    ok.

do_fb_enter_error(RoleId,FbId,OpCode) ->
    case mod_map:get_role_world_pid(RoleId) of
        undefined ->
            common_misc:send_to_role(RoleId, {mod,mod_fb,{fb_enter_reply,{error,RoleId,FbId,OpCode}}});
        WorldRolePId ->
            WorldRolePId ! {mod,mod_fb,{fb_enter_reply,{error,RoleId,FbId,OpCode}}}
    end.

%% 退出副本
do_fb_quit(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_fb_quit2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_fb_quit_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,FbDict,FbRoleDict} ->
            do_fb_quit3(Module,Method,DataRecord,RoleId,PId,FbDict,FbRoleDict)
    end.
do_fb_quit2(RoleId,DataRecord) ->
    case get_fb_dict() of
        undefined ->
            FbDict = undefined,
            erlang:throw({error,?_RC_FB_QUIT_000});
        FbDict ->
            next
    end,
    #r_fb_dict{fb_id=FbId,fb_roles=FbRoleDictList} = FbDict,
    case DataRecord#m_fb_quit_tos.fb_id of
        FbId ->
            next;
        _ ->
            erlang:throw({error,?_RC_FB_QUIT_002})
    end,
    FbRoleDict = lists:keyfind(RoleId, #r_fb_role_dict.role_id, FbRoleDictList),
    {ok,FbDict,FbRoleDict}.

do_fb_quit3(Module,Method,_DataRecord,RoleId,PId,FbDict,FbRoleDict) ->
    #r_fb_dict{fb_id=FbId} = FbDict,
    #r_fb_role_dict{from_map_id=FromMapId,
                    from_map_process_name=FromMapProcessName,
                    from_map_pid=FromMapPId,
                    from_pos=#p_pos{x=X, y=Y}} = FbRoleDict,
    %% 去掉推送，直接使用m_map_enter_toc{}消息处理
    SendSelf = #m_fb_quit_toc{op_code=0},
    ?DEBUG("do fb quit info succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf),
    
    
    #r_fb_info{create_avatar=CreateAvatar} = cfg_fb:find(FbId),
    %% 删除镜像
    case CreateAvatar of
        ?FB_CREATE_AVATAR_YES ->
            AvatarId = common_misc:get_map_avatar_id_by_id(RoleId),
            FromMapPId ! {mod,mod_map_avatar,{del_avatar,AvatarId}};
        _ ->
            next
    end,
    
    %% 玩家死亡状态下退出副本，需要处理血量和魔法值
    #r_map_actor{attr = Attr} = MapRole = mod_map:get_map_actor(RoleId, ?ACTOR_TYPE_ROLE),
    #p_fight_attr{max_hp=MaxHp,hp=OldHp,mp=Mp,anger=Anger} = Attr,
    case OldHp > 0 of
        true ->
            next;
        _ ->
            Hp = erlang:trunc(MaxHp * 0.5),
            NewAttr = Attr#p_fight_attr{hp=Hp},
            mod_map:set_map_actor(RoleId, ?ACTOR_TYPE_ROLE, MapRole#r_map_actor{attr=NewAttr}),
            mod_fight_misc:update_actor_info_attr(RoleId, ?ACTOR_TYPE_ROLE, NewAttr),
            %% 本人复活消息
            RoleReliveToc = #m_role_relive_toc{op_code= 0,role_id = RoleId,hp=Hp},
            common_misc:unicast(PId, ?ROLE, ?ROLE_RELIVE, RoleReliveToc),
            common_misc:send_to_role(RoleId, {mod, mod_role_bi, {sync_map_actor, {role_relive,RoleId, ?ACTOR_TYPE_ROLE, Hp, Mp, Anger}}}),
            next
    end,
    
    %% 切换地图
    {Tx,Ty} = mod_map_slice:to_tile_pos(X, Y),
    RoleChangeMapInfo = #r_role_change_map{role_id=RoleId,
                                           map_id=FromMapId,
                                           map_process_name=FromMapProcessName,
                                           map_pid=FromMapPId, 
                                           tx=Tx,ty=Ty,x=X,y=Y,
                                           change_type=?MAP_CHANGE_TYPE_QUIT_FB,
                                           group_id = 0,
                                           take_data=[]},
    mod_map_role:do_map_enter(RoleId, RoleChangeMapInfo),
    mgeew_packet_logger:set_statistic_action(RoleId, clean),
    ok.

do_fb_quit_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    PId ! enter_fb_map_fail,
    SendSelf = #m_fb_query_toc{op_code=OpCode},
    ?DEBUG("do fb quit info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).


%%-------------------------------------------------------------------
%%
%% dict function
%%
%%-------------------------------------------------------------------
-spec
get_fb_dict() -> FbDict | undefined when
    FbDict :: #r_fb_dict{}.
get_fb_dict() ->
    erlang:get(fb_dict).
-spec
set_fb_dict(FbDict) -> OldFbDict | undefined when
    FbDict :: #r_fb_dict{},
    OldFbDict :: #r_fb_dict{}.
set_fb_dict(FbDict) ->
    erlang:put(fb_dict, FbDict).

-spec
get_fb_monster_dict() -> FbMonsterDict | undefined when
    FbMonsterDict :: #r_fb_monster_dict{}.
get_fb_monster_dict() ->
    erlang:get(fb_monster_dict).
-spec
set_fb_monster_dict(FbMonsterDict) -> OldFbMonsterDict | undefined when
    FbMonsterDict :: #r_fb_monster_dict{},
    OldFbMonsterDict :: #r_fb_monster_dict{}.
set_fb_monster_dict(FbMonsterDict) ->
    erlang:put(fb_monster_dict, FbMonsterDict).