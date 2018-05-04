%%----------------------------------------------------
%% @doc market_mgr
%%
%% <pre>
%% 市场全局进程
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%---------------------------------------------------
-module(market).

-behaviour(gen_server).

-export([
        search/2
        ,sale/3
        ,cancle_sale/2
        ,get_sale_count/2
        ,reload/0

        ,add_sale/1
        ,delete_sale/1
        ,sale_buy/2

        ,buy/3
        ,cancle_buy/2
        ,buy_sale/3
        ,buy_receive_item/2

        ,start_link/0
        
        ,add_price_tax/1

        ,sale_pay_for/3
        ,delete_expire/2
        ,send_sale_msg/2
        ,average_price/1
        ,print_size/0
        ,save_avgprice/0
        ,eprof_start/0
        ,eprof_stop/0
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include_lib("stdlib/include/ms_transform.hrl").

-include("common.hrl").
-include("role_online.hrl").
-include("market.hrl").
%%
-include("role.hrl").
-include("storage.hrl").
-include("item.hrl").
-include("assets.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("condition.hrl").
-include("chat_rpc.hrl").
-include("mail.hrl").
-include("vip.hrl").

-define(time_tick, 10 * 60 * 1000). %% 10分钟 检查一次过期物品
-define(time_tick_avg, 55 * 60 * 1000). %% 60分钟 保存市场均价内容 

-define(sale_columns, {'$1','$2','$3','$4','$5','$6','$7','$8','$9','$10','$11','$12','$13','$14','$15','$16','$17','$18','$19','$20','$21','$22','$23','$24','$25','$26','$27','$28', '$29', '$30', '$31', '$32', '$33', '$34', '$35'}). %% 拍卖信息表字段 
-define(sale_columns_new, {'$1','$2','$3','$4','$5','$6','$7','$8','$9','$10','$11','$12','$13','$14', '$15'}). %% 拍卖信息表字段 
-define(buy_columns, {'$1','$2','$3','$4','$5','$6','$7','$8','$9','$10','$11','$12','$13','$14','$15','$16','$17', '$18'}).


-record(state, {
    }).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------
%% 查询拍卖物品 
%% 通过ID获取求购信息
search(same_id, {ItemBaseId,PageIndex}) ->
    gen_server:call(?MODULE, {same_id, ItemBaseId, PageIndex});

search(sale, {Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex, SortType}) ->
    ?CATCH(gen_server:call(?MODULE, {search_sale, Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex, SortType}));

search(sale, {Type, PageIndex}) ->
    gen_server:call(?MODULE, {search_sale, Type, PageIndex});

%% 查询我拍卖的物品
search(sale_self, {RoleId, SrvId}) ->
    ?CATCH(gen_server:call(?MODULE, {search_sale_self, RoleId, SrvId}));

%% 通过ID查询拍卖物品
search(search_sale_by_id, {SaleId}) ->
    gen_server:call(?MODULE, {search_sale_by_id, SaleId});

%% 查询求购信息
search(buy, {Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex}) ->
    gen_server:call(?MODULE, {search_buy, Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex});

%% 查询自己求购的信息
search(buy_self, {RoleId, SrvId}) ->
    gen_server:call(?MODULE, {search_buy_self, RoleId, SrvId});

%% 通过ID获取求购信息
search(buy_by_id, {BuyId}) ->
    gen_server:call(?MODULE, {search_buy_by_id, BuyId}).

%% 拍卖物品
% sale(item, Role, {ItemId, AssetsType, Price, Time, Notice}) ->
%     case check_sale(status, Role, {ItemId, AssetsType, Price, Time, 0, Notice}) of
%         {ok} ->
%             case do_sale_spend(sale_tax, Role, {ItemId, AssetsType, Price, Time, 0, Notice}) of
%                 {ok, NewRole} ->
%                     issue_sale(item, NewRole, {ItemId, AssetsType, Price, Time, 0, Notice});
%                 {false, Reason} ->
%                     {false, Reason}
%             end;
%         {false, Reason} ->
%             {false, Reason}
%     end;
%% 出售物品
sale(item, Role, {ItemId, Origin_Price, Quantity, Notice}) ->
    case do_sale_spend2(sale_tax, Role, Origin_Price, Notice) of
        {ok, NewRole} ->
            NPrice = add_price_tax(Origin_Price), 
            issue_sale2(item, NewRole, {ItemId, Origin_Price, NPrice, Quantity, Notice});
        {false, Reason} ->
            {false, Reason}
    end;


%% 拍卖晶钻
sale(gold, Role, {GoldNum, Price, Time, Notice}) ->
    case check_sale(status, Role, {?market_gold_id, ?assets_type_coin, Price, Time, GoldNum, Notice}) of
        {ok} ->
            case do_sale_spend(sale_tax, Role, {?market_gold_id, ?assets_type_coin, Price, Time, GoldNum, Notice}) of
                {ok, NewRole} ->
                    issue_sale(gold, NewRole, {?market_gold_id, ?assets_type_coin, Price, Time, GoldNum, Notice});
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 拍卖金币
sale(coin, Role, {CoinNum, Price, Time, Notice}) ->
    case check_sale(status, Role, {?market_coin_id, ?assets_type_gold, Price, Time, CoinNum, Notice}) of
        {ok} ->
            case do_sale_spend(sale_tax, Role, {?market_coin_id, ?assets_type_gold, Price, Time, CoinNum, Notice}) of
                {ok, NewRole} ->
                    issue_sale(coin, NewRole, {?market_coin_id, ?assets_type_gold, Price, Time, CoinNum, Notice});
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% 取消拍卖
cancle_sale(Role = #role{id = {RoleId, SrvId}}, SaleId) ->
    Result = ?CATCH(gen_server:call(?MODULE, {cancle_sale, RoleId, SrvId, SaleId})),
    ?DEBUG("取消拍卖：已删除拍卖记录:~w~n",[Result]),
    case Result of
        {ok, _MarketSale = #market_sale2{item_base_id = ItemBaseId, quantity = Quantity}} ->
            ?DEBUG("取消拍卖:物品[ItemBaseId:~w, Quantity:~w]", [ItemBaseId, Quantity]),
            case storage:make_and_add_fresh(ItemBaseId, 0, Quantity, Role) of
                {ok, NewRole, _} -> 
                    % NewRole2 = role_listener:get_item(NewRole, #item{base_id = ItemBaseId, quantity = Quantity}),
                    {ok, NewRole};
                {_, Reason} ->
                    {false, Reason} 
            end;
        {false, Reason} ->
            ?DEBUG("取消拍卖：已删除拍卖记录"),
            {false, Reason}
    end.

%% 取角色拍卖数量
get_sale_count(RoleId, SrvId) ->
    gen_server:call(?MODULE, {sale_count, RoleId, SrvId}).

%% 向全局进程添加拍卖记录
add_sale(MarketSale) ->
    gen_server:call(?MODULE, {add_sale, MarketSale}).

%% 删除拍卖物品
delete_sale(SaleId) ->
    gen_server:call(?MODULE, {delete_sale, SaleId}).

%% 购买出售物品
sale_buy(Role, SaleId) ->
    % ?DEBUG("**sale_buy***购买出售物品*:~w~n",["ok"]),
    Result = search(search_sale_by_id, {SaleId}),
    case length(Result) =:= 1 of
        true ->
            [MarketSale] = Result,
            case check_sale_buy(end_time, Role, {MarketSale}) of
                {ok} ->
                    case do_sale_buy(delete_sale, Role, {MarketSale}) of
                        {ok, NewRole} ->
                            %% TODO:给卖买双方发邮件
                            log:log(log_market, {<<"购买物品">>, MarketSale, Role}),
                            % gen_server:cast(?MODULE, {deal_avgprice, MarketSale}),
                            {ok, NewRole};
                        {false, Reason} ->
                            {false, Reason}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        false ->
            {false, ?MSGID(<<"您下手晚了，这物品已经售出啦">>)}
    end.

%% 删除求购物品数量
delete_buy(BuyId, ItemBaseId, Quantity) ->
    gen_server:call(?MODULE, {delete_buy, BuyId, ItemBaseId, Quantity}).

%% 发布信息到世界聊天
send_sale_msg(SaleId, Role = #role{id = {RoleId, SrvId}, vip = #vip{type = Vip}, name = Name, label = Label, realm = Realm, assets = Assets = #assets{coin = Coin}, sex = Sex}) ->
    Result = search(search_sale_by_id, {SaleId}),
    case length(Result) =:= 1 of
        true ->
            [MarketSale = #market_sale{role_id = SRoleId, srv_id = SSrvId, item_id = _ItemId, assets_type = AssetsType, price_tax = PriceTax, price = _Price, item_base_id = ItemBaseId, quantity = Quantity}] = Result,
            case RoleId =:= SRoleId andalso SrvId =:= SSrvId andalso Coin > ?market_notice_tax of
                true ->
                    case ItemBaseId of
                        ?market_coin_id ->
                            MarketMsg = util:fbin(?L(<<"寄售{str, ~w, #ffe100}金币,售价为{str, ~w, #ffe100}晶钻,欲购从速咯![3, market_~w_~w_~w_~w金币, 购买, ffe100, ~s]">>), [Quantity, PriceTax, SaleId, AssetsType, PriceTax, Quantity, SrvId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg),
                            {ok, Role#role{assets = Assets#assets{coin = (Coin - ?market_notice_tax)}}};
                        ?market_gold_id ->
                            MarketMsg = util:fbin(?L(<<"寄售{str, ~w, #ffe100}晶钻,售价为{str, ~w, #ffe100}金币,欲购从速咯![3, market_~w_~w_~w_~w晶钻, 购买, ffe100, ~s]">>), [Quantity, PriceTax, SaleId, AssetsType, PriceTax, Quantity, SrvId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg),
                            {ok, Role#role{assets = Assets#assets{coin = (Coin - ?market_notice_tax)}}};
                        _ ->
                            {ok, [RtnItem]} = item:make(ItemBaseId, 0, Quantity),
                            RtnItem2 = RtnItem#item{type = MarketSale#market_sale.type, use_type = MarketSale#market_sale.use_type, source = MarketSale#market_sale.source, quality = MarketSale#market_sale.quality, upgrade = MarketSale#market_sale.upgrade, enchant = MarketSale#market_sale.enchant, enchant_fail = MarketSale#market_sale.enchant_fail, lasttime = MarketSale#market_sale.lasttime, durability = MarketSale#market_sale.durability, attr = MarketSale#market_sale.attr, special = MarketSale#market_sale.special, max_base_attr = MarketSale#market_sale.max_base_attr, require_lev = MarketSale#market_sale.lev, career = MarketSale#market_sale.career},
                            ItemMsg = notice:item_to_msg(RtnItem2),
                            AstStr = case AssetsType of
                                ?assets_type_coin -> ?L(<<"金币">>);
                                ?assets_type_gold -> ?L(<<"晶钻">>)
                            end,
                            MarketMsg = util:fbin(?L(<<"寄售~s,售价为{str, ~w, #ffe100}~s, 欲购从速咯![3, market_~w_~w_~w_~s, 购买, ffe100, ~s]">>), [ItemMsg, PriceTax, AstStr, SaleId, AssetsType, PriceTax, MarketSale#market_sale.item_name, SrvId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg),
                            {ok, Role#role{assets = Assets#assets{coin = (Coin - ?market_notice_tax)}}}
                    end;
                false ->
                    {false, ?L(<<"这不是你的拍卖信息或者你没有足够的金币付手续费">>)}
            end;
        false ->
            {false, ?L(<<"您下手晚了，这物品已经售出啦">>)}
    end.

%% 获得物品均价
average_price(ItemBaseId) ->
    gen_server:call(?MODULE, {average_price, ItemBaseId}).

%% 重载
reload() ->
    gen_server:cast(?MODULE, {reload}).

%% 打印ets表大小
print_size() ->
    gen_server:cast(?MODULE, {print_size}).

%% 保存均价信息
save_avgprice() ->
    gen_server:cast(?MODULE, save_market_avgprice).

%% 调试
eprof_start() ->
    gen_server:cast(?MODULE, eprof_start).
eprof_stop() ->
    gen_server:cast(?MODULE, eprof_stop).

%% 计算税后价格 by bwang
add_price_tax(Price) ->
    IfOpen = platform_cfg:get_cfg(market_price_tax),
    ?DEBUG("是否开启收税~p~n", [IfOpen]),
    case IfOpen of
        1 ->
            Tax = case erlang:trunc(Price * 0.1) of
                %% N when N < 1 -> 1;
                N when N > 10 -> 10;
                N -> N
            end,
            Price + Tax;
        _ ->
            Price
    end.

%%----------------------------------------------------
%% 求购
%%----------------------------------------------------
%% 发布求购信息
buy(item, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) ->
    case check_buy(status, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) of
        {ok} ->
            case do_buy(assets, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) of
                {ok, NewRole} ->
                    {ok, ?L(<<"发布成功">>), NewRole};
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason};
        {?market_op_not_enough, Reason} ->
            {?market_op_not_enough, Reason}
    end.

%% 取消求购
cancle_buy(Role = #role{id = {RoleId, SrvId}}, BuyId) ->
    case gen_server:call(?MODULE, {cancle_buy, BuyId, RoleId, SrvId}) of
        {ok, #market_buy{assets_type = AssetsType, unit_price = UnitPrice, quantity = Quantity}} ->
            Sum = Quantity * UnitPrice,
            case AssetsType of
                ?assets_type_coin ->
                    {ok, NewRole} = role_gain:do(#gain{label = coin, val = Sum}, Role),
                    {ok, ?L(<<"求购信息成功撤销了">>), NewRole};
                ?assets_type_gold ->
                    {ok, NewRole} = role_gain:do(#gain{label = gold, val = Sum}, Role),
                    {ok, ?L(<<"求购信息成功撤销了">>), NewRole}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%% 直接出售
buy_sale(item, Role, {BuyId, ItemId, Quantity}) ->
    case check_buy_sale(status, Role, {BuyId, ItemId, Quantity}) of
        {ok} ->
            case do_buy_sale(item, Role, {BuyId, ItemId, Quantity}) of
                {ok, NewRole} ->
                    {ok, ?L(<<"物品出售成功">>), NewRole};
                {false, Reason} ->
                    {false, Reason}
            end;
         {false, Reason} ->
             {false, Reason}
    end.

%% 向全局进程插入一条求购记录 
add_buy(MarketBuy) ->
    gen_server:call(?MODULE, {add_buy, MarketBuy}).

%% 直接出售物品后检查
buy_delete_check(MarketBuy, Quantity, Succ) ->
    gen_server:call(?MODULE, {buy_delete_check, MarketBuy, Quantity, Succ}).

%% 启动市场全局进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%----------------------------------------------------
%% 全局进程处理 
%%----------------------------------------------------
%% 市场全局进程初始化
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    case ets:info(market_sale) of
        undefined ->
            ets:new(market_sale, [ordered_set, named_table, public, {keypos, #market_sale.sale_id}]);
            % ets:new(ets_market_sale_pricesort, [ordered_set, named_table, public, {keypos, #market_sale.price_sort}]);
        _Any ->
            ?DEBUG("测试:当你看到我的时候，请你告诉我!"),
            skip
    end,
    % case ets:info(market_buy) of
    %     undefined ->
    %         ets:new(market_buy, [set, named_table, public, {keypos, #market_buy.buy_id}]);
    %     _Any2 -> skip
    % end,
    % case ets:info(market_average) of
    %     undefined ->
    %         ets:new(market_average, [set, named_table, public, {keypos, #market_avgprice.item_base_id}]);
    %     _Any3 -> skip
    % end,
    do_load(market_sale),
    % do_load(market_buy),
    % do_load(average_price),
    erlang:send_after(?time_tick, self(), check_expire),
    % erlang:send_after(?time_tick_avg, self(), {save_market_avgprice, ?true}),
    %% erlang:register(?MODULE, self()),
    ?INFO("[~w] 启动完成", [?MODULE]),
    ?DEBUG("**market进程启动完成*:~s~n",["ok!"]),
    {ok, #state{}}.

%% 查询拍卖物品
handle_call({search_sale, all, PageIndex}, _From, State) ->
    ?DEBUG("**查询拍卖物品*all**:~s~n",["search_sale, all"]),
    Data = ets:select(market_sale, ets:fun2ms(fun(N = #market_sale2{})  -> N end)), %%查询所有类型
    NData = lists:reverse(lists:keysort(5,Data)),
    TotalPage = util:ceil(length(NData) / ?market_sale_row_count),
    OffsetStart = (PageIndex - 1) * ?market_sale_row_count + 1, %% 从1开始
    OffsetEnd = OffsetStart + ?market_sale_row_count,
    PageData = do_page2(NData, OffsetStart, OffsetEnd, 1, []),
    Reply = {TotalPage, PageData},
    {reply, Reply, State};
 
handle_call({search_sale, Type, PageIndex}, _From, State) ->        %% 查询具体某一种类型
    ?DEBUG("**查询拍卖物品*type**:~w~w~n",[Type,PageIndex]),
    Data = case Type of 
                0 ->
                    ets:select(market_sale, ets:fun2ms(fun(N = #market_sale2{})  -> N end)); %%查询所有类型
                _ ->
                    ets:select(market_sale, ets:fun2ms(fun(N = #market_sale2{type = ItemType}) when ItemType =:= Type  -> N end))
            end,
    ?DEBUG("**查询拍卖物品*data**:~w~n",[Data]),
    NData = lists:reverse(lists:keysort(5, Data)),
    TotalPage = util:ceil(length(NData) / ?market_sale_row_count),
    OffsetStart = (PageIndex - 1) * ?market_sale_row_count + 1, %% 从1开始
    OffsetEnd = OffsetStart + ?market_sale_row_count,
    PageData = do_page2(NData, OffsetStart, OffsetEnd, 1, []),
    Reply = {TotalPage, PageData},
    {reply, Reply, State};
  

handle_call({same_id, ItemBaseId, PageIndex}, _From, State) ->        %% 查询同一种类型
    ?DEBUG("**查询同一种类型**:~w~w~n",[ItemBaseId,PageIndex]),
    Data = ets:select(market_sale, ets:fun2ms(fun(N = #market_sale2{item_base_id = BaseId}) when BaseId =:= ItemBaseId  -> N end)),
    ?DEBUG("**查询同一种类型*data**:~w~n",[Data]),
    NData = lists:reverse(lists:keysort(5, Data)),
    TotalPage = util:ceil(length(NData) / ?market_sale_row_count),
    OffsetStart = (PageIndex - 1) * ?market_sale_row_count + 1, %% 从1开始
    OffsetEnd = OffsetStart + ?market_sale_row_count,
    PageData = do_page2(NData, OffsetStart, OffsetEnd, 1, []),
    Reply = {TotalPage, PageData},
    {reply, Reply, State};


handle_call({search_sale, Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex, SortType}, _From, State) ->
    MatchSpec = case Type >= 200 of
        false -> parse_ms([{type, '$35', Type}, {min_lev, '$17', MinLev}, {max_lev, '$17', MaxLev}, {quality, '$16', Quality}, {career, '$18', Career}]);
        true -> parse_ms([{type, '$32', Type}, {min_lev, '$17', MinLev}, {max_lev, '$17', MaxLev}, {quality, '$16', Quality}, {career, '$18', Career}])
    end,
    %% MatchSpec = parse_ms([{type, '$12', Type}, {min_lev, '$17', MinLev}, {max_lev, '$17', MaxLev}, {quality, '$16', Quality}, {career, '$18', Career}]), 
    NewMatchSpec = case length(MatchSpec) > 0 of
        true ->
            case util:string_to_term("[{'andalso', " ++ MatchSpec ++ "}]") of
                {ok, Term} ->
                    Term;
                _E ->
                    [{'=:=', 1, 2}]
            end;
        false ->
            []
    end,
    SelectMs = [{
        ?sale_columns,
        NewMatchSpec,
        ['$_']}],
    TableName = case SortType of
        ?market_sort_type_price -> ets_market_sale_pricesort;
        _ -> market_sale
    end,
    Reply = case ets:select(TableName, SelectMs) of
        [] ->
            {0, []};
        SaleList ->
            Data = case byte_size(ItemName) > 0 of
                true ->
                    name_filter(sale, SaleList, ItemName);
                false ->
                    SaleList
            end,
            TotalPage = util:ceil(length(Data) / ?market_sale_row_count),
            OffsetStart = (PageIndex - 1) * ?market_sale_row_count, %% 从0开始
            OffsetEnd = OffsetStart + ?market_sale_row_count - 1,
            PageData = do_page(Data, OffsetStart, OffsetEnd, 0),
            {TotalPage, PageData}
    end,
    {reply, Reply, State};

%% 查询我拍卖的物品
handle_call({search_sale_self, RoleId, SrvId}, _From, State) ->
    ?DEBUG("***search_sale_self**:~w~w~n",[RoleId,SrvId]),
    Reply = ets:select(market_sale, ets:fun2ms(fun(N = #market_sale2{role_id=Rid,srv_id = Srv_Id}) when Rid =:=RoleId andalso Srv_Id =:= SrvId  -> N end)),
    {reply, Reply, State};

%% 通过SaleId查询拍卖物品
handle_call({search_sale_by_id, SaleId}, _From, State) ->
    Reply = ets:lookup(market_sale, SaleId),
    {reply, Reply, State};

%% 查询求购信息
handle_call({search_buy, Type, ItemName, MinLev, MaxLev, Quality, Career, PageIndex}, _From, State) ->
    MatchSpec = case Type >= 200 of
        false -> parse_ms([{type, '$18', Type}, {min_lev, '$15', MinLev}, {max_lev, '$15', MaxLev}, {quality, '$14', Quality}, {career, '$16', Career}]);
        true -> parse_ms([{type, '$17', Type}, {min_lev, '$15', MinLev}, {max_lev, '$15', MaxLev}, {quality, '$14', Quality}, {career, '$16', Career}])
    end,
    NewMatchSpec = case length(MatchSpec) > 0 of
        true ->
            case util:string_to_term("[{'andalso', " ++ MatchSpec ++ "}]") of
                {ok, Term} -> Term;
                _ ->
                    [{'=:=', 1, 2}]
            end;
        false ->
            []
    end,
    SelectMs = [{
        ?buy_columns,
        NewMatchSpec,
        ['$_']}],
    Reply = case ets:select(market_buy, SelectMs) of
        [] ->
            {0, []};
        SaleList ->
            Data = case byte_size(ItemName) > 0 of
                true ->
                    name_filter(buy, SaleList, ItemName);
                false ->
                    SaleList
            end,
            TotalPage = util:ceil(length(Data) / ?market_sale_row_count),
            OffsetStart = (PageIndex - 1) * ?market_sale_row_count, %% 从0开始
            OffsetEnd = OffsetStart + ?market_sale_row_count - 1,
            PageData = do_page(Data, OffsetStart, OffsetEnd, 0),
            {TotalPage, PageData}
    end, 
    {reply, Reply, State};

%% 查询自己求购的信息
handle_call({search_buy_self, RoleId, SrvId}, _From, State) ->
    SelectMs = [{
        ?buy_columns,
        [{'andalso', {'=:=', '$3', RoleId}, {'=:=', '$4', SrvId}}],
        ['$_']}],
    Reply = ets:select(market_buy, SelectMs),
    {reply, Reply, State};

%% 通过ID获取求购信息
handle_call({search_buy_by_id, BuyId}, _From, State) ->
    Reply = ets:lookup(market_buy, BuyId),
    {reply, Reply, State};
    

%% 取角色拍卖数量
handle_call({sale_count, RoleId, SrvId}, _From, State) ->
    MatchList = ets:match_object(market_sale, #market_sale{role_id = RoleId, srv_id = SrvId, _ = '_'}),
    {reply, length(MatchList), State};

%% 向全局进程插入一条拍卖记录
handle_call({add_sale, MarketSale}, _From, State) ->
    case market_dao:insert_sale2(MarketSale) of
        {ok, _} -> 
            ets:insert(market_sale, MarketSale),
            % ets:insert(ets_market_sale_pricesort, NewMarketSale),
            Reply = MarketSale#market_sale2.sale_id,
            {reply, Reply, State};
        _ ->
            {reply, {false, ?L(<<"操作失败，请稍后再试">>)}, State}
    end;

%% 取消拍卖
handle_call({cancle_sale, RoleId, SrvId, SaleId}, _From, State) ->
    Now = util:unixtime(),
    case ets:lookup(market_sale, SaleId) of
        [] ->
            {reply, {false, ?L(<<"没有这个拍卖信息哦">>)}, State};
        [#market_sale2{begin_time = BeginTime}] when BeginTime + 30 > Now ->
            {reply, {false, ?L(<<"拍卖信息发布后需要等待30秒才能取消哦">>)}, State};
        [MarketSale = #market_sale2{role_id = MsRoleId, srv_id = MsSrvId}] ->
            case (MsRoleId =:= RoleId andalso MsSrvId =:= SrvId) of
                true ->
                    case market_dao:delete_sale2(SaleId) of
                        {ok, 0} ->
                            {reply, {false, ?L(<<"非法操作">>)}, State};
                        {ok, 1} ->
                            ets:delete(market_sale, SaleId),
                            % PriceScort = calc_price_sort(MarketSale),
                            % ets:delete(ets_market_sale_pricesort, PriceScort),
                            {reply, {ok, MarketSale}, State};
                        _ ->
                            {reply, {false, ?L(<<"市场有点忙，请稍后再试">>)}, State}
                    end;
                false ->
                    {reply, {false, ?L(<<"非法操作">>)}, State}
            end
    end;

%% 删除拍卖物品
handle_call({delete_sale, SaleId}, _From, State) ->
    case ets:lookup(market_sale, SaleId) of
        [] ->
            {reply, {false, ?MSGID(<<"该物品不存在了">>)}, State};
        [MarketSale] ->
            case market_dao:delete_sale2(SaleId) of
                {ok, _} ->
                    ets:delete(market_sale, SaleId),
                    % PriceScort = calc_price_sort(MarketSale),
                    % ets:delete(ets_market_sale_pricesort, PriceScort),
                    {reply, {ok, MarketSale}, State};
                {false, Msg} ->
                    ?ERR("拍卖物品有误，数据库数据与ets数据不同步[SaleId:~w][Error:~w]", [SaleId, Msg]),
                    {reply, {false, ?MSGID(<<"您下手晚了，这物品已经售出啦">>)}, State}
            end
    end;

%% 插入求购记录
handle_call({add_buy, MarketBuy}, _From, State) ->
    case market_dao:insert_buy(MarketBuy) of
        {ok, _Affected} ->
            ets:insert(market_buy, MarketBuy),
            {reply, ok, State};
        {error, Reason} ->
            {reply, {false, Reason}, State}
    end;

%% 取消拍卖
handle_call({cancle_buy, BuyId, RoleId, SrvId}, _From, State) ->
    Now = util:unixtime(),
    case ets:lookup(market_buy, BuyId) of
        [] ->
            {reply, {false, ?L(<<"没有这个求购信息哦">>)}, State};
        [#market_buy{begin_time = BeginTime}] when BeginTime + 30 > Now ->
            {reply, {false, ?L(<<"求购信息发布后需要等待30秒才能取消哦">>)}, State};
        [MarketBuy = #market_buy{role_id = MbRoleId, srv_id = MbSrvId}] ->
            case RoleId =:= MbRoleId andalso SrvId =:= MbSrvId of
                false ->
                    {reply, {false, ?L(<<"非法操作">>)}, State};
                true ->
                    ets:delete(market_buy, BuyId),
                    market_dao:delete_buy(BuyId),
                    {reply, {ok, MarketBuy}, State}
            end
    end;

%% 删除求购物品数量
handle_call({delete_buy, BuyId, ItemBaseId, Quantity}, _From, State) ->
    case ets:lookup(market_buy, BuyId) of
        [] ->
            {reply, {false, ?L(<<"没有这个求购信息哦">>)}, State};
        [MarketBuy = #market_buy{quantity = MbQuantiy, item_base_id = MbItemBaseId}] ->
            case MbQuantiy < Quantity of
                true ->
                    {reply, {false, ?L(<<"您出售的数量比人家求购的还多呢">>)}, State};
                false ->
                    case MbItemBaseId =:= ItemBaseId of
                        false ->
                            {reply, {false, ?L(<<"您这个物品不是人家需要的那个吧">>)}, State};
                        true ->
                            Q = MbQuantiy - Quantity,
                            NewMarketBuy = MarketBuy#market_buy{quantity = Q},
                            case begin case Q > 0 of
                                true ->
                                    ets:insert(market_buy, NewMarketBuy),
                                    market_dao:update_buy_quantity(BuyId, Q);
                                false ->
                                    ets:delete(market_buy, BuyId),
                                    market_dao:delete_buy(BuyId)
                            end end of
                                {ok, _Affected} ->
                                    {reply, {ok, NewMarketBuy}, State};
                                {error, Reason} ->
                                    {reply, {false, Reason}, State};
                                _ ->
                                    {reply, {false, <<>>}, State}
                            end
                    end
            end
    end;

%% 直接出售物品后检查
handle_call({buy_delete_check, MarketBuy = #market_buy{buy_id = BuyId}, Quantity, Succ}, _From, State) ->
    case Succ of
        true ->
            case ets:lookup(market_buy, BuyId) of
                [] ->
                    skip;
                [#market_buy{quantity = MbQuantiy}] ->
                    case MbQuantiy < 1 of
                        true ->
                            ets:delete(market_buy, BuyId),
                            market_dao:delete_buy(BuyId);
                        false ->
                            skip
                    end
            end;
        false ->
            case ets:lookup(market_buy, BuyId) of
                [] ->
                    NewMarketBuy = MarketBuy#market_buy{quantity = Quantity},
                    ets:insert(market_buy, NewMarketBuy),
                    market_dao:insert_buy(NewMarketBuy);
                [MarketBuy = #market_buy{quantity = MbQuantiy}] ->
                    ets:insert(market_buy, MarketBuy#market_buy{quantity = (MbQuantiy + Quantity)}),
                    market_dao:update_buy_quantity(BuyId, (MbQuantiy + Quantity))
            end
    end,
    {reply, {ok}, State};

%% 均价
handle_call({average_price, ItemBaseId}, _From, State) ->
    Reply = case ets:lookup(market_average, ItemBaseId) of
        [#market_avgprice{item_base_id = ?market_coin_id,  coin_price_sum = _CoinPriceSum, gold_price_sum = GoldPriceSum, coin_num = _CoinNum, gold_num = GoldNum}] when GoldNum > 3 -> 
            {?false, round(GoldPriceSum * 10000 / GoldNum)};
        [#market_avgprice{item_base_id = ?market_gold_id,  coin_price_sum = CoinPriceSum, gold_price_sum = _GoldPriceSum, coin_num = CoinNum, gold_num = _GoldNum}] when CoinNum > 3 -> 
            {round(CoinPriceSum / CoinNum), ?false};
        [#market_avgprice{item_base_id = ItemBId, coin_price_sum = CoinPriceSum, gold_price_sum = GoldPriceSum, coin_num = CoinNum, gold_num = GoldNum}] when ItemBId =/= ?market_coin_id andalso ItemBId =/= ?market_gold_id -> 
            CoinPrice = case CoinNum > 3 of
                true -> round(CoinPriceSum / CoinNum);
                false -> 0
            end,
            GoldPrice = case GoldNum > 3 of
                true -> round(GoldPriceSum / GoldNum);
                false -> 0
            end,
            {CoinPrice, GoldPrice};
        _ -> {?false, ?false}
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({deal_avgprice, MarketSale}, State) ->
    deal_avgprice(MarketSale),
    {noreply, State};

handle_cast({reload}, State) ->
    do_reload(),
    {noreply, State};

handle_cast({print_size}, State) ->
    Count = ets:select_count(market_sale, [{?sale_columns, [], [true]}]),
    CountPrice = ets:select_count(ets_market_sale_pricesort, [{?sale_columns, [], [true]}]),
    ?INFO("[market]时间顺序ets表大小:~w", [Count]),
    ?INFO("[market]价格顺序ets表大小:~w", [CountPrice]),
    {noreply, State};

handle_cast(save_market_avgprice, State) ->
    self() ! {save_market_avgprice, ?false},
    {noreply, State};

handle_cast(eprof_start, State) ->
    dev:eprof_start(),
    {noreply, State};
handle_cast(eprof_stop, State) ->
    dev:eprof_stop(),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 检查并删除过期物品 
handle_info(check_expire, State) ->
    Now = util:unixtime(),
    SelectMsSale = [{
        ?sale_columns_new,
        [{'<', '$6', Now}],
        ['$_']}],
    ExpireSaleData = ets:select(market_sale, SelectMsSale),
    ?DEBUG("过期的商品~p~n", [ExpireSaleData]),
    ?DEBUG("**check_expire***\n"),
    delete_expire(sale, ExpireSaleData),
    erlang:send_after(?time_tick, self(), check_expire),
    {noreply, State};

handle_info({save_market_avgprice, Continue}, State) ->
    try
        case ets:tab2list(market_average) of
            [] -> ignore;
            List when is_list(List) ->
                sys_env:set(market_average_price, List),
                sys_env:save(market_average_price, List);
            _ -> ignore
        end 
    of
        _ -> case Continue of
            ?true -> erlang:send_after(?time_tick_avg, self(), {save_market_avgprice, ?true});
            _ -> ignore
        end
    catch
        _:Reason ->
            ?ERR("保存市场均价出错:~p", [Reason]),
            error
    end,
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------
%% 加载拍卖物品信息
do_load(market_sale) ->
    case market_dao:get_all_sale2() of
        {true, Data} ->
            do_load(market_sale_data, Data);
        {false, _} ->
            ?DEBUG("没有找到拍卖信息")
    end;
do_load(market_buy) ->
    case market_dao:get_all_buy() of
        {true, Data} ->
            do_load(market_buy_data, Data);
        {false, _} ->
            ?DEBUG("没有找到求购信息")
    end;
do_load(average_price) ->
    case sys_env:get(market_average_price) of
        undefined -> ignore;
        AvgPriceList -> do_load(average_price, AvgPriceList)
    end.

%% 重载
do_reload() ->
    case market_dao:get_all_sale() of
        {true, Data} ->
            ets:delete_all_objects(market_sale),
            ets:delete_all_objects(ets_market_sale_pricesort),
            do_load(market_sale_data, Data),
            ?INFO("重载拍卖信息完成");
        {false, _} ->
            ?INFO("sale没有找到拍卖信息")
    end,
    case market_dao:get_all_buy() of
        {true, Data2} ->
            ets:delete_all_objects(market_buy),
            do_load(market_buy_data, Data2),
            ?INFO("重载求购信息完成");
        {false, _} ->
            ?INFO("buy没有找到求购信息")
    end.


%% 加载拍卖信息
do_load(market_sale_data, [[SaleId, RoleId, SrvId, BeginTime, EndTime, Origin_Price, Price, Quantity, ItemBaseId, Type,SalerName, SalerLev,SalerCareer] | T]) ->
    MarketSale = #market_sale2{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = BeginTime, end_time = EndTime, origin_price = Origin_Price, 
        price = Price, quantity = Quantity, item_base_id = ItemBaseId, type = Type, saler_name = SalerName, saler_lev = SalerLev, saler_career = SalerCareer},
    ets:insert(market_sale, MarketSale),
    do_load(market_sale_data, T);
do_load(market_sale_data, []) ->
    skip;

%% 加载求购信息
do_load(market_buy_data, [[BuyId, RoleId, SrvId, RoleName, BeginTime, EndTime, AssetsType, UnitPrice, Quantity, ItemBaseId, ItemName, Type, Quality, Lev, Career] | T]) ->
    MarketType = market_data_type:item_type_to_market(Type, ItemBaseId),
    TypeScort = case market_data_type:type_ref(MarketType) of
        {ok, TScort} -> TScort;
        _ ->
            ?ERR("没找到物品类型对应信息[~w]", [MarketType]),
            MarketType
    end,
    MarketBuy = #market_buy{buy_id = BuyId, role_id = RoleId, srv_id = SrvId, role_name = RoleName, begin_time = BeginTime, end_time = EndTime, assets_type = AssetsType, unit_price = UnitPrice, quantity = Quantity, item_base_id = ItemBaseId, item_name = ItemName, type = Type, quality = Quality, lev = Lev, career = Career, type_scort = TypeScort, market_type = MarketType},
    ets:insert(market_buy, MarketBuy),
    do_load(market_buy_data, T);
do_load(market_buy_data, []) ->
    skip;

%% 加载均价
do_load(average_price, []) -> ok;
do_load(average_price, [MarketAvg | T]) when is_record(MarketAvg, market_avgprice) ->
    ets:insert(market_average, MarketAvg),
    do_load(average_price, T);
do_load(average_price, [MarketAvg | T]) ->
    ?ERR("不认识的市场均价记录:~w", [MarketAvg]),
    do_load(average_price, T).

%% 检查状态是否合法
check_sale(status, Role = #role{status = Status}, {ItemId, AssetsType, Price, Time, AssetsNum, Notice}) ->
    case Status =:= ?status_fight of
        true ->
            {false, ?L(<<"战斗中是不可以拍卖物品的哦">>)};
        false ->
            check_sale(coin, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice})
    end;

%% 检查货币相关
check_sale(coin, Role = #role{assets = #assets{coin = RoleCoin, coin_bind = CoinBind, gold = RoleGold}}, {ItemId, AssetsType, Price, Time, AssetsNum, Notice}) ->
    case Price =< 0 orelse Price > 999999999 of
        true ->
            {false, ?L(<<"您输入的价格是非法的">>)};
        false ->
            Tax = market_util:calc_tax(sale, {AssetsType, Price, Time}),
            case Tax > (RoleCoin + CoinBind) of
                true ->
                    {false, lang_market_not_enough_tax};
                false ->
                    case ItemId of
                        ?market_gold_id -> %% 晶钻
                            case AssetsNum =< RoleGold of
                                true ->
                                    case Notice of
                                        ?false -> check_sale(over_max, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice});
                                        ?true ->
                                            case (RoleCoin + CoinBind - Tax) > ?market_notice_tax of
                                                true -> check_sale(over_max, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice});
                                                false -> {false, lang_market_not_enough_tax}
                                            end
                                    end;
                                false ->
                                    {false, lang_market_not_enough_gold}
                            end;
                        ?market_coin_id -> %% 金币
                            Ex = case CoinBind > Tax of
                                true -> 0;
                                false -> Tax - CoinBind
                            end,
                            case AssetsNum < (RoleCoin - Ex) of
                                true ->
                                    case Notice of
                                        ?false -> check_sale(over_max, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice});
                                        ?true ->
                                            case (RoleCoin + CoinBind - AssetsNum - Tax) > ?market_notice_tax of
                                                true -> check_sale(over_max, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice});
                                                false -> {false, lang_market_not_enough_tax}
                                            end
                                    end;
                                false ->
                                    {false, lang_market_not_enough_coin}
                            end;
                        _Other ->
                            check_sale(item_exist_lock_bind, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice})
                    end
            end
    end;

%% 检查物品相关
check_sale(item_exist_lock_bind, Role = #role{bag = #bag{items = Items}}, {ItemId, AssetsType, Price, Time, AssetsNum, Notice}) ->
    case storage:find(Items, #item.id, ItemId) of
        {false, _} ->
            {false, ?L(<<"该物品不存在了">>)};
        {ok, #item{status = Status, bind = Bind}} ->
            case Status =:= ?lock_exchange of
                true ->
                    {false, ?L(<<"这个紫装还在交易的冻结时间中呢">>)};
                false ->
                    case Bind =:= 1 of
                        true ->
                            {false, ?L(<<"绑定的物品是不可以拍卖的哦">>)};
                        false ->
                            check_sale(over_max, Role, {ItemId, AssetsType, Price, Time, AssetsNum, Notice})
                    end
            end
    end;

%% 检查很大拍卖物品数量
check_sale(over_max, _Role = #role{id = {RoleId, SrvId}}, {_ItemId, _AssetsType, _price, _Time, _AssetsNum, _Notice}) ->
    CurrentCount = case catch get_sale_count(RoleId, SrvId) of
        Num when is_integer(Num) -> Num;
        _Any -> 
            ?ERR("市场模块可能超时了:~w", [_Any]),
            ?market_sale_max
    end,
    case CurrentCount >= ?market_sale_max of
        true ->
            {false, ?L(<<"您的拍卖数量已经到达20个，不可以再拍卖了哦">>)};
        false ->
            {ok}
    end.

%% 购买拍卖物品，检查物品有效期
check_sale_buy(end_time, Role, {MarketSale = #market_sale2{end_time = EndTime}}) ->
    case EndTime < util:unixtime() of
        false ->
            check_sale_buy(owner, Role, {MarketSale});
        true ->
            {false, ?MSGID(<<"该商品已过期">>)}
    end;

%% 购买拍卖物品，检查物品所有者
check_sale_buy(owner, _Role = #role{id = {RoleId, SrvId}}, {_MarketSale = #market_sale2{role_id = MsRoleId, srv_id = MsSrvId}}) ->
    case RoleId =:= MsRoleId andalso SrvId =:= MsSrvId of
        false ->
            % check_sale_buy(assets, Role, {MarketSale});
            {ok};
        true ->
            {false, ?L(<<"自己拍卖自己购买，不好吧">>)}
    end;

%% 购买拍卖物品，检查资产相关条件
check_sale_buy(assets, _Role = #role{assets = #assets{coin = RoleCoin, gold = RoleGold}}, {_MarketSale = #market_sale{assets_type = AssetsType, price = Price}}) ->
    case AssetsType of
        ?assets_type_coin ->
            case RoleCoin >= Price of
                true ->
                    {ok};
                false ->
                    {false, lang_market_not_enough_coin}
            end;
        ?assets_type_gold ->
            case RoleGold >= Price of
                true ->
                    {ok};
                false ->
                    {?market_op_not_enough, lang_market_not_enough_gold}
            end
    end.

% 扣除手续费
do_sale_spend(sale_tax, Role = #role{assets = Assets = #assets{coin = RoleCoin, coin_bind = CoinBind, gold = _RoleGold}}, {_ItemId, AssetsType, Price, Time, _AssetsNum, Notice}) ->
    Tax = market_util:calc_tax(sale, {AssetsType, Price, Time}),
    {NewCoinBind, NoticeTax} = case Notice of
        ?true ->
            case CoinBind > (?market_notice_tax + Tax) of
                true -> {(CoinBind - ?market_notice_tax - Tax), 0};
                false -> {0, (?market_notice_tax + Tax - CoinBind)}
            end;
        ?false -> 
            case CoinBind > Tax of
                true -> {CoinBind - Tax, 0};
                false -> {0, Tax - CoinBind}
            end
    end,
    case RoleCoin >= NoticeTax of
        true ->
            {ok, Role#role{assets = Assets#assets{coin = (RoleCoin - NoticeTax), coin_bind = NewCoinBind}}};
        false ->
            {false, lang_market_not_enough_tax}
    end.

%% 扣除手续费
do_sale_spend2(sale_tax, Role,Price, Notice) ->
    Tax = market_util:calc_tax(sale, Price),
    L =
        case Notice of 
            1 -> [
                #loss{label = coin, val = Tax, msg = ?L(<<"保管费用(金币)不足，无法出售">>)},
                #loss{label = coin, val = 20000 , msg = ?L(<<"公告费用(金币)不足，无法出售">>)}
                ];
            0 ->
                [#loss{label = coin, val = Tax, msg = ?L(<<"保管费(金币)不足，无法出售">>)}]
        end,
    role:send_buff_begin(),
    case role_gain:do(L, Role) of 
        {false, #loss{msg = Msg}} ->
            role:send_buff_clean(),
            {false, Msg};
        {false, Reason} ->
             role:send_buff_clean(),
            {false, Reason};
        {ok, NRole} ->
            {ok, NRole}
    end.


%% 发布拍卖晶钻信息 
issue_sale(gold, Role = #role{id = {RoleId, SrvId}, vip = #vip{type = Vip}, name = Name, label = Label, realm = Realm, lev = SalerLev, sex = Sex, assets = Assets = #assets{gold = RoleGold}}, {ItemId, AssetsType, Price, Time, AssetsNum, Notice}) ->
    %% SaleId = get_key(?market_sale_key_str),
    {ok, SaleId} = key_mgr:generate(market_key_sale),
    Now = util:unixtime(),
    EndTime = Now + (Time * 60 * 60),
    MarketType = market_data_type:item_type_to_market(?market_item_type_gold, ItemId),
    TypeScort = case market_data_type:type_ref(?market_item_type_gold) of
        {ok, TScort} -> TScort;
        _ ->
            ?ERR("没找到物品类型对应信息[~w]", [?market_item_type_gold]),
            ?market_item_type_gold
    end,
    PriceScort = calc_price_sort(SaleId, AssetsType, Price, AssetsNum),
    PriceTax = calc_price_tax(AssetsType, Price),
    MarketSale = #market_sale{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = Now, end_time = EndTime, assets_type = AssetsType, price = Price, price_tax = PriceTax, item_id = 0, item_base_id = ItemId, item_name = ?L(<<"晶钻">>), type = ?market_item_type_gold, quantity = AssetsNum, status = ?lock_release, saler_name = Name, saler_lev = SalerLev, type_scort = TypeScort, price_sort = PriceScort, market_type = MarketType},
    case RoleGold >= AssetsNum of
        true ->
            NewRole = Role#role{assets = Assets#assets{gold = (RoleGold - AssetsNum)}},
            case catch add_sale(MarketSale) of
                {false, Reason} -> {false, Reason};
                %%{ok} ->
                _ ->
                    case Notice of
                        ?false -> ignore;
                        _ ->
                            MarketMsg = util:fbin(?L(<<"寄售{str, ~w, #ffe100}晶钻,售价为{str, ~w, #ffe100}金币,欲购从速咯![3, market_~w_~w_~w_~w晶钻, 购买, ffe100, ~s]">>), [AssetsNum, PriceTax, SaleId, AssetsType, PriceTax, AssetsNum, SrvId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg)
                    end,
                    log:log(log_market, {Now, <<"拍卖晶钻">>, Time, MarketSale, ignore}),
                    {ok, ?L(<<"物品出售成功">>), NewRole}
            end;
        false ->
            {false, lang_market_not_enough_gold}
    end;

%% 发布拍卖金币信息
issue_sale(coin, Role = #role{id = {RoleId, SrvId}, vip = #vip{type = Vip}, lev = SalerLev, name = Name, label = Label, realm = Realm, sex = Sex, assets = Assets = #assets{coin = RoleCoin}}, {ItemId, AssetsType, Price, Time, AssetsNum, Notice}) ->
    %% SaleId = get_key(?market_sale_key_str),
    {ok, SaleId} = key_mgr:generate(market_key_sale),
    Now = util:unixtime(),
    EndTime = Now + (Time * 60 * 60),
    MarketType = market_data_type:item_type_to_market(?market_item_type_coin, ItemId),
    TypeScort = case market_data_type:type_ref(?market_item_type_coin) of
        {ok, TScort} -> TScort;
        _ ->
            ?ERR("没找到物品类型对应信息[~w]", [?market_item_type_coin]),
            ?market_item_type_coin
    end,
    PriceTax = calc_price_tax(AssetsType, Price),
    PriceScort = calc_price_sort(SaleId, AssetsType, Price, AssetsNum),
    MarketSale = #market_sale{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = Now, end_time = EndTime, assets_type = AssetsType, price = Price, price_tax = PriceTax, item_id = 0, item_base_id = ItemId, item_name = ?L(<<"金币">>), type = ?market_item_type_coin, quantity = AssetsNum, status = ?lock_release, saler_name = Name, saler_lev = SalerLev, type_scort = TypeScort, price_sort = PriceScort, market_type = MarketType},
    case RoleCoin > AssetsNum of
        true ->
            case Notice of
                ?false -> ignore;
                _ ->
                    MarketMsg = util:fbin(?L(<<"寄售{str, ~w, #ffe100}金币,售价为{str, ~w, #ffe100}晶钻,欲购从速咯![3, market_~w_~w_~w_~w金币, 购买, ffe100, ~s]">>), [AssetsNum, PriceTax, SaleId, AssetsType, PriceTax, AssetsNum, SrvId]),
                    notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg)
            end,
            NewRole = Role#role{assets = Assets#assets{coin = (RoleCoin - AssetsNum)}},
            case catch add_sale(MarketSale) of
                {false, Reason} -> {false, Reason};
                _ ->
                    log:log(log_market, {Now, <<"拍卖金币">>, Time, MarketSale, ignore}),
                    {ok, ?L(<<"物品出售成功">>), NewRole}
            end;
        false ->
            {false, lang_market_not_enough_tax}
    end;

% 发布拍卖物品信息
issue_sale(item, Role = #role{id = {RoleId, SrvId}, vip = #vip{type = Vip}, lev = SalerLev, name = Name, label = Label, realm = Realm, sex = Sex, bag = Bag = #bag{items = Items}, link = #link{conn_pid = ConnPid}}, {ItemId, AssetsType, Price, Time, _AssetsNum, Notice}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item = #item{base_id = ItemBaseId}} ->
            %% SaleId = market:get_key(?market_sale_key_str),
            {ok, SaleId} = key_mgr:generate(market_key_sale),
            Now = util:unixtime(),
            EndTime = Now + (Time * 60 * 60),
            {ok, #item_base{name = ItemName}} = item_data:get(ItemBaseId),
            MarketType = market_data_type:item_type_to_market(Item#item.type, ItemBaseId),
            TypeScort = case market_data_type:type_ref(MarketType) of
                {ok, TScort} -> TScort;
                _ ->
                    ?ERR("没找到物品类型对应信息[~w]", [MarketType]),
                    MarketType
            end,
            PriceTax = calc_price_tax(AssetsType, Price),
            PriceScort = calc_price_sort(SaleId, AssetsType, Price, Item#item.quantity),
            MarketSale = #market_sale{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = Now, end_time = EndTime, assets_type = AssetsType, price = Price, price_tax = PriceTax, item_id = ItemId, item_base_id = ItemBaseId, item_name = ItemName, type = Item#item.type, use_type = Item#item.use_type, bind = Item#item.bind, source = Item#item.source, quality = Item#item.quality, lev = Item#item.require_lev, career = Item#item.career, upgrade = Item#item.upgrade, enchant = Item#item.enchant, enchant_fail = Item#item.enchant_fail, quantity = Item#item.quantity, status = ?lock_release, pos = 0, lasttime = Now, durability = Item#item.durability, attr = Item#item.attr, special = Item#item.special, max_base_attr = Item#item.max_base_attr, saler_name = Name, saler_lev = SalerLev, type_scort = TypeScort, price_sort = PriceScort, market_type = MarketType},
            case storage:del_item_by_id(Bag, ItemId, Item#item.quantity, true, [], []) of
                {ok, NewBag, _, _} ->
                    ItemMsg = notice:item_to_msg(Item),
                    AstStr = case AssetsType of
                        ?assets_type_coin -> ?L(<<"金币">>);
                        ?assets_type_gold -> ?L(<<"晶钻">>)
                    end,
                    case Notice of
                        ?false -> ignore;
                        ?true ->
                            MarketMsg = util:fbin(?L(<<"寄售~s,售价为{str, ~w, #ffe100}~s, 欲购从速咯![3, market_~w_~w_~w_~s, 购买, ffe100, ~s]">>), [ItemMsg, PriceTax, AstStr, SaleId, AssetsType, PriceTax, ItemName, SrvId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, Name, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg)
                    end,
                    NewRole = Role#role{bag = NewBag},
                    case catch add_sale(MarketSale) of
                        {false, Reason} -> {false, Reason};
                        _ ->
                            storage_api:del_item_info(ConnPid, [{?storage_bag, Item}]),
                            log:log(log_market, {Now, <<"拍卖物品">>, Time, MarketSale, ignore}),
                            {ok, ?L(<<"物品出售成功">>), NewRole}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

%%出售物品
issue_sale2(item, Role = #role{id = {RoleId, SrvId}, vip = #vip{type = VLev}, lev = SalerLev, name = Name, sex = Sex, career = Career, bag = 
    Bag = #bag{items = Items, volume = _Volumn}, link = #link{conn_pid = ConnPid}}, {ItemId, Origin_Price, Price, Quantity, Notice}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, _Item = #item{base_id = ItemBaseId}} ->

            {ok, SaleId} = key_mgr:generate(market_key_sale),
            Now = util:unixtime(),
            EndTime = Now + ?sail_time,
            % {ok, #item_base{name = ItemName}} = item_data:get(ItemBaseId),
            Type = market_data:get_type(ItemBaseId),
            case is_number(Type) of 
                    true -> 
                        MarketSale = #market_sale2{sale_id = SaleId, role_id = RoleId, srv_id = SrvId, begin_time = Now, end_time = EndTime, 
                        origin_price = Origin_Price, price = Price, quantity = Quantity, item_base_id = ItemBaseId, type = Type, saler_name = Name, saler_lev = SalerLev, saler_career = Career},
                        TmpList = [{ItemBaseId, Quantity}],

                        case storage:del(Bag, TmpList) of
                            {ok, NewBag, NewDel, Refresh} ->
                                NewRole = Role#role{bag = NewBag},
                                case Notice of
                                    0 -> ignore;
                                    1 ->
                                        ItemMsg = notice:item_msg({ItemBaseId, 0, Quantity}),
                                        MarketMsg = util:fbin(?L(<<"寄售~s,售价为~w晶钻,欲购从速咯! <a href='11344&~w'><font color='~s'><u>点击购买</u></font></a>">>), [ItemMsg, Price, SaleId, notice_color:get_color_item(5)]),
                                        role_group:pack_cast(world, 10910, {1, RoleId, SrvId, Name, Sex, VLev, [], [], MarketMsg});
                                    _ ->ignore
                                end,
                                case catch add_sale(MarketSale) of %%加入到ets以及数据库中
                                     {false, Reason} -> 
                                        role:send_buff_clean(),
                                        {false, Reason};
                                    Sale_Id->

                                        NewDel2 = [{?storage_bag, Item}||Item <- NewDel],
                                        storage_api:del_item_info(ConnPid, NewDel2),

                                        Refresh2 = [{?storage_bag, Item}||Item <- Refresh],
                                        storage_api:refresh_mulit(ConnPid, Refresh2),
                                        log:log(log_market, {Now, <<"拍卖物品">>, EndTime, MarketSale, ignore}),
                                        role:send_buff_flush(),

                                        {ok, ?MSGID(<<"物品出售成功">>), NewRole, Sale_Id}
                                end;
                            {false} ->
                                role:send_buff_clean(),
                                {false, ?MSGID(<<"使用物品出错">>)}
                        end;
                    false  ->
                        role:send_buff_clean(),
                        {false, Type}
            end;
        {false, Reason} ->
            role:send_buff_clean(),
            {false, Reason}
    end.

%% 购买出售物品
do_sale_buy(delete_sale, Role = #role{id = {Rid, SrvId}}, {#market_sale2{sale_id = SaleId, quantity = Q, price = Price, item_base_id = BaseId}}) ->
    ?DEBUG("**do_sale_buy 购买出售物品*:~w~n",["ok"]),
    case delete_sale(SaleId) of
        {ok, MarketSale} ->

            % role:send_buff_begin(),
            case role_gain:do([#loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足">>)}], Role) of 
                {false, #loss{msg = Msg}} -> 
                    % role:send_buff_clean(),
                    {false, Msg};
                {ok, NewRole} ->
                    %%产生物品的过程
                    % role:send_buff_begin(),
                    case role_gain:do([#gain{label = item, val = [BaseId, 0, Q]}], NewRole) of 
                        {ok, NewRole2} ->
                            % role:send_buff_flush(),
                            do_sale_buy(pay_for, NewRole2, {MarketSale}), 
                            {ok, NewRole2};
                        {false, #gain{err_code = ?gain_bag_full}} ->
                            award:send({Rid, SrvId}, 206000, [#gain{label = item, val = [BaseId, 0, Q]}]),
                            % role:send_buff_flush(),
                            do_sale_buy(pay_for, Role, {MarketSale}), 
                            {ok, NewRole};
                        {false, Reason} ->
                            % role:send_buff_clean(),
                            catch add_sale(MarketSale),
                            {false, Reason}
                    end;
                {false, Reason} ->
                    % role:send_buff_clean(),
                    catch add_sale(MarketSale),
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end;

%% 扣除晶钻/金币
do_sale_buy(delete_assets, Role = #role{assets = Assets = #assets{gold = RoleGold}}, {MarketSale = #market_sale2{price = Price}}) ->
    ?DEBUG("**扣除晶钻/金币*:~w~n",["ok"]),
    case RoleGold >= Price of
        true ->
            do_sale_buy(add_item, Role#role{assets = Assets#assets{gold = (RoleGold - Price)}}, {MarketSale});
        false ->
            {false, ?L(<<"亲，晶钻不足啦">>)}
    end;


%% [临时函数]添加物品
do_sale_buy(add_item, Role, {MarketSale = #market_sale2{item_base_id = _ItemBaseId, item_name = ItemName, type = _Type, quantity = Quantity, price = Price}}) ->
    ?DEBUG("**邮件添加物品*:~w~n",["add_item"]),
    Content = util:fbin(?L(<<"您花费了[~w 晶钻]购买了~w~s">>), [Price, Quantity,ItemName]),
    case mail:send_system(Role, {?L(<<"系统邮件">>), Content, [{?mail_gold, Quantity}], []}) of
        ok ->
            do_sale_buy(pay_for, Role, {MarketSale});
        {false, Reason } ->
            {false, Reason}
    end;


%% 邮件付款给拍卖者 
do_sale_buy(pay_for, Role, {_MarketSale = #market_sale2{role_id = ?market_sys_salerid}}) -> {ok, Role};
do_sale_buy(pay_for, Role, {_MarketSale = #market_sale2{role_id = RoleId, srv_id = SrvId, item_base_id = ItemBaseId, origin_price = Price}}) ->
    ?DEBUG("**邮件付款给出售者*:~w~n",[RoleId]),
    {ok, #item_base{name = ItemName}} = item_data:get(ItemBaseId),
    Content = util:fbin(?L(<<"你成功拍卖了[~s], 获得~w晶钻">>), [ItemName, Price]),
    case mail:send_system({RoleId, SrvId}, {?L(<<"系统邮件">>), Content, [{?mail_gold, Price}], []}) of
        ok ->
             ?DEBUG("**邮件付款给出售者*:~w~n",[RoleId]),
            {ok, Role};
        {false, Reason} ->
            %% TODO:删除已发出去的邮件
            {false, Reason}
    end.


%% 临时函数,接收付款
sale_pay_for(Role, AssetsType, Price) ->
    case AssetsType of
        ?assets_type_coin ->
            {ok, NewRole} = role_gain:do(#gain{label = coin, val = Price}, Role),
            {ok, NewRole};
        ?assets_type_gold ->
            {ok, NewRole} = role_gain:do(#gain{label = gold, val = Price}, Role),
            {ok, NewRole}
    end.

%% 发布求购信息前置检查
check_buy(status, Role = #role{status = Status}, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) ->
    case Status =:= ?status_fight of
        true ->
            {false, ?L(<<"战斗中是不可以拍卖物品的哦">>)};
        false ->
            case UnitPrice =< 0 of
                true ->
                    {false, ?L(<<"单价不可以小于0">>)};
                false ->
                    case Quantity =< 0 of
                        true ->
                            {false, ?L(<<"数量不可以小于0">>)};
                        false ->
                            case Quantity > 99 of
                                true ->
                                    {false, ?L(<<"求购数量不可以超过99">>)};
                                false ->
                                    check_buy(assets, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice})
                            end
                    end
            end
    end;

%% 检查资产类型信息
check_buy(assets, Role = #role{assets = #assets{gold = RoleGold, coin = RoleCoin, coin_bind = CoinBind}}, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) ->
    Tax = market_util:calc_tax(buy, {Time, Notice}),
    case AssetsType of
        ?assets_type_coin ->
            Sum = UnitPrice * Quantity,
            case RoleCoin =< Sum of
                true ->
                    {false, lang_market_not_enough_coin};
                false ->
                    case (RoleCoin + CoinBind) =< (Sum + Tax) of
                        true -> {false, lang_market_not_enough_coin};
                        false ->
                            check_buy(buy_max, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice})
                    end
            end;
        ?assets_type_gold ->
            Sum = UnitPrice * Quantity,
            case RoleGold < Sum of
                true ->
                    {?market_op_not_enough, lang_market_not_enough_gold};
                false ->
                    case (RoleCoin + CoinBind) =< Tax of
                        true -> {false, lang_market_not_enough_tax};
                        false -> check_buy(buy_max, Role, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice})
                    end
            end
    end;

%% 查询发布数量
check_buy(buy_max, _Role = #role{id = {RoleId, SrvId}}, {_ItemBaseId, _AssetsType, _UnitPrice, _Quantity, _Time, _Notice}) ->
    Reply = search(buy_self, {RoleId, SrvId}),
    case length(Reply) >= ?market_buy_max of
        true ->
            {false, ?L(<<"您发布的求购信息已经达到上限了">>)};
        false ->
            {ok}
    end.

%% 检查出售条件-状态
check_buy_sale(status, Role = #role{status = Status}, {BuyId, ItemId, Quantity}) ->
    case Status =:= ?status_fight of
        true ->
            {false, ?L(<<"战斗中是不可以拍卖物品的哦">>)};
        false ->
            check_buy_sale(item, Role, {BuyId, ItemId, Quantity})
    end;

%% 检查出售条件
check_buy_sale(item, _Role = #role{id = {RoleId, SrvId}, bag = #bag{items = Items}}, {BuyId, ItemId, Quantity}) ->
    MarketBuys  = search(buy_by_id, {BuyId}),
    case length(MarketBuys) < 1 of
        true ->
            {false, ?L(<<"您卖晚了，这东西人家已经收购完了">>)};
        false ->
            [#market_buy{quantity = MbQuantiy, item_base_id = MbItemBaseId, role_id = MbRoleId, srv_id = MbSrvId}] = MarketBuys,
            case Quantity > MbQuantiy of
                true ->
                    {false, ?L(<<"您出售的数量比人家求购的还多呢">>)};
                false ->
                    case storage:find(Items, #item.id, ItemId) of
                        {ok, #item{base_id = ItemBaseId, bind = Bind, quantity = ItemQuantity}} ->
                            case MbItemBaseId =/= ItemBaseId of
                                true ->
                                    {false, ?L(<<"您这个物品不是人家需要的那个吧">>)};
                                false ->
                                    case Quantity > ItemQuantity of
                                        true ->
                                            {false, ?L(<<"背包物品数量小于出售数理">>)};
                                        false ->
                                            case Bind =:= 1 of
                                                true ->
                                                    {false, ?L(<<"绑定的物品是不可以出售的哦">>)};
                                                false ->
                                                    case RoleId =:= MbRoleId andalso SrvId =:= MbSrvId of
                                                        true ->
                                                            {false, ?L(<<"自己求购自己出售，不好吧">>)};
                                                        false ->
                                                            {ok}
                                                    end
                                            end
                                    end
                            end;
                        {false, Reason} ->
                            {false, Reason}
                    end
            end
    end.

%% 发布求购信息-扣除资产值
do_buy(assets, Role = #role{assets = #assets{coin_bind = CoinBind}}, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) ->
    Tax = market_util:calc_tax(buy, {Time, Notice}),
    Sum = UnitPrice * Quantity,
    LossTax = case CoinBind >= Tax of
        true -> [#loss{label = coin_bind, val = Tax}];
        false ->
            case CoinBind > 0 of
                true ->
                    [#loss{label = coin_bind, val = CoinBind}, #loss{label = coin, val = (Tax - CoinBind)}];
                false ->
                    [#loss{label = coin, val = Tax}]
            end
    end,
    LossList = case AssetsType of
        ?assets_type_coin ->
            [#loss{label = coin, val = Sum} | LossTax];
        ?assets_type_gold ->
            [#loss{label = gold, val = Sum} | LossTax]
    end,
    case role_gain:do(LossList, Role) of
        {ok, NewRole} ->
            do_buy(issue, NewRole, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice});
        {false, Reason} ->
            {false, Reason}
    end;

%% 发布求购信息-求购 
do_buy(issue, Role = #role{id = {RoleId, SrvId}, name = RoleName, vip = #vip{type = Vip}, label = Label, realm = Realm, sex = Sex}, {ItemBaseId, AssetsType, UnitPrice, Quantity, Time, Notice}) ->
    %% BuyId = get_key(?market_buy_key_str),
    {ok, BuyId} = key_mgr:generate(market_key_buy),
    EndTime = util:unixtime() + (Time * 60 * 60),
    {ok, #item_base{name = ItemName, type = Type, quality = Quality, condition = Condition}} = item_data:get(ItemBaseId),
    Lev = case lists:keyfind(lev, #condition.label, Condition) of
        false -> 0;
        #condition{target_value = ItemLev} -> ItemLev
    end,
    Career = case lists:keyfind(career, #condition.label, Condition) of
        false -> 9;
        #condition{target_value = GetCareer} -> GetCareer
    end, 
    TypeScort = case market_data_type:type_ref(Type) of
        {ok, TScort} -> TScort;
        _ ->
            ?ERR("没找到物品类型对应信息[~w]", [Type]),
            Type
    end,
    MarketBuy = #market_buy{buy_id = BuyId, role_id = RoleId, srv_id = SrvId, role_name = RoleName, begin_time = util:unixtime(), end_time = EndTime, assets_type = AssetsType, unit_price = UnitPrice, quantity = Quantity, item_base_id = ItemBaseId, item_name = ItemName, type = Type, quality = Quality, lev = Lev, career = Career, type_scort = TypeScort},
    case catch add_buy(MarketBuy) of
        {false, Reason} ->
            {false, Reason};
        _ ->
            case Notice of
                1 ->
                    ItemMsg = notice:item_to_msg({ItemBaseId, 0, 1}),
                    case AssetsType of
                        ?assets_type_coin ->
                            MarketMsg = util:fbin(?L(<<"求购~s，求购单价为{str, ~w, #ffe100}金币，有货的速速出售咯，{handle, 30, 我要出售, FFFF66, ~w, ~s, ~w, ~w}">>), [ItemMsg, UnitPrice, RoleId, SrvId, ItemBaseId, BuyId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, RoleName, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg);
                        _ ->
                            MarketMsg = util:fbin(?L(<<"求购~s，求购单价为{str, ~w, #ffe100}晶钻，有货的速速出售咯，{handle, 30, 我要出售, FFFF66, ~w, ~s, ~w, ~w}">>), [ItemMsg, UnitPrice, RoleId, SrvId, ItemBaseId, BuyId]),
                            notice:send(?chat_world, 60, RoleId, SrvId, RoleName, Sex, Vip, [Label, chat:to_realm(Realm)], MarketMsg)
                    end;
                _ ->
                    ok
            end,
            {ok, Role}
    end.

%% 出售物品
do_buy_sale(item, Role = #role{bag = Bag = #bag{items = Items}, link = #link{conn_pid = ConnPid}}, {BuyId, ItemId, Quantity}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item = #item{base_id = ItemBaseId, quantity = OQuantity}} ->
            case delete_buy(BuyId, ItemBaseId, Quantity) of
                {ok, MarketBuy = #market_buy{role_id = MbRoleId, srv_id = MbSrvId, item_name = ItemName, assets_type = AssetsType, unit_price = UnitPrice}} ->
                    case storage:del_item_by_id(Bag, ItemId, Quantity, true, [], []) of
                        {ok, NewBag, _, _} ->
                            SendItem = Item#item{quantity = Quantity, lasttime = util:unixtime()},
                            Content = util:fbin(?L(<<"你成功求购到了[~s]">>), [ItemName]),
                            case mail:send_system({MbRoleId, MbSrvId}, {?L(<<"系统邮件">>), Content, [], [SendItem]}) of
                                ok ->
                                    case OQuantity =< Quantity of
                                        true -> storage_api:del_item_info(ConnPid, [{?storage_bag, Item}]);
                                        false -> storage_api:refresh_single(ConnPid, {?storage_bag, Item#item{quantity = OQuantity - Quantity}})
                                    end,
                                    Sum = Quantity * UnitPrice,
                                    case AssetsType of
                                        ?assets_type_coin ->
                                            {ok, NewRole} = role_gain:do(#gain{label = coin, val = Sum}, Role),
                                            {ok, NewRole#role{bag = NewBag}};
                                        ?assets_type_gold ->
                                            {ok, NewRole} = role_gain:do(#gain{label = gold, val = Sum}, Role),
                                            {ok, NewRole#role{bag = NewBag}}
                                    end;
                                {false, Reason } ->
                                    {false, Reason}
                            end;
                        {false, Reason} ->
                            buy_delete_check(MarketBuy, Quantity, false),
                            {false, Reason}
                    end;
                {false, Reason} ->
                    {false, Reason}
            end;
        {false, Reason} ->
            {false, Reason}
    end.

buy_receive_item(Role, Item) ->
    case storage:add(bag, Role, [Item]) of
        false ->
            ?DEBUG("你的背包已满，收不到求购的物品"),
            {ok, Role};
        {ok, NewBag} ->
            NewRole = Role#role{bag = NewBag},
            {ok, NewRole}
    end.

%% 删除过期拍卖品
delete_expire(sale, [MarketSale = #market_sale2{role_id = RoleId, srv_id = SrvId, sale_id = SaleId, type = _Type, item_base_id = ItemBaseId, quantity = Quantity} | T]) ->
    case market_dao:delete_sale2(SaleId) of
        {ok, _} ->
            ets:delete(market_sale, SaleId),
            log:log(log_market, {<<"退还成功">>, MarketSale, ignore}),
            % PriceScort = calc_price_sort(MarketSale),
            % ets:delete(ets_market_sale_pricesort, PriceScort),
            % {ok, [RtnItem]} = item:make(ItemBaseId, 0, Quantity),
            Content = util:fbin(?L(<<"拍卖信息到期，系统归还物品[~s]归还给你。">>), [MarketSale#market_sale2.item_name]),
            case mail:send_system({RoleId, SrvId}, {?L(<<"系统邮件">>), Content, [], [{ItemBaseId, 0, Quantity}]}) of
                ok ->
                    ?DEBUG("***删除过期拍卖品***\n"),
                    ok;
                {false, Reason} ->
                    ?ERR("【市场】买了个杯具，过期物品发邮件失败了:~w", [Reason])
            end;
        {false, _} -> ignore
    end,
    delete_expire(sale, T);
delete_expire(sale, []) ->
    ok;

%% 删除求购信息
delete_expire(buy, [#market_buy{buy_id = BuyId, role_id = RoleId, srv_id = SrvId, assets_type = ?assets_type_coin, unit_price = UnitPrice, quantity = Quantity} | T]) ->
    Sum = Quantity * UnitPrice,
    Content = ?L(<<"求购信息到期，系统归还物品[金币]给你。">>),
    case market_dao:delete_buy(BuyId) of
        {ok, _Affected} ->
            ets:delete(market_buy, BuyId),
            case mail:send_system({RoleId, SrvId}, {?L(<<"系统邮件">>), Content, [{?mail_coin, Sum}], []}) of
                ok ->
                    delete_expire(buy, T);
                {false, _Reason} ->
                    delete_expire(buy, T)
            end;
        {error, Reason} ->
            ?ERR("删除求购信息出错了:~w", [Reason]),
            delete_expire(buy, T)
    end;

delete_expire(buy, [#market_buy{buy_id = BuyId, role_id = RoleId, srv_id = SrvId, assets_type = ?assets_type_gold, unit_price = UnitPrice, quantity = Quantity} | T]) ->
    Sum = Quantity * UnitPrice,
    Content = ?L(<<"求购信息到期，系统归还物品[晶钻]给你。">>),
    case market_dao:delete_buy(BuyId) of
        {ok, _Affected} ->
            ets:delete(market_buy, BuyId),
            case mail:send_system({RoleId, SrvId}, {?L(<<"系统邮件">>), Content, [{?mail_gold, Sum}], []}) of
                ok ->
                    delete_expire(buy, T);
                {false, _Reason} ->
                    delete_expire(buy, T)
            end;
        {error, Reason} ->
            ?ERR("删除求购信息出错了:~w", [Reason]),
            delete_expire(buy, T)
    end;

delete_expire(buy, []) ->
    ok.



%% 生成匹配字符串
parse_ms([Opt | T]) ->
    Ms = parse_ms(T),
    MsHead = parse_ms_cell(Opt),
    case length(Ms) > 0 of
        true ->
            case length(MsHead) > 0 of
                true ->
                    MsHead ++ ", " ++ Ms;
                false ->
                    Ms
            end;
        false -> 
            MsHead
    end;
parse_ms([]) ->
    "".

%% 类型
parse_ms_cell({type, Index, Type}) ->
    case Type =:= 99 of
        true ->
            "";
        false ->
            lists:concat(["{'=:=', '", Index, "', ", Type, "}"])
            %% util:term_to_string({'=:=', Index, Type})
    end;
%% 最小等级
parse_ms_cell({min_lev, Index, MinLev}) ->
    case MinLev =:= 0 of
        true ->
            "";
        false ->
            lists:concat(["{'>=', '", Index, "', ", MinLev, "}"])
            %% util:term_to_string({'>=', Index, MinLev})
    end;
%% 最大等级
parse_ms_cell({max_lev, Index, MaxLev}) ->
    case MaxLev =:= 0 of
        true ->
            "";
        false ->
            lists:concat(["{'=<', '", Index, "', ", MaxLev, "}"])
            %% util:term_to_string({'=<', Index, MaxLev})
    end;
%%品质
parse_ms_cell({quality, Index, Quality}) ->
    case Quality =:= 9 of
        true ->
            "";
        false ->
            lists:concat(["{'=:=', '", Index, "', ", Quality, "}"])
            %% util:term_to_string({'=:=', Index, Quality})
    end;
%% 职业
parse_ms_cell({career, Index, Career}) ->
    case Career =:= 9 of
        true ->
            "";
        false ->
            lists:concat(["{'=:=', '", Index, "', ", Career, "}"])
            %% util:term_to_string({'=:=', Index, Career})
    end.
    
%% 物品名称过滤
name_filter(sale, [Sale = #market_sale{item_name = ItemName} | T], SearchName) ->
    case string:str(util:to_list(ItemName), util:to_list(SearchName)) > 0 of
        true ->
            [Sale | name_filter(sale, T, SearchName)];
        false ->
            name_filter(sale, T, SearchName)
    end;
name_filter(sale, [], _SearchName) ->
    [];

name_filter(buy, [Buy = #market_buy{item_name = ItemName} | T], SearchName) ->
    case string:str(util:to_list(ItemName), util:to_list(SearchName)) > 0 of
        true ->
            [Buy | name_filter(buy, T, SearchName)];
        false ->
            name_filter(buy, T, SearchName)
    end;
name_filter(buy, [], _SearchName) ->
    [].
       
%% 取当前页数据

do_page2([], _OffsetStart, _OffsetEnd, _Index,T) -> T;
do_page2(_, _OffsetStart, OffsetEnd, OffsetEnd,T) -> T;
do_page2([Data | T], OffsetStart, OffsetEnd, Index, Temp) ->
    case OffsetStart =< Index of
        true ->
            do_page2(T, OffsetStart, OffsetEnd, (Index + 1),[Data|Temp]);    
        false ->
            do_page2(T, OffsetStart, OffsetEnd, (Index + 1),Temp)
    end.

do_page([Data | T], OffsetStart, OffsetEnd, Index) ->
    case OffsetStart =< Index of
        true ->
            case Index =< OffsetEnd of
                true ->
                    [Data | do_page(T, OffsetStart, OffsetEnd, (Index + 1))];
                false ->
                    []
            end;
        false ->
            do_page(T, OffsetStart, OffsetEnd, (Index + 1))
    end;
do_page([], _OffsetStart, _OffsetEnd, _Index) ->
    [].

%% 处理均价
deal_avgprice(#market_sale{item_base_id = ItemBaseId, assets_type = ?assets_type_coin, price = Price, quantity = Quantity}) ->
    case ets:lookup(market_average, ItemBaseId) of
        [] -> 
            Quantity2 = case Quantity < 1 of
                true -> 1;
                false -> Quantity
            end,
            Avg = #market_avgprice{item_base_id = ItemBaseId, coin_price_sum = Price, coin_num = Quantity2},
            ets:insert(market_average, Avg);
        [Avg = #market_avgprice{coin_price_sum = CoinPriceSum, coin_num = CoinNum}] ->
            Quantity2 = case Quantity < 1 of
                true -> 1;
                false -> Quantity
            end,
            NewAvg = Avg#market_avgprice{coin_price_sum = CoinPriceSum + Price, coin_num = CoinNum + Quantity2},
            ets:insert(market_average, NewAvg);
        _ -> ignore
    end;
deal_avgprice(#market_sale{item_base_id = ItemBaseId, assets_type = ?assets_type_gold, price = Price, quantity = Quantity}) ->
    case ets:lookup(market_average, ItemBaseId) of
        [] -> 
            Quantity2 = case Quantity < 1 of
                true -> 1;
                false -> Quantity
            end,
            Avg = #market_avgprice{item_base_id = ItemBaseId, gold_price_sum = Price, gold_num = Quantity2},
            ets:insert(market_average, Avg);
        [Avg = #market_avgprice{gold_price_sum = GoldPriceSum, gold_num = GoldNum}] ->
            Quantity2 = case Quantity < 1 of
                true -> 1;
                false -> Quantity
            end,
            NewAvg = Avg#market_avgprice{gold_price_sum = GoldPriceSum + Price, gold_num = GoldNum + Quantity2},
            ets:insert(market_average, NewAvg);
        _ -> ignore
    end;
deal_avgprice(_) ->
    ?ERR("处理均价有误"),
    ignore.

%% 获取排序字段 return {PriceType, SinglePricc, SaleId}
% calc_price_sort(#market_sale{sale_id = SaleId}) ->
%     1893427200 - SaleId.
calc_price_sort(SaleId, _AssetsType, _Price, _Quantity) ->
    1893427200 - SaleId.
%% calc_price_sort(#market_sale{sale_id = SaleId, assets_type = AssetsType, price = Price, quantity = Quantity}) ->
%%     calc_price_sort(SaleId, AssetsType, Price, Quantity).
%% calc_price_sort(SaleId, AssetsType, Price, Quantity) ->
%%     PriceType = case AssetsType of
%%         ?assets_type_coin -> 1;
%%         ?assets_type_gold -> 0;
%%         _ -> 1
%%     end,
%%     SPrice = case Quantity > 0 of
%%         true ->
%%             round(Price * 100000 / Quantity);
%%         false -> 1
%%     end,
%%     {PriceType, SPrice, SaleId}.

%% 计算税后价格
calc_price_tax(?assets_type_coin, Price) -> Price;
calc_price_tax(?assets_type_gold, Price) -> %% 晶钻出售税计算
    IfOpen = platform_cfg:get_cfg(market_price_tax),
    ?DEBUG("是否开启收税~p~n", [IfOpen]),
    case IfOpen of
        1 ->
            Tax = case erlang:trunc(Price * 0.1) of
                %% N when N < 1 -> 1;
                N when N > 10 -> 10;
                N -> N
            end,
            Price + Tax;
        _ ->
            Price
    end;
calc_price_tax(_AssetsType, Price) -> Price.




