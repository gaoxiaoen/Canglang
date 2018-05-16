%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 十二月 2015 下午1:57
%%%-------------------------------------------------------------------
-module(vip_rpc).
-author("fengzhenlin").
-include("server.hrl").
-include("common.hrl").

%% API
-export([
    handle/3
]).

%%玩家vip信息
handle(47001, Player, _) ->
    vip:get_player_vip(Player),
    ok;

%% 领取vip奖励
handle(47002, Player, {VipLv}) ->
    case vip:buy_gift(Player, VipLv) of
        {false, Res} ->
            {ok, Bin} = pt_470:write(47002, {Res, VipLv}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_470:write(47002, {1, VipLv}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 领取vip每周礼包
handle(47005, Player, _) ->
    case vip:get_week_gift(Player) of
        {false, Res} ->
            {ok, Bin} = pt_470:write(47005, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_470:write(47005, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;


%% 一元vip状态
handle(47006, Player, {}) ->
    ?DEBUG("47006 read ~n"),
    limit_vip:get_state(Player),
    ok;

%% 一元vip开启
handle(47008, Player, {}) ->
    NewPlayer = limit_vip:open_time_limit_vip(Player),
    {ok, Bin} = pt_470:write(47008, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, attrs, NewPlayer};


handle(_cmd, _Player, _Data) ->
    ?ERR("bad cmd ~p~n", [_cmd]),
    ok.