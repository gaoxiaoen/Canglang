%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 21:29
%%%-------------------------------------------------------------------
-module(pet_assist).
-author("hxming").
-include("pet.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("tips.hrl").

%% API
-export([
    assist_info/0,
    pet_assist_put_on/3,
    pet_assist_put_off/2,
    pet_change_cell/3
]).
-export([
    get_pet_assist_star_list/1,
    id_to_cell/1,
    check_pet_assist_state/2,
    check_state/1
]).


%%助战信息
assist_info() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    %%部位融合信息
    F = fun(Cell, {InfoList, AttrList}) ->
        OpenLv = get_open_lv(Cell),
        Pet =
            case lists:keyfind(Cell, #pet.assist_cell, StPet#st_pet.pet_list) of
                false ->
                    #pet{};
                Pet1 ->
                    Pet1
            end,
        MergeAttr =
            case Pet#pet.key == 0 of
                true -> #attribute{};
                false -> attribute_util:make_attribute_by_key_val_list(data_pet_assist:get_attrs(Cell))
            end,

        MergeAttrList = attribute_util:pack_attr(MergeAttr),
        NewInfoList = InfoList ++ [[Cell, OpenLv, Pet#pet.key, Pet#pet.figure, Pet#pet.star, MergeAttrList]],
        NewAttrList = [MergeAttr | AttrList],
        {NewInfoList, NewAttrList}
        end,
    {CellInfoList, CellAttrList} = lists:foldl(F, {[], []}, lists:seq(1, 8)),
    %%激活的属性信息
    F1 = fun(Id, {AcList, Attr1List}) ->
        CellList = id_to_cell(Id),
        F2 = fun(Cell) ->
            case lists:keyfind(Cell, #pet.assist_cell, StPet#st_pet.pet_list) of
                false -> [];
                Pet2 -> [Pet2#pet.star]
            end
             end,
        StarList = lists:flatmap(F2, CellList),
        StarSum =
            case length(StarList) == 3 of
                true -> lists:sum(StarList);
                false -> 0
            end,
        MaxStar = data_pet_assist_suit:max_star(Id),
        MergeSuitAttr = data_pet_assist_suit:get(Id, StarSum),
        MergeActiveList = attribute_util:pack_attr(MergeSuitAttr),
        NewAcList = AcList ++ [[Id, StarSum, MaxStar, MergeActiveList]],
        NewAttr1List = [attribute_util:make_attribute_by_key_val_list(MergeSuitAttr) | Attr1List],
        {NewAcList, NewAttr1List}
         end,
    {ActiveList, ActivityAttrList} = lists:foldl(F1, {[], []}, lists:seq(1, 6)),
    SumAttr = attribute_util:sum_attribute(CellAttrList ++ ActivityAttrList),
    Cbp = attribute_util:calc_combat_power(SumAttr),
    %%助战种类属性
    AssistAcc = pet_attr:calc_pet_assist_acc(StPet#st_pet.pet_list),
    CbpAssistAcc = attribute_util:calc_combat_power(StPet#st_pet.assist_acc_attribute),
    AssistAccAttributeList = attribute_util:pack_attr(StPet#st_pet.assist_acc_attribute),
    %%助战星级属性
    AssistStar = pet_attr:calc_pet_assist_star(StPet#st_pet.pet_list),
    CbpAssistStar = attribute_util:calc_combat_power(StPet#st_pet.assist_star_attribute),
    AssistStarAttributeList = attribute_util:pack_attr(StPet#st_pet.assist_star_attribute),
    CbpTotal = round(Cbp + CbpAssistAcc + CbpAssistStar),
    {CellInfoList, ActiveList, CbpTotal, AssistAcc, AssistAccAttributeList, AssistStar, AssistStarAttributeList}.

id_to_cell(Id) ->
    case Id of
        1 -> [1, 2, 7];
        2 -> [2, 3, 7];
        3 -> [3, 4, 7];
        4 -> [4, 5, 7];
        5 -> [5, 6, 7];
        6 -> [1, 6, 7];
        _ -> []
    end.


%%获取宠物助战星级列表
get_pet_assist_star_list(PetList) ->
    F = fun(Cell) ->
        case lists:keyfind(Cell, #pet.assist_cell, PetList) of
            false -> [];
            Pet -> [{Cell, Pet#pet.star}]
        end
        end,
    lists:flatmap(F, lists:seq(1, 7)).


calc_assist_attribute(Player, StPet, PetList) ->
    AssistAttribute = pet_attr:calc_pet_assist_attribute(PetList),
    AssistAccAttribute = pet_attr:calc_pet_assist_acc_attribute(PetList),
    AssistStarAttribute = pet_attr:calc_pet_assist_star_attribute(PetList),
    AssistXhAttribute = pet_attr:calc_pet_assist_xh_attribute(PetList),
    StPet1 = StPet#st_pet{
        pet_list = PetList,
        assist_attribute = AssistAttribute,
        assist_acc_attribute = AssistAccAttribute,
        assist_star_attribute = AssistStarAttribute,
        assist_xh_attribute = AssistXhAttribute,
        is_change = 1},
    NewStPet = pet_attr:calc_attribute(StPet1),
    lib_dict:put(?PROC_STATUS_PET, NewStPet),
    NewPlayer = player_util:count_player_attribute(Player, true),
    activity:get_notice(Player, [110], true),
    {ok, NewPlayer}.

check_state(_Player) ->
    Tips = check_pet_assist_state(_Player, #tips{}),
    ?IF_ELSE(Tips#tips.state == 1, 1, 0).

check_pet_assist_state(Player, Tips) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    PetList = StPet#st_pet.pet_list,
    F0 = fun(#pet{state = State}) -> State == 0 end,
    F1 = fun(#pet{star = S1}, #pet{star = S2}) -> S1 > S2 end,
    %% 空闲
    NewPetList1 = lists:sort(F1, lists:filter(F0, PetList)),
    F2 = fun(#pet{state = State}) -> State == 1 end,
    %% 助战
    NewPetList2 = lists:sort(F1, lists:filter(F2, PetList)),
    F3 = fun(Cell) ->
        NeedLv = get_open_lv(Cell),
        ?IF_ELSE(Player#player.lv >= NeedLv, [Cell], [])
         end,
    %% 计算助战开的孔
    CellList = lists:flatmap(F3, lists:seq(1, 7)),
    if
        NewPetList1 == [] -> Tips;
        NewPetList2 == [] ->
            ?IF_ELSE(CellList == [], Tips, #tips{state = 1});
        true ->
            Pet1 = hd(NewPetList1),
            Pet2 = hd(lists:reverse(NewPetList2)),
            Code1 = ?IF_ELSE(Pet1#pet.star > Pet2#pet.star, 1, 0),
            Code2 = ?IF_ELSE(length(CellList) > length(NewPetList2), 1, 0),
            #tips{state = max(Code1, Code2)}
    end.

%%宠物助战
pet_assist_put_on(Player, Cell, PetKey) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    if
        Cell < 1 orelse Cell > 7 -> {false, 0};
        true ->
            case lists:keytake(PetKey, #pet.key, StPet#st_pet.pet_list) of
                false ->
                    {false, 4};
                {value, Pet, T} ->
                    NeedLv = get_open_lv(Cell),
                    if Pet#pet.state == ?PET_STATE_ASSIST -> {false, 19};
                        Pet#pet.state == ?PET_STATE_FIGHT -> {false, 21};
                        NeedLv > Player#player.lv -> {false, 22};
                        true ->
                            Lan = version:get_lan_config(),
                            check_assist(Lan, Player, StPet, T, Pet, Cell)
                    end
            end
    end.

check_assist(korea, Player, StPet, PetList, Pet, Cell) ->
    case lists:keytake(Cell, #pet.assist_cell, PetList) of
        false ->
            case lists:keymember(Pet#pet.type_id, #pet.type_id, [Pet1 || Pet1 <- PetList, Pet#pet.state == ?PET_STATE_ASSIST]) of
                true -> {false, 19};
                false ->
                    NewPetList = [Pet#pet{state = ?PET_STATE_ASSIST, assist_cell = Cell, is_change = 1} | PetList],
                    calc_assist_attribute(Player, StPet, NewPetList)
            end;
        {value, OldPet, T} ->
            if OldPet#pet.type_id /= Pet#pet.type_id ->
                {false, 20};
                Pet#pet.star =< OldPet#pet.star ->
                    {false, 19};
                true ->
                    PetList1 = [Pet#pet{state = ?PET_STATE_ASSIST, assist_cell = Cell, is_change = 1} | T],
                    NewPetList = [OldPet#pet{state = ?PET_STATE_FREE, assist_cell = 0, is_change = 1} | PetList1],
                    calc_assist_attribute(Player, StPet, NewPetList)
            end

    end;
check_assist(_Lan, Player, StPet, PetList, Pet, Cell) ->
    case lists:keymember(Cell, #pet.assist_cell, StPet#st_pet.pet_list) of
        true -> {false, 20};
        false ->
            NewPetList = [Pet#pet{state = ?PET_STATE_ASSIST, assist_cell = Cell, is_change = 1} | PetList],
            calc_assist_attribute(Player, StPet, NewPetList)
    end.

%%助战卸下
pet_assist_put_off(Player, Key) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keytake(Key, #pet.key, StPet#st_pet.pet_list) of
        false ->
            {false, 4};
        {value, Pet, T} ->
            if Pet#pet.state =/= ?PET_STATE_ASSIST -> {false, 23};
                true ->
                    PetList = [Pet#pet{state = ?PET_STATE_FREE, assist_cell = 0, is_change = 1} | T],
                    calc_assist_attribute(Player, StPet, PetList)
            end
    end.

%%助战宠物互换位置
pet_change_cell(Player, Cell1, Cell2) ->
    if Cell1 < 1 orelse Cell2 < 1 orelse Cell1 > 7 orelse Cell2 > 7 -> {false, 0};
        true ->
            StPet = lib_dict:get(?PROC_STATUS_PET),
            OpenLv1 = get_open_lv(Cell1),
            OpenLv2 = get_open_lv(Cell2),
            if OpenLv1 > Player#player.lv orelse OpenLv2 > Player#player.lv ->
                {false, 22};
                true ->
                    Pet1 = get_cell_pet(StPet#st_pet.pet_list, Cell1),
                    Pet2 = get_cell_pet(StPet#st_pet.pet_list, Cell2),
                    %%直接互换位置
                    if Pet1#pet.type_id > 0 andalso Pet2#pet.type_id > 0 ->
                        PetList1 = [Pet1#pet{assist_cell = Cell2, is_change = 1} | lists:keydelete(Pet1#pet.key, #pet.key, StPet#st_pet.pet_list)],
                        PetList2 = [Pet2#pet{assist_cell = Cell1, is_change = 1} | lists:keydelete(Pet2#pet.key, #pet.key, PetList1)],
                        calc_assist_attribute(Player, StPet, PetList2);
                        Pet1#pet.type_id > 0 andalso Pet2#pet.type_id == 0 ->
                            PetList1 = [Pet1#pet{assist_cell = Cell2, is_change = 1} | lists:keydelete(Pet1#pet.key, #pet.key, StPet#st_pet.pet_list)],
                            calc_assist_attribute(Player, StPet, PetList1);
                        Pet1#pet.type_id == 0 andalso Pet2#pet.type_id > 0 ->
                            PetList1 = [Pet2#pet{assist_cell = Cell1, is_change = 1} | lists:keydelete(Pet2#pet.key, #pet.key, StPet#st_pet.pet_list)],
                            calc_assist_attribute(Player, StPet, PetList1);
                        true ->
                            {false, 0}
                    end
            end
    end.


get_cell_pet(PetList, Cell) ->
    case lists:keyfind(Cell, #pet.assist_cell, PetList) of
        false -> #pet{};
        Pet -> Pet
    end.

get_open_lv(Cell) ->
    data_pet_assist:get_lv(Cell).

