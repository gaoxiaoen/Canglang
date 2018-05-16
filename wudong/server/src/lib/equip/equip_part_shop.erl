%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 一月 2018 16:22
%%%-------------------------------------------------------------------
-module(equip_part_shop).
-author("Administrator").

-include("goods.hrl").
-include("equip.hrl").
-include("common.hrl").
-include("server.hrl").

%% API
-export([init/1, get_shop_info/2, buy/3, get_type_list/1]).

init(Player) ->
    St = dbget_equip_level_shop(Player#player.key),
    lib_dict:put(?PROC_STATUS_EQUIP_SHOP, St),
    Player.


get_type_list(_Player) ->
    Types = data_equip_part_shop:get_all_type(),
    Types.

%% 获取兑换信息
get_shop_info(_Player, Type) ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_SHOP),
    MyList = St#st_equip_part_shop.list,
    ?DEBUG("MyList ~p~n", [MyList]),
    Ids = data_equip_part_shop:get_ids_by_type(Type),
    F0 = fun(Id) ->
        case data_equip_part_shop:get(Type, Id) of
            [] -> [];
            Base ->
                case lists:keyfind({Type, Id}, 1, MyList) of
                    false ->
                        [
                            Base#base_equip_part_shop.type,
                            Base#base_equip_part_shop.id,
                            Base#base_equip_part_shop.goods_id,
                            Base#base_equip_part_shop.goods_num,
                            Base#base_equip_part_shop.cost,
                            Base#base_equip_part_shop.limit,
                            goods:pack_goods(Base#base_equip_part_shop.cost_list)
                        ];
                    {{Type, Id}, Count} ->
                        [
                            Base#base_equip_part_shop.type,
                            Base#base_equip_part_shop.id,
                            Base#base_equip_part_shop.goods_id,
                            Base#base_equip_part_shop.goods_num,
                            Base#base_equip_part_shop.cost,
                            max(0, Base#base_equip_part_shop.limit - Count),
                            goods:pack_goods(Base#base_equip_part_shop.cost_list)
                        ]
                end
        end
         end,
    lists:map(F0, Ids).


buy(Player, Type, Id) ->
    St = lib_dict:get(?PROC_STATUS_EQUIP_SHOP),
    case check_buy(Player, Type, Id, St#st_equip_part_shop.list) of
        {false, Res} ->
            {Res, Player};
        {ok, Base, NewList} ->
            NewPlayer = money:add_equip_part(Player, -Base#base_equip_part_shop.cost), %%扣除碎片
            goods:subtract_good(NewPlayer, Base#base_equip_part_shop.cost_list, 346),
            {ok, NewPlayer1} = goods:give_goods(NewPlayer, goods:make_give_goods_list(346, [{Base#base_equip_part_shop.goods_id, Base#base_equip_part_shop.goods_num}])),
            NewSt = St#st_equip_part_shop{list = NewList},
            lib_dict:put(?PROC_STATUS_EQUIP_SHOP, NewSt),
            log_equip_shop(Player#player.key, Player#player.nickname, Base#base_equip_part_shop.cost, Base#base_equip_part_shop.goods_id, Base#base_equip_part_shop.goods_num),
            dbup_equip_level_shop(NewSt),
            {1, NewPlayer1}
    end.

check_buy(Player, Type, Id, MyList) ->
    ?DEBUG("Type, Id ~p~n", [{Type, Id}]),
    case data_equip_part_shop:get(Type, Id) of
        [] -> {false, 0};
        Base ->
            if Player#player.equip_part < Base#base_equip_part_shop.cost ->
                {false, 57};
                true ->
                    F = fun({GoodsId, GoodsNum}) ->
                        Count0 = goods_util:get_goods_count(GoodsId),
                        ?IF_ELSE(Count0 >= GoodsNum, true, false)
                        end,
                    CostState = lists:all(F, Base#base_equip_part_shop.cost_list),
                    if
                        CostState == true ->
                            case lists:keytake({Type, Id}, 1, MyList) of
                                false ->
                                    {ok, Base, [{{Type, Id}, 1} | MyList]};
                                {value, {{Type, Id}, Count}, L} ->
                                    if
                                        Count >= Base#base_equip_part_shop.limit ->
                                            {false, 58};
                                        true ->
                                            {ok, Base, [{{Type, Id}, Count + 1} | L]}
                                    end
                            end;
                        true -> {false, 3}
                    end
            end
    end.

dbget_equip_level_shop(Pkey) ->
    Sql = io_lib:format("select buy_list from player_equip_part_shop where pkey=~p", [Pkey]),
    case db:get_row(Sql) of
        [] -> #st_equip_part_shop{pkey = Pkey};
        [BuyList] ->
            #st_equip_part_shop{pkey = Pkey, list = util:bitstring_to_term(BuyList)}
    end.

dbup_equip_level_shop(St) ->
    List = St#st_equip_part_shop.list,
    Pkey = St#st_equip_part_shop.pkey,
    Sql = io_lib:format("replace into player_equip_part_shop set buy_list = '~s', pkey =~p", [util:term_to_bitstring(List), Pkey]),
    db:execute(Sql),
    ok.


log_equip_shop(Pkey, Nickname, Cost, GoodsId, GoodsNum) ->
    Sql = io_lib:format(<<"insert into log_equip_shop set pkey = ~p,nickname = '~s',  cost = ~p, goods_id = ~p,goods_num = ~p,time=~p">>,
        [Pkey, Nickname, Cost, GoodsId, GoodsNum, util:unixtime()]),
    log_proc:log(Sql),
    ok.
