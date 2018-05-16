%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2017 下午8:06
%%%-------------------------------------------------------------------
-module(hot_well_rpc).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

%% API
-export([
    handle/3
]).

%% 活动状态
handle(58301, Player, _) ->
    cross_area:apply(hot_well, get_state, [node(), Player#player.key, Player#player.sid]),
    ok;

%% 进入温泉
handle(58302, Player, _) ->
    IsNormal = scene:is_normal_scene(Player#player.scene),
    State = cross_area:apply_call(hot_well, get_state_call, []),
    Ret =
        if
            not IsNormal -> 2;
            State =/= 1 -> 3;
            true ->
                case scene:is_normal_scene(Player#player.scene) of
                    false -> 6;
                    true ->
                        Mb = hot_well:make_mb(Player),
                        cross_area:apply(hot_well, enter_hot_well, [Mb]),
                        %% 玩法找回
                        findback_src:fb_trigger_src(Player, 37, 1),
                        ok
                end
        end,
    case Ret of
        ok -> ok;
        _ ->
            {ok, Bin} = pt_583:write(58302, {Ret}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok
    end;

%% 退出温泉
handle(58303, Player, _) ->
    Check = Player#player.scene =/= ?SCENE_ID_HOT_WELL,
    case Check of
        true ->
            {ok, Bin} = pt_583:write(58303, {4}),
            server_send:send_to_sid(Player#player.sid, Bin),
            ok;
        _ ->
            {ok, Bin} = pt_583:write(58303, {1}),
            server_send:send_to_sid(Player#player.sid, Bin),
            cross_area:apply(hot_well, exit_hot_well, [Player#player.key, Player#player.sid]),
            NewPlayer = scene_change:change_scene_back(Player),
            {ok, NewPlayer}
    end;

%% 温泉信息
handle(58304, Player, _) ->
    cross_area:apply(hot_well, get_info, [node(), Player#player.key, Player#player.sid]),
    ok;

%%申请双修
handle(58305, Player, _) ->
    cross_area:apply(hot_well, apply_sx, [node(), Player#player.key, Player#player.sid]),
    ok;

%%结束双修
handle(58307, Player, _) ->
    ?DEBUG("58307 ~n"),
    cross_area:apply(hot_well, stop_sx, [Player#player.key, Player#player.sid]),
    ok;

%%开始双修
handle(58308, Player, _) ->
    cross_area:apply(hot_well, start_sx, [node(), Player#player.key, Player#player.sid]),
    {ok, Bin} = pt_583:write(58308, {1}),
    server_send:send_to_sid(Player#player.sid, Bin),
    ok;

%%发起双修
handle(58309, Player, {Pkey}) ->
    cross_area:apply(hot_well, invite_sx, [node(), Player#player.key, Player#player.sid, Pkey]),
    ok;

%%发起整蛊
handle(58310, Player, {Pkey}) ->
    cross_area:apply(hot_well, start_joke, [node(), Player#player.key, Player#player.sid, Pkey]),
    ok;

handle(_cmd, _Player, _Data) ->
    ok.
