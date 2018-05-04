%%---------------------------------------------
%% 测试VIP相关RPC调用
%% @author 252563398@qq.com
%%---------------------------------------------
-module(test_vip_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% VIP信息
handle(info, {}, _Tester) ->
    tester:pack_send(12400, {}),
    {ok};
handle(12400, {_Type, _Expire, _PortraitId, _SpecialTime, _BuffTime, _IsBless, _IsSpecial}, _TesterState) ->
    ?DEBUG("收到VIP信息:[~w,~w,~w,~w,~w,~w,~w]",[_Type, _Expire, _PortraitId, _SpecialTime, _BuffTime, _IsBless, _IsSpecial]),
    {ok};

%% 领取祝福
handle(bless, {}, _Tester) ->
    tester:pack_send(12401, {}),
    {ok};
handle(12401, {_Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w]", [_Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 更换头像
handle(faceid, {FaceId}, _Tester) ->
    tester:pack_send(12402, {FaceId}),
    {ok};
handle(12402, {_FaceId, _Code, _Msg}, _TesterState) ->
    ?DEBUG("返回信息[~w:~w:~w]", [_FaceId, _Code, _Msg]),
    util:cn(_Msg),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
