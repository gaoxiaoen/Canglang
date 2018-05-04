%%----------------------------------------------------
%% cli_handle
%% 
%% @author Qingxuan
%%----------------------------------------------------
-module(cli_handle).
-compile(export_all).
-include("cli.hrl").

%% ----------------------------------------------------------

on_connect(Client = #client{acc = Acc, srv_id = SrvId, platform = Platform}) ->
    timer:sleep(500),
    ok = cli:send(Client, 1010, {Platform, Acc, SrvId, util:unixtime(), <<>>, <<>>}),
    erlang:send_after(20000, self(), heartbeat),
    Client.

%% ----------------------------------------------------------

on_msg(heartbeat, Client) ->
    cli:send(Client, 1099, {}),
    Client;

on_msg(move, Client) ->
    case get(move_paths) of
        [Fun] ->
            Fun(Client);
        [{X, Y}|T] ->
            cli:send(Client, 10115, {X, Y, 0}), %% 移动
            put(move_paths, T),
            erlang:send_after(1000, self(), move)
    end,
    Client;

on_msg(_Msg, Client) ->
    Client.

%% ----------------------------------------------------------

%% 登录返回
recv(1010, _Bin = {Status, MsgId, _Time, _Code, _Gm}, Client = #client{srv_id = SrvId}) ->
    ?I("1010 ~p ~p", [Status, MsgId]),
    case Status of
        1 ->
            {1100, {SrvId}, Client};
        _ ->
            stop
    end;

%% 心跳
recv(1099, _, Client) ->
    Client;

%% 返回角色列表
recv(1100, {_Msg, _Ck0, _Ck1, _Xz0, _Xz1, _Qs0, _Qs1, RoleL}, Client = #client{srv_id = SrvId}) ->
    case RoleL of
        [] -> 
            Sex = util:rand(0, 1),
            CareerIndex = util:rand(1, 3),
            Career = lists:nth(CareerIndex, [2, 3, 5]),
            {1105, {Client#client.acc, Sex, Career, SrvId, <<>>}, Client};  %% 创建角色
        [[RoleId, _SrvId, _Status, _Name, _Sex, _Lev, _Career]|_] ->
            {1120, {RoleId, SrvId}, Client} %% 登录第一个角色
    end;

%% 创建角色返回值
recv(1105, {RoleId, _MsgId}, Client = #client{srv_id = SrvId}) ->
    case RoleId > 0 of
        true ->
            {1120, {RoleId, SrvId}, Client#client{role_id = RoleId}}; %% 登录角色
        _ ->
            stop
    end;

%% 登录角色返回值
recv(1120, {Code, _MsgId}, Client) ->
    case Code of
        1 -> 
            {10000, {}, Client}; %% 获取角色信息
        _ ->
            ?D("~p : ~p", [Code, i18n:text(_MsgId)]),
            stop  %% 创建失败
    end;

%% 获取角色信息
recv(10000, _Data, Client) ->
    {10100, {0, 0}, Client}; %% 进入场景

%% 服务端通知地图切换
recv(10110, {Map, X, Y}, Client) ->
    ?D("enter map: ~p", [Map]),
    {10111, {}, Client#client{map = Map, x = X, y = Y}}; %% 请求场景元素

%% 返回场景元素
recv(10111, {_Elems, Npcs, _Roles}, Client) ->
    Npcs2 = [ #cli_map_npc{id = Id, base_id = BaseId, x = X, y = Y} || [Id, _Status, BaseId, _MoveSpeed, X, Y] <- Npcs ],
    Npcs3 = lists:keysort(#cli_map_npc.x, Npcs2),
    Client#client{npcs = Npcs3};

%% 提示
recv(Cmd, {MsgId}, Client) when Cmd =:= 11101 orelse Cmd =:= 11102 orelse Cmd =:= 11103 ->
    ?I("收到通知：~ts", [i18n:text(MsgId)]),
    Client;

%% 提示
recv(Cmd, {Msg}, Client) when Cmd =:= 11111 orelse Cmd =:= 11112 orelse Cmd =:= 11113 ->
    ?I("收到通知：~ts", [Msg]),
    Client;

recv(_Cmd, _Data, Client) ->
    ?D("recv unknown: ~p ~p", [_Cmd, _Data]),
    Client.


%% ------
move(Paths, FinishFun) ->
    put(move_paths, Paths ++ [FinishFun]),
    self() ! move.

