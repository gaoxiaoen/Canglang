%%----------------------------------------------------
%% 测试背包系统
%% 
%% @author shawnoyc@163.com
%%----------------------------------------------------
-module(test_item_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 收到背包物品列表
handle(10300, {_Volume, _BagItems}, _Tester) ->
    ?DEBUG("收到背包物品列表Volume:~w BagItems:~w",[_Volume, _BagItems]),
    {ok};

%% 请求背包物品列表
handle(bag_item, {}, _Tester) ->
    tester:pack_send(10300, {}),
    {ok};

%% 收到任务背包列表
handle(10301, {_BagItems}, _Tester) ->
    ?DEBUG("收到任务背包列表:~w",[_BagItems]),
    {ok};

%% 请求任务背包列表
handle(task_bag, {}, _Tester) ->
    tester:pack_send(10301, {}),
    {ok};

%% 收到仓库物品列表
handle(10305, {_Volume, _StoreItems}, _Tester) ->
    ?DEBUG("收到仓库物品列表Volume:~w StoreItems:~w",[_Volume, _StoreItems]),
    {ok};

%% 请求仓库物品列表
handle(store_item, {}, _Tester) ->
    tester:pack_send(10305, {}),
    {ok};

%% 收到装备物品列表
handle(10306, {_EqmItems}, _Tester) ->
    ?DEBUG("收到装备物品列表EqmItems:~w",[_EqmItems]),
    {ok};

%% 请求装备物品列表
handle(eqm_item, {}, _Tester) ->
    tester:pack_send(10306, {}),
    {ok};

%% 收到其他玩家装备物品列表
handle(10307, {_EqmItems}, _Tester) ->
    ?DEBUG("收到装备物品列表EqmItems:~w",[_EqmItems]),
    {ok};

%% 请求其他玩家装备物品列表
handle(other_eqm_item, {_Rid, _SrvId}, _Tester) ->
    tester:pack_send(10307, {_Rid, _SrvId}),
    {ok};

%% 收到刷新单个物品通知
handle(10310, _Item, _Tester) ->
    ?DEBUG("收到单个物品的刷新通知:~w~n", [_Item]),
    {ok};

%% 收到刷新多个物品的通知
handle(10311,{_ItemList}, _Tester) ->
    ?DEBUG("收到多个物品的刷新通知:~w~n",[_ItemList]),
    {ok};

%% 收到增加物品的通知
handle(10312, {_ItemList}, _Tester) ->
    ?DEBUG("收到增加物品的通知:~w~n",[_ItemList]),
    {ok};

%% 收到删除物品的通知
handle(10313, {_ItemList}, _Tester) ->
    ?DEBUG("收到删除物品的通知:~w~n",[_ItemList]),
    {ok};

%% 收到使用物品的通知
handle(10315, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到使用物品的返回Flag:~w, Info:~s",[_Flag, _Info]),
    {ok};

%% 请求使用物品
handle(use_item, {_Id, _Num}, _Tester) ->
    tester:pack_send(10315, {_Id, _Num}),
    {ok};

%% 收到移动背包物品返回信息
handle(10325, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到移动背包物品返回Flag:~w, Info:~w",[_Flag, _Info]),
    {ok};

%% 请求移动背包物品
handle(move_bag_item, {_Id, _StorageType, _Tpos}, _Tester) ->
    tester:pack_send(10325, {_Id, _StorageType, _Tpos}),
    {ok};

%% 收到移动仓库物品返回信息
handle(10326, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到移动仓库物品返回Flag:~w,Info:~w",[_Flag, _Info]),
    {ok};

%% 请求移动仓库物品
handle(move_store_item, {_Id, _StorageType, _Tpos}, _Tester) ->
    tester:pack_send(10326, {_Id, _StorageType, _Tpos}),
    {ok};

%% 收到移动装备返回信息
handle(10327, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到移动装备返回信息Flag:~w,Info:~w",[_Flag, _Info]),
    {ok};

%% 请求移动装备
handle(move_eqm, {_Id, _StorageType, _Tpos}, _Tester) ->
    tester:pack_send(10327, {_Id, _StorageType, _Tpos}),
    {ok};

%% 收到删除物品返回信息
handle(10330, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到删除物品返回[Flag:~w],[Info:~w]",[_Flag, _Info]),
    {ok};

%% 请求删除物品
handle(del_item, {_Id, _StorageType}, _Tester) ->
    tester:pack_send(10330, {_Id, _StorageType}),
    {ok};

%% 收到整理背包返回
handle(10331, {_Flag, _Info}, _Tester) ->
    ?DEBUG("收到整理背包返回[Flag:~w],[Info:~w]",[_Flag, _Info]),
    {ok};

%% 请求整理背包
handle(sort_bag, {}, _Tester) ->
    tester:pack_send(10331, {}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
