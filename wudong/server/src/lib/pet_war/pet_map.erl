%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 宠物阵营图
%%% @end
%%% Created : 17. 十一月 2017 18:11
%%%-------------------------------------------------------------------
-module(pet_map).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("pet.hrl").
-include("pet_war.hrl").

%% API
-export([
    put_on/3, %% 上阵
    put_down/2, %% 下阵
    swap/3, %% 交换位置
    get_map_info/0, %% 读取阵型图
    save_map/1
]).

%% 内部接口
-export([
    init/1,
    get_map/1,
    delete_pet/1,
    delete_pet_list/1
]).

init(#player{key = Pkey}) ->
    {MapList, UseMapId} = pet_war_load:load_map(Pkey),
    St = #st_pet_map{pkey = Pkey, map_list = MapList, use_map_id = UseMapId},
    lib_dict:put(?PROC_STATUS_PET_MAP, St).

%% 上阵出战
put_on(PetKey, MapId, Pos) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    PutOnPet = get_pet(PetKey),
    #st_pet_map{map_list = MapList} = St,
    F = fun({{MId, _Pos}, K} = R) ->
        if
            MId == MapId andalso PetKey == K -> [R];
            MId == MapId ->
                Pet = get_pet(K),
                ?IF_ELSE(PutOnPet#pet.type_id == Pet#pet.type_id, [R], []);
            true -> []
        end
    end,
    PutOnList = lists:flatmap(F, MapList),
    if
        PutOnList /= [] -> 9; %% 不可上阵相同类型宠物
        true ->
            NewMapList =
                case lists:keytake({MapId, Pos}, 1, MapList) of
                    false ->
                        [{{MapId, Pos}, PetKey} | MapList];
                    {value, _, Rest} ->
                        [{{MapId, Pos}, PetKey} | Rest]
                end,
            F0 = fun({{MapId0, _Pos0}, _PetKey0}) -> MapId0 == MapId end,
            FilterList = lists:filter(F0, NewMapList),

            if
                length(FilterList) > ?PET_PUT_ON_MAX -> 10; %% 最多上阵5只宠物
                true ->
                    NewSt = St#st_pet_map{map_list = NewMapList},
                    lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
                    pet_war_load:update_map(NewSt),
                    1
            end
    end.

get_pet(PetKey) ->
    St = lib_dict:get(?PROC_STATUS_PET),
    #st_pet{pet_list = PetList} = St,
    case lists:keyfind(PetKey, #pet.key, PetList) of
        false -> #pet{};
        Pet -> Pet
    end.

%% 获取出战宠物key和出战pos
get_map(TargetMapId) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList} = St,
    F = fun({{MapId, Pos}, PetKey}) ->
        if
            TargetMapId == MapId -> [{PetKey, Pos}];
            true -> []
        end
    end,
    lists:flatmap(F, MapList).

%% 宠物被分解，吞噬等等，消失时调用
delete_pet_list(PetKeyList) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList} = St,
    F = fun({_MapInfo, FightPetKey} = T) ->
        case lists:member(FightPetKey, PetKeyList) of
            true -> [];
            false -> [T]
        end
    end,
    NewMapList = lists:flatmap(F, MapList),
    NewSt = St#st_pet_map{map_list = NewMapList},
    lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
    if
        St /= NewSt -> pet_war_load:update_map(NewSt);
        true -> ok
    end.

delete_pet(PetKey) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList} = St,
    F = fun({_MapInfo, FightPetKey} = T) ->
        if
            PetKey /= FightPetKey -> [T];
            true -> []
        end
    end,
    NewMapList = lists:flatmap(F, MapList),
    NewSt = St#st_pet_map{map_list = NewMapList},
    lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
    if
        St /= NewSt -> pet_war_load:update_map(NewSt);
        true -> ok
    end.

%% 下阵
put_down(Key0, MapId0) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList} = St,
    F = fun({{MapId, _Pos}, Key} = R) ->
        if
            MapId == MapId0 andalso Key == Key0 -> [];
            true -> [R]
        end
    end,
    NewMapList = lists:flatmap(F, MapList),
    NewSt = St#st_pet_map{map_list = NewMapList},
    lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
    pet_war_load:update_map(NewSt),
    1.

%% 交换位置
swap(Key1, Key2, MapId0) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList} = St,
    F = fun({{MapId, _Pos}, Key} = R) ->
        if  %% 读取选中宠物位置
            MapId == MapId0 andalso (Key == Key1 orelse Key == Key2) -> [R];
            true -> []
        end
    end,
    InfoList = lists:flatmap(F, MapList),

    F1 = fun({{MapId, _Pos}, Key} = R) ->
        if  %% 读取非选中宠物位置
            MapId == MapId0 andalso (Key == Key1 orelse Key == Key2) -> [];
            true -> [R]
        end
    end,
    InfoList1 = lists:flatmap(F1, MapList),

    if
        length(InfoList) < 2 -> 0;
        true ->
            [{{M,P1}, K1},{{M,P2},K2}] = InfoList,
            NewInfoList = [{{M,P2}, K1},{{M,P1},K2}],
            NewMapList = NewInfoList ++ InfoList1,
            NewSt = St#st_pet_map{map_list = NewMapList},
            lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
            pet_war_load:update_map(NewSt),
            1
    end.

%% 读取阵型图
get_map_info() ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    #st_pet_map{map_list = MapList, use_map_id = UseMapId} = St,
    F = fun({{MapId, Pos},Key}) -> [MapId, Key, Pos] end,
    List = lists:map(F, MapList),
    {UseMapId, List}.

save_map(UseMapId) ->
    St = lib_dict:get(?PROC_STATUS_PET_MAP),
    NewSt = St#st_pet_map{use_map_id = UseMapId},
    lib_dict:put(?PROC_STATUS_PET_MAP, NewSt),
    pet_war_load:update_map(NewSt),
    1.