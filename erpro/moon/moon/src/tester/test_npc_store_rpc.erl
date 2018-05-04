%%---------------------------------------------
%% 测试NPC商场相关RPC调用
%% @author 252563398@qq.com
%%---------------------------------------------
-module(test_npc_store_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 商场物品列表
handle(list, {NpcId, IsRemote}, _Tester) ->
    tester:pack_send(11900, {NpcId, IsRemote}),
    {ok};
handle(11900, {_ItemList}, _TesterState) ->
    ?DEBUG("收到物品列表:~w",[_ItemList]),
    {ok};

%% 可出售物品列表
handle(list_sale, {}, _Tester) ->
    tester:pack_send(11901, {}),
    {ok};
handle(11901, {_ItemList}, _TesterState) ->
    ?DEBUG("收到可出售物品列表:~w",[_ItemList]),
    {ok};

%% 购买物品
handle(buy, {NpcId, IsRemote, Bindtype, BuyItems}, _Tester) ->
    tester:pack_send(11902, {NpcId, IsRemote, Bindtype, BuyItems}),
    {ok};
handle(11902, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 出售物品
handle(sale, {NpcId, IsRemote, Ids}, _Tester) ->
    tester:pack_send(11903, {NpcId, IsRemote, Ids}),
    {ok};
handle(11903, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
