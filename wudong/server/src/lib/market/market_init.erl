%%%-------------------------------------------------------------------
%%% @author and_me
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十月 2015 15:23
%%%-------------------------------------------------------------------
-module(market_init).
-author("and_me").

-include("market.hrl").
-include("server.hrl").
-include("common.hrl").
-include("goods.hrl").

%% API
-compile(export_all).

init(#player{key = Pkey} = Player) ->
    St = market_load:load_market_p(Pkey),
    lib_dict:put(?PROC_STATUS_MARKET, St),
    market:update(),
    Player.

init() ->
    Fun = fun([Key, Pkey, GoodsId, Num, Price, Tip, Args, Time]) ->
        {Type, SubType, GoodsName} = get_goods_info(GoodsId),
        NewArgs =
            case Args of
                null -> [];
                _ -> util:bitstring_to_term(Args)
            end,
        #market{
            mkey = Key,
            pkey = Pkey,
            goods_id = GoodsId,
            goods_name = GoodsName,
            num = Num,
            price = Price,
            tip = Tip,
            args = NewArgs,
            time = Time,
            type = Type,
            subtype = SubType
        }
          end,
    lists:map(Fun, market_load:load_market()).

get_goods_info(GoodsId) ->
    case data_goods:get(GoodsId) of
        [] -> {0, 0, <<>>};
        GoodsType ->
            {GoodsType#goods_type.market_type, GoodsType#goods_type.market_subtype, GoodsType#goods_type.goods_name}
    end.



get_market_list(MarketList, Now) ->
    [Market || Market <- MarketList, Market#market.time > Now].

get_market_list_top50(MarketList, Now) ->
    L = lists:keysort(#market.time, [Market || Market <- MarketList, Market#market.time > Now]),
    lists:sublist(L, 50).

get_market_by_type(MarketList, Type, Now) ->
    [Market || Market <- MarketList, Market#market.type == Type, Market#market.time > Now].

get_market_by_subtype(MarketList, Type, Subtype, Now) ->
    [Market || Market <- MarketList, Market#market.type == Type, Market#market.subtype == Subtype, Market#market.time > Now].

%%获取玩家售卖的物品
get_market_by_pkey(MarketList, Pkey, Now) ->
    [Market || Market <- MarketList, Market#market.pkey == Pkey, Market#market.time > Now].



