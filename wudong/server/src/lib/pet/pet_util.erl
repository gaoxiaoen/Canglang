%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 15:56
%%%-------------------------------------------------------------------
-module(pet_util).
-author("hxming").

-include("pet.hrl").
-include("server.hrl").
-include("common.hrl").
-include("skill.hrl").
-include("achieve.hrl").
%% API
-export([
    create_pet/3,
    sort_pet_list/1,
    get_pet/2,
    get_pet_skill_for_battle/3,
    pet_name/1,
    calc_skill_cbp/0
]).

-export([new_pet/3]).

-export([cmd_pet/1]).

cmd_pet(Player) ->
    F = fun(PetId, P) ->
        create_pet(P, PetId, 0)
        end,
    NewPlayer = lists:foldl(F, Player, data_pet:get_all()),
    {ok, NewPlayer}.


%%获得宠物
create_pet(Player, PetId, Star) ->
    case data_pet:get(PetId) of
        [] -> Player;
        BasePet ->
            {NewPlayer, _} = new_pet(Player, BasePet, Star),
            NewPlayer
    end.

new_pet(Player, BasePet, Star) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    NewStar = ?IF_ELSE(Star == 0, BasePet#base_pet.star, Star),
    SKillList = [{Cell, SkillId} || {Cell, Star1, SkillId} <- BasePet#base_pet.skill_list, NewStar >= Star1],
    F = fun({FigureId1, Stage1}) ->
        if Stage1 =< StPet#st_pet.stage -> [FigureId1];true -> [] end
        end,
    BaseFigureId = hd(lists:flatmap(F, tuple_to_list(BasePet#base_pet.figure))),
    PetState =
        case lists:keymember(?PET_STATE_FIGHT, #pet.state, StPet#st_pet.pet_list) of
            true ->
                ?PET_STATE_FREE;
            false ->
                ?PET_STATE_FIGHT
        end,
    Pet = #pet{
        key = misc:unique_key(),
        type_id = BasePet#base_pet.id,
        name = BasePet#base_pet.name,
        figure = BaseFigureId,
        star = NewStar,
        skill = SKillList,
        state = PetState,
        time = util:unixtime(),
        is_change = 1
    },
    %%星级属性
    Pet1 = pet_attr:calc_pet_star_attribute(Pet),
    %%技能属性
    Pet2 = pet_attr:calc_pet_skill_attribute(Pet1),

    PetList = [Pet2 | StPet#st_pet.pet_list],
    %%当前形象
    FigureId = ?IF_ELSE(StPet#st_pet.figure == 0, Pet#pet.figure, StPet#st_pet.figure),
    StPet0 = StPet#st_pet{pet_list = PetList, figure = FigureId, is_change = 1},
    %%激活图鉴
    StPet1 = pet_pic:activate_pic(Player, StPet0, tuple_to_list(BasePet#base_pet.figure), PetState),
    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1010, 0, 1),
    StPet2 = pet_attr:calc_attribute(StPet1),
    lib_dict:put(?PROC_STATUS_PET, StPet2),
    pet_log:log_pet(Player#player.key, Player#player.nickname, Pet#pet.key, BasePet#base_pet.id, Pet#pet.name, 1),
    Player1 = player_util:count_player_attribute(Player, true),
    PetFinal = lists:keyfind(Pet#pet.key, #pet.key, StPet2#st_pet.pet_list),
    fashion_suit:active_icon_push(Player1),
    if StPet#st_pet.pet_list == [] ->
        Fpet = pet_init:fight_pet(PetFinal, StPet0#st_pet.figure, StPet0#st_pet.stage),
        NewPlayer = Player1#player{pet = Fpet},
        scene_agent_dispatch:pet_update(NewPlayer),
        {NewPlayer, PetFinal};
        true ->
            {Player1, PetFinal}
    end.

sort_pet_list(PetList) ->
    F = fun(Pet1, Pet2) ->
        if
            Pet1#pet.state > Pet2#pet.state -> true;
            Pet1#pet.state == Pet2#pet.state andalso Pet1#pet.star > Pet2#pet.star -> true;
            true ->
                false
        end

        end,
    lists:sort(F, PetList).


get_pet(PetList, Key) ->
    case lists:keyfind(Key, #pet.key, PetList) of
        false -> #pet{};
        Pet -> Pet
    end.


%%提取战斗技能
get_pet_skill_for_battle(SkillList, SkillCd, AiParams) ->
    F = fun({_, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> false;
            Skill ->
                Skill#skill.type == 5 andalso Skill#skill.subtype == 0
        end
        end,
    BattleSkills = lists:filter(F, SkillList),
    CanUseList = get_pet_skill(BattleSkills, [], SkillCd, util:unixtime(), AiParams),
    case util:list_shuffle(CanUseList) of
        [SkillId | _] ->
            SkillId;
        _ ->
            0
    end.

get_pet_skill([], CanUseList, _CdList, _Now, _AiParams) ->
    CanUseList;
get_pet_skill([{_, SkillId} | L], CanUseList, CdList, Now, AiParams) ->
    NewCanUseList =
        case lists:keyfind(SkillId, 1, CdList) of
            false ->
                [SkillId | CanUseList];
            {SkillId, ExpireTime} ->
                if
                    ExpireTime > Now ->
                        CanUseList;
                    true ->
                        [SkillId | CanUseList]
                end
        end,
    get_pet_skill(L, NewCanUseList, CdList, Now, AiParams).


pet_name(FigureId) ->
    case data_pet_pic:get(FigureId) of
        [] -> false;
        Base ->
            case data_pet:get(Base#base_pet_pic.pet_id) of
                [] -> false;
                BasePet -> BasePet#base_pet.name
            end
    end.

%%计算技能战力
calc_skill_cbp() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    F = fun(Pet) ->
        if Pet#pet.state == ?PET_STATE_FIGHT ->
            pet_skill_cbp(Pet);
            true -> []
        end
        end,
    CbpList = lists:flatmap(F, StPet#st_pet.pet_list),
    lists:sum(CbpList).

pet_skill_cbp(Pet) ->
    F = fun({_, SkillId}) ->
        case data_skill:get(SkillId) of
            [] -> 0;
            Skill ->
                Skill#skill.skill_cbp
        end
        end,
    lists:map(F, Pet#pet.skill).