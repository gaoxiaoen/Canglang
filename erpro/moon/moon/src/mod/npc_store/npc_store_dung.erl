%%----------------------------------------------------
%% 副本NPC神秘商店
%% @author wpf (wprehard@qq.com)
%%----------------------------------------------------
-module(npc_store_dung).
-behaviour(gen_server).
-export([
        start_link/0
        ,create/2
        ,close/1
        ,get_items/2
        ,buy_items/3
        ,buy_items_confirm/4
        ,buy_reply/3
        %% ----------------
        ,adm_reload/0
    ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("store.hrl").
-include("npc_store.hrl").
%%
-include("role.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("gain.hrl").
-include("link.hrl").

%% 副本神秘商店全服管理数据结构
-record(state, {
        info = []           %% 全服限制信息
        ,log = []           %% 玩家操作购买日志记录
        ,cache = []         %% 存入玩家限制信息（持久化时有效，启动后不做实际记录）
    }).

%% @spec get_items(RoleId, RolePos, NpcId) -> {false, Msg} | {ok, Items, Logs}
%% Items = [#store_item_base{} | ...]
%% @doc 获取当前NPC的商店物品列表
get_items(#role{id = RoleId, pos = RolePos, cross_srv_id = <<"center">>}, NpcId) ->
    case center:call(npc_store_dung, get_items, [{RoleId, RolePos}, NpcId]) of
        {badrpc, _} -> {false, ?L(<<"网络异常，请等待">>)};
        D -> D
    end;
get_items(#role{id = RoleId, pos = RolePos}, NpcId) ->
    gen_server:call(?MODULE, {get_items, RoleId, RolePos, NpcId});
get_items({RoleId, RolePos}, NpcId) ->
    gen_server:call(?MODULE, {get_items, RoleId, RolePos, NpcId}).

%% @spec buy_items(Role, NpcId, BuyList) -> {false, Msg} | {ok, NewRole, NewItems, InformList}
%% @doc 购买物品
buy_items(Role = #role{cross_srv_id = CrossSrvId, link = #link{conn_pid = ConnPid}, pos = #pos{map = MapId, map_base_id = MapBaseId}}, NpcId, BuyList) ->
    case check_can_buy(Role, BuyList) of
        false -> {false, ?L(<<"背包格子不够">>)};
        true ->
            case buy_items_confirm(CrossSrvId, MapId, NpcId, BuyList) of
                {false, Msg} -> {false, Msg};
                {ok, NewItems, InformList, LossList} ->
                    case role_gain:do(LossList, Role) of
                        {false, #loss{err_code = ErrCode, msg = Msg}} -> {false, {ErrCode, Msg}};
                        {false, Msg} -> {false, Msg};
                        {ok, Role1} ->
                            case pull_items(Role1, BuyList) of
                                {false, Msg} -> {false, Msg};
                                {ok, NewRole} ->
                                    %% Logs = buy_reply(CrossSrvId, NpcId, NewItems),
                                    buy_reply(CrossSrvId, NpcId, NewItems),
                                    broad_cast(NewRole, MapBaseId, BuyList),
                                    sys_conn:pack_send(ConnPid, 11930, {?true, <<>>, NewItems, []}),
                                    inform(InformList),
                                    {ok, NewRole}
                            end
                    end
            end
    end.

buy_items_confirm(<<>>, MapId, NpcId, BuyList) ->
    gen_server:call(?MODULE, {buy_items, MapId, NpcId, BuyList});
buy_items_confirm(<<"center">>, MapId, NpcId, BuyList) ->
    center:call(npc_store_dung, buy_items_confirm, [<<>>, MapId, NpcId, BuyList]);
buy_items_confirm(_, _MapId, _NpcId, _BuyList) ->
    {false, ?L(<<"错误的请求">>)}.

buy_reply(<<>>, NpcId, NewItems) ->
    gen_server:cast(?MODULE, {buy_reply, NpcId, NewItems});
buy_reply(<<"center">>, NpcId, NewItems) ->
    case center:cast(npc_store_dung, buy_reply, [<<>>, NpcId, NewItems]) of
        {badrpc, _} -> [];
        D -> D
    end;
buy_reply(_, _, _) -> [].

%% @spec create(Npc) ->
%% @doc 副本boss被杀后激活神秘商店
create(NpcId, #pos{map = NpcMap, map_base_id = NpcMapBase}) ->
    gen_server:cast(?MODULE, {create, NpcId, NpcMap, NpcMapBase});
create(_Npc, _NpcPos) ->
    ?ERR("创建npc神秘商店失败：~w, POS:~w", [_Npc, _NpcPos]).

%% @spec close(NpcId) ->
close(NpcId) ->
    gen_server:cast(?MODULE, {close, NpcId}).

%% @spec adm_reload() -> any()
%% @doc 重载全服限制信息
adm_reload() ->
    gen_server:cast(?MODULE, adm_reload).

%% @doc 创建副本神秘商店进程
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ----------------------------------------------------
%% 内部处理
%% ----------------------------------------------------
init([]) ->
    ?INFO("正在启动..."),
    process_flag(trap_exit, true),
    ets:new(ets_dung_store, [public, set, named_table, {keypos, #dung_store.npc_id}]),
    ets:new(ets_dung_store_role_info, [protected, set, named_table, {keypos, #dung_store_role.id}]),
    init_items(),
    State = load(),
    %% TODO: 数据导入
    ?INFO("启动完成..."),
    {ok, State}.

%% 获取商店商品列表
%% 返回{false, Reason} | {ok, Items, Logs}
handle_call({get_items, _RoleId, #pos{map = MapId}, NpcId}, _From, State) ->
    Reply = case ets:lookup(ets_dung_store, NpcId) of
        [] -> {false, ?L(<<"商店NPC未产生">>)};
        [#dung_store{map = MapId, items = Items, log = Logs}] ->
            {ok, Items, Logs};
        _ -> {false, ?L(<<"请求商店物品数据出错">>)}
    end,
    {reply, Reply, State};

%% 购买物品
%% BuyList = [{BaseId, Num} | ...]
handle_call({buy_items, MapId, NpcId, BuyList}, _From, State) ->
    Reply = case ets:lookup(ets_dung_store, NpcId) of
        [] -> {false, ?L(<<"商店NPC未产生">>)};
        [#dung_store{map = MapId, log = _Logs, items = Items}] ->
            case do_buy_items(Items, BuyList) of
                {false, ErrMsg} -> {false, ErrMsg};
                {NewItems, InformList, LossList} ->
                    %% NewLogs = set_log(RoleId, BuyList, Logs),
                    {ok, NewItems, InformList, LossList}
            end;
        _ -> {false, ?L(<<"您距离神秘商人太远，无法购买">>)}
    end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 购买返回处理
handle_cast({buy_reply, NpcId, NewItems}, State) ->
    case ets:lookup(ets_dung_store, NpcId) of
        [DungStore = #dung_store{log = Ls}] ->
            ets:insert(ets_dung_store, DungStore#dung_store{items = NewItems}),
            Ls;
        _ -> []
    end,
    {noreply, State};

%% 创建一个商店
handle_cast({create, NpcId, NpcMap, NpcMapBase}, State) ->
    case ets:lookup(ets_dung_store, NpcId) of
        [#dung_store{}] ->
            ?ERR("要创建的神秘商店已存在:~w, ~w", [NpcId, NpcMap]),
            {noreply, State};
        _ ->
            NewState = do_create(NpcId, NpcMap, NpcMapBase, State),
            {noreply, NewState}
    end;

%% 销毁一个商店
handle_cast({close, NpcId}, State) ->
    ets:delete(ets_dung_store, NpcId),
    ?DEBUG("副本神秘商店NPCID:~w关闭", [NpcId]),
    {noreply, State};

%% 重载限制信息
handle_cast(adm_reload, State = #state{info = Info}) ->
    init_items(),
    case catch reset_info(Info) of
        NewInfo when is_list(NewInfo) ->
            ?INFO("NewInfo:~w", [NewInfo]),
            {noreply, State#state{info = NewInfo}};
        _ ->
            ?INFO("失败，Info:~w", [Info]),
            {noreply, State}
    end;

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    L = ets:tab2list(ets_dung_store_role_info),
    case sys_env:save(npc_store_dung_state, State#state{cache = L}) of
        ok -> ?DEBUG("信息保存成功");
        _E -> ?ERR("信息保存失败:~w", [_E])
    end,
    %% TODO:
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------
%% 导入玩家限制信息
load() ->
    case sys_env:get(npc_store_dung_state) of
        S = #state{info = []} ->
            S#state{info = init_info(global)};
        S = #state{} ->
            S;
        _ ->
            #state{info = init_info(global)}
    end.
%% do_load_info([]) -> ok;
%% do_load_info([D = #dung_store_role{} | T]) ->
%%     ets:insert(ets_npc_store_role_info, D),
%%     do_load_info(T).

%% 初始化限制信息列表
init_info(Type) ->
    L = npc_store_data_dung:list(),
    Fun = fun(BaseId) ->
            case npc_store_data_dung:get(BaseId) of
                {ok, #store_item_base{limit = ?limit_global}} when Type =:= global -> true;
                {ok, #store_item_base{limit = ?limit_role}} when Type =:= role -> true;
                _ -> false
            end
    end,
    init_rand_info([Id || Id <- L, Fun(Id)]).
init_rand_info(L) ->
    [#rand_info{id = Id} || Id <- L].

%% 初始化所有物品列表
init_items() ->
    L = npc_store_data_dung:list(),
    Fun = fun(Id) ->
            case npc_store_data_dung:get(Id) of
                {ok, I} -> I;
                _ -> error
            end
    end,
    put(all_items, [Fun(Id) || Id <- L]).

%% 创建神秘商店的商品列表
do_create(NpcId, NpcMap, NpcMapBase, State = #state{info = GlobalInfo}) ->
    Now = util:unixtime(),
    DS = #dung_store{npc_id = NpcId, map = NpcMap, map_base = NpcMapBase},
    Info1 = check_and_update(global, GlobalInfo),
    ItemsList = create_items(Now, Info1, get(all_items)),
    NewGlobalInfo = update(Now, ItemsList, GlobalInfo),
    ets:insert(ets_dung_store, DS#dung_store{items = ItemsList}),
    ?DEBUG("神秘商店信息：~w", [DS]),
    State#state{info = NewGlobalInfo}.
create_items(Now, GlobalInfo, AllItems) ->
    create_items(Now, GlobalInfo, AllItems, []).
create_items(_Now, _GlobalInfo, _AllItems, List) when length(List) =:= ?npc_store_dung_item_all ->
    List;
create_items(Now, GlobalInfo, AllItems, List) ->
    RandItem = rand_items(AllItems),
    %% ?DEBUG("RandItems:~w~nGlobalInfo: ~w", [RandItem, GlobalInfo]),
    %% 暂时只判断全服限制
    I = case check(global, Now, RandItem, GlobalInfo) of
        false ->
            X = rand_items_default(),
            ?DEBUG("I: ~w", [X]),
            X;
        true ->
            %% TODO: 个人限制判断
            RandItem
    end,
    StoreItem = base_to_store_item(I),
    ?DEBUG("随机的物品：~s", [StoreItem#store_item.name]),
    create_items(Now, GlobalInfo, filter_item(I, AllItems), [StoreItem | List]).

base_to_store_item(#store_item_base{base_id = BaseId, name = Name, price_type = PriceType, price = Price, num = Num, is_notice = IsNotice}) ->
    #store_item{base_id = BaseId, name = Name, price_type = PriceType, price = Price, num = Num, is_notice = IsNotice}.

%% 检查并更新随机限制信息
check_and_update(global, Info) ->
    Fun = fun(Id) ->
            case npc_store_data_dung:get(Id) of
                {ok, I = #store_item_base{limit = ?limit_global}} -> I;
                _ -> error
            end
    end,
    L = [Fun(Id) || Id <- npc_store_data_dung:list()],
    do_check_update_limit(L, Info).
do_check_update_limit([], InfoList) -> InfoList;
do_check_update_limit([#store_item_base{base_id = BaseId} | T], InfoList) ->
    case lists:keyfind(BaseId, #rand_info.id, InfoList) of
        false ->
            Info = #rand_info{id = BaseId},
            do_check_update_limit(T, [Info | InfoList]);
        _ ->
            do_check_update_limit(T, InfoList)
    end;
do_check_update_limit([_H | T], InfoList) ->
    ?DEBUG("更新随机限制信息发现不匹配的数据:~w", [_H]),
    do_check_update_limit(T, InfoList).

%% 重置随机限制因子信息
reset_info(Info) ->
    Fun = fun(Id) ->
            case npc_store_data_dung:get(Id) of
                {ok, I = #store_item_base{limit = ?limit_global}} -> I;
                _ -> error
            end
    end,
    L = [Fun(Id) || Id <- npc_store_data_dung:list()],
    NewInfo = do_check_update_limit(L, Info),
    do_reset_info(L, NewInfo, []).
do_reset_info(_L, [], InfoList) -> InfoList;
do_reset_info(L, [RandInfo = #rand_info{id = Id} | T], InfoList) ->
    case lists:keyfind(Id, #store_item_base.base_id, L) of
        false ->
            do_reset_info(L, T, InfoList);
        _ ->
            do_reset_info(L, T, [RandInfo | InfoList])
    end.

%% 计算概率总区间
calc_interval(List) ->
    calc_interval(List, 0).
calc_interval([], Interval) -> Interval;
calc_interval([#store_item_base{rand = Rand} | T], Interval) ->
    calc_interval(T, Interval + Rand);
calc_interval([_ | T], Interval) ->
    calc_interval(T, Interval).

%% 筛选下一轮的物品列表
filter_item(#store_item_base{base_id = BaseId}, List) ->
    [SIB || SIB = #store_item_base{base_id = Id} <- List, Id =/= BaseId].

%% 获取随机商品
rand_items(List) ->
    rand_items(calc_interval(List),List).
rand_items(Interval, List) ->
    RandVal = util:rand(1, Interval),
    do_rand_items(RandVal, List).
do_rand_items(_RandVal, [H]) ->
    %% ?DEBUG("落到最后RandVal:~w,   H:~w", [_RandVal, H]),
    H;
do_rand_items(RandVal, [LI = #store_item_base{base_id = _Id, rand = Rand} | _T])
when RandVal =< Rand ->
    %% ?DEBUG("RandVal:~w, ID:~w, Rand:~w", [RandVal, _Id, Rand]),
    LI;
do_rand_items(RandVal, [#store_item_base{base_id = _Id, rand = Rand} | T]) ->
    %% ?DEBUG("RandVal:~w, ID:~w, Rand:~w", [RandVal, _Id, Rand]),
    do_rand_items(RandVal - Rand, T);
do_rand_items(RandVal, [_H | T]) -> %% 其他错误情况
    ?ERR("随机物品失败RandVal:~w, H:~w", [RandVal, _H]),
    do_rand_items(RandVal, T).
%%  从默认列表随机获得一个商品
rand_items_default() ->
    RandId = util:rand_list(npc_store_data_dung:list_default()),
    {ok, I} = npc_store_data_dung:get_default(RandId),
    I.

%% 检查全服限制信息因子
check(global, _Now, #store_item_base{limit = ?limit_role}, _) ->
    true;
check(global, Now, #store_item_base{base_id = Id, limit = ?limit_global, limit_time = {_, Xt}, limit_num = {Ln, Xn}, must_num = Xm}, Info) ->
    case lists:keyfind(Id, #rand_info.id, Info) of
        false ->
            true; %% 全服没有限制, 可通过
        #rand_info{lucky_num = Lnum} when Xm =/= 0 andalso Lnum >= Xm ->
            true; %% 必出
        #rand_info{time_info = {ToTime, Xtn}} when Xt =/= 0 andalso Now =< ToTime andalso Xtn >= Xt ->
            false; %% 限制时间内不出
        #rand_info{num_info = {Nn, Xno}} when Xn =/= 0 andalso Nn >= Ln andalso Xno =< Xn ->
            false; %% 中Ln次该物品后，Xn次内不能再中
        _ ->
            true
    end;
check(_Type, _, _, _) ->
    %% 其他限制类型直接通过
    true.

%% 更新限制因子信息
update(Now, RandList, Info) ->
    do_update(Now, RandList, Info, []).
do_update(_Now, _ItemList, [], NewInfoList) -> NewInfoList;
do_update(Now, ItemList, [Info = #rand_info{id = Id, time_info = {ToTime, ToXt}, num_info = {Nn, Xno}, lucky_num = Lnum} | T], NewInfoList) ->
    case lists:keyfind(Id, #store_item.base_id, ItemList) of
        false ->
            case npc_store_data_dung:get(Id) of
                {ok, _I = #store_item_base{limit_time = {Lt, Xt}, limit_num = {Ln, Xn}}} ->
                    %% 本轮没有随机到当前奖品
                    NewInfo0 = Info#rand_info{lucky_num = Lnum + 1},
                    NewInfo1 = case Xt =/= 0 of
                        false -> %% 无效因子忽略
                            NewInfo0;
                        true ->
                            case Now >= ToTime of
                                true -> %% 时间限制已结束
                                    NewInfo0#rand_info{time_info = {Now + Lt, 0}};
                                false ->
                                    NewInfo0
                            end
                    end,
                    NewInfo2 = case Xno >= Xn of %% 抽空足够次数
                        true ->
                            NewInfo1#rand_info{num_info = {0, 0}};
                        false when Ln >= Nn -> %% 实际抽中数小于等于限制数
                            NewInfo1#rand_info{num_info = {Nn, Xno + 1}};
                        false ->        %% 实际抽中数如果大于Nn, 说明前面抽奖判断可能有错误
                            ?ELOG("抽奖更新异常[BASE:~w, INFOList:~w, NewList:~w]", [_I, Info, NewInfoList]),
                            NewInfo1#rand_info{num_info = {Nn, Xno + 1}}
                    end,
                    do_update(Now, ItemList, T, [NewInfo2 | NewInfoList]);
                _ ->
                    do_update(Now, ItemList, T, NewInfoList)
            end;
        #store_item{base_id = Id} ->
            %% 本轮已随机到
            case npc_store_data_dung:get(Id) of
                {ok, _I = #store_item_base{limit_time = {Lt, Xt}}} ->
                    NewInfo0 = Info#rand_info{last_time = Now, lucky_num = 0},
                    NewInfo1 = case Xt =/= 0 of
                        false -> %% 无效因子
                            NewInfo0;
                        true ->
                            case Now >= ToTime of
                                true -> %% Limit时间限制因子：时间累加，次数重置
                                    NewInfo0#rand_info{time_info = {Now + Lt, ToXt + 1}};
                                false -> %% 时间不变，次数累加
                                    NewInfo0#rand_info{time_info = {ToTime, ToXt + 1}}
                            end
                    end,
                    NewInfo2 = NewInfo1#rand_info{num_info = {Nn + 1, 0}},
                    do_update(Now, ItemList, T, [NewInfo2 | NewInfoList]);
                _ ->
                    do_update(Now, ItemList, T, NewInfoList)
            end
    end;
do_update(_, _, _, NewInfoList) ->
    ?DEBUG("抽奖更新异常2"),
    NewInfoList.

%% 损失财产类型
loss_price_type(?npc_store_nor_coin) -> coin;
loss_price_type(?npc_store_bind_coin) -> coin_bind;
loss_price_type(?npc_store_arena_score) -> arena;
loss_price_type(?npc_store_nor_gold) -> gold;
loss_price_type(?npc_store_bind_gold) -> gold_bind;
loss_price_type(?npc_store_coin_all) -> coin_all;
loss_price_type(?npc_store_career_devote) -> career_devote;
loss_price_type(?npc_store_guild_war) -> guild_war;
loss_price_type(?npc_store_guild_devote) -> guild_devote;
loss_price_type(_) -> false.

%% 扣除财产失败信息
loss_error_msg(?npc_store_nor_coin) ->      ?L(<<"您的金币不够了哦">>);
loss_error_msg(?npc_store_bind_coin) ->     ?L(<<"您的绑定金币不够了哦">>);
loss_error_msg(?npc_store_arena_score) ->   ?L(<<"您的竞技积分不够了哦">>);
loss_error_msg(?npc_store_nor_gold) ->      ?L(<<"您的晶钻不够了哦">>);
loss_error_msg(?npc_store_bind_gold) ->     ?L(<<"您的绑定晶钻不够了哦">>);
loss_error_msg(?npc_store_coin_all) ->      ?L(<<"您的金币不够了哦">>);
loss_error_msg(?npc_store_career_devote) -> ?L(<<"您的师门积分不够了哦">>);
loss_error_msg(?npc_store_guild_war) ->     ?L(<<"您的帮战积分不够了哦">>);
loss_error_msg(?npc_store_guild_devote) ->  ?L(<<"您的帮会贡献不够了哦">>);
loss_error_msg(_) ->                        ?L(<<"错误的资产扣除操作">>).

%% 左下角提示信息
inform_msg(PriceType, Price, BaseId, Num) ->
    util:fbin(?L(<<"购买消耗~s ~w\n获得 ~s">>), [inform_price(PriceType), Price, notice:item2_to_inform({BaseId, 1, Num})]).
inform_price(?npc_store_nor_coin) ->      ?L(<<"{str,金币,#FFD700}">>);
inform_price(?npc_store_bind_coin) ->     ?L(<<"{str,绑定金币,#FFD700}">>);
inform_price(?npc_store_arena_score) ->   ?L(<<"{str,竞技场积分,2fecdc}">>);
inform_price(?npc_store_nor_gold) ->      ?L(<<"{str,晶钻,#FFD700}">>);
inform_price(?npc_store_bind_gold) ->     ?L(<<"{str,绑定晶钻,#FFD700}">>);
inform_price(?npc_store_coin_all) ->      ?L(<<"{str,金币,#FFD700}">>);
inform_price(?npc_store_career_devote) -> ?L(<<"{str,师门积分,#2fecdc}">>);
inform_price(?npc_store_guild_war) ->     ?L(<<"{str,帮战积分,#2fecdc}">>);
inform_price(?npc_store_guild_devote) ->  ?L(<<"{str,帮会贡献,#2fecdc}">>);
inform_price(_) -> <<>>.

%% 购买物品
do_buy_items(StoreItems, BuyList) ->
    do_buy_items(StoreItems, BuyList, [], []).
do_buy_items(StoreItems, [], InformList, LossList) ->
    {StoreItems, InformList, LossList};
do_buy_items(StoreItems, [H | T], InformList, LossList) ->
    case do_check_and_loss(StoreItems, H) of
        {false, Msg} -> {false, Msg};
        {ok, InformMsg, NewStoreItems, Loss} ->
            do_buy_items(NewStoreItems, T, [InformMsg | InformList], [Loss | LossList])
    end.
%% 判断购买并扣除资产
do_check_and_loss(_StoreItems, [_BaseId, BuyNum]) when BuyNum =< 0 ->
    {false, ?L(<<"错误的物品数量">>)};
do_check_and_loss(StoreItems, [BaseId, BuyNum]) ->
    case lists:keyfind(BaseId, #store_item.base_id, StoreItems) of
        false -> {false, ?L(<<"不存在的神秘商品">>)};
        #store_item{name = Name, num = Num} when Num < BuyNum ->
            {false, util:fbin(?L(<<"您购买的 ~s 已卖完">>), [Name])}; %% 売り切
        SI = #store_item{price_type = PriceType, price = Price, base_id = BaseId, num = Num} when Num >= BuyNum ->
            Loss = #loss{label = loss_price_type(PriceType), val = Price, msg = loss_error_msg(PriceType)},
            NewSI = SI#store_item{num = Num - BuyNum},
            NewStoreItems = lists:keyreplace(BaseId, #store_item.base_id, StoreItems, NewSI),
            {ok, {PriceType, Price, BaseId, Num}, NewStoreItems, Loss}
    end.

%% 检查物品是否可以全部购买放入背包
check_can_buy(Role, BuyList) ->
    length(BuyList) =< storage_api:get_free_num(bag, Role).

%% 实际发放物品
pull_items(Role, BuyList) ->
    case make_item(BuyList, []) of
        {false, Msg} -> {false, Msg};
        Items ->
            case storage:add(bag, Role, Items) of
                false -> {false, ?L(<<"您的背包已经满了哦">>)};
                {ok, NewBag} ->
                    Role1 = Role#role{bag = NewBag},
                    Role2 = role_listener:buy_item_store(Role1, Items),
                    NewRole = role_listener:get_item(Role2, Items),
                    {ok, role_api:push_assets(Role, NewRole)}
            end
    end.

%% 组合物品的收益信息
make_item([], Items) -> Items;
make_item([[BaseId, Num] | T], Items) ->
    case item:make(BaseId, 1, Num) of
        false -> {false, ?L(<<"未知物品不能产生">>)};
        {ok, Is} ->
            make_item(T, Is ++ Items)
    end.

%% 右下角事件通知
inform([]) -> ok;
inform([{PriceType, Price, BaseId, Num} | T]) ->
    InformMsg = inform_msg(PriceType, Price, BaseId, Num),
    notice:inform(InformMsg),
    inform(T);
inform([_ | T]) ->
    inform(T).

%% 广播
broad_cast(Role, MapBaseId, BuyList) ->
    Fun1 = fun(BaseId) ->
            case npc_store_data_dung:get(BaseId) of
                {ok, #store_item_base{is_notice = ?true}} ->
                    true;
                _ -> false
            end
    end,
    case [{Id, 1, Num} || [Id, Num] <- BuyList, Fun1(Id)] of
        [] -> ok;
        CastItems ->
            MapName = case map_data:get(MapBaseId) of
                #map_data{name = MN} -> MN;
                _ -> <<>>
            end,
            RoleMsg = notice:role_to_msg(Role),
            ItemMsg = notice:item_to_msg(CastItems),
            Msg = util:fbin(?L(<<"~s在危机重重的~s中遇到神秘商人，购得极其稀有的~s">>), [RoleMsg, MapName, ItemMsg]),
            notice:send(53, Msg)
    end.

%% 检查购买日志(限制同一商品一个角色只能购买一个), 是否可以购买
%% false | {true, BaseId, Num}
%% check_buy_log(_RoleId, [], _Logs) -> false;
%% check_buy_log(RoleId, [H | T], Logs) ->
%%     case check_buy_log(RoleId, H, Logs) of
%%         {true, BaseId, Num} -> {true, BaseId, Num};
%%         false ->
%%             check_buy_log(RoleId, T, Logs)
%%     end;
%% check_buy_log(RoleId, {BaseId, BuyNum}, Logs) ->
%%     case lists:keyfind({RoleId, BaseId}, 1, Logs) of
%%         false -> false;
%%         {_, Num} when BuyNum + Num =< ?npc_store_dung_sale_per_role ->
%%             false;
%%         {_, Num} ->
%%             {true, BaseId, Num}
%%     end;
%% check_buy_log(_, _, _) -> false.

%% 设置日志
%% set_log(_RoleId, [], RoleLogs) -> RoleLogs;
%% set_log(RoleId, [{BaseId, BuyNum} | T], RoleLogs) ->
%%     NewLogs = case lists:keyfind({RoleId, BaseId}, 1, RoleLogs) of
%%         false -> [{{RoleId, BaseId}, BuyNum} | RoleLogs];
%%         {_, Num} ->
%%             lists:keyreplace({RoleId, BaseId}, 1, RoleLogs, {{RoleId, BaseId}, Num+BuyNum})
%%     end,
%%     set_log(RoleId, T, NewLogs).

