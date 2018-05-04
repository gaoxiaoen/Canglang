%%----------------------------------------------------
%% 跨服排行榜处理
%% @author whjing2011@gmail.com
%%----------------------------------------------------
-module(rank_cross).
-export([
        get_rank_pet_info/2
        ,get_rank_role_info/2
        ,get_rank_item/4
        ,get_rank_mount_info/2
        ,get_rank_soul_array_info/2
        ,get_rank_soul_spirit_info/2
        ,get_rank_soul_spirits_info/2
    ]
).

-include("common.hrl").
-include("role.hrl").
-include("rank.hrl").
-include("item.hrl").

%% 获取排行榜玩家宠物信息
get_rank_pet_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_pet_lev{name = Name, pet = Pet} -> {Name, Pet};
        #rank_cross_role_pet_power{name = Name, pet = Pet} -> {Name, Pet};
        #rank_cross_pet_grow{name = Name, pet = Pet} -> {Name, Pet};
        #rank_cross_pet_potential{name = Name, pet = Pet} -> {Name, Pet};
        _ -> false
    end.

%% 获取榜上角色信息
get_rank_role_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_role_lev{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_role_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_role_coin{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_role_skill{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_role_achieve{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_role_soul{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_mount_power{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_mount_lev{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        #rank_cross_world_compete_win{career = Career, sex = Sex, lev = Lev, eqm = Eqm, looks = Looks} -> {Career, Sex, Lev, Eqm, Looks};
        _ -> false
    end.

%% 获取榜上角色坐骑信息
get_rank_mount_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_mount_power{name = Name, power = Power, eqm = Eqm} -> {Name, Power, lists:keyfind(?item_zuo_qi , #item.type, Eqm)};
        #rank_cross_mount_lev{name = Name, power = Power, eqm = Eqm} -> {Name, Power, lists:keyfind(?item_zuo_qi , #item.type, Eqm)};
        _ -> false
    end.

%% 获取榜上角色灵戒信息
get_rank_soul_spirits_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_soul_world{name = Name, power = Power, arrays = Arrays, spirits = Spirits} -> {Name, Power, Arrays, Spirits};
        _ -> false
    end.

%% 获取榜上角色妖灵信息
get_rank_soul_spirit_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_soul_world_spirit{name = Name, spirit = Spirit} -> {Name, Spirit};
        _ -> false
    end.

%% 获取榜上角色神魔阵信息
get_rank_soul_array_info(RoleId, Type) ->
    L = rank:list(Type),
    case lists:keyfind(RoleId, 2, L) of
        #rank_cross_soul_world_array{name = Name, lev = ArrayLev, arrays = Arrays} -> {Name, ArrayLev, Arrays};
        _ -> false
    end.

%% 获取角色装备
get_rank_item(Rid, Srvid, Type, EqmType) ->
    Id = case Type of
        ?rank_cross_armor -> {Rid, Srvid, EqmType};
        _ -> {Rid, Srvid}
    end,
    L = rank:list(Type),
    case lists:keyfind(Id, 2, L) of
        #rank_cross_equip_arms{item = Item} -> Item;
        #rank_cross_equip_armor{item = Item} -> Item;
        _ -> false
    end.

