%%----------------------------------------------------
%% 测试GM命令
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(test_role_adm_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

handle(test_all, {}, _Tester) ->
    tester:pack_send(9900, {}),
    tester:pack_send(9910, {<<"设金币 1000">>}),
    tester:pack_send(9910, {<<"设梆定铜 10000">>}),
    tester:pack_send(9910, {<<"设晶钻 1000">>}),
    tester:pack_send(9910, {<<"设梆定晶钻 1000">>}),
    tester:pack_send(9910, {<<"获取物品 10000 3">>}),
    tester:pack_send(9910, {<<"获取物品 10002 5">>}),
    tester:pack_send(9910, {<<"设灵力 20000">>}),
    tester:pack_send(9910, {<<"设等级 9">>}), 
    {ok};

handle(get_item, {Id, Num}, _Tester) ->
    Msg = util:all_to_binary([<<"获取物品">>, " ", Id, " ", Num]),
    tester:pack_send(9910, {Msg}),
    {ok};

handle(add_coin, {Num}, _Tester) ->
    Msg = util:all_to_binary([<<"设金币">>, " ", Num]),
    tester:pack_send(9910, {Msg}),
    {ok};


handle(9900, {_HelpText}, _Tester) ->
    ?DEBUG("收到GM命令的帮助信息: ...", []),
    {ok};

handle(9910, {_Result}, _Tester) ->
    ?DEBUG("收到GM命令的执行结果:~s", [_Result]),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
