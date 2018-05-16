%%%-------------------------------------------------------------------
%%% @author luobaqun
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 二月 2017 11:18
%%%-------------------------------------------------------------------
-module(equip_refine).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
-include("error_code.hrl").
-include("money.hrl").
-include("new_shop.hrl").
-include("tips.hrl").

%% API
-export([
    equip_refine/2
    , gm/0
    , format_equip_refine/1
    , pack_equip_refine/1
    , total_attribute/1
    , add_goods_refine/1
    , check_equip_refine_state/1
    , get_count/2
    , refine_default/0
]).

%%装备默认精炼
refine_default() ->
    [{hp_lim,0},{def,0},{att,0}].

%%检查装备是否可升级
check_equip_refine_state(_Player) ->
    F = fun(Goods) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        Lim = data_equip_refine_limit:equip_refine_lim(GoodsType#goods_type.star), %% 星级精炼限制
        StEquipRefine = lib_dict:get(?PROC_STATUS_EQUIP_REFINE),
        EquipRefine =
            case lists:keyfind(GoodsType#goods_type.subtype, #st_refine_info.subtype, StEquipRefine#st_refine.refin_list) of
                false ->
                    #st_refine_info{subtype = GoodsType#goods_type.subtype};
                Value ->
                    Value
            end,
        if
            EquipRefine#st_refine_info.hp_lim_num >= Lim andalso EquipRefine#st_refine_info.att_num >= Lim andalso EquipRefine#st_refine_info.def_num >= Lim ->
                []; %% 已达精炼上限
            true ->
                StoneNumList = data_equip_refine:get_all(),
                case check_stone_num(StoneNumList, EquipRefine, Lim) of
                    false -> [];%% 物品不足
                    true -> [1]
                end
        end
    end,
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    case lists:flatmap(F, GoodsList) of
        [] -> 0;
        _ -> 1
    end.

equip_refine(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    Lim = data_equip_refine_limit:equip_refine_lim(GoodsType#goods_type.star), %% 星级精炼限制
    StEquipRefine = lib_dict:get(?PROC_STATUS_EQUIP_REFINE),
    EquipRefine =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_refine_info.subtype, StEquipRefine#st_refine.refin_list) of
            false ->
                #st_refine_info{subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    if
        EquipRefine#st_refine_info.hp_lim_num >= Lim andalso EquipRefine#st_refine_info.att_num >= Lim andalso EquipRefine#st_refine_info.def_num >= Lim ->
            {false, 40}; %% 已达精炼上限
        true ->
            StoneNumList = data_equip_refine:get_all(),
            case check_stone_num(StoneNumList, EquipRefine, Lim) of
                false -> {false, 41};%% 物品不足
                true ->
                    StoneNumList = data_equip_refine:get_all(),
                    equip_refining(Player, Goods, GoodsType, StEquipRefine, EquipRefine, Lim, StoneNumList),
                    computation_attribute(Player, Goods, GoodsType)
            end
    end.

equip_refining(_Player, _Goods, _GoodsType, _StEquipRefine, _EquipRefine, _Lim, []) -> ok;
equip_refining(Player, Goods, GoodsType, StEquipRefine, EquipRefine, Lim, [Id | T]) ->
    Base = data_equip_refine:get(Id),
    StoneNum = goods_util:get_goods_count(Base#base_equip_refine.goods_id),
    if
        StoneNum == 0 ->
            NewEquipRefine = EquipRefine,
            NewRefineList = StEquipRefine#st_refine.refin_list;
        true ->
            RefineNum = element(Id + 1, EquipRefine),
            if
                RefineNum >= Lim ->
                    NewEquipRefine = EquipRefine,
                    NewRefineList = StEquipRefine#st_refine.refin_list;
                true ->
                    goods:subtract_good(Player, [{Base#base_equip_refine.goods_id, 1}], 0),
                    NewEquipRefine = erlang:setelement(Id + 1, EquipRefine, RefineNum + 1),
                    NewRefineList = [NewEquipRefine | lists:keydelete(GoodsType#goods_type.subtype, #st_refine_info.subtype, StEquipRefine#st_refine.refin_list)],
                    db_log_equip_refine(Player, GoodsType#goods_type.subtype, RefineNum, Base#base_equip_refine.goods_id)
            end
    end,
    lib_dict:put(?PROC_STATUS_EQUIP_REFINE, StEquipRefine#st_refine{is_change = 1, refin_list = NewRefineList}),
    NewStEquipRefine = lib_dict:get(?PROC_STATUS_EQUIP_REFINE),
    equip_refining(Player, Goods, GoodsType, NewStEquipRefine, NewEquipRefine, Lim, T).


computation_attribute(Player, Goods, GoodsType) ->
    StEquipRefine = lib_dict:get(?PROC_STATUS_EQUIP_REFINE),
    EquipRefine =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_refine_info.subtype, StEquipRefine#st_refine.refin_list) of
            false ->
                #st_refine_info{subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    AttributeAll = total_attribute(StEquipRefine#st_refine.refin_list),
    ?DEBUG("EquipRefine ~p~n", [EquipRefine]),
    Attribute = total_attribute([EquipRefine]),
    lib_dict:put(?PROC_STATUS_EQUIP_REFINE, StEquipRefine#st_refine{is_change = 1, attribute = AttributeAll}),
    ?DEBUG("Attribute ~p~n", [Attribute]),
    Goods1 = Goods#goods{refine_attr = Attribute},
    NewGoods = equip_attr:equip_combat_power(Goods1),
    GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
    server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
    %%goods_load:dbup_goods_refine(NewGoods),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
    Player1 = equip_attr:equip_suit_calc(Player),
    NewPlayer1 = player_util:count_player_attribute(Player1, true),
    {ok, NewPlayer1}.

%% 根据装备精炼信息计算总属性加成
total_attribute(EquipRefineList) ->
    StoneNumList = data_equip_refine:get_all(),
    total_attribute(EquipRefineList, StoneNumList, []).
total_attribute([], _StoneNumList, AttrList) -> AttrList;
total_attribute([EquipRefine | T], StoneNumList, AttrList) ->
    F = fun(Id, AttributeList) ->
        Base = data_equip_refine:get(Id),
        RefineAttribute = [{Attr0, Price * element(Id + 1, EquipRefine)} || {Attr0, Price} <- Base#base_equip_refine.attrs],
        lists:append([RefineAttribute, AttributeList])
    end,
    AttributeList = lists:foldl(F, [], StoneNumList),
    total_attribute(T, StoneNumList, lists:append([AttributeList, AttrList])).

gm() ->
    lib_dict:put(?PROC_STATUS_EQUIP_REFINE, #st_refine{}).

pack_equip_refine(ExpList) ->
    F = fun({AttNum, DefNum, HpLimNum, SubType}) ->
        #st_refine_info{subtype = SubType, att_num = AttNum, def_num = DefNum, hp_lim_num = HpLimNum}
    end,
    lists:map(F, ExpList).

format_equip_refine(RefineList) ->
    F = fun(EquipRefine) ->
        {
            EquipRefine#st_refine_info.att_num,
            EquipRefine#st_refine_info.def_num,
            EquipRefine#st_refine_info.hp_lim_num,
            EquipRefine#st_refine_info.subtype}
    end,
    lists:map(F, RefineList).

check_stone_num(StoneNumList, EquipRefine, Lim) ->
    check_stone_num_help(StoneNumList, EquipRefine, Lim, 0).

check_stone_num_help([], _EquipRefine, _Lim, Num) ->
    case Num of
        0 -> false;
        _ -> true
    end;
check_stone_num_help([Id | T], EquipRefine, Lim, Num) ->
    Base = data_equip_refine:get(Id),
    StoneNum = goods_util:get_goods_count(Base#base_equip_refine.goods_id),
    RefineNum = element(Id + 1, EquipRefine),
    if
        RefineNum < Lim andalso StoneNum > 0 ->
            check_stone_num_help(T, EquipRefine, Lim, Num + StoneNum);
        true ->
            check_stone_num_help(T, EquipRefine, Lim, Num)
    end.


add_goods_refine(GoodsList) ->
    add_goods_refine(GoodsList, []).

add_goods_refine([], List) -> List;
add_goods_refine([Goods | T], List) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    if
        GoodsType#goods_type.type == 1 ->
            NewGoods = add_goods_refine_help(Goods),
            add_goods_refine(T, [NewGoods | List]);
        true ->
            add_goods_refine(T, [Goods | List])
    end.

add_goods_refine_help(Goods) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    GoodsType#goods_type.type,
    St_refien = get(?PROC_STATUS_EQUIP_REFINE),
    EquipRefine =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_refine_info.subtype, St_refien#st_refine.refin_list) of
            false ->
                #st_refine_info{att_num = 0, def_num = 0, hp_lim_num = 0, subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    Attribute = total_attribute([EquipRefine]),
    NewGoods = Goods#goods{refine_attr = Attribute},
    %%goods_load:dbup_goods_refine(NewGoods),
    NewGoods.


get_count(Type, Value) ->
    BaseList = data_equip_refine:get_all(),
    get_count_help(Type, Value, BaseList).

get_count_help(_Type, _Value, []) -> 0;
get_count_help(Type, Value, [Id | List]) ->
    Base = data_equip_refine:get(Id),
    [{Type0, Value0}] = Base#base_equip_refine.attrs,
    if
        Type0 == Type -> Value div Value0;
        true ->
            get_count_help(Type, Value, List)
    end.


db_log_equip_refine(Player, Subtype, RefineNum, CostGoodsId) ->
    Now = util:unixtime(),
    Sql = io_lib:format("insert into log_equip_refine(pkey,nickname,subtype,refine_before,refine_after,cost_goods_id,time) value(~p,'~s',~p,~p,~p,~p,~p) ",
        [Player#player.key, Player#player.nickname, Subtype, RefineNum, RefineNum + 1, CostGoodsId, Now]),
    log_proc:log(Sql),
    ok.
