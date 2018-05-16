%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 八月 2016 16:48
%%%-------------------------------------------------------------------
-module(panic_buying_handle).
-author("hxming").

-include("panic_buying.hrl").
-include("common.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).


handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

%%检查活动状态
handle_cast({check_state, Node, Sid}, State) ->
    if State#st_panic_buying.open_state == 0 -> ok;
        true ->
            Now = util:unixtime(),
            {ok, Bin} = pt_153:write(15301, {1, max(0, State#st_panic_buying.time - Now)}),
            center:apply(Node, server_send, send_to_sid, [Sid, Bin])
    end,
    {noreply, State};

%%夺宝物品列表
handle_cast({check_goods_list, Node, Pkey, Sid}, State) ->
    Data =
        if State#st_panic_buying.open_state == 0 ->
            {2, 0, []};
            true ->
                Now = util:unixtime(),
                F = fun(PB) ->
                    HadBuyLen = lists:sum([length(Mb#pb_mb.num_list) || Mb <- PB#pb_goods.buy_log]),
                    MyBuyLen = case lists:keyfind(Pkey, #pb_mb.pkey, PB#pb_goods.buy_log) of
                                   false -> 0;
                                   Mb -> length(Mb#pb_mb.num_list)
                               end,
                    Time = max(0, PB#pb_goods.time - Now),
                    [[PB#pb_goods.id, PB#pb_goods.type, PB#pb_goods.date, PB#pb_goods.goods_id, PB#pb_goods.num,
                        HadBuyLen, PB#pb_goods.times, MyBuyLen, PB#pb_goods.state, Time]]
                    end,
                GoodsList = lists:map(F, get_unfinish_goods_list(State#st_panic_buying.goods_list)),
                {1, max(0, State#st_panic_buying.time - Now), GoodsList}
        end,
    {ok, Bin} = pt_153:write(15302, Data),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

%%查看往期记录
handle_cast({review_goods_list, Node, Sid, Type, Page}, State) ->
    GoodsList = get_finish_goods_list(State#st_panic_buying.goods_list, Type),
    GoodsList1 = lists:reverse(lists:keysort(#pb_goods.id, GoodsList)),
    GoodsLen = length(GoodsList1),
    MaxPage = GoodsLen div 8 + 1,
    Data =
        if Page > MaxPage orelse Page < 0 -> {0, MaxPage, []};
            true ->
                NowPage = if Page == 0 -> 1;true -> Page end,
                GoodsList2 = lists:sublist(GoodsList1, NowPage * 8 - 7, 8),
                F = fun(PB) ->
                    {Sn, Nickname, Times} =
                        case lists:keyfind(PB#pb_goods.pkey, #pb_mb.pkey, PB#pb_goods.buy_log) of
                            false -> {0, <<>>, 0};
                            Mb -> {Mb#pb_mb.sn, Mb#pb_mb.nickname, length(Mb#pb_mb.num_list)}
                        end,
                    [PB#pb_goods.goods_id, PB#pb_goods.num, PB#pb_goods.date, Sn, Nickname, Times, PB#pb_goods.lucky_num]
                    end,
                GoodsList3 = lists:map(F, GoodsList2),
                {NowPage, MaxPage, GoodsList3}
        end,
    {ok, Bin} = pt_153:write(15303, Data),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({check_my_pay, Node, Pkey, Sid, Page}, State) ->
    GoodsList = lists:filter(fun(PB) ->
        lists:keymember(Pkey, #pb_mb.pkey, PB#pb_goods.buy_log) end, State#st_panic_buying.goods_list),
    GoodsLen = length(GoodsList),
    MaxPage = GoodsLen div 3 + 1,
    Data =
        if Page > MaxPage orelse Page < 0 -> {0, MaxPage, []};
            true ->
                NowPage = if Page == 0 -> 1;true -> Page end,
                NewGoodsList = lists:sublist(GoodsList, NowPage * 3 - 2, 3),
                F = fun(PB) ->
                    NewMb = lists:keyfind(Pkey, #pb_mb.pkey, PB#pb_goods.buy_log),
                    NumLen = length(NewMb#pb_mb.num_list),
                    IsLucky = ?IF_ELSE(lists:member(PB#pb_goods.lucky_num, NewMb#pb_mb.num_list), 1, 0),
                    [PB#pb_goods.goods_id, PB#pb_goods.num, PB#pb_goods.date, NewMb#pb_mb.time, NumLen,
                        PB#pb_goods.state, IsLucky, PB#pb_goods.lucky_num, lists:sort(NewMb#pb_mb.num_list)]
                    end,
                GoodsList3 = lists:map(F, NewGoodsList),
                {NowPage, MaxPage, GoodsList3}
        end,
    {ok, Bin} = pt_153:write(15304, Data),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State};

handle_cast({pay_goods, Node, Sn, Pkey, Pid, Nickname, Sid, Id, Num, PayList}, State) ->
    {Ret, GoodsList} =
        if State#st_panic_buying.open_state == 0 ->
            {2, State#st_panic_buying.goods_list};
            true ->
                case lists:keytake(Id, #pb_goods.id, State#st_panic_buying.goods_list) of
                    false -> {5, State#st_panic_buying.goods_list};
                    {value, Goods, T} ->
                        if Goods#pb_goods.state /= ?PANIC_BUYING_STATE_BUY ->
                            {6, State#st_panic_buying.goods_list};
                            true ->
                                HadBuyLen = lists:sum([length(Mb#pb_mb.num_list) || Mb <- Goods#pb_goods.buy_log]),
                                case Goods#pb_goods.times - HadBuyLen >= Num of
                                    false -> {7, State#st_panic_buying.goods_list};
                                    true ->
                                        NumList = panic_buying_init:number_list(Goods#pb_goods.type, Goods#pb_goods.date, HadBuyLen, Num),
                                        BuyLog =
                                            case lists:keytake(Pkey, #pb_mb.pkey, Goods#pb_goods.buy_log) of
                                                false ->
                                                    [#pb_mb{sn = Sn, pkey = Pkey, nickname = Nickname, num_list = NumList, time = util:unixtime()} | Goods#pb_goods.buy_log];
                                                {value, Mb, T1} ->
                                                    [#pb_mb{sn = Sn, pkey = Pkey, nickname = Nickname, num_list = NumList ++ Mb#pb_mb.num_list, time = util:unixtime()} | T1]
                                            end,
                                        NewGoods = Goods#pb_goods{buy_log = BuyLog},
                                        panic_buying_load:replace(NewGoods),
                                        %%售完加入开奖
                                        ?IF_ELSE(HadBuyLen + Num >= Goods#pb_goods.times, self() ! {ready, Id}, ok),
                                        server_send:send_node_pid(Node, Pid, {panic_buying, PayList}),
                                        {1, [NewGoods | T]}
                                end
                        end
                end
        end,
    {ok, Bin} = pt_153:write(15305, {Ret}),
    center:apply(Node, server_send, send_to_sid, [Sid, Bin]),
    {noreply, State#st_panic_buying{goods_list = GoodsList}};

handle_cast(Msg, State) ->
    ?DEBUG("msg udef ~p~n", [Msg]),
    {noreply, State}.

%%初始化数据
handle_info(init, State) ->
    case center:is_center_all() of
        true ->
            Now = util:unixtime(),
            GoodsList = panic_buying_init:init(Now),
            {OpenState, EndTime} =
                case panic_buying:is_activity_time(Now) of
                    false -> {0, 0};
                    {true, Time} ->
                        {1, Time + Now}
                end,
            {noreply, State#st_panic_buying{goods_list = GoodsList, open_state = OpenState, time = EndTime}};
        false -> {noreply, State}
    end;

handle_info(timer, State) ->
    util:cancel_ref([State#st_panic_buying.ref]),
    Ref = erlang:send_after(60000, self(), timer),
    F = fun({Sn, Pkey, Type, Date, LuckyId, Ret, GoodsId, Num}) ->
        case center:get_node_by_sn(Sn) of
            false -> [{Sn, Pkey, Type, Date, LuckyId, Ret, GoodsId, Num}];
            Node ->
                center:apply(Node, panic_buying, mail_reward, [Pkey, Type, Date, LuckyId, Ret, GoodsId, Num]),
                []
        end
        end,
    CacheList =
        lists:flatmap(F, State#st_panic_buying.cache_list),
    {noreply, State#st_panic_buying{ref = Ref, cache_list = CacheList}};

%%活动开始
handle_info(activity_start, State) ->
    Now = util:unixtime(),
    case panic_buying:is_activity_time(Now) of
        false ->
            {noreply, State};
        {true, Time} ->
            {ok, Bin} = pt_153:write(15301, {1, Time}),
            F = fun(Node) -> center:apply(Node, server_send, send_to_all, [Bin]) end,
            lists:foreach(F, center:get_nodes()),
            panic_buying_load:clean_db(),
            GoodsList = panic_buying_init:default_list(Now),
            {noreply, State#st_panic_buying{goods_list = GoodsList, open_state = 1, time = Time + Now}}
    end;

%%活动结束
handle_info(activity_close, State) ->
    {ok, Bin} = pt_153:write(15301, {0, 0}),
    F = fun(Node) -> center:apply(Node, server_send, send_to_all, [Bin]) end,
    lists:foreach(F, center:get_nodes()),
    panic_buying_load:clean_db(),
    {noreply, State#st_panic_buying{goods_list = [], open_state = 0, time = 0}};

%%准备开奖
handle_info({ready, Id}, State) ->
    GoodsList =
        case lists:keytake(Id, #pb_goods.id, State#st_panic_buying.goods_list) of
            false -> State#st_panic_buying.goods_list;
            {value, Goods, T} ->
                util:cancel_ref([Goods#pb_goods.ref]),
                Timer = 300,
                Ref = erlang:send_after(Timer * 1000, self(), {reward, Id}),
                [Goods#pb_goods{ref = Ref, state = ?PANIC_BUYING_STATE_REWARD, time = Timer + util:unixtime()} | T]
        end,
    {noreply, State#st_panic_buying{goods_list = GoodsList}};

%%开奖了喂
handle_info({reward, Id}, State) ->
    State =
        case lists:keytake(Id, #pb_goods.id, State#st_panic_buying.goods_list) of
            false -> State;
            {value, Goods, T} ->
                util:cancel_ref([Goods#pb_goods.ref]),
                Now = util:unixtime(),
                %%抽奖号码列表
                IdList = lists:flatmap(fun(Mb) -> Mb#pb_mb.num_list end, Goods#pb_goods.buy_log),
                %%幸运号码
                LuckyId = ?IF_ELSE(IdList == [], 0, util:list_rand(IdList)),
                %%发放奖励
                {Pkey, CacheList} = reward(Goods#pb_goods.type, Goods#pb_goods.date, LuckyId, Goods#pb_goods.goods_id, Goods#pb_goods.num, Goods#pb_goods.buy_log, LuckyId),
                Goods1 = Goods#pb_goods{state = ?PANIC_BUYING_STATE_FINISH, lucky_num = LuckyId, pkey = Pkey},
                NewGoods = panic_buying_init:new_buying_goods(Goods#pb_goods.type, Goods#pb_goods.date + 1, Now),
                GoodsList = [NewGoods, Goods1] ++ T,
                State#st_panic_buying{goods_list = GoodsList, cache_list = State#st_panic_buying.cache_list ++ CacheList}
        end,
    {noreply, State};

handle_info(Msg, State) ->
    ?DEBUG("msg udef ~p~n", [Msg]),
    {noreply, State}.

%%获取在售未开奖物品列表
get_unfinish_goods_list(GoodsList) ->
    [Goods || Goods <- GoodsList, Goods#pb_goods.state /= ?PANIC_BUYING_STATE_FINISH].
%%获取已开奖物品列表
get_finish_goods_list(GoodsList, Type) ->
    [Goods || Goods <- GoodsList, Goods#pb_goods.state == ?PANIC_BUYING_STATE_FINISH, Goods#pb_goods.type == Type].

%%开奖
reward(Type, Date, LuckyId, GoodsId, Num, MbList, LuckyId) ->
    F = fun(Mb, {Pkey, L}) ->
        case lists:member(LuckyId, Mb#pb_mb.num_list) of
            false ->
                case center:get_node_by_sn(Mb#pb_mb.sn) of
                    false ->
                        {Pkey, [{Mb#pb_mb.sn, Mb#pb_mb.pkey, Type, Date, LuckyId, 0, ?PANIC_BUYING_CONFORT_GOODS_ID, 1} | L]};
                    Node ->
                        center:apply(Node, panic_buying, mail_reward, [Mb#pb_mb.pkey, Type, Date, LuckyId, ?PANIC_BUYING_CONFORT_GOODS_ID, 1]),
                        {Pkey, L}
                end;
            true ->
                case center:get_node_by_sn(Mb#pb_mb.sn) of
                    false ->
                        {Mb#pb_mb.pkey, [{Mb#pb_mb.sn, Mb#pb_mb.pkey, Type, Date, LuckyId, 1, GoodsId, Num} | L]};
                    Node ->
                        center:apply(Node, panic_buying, mail_reward, [Mb#pb_mb.pkey, Type, Date, LuckyId, 1, GoodsId, Num]),
                        {Mb#pb_mb.pkey, L}
                end
        end
        end,
    lists:foldl(F, {0, []}, MbList).
