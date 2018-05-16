%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%     宠物蛋
%%% @end
%%% Created : 15. 五月 2017 11:56
%%%-------------------------------------------------------------------
-module(pet_egg).
-author("hxming").

-include("pet.hrl").
-include("goods.hrl").
-include("common.hrl").
%% API
-export([egg_info/1, open_egg/2, open_egg/3, open_pet_all/2, drop_egg/1]).

-export([egg2list/1, list2egg/1]).

egg2list(EggList) ->
    F = fun(Egg) ->
        {Egg#pet_egg.goods_key, Egg#pet_egg.pet_type_id, Egg#pet_egg.star}
        end,
    lists:map(F, EggList).

list2egg(EggList) ->
    F = fun({GoodsKey, PetTypeId, Star}) ->
        #pet_egg{goods_key = GoodsKey, pet_type_id = PetTypeId, star = Star}
        end,
    lists:map(F, EggList).

%%宠物蛋预览
egg_info(GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {27, 0, 0, 0, 0, 0, []};
        Goods ->
            GoodsType = data_goods:get(Goods#goods.goods_id),
            StPet = lib_dict:get(?PROC_STATUS_PET),
            case get_pet_egg(StPet, GoodsKey, GoodsType#goods_type.special_param_list) of
                false ->
                    {28, 0, 0, 0, 0, 0, []};
                PetEgg ->
                    BasePet = data_pet:get(PetEgg#pet_egg.pet_type_id),
                    {Figure, _} = hd(tuple_to_list(BasePet#base_pet.figure)),
                    {Cbp, AttList} = pet_egg_attr(PetEgg#pet_egg.star, Figure),
                    FigureState =
                        case lists:keymember(Figure, 1, StPet#st_pet.pic_list) of
                            false -> 0;
                            true -> 1
                        end,
                    Type =
                        case data_pet_pic:get(Figure) of
                            [] -> 1;
                            BasePic -> BasePic#base_pet_pic.type
                        end,
                    {1, Type, PetEgg#pet_egg.pet_type_id, PetEgg#pet_egg.star, Cbp, FigureState, AttList}
            end
    end.

pet_egg_attr(Star, Figure) ->
    StarAttrList =
        case data_pet_star:get(Star) of
            [] -> [];
            BaseStar -> BaseStar#base_pet_star.attrs
        end,
    PicAttrList =
        case data_pet_pic:get(Figure) of
            [] -> [];
            BasePic -> BasePic#base_pet_pic.attrs
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(StarAttrList ++ PicAttrList),
    Cbp = attribute_util:calc_combat_power(Attribute),
    {Cbp, attribute_util:pack_attr(PicAttrList)}.

get_pet_egg(StPet, GoodsKey, Type) ->
    StPet = lib_dict:get(?PROC_STATUS_PET),
    case lists:keyfind(GoodsKey, #pet_egg.goods_key, StPet#st_pet.egg_list) of
        false ->
            case data_pet_egg:get_type(Type) of
                [] -> false;
                TypeList ->
                    BaseEgg = rand_pet(TypeList),
                    Star = util:list_rand_ratio(BaseEgg#base_pet_egg.star_list),
                    PetEgg = #pet_egg{goods_key = GoodsKey, pet_type_id = BaseEgg#base_pet_egg.pet_type_id, star = Star},
                    EggList = [PetEgg | StPet#st_pet.egg_list],
                    NewStPet = StPet#st_pet{egg_list = EggList, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    PetEgg
            end;
        PetEgg ->
            PetEgg
    end.

rand_pet(TypeList) ->
    F = fun(Type) ->
        Base = data_pet_egg:get(Type),
        {Base, Base#base_pet_egg.ratio}
        end,
    RatioList = lists:map(F, TypeList),
    util:list_rand_ratio(RatioList).


%%领取宠物蛋
open_egg(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {27, Player};
        _Goods ->
            StPet = lib_dict:get(?PROC_STATUS_PET),
            case lists:keytake(GoodsKey, #pet_egg.goods_key, StPet#st_pet.egg_list) of
                false ->
                    {27, Player};
                {value, PetEgg, T} ->
                    goods:subtract_good_by_key(GoodsKey, 1),
                    NewStPet = StPet#st_pet{egg_list = T, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    NewPlayer = pet_util:create_pet(Player, PetEgg#pet_egg.pet_type_id, PetEgg#pet_egg.star),
                    {1, NewPlayer}
            end
    end.

%%使用全部宠物蛋
open_pet_all(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {27, [], Player};
        Goods ->
            Num = min(10, Goods#goods.num),
            StPet = lib_dict:get(?PROC_STATUS_PET),
            EggList = lists:keydelete(GoodsKey, #pet_egg.goods_key, StPet#st_pet.egg_list),
            goods:subtract_good_by_key(GoodsKey, Num),
            NewStPet = StPet#st_pet{egg_list = EggList, is_change = 1},
            lib_dict:put(?PROC_STATUS_PET, NewStPet),
            GoodsType = data_goods:get(Goods#goods.goods_id),
            F = fun(_, {Player1, L}) ->
                case data_pet_egg:get_type(GoodsType#goods_type.special_param_list) of
                    [] -> Player1;
                    TypeList ->
                        BaseEgg = rand_pet(TypeList),
                        Star = util:list_rand_ratio(BaseEgg#base_pet_egg.star_list),
                        Player2 = pet_util:create_pet(Player1, BaseEgg#base_pet_egg.pet_type_id, Star),
                        {Player2, [[BaseEgg#base_pet_egg.pet_type_id, Star] | L]}
                end
                end,
            {NewPlayer, PetLit} = lists:foldl(F, {Player, []}, lists:seq(1, Num)),
            {1, PetLit, NewPlayer}
    end.

%%领取宠物蛋,指定宠物
open_egg(Player, GoodsKey, PetId) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {{27, 0, 0, 0, 0, 0, []}, Player};
        _Goods ->
            GoodsType = data_goods:get(_Goods#goods.goods_id),
            if GoodsType#goods_type.subtype =/= 52 ->
                {{27, 0, 0, 0, 0, 0, []}, Player};
                true ->
                    case lists:member(PetId, tuple_to_list(GoodsType#goods_type.special_param_list)) of
                        false ->
                            {{29, 0, 0, 0, 0, 0, []}, Player};
                        true ->
                            case data_pet:get(PetId) of
                                [] ->
                                    {{29, 0, 0, 0, 0, 0, []}, Player};
                                BasePet ->
                                    goods:subtract_good_by_key(GoodsKey, 1),
                                    {NewPlayer, Pet} = pet_util:new_pet(Player, BasePet, 0),
                                    {Figure, _} = hd(tuple_to_list(BasePet#base_pet.figure)),
                                    StPet = lib_dict:get(?PROC_STATUS_PET),

                                    FigureState =
                                        case lists:keymember(Figure, 1, StPet#st_pet.pic_list) of
                                            false -> 0;
                                            true -> 1
                                        end,

                                    AttList = attribute_util:pack_attr(Pet#pet.attribute),

                                    Type =
                                        case data_pet_pic:get(Figure) of
                                            [] -> 1;
                                            BasePic -> BasePic#base_pet_pic.type
                                        end,
                                    Data = {1, Type, PetId, Pet#pet.star, Pet#pet.cbp, FigureState, AttList},
                                    {Data, NewPlayer}
                            end
                    end
            end
    end.

%%丢弃宠物蛋
drop_egg(GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> 27;
        _Goods ->
            goods:subtract_good_by_key(GoodsKey, 1),
            StPet = lib_dict:get(?PROC_STATUS_PET),
            case lists:keytake(GoodsKey, #pet_egg.goods_key, StPet#st_pet.egg_list) of
                false -> 1;
                {value, _PetEgg, T} ->
                    NewStPet = StPet#st_pet{egg_list = T, is_change = 1},
                    lib_dict:put(?PROC_STATUS_PET, NewStPet),
                    1
            end
    end.

