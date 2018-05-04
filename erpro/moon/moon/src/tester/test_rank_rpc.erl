%%----------------------------------------------------
%% 测试排行榜
%% 
%% @author zhongkj@jieyou.cn
%%----------------------------------------------------
-module(test_rank_rpc).
-export([handle/3]).
-include("common.hrl").
-include("tester.hrl").

%% 收到等级排行榜数据
handle(11000, {_LevList}, _Tester) ->
    ?DEBUG("收到等级排行榜数据[LevlList:~w]", [_LevList]),
    {ok};

%% 请求等级排行榜数据
handle(lev_list, {}, _Tester) ->
    tester:pack_send(11000, {}),
    {ok};

%% 收到财富排行榜数据
handle(11001, {_CoinList}, _Tester) ->
    ?DEBUG("收到财富排行榜数据[CoinList:~w]", [_CoinList]),
    {ok};

%% 请求财富排行榜数据
handle(coin_list, {}, _Tester) ->
    tester:pack_send(11001, {}),
    {ok};

%% 容错处理
handle(_Cmd, _Data, #tester{name = _Name}) ->
    ?DEBUG("[~s]收到未知消息[~w]: ~w", [_Name, _Cmd, _Data]),
    {ok}.
