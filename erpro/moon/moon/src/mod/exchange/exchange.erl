%%----------------------------------------------------
%% 交易状态处理进程
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(exchange).
-behaviour(gen_server).
-export([
        start/2
        ,stop/2
        ,update_coin/3
%%      ,update_gold/3
        ,add_item/3
        ,del_item/3
        ,lock/2
        ,confirm/2
        ,has_coin/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {
         from_pid           %% 发起方的角色进程ID
        ,from_rid           %% 发起方的角色ID
        ,from_srv_id        %% 发起方的服务器标识
        ,from_name          %% 发起方的服务器标识
        ,from_lock = 0      %% 发起方的服务器标识
        ,from_coin = 0      %% 发起方的交易铜数量
        ,from_gold = 0      %% 发起方的交易晶钻数量
        ,from_items = []    %% 发起方的服务器标识
        ,from_confirm = false %% 发起方是否已经确认交易
        ,to_pid             %% 接受方的角色进程ID
        ,to_rid             %% 接受方的角色ID
        ,to_srv_id          %% 接受方的服务器标识
        ,to_name            %% 接受方的名称
        ,to_lock = 0        %% 接受方的锁定状态
        ,to_coin = 0        %% 接受方的交易铜数量
        ,to_gold = 0        %% 接受方的交易晶钻数量
        ,to_items = []      %% 接受方的交易物品列表
        ,to_confirm = false %% 接受方是否已经确认交易
    }
).
-include("common.hrl").
-include("role.hrl").
-include("item.hrl").
-include("link.hrl").
-include("storage.hrl").
-include("gain.hrl").
%%

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec start(FromRole, ToRole) -> ok
%% FromRole = tuple()
%% ToRole = tuple()
%% @doc 启动一个交易进程
start({ToPid, ToRid, ToSrvId, ToName}, {FromRid, FromSrvId}) ->
    gen_server:start(?MODULE, [{ToPid, ToRid, ToSrvId, ToName}, {FromRid, FromSrvId}], []).

%% @spec stop(ExPid, RolePid) -> ok
%% ExPid = pid()
%% RolePid = pid()
%% @doc 中止交易
stop(ExPid, RolePid) when is_pid(ExPid) ->
    gen_server:cast(ExPid, {stop, RolePid});
stop(_ExPid, _RolePid) ->
    ignore.

%% @spec update_coin(ExPid, RolePid, Num) -> ok
%% ExPid = pid()
%% RolePid = pid()
%% Num = integer()
%% @doc 更新交易铜数量
update_coin(ExPid, RolePid, Num) ->
    gen_server:cast(ExPid, {update_coin, RolePid, Num}).

%% %% @spec update_gold(ExPid, RolePid, Num) -> ok
%% %% ExPid = pid()
%% %% RolePid = pid()
%% %% Num = integer()
%% %% @doc 更新交易铜数量
%% update_gold(ExPid, RolePid, Num) ->
%%     gen_server:cast(ExPid, {update_gold, RolePid, Num}).

%% add_item(ExPid, RolePid, Item) ->
%% ExPid = pid()
%% RolePid = pid()
%% Item = #item{}
%% @doc 添加物品
add_item(ExPid, RolePid, Item) ->
    gen_server:cast(ExPid, {add_item, RolePid, Item}).

%% @spec del_item(ExPid, RolePid, Item) ->
%% ExPid = pid()
%% RolePid = pid()
%% Item = #item{}
%% @doc 删除物品
del_item(ExPid, RolePid, Item) ->
    gen_server:cast(ExPid, {del_item, RolePid, Item}).

%% @spec lock(ExPid, RolePid) ->
%% ExPid = pid()
%% RolePid = pid()
%% @doc 锁定界面
lock(ExPid, RolePid) ->
    gen_server:cast(ExPid, {lock, RolePid}).

%% @spec confirm(ExPid, RolePid) ->
%% ExPid = pid()
%% RolePid = pid()
%% @doc 确认交易
confirm(ExPid, RolePid) ->
    gen_server:cast(ExPid, {confirm, RolePid}).

%% @spec has_coin(ExPid, RolePid) -> true | false
%% @doc 是否包含校验码
has_coin(ExPid, Pid) ->
    gen_server:call(ExPid, {has_coin, Pid}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------

init([{ToPid, ToRid, ToSrvId, ToName}, {FromRid, FromSrvId}]) ->
    case role_api:lookup(by_id, {FromRid, FromSrvId}, [#role.pid, #role.name]) of
        {ok, _Node, [FromPid, FromName]} ->
            %% 修改交易状态
            case role:apply(sync, FromPid, {fun set_exchange_status/2, [self()]}) of
                true ->
                    State = #state{
                        from_pid = FromPid, from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
                        ,to_pid = ToPid, to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
                    },
                    refresh_client(State),
                    {ok, State};
                _ ->
                    {stop, failure}
            end;
        _ ->
            {stop, failure}
    end.

handle_call({has_coin, RolePid}, _From, State = #state{to_pid = RolePid, to_coin = Coin}) ->
    {reply, (Coin > 0), State};
handle_call({has_coin, RolePid}, _From, State = #state{from_pid = RolePid, from_coin = Coin}) ->
    {reply, (Coin > 0), State};
handle_call({has_coin, _RolePid}, _From, State) ->
    {reply, false, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

%% 更新发起方交易铜数量
handle_cast({update_coin, RolePid, Num}, State = #state{from_lock = ?false, from_pid = RolePid}) when Num >= 0 ->
    NewState = State#state{from_coin = Num},
    refresh_client(NewState),
    {noreply, NewState};

%% 更新接受方交易铜数量
handle_cast({update_coin, RolePid, Num}, State = #state{to_lock = ?false, to_pid = RolePid}) when Num >= 0 ->
    NewState = State#state{to_coin = Num},
    refresh_client(NewState),
    {noreply, NewState};

%% 更新发起方交易晶钻数量
handle_cast({update_gold, RolePid, Num}, State = #state{from_lock = ?false, from_pid = RolePid}) when Num >= 0 ->
    NewState = State#state{from_gold = Num},
    refresh_client(NewState),
    {noreply, NewState};

%% 更新接受方交易晶钻数量
handle_cast({update_gold, RolePid, Num}, State = #state{to_lock = ?false, to_pid = RolePid}) when Num >= 0 ->
    NewState = State#state{to_gold = Num},
    refresh_client(NewState),
    {noreply, NewState};

%% 发起方添加物品到交易栏
handle_cast({add_item, RolePid, Item}, State = #state{from_lock = ?false, from_pid = RolePid, from_items = Items}) ->
    NewItems = case lists:keyfind(Item#item.id, #item.id, Items) of
        false -> [Item | Items];
        _ -> lists:keyreplace(Item#item.id, #item.id, Items, Item)
    end,
    NewState = State#state{from_items = NewItems},
    refresh_client(NewState),
    {noreply, NewState};

%% 接受方添加物品到交易栏
handle_cast({add_item, RolePid, Item}, State = #state{to_lock = ?false, to_pid = RolePid, to_items = Items}) ->
    NewItems = case lists:keyfind(Item#item.id, #item.id, Items) of
        false -> [Item | Items];
        _ -> lists:keyreplace(Item#item.id, #item.id, Items, Item)
    end,
    NewState = State#state{to_items = NewItems},
    refresh_client(NewState),
    {noreply, NewState};

%% 处理发起方删除物品
handle_cast({del_item, RolePid, ItemId}, State = #state{from_lock = ?false, from_pid = RolePid, from_items = Items}) ->
    NewState = State#state{from_items = lists:keydelete(ItemId, #item.id, Items)},
    refresh_client(NewState),
    {noreply, NewState};

%% 处理接受方删除物品
handle_cast({del_item, RolePid, ItemId}, State = #state{to_lock = ?false, to_pid = RolePid, to_items = Items}) ->
    NewState = State#state{to_items = lists:keydelete(ItemId, #item.id, Items)},
    refresh_client(NewState),
    {noreply, NewState};

%% 发起方锁定界面
handle_cast({lock, RolePid}, State = #state{from_pid = RolePid}) ->
    NewState = State#state{from_lock = ?true},
    refresh_client(NewState),
    {noreply, NewState};

%% 接受方锁定界面
handle_cast({lock, RolePid}, State = #state{to_pid = RolePid}) ->
    NewState = State#state{to_lock = ?true},
    refresh_client(NewState),
    {noreply, NewState};

%% 发起方确认交易
handle_cast({confirm, RolePid}, State = #state{from_pid = RolePid}) ->
    NewState = State#state{from_confirm = true},
    refresh_client(NewState),
    case NewState#state.from_confirm andalso NewState#state.to_confirm of
        false -> {noreply, NewState}; %% 有一方未确认
        true -> {stop, normal, NewState} %% 双方已确认交易
    end;

%% 接受方确认交易
handle_cast({confirm, RolePid}, State = #state{to_pid = RolePid}) ->
    NewState = State#state{to_confirm = true},
    refresh_client(NewState),
    case NewState#state.from_confirm andalso NewState#state.to_confirm of
        false -> {noreply, NewState}; %% 有一方未确认
        true -> {stop, normal, NewState} %% 双方已确认交易
    end;

%% 发起方中止交易
handle_cast({stop, RolePid}, State = #state{from_pid = RolePid, from_name = Name, to_pid = NoticePid}) ->
    role:pack_send(NoticePid, 11232, {Name}), %% 通知接受方交易已中止
    {stop, normal, State};

%% 接受方中止交易
handle_cast({stop, RolePid}, State = #state{to_pid = RolePid, to_name = Name, from_pid = NoticePid}) ->
    role:pack_send(NoticePid, 11232, {Name}), %% 通知发起方交易已中止
    {stop, normal, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

%% 双方都已经确认交易，处理物品交换
terminate(_Reason, #state{
        from_lock = FromLock, to_lock = ToLock,
        from_confirm = true, to_confirm = true, %% 双方已确认交易
        from_rid = FromId, from_srv_id = FromSrvid, to_rid = ToId, to_srv_id = ToSrvid,
        from_pid = FromPid, from_coin = FromCoin, from_gold = FromGold, from_items = FromItems, from_name = FromName,
        to_pid = ToPid, to_coin = ToCoin, to_gold = ToGold, to_items = ToItems, to_name = ToName
    }
) ->
    case role:apply(sync, FromPid, {fun exchange_item/8, [FromItems, FromCoin, FromGold, ToPid, ToItems, ToCoin, ToGold]}) of
        {ok, NewFromItems, NewToItems} -> %% {发起者新增, 接受者新增}
            log:log(log_exchange, {FromId, FromSrvid, FromName, FromLock, FromCoin, FromGold, FromItems, true, ToId, ToSrvid, ToName, ToLock, ToCoin, ToGold, ToItems, true}),
            log:log(log_item_del, {FromItems, <<"交易">>, <<"背包">>, FromId, FromSrvid, FromName}),
            log:log(log_item_del, {ToItems, <<"交易">>, <<"背包">>, ToId, ToSrvid, ToName}),
            role:apply(async, FromPid, {fun exchange_fresh_client/8, [FromItems, NewFromItems, FromCoin, FromGold, ToCoin, ToGold, ToName]}),
            role:apply(async, ToPid, {fun exchange_fresh_client/8, [ToItems, NewToItems, ToCoin, ToGold, FromCoin, FromGold, FromName]});
        {error, _R} ->
            role:apply(async, FromPid, {fun unlock_item/2, [FromItems]}),
            role:apply(async, ToPid, {fun unlock_item/2, [ToItems]})
    end,
    role:pack_send(FromPid, 11232, {<<>>}),
    role:pack_send(ToPid, 11232, {<<>>}),
    ok;

%% 并不是双方确认交易的情况，交易中止
terminate(_Reason, #state{
        from_rid = FromId, from_srv_id = FromSrvid, to_rid = ToId, to_srv_id = ToSrvid,
        from_coin = FromCoin, from_name = FromName, from_gold = FromGold,
        to_coin = ToCoin, to_name = ToName, to_gold = ToGold,
        from_lock = FromLock, to_lock = ToLock,
        from_confirm = FromCon, to_confirm = ToCon,
        from_pid = FromPid, from_items = FromItems, to_pid = ToPid, to_items = ToItems}) ->
    role:apply(async, FromPid, {fun unlock_item/2, [FromItems]}),
    role:apply(async, ToPid, {fun unlock_item/2, [ToItems]}),
    log:log(log_exchange, {FromId, FromSrvid, FromName, FromLock, FromCoin, FromGold, FromItems, FromCon, ToId, ToSrvid, ToName, ToLock, ToCoin, ToGold, ToItems, ToCon}),%% 记录交易结果
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 私有函数
%%----------------------------------------------------

%% 刷新客户端的交易界面(如果客户端没有打开交易界面则需要自动打开)
refresh_client(_S = #state{
        from_rid = FromRid, from_srv_id = FromSrvId, from_name = FromName
        ,from_pid = FromPid, from_lock = FromLock, from_coin = FromCoin, from_gold = FromGold
        ,from_items = FromItems
        ,to_rid = ToRid, to_srv_id = ToSrvId, to_name = ToName
        ,to_pid = ToPid,  to_lock = ToLock, to_coin = ToCoin, to_gold = ToGold
        ,to_items = ToItems
    }
) ->
    role:pack_send(FromPid, 11210, {
            FromLock, FromRid, FromSrvId, FromName, FromCoin, FromGold, FromItems
            ,ToLock, ToRid, ToSrvId, ToName, ToCoin, ToGold, ToItems
        }
    ),
    role:pack_send(ToPid, 11210, {
            FromLock, FromRid, FromSrvId, FromName, FromCoin, FromGold, FromItems
            ,ToLock, ToRid, ToSrvId, ToName, ToCoin, ToGold, ToItems
        }
    ),
    ok.

%% 修改交易状态回调函数
set_exchange_status(#role{status = ?status_fight}, _Pid) ->
    {ok, false}; %% 战斗中不能交易
set_exchange_status(#role{exchange_pid = ExPid}, _Pid) when is_pid(ExPid) ->
    {ok, false}; %% 不能重复发起交易
set_exchange_status(Role, Pid) ->
    {ok, true, Role#role{exchange_pid = Pid}}.  %% 可以发起交易

%% 交易一方取消,物品解锁
unlock_item(Role = #role{bag = Bag, link = #link{conn_pid = ConnPid}} , Items) ->
    NewBag = unlock_item(Bag, ConnPid, Items),
    %% @todo 需要状态改变通知
    {ok, Role#role{bag = NewBag, exchange_pid = 0}}.
unlock_item(Bag, _ConnPid, []) -> Bag;
unlock_item(Bag, ConnPid, [#item{id = Id} | T]) ->
    case storage_api:set_item_lock(Bag, Id, ?lock_release, ConnPid) of
        {ok, NewBag, _NewItem} ->
            unlock_item(NewBag, ConnPid, T);
        _ ->
            unlock_item(Bag, ConnPid, T)
    end.

send_inform(Pid, DelItems, AddItems, DelCoin, AddCoin, DelGold, AddGold, Name) ->
    Msg = util:fbin(?L(<<"你和{str, ~s, #3ad6f0}交易">>), [Name]),
    DelItemInfo = case DelItems =:= [] of
        true -> Msg;
        false -> util:fbin(?L(<<"~s\n失去了~s">>), [Msg, notice:item2_to_inform(DelItems)])
    end,
    AddItemInfo = case AddItems =:= [] of
        true -> DelItemInfo;
        false -> util:fbin(?L(<<"~s\n获得了~s">>), [DelItemInfo, notice:item2_to_inform(AddItems)])
    end,
    DelCoinInfo = case DelCoin =:= 0 of
        true -> AddItemInfo;
        false -> util:fbin(?L(<<"~s\n失去金币:~w">>),[AddItemInfo, DelCoin])
    end,
    AddCoinInfo = case AddCoin =:= 0 of 
        true -> DelCoinInfo;
        false -> util:fbin(?L(<<"~s\n获得金币:~w">>),[DelCoinInfo, AddCoin])
    end,
    DelGoldInfo = case DelGold =:= 0 of
        true -> AddCoinInfo;
        false -> util:fbin(?L(<<"~s\n失去晶钻:~w">>),[AddCoinInfo, DelGold])
    end,
    AddGoldInfo = case AddGold =:= 0 of
        true -> DelGoldInfo;
        false -> util:fbin(?L(<<"~s\n获得晶钻:~w">>),[DelGoldInfo, AddGold])
    end,
    notice:inform(Pid, AddGoldInfo).

%% 增加物品,删除物品,增加或者减少金币刷新通知
exchange_fresh_client(Role = #role{pid = Pid, link = #link{conn_pid = ConnPid}}, DelItems, AddItems, DelCoin, DelGold, AddCoin, AddGold, Name) ->
    case DelItems =/= [] of
        true -> storage_api:refresh_client_item(del, ConnPid, [{?storage_bag, DelItems}]);
        false -> ignore
    end,
    case AddItems =/= [] of
        true -> storage_api:refresh_client_item(add, ConnPid, [{?storage_bag, AddItems}]);
        false -> ignore
    end,
    role_api:push_assets(Role),
    %% @todo 需要状态改变通知
    send_inform(Pid, DelItems, AddItems, DelCoin, AddCoin, DelGold, AddGold, Name), 
    NewRole = role_listener:get_item(Role#role{exchange_pid = 0}, AddItems),
    NewRole1 = role_listener:coin(NewRole, AddCoin),
    {ok, NewRole1}.

%% 开始进行物品交换
exchange_item(Role, FromItems, FromCoin, FromGold, ToPid, ToItems, ToCoin, ToGold) when is_record(Role, role) ->
    case del_and_add(Role, FromItems, FromCoin, FromGold, ToItems, ToCoin, ToGold) of
        {ok, {NewFromItems}, FromRole} ->
            case role:apply(sync, ToPid, {fun del_and_add/7, [ToItems, ToCoin, ToGold, FromItems, FromCoin, FromGold]}) of
                {NewToItems} ->
                    log:log(log_coin, {<<"交易">>, <<"成功">>, Role, FromRole}),
                    log:log(log_gold, {<<"交易">>, <<"成功">>, Role, FromRole}),
                    {ok, {ok, NewFromItems, NewToItems}, FromRole};
                {error, Reason} -> 
                    put(exchange_rank_flag, false),
                    {ok, {error, Reason}}
            end;
        {ok, {error, Reason}} ->
            {ok, {error, Reason}}
    end.

%% 删除物品和增加物品(回调函数)
del_and_add(Role = #role{}, DItems, DelCoin, DelGold, AItems, AddCoin, AddGold) ->
    DelItems = [{Item#item.id, Item#item.quantity} || Item <- DItems],
    AddItems = [Item#item{status = ?lock_release} ||  Item <- AItems],
    case gain_and_loss(Role, DelCoin, DelGold, AddCoin, AddGold) of
        {false, Reason} ->
            {ok, {error, Reason}};
        {ok, NewRole = #role{bag = Bag}} ->
            case storage:del_item_by_id(Bag, DelItems, false) of
                {ok, NewBag, _, _} ->
                    case storage:add_no_refresh(NewBag, AddItems) of
                        {ok, NowBag, NewItems} ->
                            log:log(log_coin, {<<"交易">>, <<"成功">>, Role, NewRole}),
                            log:log(log_gold, {<<"交易">>, <<"成功">>, Role, NewRole}),
                            put(exchange_rank_flag, true),
                            {ok, {NewItems}, NewRole#role{bag = NowBag}};
                        false -> {ok, {error, ?L(<<"背包已满">>)}}
                    end;
                {false, Reason} ->
                    {ok, {error, Reason}}
            end
    end.

%% 金币扣除和增加
gain_and_loss(Role = #role{}, DelCoin, DelGold, AddCoin, AddGold) ->
    case role_gain:do(#loss{label = coin, val = DelCoin, msg = ?L(<<"金币不足">>)}, Role) of
        {false, #loss{msg = Msg}} -> {false, Msg};
        {ok, NewRole1} ->
            case role_gain:do(#loss{label = gold, val = DelGold, msg = ?L(<<"晶钻不足">>)}, NewRole1) of
                {false, #loss{msg = Msg}} -> {false, Msg};
                {ok, NewRole2} ->
                    case role_gain:do(#gain{label = coin, val = AddCoin, msg = ?L(<<"增加金币失败">>)}, NewRole2) of
                        {false, #gain{msg = Msg}} ->
                            {false, Msg};
                        {ok, NewRole3} ->
                            case role_gain:do(#gain{label = gold, val = AddGold, msg = ?L(<<"增加晶钻失败">>)}, NewRole3) of
                                {false, #gain{msg = Msg}} ->
                                    {false, Msg};
                                {ok, NewRole4} ->
                                    {ok, NewRole4}
                            end
                    end
            end
    end.
