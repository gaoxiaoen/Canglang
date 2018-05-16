%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. 一月 2018 15:20
%%%-------------------------------------------------------------------
-module(elite_boss_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("elite_boss.hrl").
-include("scene.hrl").

%% API
-export([
    sys_init/0,
    sys_init_data/1,
    init_boss_data/1
]).

sys_init() ->
    ets:new(?ETS_ELITE_BOSS, [{keypos, #elite_boss.scene_id} | ?ETS_OPTIONS]),
    Ref = erlang:send_after(?ELITE_BOSS_NOTICE_TIME*1000, self(), update_boss_notice),
    StEliteBoss = #st_elite_boss{ref = Ref},
    erlang:send_after(20000, self(), make_init_back),
    StEliteBoss.

sys_init_data(StEliteBoss) ->
    AllSceneId = data_elite_boss:get_all_scene_id(),
    IsCenter = config:is_center_node(),
    F = fun(SceneId) ->
        case IsCenter of
            true ->
                case scene:is_cross_elite_boss_scene(SceneId) of
                    true ->
                        EliteBoss = data_elite_boss:get_by_scene(SceneId),
                        NewEliteBoss = init_boss_data(EliteBoss),
                        [NewEliteBoss];
                    false ->
                        []
                end;
            false ->
                case scene:is_elite_boss_scene(SceneId) of
                    false ->
                        [];
                    true ->
                        EliteBoss = data_elite_boss:get_by_scene(SceneId),
                        NewEliteBoss = init_boss_data(EliteBoss),
                        [NewEliteBoss]
                end
        end
    end,
    AllEliteBossList = lists:flatmap(F, AllSceneId),
    StEliteBoss#st_elite_boss{elite_boss_list = AllEliteBossList}.

init_boss_data(EliteBoss) ->
    #elite_boss{
        scene_id = SceneId,
        boss_id = BossId,
        pid = OldPid,
        ref = Ref,
        x = X,
        y = Y
    } = EliteBoss,
    util:cancel_ref([Ref]),
    %% 新的怪物刷新，确保旧的怪物一定死
    case misc:is_process_alive(OldPid) of
        true -> %% 关闭当前还存活的怪物进程
            monster:stop_broadcast(OldPid);
        false ->
            skip
    end,
    Boss = data_mon:get(BossId),
%%     ?ERR("Now:~p SceneId:~p BossId:~p", [util:unixtime(), SceneId, BossId]),
    {Key, Pid} = mon_agent:create_mon([BossId, SceneId, X, Y, 0, 1, [{return_id_pid, true}]]),
    EliteBoss#elite_boss{
        key = Key,
        pid = Pid,
        hp = Boss#mon.hp_lim,
        hp_lim = Boss#mon.hp_lim,
        damage_list = [],
        kill_pkey = 0,
        boss_state = ?ELITE_BOSS_OPEN,
        ref = [],
        next_bron_time = 0
    }.