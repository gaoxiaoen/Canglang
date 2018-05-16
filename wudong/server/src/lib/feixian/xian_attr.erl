%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 十月 2017 11:50
%%%-------------------------------------------------------------------
-module(xian_attr).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("goods.hrl").

%% API
-export([
    calc_singleton_xian_attribute/1,
    get_xian_all_attribute/0,
    xian_change_recalc_attribute/2,
    off_xian_change_recalc_attribute/2
]).

%% 计算单件仙装属性
calc_singleton_xian_attribute(#goods{goods_lv = GoodsLv, goods_id = GoodsId, xian_wash_attr = XianWashAttr}) ->
    case data_feixian:get(GoodsId, GoodsLv) of
        [] ->
            #attribute{};
        #base_xian{attribute_list = AttList} ->
            F = fun({Key, Value, _AttrColor}) ->
                {Key, Value}
            end,
            NewXianWashAttr = lists:map(F, XianWashAttr),
            WashAttr = attribute_util:make_attribute_by_key_val_list(NewXianWashAttr),
            BaseAttr = attribute_util:make_attribute_by_key_val_list(AttList),
            attribute_util:sum_attribute([WashAttr, BaseAttr])
    end;

calc_singleton_xian_attribute(_) ->
    #attribute{}.

%% 获取玩家身上仙装属性
get_xian_all_attribute() ->
    GoodsStatus = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsStatus#st_goods.xian_attribute.

%%穿在身上单件仙装，发生变化属性需要重新计算
xian_change_recalc_attribute(GoodsSt, Goods) when Goods#goods.cell < 1 ->
    GoodsSt;
xian_change_recalc_attribute(GoodsSt, Goods) ->
    WearedXianList = GoodsSt#st_goods.weared_xian,
    Attribute = calc_singleton_xian_attribute(Goods),
    F = fun(#weared_xian{pos = Pos}) ->
        Pos /= Goods#goods.cell
    end,
    case lists:filter(F, WearedXianList) of
        NWearedXianList -> %%穿符文
            WearedXian = #weared_xian{
                pos = Goods#goods.cell,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                xian_attribute = Attribute
            },
            NewWearedXianList = [WearedXian | NWearedXianList]
    end,
    SumEquipAttribute = attribute_util:sum_attribute([WearedXian0#weared_xian.xian_attribute || WearedXian0 <- NewWearedXianList]),
    GoodsSt#st_goods{xian_attribute = SumEquipAttribute, weared_xian = NewWearedXianList}.

%% 发生变化属性需要重新计算
off_xian_change_recalc_attribute(GoodsSt, Cell) ->
    WearedXianList = GoodsSt#st_goods.weared_xian,
    F = fun(#weared_xian{pos = Pos}) ->
        Pos /= Cell
    end,
    case lists:filter(F, WearedXianList) of
        NWearedXianList -> %%穿符文
            NewWearedXianList = NWearedXianList
    end,
    SumEquipAttribute = attribute_util:sum_attribute([WearedXian0#weared_xian.xian_attribute || WearedXian0 <- NewWearedXianList]),
    GoodsSt#st_goods{xian_attribute = SumEquipAttribute, weared_xian = NewWearedXianList}.

