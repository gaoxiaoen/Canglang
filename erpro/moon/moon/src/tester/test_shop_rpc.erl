%%----------------------------------------------------
%% 测试商城RPC
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_shop_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 客户端发送12000封包到服务端 
handle(test_all, {}, _Tester) ->
    tester:pack_send(9900, {}),
    tester:pack_send(9910, {<<"设金币 100000">>}),
    tester:pack_send(9910, {<<"设梆定铜 100000">>}),
    tester:pack_send(9910, {<<"设晶钻 100000">>}),
    tester:pack_send(9910, {<<"设梆定晶钻 100000">>}),
    %% tester:pack_send(9910, {<<"获取物品 11 3">>}),
    %% tester:pack_send(9910, {<<"获取物品 12 30">>}),

    tester:pack_send(12000, {}), %% 测试获取商品列表
    tester:pack_send(12005, {}), %% 测试获取抢购商品列表
    %% 测试晶钻购买
    tester:pack_send(12010, {1, 3}),
    tester:pack_send(12010, {1, 20}),
    tester:pack_send(12010, {1, 100}),
    %% 测试梆定晶钻购买
    tester:pack_send(12015, {1, 2}),
    tester:pack_send(12015, {1, 20}),
    tester:pack_send(12015, {1, 100}),
    %% 测试抢购一
    tester:pack_send(12020, {}),
    tester:pack_send(12020, {}),
    %% 测试抢购二
    tester:pack_send(12025, {}),
    tester:pack_send(12025, {}),
    {ok};

%% 取得商城列表
handle(12000, {_GoldItems, _BindGoldItems}, _Tester) ->
    ?DEBUG("收到普通商品列表数据[gold_item:~p~nbind_gold_items:~p]", [_GoldItems, _BindGoldItems]),
    {ok};

%% 取得商城抢购列表
handle(12005, _Special, _Tester) ->
    ?DEBUG("收到抢购商品数据[special:~w]", [_Special]),
    {ok};

%% 购买晶钻商品
handle(12010, {_Result, _Msg}, _Tester ) ->
    ?DEBUG("收到购买晶钻商品返回结果[Result:~w,Msg:~s]", [_Result, _Msg]),
    {ok};

%% 购买梆定晶钻商品
handle(12015, {_Result, _Msg}, _Tester ) ->
    ?DEBUG("收到购买梆定晶钻商品返回结果[Result:~w,Msg:~s]", [_Result, _Msg]),
    {ok};

%% 购买抢购商品一
handle(12020, {_Result, _Msg}, _Tester ) ->
    ?DEBUG("收到购买抢购商品一的返回结果[Result:~w,Msg:~s]", [_Result, _Msg]),
    {ok};

%% 购买抢购商品二
handle(12025, {_Result, _Msg}, _Tester) ->
    ?DEBUG("收到购买抢购商品二的返回结果[Result:~w,Msg:~s]", [_Result, _Msg]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
