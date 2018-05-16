%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. 一月 2015 下午3:55
%%%-------------------------------------------------------------------
-module(goods_init).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("goods.hrl").
%% API
-export([init/1, equip_init/1, upgrade_bag_cell/1]).
-export([bag_left_cell_num/2, warehouse_left_cell_num/2, fuwen_left_cell_num/2, xian_left_cell_num/2, fairy_soul_left_cell_num/2, god_soul_left_cell_num/2]).

init(Player) ->
    gem_init(Player),
    [MaxCell, WareHouseMaxCell, MaxFuwenCell, MaxXianCell, MaxGodSoulCell, MaxFairySoulCell] = goods_load:load_player_bag_info(Player),
    GoodsDict = goods_dict_init(Player),
    {EquipAttribute, WearedEquipList} = equip_init(GoodsDict),
    {FuwenAttribute, WearedFuwenList} = fuwen_init(GoodsDict),
    {XianAttribute, WearedXianList} = xian_init(GoodsDict),
    WearedGodSoulList = god_soul_init(GoodsDict),
    {FairySoulAttribute, WearedFairySoulList} = fairy_soul_init(GoodsDict),
    LeftoverCellNum = bag_left_cell_num(MaxCell, GoodsDict),
    WareHouse_leftover_cell_num = warehouse_left_cell_num(WareHouseMaxCell, GoodsDict),
    LeftFuwenCellNum = fuwen_left_cell_num(MaxFuwenCell, GoodsDict),
    LeftXianCellNum = xian_left_cell_num(MaxXianCell, GoodsDict),
    LeftFairySoulCellNum = fairy_soul_left_cell_num(MaxFairySoulCell, GoodsDict),
    LeftGodSoulCellNum = god_soul_left_cell_num(MaxGodSoulCell, GoodsDict),
    GoodsStatus = #st_goods{
        key = Player#player.key,
        sid = Player#player.sid,
        weared_equip = WearedEquipList,
        equip_attribute = EquipAttribute,
        max_cell = MaxCell,
        leftover_cell_num = LeftoverCellNum,
        dict = GoodsDict,
        warehouse_max_cell = WareHouseMaxCell,
        warehouse_leftover_cell_num = WareHouse_leftover_cell_num,
        weared_fuwen = WearedFuwenList,
        fuwen_attribute = FuwenAttribute,
        weared_xian = WearedXianList,
        xian_attribute = XianAttribute,
        weared_god_soul = WearedGodSoulList,
        weared_fairy_soul = WearedFairySoulList,
        fairy_soul_attribute = FairySoulAttribute,
        leftfuwen_cell_num = LeftFuwenCellNum,
        maxfuwen_cell_num = MaxFuwenCell,
        leftxian_cell_num = LeftXianCellNum,
        maxxian_cell_num = MaxXianCell,
        leftgod_soul_cell_num = LeftGodSoulCellNum,
        maxgod_soul_cell_num = MaxGodSoulCell,
        left_fairy_soul_cell_num = LeftFairySoulCellNum,
        max_fairy_cell_num = MaxFairySoulCell
    },
    lib_dict:put(?PROC_STATUS_GOODS, GoodsStatus),
    goods_warehouse:lv_up(Player, false),
    Player1 = equip_figure_init(Player, WearedEquipList),
    %%这个保存起来用于其他玩家查看信息
    Player2 = Player1#player{weared_equip = equip:equip_attr_view(), baby_equip = baby:baby_equip_attr_view()},
    equip_attr:equip_suit_calc(Player2).

goods_dict_init(Player) ->
    case player_util:is_new_role(Player) of
        false ->
            GoodsList = goods_load:load_player_goods(Player#player.key, "goods"),
            PlayerGoodsList = goods_info_init(GoodsList),
            %%修复装备问题
            PlayerGoodsList1 = fix_equip_list(PlayerGoodsList),
            NewPlayerGoodsList = equip_refine:add_goods_refine(PlayerGoodsList1), %% 添加装备精炼属性
            NewPlayerGoodsList1 = equip_magic:add_goods_magic(NewPlayerGoodsList), %% 添加装备附魔属性
            NewPlayerGoodsList2 = equip_soul:add_goods_soul(Player#player.vip_lv, NewPlayerGoodsList1), %% 添加装备武魂属性
            goods_dict:update_goods(NewPlayerGoodsList2, dict:new());
        _ ->
            dict:new()
    end.

equip_init(GoodsDict) ->
    EquipDict =
        dict:filter(fun(_Key, [Goods]) ->
            Goods#goods.location =:= ?GOODS_LOCATION_BODY
                    end, GoodsDict),
    EquipList = goods_dict:dict_to_list(EquipDict),
    WearedEquipList = [
        begin
            EquipAttribute = equip_attr:calc_singleton_equip_attribute(Goods),
            #weared_equip{
                pos = Goods#goods.cell,
                goods_key = Goods#goods.key,
                goods_id = Goods#goods.goods_id,
                equip_attribute = EquipAttribute
            }
        end
        || Goods <- EquipList],
    SumWearedEquipList = attribute_util:sum_attribute([EquipAttribute#weared_equip.equip_attribute || EquipAttribute <- WearedEquipList]),
    {SumWearedEquipList, WearedEquipList}.

fix_equip_list(PlayerGoodsList) ->
    %%修复装备问题
    F = fun(Goods, {L1, L2}) ->
        if Goods#goods.location == ?GOODS_LOCATION_BODY ->
            {L1, [Goods | L2]};
            true ->
                {[Goods | L1], L2}
        end
        end,
    {PlayerGoodsList1, EquipList} = lists:foldl(F, {[], []}, PlayerGoodsList),
    F1 = fun(Goods) ->
        if Goods#goods.goods_id == 2201001 andalso Goods#goods.star == 3 ->
            NewGoods = Goods#goods{goods_id = 2201003},
            goods_load:dbup_goods_id(NewGoods),
            NewGoods;
            Goods#goods.goods_id == 2201003 andalso Goods#goods.star /= 3 ->
                GoodsId =
                    case Goods#goods.star of
                        4 -> 2201004;
                        5 -> 2201005;
                        _ -> Goods#goods.goods_id
                    end,
                NewGoods = Goods#goods{goods_id = GoodsId},
                goods_load:dbup_goods_id(NewGoods),
                NewGoods;

            true ->
                GoodsTypeInfo = data_goods:get(Goods#goods.goods_id),
                Goods#goods{star = GoodsTypeInfo#goods_type.star}
        end
         end,
    L = lists:map(F1, EquipList),
    NewEquipList = fix_pos_repeat([1, 2, 3, 4, 5, 6, 7, 130], L),
    PlayerGoodsList1 ++ NewEquipList.


fix_pos_repeat([], EquipList) ->
    EquipList;
fix_pos_repeat([Cell | CellList], EquipList) ->
    NewEquipList =
        case [E || E <- EquipList, E#goods.cell == Cell] of
            [] -> EquipList;
            List ->
                case length(List) of
                    1 -> EquipList;
                    _ ->
                        GoodsId = lists:max([G#goods.goods_id || G <- List]),
                        F = fun(Equip, L) ->
                            case lists:keytake(Equip#goods.key, #goods.key, L) of
                                false -> L;
                                {value, _, T} ->
                                    if Equip#goods.goods_id =/= GoodsId ->
                                        NewEquip = Equip#goods{location = ?GOODS_LOCATION_BAG, cell = 0},
                                        goods_load:dbup_goods_cell_location(NewEquip),
                                        [NewEquip | T];
                                        true ->
                                            [Equip | T]
                                    end
                            end
                            end,
                        lists:foldl(F, EquipList, List)
                end
        end,
    fix_pos_repeat(CellList, NewEquipList).

xian_init(GoodsDict) ->
    XianDict =
        dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_BODY_XIAN end, GoodsDict),
    XianList = goods_dict:dict_to_list(XianDict),
    F = fun(Goods) ->
        XianAttribute = xian_attr:calc_singleton_xian_attribute(Goods),
        #weared_xian{
            pos = Goods#goods.cell,
            goods_key = Goods#goods.key,
            goods_id = Goods#goods.goods_id,
            xian_attribute = XianAttribute
        }
        end,
    WearedXianList = lists:map(F, XianList),
    SumWearedXianList = attribute_util:sum_attribute([XianAttribute#weared_xian.xian_attribute || XianAttribute <- WearedXianList]),
    {SumWearedXianList, WearedXianList}.

god_soul_init(GoodsDict) ->
    GodSoulDict =
        dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_BODY_GOD_SOUL end, GoodsDict),
    GodSoulList = goods_dict:dict_to_list(GodSoulDict),
    F = fun(Goods) ->
        GodSoulAttribute = godness_attr:calc_singleton_god_soul_attribute(Goods),
        #weared_god_soul{
            pos = Goods#goods.cell,
            goods_key = Goods#goods.key,
            goods_id = Goods#goods.goods_id,
            god_soul_attribute = GodSoulAttribute,
            wear_key = Goods#goods.wear_key
        }
        end,
    WearedGodSoulList = lists:map(F, GodSoulList),
    WearedGodSoulList.

fuwen_init(GoodsDict) ->
    FuwenDict =
        dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_BODY_FUWEN end, GoodsDict),
    FuwenList = goods_dict:dict_to_list(FuwenDict),
    F = fun(Goods) ->
        FuwenAttribute = fuwen_attr:calc_singleton_fuwen_attribute(Goods),
        #weared_fuwen{
            pos = Goods#goods.cell,
            goods_key = Goods#goods.key,
            goods_id = Goods#goods.goods_id,
            fuwen_attribute = FuwenAttribute
        }
        end,
    WearedFuwenList = lists:map(F, FuwenList),
    SumWearedFuwenList = attribute_util:sum_attribute([FuwenAttribute#weared_fuwen.fuwen_attribute || FuwenAttribute <- WearedFuwenList]),
    {SumWearedFuwenList, WearedFuwenList}.

fairy_soul_init(GoodsDict) ->
    FairySoulDict =
        dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_BODY_FAIRY_SOUL end, GoodsDict),
    FairySoulList = goods_dict:dict_to_list(FairySoulDict),
    F = fun(Goods) ->
        FairySoulAttribute = fairy_soul_attr:fairy_soul_change_recalc_attribute(Goods),
        #weared_fairy_soul{
            pos = Goods#goods.cell,
            goods_key = Goods#goods.key,
            goods_id = Goods#goods.goods_id,
            fairy_soul_attribute = FairySoulAttribute
        }
        end,
    WearedFairySoulList = lists:map(F, FairySoulList),
    SumWearedFairySoulList = attribute_util:sum_attribute([FairySoulAttribute#weared_fairy_soul.fairy_soul_attribute || FairySoulAttribute <- WearedFairySoulList]),
    {SumWearedFairySoulList, WearedFairySoulList}.

equip_figure_init(Player, WearedEquipList) ->
    case lists:keyfind(?GOODS_SUBTYPE_WEAPON, #weared_equip.pos, WearedEquipList) of
        false ->
            WeaponId = 0;
        WearedEquip ->
            WeaponId = WearedEquip#weared_equip.goods_id
    end,
    case lists:keyfind(?GOODS_SUBTYPE_GLOVE, #weared_equip.pos, WearedEquipList) of
        false ->
            Cloth = 0;
        ClothEquip ->
            Cloth = ClothEquip#weared_equip.goods_id
    end,
    Player#player{equip_figure = #equip_figure{weapon_id = WeaponId, clothing_id = Cloth}}.

%%left_cell_num(MaxCell, GoodsDict) ->
%%    BagGoodsDict = dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =/= ?GOODS_LOCATION_BODY end, GoodsDict),
%%    AlreadyUsedCellNum = dict:size(BagGoodsDict),
%%    MaxCell - AlreadyUsedCellNum.

warehouse_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_WHOUSE end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

fuwen_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_FUWEN end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

xian_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_XIAN end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

god_soul_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) -> Goods#goods.location =:= ?GOODS_LOCATION_GOD_SOUL end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

fairy_soul_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) ->
        Goods#goods.location =:= ?GOODS_LOCATION_FAIRY_SOUL end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

bag_left_cell_num(MaxCell, GoodsDict) ->
    BagGoodsDict = dict:filter(fun(_Key, [Goods]) ->
        if Goods#goods.location =:= ?GOODS_LOCATION_BAG ->
            case data_goods:get(Goods#goods.goods_id) of
                GoodsTypeInfo when is_record(GoodsTypeInfo, goods_type) andalso GoodsTypeInfo#goods_type.type =:= 3 ->
                    false;
                _ ->
                    true
            end;
            true -> false
        end
                               end, GoodsDict),
    AlreadyUsedCellNum = dict:size(BagGoodsDict),
    MaxCell - AlreadyUsedCellNum.

goods_info_init(GoodsList) ->
    goods_info_init(util:unixtime(), GoodsList, []).

goods_info_init(_Now, [], GoodsList) ->
    GoodsList;

%%物品过期
%%goods_info_init(Now, [[_Gkey, Pkey, GoodsId, _Location, _Cell, Num, _Bind, Expiretime | _] | Tail], GoodsList) when Expiretime =/= 0 andalso Expiretime =< Now ->
%%    case data_goods:get(GoodsId) of
%%        [] ->
%%            ?ERR("goods_info_init goods ~p udef~n", [GoodsId]),
%%            goods_info_init(Now, Tail, GoodsList);
%%        _ ->
%%            Msg = io_lib:format(?T("您的物品~s*~p过期,系统删除,祝您游戏愉快!"), [goods_util:get_goods_name(GoodsId), Num]),
%%            spawn(fun() ->
%%                goods_load:dbdel_goods_by_gkey(_Gkey),
%%                util:sleep(3000),
%%                mail:sys_send_mail([Pkey], ?T("物品过期"), Msg)
%%                  end),
%%            goods_info_init(Now, Tail, GoodsList)
%%    end;

goods_info_init(Now, [[Gkey, Pkey, GoodsId, Location, Cell, Num, Bind, Expiretime, GoodsLv, Star, Stren, Color, WearKey, Wash_luck_value, WashAttrs, XianWashAttrs, GemstoneGroove, TotalAttrs, CombatPower, RefineAttr, Exp, GodForging, Lock, FixAttrs, RandomAttrs, Sex, Level] | Tail], GoodsList) ->
    case data_goods:get(GoodsId) of
        [] ->
            ?ERR("goods_info_init goods ~p udef~n", [GoodsId]),
            goods_info_init(Now, Tail, GoodsList);
        #goods_type{attr_list = AttrList, type = Type} ->
            GemstoneGrooveList = util:bitstring_to_term(GemstoneGroove),
            WashAttrsList = util:bitstring_to_term(WashAttrs),
            XianWashAttrsList = util:bitstring_to_term(XianWashAttrs),
            TotalAttrsList = util:bitstring_to_term(TotalAttrs),
            RefineAttrList = util:bitstring_to_term(RefineAttr),
            FixAttrsList = util:bitstring_to_term(FixAttrs),
            RandomAttrsList = util:bitstring_to_term(RandomAttrs),
            GodSoulAttrsList = godness_attr:calc_singleton_god_soul_attribute(Type, AttrList, GoodsLv, Color),
            Goods = #goods{key = Gkey, pkey = Pkey, goods_id = GoodsId, location = Location, cell = Cell, num = Num,
                bind = Bind, expire_time = Expiretime, goods_lv = GoodsLv, star = Star, stren = Stren, color = Color, wash_luck_value = Wash_luck_value, gemstone_groove = GemstoneGrooveList,
                total_attrs = TotalAttrsList, wash_attr = WashAttrsList, xian_wash_attr = XianWashAttrsList, god_soul_attr = GodSoulAttrsList, combat_power = CombatPower, refine_attr = RefineAttrList, exp = Exp, god_forging = GodForging, lock = Lock,
                fix_attrs = FixAttrsList, random_attrs = RandomAttrsList, sex = Sex, wear_key = WearKey, level = Level
            },
            goods_info_init(Now, Tail, [Goods | GoodsList])
    end.

gem_init(Player) ->
%%    lib_dict:put(?PROC_STATUS_GEM_EXP, goods_load:get_gem_exp(Player)),
    lib_dict:put(?PROC_STATUS_EQUIP_STRENTH, goods_load:get_str_exp(Player)),
    lib_dict:put(?PROC_STATUS_WASH, goods_load:db_equip_wash_info(Player)),
    lib_dict:put(?PROC_STATUS_EQUIP_REFINE, goods_load:get_refine_info(Player)),
    lib_dict:put(?PROC_STATUS_EQUIP_MAGIC, goods_load:get_magic_info(Player)),
    lib_dict:put(?PROC_STATUS_EQUIP_SOUL, goods_load:get_soul_info(Player)),
    ok.

%%玩家等级提升,开放背包格子
upgrade_bag_cell(Player) ->
    StGoods = lib_dict:get(?PROC_STATUS_GOODS),
    MaxCell = max(data_bag_cell:get(Player#player.lv), StGoods#st_goods.max_cell),
    if MaxCell == StGoods#st_goods.max_cell -> skip;
        true ->
            LeftoverCellNum = bag_left_cell_num(MaxCell, StGoods#st_goods.dict),
            NewStGoods = StGoods#st_goods{max_cell = MaxCell, leftover_cell_num = LeftoverCellNum},
            lib_dict:put(?PROC_STATUS_GOODS, NewStGoods),
            goods_load:dbup_bag_cell_num(NewStGoods),
            {ok, Bin} = pt_150:write(15008, {MaxCell}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end.
