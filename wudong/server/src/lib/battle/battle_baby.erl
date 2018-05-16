%%%-------------------------------------------------------------------
%%% @author hxming
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 八月 2017 17:29
%%%-------------------------------------------------------------------
-module(battle_baby).
-author("hxming").


-include("common.hrl").
-include("battle.hrl").
-include("scene.hrl").

%% API
-export([check_battle/5, battle/4]).


check_battle(Sign, ScenePid, ScenePlayer, TargetList, LongTime) when Sign == ?SIGN_PLAYER ->
    case ScenePlayer#scene_player.baby#scene_baby.type_id /= 0 andalso ScenePlayer#scene_player.t_att rem 7 == 0 of
        true ->
            case get_baby_skill(Sign, ScenePlayer, round(LongTime / 1000)) of
                false -> ok;
                BabySkillId ->
                    Msg = {auto_battle, Sign, ScenePlayer#scene_player.key, TargetList, BabySkillId, baby},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 200, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(Sign, ScenePid, Mon, TargetList, LongTime) when Sign == ?SIGN_MON ->
    case Mon#mon.shadow_status#player.baby#fbaby.type_id /= 0 andalso Mon#mon.t_att rem 7 == 0 of
        true ->
            case get_baby_skill(Sign, Mon, round(LongTime / 1000)) of
                false -> ok;
                BabySkillId ->
                    Msg = {auto_battle, Sign, Mon#mon.key, TargetList, BabySkillId, baby},
                        catch scene:get_battle_delay_pid() ! {battle_delay, 220, ScenePid, Msg}
            end;
        false -> ok
    end;
check_battle(_, _, _, _, _) ->
    ok.


%%获取宝宝攻击技能
get_baby_skill(Sign, AttPlayer, Now) when Sign == ?SIGN_PLAYER ->
    F = fun({_Cell, Sid}) ->
        case lists:keyfind(Sid, 1, AttPlayer#scene_player.battle_info#batt_info.skill_cd) of
            false -> true;
            {_, Cd} ->
                if Cd > Now -> false;
                    true -> true
                end
        end
        end,
    case lists:filter(F, AttPlayer#scene_player.baby#scene_baby.skill) of
        [] ->
            false;
        L ->
            {_, SkillId} = util:list_rand(L),
            SkillId
    end;
get_baby_skill(Sign, Mon, Now) when Sign == ?SIGN_MON ->
    F = fun({_Cell, Sid}) ->
        case lists:keyfind(Sid, 1, Mon#mon.skill_cd) of
            false -> true;
            {_, Cd} ->
                if Cd > Now -> false;
                    true -> true
                end
        end
        end,
    case lists:filter(F, Mon#mon.shadow_status#player.baby#fbaby.skill) of
        [] -> false;
        L ->
            {_, SkillId} = util:list_rand(L),
            SkillId
    end;
get_baby_skill(_, _, _) -> false.


%%宝宝战斗
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_PLAYER ->
    ScenePlayer = scene_agent:dict_get_player(AttKey),
    case battle:check_battle(ScenePlayer) of
        {ok, AttPlayer} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(ScenePlayer, ?SIGN_BABY),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttPlayer#scene_player.scene),
            BattleInfo = AttPlayer#scene_player.battle_info#batt_info{buff_list = []},
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_BABY, AttPlayer#scene_player{battle_info = BattleInfo}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> ok
    end;
battle(Sign, AttKey, SkillId, TargetList) when Sign == ?SIGN_MON ->
    SceneMon = mon_agent:dict_get_mon(AttKey),
    case battle:check_shadow_battle(SceneMon) of
        {ok, AttMon} ->
            LongTime = util:longunixtime(),
            Attacker = battle:make_attacker(SceneMon, ?SIGN_BABY),
            Skill = skill:get_skill(SkillId),
            SceneObjList = battle:get_target_list(Attacker, TargetList, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttMon#mon.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_BABY, AttMon#mon{buff_list = []}, {Skill, 0, 0}, SceneObjList, LongTime]});
        _ -> skip
    end;
battle(_, _, _, _) -> err.