%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 一月 2018 18:28
%%%-------------------------------------------------------------------
-module(act_godness_limit).
-author("Administrator").

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
    St =
        case player_util:is_new_role(Player) of
            true -> #st_godness_limit{pkey = Pkey};
            false -> activity_load:dbget_godness_limit_time_gift(Pkey)
        end,
    lib_dict:put(?PROC_STATUS_GODNESS_LIMIT, St),
    update_limit_time_shop(),
    Player.

update_limit_time_shop() ->
    St = lib_dict:get(?PROC_STATUS_GODNESS_LIMIT),
    #st_godness_limit{
        pkey = Pkey,
        act_id = ActId
    } = St,
    case get_act() of
        [] ->
            NewSt = #st_godness_limit{pkey = Pkey};
        #base_godness_limit{act_id = BaseActId} ->
            if
                BaseActId =/= ActId ->
                    NewSt = #st_godness_limit{pkey = Pkey, act_id = BaseActId};
                true ->
                    NewSt = St
            end
    end,
    lib_dict:put(?PROC_STATUS_GODNESS_LIMIT, NewSt).

%% 凌晨重置不操作数据库
midnight_refresh(_ResetTime) ->
    update_limit_time_shop().

get_act() ->
    case activity:get_work_list(data_godness_limit) of
        [] -> [];
        [Base | _] -> Base
    end.

get_act_info(_Player) ->
    update_limit_time_shop(),
    case get_act() of
        [] ->
            {0, []};
        #base_godness_limit{list = BaseList, open_info = OpenInfo} ->
            LTime = activity:calc_act_leave_time(OpenInfo),
            St = lib_dict:get(?PROC_STATUS_GODNESS_LIMIT),
            #st_godness_limit{buy_list = BuyList} = St,
            F = fun(#base_godness_limit_sub{id = Id, show_type = ShowType, cost_gold = CostGold, sell_list = SellList, desc = Desc}) ->
                BuyNum =
                    case lists:keyfind(Id, 1, BuyList) of
                        false -> 0;
                        {_Id, Num} -> Num
                    end,
                [Id, Desc, ShowType, CostGold, BuyNum, util:list_tuple_to_list(SellList)]
            end,
            ProList = lists:map(F, BaseList),
            {LTime, ProList}
    end.

buy(Player, Id) ->
    case check_buy(Player, Id) of
        {fail, Code} ->
            {Code, Player};
        {true, CostGold, SellList, NewBuyList} ->
            St = lib_dict:get(?PROC_STATUS_GODNESS_LIMIT),
            NewSt =
                St#st_godness_limit{
                    buy_list = NewBuyList,
                    op_time = util:unixtime()
                },
            lib_dict:put(?PROC_STATUS_GODNESS_LIMIT, NewSt),
            activity_load:dbup_godness_limit_time_gift(NewSt),
            NPlayer = money:add_no_bind_gold(Player, -CostGold, 342, 0, 0),
            GiveGoodsList = goods:make_give_goods_list(342, SellList),
            {ok, NewPlayer} = goods:give_goods(NPlayer, GiveGoodsList),
            log_godness_limit(Player#player.key, Player#player.nickname, Id, CostGold, SellList),
%%             if
%%                 Id >= 3 ->
%%                     spawn(fun() -> buy_notice(Player, CostGold, Id) end);
%%                 true -> skip
%%             end,
            {1, NewPlayer}
    end.

buy_notice(Player, CostGold, Id) ->
    case get_act() of
        [] -> skip;
        #base_godness_limit{list = BaseList} ->
            #base_godness_limit_sub{desc = Desc} = lists:nth(Id, BaseList),
            notice_sys:add_notice(limit_time_buy, [Player, CostGold, Desc]),
            ok
    end.

check_buy(Player, Id) ->
    case get_act() of
        [] -> {fail, 0};
        #base_godness_limit{list = BaseList} ->
            case lists:keyfind(Id, #base_godness_limit_sub.id, BaseList) of
                false ->
                    {fail, 0};
                #base_godness_limit_sub{cost_gold = CostGold, sell_list = SellList} ->
                    case money:is_enough(Player, CostGold, gold) of
                        false ->
                            {fail, 2};
                        true ->
                            St = lib_dict:get(?PROC_STATUS_GODNESS_LIMIT),
                            #st_godness_limit{buy_list = BuyList} = St,
                            case lists:keytake(Id, 1, BuyList) of
                                false ->
                                    {true, CostGold, SellList, [{Id, 1} | BuyList]};
                                {value, {Id, OldBuyNum}, Rest} ->
                                    if
                                        OldBuyNum >= 1 ->
                                            {fail, 6};
                                        true ->
                                            {true, CostGold, SellList, [{Id, 1} | Rest]}
                                    end
                            end
                    end
            end
    end.

get_notice_state(_Player) ->
    case get_act() of
        [] -> -1;
        #base_godness_limit{act_info = ActInfo} ->
            Args = activity:get_base_state(ActInfo),
            {0, Args}
    end.

%% 购买日志
log_godness_limit(Pkey, Nickname, ActId, Cost, GoodsList) ->
    Sql = io_lib:format("insert into log_godness_limit set pkey=~p,nickname='~s',act_id=~p,cost = ~p, goods_list='~s',time=~p",
        [Pkey, Nickname, ActId, Cost, util:term_to_bitstring(GoodsList), util:unixtime()]),
    log_proc:log(Sql).
