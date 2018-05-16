%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 八月 2017 17:30
%%%-------------------------------------------------------------------
-module(limit_time_gift).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("activity.hrl").

%% API
-export([
    init/1,
    midnight_refresh/1,
    get_act/0,

    get_act_info/1,
    buy/2,
    get_notice_state/1
]).

init(#player{key = Pkey} = Player) ->
    StLimitTimeGift =
        case player_util:is_new_role(Player) of
            true -> #st_limit_time_gift{pkey = Pkey};
            false -> activity_load:dbget_limit_time_gift(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_LIMIT_TIME_GIFT, StLimitTimeGift),
    update_limit_time_shop(),
    Player.

update_limit_time_shop() ->
    StLimitTimeGift = lib_dict:get(?PROC_STATUS_LIMIT_TIME_GIFT),
    #st_limit_time_gift{
        pkey = Pkey,
        act_id = ActId
    } = StLimitTimeGift,
    case get_act() of
        [] ->
            NewStLimitTimeGift = #st_limit_time_gift{pkey = Pkey};
        #base_limit_time_gift{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewStLimitTimeGift = #st_limit_time_gift{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewStLimitTimeGift = StLimitTimeGift
            end
    end,
    lib_dict:put(?PROC_STATUS_LIMIT_TIME_GIFT, NewStLimitTimeGift).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_limit_time_shop().

get_act() ->
    case activity:get_work_list(data_limit_time_gift) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act_info(_Player) ->
    update_limit_time_shop(),
    case get_act() of
        [] ->
            {0, []};
        #base_limit_time_gift{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            St = lib_dict:get(?PROC_STATUS_LIMIT_TIME_GIFT),
            #st_limit_time_gift{buy_list = BuyList} = St,
            F = fun(#base_limit_time_gift_sub{id = Id, cost_gold = CostGold, base_cost_gold = BaseCostGold, sell_list = SellList, buy_num = BaseBuyNum}) ->
                BuyNum =
                    case lists:keyfind(Id, 1, BuyList) of
                        false -> 0;
                        {_Id, Num} -> Num
                    end,
                [Id, CostGold, BaseCostGold, BuyNum, BaseBuyNum, util:list_tuple_to_list(SellList)]
                end,
            ProList = lists:map(F, BaseList),
            {LTime, ProList}
    end.

buy(Player, Id) ->
    case check_buy(Player, Id) of
        {fail, Code} ->
            {Code, Player};
        {true, CostGold, SellList, NewBuyList} ->
            St = lib_dict:get(?PROC_STATUS_LIMIT_TIME_GIFT),
            NewSt =
                St#st_limit_time_gift{
                    buy_list = NewBuyList,
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_LIMIT_TIME_GIFT, NewSt),
            activity_load:dbup_limit_time_gift(NewSt),
            NPlayer = money:add_no_bind_gold(Player, -CostGold, 687, 0, 0),
            GiveGoodsList = goods:make_give_goods_list(688, SellList),
            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
            if
                Id >= 3 ->
                    spawn(fun() -> buy_notice(Player, CostGold, Id) end);
                true -> skip
            end,
            {1, NewPlayer}
    end.

buy_notice(Player, CostGold, Id) ->
    case get_act() of
        [] -> skip;
        #base_limit_time_gift{list = BaseList} ->
            #base_limit_time_gift_sub{desc = Desc} = lists:nth(Id, BaseList),
            notice_sys:add_notice(limit_time_buy, [Player, CostGold, Desc]),
            ok
    end.

check_buy(Player, Id) ->
    case get_act() of
        [] -> {fail, 0};
        #base_limit_time_gift{list = BaseList} ->
            case lists:keyfind(Id, #base_limit_time_gift_sub.id, BaseList) of
                false ->
                    {fail, 0};
                #base_limit_time_gift_sub{cost_gold = CostGold, sell_list = SellList, buy_num = BaseBuyNum} ->
                    case money:is_enough(Player, CostGold, gold) of
                        false ->
                            {fail, 2};
                        true ->
                            St = lib_dict:get(?PROC_STATUS_LIMIT_TIME_GIFT),
                            #st_limit_time_gift{buy_list = BuyList} = St,
                            case lists:keytake(Id, 1, BuyList) of
                                false ->
                                    {true, CostGold, SellList, [{Id, 1} | BuyList]};
                                {value, {Id, OldBuyNum}, Rest} ->
                                    if
                                        OldBuyNum >= BaseBuyNum ->
                                            {fail, 6};
                                        true ->
                                            {true, CostGold, SellList, [{Id, OldBuyNum + 1} | Rest]}
                                    end
                            end
                    end
            end
    end.

get_notice_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_limit_time_gift{act_info = ActInfo} ->
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.