%%----------------------------------------------------
%% NPC商店 
%% @author 252563398@qq.com
%%----------------------------------------------------
-module(npc_store_rpc).
-export([handle/3]).

-include("common.hrl").
-include("npc.hrl").
-include("map.hrl").
-include("pos.hrl").
-include("role.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("vip.hrl").
-include("npc_store.hrl").
%%
-include("assets.hrl").
-include("guild.hrl").
-include("storage.hrl").
-include("item.hrl").

%% 获取NPC商品列表
handle(11900, {NpcId, IsRemote}, Role) ->
    case check_distance(IsRemote, NpcId, Role) of
        {false, Reason} -> 
            {reply, {0, Reason, []}};
        {ok, BaseId} -> 
            Rate = npc_store:get_rate(IsRemote, Role),
            case npc_store:get_buy_item_list(BaseId, Rate) of
                {false, Reason} ->
                    {reply, {0, Reason, []}};
                {ok, L} ->
                    {reply, {1, <<>>, L}}
            end
    end;

%% 获取可出售物品列表
handle(11901, {}, Role) ->
    {reply, {npc_store:get_can_sale_list(Role)}};

%% 购买物品
handle(11902, {NpcId, IsRemote, Bindtype, BuyList}, Role) ->
    case check_distance(IsRemote, NpcId, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, BaseId} -> 
            Rate = npc_store:get_rate(IsRemote, Role),
            case npc_store:buy(BaseId, Rate, Bindtype, BuyList, Role) of
                {ok, NRole} ->
                    log:log(log_coin, {<<"npc商店购买">>, util:fbin(<<"是否绑定:~w">>, [Bindtype]), Role, NRole}),
                    {reply, {1, ?L(<<"购买成功">>)}, NRole};
                {coin, Reason} ->
                    {reply, {?coin_less, Reason}};
                {coin_bind, Reason} ->
                    {reply, {?coin_bind_less, Reason}};
                {_, Reason} ->
                    {reply, {0, Reason}}
            end
    end;

%% 出售物品
handle(11903, {NpcId, IsRemote, Ids}, Role) ->
    case check_distance(IsRemote, NpcId, Role) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, BaseId} -> 
            case npc_store_data:get(BaseId, ?npc_store_nor_coin) of
                {false, _Reason} -> {reply, {0, ?L(<<"此NPC无法出售物品">>)}};
                {ok, _} ->
                    case npc_store:sale(Ids, Role) of
                        {false, Reason} -> {reply, {0, Reason}};
                        {ok, NRole} -> 
                            log:log(log_coin, {<<"npc商店出售">>, <<"">>, Role, NRole}),
                            log:log(log_item_del_loss, {<<"NPC商店出售">>, NRole}),
                            {reply, {1, ?L(<<"出售成功">>)}, NRole}
                    end
            end
    end;

%% 获取兑换商品列表
handle(11904, {_BaseId, Type = ?npc_store_guild_devote}, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) -> %% 帮贡兑换
    BaseId = case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{lev = GuildLev} when GuildLev >= 25 -> 4;
        #guild{lev = GuildLev} when GuildLev >= 20 -> 3;
        #guild{lev = GuildLev} when GuildLev >= 10 -> 2;
        #guild{lev = GuildLev} when GuildLev >= 3 -> 1;
        _ -> -1
    end,
    case BaseId of
        -1 -> {reply, {0, ?L(<<"帮会达3级才开启贡献兑换商店功能">>), Type, 0, 0, []}};
        _ ->
            {{_Type, Times, Count}, _NS} = npc_store:find_today_log(Type, Role),
            case npc_store:exchange_item_list(Type, BaseId, Role) of
                {false, Reason} ->
                    {reply, {0, Reason, Type, Times, Count, []}};
                {ok, L} ->
                    {reply, {1, <<>>, Type, Times, Count, L}}
            end
    end;
handle(11904, {BaseId, Type}, Role) ->
    {{_Type, Times, Count}, _NS} = npc_store:find_today_log(Type, Role),
    case npc_store:exchange_item_list(Type, BaseId, Role) of
        {false, Reason} ->
            {reply, {0, Reason, Type, Times, Count, []}};
        {ok, L} ->
            {reply, {1, <<>>, Type, Times, Count, L}}
    end;

%% 兑换物品
handle(11905, {_BaseId, Type = ?npc_store_guild_devote, BuyList}, Role = #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) -> %% 帮贡兑换
    BaseId = case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{lev = GuildLev} when GuildLev >= 25 -> 4;
        #guild{lev = GuildLev} when GuildLev >= 20 -> 3;
        #guild{lev = GuildLev} when GuildLev >= 10 -> 2;
        #guild{lev = GuildLev} when GuildLev >= 3 -> 1;
        _ -> -1
    end,
    case BaseId of
        -1 -> {reply, {Type, 0, 0, 0, ?L(<<"帮会达3级才开启贡献兑换商店功能">>)}};
        _ ->
            role:send_buff_begin(),
            case npc_store:exchange_item(Type, BaseId, BuyList, Role) of
                {false, Reason} -> 
                    role:send_buff_clean(),
                    {reply, {Type, 0, 0, 0, Reason}};
                {ok, Times, Count, NRole} ->
                    role:send_buff_flush(),
                    log:log(log_integral, {Type, <<"兑换">>, BuyList, Role, NRole}),
                    {reply, {Type, Times, Count, 1, ?L(<<"兑换成功">>)}, NRole}
            end
    end;
handle(11905, {BaseId, Type, BuyList}, Role) ->
    case npc_store:exchange_item(Type, BaseId, BuyList, Role) of
        {false, Reason} -> 
            {reply, {Type, 0, 0, 0, Reason}};
        {ok, Times, Count, NRole} ->
            log:log(log_integral, {Type, <<"兑换">>, BuyList, Role, NRole}),
            {reply, {Type, Times, Count, 1, ?L(<<"兑换成功">>)}, NRole}
    end;

%% 获取神秘商店商品列表
handle(11906, {}, Role) ->
    {{_Type, UseTimes, TotalTimes}, _NS} = npc_store:find_today_log(?npc_store_refresh_sm, Role),
    FreeTimes = TotalTimes - UseTimes,
    case npc_store_sm:call({sm_items, Role}) of
        {false, Reason} ->
            {reply, {0, Reason, 0, [], [], FreeTimes, TotalTimes}};
        {ok, RefreshTime, Items, Logs} ->
            {reply, {1, <<>>, RefreshTime, Items, Logs, FreeTimes, TotalTimes}};
        {ok, RefreshTime, Items, Logs, NRole} ->
            {reply, {1, <<>>, RefreshTime, Items, Logs, FreeTimes, TotalTimes}, NRole}
    end;


%% 神秘商店刷新
handle(11907, {}, Role = #role{id = {Rid, _}, link = #link{conn_pid = Conn_Pid}}) ->
    {_, Free_Times, _} = npc_store_sm:get_role_last_items(Role),
    RefreshType = 
        case Free_Times > 0 of 
            true -> Free_Times;
            false -> 0
        end,
    case npc_store:refresh_items(RefreshType, Role) of 
        {false, Reason} ->
            notice:alert(error, Conn_Pid, Reason),
            {ok};
        {true, NRole, Items, FreeTimes} ->
            ItemOrders = npc_store:get_items_order(Items, []),
            T1 = npc_store_sm:get_role_refresh_times(Rid),
            log:log(log_coin, {<<"神秘商店刷新">>, <<"神秘商店刷新消耗">>, Role, NRole}),
            {reply, {FreeTimes, ?refresh_time, T1, ItemOrders}, NRole}
    end;


%% 购买神秘商店物品
handle(11908, {Id}, Role = #role{name = Name, link = #link{conn_pid = Conn_Pid}, assets = #assets{gold = _Gold, gold_bind = GoldBind}}) ->
    case npc_store_data_sm_item:get(Id) of 
        {ok, Item} ->
            BaseId = Item#npc_store_item2.item_id,
            Price = Item#npc_store_item2.price,
            ItemName = Item#npc_store_item2.item_name,
            Price_Type = Item#npc_store_item2.price_type,
            Is_notice = Item#npc_store_item2.is_notice,
            
            L = 
                case Price_Type of 
                    3 ->
                        [#loss{label = gold, val = Price, msg = ?MSGID(<<"晶钻不足">>)}];
                    0 ->
                        [#loss{label = coin, val = Price, msg = ?MSGID(<<"金币不足！">>)}];
                    4 ->
                        case GoldBind < Price of 
                            true ->
                                [#loss{label = gold_bind, val = GoldBind, msg = ?MSGID(<<"绑定晶钻不足！">>)},
                                #loss{label = gold, val = Price - GoldBind, msg = ?MSGID(<<"晶钻不足">>)}];
                            false ->
                                [#loss{label = gold_bind, val = Price, msg = ?MSGID(<<"绑定晶钻不足！">>)}]
                        end
                end,
            role:send_buff_begin(),
            case role_gain:do(L, Role) of
                {false, #loss{msg = Msg}} -> 
                    role:send_buff_clean(),
                    notice:alert(error, Conn_Pid, Msg),
                    {ok};
                {false, Rea} ->
                    role:send_buff_clean(),
                    notice:alert(error, Conn_Pid, Rea),
                    {ok};
                {ok, NRole} -> 
                    case storage:make_and_add_fresh(BaseId, 1, 1, NRole) of 
                        {ok, #role{bag = NewBag}, _} ->
                            NR = NRole#role{bag = NewBag},
                            NR1 = role_listener:get_item(NR, #item{base_id = BaseId, quantity = 1}),
                            case Is_notice of 
                                1 ->
                                    npc_store_sm:update_lucky_ets(Name, ItemName),     
                                    RoleMsg = notice:role_to_msg(Name),
                                    ItemMsg = notice:item_msg({BaseId, 0, 1}),
                                    role_group:pack_cast(world, 10932, {7, 0, util:fbin(?L(<<"~s从神秘商店购买了~s">>), [RoleMsg, ItemMsg])});
                                _ -> ok
                            end,
                            {true, NewItem} = npc_store:refresh_item(Id, Role),
                            role:send_buff_flush(),
                            case Price_Type of 
                                0 ->
                                    log:log(log_coin, {<<"npc神秘商店购买物品">>, <<"">>, Role, NRole});
                                _ -> skip
                            end,
                            % random_award:item(NR1, BaseId, 1),
                            add_log(Role, BaseId, Price, Price_Type, Is_notice),
                            {reply, {NewItem#npc_store_base_item.order}, NR1};
                        {_, Reason} ->
                            role:send_buff_clean(),
                            notice:alert(error, Conn_Pid, Reason),
                            {ok}
                    end
            end;
        {false, Reason} ->
            notice:alert(error, Conn_Pid, Reason),
            {ok}
    end;


%% 进入神秘商店,推送剩余免费的刷新次数，以及上次刷新的物品，以及幸运榜
handle(11910, {}, Role = #role{id = {Rid, _}}) ->
    {Last_Time, Free_Times, Last_Items} = npc_store_sm:get_role_last_items(Role),
    Now = util:unixtime(),
    AllFree = ?base_free + vip:npc_store(Role),
    {NFreeTimes, Cool_Time} = 
        case Free_Times < AllFree of 
            true ->               
                case Now - Last_Time >= (AllFree - Free_Times) * ?refresh_time of %%6/12小时没刷新能得到1/2次免费机会，满2次则不计时
                    true -> 
                        npc_store_sm:update_role_last_items(Rid, 0, AllFree, Last_Items),
                        {AllFree, 0}; %%过了n久
                    false -> 
                        N = (Now - Last_Time) div ?refresh_time,
                        NF1 = Free_Times + N,
                        npc_store_sm:update_role_last_items(Rid, Last_Time + N * ?refresh_time, NF1, Last_Items),
                        {NF1, ?refresh_time - (Now - Last_Time) rem ?refresh_time} %%已经过了6n个小时，下一个计时
                end;
            false ->
                npc_store_sm:update_role_last_items(Rid, 0, AllFree, Last_Items),
                {Free_Times, 0}
        end,
    NItems = 
        case erlang:length(Last_Items) of 
            0 ->
                Default = npc_store:get_default_rand_items(),      %%获取配置表关于神秘商店默认物品的配置,随机
                npc_store_sm:update_role_last_items(Rid, 0, NFreeTimes, Default),
                Default;
            _ ->
                case {util:is_same_day2(Last_Time, Now), Last_Time =/= 0} of %%util:is_same_day2(LastTime, Now)
                    {fasle, true} -> 
                        Default = npc_store:get_default_rand_items(),
                        npc_store_sm:update_role_last_items(Rid, 0, NFreeTimes, Default),
                        Default;
                    _ -> 
                        Last_Items
                end
        end,
    %%好运榜
    Lucky_Data = npc_store_sm:get_all_lucky(),
    ItemOrders = npc_store:get_items_order(NItems, []),
    ?DEBUG("------ItemOrders-----~p~n", [ItemOrders]),
    T1 = npc_store_sm:get_role_refresh_times(Rid),
    {reply, {NFreeTimes, Cool_Time, T1, ItemOrders, Lucky_Data}};


%% 推送倒计时时间,客户端每次倒计时到0时请求一次
handle(11911, {}, Role = #role{id = {Rid, SrviD}}) ->
    {Last_Time, Free_Times, Last_Items} = npc_store_sm:get_role_last_items(Role),
    Now = util:unixtime(),
    AllFree = ?base_free + vip:npc_store(Role),
    {NFreeTimes, Cool_Time} = 
        case Free_Times < AllFree of 
            true ->               
                case Now - Last_Time >= ?refresh_time * (AllFree - Free_Times) of %%
                    true -> 
                        npc_store_sm:update_role_last_items(Rid, 0, AllFree, Last_Items),
                        {AllFree, 0}; 
                    false -> 
                        N = (Now - Last_Time) div ?refresh_time,
                        NF1 = Free_Times + N,
                        case NF1 == AllFree of 
                            true -> 
                                npc_store_sm:update_role_last_items(Rid, 0, AllFree, Last_Items),
                                {NF1, 0};
                            false ->
                                npc_store_sm:update_role_last_items(Rid, Last_Time + N * ?refresh_time, NF1, Last_Items),
                                {NF1, ?refresh_time}
                        end
                end;
            false ->    
                npc_store_sm:update_role_last_items(Rid, 0, Free_Times, Last_Items),
                {Free_Times, 0}
        end,
    notification:send(offline, {Rid, SrviD}, 2, <<"你的<font color ='ffffffff'>【神秘商店】</font>刷新次数增加了，赶快去刷一刷吧！">>, []),
    {reply, {Cool_Time, NFreeTimes}};



%% 获取动态商店物品价格信息
handle(11920, {0}, _Role) -> %% 金币售价列表
    case npc_store_live:apply(sync, get) of
        {RT, PL} -> {reply, {0, RT, PL}};
        _ -> {ok}
    end;
handle(11920, {1}, _Role) -> %% 绑定金币售价列表
    {reply, {1, 0, ?npc_store_live_bind_items}};
handle(11920, {_Type}, _Role) ->
    {ok};

%% 在动态商店出售物品
handle(11921, {Type, Ids}, Role) ->
    case npc_store_live:apply(sync, {sale, {Type, Ids}, Role}) of
        {false, Reason} -> {reply, {0, Reason}};
        {ok, NRole} ->
            NewRole = role_listener:coin(NRole, NRole#role.assets#assets.coin - Role#role.assets#assets.coin),
            {reply, {1, <<>>}, NewRole}
    end;

%% 获取副本神秘商店的商品列表
handle(11930, {NpcId}, Role) ->
    case npc_store_dung:get_items(Role, NpcId) of
        {false, Msg} ->
            {reply, {?false, Msg, [], []}};
        {ok, Items, Logs} ->
            {reply, {?true, <<>>, Items, Logs}}
    end;

%% 购买副本神秘商店物品列表
handle(11931, {NpcId, BuyList}, Role = #role{event = ?event_dungeon, pos = #pos{map_base_id = MapBaseId}})
when (MapBaseId >= 20404 andalso MapBaseId =< 20412) orelse (MapBaseId >= 20506 andalso MapBaseId =< 20512) -> %% 限制只能在地狱塔副本内
    case npc_store_dung:buy_items(Role, NpcId, BuyList) of
        {false, {ErrCode, Msg}} ->
            {reply, {ErrCode, Msg}};
        {false, Msg} ->
            {reply, {?false, Msg}};
        {ok, NewRole} ->
            {reply, {?true, <<>>}, NewRole}
    end;
handle(11931, _, _) ->
    {reply, {?false, ?L(<<"您距离神秘商人太远，无法购买">>)}};

handle(11941, {ItemId, _DanId, Type}, Role = #role{bag = #bag{items = Items}}) when Type =:= 1 orelse Type =:= 2 ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item} ->
            case pandora_box:polish(Type, Item, Role) of
                {ok, NewRole} ->
                    {reply, {?true, <<>>}, NewRole};
                {false, Msg} ->
                    {reply, {?false, Msg}};
                {ErrCode, Msg} ->
                    {reply, {ErrCode, Msg}}
            end;
        _ ->
            {reply, {?false, ?L(<<"未找到该物品">>)}}
    end;

%% 购买宝盒内的时装饰品等
%% ItemId 宝盒的ID(面板打开已提前通知客户端)
%% BaseId 购买物品的基础ID
handle(11942, {ItemId, _DanId, BaseId}, Role = #role{bag = #bag{items = Items}}) ->
    case storage:find(Items, #item.id, ItemId) of
        {ok, Item} ->
            case pandora_box:get_item(Item, BaseId, Role) of
                {ok, NewRole} ->
                    {reply, {?true, <<>>}, NewRole};
                {false, Msg} ->
                    {reply, {?false, Msg}};
                {ErrCode, Msg} ->
                    {reply, {ErrCode, Msg}}
            end;
        _ ->
            {reply, {?false, ?L(<<"未找到该物品">>)}}
    end;

handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.

%%----------------------------------------------------------
%% 内部方法
%%----------------------------------------------------------

%% 判断人与NPC距离
check_distance(1, _NpcId, Role) ->
    case vip:check(Role) of
        false -> 
            ?DEBUG("非VIP无远程商店功能"),
            {false, ?L(<<"非VIP无远程商店功能">>)};
        true -> {ok, remote}
    end;
check_distance(_IsRemote, NpcId, _Role = #role{pos = #pos{map_pid = MapPid1, x = X1, y = Y1}}) -> 
    case npc_mgr:lookup(by_id, NpcId) of
        false ->
            ?DEBUG("不存在的NPC:[~p]", [NpcId]),
            {false, ?L(<<"无法指定相关NPC">>)};
        _Npc = #npc{pos = #pos{map_pid = MapPid2, x = X2, y = Y2}, base_id = BaseId} ->
            DistX = erlang:abs(X1 - X2),
            DistY = erlang:abs(Y1 - Y2),
            if
                MapPid1 =:= MapPid2 andalso DistX =< 500 andalso DistY =< 500 -> 
                    {ok, BaseId};
                true ->
                    ?DEBUG("距离太远 NpcId:~p BaseId:~p [npc: ~p, ~p] [role: ~p, ~p]", [NpcId, BaseId, X2, Y2, X1, Y1]),
                    {false, ?L(<<"您的距离太远了，请离商人近一点">>)}
            end
    end.

add_log(_Role = #role{id = {Rid, SrvId}, name = Name}, BaseId, Price, PriceType, IsNotice) ->
    Log = #npc_store_sm_log{
        rid = Rid, srv_id = SrvId, name = Name 
        ,base_id = BaseId, num = 1, price = Price
        ,price_type = PriceType, buy_time = util:unixtime()
    },
    npc_store_dao:add_log_sm(2, IsNotice, Log). %% 2表示未知