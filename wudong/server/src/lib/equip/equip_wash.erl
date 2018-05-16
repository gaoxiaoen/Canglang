%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备强化
%%% @end
%%% Created : 17. 一月 2015 14:52
%%%-------------------------------------------------------------------
-module(equip_wash).
-include("goods.hrl").
-include("server.hrl").
-include("common.hrl").
-include("equip.hrl").
-include("error_code.hrl").
-include("new_shop.hrl").
%% API
-export([
    equip_wash/4,  %%装备洗练,
    equip_wash_restore/2,
    transfer/3,
    get_wash_attr_color_total/1,
    check_wash_state/0,
    cron_equip_wash/9,
    equip_wash_restore_init/1,
    equip_wash_restore_save/1,
    upgrade_plv/1
]).

-export([timer_update/0, logout/0]).
-export([cmd_test/1]).

cmd_test(Times) ->
    RatioList = [{1, 6799}, {2, 3000}, {3, 170}, {4, 30}, {5, 1}],
    case util:list_rand_ratio(RatioList) of
        5 ->
            Times;
        _ -> cmd_test(Times + 1)
    end.

%%定时更新
timer_update() ->
    StEquipWash = lib_dict:get(?PROC_STATUS_WASH),
    if StEquipWash#st_equip_wash.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_WASH, StEquipWash#st_equip_wash{is_change = 0}),
        goods_load:db_replace_wash_info(StEquipWash#st_equip_wash.pkey, StEquipWash#st_equip_wash.wash, StEquipWash#st_equip_wash.wash_attr),
        ok;
        true -> ok
    end.

logout() ->
    StEquipWash = lib_dict:get(?PROC_STATUS_WASH),
    if StEquipWash#st_equip_wash.is_change == 1 ->
        goods_load:db_replace_wash_info(StEquipWash#st_equip_wash.pkey, StEquipWash#st_equip_wash.wash, StEquipWash#st_equip_wash.wash_attr),
        ok;
        true -> ok
    end.

equip_wash_restore_save(_Player) ->
    ok.

equip_wash_restore_init(_Player) ->
    put(equip_wash_restore, []).



cost_goods(Player, AutoBuy, NeedLuckNum) ->
    [GoodsId, Num, LockId] = data_wash_consume:get(Player#player.lv),
    StoneNum = goods_util:get_goods_count(GoodsId),
    LockNnm = goods_util:get_goods_count(LockId),
    if StoneNum >= Num andalso LockNnm >= NeedLuckNum ->
        %%洗练石和锁全部够
        goods:subtract_good_throw(Player, [{GoodsId, Num}, {LockId, NeedLuckNum}], 22),
        Player;
        AutoBuy == 1 ->
            %%洗练锁不足
            if StoneNum >= Num andalso LockNnm < NeedLuckNum ->
                BuyNeed = NeedLuckNum - LockNnm,
                case new_shop:auto_buy(Player, LockId, BuyNeed, 22) of
                    {ok, NewPlayer, _} ->
                        goods:subtract_good_throw(Player, [{GoodsId, Num}, {LockId, LockNnm}], 22),
                        NewPlayer;
                    {false, 1} -> throw({false, 39});
                    _ -> throw({false, 15})
                end;
            %%试炼石不足
                StoneNum < Num andalso LockNnm >= NeedLuckNum ->
                    BuyNeed = Num - StoneNum,
                    case new_shop:auto_buy(Player, GoodsId, BuyNeed, 22) of
                        {ok, NewPlayer, _} ->
                            goods:subtract_good_throw(Player, [{GoodsId, StoneNum}, {LockId, NeedLuckNum}], 22),
                            NewPlayer;
                        {false, 1} -> throw({false, 39});
                        _ -> throw({false, 15})
                    end;
                true ->
                    %%洗练石和锁全部不足
                    case new_shop:get_goods_price(GoodsId) of
                        false -> throw({false, 39});
                        {ok, Type, Price} ->
                            case new_shop:get_goods_price(LockId) of
                                false -> throw({false, 39});
                                {ok, Type1, Price1} ->
                                    BuyStone = Num - StoneNum,
                                    BuyLock = NeedLuckNum - LockNnm,
                                    case money:is_enough_list(Player, [{Type, Price * BuyStone}, {Type1, Price1 * BuyLock}]) of
                                        false -> throw({false, 15});
                                        true ->
                                            Player1 = money:cost_money(Player, Type, Price * BuyStone, 22, GoodsId, BuyStone),
                                            Player2 = money:cost_money(Player1, Type1, Price1 * BuyLock, 22, LockId, BuyLock),
                                            goods:subtract_good_throw(Player, [{GoodsId, StoneNum}, {LockId, LockNnm}], 22),
                                            Player2
                                    end
                            end
                    end
            end;
        true ->
            %%材料不足,没有开启自动购买
            ?IF_ELSE(StoneNum < Num, goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 22), goods_util:client_popup_goods_not_enough(Player, LockId, NeedLuckNum, 22)),
            throw({false, 3})
    end.


%%    [HaveGold, HaveBgold] = money:get_gold(Player#player.key),
%%    LockGold = data_new_shop:get_by_goods_id(LockId),
%%    StoneGold = data_new_shop:get_by_goods_id(GoodsId),
%%    if
%%        LockNnm < NeedLuckNum andalso AutoBuy == 0 -> %%需要使用锁，且没有勾选自动购买
%%            NeedGold = 999999999,
%%            NeedBindGold = 999999999,
%%            NeedGoods = [],
%%            goods_util:client_popup_goods_not_enough(Player, LockId, NeedLuckNum, 22),
%%            throw({false, 3});
%%        StoneNum < Num andalso AutoBuy == 0 -> %%需要使用洗练石头，且没有勾选自动购买
%%            NeedGold = 999999999,
%%            NeedBindGold = 999999999,
%%            NeedGoods = [],
%%            goods_util:client_popup_goods_not_enough(Player, GoodsId, Num, 22),
%%            throw({false, 3});
%%        StoneNum < Num andalso LockNnm < NeedLuckNum ->  %%石头，洗练锁，都不够，全部自动购买
%%            NeedGoods = [{GoodsId, StoneNum}, {LockId, LockNnm}],
%%            NeedGold = LockGold#base_shop.gold * (NeedLuckNum - LockNnm),
%%            NeedBindGold = StoneGold#base_shop.bgold * (Num - StoneNum);
%%        StoneNum < Num ->                                %%石头不够
%%            NeedGoods = [{GoodsId, StoneNum}, {LockId, NeedLuckNum}],
%%            NeedGold = 0,
%%            NeedBindGold = StoneGold#base_shop.bgold * (Num - StoneNum);
%%        LockNnm < NeedLuckNum ->         %%锁不够
%%            NeedGoods = [{GoodsId, Num}, {GoodsId, LockNnm}],
%%            NeedBindGold = 0,
%%            NeedGold = LockGold#base_shop.gold * (NeedLuckNum - LockNnm);
%%        true -> %%全部都足够
%%            NeedGold = 0,
%%            NeedBindGold = 0,
%%            NeedGoods = [{GoodsId, Num}, {LockId, NeedLuckNum}]
%%    end,
%%    if
%%        HaveGold < NeedGold orelse (HaveGold >= NeedGold andalso HaveGold - NeedGold + HaveBgold < NeedBindGold) ->
%%            NewPlayer = Player,
%%            throw({false, 15});
%%        NeedGold > 0 orelse NeedBindGold > 0 ->
%%            Player1 = ?IF_ELSE(NeedGold > 0, money:add_no_bind_gold(Player, -NeedGold, 22), Player),
%%            NewPlayer = ?IF_ELSE(NeedBindGold > 0, money:add_gold(Player, -NeedBindGold, 22), Player1);
%%        true ->
%%            NewPlayer = Player
%%    end,
%%    goods:subtract_good_throw(Player, NeedGoods, 22),
%%    NewPlayer.

%%获取属性权值
random_wash_attr(List) ->
    F = fun({Type, _}, L) ->
        case lists:keytake(Type, 1, L) of
            false -> [{Type, 1} | L];
            {value, {_, Count}, T} ->
                [{Type, Count + 1} | T]
        end
        end,
    AttrCountList = lists:foldl(F, [], List),
    F1 = fun(AttrType) ->
        [Ratio, RatioRepeat] = data_wash_ratio:get(AttrType),
        Times =
            case lists:keyfind(AttrType, 1, AttrCountList) of
                false -> 0;
                {_, Val} -> Val
            end,
        {AttrType, max(0, (Ratio - RatioRepeat * Times))}
         end,
    RatioList = lists:map(F1, data_wash_ratio:type_list()),
    util:list_rand_ratio(RatioList).


%%玩家升级
upgrade_plv(Plv) ->
    StWash = lib_dict:get(?PROC_STATUS_WASH),
    NewLvArea = data_wash_uplv:get(Plv),
    F = fun({Subtype, Lv, Area, WashTimes, LvTimes}) ->
        if Plv == Lv -> {Subtype, Lv, Area, WashTimes, LvTimes};
            true ->
                OldLvArea = data_wash_uplv:get(Lv),
                if NewLvArea == OldLvArea ->
                    {Subtype, Lv, Area, WashTimes, LvTimes};
                    true ->
                        NewArea = data_wash_area:last_area(LvTimes),
                        {Subtype, Plv, NewArea, 0, 0}
                end
        end
        end,
    Wash = lists:map(F, StWash#st_equip_wash.wash),

    NewStWash = StWash#st_equip_wash{wash = Wash, is_change = 1},
    lib_dict:put(?PROC_STATUS_WASH, NewStWash),
    ok.

%%更新洗练区间
update_wash_area(StWash, SubType) ->
    Wash =
        case lists:keytake(SubType, 1, StWash#st_equip_wash.wash) of
            false -> StWash#st_equip_wash.wash;
            {value, {_, Plv, Area, _WashTimes, LvTimes}, T} ->
                NewArea = ?IF_ELSE(Area == 1, 1, Area - 1),
                [{SubType, Plv, NewArea, 0, LvTimes + 1} | T]
        end,
    lib_dict:put(?PROC_STATUS_WASH, StWash#st_equip_wash{wash = Wash, is_change = 1}),
    ok.

%%更新洗练次数
update_wash_times(StWash, SubType, Plv) ->
    Wash =
        case lists:keytake(SubType, 1, StWash#st_equip_wash.wash) of
            false -> [{SubType, Plv, 1, 1, 1} | StWash#st_equip_wash.wash];
            {value, {_, _, Area, WashTimes, LvTimes}, T} ->
                AreaTimes = data_wash_area:area_times(Area),
                {NewArea, NewWashTimes} =
                    case (WashTimes + 1) rem AreaTimes of
                        0 ->
                            case lists:member(Area + 1, data_wash_area:area_list()) of
                                true ->
                                    {Area + 1, 0};
                                false -> {Area, 0}
                            end;
                        _ ->
                            {Area, WashTimes + 1}
                    end,
                [{SubType, Plv, NewArea, NewWashTimes, LvTimes + 1} | T]
        end,
    lib_dict:put(?PROC_STATUS_WASH, StWash#st_equip_wash{wash = Wash, is_change = 1}).

random_attr_color(WashArea) ->
    ColorList = data_wash_area:color_ratio(WashArea),
    case util:list_rand_ratio(ColorList) of
        0 -> 1;
        C -> C
    end.

check_lock_state(WashAttr, LockList) ->
    Len = length(WashAttr),
    F = fun(Pos) ->
        Pos =< Len
        end,
    lists:all(F, LockList).


%%装备洗练
equip_wash(AutoBuy, Player, GoodsKey, LockList) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    WashCell = data_wash_num:get(Player#player.lv),
    ?ASSERT(WashCell > 0, {false, 38}),
    ?ASSERT(check_lock_state(Goods#goods.wash_attr, LockList), {false, 0}),
    NewPlayer = cost_goods(Player, AutoBuy, length(LockList)),
    %%
    FilterLockList =
        case Goods#goods.wash_attr of
            [] -> [];
            _ ->
                lists:map(fun(Pos) -> {Pos, lists:nth(Pos, Goods#goods.wash_attr)} end, LockList)
        end,
    StWash = lib_dict:get(?PROC_STATUS_WASH),
    WashArea =
        case lists:keyfind(GoodsType#goods_type.subtype, 1, StWash#st_equip_wash.wash) of
            false -> 1;
            {_, _, Val, _WashTimes, _LvTimes} ->
                Val
        end,
    Fun = fun(Cell, {List, IsRed}) ->
        case lists:keyfind(Cell, 1, FilterLockList) of
            false ->
                AttrType = random_wash_attr(List),
                Color = random_attr_color(WashArea),
                [AttrValMin, AttrValMax] = data_wash_attr:get_attr(Player#player.lv, AttrType, Color),
                {[{AttrType, util:rand(AttrValMin, AttrValMax)} | List],
                    ?IF_ELSE(Color == 5, true, IsRed)};
            {_, AttrVal} ->
                {[AttrVal | List], IsRed}
        end
          end,
    {NewWashList, IsRedColor} = lists:foldr(Fun, {[], false}, lists:seq(1, WashCell)),
    WashAttrList =
        case lists:keytake(GoodsType#goods_type.subtype, 1, StWash#st_equip_wash.wash_attr) of
            false ->
                [{GoodsType#goods_type.subtype, NewWashList} | StWash#st_equip_wash.wash_attr];
            {value, _, T} ->
                [{GoodsType#goods_type.subtype, NewWashList} | T]
        end,
    NewStWash = StWash#st_equip_wash{wash_attr = WashAttrList},
    ?IF_ELSE(IsRedColor, update_wash_area(NewStWash, GoodsType#goods_type.subtype), update_wash_times(NewStWash, GoodsType#goods_type.subtype, Player#player.lv)),
%%    case lists:keytake(GoodsType#goods_type.subtype, 1, get(equip_wash_restore)) of
%%        false ->
%%            put(equip_wash_restore, [{GoodsType#goods_type.subtype, NewWashList} | get(equip_wash_restore)]);
%%        {value, _, L1} ->
%%            put(equip_wash_restore, [{GoodsType#goods_type.subtype, NewWashList} | L1])
%%    end,

    cron_equip_wash(Player#player.key, Player#player.nickname, 1, Goods#goods.key, Goods#goods.goods_id, Goods#goods.wash_attr, NewWashList, LockList, util:unixtime()),
    self() ! {d_v_trigger, 4, []},
    {ok, NewPlayer, [[attribute_util:attr_tans_client(K), V] || {K, V} <- NewWashList], Goods}.


equip_wash_restore(Player, GoodsKey) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    StWash = lib_dict:get(?PROC_STATUS_WASH),
    case lists:keytake(GoodsType#goods_type.subtype, 1, StWash#st_equip_wash.wash_attr) of
        false ->
            throw({false, 0});
        {value, {_, WashAttr}, L1} ->
            Goods = goods_util:get_goods(GoodsKey),
            NewGoods0 = Goods#goods{wash_attr = WashAttr},
            NewGoods = equip_attr:equip_combat_power(NewGoods0),
            GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
            GoodsSt2 = goods_dict:update_goods(NewGoods, GoodsSt),
            NewGoodsSt = equip_attr:equip_change_recalc_attribute(GoodsSt2, NewGoods),
            lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
            goods_load:dbup_wash_attrs(NewGoods),
            goods_pack:pack_send_goods_info([NewGoods], GoodsSt#st_goods.sid),
            NewPlayer = player_util:count_player_attribute(Player, true),
            cron_equip_wash(Player#player.key, Player#player.nickname, 2, Goods#goods.key, Goods#goods.goods_id, Goods#goods.wash_attr, WashAttr, [], util:unixtime()),
            NewStWash = StWash#st_equip_wash{wash_attr = L1, is_change = 1},
            lib_dict:put(?PROC_STATUS_WASH, NewStWash),
            self() ! {d_v_trigger, 4, []},
            {ok, NewPlayer}
    end.

transfer(Player, GoodsKey1, GoodsKey2) ->
    Goods1 = goods_util:get_goods(GoodsKey1),
    Goods2 = goods_util:get_goods(GoodsKey2),
    NewGoods1 = Goods1#goods{stren = Goods2#goods.stren,
        wash_attr = Goods2#goods.wash_attr,
        gemstone_groove = Goods2#goods.gemstone_groove},
    NewGoods2 = Goods2#goods{
        stren = Goods1#goods.stren,
        wash_attr = Goods1#goods.wash_attr,
        gemstone_groove = Goods1#goods.gemstone_groove},
    goods_load:dbup_goods(NewGoods1),
    goods_load:dbup_goods(NewGoods2),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    NewGoodsSt = goods_dict:update_goods([NewGoods1, NewGoods2], GoodsSt),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
    goods_pack:pack_send_goods_info([NewGoods1, NewGoods2], GoodsSt#st_goods.sid),

    self() ! {d_v_trigger, 4, []},
    {ok, Player}.

%%获取装备洗练属性颜色总和
get_wash_attr_color_total(Plv) ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
%%    ColorFun =
%%        fun(_GoodsId, Key, Val) ->
%%            data_wash_colour:get(Plv, Key, Val)
%%        end,
    F = fun(Goods) ->
        lists:sum([data_wash_colour:get(Plv, Key, Val) || {Key, Val} <- Goods#goods.wash_attr])
        end,
    lists:sum(lists:map(F, GoodsList)).

%%检查是否有装备可洗练
check_wash_state() ->
    case goods_util:get_goods_list_by_type_list(?GOODS_LOCATION_BAG, [?GOODS_TYPE_EQUIP]) of
        [] -> 0;
        GoodsList ->
            F = fun(Goods) ->
                case data_goods:get(Goods#goods.goods_id) of
                    [] -> 0;
                    GoodsTypeInfo ->
                        if GoodsTypeInfo#goods_type.color == 2 ->
                            1;
                            true -> 0
                        end
                end
                end,
            %%蓝色装备5件以上
            case lists:sum(lists:map(F, GoodsList)) >= 1 of
                true -> 1;
                false -> 0
            end
    end.

cron_equip_wash(Pkey, Nickname, Type, Gkey, Goods_id, Befor_attr, After_attr, LockPos, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_wash set pkey = ~p,nickname = '~s',type = ~p,gkey= ~p,goods_id =~p,
			befor_attr ='~s',after_attr ='~s',lock_pos = '~s',time=~p">>,
        [Pkey, Nickname, Type, Gkey, Goods_id, util:term_to_bitstring(Befor_attr), util:term_to_bitstring(After_attr), util:term_to_bitstring(LockPos), Time]),
    log_proc:log(Sql),
    ok.