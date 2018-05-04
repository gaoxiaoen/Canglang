%%----------------------------------------------------
%% 测试地图RPC
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_map_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

handle(10100, {0, _Reason}, #tester{name = _Name}) ->
    ?DEBUG("[~s]对地图元素的操作失败:~w", [_Reason]),
    {ok};

handle(10110, {_BaseId, ToX, ToY}, Tester = #tester{name = _Name}) ->
    %% ?DEBUG("[~s]进入了地图[BaseId:~w X:~w Y:~w]", [_Name, _BaseId, ToX, ToY]),
    tester:pack_send(10111, {}),
    {ok, Tester#tester{x = ToX, y = ToY}};

%% 请求地图元素
handle(list, {}, _Tester) ->
    tester:pack_send(10111, {}),
    {ok};

handle(10111, _Data, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到地图数据: ~w", [_Name, _Data]),
    random:seed(erlang:now()),
    Cmd = util:fbin(<<"变身 ~w 7">>, [tester:rand(1, 5)]),
    tester:pack_send(9910, {Cmd}),
    erlang:send_after(tester:rand(300, 1800), self(), {cmd, test_map_rpc, move, {}}),
    {ok};

%% 移动
handle(move, {}, Tester = #tester{x = X, y = Y}) ->
    X1 = X + (tester:rand(1, 600) - 300),
    Y1 = Y + (tester:rand(1, 400) - 200),
    Nx = if
        X1 < 0 -> 0;
        X1 > 7200 -> 7200;
        true -> X1
    end,
    Ny = if
        Y1 < 0 -> 0;
        Y1 > 7200 -> 7200;
        true -> Y1
    end,
    tester:pack_send(10115, {Nx, Ny, 0}),
    erlang:send_after(1000, self(), {cmd, test_map_rpc, move, {}}),
    {ok, Tester#tester{x = Nx, y = Ny}};

handle(10115, _Info, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到角色移动消息: ~p", [_Name, _Info]),
    {ok};

handle(10116, {_RoleList}, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到进入视野的角色列表~p", [_Name, _RoleList]),
    {ok};

handle(10117, _RoleList, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到更新角色列表~p", [_Name, _RoleList]),
    {ok};

handle(10113, _Info, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到了角色进入视野的消息: ~p", [_Name, _Info]),
    {ok};

handle(10114, {_Id, _SrvId}, #tester{name = _Name}) ->
    %% ?DEBUG("[~s]收到角色离开地图的消息[Id:~w SrvId:~s]", [_Name, _Id, _SrvId]),
    {ok};

%% 无视NPC和地图相关的消息
handle(10120, _, _Tester) -> {ok};
handle(10121, _, _Tester) -> {ok};
handle(10122, _, _Tester) -> {ok};
handle(10123, _, _Tester) -> {ok};
handle(10130, _, _Tester) -> {ok};
handle(10131, _, _Tester) -> {ok};
handle(10132, _, _Tester) -> {ok};

handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
