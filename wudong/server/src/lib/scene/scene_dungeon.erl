%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 副本进入处理
%%% @end
%%% Created : 18. 三月 2017 下午2:15
%%%-------------------------------------------------------------------
-module(scene_dungeon).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").
-include("dungeon.hrl").
-include("sword_pool.hrl").

%% API
-compile([export_all]).

check_and_enter_dungeon_scene(Player, TargetScene) ->
    IsDungeonTower = dungeon_util:is_dungeon_tower(Player#player.scene),
    IsDungeonFuwenTower = dungeon_util:is_dungeon_fuwen_tower(Player#player.scene),
    IsFuwenTargetScene = dungeon_util:is_dungeon_fuwen_tower(TargetScene),
    IsNormalScene = scene:is_normal_scene(Player#player.scene),
    IsDungeonGodWeapon = dungeon_util:is_dungeon_god_weapon(Player#player.scene),
    if
        IsDungeonFuwenTower andalso IsFuwenTargetScene ->
            create_dungeon_scene(Player, TargetScene);
        IsDungeonTower orelse IsDungeonGodWeapon ->
            create_dungeon_scene(Player, TargetScene);
        IsNormalScene == false ->
            {false, ?T("普通野外场景才能进入副本!")};
        true ->
            case is_pid(Player#player.copy) andalso misc:is_process_alive(Player#player.copy) of
                true ->
                    enter_dungeon_scene(Player, TargetScene, Player#player.copy, 1);
                false ->
                    create_dungeon_scene(Player, TargetScene)
            end
    end.

create_dungeon_scene(Player, TargetScene) ->
    case data_dungeon:get(TargetScene#scene.id) of
        [] ->
            {false, ?T("副本场景ID不存在!")};
        Dun ->
            case check_dungeon_condition(Player, Dun) of
                {false, Reason} ->
                    {false, Reason};
                true ->
                    Count = dungeon_util:get_dungeon_times(TargetScene#scene.id),
                    Extra = dungeon_extra(Player, TargetScene),
                    case (Dun#dungeon.count > 0 andalso Count >= Dun#dungeon.count) orelse (Dun#dungeon.count == 0 andalso Count /= 0) of
                        true ->
                            {false, ?T("今日副本可挑战次数已用完!")};
                        false ->
                            case kindom_guard:is_kindom_guard_dun(TargetScene#scene.id) of
                                true ->
                                    Res = kindom_guard:get_enter_dun_copy(Player#player.key),
                                    case is_pid(Res) of
                                        true ->
                                            enter_dungeon_scene(Player, TargetScene, Res, 1);
                                        false -> {false, Res}
                                    end;
                                false ->
                                    PlayerList =
                                        case scene:is_dun_marry_scene(TargetScene#scene.id) of
                                            true ->
                                                case player_util:get_player(Player#player.marry#marry.couple_key) of
                                                    [] -> [Player];
                                                    CouplePlayer -> [Player, CouplePlayer]
                                                end;
                                            false ->
                                                [Player]
                                        end,
                                    %%玩家创建副本进程
                                    Now = util:unixtime(),
                                    DunPlayerList = lists:map(fun(Player00) -> dungeon_util:make_dungeon_mb(Player00, Now) end, PlayerList),
                                    DunPid = dungeon:start(DunPlayerList, Dun#dungeon.id, Now, Extra),
                                    dungeon_marry:notice_ta(Player, TargetScene#scene.id, DunPid),
                                    enter_dungeon_scene(Player, TargetScene, DunPid, 1)
                            end
                    end
            end
    end.

dungeon_extra(Player, TargetScene) ->
    case dungeon_util:is_dungeon_material(TargetScene#scene.id) of
        true ->
            dungeon_material:get_enter_dungeon_extra(TargetScene#scene.id);
        false ->
            case dungeon_util:is_dungeon_exp(TargetScene#scene.id) of
                true ->
                    dungeon_exp:get_enter_dungeon_extra(TargetScene#scene.id);
                false ->
                    case dungeon_util:is_dungeon_daily(TargetScene#scene.id) of
                        true ->
                            dungeon_daily:get_enter_dungeon_extra(TargetScene#scene.id);
                        false ->
                            case dungeon_util:is_dungeon_demon(TargetScene#scene.id) of
                                true ->
                                    guild_demon:get_enter_dungeon_extra(Player);
                                false ->
                                    case dungeon_util:is_dungeon_god_weapon(TargetScene#scene.id) of
                                        true ->
                                            dungeon_god_weapon:get_enter_dungeon_extra(TargetScene#scene.id);
                                        false ->
                                            case dungeon_util:is_dungeon_guard(TargetScene#scene.id) of
                                                true ->
                                                    dungeon_guard:get_enter_dungeon_extra(Player, TargetScene#scene.id);
                                                false ->
                                                    []
                                            end
                                    end
                            end
                    end
            end
    end.

enter_dungeon_scene(Player, TargetScene, DunPid, _EnterType) ->
    case dungeon:check_enter(TargetScene#scene.id, DunPid) of
        {false, Msg} ->
            {false, Msg};
        {true, _ResId} ->
            [X, Y] = get_revive(Player, TargetScene),
            {true, Player, TargetScene#scene.id, DunPid, X, Y, TargetScene#scene.name, TargetScene#scene.sid}
    end.


get_revive(Player, TargetScene) ->
    case dungeon_util:is_dungeon_exp(TargetScene#scene.id) of
        false ->
            case dungeon_util:is_dungeon_god_weapon(TargetScene#scene.id) of
                false ->
                    case dungeon_util:is_dungeon_demon(TargetScene#scene.id) of
                        false -> [TargetScene#scene.x, TargetScene#scene.y];
                        true ->
                            case guild_demon:get_demon_round_xy(Player) of
                                [] -> [TargetScene#scene.x, TargetScene#scene.y];
                                Position -> Position
                            end
                    end;
                true ->
                    {Layer, Round} = dungeon_god_weapon:get_cur_layer(),
                    case data_dungeon_god_weapon:get_revive(Layer, Round) of
                        [] ->
                            [TargetScene#scene.x, TargetScene#scene.y];
                        Revive -> Revive
                    end
            end;
        true ->
            Round = dungeon_exp:get_enter_dungeon_round(),
            case data_dungeon_exp:get_revive(Round + 1) of
                [] ->
                    [TargetScene#scene.x, TargetScene#scene.y];
                %%经验副本每一波出生点有差异
                Revive -> Revive
            end
    end.

%%进入副本条件判断
check_dungeon_condition(Player, Dun) ->
    case lists:member(Dun#dungeon.type, ?DUNGEON_NORMAL_ENTRANCE) of
        false ->
            {false, ?T("不能从该处进入副本")};
        true ->
            case check_dungeon_condition_normal(Dun#dungeon.condition, Player) of
                true ->
                    dungeon_check(?DUNGEON_TYPE_MATERIAL, Player, Dun);
                {false, ErrReason} ->
                    {false, ErrReason}
            end
    end.


dungeon_check(?DUNGEON_TYPE_MATERIAL, Player, Dun) ->
    case dungeon_material:check_enter(Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_EXP, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;
dungeon_check(?DUNGEON_TYPE_EXP, Player, Dun) ->
    case dungeon_exp:check_enter(Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_GUILD_DEMON, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;
dungeon_check(?DUNGEON_TYPE_GUILD_DEMON, Player, Dun) ->
    case guild_demon:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_VIP, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;
dungeon_check(?DUNGEON_TYPE_VIP, Player, Dun) ->
    case dungeon_vip:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_FUWEN_TOWER, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;
dungeon_check(?DUNGEON_TYPE_FUWEN_TOWER, Player, Dun) ->
    case dungeon_fuwen_tower:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_GOD_WEAPON, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;
dungeon_check(?DUNGEON_TYPE_GOD_WEAPON, Player, Dun) ->
    case dungeon_god_weapon:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_GUARD, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_GUARD, Player, Dun) ->
    case dungeon_guard:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_MARRY, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_MARRY, Player, Dun) ->
    case dungeon_marry:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_EQUIP, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_EQUIP, Player, Dun) ->
    case dungeon_equip:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_XIAN, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_XIAN, Player, Dun) ->
    case dungeon_xian:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_GODNESS, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_GODNESS, Player, Dun) ->
    case dungeon_godness:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_ELITE_BOSS, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_ELITE_BOSS, Player, Dun) ->
    case dungeon_elite_boss:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_ELEMENT, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_ELEMENT, Player, Dun) ->
    case dungeon_element:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_JIANDAO, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;


dungeon_check(?DUNGEON_TYPE_JIANDAO, Player, Dun) ->
    case dungeon_jiandao:check_enter(Player, Dun#dungeon.id) of
        true ->
            dungeon_check(?DUNGEON_TYPE_NORMAL, Player, Dun);
        {false, ErrReason} ->
            {false, ErrReason}
    end;

dungeon_check(?DUNGEON_TYPE_NORMAL, _Player, _Dun) ->
    true.

check_dungeon_condition_normal([], _Player) -> true;
check_dungeon_condition_normal([{lvup, Lv} | T], Player) ->
    if Player#player.lv < Lv ->
        {false, ?T("等级不足，不能进入")};
        true ->
            check_dungeon_condition_normal(T, Player)
    end;
check_dungeon_condition_normal([{lvdown, Lv} | T], Player) ->
    if Player#player.lv > Lv ->
        {false, ?T("等级超过可进入等级，不能进入")};
        true ->
            check_dungeon_condition_normal(T, Player)
    end;
check_dungeon_condition_normal([Item | _T], _Player) ->
    {false, ?T(Item)}.

%%进入副本处理  所有的活动触发等 都在这里处理
enter_dungeon_handle(Player, SceneId, DunPid) ->
    TargetScene = data_scene:get(SceneId),
    BaseDungeon = data_dungeon:get(TargetScene#scene.id),
    %%活跃度、7天目标
    case BaseDungeon#dungeon.type of
%%                ?DUNGEON_TYPE_MATERIAL ->
%%                    dungeon_material:update_sword_pool(TargetScene#scene.id);

        ?DUNGEON_TYPE_KINDOM_GUARD ->
            kindom_guard:enter_kindom_guard(Player, DunPid);
        ?DUNGEON_TYPE_GUILD_DEMON ->
            guild_demon:enter_demon_dungeon(Player);
        ?DUNGEON_TYPE_EXP ->
            act_hi_fan_tian:trigger_finish_api(Player,3,1);
        _ ->
            skip
    end,
    Player.

%%退出副本
exit_dungeon(Player, ExitScene) ->
    BaseDungeon = data_dungeon:get(ExitScene),
    case BaseDungeon#dungeon.type of
        ?DUNGEON_TYPE_KINDOM_GUARD ->
            kindom_guard:exit_kindom_guard(Player);
        _ ->
            Player
    end.