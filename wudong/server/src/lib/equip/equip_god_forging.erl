%%%-------------------------------------------------------------------
%%% @author luobq
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 装备神炼
%%% @end
%%% Created : 21. 七月 2017 13:56
%%%-------------------------------------------------------------------
-module(equip_god_forging).
-author("luobq").
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
-include("error_code.hrl").
-include("money.hrl").
-include("new_shop.hrl").
-include("achieve.hrl").
-include("task.hrl").
%% API
-export([
    equip_god_forging/2
]).

%%装备神炼
equip_god_forging(Player, GoodsKey) ->
    case check_and_cost(Player, GoodsKey) of
        {false, Res} -> {false, Res};
        {ok, Goods, GoodsId, GoodsNum} ->
            goods:subtract_good_throw(Player, [{GoodsId, GoodsNum}], 21),
            log_equip_god_forging(Player#player.key, Player#player.nickname, Goods#goods.goods_id, Goods#goods.god_forging, 1, GoodsId, GoodsNum, util:unixtime()),
            Goods1 = Goods#goods{god_forging = Goods#goods.god_forging + 1},
            NewGoods = equip_attr:equip_combat_power(Goods1),
            GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
            server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
            goods_load:dbup_goods_god_forging(NewGoods),
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
            GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
            lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
            NewPlayer1 = player_util:count_player_attribute(Player, true),
            {ok, NewPlayer1}
    end.

check_and_cost(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    Limti = data_equip_god_forging:subtype_god_forging_lim(GoodsType#goods_type.subtype),
    if
        Goods#goods.god_forging >= Limti -> {false, 49};
        Goods#goods.star < 4 -> {false,51};
        true ->
            Base = data_equip_god_forging:get(GoodsType#goods_type.subtype, Goods#goods.god_forging + 1),
            GoodsId = Base#base_equip_god_forging.goods_id,
            GoodsNum = Base#base_equip_god_forging.num,
            HaveNum = goods_util:get_goods_count(GoodsId),
            if HaveNum >= GoodsNum ->
                {ok, Goods, GoodsId, GoodsNum};
                true ->
                    goods_util:client_popup_goods_not_enough(Player, GoodsId, GoodsNum, 21),
                    {false, 41} %% 物品不足
            end
    end.

log_equip_god_forging(Pkey, Nickname, GoodsId, BeforLv, AddLevel, CostGoods, GoodsNum, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_god_forging set pkey = ~p,nickname = '~s',goods_id =~p,result=~p,befor_lv=~p,after_lv = ~p, cost_goods = ~p, goods_num = ~p,time=~p">>,
        [Pkey, Nickname, GoodsId, AddLevel, BeforLv, BeforLv + AddLevel, CostGoods, GoodsNum, Time]),
    log_proc:log(Sql),
    ok.
