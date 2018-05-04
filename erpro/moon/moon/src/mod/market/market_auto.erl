%%----------------------------------------------------
%% @doc 市场自动出售货物模块
%%
%% <pre>
%% 市场自动出售货物模块
%% </pre> 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(market_auto).

-behaviour(gen_fsm).

-export([
        start_link/0
        ,next/1
    ]
).
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([
        idel/2
        ,sale/2
    ]
).

-include("common.hrl").
-include("market.hrl").
-include("item.hrl").

-record(state, {
        ts = 0              %% 进入某状态时刻
        ,timeout = 0    %% 空间时间(不是固定的)
    }).

%%----------------------------------------------------
%% 对外接口 
%%----------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 下一个状态
next(Event) ->
    gen_fsm:send_event(?MODULE, Event).

%%----------------------------------------------------
%% gen_fsm函数 
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    ?INFO("[~w] 启动完成", [?MODULE]),
    StartGameTime = sys_env:get(srv_open_time), %% 开服时间
    Now = util:unixtime(),
    case (Now + 3600) > (StartGameTime + 5 * 3600) of
        true ->
            {ok, idel, #state{ts = erlang:now(), timeout = ?market_auto_idel_time}, ?market_auto_idel_time};
        false ->
            IdelTime = ((StartGameTime + 5 * 3600) - Now) * 1000,
            {ok, idel, #state{ts = erlang:now(), timeout = IdelTime}, IdelTime}
    end.

handle_event(_Event, StateName, State) ->
    continue(StateName, State).

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    continue(StateName, Reply, State).

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    continue(StateName, State).

%%----------------------------------------------------
%% 状态函数 
%%----------------------------------------------------
idel(timeout, State) ->
    {next_state, sale, State#state{ts = erlang:now(), timeout = ?market_auto_sale_time}, ?market_auto_sale_time};
idel(_Any, State) ->
    continue(idel, State).

sale(timeout, State) ->
    All = market_data_auto:all(),
    case util:platform(undefined) of
        "taiwan" -> ignore;
        "taiwanxmfx" -> ignore;
        _ -> sale(All)
    end,
    {next_state, idel, State#state{ts = erlang:now(), timeout = ?market_auto_idel_time}, ?market_auto_idel_time};
sale(_Any, State) ->
    continue(sale, State).

%%----------------------------------------------------
%% 私有函数 
%%----------------------------------------------------
%% 出售
sale([]) -> ok;
sale([Id | T]) ->
    BaseTime = case sys_env:get(srv_open_time) of
        OpenTime when is_integer(OpenTime) -> OpenTime;
        _ -> 0
    end,
    NowVal = util:unixtime(),
    case market_data_auto:get(Id) of
        {ok, #market_auto_sale{valid_time = ValidTime}} when ValidTime =/= 0 andalso (ValidTime + BaseTime) < NowVal -> sale(T);
        {ok, #market_auto_sale{item_base_id = ItemBaseId, item_name = _ItemName, quantity = Quantity, time = Time, price_type = PriceType, price = Price, range = Range}} ->
            case item:make(ItemBaseId, 0, Quantity) of
                {ok, [Item = #item{id = ItemId}]} ->
                    {ok, #item_base{name = ItemBaseName}} = item_data:get(ItemBaseId),
                    {ok, SaleId} = key_mgr:generate(market_key_sale),
                    Now = util:unixtime(),
                    %% EndTime = Now + (Time * 60),
                    EndTime = Now + (Time * 60 * 60),
                    MarketType = market_data_type:item_type_to_market(Item#item.type, ItemBaseId),
                    TypeScort = case market_data_type:type_ref(MarketType) of
                        {ok, TScort} -> TScort;
                        _ ->
                            ?ERR("没找到物品类型对应信息[~w]", [MarketType]),
                            MarketType
                    end,
%%                    NewPrice = case {market:average_price(ItemBaseId), PriceType} of
%%                        {{false, _Reason}, _} -> Quantity * util:ceil(Price * (100 - Range + util:rand(1, Range * 2)) / 100);
%%                        {{?false, _GoldAverPrice}, ?assets_type_coin} -> Quantity * util:ceil(Price * (100 - Range + util:rand(1, Range * 2)) / 100);
%%                        {{_CoinAverPrice, ?false}, ?assets_type_gold} -> Quantity * util:ceil(Price * (100 - Range + util:rand(1, Range * 2)) / 100);
%%                        {{CoinAverPrice, _GoldAverPrice}, ?assets_type_coin} -> 
%%                            case CoinAverPrice > Price of
%%                                true -> Quantity * util:ceil(CoinAverPrice * (100 - util:rand(1, Range)) / 100);
%%                                false -> Quantity * util:ceil(CoinAverPrice * (100 + util:rand(1, Range)) / 100)
%%                            end;
%%                        {{_CoinAverPrice, GoldAverPrice}, ?assets_type_gold} -> 
%%                            case GoldAverPrice > Price of
%%                                true -> Quantity * util:ceil(GoldAverPrice * (100 - util:rand(1, Range)) / 100);
%%                                false -> Quantity * util:ceil(GoldAverPrice * (100 + util:rand(1, Range)) / 100)
%%                            end;
%%                        _ -> Quantity * util:ceil(Price * (100 - Range + util:rand(1, Range * 2)) / 100) 
%%                    end,
                    NewPrice = Quantity * util:ceil(Price * (100 - Range + util:rand(1, Range * 2)) / 100),
                    SrvId = case sys_env:get(srv_id) of
                        undefined -> <<>>;
                        ESrvId -> ESrvId
                    end,
                    MarketSale = #market_sale{sale_id = SaleId, role_id = ?market_sys_salerid, srv_id = SrvId, begin_time = Now, end_time = EndTime, assets_type = PriceType, price = NewPrice, price_tax = NewPrice, item_id = ItemId, item_base_id = ItemBaseId, item_name = ItemBaseName, type = Item#item.type, use_type = Item#item.use_type, bind = Item#item.bind, source = Item#item.source, quality = Item#item.quality, lev = Item#item.require_lev, career = Item#item.career, upgrade = Item#item.upgrade, enchant = Item#item.enchant, enchant_fail = Item#item.enchant_fail, quantity = Item#item.quantity, status = ?lock_release, pos = 0, lasttime = Now, durability = Item#item.durability, attr = Item#item.attr, special = Item#item.special, max_base_attr = Item#item.max_base_attr, saler_name = ?L(<<"系统">>), saler_lev = 1, type_scort = TypeScort, market_type = MarketType},
                    market:add_sale(MarketSale),
                    sale(T);
                _ ->
                    ?ERR("自动出售物品出错了[Id:~w]", [Id]),
                    sale(T)
            end;
        _->
            ?ERR("没有找到自动出售信息:~w", [Id]),
            sale(T)
    end.

%% 时间校正函数
continue(StateName, State = #state{ts = Ts, timeout = Timeout}) ->
    {next_state, StateName, State, util:time_left(Timeout, Ts)}.
continue(StateName, Reply, State = #state{ts = Ts, timeout = Timeout}) ->
    {reply, Reply, StateName, State, util:time_left(Timeout, Ts)}.
