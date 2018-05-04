%%---------------------------------------------
%% 测试活动奖励系统相关RPC调用
%% @author Jange
%%---------------------------------------------
-module(test_award_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 开服活动列表
handle(list, {}, _Tester) ->
    tester:pack_send(14005, {}),
    {ok};
handle(14005, {_CList}, _TesterState) ->
    ?DEBUG("返回信息[~w]", [_CList]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
