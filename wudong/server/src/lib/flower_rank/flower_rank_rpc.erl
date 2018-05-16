%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(flower_rank_rpc).
-include("daily.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").
%% API
-export([handle/3]).

%%查询鲜花排行榜数据
handle(60300, Player, {}) ->
    ?CAST(flower_rank_proc:get_server_pid(), {check_info, Player}),
    ok;

%%查询鲜花达标榜数据
handle(60301, Player, {}) ->
    Data = flower_rank:get_achieve_info(Player),
    {ok, Bin} = pt_603:write(60301, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取鲜花达标奖励
handle(60302, Player, {Type, Id}) ->
    case flower_rank:get_achieve_award(Player, Type, Id) of
        {false, Res} ->
            {ok, Bin} = pt_603:write(60302, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_603:write(60302, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.
