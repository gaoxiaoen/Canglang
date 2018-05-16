%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. 五月 2017 15:17
%%%-------------------------------------------------------------------
-module(cross_flower_rpc).
-include("daily.hrl").
-include("activity.hrl").
-include("server.hrl").
-include("common.hrl").
-include("achieve.hrl").
%% API
-export([handle/3]).


%%查询鲜花排行榜数据
handle(60200, Player, {}) ->
    cross_all:apply(cross_flower, check_info, [node(), config:get_server_num(), Player#player.key, Player#player.sid]),
    ok;

%%查询鲜花达标榜数据
handle(60201, Player, {}) ->
    Data = cross_flower:get_achieve_info(Player),
    {ok, Bin} = pt_602:write(60201, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%领取鲜花达标奖励
handle(60202, Player, {Type, Id}) ->
    case cross_flower:get_achieve_award(Player, Type, Id) of
        {false, Res} ->
            {ok, Bin} = pt_602:write(60202, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_602:write(60202, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(_cmd, _Player, _Data) ->
    ?DEBUG("cmd ~p err~n", [_cmd]),
    ok.
