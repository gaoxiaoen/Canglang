%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备模块工具
%%% @end
%%% Created : 15. 一月 2015 15:19
%%%-------------------------------------------------------------------
-module(equip_util).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").

-export([
    get_equip_quality_total/0,
    get_equip_star_total/0,
    get_equip_lv_total/0,
    get_equip_strength_total/0,
    get_equip_stone_total/0,
    get_equip_stone_lv_lim/0,
    get_suit_cliet_list/1,
    get_equip_lv_num/0,
    get_all_equip_stren_lv/0,
    get_all_equip_star/0,
    get_equip_sum_lv/0,
    get_equip_wash/0,
    exchange_attr/2,
    wear_equip/9,
    equip_smelt/8
]).

-export([get_equip_color_list/1, get_equip_stren_list/1]).

%%获取身上装备品质总和
get_equip_quality_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    lists:sum([goods_util:get_goods_color(Goods#goods.goods_id) || Goods <- GoodsList]).

%%获取身上装备星级总和
get_equip_star_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    lists:sum([Goods#goods.star || Goods <- GoodsList]).

get_all_equip_stren_lv() ->
    GoodsList0 = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    GoodsList1 = lists:keydelete(129, #goods.cell, GoodsList0),
    GoodsList = lists:keydelete(132, #goods.cell, GoodsList1),
    case length(GoodsList) >= 10 of
        true ->
            MinFun1 = fun(Goods, MinLv) -> ?IF_ELSE(Goods#goods.stren < MinLv, Goods#goods.stren, MinLv) end,
            lists:foldl(MinFun1, 999, GoodsList);
        _ ->
            0
    end.

get_all_equip_star() ->
    GoodsList0 = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    GoodsList1 = lists:keydelete(129, #goods.cell, GoodsList0),
    GoodsList = lists:keydelete(132, #goods.cell, GoodsList1),
    case length(GoodsList) >= 10 of
        true ->
            MinFun1 = fun(Goods, MinLv) -> ?IF_ELSE(Goods#goods.star < MinLv, Goods#goods.star, MinLv) end,
            lists:foldl(MinFun1, 999, GoodsList);
        _ ->
            0
    end.

get_equip_lv_num() ->
    GoodsList0 = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    GoodsList1 = lists:keydelete(129, #goods.cell, GoodsList0),
    GoodsList = lists:keydelete(132, #goods.cell, GoodsList1),
    case length(GoodsList) > 0 of
        true ->
            MinFun1 = fun(Goods, {MinLv, LvList}) ->
                case data_goods:get(Goods#goods.goods_id) of
                    [] -> {MinLv, LvList};
                    GoodsType ->
                        NewMinLv = ?IF_ELSE(GoodsType#goods_type.equip_lv < MinLv, GoodsType#goods_type.equip_lv, MinLv),
                        {NewMinLv, [GoodsType#goods_type.equip_lv | LvList]}
                end
                      end,
            {EquipMinLv, List} = lists:foldl(MinFun1, {999, []}, GoodsList),
            Num = lists:sum([1 || Lv <- List, Lv >= EquipMinLv]),
            case [Lv || Lv <- List, Lv > EquipMinLv] of
                [] -> SecondMinLv = 0;
                Mlist ->
                    SecondMinLv = lists:min(Mlist)
            end,

            {EquipMinLv, SecondMinLv, Num, List};
        _ ->
            {0, 0, 0, []}
    end.


%%获取身上装备等级总和
get_equip_lv_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    F = fun(Goods) ->
        case lists:member(Goods#goods.goods_id, [30001, 30002, 30003, 30004]) of
            true -> 53;
            false ->
                Goods#goods.goods_lv
        end
        end,
    lists:sum(lists:map(F, GoodsList)).

%%获取身上装备强化总和
get_equip_strength_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    lists:sum([Goods#goods.stren || Goods <- GoodsList]).

%%获取身上装备总等级
get_equip_sum_lv() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    lists:sum([G#goods.goods_lv || G <- GoodsList]).

get_equip_wash() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    [G#goods.wash_attr || G <- GoodsList, G#goods.wash_attr =/= []].

%%获取身上装备石头总和
get_equip_stone_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    GemstoneGroove = lists:flatten([Goods#goods.gemstone_groove || Goods <- GoodsList]),
    lists:sum([data_gemstone_level:get(GoodsId) || {_, GoodsId} <- GemstoneGroove, GoodsId =/= 0]).

get_equip_stone_lv_lim() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    GemstoneGroove = lists:flatten([Goods#goods.gemstone_groove || Goods <- GoodsList]),
    case [data_gemstone_level:get(GoodsId) || {_, GoodsId} <- GemstoneGroove, GoodsId =/= 0] of
        [] -> 0;
        Lvs ->
            lists:min(Lvs)
    end.


get_suit_cliet_list(Player) ->
    StrengthLv = Player#player.max_stren_lv,
    StoneLv = Player#player.max_stone_lv,
%%    {PetStarList, AllStar} = lists:foldl(fun({Race, Star}, {Out, AllSOut}) ->
%%        case lists:keytake(Race, 1, Out) of
%%            false ->
%%                {[{Race, Star} | Out], AllSOut + Star};
%%            {value, {Race, OldS}, L1} ->
%%                {[{Race, OldS + Star} | L1], AllSOut + Star}
%%        end
%%                                         end, {[{1, 0}, {2, 0}, {3, 0}, {4, 0}], 0}, pet_star:get_pet_star_list()),
%%    PetClientStarList = [[K, V] || {K, V} <- PetStarList],
    {StrengthLv, StoneLv, 0, []}.


%% ---------------------------------------坐骑宠物精灵翅膀装备处理-------------------------------------------------------

exchange_attr(Goods1, Goods2) ->
    NewGoods1 = Goods1#goods{
        star = Goods2#goods.star,
        stren = Goods2#goods.stren,
        color = Goods2#goods.color},
    NewGoods2 = Goods2#goods{wash_attr = Goods1#goods.wash_attr,
        star = Goods1#goods.star,
        stren = Goods1#goods.stren,
        color = Goods1#goods.color},
    {NewGoods1, NewGoods2}.


wear_equip(Player, GoodsKey, DictIndex, LeftoverIndex, WearedIndex, EquipCheck, DataEquipStrength, DataEquipStrengthAttr, NewLocation) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Dict = erlang:element(DictIndex, GoodsSt),
    WearGoods = goods_util:get_goods(GoodsKey, Dict),
    WearGoodsType = data_goods:get(WearGoods#goods.goods_id),
    EquipCheck(WearGoods, WearGoodsType, Player),
    WearedEquipList = erlang:element(WearedIndex, GoodsSt),
    %%看看原来这个位置，是否已经佩戴了装备
    case lists:keyfind(WearGoodsType#goods_type.subtype, #weared_equip.pos, WearedEquipList) of
        false -> %%原来格子上没有配带装备
            ErrorCode = 1,
            NewWearGoods = WearGoods#goods{bind = ?BIND, cell = WearGoodsType#goods_type.subtype, location = ?GOODS_LOCATION_BODY},
            goods_load:dbup_goods_cell_location(NewWearGoods),
            NewGoodsDict = goods_dict:update_goods(NewWearGoods, Dict),
            goods_pack:pack_send_all_goods_info(NewLocation, [NewWearGoods], GoodsSt#st_goods.sid),
            LeftoverCellNum = erlang:element(LeftoverIndex, GoodsSt),
            GoodsSt1 = erlang:setelement(LeftoverIndex, GoodsSt, LeftoverCellNum + 1),
            GoodsSt2 = erlang:setelement(DictIndex, GoodsSt1, NewGoodsDict);
        OldWearedEquip -> %%原来这个格子上有装备，进行装备替换，把原来的装被放进背包
            ErrorCode = 18,
            OldGoods = goods_util:get_goods(OldWearedEquip#weared_equip.goods_key, Dict),
            {WearGoods0, OldGoods1} = equip_util:exchange_attr(WearGoods, OldGoods),
            {Exp, _Coin, MaxStrn} = DataEquipStrength:get(WearGoodsType#goods_type.equip_lv, WearGoodsType#goods_type.color),
            if
                WearGoods0#goods.color >= Exp andalso WearGoods0#goods.stren < MaxStrn ->
                    WearGoods1 = wear_equip_add_exp_loop(DataEquipStrengthAttr, MaxStrn, WearGoods0#goods{color = 0, stren = WearGoods0#goods.stren + 1}, OldGoods#goods.color - Exp),
                    goods_load:dbup_color(WearGoods1);
                true ->
                    WearGoods1 = WearGoods0
            end,
            OldGoods2 = OldGoods1#goods{location = NewLocation, cell = 0},
            NewWearGoods = WearGoods1#goods{location = ?GOODS_LOCATION_BODY, cell = WearGoodsType#goods_type.subtype},
            goods_load:dbup_goods(OldGoods2),
            goods_load:dbup_goods(NewWearGoods),
            goods_pack:pack_send_all_goods_info(NewLocation, [NewWearGoods, OldGoods2], GoodsSt#st_goods.sid),
            NewGoodsDict = goods_dict:update_goods([NewWearGoods, OldGoods2], Dict),
            GoodsSt2 = erlang:setelement(DictIndex, GoodsSt, NewGoodsDict)
    end,
    NewGoodsSt = equip_attr:equip_change_recalc_attribute(GoodsSt2, NewWearGoods),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    {ErrorCode, NewGoodsSt}.


wear_equip_add_exp_loop(DataEquipStrength, MaxStrn, Goods, LeftExp) ->
    EGoodsType = data_goods:get(Goods#goods.goods_id),
    {NeedExp, _} = DataEquipStrength:get(EGoodsType#goods_type.subtype, Goods#goods.stren + 1),
    if
        MaxStrn =< Goods#goods.stren ->
            Goods#goods{color = Goods#goods.color + LeftExp};
        Goods#goods.color + LeftExp >= NeedExp ->
            NewGoods = Goods#goods{color = 0, stren = Goods#goods.stren + 1},
            wear_equip_add_exp_loop(DataEquipStrength, MaxStrn, NewGoods, Goods#goods.color + LeftExp - NeedExp);
        true ->
            Goods#goods{color = Goods#goods.color + LeftExp}
    end.


equip_smelt(Player, DictIndex, LeftoverIndex, EquipGoodsKey, GoodsList, DataEquipStrength, DataEquipStrengthAttr, Location) ->
    %%去重检测
    lists:foldl(fun(Key, Out) ->
        case lists:member(Key, Out) of
            true -> throw({false, 14});
            false -> [Key | Out]
        end
                end, [], GoodsList),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    Dict = erlang:element(DictIndex, GoodsSt),
    EGoods = goods_util:get_goods(EquipGoodsKey, Dict),
    EGoodsType = data_goods:get(EGoods#goods.goods_id),
    {_, _, MaxStrn} = DataEquipStrength:get(EGoodsType#goods_type.equip_lv, EGoodsType#goods_type.color),
    BaseComBat = attribute_util:calc_combat_power(attribute_util:make_attribute_by_key_val_list(EGoodsType#goods_type.attr_list)),
    Fun = fun(GoodsKey, {AddExp, InNeedCoin, GoodsInfoList}) ->
        Goods = goods_util:get_goods(GoodsKey, Dict),
        GoodsType = data_goods:get(Goods#goods.goods_id),
        BaseComBat1 = attribute_util:calc_combat_power(attribute_util:make_attribute_by_key_val_list(GoodsType#goods_type.attr_list)),
        ?ASSERT(GoodsType#goods_type.subtype =:= EGoodsType#goods_type.subtype, {false, subtype}),
        ?ASSERT(BaseComBat >= BaseComBat1, {false, combat}),
        {Exp, Coin, _MaxStrn} = DataEquipStrength:get(GoodsType#goods_type.equip_lv, GoodsType#goods_type.color),
        {Exp + AddExp, Coin + InNeedCoin, [Goods | GoodsInfoList]}
          end,
    {NewAddExp, NeedCoin, GoodsInfoList} = lists:foldl(Fun, {0, 0, []}, GoodsList),
    ?ASSERT(money:is_enough(Player, NeedCoin, coin), {false, coin}),
    NewEGoods = wear_equip_add_exp_loop(DataEquipStrengthAttr, MaxStrn, EGoods, NewAddExp),
    NewDict = goods_dict:update_goods(NewEGoods, Dict),
    GoodsSt1 = erlang:setelement(DictIndex, GoodsSt, NewDict),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewEGoods),
    NewGoodsSt = del_equip_smelt_material(GoodsSt2, GoodsInfoList, DictIndex, LeftoverIndex, Location),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    goods_load:dbup_color(NewEGoods),
    goods_pack:pack_send_all_goods_info(Location, [NewEGoods], Player#player.sid),
    Player1 = money:add_coin(Player, -NeedCoin, 155, 0, 0),
    {ok, MaxStrn, NewEGoods, Player1}.

del_equip_smelt_material(GoodsSt, List, DictIndex, LeftoverIndex, Location) ->
    GoodsList = [Goods#goods{num = 0} || Goods <- List],
    Dict = erlang:element(DictIndex, GoodsSt),
    NewGoodsDict = goods_dict:update_goods(GoodsList, Dict),
    LeftoverCellNum = erlang:element(LeftoverIndex, GoodsSt),
    NewLeftoverCellNum = LeftoverCellNum + length(List),
    GoodsSt1 = erlang:setelement(LeftoverIndex, GoodsSt, NewLeftoverCellNum),
    GoodsSt2 = erlang:setelement(DictIndex, GoodsSt1, NewGoodsDict),
    goods_load:dbdel_goods(List),
    goods_pack:pack_send_all_goods_info(Location, GoodsList, GoodsSt#st_goods.sid),
    GoodsSt2.


%%成就
get_equip_color_list(EquipList) ->
    F = fun(Color) ->
        F1 = fun(Equip) ->
            case data_goods:get(Equip#goods.goods_id) of
                [] -> [];
                GoodsType ->
                    if GoodsType#goods_type.color >= Color -> [Equip];
                        true ->
                            []
                    end
            end
             end,
        case length(lists:flatmap(F1, EquipList)) of
            0 -> [];
            ColorLen ->
                [{Color, ColorLen}]
        end
        end,
    lists:flatmap(F, lists:seq(1, 5)).

get_equip_stren_list(EquipList) ->
    F = fun(Stren) ->
        case length([E || E <- EquipList, E#goods.stren >= Stren]) of
            0 -> [];
            StrenLen ->
                [{Stren, StrenLen}]
        end
        end,
    lists:flatmap(F, lists:seq(1, data_equip_strength:max_stren())).