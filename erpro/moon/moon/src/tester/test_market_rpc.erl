%%----------------------------------------------------
%% @doc test_market_rpc 
%%
%% <pre>
%% 市场系统
%% </pre>
%% @author yqhuang(QQ:19123767)
%% @end 
%%---------------------------------------------------
-module(test_market_rpc).

-export([
        handle/3
    ]
).

-include("common.hrl").
-include("market.hrl").
-include("tester.hrl").

handle(test_all, {}, _Tester) ->
    tester:cmd(test_market_rpc, send11300, {}),
    tester:cmd(test_market_rpc, send11301, {}),
    tester:cmd(test_market_rpc, send11302, {}),
    {ok};

%% 搜索拍卖物品 
handle(send11300, {}, _Tester) ->
    tester:pack_send(11300, {2, <<"石">>, 0, 99, 9, 9, 1});
handle(11300, _Data, _Tester) ->
    ?DEBUG("收到搜索拍卖物品数据[Data:~p]", [_Data]),
    {ok};

%% 查询我拍卖的物品
handle(send11301, {}, _Tester) ->
    tester:pack_send(11301, {});
handle(11301, _Data, _Tester) ->
    ?DEBUG("收到搜索个人拍卖物品数据[Data:~p]", [_Data]),
    {ok};

%% 拍卖物品
handle(send11302, {}, _Tester) ->
    tester:pack_send(11302, {});
handle(11302, _Data, _Tester) ->
    ?DEBUG("收到拍卖物品返回数据[Data:~p]", [_Data]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
