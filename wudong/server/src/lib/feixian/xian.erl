%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 仙装
%%% @end
%%% Created : 11. 十月 2017 15:47
%%%-------------------------------------------------------------------
-module(xian).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("xian.hrl").
-include("goods.hrl").

%% API
-export([
    put_on/3 %% 穿戴仙装
    , resolved_xian/2 %%分解
    , upgrade/4 %% 升级
    , one_key_upgrade/2 %% 一键升级
    , gold_one_key_upgrade/2
    , swap_attr/5 %% 仙练属性交换
]).

%% 内部接口
-export([
    get_xian_lian/1
]).

check_put_on(XianZhuang, _WearXianList) ->
    GoodsTypeInfo = data_goods:get(XianZhuang#goods.goods_id),
    if
        GoodsTypeInfo#goods_type.type /= ?GOODS_TYPE_XIAN -> {false, 2}; %% 非仙装
        XianZhuang#goods.cell > 0 -> {false, 3}; %% 该仙装已经配戴
        true ->
            true
    end.

%% 卸下
put_on(Player, GoodsKey, 0) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        XianZhuang ->
            if
                XianZhuang#goods.cell < 1 ->
                    {0, Player};
                true ->
                    NewXianZhuang = XianZhuang#goods{
                        cell = 0,
                        location = ?GOODS_LOCATION_XIAN
                    },
                    goods_load:dbup_goods_cell_location(NewXianZhuang),
                    GoodsSt1 = goods_dict:update_goods([NewXianZhuang], GoodsSt),
                    goods_pack:pack_send_goods_info([NewXianZhuang], GoodsSt#st_goods.sid),
                    NewGoodsSt = xian_attr:off_xian_change_recalc_attribute(GoodsSt1, XianZhuang#goods.cell),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    xian_log:put_on_log(Player#player.key, #goods{key = 0}, NewXianZhuang),
                    {1, NewPlayer}
            end
    end;

%% 穿上和替换
put_on(Player, GoodsKey, 1) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player}; %% 系统物品不存在
        XianZhuang ->
            case check_put_on(XianZhuang, GoodsSt#st_goods.weared_xian) of
                {false, Code} ->
                    {Code, Player};
                true ->
                    GoodsType = data_goods:get(XianZhuang#goods.goods_id),
                    Pos = get_pos(GoodsType#goods_type.subtype),
                    F = fun(#weared_xian{pos = Pos0} = WearXian) ->
                        ?IF_ELSE(Pos0 == Pos, [WearXian], [])
                    end,
                    case lists:flatmap(F, GoodsSt#st_goods.weared_xian) of
                        [] -> %% 新穿上仙装
                            NewXianZhuang = XianZhuang#goods{
                                cell = Pos,
                                location = ?GOODS_LOCATION_BODY_XIAN
                            },
                            goods_load:dbup_goods_cell_location(NewXianZhuang),
                            NewGoodsDict = goods_dict:update_goods(NewXianZhuang, GoodsSt#st_goods.dict),
                            goods_pack:pack_send_goods_info([NewXianZhuang], GoodsSt#st_goods.sid),
                            xian_log:put_on_log(Player#player.key, NewXianZhuang, #goods{}),
                            GoodsSt1 = GoodsSt#st_goods{
                                leftxian_cell_num = GoodsSt#st_goods.leftxian_cell_num + 1,
                                dict = NewGoodsDict
                            };
                        [OldWearedXianZhang] -> %% 替换旧的仙装
                            OldXianZhang = goods_util:get_goods(OldWearedXianZhang#weared_xian.goods_key, GoodsSt#st_goods.dict),
                            OldXianZhuang2 = OldXianZhang#goods{
                                cell = 0,
                                location = ?GOODS_LOCATION_XIAN
                            },
                            goods_load:dbup_goods_cell_location(OldXianZhuang2),
                            NewXianZhuang = XianZhuang#goods{
                                cell = Pos,
                                location = ?GOODS_LOCATION_BODY_XIAN
                            },
                            GoodsSt1 = goods_dict:update_goods([OldXianZhuang2, NewXianZhuang], GoodsSt),
                            goods_load:dbup_goods_cell_location(NewXianZhuang),
                            goods_pack:pack_send_goods_info([OldXianZhuang2, NewXianZhuang], GoodsSt#st_goods.sid),
                            xian_log:put_on_log(Player#player.key, NewXianZhuang, OldXianZhang)
                    end,
                    NewGoodsSt = xian_attr:xian_change_recalc_attribute(GoodsSt1, NewXianZhuang),
                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                    xian_skill:act_skill(Player, XianZhuang#goods.goods_id),
                    StXianSkill = lib_dict:get(?PROC_STATUS_XIAN_SKILL),
                    NewPlayer = player_util:count_player_attribute(Player, true),
                    NewPlayer99 =
                        NewPlayer#player{
                            xian_skill = StXianSkill#st_xian_skill.skill_list,
                            passive_skill = util:list_filter_repeat(StXianSkill#st_xian_skill.passive_skill_list ++ NewPlayer#player.passive_skill)
                        },
                    player_handle:sync_data(xian_stage, NewPlayer99),
                    player_handle:sync_data(xian_skill, NewPlayer99),
                    skill:get_skill_list(NewPlayer99),
                    {1, NewPlayer99}
            end
    end.

%% 获取仙装仙练属性
get_xian_lian(Color) ->
    case data_feixian_lian:get_attr_num(Color) of
        [] ->
            [];
        AttrNumList ->
            case util:list_rand_ratio(AttrNumList) of
                0 ->
                    [];
                AttrNum ->
                    AllAttrs = data_feixian_lian_random:get_all(),
                    RandAttrs = util:get_random_list(AllAttrs, AttrNum),
                    case data_feixian_lian:get_random_list(Color) of
                        [] ->
                            [];
                        RandomList ->
                            F = fun(Key) ->
                                AttrColor = util:list_rand_ratio(RandomList),
                                case lists:keyfind(AttrColor, 1, data_feixian_lian_random:get_by_attr(Key)) of
                                    false ->
                                        [];
                                    {AttrColor, Min, Max} ->
                                        [{Key, util:rand(Min, Max), AttrColor}]
                                end
                            end,
                            lists:flatmap(F, RandAttrs)
                    end
            end
    end.

%%分解仙装
resolved_xian(Player, []) ->
    {0, Player};

resolved_xian(Player, GoodsKeyList) ->
    resolved_xian(Player, util:list_filter_repeat(GoodsKeyList), 0, []).

resolved_xian(Player, [], AccXianYu, DelGoodsList) ->
    goods_util:reduce_goods_key_list(Player, [{Goods#goods.key, 1} || Goods <- DelGoodsList], 711),
    if
        AccXianYu == 0 -> {1, Player};
        true ->
            GiveGoodsList = goods:make_give_goods_list(711, [{?GOODS_ID_XIANYU, AccXianYu}]),
            {ok, NewPlayer} = goods:give_goods(Player, GiveGoodsList),
            {1, NewPlayer}
    end;

resolved_xian(OldPlayer, [GoodsKey | T], OldAccXianYu, DelGoodsList) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            ?ERR("resolved_xian no exit ~p~n", [GoodsKey]),
            resolved_xian(OldPlayer, T, OldAccXianYu, DelGoodsList); %% 系统物品不存在
        XianZhuang ->
            if
                XianZhuang#goods.cell > 0 -> %% 穿在身上的符文不可以分解
                    resolved_xian(OldPlayer, T, OldAccXianYu, DelGoodsList);
                true ->
                    case data_feixian:get(XianZhuang#goods.goods_id, XianZhuang#goods.goods_lv) of
                        [] ->
                            resolved_xian(OldPlayer, T, OldAccXianYu, DelGoodsList);
                        BaseXian ->
                            AddXainYu = BaseXian#base_xian.resolved_back,
                            xian_log:resolved_log(OldPlayer#player.key, XianZhuang, AddXainYu),
                            resolved_xian(OldPlayer, T, OldAccXianYu + AddXainYu, [XianZhuang | DelGoodsList])
                    end
            end
    end.

%% 一键升级
one_key_upgrade(Player, GoodsKey) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player};
        #goods{goods_id = GoodsId, goods_lv = GoodsLv} = XianZhang ->
            case data_feixian:get(GoodsId, GoodsLv + 1) of
                [] ->
                    {8, Player};
                _ ->
                    case data_feixian:get(GoodsId, GoodsLv) of
                        [] ->
                            {0, Player};
                        #base_xian{need_exp = NeedExp} ->
                            HasXianYuNum = goods_util:get_goods_count(?GOODS_ID_XIANYU),
                            case HasXianYuNum < 1 of
                                true ->
                                    {5, Player};
                                _ ->
                                    {RemainXianYu, NewXianZhuang} = one_key_upgrade(HasXianYuNum, NeedExp, XianZhang),
                                    CostXianyu = HasXianYuNum - RemainXianYu,
                                    {ok, _} = goods:subtract_good(Player, [{?GOODS_ID_XIANYU, CostXianyu}], 715),
                                    GoodsSt0 = lib_dict:get(?PROC_STATUS_GOODS),
                                    GoodsSt1 = xian_attr:xian_change_recalc_attribute(GoodsSt0, NewXianZhuang),
                                    NewGoodsSt = goods_dict:update_goods([NewXianZhuang], GoodsSt1),
                                    goods_pack:pack_send_goods_info([NewXianZhuang], GoodsSt#st_goods.sid),
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    NewPlayer99 = player_util:count_player_attribute(Player, true),
                                    goods_load:dbup_goods_lv_exp(NewXianZhuang),
                                    xian_log:upgrade_log(Player#player.key, NewXianZhuang, XianZhang, CostXianyu, 0),
                                    if
                                        NewXianZhuang#goods.goods_lv /= XianZhang#goods.goods_lv ->
                                            {7, NewPlayer99};
                                        true ->
                                            {1, NewPlayer99}
                                    end
                            end
                    end
            end
    end.

one_key_upgrade(0, _NeedExp, XianZhang) ->
    {0, XianZhang};

one_key_upgrade(HasXianYuNum, NeedExp, XianZhang) ->
    AddExp = util:rand(8, 11),
    NewExp = XianZhang#goods.exp + AddExp,
    if
        NewExp >= NeedExp ->
            NewXianZhang =
                XianZhang#goods{
                    exp = NewExp-NeedExp,
                    goods_lv = XianZhang#goods.goods_lv+1
                },
            {HasXianYuNum-1, NewXianZhang};
        true ->
            one_key_upgrade(HasXianYuNum-1, NeedExp, XianZhang#goods{exp = NewExp})
    end.

%% 仙装升级
upgrade(Player, GoodsKey, IsAuto, _XianYuCost) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player};
        XianZhang -> %% 物品不存在异常
            case data_feixian:get(XianZhang#goods.goods_id, XianZhang#goods.goods_lv + 1) of
                [] ->
                    {8, Player};
                _ ->
                    case data_feixian:get(XianZhang#goods.goods_id, XianZhang#goods.goods_lv) of
                        [] ->
                            {8, Player};
                        #base_xian{cost = XianYuCost} ->
                            case check_upgrade(Player, IsAuto, XianYuCost, XianZhang) of
                                {false, Code} ->
                                    {Code, Player};
                                {true, Money, NewPlayer} ->
                                    AddExp = util:rand(8 * XianYuCost, 11 * XianYuCost),
                                    NewXianZhuang = cacl_lv_exp(XianZhang, AddExp),
                                    GoodsSt0 = lib_dict:get(?PROC_STATUS_GOODS),
                                    GoodsSt1 = xian_attr:xian_change_recalc_attribute(GoodsSt0, NewXianZhuang),
                                    NewGoodsSt = goods_dict:update_goods([NewXianZhuang], GoodsSt1),
                                    goods_pack:pack_send_goods_info([NewXianZhuang], GoodsSt#st_goods.sid),
                                    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt),
                                    goods_load:dbup_goods_lv_exp(NewXianZhuang),
                                    xian_log:upgrade_log(Player#player.key, NewXianZhuang, XianZhang, XianYuCost, Money),
                                    if
                                        NewXianZhuang#goods.goods_lv /= XianZhang#goods.goods_lv ->
                                            NewPlayer99 = player_util:count_player_attribute(NewPlayer, true),
                                            {7, NewPlayer99};
                                        true ->
                                            NewPlayer99 = NewPlayer,
                                            {1, NewPlayer99}
                                    end
                            end
                    end
            end
    end.

gold_one_key_upgrade(Player, GoodsKey) ->
    case one_key_upgrade(Player, GoodsKey) of
        {Code0, NPlayer} when Code0 == 5 ->
            F = fun(_N, {AccPlayer, AccFlag}) ->
                if
                    AccFlag == true ->
                        case upgrade(AccPlayer, GoodsKey, 1, 0) of
                            {Code, NewAccPlayer} when Code == 1 orelse Code == 7 ->
                                {NewAccPlayer, false};
                            _ ->
                                {AccPlayer, false}
                        end;
                    true ->
                        {AccPlayer, AccFlag}
                end
            end,
            {NewPlayer, _} = lists:foldl(F, {NPlayer, true}, lists:seq(1,300)),
            {1, NewPlayer};
        Tuple ->
            ?DEBUG("Tuple:~p", [Tuple]),
            Tuple
    end.


%% 计算等级经验
cacl_lv_exp(XianZhuang, AddExp) ->
    #goods{goods_id = GoodsId, goods_lv = GoodsLv, exp = Exp} = XianZhuang,
    #base_xian{need_exp = NeedExp} = data_feixian:get(GoodsId, GoodsLv),
    if
        AddExp + Exp >= NeedExp ->
            NewXianZhuang = XianZhuang#goods{goods_lv = GoodsLv + 1, exp = AddExp + Exp - NeedExp},
            NewXianZhuang;
        true ->
            NewXianZhuang = XianZhuang#goods{exp = AddExp + Exp},
            NewXianZhuang
    end.

check_upgrade(_Player, _IsAuto, _Num, XianZhuang) ->
    case data_feixian:get(XianZhuang#goods.goods_id, XianZhuang#goods.goods_lv) of
        [] ->
            {false, 8};
        #base_xian{} ->
            check_upgrade2(_Player, _IsAuto, _Num, XianZhuang)
    end.

check_upgrade2(Player, IsAuto, Num, _XianZhuang) ->
    CountList = [{?GOODS_ID_XIANYU, goods_util:get_goods_count(?GOODS_ID_XIANYU)}],
    Amount = lists:sum([Val || {_, Val} <- CountList]),
    if
        Amount >= Num ->
            DelGoodsList = goods_num(CountList, Num, []),
            {ok, _} = goods:subtract_good(Player, DelGoodsList, 715),
            {true, 0, Player};
        Amount < Num andalso IsAuto == 1 ->
            case new_shop:get_goods_price(?GOODS_ID_XIANYU) of
                false -> {false, 0};
                {ok, Type, Price} ->
                    Money = Price * (Num - Amount),
                    case money:is_enough(Player, Money, Type) of
                        false -> {false, 6};
                        true ->
                            DelGoodsList = goods_num(CountList, Num, []),
                            {ok, _} = goods:subtract_good(Player, DelGoodsList, 716),
                            NewPlayer = money:cost_money(Player, Type, -Money, 715, ?GOODS_ID_XIANYU, Num - Amount),
                            {true, Money, NewPlayer}
                    end
            end;
        true ->
            goods_util:client_popup_goods_not_enough(Player, ?GOODS_ID_XIANYU, Num, 60),
            {false, 5}
    end.

goods_num([], _, GoodsList) -> GoodsList;
goods_num(_, 0, GoodsList) -> GoodsList;
goods_num([{Gid, Num} | T], NeedNum, GoodsList) ->
    if
        Num =< 0 -> goods_num(T, NeedNum, GoodsList);
        Num < NeedNum ->
            goods_num(T, NeedNum - Num, [{Gid, Num} | GoodsList]);
        true ->
            [{Gid, NeedNum} | GoodsList]
    end.

get_pos(?GOODS_SUBTYPE_XIAN_1) -> 1;
get_pos(?GOODS_SUBTYPE_XIAN_2) -> 2;
get_pos(?GOODS_SUBTYPE_XIAN_3) -> 3;
get_pos(?GOODS_SUBTYPE_XIAN_4) -> 4;
get_pos(_) -> 0.

swap_attr(Player, _GoodsKey1, _GoodsKey2, 0, 0) ->
    {0, Player};

swap_attr(Player, GoodsKey1, GoodsKey2, Pos1, Pos2) ->
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    case catch goods_util:get_goods(GoodsKey1, GoodsSt#st_goods.dict) of
        {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
            {0, Player};
        Goods1 ->
            case catch goods_util:get_goods(GoodsKey2, GoodsSt#st_goods.dict) of
                {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} ->
                    {0, Player};
                Goods2 ->
                    #goods{xian_wash_attr = XianWashAttr1, color = Color} = Goods1,
                    #goods{xian_wash_attr = XianWashAttr2} = Goods2,
                    XianAttrNum = data_feixian_lian:get_maxNum_by_color(Color),
                    if
                        Pos1 == 0 andalso XianAttrNum == length(XianWashAttr1) ->
                            {0, Player}; %% 超额限制
                        length(XianWashAttr1) == 0 andalso Pos1 > 1 ->
                            {0, Player};
                        length(XianWashAttr2) == 0 andalso Pos2 > 1 ->
                            {0, Player};
                        length(XianWashAttr1) > 10 orelse length(XianWashAttr2) > 10 ->
                            {0, Player};
                        length(XianWashAttr1) < Pos1 orelse length(XianWashAttr2) < Pos2 ->
                            {0, Player};
                        true ->
                            if
                                Pos1 == 0 -> Color1 = 0;
                                Pos1 > length(XianWashAttr1) -> Color1 = 0;
                                true ->
                                    {_Key1, _Value1, Color1} = lists:nth(Pos1, XianWashAttr1)
                            end,
                            if
                                Pos2 == 0 -> Color2 = 0;
                                Pos2 > length(XianWashAttr2) -> Color2 = 0;
                                true ->
                                    {_Key2, _Value2, Color2} = lists:nth(Pos2, XianWashAttr2)
                            end,
                            AbsColor = abs(Color1-Color2),
                            case data_feixian_lian_cost:get(AbsColor) of
                                [] ->
                                    {0, Player};
                                Cost ->
                                    case money:is_enough(Player, Cost, bgold) of
                                        false ->
                                            {6, Player};
                                        true ->
                                            NewPlayer = money:add_gold(Player, -Cost, 728, 0, 0),
                                            swap_attr(NewPlayer, Goods1, XianWashAttr1, Goods2, XianWashAttr2, Pos1, Pos2, GoodsSt, Cost)
                                    end
                            end
                    end
            end
    end.

swap_attr(Player, Goods1, XianWashAttr1, Goods2, XianWashAttr2, Pos1, Pos2, GoodsSt, Cost) ->
    {NewXianWashAttr1, NewXianWashAttr2} = swap(XianWashAttr1, XianWashAttr2, Pos1, Pos2, [], []),
    NewGoods1 = Goods1#goods{xian_wash_attr = NewXianWashAttr1},
    NewGoods2 = Goods2#goods{xian_wash_attr = NewXianWashAttr2},
    NewGoodsSt = goods_dict:update_goods([NewGoods1, NewGoods2], GoodsSt),
    goods_pack:pack_send_goods_info([NewGoods1, NewGoods2], GoodsSt#st_goods.sid),
    NewGoodsSt1 = xian_attr:xian_change_recalc_attribute(NewGoodsSt, NewGoods1),
    NewGoodsSt2 = xian_attr:xian_change_recalc_attribute(NewGoodsSt1, NewGoods2),
    lib_dict:put(?PROC_STATUS_GOODS, NewGoodsSt2),
    goods_load:dbup_goods_xian_wash_attr(NewGoods1),
    goods_load:dbup_goods_xian_wash_attr(NewGoods2),
    NewPlayer = player_util:count_player_attribute(Player, true),
    Sql = io_lib:format("insert into log_xian_attr_swap set pkey=~p, goods_key1=~p, goods_id1=~p, goods_id2=~p, goods_key2=~p, old_attr_list1='~s', attr_list1='~s', old_attr_list2='~s', attr_list2='~s', cost=~p,time=~p",
        [Player#player.key, Goods1#goods.key, Goods1#goods.goods_id, Goods2#goods.goods_id, Goods2#goods.key, util:term_to_bitstring(XianWashAttr1), util:term_to_bitstring(NewXianWashAttr1), util:term_to_bitstring(XianWashAttr2), util:term_to_bitstring(NewXianWashAttr2),Cost,util:unixtime()]),
    log_proc:log(Sql),
    {1, NewPlayer}.

swap(XianWashAttr1, XianWashAttr2, 0, Pos2, _NewXianWashAttr1, _NewXianWashAttr2) when length(XianWashAttr2) < Pos2 ->
    {XianWashAttr1, XianWashAttr2};
swap(XianWashAttr1, XianWashAttr2, Pos1, 0, _NewXianWashAttr1, _NewXianWashAttr2) when length(XianWashAttr1) < Pos1 ->
    {XianWashAttr1, XianWashAttr2};
swap(XianWashAttr1, XianWashAttr2, 0, Pos2, _NewXianWashAttr1, _NewXianWashAttr2) ->
    AttrInfo = [lists:nth(Pos2, XianWashAttr2)],
    {XianWashAttr1++AttrInfo, XianWashAttr2--AttrInfo};
swap(XianWashAttr1, XianWashAttr2, Pos1, 0, _NewXianWashAttr1, _NewXianWashAttr2) ->
    AttrInfo = lists:nth(Pos1, XianWashAttr1),
    {XianWashAttr1--AttrInfo, XianWashAttr2++AttrInfo};
swap([H1 | T1], [H2 | T2], 1, 1, NewXianWashAttr1, NewXianWashAttr2) ->
    {NewXianWashAttr1 ++ [H2] ++ T1, NewXianWashAttr2 ++ [H1] ++ T2};
swap(L1, [H2 | T2], 1, Pos2, NewXianWashAttr1, NewXianWashAttr2) ->
    swap(L1, T2, 1, Pos2-1, NewXianWashAttr1, NewXianWashAttr2 ++ [H2]);
swap([H1 | T1], L2, Pos1, 1, NewXianWashAttr1, NewXianWashAttr2) ->
    swap(T1, L2, Pos1-1, 1, NewXianWashAttr1 ++ [H1], NewXianWashAttr2);
swap([H1 | T1], [H2 | T2], Pos1, Pos2, NewXianWashAttr1, NewXianWashAttr2) ->
    swap(T1, T2, Pos1-1, Pos2-1, NewXianWashAttr1 ++ [H1], NewXianWashAttr2 ++ [H2]).
