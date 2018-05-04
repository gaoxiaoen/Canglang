%%----------------------------------------------------
%% 商城服务进程
%% 
%% @author mobin
%% @end
%%----------------------------------------------------
-module(shop).
-behaviour(gen_server).
-export([
        gm_reload/0
        ,list/1
        ,list_rank/0
        ,list_special/1
        ,get_id_by_base_id/1
        ,buy/4
        ,buy_quota/4
        ,buy_limited/3
        ,start_link/0
        ,item_price/1
        ,buy_fashion/5
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("assets.hrl").
-include("storage.hrl").
-include("shop.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("item.hrl").

%% 进程状态数据
-record(state, {
        gold_items = []           %% 晶钻商品
        ,bind_gold_items = []     %% 绑定晶钻商品
        ,fashion_items = []       %% 时装商品
        ,special_items = []       %% 优惠商品
        ,rank_items = []          %% 人气排行商品
        ,limit_info = []          %% 已抢购角色 {Id, Rid}
        ,quota_info = []          %% 已限购角色 {{Id, Rid}, Num}
    }
).

-define(seconds_of_day, 86400). 

%%----------------------------------------------------
%% gm命令
%%----------------------------------------------------
%% @doc 重新加载商品和清空玩家活动商品购买记录
gm_reload() ->
    gen_server:cast({global, ?MODULE}, reload).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec list(ItemsType) -> Items
%% @doc 根据类型获取商城中的普通商品列表
list(ItemsType) ->
    gen_server:call({global, ?MODULE}, {common_items, ItemsType}).

list_rank() ->
    gen_server:call({global, ?MODULE}, {rank_items}).

list_special(Rid) ->
    gen_server:call({global, ?MODULE}, {special_items, Rid}).

get_id_by_base_id(BaseId) ->
    gen_server:call({global, ?MODULE}, {get_id_by_base_id, BaseId}).

buy(Id, Num, Type, Role) ->
    gen_server:call({global, ?MODULE}, {buy, Id, Num, Type, Role}).

buy_quota(Id, Num, Type, Role) ->
    gen_server:call({global, ?MODULE}, {buy_quota, Id, Num, Type, Role}).

buy_limited(Id, Type, Role) ->
    gen_server:call({global, ?MODULE}, {buy_limited, Id, Type, Role}).

buy_fashion(Id, Expire, Attr_idx, DiscountBaseId, Role) ->
    gen_server:call({global, ?MODULE}, {buy_fashion, Id, Expire, Attr_idx, DiscountBaseId, Role}).

%% @spec start_link() -> ok
%% @doc 启动商城服务进程
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

%% 商城物品价格
item_price(ItemBaseId) ->
    Items = shop_data:common_items(),
    find_price(Items, ItemBaseId).

find_price([], _) -> false;
find_price([#shop_item{base_id = Id, type = 1, price = Price} | _T], Id) -> Price;
find_price([#shop_item{base_id = BaseId} | T], Id) when BaseId =/= Id ->
    find_price(T, Id).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    put(sell_list, []),
    State = reload_shop(#state{}),
    Tomorrow = util:unixtime(today) + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), tick),
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

%% 获取普通商品列表
handle_call({common_items, ItemsType}, _From, State = #state{gold_items = GoldItems, bind_gold_items = BindGoldItems, 
        fashion_items = FashionItems}) ->
    Items = case ItemsType of
        ?gold_item ->
            GoldItems;
        ?bind_gold_item ->
            BindGoldItems;
        ?fashion_item ->
            FashionItems
    end,
    {reply, Items, State};

%% 获取人气排行商品列表
handle_call({rank_items}, _From, State = #state{rank_items = RankItems}) ->
    {reply, RankItems, State};

%% 获取优惠商品列表
handle_call({special_items, Rid}, _From, State = #state{special_items = SpecialItems, quota_info = QuotaInfo}) ->
    {reply, set_quota(SpecialItems, Rid, QuotaInfo), State};

handle_call({get_id_by_base_id, BaseId}, _From, State = #state{gold_items = GoldItems}) ->
    Reply = case lists:keyfind(BaseId, #shop_item.base_id, GoldItems) of
        false -> 
            {false, ?MSGID(<<"不存在此物品，无法购买">>)};
        #shop_item{id = Id} ->
            Id
    end,
    {reply, Reply, State};

%% 购买商品
handle_call({buy, Id, Num, Type, Role = #role{assets = #assets{gold = Gold, gold_bind = BindGold}}},
    _From, State = #state{gold_items = GoldItems, bind_gold_items = BindGoldItems}) ->
    Reply = case Type of
        ?gold_item ->
            case lists:keyfind(Id, #shop_item.id, GoldItems) of
                false -> 
                    {false, ?MSGID(<<"不存在此物品，无法购买">>)};
                Item ->
                    buy_by_gold(Item, ?item_unbind, Num, Role, Gold)
            end;
        ?bind_gold_item ->
            case lists:keyfind(Id, #shop_item.id, BindGoldItems) of
                false -> 
                    {false, ?MSGID(<<"不存在此物品，无法购买">>)};
                Item ->
                    buy_by_bind_gold(Item, ?item_bind, Num, Role, BindGold)
            end;
        ?fashion_item -> %% 时装特殊处理
            {false, ?MSGID(<<"不存在此物品，无法购买">>)};
        _ ->
            ?ERR("不存在此物品~p", [Type]),
            {false, ?MSGID(<<"不存在此物品，无法购买">>)}
    end,
    %%记录销售情况
    case Reply of
        {false, _} ->
            ok;
        _ ->
            SellList = get(sell_list),
            SellList2 = case lists:keyfind(Id, 1, SellList) of
                false ->
                    [{Id, Num} | SellList];
                {_, Count} ->
                    lists:keyreplace(Id, 1, SellList, {Id, Count + Num})
            end,
            ?DEBUG("sell_list, ~w~n", [SellList2]),
            put(sell_list, SellList2)
    end,
    {reply, Reply, State};

%% 购买抢购商品
handle_call({buy_limited, Id, Type, Role = #role{id = Rid, assets = #assets{gold = Gold, gold_bind = BindGold}}},
    _From, State = #state{special_items = SpecialItems, limit_info = LimitInfo}) ->
    case get_limit_item(Id, Rid, LimitInfo, SpecialItems) of
        {false, Reason} ->
            {reply, {false, Reason}, State};
        {ok, Item = #shop_item{count = Count}} ->
            Result = case Type of
                ?special_item ->
                    buy_by_gold(Item, ?item_bind, 1, Role, Gold);
                ?bind_special_item ->
                    buy_by_bind_gold(Item, ?item_bind, 1, Role, BindGold)
            end,
            case Result of
                {false, Reason} ->
                    {reply, {false, Reason}, State};
                Reply ->
                    SpecialItems2 = lists:keyreplace(Id, #shop_item.id, SpecialItems, Item#shop_item{count = Count - 1}),
                    ?DEBUG("limit_info, ~w~n", [[{Id, Rid} | LimitInfo]]),
                    {reply, Reply, State#state{special_items = SpecialItems2, limit_info = [{Id, Rid} | LimitInfo]}}
            end
    end;

%% 购买限购商品
handle_call({buy_quota, Id, Num, Type, Role = #role{id = Rid, assets = #assets{gold = Gold, gold_bind = BindGold}}},
    _From, State = #state{special_items = SpecialItems, quota_info = QuotaInfo}) ->
    case get_quota_item(Id, Rid, QuotaInfo, Num, SpecialItems) of
        {false, Reason} ->
            {reply, {false, Reason}, State};
        {ok, Item} ->
            Result = case Type of
                ?special_item ->
                    buy_by_gold(Item, ?item_bind, Num, Role, Gold);
                ?bind_special_item ->
                    buy_by_bind_gold(Item, ?item_bind, Num, Role, BindGold)
            end,
            case Result of
                {false, Reason} ->
                    {reply, {false, Reason}, State};
                Reply ->
                    QuotaInfo2 = case lists:keyfind({Id, Rid}, 1, QuotaInfo) of
                        false ->
                            [{{Id, Rid}, Num} | QuotaInfo];
                        {_, BoughtNum} ->
                            lists:keyreplace({Id, Rid}, 1, QuotaInfo, {{Id, Rid}, BoughtNum + Num})
                    end,
                    ?DEBUG("quota_info, ~w~n", [QuotaInfo2]),
                    {reply, Reply, State#state{quota_info = QuotaInfo2}}
            end
    end;


%% 购买时装
handle_call({buy_fashion, Id, Expire, Attr_idx, DiscountBaseId, Role = #role{assets = #assets{gold = Gold}}}, 
    _From, State = #state{fashion_items = FashionItems}) ->
    Reply =
    case lists:keyfind(Id, #shop_item.id, FashionItems) of
        false -> 
            {false, ?MSGID(<<"不存在此物品，无法购买">>)};
        #shop_item{base_id = BaseId} ->
            case check_fashion_attr(BaseId, Attr_idx) of
                {ok, SelectAttr} ->
                    case check_fashion_expire(BaseId, Expire) of
                        {ok, Price} ->
                            Price1 = case DiscountBaseId =/= 0 of true -> round(Price * 0.8); false -> Price end,
                            buy_fashion_by_gold(BaseId, Price1, 1, Expire, SelectAttr, Role, Gold);
                        {false, ReasonId} ->
                            {false, ReasonId}
                    end;
                {false, ReasonId} ->
                    {false, ReasonId}
            end
    end,

    %%记录销售情况
    case Reply of
        {false, _} ->
            ok;
        _ ->
            SellList = get(sell_list),
            SellList2 = case lists:keyfind(Id, 1, SellList) of
                false ->
                    [{Id, 1} | SellList];
                {_, Count} ->
                    lists:keyreplace(Id, 1, SellList, {Id, Count + 1})
            end,
            ?DEBUG("sell_list, ~w~n", [SellList2]),
            put(sell_list, SellList2)
    end,
    {reply, Reply, State};


handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 重新加载商城物品
handle_cast(reload, State) ->
    {noreply, reload_shop(State)};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 定时轮循
handle_info(tick, State = #state{}) ->
    State2 = reload_shop(State),
    Tomorrow = util:unixtime(today) + ?seconds_of_day + 1,
    Now = util:unixtime(),
    erlang:send_after((Tomorrow - Now) * 1000, self(), tick),
    {noreply, State2}; 

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% 重新加截物品
reload_shop(State) ->
    %% 开服物品
    SpecialItems = case day_diff(sys_env:get(srv_open_time), util:unixtime()) of
        Day when Day >= 0 andalso Day =< 6 ->
            shop_data:open_items(Day + 1);
        _ ->
            []
    end,
    
    %% 每天物品
    SpecialItems2 = case SpecialItems of
        [] ->
            DayOfWeek = calendar:day_of_the_week(date()),
            shop_data:week_items(DayOfWeek);
        _ ->
            SpecialItems
    end,
    
    %% 普通优惠物品
    SpecialItems3 = case SpecialItems2 of
        [] ->
            Count = get_special_items_count(),
            get_special_items(Count, shop_data:special_items_info());
        _ ->
            SpecialItems2
    end,
    
    SortFun = fun(#shop_item{id = Id1, label = Label1}, #shop_item{id = Id2, label = Label2}) ->
            if
                Label1 > Label2 ->
                    true;
                Label1 =:= Label2 ->
                    Id1 < Id2;
                Label1 < Label2 ->
                    false
            end
    end,
    SpecialItems4 = lists:sort(SortFun, SpecialItems3),

    %%普通物品销售记录，用于排行[{Id, SellCount}]
    SellList = get(sell_list),
    SellList2 = lists:sort(fun({_, Count1}, {_, Count2}) -> Count1 > Count2 end, SellList),
    SellList3 = lists:sublist(SellList2, 8),

    {RankItems, CommonItems} = set_rank(SellList3, shop_data:common_items()),

    CommonItems2 = lists:sort(SortFun, CommonItems),
    GoldItems = [Item || Item = #shop_item{type = Type} <- CommonItems2, Type =:= ?gold_item],
    BindGoldItems = [Item || Item = #shop_item{type = Type} <- CommonItems2, Type =:= ?bind_gold_item],
    FashionItems = [Item || Item = #shop_item{type = Type} <- CommonItems2, Type =:= ?fashion_item],

    put(sell_list, []),

    State#state{
        gold_items = GoldItems
        ,bind_gold_items = BindGoldItems
        ,fashion_items = FashionItems
        ,special_items = SpecialItems4
        ,rank_items = lists:sublist(RankItems, 4)
        ,quota_info = []
        ,limit_info = []
    }.

set_rank(SellList, CommonItems) ->
    set_rank(SellList, CommonItems, []).
set_rank([], CommonItems, Return) ->
    {lists:reverse(Return), CommonItems};
set_rank([{Id, _} | T], CommonItems, Return) ->
    case lists:keyfind(Id, #shop_item.id, CommonItems) of
        false ->
            set_rank(T, CommonItems, Return);
        Item ->
            %%根据排行设置为热卖
            Item2 = Item#shop_item{label = 3},
            CommonItems2 = lists:keyreplace(Id, #shop_item.id, CommonItems, Item2),
            set_rank(T, CommonItems2, [Item2 | Return])
    end.

get_special_items_count() ->
    CountList = [{2, 25}, {3, 25}, {4, 50}],

    RandList = [Rand || {_, Rand} <- CountList, Rand > 0], %% 随机列表
    SumRand = lists:sum(RandList),
    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    Count = get_special_items_count(RandValue, CountList),
    Count.
get_special_items_count(RandValue, [{Count, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Count;
get_special_items_count(RandValue, [{_, Rand} | T]) ->
    get_special_items_count(RandValue - Rand, T).

get_special_items(Count, SpecialItemsInfo) ->
    RandList = [Rand || {_, Rand} <- SpecialItemsInfo, Rand > 0], %% 随机列表
    SumRand = lists:sum(RandList),
    get_special_items(Count, SumRand, SpecialItemsInfo, []).
get_special_items(Count, _, _, Return) when Count =:= 0 ->
    Return;
get_special_items(Count, SumRand, SpecialItemsInfo, Return) ->
    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    {SpecialItem, Rand} = get_special_item(RandValue, SpecialItemsInfo),
    SpecialItemsInfo2 = lists:keydelete(SpecialItem, 1, SpecialItemsInfo),
    get_special_items(Count - 1, SumRand - Rand, SpecialItemsInfo2, [SpecialItem | Return]).

get_special_item(RandValue, [{SpecialItem, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    {SpecialItem, Rand};
get_special_item(RandValue, [{_, Rand} | T]) ->
    get_special_item(RandValue - Rand, T).
   

%% @spec day_diff(UnixTime, UnixTime) -> int()
%% @doc 两个unixtime相差的天数,同一天内则返回0
%% return int() 相差的天数
day_diff(FromTime, ToTime) when ToTime > FromTime ->
    FromDate = util:unixtime({today, FromTime}),
    ToDate = util:unixtime({today, ToTime}),
    case (ToDate - FromDate) / (3600 * 24) of
        Diff when Diff < 0 -> 0;
        Diff -> round(Diff)
    end;
day_diff(FromTime, ToTime) when ToTime=:=FromTime ->
    0;
day_diff(FromTime, ToTime) ->
    day_diff(ToTime, FromTime).

set_quota(SpecialItems, Rid, QuotaInfo) ->
    set_quota(SpecialItems, Rid, QuotaInfo, []).
set_quota([], _, _, Return) ->
    lists:reverse(Return);
set_quota([Item | T], Rid, QuotaInfo, Return) ->
    case lists:keyfind({Item#shop_item.id, Rid}, 1, QuotaInfo) of
        false ->
            set_quota(T, Rid, QuotaInfo, [Item | Return]);
        {_, Num} ->
            set_quota(T, Rid, QuotaInfo, [Item#shop_item{count = Item#shop_item.count - Num} | Return])
    end.

buy_by_gold(#shop_item{base_id = BaseId, price = Price, type = Type}, BindType, Num, Role = #role{assets = Assets}, Money) ->
    Money2 = Money - (Price * Num), %% 剩余
    case Money2 >= 0 of
        false -> 
            {false, ?MSGID(<<"晶钻不足">>)};
        true ->
            case create_item(BaseId, BindType, Num, Role) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewBag, Items} ->
                    log:log(log_shop, {BaseId, Num, Type, 0, (Price * Num), Role}),
                    {ok, log_gold, Items, Assets#assets{gold = Money2}, NewBag}
            end
    end.

buy_by_bind_gold(#shop_item{base_id = BaseId, price = Price, type = Type}, BindType, Num, Role = #role{assets = Assets}, Money) ->
    Money2 = Money - (Price * Num), %% 剩余
    case Money2 >= 0 of
        false -> 
            {false, ?MSGID(<<"绑定晶钻不足，无法购买">>)};
        true ->
            case create_item(BaseId, BindType, Num, Role) of
                {false, Reason} ->
                    {false, Reason};
                {ok, NewBag, Items} ->
                    log:log(log_shop, {BaseId, Num, Type, 1, (Price * Num), Role}),
                    {ok, log_bind_gold, Items, Assets#assets{gold_bind = Money2}, NewBag}
            end
    end.

buy_fashion_by_gold(BaseId, Price, BindType, Expire, SelectAttr, Role = #role{assets = Assets}, Money) ->
    Money2 = Money - Price, %% 剩余
    case Money2 >= 0 of
        false -> 
            {false, ?MSGID(<<"晶钻不足">>)};
        true ->
            case item:make(BaseId, BindType, 1) of
                false ->
                    {false, ?MSGID(<<"物品数据异常，购买失败">>)};
                {ok, [Item = #item{attr = Attr, special = Spec}]} ->
                    Item1 = Item#item{special = [{?special_expire_time, dress:expire_idx_to_seconds(Expire)} | Spec], attr = [SelectAttr | Attr],
                        durability = util:unixtime()},
                    log:log(log_shop, {BaseId, 1, 3, 0, Price, Role}),
                    {ok, log_gold, Item1, Assets#assets{gold = Money2}}
                 
            end
    end.

create_item(BaseId, BindType, Num, Role) -> 
    case item:make(BaseId, BindType, Num) of
        false ->
            {false, ?MSGID(<<"物品数据异常，购买失败">>)};
        {ok, Items} ->
            case storage:add(bag, Role, Items) of
                false -> 
                    {false, ?MSGID(<<"你的背包空间不足，购买失败">>)};
                {ok, NewBag} ->
                    {ok, NewBag, Items}
            end
    end.

get_limit_item(Id, Rid, LimitInfo, Items) ->
    case lists:keyfind(Id, #shop_item.id, Items) of
        false -> 
            {false, ?MSGID(<<"不存在此物品，无法购买">>)};
        Item ->
            check_limit(Id, Rid, LimitInfo, Item)
    end.

check_limit(_Id, _Rid, _LimitInfo, _Item = #shop_item{count = Count}) when Count < 1 ->
    {false, ?MSGID(<<"抢购商品已经售完">>)};
check_limit(Id, Rid, LimitInfo, Item) ->
    case lists:member({Id, Rid}, LimitInfo) of
        true ->
            {false, ?MSGID(<<"你已经达到了当天的抢购上限，你无法再购买。敬请关注下一次抢购商品">>)};
        false ->
            {ok, Item}
    end.

get_quota_item(Id, Rid, QuotaInfo, Num, Items) ->
    case lists:keyfind(Id, #shop_item.id, Items) of
        false -> 
            {false, ?MSGID(<<"不存在此物品，无法购买">>)};
        Item ->
            check_quota(Id, Rid, QuotaInfo, Item, Num)
    end.

check_quota(Id, Rid, QuotaInfo, Item = #shop_item{count = Count}, Num) ->
    BoughtNum = case lists:keyfind({Id, Rid}, 1, QuotaInfo) of
        false -> 0;
        {_, _BoughtNum} -> _BoughtNum
    end,
    case BoughtNum + Num > Count of
        true -> 
            {false, ?MSGID(<<"超过了今天的购买上限，无法购买">>)};
        false ->
            {ok, Item}
    end.

check_fashion_expire(BaseId, Expire) ->
    {ok, #item_base{value = Value}} = item_data:get(BaseId),
    case lists:keyfind(buy_npc, 1, Value) of
        {buy_npc, Price} ->
            case lists:keyfind(Expire, 1, Price) of
                {Expire, Gold} -> {ok,Gold};
                false ->
                    ?ERR(" [~w] 物品没有价格 ", [BaseId]),
                    {false, ?MSGID(<<"不存在此物品，无法购买">>)}
            end;
        false ->
            ?ERR("  购买失败，没配价格"),
            {false, ?MSGID(<<"不存在此物品，无法购买">>)}
    end.

check_fashion_attr(BaseId, Attr_idx) ->
    {ok, #item_base{effect = Effect}} = item_data:get(BaseId),
    case lists:keyfind(Attr_idx, 1, Effect) of
        A = {Attr_idx, _, _} -> {ok, A};
        false ->
            {false, ?MSGID(<<"不存在此属性，无法购买">>)}
    end.

