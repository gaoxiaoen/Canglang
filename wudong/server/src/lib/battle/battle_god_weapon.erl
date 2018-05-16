%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2017 17:26
%%%-------------------------------------------------------------------
-module(battle_god_weapon).
-author("hxming").

-include("common.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-export([check_battle/5, battle/4]).


check_battle(Sign, ScenePid, ScenePlayer, TargetList, LongTime) when Sign == ?SIGN_PLAYER ->
    case ScenePlayer#scene_player.god_weapon_id /= 0 andalso ScenePlayer#scene_player.t_att rem 10 == 0 of
        true ->
            case get_god_weapon_skill(Sign, ScenePlayer, round(LongTime / 1000)) of
                false -> ok;
                GodWeaponSkillId ->
                    Msg = {auto_battle, Sign, ScenePlayer#scene_player.key, TargetList, GodWeaponSkillId, god_weapon},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 150, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(Sign, ScenePid, Mon, TargetList, LongTime) when Sign == ?SIGN_MON ->
    case Mon#mon.shadow_status#player.god_weapon_id /= 0 andalso Mon#mon.t_att rem 10 == 0 of
        true ->
            case get_god_weapon_skill(Sign, Mon, round(LongTime / 1000)) of
                false -> ok;
                GodWeaponSkillId ->
                    Msg = {auto_battle, Sign, Mon#mon.key, TargetList, GodWeaponSkillId, god_weapon},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 180, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(_, _, _, _, _) ->
    ok.


get_god_weapon_skill(Sign, AttPlayer, Now) when Sign == ?SIGN_PLAYER ->
    SkillId = AttPlayer#scene_player.god_weapon_skill,
    case lists:keyfind(SkillId, 1, AttPlayer#scene_player.battle_info#batt_info.skill_cd) of
        false -> SkillId;
        {_, Cd} ->
            if Cd > Now -> false;
                true -> SkillId
            end
    end;
get_god_weapon_skill(Sign, Mon, Now) when Sign == ?SIGN_MON ->
    SkillId = Mon#mon.shadow_status#player.god_weapon_skill,
    case lists:keyfind(SkillId, 1, Mon#mon.skill_cd) of
        false -> SkillId;
        {_, Cd} ->
            if Cd > Now -> false;
                true -> SkillId
            end
    end;
get_god_weapon_skill(_, _, _) -> false.


%%神器战斗
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_PLAYER ->
    ScenePlayer = scene_agent:dict_get_player(AttKey),
    case battle:check_battle(ScenePlayer) of
        {ok, AttPlayer} ->
            LongTime = util:longunixtime(),
            BattleInfo = AttPlayer#scene_player.battle_info#batt_info{buff_list = []},
            Attacker = battle:make_attacker(ScenePlayer, ?SIGN_GOD_WEAPON),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttPlayer#scene_player.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_GOD_WEAPON, AttPlayer#scene_player{battle_info = BattleInfo}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_MON ->
    SceneMon = mon_agent:dict_get_mon(AttKey),
    case battle:check_shadow_battle(SceneMon) of
        {ok, AttMon} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(SceneMon, ?SIGN_GOD_WEAPON),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttMon#mon.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_GOD_WEAPON, AttMon#mon{buff_list = []}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(_, _, _, _) -> err.