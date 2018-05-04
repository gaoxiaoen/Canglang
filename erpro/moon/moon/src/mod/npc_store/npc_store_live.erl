%%----------------------------------------------------
%%  NPC 活动商店
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(npc_store_live).
-behaviour(gen_server).
-export([apply/2, start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
        market_gold = []         %% 市场交易晶钻 [{Time, Gold, Coin}...]
        ,market_coin = []        %% 市场交易金币 [{Time, Gold, Coin}...]
        ,refresh_time = 0        %% 下一次更新时间
        ,price_list = []         %% 当前价格列表 [{BaseId, Price}]
    }
).

-include("common.hrl").
-include("role.hrl").
-include("npc_store.hrl").
%%
-include("item.hrl").
-include("storage.hrl").
-include("gain.hrl").

%% 异步方法调用
%% npc_store_live:apply(async, {gold_coin, Gold, Coin}). %% 晶钻拍卖
%% npc_store_live:apply(async, {coin_gold, Coin, Gold}). %% 金币拍卖
apply(async, Args) ->
    gen_server:cast(?MODULE, Args);
%% 同步方法调用
apply(sync, Args) ->
    gen_server:call(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("正在启动..."),
    %% TODO 获取当天金币产出
    State = case catch sys_env:get(npc_store_live) of
        S when is_record(S, state) -> S;
        _ -> update_price_list(#state{})
    end,
    {SS, MS} = next_time(update),
    erlang:send_after(MS, self(), update),
    process_flag(trap_exit, true),
    ?INFO("启动完成..."),
    {ok, State#state{refresh_time = SS}}.

%% 获取当前价格数据
handle_call(get_all, _From, State) ->
    {reply, {State}, State};
handle_call(get, _From, State = #state{refresh_time = RT, price_list = PList}) ->
    {reply, {RT, PList}, State};

%% 出售物品
handle_call({sale, {Type, Ids}, Role = #role{bag = Bag}}, _From, State = #state{price_list = PList}) ->
    case npc_store:get_items(Bag, Ids, []) of %% 根据ID从背包中获取物品
        {false, Reason} -> {reply, {false, Reason}, State};
        {ok, Items} ->
            {PLabel, PL} = case Type =:= 0 of
                true -> {coin, PList};
                _ -> {coin_bind, ?npc_store_live_bind_items}
            end,
            case sum_price(Items, PL, 0) of %% 统计物品价格
                false -> {reply, {false, ?L(<<"计算物品价格失败">>)}, State};
                {ok, TotalPrice} -> 
                    DelItems = [{Id, Num} || #item{id = Id, quantity = Num} <- Items],
                    G = [
                        #loss{label = item_id, val = DelItems}
                        ,#gain{label = PLabel, val = TotalPrice}
                    ],
                    case role_gain:do(G, Role) of
                        {false, #gain{}} -> {reply, {false, ?L(<<"增加金币失败">>)}, State};
                        {false, #loss{}} -> {reply, {false, ?L(<<"删除物品失败">>)}, State}; 
                        {ok, NRole} ->
                            npc_store:send_inform(NRole, ?npc_store_nor_coin, TotalPrice),
                            log:log(log_item_del, {Items, <<"金银兑换">>, <<"背包">>, Role}),
                            log:log(log_coin, {<<"金银兑换">>, <<"">>, Role, NRole}),
                            {reply, {ok, NRole}, State}
                    end
            end
    end;

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 金币晶钻交易
handle_cast({gold_coin, Gold, Coin}, State = #state{market_gold = MGold}) -> %% 晶钻拍卖
    {noreply, State#state{market_gold = [{util:unixtime(), Gold, Coin} | MGold]}};
handle_cast({coin_gold, Coin, Gold}, State = #state{market_coin = MCoin}) -> %% 金币拍卖
    {noreply, State#state{market_coin = [{util:unixtime(), Gold, Coin} | MCoin]}};

%% 设置市场交易金币晶钻(GM命令)
handle_cast({set_gold_coin, Gold, Coin}, State = #state{market_coin = MCoin}) ->
    {noreply, State#state{market_coin = [{util:unixtime(), Gold, Coin} | MCoin]}};

%% 重置数据(GM命令)
handle_cast(reset, State) ->
    {noreply, State#state{market_gold = [], market_coin = []}};

%% 更新数据(GM命令)
handle_cast(update, State) ->
    {noreply, update_price_list(State)};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 数据定时更新
handle_info(update, State) ->
    ?INFO("开始执行数据更新！"),
    {SS, MS} = next_time(update),
    NewState = update_price_list(State),
    erlang:send_after(MS, self(), update),
    ?INFO("结束执行数据更新"),
    {noreply, NewState#state{refresh_time = SS}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    %% TODO 保存当天金币产出
    %% sys_env:save(npc_store_live, State),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------
%% 内部方法
%%--------------------------------------------------------------

%% 获取下一次更新时间
next_time(update) -> %% 每天 3、9、15、21点更新一次
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Time = case Now - Today of
        N when N < 3 * 3600 -> %% 0到3点
            3 * 3600 - N;
        N when N < 6 * 3600 -> %% 3到6点
            6 * 3600 - N;
        N when N < 9 * 3600 -> %% 6到9点
            9 * 3600 - N;
        N when N < 12 * 3600 -> %% 9到12点
            12 * 3600 - N;
        N when N < 15 * 3600 -> %% 12到15点
            15 * 3600 - N;
        N when N < 18 * 3600 -> %% 15到18点
            18 * 3600 - N;
        N when N < 21 * 3600 -> %% 18到21点
            21 * 3600 - N;
        N when N < 24 * 3600 -> %% 21到24点
            24 * 3600 - N;
        N -> %% 24点到27点
            27 * 3600 - N
    end,
    {Now + Time, Time * 1000}.

%% 统计物品价格
sum_price([], _PList, TotalPrice) -> {ok, TotalPrice};
sum_price([#item{base_id = BaseId, quantity = Num} | T], PList, TotalPrice) ->
    case lists:keyfind(BaseId, 1, PList) of
        {BaseId, Price} ->
            sum_price(T, PList, TotalPrice + Price * Num);
        _ -> 
            false
    end.

%% 获取新的物品价格数据
update_price_list(State = #state{market_gold = MGold, market_coin = MCoin}) ->
    TimeOut = util:unixtime() - 86400,
    NewMGold = [{Time, Gold, Coin} || {Time, Gold, Coin} <- MGold, Time >= TimeOut],
    NewMCoin = [{Time, Gold, Coin} || {Time, Gold, Coin} <- MCoin, Time >= TimeOut],
    {TGold, TCoin} = sum_gold_coin(NewMGold, 0, 0),
    {TotalGold, TotalCoin} = sum_gold_coin(NewMCoin, TGold, TCoin),
    Now = util:unixtime(), 
    Num = case sys_env:get(srv_open_time) of
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 3 * 3600 -> 140;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 6 * 3600 -> 120;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 9 * 3600 -> 100;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 12 * 3600 -> 80;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 15 * 3600 -> 60;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 18 * 3600 -> 40;
        OpenTime when is_integer(OpenTime) andalso Now - OpenTime < 21 * 3600 -> 20;
        _ -> 
            case sys_env:get(merge_time) of
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 3 * 3600 -> 140;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 6 * 3600 -> 120;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 9 * 3600 -> 100;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 12 * 3600 -> 80;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 15 * 3600 -> 60;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 18 * 3600 -> 40;
                MergeTime when is_integer(MergeTime) andalso Now - MergeTime < 21 * 3600 -> 20;
                _ -> 0
            end
    end,
    PricePer = price_per(TotalCoin, TotalGold), %% 参数A
    NumPer = market_num_per(Num + length(NewMCoin)), %% 参数B
    ?DEBUG("开服附加次数:~p 价格比例:~w 次数比例:~w ~n开服时间:~w 当前旧状态:~w", [Num, PricePer, NumPer, sys_env:get(srv_open_time), State]),
    %% [{BaseId, lists:min([erlang:round(Price * PricePer) + util:rand(1, 2 * N) - N, Price])} || {BaseId, Price, N} <- ?npc_store_live_base].
    PriceList = [{BaseId, erlang:round(Price * PricePer * NumPer) - util:rand(1, N) + 1} || {BaseId, Price, N} <- ?npc_store_live_base],

%%    PriceList = if
%%        TotalGold =/= 0 andalso TotalCoin/TotalGold < 4000 -> %% 当晶钻与金币比例区间为1:1~1:4000之间时 =====> 物品价值*参数A*参数B±波动值
%%            [{BaseId, erlang:round(Price * PricePer * NumPer) - util:rand(1, N) + 1} || {BaseId, Price, N} <- ?npc_store_live_base];
%%        true -> %% 物品价值*参数A±波动值
%%            [{BaseId, erlang:round(Price * PricePer) - util:rand(1, N) + 1} || {BaseId, Price, N} <- ?npc_store_live_base]
%%    end,
    NewState = State#state{market_gold = NewMGold, market_coin = NewMCoin, price_list = PriceList},
    sys_env:save(npc_store_live, NewState),
    [{_, Price1}, {_, Price2}] = PriceList,
    log:log(log_npc_store_live, {TotalCoin, TotalGold, length(NewMGold), Price1, Price2, PricePer, NumPer}),
    NewState.

%% 计算晶钻金币数目
sum_gold_coin([], Gold, Coin) -> {Gold, Coin};
sum_gold_coin([{_Time, Gold, Coin} | T], TGold, TCoin) ->
    sum_gold_coin(T, Gold + TGold, Coin + TCoin).

%% 根据交易次数获取比例
market_num_per(N) when N > 96 -> 1;
market_num_per(N) when N > 84 -> 1.07;
market_num_per(N) when N > 72 -> 1.14;
market_num_per(N) when N > 60 -> 1.21;
market_num_per(N) when N > 48 -> 1.28;
market_num_per(N) when N > 36 -> 1.35;
market_num_per(N) when N > 24 -> 1.42;
market_num_per(N) when N > 18 -> 1.49;
market_num_per(N) when N > 12 -> 1.56;
market_num_per(N) when N > 6 -> 1.63;
market_num_per(_) -> 1.7.

%% 获取价格比例
price_per(_MCoin, 0) -> 1;
price_per(MCoin, MGold) ->
    price_per(MCoin/MGold).
price_per(N) when N < 4000 -> 1;
price_per(N) when N < 4500 -> 0.95;
price_per(N) when N < 5000 -> 0.9;
price_per(N) when N < 6000 -> 0.85;
price_per(N) when N < 8000 -> 0.8;
price_per(N) when N < 11000 -> 0.75;
price_per(N) when N < 14000 -> 0.7;
price_per(N) when N < 19000 -> 0.65;
price_per(N) when N < 29000 -> 0.6;
price_per(N) when N < 39000 -> 0.55;
price_per(_) -> 0.5.

%%-----------------------------------------------
%% 活跃玩家算法 过期先注释掉 以后可能会用到
%%-----------------------------------------------

%% 获取新的物品价格数据
%% get_price_list(TodayCoin) ->
%%    {Num, AvgLev} = npc_store_dao:get_activity(),
%%    LevCoin = lev_coin(AvgLev),
%%    TotalCoin = Num * LevCoin,
%%    PricePer = price_per(TodayCoin, TotalCoin),
%%    [{BaseId, erlang:round(Price * PricePer)} || {BaseId, Price} <- ?npc_store_live_base].

%% 等级每日最大收益金币
%% lev_coin(AvgLev) when AvgLev < 30 -> 101000;
%% lev_coin(AvgLev) when AvgLev < 35 -> 156857.77;
%% lev_coin(AvgLev) when AvgLev < 40 -> 171360.29;
%% lev_coin(AvgLev) when AvgLev < 45 -> 246142.86;
%% lev_coin(AvgLev) when AvgLev < 50 -> 252142.86;
%% lev_coin(AvgLev) when AvgLev < 55 -> 371357.14;
%% lev_coin(AvgLev) when AvgLev < 60 -> 379357.14;
%% lev_coin(AvgLev) when AvgLev < 65 -> 508571.43;
%% lev_coin(AvgLev) when AvgLev < 70 -> 518571.43;
%% lev_coin(_) -> 66.978571.

%% 获取价格百分比
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< TotalCoin -> 1;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.05 * TotalCoin -> 0.95;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.11 * TotalCoin -> 0.9;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.18 * TotalCoin -> 0.85;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.25 * TotalCoin -> 0.8;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.33 * TotalCoin -> 0.75;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.43 * TotalCoin -> 0.7;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.54 * TotalCoin -> 0.65;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.67 * TotalCoin -> 0.6;
%% price_per(TodayCoin, TotalCoin) when TodayCoin =< 1.82 * TotalCoin -> 0.55;
%% price_per(_TodayCoin, _TotalCoin) -> 0.5.

