%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. 二月 2017 下午8:00
%%%-------------------------------------------------------------------
-module(answer_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").

%% API
-export([handle/3]).

handle(26000, Player, _) ->
    cross_area:apply(answer, get_answer_state, [Player#player.sid, Player#player.node]),
    ok;

handle(26001, Player, _) ->
    cross_area:apply(answer, check_enter_answer_scene, [answer:make_player_to_apinfo(Player), Player#player.scene]),
    %%玩法找回
    findback_src:fb_trigger_src(Player, 35, 1),
    ok;

%%退出答题
handle(26002, Player, _) ->
    case answer:exit_answer(Player) of
        {false, Res} ->
            {ok, Bin} = pt_260:write(26002, {Res}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_260:write(26002, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

handle(26005, Player, {Select}) ->
    cross_area:apply(answer, select_answer, [Player#player.key, Select]),
    ok;

%%使用道具
handle(26006, Player, {Type}) ->
    cross_area:apply(answer, use_daoju, [Player#player.key, Type]),
    ok;

%%查看排名
handle(26008, Player, _) ->
    cross_area:apply(answer, get_rank, [Player#player.key,Player#player.node,Player#player.sid]),
    ok;

handle(_cmd, _Player, _Data) ->
    ?ERR("answer_rpc cmd ~p~n", [_cmd]),
    ok.
