%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 十二月 2015 14:44
%%%-------------------------------------------------------------------
-module(scene_transport).
-author("hxming").
-include("server.hrl").
-include("scene.hrl").
-include("common.hrl").

%% API
-export([target_transport/4, target_transport_x_y/3]).

target_transport_x_y(Player, ?SCENE_ID_CROSS_WAR, Id) ->
    {X, Y} = data_cross_war_scene_door:get(Id),
    NewPlayer = transport(Player, ?SCENE_ID_CROSS_WAR, X, Y),
    {1, NewPlayer}.
%%Param type 1场景,2NPC,3怪物, PosType : 0点对场景,1点对点,TargetId:目标ID
%%Return ErrCode
%%1场景传送
target_transport(1, Player, TargetId, _PosType) ->
    case data_scene:get(match_scene(Player#player.lv, TargetId)) of
        [] -> {5, Player};
        Scene ->
            case check_scene(Scene, Player) of
                true ->
                    case check_transport_state(Player) of
                        true ->
                            {X, Y} = {Scene#scene.x, Scene#scene.y},
                            NewPlayer = transport(Player, Scene#scene.id, X, Y),
                            {1, NewPlayer};
                        Err ->
                            {Err, Player}
                    end;
                Err ->
                    {Err, Player}
            end
    end;
%%2NPC传送
target_transport(2, Player, TargetId, PosType) ->
    case data_npc_transport:get(TargetId) of
        [] -> {7, Player};
        [SceneId, X, Y] ->
            Scene = data_scene:get(match_scene(Player#player.lv, SceneId)),
            case check_scene(Scene, Player) of
                true ->
                    case check_transport_state(Player) of
                        true ->
                            case PosType of
                                1 ->
                                    NewPlayer = transport(Player, Scene#scene.id, X, Y);
                                _ ->
                                    NewPlayer = transport(Player, Scene#scene.id, Scene#scene.x, Scene#scene.y)
                            end,
                            {1, NewPlayer};
                        Err ->
                            {Err, Player}
                    end;
                Err ->
                    {Err, Player}
            end
    end;
%%3怪物传送
target_transport(3, Player, TargetId, PosType) ->
    case data_mon_transport:get(TargetId) of
        [] -> {8, Player};
        [SceneId, X, Y] ->
            Scene = data_scene:get(match_scene(Player#player.lv, SceneId)),
            case check_scene(Scene, Player) of
                true ->
                    case check_transport_state(Player) of
                        true ->
                            case PosType of
                                1 ->
                                    NewPlayer = transport(Player, Scene#scene.id, X, Y);
                                _ ->
                                    NewPlayer = transport(Player, Scene#scene.id, Scene#scene.x, Scene#scene.y)
                            end,
                            {1, NewPlayer};
                        Err ->
                            {Err, Player}
                    end;
                Err ->
                    {Err, Player}
            end
    end;
target_transport(_, Player, _TargetId, _) ->
    {4, Player}.

check_scene(Scene, Player) ->
    if Scene#scene.id == Player#player.scene -> 11;
        Scene#scene.type == ?SCENE_TYPE_NORMAL ->
            check_enter_lv(Player, Scene);
        true ->
            case scene:is_cross_normal_scene(Scene#scene.id) of
                true ->
                    case cross_area:check_cross_area_state() of
                        false -> 14;
                        true ->
                            check_enter_lv(Player, Scene)
                    end;
                false -> 6
            end
    end.

check_enter_lv(Player, Scene) ->
    case lists:keyfind(lv, 1, Scene#scene.require) of
        false -> true;
        {_, Lv} ->
            if Lv > Player#player.lv -> 9;
                true -> true
            end
    end.

%%检查玩家状态
check_transport_state(Player) ->
    case scene:is_normal_scene(Player#player.scene) orelse scene:is_cross_normal_scene(Player#player.scene) of
        false -> 6;
        true ->
            if Player#player.convoy_state > 0 ->
                10;
                Player#player.marry#marry.cruise_state > 0 -> 23;
                true ->
                    true
            end
    end.

transport(Player, SceneId, X1, Y1) ->
    {X, Y} = scene:random_xy(SceneId, X1, Y1),
    NewCopy = scene_copy_proc:get_scene_copy(SceneId, Player#player.copy),
    scene_change:change_scene(Player, SceneId, NewCopy, X, Y, false).

match_scene(Plv, SceneId) ->
    case scene:is_cross_normal_scene(SceneId) of
        false -> SceneId;
        true ->
            case data_scene_cross:get(Plv) of
                [] -> SceneId;
                List -> hd(List)
            end
    end.
