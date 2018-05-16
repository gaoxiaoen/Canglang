%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备
%%% @end
%%% Created : 15. 一月 2015 14:29
%%%-------------------------------------------------------------------
-module(equip).
-include("common.hrl").
-include("server.hrl").
-include("equip.hrl").
-include("goods.hrl").
-include("goods.hrl").
-include("achieve.hrl").
-include("task.hrl").

%% 协议接口
-export([
    put_on_equip/2,   %%穿上装备
    get_off_equip/2,   %%卸下装备,
    check_equip_up_state/1,
    check_equip_star_state/1,
    equip_attr_view/0,
    equip_figure_update/2,
    auto_wear/2,
    equip_compose/3 %% 图纸合成
]).

%%put_on_equip_check(GoodsInfo, GoodsTypeInfo, Player) ->
%%    ?ASSERT(Player#player.lv >= GoodsTypeInfo#goods_type.need_lv, {false, 4}),
%%    ?ASSERT(GoodsTypeInfo#goods_type.type =:= ?GOODS_TYPE_EQUIP, {false, 0}),
%%    ?ASSERT(GoodsInfo#goods.location =:= ?GOODS_LOCATION_BAG, {false, 0}),
%%    ?ASSERT(GoodsTypeInfo#goods_type.type =:= 1, {false, 0}),
%%    ?ASSERT(GoodsTypeInfo#goods_type.career =:= 0 orelse GoodsTypeInfo#goods_type.career =:= Player#player.career, {false, 17}),
%%    ok.

%%穿上装备
put_on_equip(GoodsKey, Player) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST};
        Equip ->
            GoodsTypeInfo = data_goods:get(Equip#goods.goods_id),
            if Player#player.lv < GoodsTypeInfo#goods_type.need_lv -> {false, 4};
                GoodsTypeInfo#goods_type.type =/= ?GOODS_TYPE_EQUIP -> {false, 0};
                Equip#goods.location =/= ?GOODS_LOCATION_BAG -> {false, 0};
                GoodsTypeInfo#goods_type.career /= 0 andalso GoodsTypeInfo#goods_type.career =/= Player#player.career ->
                    {false, 17};
                true ->
                    %%看看原来这个位置，是否已经佩戴了装备
                    case lists:keyfind(GoodsTypeInfo#goods_type.subtype, #weared_equip.pos, GoodsSt#st_goods.weared_equip) of
                        false -> %%原来格子上没有配带装备
                            ErrorCode = 1,
                            NewEquip = Equip#goods{
                                bind = ?BIND,
                                cell = GoodsTypeInfo#goods_type.subtype,
                                location = ?GOODS_LOCATION_BODY},
                            goods_load:dbup_goods_cell_location(NewEquip),
                            NewGoodsDict = goods_dict:update_goods(NewEquip, GoodsSt#st_goods.dict),
                            goods_pack:pack_send_goods_info([NewEquip], GoodsSt#st_goods.sid),
                            GoodsSt1 = GoodsSt#st_goods{
                                leftover_cell_num = GoodsSt#st_goods.leftover_cell_num + 1,
                                dict = NewGoodsDict};
                        OldEquip -> %%原来这个格子上有装备，进行装备替换，把原来的装被放进背包
                            ErrorCode = 18,
                            OldGoods = goods_util:get_goods(OldEquip#weared_equip.goods_key),
                            ?ASSERT(OldGoods#goods.star < Equip#goods.star, {false, 53}),
                            NewEquip = OldGoods#goods{
                                key = Equip#goods.key,
                                bind = ?BIND,
                                level = max(Equip#goods.level, OldGoods#goods.level),
                                goods_id = GoodsTypeInfo#goods_type.goods_id,
                                goods_lv = GoodsTypeInfo#goods_type.equip_lv,
                                stren = max(Equip#goods.stren, OldGoods#goods.stren),
                                star = Equip#goods.star
                            },
                            DelGoods = OldGoods#goods{location = ?GOODS_LOCATION_BAG},
                            goods_load:dbup_goods(NewEquip),
                            goods_load:dbup_goods(DelGoods),
%%                             goods_load:dbdel_goods(DelGoods),
                            goods_pack:pack_send_goods_info([DelGoods, NewEquip], GoodsSt#st_goods.sid),
                            GoodsSt0 = goods_dict:update_goods([DelGoods, NewEquip], GoodsSt),
                            GoodsSt1 = GoodsSt0#st_goods{leftover_cell_num = GoodsSt#st_goods.leftover_cell_num}
                    end,
                    NewGoodsSt = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewEquip),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    Player1 = equip_figure_update(Player, GoodsTypeInfo),
                    Player2 = equip_attr:equip_suit_calc(Player1),
                    NewPlayer = player_util:count_player_attribute(Player2, true),
                    self() ! {d_v_trigger, 3, []},
                    %%冲榜活动
                    act_rank:update_player_rank_data(Player, 1, false),
                    %%成就
                    EquipList = goods_util:get_goods_list_by_location(NewGoodsSt, ?GOODS_LOCATION_BODY),
                    EquipColorList = equip_util:get_equip_color_list(EquipList),
                    F1 = fun({Color, ColorCount}) ->
                        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1004, Color, ColorCount)
                    end,
                    lists:foreach(F1, EquipColorList),
                    EquipStrengthList = equip_util:get_equip_stren_list(EquipList),
                    F2 = fun({Stren, StrenCount}) ->
                        task_event:event(?TASK_ACT_EQUIP_STRENGTH, {Stren, StrenCount})
                    end,
                    lists:foreach(F2, EquipStrengthList),
                    %%这个保存起来用于其他玩家查看信息
                    {ok, NewPlayer#player{weared_equip = equip_attr_view()}, ErrorCode}
            end
    end.

equip_attr_view() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    F = fun(Goods0) ->
        GoodsType = data_goods:get(Goods0#goods.goods_id),
        GoodsType#goods_type.subtype
    end,
    [#equip_attr_view{goods_id = Goods#goods.goods_id,
        stren = Goods#goods.stren,
        star = Goods#goods.star,
        gem = Goods#goods.gemstone_groove,
        wash = Goods#goods.wash_attr,
        refine_attr = Goods#goods.refine_attr,
        magic_info = equip_magic:get_magic_info(F(Goods)),
        god_forging = Goods#goods.god_forging,
        level = Goods#goods.level
    } || Goods <- GoodsList].


equip_figure_update(Player, GoodsType) ->
    case GoodsType#goods_type.subtype of
        ?GOODS_SUBTYPE_WEAPON ->
            OldEquipFigure = Player#player.equip_figure,
            Player#player{equip_figure = OldEquipFigure#equip_figure{weapon_id = GoodsType#goods_type.goods_id}};
        ?GOODS_SUBTYPE_GLOVE ->
            OldEquipFigure = Player#player.equip_figure,
            Player#player{equip_figure = OldEquipFigure#equip_figure{clothing_id = GoodsType#goods_type.goods_id}};
        _ ->
            Player
    end.

%%卸下装备
get_off_equip(_GoodsKey, Player) ->
    {ok, Player}.


%%检查装备是否可升级
check_equip_up_state(Player) ->
    F = fun(Goods) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        case data_equip_upgrade:get(GoodsType#goods_type.equip_lv, GoodsType#goods_type.subtype) of
            [] ->
                false;
            EquipUpgrade ->
                [GiveGoodsId | _] = [GoodsId || {C, GoodsId} <- EquipUpgrade#base_equip_upgrade.get_goods_id, C == Player#player.career orelse C == 0],
                NewGoodsType = data_goods:get(GiveGoodsId),
                if NewGoodsType#goods_type.equip_lv > Player#player.lv -> false;
                    true ->
                        F1 = fun({Gid, Num}) ->
                            Count = goods_util:get_goods_count(Gid),
                            Count < Num
                        end,
                        case lists:any(F1, EquipUpgrade#base_equip_upgrade.need_goods) of
                            true -> false;
                            false -> true
                        end
                end
        end
    end,
    case lists:any(F, goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY)) of
        true ->
            1;
        false -> 0
    end.

%%检查装备是否可升级
check_equip_star_state(_Player) ->
    F = fun(Goods) ->
        if Goods#goods.star >= 5 -> false;
            true ->
                GoodsType = data_goods:get(Goods#goods.goods_id),
                EquipStar = data_equip_star:get(GoodsType#goods_type.subtype, Goods#goods.star),
                F1 = fun({Gid, Num}) ->
                    Count = goods_util:get_goods_count(Gid),
                    Count < Num
                end,
                case lists:any(F1, EquipStar#base_equip_star.need_goods) of
                    true -> false;
                    false -> true
                end
        end
    end,
    case lists:any(F, goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY)) of
        true ->
            1;
        false -> 0
    end.

auto_wear(GoodsKey, Player) ->
    case catch put_on_equip(GoodsKey, Player) of
        {ok, NewPlayer, _ErrorCode} ->
            scene_agent_dispatch:equip_update(Player),
            {ok, NewPlayer};
        _ ->
            ok
    end.

equip_compose(Player, GoodsId, ConsumeList) ->
    case check_equip_compose(Player, GoodsId, ConsumeList) of
        {fail, Code} ->
            {Code, Player};
        {true, AddNum} ->
            F = fun([CostGoodsId, CostNum]) ->
                goods:subtract_good(Player, [{CostGoodsId, CostNum}], 0)
            end,
            lists:map(F, ConsumeList),
            GiveGoodsList = goods:make_give_goods_list(0, [{GoodsId, AddNum}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {1, NewPlayer}
    end.

check_equip_compose(_Player, _GoodsId, []) -> {fail, 42};

check_equip_compose(_Player, GoodsId, ConsumeList) ->
    #base_equip_compose{
        consume = BaseConsumeList,
        cost_num = CostNum
    } = data_equip_compose:get(GoodsId),
    F = fun([CostGoodsId, CostNum0]) ->
        StGoods = lib_dict:get(?PROC_STATUS_GOODS),
        case goods_util:get_goods_list_by_goods_id(CostGoodsId, StGoods#st_goods.dict) of
            {false, _} -> true;
            {HasCount, _} ->
                Flag = lists:member(CostGoodsId, BaseConsumeList),
                ?IF_ELSE(HasCount >= CostNum0 andalso Flag == true, false, true)
        end
    end,
    case lists:any(F, ConsumeList) of
        true ->
            {fail, 42}; %% 数量不足
        false ->
            TotalNum = lists:sum(lists:map(fun([_GoodsId, GNum]) -> GNum end, ConsumeList)),
            ?DEBUG("TotalNum:~p CostNum:~p~n", [TotalNum, CostNum]),
            if
                TotalNum rem CostNum /= 0 -> {fail, 42};
                true -> {true, TotalNum div CostNum}
            end
    end.
