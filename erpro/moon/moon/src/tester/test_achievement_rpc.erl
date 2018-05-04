%%---------------------------------------------
%% 测试成就系统相关RPC调用
%% @author 252563398@qq.com
%%---------------------------------------------
-module(test_achievement_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 成就目标列表
handle(list, {}, _Tester) ->
    tester:pack_send(13000, {}),
    {ok};
handle(13000, {_CList}, _TesterState) ->
    ?DEBUG("返回信息[~w]", [_CList]),
    {ok};

%% 领取奖励
handle(reward, {Id}, _Tester) ->
    tester:pack_send(13001, {Id}),
    {ok};
handle(13001, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~s]", [_Code, _Msg]),
    {ok};

%% 当前目标进度
handle(progress, {Id}, _Tester) ->
    tester:pack_send(13002, {Id}),
    {ok};
handle(13002, {_Id, _ReStatus, _Status, _CList}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w:~w]", [_Id, _ReStatus, _Status, _CList]),
    {ok};

%% 当前目标进度(多个)
handle(some_progress, {Ids}, _Tester) ->
    tester:pack_send(13003, {Ids}),
    {ok};
handle(13003, {_CList}, _TesterState) ->
    ?DEBUG("返回信息[~w]", [_CList]),
    {ok};

%% 自动方法领取奖励 服务器推送数据
handle(13020, {_Id, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w]", [_Id, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 成就目标进度更新列表
handle(13021, {_CList}, _TesterState) ->
    ?DEBUG("返回信息[~w]", [_CList]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
