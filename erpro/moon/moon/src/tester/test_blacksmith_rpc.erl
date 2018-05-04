%%----------------------------------------------------
%% 测试锻造系统
%% 
%% @author shawnoyc@163.com
%%----------------------------------------------------

-module(test_blacksmith_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 收到修炼的等级以及需要的灵力
handle(10500, {_Lev, _Psychic}, _Tester) ->
    ?DEBUG("收到修炼能到的等级和需要的灵力:Lev = ~w,Psychic = ~w",[_Lev, _Psychic]),
    {ok};

%% 请求武器修炼能到的等级和需要的灵力
handle(get_info, {_Id, _StorageType}, _Tester) ->
    tester:pack_send(10500, {_Id, _StorageType}),
    ?DEBUG("请求数据:~w ~w",[_Id, _StorageType]),
    {ok};

%% 收到修炼返回的信息
handle(10501, {_Flag, _Msg}, _Tester) ->
    ?DEBUG("收到修炼返回的信息Flag:~w, Msg:~w",[_Flag, _Msg]),
    {ok};

%% 请求修炼武器
handle(train_eqm, {_Id, _StorageType, _TrainType}, _Tester) ->
    tester:pack_send(10501, {_Id, _StorageType, _TrainType}),
    {ok};

%% 获取强化信息
handle(10502, {_Sucrate, _FailAdd, _NeedCoin}, _Tester) ->
    ?DEBUG("收到强化信息返回Suc:~w,FailAdd:~w,NeedCoin:~w",[_Sucrate, _FailAdd, _NeedCoin]),
    {ok};

%% 请求强化信息
handle(enchan_info, {_Id, _StorageType, _LuckList}, _Tester) ->
    tester:pack_send(10502, {_Id, _StorageType, _LuckList}),
    {ok};

%% 获取强化至下一级物品的属性
handle(10503, _ReplyList, _Tester) ->
    ?DEBUG("收到强化至下一级物品的属性Attr:~w",[_ReplyList]),
    {ok};

%% 请求获取强化至下一级物品的属性
handle(next_enchant_attr, {_Id, _StorageType}, _Tester) ->
    tester:pack_send(10503, {_Id, _StorageType}),
    {ok};

%% 获取修炼至下一级物品的属性
handle(10504, _ReplyList, _Tester) ->
    ?DEBUG("收到修炼至下一级物品的属性Attr:~w",[_ReplyList]),
    {ok};

%% 请求获取修炼至下一级物品的属性
handle(next_train_attr, {_Id, _StorageType}, _Tester) ->
    tester:pack_send(10504, {_Id, _StorageType}),
    {ok};

%% 获取强化是否成功返回
handle(10505, {_Flag, _Msg}, _Tester) ->
    ?DEBUG("强化是否成功:~w, ~s",[_Flag, _Msg]),
    {ok};

%% 请求强化
handle(enchant, {_Id, _StorageType, _StoneId, _ProtectId, _LuckList}, _Tester) ->
    tester:pack_send(10505, {_Id, _StorageType, _StoneId, _ProtectId, _LuckList}),
    {ok};

%% 获取打孔信息返回
handle(10506, {_NeedCoin, _HoleNum}, _Tester) ->
    ?DEBUG("打孔需要coin:~w, 可打孔数量为:~w",[_NeedCoin, _HoleNum]),
    {ok};

%% 请求打孔信息
handle(slotting_info, {_Id, _StorageType}, _Tester) ->
    tester:pack_send(10506, {_Id, _StorageType}),
    {ok};

%% 获取打孔信息返回
handle(10507, {_Flag, _Msg}, _Tester) ->
    ?DEBUG("打孔是否成功:~w, ~s",[_Flag, _Msg]),
    {ok};

%% 请求打孔
handle(slotting, {_Id, _StorageType, _PaperId}, _Tester) ->
    tester:pack_send(10507, {_Id, _StorageType, _PaperId}),
    {ok};

%% 获取镶嵌信息返回
handle(10508, {_NeedCoin, _Sucrate}, _Tester) ->
    ?DEBUG("镶嵌需要coin:~w, 成功率:~w",[_NeedCoin, _Sucrate]),
    {ok};

%% 请求镶嵌信息
handle(embed_info, {_Id, _StorageType, _StoneId, _ProtectList}, _Tester) ->
    tester:pack_send(10508, {_Id, _StorageType, _StoneId, _ProtectList}),
    {ok};

%% 获取镶嵌返回
handle(10509, {_Flag, _Msg}, _Tester) ->
    ?DEBUG("镶嵌是否成功:~w, ~s",[_Flag, _Msg]),
    {ok};

%% 请求镶嵌
handle(embed, {_Id, _StorageType, _StoneId, _ProtectList}, _Tester) ->
    tester:pack_send(10509, {_Id, _StorageType, _StoneId, _ProtectList}),
    {ok};

%% 获取洗练返回
handle(10510, {_Flag, _Msg}, _Tester) ->
    ?DEBUG("洗练是否成功:~w, ~s",[_Flag, _Msg]),
    {ok};

%% 请求洗练
handle(polish, {_Id, _StorageType, _StoneId}, _Tester) ->
    tester:pack_send(10510, {_Id, _StorageType, _StoneId}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
