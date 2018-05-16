%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备强化
%%% @end
%%% Created : 17. 一月 2015 14:52
%%%-------------------------------------------------------------------
-module(equip_inlay).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
-include("error_code.hrl").
-include("achieve.hrl").


%% API
-export([
    get_inlay_suit/1,
    gem_default/0,
    get_equip_inlay_stone_lv_total/0,
    check_stone_inlay_state/0,
    equip_inlay/3,      %%装备镶嵌
    exp_info_send/2
]).

-define(GEM_TYPE_ATT, 61).
-define(GEM_TYPE_HP, 63).
-define(GEM_TYPE_DEF, 62).


%%装备默认孔位
gem_default() ->
    [{?GEM_TYPE_ATT, 0}, {?GEM_TYPE_HP, 0}, {?GEM_TYPE_DEF, 0}].


%%检查是否有宝石可镶嵌
check_stone_inlay_state() ->
    case goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [?GOODS_SUBTYPE_HEXAGRAM_STONE, ?GOODS_SUBTYPE_ROUNDNESS_STONE, ?GOODS_SUBTYPE_SQUARE_STONE]) of
        [] -> 0;
        _ ->
            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
            F = fun(Goods) ->
                case [Id || {Id, GoodsId} <- Goods#goods.gemstone_groove, GoodsId == 0] of
                    [] ->
                        case [Id || {Id, GoodsId} <- Goods#goods.gemstone_groove, GoodsId > 0] of
                            [] -> false;
                            Ids ->
                                case lists:any(fun(Id) -> goods_util:get_goods_count(Id) >= 3 end, Ids) of
                                    true ->
                                        true;
                                    false ->
                                        false
                                end
                        end;
                    TypeList ->
                        case lists:any(fun(SubType) ->
                            goods_util:get_goods_count_by_subtype(SubType) > 0 end, TypeList) of
                            true ->
                                true;
                            false ->
                                false
                        end
                end
                end,
            case lists:any(F, GoodsList) of
                true -> 1;
                false -> 0
            end
    end.

%%获取镶嵌的宝石总等级
get_equip_inlay_stone_lv_total() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    LvFun =
        fun(StoneId) ->
            data_gemstone_level:get(StoneId)
        end,
    F = fun(Goods) ->
        lists:sum([LvFun(StoneId) || {_, StoneId} <- Goods#goods.gemstone_groove])
        end,
    lists:sum(lists:map(F, GoodsList)).


%%获取装备镶嵌套装属性
get_inlay_suit(_Player) ->
    StoneLv = equip_attr:stone_lv(),
    CurStoneLv =
        case [Lv || Lv <- data_equip_inlay_suit:ids(), Lv =< StoneLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_inlay_suit:get(CurStoneLv)),
    Cbp = attribute_util:calc_combat_power(Attribute),
    AttrList = attribute_util:pack_attr(Attribute),
    MaxLv = data_equip_inlay_suit:max_lv(),
    if StoneLv >= MaxLv ->
        {StoneLv, Cbp, AttrList, 1, 0, 0, 0, 0, []};
        true ->
            NextStoneLv =
                case [Lv || Lv <- data_equip_inlay_suit:ids(), Lv > StoneLv] of
                    [] -> 0;
                    L2 -> lists:min(L2)
                end,
            {Active, ActiveLim} = equip_attr:stone_active(NextStoneLv),
            NextAttribute = attribute_util:make_attribute_by_key_val_list(data_equip_inlay_suit:get(NextStoneLv)),
            NextCbp = attribute_util:calc_combat_power(NextAttribute),
            NextAttrList = attribute_util:pack_attr(NextAttribute),
            {StoneLv, Cbp, AttrList, 0, NextStoneLv, Active, ActiveLim, NextCbp, NextAttrList}
    end.


%%装备镶嵌
equip_inlay(Player, GoodsKey, GemType) ->
    Goods = goods_util:get_goods(GoodsKey),
    case lists:keytake(GemType, 1, Goods#goods.gemstone_groove) of
        false -> {false, 8};
        {value, {_GemType, OldGemId}, T} ->
            case check_gem(GemType, OldGemId) of
                0 -> {false, 34};
                GemId ->
                    [MaterialId, MaterialNum, Plv, Coin] = data_gemstone_level:get_material(GemId),
                    GoodsCount = goods_util:get_goods_count(MaterialId),
                    ?DO_IF(GoodsCount < MaterialNum, goods_util:client_popup_goods_not_enough(Player, MaterialId, MaterialNum, 193)),
                    ?ASSERT(GoodsCount >= MaterialNum, {false, 35}),
                    ?ASSERT(Player#player.lv >= Plv, {false, 36}),
                    ?ASSERT(money:is_enough(Player, Coin, coin), {false, 5}),
                    goods:subtract_good(Player, [{MaterialId, MaterialNum}], 193),
                    Player1 = money:add_coin(Player, -Coin, 193, 0, 0),
                    GemstoneGroove = [{GemType, GemId} | T],
                    NewGoods0 = Goods#goods{bind = ?BIND, gemstone_groove = GemstoneGroove},
                    NewGoods = equip_attr:equip_combat_power(NewGoods0),
                    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
                    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
                    goods_load:dbup_equip_inlay(NewGoods),
                    NewGoodsSt = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
                    goods_pack:pack_send_goods_info(NewGoods,Player#player.sid),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    Player2 = equip_attr:equip_suit_calc(Player1),
                    if
                        Goods#goods.location =:= ?GOODS_LOCATION_BODY -> %%穿在身上的装备镶嵌，需要重新计算玩家属性
                            %%冲榜活动
                            act_rank:update_player_rank_data(Player, 3, false),
                            NewPlayer = player_util:count_player_attribute(Player2, true);
                        true ->
                            NewPlayer = Player2
                    end,
                    log_inlay(Player#player.key, Player#player.nickname, 1, GemId, 1, Goods#goods.goods_id, GemstoneGroove, GemstoneGroove, 0, util:unixtime()),
                    %%成就
                    gem_achieve(Player, NewGoodsSt),
                    {ok, NewPlayer}
            end
    end.

gem_achieve(Player, GoodsSt) ->
    %%成就
    EquipList = goods_util:get_goods_list_by_location(GoodsSt, ?GOODS_LOCATION_BODY),
    F = fun(Equip) -> [data_gemstone_level:get(Id) || {_, Id} <- Equip#goods.gemstone_groove] end,
    case lists:flatmap(F, EquipList) of
        [] -> ok;
        GemList ->
            case lists:max(GemList) of
                0 -> ok;
                MaxLv ->
                    F2 = fun(GemLv) ->
                        GemCount = length([Lv || Lv <- GemList, Lv >= GemLv]),
                        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1009, GemLv, GemCount)
                         end,
                    lists:foreach(F2, lists:seq(1, MaxLv))
            end
    end.

check_gem(GemType, GemId) ->
    if GemId == 0 ->
        data_gemstone_level:get_goods_id(GemType, 1);
        true ->
            Level = data_gemstone_level:get(GemId),
            data_gemstone_level:get_goods_id(GemType, Level + 1)
    end.



log_inlay(Pkey, Nickname, Type, GemGoodsId, Gem_num, Goods_id, Befor_attr, After_attr, Cost_money, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_inlay set pkey = ~p,nickname = '~s',type = ~p,gem_goods_id=~p,gem_num =~p,
			goods_id =~p,befor_attr ='~s',after_attr ='~s',cost_money = ~p,time=~p">>,
        [Pkey, Nickname, Type, GemGoodsId, Gem_num, Goods_id, util:term_to_bitstring(Befor_attr), util:term_to_bitstring(After_attr), Cost_money, Time]),
    log_proc:log(Sql),
    ok.

exp_info_send(Sid, List) ->
    {ok, Bin} = pt_160:write(16020, {[[GoodsId, Exp] || {GoodsId, Exp} <- List]}),
    server_send:send_to_sid(Sid, Bin),
    ok.
