%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. 八月 2017 10:44
%%%-------------------------------------------------------------------
-module(fairy_soul_attr).
-author("Administrator").
-include("server.hrl").
-include("common.hrl").
-include("fairy_soul.hrl").
-include("goods.hrl").

%% API
-export([
    fairy_soul_change_recalc_attribute/1
    , fairy_soul_change_recalc_attribute/2
    , fairy_soul_recalc_attribute/0
    , get_fairy_soul_all_attribute/0
    , get_add_exp/0
]).

%% 计算单件仙魂属性
fairy_soul_change_recalc_attribute(#goods{goods_lv = GoodsLv, color = Color, goods_id = GoodsId}) when GoodsLv > 0 ->
    #goods_type{subtype = SubType} = data_goods:get(GoodsId),
    case data_fairy_soul:get(SubType, GoodsLv, Color) of
        [] ->
            #attribute{};
        #base_fairy_soul{attribute_list = AttList} ->
            attribute_util:make_attribute_by_key_val_list(AttList)
    end;
fairy_soul_change_recalc_attribute(_) ->
    #attribute{}.

%%穿在身上单件仙魂，发生变化属性需要重新计算
fairy_soul_change_recalc_attribute(GoodsSt, Goods) ->
    WearedFairySoulList = GoodsSt#st_goods.weared_fairy_soul,
    Attribute = fairy_soul_change_recalc_attribute(Goods),
    F = fun(#weared_fairy_soul{pos = Pos}) ->
        Pos /= Goods#goods.cell
    end,
    case lists:filter(F, WearedFairySoulList) of
        NWearedFairySoulList -> %%穿仙魂
            WearedFairySoul = #weared_fairy_soul{
                pos = Goods#goods.cell,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                fairy_soul_attribute = Attribute
            },
            NewWearedFairySoulList = [WearedFairySoul | NWearedFairySoulList]
    end,
    SumEquipAttribute = attribute_util:sum_attribute([WearedFairySoul0#weared_fairy_soul.fairy_soul_attribute || WearedFairySoul0 <- NewWearedFairySoulList]),
    GoodsSt#st_goods{fairy_soul_attribute = SumEquipAttribute, weared_fairy_soul = NewWearedFairySoulList}.

fairy_soul_recalc_attribute() ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    WearedFairySoulList = GoodsSt#st_goods.weared_fairy_soul,
    SumEquipAttribute = attribute_util:sum_attribute([WearedFairySoul0#weared_fairy_soul.fairy_soul_attribute || WearedFairySoul0 <- WearedFairySoulList]),
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt#st_goods{fairy_soul_attribute = SumEquipAttribute}),
    ok.

%% 获取玩家身上仙魂属性
get_fairy_soul_all_attribute() ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsStatus#st_goods.fairy_soul_attribute.

get_add_exp() ->
    #attribute{exp_add = ExpAdd} = get_fairy_soul_all_attribute(),
    ExpAdd.


