%% @filename db_migration.erl
%% @author caochuncheng2002@gmail.com
%% @create time  2016-01-18 
%% @doc 
%% 数据迁移模模块.

-module(db_migration).

-include("common.hrl").
-include("common_server.hrl").

-export([move_inactive/0,
         to_inactive/1,
         to_active/1
        ]).

%% 根据不同的条件判断那些数据可以迁移到不活跃存储
%% 玩家数据根据玩家的登录时间来判断
%% 其它业务表需要根据相应的条件判断是否需要迁移到不活跃存储
-spec move_inactive() -> ok.
move_inactive() ->
    %% 玩家数据
    RoleIdList = db_active_api:dirty_all_keys(?DB_ROLE_BASE),
    NowSeconds = common_tool:now(),
    MoveInactiveInterval = cfg_mnesia:find(move_inactive_interval),
    MoveRoleIdList = verify_move_by_role(RoleIdList,NowSeconds,MoveInactiveInterval,[]),
    do_move_inactive_by_role(MoveRoleIdList),
    to_inactive_by_pay_request(),
    ok.
%% 验证玩家数据是否迁移到不活跃存储
-spec
verify_move_by_role(RoleIdList,NowSeconds,MoveInactiveInterval,MoveRoleIdList) -> MoveRoleIdList when
    RoleIdList :: [integer(),...],
    NowSeconds :: integer(),
    MoveInactiveInterval :: integer(),
    MoveRoleIdList :: [] | [integer()].
verify_move_by_role([],_NowSeconds,_MoveInactiveInterval,MoveRoleIdList) ->
    MoveRoleIdList;
verify_move_by_role([RoleId | RoleIdList],NowSeconds,MoveInactiveInterval,MoveRoleIdList) ->
    [RoleBase] = db_active_api:dirty_read(?DB_ROLE_BASE, RoleId),
    #p_role_base{last_login_time=LastLoginTime} = RoleBase,
    DiffSeconds = NowSeconds - LastLoginTime,
    %% 目前只是根据最后登录时间判断数据是否迁移到不活跃存储
    %% TODO 是否需要处理删号问题
    case DiffSeconds > 0 andalso DiffSeconds >= MoveInactiveInterval of
        true ->
            verify_move_by_role(RoleIdList,NowSeconds,MoveInactiveInterval,[RoleId|MoveRoleIdList]);
        _ ->
            verify_move_by_role(RoleIdList,NowSeconds,MoveInactiveInterval,MoveRoleIdList)
    end.

%% 执行将玩家数据迁移到不活跃存储
-spec do_move_inactive_by_role(RoleIdList) -> ok when RoleIdList :: [integer()].
do_move_inactive_by_role([]) ->
    ok;
do_move_inactive_by_role([RoleId | RoleIdList]) ->
    to_inactive(RoleId),
    do_move_inactive_by_role(RoleIdList).

%% 将此玩家的数据迁移到不活跃表存储
-spec to_inactive(RoleId) -> ok when RoleId :: integer().
to_inactive(RoleId) ->
    case catch do_to_inactive(RoleId) of
        ok ->
            ok;
        {error,Reason} ->
            ?ERROR_MSG("data migration to inactive error=~w",[Reason]),
            ok
    end.
do_to_inactive(RoleId) ->
    case db_active_api:dirty_read(?DB_ROLE_BASE, RoleId) of
        [RoleBase] ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_found_role_base})
    end,
    db_active_api:dirty_delete(?DB_ROLE_BASE, RoleId),
    db_inactive_api:dirty_write(?DB_ROLE_BASE, RoleBase),
    %% 以RoleId 为key的数据
    lists:foreach(
        fun(Tab) -> 
            case db_active_api:dirty_read(Tab, RoleId) of
                [RoleData] ->
                    db_active_api:dirty_delete(Tab, RoleId),
                    db_inactive_api:dirty_write(Tab, RoleData);
                _ ->
                    next
            end
        end, [?DB_ROLE_ATTR,?DB_ROLE_POS,?DB_ROLE_STATE,?DB_ROLE_EXT,
              ?DB_ROLE_MISSION,?DB_ROLE_SYS_CONF,?DB_ROLE_LETTER,
              ?DB_ROLE_CUSTOMER_SERVICE,?DB_ROLE_SKILL,?DB_ROLE_BUFF,
              ?DB_ROLE_FB,?DB_ROLE_PET]),
    %% 背包
    [RoleBagBasic] = db_active_api:dirty_read(?DB_ROLE_BAG_BASIC, RoleId),
    db_active_api:dirty_delete(?DB_ROLE_BAG_BASIC, RoleId),
    db_inactive_api:dirty_write(?DB_ROLE_BAG_BASIC, RoleBagBasic),
    #r_role_bag_basic{bag_id_list=BagIdList} = RoleBagBasic,
    lists:foreach(
        fun(BagId) -> 
            [RoleBag] = db_active_api:dirty_read(?DB_ROLE_BAG, {RoleId,BagId}),
            db_active_api:dirty_delete(?DB_ROLE_BAG, {RoleId,BagId}),
            db_inactive_api:dirty_write(?DB_ROLE_BAG, RoleBag)
        end, BagIdList),
    
    
    %% 宠物
    [RolePetBagMain] = db_active_api:dirty_read(?DB_PET_BAG,{RoleId,?PET_BAG_ID_MAIN}),
    db_active_api:dirty_delete(?DB_PET_BAG, {RoleId,?PET_BAG_ID_MAIN}),
    db_inactive_api:dirty_write(?DB_PET_BAG, RolePetBagMain),
    #r_pet_bag{pets = PetIdListA} = RolePetBagMain,
    case db_active_api:dirty_read(?DB_PET_BAG,{RoleId,?PET_BAG_ID_DEPOT}) of
        [#r_pet_bag{pets = PetIdListB} = RolePetBagDepot] ->
            db_active_api:dirty_delete(?DB_PET_BAG, {RoleId,?PET_BAG_ID_DEPOT}),
            db_inactive_api:dirty_write(?DB_PET_BAG, RolePetBagDepot);
        _ ->
            PetIdListB = []
    end,
    lists:foreach(
        fun(PetId) -> 
            [Pet] = db_active_api:dirty_read(?DB_PET, PetId),
            db_active_api:dirty_delete(?DB_PET, PetId),
            db_inactive_api:dirty_write(?DB_PET, Pet)
        end, PetIdListA ++ PetIdListB),
    ok.
%% 将此玩家的数据迁移到活跃表存储
-spec to_active(RoleId) -> ok when RoleId :: integer().
to_active(RoleId) ->
    case catch do_to_active(RoleId) of
        ok ->
            ok;
        {error,Reason} ->
            ?ERROR_MSG("data migration to active error=~w",[Reason]),
            ok
    end.
do_to_active(RoleId) ->
    case db_inactive_api:dirty_read(?DB_ROLE_BASE, RoleId) of
        [RoleBase] ->
            next;
        _ ->
            RoleBase = undefined,
            erlang:throw({error,not_found_role_base})
    end,
    db_inactive_api:dirty_delete(?DB_ROLE_BASE, RoleId),
    db_active_api:dirty_write(?DB_ROLE_BASE, RoleBase),
    %% 以RoleId 为key的数据
    lists:foreach(
        fun(Tab) -> 
            case db_inactive_api:dirty_read(Tab, RoleId) of
                [RoleData] ->
                    db_inactive_api:dirty_delete(Tab, RoleId),
                    db_active_api:dirty_write(Tab, RoleData);
                _ ->
                    next
            end
        end, [?DB_ROLE_ATTR,?DB_ROLE_POS,?DB_ROLE_STATE,?DB_ROLE_EXT,
              ?DB_ROLE_MISSION,?DB_ROLE_SYS_CONF,?DB_ROLE_LETTER,
              ?DB_ROLE_CUSTOMER_SERVICE,?DB_ROLE_SKILL,?DB_ROLE_BUFF,
              ?DB_ROLE_FB,?DB_ROLE_PET]),
    %% 背包
    [RoleBagBasic] = db_inactive_api:dirty_read(?DB_ROLE_BAG_BASIC, RoleId),
    db_inactive_api:dirty_delete(?DB_ROLE_BAG_BASIC, RoleId),
    db_active_api:dirty_write(?DB_ROLE_BAG_BASIC, RoleBagBasic),
    #r_role_bag_basic{bag_id_list=BagIdList} = RoleBagBasic,
    lists:foreach(
        fun(BagId) -> 
            [RoleBag] = db_inactive_api:dirty_read(?DB_ROLE_BAG, {RoleId,BagId}),
            db_inactive_api:dirty_delete(?DB_ROLE_BAG, {RoleId,BagId}),
            db_active_api:dirty_write(?DB_ROLE_BAG, RoleBag)
        end, BagIdList),
    
    
    %% 宠物
    [RolePetBagMain] = db_inactive_api:dirty_read(?DB_PET_BAG,{RoleId,?PET_BAG_ID_MAIN}),
    db_inactive_api:dirty_delete(?DB_PET_BAG, {RoleId,?PET_BAG_ID_MAIN}),
    db_active_api:dirty_write(?DB_PET_BAG, RolePetBagMain),
    #r_pet_bag{pets = PetIdListA} = RolePetBagMain,
    case db_inactive_api:dirty_read(?DB_PET_BAG,{RoleId,?PET_BAG_ID_DEPOT}) of
        [#r_pet_bag{pets = PetIdListB} = RolePetBagDepot] ->
            db_inactive_api:dirty_delete(?DB_PET_BAG, {RoleId,?PET_BAG_ID_DEPOT}),
            db_active_api:dirty_write(?DB_PET_BAG, RolePetBagDepot);
        _ ->
            PetIdListB = []
    end,
    lists:foreach(
        fun(PetId) -> 
            [Pet] = db_inactive_api:dirty_read(?DB_PET, PetId),
            db_inactive_api:dirty_delete(?DB_PET, PetId),
            db_active_api:dirty_write(?DB_PET, Pet)
        end, PetIdListA ++ PetIdListB),
    ok.

%% 将充值日志数据迁移到不活跃表存储
to_inactive_by_pay_request() ->
    AllKeyList = db_active_api:dirty_all_keys(?DB_PAY_REQUEST),
    to_inactive_by_pay_request(AllKeyList).
to_inactive_by_pay_request([]) ->
    ok;
to_inactive_by_pay_request([Key | AllKeyList]) ->
    case db_active_api:dirty_read(?DB_PAY_REQUEST, Key) of
        [#r_pay_request{status=Status}=PayRequest] ->
            next;
        _ ->
            Status = 0, PayRequest = undefined
    end,
    case Status of
        1 ->
            db_active_api:dirty_delete(?DB_PAY_REQUEST,Key),
            db_inactive_api:dirty_write(?DB_PAY_REQUEST,PayRequest);
        _ ->
            next
    end,
    to_inactive_by_pay_request(AllKeyList).
    
