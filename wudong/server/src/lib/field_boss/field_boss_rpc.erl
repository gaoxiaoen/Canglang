%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2016 14:49
%%%-------------------------------------------------------------------
-module(field_boss_rpc).
-author("hxming").
-include("field_boss.hrl").
-include("common.hrl").
-include("server.hrl").
-include("sword_pool.hrl").
%% API
-export([handle/3]).

%%获取boss列表
handle(56001, Player, {}) ->
    Data = field_boss:get_boss_list(Player),
    {ok, Bin} = pt_560:write(56001, Data),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%飞鞋进入boss场景
handle(56002, Player, {Sid}) ->
    case field_boss:fly_to_scene(Player, Sid) of
        {false, Msg} ->
            {ok, Bin} = pt_560:write(56002, {Msg}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_560:write(56002, {?T("成功")}),
            server_send:send_to_sid(Player#player.sid, Bin),
            sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_WORLD_BOSS),
            {ok, NewPlayer}
    end;

%%获取伤害列表
handle(56003, Player, {}) ->
    field_boss:damage_info(Player),
    ok;

%%获取boss排行
handle(56004, Player, {}) ->
    field_boss:get_rank(Player),
    ok;

%%获取具体榜单
handle(56005, Player, {SceneId}) ->
    field_boss:get_scene_rank(Player, SceneId),
    ok;

%%roll
handle(56007, Player, {Mkey}) ->
    field_boss_roll:player_roll(Player, Mkey),
    ok;

handle(56011, Player, _) ->
    ?CAST(field_boss_proc:get_server_pid(), {get_state_info, Player#player.sid}),
    ok;

%%获取精英怪
handle(56021, Player, _) ->
    field_boss:get_elite_info(Player),
    ok;

%%飞鞋去精英怪
handle(56022, Player, {SceneId, Copy, MonId, X, Y}) ->
    case field_boss:fly_to_elite_scene(Player, SceneId, Copy, MonId, X, Y) of
        {false, Msg} ->
            {ok, Bin} = pt_560:write(56022, {Msg}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        {ok, NewPlayer} ->
            {ok, Bin} = pt_560:write(56022, {?T("成功")}),
            server_send:send_to_sid(Player#player.sid, Bin),
            {ok, NewPlayer}
    end;

%% 购买挑战次数
handle(56023, Player, {N}) ->
    {Code, NewPlayer} = field_boss:buy_challenge(Player, N),
    {ok, Bin} = pt_560:write(56023, {Code}),
    server_send:send_to_sid(Player#player.sid, Bin),
    {ok, NewPlayer};

handle(_cmd, _Player, _Data) ->
    ok.
