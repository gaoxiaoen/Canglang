%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 十一月 2016 10:04
%%%-------------------------------------------------------------------
-module(sword_pool_rpc).
-author("hxming").
-include("common.hrl").
-include("server.hrl").
%% API
-export([handle/3]).

%%剑池信息
handle(15401, Player, {}) ->
    Data = sword_pool:sword_pool_info(Player),
    {ok, Bin} = pt_154:write(15401, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%升级
handle(15402, Player, {}) ->
    {Ret, NewPlayer} = sword_pool:upgrade(Player),
    {ok, Bin} = pt_154:write(15402, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, sword_pool_figure, NewPlayer};
        true -> ok
    end;

%%幻化
handle(15403, Player, {Figure}) ->
    {Ret, NewPlayer} = sword_pool:figure(Player, Figure),
    {ok, Bin} = pt_154:write(15403, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    if Ret == 1 ->
        {ok, sword_pool_figure, NewPlayer};
        true -> ok
    end;

%%领取每日额外奖励
handle(15404, Player, {}) ->
    {Ret, NewPlayer} = sword_pool:daily_goods(Player),
    {ok, Bin} = pt_154:write(15404, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

%%获取可找回列表
handle(15405, Player, {}) ->
    Data = sword_pool:find_back_list(),
    {ok, Bin} = pt_154:write(15405, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%一键找回
handle(15406, Player, {}) ->
    {Ret, NewPlayer} = sword_pool:find_back(Player),
    {ok, Bin} = pt_154:write(15406, {Ret}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ?ERR("sword_pool_rpc cmd ~p~n", [_cmd]),
    ok.
