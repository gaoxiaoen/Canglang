%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015,苍狼工作室
%%% @doc
%%% 战斗逻辑
%%% @end
%%% Created : 07. 一月 2015 下午2:53
%%%-------------------------------------------------------------------
-module(battle).
-author("fancy").
-include("common.hrl").
-include("scene.hrl").
-include("battle.hrl").
-include("skill.hrl").
-include("invade.hrl").
-include("grace.hrl").
-include("cross_war.hrl").
-export([
    battle/4, do_battle/5, collect/6, init_data/2, init_data/3, get_target_key_list/6
]).

-export([make_attacker/2, get_target_list/4, check_battle/1, check_shadow_battle/1, delay_battle_scene_limit/1]).

%%场景进程
%% Tx 技能目标x坐标 Ty 技能目标y坐标
battle(Sign, Akey, {SkillId, Tx, Ty}, TargetList1) when Sign == ?SIGN_PLAYER ->
    AttPlayer = scene_agent:dict_get_player(Akey),
    case check_battle(AttPlayer) of
        {ok, AttPlayer2} ->
            LongTime = util:longunixtime(),
            Skill = skill:get_skill(SkillId),
%%             TargetList2 = lists:sublist(TargetList1, max(1, Skill#skill.hurtnum)),
            IsNormal = lists:member(SkillId, data_skill:career_skills(6)),
            Hurtnum = ?IF_ELSE(IsNormal andalso AttPlayer#scene_player.new_career > 1, Skill#skill.hurtnum + 2, Skill#skill.hurtnum),
            TargetList = lists:sublist(TargetList1, max(1, Hurtnum)),
            Attacker = make_attacker(AttPlayer, Sign),
            SceneObjList = get_target_list(Attacker, TargetList, LongTime, Skill),
%%             ?DEBUG("SceneObjList:~p", [SceneObjList]),
            SceneWorker = scene:get_scene_worker(AttPlayer#scene_player.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_PLAYER, AttPlayer2, {Skill, Tx, Ty}, SceneObjList, LongTime]}),
            Self = self(),
            case delay_battle_scene_limit(AttPlayer#scene_player.scene) of
                true -> skip;
                false ->
                    battle_pet:check_battle(Sign, Self, AttPlayer, TargetList, LongTime),
                    battle_magic_weapon:check_battle(Sign, Self, AttPlayer, TargetList, LongTime),
                    battle_god_weapon:check_battle(Sign, Self, AttPlayer, TargetList, LongTime),
                    battle_baby:check_battle(Sign, Self, AttPlayer, TargetList, LongTime)
            end,
            ok;
        Code ->
            ?PRINT("battle fail code:~p~n", [Code])
    end;
battle(Sign, Akey, {SkillId, Tx, Ty}, TargetList) when Sign == ?SIGN_MON ->
    AttMon = mon_agent:dict_get_mon(Akey),
    if AttMon == [] -> skip;
        AttMon#mon.hp =< 0 -> skip;
        true ->
            Skill = skill:get_skill(SkillId),
            TargetList2 =
                if Tx > 0 andalso Ty > 0 ->
                    AttArea = ?IF_ELSE(Skill#skill.att_area > 0, Skill#skill.att_area, AttMon#mon.att_area),
                    lists:sublist(get_target_key_list(?SIGN_MON, AttMon#mon.copy, Tx, Ty, AttArea, AttMon#mon.group), Skill#skill.hurtnum);
                    true -> TargetList
                end,
            {Tox, Toy} = ?IF_ELSE(Tx > 0 andalso Ty > 0, {Tx, Ty}, {AttMon#mon.x, AttMon#mon.y}),
            LongTime = util:longunixtime(),
            Attacker = make_attacker(AttMon#mon{x = Tox, y = Toy}, Sign),
            SceneObjList = get_target_list(Attacker, TargetList2, LongTime, Skill),
            SceneWorker = scene:get_scene_worker(AttMon#mon.scene),
            ?CAST(SceneWorker, {apply_cast, battle, do_battle, [?SIGN_MON, AttMon, {Skill, Tox, Toy}, SceneObjList, LongTime]}),
            if AttMon#mon.shadow_key /= 0 ->
                Self = self(),
                battle_pet:check_battle(Sign, Self, AttMon, TargetList, LongTime),
                battle_magic_weapon:check_battle(Sign, Self, AttMon, TargetList, LongTime),
                battle_god_weapon:check_battle(Sign, Self, AttMon, TargetList, LongTime),
                battle_baby:check_battle(Sign, Self, AttMon, TargetList, LongTime),
                ok;
                true -> skip
            end
    end;

battle(_Sign, _AttKey, _SKillInfo, _Target) ->
    ?ERR("sign ~p key ~p skill ~p target ~p~n", [_Sign, _AttKey, _SKillInfo, _Target]),
    err.


delay_battle_scene_limit(SceneId) ->
    SceneType = scene:get_scene_type(SceneId),
    lists:member(SceneType, [?SCENE_TYPE_CROSS_BATTLEFIELD, ?SCENE_TYPE_CROSS_BOSS, ?SCENE_TYPE_CROSS_FIELD_BOSS, ?SCENE_TYPE_CROSS_DARK_BLIBE, ?SCENE_TYPE_CROSS_WAR]).

get_target_key_list(?SIGN_MON, Copy, X, Y, Area, Group) ->
    Players = scene_agent:priv_get_scene_player_for_battle(Copy, X, Y, Area, [], Group),
    [[?SIGN_PLAYER, Player#scene_player.key] || Player <- Players];
get_target_key_list(?SIGN_PLAYER, Copy, X, Y, Area, Group) ->
    MonList = mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, Area, [], Group, ?SIGN_PLAYER, 0),
    [{unlock, Mon} || Mon <- lists:sublist(MonList, util:rand(5, 15))];
get_target_key_list(_, _Copy, _X, _Y, _Area, _Group) -> [].


%%get_target_for_robot(Copy, X, Y, Area, Group) ->
%%    MonList = mon_agent:priv_get_scene_mon_for_battle(Copy, X, Y, Area, [], Group, ?SIGN_PLAYER, 0),
%%    [{unlock, Mon} || Mon <- lists:sublist(MonList, util:rand(5, 15))].


is_self_skill(Skill) ->
    Skill#skill.mod == ?SKILL_MOD_SELF orelse Skill#skill.mod == ?SKILL_MOD_TEAM.

get_target_list(Attacker, TargetList, LongTime, Skill) ->
    AttArea = ?IF_ELSE(Skill#skill.att_area > 0, Skill#skill.att_area, Attacker#attacker.att_area),
    IsSelfSkill = is_self_skill(Skill),
    F = fun([Sign, Key], List) ->
        Target =
            case Sign of
                ?SIGN_PLAYER ->
                    filter_player(Key, Attacker, LongTime, IsSelfSkill, AttArea);
                _ ->
                    filter_mon(Key, Attacker, LongTime, IsSelfSkill, AttArea)
            end,
        List ++ Target
        end,
    lists:foldl(F, [], TargetList).

%%过滤玩家
filter_player(Key, Attacker, LongTime, IsSelfSkill, AttArea) ->
    #attacker{scene = Scene, x = X, y = Y, copy = Copy, group = Group, gkey = Gkey} = Attacker,
    case scene_agent:dict_get_player_for_battle(Key, Attacker#attacker.key, LongTime) of
        [] -> [];
        {lock, ScenePlayer} ->
            [{lock, ScenePlayer}];
        ScenePlayer when ScenePlayer#scene_player.copy == Copy andalso ScenePlayer#scene_player.hp > 0 ->
            %%检查攻击距离
            case check_att_area(AttArea, X, Y, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y) of
                false ->
                    ?DEBUG("att area ~p fail ~p/~p ~p/~p~n", [AttArea, X, Y, ScenePlayer#scene_player.x, ScenePlayer#scene_player.y]),
                    [];
                true ->
                    if IsSelfSkill ->
                        ?IF_ELSE(ScenePlayer#scene_player.group /= Group, [], [{unlock, ScenePlayer}]);
                        Scene == ?SCENE_ID_CROSS_ELITE -> [{unlock, ScenePlayer}];
                        Group == 0 orelse ScenePlayer#scene_player.group /= Group ->
                            IsFieldBossScene = scene:is_field_boss_scene(Scene),
                            if
                                ScenePlayer#scene_player.is_view /= ?VIEW_MODE_ALL -> [];
                                ScenePlayer#scene_player.is_transport == 1 -> [];
                                IsFieldBossScene andalso ScenePlayer#scene_player.guild_key /= 0 andalso ScenePlayer#scene_player.guild_key == Gkey ->
                                    [];
                                true ->
                                    [{unlock, ScenePlayer}]
                            end;
                        true -> []
                    end
            end;
        _ -> []
    end.
%%过滤怪物
filter_mon(Key, Attacker, LongTime, _IsSelfSkill, AttArea) ->
    #attacker{sign = AttSign, x = X, y = Y, copy = Copy, group = Group, eli_group = EliGroup, gkey = Gkey, node = Node, sid = Sid} = Attacker,
    case mon_agent:dict_get_mon_for_battle(Key, Attacker#attacker.key, LongTime) of
        [] ->
            mon_util:hide_mon(Key, Node, Sid),
            [];
        {lock, Mon} ->
            [{lock, Mon}];
        Mon when Mon#mon.copy == Copy andalso Mon#mon.hp > 0 andalso (Group == 0 orelse Mon#mon.group /= Group) ->
            %%检查攻击高距离
            case check_att_mon_area(AttArea, X, Y, Mon#mon.x, Mon#mon.y, Mon#mon.mid) of
                false -> [];
                true ->
                    if
                        Mon#mon.is_collect == 1 -> [];
                        Mon#mon.kind == ?MON_KIND_MARRY_CAR -> [];
                        Mon#mon.kind == ?MON_KIND_GUILD_FLAG_MON -> [];
                        AttSign == ?SIGN_PLAYER andalso Mon#mon.is_att_by_player == 0 -> [];
                        AttSign == ?SIGN_MON andalso Mon#mon.is_att_by_mon == 0 -> [];
                        AttSign == ?SIGN_GOD_WEAPON andalso Mon#mon.boss > 0 -> [];
                        Mon#mon.kind == ?MON_KIND_MANOR andalso AttSign /= ?SIGN_PLAYER -> [];
                        Mon#mon.kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF -> [];
                        EliGroup /= Mon#mon.eliminate_group -> [];
                        Mon#mon.kind == ?MON_KIND_MANOR ->
                            case manor_war:check_attack_flag(Mon, Gkey) of
                                {false, Err} ->
                                    ?IF_ELSE(Sid /= none, battle_util:battle_fail(Err, Node, Sid), ok),
                                    [];
                                true ->
                                    [{unlock, Mon}]
                            end;
                        Mon#mon.kind == ?MON_KIND_MANOR_BOSS ->
                            case manor_war:check_attack_boss(Mon, Gkey) of
                                {false, Err} ->
                                    ?IF_ELSE(Sid /= none, battle_util:battle_fail(Err, Node, Sid), ok),
                                    [];
                                true ->
                                    [{unlock, Mon}]
                            end;
                        true ->
                            [{unlock, Mon}]
                    end
            end;
        _Other ->
            mon_util:hide_mon(Key, Node, Sid),
            []
    end.

%%检查自己是否可攻击
check_battle([]) -> 0;
check_battle(ScenePlayer) ->
    if
        ScenePlayer#scene_player.hp =< 0 -> 2;
        ScenePlayer#scene_player.is_transport == 1 -> 3;
        true ->
            {ok, ScenePlayer}
    end.

check_shadow_battle([]) -> 0;
check_shadow_battle(Mon) ->
    if Mon#mon.shadow_key == 0 -> 2;
        Mon#mon.hp < 0 -> 3;
        true -> {ok, Mon}
    end.


%%发起攻击
do_battle(_AttSign, _AttObj, {_Skill, _tx, _ty}, [], _LongTime) ->
    skip;
do_battle(AttSign, AttObj, {Skill, Tx, Ty}, SceneObjList, LongTime) ->
    Aer0 = init_data(AttObj, AttSign, LongTime),
    BsArgs = Aer0#bs.bs_args,
    Aer = Aer0#bs{bs_args = BsArgs#bs_args{tx = Tx, ty = Ty}},
    F = fun({Type, Obj}, {Lock, UnLock}) ->
        Der0 = init_data(Obj, LongTime),
        case Type of
            lock ->
                {[Der0 | Lock], UnLock};
            unlock ->
                {Lock, [Der0 | UnLock]};
            _ ->
                {Lock, UnLock}
        end
        end,
    {LockDerList, DerList} = lists:foldl(F, {[], []}, SceneObjList),
    lock_miss(Aer, Skill#skill.skillid, LockDerList),

    {Aer5, Skill3} = check_skill_cd(Aer, Skill),
%%    Att_area = ?IF_ELSE(Skill#skill.att_area > 0, Skill#skill.att_area, Aer0#bs.att_area),
%%    DerList1 = check_attarea(DerList, {Att_area, Aer5#bs.x, Aer5#bs.y}, []),
    IsSelfSkill = is_self_skill(Skill),
    DerList2 = check_pk(DerList, Aer5, LongTime div 1000, IsSelfSkill),
    case attack(Aer5, lists:reverse(DerList2), Skill3, IsSelfSkill) of
        false ->
            none;
        {Aer6, DerList4} ->
            NewSin = player_evil:check_add_sin(Aer6, DerList4, Skill#skill.skillid),
            Aer7 = Aer6#bs{sin = NewSin},
            BSList =
                if IsSelfSkill ->
                    case lists:keytake(Aer7#bs.key, #bs.key, DerList4) of
                        false ->
                            [Aer7#bs{t_att = Aer#bs.t_att + 1} | DerList4];
                        {value, Find, T} ->
                            BuffList = buff:merge_buff_list(Aer7#bs.buff_list, Find#bs.buff_list),
                            [Aer7#bs{t_att = Aer#bs.t_att + 1, buff_list = BuffList} | T]
                    end;
                    true -> [Aer7#bs{t_att = Aer#bs.t_att + 1} | DerList4]
                end,
            ReBSList = remark(BSList, []),
            sync_scene_obj(ReBSList, Aer7#bs.scene, Aer7#bs.copy, []),
            sync_obj(BSList, Skill#skill.skillid),
            battle_msg(Aer7, Skill#skill.skillid, BSList)
    end;
do_battle(_Attsign, _AttObj, _SkillInfo, _SceneObjList, _LongTime) ->
    ?ERR("do_battle_err:~p  |    ~p   |   ~p    |   ~p    ~n", [_Attsign, _AttObj, _SkillInfo, _SceneObjList, _LongTime]),
    ok.

%%攻击锁定玩家miss
lock_miss(_Aer, _SkillId, []) -> ok;
lock_miss(Aer, SkillId, [Der0 | DerList]) ->
    Attacker = make_attacker(Aer, 0),
    F = fun(Der) ->
        Der#bs{attacker = Attacker, state = ?STATE_DODGE, hurt_list = [[?HURT_TYPE_NORMAL, 0]]}
        end,
    NewDerList = lists:map(F, [Der0#bs{actor = ?ACTOR_DEF} | DerList]),
    BSList = [Aer#bs{actor = ?ACTOR_ATT} | NewDerList],
    battle_msg(Aer, SkillId, BSList),
    ok;
lock_miss(_Aer, _SkillId, _) ->
    ok.

%%攻击
attack(_, [], _, _) -> false;
attack(Aer, [Der | Dlist], Skill, IsSelfSkill) ->
    %%触发被动技能
    NewDer = Der#bs{actor = ?ACTOR_DEF},
    {Aer0, NewDer0} = skill_passive:activate_passive_skill_att(Aer, NewDer),
    Aer1 = use_skill(Aer0, Skill),
    F = fun(Derx, [Aerx1, DerListx, R]) ->
        %%受击触发被动技能
        Derx1 = skill_passive:activate_passive_skill_def(Derx, Aer),
        {Aerx2, Derx2} = effect:active(Aerx1#bs.eff_list, Aerx1, Derx1, R),
        {Derx3, Aerx3} = effect:active(Derx2#bs.eff_list, Derx2, Aerx2, R),%%玩家持续buff的效果影响
        {Aerx4, Derx4, Hurt} = cale_hurt(Aerx3, Derx3, Skill, IsSelfSkill),
        {Aerx5, Derx5} = effect:last_active(Aerx4#bs.eff_list, Aerx4, Derx4, Hurt),
        {Aerx6, Derx6} = effect:last_active_der(Derx5#bs.eff_list, Aerx5, Derx5, Hurt),
        [Aerx6, [Derx6#bs{t_def = Derx#bs.t_def + 1} | DerListx], R + 1]
        end,
    Dlist2 = ?IF_ELSE(Aer1#bs.bs_args#bs_args.fix_target, [], Dlist),
    [Aer2, DerList, R1] = lists:foldl(F, [Aer1#bs{actor = ?ACTOR_ATT}, [], 1], [NewDer0 | Dlist2]),
    %%计算使用某些技能后的新增被击玩家
    [Aer3, DerList2, _R2] = lists:foldl(F, [Aer2, [], R1], Aer2#bs.der_list),
    DerList3 = filter_repeat(DerList, DerList2),
    {Aer3, DerList3}.


%%过滤攻击重复的目标
filter_repeat(DerList, DerList2) ->
    F1 = fun(DerF, L) ->
        case lists:keytake(DerF#bs.key, #bs.key, L) of
            false -> [DerF | L];
            {value, DerF1, T} ->
                if DerF#bs.hp > DerF1#bs.hp -> [DerF1 | T];
                    true -> [DerF | T]
                end
        end
         end,
    DerList3 = lists:foldl(F1, DerList, DerList2),
    DerList3.
%%使用技能
use_skill(BS, Skill) ->
    BsArgs = #bs_args{skillid = Skill#skill.skillid, param1 = Skill#skill.param, param2 = Skill#skill.param2, hurt_prop = Skill#skill.hurt_prop},
    BS1 = effect:add_effect(BS, Skill#skill.efflist, Skill#skill.skillid, 1),
    BuffList = Skill#skill.bufflist,
    {BS2, AddBuffList} = buff:skill_add_buff(BS1, BuffList, Skill#skill.skillid, Skill#skill.lv),
    BS3 = buff:buff_to_eff(BS2, AddBuffList),
    BS3#bs{bs_args = BsArgs}.


%%计算伤害
cale_hurt(Aer, Der, Skill, IsSelfSkill) ->
    #bs{
        sign = A_sign,
        kind = A_kind,
        att = A_att,
        hit = A_hit,
        crit = A_crit,                  %%暴击率
        crit_inc = A_crit_inc,          %%暴击伤害
        hurt_inc = A_hurt_inc,
        hurt_fix = A_hurt_fix,
        pvp_inc = A_pvp_inc,
        pet_att_param = A_pet_att_param,
        kill_list = A_kill_list,
        bs_args = A_BsArgs,
        now = Now,
        new_career = NewCareer,
        buff_list = A_BuffList
    } = Aer,
    #bs{
        key = D_key,
        sign = D_sign,
        boss = D_boss,
        mid = D_mid,
        hp = D_hp,
        mana = D_mana,
        ten = D_ten,
%%        att = D_att,
        def = D_def,
        crit_dec = D_crit_dec,          %%内力
        hurt_dec = D_hurt_dec,
        pvp_dec = D_pvp_dec,
        dodge = D_dodge,
        time_mark = D_timeMark,
        bs_args = D_BsArgs,
        actor = Actor,
        kind = D_Kind,
%%        lv = D_lv,
        scene = D_scene,
        buff_list = D_BuffList
    } = Der,
    #bs_args{
        param1 = SkillParam1,
        param2 = SkillParam2,
        fix_miss = FixMiss
    } = A_BsArgs,
    #bs_args{fix_protect = FixProtect, god_mode = GodMode} = D_BsArgs,
    ElementHurtMult = element:cacl_element_hurt(Aer, Der),
    SkillId = Skill#skill.skillid,
    %%0.7 +max[(命中-闪避)/(命中/5 * 13.333333）,0]
    RealAHit = ?IF_ELSE(A_hit == 0, 1, A_hit),
    HitRatio = round((0.9 + max(-0.5, (RealAHit - D_dodge) / (RealAHit / 5 * 15))) * 100),
    %%0.1+max[(暴击-韧性)/(暴击/4 * 11.11111),0]
    RealCrit = ?IF_ELSE(A_crit == 0, 1, A_crit),
    CritRatio = round((0.2 + max(-0.2, (RealCrit - D_ten) / (RealCrit / 4 * (10 + 10 / 9)))) * 100),
    HurtCdt2 = not (SkillId == 10010 andalso (D_boss > 0 orelse D_sign == ?SIGN_PLAYER)),
    IsNormal = lists:member(SkillId, [1001001, 1001002, 1001003, 1001004, 1001005]),
    AddHurt = ?IF_ELSE(NewCareer > 2 andalso IsNormal, 0.1, 0.0),
    AttCrossWarCarFlag = lists:keyfind(154, #skillbuff.buffid, A_BuffList),
    DefCrossWarCarFlag = lists:keyfind(154, #skillbuff.buffid, D_BuffList),
    IsDark = scene:is_cross_dark_blibe(D_scene),
    DefCrossDarkFlag = check_dark_buff(D_BuffList),
    {Hurt, Dstate, ElementHurt} =
        if
            IsSelfSkill ->
                {0, ?STATE_NORMAL, 0};
            D_timeMark#time_mark.godt > Now orelse FixMiss orelse GodMode -> {0, ?STATE_GOD, 0};
            D_Kind == ?MON_KIND_ELIMINATE_MON orelse D_Kind == ?MON_KIND_MANOR orelse D_Kind == ?MON_KIND_CROSS_WAR_BANNER orelse D_Kind == ?MON_KIND_PRISON ->
                {1, ?STATE_NORMAL, 0};
        %% 攻城战场玩家(或攻城车)攻击非野怪
            D_scene == ?SCENE_ID_CROSS_WAR andalso A_sign == ?SIGN_PLAYER andalso D_sign /= ?SIGN_PLAYER andalso D_Kind /= ?MON_KIND_NORMAL ->
                BaseHurt = cross_war_battle:cacl_hurt(Aer, Der),
                {BaseHurt, ?STATE_NORMAL, 0};
        %% 攻城战场攻城车攻击玩家
            D_scene == ?SCENE_ID_CROSS_WAR andalso A_sign == ?SIGN_PLAYER andalso AttCrossWarCarFlag /= false andalso D_sign == ?SIGN_PLAYER ->
                BaseHurt = cross_war_battle:cacl_hurt(Aer, Der),
                {BaseHurt, ?STATE_NORMAL, 0};
        %% 攻城战场攻城车受到敌方玩家伤害
            D_scene == ?SCENE_ID_CROSS_WAR andalso A_sign == ?SIGN_PLAYER andalso D_sign == ?SIGN_PLAYER andalso DefCrossWarCarFlag /= false ->
                BaseHurt = cross_war_battle:cacl_hurt2(Aer, Der),
                {BaseHurt, ?STATE_NORMAL, 0};
        %% 攻城战场攻城车受到敌方玩家伤害
            D_scene == ?SCENE_ID_CROSS_WAR andalso A_sign == ?SIGN_MON andalso A_kind == ?MON_KIND_NORMAL andalso D_sign == ?SIGN_PLAYER andalso DefCrossWarCarFlag /= false ->
                BaseHurt = cross_war_battle:cacl_hurt3(Aer, Der),
                {BaseHurt, ?STATE_NORMAL, 0};
            D_sign == ?SIGN_MON andalso (D_boss == ?BOSS_TYPE_FIELD orelse D_boss == ?BOSS_TYPE_ELITE orelse D_boss == ?BOSS_ACT_FESTIVE orelse D_boss == ?BOSS_TYPE_CROSS) andalso D_mana > 0 ->
                {1, ?STATE_NORMAL, 0};
        %% 魔宫保护符判断
            IsDark andalso DefCrossDarkFlag == true andalso A_sign == ?SIGN_PLAYER andalso D_sign == ?SIGN_PLAYER ->
                {0, ?STATE_GOD, 0};
            FixMiss -> {0, ?STATE_DODGE, 0};
            A_kind == ?MON_KIND_CROSS_BATTLEFIELD_BUFF -> {0, ?STATE_DODGE, 0};
%%            A_sign == ?SIGN_PLAYER andalso D_sign == ?SIGN_PLAYER andalso (D_hp >= 1000000000 orelse D_att >= 99999999) ->
%%                {D_hp, ?STATE_CRIT, 0};
            true ->
                case HurtCdt2 of
                    true ->
                        case util:odds(HitRatio, 100) orelse A_BsArgs#bs_args.fix_hit orelse A_sign == ?SIGN_PET of
                            true ->
                                HurtMax = ?IF_ELSE(SkillId > 0, 0, 1),
                                AttDef = ?IF_ELSE(A_att - D_def < 0.25 * A_att, 0.25 * A_att, A_att - D_def),
                                RandomParam = util:rand(99, 101) / 100,
                                HurtParam = max(0.25, (1 + (A_hurt_inc - D_hurt_dec) / 1000)),
                                {Hurt99, Status} =
                                    if
                                    %%PVP
                                        A_sign == ?SIGN_PLAYER andalso D_sign == ?SIGN_PLAYER andalso Actor == ?ACTOR_DEF ->
                                            PVPParam = 1 + (A_pvp_inc - D_pvp_dec) / 1000,
                                            case util:odds(CritRatio, 100) of
                                                true -> %%暴击
                                                    CritParam = max(1.5, A_crit_inc / 1000 - D_crit_dec / 1000),
                                                    {max(HurtMax, round(AttDef * (SkillParam1 + AddHurt) * HurtParam * CritParam * PVPParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_CRIT};
                                                _ ->
                                                    {max(HurtMax, round(AttDef * (SkillParam1 + AddHurt) * HurtParam * RandomParam * PVPParam + SkillParam2 + A_hurt_fix)), ?STATE_NORMAL}
                                            end;
                                        A_sign == ?SIGN_PET ->
                                            %%宠物攻击
                                            {max(HurtMax, round((A_pet_att_param * AttDef * HurtParam) * RandomParam)), ?STATE_NORMAL};
                                        Der#bs.sign == ?SIGN_MON orelse Actor == ?ACTOR_DEF ->%%攻击怪物和首选目标
                                            case util:odds(CritRatio, 100) of
                                                true -> %%暴击
                                                    CritParam = max(1.5, A_crit_inc / 1000 - D_crit_dec / 1000),
                                                    {max(HurtMax, round(AttDef * (SkillParam1 + AddHurt) * HurtParam * CritParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_CRIT};
                                                _ ->
                                                    {max(HurtMax, round(AttDef * (SkillParam1 + AddHurt) * HurtParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_NORMAL}
                                            end;

                                        true ->
                                            case util:odds(CritRatio, 100) of
                                                true -> %%暴击
                                                    %%波及玩家AOE伤害
                                                    CritParam = max(1.5, A_crit_inc / 1000 - D_crit_dec / 1000),
                                                    {max(HurtMax, round(0.01 * AttDef * (SkillParam1 + AddHurt) * HurtParam * CritParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_CRIT};
                                                _ ->
                                                    {max(HurtMax, round(0.01 * AttDef * (SkillParam1 + AddHurt) * HurtParam * RandomParam + SkillParam2 + A_hurt_fix)), ?STATE_NORMAL}
                                            end
                                    end,
                                {max(HurtMax, round(Hurt99 * (1 + ElementHurtMult))), Status, max(HurtMax, round(Hurt99 * ElementHurtMult))};
                            false ->
                                {0, ?STATE_DODGE, 0}
                        end;
                    false ->
                        {0, ?STATE_NORMAL, 0}
                end
        end,
    {Hurt2, D_mana2} = ?IF_ELSE(D_mana > Hurt, {0, D_mana - Hurt}, {Hurt - D_mana, 0}),%%法盾减免伤害
    ?DO_IF(scene:is_field_boss_scene(Der#bs.scene) andalso Der#bs.sign == ?SIGN_MON, field_boss_roll:roll_handle(Der#bs.mana_lim, D_mana, D_mana2, Der)),
    ?DO_IF(D_mana > 0 andalso D_mana2 =< 0, erase_mana_buff(Der)),
    D_hp2 = ?IF_ELSE(D_hp > Hurt2, round(D_hp - Hurt2), 0),
    D_hp3 = if
                D_hp2 =< 0 andalso FixProtect -> 1;
                D_hp2 =< 0 andalso A_sign == ?SIGN_PLAYER -> 0;
                D_hp2 =< 0 andalso A_sign == ?SIGN_MON andalso D_sign == ?SIGN_PLAYER -> 0;
                D_hp2 =< 0 andalso A_sign == ?SIGN_MON andalso D_sign == ?SIGN_MON ->
                    IsDunGeonGuard = dungeon_util:is_dungeon_guard_cross(D_scene),
                    if
                        D_boss =< 0 -> 0;
                        D_scene == ?SCENE_ID_KINDOM_GUARD_ID -> 0;
                        D_scene == ?SCENE_ID_DUN_GUARD -> 0;
                        IsDunGeonGuard -> 0;
                        true -> 1
                    end;
                D_hp2 =< 0 -> 1;
                true ->
                    D_hp2
            end,
    D_hurt_list = [[?HURT_TYPE_NORMAL, Hurt2] | Der#bs.hurt_list],
    A_kill_list2 = ?IF_ELSE(D_hp3 == 0, [[D_sign, D_key, D_mid] | A_kill_list], A_kill_list),
    Attacker = make_attacker(Aer, Hurt),
    {Aer#bs{kill_list = A_kill_list2}, Der#bs{attacker = Attacker, state = Dstate, hp = D_hp3, mana = D_mana2, hurt_list = D_hurt_list, element_hurt = ElementHurt}, Hurt}.

erase_mana_buff(Der) ->
    F = fun(SkillBuff) ->
        #skillbuff{
            buffid = BuffId,
            subtype = SubType
        } = SkillBuff,
        case SubType == 2 of
            true ->
                buff_proc:reset_buff(Der#bs.node, Der#bs.pid, BuffId);
            false -> skip
        end
        end,
    lists:foreach(F, Der#bs.buff_list).


make_attacker(ScenePlayer, Sign) when is_record(ScenePlayer, scene_player) ->
    #attacker{
        key = ScenePlayer#scene_player.key,
        sign = Sign,
        scene = ScenePlayer#scene_player.scene,
        x = ScenePlayer#scene_player.x,
        y = ScenePlayer#scene_player.y,
        copy = ScenePlayer#scene_player.copy,
        group = ScenePlayer#scene_player.group,
        lv = ScenePlayer#scene_player.lv,
        gkey = ScenePlayer#scene_player.guild_key,
        eli_group = ScenePlayer#scene_player.eliminate_group,
        node = ScenePlayer#scene_player.node,
        sid = ScenePlayer#scene_player.sid,
        att_area = ScenePlayer#scene_player.attribute#attribute.att_area,
        cbp = ScenePlayer#scene_player.cbp,
        field_boss_times = ScenePlayer#scene_player.field_boss_times
    };
make_attacker(Mon, Sign) when is_record(Mon, mon) ->

    #attacker{
        key = Mon#mon.key,
        sign = Sign,
        scene = Mon#mon.scene,
        x = Mon#mon.x,
        y = Mon#mon.y,
        copy = Mon#mon.copy,
        group = Mon#mon.group,
        lv = Mon#mon.lv,
        gkey = Mon#mon.guild_key,
        eli_group = Mon#mon.eliminate_group,
        att_area = Mon#mon.att_area
    };
make_attacker(Aer, Hurt) when is_record(Aer, bs) ->
    #attacker{
        key = Aer#bs.key,
        cbp = Aer#bs.cbp,
        hp = Aer#bs.hp,
        hp_lim = Aer#bs.hp_lim,
        lv = Aer#bs.lv,
        name = Aer#bs.name,
        pid = Aer#bs.pid,
        team = Aer#bs.team,
        group = Aer#bs.group,
        sign = Aer#bs.sign,
        x = Aer#bs.x, y = Aer#bs.y,
        hurt = Hurt,
        is_shadow = Aer#bs.is_shadow,
        shadow_key = Aer#bs.shadow_key,
        gkey = Aer#bs.guild_key,
        gname = Aer#bs.guild_name,
        node = Aer#bs.node,
        sn = Aer#bs.sn,
        pk_status = Aer#bs.pk#pk.pk,
        mid = Aer#bs.mid,
        convoy_rob = Aer#bs.convoy_rob,
        vip = Aer#bs.vip,
        figure = Aer#bs.figure,
        field_boss_times = Aer#bs.field_boss_times
    };
make_attacker(_, _) -> #attacker{}.

%%硬直效果
%%battle_add_faint(BS) ->
%%    effect:add_effect(BS, [{99999, 1, [3]}], 0, 1).
%%get_faint_ratio(Diff) ->
%%    if Diff =< 1 -> 4;
%%        Diff =< 2 -> 8;
%%        Diff =< 3 -> 12;
%%        Diff =< 4 -> 16;
%%        Diff =< 5 -> 20;
%%        Diff =< 6 -> 21;
%%        Diff =< 7 -> 22;
%%        Diff =< 8 -> 23;
%%        Diff =< 9 -> 24;
%%        Diff =< 10 -> 25;
%%        Diff =< 11 -> 26;
%%        Diff =< 12 -> 27;
%%        Diff =< 13 -> 28;
%%        Diff =< 14 -> 29;
%%        true -> 30
%%    end.

%%
%%%%扣怒气
%%skill_mp_cost(Aer, Skill) ->
%%    Mp = Aer#bs.mp + Skill#skill.mp,
%%    if
%%        Mp >= 0 ->
%%            Mp1 = ?IF_ELSE(Mp > Aer#bs.mp_lim, Aer#bs.mp_lim, Mp),
%%            {Aer#bs{mp = Mp1}, Skill};
%%        true ->
%%            {Aer, #skill{}}
%%    end.
%%
%%%%检查玩家身上eff效果是否能发起攻击
%%check_skill_effect(Aer, _Skill) ->
%%    {true, Aer}.
%%
%%%%检查技能限制
%%check_skill_limit(Aer, _TargetData, _Skill) ->
%%    {true, Aer}.

check_att_mon_area(AttArea, X, Y, TarX, TarY, Mid) ->
    %%某些怪物不判断距离
    case lists:member(Mid, [50107,50108]) of
        true -> true;
        false ->
            (AttArea + 2 >= abs(X - TarX)) andalso (AttArea * 1.5 + 4 >= abs(Y - TarY))
    end.
check_att_area(AttArea, X, Y, TarX, TarY) ->
    (AttArea + 2 >= abs(X - TarX)) andalso (AttArea * 1.5 + 4 >= abs(Y - TarY)).

%% 验证攻击范围
%%check_attarea([], _, AllowData) -> AllowData;
%%check_attarea([Target | L], {Att_area, X1, Y1}, AllowData) ->
%%    case Att_area + 2 >= abs(X1 - Target#bs.x) of
%%        true ->
%%            case Att_area * 1.5 + 4 >= abs(Y1 - Target#bs.y) of
%%                true ->
%%                    check_attarea(L, {Att_area, X1, Y1}, [Target | AllowData]);
%%                false ->
%%                    check_attarea(L, {Att_area, X1, Y1}, AllowData)
%%            end;
%%        false ->
%%            check_attarea(L, {Att_area, X1, Y1}, AllowData)
%%    end.

%% 过滤pk状态
check_pk(TargetList, Aer, Now, IsSelfSkill) ->
    DataScene = data_scene:get(Aer#bs.scene),
    PkProtect = DataScene#scene.pk_protect,
    AttRedName = DataScene#scene.att_red_name,
    check_pk_status(TargetList, {PkProtect, AttRedName, Aer}, [], Now, IsSelfSkill).

check_pk_status([], _, AllowData, _Now, _SkillId) -> AllowData;
check_pk_status([Target | L], {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill) ->
    RedNameVal = prison:get_red_name_val(),
    ProtectLv = prison:get_protect_lv(),
    {MinLv, MaxLv} = prison:get_first_kill_protect_lv(),
    if
        Aer#bs.scene == ?SCENE_ID_CROSS_ELITE ->
            check_pk_status(L, {PkProtect, AttRedName, Aer}, [Target | AllowData], Now, IsSelfSkill);
        Target#bs.kind == ?MON_KIND_MANOR andalso Aer#bs.pk#pk.pk /= ?PK_TYPE_GUILD andalso Aer#bs.pk#pk.pk /= ?PK_TYPE_FIGHT ->
            check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill);
        Target#bs.pk#pk.value > RedNameVal andalso AttRedName == 1 ->
            %%红名玩家不受保护
            check_pk_status(L, {PkProtect, AttRedName, Aer}, [Target | AllowData], Now, IsSelfSkill);
        IsSelfSkill ->
            if Target#bs.group == Aer#bs.group ->
                check_pk_status(L, {PkProtect, AttRedName, Aer}, [Target | AllowData], Now, IsSelfSkill);
                true ->
                    check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill)
            end;
        Target#bs.group > 0 andalso Target#bs.group == Aer#bs.group ->
            %%同阵营不能被攻击
            check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill);
        Aer#bs.sign == ?SIGN_PLAYER andalso Target#bs.sign == ?SIGN_PLAYER
            andalso Target#bs.pk#pk.pk == ?PK_TYPE_PEACE andalso Target#bs.lv =< ProtectLv ->
            %%不能打和平模式，并且在保护等级以下的玩家
            check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill);
        Aer#bs.sign == ?SIGN_PLAYER andalso Target#bs.sign == ?SIGN_PLAYER
            andalso Target#bs.pk#pk.pk == ?PK_TYPE_PEACE andalso Target#bs.pk#pk.protect_time > Now
            andalso (Target#bs.lv >= MinLv andalso Target#bs.lv =< MaxLv) ->
            %%击杀保护时间内，不被攻击
            check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill);
        true ->
            %%玩家处于自己的势力点内不能被攻击
%%            case guild_war_util:is_protect_area(Target#bs.scene, Target#bs.x, Target#bs.y, Target#bs.group) of
%%                true ->
%%                    check_pk_status(L, {PkProtect, Aer}, AllowData);
%%                false ->
            ProtectSign =
                if
                    Aer#bs.sign == ?SIGN_MON orelse Target#bs.sign == ?SIGN_MON -> -1;
                    Target#bs.pk#pk.pk == ?PK_TYPE_PEACE andalso Aer#bs.pk#pk.pk == ?PK_TYPE_FIGHT -> 0;
                    Target#bs.pk#pk.pk == ?PK_TYPE_PEACE andalso Aer#bs.pk#pk.pk == ?PK_TYPE_PEACE -> 0;
                    is_pid(Target#bs.team) andalso Target#bs.team == Aer#bs.team -> 2;
                    Target#bs.guild_key /= 0 andalso Target#bs.guild_key == Aer#bs.guild_key -> 3;
                    Target#bs.sn == Aer#bs.sn -> 4;
                    true -> -1
                end,
%%            ?PRINT("ProtectSign:~p  |  PkProtect:~p ~n", [ProtectSign, PkProtect]),
            case lists:member(ProtectSign, PkProtect) of
                true ->
                    check_pk_status(L, {PkProtect, AttRedName, Aer}, AllowData, Now, IsSelfSkill);
                false ->
                    check_pk_status(L, {PkProtect, AttRedName, Aer}, [Target | AllowData], Now, IsSelfSkill)
            end
%%            end
    end.


%% skill cd
check_skill_cd(Aer, Skill) ->
    Sid = Skill#skill.skillid,
    BfSkillId = data_battlefield:skill_id(),
    if
        Aer#bs.sign == ?SIGN_MAGIC_WEAPON orelse Aer#bs.sign == ?SIGN_GOD_WEAPON orelse Aer#bs.sign == ?SIGN_BABY ->
            Skill_cd2 = [{Sid, Aer#bs.now + Skill#skill.cd} | lists:keydelete(Sid, 1, Aer#bs.new_skill_cd)],
            {Aer#bs{new_skill_cd = Skill_cd2}, Skill};
        Sid > 0 andalso Sid /= 10010 andalso Sid /= BfSkillId ->
            CdSec = Skill#skill.cd,
            Now = Aer#bs.now,
            case lists:keyfind(Sid, 1, Aer#bs.skill_cd) of
                false ->
                    {Aer#bs{new_skill_cd = [{Sid, Now + CdSec} | Aer#bs.new_skill_cd]}, Skill};
                {_, ExpireTime} ->
                    case ExpireTime =< Now of
                        true ->
                            Skill_cd2 = [{Sid, Now + CdSec} | lists:keydelete(Sid, 1, Aer#bs.new_skill_cd)],
                            {Aer#bs{new_skill_cd = Skill_cd2}, Skill};
                        false ->
                            {Aer, #skill{}}
                    end
            end;
        true ->
            {Aer, Skill}
    end.

%% divide([],AliveList,DeadList) ->
%%     {AliveList,DeadList};
%% divide([BS|L],AliveList,DeadList) ->
%%     ?IF_ELSE(BS#bs.hp > 0,divide(L,[BS|AliveList],DeadList),divide(L,AliveList,[BS|DeadList])).

battle_msg(BS, SkillId, BSList) ->
    Msg = battle_pack:pack_battle_info_helper(BSList),
    {ok, Bin} = pt_200:write(20001, {SkillId, Msg, BS#bs.skill_effect}),
    case scene:is_broadcast_scene(BS#bs.scene) of
        true ->
            server_send:send_to_scene(BS#bs.scene, BS#bs.copy, Bin);
%%            server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, Bin]);
        false ->
            server_send:send_to_scene(BS#bs.scene, BS#bs.copy, BS#bs.x, BS#bs.y, Bin)
%%            server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, BS#bs.x, BS#bs.y, Bin])
    end.
%%    case scene:is_cross_boss_scene(BS#bs.scene) orelse scene:is_field_boss_scene(BS#bs.scene) of
%%        false ->
%%            case scene:is_broadcast_scene(BS#bs.scene) of
%%                true ->
%%                    server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, Bin]);
%%                false ->
%%                    server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, BS#bs.x, BS#bs.y, Bin])
%%            end;
%%        true ->
%%            if BS#bs.sign == ?SIGN_PET ->
%%                server_send:rpc_node_apply(BS#bs.node, server_send, send_to_pid, [BS#bs.pid, Bin]);
%%                true ->
%%                    case scene:is_broadcast_scene(BS#bs.scene) of
%%                        true ->
%%                            server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, Bin]);
%%                        false ->
%%                            server_send:rpc_node_apply(BS#bs.node, server_send, send_to_scene, [BS#bs.scene, BS#bs.copy, BS#bs.x, BS#bs.y, Bin])
%%                    end
%%            end
%%    end.


%%同步单位数据
sync_obj([], _SkillId) -> ok;
sync_obj([BS | L], SkillId) ->
    case BS#bs.sign of
        ?SIGN_PLAYER ->
            sync_player(BS, SkillId);
        ?SIGN_PET when BS#bs.is_shadow == 1 ->
            sync_mon(BS);
        ?SIGN_PET ->
            sync_player(BS, SkillId);
        ?SIGN_MAGIC_WEAPON -> skip;
        ?SIGN_BABY -> skip;
        ?SIGN_GOD_WEAPON -> skip;
        ?SIGN_MON ->
            sync_mon(BS);
        _ ->
            ok
    end,
    sync_obj(L, SkillId).


%%同步玩家进程
sync_player(BS, SkillId) ->
    #bs{
        actor = Actor,
        pid = Pid,
        node = Node,
        hp = Hp,
        mp = Mp,
        x = X,
        y = Y,
        is_move = IsMove,
        sin = Sin,
        now2 = LongTime,
        now = Time,
        speed = Speed,
        time_mark = TimeMark,
        buff_list = BuffList,
        kill_list = KillList,
        attacker = Attacker,
        hurt_list = HurtList
    } = BS,
    Ast = TimeMark#time_mark.ast,
    Lat = TimeMark#time_mark.lat,
    Ast2 = ?IF_ELSE(Time - Lat > 5, Time, Ast),
    Ldt = ?IF_ELSE(Hp =< 0, Time, TimeMark#time_mark.ldt),
    TimeMark2 = TimeMark#time_mark{ast = Ast2, lat = Time, ldt = Ldt},
    NewSkillId = ?IF_ELSE(Actor == ?ACTOR_ATT, SkillId, 0),
    Damage = lists:sum([Hurt || [_, Hurt] <- HurtList]),
    Msg =
        case Hp > 0 of
            true ->
                {battle_info, {Hp, Mp, X, Y, IsMove, Sin, Speed, LongTime, TimeMark2, BuffList, KillList, NewSkillId, Damage}};
            false ->
                {battle_die, {Hp, Mp, X, Y, IsMove, LongTime, Attacker, Damage}}
        end,
    server_send:send_node_pid(Node, Pid, Msg).

%%同步怪物进程
sync_mon(BS) ->
    #bs{
        pid = Pid,
        node = _Node,
        hp = Hp,
        mp = Mp,
        x = X,
        y = Y,
        is_move = IsMove,
        now2 = LongTime,
        now = Time,
        speed = Speed,
        time_mark = TimeMark,
        buff_list = BuffList,
        skill_cd = SkillCd,
        attacker = Attacker,
        t_att = Tatt,
        t_def = Tdef,
        mana = Mana,
        mana_lim = ManaLim
    } = BS,
    Ast = TimeMark#time_mark.ast,
    Lat = TimeMark#time_mark.lat,
    Ldt = ?IF_ELSE(Hp =< 0, Time, TimeMark#time_mark.ldt),
    Ast2 = ?IF_ELSE(Time - Lat > 5, Time, Ast),
    TimeMark2 = TimeMark#time_mark{ast = Ast2, lat = Time, ldt = Ldt},
    Pid ! {battle_info_mon, {Hp, Mp, X, Y, IsMove, Speed, LongTime, TimeMark2, BuffList, SkillCd, Tatt, Tdef, Mana, ManaLim}, Attacker}.
%%    server_send:send_node_pid(Node, Pid, {battle_info_mon, {Hp, Mp, X, Y, IsMove, Speed, LongTime, TimeMark2, BuffList, SkillCd, Tatt, Tdef, Mana, ManaLim}, Attacker}).

remark([], List) ->
    lists:reverse(List);
remark([BS | L], List) ->
    case BS#bs.sign of
        ?SIGN_PET when BS#bs.is_shadow == 1 ->
            remark(L, [BS#bs{sign = ?SIGN_MON} | List]);
        ?SIGN_PET ->
            remark(L, [BS#bs{sign = ?SIGN_PLAYER} | List]);
        _ ->
            remark(L, [BS | List])
    end.


%%同步场景数据
sync_scene_obj([], Scene, Copy, MsgList) ->
    scene_agent_dispatch:dispatch(Scene, Copy, {sync_scene_obj_list, MsgList}),
    ok;
sync_scene_obj([BS | L], Scene, Copy, MsgList) when (BS#bs.sign == ?SIGN_MAGIC_WEAPON orelse BS#bs.sign == ?SIGN_GOD_WEAPON orelse BS#bs.sign == ?SIGN_BABY) ->
    #bs{
        new_skill_cd = SkillCd,
        buff_list = BuffList,
        attacker = Attacker
    } = BS,
    Sign = ?IF_ELSE(BS#bs.is_shadow == 1, ?SIGN_MON, ?SIGN_PLAYER),
    Msg = {battle_eff, Sign, BS#bs.key, SkillCd, BuffList, Attacker#attacker.key},
    sync_scene_obj(L, Scene, Copy, [Msg | MsgList]);
sync_scene_obj([BS | L], Scene, Copy, MsgList) when BS#bs.sign == ?SIGN_MON orelse BS#bs.sign == ?SIGN_PLAYER ->
    #bs{
        key = Key,
        sign = Sign,
        hp = Hp,
        mp = Mp,
        mana_lim = Manalim,
        mana = Mana,
        sin = Sin,
        x = X,
        y = Y,
        is_move = IsMove,
        now = Time,
        now2 = LongTime,
        buff_list = BuffList,
        new_skill_cd = SkillCd,
        obj_ref = ObjRef,
        time_mark = TimeMark,
        t_att = Tatt,
        t_def = Tdef,
        attacker = Attacker
    } = BS,
    Ast = TimeMark#time_mark.ast,
    Lat = TimeMark#time_mark.lat,
    Ast2 = ?IF_ELSE(Time - Lat > 5, Time, Ast),
    Godt = ?IF_ELSE(BS#bs.actor == ?ACTOR_ATT, 0, TimeMark#time_mark.godt),
    Ldt = ?IF_ELSE(Hp =< 0, Time, TimeMark#time_mark.ldt),
    TimeMark2 = TimeMark#time_mark{ast = Ast2, lat = Time, godt = Godt, ldt = Ldt},
    Msg = {Sign, Key, Hp, Mp, Manalim, Mana, Sin, X, Y, IsMove, LongTime, BuffList, SkillCd, ObjRef, TimeMark2, Tatt, Tdef, Attacker#attacker.key},
    sync_scene_obj(L, Scene, Copy, [Msg | MsgList]);

sync_scene_obj([_BS | L], Scene, Copy, MsgList) ->
    sync_scene_obj(L, Scene, Copy, MsgList).

init_data(P, LongTime) ->
    init_data(P, 0, LongTime).
init_data(P, Sign, LongTime) ->
    Now = LongTime div 1000, %秒
    BS =
        if
            is_record(P, mon) ->
                BsArgs = #bs_args{
                    unyun = P#mon.unyun,
                    unbeat_back = P#mon.unbeat_back,
                    unholding = P#mon.unholding,
                    unfreeze = P#mon.unfreeze,
                    uncm = P#mon.uncm
                },
                IsShadow = ?IF_ELSE(P#mon.shadow_key == 0, 0, 1),
                #bs{
                    key = P#mon.key,
                    name = P#mon.name,
                    pid = P#mon.pid,
                    now = Now,
                    now2 = LongTime,
                    sign = max(Sign, ?SIGN_MON),
                    is_shadow = IsShadow,
                    shadow_key = P#mon.shadow_key,
                    scene = P#mon.scene,
                    x = P#mon.x,
                    y = P#mon.y,
                    copy = P#mon.copy,
                    group = P#mon.group,
                    lv = P#mon.lv,
                    mid = P#mon.mid,
                    kind = P#mon.kind,
                    boss = P#mon.boss,
                    skill = P#mon.skill,
                    %% -- 属性
                    att_area = P#mon.att_area,
                    hp_lim = P#mon.hp_lim,
                    hp = P#mon.hp,
                    mp_lim = P#mon.mp_lim,
                    mp = P#mon.mp,
                    att = P#mon.att,
                    def = P#mon.def,
                    dodge = P#mon.dodge,
                    crit = P#mon.crit,
                    hit = P#mon.hit,
                    ten = P#mon.ten,
                    crit_inc = P#mon.crit_inc,
                    crit_dec = P#mon.crit_dec,
                    hurt_inc = P#mon.hurt_inc,
                    hurt_dec = P#mon.hurt_dec,
                    hp_lim_inc = P#mon.hp_lim_inc,
                    pvp_inc = P#mon.pvp_inc,
                    pvp_dec = P#mon.pvp_dec,

                    fire_att = P#mon.fire_att, %% 火系元素攻击
                    fire_def = P#mon.fire_def, %% 火系元素防御
                    wood_att = P#mon.wood_att, %% 木系元素攻击
                    wood_def = P#mon.wood_def, %% 木系元素防御
                    wind_att = P#mon.wind_att, %% 风系元素攻击
                    wind_def = P#mon.wind_def, %% 风系元素防御
                    water_att = P#mon.water_att, %% 水系元素攻击
                    water_def = P#mon.water_def, %% 水系元素防御
                    light_att = P#mon.light_att, %% 光系元素攻击
                    light_def = P#mon.light_def, %% 光系元素防御
                    dark_att = P#mon.dark_att, %% 暗系元素攻击
                    dark_def = P#mon.dark_def, %% 暗系元素防御

                    recover = P#mon.recover,
                    recover_hit = P#mon.recover_hit,
                    size = P#mon.size,
                    cure = P#mon.cure,
                    speed = P#mon.speed,
                    base_speed = P#mon.speed,
                    %% --
                    mana_lim = P#mon.mana_lim,
                    mana = P#mon.mana,
                    bs_args = BsArgs,
                    obj_ref = P#mon.obj_ref,
                    buff_list = P#mon.buff_list,
                    dieeff_list = P#mon.dieeff,
                    skill_cd = P#mon.skill_cd,
                    time_mark = P#mon.time_mark,
                    pet_att_param = P#mon.pet_att_param,
                    t_att = P#mon.t_att,
                    t_def = P#mon.t_def

                };
            true ->
                Attribute = if
                                P#scene_player.scene == ?SCENE_ID_CROSS_SCUFFLE -> P#scene_player.scuffle_attribute;
                                P#scene_player.scene == ?SCENE_ID_CROSS_SCUFFLE_ELITE ->
                                    P#scene_player.scuffle_elite_attribute;
                                true -> P#scene_player.attribute
                            end,
                #attribute{
                    hp_lim = HpLim,
                    mp_lim = MpLim,
                    att = Att,
                    def = Def,
                    dodge = Dodge,
                    crit = Crit,
                    hit = Hit,
                    ten = Ten,
                    crit_inc = CritInc,
                    crit_dec = CritDec,
                    hurt_inc = HurtInc,
                    hurt_dec = HurtDec,
                    pvp_inc = PvpInc,
                    pvp_dec = PvpDec,

                    fire_att = FireAtt, %% 火系元素攻击
                    fire_def = FireDef, %% 火系元素防御
                    wood_att = WoodAtt, %% 木系元素攻击
                    wood_def = WoodDef, %% 木系元素防御
                    wind_att = WindAtt, %% 风系元素攻击
                    wind_def = WindDef, %% 风系元素防御
                    water_att = WaterAtt, %% 水系元素攻击
                    water_def = WaterDef, %% 水系元素防御
                    light_att = LightAtt, %% 光系元素攻击
                    light_def = LightDef, %% 光系元素防御
                    dark_att = DarkAtt, %% 暗系元素攻击
                    dark_def = DarkDef, %% 暗系元素防御

                    hp_lim_inc = HpLimInc,
                    recover = Recover,
                    recover_hit = RecoverHit,
                    size = Size,
                    cure = Cure,
                    prepare = Prepare,
                    att_area = Att_area,
                    speed = Speed
                } = Attribute,
                #batt_info{
                    skill = Skill,
                    skill_cd = SkillCd,
                    buff_list = BuffList,
                    obj_ref = ObjRef,
                    time_mark = TimeMark
                } = P#scene_player.battle_info,
                #bs{
                    key = P#scene_player.key,
                    name = P#scene_player.nickname,
                    pid = P#scene_player.pid,
                    now = Now,
                    now2 = LongTime,
                    sign = max(Sign, ?SIGN_PLAYER),
                    scene = P#scene_player.scene,
                    x = P#scene_player.x,
                    y = P#scene_player.y,
                    copy = P#scene_player.copy,
                    lv = P#scene_player.lv,
                    career = P#scene_player.career,
                    team = P#scene_player.team,
                    group = P#scene_player.group,
                    realm = P#scene_player.realm,
                    guild_key = P#scene_player.guild_key,
                    guild_name = P#scene_player.guild_name,
                    att_area = ?IF_ELSE(P#scene_player.pf == 888, 10, Att_area),
                    skill = Skill,
                    skill_effect = P#scene_player.skill_effect,
                    skill_cd = SkillCd,
                    passive_skill = P#scene_player.passive_skill,
                    obj_ref = ObjRef,
                    buff_list = BuffList,
                    time_mark = TimeMark,
                    mana_lim = P#scene_player.mana_lim,
                    mana = P#scene_player.mana,
                    %%属性
                    hp_lim = HpLim,
                    hp = P#scene_player.hp,
                    mp_lim = MpLim,
                    mp = P#scene_player.mp,
                    sin = P#scene_player.sin,
                    evil = P#scene_player.evil#pevil.evil,
                    att = Att,
                    def = Def,
                    dodge = Dodge,
                    crit = Crit,
                    hit = Hit,
                    ten = Ten,
                    crit_inc = CritInc,
                    crit_dec = CritDec,
                    hurt_inc = HurtInc,
                    hurt_dec = HurtDec,
                    pvp_inc = PvpInc,
                    pvp_dec = PvpDec,
                    hp_lim_inc = HpLimInc,
                    fire_att = FireAtt, %% 火系元素攻击
                    fire_def = FireDef, %% 火系元素防御
                    wood_att = WoodAtt, %% 木系元素攻击
                    wood_def = WoodDef, %% 木系元素防御
                    wind_att = WindAtt, %% 风系元素攻击
                    wind_def = WindDef, %% 风系元素防御
                    water_att = WaterAtt, %% 水系元素攻击
                    water_def = WaterDef, %% 水系元素防御
                    light_att = LightAtt, %% 光系元素攻击
                    light_def = LightDef, %% 光系元素防御
                    dark_att = DarkAtt, %% 暗系元素攻击
                    dark_def = DarkDef, %% 暗系元素防御
                    speed = Speed,
                    base_speed = Speed,
                    recover = Recover,
                    recover_hit = RecoverHit,
                    size = Size,
                    cure = Cure,
                    prepare = Prepare,
                    pk = P#scene_player.pk,
                    node = P#scene_player.node,
                    sn = P#scene_player.sn_cur,
                    pet_att_param = P#scene_player.pet#scene_pet.att_param,
                    t_att = P#scene_player.t_att,
                    t_def = P#scene_player.t_def,
                    convoy_rob = P#scene_player.convoy_rob,
                    vip = P#scene_player.vip,
                    figure = P#scene_player.figure,
                    new_career = P#scene_player.new_career,
                    cbp = P#scene_player.cbp,
                    field_boss_times = P#scene_player.field_boss_times
                }
        end,
%%    BS1 = effect:add_effect(BS, BS#bs.dieeff_list, 0, 1),
    buff:buff_to_eff(BS, BS#bs.buff_list).

%%采集
collect(Pkey, Mkey, Action, Figure, Plv, PartyTimes) ->
    Res = case scene_agent:dict_get_player(Pkey) of
              [] ->
                  0;
              ScenePlayer ->
                  case mon_agent:dict_get_mon(Mkey) of
                      [] ->
                          mon_util:hide_mon(Mkey, ScenePlayer#scene_player.node, ScenePlayer#scene_player.sid),
                          0;
                      SceneMon ->
                          if
                              ScenePlayer#scene_player.hp =< 0 orelse SceneMon#mon.hp =< 0 ->
                                  0;
                              abs(ScenePlayer#scene_player.x - SceneMon#mon.x) > 5 orelse abs(ScenePlayer#scene_player.y - SceneMon#mon.y) > 5 orelse ScenePlayer#scene_player.copy /= SceneMon#mon.copy ->
                                  0;
%%                              SceneMon#mon.kind == ?MON_KIND_INVADE_BOX andalso ScenePlayer#scene_player.lv < ?INVADE_OPEN_LV ->
%%                                  13;
                              SceneMon#mon.kind == ?MON_KIND_GRACE_COLLECT andalso ScenePlayer#scene_player.lv < ?GRACE_OPEN_LV ->
                                  14;
                              ScenePlayer#scene_player.eliminate_group /= SceneMon#mon.eliminate_group ->
                                  20;
%%                              SceneMon#mon.kind == ?MON_KIND_CROSS_WAR_GUN_CARRIER andalso ScenePlayer#scene_player.group == 1 ->
%%                                  23;
                              SceneMon#mon.kind == ?MON_KIND_CROSS_WAR_KING_GOLD andalso SceneMon#mon.group == ?CROSS_WAR_TYPE_DEF andalso ScenePlayer#scene_player.group == ?CROSS_WAR_TYPE_DEF ->
                                  41;
                              true ->
                                  SceneMon#mon.pid ! {collect, ScenePlayer#scene_player.node, Pkey, ScenePlayer#scene_player.pid, ScenePlayer#scene_player.nickname, ScenePlayer#scene_player.guild_key, Action, Figure, Plv, PartyTimes},
                                  1
                          end
                  end
          end,
    if
        Res /= 1 ->
            {ok, Bin} = pt_200:write(20003, {Res}),
            server_send:send_to_key(Pkey, Bin);
        true ->
            skip
    end,
    ok.

%%
%%%%攻击回蓝
%%restore_mp(aer, BS) when BS#bs.sign == ?SIGN_PLAYER ->
%%    BsArgs = BS#bs.bs_args,
%%    Mp =
%%        if
%%            BS#bs.career == ?CAREER1 andalso BsArgs#bs_args.skillid == 0 ->
%%                min(BS#bs.mp_lim, BS#bs.mp + 3);
%%            BS#bs.career == ?CAREER3 andalso BsArgs#bs_args.skillid == 0 ->
%%                min(BS#bs.mp_lim, BS#bs.mp + 5);
%%            true ->
%%                BS#bs.mp
%%        end,
%%    BS#bs{mp = Mp};
%%%%被击回蓝
%%restore_mp(der, BS) when BS#bs.sign == ?SIGN_PLAYER ->
%%    TimeMark = BS#bs.time_mark,
%%    {Mp, Rmh} =
%%        if
%%            BS#bs.career == ?CAREER4 andalso (BS#bs.now - TimeMark#time_mark.rmh) > 1 ->
%%                {min(BS#bs.mp_lim, BS#bs.mp + 7), BS#bs.now};
%%            true ->
%%                {BS#bs.mp, TimeMark#time_mark.rmh}
%%        end,
%%    BS#bs{mp = Mp, time_mark = TimeMark#time_mark{rmh = Rmh}};
%%%%时间回蓝
%%restore_mp(time, BS) when BS#bs.sign == ?SIGN_PLAYER ->
%%    TimeMark = BS#bs.time_mark,
%%    {Mp, Rmt} =
%%        if
%%            BS#bs.career == ?CAREER2 ->
%%                Diff = BS#bs.now - TimeMark#time_mark.rmt,
%%                ?IF_ELSE(Diff > 1, {min(BS#bs.mp_lim, BS#bs.mp + Diff * 5), BS#bs.now}, {BS#bs.mp, TimeMark#time_mark.rmt});
%%            BS#bs.career == ?CAREER4 ->
%%                Diff = BS#bs.now - TimeMark#time_mark.rmt,
%%                ?IF_ELSE(Diff > 1, {min(BS#bs.mp_lim, BS#bs.mp + Diff * 2), BS#bs.now}, {BS#bs.mp, TimeMark#time_mark.rmt});
%%            true ->
%%                {BS#bs.mp, TimeMark#time_mark.rmt}
%%        end,
%%    BS#bs{mp = Mp, time_mark = TimeMark#time_mark{rmt = Rmt}};
%%%%击杀回蓝
%%restore_mp(kill, BS) when BS#bs.sign == ?SIGN_PLAYER ->
%%    Mp =
%%        if
%%            BS#bs.career == ?CAREER2 ->
%%                min(BS#bs.mp_lim, BS#bs.mp + 2);
%%            true ->
%%                BS#bs.mp
%%        end,
%%    BS#bs{mp = Mp};
%%restore_mp(_, BS) ->
%%    BS.
%%

check_dark_buff(D_BuffList) ->
    F = fun(BuffId) ->
        lists:keymember(BuffId, #skillbuff.buffid, D_BuffList)
        end,
    lists:any(F, [56003, 56004]).





