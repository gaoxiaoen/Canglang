%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2017 17:18
%%%-------------------------------------------------------------------
-module(battle_magic_weapon).
-author("hxming").

-include("common.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-export([check_battle/5, battle/4]).


check_battle(Sign, ScenePid, ScenePlayer, TargetList, LongTime) when Sign == ?SIGN_PLAYER ->
    case ScenePlayer#scene_player.magic_weapon_id /= 0 andalso ScenePlayer#scene_player.t_att rem 8 == 0 of
        true ->
            case get_magic_weapon_skill(Sign, ScenePlayer, round(LongTime / 1000)) of
                false -> ok;
                MagicWeaponSkillId ->
                    Msg = {auto_battle, Sign, ScenePlayer#scene_player.key, TargetList, MagicWeaponSkillId, magic_weapon},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 100, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(Sign, ScenePid, Mon, TargetList, LongTime) when Sign == ?SIGN_MON ->
    case Mon#mon.shadow_status#player.magic_weapon_id /= 0 andalso Mon#mon.t_att rem 8 == 0 of
        true ->
            case get_magic_weapon_skill(Sign, Mon, round(LongTime / 1000)) of
                false -> ok;
                MagicWeaponSkillId ->
                    Msg = {auto_battle, Sign, Mon#mon.key, TargetList, MagicWeaponSkillId, magic_weapon},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 120, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(_, _, _, _, _) ->
    ok.


%%获取法器攻击技能
get_magic_weapon_skill(Sign, AttPlayer, Now) when Sign == ?SIGN_PLAYER ->
    F = fun({Sid, _Slv}) ->
        case lists:keyfind(Sid, 1, AttPlayer#scene_player.battle_info#batt_info.skill_cd) of
            false -> true;
            {_, Cd} ->
                if Cd > Now -> false;
                    true -> true
                end
        end
        end,
    case lists:filter(F, AttPlayer#scene_player.magic_weapon_skill) of
        [] ->
            false;
        L ->
            {SkillId, _} = util:list_rand(L),
            SkillId
    end;
get_magic_weapon_skill(Sign, Mon, Now) when Sign == ?SIGN_MON ->
    F = fun({Sid, _Slv}) ->
        case lists:keyfind(Sid, 1, Mon#mon.skill_cd) of
            false -> true;
            {_, Cd} ->
                if Cd > Now -> false;
                    true -> true
                end
        end
        end,
    case lists:filter(F, Mon#mon.shadow_status#player.magic_weapon_skill) of
        [] -> false;
        L ->
            {SkillId, _} = util:list_rand(L),
            SkillId
    end;
get_magic_weapon_skill(_, _, _) -> false.

%%法器战斗
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_PLAYER ->
    ScenePlayer = scene_agent:dict_get_player(AttKey),
    case battle:check_battle(ScenePlayer) of
        {ok, AttPlayer} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(ScenePlayer, ?SIGN_MAGIC_WEAPON),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttPlayer#scene_player.scene),
            BattleInfo = AttPlayer#scene_player.battle_info#batt_info{buff_list = []},
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_MAGIC_WEAPON, AttPlayer#scene_player{battle_info = BattleInfo}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> ok
    end;
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_MON ->
    SceneMon = mon_agent:dict_get_mon(AttKey),
    case battle:check_shadow_battle(SceneMon) of
        {ok, AttMon} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(SceneMon, ?SIGN_MAGIC_WEAPON),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttMon#mon.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_MAGIC_WEAPON, AttMon#mon{buff_list = []}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(_, _, _, _) -> err.