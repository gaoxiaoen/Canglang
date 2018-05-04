%%----------------------------------------------------
%% 测试消息通知系统
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_notice_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 购买抢购商品二
handle(11100, {_Code, _Msg}, _Tester) ->
    ?DEBUG("收到通知消息:[Code:~w,Msg:~s]", [_Code, _Msg]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
