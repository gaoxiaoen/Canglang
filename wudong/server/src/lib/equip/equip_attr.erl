%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备属性计算
%%% @end
%%% Created : 17. 一月 2015 16:35
%%%-------------------------------------------------------------------
-module(equip_attr).
-include("goods.hrl").
-include("equip.hrl").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    get_equip_all_attribute/0,
    calc_singleton_equip_attribute/1,
    get_equip_suit_attribute/0,
    equip_suit_calc/1,
    calc_strength_all_attr/0
]).

%%属性计算工具
-export([
    equip_change_recalc_attribute/2, %%单件装备发生变化，属性需要重新计算
    equip_combat_power/1,
    equip_combat_power/2
]).

-export([strength_lv/0, stone_lv/0, soul_lv/0, stone_active/1, soul_active/1, calc_soul_all_attr/0]).

get_equip_suit_attribute() ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    attribute_util:sum_attribute([GoodsStatus#st_goods.stone_suit_attribute, GoodsStatus#st_goods.stren_suit_attribute, GoodsStatus#st_goods.soul_suit_attribute]).

get_equip_all_attribute() ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsStatus#st_goods.equip_attribute.


%%穿在身上单件装备，发生变化属性需要重新计算
equip_change_recalc_attribute(GoodsSt, Goods) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    WearedEquipList = GoodsSt#st_goods.weared_equip,
    Attribute = calc_singleton_equip_attribute(Goods),
    case lists:keytake(GoodsType#goods_type.subtype, #weared_equip.pos, WearedEquipList) of
        false -> %%穿装备
            WearedEquip = #weared_equip{pos = GoodsType#goods_type.subtype,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                equip_attribute = Attribute},
            NewEearedEquipList = [WearedEquip | WearedEquipList];
        {value, WearedEquip, WearedEquipList1} ->    %%装备替换
            NewWearedEquip = WearedEquip#weared_equip{
                goods_id = Goods#goods.goods_id,
                goods_key = Goods#goods.key,
                equip_attribute = Attribute},
            NewEearedEquipList = [NewWearedEquip | WearedEquipList1];
        _ -> %%异常情况
            ?PRINT("equip_change_recalc_attribute error ~p ~n Goods#goods.key ~p ~n ~p ~p ~n ", [WearedEquipList, Goods#goods.key, Goods#goods.cell, lists:keytake(Goods#goods.cell, #weared_equip.pos, WearedEquipList)]),
            NewEearedEquipList = WearedEquipList
    end,
    SumEquipAttribute = attribute_util:sum_attribute([WearedEquip#weared_equip.equip_attribute || WearedEquip <- NewEearedEquipList]),
    GoodsSt#st_goods{equip_attribute = SumEquipAttribute, weared_equip = NewEearedEquipList}.

%%计算单件装备的属性
calc_singleton_equip_attribute(Goods) ->
    case catch
        begin
            GoodsTypeInfo = data_goods:get(Goods#goods.goods_id),
            BaseAttr = attribute_util:make_attribute_by_key_val_list(GoodsTypeInfo#goods_type.attr_list),
            Attribute1 = calc_strengthen_after_attribute(BaseAttr, Goods, GoodsTypeInfo), %在物品基础属性上叠加强化属性
            Washattrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.wash_attr), %%加上洗练属性
            Attribute2 = attribute_util:sum_attribute([Attribute1, Washattrs]),
            Attribute3 = calc_stone_socket_attribute(Attribute2, Goods#goods.gemstone_groove), %%加上镶嵌属性
            RefineAttrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.refine_attr), %%精炼属性
            Attribute4 = attribute_util:sum_attribute([Attribute3, RefineAttrs]),%% 加上精炼属性
            Attribute5 = calc_god_forging_after_attribute(Attribute4, Goods, GoodsTypeInfo), %% 加上神炼属性
            MagicAttrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.magic_attrs), %% 附魔属性
            Attribute6 = attribute_util:sum_attribute([Attribute5, MagicAttrs]),%% 加上附魔属性
            SoulAttrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.soul_attrs), %% 武魂属性
            Attribute7 = attribute_util:sum_attribute([Attribute6, SoulAttrs]),%% 加上武魂属性
            FixAttrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.fix_attrs), %% 固定属性
            Attribute8 = attribute_util:sum_attribute([Attribute7, FixAttrs]),%%
            RandAttrs = attribute_util:make_attribute_by_key_val_list(Goods#goods.random_attrs), %% 固定属性
            Attribute9 = attribute_util:sum_attribute([Attribute8, RandAttrs]),%%
            Attribute10 = calc_level_after_attribute(Attribute9, Goods, GoodsTypeInfo), %% 加上等级属性
            Attribute10
        end of
        EquipAttribute when is_record(EquipAttribute, attribute) ->
            EquipAttribute;
        Error ->
            ?PRINT("calc_singleton_equip_attribute error ~p ~n", [Error]),
            #attribute{}
    end.


%%计算全套装备强化套装属性加成
calc_strength_all_attr() ->
    StrengthLv = strength_lv(),
    CurStrengthLv =
        case [Lv || Lv <- data_equip_strength_suit:ids(), Lv =< StrengthLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_strength_suit:get(CurStrengthLv)),
    {StrengthLv, Attribute}.

%%计算全套装备 武魂套装属性加成
calc_soul_all_attr() ->
    SoulLv = soul_lv(),
    CurStrengthLv =
        case [Lv || Lv <- data_equip_soul_suit:ids(), Lv =< SoulLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_soul_suit:get(CurStrengthLv)),
    {SoulLv, Attribute}.

soul_lv() ->
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    SubTypeList = data_equip_strength:ids(),
    F = fun(SubType) ->
        case lists:keyfind(SubType, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
            false -> 0;
            Soul ->
                Soul#st_soul_info.info_list,
                F0 = fun({_, _, Gid}) ->
                    case data_equip_soul:get_gid(Gid) of
                        [] -> 0;
                        Base -> Base#base_equip_soul.lv
                    end
                end,
                lists:map(F0, Soul#st_soul_info.info_list)
        end
    end,
    LvList = lists:flatmap(F, SubTypeList),
    case length(LvList) == length(SubTypeList) * 5 of
        false -> 0;
        true ->
            lists:min(LvList)
    end.


soul_active(Lv) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = goods_util:get_goods_list_by_location(GoodsSt, ?GOODS_LOCATION_BODY),
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    SubTypeList = data_equip_strength:ids(),
    F = fun(Equip) ->
        GoodsType = data_goods:get(Equip#goods.goods_id),
        case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
            false -> [];
            #st_soul_info{info_list = InfoList} ->
                F0 = fun({_, _, Gid}) ->
                    case data_equip_soul:get_gid(Gid) of
                        [] -> 0;
                        Base -> Base#base_equip_soul.lv
                    end
                end,
                lists:map(F0, InfoList)
        end
    end,
    LvList = lists:flatmap(F, EquipList),
    {length([Lv1 || Lv1 <- LvList, Lv1 >= Lv]), length(SubTypeList) * 5}.

strength_lv() ->
    StStrength = lib_dict:get(?PROC_STATUS_EQUIP_STRENTH),
    F = fun(SubType) ->
        case lists:keyfind(SubType, #equip_strength.subtype, StStrength#st_strength_exp.exp_list) of
            false -> 0;
            Strength -> Strength#equip_strength.strength
        end
    end,
    case lists:map(F, data_equip_strength:ids()) of
        [] -> 0;
        StrengthList ->
            lists:min(StrengthList)
    end.

%%计算全套装备镶嵌套装属性加成
calc_inlay_all_attr() ->
    StoneLv = stone_lv(),
    CurStoneLv =
        case [Lv || Lv <- data_equip_inlay_suit:ids(), Lv =< StoneLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_inlay_suit:get(CurStoneLv)),
    {StoneLv, Attribute}.

stone_lv() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = goods_util:get_goods_list_by_location(GoodsSt, ?GOODS_LOCATION_BODY),
    SubTypeList = data_equip_strength:ids(),
    F = fun(Equip) ->
        case data_goods:get(Equip#goods.goods_id) of
            [] -> [];
            GoodsType ->
                case lists:member(GoodsType#goods_type.subtype, SubTypeList) of
                    false -> [];
                    true ->
                        [data_gemstone_level:get(Gid) || {_SubType, Gid} <- Equip#goods.gemstone_groove]
                end
        end
    end,
    LvList = lists:flatmap(F, EquipList),
    case length(LvList) == length(SubTypeList) * 3 of
        false -> 0;
        true ->
            lists:min(LvList)
    end.

stone_active(Lv) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = goods_util:get_goods_list_by_location(GoodsSt, ?GOODS_LOCATION_BODY),
    SubTypeList = data_equip_strength:ids(),
    F = fun(Equip) ->
        GoodsType = data_goods:get(Equip#goods.goods_id),
        case lists:member(GoodsType#goods_type.subtype, SubTypeList) of
            false -> [];
            true ->
                [data_gemstone_level:get(Gid) || {_SubType, Gid} <- Equip#goods.gemstone_groove]
        end
    end,
    LvList = lists:flatmap(F, EquipList),
    {length([Lv1 || Lv1 <- LvList, Lv1 >= Lv]), length(SubTypeList) * 3}.


%%计算强化附加属性
calc_strengthen_after_attribute(BaseAttribute, Goods, GoodsTypeInfo) when GoodsTypeInfo#goods_type.type =:= 1 ->
    case data_equip_strength:get(GoodsTypeInfo#goods_type.subtype, Goods#goods.stren) of
        [] -> BaseAttribute;
        Base ->
            Attr1 = attribute_util:make_attribute_by_key_val_list(Base#base_equip_strength.attrs),
            attribute_util:sum_attribute([Attr1, BaseAttribute])
    end;

%%计算强化附加属性
calc_strengthen_after_attribute(BaseAttribute, _, _) ->
    BaseAttribute.

%%计算神炼附加属性
calc_god_forging_after_attribute(BaseAttribute, Goods, GoodsTypeInfo) when GoodsTypeInfo#goods_type.type =:= 1 ->
    case data_equip_god_forging:get(GoodsTypeInfo#goods_type.subtype, Goods#goods.god_forging) of
        [] -> BaseAttribute;
        Base ->
            Attr1 = attribute_util:make_attribute_by_key_val_list(Base#base_equip_god_forging.attrs),
            attribute_util:sum_attribute([Attr1, BaseAttribute])
    end;

%%计算强化附加属性
calc_god_forging_after_attribute(BaseAttribute, _, _) ->
    BaseAttribute.


%%计算等级附加属性
calc_level_after_attribute(BaseAttribute, Goods, GoodsTypeInfo) when GoodsTypeInfo#goods_type.type =:= 1 ->
    case data_equip_level_att:get(GoodsTypeInfo#goods_type.subtype, Goods#goods.level) of
        [] ->
            ?DEBUG("[][] ~n"),
            BaseAttribute;
        Attr ->
            ?DEBUG("Attr ~p~n", [Attr]),
            Attr1 = attribute_util:make_attribute_by_key_val_list(Attr),
            attribute_util:sum_attribute([Attr1, BaseAttribute])
    end;
%%计算等级附加属性
calc_level_after_attribute(BaseAttribute, _, _) ->
    BaseAttribute.

%%计算镶嵌附加属性
calc_stone_socket_attribute(Attribute, []) ->
    Attribute;
calc_stone_socket_attribute(Attribute, StoneList) ->
    AttributeList = [attribute_util:make_attribute_by_key_val_list(data_equip_inlay:get(StoneId)) || {_, StoneId} <- StoneList, StoneId =/= 0],
    attribute_util:sum_attribute([Attribute | AttributeList]).

%%装备强化/镶嵌/武魂套装属性
equip_suit_calc(Player) ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    {StrengthLv, StrengthAttr} = equip_attr:calc_strength_all_attr(),
    {InlayLv, InlayAttr} = calc_inlay_all_attr(),
    {SoulLv, SoulAttr} = calc_soul_all_attr(),
    NewPlayer = Player#player{max_stren_lv = StrengthLv, max_stone_lv = InlayLv, soul_lv = SoulLv},
    NewGoodsStatus = GoodsStatus#st_goods{stren_suit_attribute = StrengthAttr, stone_suit_attribute = InlayAttr, soul_suit_attribute = SoulAttr},
    put(?PROC_STATUS_GOODS, NewGoodsStatus),
    NewPlayer.

%%装备战力
equip_combat_power(GoodsType, Goods) ->
    case GoodsType#goods_type.type =:= ?GOODS_TYPE_EQUIP orelse equip_random:is_gen_attr(GoodsType#goods_type.type, GoodsType#goods_type.subtype) of
        true ->
            Combat_power = attribute_util:calc_combat_power(calc_singleton_equip_attribute(Goods)),
            Goods#goods{combat_power = Combat_power};
        _ ->
            Goods
    end.
%%装备战力
equip_combat_power(Goods) ->
    Combat_power = attribute_util:calc_combat_power(calc_singleton_equip_attribute(Goods)),
    Goods#goods{combat_power = Combat_power}.

