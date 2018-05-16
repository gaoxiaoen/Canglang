%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 七月 2017 18:24
%%%-------------------------------------------------------------------
-module(scene_pid).
-author("hxming").
-include("common.hrl").
-include("scene.hrl").
%% API
-compile(export_all).

-define(ACC_LIM, 10).

-define(MAKE_KEY(SceneId, Copy), {scene_pid, SceneId, Copy}).

%%更新场景映射
update_scene_pid(SceneId, Copy, Pid) ->
    ets:insert(?ETS_SCENE_ACC, #ets_scene_acc{pid = Pid, scene_id = SceneId, copy = Copy, acc = 1, time = util:unixtime()}),
    Key = ?MAKE_KEY(SceneId, Copy),
    ets:insert(?ETS_SCENE_PID, #ets_scene_pid{key = Key, pid = Pid}),
    ok.

%%获取场景PID
get_scene_pid(SceneId,Copy) ->
    Key = ?MAKE_KEY(SceneId,Copy),
    case ets:lookup(?ETS_SCENE_PID, Key) of
        [] -> false;
        [Ets] ->
            Ets#ets_scene_pid.pid
    end.

%%删除副本类场景PID,如同类全部清除,则关闭场景
delete_scene_pid(SceneId, Copy) ->
    [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(SceneId, Copy)],
    scene_copy_proc:erase_scene_copy(SceneId, Copy),
    Key = ?MAKE_KEY(SceneId, Copy),
    case ets:lookup(?ETS_SCENE_PID, Key) of
        [] -> ok;
        [ScenePid] ->
            ets:delete(?ETS_SCENE_PID, Key),
            case ets:lookup(?ETS_SCENE_ACC, ScenePid#ets_scene_pid.pid) of
                [] ->
                    ok;
                [SceneAcc] ->
                    case SceneAcc#ets_scene_acc.acc >= ?ACC_LIM orelse is_integer(SceneAcc#ets_scene_acc.copy) of
                        true ->
                            case ets:match_object(?ETS_SCENE_PID, #ets_scene_pid{pid = ScenePid#ets_scene_pid.pid, _ = '_'}) of
                                [] ->
                                    ets:delete(?ETS_SCENE_ACC, ScenePid#ets_scene_pid.pid),
                                    exit(SceneAcc#ets_scene_acc.pid, kill),
                                    ok;
                                _ -> ok
                            end;
                        false -> ok
                    end
            end
    end.


check_scene_pid(SceneId, Copy) ->
    L = ets:match_object(?ETS_SCENE_ACC, #ets_scene_acc{scene_id = SceneId, _ = '_'}),
    F = fun(Acc) ->
        Acc#ets_scene_acc.acc < ?ACC_LIM andalso is_pid(Acc#ets_scene_acc.copy)
        end,
    case lists:filter(F, L) of
        [] -> false;
        [SceneAcc | _] ->
            Key = ?MAKE_KEY(SceneId, Copy),
            ets:insert(?ETS_SCENE_ACC, SceneAcc#ets_scene_acc{acc = SceneAcc#ets_scene_acc.acc + 1}),
            ets:insert(?ETS_SCENE_PID, #ets_scene_pid{key = Key, pid = SceneAcc#ets_scene_acc.pid}),
            true
    end.
