%%----------------------------------------------------
%% 测试Buff系统
%% 
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(test_buff_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 收到BUFF列表
handle(10400, {_BuffList}, _Tester) ->
    ?DEBUG("收到BUff列表:~w",[_BuffList]),
    {ok};

%% 请求发送Buff列表
handle(buff_list, {}, _Tester) ->
    tester:pack_send(10400, {}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
