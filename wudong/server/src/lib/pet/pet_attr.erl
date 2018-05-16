%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 12:01
%%%-------------------------------------------------------------------
-module(pet_attr).
-author("hxming").

-include("common.hrl").
-include("pet.hrl").
-include("skill.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%获取宠物属性
get_pet_attribute() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    StPet#st_pet.attribute.


%%计算宠物总属性
calc_attribute(StPet) ->
    F = fun(Pet) -> calc_single_pet_attribute(StPet, Pet) end,
    PetList = lists:map(F, StPet#st_pet.pet_list),
    case lists:keyfind(?PET_STATE_FIGHT, #pet.state, PetList) of
        false ->
            Attribute = #attribute{},
            Cbp = 0;
        FightPet ->
            Attribute = FightPet#pet.attribute,
            Cbp = FightPet#pet.cbp
    end,
    StPet#st_pet{
        pet_list = PetList,
        attribute = Attribute,
        cbp = Cbp
    }.


%%计算单个宠物属性
calc_single_pet_attribute(StPet, Pet) ->
    AttributeList =
        [StPet#st_pet.stage_attribute
            , StPet#st_pet.pic_attribute
            , StPet#st_pet.assist_attribute
            , Pet#pet.star_attribute
            , Pet#pet.skill_attribute
            , StPet#st_pet.assist_acc_attribute
            , StPet#st_pet.assist_star_attribute
            , StPet#st_pet.assist_xh_attribute
            , StPet#st_pet.pic_normal_attribute
            , StPet#st_pet.pic_special_attribute
        ],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Pet#pet{attribute = Attribute, cbp = Cbp}.

%%计算星级属性
calc_pet_star_attribute(Pet) ->
    case data_pet_star:get(Pet#pet.star) of
        [] -> Pet;
        Base ->
            Pet#pet{star_attribute = attribute_util:make_attribute_by_key_val_list(Base#base_pet_star.attrs)}
    end.

%%计算技能属性
calc_pet_skill_attribute(Pet) ->
    F = fun({_, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill ->
                Skill#skill.attrs
        end
        end,
    AttrList = lists:flatmap(F, Pet#pet.skill),
    Attribute = attribute_util:make_attribute_by_key_val_list(AttrList),
    Pet#pet{skill_attribute = Attribute}.

%%计算阶数属性
calc_pet_stage_attribute(Stage, StageLv) ->
    case data_pet_stage:get(Stage, StageLv) of
        [] -> #attribute{};
        Base ->
            attribute_util:make_attribute_by_key_val_list(Base#base_pet_stage.attrs)
    end.

get_war_pet(StPet, Pet) ->
    AttributeList =
        [StPet#st_pet.stage_attribute, Pet#pet.star_attribute],
    Attribute = attribute_util:sum_attribute(AttributeList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    Pet#pet{attribute = Attribute, cbp = Cbp}.

%%计算图鉴属性
calc_pet_pic_attribute(FigureList) ->
    F = fun({FigureId, Lv}) ->
        if Lv == 0 -> [];
            true ->
                case data_pet_pic:get(FigureId) of
                    [] -> [];
                    Base ->
                        Base#base_pet_pic.attrs
                end
        end
        end,
    AttrList = lists:flatmap(F, FigureList),
    attribute_util:make_attribute_by_key_val_list(AttrList).


%%计算助战属性
calc_pet_assist_attribute(PetList) ->
    StarList = pet_assist:get_pet_assist_star_list(PetList),
    AttrList =
        lists:flatmap(fun({Pos, _}) -> data_pet_assist:get_attrs(Pos) end, StarList),
    F = fun(Id) ->
        PosList = pet_assist:id_to_cell(Id),
        F1 = fun(Pos) ->
            case lists:keyfind(Pos, 1, StarList) of
                false -> [];
                {_, Star} -> [Star]
            end
             end,
        PosStarList = lists:flatmap(F1, PosList),
        case length(PosStarList) >= 3 of
            false -> [];
            true ->
                StarSum = lists:sum(PosStarList),
                data_pet_assist_suit:get(Id, StarSum)
        end
        end,
    AttrList1 = lists:flatmap(F, lists:seq(1, 6)),
    attribute_util:make_attribute_by_key_val_list(AttrList ++ AttrList1).


calc_pet_assist_acc_attribute(PetList) ->
    Acc = calc_pet_assist_acc(PetList),
    F = fun(Count) ->
        data_pet_assist_acc:get(Count)
        end,
    AttrList = lists:flatmap(F, lists:seq(1, Acc)),
    case AttrList of
        [] -> #attribute{};
        _AttrList ->
            attribute_util:make_attribute_by_key_val_list(AttrList)
    end.

calc_pet_assist_acc(PetList) ->
    TypeList = [Pet#pet.type_id || Pet <- PetList, Pet#pet.state == ?PET_STATE_ASSIST],
    length(util:list_filter_repeat(TypeList)).


calc_pet_assist_star_attribute(PetList) ->
    Acc = calc_pet_assist_star(PetList),
    F = fun(Count) ->
        data_pet_assist_star:get(Count)
        end,
    AttrList = lists:flatmap(F, lists:seq(1, Acc)),
    case AttrList of
        [] -> #attribute{};
        _ ->
            attribute_util:make_attribute_by_key_val_list(AttrList)
    end.

calc_pet_assist_star(PetList) ->
    case [Pet#pet.star || Pet <- PetList, Pet#pet.state == ?PET_STATE_ASSIST] of
        [] -> 0;
        StarList ->
            lists:sum(StarList)
    end.

calc_pet_assist_xh_attribute(_PetList) ->
    #attribute{}.


calc_pet_acc_normal_attribute(PicList) ->
    Acc = calc_pet_acc(PicList, 1),
    F = fun(Count) ->
        data_pet_acc_normal:get(Count)
        end,
    AttrList = lists:flatmap(F, lists:seq(1, Acc)),
    case AttrList of
        [] -> #attribute{};
        _ ->
            attribute_util:make_attribute_by_key_val_list(AttrList)
    end.

calc_pet_acc(PicList, Type) ->
    F = fun({PicId, Stage}) ->
        if Stage > 0 ->
            case data_pet_pic:get(PicId) of
                #base_pet_pic{type = Type} ->
                    [PicId];
                _ -> []
            end;
            true -> []
        end
        end,
    IdList = lists:flatmap(F, PicList),
    length(util:list_filter_repeat(IdList)).


calc_pet_acc_special_attribute(PicList) ->
    Acc = calc_pet_acc(PicList, 2),
    F = fun(Count) ->
        data_pet_acc_special:get(Count)
        end,
    AttrList = lists:flatmap(F, lists:seq(1, Acc)),
    case AttrList of
        [] -> #attribute{};
        _ ->
            attribute_util:make_attribute_by_key_val_list(AttrList)
    end.