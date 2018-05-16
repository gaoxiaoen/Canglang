%%%-------------------------------------------------------------------
%%% @author fzl
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 装备强化
%%% @end
%%% Created : 17. 一月 2015 14:52
%%%-------------------------------------------------------------------
-module(equip_stren).
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
    get_stren_suit/0,
    cron_equip_stren/8,
    equip_strength/3,
    get_equip_stren_sum_lv/0  %%获取身上装备强化总等级
    , check_equip_stren_state/1
    , get_equip_strength_exp/2
]).
-export([pack_equip_exp/1, format_equip_exp/1]).

pack_equip_exp(ExpList) ->
    F = fun({SubType, Lv, Exp}) ->
        #equip_strength{subtype = SubType, strength = Lv, exp = Exp}
    end,
    lists:map(F, ExpList).

format_equip_exp(ExpList) ->
    F = fun(EquipStren) ->
        {EquipStren#equip_strength.subtype, EquipStren#equip_strength.strength, EquipStren#equip_strength.exp}
    end,
    lists:map(F, ExpList).

%%检查装备强化状态,看看身上的材料是否能强化三次
check_equip_stren_state(Player) ->
    F = fun(Goods) ->
        GoodsType = data_goods:get(Goods#goods.goods_id),
        case Goods#goods.stren < data_equip_strength:subtype_strength_lim(GoodsType#goods_type.subtype) of
            true ->
                case data_equip_strength:get(GoodsType#goods_type.subtype, Goods#goods.stren + 1) of
                    [] ->
                        false;
                    Base ->
                        Have = goods_util:get_goods_count(Base#base_equip_strength.goods_id),
                        NeedCoin = Base#base_equip_strength.coin,
                        IsEnough = money:is_enough(Player, NeedCoin, coin),
                        Have >= Base#base_equip_strength.num * 1 andalso IsEnough
                end;
            false -> false
        end
    end,
    List = [Goods || Goods <- goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY)],
    case lists:any(F, List) of
        true -> 1;
        false -> 0
    end.

%%获取强化套装属性
get_stren_suit() ->
    StrengthLv = equip_attr:strength_lv(),
    CurStrengthLv =
        case [Lv || Lv <- data_equip_strength_suit:ids(), Lv =< StrengthLv] of
            [] -> 0;
            L1 -> lists:max(L1)
        end,
    Attribute = attribute_util:make_attribute_by_key_val_list(data_equip_strength_suit:get(CurStrengthLv)),
    Cbp = attribute_util:calc_combat_power(Attribute),
    AttrList = attribute_util:pack_attr(Attribute),
    MaxLv = data_equip_strength_suit:max_lv(),

    if StrengthLv >= MaxLv ->
        {StrengthLv, Cbp, AttrList, 1, 0, 0, 0, 0, []};
        true ->
            IdList = data_equip_strength:ids(),
            NextStrengthLv =
                case [Lv || Lv <- data_equip_strength_suit:ids(), Lv > StrengthLv] of
                    [] -> 0;
                    L2 -> lists:min(L2)
                end,
            StStrength = lib_dict:get(?PROC_STATUS_EQUIP_STRENTH),
            F1 = fun(Strength) -> Strength#equip_strength.strength >= NextStrengthLv end,
            Active = length(lists:filter(F1, StStrength#st_strength_exp.exp_list)),
            NextAttribute = attribute_util:make_attribute_by_key_val_list(data_equip_strength_suit:get(NextStrengthLv)),
            NextCbp = attribute_util:calc_combat_power(NextAttribute),
            NextAttrList = attribute_util:pack_attr(NextAttribute),
            {StrengthLv, Cbp, AttrList, 0, NextStrengthLv, Active, length(IdList), NextCbp, NextAttrList}
    end.

%%装备强化
equip_strength(Player, GoodsKey, AutoBuy) ->
    Goods = goods_util:get_goods(GoodsKey),
    GoodsType = data_goods:get(Goods#goods.goods_id),
    ?ASSERT(Goods#goods.stren < data_equip_strength:subtype_strength_lim(GoodsType#goods_type.subtype), {false, 12}),
    Base = data_equip_strength:get(GoodsType#goods_type.subtype, Goods#goods.stren + 1),
    {NewPlayer, NeedMoney, StoneId} = check_and_cost(Player, Base, AutoBuy),
    StStrenExp = lib_dict:get(?PROC_STATUS_EQUIP_STRENTH),
    EquipStrength =
        case lists:keyfind(GoodsType#goods_type.subtype, #equip_strength.subtype, StStrenExp#st_strength_exp.exp_list) of
            false ->
                #equip_strength{subtype = GoodsType#goods_type.subtype};
            Value ->
                Value
        end,
    if EquipStrength#equip_strength.exp >= Base#base_equip_strength.exp_lim ->
        equip_success(NewPlayer, Goods, GoodsType, StStrenExp, EquipStrength, StoneId, NeedMoney);
        true ->
            RatioList = [{1, Base#base_equip_strength.success_ratio}, {2, Base#base_equip_strength.fail_ratio}],
            case util:list_rand_ratio(RatioList) of
                1 -> equip_success(NewPlayer, Goods, GoodsType, StStrenExp, EquipStrength, StoneId, NeedMoney);
                _ -> equip_fail(NewPlayer, StStrenExp, EquipStrength, Base,Goods)
            end
    end.

equip_success(Player, Goods, GoodsType, StStrenExp, EquipStrength, StoneId, NeedMoney) ->
    NewExpList = [EquipStrength#equip_strength{exp = 0, strength = Goods#goods.stren  + 1} | lists:keydelete(GoodsType#goods_type.subtype, #equip_strength.subtype, StStrenExp#st_strength_exp.exp_list)],
    lib_dict:put(?PROC_STATUS_EQUIP_STRENTH, StStrenExp#st_strength_exp{is_change = 1, exp_list = NewExpList}),
%%    equip_attr:calc_strength_all_attr(),
    Goods1 = Goods#goods{stren = Goods#goods.stren  + 1, bind = ?BIND},
    NewGoods = equip_attr:equip_combat_power(Goods1),
    %%广播
    notice_sys:add_notice(eq_stren, [Player, NewGoods]),
    GoodsUpdateBin = goods_pack:pack_goods_info_bin([NewGoods]),
    server_send:send_to_sid(Player#player.sid, GoodsUpdateBin),
    goods_load:dbup_goods_stren(NewGoods),
    GoodsSt = lib_dict:get(?PROC_STATUS_GOODS),
    GoodsSt1 = goods_dict:update_goods(NewGoods, GoodsSt),
    GoodsSt2 = equip_attr:equip_change_recalc_attribute(GoodsSt1, NewGoods),
    lib_dict:put(?PROC_STATUS_GOODS, GoodsSt2),
    Player1 = equip_attr:equip_suit_calc(Player),
    player_load:dbup_max_stren_lv(Player1),
    NewPlayer1 = player_util:count_player_attribute(Player1, true),
    %%冲榜活动
    act_rank:update_player_rank_data(Player, 1, false),
    cron_equip_stren(Player#player.key, Player#player.nickname, Goods#goods.goods_id, Goods#goods.stren, 1, StoneId, NeedMoney, util:unixtime()),
    get_equip_strength_exp(Player, EquipStrength#equip_strength.subtype),
    %%成就
    EquipList = goods_util:get_goods_list_by_location(GoodsSt2, ?GOODS_LOCATION_BODY),
    EquipStrengthList = equip_util:get_equip_stren_list(EquipList),

    F = fun({Stren, StrenCount}) ->
        achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_1, ?ACHIEVE_SUBTYPE_1005, Stren, StrenCount),
        task_event:event(?TASK_ACT_EQUIP_STRENGTH, {Stren, StrenCount})
    end,
    lists:foreach(F, EquipStrengthList),
    {ok, NewPlayer1, 32}.
equip_fail(Player, StStrenExp, EquipStrength, Base,Goods) ->
    NewExpList = [EquipStrength#equip_strength{exp = Base#base_equip_strength.exp_add + EquipStrength#equip_strength.exp,strength = Goods#goods.stren} | lists:keydelete(EquipStrength#equip_strength.subtype, #equip_strength.subtype, StStrenExp#st_strength_exp.exp_list)],
    lib_dict:put(?PROC_STATUS_EQUIP_STRENTH, StStrenExp#st_strength_exp{is_change = 1, exp_list = NewExpList}),
    get_equip_strength_exp(Player, EquipStrength#equip_strength.subtype),
    {ok, Player, 0}.

check_and_cost(Player, Base, AutoBuy) ->
    case money:is_enough(Player, Base#base_equip_strength.coin, coin) of
        false ->
            goods_util:client_popup_goods_not_enough(Player, 10101, Base#base_equip_strength.coin, 21),
            throw({false, ?ER_NOT_ENOUGH_COIN});
        true ->
            ok
    end,
    GoodsId = Base#base_equip_strength.goods_id,
    GoodsNum = Base#base_equip_strength.num,
    HaveNum = goods_util:get_goods_count(GoodsId),
    if HaveNum >= GoodsNum ->
        goods:subtract_good_throw(Player, [{GoodsId, GoodsNum}], 21),
        NewPlayer = money:add_coin(Player, -Base#base_equip_strength.coin, 21, 0, 0),
        target_act:trigger_tar_act(Player, 2, GoodsNum),
        self() ! {m_task_trigger, 5, GoodsNum},
        {NewPlayer, 0, GoodsId};
        AutoBuy == 1 ->
            BuyNeed = GoodsNum - HaveNum,
            case new_shop:auto_buy(Player, GoodsId, BuyNeed, 21) of
                {ok, Player1, Price} ->
                    NewPlayer = money:add_coin(Player1, -Base#base_equip_strength.coin, 21, 0, 0),
                    goods:subtract_good_throw(Player, [{GoodsId, HaveNum}], 21),
                    target_act:trigger_tar_act(Player, 2, GoodsNum),
                    self() ! {m_task_trigger, 5, GoodsNum},
                    {NewPlayer, Price, GoodsId};
                {false, 1} -> throw({false, 39});
                _ -> throw({false, 15})
            end;
        true ->
            goods_util:client_popup_goods_not_enough(Player, GoodsId, GoodsNum, 21),
            throw({false, 3})
    end.

%%获取身上装备强化总等级
get_equip_stren_sum_lv() ->
    GoodsList = goods_util:get_goods_list_by_location(?GOODS_LOCATION_BODY),
    lists:sum([G#goods.stren || G <- GoodsList]).

cron_equip_stren(Pkey, Nickname, GoodsId, BeforLv, AddLevel, CostGoods, NeedMoney, Time) ->
    Sql = io_lib:format(<<"insert into log_equip_streng set pkey = ~p,nickname = '~s',goods_id =~p,result=~p,befor_lv=~p,after_lv = ~p,cost_coin = ~p,cost_goods = ~p,time=~p">>,
        [Pkey, Nickname, GoodsId, AddLevel, BeforLv, BeforLv + AddLevel, NeedMoney, CostGoods, Time]),
    log_proc:log(Sql),
    ok.

%%获取强化累计经验
get_equip_strength_exp(Player, Subtype) ->
    StStrenExp = lib_dict:get(?PROC_STATUS_EQUIP_STRENTH),
    Exp =
        case lists:keyfind(Subtype, #equip_strength.subtype, StStrenExp#st_strength_exp.exp_list) of
            false ->
                0;
            EquipStrength ->
                EquipStrength#equip_strength.exp
        end,
    {ok, Bin} = pt_160:write(16006, {Subtype, Exp}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok.
