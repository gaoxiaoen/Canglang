%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 10:34
%%%-------------------------------------------------------------------
-module(pet).
-author("hxming").
-include("pet.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("common.hrl").
-include("tips.hrl").
%% API
-export([
    pet_list/0,
    pet_info/1,
    fight_pet/2,
    upgrade_skill/3
]).

-export([activate_skill_by_star/1, check_skill_state/0, check_skill_state_tips/2, check_cbp_state/0]).

%%获取宠物列表
pet_list() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    F = fun(Pet) ->
        [Pet#pet.key, Pet#pet.type_id, Pet#pet.figure, Pet#pet.state, Pet#pet.star, Pet#pet.cbp]
        end,
    lists:map(F, pet_util:sort_pet_list(StPet#st_pet.pet_list)).

%%查询单个宠物信息
pet_info(Key) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keyfind(Key, #pet.key, StPet#st_pet.pet_list) of
        false ->
            {0, 0, 0, 0, 0, 0, <<>>, 0, 0, 0, 0, [], []};
        Pet ->
            SkillList = pack_skill(Pet),
            StarExpLim =
                case data_pet_star:get(Pet#pet.star) of
                    [] -> 0;
                    BaseStar -> BaseStar#base_pet_star.exp
                end,
            {Key, Pet#pet.type_id, StPet#st_pet.stage, Pet#pet.star, Pet#pet.star_exp, StarExpLim,
                Pet#pet.name, Pet#pet.figure, StPet#st_pet.figure, Pet#pet.state,
                Pet#pet.cbp, attribute_util:pack_attr(Pet#pet.attribute), SkillList}
    end.

%%打包技能列表
pack_skill(Pet) ->
    BasePet = data_pet:get(Pet#pet.type_id),
    F = fun({Cell, Star, SkillId}) ->
        case lists:keyfind(Cell, 1, Pet#pet.skill) of
            false ->
                [Cell, SkillId, 0, Star];
            {_, CurSkillId} ->
                case data_skill:get(CurSkillId) of
                    [] ->
                        [Cell, 0, 0, Star];
                    Skill ->
                        case Skill#skill.goods of
                            {} ->
                                [Cell, CurSkillId, 0, Star];
                            {GoodsId, Num} ->
                                Count = goods_util:get_goods_count(GoodsId),
                                if Count >= Num ->
                                    [Cell, CurSkillId, 2, Star];
                                    true ->
                                        [Cell, CurSkillId, 1, Star]
                                end
                        end

                end
        end
        end,
    lists:map(F, BasePet#base_pet.skill_list).

%%宠物出战
fight_pet(Player, Key) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keytake(Key, #pet.key, StPet#st_pet.pet_list) of
        false ->
            {4, Player};
        {value, Pet, T} ->
            if Pet#pet.state == ?PET_STATE_FIGHT ->
                {5, Player};
                Pet#pet.state == ?PET_STATE_ASSIST ->
                    %%助攻
                    T1 = reset_fight_pet_state(T, ?PET_STATE_ASSIST, Pet#pet.assist_cell),
                    PetList = [Pet#pet{state = ?PET_STATE_FIGHT, assist_cell = 0, is_change = 1} | T1],
                    %%重新计算助战属性
                    AssistAttribute = pet_attr:calc_pet_assist_attribute(PetList),
                    AssistAccAttribute = pet_attr:calc_pet_assist_acc_attribute(PetList),
                    AssistStarAttribute = pet_attr:calc_pet_assist_star_attribute(PetList),
                    AssistXhAttribute = pet_attr:calc_pet_assist_xh_attribute(PetList),
                    StPet1 = StPet#st_pet{pet_list = PetList, assist_attribute = AssistAttribute, assist_acc_attribute = AssistAccAttribute,assist_star_attribute = AssistStarAttribute,assist_xh_attribute = AssistXhAttribute,is_change = 1},
                    NewStPet = pet_attr:calc_attribute(StPet1),
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    Fpet = pet_init:fight_pet(Pet, StPet1#st_pet.figure, NewStPet#st_pet.stage),
                    {1, NewPlayer#player{pet = Fpet}};
                true ->
                    T1 = reset_fight_pet_state(T, ?PET_STATE_FREE),
                    PetList = [Pet#pet{state = ?PET_STATE_FIGHT, assist_cell = 0, is_change = 1} | T1],
                    StPet1 = StPet#st_pet{pet_list = PetList, is_change = 1},
                    NewStPet = pet_attr:calc_attribute(StPet1),
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    Fpet = pet_init:fight_pet(Pet, StPet1#st_pet.figure, NewStPet#st_pet.stage),
                    {1, NewPlayer#player{pet = Fpet}}
            end
    end.


reset_fight_pet_state(PetList, State) ->
    F = fun(Pet) ->
        ?IF_ELSE(Pet#pet.state == ?PET_STATE_FIGHT, Pet#pet{state = State, assist_cell = 0, is_change = 1}, Pet)
        end,
    lists:map(F, PetList).

reset_fight_pet_state(PetList, State, Cell) ->
    F = fun(Pet) ->
        ?IF_ELSE(Pet#pet.state == ?PET_STATE_FIGHT, Pet#pet{state = State, assist_cell = Cell, is_change = 1}, Pet)
        end,
    lists:map(F, PetList).

%%检查出战宠物是否有技能可升级
check_skill_state() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keyfind(?PET_STATE_FIGHT, #pet.state, StPet#st_pet.pet_list) of
        false -> 0;
        Pet ->
            F1 = fun({_Cell, SkillId}) ->
                case data_skill:get(SkillId) of
                    [] -> false;
                    Skill ->
                        if Skill#skill.next_skillid == 0 -> false;
                            true ->
                                case Skill#skill.goods of
                                    {} -> false;
                                    {GoodsId, Num} ->
                                        Count = goods_util:get_goods_count(GoodsId),
                                        if Count > Num -> true;
                                            true -> false

                                        end
                                end
                        end
                end
                 end,
            case lists:any(F1, Pet#pet.skill) of
                true -> 1;
                false -> 0
            end
    end.

%% 战力替换提示红点
check_cbp_state() ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    F0 = fun(#pet{cbp = Cbp1}, #pet{cbp = Cbp2}) ->
        Cbp1 > Cbp2
    end,
    F1 = fun(#pet{state = State}) ->
        State =:= 0
    end,
    %% 休闲宠物
    PetList1 = lists:sort(F0, lists:filter(F1, StPet#st_pet.pet_list)),
    F2 = fun(#pet{state = State}) ->
        State =:= 1
    end,
    %% 出战宠物
    PetList2 = lists:sort(F0, lists:filter(F2, StPet#st_pet.pet_list)),
    if
        PetList1 == [] -> 0;
        PetList2 == [] -> 0;
        true ->
            Pet1 = hd(lists:reverse(PetList1)),
            Pet2 = hd(PetList2),
            ?IF_ELSE(Pet1#pet.cbp < Pet2#pet.cbp, 1, 0)
    end.

check_skill_state_tips(_Player, Tips) ->
    State = check_skill_state(),
    ?IF_ELSE(State == 1, Tips#tips{state = 1}, Tips).


%%升级技能
upgrade_skill(Player, Key, Cell) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keytake(Key, #pet.key, StPet#st_pet.pet_list) of
        false -> {4, Player};
        {value, Pet, T} ->
            case lists:keytake(Cell, 1, Pet#pet.skill) of
                false -> {6, Player};
                {value, {_, SkillId}, L} ->
                    case data_skill:get(SkillId) of
                        [] -> {7, Player};
                        Skill ->
                            if Skill#skill.next_skillid == 0 -> {8, Player};
                                true ->
                                    case Skill#skill.goods of
                                        {} -> {9, Player};
                                        {GoodsId, Num} ->
                                            Count = goods_util:get_goods_count(GoodsId),
                                            if Count < Num ->
                                                goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 191),
                                                {10, Player};
                                                true ->
                                                    goods:subtract_good(Player, [{GoodsId, Num}], 191),
                                                    Pet1 = Pet#pet{skill = [{Cell, Skill#skill.next_skillid} | L], is_change = 1},
                                                    %%技能属性
                                                    Pet2 = pet_attr:calc_pet_skill_attribute(Pet1),
                                                    PetList = [Pet2 | T],
                                                    StPet1 = StPet#st_pet{pet_list = PetList, is_change = 1},
                                                    pet_log:log_pet_skill(Player#player.key, Player#player.nickname, Pet#pet.key, Pet#pet.type_id, Pet#pet.name, Pet#pet.skill, Pet1#pet.skill),
                                                    if Pet#pet.state == ?PET_STATE_FIGHT ->
                                                        NewStPet = pet_attr:calc_attribute(StPet1),
                                                        Fpet = pet_init:fight_pet(Pet1, StPet#st_pet.figure, NewStPet#st_pet.stage),
                                                        lib_dict:put(?PROC_STATUS_PET, NewStPet),
                                                        NewPlayer = player_util:count_player_attribute(Player, true),
                                                        activity:get_notice(Player, [110], true),
                                                        {ok, NewPlayer#player{pet = Fpet}};
                                                        true ->
                                                            lib_dict:put(?PROC_STATUS_PET, StPet1),
                                                            activity:get_notice(Player, [110], true),
                                                            {1, Player}
                                                    end
                                            end
                                    end
                            end
                    end
            end
    end.

%%升星激活技能
activate_skill_by_star(Pet) ->
    case data_pet:get(Pet#pet.type_id) of
        [] -> Pet;
        Base ->
            F = fun({Cell, Star, SkillId}, L) ->
                case lists:keymember(Cell, 1, L) of
                    true -> L;
                    false ->
                        if Pet#pet.star >= Star ->
                            [{Cell, SkillId} | L];
                            true ->
                                L
                        end
                end
                end,
            SkillList = lists:foldl(F, Pet#pet.skill, Base#base_pet.skill_list),
            Pet1 = Pet#pet{skill = SkillList},
            pet_attr:calc_pet_skill_attribute(Pet1)
    end.

