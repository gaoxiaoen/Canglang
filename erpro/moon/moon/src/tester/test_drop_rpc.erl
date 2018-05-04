%%----------------------------------------------------
%% Author: yqhuang(QQ:19123767)
%% Created: 2011-8-22
%% Description: TODO: Add description to test_drop_rpc
%%----------------------------------------------------
-module(test_drop_rpc).

-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

handle(kill_npc, {NpcId, Times}, _Tester) ->
    tester:pack_send(9910, {erlang:list_to_bitstring(io_lib:format("测试掉落 ~p ~p", [NpcId, Times]))}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
