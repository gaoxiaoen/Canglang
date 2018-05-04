%%----------------------------------------------------
%% NPC神秘商店
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(npc_store_sm).
-behaviour(gen_server).
-export([start_link/0,
        get_all_lucky/0,
        update_lucky_ets/2,
        update_role_all_items/2,
        get_role_all_items/1,
        update_role_last_items/4,
        get_role_last_items/1,
        init_role_items/1,
        update_role_refresh_times/2,
        get_role_refresh_times/1,
        delete_role_refresh_times/0
        ]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
        call/1
    ]
).

-record(state, {
        sm_logs = []      %% 神秘商店操作日志
        ,sm_refresh = []  %% 神秘商店物品刷新数据
        ,role_sm = []     %% 角色神秘商店
    }).

-include("common.hrl").
-include("role.hrl").
-include("npc_store.hrl").
-include("gain.hrl").
%%
-include("link.hrl").
-include("item.hrl").
-include("storage.hrl").
-define(TIME_TICK, 86500000).  %% 清除数据执行时间
-define(camp_time, {util:datetime_to_seconds({{2012, 10, 30}, {0, 0, 1}}), %% 活动时间定义
        util:datetime_to_seconds({{2012, 11, 1}, {23, 59, 59}})}).

%% 查询ets表 好运榜
%% lookup(Type) -> #rank{}
get_all_lucky() ->
    case ets:tab2list(npc_store_sm_rank) of
        [] ->
            [];
        Data ->
            ?DEBUG("--Data--~p~n", [Data]),
            format(Data, [])
    end.
format([], L) -> L;
format([{_Key, Role_Name, Item_Name}|T],L) ->
    format(T, [{Role_Name, Item_Name}|L]).

%% 获取今天使用晶钻刷新的次数
get_role_refresh_times(RoleId) ->
    case ets:lookup(npcs_store_refresh_times, RoleId) of 
        [] ->
            0;
        [{_,Times}] ->
            Times
    end.
%% 更新使用晶钻刷新的次数
update_role_refresh_times(RoleId, Times) ->
    ets:delete(npcs_store_refresh_times, RoleId),
    ets:insert(npcs_store_refresh_times, {RoleId, Times}).

%% 更新ets表 好运榜
%% update_ets(State) -> ok
update_lucky_ets(Role_Name,Item_Name) ->

    Datas = get_all_lucky(),
    case erlang:length(Datas) >= 5 of 
        true -> 
            Key = ets:first(npc_store_sm_rank),
            ets:delete(npc_store_sm_rank, Key),
            ets:insert(npc_store_sm_rank, {util:unixtime(), Role_Name, Item_Name});
        false ->
            ets:insert(npc_store_sm_rank, {util:unixtime(), Role_Name, Item_Name})
    end.

%%更新角色在神秘商店全部物品的数据    
update_role_all_items(Rid, Items) ->
     ets:delete(npc_store_sm_role_items, Rid),
     ets:insert(npc_store_sm_role_items, {Rid, Items}).


%%获取角色在神秘商店全部物品的数据 
get_role_all_items(Rid) ->
    NItems = case ets:lookup(npc_store_sm_role_items, Rid) of 
                [] ->
                    [];
                [{_, Items}] ->
                    {Items}
            end,
    case NItems of 
        [] -> [];
        _ ->
            [Items2] = tuple_to_list(NItems),   
            % npc_store:format_to_record_list(Items2, [])
            Items2
    end.

%%更新角色在神秘商店刷新物品的数据    
update_role_last_items(Rid,Last_Time,Free_Times,Items) ->
    ets:delete(npc_store_sm_role_lastitems, Rid),
    ets:insert(npc_store_sm_role_lastitems, {Rid, Last_Time, Free_Times, Items}).

%%获取角色在神秘商店上次刷新物品的数据 
get_role_last_items(Role = #role{id = {Rid, _}}) ->
    case ets:lookup(npc_store_sm_role_lastitems, Rid) of 
        [] ->

            {0, ?base_free + vip:npc_store(Role), []};
        [{_, Last_Time, Free_Times, Items}] ->
            {Last_Time, Free_Times, Items}
    end.
 
init_role_items(Rid) ->
    Items = npc_store_data_sm_item:get_all_item(),%%返回物品id与物品权重的列表
    update_role_all_items(Rid, Items), %%插入到ets表中
    Items.

%%  @spec封测结束后可以删除此接口
delete_role_refresh_times() -> 
    erlang:send_after(util:unixtime({nexttime, 86400}) * 1000, ?MODULE, clear_npcs_store_refresh_times),
    ok.


%% 神秘商店GM命令
call(Args) -> 
    gen_server:call(?MODULE, Args).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),  
    ets:new(npc_store_sm_rank, [public,ordered_set, named_table,{keypos, 1}]),

    ets:new(npc_store_sm_role_items, [public, bag, named_table]),
    
    ets:new(npc_store_sm_role_lastitems, [public, set, named_table,{keypos, 1}]),

    ets:new(npcs_store_refresh_times, [public, set, named_table,{keypos, 1}]),

    erlang:send_after(util:unixtime({nexttime, 86400}) * 1000, self(), clear_npcs_store_refresh_times),

    process_flag(trap_exit, true), 
    ?INFO("[~w] npc神秘商店幸运榜启动完成", [?MODULE]),
    {ok, #state{}}.
  

%% 获取神秘商店物品列表 {false, Reason} | {ok, RefreshTime, Items, Logs} | {ok, RefreshTime, Items, Logs, NewRole}
handle_call({sm_items, Role = #role{id = Id}}, _From, State = #state{role_sm = Rsm, sm_logs = Logs}) ->
    Now = util:unixtime(),
    case lists:keyfind(Id, #npc_store_sm_role.id, Rsm) of
        #npc_store_sm_role{refresh_time = RefreshTime, items = Items} when Now < RefreshTime -> %% 已生成有数据 且时间合法
            {reply, {ok, RefreshTime, Items, Logs}, State};
        _ -> %% 未生成过数据或数据已过时
            {#npc_store_sm_role{refresh_time = RefreshTime, items = Items}, NR, NewState} = build_role_sm_items(1, Role, State),
            {reply, {ok, RefreshTime, Items, Logs, NR}, NewState}
    end;

%% 刷新神秘商店物品列表 {false, Reason} | {ok, RefreshTime, Items, NewRole}
handle_call({refresh_sm, 0, Role}, _From, State) -> %% 花钱刷新
    case npc_store:find_today_log(?npc_store_refresh_sm, Role) of
        {{Type, UseTimes, TotalTimes}, NS = #npc_store{log = Logs}} when UseTimes < TotalTimes -> %% 还有免费次数
            Log = {Type, UseTimes + 1, TotalTimes},
            NewLogs = lists:keyreplace(Type, 1, Logs, Log),
            NRole = Role#role{npc_store = NS#npc_store{log = NewLogs}},
            {#npc_store_sm_role{refresh_time = RefreshTime, items = Items}, NR, NewState} = build_role_sm_items(0, NRole, State),
            {reply, {ok, RefreshTime, Items, NR}, NewState};
        _ -> %% 没有免费次数
            HasItemNum = case storage:find(Role#role.bag#bag.items, #item.base_id, 33120) of
                        {false, _R} -> 0;
                        {ok, Num2, _, _, _} -> Num2
                    end,
            L = if 
                HasItemNum > 0 -> [#loss{label = item, val = [33120, 1, 1]}];
                true -> [#loss{label = gold, val = pay:price(?MODULE, refresh_sm, null), msg = ?L(<<"您没有足够的晶钻刷新">>)}]
            end,
            case role_gain:do(L, Role) of
                {false, #loss{msg = Msg}} ->
                    {reply, {gold, Msg}, State};
                {ok, NRole} ->
                    {#npc_store_sm_role{refresh_time = RefreshTime, items = Items}, NR, NewState} = build_role_sm_items(0, NRole, State),
                    {reply, {ok, RefreshTime, Items, NR}, NewState}
            end
    end;
handle_call({refresh_sm, 1, Role = #role{id = Id}}, _From, State = #state{role_sm = Rsm}) -> %% 到点刷新
    Now = util:unixtime(),
    case lists:keyfind(Id, #npc_store_sm_role.id, Rsm) of
        #npc_store_sm_role{refresh_time = RefreshTime} when Now < RefreshTime - 10 ->
            {reply, {false, ?L(<<"物品刷新时间未到">>)}, State};
        _ ->
            {#npc_store_sm_role{refresh_time = RefreshTime, items = Items}, NR, NewState} = build_role_sm_items(1, Role, State),
            {reply, {ok, RefreshTime, Items, NR}, NewState}
    end;

%% 购买神秘商店物品 {false, Reason} | {ok, NewRole}
handle_call({buy_sm_item, {Id, Num}, Role = #role{id = RId}}, _From, State = #state{role_sm = Rsm, sm_logs = Logs}) ->
    Now = util:unixtime(),
    case lists:keyfind(RId, #npc_store_sm_role.id, Rsm) of %% 先从列表中获取自己神秘商店数据
        false ->
            {reply, {false, ?L(<<"个人神秘商店无数据">>)}, State};
        #npc_store_sm_role{refresh_time = RefreshTime} when Now > RefreshTime ->
            {reply, {false, ?L(<<"神秘商店数据已过时，请重新选择物品购买">>)}, State};
        SmRole = #npc_store_sm_role{refresh_type = ReType, items = Items} ->
            case lists:keyfind(Id, #npc_store_sm_item.id, Items) of %% 从自己神秘商店中获取需购买的物品数据
                false ->
                    {reply, {false, ?L(<<"个人神秘商店中无此物品出售">>)}, State};
                #npc_store_sm_item{num = N} when N < Num ->
                    {reply, {false, ?L(<<"购买物品数量超出范围">>)}, State};
                SmItem = #npc_store_sm_item{base_id = BaseId, price = Price, price_type = PriceType, num = N} ->
                    TotalPrice = Price * Num,
                    Label = npc_store:loss_price_type(PriceType),
                    case role_gain:do(#loss{label = Label, val = TotalPrice, msg = npc_store:loss_error_msg(PriceType)}, Role) of %% 先扣除资产
                        {false, #loss{msg = Reason}} ->
                            {reply, {Label, Reason}, State};
                        {ok, NRole} ->
                            case item:make(BaseId, 1, Num) of %% 生成物品
                                false -> 
                                    {reply, {false, ?L(<<"未知物品不能产生">>)}, State};
                                {ok, GetItems} ->
                                    case storage:add(bag, NRole, GetItems) of %% 增加物品到背包
                                        false -> 
                                            {reply, {false, ?L(<<"您的背包已经满了哦">>)}, State};
                                        {ok, NewBag} ->
                                            NewSmItem = SmItem#npc_store_sm_item{num = N - Num},
                                            NewItems = lists:keyreplace(Id, #npc_store_sm_item.id, Items, NewSmItem),
                                            NewSmRole = SmRole#npc_store_sm_role{items = NewItems},
                                            npc_store_dao:save_role_items_sm(NewSmRole),
                                            NewRsm = lists:keyreplace(RId, #npc_store_sm_role.id, Rsm, NewSmRole),
                                            NewLogs = add_log(Role, ReType, SmItem, GetItems, Now, Num, Logs),
                                            NewRole = role_listener:get_item(NRole, GetItems),
                                            role_api:push_assets(Role, NewRole),
                                            npc_store:send_inform(NewRole, PriceType, TotalPrice, GetItems),
                                            log:log(log_item_output, {GetItems, <<"神秘商店">>}),
                                            {reply, {ok, NewRole#role{bag = NewBag}}, State#state{role_sm = NewRsm, sm_logs = NewLogs}}
                                    end
                            end
                    end
            end
    end;

%% 执行GM命令操作(GM命令)
handle_call({gm, RefreshNum, Role}, _From, State) ->
    {Items, NewState} = do_gm_refresh(RefreshNum, Role, State, []),
    SortItems = lists:keysort(1, Items),
    Msg = util:fbin("items[~w]", [SortItems]), %% [{BaseId, Num}]
    {reply, {false, Msg}, NewState};

%% 清理数据(GM命令)
handle_call({clear, Role = #role{npc_store = Store}}, _From, State) ->
    {reply, {ok, Role#role{npc_store = Store#npc_store{sm_refresh = []}}}, State#state{sm_refresh = []}};

%% 获取当前神秘商店刷新情况(GM命令)
handle_call({get, #role{npc_store = #npc_store{sm_refresh = RoleSmRf}}}, _From, State = #state{sm_refresh = GlobalSmRf}) ->
    GList = [{BaseId, TN, LN, RN} || #npc_store_sm_refresh{
            base_id = BaseId, time_num = TN, limit_num = LN, refresh_num = RN} <- GlobalSmRf],
    RList = [{BaseId, TN, LN, RN} || #npc_store_sm_refresh{
            base_id = BaseId, time_num = TN, limit_num = LN, refresh_num = RN} <- RoleSmRf],
    Msg = util:fbin(" global_list[~w] \n role_list[~w]", [GList, RList]),
    {reply, {false, Msg}, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(tick, State = #state{sm_logs = Logs, role_sm = Rsm}) ->
    ?INFO("开始执行过时清除/数据更新！"),
    npc_store_dao:del_logs_sm(Logs),
    %% npc_store_dao:del_role_items_sm(),
    %% npc_store_dao:save_refresh_sm(Rf),
    erlang:send_after(?TIME_TICK, self(), tick),
    Now = util:unixtime(),
    NewRsm = [SM || SM = #npc_store_sm_role{refresh_time = RT} <- Rsm, RT > Now],
    ?INFO("结束执行过时清除/数据更新！"),
    {noreply, State#state{role_sm = NewRsm}};



handle_info(clear_npcs_store_refresh_times, State) ->
    ets:delete_all_objects(npcs_store_refresh_times),
    erlang:send_after(util:unixtime({nexttime, 86400}) * 1000, self(), clear_npcs_store_refresh_times),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State = #state{sm_refresh = Rf}) ->
    npc_store_dao:save_refresh_sm(Rf),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%---------------------------------------------------------
%% 内部函数
%%---------------------------------------------------------

%% 增加新购买日志
add_log(_Role = #role{account = Account, id = {Rid, SrvId}, name = Name, link = #link{conn_pid = ConnPid}}, ReType, #npc_store_sm_item{base_id = BaseId, price = Price, price_type = PriceType, is_notice = IsNotice}, Item, Time, Num, Logs) ->
    Log = #npc_store_sm_log{
        rid = Rid, srv_id = SrvId, name = Name 
        ,base_id = BaseId, num = Num, price = Price
        ,price_type = PriceType, buy_time = Time
    },
    npc_store_dao:add_log_sm(ReType, IsNotice, Log),
    case IsNotice =:= 1 of
        true ->
            %% _RoleMsg = notice:role_to_msg(Role),
            %% _ItemMsg = notice:item_to_msg(Item),
            %% notice:send(52, util:fbin(?L(<<"~s在神秘的秘宝商人处不断的寻找，突然间灵光闪动，~s神奇的出现了，真是洪福齐天！">>), [RoleMsg, ItemMsg])),
            NameList = notice:items_to_name(Item),
            notice:send_interface({connpid, ConnPid}, 3, Account, SrvId, Name, <<"">>, NameList),
            sys_conn:pack_send(ConnPid, 11909, {Rid, SrvId, Name, BaseId, Num, Time}),
            lists:sublist([Log | Logs], ?npc_store_sm_log_num);
        false -> Logs
    end.

%% GM命令操作
do_gm_refresh(0, _Role, State, Items) -> {Items, State};
do_gm_refresh(RefreshNum, Role, State, Items) ->
    Now = util:unixtime(),
    {SmItems, NRole, NewState} = do_build_role_sm_items(Now, Role, State),
    NewItems = do_join(SmItems, Items),
    do_gm_refresh(RefreshNum - 1, NRole, NewState, NewItems).

do_join([], Items) -> Items;
do_join([#npc_store_sm_item{base_id = BaseId} | T], Items) ->
    case lists:keyfind(BaseId, 1, Items) of
        false -> 
            do_join(T, [{BaseId, 1} | Items]);
        {BaseId, Num} ->
            NewItems = lists:keyreplace(BaseId, 1, Items, {BaseId, Num + 1}),
            do_join(T, NewItems)
    end.

%% 生成一个新角色神秘商店数据列表
build_role_sm_items(ReType, Role = #role{id = Id}, State = #state{role_sm = Rsm}) ->
    Now = util:unixtime(),
    {Items, NRole, NewState} = do_build_role_sm_items(Now, Role, State),
    Sm = #npc_store_sm_role{
        id = Id 
        ,refresh_time = Now + ?refresh_time
        ,refresh_type = ReType
        ,items = Items
    },
    npc_store_dao:save_role_items_sm(Sm),
    NewRsm = lists:keydelete(Id, #npc_store_sm_role.id, Rsm),
    {Sm, NRole, NewState#state{role_sm = [Sm | NewRsm]}}.

%% 执行生成神秘商店数据列表操作
do_build_role_sm_items(Now, Role = #role{npc_store = Store = #npc_store{sm_refresh = RoleSmRf}}, State = #state{sm_refresh = GlobalSmRf}) ->
    Now = util:unixtime(),
    {StartT, EndT} = ?camp_time,
    IsCampTime = campaign_adm:is_camp_time(npc_store_sm),
    AllBaseItems = case (Now >= StartT andalso Now < EndT) orelse IsCampTime of
        false -> base_items(1);
        true -> base_items(2)
    end,
    DefaultItems = base_items(0),
    GlobalSmRf0 = clear_time_out_refresh(?npc_store_sm_limit_global, GlobalSmRf, [], AllBaseItems),
    RoleSmRf0 = clear_time_out_refresh(?npc_store_sm_limit_role, RoleSmRf, [], AllBaseItems),
    {BaseItems, Items} = do_build_item_list(0, Now, GlobalSmRf0, RoleSmRf0, AllBaseItems, DefaultItems, [], []),
    GlobalSmRf1 = update_refresh_sm(GlobalSmRf, []),
    NewGlobalSmRf = update_refresh_sm(?npc_store_sm_limit_global, Now, GlobalSmRf1, BaseItems),
    RoleSmRf1 = update_refresh_sm(RoleSmRf, []),
    NewRoleSmRf = update_refresh_sm(?npc_store_sm_limit_role, Now, RoleSmRf1, BaseItems),
    NewItems = [#npc_store_sm_item{
            id = Id, base_id = BaseId ,price = Price ,price_type = PriceType
            ,is_notice = IsNotice,is_music = IsMusic
        } || {Id, #npc_store_base_sm{base_id = BaseId, price = Price, price_type = PriceType
                ,is_notice = IsNotice, is_music = IsMusic}} <- Items],
    {NewItems, Role#role{npc_store = Store#npc_store{sm_refresh = NewRoleSmRf}}, State#state{sm_refresh = NewGlobalSmRf}}.

%% 清除过期规则
clear_time_out_refresh(_Type, [], SmRf, _BaseItems) -> SmRf;
clear_time_out_refresh(Type, [I = #npc_store_sm_refresh{base_id = BaseId} | T], SmRf, BaseItems) ->
    case lists:keyfind(BaseId, #npc_store_base_sm.base_id, BaseItems) of
        #npc_store_base_sm{limit_type = Type} -> clear_time_out_refresh(Type, T, [I | SmRf], BaseItems);
        _ -> clear_time_out_refresh(Type, T, SmRf, BaseItems)
    end.

%% 生成物品
do_build_item_list(?npc_store_sm_num, _Now, _GlobalSmRf, _RoleSmRf, _AllBaseItems, _DefaultItems, BaseItems, Items) -> {BaseItems, Items};
do_build_item_list(_Num, _Now, _GlobalSmRf, _RoleSmRf, [], _DefaultItems, BaseItems, Items) -> {BaseItems, Items};
do_build_item_list(Num, Now, GlobalSmRf, RoleSmRf, AllBaseItems, [], BaseItems, Items) ->
    do_build_item_list(Num, Now, GlobalSmRf, RoleSmRf, AllBaseItems, AllBaseItems, BaseItems, Items);
do_build_item_list(Num, Now, GlobalSmRf, RoleSmRf, AllBaseItems, DefaultItems, BaseItems, Items) -> 
    BaseItem = #npc_store_base_sm{base_id = BaseId} = find_rand_item(AllBaseItems),
    case {check_item(Now, GlobalSmRf, BaseItem), check_item(Now, RoleSmRf, BaseItem)} of
        {true, true} -> %% 可出物品
            case lists:keyfind(BaseId, #npc_store_base_sm.base_id, BaseItems) of
                false -> %% 不存在 可出现
                    do_build_item_list(Num + 1, Now, GlobalSmRf, RoleSmRf, AllBaseItems, DefaultItems, [BaseItem | BaseItems], [{Num, BaseItem} | Items]);
                _ -> %% 已出现 不重复出现 从默认物品中随机抽取
                    %% ?DEBUG("重复出现a3"),
                    Item = find_rand_item(DefaultItems),
                    do_build_item_list(Num + 1, Now, GlobalSmRf, RoleSmRf, AllBaseItems, DefaultItems -- [Item], BaseItems, [{Num, Item} | Items])
            end;
        _ -> %% 不可出现物品 从默认物品中随机抽取
            Item = find_rand_item(DefaultItems),
            do_build_item_list(Num + 1, Now, GlobalSmRf, RoleSmRf, AllBaseItems, DefaultItems -- [Item], BaseItems, [{Num, Item} | Items])
    end.

%% 查找本次产生的物品
find_rand_item(BaseItems) ->
    RandList = [Rand || #npc_store_base_sm{rand = Rand} <- BaseItems],
    MaxRand = lists:sum(RandList),
    RandVal = util:rand(1, MaxRand),
    do_find_rand_item(RandVal, BaseItems).
do_find_rand_item(_RandVal, [BaseItem | []]) ->
    BaseItem;
do_find_rand_item(RandVal, [BaseItem = #npc_store_base_sm{rand = Rand} | _BaseItems]) when RandVal =< Rand ->
    BaseItem;
do_find_rand_item(RandVal, [#npc_store_base_sm{rand = Rand} | BaseItems]) ->
    do_find_rand_item(RandVal - Rand, BaseItems).

%% 生成所有物品基础数据
base_items(Mod) -> 
    BaseIds = npc_store_data_sm:list(Mod),
    do_base_items(Mod, BaseIds, []).
do_base_items(_Mod, [], BaseItems) -> BaseItems;
do_base_items(Mod, [BaseId | T], BaseItems) ->
    case npc_store_data_sm:get(Mod, BaseId) of
        {ok, BaseItem} -> 
            case item_data:get(BaseId) of %% 确定此物品存在
                {ok, _} -> 
                    do_base_items(Mod, T, [BaseItem | BaseItems]);
                _ ->
                    do_base_items(Mod, T, BaseItems)
            end;
        _ -> 
            do_base_items(Mod, T, BaseItems)
    end.

%% 判断是否可出物品出现物品
check_item(Now, SmRf, #npc_store_base_sm{base_id = BaseId, limit_time = {_T, Y}, limit_num = {N, X}}) ->
    case lists:keyfind(BaseId, #npc_store_sm_refresh.base_id, SmRf) of
        #npc_store_sm_refresh{limit_time = LT, time_num = TN} when Y =/= 0 andalso Now =< LT andalso TN >= Y -> %% 限制时间范围内不能出现
            %% ?DEBUG("时间限制a1"),
            false;
        #npc_store_sm_refresh{limit_num = LN, refresh_num = RN} when X =/= 0 andalso LN >= N andalso RN =< X -> %% 限制次数范围内不能出现
            %% ?DEBUG("次数限制a2"),
            false;
        _ -> %% 本次可出现
            true
    end.

%% %% 更新操作更新次数
update_refresh_sm([], NewSmRf) -> NewSmRf;
update_refresh_sm([Rf = #npc_store_sm_refresh{base_id = BaseId, limit_num = LN, refresh_num = RN} | T], SmRf) ->
    case npc_store_data_sm:get(1, BaseId) of
        {ok, #npc_store_base_sm{limit_num = {N, X}}} when X =/= 0 andalso LN >= N andalso RN >= X -> %% 物品受限解除
            update_refresh_sm(T, [Rf#npc_store_sm_refresh{refresh_num = 0, limit_num = 0} | SmRf]);
        {ok, #npc_store_base_sm{limit_num = {N, X}}} when X =/= 0 andalso LN >= N -> %% 物品处于受限出现状态 更新刷新次数
            update_refresh_sm(T, [Rf#npc_store_sm_refresh{refresh_num = RN + 1} | SmRf]);
        _ ->
            update_refresh_sm(T, [Rf#npc_store_sm_refresh{refresh_num = 0} | SmRf])
    end.

%% 更新物品出现信息
update_refresh_sm(_Type, _Now, SmRf, []) -> SmRf;
update_refresh_sm(Type, Now, SmRf, [#npc_store_base_sm{base_id = BaseId, limit_type = Type, limit_time = {T, Y}} | BaseItems]) ->
    NewRf = case lists:keyfind(BaseId, #npc_store_sm_refresh.base_id, SmRf) of
        false -> %% 物品之前没刷新出现过
            #npc_store_sm_refresh{base_id = BaseId, limit_time = Now + T, time_num = 1, limit_num = 1};
        Rf = #npc_store_sm_refresh{limit_time = LT, limit_num = LN} when Y =/= 0 andalso LT < Now -> %% 限制时间超时
            Rf#npc_store_sm_refresh{limit_time = Now + T, time_num = 1, limit_num = LN + 1};
        Rf = #npc_store_sm_refresh{time_num = TN, limit_num = LN} ->
            Rf#npc_store_sm_refresh{time_num = TN + 1, limit_num = LN + 1}
    end,
    NewSmRf = lists:keydelete(BaseId, #npc_store_sm_refresh.base_id, SmRf),
    update_refresh_sm(Type, Now, [NewRf | NewSmRf], BaseItems);
update_refresh_sm(Type, Now, SmRf, [_ | BaseItems]) ->
    update_refresh_sm(Type, Now, SmRf, BaseItems).

