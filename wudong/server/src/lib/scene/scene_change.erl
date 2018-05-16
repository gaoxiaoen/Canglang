%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 三月 2017 下午4:14
%%%-------------------------------------------------------------------
-module(scene_change).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("field_boss.hrl").
-include("sword_pool.hrl").
-include("manor_war.hrl").

%% API
-compile([export_all]).

%% 切换回上一次场景
change_scene_back(Player) ->
    {Scene, Copy, X, Y} = get_out(Player),
    change_scene(Player, Scene, Copy, X, Y, false).

%%无条件切换场景
%% Back 是否需要返回旧场景
change_scene(Player, TarScene) ->
    change_scene(Player, TarScene, 0).
change_scene(Player, TarScene, Copy) ->
    Scene = data_scene:get(TarScene),
    change_scene(Player, TarScene, Copy, Scene#scene.x, Scene#scene.y, true).
change_scene(Player, TarScene, TarCopy, TarX, TarY, Back) ->
    scene_agent_dispatch:leave_scene(Player),
    {SceneId, Copy, X, Y} =
        case Back of
            false ->
                {TarScene, TarCopy, TarX, TarY};
            true ->
                if
                    TarScene == Player#player.scene_old andalso Player#player.x_old > 0 andalso Player#player.y_old > 0 ->
                        {Player#player.scene_old, Player#player.copy_old, Player#player.x_old, Player#player.y_old};
                    true ->
                        {TarScene, TarCopy, TarX, TarY}
                end
        end,
    SceneData = data_scene:get(SceneId),
    {ok, Bin} = pt_120:write(12005, {SceneId, X, Y, SceneData#scene.sid, SceneData#scene.name}),
    server_send:send_to_sid(Player#player.sid, Bin),
    Player1 = Player#player{scene = SceneId, copy = Copy, x = X, y = Y, enter_sid_time = util:unixtime()},
    %%从普通场景进入，保留坐标和pk信息
    Player2 =
        case scene:is_normal_scene(Player#player.scene) of
            true ->
                Player1#player{
                    scene_old = Player#player.scene,
                    copy_old = Player#player.copy,
                    x_old = Player#player.x,
                    y_old = Player#player.y
                };
            false ->
                Player1
        end,

    %%气血处理
    Player3 = change_hpmp(Player2, SceneId),
    SceneType = scene:get_scene_type(SceneId),
    ExitSceenType = scene:get_scene_type(Player#player.scene),
    %%pk状态处理
    ManorWarOpenState =
        case config:get_open_days() < 4 of
            true -> ?MANOR_WAR_STATE_CLOSE;
            false -> ?CALL(manor_war_proc:get_server_pid(), get_state)
        end,
    if
        ManorWarOpenState == ?MANOR_WAR_STATE_START ->
            Player99 = Player3;
        true ->
            Player99 = change_pk(Player3, SceneId, Player#player.scene)
    end,
    %%其他特定场景处理
    IsGuildWarScene = scene:is_guild_war_scene(Player#player.scene),
    IsBattlefield = scene:is_battlefield_scene(Player#player.scene),
    IsWarScene = scene:is_cross_war_scene(Player#player.scene),
    IsAnswerScene = scene:is_answer_scene(Player#player.scene),
    %%进入场景处理
    ?DEBUG("SceneType:~p", [SceneType]),
    NewPlayer99 =
        if
            SceneType == ?SCENE_TYPE_DUNGEON ->  %%副本场景
                scene_dungeon:enter_dungeon_handle(Player99, SceneId, Copy);
            SceneType == ?SCENE_TYPE_FIELD_BOSS orelse SceneType == ?SCENE_TYPE_CROSS_FIELD_BOSS -> %%野外boss
                %%切换PK模式
                Boss = field_boss:get_ets_boss(SceneId),
                if
                    ManorWarOpenState == ?MANOR_WAR_STATE_START ->  %% 领地争霸战开启后,切换野外场景不更改攻击模式
                        sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_WORLD_BOSS),
                        field_boss:damage_info(Player),
                        Player99;
                    true ->
                        Pk =
                            case Boss#field_boss.is_pk == 1 of
                                true ->
                                    case Player#player.guild#st_guild.guild_key > 0 of
                                        true -> ?PK_TYPE_GUILD;
                                        false -> ?PK_TYPE_PEACE
                                    end;
                                false -> ?PK_TYPE_PEACE
                            end,
                        sword_pool:add_exp_by_type(Player#player.lv, ?SWORD_POOL_TYPE_WORLD_BOSS),
                        field_boss:damage_info(Player),
                        player_battle:pk_change_sys(Player99, Pk, 1)
                end;
            SceneType == ?SCENE_TYPE_PRISON -> %%监狱
                prison:enter_prison(Player99);
            IsGuildWarScene ->
                Player99_1 = Player99#player{group = 0, figure = 0},
                scene_agent_dispatch:figure(Player99_1),
                {ok, BinFigure} = pt_120:write(12025, {Player#player.key, Player99_1#player.figure, 0}),
                server_send:send_to_sid(Player#player.sid, BinFigure),
                Player99_1;
            IsBattlefield ->
                Player99_1 = Player99#player{combo = 0, group = 0, bf_score = 0},
                scene_agent_dispatch:battlefield(Player99_1),
                {ok, BinFigure} = pt_120:write(12032, {Player#player.key, 0, 0, 0}),
                server_send:send_to_sid(Player#player.sid, BinFigure),
                Player99_1;
            IsAnswerScene ->
                answer:exit_scene(Player99),
                Player99;
            IsWarScene ->
                %%TODO 形象处理
                Player99;
            true -> Player99
        end,
    %%退出场景处理
    NewPlayer =
        if
            ExitSceenType == ?SCENE_TYPE_PRISON ->
                prison:exit_prison(NewPlayer99);
            ExitSceenType == ?SCENE_TYPE_DUNGEON ->
                scene_dungeon:exit_dungeon(NewPlayer99, Player#player.scene);
            true ->
                NewPlayer99
        end,
    NewPlayer1 = mount:double_leave_scene(NewPlayer, SceneId, Copy, X, Y),%%检测是否是双人坐骑状态，如果是，另外一人要跟着跳转
    NewPlayer2 = player_evil:change_scene(NewPlayer1),
    cross_six_dragon:leave_wait_scene(Player, Player#player.scene),
    NewPlayer2.


%%切换场景,气血处理
change_hpmp(Player, TargetSceneId) ->
    %%气血处理
%%    EnterArena = dungeon_util:is_dungeon_arena(TargetSceneId),
    EnterElite = scene:is_cross_elite_scene(TargetSceneId),
    EnterCrossArena = scene:is_cross_arena_scene(TargetSceneId),
    EnterSixDragon = scene:is_six_dragon_scene(TargetSceneId),
    CrossScuffle = scene:is_cross_scuffle_elite_scene(TargetSceneId),
    CrossScuffleReady = scene:is_cross_scuffle_elite_ready_scene(TargetSceneId),
    EnterCrossBattle = scene:is_cross_battlefield_scene(TargetSceneId),
    IsCross1vn = scene:is_cross_1vn_scene(TargetSceneId),
    EnterTower = dungeon_util:is_dungeon_fuwen_tower(TargetSceneId),
    if
    %%进入竞技场满血,退出副本满血
        (EnterTower orelse EnterCrossBattle orelse EnterCrossArena orelse EnterElite orelse EnterSixDragon orelse CrossScuffle orelse CrossScuffleReady orelse IsCross1vn) andalso Player#player.hp < Player#player.attribute#attribute.hp_lim ->
               {ok, BinHp} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Player#player.attribute#attribute.hp_lim - Player#player.hp, Player#player.attribute#attribute.hp_lim]]}),
            server_send:send_to_sid(Player#player.sid, BinHp),
            PlayerHp = Player#player{hp = Player#player.attribute#attribute.hp_lim, mp = Player#player.attribute#attribute.mp_lim},
            if Player#player.hp =< 0 ->
                {ok, BinRevive} = pt_200:write(20010, {1, 0, PlayerHp#player.scene, PlayerHp#player.x, PlayerHp#player.y, PlayerHp#player.hp, PlayerHp#player.mp, PlayerHp#player.gold, PlayerHp#player.bgold, 0}),
                server_send:send_to_sid(Player#player.sid, BinRevive);
                true -> skip
            end,
            PlayerHp;
        Player#player.hp =< 0 ->
            Hp = round(Player#player.attribute#attribute.hp_lim * 0.3),
            {ok, BinHp} = pt_200:write(20004, {[[?SIGN_PLAYER, Player#player.key, 1, Hp, Hp]]}),
            server_send:send_to_sid(Player#player.sid, BinHp),
            PlayerHp = Player#player{hp = Hp},
            {ok, BinRevive} = pt_200:write(20010, {1, 0, PlayerHp#player.scene, PlayerHp#player.x, PlayerHp#player.y, PlayerHp#player.hp, PlayerHp#player.mp, PlayerHp#player.gold, PlayerHp#player.bgold, 0}),
            server_send:send_to_sid(Player#player.sid, BinRevive),
            PlayerHp;
        true ->
            Player
    end.

%%切换场景,pk处理
change_pk(Player, SceneId, LeaveSceneId) ->
    Scene = data_scene:get(SceneId),
    #scene{
        pk_change = PkChange
    } = Scene,
    %%恢复pk
    ChangePk1 =
        case data_scene:get(LeaveSceneId) of
            [] -> Player#player.pk#pk.pk;
            LeaveScene ->
                #scene{
                    pk_recover = PkRecover
                } = LeaveScene,
                case PkRecover == 1 of
                    true -> %%恢复
                        Player#player.old_scene_pk;
                    false ->
                        Player#player.pk#pk.pk
                end
        end,
    %%进入场景，强制切换pk
    ChangePk2 =
        case PkChange == -1 of
            true -> ChangePk1;
            false -> PkChange
        end,
    %%  需要手动切换的场景ID
    IsDark = scene:is_cross_dark_blibe(SceneId),
    Player2 =
        case ChangePk2 == Player#player.pk#pk.pk of
            true -> Player;
            false ->
                if IsDark -> Player;
                    true ->
                        player_battle:pk_change_sys(Player, ChangePk2, 1)
                end
        end,
    Player2#player{old_scene_pk = Player#player.pk#pk.pk}.

%%获取上一场景坐标
get_out(Player) ->
    #player{
        x_old = X,
        y_old = Y,
        copy_old = Copy,
        scene_old = Scene
    } = Player,
    case Scene > 0 andalso X > 0 andalso Y > 0 of
        false ->
            Scene2 = ?SCENE_ID_MAIN,
            DataScene2 = data_scene:get(Scene2),
            X2 = DataScene2#scene.x,
            Y2 = DataScene2#scene.y,
            Copy2 = scene_copy_proc:get_scene_copy(Scene2, 0),
            {Scene2, Copy2, X2, Y2};
        true ->
            Copy2 = scene_copy_proc:get_scene_copy(Scene, Copy),
            {Scene, Copy2, X, Y}
    end.
