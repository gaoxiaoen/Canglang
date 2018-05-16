%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 一月 2015 14:04
%%%-------------------------------------------------------------------
-module(equip_rpc).
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("equip.hrl").
-include("task.hrl").
-include("achieve.hrl").
%% API
-export([
    handle/3
]).

%%装备物品
handle(16001, Player, {GoodsKey}) ->
    case catch equip:put_on_equip(GoodsKey, Player) of
        {ok, NewPlayer} ->
            {ok, attr, NewPlayer};
        {ok, NewPlayer, ErrorCode} ->
            {ok, Bin} = pt_160:write(16001, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, equip, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16001, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%卸下装备
handle(16002, Player, {GoodsKey}) ->
    case catch equip:get_off_equip(GoodsKey, Player) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16002, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, equip, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16002, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%强化装备
handle(16003, Player, {GoodsKey, AutoBuy}) ->
    case catch equip_stren:equip_strength(Player, GoodsKey, AutoBuy) of
        {ok, NewPlayer, ErrorCode} ->
            {ok, Bin} = pt_160:write(16003, {GoodsKey, ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_STRENGTHEN, {1}),
            {ok, halo, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {ok, Bin} = pt_160:write(16003, {GoodsKey, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16003, {GoodsKey, ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%装备洗练
handle(16004, Player, {SourceGoodsKey, DestGoodsKey, Which}) ->
    case catch equip_wash:equip_wash(Player, SourceGoodsKey, DestGoodsKey, Which) of
        {ok, NewPlayer, {OldType, OldValue}, {NewType, NewValue}} ->
            {ok, Bin} = pt_160:write(16004, {?ER_SUCCEED, attribute_util:attr_tans_client(OldType), OldValue, attribute_util:attr_tans_client(NewType), NewValue}),
            server_send:send_to_sid(Player#player.sid, Bin),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1006, 0, 1),
            {ok, attr, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16004, {?IF_ELSE(ErrorCode =:= 3, 22, ErrorCode), 0, 0, 0, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


handle(16006, Player, {Subtype}) ->
    equip_stren:get_equip_strength_exp(Player, Subtype),
    ok;

%%装备镶嵌
handle(16007, Player, {GoodsKey, GemType}) ->
    case catch equip_inlay:equip_inlay(Player, GoodsKey, GemType) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16007, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_STONE, {1}),
            {ok, attr, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16007, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%获取强化套装属性
handle(16008, Player, {}) ->
    Data = equip_stren:get_stren_suit(),
    {ok, Bin} = pt_160:write(16008, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%获取宝石套装属性
handle(16009, Player, {}) ->
    Data = equip_inlay:get_inlay_suit(Player),
    {ok, Bin} = pt_160:write(16009, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 装备熔炼
handle(16011, Player, {List}) ->
    case catch equip_smelt:equip_smelt(Player, List) of
        {ok, NewPlayer, ErrorCode, GoodsId} ->
            {ok, Bin} = pt_160:write(16011, {ErrorCode, GoodsId}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16011, {ErrorCode, 0}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 获取熔炼值
handle(16012, Player, _) ->
    {ok, Bin} = pt_160:write(16012, {Player#player.smelt_value}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 洗练转移
handle(16013, Player, {GoodsKey1, GoodsKey2}) ->
    case catch equip_wash:transfer(Player, GoodsKey1, GoodsKey2) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16013, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16013, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 装备升星
handle(16014, Player, {GoodsKey}) ->
    case catch equip_star:upgrade_star(Player, GoodsKey) of
        {false, Code} ->
            {ok, Bin} = pt_160:write(16014, {?IF_ELSE(Code == 3, 22, Code), 0, 0, 0, 0, 0, 0, [], []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, EGoods, ENewGoods, EGoodsType, ENewGoodsType} ->
            AttrList = [[attribute_util:attr_tans_client(K), V] || {K, V} <- EGoodsType#goods_type.attr_list],
            AfterAttrList = [[attribute_util:attr_tans_client(K), V] || {K, V} <- ENewGoodsType#goods_type.attr_list],
            {ok, Bin} = pt_160:write(16014, {1, EGoods#goods.goods_id, ENewGoods#goods.goods_id, EGoods#goods.combat_power, ENewGoods#goods.combat_power, ENewGoods#goods.stren, ENewGoods#goods.star, AttrList, AfterAttrList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            self() ! {d_v_trigger, 4, []},
            self() ! {m_task_trigger, 10, 1},
            {ok, NewPlayer#player{weared_equip = equip:equip_attr_view()}}
    end;

%%装备洗练
handle(16016, Player, {AutoBuy, GoodsKey, LockList}) ->
    case catch equip_wash:equip_wash(AutoBuy, Player, GoodsKey, LockList) of
        {ok, NewPlayer, NewWashList, Goods} when Goods#goods.wash_attr == [] ->
            {ok, Bin} = pt_160:write(16016, {?ER_SUCCEED, NewWashList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_WASH, {1}),
            {ok, NewPlayer1} = handle(16017, NewPlayer, {GoodsKey}),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1006, 0, 1),
            {ok, NewPlayer1};
        {ok, NewPlayer, NewWashList, _} ->
            {ok, Bin} = pt_160:write(16016, {?ER_SUCCEED, NewWashList}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_WASH, {1}),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1006, 0, 1),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16016, {ErrorCode, []}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%装备洗练替换
handle(16017, Player, {GoodsKey}) ->
    case catch equip_wash:equip_wash_restore(Player, GoodsKey) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16017, {?ER_SUCCEED}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16017, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, Player}
    end;

%%装备洗练替换
handle(16018, Player, _) ->
    StWash = lib_dict:get(?PROC_STATUS_WASH),
    List = [[Pos, [[attribute_util:attr_tans_client(K), V] || {K, V} <- WashList]] || {Pos, WashList} <- StWash#st_equip_wash.wash_attr],
    {ok, Bin} = pt_160:write(16018, {List}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%合成
handle(16019, Player, {Id, CompoundNum}) ->
    case catch equip_compound:compound(Id, CompoundNum, Player) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16019, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16019, {ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%% 婚戒升级
handle(16022, Player, {GoodsKey}) ->
    case catch begin
                   Goods = goods_util:get_goods(GoodsKey),
                   GoodsType = data_goods:get(Goods#goods.goods_id),
                   EquipUpgrade = data_wedding_ring_upgrade:get(Goods#goods.goods_id),
                   ?ASSERT(EquipUpgrade =/= [], {false, 4}),
                   ?DO_IF(Player#player.coin < EquipUpgrade#wedding_ring_upgrade.need_coin, goods_util:client_popup_goods_not_enough(Player, 10101, EquipUpgrade#wedding_ring_upgrade.need_coin, 21)),
                   ?ASSERT(money:is_enough(Player, EquipUpgrade#wedding_ring_upgrade.need_coin, coin), {false, 5}),
                   goods:subtract_good_throw(Player, EquipUpgrade#wedding_ring_upgrade.need_goods, 189),
                   Player1 = money:add_coin(Player, -EquipUpgrade#base_equip_upgrade.need_coin, 189, 0, 0),
                   Goods1 = Goods#goods{goods_id = EquipUpgrade#wedding_ring_upgrade.get_goods_id, goods_lv = GoodsType#goods_type.equip_lv},
                   NewGoods = equip_attr:equip_combat_power(Goods1),
                   GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
                   server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
                   GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
                   goods_load:dbup_goods_id(NewGoods),
                   GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
                   GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
                   lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
                   NewPlayer1 = player_util:count_player_attribute(Player1, true),
                   {ok, NewPlayer1} end of
        {false, Code} ->
            {ok, Bin} = pt_160:write(16022, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16022, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer#player{weared_equip = equip:equip_attr_view()}}
    end;

%% 婚戒兑换
handle(16023, Player, {GoodsId, Num}) ->
    case catch begin
                   EquipUpgrade = data_wedding_ring_upgrade:get(GoodsId),
                   ?ASSERT(EquipUpgrade =/= [], {false, 4}),
                   goods:subtract_good_throw(Player, [{GoodsId, Num}], 189),
                   goods:give_goods(Player, goods:make_give_goods_list(189, EquipUpgrade#wedding_ring_upgrade.exchange_goods)),
                   ok
               end of
        {false, Code} ->
            {ok, Bin} = pt_160:write(16023, {Code}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        ok ->
            {ok, Bin} = pt_160:write(16023, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 装备精炼
handle(16035, Player, {GoodsKey}) ->
    case equip_refine:equip_refine(Player, GoodsKey) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16035, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16035, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1007, 0, 1),
            {ok, attr, NewPlayer};
        _ ->
            ok
    end;

%%装备神炼
handle(16026, Player, {GoodsKey}) ->
    case catch equip_god_forging:equip_god_forging(Player, GoodsKey) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16026, {GoodsKey, 1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            task_event:event(?TASK_ACT_STRENGTHEN, {1}),
            {ok, halo, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        {false, ErrorCode} ->
            {ok, Bin} = pt_160:write(16026, {GoodsKey, ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 装备附魔
handle(16029, Player, {GoodsKey}) ->
    case equip_magic:equip_magic(Player, GoodsKey) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16029, {Res, 1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer, Index} ->
            {ok, Bin} = pt_160:write(16029, {1, Index}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        _ ->
            ok
    end;

%% 武魂镶嵌
handle(16037, Player, {GoodsKey, Location, GoodsId}) ->
    case equip_soul:put_on_soul(Player, GoodsKey, Location, GoodsId) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16037, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16037, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        _ ->
            ok
    end;

%% 取下武魂
handle(16038, Player, {GoodsKey, Location}) ->
    case equip_soul:take_down_soul(Player, GoodsKey, Location) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16038, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16038, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        _ ->
            ok
    end;

%% 武魂合成
handle(16039, Player, {Goodsid, Num}) ->
    case equip_soul:soul_com(Player, Goodsid, Num) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16039, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16039, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        _ ->
            ok
    end;

%% 武魂开启
handle(16040, Player, {GoodsKey}) ->
    case equip_soul:open_soul(Player, GoodsKey) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16040, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16040, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        _ ->
            ok
    end;

%%获取武魂套装属性
handle(16041, Player, {}) ->
    Data = equip_soul:get_soul_suit(Player),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_160:write(16041, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 武魂升级
handle(16042, Player, {GoodsKey, Location, GoodsId}) ->
    case equip_soul:take_upgrade_soul(Player, GoodsKey, Location, GoodsId) of
        {false, Res} ->
            {ok, Bin} = pt_160:write(16039, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16039, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, attr, NewPlayer};
        _ ->
            ok
    end;


%%一键穿上背包里面所有的装备,单元测试用
handle(16102, Player, _) ->
    case config:is_debug() of
        true ->
            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BAG),
            Fun = fun(Goods, PlayerOut) ->
                case catch equip:put_on_equip(Goods#goods.key, PlayerOut) of
                    {ok, NewPlayerOut, _} ->
                        NewPlayerOut;
                    {false, _ErrorCode} ->
                        PlayerOut
                end
                  end,
            NewPlayer = lists:foldl(Fun, Player, GoodsList),
            goods_rpc:handle(15001, NewPlayer, 0),
            {ok, equip, NewPlayer};
        _ ->
            ok
    end;

%%将身装备强化1次，单元测试用
%%handle(16103, Player, _N) ->
%%    case config:is_debug() of
%%        true ->
%%            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%            Fun = fun(Goods, PlayerOut) ->
%%                case catch equip_stren:equip_stren(Player, Goods#goods.key, "") of
%%                    {ok, NewPlayerOut, _AddLevel} ->
%%                        NewPlayerOut;
%%                    {false, _ErrorCode} ->
%%                        ?PRINT("equip_stren _ErrorCode~p ~n", [_ErrorCode]),
%%                        PlayerOut
%%                end
%%                  end,
%%            NewPlayer = lists:foldl(Fun, Player, GoodsList),
%%            {ok, equip, NewPlayer};
%%        _ ->
%%            ok
%%    end;
%%
%%%%将身装备打孔一次，单元测试用
%%handle(16104, Player, _N) ->
%%    case config:is_debug() of
%%        true ->
%%            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%            Fun = fun(Goods, PlayerOut) ->
%%                case catch equip_inlay:equip_hole(Player, Goods#goods.key) of
%%                    {ok, NewPlayerOut} ->
%%                        NewPlayerOut;
%%                    {false, _ErrorCode} ->
%%                        ?PRINT("equip_hole _ErrorCode ~p ~n", [_ErrorCode]),
%%                        PlayerOut
%%                end
%%                  end,
%%            NewPlayer = lists:foldl(Fun, Player, GoodsList),
%%            {ok, equip, NewPlayer};
%%        _ ->
%%            ok
%%    end;

%%%%将全身装备上面的孔都镶嵌宝石，单元测试用
%%handle(16105, Player, _N) ->
%%    case config:is_debug() of
%%        true ->
%%            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%            Fun = fun(Goods, PlayerOut) ->
%%                Fun1 = fun(Pos, PlayerOut1) ->
%%                    {GemType, _} = lists:nth(Pos, Goods#goods.gemstone_groove),
%%                    [GemGoods | _] = goods_util:get_goods_list_by_subtype_list(?GOODS_LOCATION_BAG, [GemType]),
%%                    {ok, NewPlayerOut1} = equip_inlay:equip_inlay(PlayerOut1, Goods#goods.key, GemGoods#goods.key, Pos),
%%                    NewPlayerOut1
%%                       end,
%%                lists:foldl(Fun1, PlayerOut, lists:seq(1, length(Goods#goods.gemstone_groove)))
%%                  end,
%%            NewPlayer = lists:foldl(Fun, Player, GoodsList),
%%            {ok, equip, NewPlayer};
%%        _ ->
%%            ok
%%    end;

%%将全身装备上面镶嵌的宝石都拆除，单元测试用
%%handle(16106, Player, _N) ->
%%    case config:is_debug() of
%%        true ->
%%            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%            Fun = fun(Goods, PlayerOut) ->
%%                Fun1 = fun(Pos, PlayerOut1) ->
%%                    {ok, NewPlayerOut1} = equip_inlay:dismantle(PlayerOut1, Goods#goods.key, Pos),
%%                    NewPlayerOut1
%%                       end,
%%                lists:foldl(Fun1, PlayerOut, lists:seq(1, length(Goods#goods.gemstone_groove)))
%%                  end,
%%            NewPlayer = lists:foldl(Fun, Player, GoodsList),
%%            {ok, equip, NewPlayer};
%%        _ ->
%%            ok
%%    end;

%%将身上的装备都熔炼一次，单元测试用
handle(16107, Player, _N) ->
    case config:is_debug() of
        true ->
            GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BAG),
            Fun = fun(Goods, OutList) ->
                case data_goods:get(Goods#goods.goods_id) of
                    GoodsType when GoodsType#goods_type.type =:= ?GOODS_TYPE_EQUIP ->
                        Key = lists:concat([GoodsType#goods_type.color, GoodsType#goods_type.career, GoodsType#goods_type.equip_lv]),
                        case lists:keytake(Key, 1, OutList) of
                            false ->
                                [{Key, [Goods#goods.key]} | OutList];
                            {value, {Key, LL}, L3} ->
                                [{Key, [Goods#goods.key | LL]} | L3]
                        end;
                    _ ->
                        OutList
                end
                  end,
            NewList = lists:foldl(Fun, [], GoodsList),
            NewPlayer = lists:foldl(fun({_Key, List}, PlayerOut) ->
                {ok, NewPlayerOut, _, _} = equip_smelt:equip_smelt(PlayerOut, List),
                NewPlayerOut
                                    end, Player, NewList),
            {ok, NewPlayer};
        _ ->
            ok
    end;


%%
handle(16109, Player, _N) ->
    case config:is_debug() of
        true ->
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            {NewPlayer, _NewGoodsSt} =
                lists:foldl(fun(GoodsId, {PlayerOut, GoodsStatusOut}) ->
                    case data_goods:get(GoodsId) of
                        GoodsType when GoodsType#goods_type.subtype == ?GOODS_SUBTYPE_GIFT_BAG ->
                            case catch goods_use:direct_use_virtual_goods([#give_goods{goods_id = GoodsId, num = 1, from = 111111}], PlayerOut, GoodsStatusOut) of
                                {Player1, GoodsSt1} when is_record(Player1, player) andalso is_record(GoodsSt1, st_goods) ->
                                    {Player1, GoodsSt1};
                                Other ->
                                    ?PRINT("GoodsId ~p error ~p ~n", [GoodsId, Other]),
                                    {PlayerOut, GoodsStatusOut}
                            end;
                        _ ->
                            {PlayerOut, GoodsStatusOut}
                    end
                            end, {Player, GoodsSt}, data_goods:get_all_goods_id()),
            ?PRINT("gift test ok ~n", []),
%GoodsInfoList = goods_dict:dict_to_list(NewGoodsSt#st_goods.dict),
%?PRINT("GoodsInfoList ~p  ~n", [[{GoodsInfo#goods.goods_id, GoodsInfo#goods.num} || GoodsInfo <- GoodsInfoList]]),
%put(?PROC_STATUS_GOODS, NewGoodsSt),
            {ok, NewPlayer};
        _ ->
            ok
    end;

%% 装备相关----图纸合成
%% @16050
handle(16050, Player, {GoodsId, ConsumeList}) ->
    {Code, NewPlayer} = equip:equip_compose(Player, GoodsId, ConsumeList),
    {ok, Bin} = pt_160:write(16050, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%% 获取激活套装ID列表
handle(16055, Player, _) ->
    Ids = equip_suit:get_ids(),
    ?DEBUG("Ids:~p", [Ids]),
    {ok, Bin} = pt_160:write(16055, {Ids}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%% 激活
handle(16056, Player, {ActId}) ->
    ?DEBUG("16056 ActId:~p", [ActId]),
    {Code, NewPlayer} = equip_suit:act(Player, ActId),
    ?DEBUG("Code:~p", [Code]),
    {ok, Bin} = pt_160:write(16056, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};


%%装备升级
handle(16057, Player, {GoodsKey}) ->
    case catch equip_level:equip_up_lv(Player, GoodsKey) of
        {ok, NewPlayer} ->
            {ok, Bin} = pt_160:write(16057, {GoodsKey, 1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer#player{weared_equip = equip:equip_attr_view()}};
        {false, ErrorCode} ->
            ?DEBUG("ErrorCode ~p~n", [ErrorCode]),
            {ok, Bin} = pt_160:write(16057, {GoodsKey, ErrorCode}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%%装备兑换商店 信息
handle(16058, Player, {Type}) ->
    Data = equip_part_shop:get_shop_info(Player, Type),
    ?DEBUG("Data ~p~n", [Data]),
    {ok, Bin} = pt_160:write(16058, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%装备兑换商店 购买
handle(16059, Player, {Type, Id}) ->
    {Res, NewPlayer} = equip_part_shop:buy(Player, Type, Id),
    {ok, Bin} = pt_160:write(16059, {Res}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取装备兑换商店分页列表
handle(16060, Player, {}) ->
    Data = equip_part_shop:get_type_list(Player),
    {ok, Bin} = pt_160:write(16060, {Data}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;


handle(_Cmd, _, _) ->
    ?PRINT("equip_rpc bad match cmd ~p~n", [_Cmd]),
    ok.
