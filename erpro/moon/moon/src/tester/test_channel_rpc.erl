%% *********************
%% 元神测试模块
%% wpf  wprehard@qq.com
%% *********************

-module(test_channel_rpc).
-export([
        handle/3
    ]).

-include("common.hrl").
-include("tester.hrl").

%% 元神列表
handle(channels, {}, _Tester) ->
    tester:pack_send(12900, {}),
    {ok};
handle(12900, _Data, _Tester) ->
    ?DEBUG("元神列表数据：~w", [_Data]),
    {ok};

%% 修炼元神
handle(practice, {ChannelId}, _Tester) ->
    tester:pack_send(12901, {ChannelId}),
    {ok};
handle(12901, {_Msg, _Id, _Time}, _Tester) ->
    ?DEBUG("元神修炼返回[Msg:~s, ID:~w, TIME:~w]", [_Msg, _Id, _Time]),
    {ok};

%% 取消修炼
handle(cancel_practice, {ChannelId}, _Tester) ->
    tester:pack_send(12902, {ChannelId}),
    {ok};
handle(12902, {_Msg}, _Tester) ->
    ?DEBUG("元神取消修炼结果[Msg:~s]", [_Msg]),
    {ok};

%% 加速修炼
handle(speed_up, {ChannelId, UpType, SpeedType}, _Tester) ->
    tester:pack_send(12903, {ChannelId, UpType, SpeedType}),
    {ok};
handle(12903, {_Msg, _Id, _Time}, _Tester) ->
    ?DEBUG("元神修炼加速结果[Msg:~s, ChannelID:~w, Time:~w]", [_Msg, _Id, _Time]),
    {ok};

%% 修炼完成通知
handle(12904, {_ChannelId, _Time, _Lev, _, _, _, _, _, _, _}, _Tester) ->
    ?DEBUG("元神修炼完成通知ID：~w, Time:~w, Lev:~w", [_ChannelId, _Time, _Lev]),
    {ok};

%% 提升元神境界
handle(upgrade, {ChannelId, IsProt}, _Tester) ->
    tester:pack_send(12905, {ChannelId, IsProt}),
    {ok};
handle(12905, {_Msg, _Id, _State, _Attr, _NextAttr}, _Tester) ->
    ?DEBUG("元神提升返回[Msg:~s, ID:~w, State:~w, Attr:~w, NextAttr:~w]", [_Msg, _Id, _State, _Attr, _NextAttr]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
