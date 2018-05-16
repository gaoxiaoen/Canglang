%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 31. 十月 2016 18:23
%%%-------------------------------------------------------------------
-module(equip_star).
-author("hxming").

-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").
-include("equip.hrl").
-include("achieve.hrl").
%% API
-export([upgrade_star/2]).

%%升星
upgrade_star(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    EquipUpgrade = data_equip_upgrade:get(Goods#goods.star, GoodsType#goods_type.subtype),
    ?ASSERT(EquipUpgrade =/= [], {false, 20}),
    ?DO_IF(Player#player.coin < EquipUpgrade#base_equip_upgrade.need_coin, goods_util:client_popup_goods_not_enough(Player, 10101, EquipUpgrade#base_equip_upgrade.need_coin, 21)),
    ?ASSERT(money:is_enough(Player, EquipUpgrade#base_equip_upgrade.need_coin, coin), {false, 5}),
    ?ASSERT(Player#player.bgold + Player#player.gold >= EquipUpgrade#base_equip_upgrade.need_bgold, {false, 37}),
    ?ASSERT(Player#player.gold >= EquipUpgrade#base_equip_upgrade.need_gold, {false, 37}),
    [GiveGoodsId | _] = [GoodsId || {C, GoodsId} <- EquipUpgrade#base_equip_upgrade.get_goods_id, C == Player#player.career orelse C == 0],
    NewGoodsType = data_goods:get(GiveGoodsId),

    F0 = fun({BaseGoodsId, BaseGoodsNum}) ->
        case catch goods:subtract_good_throw(Player, [{BaseGoodsId, BaseGoodsNum}], 68) of
            {ok, _} -> true;
            _ -> false
        end
    end,
    %% 优先扣除第一个物品
    Flag = lists:any(F0, EquipUpgrade#base_equip_upgrade.need_goods),
    ?ASSERT(Flag == true, {false, 41}),

    Goods1 = Goods#goods{goods_id = GiveGoodsId, goods_lv = NewGoodsType#goods_type.equip_lv, star = Goods#goods.star + 1},
    NewGoods = equip_attr:equip_combat_power(Goods1),
    GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
    server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    goods_load:dbup_goods_id(NewGoods),
    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
    equip_soul:update_soul_goods(Player#player.vip_lv,NewGoods), %% 检查武魂
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
    Player0 = money:add_coin(Player, -EquipUpgrade#base_equip_upgrade.need_coin, 68, 0, 0),
    Player0_1 = money:add_gold(Player0, -EquipUpgrade#base_equip_upgrade.need_bgold, 68, 0, 0),
    Player0_2 = money:add_no_bind_gold(Player0_1, -EquipUpgrade#base_equip_upgrade.need_gold, 68, 0, 0),
    Player1 = equip_attr:equip_suit_calc(Player0_2),
    NewPlayer1 = player_util:count_player_attribute(Player1, true),
    cron_equip_upgrade(Player#player.key, Player#player.nickname, Goods#goods.key, Goods#goods.goods_id, NewGoods#goods.goods_id, EquipUpgrade#base_equip_upgrade.need_coin, EquipUpgrade#base_equip_upgrade.need_goods, util:unixtime()),
    %%  成就
    EquipList = goods_util:get_goods_list_by_location(GoodsSt2, ?GOODS_LOCATION_BODY),
    EquipColorList = equip_util:get_equip_color_list(EquipList),
    F1 = fun({Color, ColorCount}) ->
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1004, Color, ColorCount)
    end,
    lists:foreach(F1, EquipColorList),

    {ok, NewPlayer1, Goods, NewGoods, GoodsType, NewGoodsType}.





cron_equip_upgrade(Pkey, Nickname, Gkey, GoodsId, AfterGoodsId, GoodsMoney, CostGoods, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_upgrade set pkey = ~p,nickname = '~s',gkey = ~p,goods_id= ~p,after_goods_id = ~p,cost_money =~p,
			cost_goods ='~s',time=~p">>,
        [Pkey, Nickname, Gkey, GoodsId, AfterGoodsId, GoodsMoney, util:term_to_bitstring(CostGoods), Time]),
    log_proc:log(Sql),
    ok.
