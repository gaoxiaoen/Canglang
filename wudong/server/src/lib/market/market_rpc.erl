%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 17:16
%%%-------------------------------------------------------------------
-module(market_rpc).

-include("server.hrl").
-include("common.hrl").
-include("market.hrl").
-include("goods.hrl").
-include("achieve.hrl").


%% API
-export([handle/3]).

%%集市列表
handle(31001, Player, {Type, SubType}) ->
    ?CAST(market_proc:get_server_pid(), {market_list, Player#player.sid, Player#player.pf, Player#player.is_interior, Type, SubType}),
    ok;

%%购买
handle(31002, Player, {Key}) ->
    ?DEBUG("31002 Key:~p", [Key]),
    St = lib_dict:get(?PROC_STATUS_MARKET),
    {BaseBuyNum, _BaseSellNum} = data_market_vip:get_buy_sell_by_vip(Player#player.vip_lv),
    if
        St#st_market_p.buy_num >= BaseBuyNum ->
            {ok, Bin} = pt_310:write(31002, {18}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        true ->
            case ?CALL(market_proc:get_server_pid(), {market_buy, Player, Key}) of
                [] ->
                    {ok, Bin} = pt_310:write(31002, {0}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok;
                {ok, 1, Gold, GoodsId, Num} ->
                    NewPlayer = money:add_no_bind_gold(Player, -Gold, 32, GoodsId, Num),
                    {ok, Bin} = pt_310:write(31002, {1}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    achieve:trigger_achieve(Player, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4015, 0, Gold),
                    NewSt = St#st_market_p{buy_num = St#st_market_p.buy_num + 1},
                    lib_dict:put(?PROC_STATUS_MARKET, NewSt),
                    market_load:update_market_p(NewSt),
                    {ok, NewPlayer};
                {ok, Err, _, _, _} ->
                    {ok, Bin} = pt_310:write(31002, {Err}),
                    server_send:send_to_sid(Player#player.sid, Bin),
                    ok
            end
    end;

%%我的上架
handle(31003, Player, {}) ->
    case Player#player.vip_lv >= data_market_args:get_vip_limit() orelse Player#player.lv >= data_market_args:get_lv_limit() of
        true ->
            ?CAST(market_proc:get_server_pid(), {sell_list, Player#player.key, Player#player.sid});
        false ->
            {ok, Bin} = pt_310:write(31003, {16, []}),
            server_send:send_to_sid(Player#player.sid, Bin)
    end,
    ok;

%%挂售物品
handle(31004, Player, {GoodsKey, Num, Price, Time}) ->
    case Player#player.vip_lv >= data_market_args:get_vip_limit() orelse Player#player.lv >= data_market_args:get_lv_limit() of
        true ->
            ?DEBUG("GoodsKey:~p, Num:~p, Price:~p, Time:~p", [GoodsKey, Num, Price, Time]),
            Ret =
                case data_channel_limit:get(Player#player.pf) of
                    true -> 2;
                    false ->
                        case catch goods_util:get_goods(GoodsKey) of
                            {false, ?ER_VERIFY_FAILL_GOODS_NOT_EXIST} -> 7;
                            Goods ->
                                GoodsType = data_goods:get(Goods#goods.goods_id),
                                St = lib_dict:get(?PROC_STATUS_MARKET),
                                {_BaseBuyNum, BaseSellNum} = data_market_vip:get_buy_sell_by_vip(Player#player.vip_lv),
                                ?DEBUG("BaseSellNum:~p St#st_market_p.sell_num:~p", [BaseSellNum, St#st_market_p.sell_num]),
                                if
                                    GoodsType#goods_type.is_sell == 0 -> 8;
                                    Num =< 0 -> 0;
                                    Goods#goods.num < Num -> 9;
                                    Goods#goods.bind /= 0 -> 13;
                                    Goods#goods.expire_time > 0 -> 15;
                                    Player#player.is_interior == 1 -> 0;
                                    Price =< 0 -> 14;
                                    St#st_market_p.sell_num >= BaseSellNum -> 17;
                                    true ->
                                        case lists:member(Time, ?MARKET_SHELVES_TIME_LIST) of
                                            false -> 11;
                                            true ->
                                                SellArgs = equip_random:make_sell_args(Goods),
                                                MarketPid = market_proc:get_server_pid(),
                                                case ?CALL(MarketPid, {market_sell_goods, Player, GoodsType, Num, Price, Time, SellArgs}) of
                                                    {ok, Key} ->
                                                        case catch goods_util:reduce_goods_key_list(Player, [{GoodsKey, Num}], 24) of
                                                            [#goods{} | _] ->
                                                                NewSt = St#st_market_p{sell_num = St#st_market_p.sell_num + 1},
                                                                lib_dict:put(?PROC_STATUS_MARKET, NewSt),
                                                                market_load:update_market_p(NewSt),
                                                                1;
                                                            _Other ->
                                                                MarketPid ! {market_del_goods, Key},
                                                                0
                                                        end;
                                                    _ -> 0
                                                end
                                        end
                                end
                        end
                end,
            ?DEBUG("Ret:~p", [Ret]),
            {ok, Bin} = pt_310:write(31004, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        false ->
            {ok, Bin} = pt_310:write(31004, {16}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;


%%下架物品
handle(31006, Player, {Key}) ->
    ?CAST(market_proc:get_server_pid(), {market_sold_out, Player#player.key, Player#player.nickname, Player#player.sid, Key}),
    ok;

%%搜索上架物品
handle(31007, Player, {GoodsName}) ->
    ?CAST(market_proc:get_server_pid(), {market_search, Player#player.sid, GoodsName}),
    ok;

%%获取最低价格
handle(31008, Player, {GoodsId}) ->
    ?DEBUG("###31008 GoodsId:~p", [GoodsId]),
    ?CAST(market_proc:get_server_pid(), {get_price, Player#player.sid, GoodsId}),
    ok;

handle(_cmd, _player, _data) ->
    ok.


	