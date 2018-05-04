%%----------------------------------------------------
%%  帮会仓库
%% @author liuweihua(yjbgwxf@gmail.com)
%%----------------------------------------------------
-module(guild_store).
-export([start/1
        ,async_maintain/1
        ,log/1
        ,items/1
        ,in_store/3
        ,in_store_sync/5
        ,out_store/3
        ,out_store_sync/5
        ,out_store_sync/7
        ,move/3
        ,move_async/5
        ,discard/2
        ,discard_async/6
        ,tidy/1
        ,tidy_async/2
    ]
).

-include("common.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("link.hrl").
-include("item.hrl").
-include("storage.hrl").
-include("gain.hrl").
%%

%% @spec start(GuildID) -> ok
%% GuildID = gid()
%% @doc 注册仓库日志午夜清理函数
start({Gid, Gsrvid}) ->
    guild:reg_maintain_callback({Gid, Gsrvid}, {?MODULE,  async_maintain, []}).

%% @spec async_maintain(Guild) -> {ok, NewGuild}
%% Guild = NewGuild = #guild{}
%% @doc 午夜维护仓库回调函数
async_maintain(Guild = #guild{store_log = Log}) ->
    {ok, guild:alters([{store_log, lists:sublist(Log, 200)}], Guild)}.

%% @spec items(Role) -> Itemslist
%% @doc 获取仓库物品列表
items(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{store = #guild_store{items = Items}} ->
            Items;
        _ ->
            []
    end.

%% @spec log(Role) -> List
%% @doc 获取仓库操作记录
log(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{store_log = Log} ->
            Log;
        _ ->
            []
    end.

%% @spec in_store(ItemId, StorePos, Role) -> {false, Reason} | {ok, NewRole}
%% ItemId = StorePos = integer()
%% Role = #role{}
%% @doc 放入仓库
in_store(ItemId, StorePos, Role = #role{id = {Rid, _}, name = Name, bag = Bag = #bag{items = Items}, link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case storage:find(Items, #item.id, ItemId) of 
        {false, Reason} ->
            {false, Reason};
        {ok, Item = #item{quantity = Num, status = ?lock_release, bind = 0}}  ->
            case role_gain:do([#loss{label = item_id, val = [{ItemId, Num}]}], Role) of
                {ok, NewRole} ->
                    case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, in_store_sync, [StorePos, Item, Rid, Name]}) of
                        true ->
                            store(refresh, Role),   %% 只给当前进程刷新当前仓库物品
                            log:log(log_item_del_loss, {<<"放帮会仓库">>, NewRole}),
                            {ok, NewRole};
                        {true, NumRest} ->
                            NewItem = Item#item{quantity = NumRest},
                            storage_api:add_item_info(ConnPid, [{?storage_bag, NewItem}]),
                            store(refresh, Role),  %% 只给当前进程刷新当前仓库物品
                            log:log(log_item_del_loss, {<<"放帮会仓库">>, NewRole}), %% TODO 则此时记录的角色物品使用记录有误，可集合帮会仓库日志分析具体使用数量
                            {ok, NewRole#role{bag = Bag#bag{items = lists:keyreplace(ItemId, #item.id, Items, NewItem)}}};
                        {false, Reason} ->
                            storage_api:add_item_info(ConnPid, [{?storage_bag, Item}]),
                            {false, Reason};
                        _ ->
                            storage_api:add_item_info(ConnPid, [{?storage_bag, Item}]),
                            {false, ?MSGID(<<"放入失败">>)}
                    end;
                _ ->
                    {false, ?MSGID(<<"物品数量不足">>)}
            end;
        _ -> 
            {false, ?MSGID(<<"此为锁定或绑定物品,不能移动">>)}
    end.

%% @spec out_store(ItemId, BagPos, Role) -> {false, Reason} | {ok, NewRolel}
%% ItemId = BagPos = integer()
%% Role = NewRole = #role{}
%% Reason = binary()
%% @doc 从仓库取出 角色进程取不到帮会仓库对应的item数据，无法判断是否同物品
out_store(_ItemId, _BagPos, #role{guild = #role_guild{gid = 0}}) ->
    {false, <<>>};
out_store(_ItemId, BagPos, #role{bag = #bag{volume = Vol}}) when BagPos > Vol ->
    {false, ?MSGID(<<"目标格子没有开通">>)};
out_store(ItemId, BagPos, Role = #role{id = {Rid, _}, name = Name, bag = Bag = #bag{next_id = NextId, free_pos = FPos, items = Items}, link = #link{conn_pid = ConnPid},guild = #role_guild{gid = Gid, srv_id = Gsrvid, donation = DO}}) ->
    case lists:member(BagPos, FPos) of
        false ->
            case lists:keyfind(BagPos, #item.pos, Items) of
                false ->
                    ?ERR("角色背包数据异常，位置~w，没有物品，背包数据: ~w", [BagPos, Items]),
                    {false, <<>>};
                H = #item{id = BItemId, status = ?lock_release, bind = 0, quantity = Num, base_id = BaseId} ->
                    case item_data:get(BaseId) of
                        {ok, #item_base{overlap = OLap}} when Num < OLap, OLap =/=1 ->
                            case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, out_store_sync, [ItemId, Rid, Name, BaseId, Num, DO]}) of
                                {false, Reason} -> {false, Reason};
                                {true, NewNum} ->
                                    NewItem = H#item{quantity = NewNum},
                                    storage_api:refresh_single(ConnPid, {1, NewItem}),
                                    store(refresh, Role),  %% 只给当前进程刷新当前仓库物品
                                    {ok, Role#role{bag = Bag#bag{items = lists:keyreplace(BItemId, #item.id, Items, NewItem)}}};
                                _ -> 
                                    {false, ?MSGID(<<"取出失败">>)}
                            end;
                        {ok, _ItemBase} -> {false, ?MSGID(<<"目标格子已满">>)};
                        {false, Reason} -> {false, Reason}
                    end;
                _ -> {false, ?MSGID(<<"目标格子类物品被锁定或为绑定物品，不可放置该格子">>)}
            end;
        true ->
            case guild:apply(sync, {Gid, Gsrvid}, {?MODULE, out_store_sync, [ItemId, Rid, Name, DO]}) of
                {true, Item} ->
                    NewItem = Item#item{id = NextId, pos = BagPos},
                    storage_api:add_item_info(ConnPid, [{?storage_bag, NewItem}]),
                    store(refresh, Role),  %% 只给当前进程刷新当前仓库物品
                    {ok, Role#role{bag = Bag#bag{next_id = NextId+1, free_pos = lists:delete(BagPos, FPos), items = [NewItem|Items]}}};
                {false, Reason} -> {false, Reason};
                _ -> {false, ?MSGID(<<"取出失败">>)}
            end
    end.

%% @spec move(ItemId, Pos, Role) -> ok
%% ItemId = Pos = integer()
%% Role = #role{}
%% @doc 仓库整理
move(ItemId, Pos, #role{guild = #role_guild{gid = Gid, srv_id = Gsrvid, donation = DO}, link = #link{conn_pid = ConnPid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, move_async, [ItemId, Pos, DO, ConnPid]}).

%% @spec tidy(Role) -> ok
%% Role = #role{}
%% @doc 仓库自动整理
tidy(#role{guild = #role_guild{gid = Gid, srv_id = Gsrvid}, link = #link{conn_pid = ConnPid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, tidy_async, [ConnPid]}).

%% @spec discard(ItemId, Role) -> ok
%% 删除仓库物品
discard(ItemId, #role{id = {Rid, _}, name = Rname, guild = #role_guild{gid = Gid, srv_id = Gsrvid, donation = Do}, link = #link{conn_pid = ConnPid}}) ->
    guild:apply(async, {Gid, Gsrvid}, {?MODULE, discard_async, [ItemId, Rid, Rname, Do, ConnPid]}).

%% 刷新仓库物品
store(refresh, #role{link = #link{conn_pid = ConnPid}, guild = #role_guild{gid = Gid, srv_id = Gsrvid}}) ->
    case guild_mgr:lookup(by_id, {Gid, Gsrvid}) of
        #guild{store = #guild_store{items = Items}} ->
            sys_conn:pack_send(ConnPid, 12733, {Items});
        _ ->
            ignore
    end.

%%------------------------------------------------------------------------------
%% 帮会进程回调函数
%%------------------------------------------------------------------------------
%% @spec in_store_sync(Guild, ToPos, Item, Rid, Rname) -> {ok, {false, Reason}} | {ok, true, NewGuild} | {ok, {true, Rem}, NewGuild}
%% Guild = NewGuild = #guild{}
%% Reason = binary()
%% Rem = integer()
%% @doc 将物品放入帮会仓库
in_store_sync(#guild{store = #guild_store{volume = Vol}}, ToPos, _, _, _) when ToPos > Vol ->
    {ok, {false, ?L(<<"目标格子没有开通">>)}};
in_store_sync(State = #guild{name = Name, store_log = StoreLog, store = Store = #guild_store{next_id = ID, free_pos = FPos, items = Items}, members = Mems}, 
    ToPos, Item = #item{base_id = BaseId, quantity = Num}, Rid, Rname
) ->
    case item_data:get(BaseId) of
        {ok, #item_base{name = ItemName, overlap = OLap, quality = Quality}} ->
            case find(item, ToPos, State) of
                false ->
                    ?ERR("帮会【~s】仓库数据异常, 目标格子 ~w, 自由格子 ~w, 仓库情况 ~w", [Name, ToPos, FPos, [{_I, _P} ||#item{id = _I, pos = _P} <- Items]]),
                    {ok, {false, <<>>}};
                null ->                             %% 目标位置空
                    NewLog = update_store_log(in, Rid, Rname, ItemName, Quality, Num, StoreLog), 
                    NewStore = Store#guild_store{next_id = ID+1, free_pos = lists:delete(ToPos, FPos), items = [Item#item{id = ID, pos = ToPos}|Items]},
                    guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 往帮会仓库放入【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, Num])),
                    {ok, true, State#guild{store_log = NewLog, store = NewStore}};
                Itemed = #item{base_id = GBaseId, quantity = GNum} when BaseId =:= GBaseId, OLap =/=1  ->
                    case (Num + GNum) > OLap of
                        false ->                    %% 不超过堆叠
                            NewLog = update_store_log(in, Rid, Rname, ItemName, Quality, Num, StoreLog),
                            NewStore = Store#guild_store{items = lists:keyreplace(ToPos, #item.pos, Items, Itemed#item{quantity = Num + GNum})},
                            guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 往帮会仓库放入【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, Num])),
                            {ok, true, State#guild{store_log = NewLog, store = NewStore}};
                        true when GNum =/= OLap ->  %% 超过堆叠
                            NewLog = update_store_log(in, Rid, Rname, ItemName, Quality, OLap - GNum, StoreLog), 
                            NewStore = Store#guild_store{items = lists:keyreplace(ToPos, #item.pos, Items, Itemed#item{quantity = OLap})},
                            guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 往帮会仓库放入【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, OLap - GNum])),
                            {ok, {true, Num + GNum - OLap}, State#guild{store_log = NewLog, store = NewStore}};
                        _ ->                        %% 已满
                            {ok, {false, ?L(<<"放入失败，格子已满">>)}}
                    end;
                _ ->                                %% 有其他物品
                    {ok, {false, ?L(<<"放入失败，格子里有其他物品">>)}}
            end;
        {false, Reason} ->
            {ok, {false, Reason}}
    end.

out_store_sync(#guild{permission = {_, _, Limit}}, _ItemId, _Rid, _Name, Donation) when Donation < Limit ->
    {ok, {false, ?L(<<"帮会累积贡献低于帮主设定限制值">>)}};
out_store_sync(State = #guild{store_log = Log, store = Store = #guild_store{free_pos = FPos, items = Items}, members = Mems}, ItemId, Rid, Rname, _) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false ->
            {ok, {false, ?L(<<"未选中任何物品">>)}};
        Item = #item{base_id = BaseId, quantity = Num, pos = Pos} ->
            case item_data:get(BaseId) of
                {ok, #item_base{name = ItemName, quality = Quality}} ->
                    NewLog = update_store_log(out, Rid, Rname, ItemName, Quality, Num, Log), 
                    NewStore = Store#guild_store{free_pos = [Pos|FPos], items = lists:keydelete(ItemId, #item.id, Items)},
                    guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 从帮会仓库取出【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, Num])),
                    {ok, {true, Item}, State#guild{store_log = NewLog, store = NewStore}};
                {false, Reason} ->
                    {ok, {false, Reason}}
            end
    end.

%% 取出物品
out_store_sync(#guild{permission = {_, _, Limit}}, _, _, _, _, _, Donation) when Donation < Limit ->
    {ok, {false, ?L(<<"帮会累积贡献低于帮主设定限制值">>)}};
out_store_sync(State = #guild{store_log = Log, store = Store = #guild_store{free_pos = FPos, items = Items}, members = Mems}, ItemId, Rid, Rname, BaseId, Num, _) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false ->
            {ok, {false, ?L(<<"未选中任何物品">>)}};
        Item = #item{base_id = GBaseId, quantity = GNum, pos = Pos} when GBaseId =:= BaseId ->
            case item_data:get(BaseId) of
                {ok, #item_base{name = ItemName, overlap = OLap, quality = Quality}} ->
                    case GNum > OLap - Num of
                        false ->
                            NewLog = update_store_log(out, Rid, Rname, ItemName, Quality, GNum, Log), 
                            NewStore = Store#guild_store{free_pos = [Pos|FPos], items = lists:keydelete(ItemId, #item.id, Items)},
                            guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 从帮会仓库取出【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, GNum])),
                            {ok, {true, GNum+Num}, State#guild{store_log = NewLog, store = NewStore}};
                        true ->
                            NewLog = update_store_log(out, Rid, Rname, ItemName, Quality, OLap - Num, Log),
                            NewStore = Store#guild_store{items = lists:keyreplace(ItemId, #item.id, Items, Item#item{quantity = GNum+Num-OLap})},
                            guild:guild_chat(Mems, util:fbin(?L(<<"【{str, ~s, #FFFF66}】 从帮会仓库取出【{str, ~sx~w, #FFFF66}】">>), [Rname, ItemName, OLap - Num])),
                            {ok, {true, OLap}, State#guild{store_log = NewLog, store = NewStore}}
                    end;
                {false, Reason} ->
                    {ok, {false, Reason}}
            end;
        _ ->
            {ok, {false, ?L(<<"放入失败，格子里有其他物品">>)}}
    end.

%% 仓库内移动物品
move_async(#guild{permission = {_, _, Limit}}, ItemId, _EndPos, Donation, ConnPid) when Donation < Limit ->
    sys_conn:pack_send(ConnPid, 12729, {?false, ?L(<<"帮会累积贡献低于帮主设定限制值">>), ItemId}),
    {ok};
move_async(#guild{store = #guild_store{volume = Vol}}, ItemId, EndPos, _Donation, ConnPid) when EndPos =< 0 orelse EndPos > Vol ->
    sys_conn:pack_send(ConnPid, 12729, {?false, <<>>, ItemId}),
    {ok};
move_async(State = #guild{store = Store = #guild_store{free_pos = FPos, items = Items}}, ItemId, EndPos, _, ConnPid) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false -> 
            sys_conn:pack_send(ConnPid, 12729, {?false, ?L(<<"未选中任何物品">>), ItemId}),
            {ok};
        Item1 = #item{base_id = Bid1, quantity = Num1, pos = BegPos} when BegPos =/= EndPos ->
            case lists:keyfind(EndPos, #item.pos, Items) of
                false ->
                    NewItems = lists:keyreplace(BegPos, #item.pos, Items, Item1#item{pos = EndPos}),
                    NewStore = Store#guild_store{free_pos = [BegPos|lists:delete(EndPos, FPos)], items = NewItems},
                    sys_conn:pack_send(ConnPid, 12729, {?true, ?L(<<"整理成功">>), ItemId}),
                    sys_conn:pack_send(ConnPid, 12733, {NewItems}),
                    {ok, State#guild{store = NewStore}};
                Item2 = #item{base_id = Bid2} when Bid1 =/= Bid2 ->
                    %% 分别用POS，itemid来替代，若全用同一个会发送覆盖
                    NewItems = lists:keyreplace(ItemId, #item.id, lists:keyreplace(EndPos, #item.pos, Items, Item2#item{pos = BegPos}), Item1#item{pos = EndPos}),
                    sys_conn:pack_send(ConnPid, 12729, {?true, ?L(<<"整理成功">>), ItemId}),
                    sys_conn:pack_send(ConnPid, 12733, {NewItems}),
                    {ok, State#guild{store = Store#guild_store{items = NewItems}}};
                Item2 = #item{base_id = Bid2, quantity = Num2} when Bid1 =:= Bid2 ->
                    case item_data:get(Bid1) of
                        {ok, #item_base{overlap = OLap}} ->
                            case (Num1 + Num2) > OLap of
                                false ->
                                    NewItems = lists:keydelete(BegPos, #item.pos, lists:keyreplace(EndPos, #item.pos, Items, Item2#item{quantity = Num1 + Num2})),
                                    sys_conn:pack_send(ConnPid, 12729, {?true, ?L(<<"整理成功">>), ItemId}),
                                    sys_conn:pack_send(ConnPid, 12733, {NewItems}),
                                    {ok, State#guild{store = Store#guild_store{free_pos = [BegPos | FPos], items = NewItems}}};
                                true ->
                                    NewItems = lists:keyreplace(BegPos, #item.pos, lists:keyreplace(EndPos, #item.pos, Items, Item2#item{quantity = OLap}), 
                                                Item1#item{quantity = Num1 + Num2 - OLap}),
                                    sys_conn:pack_send(ConnPid, 12729, {?true, ?L(<<"整理成功">>), ItemId}),
                                    sys_conn:pack_send(ConnPid, 12733, {NewItems}),
                                    {ok, State#guild{store = Store#guild_store{items = NewItems}}}
                            end;
                        {false, Reason} -> 
                            sys_conn:pack_send(ConnPid, 12729, {?false, Reason, ItemId}),
                            {ok}
                    end
            end;
        _ -> 
            {ok}
    end.

%% 删除物品
discard_async(#guild{permission = {_, _, Limit}}, ItemId, _Rid, _Rname, Donation, ConnPid) when Donation < Limit ->
    sys_conn:pack_send(ConnPid, 12731, {?false, ?L(<<"帮会累积贡献低于帮主设定限制值">>), ItemId}),
    {ok};
discard_async(State = #guild{store_log = Log, store = Store = #guild_store{free_pos = FPos, items = Items}}, ItemId, Rid, Rname, _, ConnPid) ->
    case lists:keyfind(ItemId, #item.id, Items) of
        false ->
            sys_conn:pack_send(ConnPid, 12731, {?false, ?L(<<"未选中任何物品">>), ItemId}),
            {ok};
        #item{pos = Pos, base_id = BaseID, quantity = Num} ->
            case item_data:get(BaseID) of
                {ok, #item_base{name = ItemName, quality = Quality}} ->
                    NewLog = update_store_log(del, Rid, Rname, ItemName, Quality, Num, Log),
                    NewItems = lists:keydelete(ItemId, #item.id, Items),
                    NewStore = Store#guild_store{free_pos = lists:usort([Pos|FPos]), items = NewItems},
                    sys_conn:pack_send(ConnPid, 12731, {?true, ?L(<<"删除物品成功">>), ItemId}),
                    sys_conn:pack_send(ConnPid, 12733, {NewItems}),
                    {ok, State#guild{store = NewStore, store_log = NewLog}};
                {false, Reason} ->
                    sys_conn:pack_send(ConnPid, 12731, {?false, Reason, ItemId}),
                    {ok}
            end
    end.

%% 整理背包
tidy_async(State = #guild{store = Store = #guild_store{items = Items}}, ConnPid) ->
    case cd(cd_tidy_store) of
        true ->
            case Items =:= [] of
                true -> 
                    {ok};
                false ->
                    {ok, NewStore} = storage:sort(Store),
                    sys_conn:pack_send(ConnPid, 12733, {NewStore#guild_store.items}),
                    {ok, State#guild{store = NewStore}}
            end;
        false ->
            {ok}
    end.

%% 查找一件物品
find(item, Pos, #guild{store = #guild_store{free_pos = FreePos, items = Items}}) ->
    case lists:member(Pos, FreePos) of
        false ->
            lists:keyfind(Pos, #item.pos, Items);
        true ->
            null
    end.

%% 更新帮会仓库操作记录
update_store_log(in, Rid, Rname, ItemName, Quality, Num, Log) ->
    [#store_log{id = Rid, name = Rname, item = ItemName, type = 0, quality = Quality, num = Num, date = util:unixtime()} |Log];
update_store_log(del, Rid, Rname, ItemName, Quality, Num, Log) ->
    [#store_log{id = Rid, name = Rname, item = ItemName, type = 2, quality = Quality, num = Num, date = util:unixtime()} |Log];
update_store_log(out, Rid, Rname, ItemName, Quality, Num, Log) ->
    [#store_log{id = Rid, name = Rname, item = ItemName, type = 1, quality = Quality, num = Num, date = util:unixtime()} |Log].

%% cd 冷却
cd(cd_tidy_store) ->
    case get(cd_tidy_store) of
        Time when is_integer(Time) ->
            case (util:unixtime() - Time) > 5 of
                true ->
                    put(cd_tidy_store, util:unixtime()),
                    true;
                _ ->
                    false
            end;
        _ ->
            put(cd_tidy_store, util:unixtime()),
            true
    end.
