%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 场景功能
%%% @end
%%% Created : 16. 一月 2015 下午5:05
%%%-------------------------------------------------------------------
-module(scene).
-author("fancy").

-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("task.hrl").
-include("pet.hrl").
-include("cross_battlefield.hrl").
-include("designation.hrl").
-include("field_boss.hrl").
-include("sword_pool.hrl").
-include("battle.hrl").
-include("cross_scuffle.hrl").
-include("cross_scuffle_elite.hrl").
-include("daily.hrl").
-include("guild.hrl").

-export([
    get_scene_pid/2,
    get_scene_worker/1,
    put_battle_delay_pid/1,
    get_battle_delay_pid/0,
    is_broadcast_scene/1,
    can_moved/3,
    can_moved2/3,
    player_to_scene_player/1,
    in_which_scene/11,
    is_dungeon_scene/1,
    is_hunt_scene/1,
    is_normal_scene/1,
    is_field_boss_scene/1,
    is_cross_field_boss_scene/1,
    is_battlefield_scene/1,
    is_cross_battlefield_scene/1,
    is_cross_scene/1,
    is_cross_scene_type/1,
    is_cross_boss_scene/1,
    is_dun_marry_scene/1,
    is_six_dragon_scene/1,
    is_six_dragon_wait_scene/1,
    is_cross_elite_scene/1,
    is_cross_war_scene/1,
    is_guild_war_scene/1,
    is_cross_normal_scene/1,
    is_answer_scene/1,
    is_cross_arena_scene/1,
    is_cross_eliminate_scene/1,
    is_prison_scene/1,
    is_cross_scuffle_scene/1,
    is_cross_scuffle_elite_scene/1,
    is_cross_scuffle_elite_ready_scene/1,
    is_cross_dark_blibe/1,
    check_cross_scene_type/1,
    check_normal_scene_cross_state/1,
    is_scene_cross_all/1,
    is_scene_cross_area/1,
    is_scene_cross_war_area/1,
    is_cross_1vn_ready_scene/1,
    is_cross_1vn_war_scene/1,
    is_cross_1vn_final_ready_scene/1,
    is_cross_1vn_final_war_scene/1,
    is_cross_1vn_scene/1,
    random_xy/3,
    get_scene_name/1,
    get_area_position_list/4,
    get_area_position_list/3,
    get_drop_area_list/4,
    get_scene_type/1,
    is_hot_well_scene/1,
    is_cross_1vn_war_all_scene/1,
    is_cross_1vn_ready_all_scene/1,
    is_elite_boss_scene/1,
    is_cross_elite_boss_scene/1,
    is_elite_vip_boss_scene/1,
    is_guild_scene/1
]).

-export([
    create_fix/2
]).
%% 获取场景进程
%% return none/错误 | ?SCENE_TYPE_CROSS/转发到跨服 | pid/场景进程
get_scene_pid(Scene, Copy) ->
    case get(?SCENE_PID(Scene, Copy)) of
        undefined ->
            case data_scene:get(Scene) of
                [] ->
                    none;
                _SceneData ->
                    GetProcess =
                        case check_cross_scene_type(Scene) of
                            ?SCENE_TYPE_CROSS_All ->
                                ?IF_ELSE(config:is_center_node(), true, ?SCENE_TYPE_CROSS_All);
                            ?SCENE_TYPE_CROSS_AREA ->
                                ?IF_ELSE(config:is_center_node(), true, ?SCENE_TYPE_CROSS_AREA);
                            ?SCENE_TYPE_CROSS_WAR_AREA ->
                                ?IF_ELSE(config:is_center_node(), true, ?SCENE_TYPE_CROSS_WAR_AREA);
                            false ->
                                true
                        end,
                    case GetProcess of
                        true ->
                            case misc:get_scene_process(Scene, Copy) of
                                Pid when is_pid(Pid) ->
                                    put(?SCENE_PID(Scene, Copy), Pid),
                                    Pid;
                                _ ->
                                    none
                            end;
                        _ ->
                            GetProcess
                    end
            end;
        Pid -> Pid
    end.

%% 获取场景worker进程
get_scene_worker(_Scene) ->
    WorkerPid = scene_agent:rank_worker_pid(),
    case is_pid(WorkerPid) of
        true ->
            WorkerPid;
        false ->
            self()
    end.


put_battle_delay_pid(Pid) ->
    put(battle_delay_pid, Pid).
get_battle_delay_pid() ->
    get(battle_delay_pid).

%%转换场景玩家数据
player_to_scene_player(Player) ->
    IsScuffleScene = scene:is_cross_scuffle_scene(Player#player.scene),
    IsScuffleEliteScene = scene:is_cross_scuffle_elite_scene(Player#player.scene),
    P =
        case is_cross_eliminate_scene(Player#player.scene)
            orelse is_cross_arena_scene(Player#player.scene)
            orelse is_arena_scene(Player#player.scene)
            orelse IsScuffleScene
            orelse IsScuffleEliteScene of
            false ->
                Player;
            true ->
                Player#player{pet = #fpet{}}
        end,
    {Design, Node} =
        case scene:is_cross_scene(Player#player.scene) of
            false -> {Player#player.design, none};
            true ->
                {Player#player.design, node()}
        end,
    {BuffList, MagicWeaponId, GodWeaponId, PassiveSkill, CatId} =
        case IsScuffleScene orelse IsScuffleEliteScene of
            true -> {[], 0, 0, P#player.scuffle_passive_skill, 0};
            false ->
                {P#player.buff_list, P#player.magic_weapon_id, P#player.god_weapon_id, P#player.passive_skill, P#player.cat_id}
        end,
    FieldBossTimes = daily:get_count(?DAILY_FIELD_BOSS),
    #scene_player{
        node = Node,
        key = P#player.key,
        sn = P#player.sn,
        sn_cur = P#player.sn_cur,
        sn_name = P#player.sn_name,
        pf = P#player.pf,
        nickname = P#player.nickname,
        avatar = P#player.avatar,
        career = P#player.career,
        sex = P#player.sex,
        lv = P#player.lv,
        copy = P#player.copy,
        scene = P#player.scene,
        x = P#player.x,
        y = P#player.y,
        pid = P#player.pid,
        sid = P#player.sid,
        hp = P#player.hp,
        mp = P#player.mp,
        sin = P#player.sin,
        cbp = P#player.cbp,
        attribute = P#player.attribute,
        scuffle_attribute = P#player.scuffle_attribute,
        scuffle_elite_attribute = P#player.scuffle_elite_attribute,
        guild_key = P#player.guild#st_guild.guild_key,
        guild_name = P#player.guild#st_guild.guild_name,
        guild_position = P#player.guild#st_guild.guild_position,
        convoy_state = P#player.convoy_state,
        convoy_rob = task_convoy:get_rob_times(),
        mount_id = P#player.mount_id,
        teamkey = P#player.team_key,
        team = P#player.team,
        team_leader = P#player.team_leader,
        figure = P#player.figure,
        pet = #scene_pet{
            type_id = P#player.pet#fpet.type_id,
            name = P#player.pet#fpet.name,
            figure = P#player.pet#fpet.figure,
            star = P#player.pet#fpet.star,
            stage = P#player.pet#fpet.stage,
            skill = P#player.pet#fpet.skill,
            att_param = P#player.pet#fpet.att_param
        },
        baby = #scene_baby{
            type_id = P#player.baby#fbaby.type_id,
            name = P#player.baby#fbaby.name,
            figure = P#player.baby#fbaby.figure,
            step = P#player.baby#fbaby.step,
            lv = P#player.baby#fbaby.lv,
            skill = P#player.baby#fbaby.skill
        },
        design = Design,
        wing_id = P#player.wing_id,
        baby_wing_id = P#player.baby_wing_id,
        baby_mount_id = P#player.baby_mount_id,
        baby_weapon_id = P#player.baby_weapon_id,
        sprite_lv = P#player.sprite_lv,
        light_weapon_id = P#player.light_weaponid,
        fashion = P#player.fashion,
        equip_figure = P#player.equip_figure,
        halo_id = P#player.max_stren_lv,
        group = P#player.group,
        pk = P#player.pk,
        vip = P#player.vip_lv,
        vip_state = P#player.vip_state,
        combo = P#player.combo,
        bf_score = P#player.bf_score,
        scene_face = P#player.scene_face,
        battle_info = #batt_info{buff_list = BuffList, time_mark = P#player.time_mark},
        eliminate_group = P#player.eliminate_group,
        cw_leader = P#player.cw_leader,
        commom_mount_pkey = P#player.common_riding#common_riding.common_pkey,
        main_mount_pkey = P#player.common_riding#common_riding.main_pkey,
        commom_mount_state = P#player.common_riding#common_riding.state,
        sword_pool_figure = P#player.sword_pool_figure,
        passive_skill = PassiveSkill,
        magic_weapon_id = MagicWeaponId,
        magic_weapon_skill = P#player.magic_weapon_skill,
        god_weapon_id = GodWeaponId,
        god_weapon_skill = P#player.god_weapon_skill,
        footprint_id = P#player.footprint_id,
        is_view = P#player.is_view,
        hot_well = P#player.hot_well,
        cat_id = CatId,
        golden_body_id = P#player.golden_body_id,
        god_treasure_id = P#player.god_treasure_id,
        jade_id = P#player.jade_id,
        marry = P#player.marry,
        marry_ring_lv = P#player.marry_ring_lv,
        new_career = P#player.new_career,
        dvip_type = P#player.d_vip#dvip.vip_type,
        skill_effect = P#player.skill_effect,
        xian_stage = P#player.xian_stage,
        xian_skill = P#player.xian_skill,
        war_team_key = P#player.war_team#st_war_team.war_team_key,
        war_team_name = P#player.war_team#st_war_team.war_team_name,
        war_team_position = P#player.war_team#st_war_team.war_team_position,
        field_boss_times = FieldBossTimes,
        show_golden_body = P#player.show_golden_body
    }.

%%获取场景类型
get_scene_type(Scene) ->
    Key = {scenetype, Scene},
    case get(Key) of
        undefined ->
            SceneType =
                case data_scene:get(Scene) of
                    [] -> 9999;
                    DataScene ->
                        DataScene#scene.type
                end,
            put(Key, SceneType),
            SceneType;
        SceneType ->
            SceneType
    end.

%%是否全场景广播
is_broadcast_scene(SceneId) ->
    if
        SceneId == ?SCENE_ID_KINDOM_GUARD_ID -> false;  %%王城守卫特殊处理
        true ->
            Type = get_scene_type(SceneId),
            lists:member(Type, [?SCENE_TYPE_DUNGEON, ?SCENE_TYPE_CROSS_ELITE,
                ?SCENE_TYPE_CROSS_ELIMINATE, ?SCENE_TYPE_CROSS_FIELD_BOSS,
                ?SCENE_TYPE_FIELD_BOSS, ?SCENE_TYPE_MARRY, ?SCENE_TYPE_CROSS_DUN, ?SCENE_TYPE_CROSS_ANSWER, ?SCENE_TYPE_CROSS_GUARD_DUN,
                ?SCENE_TYPE_HOT_WELL, ?SCENE_TYPE_CROSS_SIX_DRAGON_FIGHT, ?SCENE_TYPE_CROSS_1VN_WAR, ?SCENE_TYPE_CROSS_1VN_FINAL_WAR])
    end.

%%是否普通野外场景
is_normal_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_NORMAL.

is_field_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_FIELD_BOSS orelse Type == ?SCENE_TYPE_CROSS_FIELD_BOSS.

is_cross_field_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_FIELD_BOSS.


%%是否战场场景
is_battlefield_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_BATTLEFIELD.

%%是否跨服战场
is_cross_battlefield_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_BATTLEFIELD.

%%是否温泉
is_hot_well_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_HOT_WELL.


%%是跨服1vn资格赛准备场景
is_cross_1vn_ready_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_READY.

%%是跨服1vn资格赛战斗场景
is_cross_1vn_war_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_WAR.

%%是跨服1vn决赛准备场景
is_cross_1vn_final_ready_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_FINAL_READY.

%%是跨服1vn决赛战斗场景
is_cross_1vn_final_war_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_FINAL_WAR.

%% 是否跨服1vn场景
is_cross_1vn_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    case lists:member(Type, ?SCENE_TYPE_CROSS_1VN_LIST) of
        false -> false;
        true -> true
    end.

%% 是否跨服1vn战斗场景
is_cross_1vn_war_all_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_FINAL_WAR orelse Type == ?SCENE_TYPE_CROSS_1VN_WAR.

%% 是否跨服1vn准备场景
is_cross_1vn_ready_all_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_1VN_READY orelse Type == ?SCENE_TYPE_CROSS_1VN_FINAL_READY.

is_elite_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_NEW_ELITE.

is_cross_elite_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_NEW_ELITE.

is_elite_vip_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == 100.

%%是否跨服场景
is_cross_scene(SceneId) ->
    case is_cross_scene_type(SceneId) of
        true -> true;
        false ->
            case check_normal_scene_cross_state(SceneId) of
                false -> false;
                _ -> true
            end
    end.

is_cross_scene_type(SceneId) ->
    Type = get_scene_type(SceneId),
    case lists:member(Type, ?SCENE_TYPE_CROSS_AREA_LIST) orelse lists:member(Type, ?SCENE_TYPE_CROSS_ALL_LIST) orelse lists:member(Type, ?SCENE_TYPE_CROSS_WAR_AREA_LIST) of
        true -> true;
        false ->
            false
    end.


%%全平台跨服场景
is_scene_cross_all(SceneId) ->
    Type = get_scene_type(SceneId),
    case lists:member(Type, ?SCENE_TYPE_CROSS_ALL_LIST) of
        true -> true;
        false ->
            case check_normal_scene_cross_state(SceneId) of
                false -> false;
                _ -> true
            end
    end.

%%全平台跨服场景
is_scene_cross_area(SceneId) ->
    Type = get_scene_type(SceneId),
    lists:member(Type, ?SCENE_TYPE_CROSS_AREA_LIST).

is_scene_cross_war_area(SceneId) ->
    Type = get_scene_type(SceneId),
    lists:member(Type, ?SCENE_TYPE_CROSS_WAR_AREA_LIST).


check_cross_scene_type(SceneId) ->
    Type = get_scene_type(SceneId),
    case lists:member(Type, ?SCENE_TYPE_CROSS_AREA_LIST) of
        false ->
            case lists:member(Type, ?SCENE_TYPE_CROSS_ALL_LIST) of
                false ->
                    case lists:member(Type, ?SCENE_TYPE_CROSS_WAR_AREA_LIST) of
                        false ->
                            check_normal_scene_cross_state(SceneId);
                        true ->
                            ?SCENE_TYPE_CROSS_WAR_AREA
                    end;
                true -> ?SCENE_TYPE_CROSS_All
            end;
        true -> ?SCENE_TYPE_CROSS_AREA
    end.

%%检查普通场景跨服状态
check_normal_scene_cross_state(SceneId) ->
    case lists:member(SceneId, ?SCENE_ID_NORMAL_CROSS_LIST) of
        true ->
            case cross_all:check_cross_all_state() of
                true ->
                    ?SCENE_TYPE_CROSS_All;
                false -> false
            end;
        false -> false
    end.

%% 跨服罪恶深渊
is_cross_dark_blibe(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_DARK_BLIBE.


%%是否跨服boss场景
is_cross_boss_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_BOSS.

%%是否跨服elite场景
is_cross_elite_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_ELITE.

%%是否跨服乱斗场景
is_cross_scuffle_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_SCUFFLE.


%%是否跨服乱斗精英赛场景
is_cross_scuffle_elite_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_SCUFFLE_ELITE.

%%是否跨服乱斗精英赛准备场景
is_cross_scuffle_elite_ready_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_SCUFFLE_READY.


%%是否城战场景
is_cross_war_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_WAR.

%%是否六龙争霸战斗场景
is_six_dragon_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_SIX_DRAGON_FIGHT.

%%是否六龙争霸战斗场景
is_six_dragon_wait_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_CROSS_SIX_DRAGON.

%%是否跨服普通地图
is_cross_normal_scene(SceneId) ->
    lists:member(SceneId, data_scene_cross:ids()).

%%是否答题场景
is_answer_scene(SceneId) ->
    SceneId == ?SCENE_ID_ANSWER.

%%是否爱情试炼场景
is_dun_marry_scene(SceneId) ->
    SceneId == ?SCENE_ID_DUN_MARRY.

%%是否跨服竞技场
is_cross_arena_scene(SceneId) ->
    SceneId == ?SCENE_ID_CROSS_ARENA.

%%是否竞技场
is_arena_scene(SceneId) ->
    SceneId == ?SCENE_ID_ARENA.

is_cross_eliminate_scene(SceneId) ->
    SceneId == ?SCENE_ID_CROSS_ELIMINATE.

%%是否监狱场景
is_prison_scene(SceneId) ->
    SceneId == ?SCENE_ID_PRISON.

%%判断是否副本场景
is_dungeon_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_DUNGEON.


%%判断是否副本场景
is_hunt_scene(SceneId) ->
    Type = get_scene_type(SceneId),
    Type == ?SCENE_TYPE_HUNT.

%%是否仙盟战场景
is_guild_war_scene(SceneId) ->
    SceneId == ?SCENE_ID_GUILD_WAR.

is_guild_scene(SceneId) ->
    SceneId == ?SCENE_ID_GUILD.

%%坐标点是否可以移动
%% true  可走  | false 不可走
can_moved(SceneId, X, Y) ->
    case scene_mark:is_blocked({SceneId, X, Y}) of
        true ->
            false;
        false ->
            case data_scene:get(SceneId) of
                [] ->
                    true;
                Data ->
                    X > 0 andalso Y > 0 andalso Data#scene.width div 60 > X andalso Data#scene.height div 30 > Y
            end
    end.
%%是否能移动 障碍区+跳跃区
can_moved2(SceneId, X, Y) ->
    case scene_mark:is_blocked2({SceneId, X, Y}) of
        true ->
            false;
        false ->
            case data_scene:get(SceneId) of
                [] ->
                    true;
                Data ->
                    X > 0 andalso Y > 0 andalso Data#scene.width div 60 > X andalso Data#scene.height div 30 > Y
            end
    end.

%% 登陆玩家场景判断
in_which_scene(Pkey, Scene, X, Y, Pk, Sid, PkVal, OldScene, OldX, OldY, OldScenePk) ->
    Default =
        fun() ->
            case is_normal_scene(OldScene) andalso OldX > 0 andalso OldY > 0 andalso can_moved(OldScene, OldX, OldY) of
                true ->
                    Copy = scene_copy_proc:get_scene_copy(OldScene, 0),
                    #ets_back{scene = OldScene, copy = Copy, x = OldX, y = OldY, pk = OldScenePk};
                false ->
                    Scene2 = hd(data_scene:get_all_scene_id()),
                    DataScene2 = data_scene:get(Scene2),
                    X2 = DataScene2#scene.x,
                    Y2 = DataScene2#scene.y,
                    Copy = scene_copy_proc:get_scene_copy(Scene2, 0),
                    #ets_back{scene = Scene2, copy = Copy, x = X2, y = Y2, pk = ?PK_TYPE_PEACE}
            end
        end,
    case data_scene:get(Scene) of
        [] ->
            Default();
        DataScene ->
            PrisonRedVal = prison:get_red_name_val(),
            if
                DataScene#scene.type == ?SCENE_TYPE_DUNGEON ->
                    case dungeon_record:get(Pkey) of
                        [] ->
                            case DataScene#scene.sid of
                                ?SCENE_ID_KINDOM_GUARD_ID ->
                                    Copy = kindom_guard:get_enter_dun_copy(Pkey),
                                    case is_pid(Copy) of
                                        false -> Default();
                                        true ->
                                            #ets_back{scene = ?SCENE_ID_KINDOM_GUARD_ID, copy = Copy, x = DataScene#scene.x, y = DataScene#scene.y, pk = Pk}
                                    end;
                                _ ->
                                    Default()
                            end;
                        DR ->
                            case misc:is_process_alive(DR#dungeon_record.dungeon_pid) of
                                true ->
                                    DR#dungeon_record.dungeon_pid ! {back, Pkey, self()},
                                    #ets_back{scene = DR#dungeon_record.dun_id, copy = DR#dungeon_record.dungeon_pid, x = X, y = Y, pk = Pk};
                                false ->
                                    dungeon_record:erase(Pkey),
                                    [DunId, Copy, DunX, DunY] = DR#dungeon_record.out,
                                    case is_pid(Copy) of
                                        true ->
                                            Default();
                                        false ->
                                            #ets_back{scene = DunId, copy = Copy, x = DunX, y = DunY, pk = Pk}
                                    end
                            end
                    end;
                DataScene#scene.type == ?SCENE_TYPE_CROSS_DUN ->
                    case dungeon_record:get(Pkey) of
                        [] ->
                            Default();
                        DR ->
                            cross_all:apply(cross_dungeon, back, [Pkey, self(), Sid, DR#dungeon_record.dungeon_pid]),
                            #ets_back{scene = DR#dungeon_record.dun_id, copy = DR#dungeon_record.dungeon_pid, x = X, y = Y, pk = Pk}
                    end;
                DataScene#scene.type == ?SCENE_TYPE_CROSS_GUARD_DUN ->
                    case dungeon_record:get(Pkey) of
                        [] ->
                            Default();
                        DR ->
                            cross_all:apply(cross_dungeon_guard, back, [Pkey, self(), Sid, DR#dungeon_record.dungeon_pid]),
                            #ets_back{scene = DR#dungeon_record.dun_id, copy = DR#dungeon_record.dungeon_pid, x = X, y = Y, pk = Pk, group = 9}
                    end;
                DataScene#scene.type == ?SCENE_TYPE_CROSS_SCUFFLE_READY ->
                    case cross_all:apply_call(cross_scuffle_elite, get_state, []) of
                        {State, _} ->
                            case State of
                                ?CROSS_SCUFFLE_ELITE_STATE_CLOSE ->
                                    Default();
                                _ ->
                                    case can_moved(Scene, X, Y) of
                                        true ->
                                            Copy = scene_copy_proc:get_scene_copy(Scene, 0),
                                            #ets_back{scene = Scene, copy = Copy, x = X, y = Y, pk = Pk};
                                        false ->
                                            Default()
                                    end
                            end;
                        _ -> Default()
                    end;
                DataScene#scene.type == ?SCENE_TYPE_GUILD_WAR ->
                    case ?CALL(guild_war_proc:get_server_pid(), {back, Pkey}) of
                        [] ->
                            Default();
                        {true, Figure, Group} ->
                            #ets_back{scene = Scene, copy = 0, x = X, y = Y, pk = Pk, figure = Figure, group = Group};
                        {false, NewScene, NewCopy, NewX, NewY} ->
                            #ets_back{scene = NewScene, copy = NewCopy, x = NewX, y = NewY, pk = ?PK_TYPE_PEACE}
                    end;
                DataScene#scene.type == ?SCENE_TYPE_HOT_WELL ->
                    case cross_area:apply_call(hot_well, get_state_call, []) of
                        1 ->
                            {SceneId1, Copy1, X1, Y1} = hot_well:back(Pkey),
                            #ets_back{scene = SceneId1, copy = Copy1, x = X1, y = Y1, pk = ?PK_TYPE_PEACE};
                        _ -> Default()
                    end;
                DataScene#scene.type == ?SCENE_TYPE_HUNT orelse
                    DataScene#scene.type == ?SCENE_TYPE_BATTLEFIELD orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_BATTLEFIELD orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_BOSS orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_ELITE orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_NORMAL orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_ANSWER orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_ARENA orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_ELIMINATE orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_WAR orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_SIX_DRAGON_FIGHT orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_SIX_DRAGON orelse
                    DataScene#scene.type == ?SCENE_TYPE_FIELD_BOSS orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_1VN_READY orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_1VN_WAR orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_1VN_FINAL_READY orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_1VN_FINAL_WAR orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_NEW_ELITE orelse
                    DataScene#scene.type == ?SCENE_TYPE_NEW_ELITE orelse
                    DataScene#scene.type == ?SCENE_TYPE_CROSS_DARK_BLIBE ->
                    Default();
                DataScene#scene.type == ?SCENE_TYPE_MARRY ->
                    Default();
                DataScene#scene.type == ?SCENE_TYPE_PRISON andalso PkVal < PrisonRedVal ->
                    Default();
                DataScene#scene.type == ?SCENE_TYPE_CROSS_SCUFFLE ->
                    case ets:lookup(?ETS_CROSS_SCUFFLE_RECORD, Pkey) of
                        [] ->
                            Default();
                        [Record] ->
                            Now = util:unixtime(),
                            if Now > Record#ets_cross_scuffle_record.time -> Default();
                                true ->
                                    cross_all:apply(cross_scuffle_play, back, [Pkey, self(), Record#ets_cross_scuffle_record.pid]),
                                    #ets_back{scene = Scene, copy = Record#ets_cross_scuffle_record.pid, x = X, y = Y, pk = Pk,
                                        figure = Record#ets_cross_scuffle_record.figure, group = Record#ets_cross_scuffle_record.group}
                            end
                    end;
                DataScene#scene.type == ?SCENE_TYPE_CROSS_SCUFFLE_ELITE -> Default();

                DataScene#scene.type == ?SCENE_TYPE_GUILD ->
                    case guild_ets:get_guild_member(Pkey) of
                        false ->
                            Default();
                        #g_member{gkey = Gkey} ->
                            #ets_back{scene = ?SCENE_ID_GUILD, copy = Gkey, x = X, y = Y}
                    end;
%%                     case ets:lookup(?ETS_CROSS_SCUFFLE_ELITE_RECORD, Pkey) of
%%                         [] ->
%%                             Default();
%%                         [Record] ->
%%                             Now = util:unixtime(),
%%                             if Now > Record#ets_cross_scuffle_elite_record.time -> Default();
%%                                 true ->
%%                                     cross_all:apply(cross_scuffle_elite_play, back, [Pkey, self(), Record#ets_cross_scuffle_elite_record.pid]),
%%                                     #ets_back{scene = Scene, copy = Record#ets_cross_scuffle_elite_record.pid, x = X, y = Y, pk = Pk,
%%                                         figure = Record#ets_cross_scuffle_elite_record.figure, group = Record#ets_cross_scuffle_elite_record.group}
%%                             end
%%                     end;
                true ->
                    case can_moved(Scene, X, Y) of
                        true ->
                            Copy = scene_copy_proc:get_scene_copy(Scene, 0),
                            #ets_back{scene = Scene, copy = Copy, x = X, y = Y, pk = Pk};
                        false ->
                            Default()
                    end
            end
    end.






random_xy(SceneId, X, Y) ->
    X1 = X + util:rand(-2, 2),
    Y1 = Y + util:rand(-2, 2),
    ?IF_ELSE(scene_mark:is_blocked2({SceneId, X1, Y1}), {X, Y}, {X1, Y1}).


%%获取场景名称
get_scene_name(SceneId) ->
    case data_scene:get(SceneId) of
        [] -> <<>>;
        Scene -> Scene#scene.name
    end.


create_fix(Mid, SceneId) ->
    F = fun([MId1, X, Y]) ->
        case MId1 == Mid of
            true ->
                mon_agent:create_mon([Mid, SceneId, X, Y, 0, 1, []]);
            _ ->
                skip
        end
    end,
    Scene = data_scene:get(SceneId),
    lists:foreach(F, Scene#scene.mon),
    ok.

%%获取坐标点区域坐标
get_area_position_list(SceneId, X, Y, Area) ->
    PosList = pos_loop(lists:seq(-Area, Area), SceneId, X, Y, Area, []),
    util:list_shuffle(util:list_filter_repeat(PosList)).

pos_loop([], _SceneId, _X, _Y, _Area, PosList) -> PosList;
pos_loop([Dx | T], SceneId, X, Y, Area, PosList) ->
    Pos = lists:map(fun(Dy) ->
        ?IF_ELSE(X + Dx < 0 orelse Y + Dy < 0 orelse scene_mark:is_blocked2({SceneId, X + Dx, Y + Dy}), {X, Y}, {X + Dx, Y + Dy})
    end,
        lists:seq(-Area, Area)),
    pos_loop(T, SceneId, X, Y, Area, Pos ++ PosList).

%%掉落坐标区域，从里到外
get_drop_area_list(SceneId, Monid, X, Y) ->
    case is_cross_boss_scene(SceneId) of
        false ->
            case is_cross_elite_boss_scene(SceneId) of
                true ->
                    get_elite_boss_drop_xy_list(SceneId, X, Y);
                false ->
                    case is_elite_boss_scene(SceneId) of
                        true ->
                            get_elite_boss_drop_xy_list(SceneId, X, Y);
                        false ->
                            get_area_position_list(SceneId, X, Y)
                    end
            end;
        true ->
            case data_cross_boss:get_xy(Monid) of
                [] ->
                    get_cross_boss_drop_xy_list(SceneId, X, Y);
                {NX, NY} ->
                    get_cross_boss_drop_xy_list(SceneId, NX, NY)
            end
    end.

get_area_position_list(SceneId, X, Y) ->
    F = fun({Dx, Dy}) ->
        Tx = X + Dx,
        Ty = Y + Dy,
        ?IF_ELSE(Tx < 0 orelse Ty < 0 orelse scene_mark:is_blocked2({SceneId, Tx, Ty}), {X, Y}, {Tx, Ty})
    end,
    lists:map(F, area_list()).

area_list() ->
    [
        {0, 1}, {1, 1},
        {1, 0}, {1, -1},
        {0, -1}, {-1, -1},
        {-1, 0}, {-1, 1}, {-1, 2},
        {0, 2}, {1, 2}, {2, 2},
        {2, 1}, {2, 0}, {2, -1}, {2, -2},
        {1, -2}, {0, -2}, {-1, -2}, {-2, -2},
        {-2, -1}, {-2, 0}, {-2, 1}, {-2, 2},
        {-2, 3}, {-1, 3}, {0, 3}, {1, 3}, {2, 3}, {3, 3},
        {3, 2}, {3, 1}, {3, 0}, {3, -1}, {3, -2}, {3, -3},
        {2, -3}, {1, -3}, {0, -3}, {-1, -3}, {-2, -3}, {-3, -3},
        {-3, -2}, {-3, -1}, {-3, 0}, {-3, 1}, {-3, 2}, {-3, 3},
        {-3, 4}, {-2, 4}, {-1, 4}, {0, 4}, {1, 4}, {2, 4}, {3, 4}, {4, 4},
        {4, 3}, {4, 2}, {4, 1}, {4, 0}, {4, -1}, {4, -2}, {4, -3}, {4, -4},
        {3, -4}, {2, -4}, {1, -4}, {0, -4}, {-1, -4}, {-2, -4}, {-3, -4}, {-4, -4},
        {-4, -3}, {-4, -2}, {-4, -1}, {-4, 0}, {-4, 1}, {-4, 2}, {-4, 3}, {-4, 4},
        {-4, 5}, {-3, 5}, {-2, 5}, {-1, 5}, {0, 5}, {1, 5}, {2, 5}, {3, 5}, {4, 5}, {5, 5}].

get_cross_boss_drop_xy_list(SceneId, X, Y) ->
    F0 = fun(XX) ->
        if
            XX rem 3 == 0 ->
                F1 = fun(YY) ->
                    if
                        YY rem 3 == 0 ->
                            case scene:can_moved(SceneId, XX, YY) of
                                true -> [{XX, YY}];
                                false -> []
                            end;
                        true -> []
                    end
                end,
                lists:flatmap(F1, lists:seq(max(0, Y - 3), Y + 6));
            true -> []
        end
    end,
    LL = lists:flatmap(F0, lists:seq(max(0, X - 6), X + 6)),
    NewLL =
        if
            LL == [] ->
                get_area_position_list(SceneId, X, Y);
            true ->
                LL
        end,
    util:list_shuffle(NewLL).

get_elite_boss_drop_xy_list(SceneId, X, Y) ->
    F0 = fun(XX) ->
        if
            XX rem 3 == 0 ->
                F1 = fun(YY) ->
                    if
                        YY rem 3 == 0 ->
                            case scene:can_moved(SceneId, XX, YY) of
                                true -> [{XX, YY}];
                                false -> []
                            end;
                        true -> []
                    end
                end,
                lists:flatmap(F1, lists:seq(max(0, Y - 3), Y + 6));
            true -> []
        end
    end,
    LL = lists:flatmap(F0, lists:seq(max(0, X - 5), X + 5)),
    NewLL =
        if
            LL == [] ->
                get_area_position_list(SceneId, X, Y);
            true ->
                LL
        end,
    util:list_shuffle(NewLL).