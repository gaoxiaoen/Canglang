%%---------------------------------------------
%% 测试采集相关RPC调用
%% @author 252563398@qq.com
%%---------------------------------------------
-module(test_collect_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 采集背包列表
handle(list, {}, _Tester) ->
    tester:pack_send(12300, {}),
    {ok};
handle(12300, {_Volume, _CollectItems}, _TesterState) ->
    ?DEBUG("收到采集背包物品列表Volume:~w CollectItems:~w",[_Volume, _CollectItems]),
    {ok};

%% 开始采集指定物品
handle(collect, {BaseId}, _Tester) ->
    tester:pack_send(12301, {BaseId}),
    {ok};
handle(12301, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 删除所有选项
handle(del_all, {}, _Tester) ->
    tester:pack_send(12303, {}),
    {ok};
handle(12303, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 删除指定选项
handle(del, {Pos}, _Tester) ->
    tester:pack_send(12304, {Pos}),
    {ok};
handle(12304, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 整理采集背包
handle(refresh, {}, _Tester) ->
    tester:pack_send(12305, {}),
    {ok};
handle(12305, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 移动采集背包某格子物品到背包
handle(move, {CPos}, _Tester) ->
    tester:pack_send(12306, {CPos}),
    {ok};
handle(12306, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 移动所有采集背包物品数据到背包
handle(move_all, {}, _Tester) ->
    tester:pack_send(12307, {}),
    {ok};
handle(12307, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 获取广播数据
handle(12308, _Status, _TesterState) ->
    ?DEBUG("收到广播数据-状态变化[Msg:~w]", [_Status]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
