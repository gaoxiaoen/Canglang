%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 二月 2017 下午12:01
%%%-------------------------------------------------------------------
-module(cross_six_dragon_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

handle(58101, Player, _) ->
    cross_area:apply(cross_six_dragon, get_state, [node(), Player#player.sid]),
    ok;

%%获取个人比赛信息
handle(58102, Player, _) ->
    cross_area:apply(cross_six_dragon, get_fight_info, [Player#player.key, Player#player.sid, node()]),
    ok;

%%申请匹配
handle(58103, Player, _) ->
    cross_six_dragon:apply_match(Player),
    ok;

%%取消匹配
handle(58104, Player, _) ->
    cross_area:apply(cross_six_dragon, cancel_match, [Player#player.key, Player#player.sid, Player#player.node]),
    ok;

%%获取当前比赛信息
handle(58105, Player, _) ->
    cross_area:apply(cross_six_dragon, get_fight_target, [Player#player.key, Player#player.sid, Player#player.node]),
    ok;

%%退出比赛场景
handle(58107, Player, _) ->
    case cross_six_dragon:exit_six_dragon_battle(Player) of
        {false, Res} ->
            {ok, Bin} = pt_581:write(58107, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_581:write(58107, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%%获取积分排行
handle(58108, Player, _) ->
    cross_area:apply(cross_six_dragon, get_point_rank, [Player#player.key, Player#player.sid, config:get_acceptor_num(), Player#player.node]),
    ok;

%%查看积分奖励
handle(58109, Player, _) ->
    cross_six_dragon:get_rank_gift(Player),
    ok;

handle(Cmd, _Player, Data) ->
    ?DEBUG("Cmd ~p undef ~p~n", [Cmd, Data]),
    ok.