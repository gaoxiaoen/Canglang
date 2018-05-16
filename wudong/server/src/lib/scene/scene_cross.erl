%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 五月 2016 16:35
%%%-------------------------------------------------------------------
-module(scene_cross).
-author("hxming").

-include("scene.hrl").
-include("server.hrl").

%% API
-compile(export_all).

%%获取传送门信息
door(SceneId, Plv) ->
    case data_scene_cross:get(Plv) of
        [] -> [];
        [Sid, DoorId, DoorX, DoorY] ->
            if DoorId == SceneId ->
                case data_scene:get(Sid) of
                    [] -> [];
                    Scene ->
                        [[Sid, Scene#scene.name, DoorX, DoorY]]
                end;
                true -> []
            end
    end.

%%跨服踢人
send_out_cross_all() ->
    F = fun(Type) ->
        send_out_cross(Type)
    end,
    lists:foreach(F, ?SCENE_TYPE_CROSS_AREA_LIST ++ ?SCENE_TYPE_CROSS_ALL_LIST).

%%跨服巅峰塔踢人
send_out_cross(?SCENE_TYPE_CROSS_BATTLEFIELD) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_battlefield)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, data_cross_battlefield:scene_ids());
%%跨服boss
send_out_cross(?SCENE_TYPE_CROSS_BOSS) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_boss)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_CROSS_BOSS_ONE, ?SCENE_ID_CROSS_BOSS_TWO, ?SCENE_ID_CROSS_BOSS_THREE, ?SCENE_ID_CROSS_BOSS_FOUR, ?SCENE_ID_CROSS_BOSS_FIVE]);
%%跨服1v1
send_out_cross(?SCENE_TYPE_CROSS_ELITE) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_elite)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_CROSS_ELITE]);
%%退出战场
send_out_cross(?SCENE_TYPE_BATTLEFIELD) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_battlefild)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_BATTLEFIELD]);
%%退出跨服猎场
send_out_cross(?SCENE_TYPE_HUNT) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_hunt)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_HUNT]);
%%跨服普通地图
send_out_cross(?SCENE_TYPE_CROSS_NORMAL) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_normal)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, data_scene_cross:ids());
%%竞技场
send_out_cross(?SCENE_TYPE_CROSS_ARENA) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_arena)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_CROSS_ARENA]);
%%消消乐
send_out_cross(?SCENE_TYPE_CROSS_ELIMINATE) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_eliminate)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, [?SCENE_ID_CROSS_ELIMINATE]);
%%城战
send_out_cross(?SCENE_TYPE_CROSS_WAR) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_war)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, []);

send_out_cross(?SCENE_TYPE_CROSS_SCUFFLE) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_scuffle)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, []);

send_out_cross(?SCENE_TYPE_CROSS_SCUFFLE_ELITE) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_scuffle_elite)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, []);

send_out_cross(?SCENE_TYPE_CROSS_DARK_BLIBE) ->
    F = fun(SceneId) ->
        PlayerList = scene_agent:get_scene_player(SceneId),
        F1 = fun(ScenePlayer) ->
            server_send:send_node_pid(ScenePlayer#scene_player.node, ScenePlayer#scene_player.pid, quit_cross_dark)
        end,
        lists:foreach(F1, PlayerList)
    end,
    lists:foreach(F, data_cross_dark_scene_lv:ids());

send_out_cross(_) -> ok.
