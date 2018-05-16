%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. 五月 2017 18:17
%%%-------------------------------------------------------------------
-module(fuwen_attr).
-author("li").

-include("server.hrl").
-include("common.hrl").
-include("fuwen.hrl").
-include("goods.hrl").

%% API
-export([
    calc_singleton_fuwen_attribute/1, %% 计算单件符文属性
    get_fuwen_all_attribute/0, %% 获取玩家身上符文属性
    fuwen_change_recalc_attribute/2, %%穿在身上单件符文，发生变化属性需要重新计算
    get_add_exp/0
]).

%% 计算单件符文属性
calc_singleton_fuwen_attribute(#goods{goods_lv = GoodsLv, color = Color, goods_id = GoodsId}) when GoodsLv > 0 ->
    #goods_type{subtype = SubType} = data_goods:get(GoodsId),
    if
        SubType == ?GOODS_SUBTYPE_FUWEN_WHITE ->
            #attribute{};
        true ->
            case data_fuwen:get(SubType, GoodsLv, Color) of
                [] ->
                    #attribute{};
                #base_fuwen{attribute_list = AttList} ->
                    attribute_util:make_attribute_by_key_val_list(AttList)
            end
    end;

calc_singleton_fuwen_attribute(_) ->
    #attribute{}.

%% 获取玩家身上符文属性
get_fuwen_all_attribute() ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsStatus#st_goods.fuwen_attribute.

get_add_exp() ->
    #attribute{exp_add = ExpAdd} = get_fuwen_all_attribute(),
    ExpAdd.

%%穿在身上单件符文，发生变化属性需要重新计算
fuwen_change_recalc_attribute(GoodsSt, Goods) ->
    WearedFuwenList = GoodsSt#st_goods.weared_fuwen,
    Attribute = calc_singleton_fuwen_attribute(Goods),
    F = fun(#weared_fuwen{pos = Pos}) ->
        Pos /= Goods#goods.cell
    end,
    case lists:filter(F, WearedFuwenList) of
        NWearedFuwenList -> %%穿符文
            WearedFuwen = #weared_fuwen{
                pos = Goods#goods.cell,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                fuwen_attribute = Attribute
            },
            NewWearedFuwenList = [WearedFuwen | NWearedFuwenList]
    end,
    SumEquipAttribute = attribute_util:sum_attribute([WearedFuwen0#weared_fuwen.fuwen_attribute || WearedFuwen0 <- NewWearedFuwenList]),
    GoodsSt#st_goods{fuwen_attribute = SumEquipAttribute, weared_fuwen = NewWearedFuwenList}.