%%----------------------------------------------------
%% 测试角色登录
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_client_rpc_game).
-export([handle/3]).
-include("tester.hrl").
-include("common.hrl").
-include_lib("eunit/include/eunit.hrl").

%% 处理获取角色列表结果
handle(1100, _, #tester{id = Rid}) when Rid =/= 0 ->
    ?DEBUG("重复登录"),
    {ok};
%% 自动创建角色
handle(1100, {<<>>, []}, #tester{acc_name = AccName}) ->
    ?DEBUG("帐号[~s]创建新角色", [AccName]),
    tester:pack_send(1105, {AccName, tester:rand(0, 1)}),
    {ok};
%% 登录角色
handle(1100, {<<>>, [[Id, SrvId, _Status, Name, _Sex, _Lev] | _T]}, _Tester)->
    %% ?DEBUG("正在登录角色[~s]", [Name]),
    put(role_info, {Id, SrvId, Name}),   %% 临时保存
    tester:pack_send(1120, {Id, SrvId}),
    {ok};

%% 创建角色成功,请求角色列表
handle(1105, {1, _Msg}, _Tester) ->
    %% ?DEBUG("创建角色成功"),
    tester:pack_send(1100, {}),
    {ok};
%% 角色失败
handle(1105, {0, _Msg}, _Tester) ->
    ?DEBUG("创建角色失败: ~s", [_Msg]),
    {ok};

%% 登录结果
handle(1120, {Result, _Msg}, Tester) ->
    {Id, SrvId, Name} = erase(role_info),
    case Result of
        1 ->
            ?DEBUG("角色[Id:~w, SrvId:~s, Name:~s]登录成功", [Id, SrvId, Name]),
            NewTester = Tester#tester{id = Id, srv_id = SrvId, name = Name},
            random:seed({Id, Id, Id}),
            ets:insert(tester_online, NewTester),
            tester:pack_send(10100, {0, 0}),
            {ok, NewTester};
        _ ->
            ?DEBUG("角色[Id:~w, SrvId:~s, Name:~s]登录失败，原因:~s", [Id, SrvId, Name, _Msg]),
            tester:stop(self()), %% 退出进程
            {ok}
    end;

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
