%%----------------------------------------------------
%% 交易RPC处理
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(exchange_rpc).
-export([handle/3]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("item.hrl").
%%

%% 屏蔽死亡状态
handle(_, _, #role{status = ?status_die}) -> {ok};

%% 过滤无法发起交易的状态
handle(11200, {Rid, SrvId}, #role{id = {RidSelf, SrvIdSelf}, status = Status, exchange_pid = ExPid, event = Event})
when Status =:= ?status_fight %% 战斗中
orelse (Rid =:= RidSelf andalso SrvId =:= SrvIdSelf) %% 跟自已交易
orelse is_pid(ExPid) %% 已经在交易中
orelse Event =:= ?event_arena_prepare
orelse Event =:= ?event_arena_match
orelse Event =:= ?event_top_fight_match
orelse Event =:= ?event_top_fight_prepare
->
    {reply, {0, ?L(<<"当前状态下无法进行交易操作">>)}};

%% 发起交易请求
handle(11200, {Rid, SrvId}, #role{id = {RidSelf, SrvIdSelf}, name = Name}) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.link) of
        {ok, _Node, #link{conn_pid = ConnPid}} ->
            sys_conn:pack_send(ConnPid, 11201, {RidSelf, SrvIdSelf, Name}), %% 发送交易请求
            {reply, {1, ?MSGID(<<"交易请求已经发送，请耐心等待对方回应">>)}};
        _ ->
            {reply, {0, ?MSGID(<<"对方目前不在线，发起交易请求失败">>)}}
    end;

%% 过滤无法接受交易的状态
handle(11205, {Rid, SrvId}, #role{id = {RidSelf, SrvIdSelf}, status = Status, exchange_pid = ExPid})
when Status =:= ?status_fight %% 战斗中
orelse (Rid =:= RidSelf andalso SrvId =:= SrvIdSelf) %% 跟自已交易
orelse is_pid(ExPid) %% 已经在交易中
->
    {reply, {0, ?MSGID(<<"当前状态下无法进行交易操作">>)}};

%% 接受交易请求
handle(11205, {Rid, SrvId}, Role = #role{pid = RolePid, id = {RidSelf, SrvIdSelf}, name = Name}) ->
    case exchange:start({RolePid, RidSelf, SrvIdSelf, Name}, {Rid, SrvId}) of
        {ok, Pid} ->
            {reply, {1, <<>>}, Role#role{exchange_pid = Pid}};
        _ ->
            {reply, {0, ?MSGID(<<"对方在当前状态下无法进行交易操作">>)}}
    end;

%% 拒绝交易请求
handle(11206, {Rid, SrvId}, #role{name = Name}) ->
    case role_api:lookup(by_id, {Rid, SrvId}, #role.link) of
        {ok, _Node, #link{conn_pid = ConnPid}} ->
            sys_conn:pack_send(ConnPid, 11207, {Name}); %% 发送拒绝通知
        _ -> ignore
    end,
    {ok};

%% 更新交易铜数量
handle(11220, {Num}, #role{exchange_pid = ExPid, pid = RolePid})
when is_pid(ExPid) andalso Num >= 0 ->
    exchange:update_coin(ExPid, RolePid, Num),
    {ok};

%%  %% 更新交易晶钻数量
%%  handle(11223, {Num}, #role{exchange_pid = ExPid, pid = RolePid})
%%  when is_pid(ExPid) andalso Num >= 0 ->
%%      exchange:update_gold(ExPid, RolePid, Num),
%%      {ok};

%% 添加物品到交易界面
handle(11221, {ItemId}, Role = #role{exchange_pid = ExPid, pid = RolePid, bag = Bag, link = #link{conn_pid = ConnPid}})
when is_pid(ExPid) ->
    case storage_api:set_item_lock(Bag, ItemId, ?lock_exchange, ConnPid) of
        {ok, NewBag, Item} ->
            exchange:add_item(ExPid, RolePid, Item),
            {ok, Role#role{bag = NewBag}};
        _ ->
            {ok}
    end;

%% 从交易界面移除物品
handle(11222, {ItemId}, Role = #role{exchange_pid = ExPid, pid = RolePid, bag = Bag, link = #link{conn_pid = ConnPid}})
when is_pid(ExPid) ->
    case storage_api:set_item_lock(Bag, ItemId, ?lock_release, ConnPid) of
        {ok, NewBag, _Item} ->
            exchange:del_item(ExPid, RolePid, ItemId),
            {ok, Role#role{bag = NewBag}};
        _ ->
            {ok}
    end;

%% 锁定交易界面
handle(11230, {}, #role{exchange_pid = ExPid, pid = RolePid}) when is_pid(ExPid) ->
    exchange:lock(ExPid, RolePid),
    {ok};

%% 确认交易
handle(11231, Data, Role = #role{exchange_pid = ExPid, pid = RolePid}) when is_pid(ExPid) ->
    case exchange:has_coin(ExPid, RolePid) of
        true ->
            case captcha:check(?MODULE, 11231, Data, Role) of
                false -> ignore;
                {ok, _Data} -> exchange:confirm(ExPid, RolePid)
            end;
        _ -> exchange:confirm(ExPid, RolePid)
    end,
    {ok};

%% 中止交易
handle(11232, {}, #role{exchange_pid = ExPid, pid = RolePid}) when is_pid(ExPid) ->
    exchange:stop(ExPid, RolePid),
    {ok};

%% 容错匹配
handle(_Cmd, _Data, _Role) ->
    {error, unknow_command}.
