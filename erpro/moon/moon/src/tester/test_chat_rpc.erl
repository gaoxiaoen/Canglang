%%----------------------------------------------------
%% 测试聊天
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_chat_rpc).
-export([handle/3]).
-include("tester.hrl").
-include("common.hrl").

%% 世界聊天
handle(world, {}, _Tester) ->
    tester:pack_send(10910, {1, <<"这是一条世界聊天消息">>}),
    {ok};

%% 收到聊天消息
handle(10910, {_Channel, _Rid, _SrvId, _Name, _Sex, _Msg}, _Tester) ->
    ?DEBUG("收到聊天消息[channel:~w rid:~w srv_id:~s name:~s sex:~w]:~s", [_Channel, _Rid, _SrvId, _Name, _Sex, _Msg]), 
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
