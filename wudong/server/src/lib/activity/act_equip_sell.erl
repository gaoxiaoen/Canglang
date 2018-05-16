%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 特权炫装
%%% @end
%%% Created : 16. 五月 2017 14:46
%%%-------------------------------------------------------------------
-module(act_equip_sell).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").
-include("goods.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,

    get_state/1,
    get_act/0,
    get_act_info/1,
    buy/2
]).

init(#player{key = Pkey} = Player) ->
    StEquipSell =
        case player_util:is_new_role(Player) of
            true -> #st_equip_sell{pkey = Pkey};
            false -> activity_load:dbget_equip_sell(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_ACT_EQUIP_SELL, StEquipSell),
    update_equip_sell(),
    Player.

update_equip_sell() ->
    StEquipSell = lib_dict:get(?PROC_STATUS_ACT_EQUIP_SELL),
    #st_equip_sell{
        pkey = Pkey,
        act_id = ActId
    } = StEquipSell,
    case get_act() of
        [] ->
            NewStEquipSell = #st_equip_sell{pkey = Pkey};
        #base_act_equip_sell{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewStEquipSell = #st_equip_sell{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewStEquipSell = StEquipSell
            end
    end,
    lib_dict:put(?PROC_STATUS_ACT_EQUIP_SELL, NewStEquipSell).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_equip_sell().

get_act_info(_Player) ->
    case get_act() of
        [] ->
            {0, []};
        #base_act_equip_sell{open_info = OpenInfo, list = BaseList} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            StEquipSell = lib_dict:get(?PROC_STATUS_ACT_EQUIP_SELL),
            #st_equip_sell{buy_list = BuyList} = StEquipSell,
            F = fun(#base_act_equip_sell_sub{id = Id, page = Page, goods_info = GoodsInfo, sell_num = SellNum, price = Price, cbp = Cbp, dec = Desc}) ->
                {GoodsId, GoodsNum} = hd(GoodsInfo),
                case lists:keyfind(Id, 1, BuyList) of
                    false ->
                        RemainSellNum = SellNum;
                    {_Id, Num} ->
                        RemainSellNum = max(0, SellNum - Num)
                end,
                [Id, Page, Desc, GoodsId, GoodsNum, RemainSellNum, Price, Cbp]
                end,
            L = lists:map(F, BaseList),
            ?DEBUG("L:~p", [L]),
            {LTime, L}
    end.

check_buy(Player, Id, BuyList, BaseList) ->
    case lists:keyfind(Id, #base_act_equip_sell_sub.id, BaseList) of
        false ->
            ?ERR("Id:~p~n", [Id]),
            {false, 0};
        #base_act_equip_sell_sub{price = Price, sell_num = SellNum} = BaseSub ->
            case money:is_enough(Player, Price, gold) of
                false ->
                    {false, 5}; %% 元宝不足
                true ->
                    case lists:keyfind(Id, 1, BuyList) of
                        false ->
                            {true, BaseSub};
                        {_Id, Num} ->
                            if
                                Num >= SellNum -> {false, 18}; %% 次数不足
                                true -> {true, BaseSub}
                            end
                    end
            end
    end.

buy(Player, Id) ->
    case get_act() of
        [] ->
            0;
        #base_act_equip_sell{list = BaseList} ->
            StEquipSell = lib_dict:get(?PROC_STATUS_ACT_EQUIP_SELL),
            #st_equip_sell{buy_list = BuyList} = StEquipSell,
            case check_buy(Player, Id, BuyList, BaseList) of
                {false, Code} ->
                    {Code, Player};
                {true, BaseSub} ->
                    NewBuyList =
                        case lists:keytake(Id, 1, BuyList) of
                            false ->
                                [{Id, 1} | BuyList];
                            {value, {Id, Num}, Ret} ->
                                [{Id, Num + 1} | Ret]
                        end,
                    NewStEquipSell = StEquipSell#st_equip_sell{buy_list = NewBuyList},
                    lib_dict:put(?PROC_STATUS_ACT_EQUIP_SELL, NewStEquipSell),
                    activity_load:dbup_equip_sell(NewStEquipSell),
                    #base_act_equip_sell_sub{goods_info = GoodsInfo, price = Price, bind = Bind} = BaseSub,
                    NPlayer = money:add_no_bind_gold(Player, - Price, 628, 0, 0),
                    {GoodsId, GoodsNum} = hd(GoodsInfo),
                    GiveGoodsList = goods:make_give_goods_list(629, [{GoodsId, GoodsNum, Bind}]),
                    {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
                    activity:get_notice(Player, [41], true),
                    activity_log:log_sell_equip(Player#player.key, Player#player.nickname, GoodsId, Price),
                    {1, NewPlayer}
            end
    end.

get_state(_Player) ->
    case get_act() of
        [] ->
            -1;
        #base_act_equip_sell{list = _BaseList, act_info = ActInfo} ->
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.

get_act() ->
    case activity:get_work_list(data_act_equip_sell) of
        [] -> [];
        [Base | _] -> Base
    end.