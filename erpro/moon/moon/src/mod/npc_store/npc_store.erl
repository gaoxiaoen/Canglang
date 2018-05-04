%%----------------------------------------------------
%% NPC商品 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(npc_store).
-export([
        buy/5
        ,sale/2
        ,get_items/3
        ,get_can_sale_list/1
        ,get_buy_item_list/2
        ,get_rate/2
        ,exchange_item_list/3
        ,exchange_item/4
        ,find_today_log/2
        ,loss_price_type/1
        ,loss_error_msg/1
        ,send_inform/4
        ,send_inform/3
        ,guild_lev_up/1
        ,refresh_items/2
        ,refresh_item/2
        % ,format_to_record_list/2
        ,get_items_id/2
        ,get_items_order/2
        ,get_default_rand_items/0
        ,login/1
        ,refresh_cd/1
    ]
).

-include("common.hrl").
-include("item.hrl").
-include("store.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("storage.hrl").
-include("gain.hrl").
-include("npc_store.hrl").
%%
-include("guild.hrl").
-include("link.hrl").

%%登录时检查vip等级
login(Role = #role{id = {Rid, _}, login_info = #login_info{last_logout = Logout}}) ->
    case util:is_today(Logout) of
        true ->
            ok;
        false ->
            {Last_time, _, Last_Items} = npc_store_sm:get_role_last_items(Role),
            ?DEBUG("----login update--"),
            AllFree = ?base_free + vip:npc_store(Role),
            npc_store_sm:update_role_last_items(Rid, Last_time, AllFree, Last_Items)
    end,

    role_timer:set_timer(refresh_cd, util:unixtime({nexttime, 86403}) * 1000, {npc_store, refresh_cd, []}, 1, Role).
    % role_timer:set_timer(check_casino, 10* 1000, {casino_refresh_items, check_casino, []}, 1, Role).

refresh_cd(Role = #role{id = {Rid, _}, link = #link{conn_pid = ConnPid}}) ->
    {Last_time, _, Last_Items} = npc_store_sm:get_role_last_items(Role),
    ?DEBUG("----login update--"),
    AllFree = ?base_free + vip:npc_store(Role),
    npc_store_sm:update_role_last_items(Rid, Last_time, AllFree, Last_Items),
    % npc_store_sm:update_role_refresh_times(Rid, 0),

    Lucky_Data = npc_store_sm:get_all_lucky(),
    sys_conn:pack_send(ConnPid, 11910, {AllFree, 0, 0, get_items_order(Last_Items, []), Lucky_Data}),        
    Time0 = util:unixtime(today),
    Tomorrow0 = (Time0 + 86405) - util:unixtime(),
    {ok, role_timer:set_timer(refresh_cd2, Tomorrow0 * 1000, {npc_store, refresh_cd, []}, day_check, Role)}.               


%%刷新一个物品
refresh_item(OldOrderId, Role = #role{id = {Rid, _}}) ->
    put(npc_store_role_id, Rid),
    Items = npc_store_sm:get_role_all_items(Rid), %%获取角色在ets的所有数据
    Items2 = 
        case Items of  %%玩家第一次刷新时ets中没有数据
            [] ->
                npc_store_sm:init_role_items(Rid), %%初始化玩家在ets中的数据
                npc_store_sm:get_role_all_items(Rid);
            _ ->Items
        end,      
    [NItem = #npc_store_base_item{order = NOrderId}] = do_refresh_items(1, Items2),     %%刷新获得物品
    {NLast_time, FreeTimes, Last_Items} = npc_store_sm:get_role_last_items(Role),
    ItemsList = Last_Items,
    case lists:keyfind(NOrderId, #npc_store_base_item.order, ItemsList) of 
        #npc_store_base_item{} ->
            refresh_item(OldOrderId, Role);
        false ->
            NLastItems = lists:keyreplace(OldOrderId, #npc_store_base_item.order, ItemsList, NItem), 
            npc_store_sm:update_role_last_items(Rid, NLast_time, FreeTimes, NLastItems), %%更新最后获得的数据到ets
            {true, NItem} %%返回最后获得的数据
    end.


%%刷新8个物品
refresh_items(RefreshType, Role = #role{id = {Rid, _}}) ->
    case RefreshType of 
            0 ->
                T1 = npc_store_sm:get_role_refresh_times(Rid),
                {Label, Val} = get_price_val(T1),
                L = case Label of 
                        coin ->
                            [#loss{label = coin, val = Val, msg = ?MSGID(<<"金币不足">>)}];
                        gold ->
                            [#loss{label = gold, val = Val, msg = ?MSGID(<<"晶钻不足">>)}]
                    end,
                role:send_buff_begin(),
                case role_gain:do(L, Role) of
                    {false, #loss{msg = Msg}} -> 
                        role:send_buff_clean(),
                        {false, Msg};
                    {false, Rea} -> 
                        role:send_buff_clean(),
                        {false, Rea};
                    {ok, NRole} -> 
                        role:send_buff_flush(),
                        npc_store_sm:update_role_refresh_times(Rid, T1 + 1),

                        do(NRole, 0)
                end;
            N ->
                do(Role, N - 1)
        end.

do(Role = #role{id = {Rid, _}}, FreeTimes) ->
    put(npc_store_role_id, Rid),
    {Last_Time, _, _} = npc_store_sm:get_role_last_items(Role),
    NLast_time = util:unixtime(),
    Items = npc_store_sm:get_role_all_items(Rid), %%获取角色在ets的所有数据
    Items2 = 
        case Items of  %%玩家第一次刷新时ets中没有数据
            [] ->
                npc_store_sm:init_role_items(Rid), %%初始化玩家在ets中的数据
                npc_store_sm:get_role_all_items(Rid);
            _ ->Items
        end,
    % ?DEBUG("--刷新前物品的个数---:~w~n",[erlang:length(Items2)]),       
    
    NLastItems = do_refresh_items(8, Items2),     %%刷新获得物品
    NItems2 = update_role_allitems(Items2, NLastItems), %%更新所有数据
    % ?DEBUG("--刷新后物品的个数---:~w~n",[erlang:length(NItems2)]),    

    npc_store_sm:update_role_all_items(Rid, NItems2), %%更新所有数据到ets
    case Last_Time =:= 0 of 
        true ->
            npc_store_sm:update_role_last_items(Rid, NLast_time, FreeTimes, NLastItems); %%更新最后获得的数据到ets
        false ->
            npc_store_sm:update_role_last_items(Rid, Last_Time, FreeTimes, NLastItems) %%更新最后获得的数据到ets
    end,
    {true, Role, NLastItems, FreeTimes}. %%返回最后获得的数据

do_refresh_items(Num, Items) ->
    Item_Weight = [Item_temp2||Item_temp2 <-Items, Item_temp2#npc_store_base_item.weight =/= 0], %%不是被限制的
    NewItems = lists:keysort(#npc_store_base_item.weight, Item_Weight), %%按第2个字段权重进行排序，默认为从小到大的序列
    Weight = [Wei|| #npc_store_base_item{weight = Wei} <- NewItems], %%获得所有的weight,已排序
    Sum = lists:sum(Weight), %%weight的和
    refresh_items2(Num, 0, {NewItems, Weight, Sum}, []).
 
refresh_items2(Num, Num, _, L) ->
    put(npc_store_refresh_count, 0),  
    L;
refresh_items2(Num, Count, {NewItems, Weight, Sum}, L) ->

    Item = refresh_item({NewItems, Weight, Sum}),
    case Item == 0 of 
        true ->
            {NewItems1, Weight1, Sum1} = fix(),
            refresh_items2(Num, Count, {NewItems1, Weight1, Sum1}, L);
        false ->
            NItems = NewItems -- [Item],
            NWeight = Weight -- [Item#npc_store_base_item.weight],
            NSum = Sum - Item#npc_store_base_item.weight,

            case lists:member(Item, L) of 
                false -> 
                    refresh_items2(Num, Count + 1, {NItems, NWeight, NSum}, [Item|L]);
                _ ->
                    case check() of
                        ok ->
                            refresh_items2(Num, Count, {NItems, NWeight, NSum}, L);
                        false ->
                            {NewItems1, Weight1, Sum1} = fix(),
                            refresh_items2(Num, Count, {NewItems1, Weight1, Sum1}, L)
                    end
            end
    end.

check() ->
    RefreshCount = get(npc_store_refresh_count),
    case RefreshCount of
        undefined -> 
            put(npc_store_refresh_count, 1),
            ok;
        _ -> 
            case RefreshCount < 100 of
                true -> 
                    put(npc_store_refresh_count, RefreshCount + 1),
                    ok;
                false -> 
                    put(npc_store_refresh_count, 50), %%从50开始
                    false
            end
    end.

fix() ->
    Rid = get(npc_store_role_id),
    npc_store_sm:init_role_items(Rid), %%初始化玩家在ets中的数据
    Items = npc_store_sm:get_role_all_items(Rid),

    Item_Weight = [Item_temp2||Item_temp2 <-Items, Item_temp2#npc_store_base_item.weight =/= 0], %%不是被限制的
    NewItems = lists:keysort(#npc_store_base_item.weight, Item_Weight), %%按第2个字段权重进行排序，默认为从小到大的序列
    Weight = [Wei|| #npc_store_base_item{weight = Wei} <- NewItems], %%获得所有的weight,已排序
    Sum = lists:sum(Weight), %%weight的和
    {NewItems, Weight, Sum}.

refresh_item({NewItems, Weight, Sum}) ->
    %%优先找将到达保底的物品,且不是限制的
    % Item_BaoDi = [Item_temp||Item_temp <-NewItems, Item_temp#npc_store_base_item.times_max - Item_temp#npc_store_base_item.times_max_undisplay == 1],

    % case erlang:length(Item_BaoDi) of 
    %     0 -> %%没有即将达到保底的，则开始找weight 不为0的
            Rand = util:rand(1, Sum), %%产生一个随机数
            Item = get_item(Weight, Rand, NewItems), 
            Item.
        % _ -> 
        %     Item_Temp2 = lists:nth(1, Item_BaoDi),
        %     Item_Temp2
    % end.

%%获得符合条件的一个物品
get_item(Weights, Rand, Items) ->
    N = get_fit_item_num(Weights, Rand, 1),
    case (N == 0) or (erlang:length(Items) == 0) of 
        true -> 0;
        false ->

            case N > erlang:length(Items) of 
                true -> lists:nth(N - 1, Items);
                false -> lists:nth(N, Items)
            end
    end.

get_fit_item_num([], _, N) -> N ; %%没有一个值可以匹配时选择最小的那一个
get_fit_item_num([Weight|T], Rand, N) ->
    case  Rand - Weight > 0 of 
        true ->
            get_fit_item_num(T, Rand - Weight, N + 1) ;
        false ->
            N
    end.

% -record(npc_store_base_item, {
%         item_id = 0                    %% 物品id
%         ,weight = 0                    %% 权重
%         ,weight_temp = 0               %% 存放暂时的权重
%         ,times_max                     %% 保底次数，表示连续N次内必须出现 
%         ,times_max_undisplay           %% 表示连续N次未出现 
%         ,times_limit_display           %% 限制次数内已经出现的次数 
%         ,times_limit                   %% 限制次数 
%         ,times_terminate               %% 禁用次数
%         ,count                         %% 计算刷新的次数，概率被清零时开始计算，概率恢复则清零计数器 
%         ,order = 0                     %% 由于相同物品有不同价格，添加order作为主键用
%     }
% ).


%%更新角色所有的物品数据，检查是否达到限制条件，是否可以解禁物品出现
update_role_allitems(Al_Items, Refresh_Items) ->
    NRefresh_Items = do_update_role_allitems_displaytime(Refresh_Items, []),%%更新出现的数据，检查各种条件
    List = Al_Items -- Refresh_Items,

    NLeftItems = do_update_role_allitems_undisplaytime(List, []),%%更新未出现的数据

    NRefresh_Items ++ NLeftItems.

do_update_role_allitems_displaytime([], L) -> L;
do_update_role_allitems_displaytime([H = #npc_store_base_item{weight = W, times_limit_display = Times, times_limit = Limit, times_terminate = Times_terminate}|T], L) -> 
    NH = 
        case Times - Limit == -1 andalso Times_terminate =/= 0  of 
            true ->     %%刚好达到了限制次数，暂时禁用，权重为0，未出现次数为0，出现次数为0，限制出现
                H#npc_store_base_item{weight = 0, weight_temp = W, times_max_undisplay =0, times_limit_display= 0, count =0};
            false ->    %%未达到限制次数，则更新未出现次数0，增加出现次数+1
                H#npc_store_base_item{times_max_undisplay = 0, times_limit_display= Times + 1}
        end,
    do_update_role_allitems_displaytime(T, [NH|L]).

do_update_role_allitems_undisplaytime([], TempList) -> 

    TempList;
do_update_role_allitems_undisplaytime([H = #npc_store_base_item{weight = W1, weight_temp = W, times_max_undisplay = UnDisplay, count = C, times_terminate =Ter}|T], TempList) ->
    NH =  
        case C + 1 == Ter of 
            true ->     %% 禁止出现的次数刚好达到了刷新的次数，则解禁，下一次刷新有机会出现
                 H#npc_store_base_item{
                 weight = W,
                 weight_temp = 0, times_max_undisplay = 0, times_limit_display= 0,
                 count =0};
            false ->    %%仍然未达到解禁的条件
                case W1 == 0 of %%禁用的，只更新计数器
                    true ->
                        H#npc_store_base_item{count = C + 1};
                    false -> %% 不是被禁用的，只更新未出现+1
                        H#npc_store_base_item{times_max_undisplay = UnDisplay + 1}
                end
        end,
    do_update_role_allitems_undisplaytime(T, [NH|TempList]).


%%获取随机的8个物品
get_default_rand_items() ->
    Items = npc_store_data_sm_item:get_all_item(),%%返回物品id与物品权重的列表
    Length = npc_store_data_sm_item:get_all_item_length(),%%返回物品id与物品权重的列表
    rand_default_items(Items, Length, 8).

rand_default_items(Items, Length, Num) ->
    do_rand_default_items(Items, Length, Num, 0, []).

do_rand_default_items(_, _, Num, Num, L) -> L;
do_rand_default_items(Items, Max, Num, Count, L) -> 
    Rand = util:rand(1, Max),
    case lists:member(Rand, L) of 
        true ->
            do_rand_default_items(Items, Max, Num, Count, L);
        false ->
            Item = lists:nth(Rand, Items),
            do_rand_default_items(Items, Max, Num, Count + 1, [Item|L])
    end.



%% 帮会升级提示
guild_lev_up(#guild{id = {Gid, Gsrvid}, lev = 3}) ->
    Items0 = make_items([{23200, 1, 1}], []),
    ItemMsg0 = notice:item_to_msg(Items0),
    Items = make_items([{32531, 1, 1}], []),
    ItemMsg = notice:item_to_msg(Items),
    Msg = util:fbin(?L(<<"帮会提升到3级，获得了帮会商店功能！可用帮贡兑换~s等珍贵物品，{open, 12, 点击打开帮贡商店, #ffe500}，继续提升帮会到10级，将有~s等珍贵物品出售。">>), [ItemMsg0, ItemMsg]),
    guild:guild_chat({Gid, Gsrvid}, Msg);
guild_lev_up(#guild{id = {Gid, Gsrvid}, lev = 10})  ->
    Items = make_items([{32532, 1, 1}, {32000, 1, 1}], []),
    ItemMsg = notice:item_to_msg(Items),
    Msg = util:fbin(?L(<<"帮会提升到10级，帮会商店增售许多珍稀物品！{open, 12, 点击打开帮贡商店, #ffe500}，继续提升帮会到20级，将有~s等珍贵物品出售。">>), [ItemMsg]),
    guild:guild_chat({Gid, Gsrvid}, Msg);
guild_lev_up(#guild{id = {Gid, Gsrvid}, lev = 20}) ->
    Items = make_items([{25022, 1, 1}, {32001, 1, 1}, {23003, 1, 1}, {21035, 1, 1}], []),
    ItemMsg = notice:item_to_msg(Items),
    Msg = util:fbin(?L(<<"帮会提升到20级，帮会商店增加了许多珍稀物品！{open, 12, 点击打开帮贡商店, #ffe500}，继续提升帮会到25，将有~s等珍贵物品出售。">>), [ItemMsg]),
    guild:guild_chat({Gid, Gsrvid}, Msg);
guild_lev_up(#guild{id = {Gid, Gsrvid}, lev = 25}) ->
    Items = make_items([{32001, 1, 1}, {23003, 1, 1}], []),
    ItemMsg = notice:item_to_msg(Items),
    Msg = util:fbin(?L(<<"帮会提升到25级，帮会商店增加~s等珍贵物品！{open, 12, 点击打开帮贡商店, #ffe500}">>), [ItemMsg]),
    guild:guild_chat({Gid, Gsrvid}, Msg);
guild_lev_up(_Guild) -> 
    ok.

%% 获取购买物品价格系数 
get_rate(_IsRemote, _Role) -> 1.

%% 普通商店：获取可购买物品列表
get_buy_item_list(NpcId, Rate) -> 
    %% ?DEBUG("普通NPC[npc_id[~p]]", [NpcId]),
    case npc_store_data:get(NpcId, ?npc_store_nor_coin) of
        {ok, #npc_store_base{price_key = PriceKey, items = StoreItems}} ->
            {ok, do_buy_item_list(PriceKey, Rate, StoreItems)};
        _ ->
            {false, ?L(<<"此NPC无法出售物品">>)}
    end.

%% 普通商店：买商店物品到背包 
buy(NpcId, Rate, Bindtype, BuyList, Role) ->
    case npc_store_data:get(NpcId, ?npc_store_nor_coin) of
        {ok, #npc_store_base{price_key = PriceKey, items = StoreItems}} ->
            case make_buy_item(StoreItems, Bindtype, BuyList, []) of
                {false, Reason} -> {false, Reason};
                {ok, []} -> {false, ?L(<<"没有可购买物品">>)};
                {ok, GetItems} ->
                    case sum_items_price(Rate, GetItems, 0, PriceKey) of
                        false -> {false, ?L(<<"计算物品价格失败">>)};
                        {ok, TotalPrice} ->
                            Label = loss_price_type(Bindtype),
                            case role_gain:do(#loss{label = Label, val = TotalPrice}, Role) of
                                {false, _Loss} -> {Label, loss_error_msg(Bindtype)};
                                {ok, NRole} ->
                                    case storage:add(bag, NRole, GetItems) of
                                        false -> {false, ?L(<<"您的背包已经满了哦">>)};
                                        {ok, NewBag} ->
                                            send_inform(NRole, Bindtype, TotalPrice, GetItems),
                                            NewRole = role_listener:buy_item_store(NRole, GetItems),
                                            NewRole2 = role_listener:get_item(NewRole#role{bag = NewBag}, GetItems),
                                            role_api:push_assets(Role, NewRole2),
                                            {ok, NewRole2}
                                    end
                            end
                    end
            end;
        _ -> {false, ?L(<<"没有可购买物品">>)}
    end.

%% 兑换：获取兑换物品列表
exchange_item_list(Type, NpcId, _Role) ->
    %% ?DEBUG("npc_id:[~p] type:[~p]", [NpcId, Type]),
    case npc_store_data:exchange(NpcId, Type) of
        {ok, #npc_store_base{price_key = PriceKey, items = StoreItems}} ->
            L = do_buy_item_list(PriceKey, 1, StoreItems),
            NewL = [{BaseId, Price} || {BaseId, Price, _N} <- L],
            {ok, NewL};
        _ -> 
            {false, ?L(<<"无相应物品兑换">>)}
    end.

%% 兑换：兑换物品到背包
exchange_item(Type, NpcId, BuyList, Role) ->
    case npc_store_data:exchange(NpcId, Type) of
        {ok, #npc_store_base{price_key = PriceKey, items = StoreItems}} ->
            TotalNum = sum_items_num(BuyList, 0),
            case find_today_log(Type, Role) of
                {{_Type, _Times, Count}, _NS} when TotalNum > Count ->
                    {false, util:fbin(?L(<<"您今天可以兑换的物品已经达到了可兑换上限~p个">>), [exchange_item_count(Type)])};
                {{_Type, Times, Count}, NS = #npc_store{log = Logs}} ->
                    case make_buy_item(StoreItems, 1, BuyList, []) of
                        {false, Reason} -> {false, Reason};
                        {ok, []} -> {false, ?L(<<"无相应物品兑换">>)};
                        {ok, GetItems} ->
                            case sum_items_price(1, GetItems, 0, PriceKey) of
                                false -> {false, ?L(<<"计算物品价格失败">>)};
                                {ok, TotalPrice} ->
                                    case role_gain:do(#loss{label = loss_price_type(Type), val = TotalPrice}, Role) of
                                        {false, _Loss} -> {false, loss_error_msg(Type)};
                                        {ok, NRole} ->
                                            case storage:add(bag, NRole, GetItems) of
                                                false -> {false, ?L(<<"您的背包已经满了哦">>)};
                                                {ok, NewBag} ->
                                                    Log = {Type, Times + 1, Count - TotalNum},
                                                    NewLogs = lists:keyreplace(Type, 1, Logs, Log),
                                                    NewNS = NS#npc_store{log = NewLogs},
                                                    NRole1 = role_listener:buy_item_store(NRole, GetItems),
                                                    NewRole = role_listener:get_item(NRole1#role{bag = NewBag, npc_store = NewNS}, GetItems),
                                                    role_api:push_assets(Role, NewRole),
                                                    send_inform(NRole, Type, TotalPrice, GetItems),
                                                    {ok, Times + 1, Count - TotalNum, NewRole}
                                            end
                                    end
                            end
                    end
            end;
        _ -> {false, ?L(<<"无相应物品兑换">>)}
    end.

%% 获取可出售物品列表
get_can_sale_list(_Role = #role{bag = #bag{items = Items}}) -> 
    get_can_sale_list(Items, []).
get_can_sale_list([], SaleItems) -> SaleItems;
get_can_sale_list([#item{id = Id, pos = Pos, base_id = BaseId, quantity = Num} | T], SaleItems) -> 
    case get_price(1, BaseId, sell_npc) of
        {ok, Price} -> 
            get_can_sale_list(T, [{Id, Pos, BaseId, Num, Price} | SaleItems]);
        _ -> get_can_sale_list(T, SaleItems)
    end.

%% 出售背包物品
sale(Ids, Role = #role{bag = Bag}) -> 
    case get_items(Bag, Ids, []) of
        {false, Reason} -> {false, Reason};
        {ok, Items} -> 
            case sum_items_price(1, Items, 0, sell_npc) of
                false -> {false, ?L(<<"计算物品价格失败">>)};
                {ok, TotalPrice} -> 
                    DelItems = [{Id, Num} || #item{id = Id, quantity = Num} <- Items],
                    G = [
                        #loss{label = item_id, val = DelItems}
                        ,#gain{label = coin_bind, val = TotalPrice}
                    ],
                    case role_gain:do(G, Role) of
                        {false, #gain{}} -> {false, ?L(<<"增加金币失败">>)};
                        {false, #loss{}} -> {false, ?L(<<"删除物品失败">>)};
                        {ok, NRole} ->
                            send_inform(NRole, ?npc_store_bind_coin, TotalPrice),
                            {ok, NRole}
                    end
            end
    end.

%% 获取背包格子物品
get_items(_Bag, [], Items) -> {ok, Items};
get_items(Bag = #bag{items = Items}, [Id | T], Is) -> 
    case storage:find(Items, #item.id, Id) of
        {false, Reason} -> {false, Reason};
        {ok, Item} ->
            get_items(Bag, T, [Item | Is])
    end.

%% 获取当天兑换情况 
%% @spec find_today_log(Type, Role) -> {{Type, Times, Count}, NewNS}
%% Type = integer() 类型
%% Role = #role{}
%% Times = integer() 次数
%% Count = integer() 件数
%% NewNS = #npc_store{}
find_today_log(Type, Role) ->
    Today = today(),
    do_find_log(Type, Role, Today).

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
loss_price_type(?npc_store_practice) -> practice;
loss_price_type(?npc_store_lilian) -> lilian;
loss_price_type(_) -> false.

%% 扣除财产失败信息
loss_error_msg(?npc_store_nor_coin) -> ?L(<<"金币不足">>);
loss_error_msg(?npc_store_bind_coin) -> ?L(<<"绑定金币不足">>);
loss_error_msg(?npc_store_arena_score) -> ?L(<<"您的竞技场积分不足，无法兑换哦">>);
loss_error_msg(?npc_store_nor_gold) -> ?L(<<"晶钻不足">>);
loss_error_msg(?npc_store_bind_gold) -> ?L(<<"绑定晶钻">>);
loss_error_msg(?npc_store_coin_all) -> ?L(<<"所有金币不足">>);
loss_error_msg(?npc_store_career_devote) -> ?L(<<"您的师门积分不足，无法兑换哦">>);
loss_error_msg(?npc_store_guild_war) -> ?L(<<"您的帮战积分不足，无法兑换哦">>);
loss_error_msg(?npc_store_guild_devote) -> ?L(<<"您的帮会贡献不足，无法兑换哦">>);
loss_error_msg(?npc_store_practice) -> ?L(<<"您的试练积分不足，无法兑换哦">>);
loss_error_msg(?npc_store_lilian) -> ?L(<<"您的仙道历练不足，无法兑换哦">>);
loss_error_msg(?npc_store_buchong) -> ?L(<<"您的捕宠积分不足，无法兑换哦">>);
loss_error_msg(_) -> ?L(<<"扣除资产失败">>).

%% 左下角提示信息
loss_inform(?npc_store_nor_coin) -> ?L(<<"{str,金币,#FFD700}">>);
loss_inform(?npc_store_bind_coin) -> ?L(<<"{str,绑定金币,#FFD700}">>);
loss_inform(?npc_store_arena_score) -> ?L(<<"{str,竞技场积分,2fecdc}">>);
loss_inform(?npc_store_nor_gold) -> ?L(<<"{str,晶钻,#FFD700}">>);
loss_inform(?npc_store_bind_gold) -> ?L(<<"{str,绑定晶钻,#FFD700}">>);
loss_inform(?npc_store_coin_all) -> ?L(<<"{str,金币,#FFD700}">>);
loss_inform(?npc_store_career_devote) -> ?L(<<"{str,师门积分,#2fecdc}">>);
loss_inform(?npc_store_guild_war) -> ?L(<<"{str,帮战积分,#2fecdc}">>);
loss_inform(?npc_store_guild_devote) -> ?L(<<"{str,帮会贡献,#2fecdc}">>);
loss_inform(?npc_store_practice) -> ?L(<<"{str,试练积分,#2fecdc}">>);
loss_inform(?npc_store_lilian) -> ?L(<<"{str,仙道历练,#2fecdc}">>);
loss_inform(?npc_store_buchong) -> ?L(<<"{str,捕宠积分,#2fecdc}">>);
loss_inform(_) -> <<>>.

%% 推送右下角提示信息
send_inform(#role{pid = Pid}, PriceType, Price, AddItems) ->
    AddItemInfo = notice:item3_to_inform(AddItems),
    PriceInfo = loss_inform(PriceType),
    Msg = util:fbin(?L(<<"商店购买\n失去 ~s ~p\n获得 ~s">>), [PriceInfo, Price, AddItemInfo]),
    notice:inform(Pid, Msg).
send_inform(#role{pid = Pid}, PriceType, CoinBind) ->
    PriceInfo = loss_inform(PriceType),
    Msg = util:fbin(?L(<<"商店出售\n获得 ~s ~p">>), [PriceInfo, CoinBind]),
    notice:inform(Pid, Msg).

%%---------------------------------------------------
%% 内部函数
%%---------------------------------------------------

%% 获取每天兑换物品总件数
exchange_item_count(?npc_store_refresh_sm) -> 2; %% 神秘商店每天免费刷新次数 借用
exchange_item_count(?npc_store_arena_score) -> 500;
exchange_item_count(?npc_store_career_devote) -> 9999999999;
exchange_item_count(?npc_store_guild_war) -> 500;
exchange_item_count(?npc_store_guild_devote) -> 500;
exchange_item_count(?npc_store_practice) -> 500;
exchange_item_count(?npc_store_lilian) -> 500;
exchange_item_count(?npc_store_buchong) -> 500;
exchange_item_count(_) -> 0. 

%% 计算兑换物品总件数
sum_items_num([], Count) -> Count;
sum_items_num([[_BaseId, Num] | T], Count) ->
    sum_items_num(T, Num + Count).

%% 返回客户端购买物品信息
do_buy_item_list(_PriceKey, _Rate, []) -> [];
do_buy_item_list(PriceKey, Rate, [{BaseId, N} | T]) ->
    case get_price(Rate, BaseId, PriceKey) of
        {ok, Price} ->
            [{BaseId, Price, N} | do_buy_item_list(PriceKey, Rate, T) ];
        _ ->
            do_buy_item_list(PriceKey, Rate, T)
    end.

%% 生成购买物品
make_buy_item(_StoreItems, _Bindtype, [], GetItems) -> {ok, GetItems};
make_buy_item(_StoreItems, _Bindtype, [[_BaseId, Num] | _T], _GetItems) when Num =< 0 ->
    {false, ?L(<<"物品数量设置非法">>)};
make_buy_item(StoreItems, Bindtype, [[BaseId, Num] | T], GetItems) ->
    case lists:keyfind(BaseId, 1, StoreItems) of
        false -> {false, ?L(<<"存在不可操作物品">>)};
        _ ->
            case item:make(BaseId, Bindtype, Num) of
                false -> {false, ?L(<<"未知物品不能产生">>)};
                {ok, Item} ->
                    make_buy_item(StoreItems, Bindtype, T, (GetItems ++ Item))
            end
    end.

%% 统计出售物品的价格 (分绑定与非绑定)
%%sum_sale_items_price(Items) ->
%%    BindItems = [Item || Item <- Items, Item#item.bind =:= 1],
%%    NoBindItems = Items -- BindItems,
%%    case {sum_items_price(1, BindItems, 0, sell_npc), sum_items_price(1, NoBindItems, 0, sell_npc)} of
%%       {{ok, BindPrice}, {ok, NoBindPrice}} -> {ok, BindPrice, NoBindPrice};
%%       _ -> false
%%   end.

%% 获取一推物品的总价
sum_items_price(_Rate, [], TotalPrice, _PriceKey) -> {ok, TotalPrice};
sum_items_price(Rate, [#item{base_id = BaseId, quantity = Num} | T], TotalPrice, PriceKey) ->
    case get_price(Rate, BaseId, PriceKey) of
        {ok, Price} -> 
            sum_items_price(Rate, T, TotalPrice + Price * Num, PriceKey);
        _ -> 
            false
    end.

%% 物品价格获取
get_price(Rate, BaseId, PriceKey) -> 
    case item_data:get(BaseId) of
        {false, Reason} -> {false, Reason};
        {ok, #item_base{value = Val}} -> price(Rate, Val, PriceKey)
    end.

%% 找出物品价格项
price(_Rate, [], _PriceKey) -> {false, ?L(<<"查找物品价格失败">>)};
price(1, [{PriceKey, Price} | _T], PriceKey) -> {ok, Price};
price(Rate, [{PriceKey, Price} | _T], PriceKey) -> {ok, erlang:round(Price * Rate)};
price(Rate, [_I | T], PriceKey) -> price(Rate, T, PriceKey).

%% 获取当天兑换情况 Logs = [{类型, 次数, 总量}]
do_find_log(Type, #role{npc_store = NS = #npc_store{day = Today, log = Logs}}, Today) -> %% 当前已是今天日志
    case lists:keyfind(Type, 1, Logs) of
        false -> 
            Log = {Type, 0, exchange_item_count(Type)},
            {Log, NS#npc_store{log = [Log | Logs]}};
        Log ->
            {Log, NS}
    end;
do_find_log(Type, #role{npc_store = NS}, Today) -> %% 新的一天重新计算
    Log = {Type, 0, exchange_item_count(Type)},
    NewNS = NS#npc_store{day = Today, log = [Log]},
    {Log, NewNS}.

%% 获取当前天 yyyyMMdd
today() ->
    {Year, Month, Day} = erlang:date(),
    Year * 10000 + Month * 100 + Day.

%% 生成物品数据 [#item{}...]
make_items([], Items) -> Items;
make_items([{BaseId, Bind, Num} | T], Items) ->
    case item:make(BaseId, Bind, Num) of
        false -> 
            {false, ?L(<<"未知物品不能产生">>)};
        {ok, Item} ->
            make_items(T, Items ++ Item)
    end. 

% %%将元组转化为列表
% format_to_record_list([], L) -> L;
% format_to_record_list([{_, ItemId, Weight, Weight_temp, Times_max, Times_max_undisplay, Times_limit_display, Times_limit, 
%                                 Times_terminate, Count, Order}|T], L) ->
%     format_to_record_list(T, [#npc_store_base_item{item_id = ItemId, weight = Weight, weight_temp = Weight_temp, 
%                                 times_max = Times_max, times_max_undisplay = Times_max_undisplay, 
%                                 times_limit_display = Times_limit_display, times_limit = Times_limit, 
%                                 times_terminate = Times_terminate, count = Count, order = Order}|L]).


%%获取物品的id
get_items_id([], L) -> L;
get_items_id([H|T], L) ->
    get_items_id(T, [H#npc_store_base_item.item_id|L]).


get_items_order([], L) -> L;
get_items_order([H|T], L) ->
    get_items_order(T, [H#npc_store_base_item.order|L]).

get_price_val(0) -> {coin, 5000};
get_price_val(1) -> {gold, 10};
get_price_val(2) -> {gold, 20};
get_price_val(_) -> {gold, 30}.