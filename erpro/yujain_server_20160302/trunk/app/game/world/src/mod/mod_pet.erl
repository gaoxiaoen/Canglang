%%-------------------------------------------------------------------
%% File              :mod_pet.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-10-20
%% @doc
%%     宠物模块
%% @end
%%-------------------------------------------------------------------


-module(mod_pet).

%%
%% Include files
%%
-include("mgeew.hrl").

%%
%% Exported Functions
%%
-export([
         handle/1,
         role_online/1,
         role_relive/1,
         role_dead/1,
         pet_dead/1,
         loop_ms/1,
         loop/1
        ]).

handle({Module,?PET_QUERY,DataRecord,RoleId,PId,_Line}) ->
    do_pet_query(Module,?PET_QUERY,DataRecord,RoleId,PId);

handle({Module,?PET_BATTLE,DataRecord,RoleId,PId,_Line}) ->
    do_pet_battle(Module,?PET_BATTLE,DataRecord,RoleId,PId);

handle({pet_battle_reply,Info}) ->
    do_pet_battle_reply(Info);

handle({Module,?PET_BACK,DataRecord,RoleId,PId,_Line}) ->
    do_pet_back(Module,?PET_BACK,DataRecord,RoleId,PId);

handle({Module,?PET_FREE,DataRecord,RoleId,PId,_Line}) ->
    do_pet_free(Module,?PET_FREE,DataRecord,RoleId,PId);

handle({pet_create,Info}) ->
    do_pet_create(Info);

handle({auto_battle_pet,RoleId}) ->
    do_auto_battle_pet(RoleId);

handle(Info)->
    ?ERROR_MSG("receive unknown message,Info=~w",[Info]).

%% 每200毫秒大循环
loop_ms(RoleId) ->
    do_loop_pet_buff(RoleId),
    ok.
%% 每秒大循环
loop(_RoleId) ->
    ok.

do_loop_pet_buff(RoleId) ->
    catch do_loop_pet_buff2(RoleId).

do_loop_pet_buff2(RoleId) ->
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw(ignore)
    end,
    #r_role_pet{battle_id=BattleId} = RolePet,
    case BattleId of
        0 ->
            erlang:throw(ignore);
        _ ->
            mod_buff:loop_ms(BattleId, ?ACTOR_TYPE_PET)
    end,
    ok.

%% 玩家上线宠物模块处理
role_online(RoleId) ->
    catch role_online2(RoleId).
role_online2(RoleId) ->
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw(ignore)
    end,
    #r_role_pet{is_has=IsHas,battle_id=BattleId,last_battle_id=LastBattleId} = RolePet,
    case IsHas of
        0 -> %% 玩家上线创建第一只宠物 todo
            case mod_role:get_role_base(RoleId) of
                {ok,#p_role_base{category=?CATEGORY_1}} ->
                    PetTypeId = 100000;
                {ok,#p_role_base{category=?CATEGORY_4}} ->
                    PetTypeId = 100001;
                _ ->
                    PetTypeId = 100000
            end,
            do_pet_create({RoleId,PetTypeId,?PET_VIA_CREATE_ROLE,?PET_BIND_TYPE_BIND}),
            erlang:throw(ok);
        _ ->
            next
    end,
    case get_pet_battle_lock(RoleId) of
        undefined ->
            next;
        _ ->
            erlang:throw(ignore)
    end,
    case mod_pet_data:get_pet(BattleId) of
        {ok,Pet} ->
            PetId = BattleId;
        _ ->
            case mod_pet_data:get_pet(LastBattleId) of
                {ok,Pet} ->
                    PetId = LastBattleId;
                _ ->
                    PetId = 0,
                    Pet = undefined,
                    erlang:throw(ignore)
            end
    end,
    
    NewRolePet = RolePet#r_role_pet{battle_id=0,last_battle_id=PetId},
    mod_pet_data:set_role_pet(RoleId,NewRolePet),
    do_pet_battle3(RoleId,RolePet,Pet),
    ok.
%% 玩家复活
role_relive(RoleId) ->
    catch do_auto_battle_pet(RoleId,role_relive).

do_auto_battle_pet(RoleId) ->
    catch do_auto_battle_pet(RoleId,change_map).

do_auto_battle_pet(RoleId,Type) ->
    case get_pet_battle_lock(RoleId) of
        undefined ->
            next;
        _ ->
            erlang:throw(ignore)
    end,
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw(ignore)
    end,
    #r_role_pet{last_battle_id=PetId} = RolePet,
    case mod_pet_data:get_pet(PetId) of
        {ok,Pet} ->
            next;
        _ ->
            Pet = undefined,
            erlang:throw(ignore)
    end,
    #r_pet{attr=Attr} = Pet,
    #p_fight_attr{max_hp=MaxHp,hp=Hp} = Attr,
    case Hp > 0 of
        true ->
            do_pet_battle3(RoleId,RolePet,Pet);
        _ ->
            CurHp = erlang:trunc(MaxHp * 0.5),
            NewAttr = Attr#p_fight_attr{hp=CurHp},
            NewPet = Pet#r_pet{attr=NewAttr},
            mod_pet_data:set_pet(PetId, NewPet),
            case Type of
                change_map ->
                    do_pet_battle3(RoleId,RolePet,NewPet);
                _ ->
                    ignore
            end
    end,
    ok.
%% 玩家死亡
role_dead(RoleId) ->
    {ok,#r_role_world_state{gateway_pid=GatewayPId}} = mgeew_role:get_role_world_state(),
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,#r_role_pet{battle_id=0}} ->
            next;
        {ok,#r_role_pet{battle_id=PetId}} ->
            do_pet_back(RoleId,GatewayPId,PetId,?PET_BACK_TYPE_NORMAL);
        _ ->
            next
    end,
    ok.
%% 宠物死亡
pet_dead(PetId) ->
    {ok,#r_role_world_state{role_id=RoleId,gateway_pid=GatewayPId}} = mgeew_role:get_role_world_state(),
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,#r_role_pet{battle_id=PetId}} ->
            do_pet_back(RoleId,GatewayPId,PetId,?PET_BACK_TYPE_DEAD);
        _ ->
            next
    end,
    ok.
%% 查询宠物信息
-define(pet_query_op_type_bag,1).          %% 1:查询携带宠物信息
-define(pet_query_op_type_depot,2).        %% 2:查询宠物仓库信息
-define(pet_query_op_type_pet,3).          %% 3:查询宠物信息
-define(pet_query_op_type_role_pet,4).     %% 4：查询玩家宠物基础信息
do_pet_query(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_pet_query2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_pet_query_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,SendSelf} ->
            do_pet_query3(Module,Method,DataRecord,RoleId,PId,SendSelf)
    end.
do_pet_query2(RoleId,DataRecord) ->
    case DataRecord#m_pet_query_tos.op_type of
        ?pet_query_op_type_bag ->
            next;
        ?pet_query_op_type_depot ->
            next;
        ?pet_query_op_type_pet ->
            case DataRecord#m_pet_query_tos.pet_id of
                0 ->
                    erlang:throw({error,?_RC_PET_QUERY_000});
                _ ->
                    next
            end;
        ?pet_query_op_type_role_pet ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_QUERY_000})
    end,
    case DataRecord#m_pet_query_tos.op_type of
        ?pet_query_op_type_bag ->
            SendSelf = #m_pet_query_toc{op_code=0,
                                        op_type=DataRecord#m_pet_query_tos.op_type,
                                        pets=mod_pet_data:get_role_bag_pets(RoleId)
                                       },
            erlang:throw({ok,SendSelf});
        ?pet_query_op_type_depot ->
            case mod_pet_data:get_pet_bag({RoleId,?PET_BAG_ID_DEPOT}) of
                {ok,#r_pet_bag{pets=PetIdList}} ->
                    Pets = [begin
                                 {ok,Pet} = mod_pet_data:get_pet(PetId),
                                 #p_pet_tiny{pet_id=PetId,
                                             pet_name=Pet#p_pet.pet_name,
                                             type_id=Pet#p_pet.type_id,
                                             bind=Pet#p_pet.bind}
                             end || PetId <- PetIdList],
                    SendSelf = #m_pet_query_toc{op_code=0,
                                        op_type=DataRecord#m_pet_query_tos.op_type,
                                        pets=Pets
                                       },
                    erlang:throw({ok,SendSelf});
                _->
                    erlang:throw({error,?_RC_PET_QUERY_002})
            end;
        ?pet_query_op_type_pet ->
            case mod_pet_data:get_pet(DataRecord#m_pet_query_tos.pet_id) of
                {ok,Pet} ->
                    SendSelf = #m_pet_query_toc{op_code=0,
                                                op_type=DataRecord#m_pet_query_tos.op_type,
                                                pet_info=mod_pet_data:gen_p_pet(Pet)
                                               },
                    erlang:throw({ok,SendSelf});
                _ ->
                    erlang:throw({error,?_RC_PET_QUERY_003})
            end;
        ?pet_query_op_type_role_pet ->
            case mod_pet_data:get_role_pet(RoleId) of
                {ok,RolePet} ->
                    PRolePet = #p_role_pet{role_id=RoleId,
                                           attack_skill=RolePet#r_role_pet.attack_skill,
                                           phy_defence_skill=RolePet#r_role_pet.phy_defence_skill,
                                           magic_defence_skill=RolePet#r_role_pet.magic_defence_skill,
                                           seal_skill=RolePet#r_role_pet.seal_skill},
                    SendSelf = #m_pet_query_toc{op_code=0,
                                                op_type=DataRecord#m_pet_query_tos.op_type,
                                                role_pet=PRolePet},
                    erlang:throw({ok,SendSelf});
                _ ->
                    erlang:throw({error,?_RC_PET_QUERY_003})
            end
    end,
    {ok}.
do_pet_query3(Module,Method,_DataRecord,_RoleId,PId,SendSelf) ->
    ?DEBUG("do query pet info succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).
    
do_pet_query_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_pet_query_toc{op_type=DataRecord#m_pet_query_tos.op_type,
                                op_code=OpCode},
    ?DEBUG("do query pet info fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).



%% 创建宠物
do_pet_create({RoleId,PetTypeId,Via,Bind}) ->
    case db_api:transaction(
           fun() ->
                   do_t_pet_create(RoleId,PetTypeId,Via,Bind)
           end) of
        {atomic,{ok,NewPet,NewPetBag}} ->
            do_pet_create2(RoleId,PetTypeId,Via,Bind,NewPet,NewPetBag);
        {aborted, Error} ->
            ?ERROR_MSG("~ts,RoleId=~w,PetTypeId=~w,Via=~w,Error=~w",[?_LANG_LOCAL_034,RoleId,PetTypeId,Via,Error])
    end.
do_pet_create2(RoleId,_PetTypeId,_Via,_Bind,Pet,PetBag) ->
    #r_pet{pet_id = PetId} = Pet,
    mod_pet_data:set_pet(PetId, Pet),
    %% 检查当前是否有是第一只获得的宠物，是的话需要做出战处理
    case erlang:length(PetBag#r_pet_bag.pets) of
        1 -> %% 出战
            catch do_pet_create3(RoleId,Pet);
        _ ->
            next
    end,
    %% 写日志
    
    ok.
do_pet_create3(RoleId,Pet) ->
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw({error,role_pet_not_found})
    end,
    case RolePet#r_role_pet.battle_id =:= 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,exist_battle_pet})
    end,
    case RolePet#r_role_pet.is_has =:= 0 of
        true -> %% 是否是第一次获得宠物
            next;
        _ ->
            erlang:throw({error,not_first_pet})
    end,
    NewRolePet = RolePet#r_role_pet{is_has=1},
    mod_pet_data:set_role_pet(RoleId, NewRolePet),
    do_pet_battle3(RoleId,NewRolePet,Pet).

%% 事务创建宠物
do_t_pet_create(RoleId,PetTypeId,Via,Bind) ->
    case cfg_pet:find(PetTypeId) of
        undefined ->
            db_api:abort({error,?_RC_PET_000});
        _PetInfo ->
            next
    end,
    %% 查检宠物背包是否为满
    case mod_pet_data:get_pet_bag({RoleId,?PET_BAG_ID_MAIN}) of
        {ok,PetBag} ->
            case erlang:length(PetBag#r_pet_bag.pets) of
                ?PET_BAG_MAIN_MAX_GRID_NUMBER ->
                    db_api:abort({error,?_RC_PET_CREATE_002});
                _ ->
                    next
            end;
        _ ->
            PetBag = undefined,
            db_api:abort({error,?_RC_PET_CREATE_003})
    end,
    
    NowSeconds = mgeew_role:get_now(),
    ServerId = common_misc:get_server_id_by_id(RoleId),
    case db_api:read(?DB_PET_COUNTER,ServerId,write) of
        [#r_counter{last_id=LastPetId}] ->
            next;
        _ ->
            LastPetId = 0,
            db_api:abort({error,?_RC_PET_CREATE_001})
    end,
    PetId = LastPetId + 1,
    {ok,PetT} = mod_pet_data:create_pet(PetTypeId),
    Pet = PetT#r_pet{pet_id = PetId,role_id = RoleId,via=Via,create_time = NowSeconds,bind=Bind},
    NewPetT = mod_attr:calc_fight_attr({?ACTOR_TYPE_PET,Pet}),
    #r_pet{attr=#p_fight_attr{max_hp=MaxHp,max_mp=MaxMp,max_anger=MaxAnger}=FightAttr}=NewPetT,
    NewPet = NewPetT#r_pet{attr=FightAttr#p_fight_attr{hp=MaxHp,mp=MaxMp,anger=MaxAnger}},
    NewPetBag = PetBag#r_pet_bag{pets=[PetId|PetBag#r_pet_bag.pets]},
    %% 宠物id信息
    db_api:write(?DB_PET_COUNTER, #r_counter{key=ServerId, last_id=PetId}, write),
    %% 宠物信息
    db_api:write(?DB_PET, NewPet, write),
    %% 宠物背包信息
    mod_pet_data:t_set_pet_bag({RoleId,?PET_BAG_ID_MAIN}, NewPetBag),
    {ok,NewPet,NewPetBag}.

%% 出战斗宠物消息锁
get_pet_battle_lock(RoleId) ->
    erlang:get({pet_battle_lock,RoleId}).
set_pet_battle_lock(RoleId,Info) ->
    erlang:put({pet_battle_lock,RoleId}, Info).
erase_pet_battle_lock(RoleId) ->
    erlang:erase({pet_battle_lock,RoleId}).

%% 宠物出站
do_pet_battle(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_pet_battle2(RoleId,DataRecord) of
        {ok,RolePet,Pet} ->
            do_pet_battle3(RoleId,RolePet,Pet);
        {error,OpCode} ->
            do_pet_battle_error(Module,Method,DataRecord,RoleId,PId,OpCode)
    end.
do_pet_battle2(RoleId,DataRecord) ->
    case get_pet_battle_lock(RoleId) of
        undefined ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_BATTLE_006})
    end,
    case DataRecord#m_pet_battle_tos.pet_id of
        0 ->
            PetId = 0,
            erlang:throw({error,?_RC_PET_BATTLE_001});
        PetId ->
            next
    end,
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw({error,?_RC_PET_BATTLE_000})
    end,
    #r_role_pet{battle_id=BattleId,battle_cd=BattleCD} = RolePet,
    case BattleId =:= PetId of
        true ->
            erlang:throw({error,?_RC_PET_BATTLE_002});
        _ ->
            next
    end,
    case BattleId of
        0 ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_BATTLE_005})
    end,
    NowSeconds = mgeew_role:get_now(),
    case NowSeconds - BattleCD > ?PET_BATTLE_MIN_CD of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_BATTLE_004})
    end,
    case mod_pet_data:get_pet_bag({RoleId,?PET_BAG_ID_MAIN}) of
        {ok,PetBag} ->
            case lists:member(PetId, PetBag#r_pet_bag.pets) of
                true ->
                    next;
                _ ->
                    erlang:throw({error,?_RC_PET_BATTLE_003})
            end;
        _ ->
            erlang:throw({error,?_RC_PET_BATTLE_000})
    end,
    case mod_pet_data:get_pet(PetId) of
        {ok,Pet} ->
            next;
        _ ->
            Pet = undefined,
            erlang:throw({error,?_RC_PET_BATTLE_000})
    end,
    {ok,RolePet,Pet}.
do_pet_battle3(RoleId,RolePet,Pet) ->
    set_pet_battle_lock(RoleId, {pet_battle,RolePet,Pet}),
    #r_pet{pet_id=PetId} = Pet,
    Info = {mod,mod_map_pet,{pet_battle_pre,{RoleId,PetId}}},
    common_misc:send_to_role_map(RoleId, Info).

%% 地图进程消息返回处理
do_pet_battle_reply({error,RoleId,PetId,OpCode}) ->
    erase_pet_battle_lock(RoleId),
    SendSelf = #m_pet_battle_toc{op_code=OpCode,pet_id=PetId},
    ?DEBUG("do pet battle info fail,SendSelf=~w",[SendSelf]),
    {ok,#r_role_world_state{gateway_pid=PId}} = mgeew_role:get_role_world_state(),
    common_misc:unicast(PId,?PET,?PET_BATTLE,SendSelf);
do_pet_battle_reply({ok,RoleId,PetId}) ->
    {pet_battle,RolePet,Pet} = get_pet_battle_lock(RoleId),
    erase_pet_battle_lock(RoleId),
    {ok,#r_role_world_state{gateway_pid=PId}} = mgeew_role:get_role_world_state(),
    #r_pet{pet_name=PetName,
           type_id=PetTypeId,level=PetLevel,
           skills=SkillList,
           buffs=BuffList} = Pet,
    %% TODO 出站需要处理宠物的技能是否需要自动触发
    NewBuffList = mod_buff:init_object_buff(PetId, ?ACTOR_TYPE_PET, BuffList),
    TocBuffIdList = mod_buff:get_toc_buff_ids(NewBuffList),
    Pet2 = Pet#r_pet{buffs=NewBuffList},
    Pet3 = mod_attr:calc_fight_attr({?ACTOR_TYPE_PET,Pet2}),
    #r_pet{attr=#p_fight_attr{hp=Hp,mp=Mp,anger=Anger}=FightAttr} = Pet3,
    #r_role_pet{attack_skill=AttackSkill,
                phy_defence_skill=PhyDefenceSkill,
                magic_defence_skill=MagicDefenceSkill,
                seal_skill=SealSkill} = RolePet,
    NewFightAttr=FightAttr#p_fight_attr{hp=Hp,mp=Mp,anger=Anger,
                                        attack_skill=AttackSkill,
                                        phy_defence_skill=PhyDefenceSkill,
                                        magic_defence_skill=MagicDefenceSkill,
                                        seal_skill=SealSkill},
    NewPet = Pet3#r_pet{status=?PET_STATUS_BATTLE,attr=NewFightAttr},
    NowSeconds = mgeew_role:get_now(),
    NewRolePet = RolePet#r_role_pet{battle_id = PetId,battle_cd=NowSeconds,last_battle_id=PetId},
    mod_pet_data:set_role_pet(RoleId, NewRolePet),
    mod_pet_data:set_pet(PetId, NewPet),
    
    {ok,#r_role_pos{group_id=GroupId}} = mod_role:get_role_pos(RoleId),
    PPetInfo = mod_pet_data:gen_p_pet(NewPet),
    NewPPetInfo = PPetInfo#p_pet{group_id=GroupId,buffs=TocBuffIdList},
    SendSelf = #m_pet_battle_toc{op_code=0,
                                 pet_id=PetId,
                                 pet_info=NewPPetInfo},
    ?DEBUG("do pet battle succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,?PET,?PET_BATTLE,SendSelf),
    %% 同步给地图进程
    #r_pet_info{display_type=DisplayType} = cfg_pet:find(PetTypeId),
    MapRolePet = #r_map_role_pet{role_id=RoleId,
                                 battle_id=PetId,
                                 battle_cd=NowSeconds,
                                 display_type=DisplayType},
    MapActor=#r_map_actor{actor_id=PetId,
                              actor_type=?ACTOR_TYPE_PET,
                              attr=NewFightAttr,
                              skill=SkillList,
                              ext = MapRolePet},
    #p_fight_attr{max_hp=MaxHp,hp=Hp,move_speed=MoveSpeed} = NewPet#r_pet.attr,
    MapPet = #p_map_pet{pet_id=PetId, 
                        pet_name=PetName,
                        role_id=RoleId,
                        type_id=PetTypeId,
                        level=PetLevel,
                        pos=undefined,
                        walk_pos=undefined,
                        status=?ACTOR_STATUS_NORMAL,
                        max_hp=MaxHp,
                        hp=Hp,
                        move_speed=MoveSpeed,
                        buffs=TocBuffIdList,
                        group_id=GroupId},
    Msg = {mod,mod_map_pet,{pet_battle,{RoleId,PetId,MapActor,MapPet}}},
    common_misc:send_to_role_map(RoleId, Msg),
    ok.
do_pet_battle_error(Module,Method,DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_pet_battle_toc{op_code=OpCode,
                                 pet_id=DataRecord#m_pet_battle_tos.pet_id},
    ?DEBUG("do pet battle fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).



%% 玩家死亡，收回宠物处理
do_pet_back(RoleId,PId,PetId,BackType) ->
    case catch do_pet_back2(RoleId) of
        {ok,RolePet,Pet} ->
            case Pet#r_pet.pet_id of
                PetId ->
                    do_pet_back3(?PET,?PET_BACK,RoleId,PId,RolePet,Pet,BackType);
                _ ->
                    ?ERROR_MSG("~ts,RoleId=~w,PetId=~w,Error=~w",[?_LANG_LOCAL_036,RoleId,PetId,{error,PetId,Pet#r_pet.pet_id}])
            end;
        Error ->
            ?ERROR_MSG("~ts,RoleId=~w,PetId=~w,Error=~w",[?_LANG_LOCAL_036,RoleId,PetId,Error])
    end.
%% 宠物收回
do_pet_back(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_pet_back2(RoleId) of
        {error,OpCode} ->
            do_pet_back_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,RolePet,Pet} ->
            do_pet_back3(Module,Method,RoleId,PId,RolePet,Pet,?PET_BACK_TYPE_NORMAL)
    end.
do_pet_back2(RoleId) ->
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = undefined,
            erlang:throw({error,?_RC_PET_BACK_000})
    end,
    #r_role_pet{battle_id=BattleId} = RolePet,
    case mod_pet_data:get_pet(BattleId) of
        {ok,Pet} ->
            next;
        _ ->
            Pet = undefined,
            erlang:throw({error,?_RC_PET_BACK_000})
    end,   
    {ok,RolePet,Pet}.

do_pet_back3(Module,Method,RoleId,PId,RolePet,Pet,BackType) ->
    #r_pet{pet_id=PetId} = Pet,
    NewRolePet = RolePet#r_role_pet{battle_id = 0},
    BuffList = mod_buff:get_object_buff(PetId, ?ACTOR_TYPE_PET),
    NewPet = Pet#r_pet{status=?PET_STATUS_NORMAL,buffs=BuffList},
    mod_pet_data:set_role_pet(RoleId, NewRolePet),
    mod_pet_data:set_pet(PetId, NewPet),
    mod_buff:erase_object_buff(PetId, ?ACTOR_TYPE_PET),
    case BackType of
        ?PET_BACK_TYPE_DEAD ->
            ignore;
        _ ->
            Msg = {mod,mod_map_pet,{pet_back,{RoleId,PetId}}},
            common_misc:send_to_role_map(RoleId, Msg),
            SendSelf = #m_pet_back_toc{op_code=0},
            ?DEBUG("do pet back succ,SendSelf=~w",[SendSelf]),
            common_misc:unicast(PId,Module,Method,SendSelf)
    end,
    ok.
do_pet_back_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_pet_back_toc{op_code=OpCode},
    ?DEBUG("do pet back fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).


%% 宠物放生
do_pet_free(Module,Method,DataRecord,RoleId,PId) ->
    case catch do_pet_free2(RoleId,DataRecord) of
        {error,OpCode} ->
            do_pet_free_error(Module,Method,DataRecord,RoleId,PId,OpCode);
        {ok,Pet} ->
            do_pet_free3(Module,Method,DataRecord,RoleId,PId,Pet)
    end.
do_pet_free2(RoleId,DataRecord) ->
    case DataRecord#m_pet_free_tos.pet_id > 0 of
        true ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_FREE_000})
    end,
    case DataRecord#m_pet_free_tos.bag_type of
        ?PET_BAG_ID_MAIN ->
            next;
        ?PET_BAG_ID_DEPOT ->
            next;
        _ ->
            erlang:throw({error,?_RC_PET_FREE_000})
    end,
    case mod_pet_data:get_role_pet(RoleId) of
        {ok,RolePet} ->
            next;
        _ ->
            RolePet = nudefined,
            erlang:throw({error,?_RC_PET_FREE_000})
    end,
    case RolePet#r_role_pet.battle_id =:= DataRecord#m_pet_free_tos.pet_id of
        true ->
            erlang:throw({error,?_RC_PET_FREE_002});
        _ ->
            next
    end,
    case mod_pet_data:get_pet(DataRecord#m_pet_free_tos.pet_id) of
        {ok,Pet} ->
            next;
        _ ->
            Pet = undefined,
            erlang:throw({error,?_RC_PET_FREE_001})
    end,
    {ok,Pet}.
do_pet_free3(Module,Method,DataRecord,RoleId,PId,Pet) ->
    BagType = DataRecord#m_pet_free_tos.bag_type,
    #r_pet{pet_id=PetId} = Pet,
    mod_pet_data:erase_pet(PetId),
    db_api:dirty_delete(?DB_PET, PetId),
    
    case mod_pet_data:get_pet_bag({RoleId,BagType}) of
        {ok,#r_pet_bag{pets=PetIdList}=PetBag} ->
            NewPetIdList = lists:delete(PetId,PetIdList),
            NewPetBag = PetBag#r_pet_bag{pets=NewPetIdList},
            mod_pet_data:set_pet_bag({RoleId,BagType},NewPetBag);
        _ ->
            next
    end,
    
    SendSelf = #m_pet_free_toc{op_code=0},
    ?DEBUG("do pet back succ,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).

do_pet_free_error(Module,Method,_DataRecord,_RoleId,PId,OpCode) ->
    SendSelf = #m_pet_free_toc{op_code=OpCode},
    ?DEBUG("do pet back fail,SendSelf=~w",[SendSelf]),
    common_misc:unicast(PId,Module,Method,SendSelf).
    

