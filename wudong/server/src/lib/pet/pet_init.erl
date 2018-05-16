%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 10:34
%%%-------------------------------------------------------------------
-module(pet_init).
-author("hxming").


-include("pet.hrl").
-include("server.hrl").
-include("common.hrl").
%% API
-export([init/1,
    logout/0,
    timer_update/0
]).

-export([fight_pet/3]).

init(Player) ->
    StPet_1 =
        case player_util:is_new_role(Player) of
            true ->
                #st_pet{pkey = Player#player.key};
            false ->
                PetList = init_pet(Player#player.key),
                case pet_load:load_pet(Player#player.key) of
                    [] ->
                        #st_pet{pkey = Player#player.key, pet_list = PetList};
                    [FigureId, Stage, StageLv, StageExp, PicList, EggListBin] ->
                        EggList = pet_egg:list2egg(util:bitstring_to_term(EggListBin)),
                        #st_pet{pkey = Player#player.key, figure = FigureId, stage = Stage, stage_lv = StageLv, stage_exp = StageExp, pic_list = util:bitstring_to_term(PicList), pet_list = PetList, egg_list = EggList}
                end

        end,
    StPet = pet_pic:init_fix_pic(StPet_1),
    %%计算阶数战力
    StageAttribute = pet_attr:calc_pet_stage_attribute(StPet#st_pet.stage, StPet#st_pet.stage_lv),
    %%图鉴
    PicAttribute = pet_attr:calc_pet_pic_attribute(StPet#st_pet.pic_list),
    PicNormalAttribute = pet_attr:calc_pet_acc_normal_attribute(StPet#st_pet.pic_list),
    PicSpecialAttribute = pet_attr:calc_pet_acc_special_attribute(StPet#st_pet.pic_list),
    %%计算助战属性
    AssistAttribute = pet_attr:calc_pet_assist_attribute(StPet#st_pet.pet_list),
    AssistAccAttribute = pet_attr:calc_pet_assist_acc_attribute(StPet#st_pet.pet_list),
    AssistStarAttribute = pet_attr:calc_pet_assist_star_attribute(StPet#st_pet.pet_list),
    AssistXhAttribute = pet_attr:calc_pet_assist_xh_attribute(StPet#st_pet.pet_list),
    StPet0 = StPet#st_pet{
        stage_attribute = StageAttribute,
        pic_attribute = PicAttribute,
        pic_normal_attribute = PicNormalAttribute,
        pic_special_attribute = PicSpecialAttribute,
        assist_attribute = AssistAttribute,
        assist_acc_attribute = AssistAccAttribute,
        assist_star_attribute = AssistStarAttribute,
        assist_xh_attribute = AssistXhAttribute
    },
    StPet1 = pet_attr:calc_attribute(StPet0),
    Fpet = init_fight_pet(StPet1#st_pet.pet_list, StPet1#st_pet.figure, StPet1#st_pet.stage),
    lib_dict:put(?PROC_STATUS_PET, StPet1),
    Player#player{pet = Fpet}.


%%初始化宠物 pet_key,type_id,name,figure,star,star_exp,state,assist_cell,time,skill
init_pet(Pkey) ->
    case pet_load:load_pet_list(Pkey) of
        [] -> [];
        PetList ->
            F = fun([Key, TypeId, Name, Figure, Star, StarExp, State, AssistCell, Time, Skill]) ->
                Pet = #pet{
                    key = Key,
                    type_id = TypeId,
                    name = Name,
                    figure = Figure,
                    star = Star,
                    star_exp = StarExp,
                    state = State,
                    assist_cell = AssistCell,
                    time = Time,
                    skill = util:bitstring_to_term(Skill)
                },
                Pet1 = pet_attr:calc_pet_star_attribute(Pet),
                Pet2 = pet_attr:calc_pet_skill_attribute(Pet1),
                Pet2
                end,
            lists:map(F, PetList)
    end.

init_fight_pet(PetList, FigureId, Stage) ->
    case lists:keyfind(?PET_STATE_FIGHT, #pet.state, PetList) of
        false -> #fpet{};
        Pet ->
            fight_pet(Pet, FigureId, Stage)
    end.


fight_pet(Pet, FigureId, Stage) ->
    BasePet = data_pet:get(Pet#pet.type_id),
    NowFigure = ?IF_ELSE(FigureId > 0, FigureId, Pet#pet.figure),
    PetName =
        case pet_util:pet_name(NowFigure) of
            false -> Pet#pet.name;
            Name -> Name
        end,
    #fpet{
        type_id = Pet#pet.type_id,
        name = PetName,
        figure = NowFigure,
        star = Pet#pet.star,
        stage = Stage,
        att_param = BasePet#base_pet.att_param,
        skill = Pet#pet.skill
    }.


timer_update() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    if StPet#st_pet.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_PET, StPet#st_pet{is_change = 0}),
        pet_load:replace_pet(StPet);
        true -> ok
    end.

logout() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    if StPet#st_pet.is_change == 1 ->
        pet_load:replace_pet(StPet);
        true -> ok
    end.


