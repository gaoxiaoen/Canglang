%%----------------------------------------------------
%% 测试商城RPC
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_sns_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 客户端发送12000封包到服务端 
handle(test_all, {}, _Tester) ->
    %% 获取好友列表
    tester:pack_send(12100, {}),
    
    %% 添加好友通过ID
    tester:pack_send(12110, {1, 16, <<"test_1">>}),
    
    %% 查看最近联系人或好友的基本信息
    tester:pack_send(12105, {16, <<"test_1">>}),
    
    %% 删除好友
    tester:pack_send(12120, {16, <<"test_1">>}), 
    
    %% 改好友类型
    tester:pack_send(12125, {2, 16, <<"test_1">>}),
    
    %% 添加好友通过名字
    tester:pack_send(12115, {1, <<"bbb">>}),
    {ok};

%% 取得好友列表
handle(send12100, {}, _Tester) ->
    tester:pack_send(12100, {});

handle(12100, _Data, _Tester) ->
    ?DEBUG("收到好友列表数据[Data:~p]", [_Data]),
    {ok};

%% 取得删除好友数据
handle(12120, _Data, _Tester) ->
    ?DEBUG("收到好友列表数据[Data:~p]", [_Data]),
    {ok};

%% 取得删除好友数据
 handle(12125, {_Ret, _Msg, _Type, _Id, _Srv}, _Tester) ->
     ?DEBUG("收到好友更换类型[Ret:~w, Msg:~s,Type:~w, Id:~w, Srv:~s]", [_Ret, _Msg, _Type, _Id, _Srv]),
    {ok};

handle(send12110, {FrId}, _Tester) ->
    tester:pack_send(12110, {0, FrId, <<"test_1">>});

handle(send12130, {FrId}, _Tester) ->
    tester:pack_send(12130, {1, FrId, <<"test_1">>});

%% 取得添加好友数据
 handle(12110, {_Ret, _Msg, _Id, _Srv, _Type}, _Tester) ->
     ?DEBUG("收到好友更换类型[Ret:~w, Msg:~s, Id:~w, Srv:~s, Type:~w]", [_Ret, _Msg,  _Id, _Srv, _Type]),
    {ok};

%% 取得名字添加好友数据
 handle(12115, {_Ret, _Msg, _Id, _Srv, _Type}, _Tester) ->
     ?DEBUG("收到好友更换类型[Ret:~w, Msg:~w, Id:~w, Srv:~w, Type:~w]", [_Ret, _Msg,  _Id, _Srv, _Type]),
    {ok};

handle(send12105, {}, _Tester) ->
    tester:pack_send(12105, {106, <<"test_1">>});
%% 取得名字添加好友数据
 handle(12105, _Data, _Tester) ->
     ?DEBUG("收到好友更换类型[_Data:~p]", [_Data]),
    {ok};

%% 接受好友请求
 handle(12146, {_FrRoleId, _FrSrvId, _Type}, _Tester) ->
     ?DEBUG("接受好友请求[FrRoleId:~w FrSrvId:~w Type:~w]", [_FrRoleId, _FrSrvId, _Type]),
    {ok};

%% 接受好友请求
 handle(12135, {_RoleId, _VipType, _SrvId, _RoleName}, _Tester) ->
     ?DEBUG("接受好友请求[RoleId:~w, VipType:~w, SrvId:~w, RoleName:~w]", [_RoleId, _VipType, _SrvId, _RoleName]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
