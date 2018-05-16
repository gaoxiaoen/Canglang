%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 一月 2018 16:13
%%%-------------------------------------------------------------------
-module(equip_level).
-author("Administrator").
-include("goods.hrl").
-include("equip.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([
    equip_up_lv/2,
    get_next_level_base/2
]).

%% 装备升级
equip_up_lv(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    LevleLimit = data_equip_level_up:subtype_level_lim(GoodsType#goods_type.subtype),
    if
        LevleLimit == [] orelse Goods#goods.level >= LevleLimit -> {false, 56};
        true ->
            case get_next_level_base(GoodsType#goods_type.subtype, Goods#goods.level) of
                [] ->
                    {false, 0};
                #base_equip_level_up{
                    level = Level,
                    cost_goods = CostGoods,
                    coin = Coin
                } ->
                    Count = goods_util:get_goods_count(CostGoods),
                    if
                        Count =< 0 -> {false, 3}; %% 数量不足
                        true ->
                            case money:is_enough(Player, Coin, coin) of
                                false -> {false, 5};
                                true ->
                                    goods:subtract_good(Player, [{CostGoods, 1}], 345),
                                    NewPlayer2 = money:add_coin(Player, -Coin, 345, 0, 0),
                                    Goods1 = Goods#goods{level = Level},
                                    NewGoods = equip_attr:equip_combat_power(Goods1),
                                    GoodsBin = goods_pack:pack_goods_info_bin([NewGoods]),
                                    server_send:send_to_sid(NewPlayer2#player.sid, GoodsBin),
                                    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
                                    goods_load:dbup_goods_level(NewGoods),
                                    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
                                    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
                                    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
                                    NewPlayer3 = equip_attr:equip_suit_calc(NewPlayer2),
                                    NewPlayer4 = player_util:count_player_attribute(NewPlayer3, true),
                                    log_equip_level_up(NewPlayer4#player.key, NewPlayer4#player.nickname, Goods#goods.key, Goods#goods.goods_id, Goods#goods.level, Goods1#goods.level, GoodsType#goods_type.subtype, CostGoods, Coin, util:unixtime()),
                                    {ok, NewPlayer4}
                            end
                    end
            end
    end.

get_next_level_base(Subtype, Level) ->
    Levels = [X || X <- data_equip_level_up:get_levev_list(Subtype), X > Level],
    case Levels of
        [] -> [];
        _ -> data_equip_level_up:get(Subtype, hd(Levels))
    end.


log_equip_level_up(Pkey, Nickname, Gkey, GoodsId, Before, After, Subtype, CostGoods, Coin, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_level_up set pkey = ~p,nickname = '~s',gkey = ~p,goods_id= ~p,before_level = ~p,after_level = ~p, cost_goods =~p,coin =~p,subtype=~p,time=~p">>,
        [Pkey, Nickname, Gkey, GoodsId, Before, After, CostGoods, Coin, Subtype, Time]),
    log_proc:log(Sql),
    ok.