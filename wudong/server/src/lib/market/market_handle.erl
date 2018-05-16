%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. 十一月 2015 10:58
%%%-------------------------------------------------------------------
-module(market_handle).
-author("hxming").
-include("common.hrl").
-include("market.hrl").
-include("server.hrl").
-include("goods.hrl").
-include("achieve.hrl").

%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%交易所购买
handle_call({market_buy, Player, Key}, _From, State) ->
    {Ret, Price, NewState, GoodsId, Num} =
        case data_channel_limit:get(Player#player.pf) of
            true -> {2, 0, State, 0, 0};
            false ->
                case lists:keytake(Key, #market.mkey, State#st_market.market_list) of
                    false -> {3, 0, State, 0, 0};
                    {value, Market, T} ->
                        Now = util:unixtime(),
                        if Market#market.time < Now -> {4, 0, State, 0, 0};
                            Market#market.pkey == Player#player.key -> {5, 0, State, 0, 0};
                            Player#player.is_interior == 1 -> {0, 0, State, 0, 0};
                            true ->
                                case money:is_enough(Player, Market#market.price, gold) of
                                    false -> {6, 0, State, 0, 0};
                                    true ->
                                        GiveGoods = #give_goods{goods_id = Market#market.goods_id, num = Market#market.num, args = Market#market.args,bind = 0, from = 32},
                                        mail:sys_send_mail([Player#player.key], ?T("集市购买"), ?T("这是你购买的物品,请查收!"), [GiveGoods]),
                                        Msg = io_lib:format(?T("您集市的~s成功售出,已扣除上架时~p元宝的手续费,请查收!"), [goods_util:get_goods_name(Market#market.goods_id), Market#market.tip]),
                                        Gold = max(0, Market#market.price - Market#market.tip),
                                        GiveGoods1 = #give_goods{goods_id = ?GOODS_ID_GOLD, num = Gold, bind = 0, from = 24},
                                        mail:sys_send_mail([Market#market.pkey], ?T("集市出售"), Msg, [GiveGoods1]),
                                        market_load:del_market(Key),
                                        market_load:log_market(Player#player.key, Player#player.nickname, 4, Market#market.goods_id, Market#market.num, Market#market.price, Now),
                                        achieve:trigger_achieve(Market#market.pkey, ?ACHIEVE_TYPE_4, ?ACHIEVE_SUBTYPE_4014, 0, Gold),
                                        market:update_sell_num(Market),
                                        Sql = io_lib:format("replace into log_market_buy set pkey=~p, mkey=~p, goods_id=~p, goods_num=~p, price=~p, sell_pkey=~p, sell_args='~s', time=~p",
                                            [Player#player.key, Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.price, Market#market.pkey, util:term_to_bitstring(Market#market.args), util:unixtime()]),
                                        log_proc:log(Sql),
                                        {1, Market#market.price, State#st_market{market_list = T}, Market#market.goods_id, Market#market.num}
                                end
                        end
                end
        end,
    {reply, {ok, Ret, Price, GoodsId, Num}, NewState};

%%出售
handle_call({market_sell_goods, Player, GoodsType, Num, Price, Time,SellArgs}, _From, State) ->
    Now = util:unixtime(),
    Market = #market{
        mkey = misc:unique_key(),
        pkey = Player#player.key,
        price = Price,
        goods_id = GoodsType#goods_type.goods_id,
        goods_name = GoodsType#goods_type.goods_name,
        num = Num,
        args = SellArgs,
        tip = market_util:get_tip(Player, Price),
        time = Now + Time,
        type = GoodsType#goods_type.market_type,
        subtype = GoodsType#goods_type.market_subtype
    },
    market_load:log_market(Player#player.key, Player#player.nickname, 1, Market#market.goods_id, Market#market.num, Market#market.price, Now),
    market_load:new_market(Market),
    MarketList = [Market | State#st_market.market_list],
    Sql = io_lib:format("replace into log_market_sell set pkey=~p, mkey=~p, goods_id=~p, goods_num=~p, price=~p, sell_args='~s', time=~p",
        [Market#market.pkey, Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.price, util:term_to_bitstring(Market#market.args), util:unixtime()]),
    log_proc:log(Sql),
    {reply, {ok, Market#market.mkey}, State#st_market{market_list = MarketList}};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%交易所列表
handle_cast({market_list, Sid, Pf, IsInterior, Type, SubType}, State) ->
    Data =
        case data_channel_limit:get(Pf) == true orelse IsInterior == 1 of
            true -> [];
            false ->
                Now = util:unixtime(),
                MarketList =
                    if Type == 0 ->
                        market_init:get_market_list_top50(State#st_market.market_list, Now);
                        true ->
                            case SubType of
                                0 -> market_init:get_market_by_type(State#st_market.market_list, Type, Now);
                                _ -> market_init:get_market_by_subtype(State#st_market.market_list, Type, SubType, Now)
                            end
                    end,
                F = fun(Market) ->
                    Cd = max(0, Market#market.time - Now),
                    {NewColor,Sex,Combat_power,FixAttrList,RandAttrList} = equip_random:parse_sell_args(Market#market.args),
                    FixAttrListPack = [[attribute_util:attr_tans_client(AttType), Value] || {AttType, Value} <- FixAttrList],
                    RandAttrListPack = [[attribute_util:attr_tans_client(AttType), Value] || {AttType, Value} <- RandAttrList],
                    [Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.price, Cd,NewColor,Sex,Combat_power,FixAttrListPack,RandAttrListPack]
                    end,
                lists:map(F, MarketList)
        end,
    {ok, Bin} = pt_310:write(31001, {Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%我的出售列表
handle_cast({sell_list, Pkey, Sid}, State) ->
    Now = util:unixtime(),
    F = fun(Market) ->
        Cd = max(0, Market#market.time - Now),
        {NewColor,Sex,Combat_power,FixAttrList,RandAttrList} = equip_random:parse_sell_args(Market#market.args),
        FixAttrListPack = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- FixAttrList],
        RandAttrListPack = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- RandAttrList],
        [Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.price, Cd,NewColor,Sex,Combat_power,FixAttrListPack,RandAttrListPack]
        end,
    Data = lists:map(F, market_init:get_market_by_pkey(State#st_market.market_list, Pkey, Now)),
    {ok, Bin} = pt_310:write(31003, {1, Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

%%下架物品
handle_cast({market_sold_out, Pkey, Nickname, Sid, Key}, State) ->
    {Ret, NewState} =
        case lists:keytake(Key, #market.mkey, State#st_market.market_list) of
            false -> {11, State};
            {value, Market, T} ->
                if Market#market.pkey /= Pkey -> {12, State};
                    true ->
                        market_load:del_market(Key),
                        GiveGoods = #give_goods{goods_id = Market#market.goods_id, num = Market#market.num, args = Market#market.args,bind = 0, from = 240},
                        mail:sys_send_mail([Pkey], ?T("集市下架"), ?T("这是您取消下架的物品,请查收!"), [GiveGoods]),
                        market_load:log_market(Pkey, Nickname, 2, Market#market.goods_id, Market#market.num, Market#market.price, util:unixtime()),
                        Sql = io_lib:format("replace into log_market_sell_out set pkey=~p, mkey=~p, goods_id=~p,goods_num=~p, time=~p",
                            [Pkey, Key, Market#market.goods_id, Market#market.num, util:unixtime()]),
                        log_proc:log(Sql),
                        {1, State#st_market{market_list = T}}
                end
        end,
    {ok, Bin} = pt_310:write(31006, {Ret}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, NewState};


handle_cast({market_search, Sid, GoodsName}, State) ->
    Now = util:unixtime(),
    F = fun(Market) ->
        case market_util:match_name(unicode:characters_to_list(GoodsName), unicode:characters_to_list(util:make_sure_list(Market#market.goods_name))) of
            true ->
                Cd = max(0, Market#market.time - Now),
                {NewColor,Sex,Combat_power,FixAttrList,RandAttrList} = equip_random:parse_sell_args(Market#market.args),
                FixAttrListPack = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- FixAttrList],
                RandAttrListPack = [[attribute_util:attr_tans_client(Type), Value] || {Type, Value} <- RandAttrList],
                [[Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.price, Cd,NewColor,Sex,Combat_power,FixAttrListPack,RandAttrListPack]];
            false -> []
        end
        end,
    Data = lists:flatmap(F, market_init:get_market_list(State#st_market.market_list, Now)),
    {ok, Bin} = pt_310:write(31007, {Data}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};


handle_cast({get_price, Sid, GoodsId}, State) ->
    Now = util:unixtime(),
    F = fun(Market) ->
        if
            Market#market.num == 0 -> [];
            Market#market.goods_id == GoodsId -> [util:ceil(Market#market.price / Market#market.num)];
            true -> []
        end
        end,
    Data = lists:flatmap(F, market_init:get_market_list(State#st_market.market_list, Now)),
    Price = case Data of
                [] -> 0;
                _ -> lists:min(Data)
            end,
    ?DEBUG("GoodsId ~p~n Price ~p~n", [GoodsId, Price]),
    {ok, Bin} = pt_310:write(31008, {GoodsId, Price}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(init, State) ->
    MarketList = market_init:init(),
    {noreply, State#st_market{market_list = MarketList}};

handle_info(timeout, State) ->
    market_proc:set_timeout(),
    Now = util:unixtime(),
    F = fun(Market, L) ->
        if Market#market.time < Now ->
            send_mail(Market),
            L;
            true ->
                [Market | L]
        end
        end,
    MarketList = lists:foldl(F, [], State#st_market.market_list),
    {noreply, State#st_market{market_list = MarketList}};

handle_info(cmd_sold_out, State) ->
    market_proc:set_timeout(),
    F = fun(Market, L) ->
        send_mail(Market),
        L
        end,
    lists:foldl(F, [], State#st_market.market_list),
    {noreply, State#st_market{market_list = []}};

%%删除商品
handle_info({market_del_goods, Key}, State) ->
    MarketList =
        case lists:keytake(Key, #market.mkey, State#st_market.market_list) of
            false -> State#st_market.market_list;
            {value, _Market, T} ->
                market_load:del_market(Key),
                T
        end,
    {noreply, State#st_market{market_list = MarketList}};

handle_info(_Info, State) ->
    {noreply, State}.

send_mail(Market) ->
    market_load:del_market(Market#market.mkey),
    GiveGoods = #give_goods{goods_id = Market#market.goods_id, num = Market#market.num, bind = 0, args = Market#market.args,from = 55},
    mail:sys_send_mail([Market#market.pkey], ?T("集市物品到期"), ?T("您上架的物品已到期,请查收!"), [GiveGoods]),
    Sql = io_lib:format("replace into log_market_past_due set pkey=~p, mkey=~p, goods_id=~p, goods_num=~p, sell_args='~s', price=~p, time=~p",
        [Market#market.pkey, Market#market.mkey, Market#market.goods_id, Market#market.num, Market#market.args, Market#market.price, util:unixtime()]),
    log_proc:log(Sql).