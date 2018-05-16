%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2017 17:05
%%%-------------------------------------------------------------------
-module(battle_pet).
-author("hxming").

-include("common.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-export([check_battle/5, battle/4]).


check_battle(Sign, ScenePid, ScenePlayer, TargetList, _LongTime) when Sign == ?SIGN_PLAYER ->
    AttPet = ScenePlayer#scene_player.pet,
    case AttPet#scene_pet.type_id > 0 andalso ScenePlayer#scene_player.t_att rem 5 == 0 of
        true ->
            PetSkillId = get_pet_skill_id(Sign, ScenePlayer),
            Msg = {auto_battle, Sign, ScenePlayer#scene_player.key, TargetList, PetSkillId, pet},
                catch scene:get_battle_delay_pid() ! {battle_delay, 50, ScenePid, Msg},
            ok;
        false -> ok
    end;
check_battle(Sign, ScenePid, Mon, TargetList, _LongTime) when Sign == ?SIGN_MON ->
    case Mon#mon.shadow_status#player.pet#fpet.type_id > 0 andalso Mon#mon.t_att rem 5 == 0 of
        true ->
            PetSkillId = get_pet_skill_id(Sign, Mon),
            Msg = {auto_battle, Sign, Mon#mon.key, TargetList, PetSkillId, pet},
                catch scene:get_battle_delay_pid() ! {battle_delay, 80, ScenePid, Msg},
            ok;
        false -> ok
    end;
check_battle(_, _, _, _, _) ->
    ok.


%%获取宠物攻击技能id
get_pet_skill_id(Sign, ScenePlayer) when Sign == ?SIGN_PLAYER ->
    AttPet = ScenePlayer#scene_player.pet,
    HpPec = ScenePlayer#scene_player.hp / ScenePlayer#scene_player.attribute#attribute.hp_lim * 100,
    TimeMark = ScenePlayer#scene_player.battle_info#batt_info.time_mark,
    pet_util:get_pet_skill_for_battle(AttPet#scene_pet.skill, ScenePlayer#scene_player.battle_info#batt_info.skill_cd, [{aihp, HpPec}, {aicd, TimeMark#time_mark.ast}]);
get_pet_skill_id(Sign, SceneMon) when Sign == ?SIGN_MON ->
    AttPet = SceneMon#mon.shadow_status#player.pet,
    HpPec = SceneMon#mon.hp / SceneMon#mon.hp_lim * 100,
    TimeMark = SceneMon#mon.time_mark,
    pet_util:get_pet_skill_for_battle(AttPet#fpet.skill, SceneMon#mon.skill_cd, [{aihp, HpPec}, {aicd, TimeMark#time_mark.ast}]);
get_pet_skill_id(_, _) ->
    0.


%%宠物战斗
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_PLAYER ->
    ScenePlayer = scene_agent:dict_get_player(AttKey),
    case battle:check_battle(ScenePlayer) of
        {ok, AttPlayer} ->
            AttPet = AttPlayer#scene_player.pet,
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(ScenePlayer, ?SIGN_PET),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttPlayer#scene_player.scene),
            BattleInfo = AttPlayer#scene_player.battle_info#batt_info{skill = AttPet#scene_pet.skill, buff_list = []},
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_PET, AttPlayer#scene_player{battle_info = BattleInfo}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_MON ->
    SceneMon = mon_agent:dict_get_mon(AttKey),
    case battle:check_shadow_battle(SceneMon) of
        {ok, AttMon} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(SceneMon, ?SIGN_PET),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttMon#mon.scene),
            AttPet = AttMon#mon.shadow_status#player.pet,
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_PET, AttMon#mon{pet_att_param = AttPet#fpet.att_param, buff_list = []}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(_, _, _, _) -> err.