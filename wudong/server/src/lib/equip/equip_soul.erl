%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 武魂
%%% @end
%%% Created : 25. 七月 2017 10:57
%%%-------------------------------------------------------------------
-module(equip_soul).
-author("Administrator").
-include("equip.hrl").
-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").
%% API
-export([
    soul_com/3
    , put_on_soul/4
    , take_down_soul/3
    , update_soul_all/1
    , pack_equip_soul/1
    , add_goods_soul/2
    , format_equip_soul/1
    , total_attribute/1
    , open_soul/2
    , get_soul_info/1
    , gm_get/0
    , get_soul_suit/1
    , init_soul_list/0
    , update_soul_goods/2
    , take_upgrade_soul/4
]).

-define(OPEN_SOUL_COST, 200). %% 开启武魂消耗元宝

get_soul_info(SubType) ->
    case lists:member(SubType, ids()) of
        false -> [];
        _ ->
            St = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
            case lists:keyfind(SubType, #st_soul_info.subtype, St#st_soul.soul_list) of
                false -> [];
                Base ->
                    [tuple_to_list(X) || X <- Base#st_soul_info.info_list]
            end
    end.

%% 武魂镶嵌
put_on_soul(Player, GoodsKey, Location, GoodsId) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    case check_put_on_soul(GoodsKey, Location, GoodsId) of
        {false, Res} ->
            {false, Res};
        {ok, SoulList, SoulId0} ->
            goods:subtract_good(Player, [{GoodsId, 1}], 298),
            {ok, NewPlayer1} =
                if SoulId0 =/= 0 -> goods:give_goods(Player, goods:make_give_goods_list(298, [{SoulId0, 1}]));
                    true -> {ok, Player}
                end,
            StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
            InfoList = SoulList#st_soul_info.info_list,
            case lists:keytake(Location, 1, InfoList) of
                {value, {Location, State, _SoulId}, _List} ->
                    NewSoul = lists:keyreplace(Location, 1, SoulList#st_soul_info.info_list, {Location, State, GoodsId}),
                    case lists:keytake(SoulList#st_soul_info.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
                        false ->
                            NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | StSoul#st_soul.soul_list];
                        {value, _, List1} ->
                            NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | List1]
                    end,
                    lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StSoul#st_soul{soul_list = NewSoulList, is_change = 1}),
                    {ok, NewPlayer2} = computation_attribute(NewPlayer1, Goods, GoodsType),
                    log_equip_soul_op(Player#player.key, Player#player.nickname, Player#player.lv, SoulId0, GoodsId),
                    soul_gem_achieve(Player, NewSoulList),
                    goods_load:db_save_soul_info(Player),
                    {ok, NewPlayer2};
                _ ->
                    {false, 0}
            end;
        Other ->
            ?DEBUG("Other ~p~n", [Other]),
            ok
    end.

soul_gem_achieve(Player, SoulList) ->
    %%成就
    F1 = fun({_, _, SoulId}) ->
        case data_equip_soul:get_gid(SoulId) of
            [] -> 0;
            Base -> Base#base_equip_soul.lv
        end
    end,
    F = fun(SoulInfo) ->
        lists:map(F1, SoulInfo#st_soul_info.info_list)
    end,
    case lists:flatmap(F, SoulList) of
        [] -> ok;
        LvList ->
            case lists:max(LvList) of
                0 -> ok;
                MaxLv ->
                    F2 = fun(GemLv) ->
                        GemCount = length([Lv || Lv <- LvList, Lv >= GemLv]),
                        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1051, GemLv, GemCount)
                    end,
                    lists:foreach(F2, lists:seq(1, MaxLv))
            end
    end.

check_put_on_soul(GoodsKey, Location, GoodsId) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    Count = goods_util:get_goods_count(GoodsId),
    if
        Count =< 0 -> {false, 47}; %% 物品不存在
        true ->
            case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
                false ->
                    {false, 0};
                SoulList ->
                    case lists:keyfind(Location, 1, SoulList#st_soul_info.info_list) of
                        false ->
                            {false, 0};
                        {_Location, State, SoulId} ->
                            if
                                State == 0 -> {false, 48};
                                true ->
                                    case data_equip_soul:get_gid(GoodsId) of
                                        [] -> {false, 0};
                                        Base0 ->
                                            Type = Base0#base_equip_soul.type,
                                            F = fun({Location0, _, SoulId0}) ->
                                                if
                                                    Location0 == Location -> false;
                                                    true ->
                                                        case data_equip_soul:get_gid(SoulId0) of
                                                            [] -> false;
                                                            Base -> Type == Base#base_equip_soul.type
                                                        end
                                                end
                                            end,
                                            case lists:any(F, SoulList#st_soul_info.info_list) of
                                                true ->
                                                    {false, 52};
                                                _ ->
                                                    %% 判断背包是否满
                                                    {ok, SoulList, SoulId}
                                            end
                                    end
                            end
                    end
            end
    end.

%% 取下武魂
take_down_soul(Player, GoodsKey, Location) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    case check_take_down_soul(GoodsKey, Location) of
        {false, Res} -> {false, Res};
        {ok, SoulList} ->
            StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
            InfoList = SoulList#st_soul_info.info_list,
            case lists:keytake(Location, 1, InfoList) of
                {value, {Location, State, SoulId}, _List} ->
                    NewGoodsType = data_goods:get(SoulId),
                    if
                        NewGoodsType == [] -> {false, 0};
                        true ->
                            NewSoul = lists:keyreplace(Location, 1, SoulList#st_soul_info.info_list, {Location, State, 0}),
                            case lists:keytake(SoulList#st_soul_info.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
                                false ->
                                    NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | StSoul#st_soul.soul_list];
                                {value, _, List0} ->
                                    NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | List0]
                            end,
                            lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StSoul#st_soul{soul_list = NewSoulList}),
                            log_equip_soul_op(Player#player.key, Player#player.nickname, Player#player.lv, SoulId, 0),
                            {ok, NewPlayer} = goods:give_goods(Player, goods:make_give_goods_list(296, [{SoulId, 1}])),
                            {ok, NewPlayer1} = computation_attribute(NewPlayer, Goods, GoodsType),
                            goods_load:db_save_soul_info(Player),
                            {ok, NewPlayer1}
                    end;
                _ ->
                    {false, 0}
            end
    end.

check_take_down_soul(GoodsKey, Location) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
        false ->
            {false, 0};
        SoulList ->
            case lists:keyfind(Location, 1, SoulList#st_soul_info.info_list) of
                false -> {false, 0};
                {_Location, State, _SoulId} ->
                    if
                        State == 0 -> {false, 48};
                        true ->
                            %%  判断背包是否满
                            {ok, SoulList}
                    end
            end
    end.

%% 升级武魂
take_upgrade_soul(Player, GoodsKey, Location, GoodsId) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    case check_take_upgrade_soul(GoodsKey, Location, GoodsId) of
        {false, Res} ->
            ?DEBUG("false ~p~n", [Res]),
            {false, Res};
        {ok, SoulList, CostList1} ->
            CostList = [{Id, Num} || {Id, Num} <- CostList1, Num > 0],
            StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
            InfoList = SoulList#st_soul_info.info_list,
            case lists:keytake(Location, 1, InfoList) of
                {value, {Location, State, SoulId}, _List} ->
                    NewSoul = lists:keyreplace(Location, 1, SoulList#st_soul_info.info_list, {Location, State, GoodsId}),
                    case lists:keytake(SoulList#st_soul_info.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
                        false ->
                            NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | StSoul#st_soul.soul_list];
                        {value, _, List0} ->
                            NewSoulList = [SoulList#st_soul_info{info_list = NewSoul} | List0]
                    end,
                    lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StSoul#st_soul{soul_list = NewSoulList}),
                    ?DEBUG("CostList ~p~n", [CostList]),
                    goods:subtract_good(Player, CostList, 296),
                    goods_load:db_save_soul_info(Player),
                    case data_equip_soul:get_gid(GoodsId) of
                        [] -> skip;
                        BaseSoul ->
                            if BaseSoul#base_equip_soul.lv >= 7 ->
                                Content = io_lib:format(t_tv:get(269), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                                notice:add_sys_notice(Content, 269);
                                true -> skip
                            end
                    end,
                    log_equip_soul_up(Player#player.key, Player#player.nickname, Player#player.lv, SoulId, 1, GoodsId, 1),
                    {ok, NewPlayer1} = computation_attribute(Player, Goods, GoodsType),
                    {ok, NewPlayer1};
                _ ->
                    {false, 0}
            end
    end.

check_take_upgrade_soul(GoodsKey, Location, GoodsId) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
        false ->
            {false, 0};
        SoulList ->
            case lists:keyfind(Location, 1, SoulList#st_soul_info.info_list) of
                false -> {false, 0};
                {_Location, State, _SoulId} ->
                    if
                        State == 0 -> {false, 48};
                        GoodsId == 0 -> {false, 0};
                        true ->
                            case data_equip_soul:get_gid(GoodsId) of
                                [] -> {false, 0};
                                Base ->
%%                                     check_soul_com(),
                                    NeedGoodsId = Base#base_equip_soul.need_goods_id,
                                    NeedGoodsNum = Base#base_equip_soul.need_goods_num,
%%                                    Count = goods_util:get_goods_count(NeedGoodsId),
                                    case get_cost_list(NeedGoodsId, NeedGoodsNum - 1, []) of
                                        {false, Res} -> {false, Res};
                                        CostList -> {ok, SoulList, CostList}
                                    end
                            end
                    end
            end
    end.

get_cost_list(NeedGoodsId, NeedGoodsNum, List) ->
    ?DEBUG("~p / ~p~n", [NeedGoodsId, NeedGoodsNum]),
    ?DEBUG("list  ~p ~n", [List]),
    Count = goods_util:get_goods_count(NeedGoodsId),
    if
        Count >= NeedGoodsNum -> [{NeedGoodsId, NeedGoodsNum} | List];
%%         Count == 0 -> {false, 45};
        true ->
            Base = data_equip_soul:get_gid(NeedGoodsId),
            if
                Base == [] -> {false,0};
                Base#base_equip_soul.lv == 1 -> {false, 45};
                true ->
                    NeedGoodsId1 = Base#base_equip_soul.need_goods_id,
                    NewCount = Base#base_equip_soul.need_goods_num * (NeedGoodsNum - Count),
                    get_cost_list(NeedGoodsId1, NewCount, [{NeedGoodsId, Count} | List])
            end
    end.

%% 武魂合成
soul_com(Player, GoodsId, Num) ->
    case check_soul_com(GoodsId, Num) of
        {false, Res} -> {false, Res};
        {ok, Base} ->
            goods:subtract_good(Player, [{Base#base_equip_soul.need_goods_id, Base#base_equip_soul.need_goods_num * Num}], 296),
            GiveGoodsList = goods:make_give_goods_list(296, [{GoodsId, Num}]),
            BaseSoul = data_equip_soul:get_gid(GoodsId),
            if
                BaseSoul ==[] -> skip;
                BaseSoul#base_equip_soul.lv >= 7 ->
                Content = io_lib:format(t_tv:get(269), [t_tv:pn(Player), t_tv:gn(GoodsId)]),
                notice:add_sys_notice(Content, 269);
                true -> skip
            end,
            log_equip_soul_up(Player#player.key, Player#player.nickname, Player#player.lv, Base#base_equip_soul.need_goods_id, Base#base_equip_soul.need_goods_num * Num, GoodsId, Num),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {ok, NewPlayer}
    end.

check_soul_com(GoodsId, Num) ->
    case data_equip_soul:get_gid(GoodsId) of
        [] -> {false, 0};
        Base ->
            NeedGoodsId = Base#base_equip_soul.need_goods_id,
            NeedGoodsNum = Base#base_equip_soul.need_goods_num,
            Count = goods_util:get_goods_count(NeedGoodsId),
            if
                Count < NeedGoodsNum * Num -> {false, 45};
                true -> {ok, Base}
            end
    end.

open_soul(Player, GoodsKey) ->
    case check_open_soul(Player, GoodsKey) of
        {false, Res} ->
            {false, Res};
        {ok, SoulList} ->
            NewPlayer = money:add_no_bind_gold(Player, -?OPEN_SOUL_COST, 297, 0, 0),
            StEquipSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL), %% 附魔字典
            NewEquipSoul = lists:keyreplace(4, 1, SoulList#st_soul_info.info_list, {4, 1, 0}),
            case lists:keytake(SoulList#st_soul_info.subtype, #st_soul_info.subtype, StEquipSoul#st_soul.soul_list) of
                false ->
                    NewSoulList = [SoulList#st_soul_info{info_list = NewEquipSoul} | StEquipSoul#st_soul.soul_list];
                {value, _, List} ->
                    NewSoulList = [SoulList#st_soul_info{info_list = NewEquipSoul} | List]
            end,
            lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StEquipSoul#st_soul{soul_list = NewSoulList, is_change = 1}),
            Goods = goods_util:get_goods(GoodsKey),
            GoodsType = data_goods:get(Goods#goods.goods_id),
            {ok, NewPlayer1} = computation_attribute(NewPlayer, Goods, GoodsType),
            {ok, NewPlayer1}
    end.

check_open_soul(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
        false ->
            {false, 0};
        SoulList ->
            case lists:keyfind(4, 1, SoulList#st_soul_info.info_list) of
                false -> {false, 0};
                {_Location, State, _SoulId} ->
                    if
                        State == 1 -> {false, 50};
                        true ->
                            case money:is_enough(Player, ?OPEN_SOUL_COST, gold) of
                                false ->
                                    {false, 15}; %% 元宝不足
                                true ->
                                    {ok, SoulList}
                            end
                    end
            end
    end.

computation_attribute(Player, Goods, GoodsType) ->
    StEquipSoul = lib_dict:get(?PROC_STATUS_EQUIP_SOUL),
    EquipSoul =
        case lists:keyfind(GoodsType#goods_type.subtype, #st_soul_info.subtype, StEquipSoul#st_soul.soul_list) of
            false ->
                #st_soul_info{subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    AttributeAll = total_attribute(StEquipSoul#st_soul.soul_list),
    Attribute = total_attribute([EquipSoul]),
    lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StEquipSoul#st_soul{is_change = 1, attribute = AttributeAll}),
    Goods1 = Goods#goods{soul_attrs = Attribute},
    NewGoods = equip_attr:equip_combat_power(Goods1),
    GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
    server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
    Player1 = equip_attr:equip_suit_calc(Player),
    NewPlayer1 = player_util:count_player_attribute(Player1, true),
    {ok, NewPlayer1}.

%% 根据装备武魂信息计算总属性加成
total_attribute(EquipSoulList) ->
    total_attribute(EquipSoulList, []).
total_attribute([], AttrList) -> AttrList;
total_attribute([EquipSoul | T], AttrList) ->
    AttList = EquipSoul#st_soul_info.info_list,
    F = fun({_Index, _State, SoulId}, AttributeList0) ->
        case data_equip_soul:get_gid(SoulId) of
            [] -> AttributeList0;
            Base -> Base#base_equip_soul.attrs ++ AttributeList0
        end
    end,
    AttributeList = lists:foldl(F, [], AttList),
    total_attribute(T, lists:append([AttributeList, AttrList])).

pack_equip_soul(ExpList) ->
    F = fun({AttList, SubType}) ->
        #st_soul_info{subtype = SubType, info_list = AttList}
    end,
    lists:map(F, ExpList).

format_equip_soul(SoulList) ->
    F = fun(EquipSoul) ->
        {
            EquipSoul#st_soul_info.info_list,
            EquipSoul#st_soul_info.subtype}
    end,
    lists:map(F, SoulList).

add_goods_soul(VipLv, GoodsList) ->
    add_goods_soul0(VipLv, GoodsList, []).

add_goods_soul0(_VipLv, [], List) -> List;
add_goods_soul0(VipLv, [Goods | T], List) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    if
        GoodsType#goods_type.type == 1 andalso Goods#goods.location == ?GOODS_LOCATION_BODY ->
            NewGoods = add_goods_soul_help(VipLv, Goods),
            add_goods_soul0(VipLv, T, [NewGoods | List]);
        true ->
            add_goods_soul0(VipLv, T, [Goods | List])
    end.

add_goods_soul_help(VipLv, Goods) ->
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StSoul = get(?PROC_STATUS_EQUIP_SOUL),
    EquipSoul =
        case lists:keytake(GoodsType#goods_type.subtype, #st_soul_info.subtype, StSoul#st_soul.soul_list) of
            false ->
                ?ERR("StSoul#st_soul.soul_list ~p~n", [StSoul#st_soul.soul_list]),
                StSoulInfo = #st_soul_info{subtype = GoodsType#goods_type.subtype},
                InfoList0 = StSoulInfo#st_soul_info.info_list,
                InfoList1 = ?IF_ELSE(Goods#goods.star >= 3, lists:keyreplace(2, 1, InfoList0, {2, 1, 0}), InfoList0), %% 装备为橙色开启第二个格子
                InfoList2 = ?IF_ELSE(Goods#goods.star >= 4, lists:keyreplace(3, 1, InfoList1, {3, 1, 0}), InfoList1), %% 装备为红色开启第三个格子
                InfoList3 = ?IF_ELSE(VipLv >= 5, lists:keyreplace(5, 1, InfoList2, {5, 1, 0}), InfoList2), %% Vip5 开启第五个格子
                NewSoulList = StSoulInfo#st_soul_info{info_list = InfoList3},
                AttributeAll = total_attribute([NewSoulList]),
                lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StSoul#st_soul{is_change = 1, attribute = AttributeAll, soul_list = [NewSoulList | StSoul#st_soul.soul_list]}),
                NewSoulList;
            {value, Value, List} ->
                InfoList0 = Value#st_soul_info.info_list,
                {2, _State0, GoodsId0} = lists:keyfind(2, 1, InfoList0),
                InfoList1 = ?IF_ELSE(Goods#goods.star >= 3, lists:keyreplace(2, 1, InfoList0, {2, 1, GoodsId0}), InfoList0),
                {3, _State1, GoodsId1} = lists:keyfind(3, 1, InfoList1),
                InfoList2 = ?IF_ELSE(Goods#goods.star >= 4, lists:keyreplace(3, 1, InfoList1, {3, 1, GoodsId1}), InfoList1),
                {5, _State2, GoodsId2} = lists:keyfind(5, 1, InfoList2),
                InfoList3 = ?IF_ELSE(VipLv >= 5, lists:keyreplace(5, 1, InfoList2, {5, 1, GoodsId2}), InfoList2),
                NewSoulList = Value#st_soul_info{info_list = InfoList3},
                AttributeAll = total_attribute([NewSoulList]),
                lib_dict:put(?PROC_STATUS_EQUIP_SOUL, StSoul#st_soul{is_change = 1, attribute = AttributeAll, soul_list = [NewSoulList | List]}),
                NewSoulList
        end,
    Attribute = total_attribute([EquipSoul]),
    NewGoods = Goods#goods{soul_attrs = Attribute},
    NewGoods.

update_soul_all(VipLv) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    EquipList = goods_util:get_goods_list_by_location(GoodsSt, ?GOODS_LOCATION_BODY),
    NewGoodsList = add_goods_soul(VipLv, EquipList),
    goods_pack:pack_send_goods_info(NewGoodsList, GoodsSt#st_goods.sid),
    ok.

update_soul_goods(VipLv, Goods) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    NewGoodsList = add_goods_soul(VipLv, [Goods]),
    goods_pack:pack_send_goods_info(NewGoodsList, GoodsSt#st_goods.sid),
    ok.

%%获取装备镶嵌套装属性
get_soul_suit(_Player) ->
    SoulLv = equip_attr:soul_lv(),
    CurStoneLv =
        case [Lv || Lv <- data_equip_soul_suit:ids(), Lv =< SoulLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_soul_suit:get(CurStoneLv)),
    Cbp = attribute_util:calc_combat_power(Attribute),
    AttrList = attribute_util:pack_attr(Attribute),
    MaxLv = data_equip_soul_suit:max_lv(),
    if SoulLv >= MaxLv ->
        {?OPEN_SOUL_COST, SoulLv, Cbp, AttrList, 1, 0, 0, 0, 0, []};
        true ->
            NextSoulLv =
                case [Lv || Lv <- data_equip_soul_suit:ids(), Lv > SoulLv] of
                    [] -> 0;
                    L2 -> lists:min(L2)
                end,
            {Active, ActiveLim} = equip_attr:soul_active(NextSoulLv),
            NextAttribute = attribute_util:make_attribute_by_key_val_list(data_equip_soul_suit:get(NextSoulLv)),
            NextCbp = attribute_util:calc_combat_power(NextAttribute),
            NextAttrList = attribute_util:pack_attr(NextAttribute),
            {?OPEN_SOUL_COST, SoulLv, Cbp, AttrList, 0, NextSoulLv, Active, ActiveLim, NextCbp, NextAttrList}
    end.

init_soul_list() ->
    SubTypeList = ids(),
    F = fun(SubType) ->
        #st_soul_info{subtype = SubType}
    end,
    SoulList = lists:map(F, SubTypeList),
    #st_soul{soul_list = SoulList, is_change = 1}.

ids() ->
    [7, 2, 130, 6, 5, 1, 3, 4].

gm_get() ->
    StSoul = get(?PROC_STATUS_EQUIP_SOUL),
    ?DEBUG("StSoul ~p~n", [StSoul]),
    ok.

log_equip_soul_op(Pkey, Nickname, Lv, OldGoods, NewGoods) ->
    Sql = io_lib:format("insert into log_equip_soul_op set pkey=~p,nickname='~s',lv=~p,old_goods = ~p,new_goods = ~p,time=~p", [Pkey, Nickname, Lv, OldGoods, NewGoods, util:unixtime()]),
    log_proc:log(Sql).


%% 武魂合成日志
log_equip_soul_up(Pkey, Nickname, Lv, CostGoods, CostNum, GetGoods, GetNum) ->
    Sql = io_lib:format("insert into log_equip_soul_up set pkey=~p,nickname='~s',lv=~p,cost_goods = ~p,cost_num = ~p, get_goods = ~p,get_num = ~p,time=~p", [Pkey, Nickname, Lv, CostGoods, CostNum, GetGoods, GetNum, util:unixtime()]),
    log_proc:log(Sql).




