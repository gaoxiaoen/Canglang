%%----------------------------------------------------
%% 角色分组管理，提供分组广播和分组查询的接口
%% 
%% @author yeahoo2000@gmail.com
%% @end
%%----------------------------------------------------
-module(role_group).
-behaviour(gen_server).
-export([
        start_link/0
        ,join/2
        ,join/3
        ,leave/2
        ,leave/4
        ,broadcast/2
        ,local_broadcast/2
        ,pack_send/3
        ,pack_cast/3
        ,pack_cast/4
        ,pack_cast_local/4
        ,apply/2
        ,local_apply/2
        ,check_shield/2
        ,cancel_shield/2
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("common.hrl").
-include("node.hrl").
-include("role.hrl").
-include("link.hrl").
-include("role_online.hrl").
-include("setting.hrl").
-record(state, {}).

%% ----------------------------------------------------
%% 对外接口
%% ----------------------------------------------------

%% @spec join(all, Role) -> ok
%% Role = #role{}
%% @doc 加入所有分组
join(all, #role{pid = RolePid, id = RoleId, account = Account, name = RoleName, status = Status, lev = Lev, platform = Platform, setting = Setting, link = #link{conn_pid = ConnPid}}) ->
    RoleOnline = #role_online{
        id = RoleId
        ,pid = RolePid
        ,name = RoleName
        ,account = Account
        ,status = Status
        ,lev = Lev
        ,platform = Platform
    },
    ets:insert(role_online, RoleOnline),
    join(world, RolePid, ConnPid),
    join(setting,RolePid, ConnPid, Setting),
    ok.

%% @spec join(world, RolePid, ConnPid) -> ok
%% RolePid = pid()
%% ConnPid = pid()
%% @doc 加入世界组
join(world, RolePid, ConnPid)
when is_pid(RolePid) andalso is_pid(ConnPid)->
    ets:insert(role_group_world, {RolePid, ConnPid}).

%% @spec join(setting, RolePid, ConnPid, Setting) -> ok
%% RolePid = pid()
%% ConnPid = pid()
%% Setting = #setting()
%% @doc 玩家设置相关分组
% -define(shield_private_chat, 1).
% -define(shield_world_chat, 2).
% -define(shield_guild_chat, 3).
% -define(shield_role, 4).
% -define(shield_pet, 5).
% -define(shield_medal, 6).
join(setting, RolePid, ConnPid, #setting{shield = Shield}) 
when is_pid(RolePid) andalso is_pid(ConnPid)->
    check_shield({RolePid, ConnPid},Shield).

%% @spec leave(all, RolePid) -> ok
%% RolePid = pid()
%% @doc 离开所有分组
leave(all, RolePid) when is_pid(RolePid) ->
    case ets:match_object(role_online, #role_online{pid = RolePid, _ = '_'}) of
        [#role_online{name = Name}] ->
            ets:delete(role_online, Name),
            leave(world, RolePid),
            leave(setting,RolePid);
        _ -> ignore
    end,
    ok;

%% @spec leave(all, Role) -> ok
%% Role = #role{}
%% @doc 离开所有分组
leave(all, #role{pid = Pid, name = Name}) ->
    ets:delete(role_online, Name),
    leave(world, Pid),
    leave(setting,Pid),
    ok;

%% @spec leave(world, RolePid) -> ok
%% RolePid = pid()
%% @doc 离开世界组
leave(world, RolePid) ->
    ets:delete(role_group_world, RolePid);

%% @spec leave(name, RoleName) -> ok
%% RoleName = binary()
%% @doc 从名称索引组中删除角色
leave(name, RoleName) ->
    ets:delete(role_idx_name, RoleName);

%% @spec leave(setting, RolePid) -> ok
%% RoleName = binary()
%% @doc 从名称索引组中删除角色
leave(setting, RolePid) ->
    ets:delete(shield_private_chat, RolePid),
    ets:delete(shield_world_chat, RolePid),
    ets:delete(shield_guild_chat, RolePid),
    ets:delete(shield_role, RolePid),
    ets:delete(shield_pet, RolePid),
    ets:delete(shield_medal, RolePid).

%% @spec leave(map, MapId, RolePid, ConnPid) -> ok
%% MapId= integer()
%% RolePid = pid()
%% ConnPid = pid()
%% @doc 离开地图组
leave(map, MapId, RolePid, ConnPid) ->
    ets:delete_object(role_group_map, {MapId, RolePid, ConnPid}).

%% @spec pack_send(Rid, Cmd, Data) -> ok | {error, not_found}
%% Rid = integer()
%% SrvId = string()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并发送消息
pack_send({Rid, SrvId}, Cmd, Data) when is_integer(Rid) ->
%%     ?DEBUG("pack_send:Cmd:~w, Data~w", [Cmd, Data]),
    case global:whereis_name({role, Rid, SrvId}) of
        undefined -> ok;
        Pid -> role:pack_send(Pid, Cmd, Data)
    end;

%% @spec pack_send(RoleName, Cmd, Data) -> ok | {error, not_found}
%% RoleId = integer()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并发送消息(如果角色不在当前节点，则会到所有节点中查找)
pack_send(RoleName, Cmd, Data) when is_binary(RoleName) ->
%%     ?DEBUG("pack_send:Cmd:~w, Data~w", [Cmd, Data]),
    case local_pack_send(RoleName, Cmd, Data) of
        {error, not_found} -> %% 到其它节点继续查找
            %% do_send_to_role(sys_node_mgr:list(exclude), RoleName, Cmd, Data);
            do_send_to_role([], RoleName, Cmd, Data);
        _ ->
            ok
    end.

%% @spec local_pack_send(RoleName, Cmd, Data) -> ok | {error, not_found}
%% RoleName = binary()
%% Cmd = integer()
%% Data = tuple()
%% @doc 在本地节点查找角色并打包发送指令
local_pack_send(RoleName, Cmd, Data) when is_binary(RoleName) ->
    case ets:lookup(role_online, RoleName) of
        [#role_online{pid = Pid}] -> role:pack_send(Pid, Cmd, Data);
        _ -> {error, not_found}
    end.


%% @spec pack_cast(world, Cmd, Data) -> ok
%% Cmd = integer()
%% Data = tuple()
%% @doc 世界聊天专用，打包并广播到世界组(所有玩家)
pack_cast(world_chat, 10910, Data) ->
    case mapping:module(game_server, 10910) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case Proto:pack(srv, 10910, Data) of
                {ok, Bin} ->
                    Data1 = ets:tab2list(shield_world_chat),
                    ?DEBUG("------~w~n",[Data1]),
                    ets:delete_all_objects(shield_temp),
                    ets:insert(shield_temp,Data1),
                    broadcast(world, Bin);
                {error, Reason} ->
                    ?ELOG("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ELOG("模块影射失败:~p", [Code])
    end;

%% @spec pack_cast(world, Cmd, Data) -> ok
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并广播到世界组(所有玩家)
pack_cast(world, Cmd, Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case Proto:pack(srv, Cmd, Data) of
                {ok, Bin} ->
                    broadcast(world, Bin);
                {error, Reason} ->
                    ?ELOG("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ELOG("模块影射失败:~p", [Code])
    end.

%% @spec pack_cast(To, Id, Cmd, Data) -> ok
%% To = map | world
%% Id = integer()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并广播到指定分组
pack_cast(To, Id, Cmd, Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case Proto:pack(srv, Cmd, Data) of
                {ok, Bin} ->
                    broadcast(To, {Id, Bin});
                {error, Reason} ->
                    ?ELOG("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ELOG("模块影射失败:~p", [Code])
    end.
%% @spec pack_cast_local(To, Id, Cmd, Data) -> ok
%% To = map | world
%% Id = integer()
%% Cmd = integer()
%% Data = tuple()
%% @doc 打包并广播到本地节点的指定分组
pack_cast_local(To, Id, Cmd, Data) ->
    case mapping:module(game_server, Cmd) of
        {ok, _Auth, _Caller, Proto, _ModName} ->
            case Proto:pack(srv, Cmd, Data) of
                {ok, Bin} ->
                    local_broadcast(To, {Id, Bin});
                {error, Reason} ->
                    ?ELOG("打包数据出错[Reason:~w]", [Reason])
            end;
        {error, Code} ->
            ?ELOG("模块影射失败:~p", [Code])
    end.

%% @spec broadcast(world, Bin) -> ok
%% Bin = binary()
%% @doc 广播数据到所有节点的所有玩家
broadcast(world, Bin) ->
    %% do_broadcast_to_nodes(sys_node_mgr:list(all), [world, Bin]).
    do_broadcast_to_nodes([#node{name = node()}], [world, Bin]).

%% @spec local_broadcast(Type, Bin) -> ok
%% Bin = binary()
%% @doc 广播数据到当前节点的世界组
local_broadcast(world, Bin) ->
    NData = ets:tab2list(shield_temp),
    % ?DEBUG("----~w~n",[NData]),
    do_broadcast(ets:tab2list(role_group_world) -- NData, Bin).

%% @spec apply(all, Mfa) -> ok
%% Mfa = mfa()
%% @doc 对所有节点的所有角色执行MFA
apply(all, Mfa)->
    %% do_apply_to_nodes(sys_node_mgr:list(all), [all, Mfa]).
    do_apply_to_nodes([#node{name = node()}], [all, Mfa]).

%% 对当前节点的所有角色执行MFA
%% @spec local_apply(all, Mfa) -> ok
%% Mfa = mfa()
local_apply(all, Mfa)->
    do_apply(ets:tab2list(role_group_world), Mfa).


%% 根据屏蔽的类型进项分组
check_shield({_RolePid, _ConnPid}, []) -> ok;
check_shield({RolePid, ConnPid}, [Type|Rest]) ->
    ets:insert(type_to_table(Type), {RolePid, ConnPid}),
    check_shield({RolePid, ConnPid}, Rest).


%%取消屏蔽，从分组中删除
cancel_shield(_RolePid, []) -> ok;
cancel_shield(RolePid, [Type|Rest]) ->
    ets:delete(type_to_table(Type),RolePid),
    cancel_shield(RolePid, Rest).


%% @spec start_link() -> ok
%% @doc 启动角色分组管理器
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ----------------------------------------------------
%% 内部调用处理
%% ----------------------------------------------------

init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    %% 共享的角色在线信息
    ets:new(role_online, [set, named_table, public, {keypos, #role_online.name}]),
    %% 世界组
    ets:new(role_group_world, [set, public, named_table]),
    %% 屏蔽私聊
    ets:new(shield_private_chat,[set, public, named_table]),
    %% 屏蔽世界聊天
    ets:new(shield_world_chat,[set, public, named_table]),
    %% 屏蔽帮会聊天
    ets:new(shield_guild_chat,[set, public, named_table]),
    %% 屏蔽玩家
    ets:new(shield_role,[set, public, named_table]),
    %% 屏蔽宠物
    ets:new(shield_pet,[set, public, named_table]),
    %% 屏蔽勋章
    ets:new(shield_medal,[set, public, named_table]),
    %% 屏蔽勋章
    ets:new(shield_temp,[set, public, named_table]),

    State = #state{},
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ----------------------------------------------------
%% 私有函数
%% ----------------------------------------------------

do_broadcast([], _Bin) -> 
    ets:delete_all_objects(shield_temp),
    ok;
do_broadcast([{_RolePid, ConnPid} | T], Bin) ->
    ConnPid ! {send_data, Bin},
    do_broadcast(T, Bin).

do_broadcast_to_nodes([], _Args) -> ok;
do_broadcast_to_nodes([H | T], Args) ->
    spawn(H#node.name, ?MODULE, local_broadcast, Args),
    do_broadcast_to_nodes(T, Args).

do_apply([], _Mfa) -> ok;
do_apply([{RolePid, _SenderPid} | T], Mfa)->
    role:apply(async, RolePid, Mfa),
    do_apply(T, Mfa).

do_apply_to_nodes([], _Args) -> ok;
do_apply_to_nodes([H | T], Args) ->
    spawn(H#node.name, ?MODULE, local_apply, Args),
    do_apply_to_nodes(T, Args).

do_send_to_role(_, 0, _Cmd, _Data) -> {error, not_found};
do_send_to_role([], _Id, _Cmd, _Data) -> {error, not_found};
do_send_to_role([H | T], Id, Cmd, Data) ->
    case rpc:call(H#node.name, ?MODULE, local_pack_send, [Id, Cmd, Data]) of
        ok -> ok;
        _ -> do_send_to_role(T, Id, Cmd, Data)
    end.



type_to_table(?shield_private_chat) ->shield_private_chat;
type_to_table(?shield_world_chat) ->shield_world_chat;
type_to_table(?shield_guild_chat) ->shield_guild_chat;
type_to_table(?shield_role) ->shield_role;
type_to_table(?shield_pet) ->shield_pet;
type_to_table(?shield_medal) ->shield_medal;
type_to_table(_) ->shield_temp.