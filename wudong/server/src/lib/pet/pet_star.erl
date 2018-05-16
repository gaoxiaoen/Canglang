%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 三月 2017 21:26
%%%-------------------------------------------------------------------
-module(pet_star).
-author("hxming").
-include("pet.hrl").
-include("server.hrl").
-include("skill.hrl").
-include("goods.hrl").
-include("achieve.hrl").
-include("common.hrl").

%% API
-export([star_up/4]).

-export([check_star_state/1]).

%%检查是否有宠物可升星
check_star_state(Player) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case StPet#st_pet.pet_list == [] of
        true ->
            0;
        false ->
            case data_menu_open:get(9) of
                BaseLv when Player#player.lv >= BaseLv ->
                    GoodsIdList = [1010005, 1010006, 1010007],
                    F = fun(GoodsId) -> goods_util:get_goods_count(GoodsId) > 0 end,
                    case lists:any(F, GoodsIdList) of
                        true -> 1;
                        false -> 0
                    end;
                _ ->
                    0
            end
    end.

%%升星
star_up(Player, PetKey, GoodsList, PetKeyList) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case check_star_up(StPet, PetKey, GoodsList, PetKeyList) of
        {false, Res} ->
            {false, Res};
        {ok, Pet, Exp} ->
            pet_map:delete_pet_list(PetKeyList),
            goods:subtract_good(Player, GoodsList, 192),
            Pet1 = do_star_up(Pet, Exp),
            Pet11 = ?IF_ELSE(Pet#pet.star /= Pet1#pet.star, pet:activate_skill_by_star(Pet1), Pet1),
            Pet2 = pet_attr:calc_pet_star_attribute(Pet11),

            pet_log:log_pet_star(Player#player.key, Player#player.nickname, PetKey, Pet#pet.type_id, Pet#pet.name, Pet2#pet.star, Pet2#pet.star_exp),

            F = fun(Key, L) ->
                pet_load:del_pet(Key),
                case lists:keytake(Key, #pet.key, L) of
                    false -> L;
                    {value, DelPet, T} ->
                        pet_log:log_pet(Player#player.key, Player#player.nickname, DelPet#pet.key, DelPet#pet.type_id, DelPet#pet.name, 2),
                        T
                end
                end,
            PetList = lists:foldl(F, StPet#st_pet.pet_list, PetKeyList),

            NewPetList = [Pet2#pet{is_change = 1} | lists:keydelete(Pet#pet.key, #pet.key, PetList)],
            if Pet#pet.star /= Pet2#pet.star ->
                %%重新计算助战属性
                AssistAttribute = pet_attr:calc_pet_assist_attribute(PetList),
                AssistStarAttribute = pet_attr:calc_pet_assist_star_attribute(PetList),
                StPet1 = StPet#st_pet{pet_list = NewPetList, assist_attribute = AssistAttribute, assist_star_attribute = AssistStarAttribute, is_change = 1},
                StPet2 = pet_attr:calc_attribute(StPet1),
                lib_dict:put(?PROC_STATUS_PET, StPet2),
                NewPlayer = player_util:count_player_attribute(Player, true),
                achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1012, 0, Pet2#pet.star),
                activity:get_notice(Player, [33, 46, 110], true),
                {ok, NewPlayer};
                true ->
                    lib_dict:put(?PROC_STATUS_PET, StPet#st_pet{pet_list = NewPetList, is_change = 1}),
                    {ok, Player}
            end
    end.


check_star_up(StPet, PetKey, GoodsList, PetKeyList) ->
    case lists:keyfind(PetKey, #pet.key, StPet#st_pet.pet_list) of
        false -> {false, 0};
        Pet ->
            case data_pet_star:get(Pet#pet.star) of
                [] -> {false, 0};
                BaseStar ->
                    if BaseStar#base_pet_star.exp == 0 -> {false, 15};
                        true ->
                            case check_goods_enough(GoodsList) of
                                false -> {false, 16};
                                Exp ->
                                    case check_pet_state(PetKeyList, Pet#pet.star, StPet#st_pet.pet_list, 0) of
                                        {false, Err} -> {false, Err};
                                        Exp1 ->
                                            {ok, Pet, Exp + Exp1}
                                    end
                            end
                    end
            end
    end.

%%检查材料是否足够
check_goods_enough(GoodsList) ->
    F = fun({GoodsId, Num}) ->
        goods_util:get_goods_count(GoodsId) < Num
        end,
    case lists:any(F, GoodsList) of
        true -> false;
        false ->
            F1 = fun({GoodsId, Num}) ->
                Goods = data_goods:get(GoodsId),
                round(Goods#goods_type.extra_val * Num)
                 end,
            lists:sum(lists:map(F1, GoodsList))
    end.

check_pet_state([], _, _L, Exp) -> Exp;
check_pet_state([Key | T], StarLv, PetList, Exp) ->
    case lists:keyfind(Key, #pet.key, PetList) of
        false -> {false, 0};
        Pet ->
            if Pet#pet.state == ?PET_STATE_FIGHT -> {false, 17};
                Pet#pet.state == ?PET_STATE_ASSIST -> {false, 18};
                true ->
                    case data_pet_star:get(Pet#pet.star) of
                        [] -> {false, 4};
                        BaseStar ->
                            check_pet_state(T, StarLv, PetList, Exp + BaseStar#base_pet_star.merge_exp)
                    end
            end
    end.


%%升星
do_star_up(Pet, Add) ->
    Exp = Pet#pet.star_exp + Add,
    case data_pet_star:get(Pet#pet.star) of
        [] -> Pet#pet{star = Pet#pet.star - 1, star_exp = 0};
        BaseStar ->
            if
                BaseStar#base_pet_star.exp == 0 ->
                    Pet#pet{star_exp = 0};
                Exp >= BaseStar#base_pet_star.exp ->
                    NewAdd = Exp - BaseStar#base_pet_star.exp,
                    do_star_up(Pet#pet{star = Pet#pet.star + 1, star_exp = 0}, NewAdd);
                true ->
                    Pet#pet{star_exp = Pet#pet.star_exp + Add}
            end
    end.
