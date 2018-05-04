%%----------------------------------------------------
%% 测试战斗
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_combat_rpc).
-export([handle/3]).
-include("tester.hrl").
-include("common.hrl").

%% 发起战斗
handle(fight, {TargetId, TargetSrvId}, _Tester) ->
    tester:pack_send(10700, {TargetId, TargetSrvId}),
    {ok};

%% 发送进度信息
handle(load, {Val}, _Tester) ->
    tester:pack_send(10711, {Val}),
    {ok};

%% 通知动画播放完成
handle(play_done, {}, _Tester) ->
    tester:pack_send(10731, {}),
    {ok};

handle(10700, {_Result, _Msg}, _Tester = #tester{name = _Name}) ->
    ?DEBUG("~s 接收到发起战斗的处理结果:~w ~s", [_Name, _Result, _Msg]),
    {ok};

handle(10720, {_Round, _AtkList, _DfdList}, _Tester = #tester{name = _Name}) ->
    ?DEBUG("~s 接收到战斗回合数据:~w", [_Name, _Round]),
    {ok};

handle(10721, {_Time}, _Tester = #tester{name = _Name}) ->
    ?DEBUG("服务端通知 ~s 有~w秒的时间出招", [_Name, _Time]),
    {ok};

handle(10790, {}, _Tester = #tester{name = _Name}) ->
    ?DEBUG("服务端通知 ~s ：战斗已结束", [_Name]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
