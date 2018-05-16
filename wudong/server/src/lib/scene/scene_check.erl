%%%-------------------------------------------------------------------
%%% @author fengzhenlin
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%% 进出场景检查
%%% @end
%%% Created : 18. 三月 2017 下午4:32
%%%-------------------------------------------------------------------
-module(scene_check).
-author("fengzhenlin").
-include("common.hrl").
-include("server.hrl").
-include("scene.hrl").

%% API
-compile([export_all]).

%% 场景进入检查
check_enter(Player, Scene, Copy) ->
    PlayerScene =
        case data_scene:get(Player#player.scene) of
            [] -> #scene{};
            S -> S
        end,
    case data_scene:get(Scene) of
        [] ->
            {false, ?T("场景出错!")};
        TargetScene ->
            ?DEBUG("TargetScene#scene.type  ~p~n", [TargetScene#scene.type]),
            case check_enter_lv(Player#player.lv, TargetScene) of
                ok ->
%%                     ?DEBUG("TargetScene:~p~n", [TargetScene]),
                    check_enter(scene_type, Player, PlayerScene, TargetScene, Copy);
                Res ->
                    Res
            end
    end.

check_enter_lv(Plv, Scene) ->
    case lists:keyfind(lv, 1, Scene#scene.require) of
        false -> ok;
        {_, Lv} ->
            if
                Plv < Lv ->
                    {false, io_lib:format(?T("~p级才可进入该场景"), [Lv])};
                true ->
                    ok
            end
    end.

%%进入副本
check_enter(scene_type, Player, _PlayerScene, TargetScene, _Copy) when TargetScene#scene.type == ?SCENE_TYPE_DUNGEON ->
    if Player#player.convoy_state > 0 ->
        {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            scene_dungeon:check_and_enter_dungeon_scene(Player, TargetScene)
    end;

%%进入仙盟领地
check_enter(scene_type, Player, _PlayerScene, TargetScene, _Copy) when TargetScene#scene.type == ?SCENE_TYPE_GUILD ->
    if Player#player.guild#st_guild.guild_key == 0 ->
        {false, ?T("你没有加入仙盟,不能进入")};
        true ->
            case scene:is_normal_scene(Player#player.scene) of
                false -> {false, ?T("普通野外场景才能进入挑战")};
                true ->
                    {true, Player, TargetScene#scene.id, Player#player.guild#st_guild.guild_key, TargetScene#scene.x, TargetScene#scene.y, TargetScene#scene.name, TargetScene#scene.sid}
            end
    end;
%%退出仙盟领地
check_enter(scene_type, Player, _PlayerScene, _TargetScene, _Copy) when _PlayerScene#scene.type == ?SCENE_TYPE_GUILD ->
    {Scene, Copy, X, Y} = scene_change:get_out(Player),
    TargetScene = data_scene:get(Scene),
    {true, Player, Scene, Copy, X, Y, TargetScene#scene.name, TargetScene#scene.sid};

%%进入野外boss场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when (TargetScene#scene.type == ?SCENE_TYPE_FIELD_BOSS orelse TargetScene#scene.type == ?SCENE_TYPE_CROSS_FIELD_BOSS) ->
    enter_field_boss_scene(Player, TargetScene, Copy);

%%进入跨服普通地图
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_CROSS_NORMAL ->
    ?DEBUG("TargetScene ~p~n", [TargetScene]),
    case data_scene_cross:get(Player#player.lv) of
        [] ->
            {false, ?T("没有对应等级的场景可进入")};
        [Sid, _DoorId, _DoorX, _DoorY] ->
            if TargetScene#scene.id /= Sid ->
                {false, ?T("您的等级不能进入该场景")};
                true ->
                    case cross_area:check_cross_area_state() of
                        false ->
                            {false, ?T("跨服场景未开放")};
                        true ->
                            F = fun(Id) ->
                                Id =:= Player#player.scene
                                end,
                            case [{X, Y} || [Id, X, Y] <- TargetScene#scene.door, F(Id)] of
                                [] ->
                                    ?DEBUG("111~n"),
                                    {false, ?T("场景出口出错!")};
                                [{X, Y}] ->
                                    {X2, Y2} = scene:random_xy(TargetScene#scene.id, X, Y),
                                    {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
                            end
                    end
            end
    end;

check_enter(scene_type, Player, PlayerScene, TargetScene, Copy) when PlayerScene#scene.type == ?SCENE_TYPE_CROSS_NORMAL ->
    case data_scene_cross:get(Player#player.lv) of
        [] ->
            {true, Player#player{x = TargetScene#scene.x, y = TargetScene#scene.y, scene = TargetScene#scene.id}, TargetScene#scene.id, TargetScene#scene.x, TargetScene#scene.y, TargetScene#scene.name, TargetScene#scene.sid};
        [_Sid, _DoorId, DoorX, DoorY] ->
            {X2, Y2} = scene:random_xy(TargetScene#scene.id, DoorX, DoorY),
            {true, Player, Copy, TargetScene#scene.id, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
    end;

%%进入结婚场景
%%check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_MARRY ->
%%    case marry:check_enter_marry_scene(Player, TargetScene#scene.id) of
%%        {false, Msg} -> {false, Msg};
%%        {X2, Y2} ->
%%            {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
%%    end;

%%进入六龙争霸场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_CROSS_SIX_DRAGON ->
    if
        Player#player.convoy_state > 0 ->
            {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            if
                not IsNormalScene -> {false, ?T("普通野外场景才能进入挑战")};
                true ->
                    case cross_six_dragon:check_enter_six_dragon_wait_scene(Player) of
                        {false, Msg} -> {false, Msg};
                        {X2, Y2} ->
                            {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
                    end
            end
    end;

%%进入跨服1vn资格赛准备场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_CROSS_1VN_READY ->
    ?DEBUG("scene_type ~n"),
    if
        Player#player.convoy_state > 0 ->
            {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            IsCross1VnScene = scene:is_cross_1vn_scene(Player#player.scene),
            if
                not IsNormalScene andalso not IsCross1VnScene -> {false, ?T("普通野外场景才能进入挑战")};
                true ->
                    {X0, Y0} = cross_1vn:get_wait_scene_xy1(),
                    {true, Player, TargetScene#scene.id, Copy, X0, Y0, TargetScene#scene.name, TargetScene#scene.sid}
            end
    end;

%%进入跨服1vn守擂赛准备场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_CROSS_1VN_FINAL_READY ->
    ?DEBUG("scene_type ~n"),
    if
        Player#player.convoy_state > 0 ->
            {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            IsCross1VnScene = scene:is_cross_1vn_scene(Player#player.scene),
            if
                not IsNormalScene andalso not IsCross1VnScene -> {false, ?T("普通野外场景才能进入挑战")};
                true ->
                    {X0, Y0} = cross_1vn:get_wait_scene_xy2(),
                    {true, Player, TargetScene#scene.id, Copy, X0, Y0, TargetScene#scene.name, TargetScene#scene.sid}
            end
    end;


%%进入乱斗精英赛准备场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_CROSS_SCUFFLE_READY ->
    if
        Player#player.convoy_state > 0 ->
            {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
%%         Player#player.war_team#st_war_team.war_team_key == 0 ->
%%             {false, ?T("十六强战队才可进入")};
        true ->
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            if
                not IsNormalScene -> {false, ?T("普通野外场景才能进入挑战")};
                true ->
%%                     case lists:member(Player#player.war_team#st_war_team.war_team_key, KeyList) of
%%                         false ->
%%                             {false, ?T("十六强战队才可进入")};
%%                         _ ->
                    case cross_scuffle_elite:check_enter_scuffle_ellite_wait_scene(Player) of
                        {false, Msg} -> {false, Msg};
                        {X2, Y2} ->
                            {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
%%                             end
                    end
            end
    end;

%%进入监狱
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when TargetScene#scene.type == ?SCENE_TYPE_PRISON ->
    RedNameVal = prison:get_red_name_val(),
    if
        Player#player.convoy_state > 0 ->
            {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 ->
            {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 ->
            {false, ?T("您正处于匹配队列中无法进入")};
        Player#player.pk#pk.value >= RedNameVal ->
            {false, ?T("您的杀戮值超过100,不能进入")};
        true ->
            F = fun(Id) ->
                Id =:= Player#player.scene
                end,
            case [{X, Y} || [Id, X, Y] <- TargetScene#scene.door, F(Id)] of
                [] ->
                    {false, ?T("场景出口出错!")};
                [{X, Y}] ->
                    {X2, Y2} = scene:random_xy(TargetScene#scene.id, X, Y),
                    {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
            end
    end;
%%退出监狱
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when _PlayerScene#scene.type == ?SCENE_TYPE_PRISON ->
    RedNameVal = prison:get_red_name_val(),
    if
        Player#player.pk#pk.value >= RedNameVal ->
            {false, ?T("您的杀戮值超过100,不能退出")};
        true ->
            F = fun(Id) ->
                Id =:= Player#player.scene
                end,
            case [{X, Y} || [Id, X, Y] <- TargetScene#scene.door, F(Id)] of
                [] ->
                    {false, ?T("场景出口出错!")};
                [{X, Y}] ->
                    {X2, Y2} = scene:random_xy(TargetScene#scene.id, X, Y),
                    {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
            end
    end;

%%进入功能战场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) when (TargetScene#scene.type == ?SCENE_TYPE_CROSS_WAR) ->
    enter_cross_war_scene(Player, TargetScene, Copy);

%%普通场景
check_enter(scene_type, Player, _PlayerScene, TargetScene, Copy) ->
    if Player#player.convoy_state > 0 andalso Player#player.scene == ?SCENE_ID_MAIN andalso TargetScene#scene.sid =/= 13003 ->
        {false, ?T("您当前在护送中,不能走捷径哦!")};
        true ->
            enter_normal_scene(Player, TargetScene, Copy)
    end.

%% 进入普通场景
enter_normal_scene(Player, TargetScene, Copy) ->
    F = fun(Id) ->
        ?IF_ELSE(Player#player.pf == 888, true, Id =:= Player#player.scene)
        end,
    DoorList = [{X, Y} || [Id, X, Y] <- TargetScene#scene.door, F(Id)],
    DoorList1 =
        if
            DoorList == [] ->
                IsSixDragonScene = scene:is_six_dragon_wait_scene(Player#player.scene),
                IsCrossScuffleEliteReadyScene = scene:is_cross_scuffle_elite_ready_scene(Player#player.scene),
                IsCross1VnReadyScene = scene:is_cross_1vn_ready_all_scene(Player#player.scene),
                if
                    IsSixDragonScene orelse IsCrossScuffleEliteReadyScene orelse IsCross1VnReadyScene ->
                        {Scene_1, Copy_1, X_1, Y_1} = scene_change:get_out(Player),
                        [{Scene_1, Copy_1, X_1, Y_1}];
                    true -> []
                end;
            true -> DoorList
        end,
    case DoorList1 of
        [] ->
            {false, ?T("场景出口出错!")};
        [{X, Y} | _] ->
            {X2, Y2} =
                if
                    Player#player.pf == 888 andalso TargetScene#scene.id == 10001 ->
                        {13, 16}; %% 机器人回到初始位置
                    true ->
                        scene:random_xy(TargetScene#scene.id, X, Y)
                end,
            {true, Player, TargetScene#scene.id, Copy, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid};
        [{Scene2, Copy2, X2, Y2}] ->
            {true, Player, Scene2, Copy2, X2, Y2, TargetScene#scene.name, TargetScene#scene.sid}
    end.

%%进入野外boss场景
enter_field_boss_scene(Player, TargetScene, Copy) ->
    if
        Player#player.convoy_state > 0 -> {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 -> {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 -> {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            Boss = field_boss:get_ets_boss(TargetScene#scene.id),
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            if
                Boss == [] -> {false, ?T("boss场景不存在")};
                not IsNormalScene -> {false, ?T("不能从该场景进入")};
                true ->
                    case check_enter_lv(Player#player.lv, TargetScene) of
                        ok ->
                            {true, Player, TargetScene#scene.id, Copy, TargetScene#scene.x, TargetScene#scene.y, TargetScene#scene.name, TargetScene#scene.sid};
                        Err -> Err
                    end
            end
    end.

enter_cross_war_scene(Player, TargetScene, Copy) ->
    if
        Player#player.convoy_state > 0 -> {false, ?T("护送中,不能进入")};
        Player#player.marry#marry.cruise_state > 0 -> {false, ?T("巡游中,不能进入")};
        Player#player.match_state > 0 -> {false, ?T("您正处于匹配队列中无法进入")};
        true ->
            IsNormalScene = scene:is_normal_scene(Player#player.scene),
            if
                not IsNormalScene -> {false, ?T("不能从该场景进入")};
                true ->
                    ?DEBUG("TargetScene:~p~n", [TargetScene]),
                    cross_war:enter_cross_war_scene(Player, TargetScene, Copy)
            end
    end.

