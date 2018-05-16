%%%-----------------------------------
%%% @Module  : mon_ai
%%% @Author  : fancy
%%% @Email   : 1812338@qq.com
%%% @Created : 2015.7
%%% @Description: 怪物Ai
%%%-----------------------------------

-module(mon_ai).
-include("scene.hrl").
-include("skill.hrl").
-include("common.hrl").
-include("battle.hrl").
-export([
    skill_ai/2,
    get_path/4,
    do_eff_list/3,
    skill_ready/2,
    dest_path/5
]).

%%技能是否吟唱
skill_ready(_Minfo, DataSkill) ->
    case DataSkill of
        [] ->
            false;
        Skill ->
            case Skill#skill.yctime > 0 of
                true ->
                    {true, Skill#skill.yctime, Skill#skill.singRes};
                false ->
                    {true, Skill}
            end
    end.


%%怪物技能触发ai
skill_ai(State, Now) ->
    Minfo = State#mon_act.minfo,
    OnceSkill = State#mon_act.once_skill,
    LastSkill = State#mon_act.last_skill,
    if Minfo#mon.shadow_key =/= 0 ->
        SkillInfo =
            get_player_skill(Minfo#mon.skill, [], Minfo#mon.skill_cd, Now),
        case SkillInfo of
            [] ->
                SkillId = random_shadow_skill(Minfo#mon.shadow_status#player.career),
                case skill:get_skill(SkillId) of
                    [] ->
                        {SkillId, 0, []};
                    SkillData ->
                        {SkillId, SkillData#skill.att_area, []}
                end;
            _ ->
                SkillId = hd(util:list_shuffle(SkillInfo)),
                case skill:get_skill(SkillId) of
                    [] ->
                        SkillId = random_shadow_skill(Minfo#mon.shadow_status#player.career),
                        case skill:get_skill(SkillId) of
                            [] ->
                                {SkillId, 0, []};
                            SkillData ->
                                {SkillId, SkillData#skill.att_area, []}
                        end;
                    SkillData ->
                        {SkillId, SkillData#skill.att_area, []}
                end
        end;
        true ->
            Skills = util:list_shuffle(lists:keydelete(LastSkill, 1, Minfo#mon.skill)),
            SkillInfo = get_mon_skill(Skills, [], Minfo#mon.skill_cd, Now),
            {SkillId, Target} = ?IF_ELSE(OnceSkill > 0, {OnceSkill, []}, skill_ai_helper(SkillInfo, State)),
            case skill:get_skill(SkillId) of
                [] ->
                    {0, 0, []};
                SkillData ->
                    {SkillId, SkillData#skill.att_area, Target}
            end
    end.

random_shadow_skill(_Career) ->
    case get(shadow_default_skill) of
        undefined ->
            case data_skill:career_skills(6) of
                [] -> 0;
                [Id | L] ->
                    put(shadow_default_skill, L ++ [Id]),
                    Id
            end;
        [Id | L] ->
            put(shadow_default_skill, L ++ [Id]),
            Id
    end.

%%技能ai触发
skill_ai_helper([], _State) ->
    {0, []};
skill_ai_helper([SkillAi | L], State) ->
    case SkillAi of
        {SkillId, TriggerCondition, TargetCondition} ->
            TriggerResult =
                case TriggerCondition of
                    [Pattern1, Op1, Pattern2, Op2, Pattern3] ->
                        if
                            Op1 == "and" andalso Op2 == "and" ->
                                parse_pattern(Pattern1, State) andalso parse_pattern(Pattern2, State) andalso parse_pattern(Pattern3, State);
                            Op1 == "or" andalso Op2 == "or" ->
                                parse_pattern(Pattern1, State) orelse parse_pattern(Pattern2, State) orelse parse_pattern(Pattern3, State);
                            true ->
                                false
                        end;
                    [Pattern1, Op1, Pattern2] ->
                        if
                            Op1 == "and" ->
                                parse_pattern(Pattern1, State) andalso parse_pattern(Pattern2, State);
                            Op1 == "or" ->
                                parse_pattern(Pattern1, State) orelse parse_pattern(Pattern2, State);
                            true ->
                                false
                        end;
                    [Pattern1] ->
                        parse_pattern(Pattern1, State);
                    [] ->
                        true;
                    _ ->
                        false
                end,
            if
                TriggerResult ->
                    TargetList =
                        case TargetCondition of
                            [PatternTarget1, OpT1, PatternTarget2] ->
                                if
                                    OpT1 == "and" ->
                                        Plist1 = target_condition([PatternTarget1], [], State),
                                        target_condition([PatternTarget2], Plist1, State);
                                    OpT1 == "or" ->
                                        Plist1 = target_condition([PatternTarget1], [], State),
                                        target_condition([PatternTarget2], [], State) ++ Plist1;
                                    true ->
                                        []
                                end;
                            [PatternTarget1] ->
                                target_condition([PatternTarget1], [], State);
                            _ ->
                                []
                        end,
                    Target =
                        case length(TargetList) > 0 of
                            true -> hd(util:list_shuffle(TargetList));
                            false -> []
                        end,
                    {SkillId, Target};
                true ->
                    skill_ai_helper(L, State)
            end;
        _ ->
            skill_ai_helper(L, State)
    end.

%%单项表达式分析
parse_pattern(Pattern, State) ->
    case Pattern of
        {P1, Op1, P2} ->
            if
                Op1 == "and" ->%%还有一层
                    [true, true] == trigger_condition([P1, P2], [], State);
                Op1 == "or" ->%%还有一层
                    lists:member(true, trigger_condition([P1, P2], [], State));
                Op1 == ">" orelse Op1 == "<" orelse Op1 == "==" ->
                    %%最后一层
                    hd(trigger_condition([{P1, Op1, P2}], [], State));
                true ->
                    false
            end;
        {Key, Value} -> %%最后一层
            hd(trigger_condition([{Key, Value}], [], State));
        _ ->
            false
    end.


%% 施放触发条件
trigger_condition([], Boollist, _State) ->
    Boollist;
trigger_condition([{Key, Value} | L], Boollist, State) ->
    trigger_condition([{Key, "==", Value} | L], Boollist, State);

trigger_condition([{Key, Operation, Value} | L], Boollist, State) ->
    Minfo = State#mon_act.minfo,
    case Key of
        11000 ->%%概率
            case util:rand(1, 100) < Value of
                true ->
                    trigger_condition(L, [true | Boollist], State);
                false ->
                    trigger_condition(L, [false | Boollist], State)
            end;
        11001 ->%%气血值
            Result =
                case Operation of
                    ">" -> trunc(Minfo#mon.hp / Minfo#mon.hp_lim * 100) > Value;
                    "<" -> trunc(Minfo#mon.hp / Minfo#mon.hp_lim * 100) < Value;
                    "==" -> trunc(Minfo#mon.hp / Minfo#mon.hp_lim * 100) == Value;
                    _ -> false
                end,
            trigger_condition(L, [Result | Boollist], State);
        11002 ->%%进入战斗
            TimeMark = Minfo#mon.time_mark,
            AttStartTime = TimeMark#time_mark.ast,
            Now = util:unixtime(),
            Result = if
                         AttStartTime > 0 ->
                             case Operation of
                                 ">" -> Now - AttStartTime > Value;
                                 "<" -> Now - AttStartTime < Value;
                                 "==" -> Now - AttStartTime == Value;
                                 _ -> false
                             end;
                         true ->
                             false
                     end,
            trigger_condition(L, [Result | Boollist], State);
        11003 ->%%攻击次数
            Result =
                case Operation of
                    ">" -> Minfo#mon.t_att > Value;
                    "<" -> Minfo#mon.t_att < Value;
                    "==" -> Minfo#mon.t_att == Value;
                    _ -> false
                end,
            trigger_condition(L, [Result | Boollist], State);
        _ ->
            trigger_condition(L, [false | Boollist], State)
    end.

%%施放目标
target_condition([], AttList, _State) ->
    AttList;
target_condition([{Key, Value} | L], AttList, State) ->
    target_condition([{Key, "==", Value} | L], AttList, State);

target_condition([{Key, Operation, Value} | L], AttList, State) ->
    AttackerList = State#mon_act.attlist,
    HatredList = State#mon_act.klist,
    case Key of
        12001 ->
            MaxHatredKey = monster:get_hatred_max(HatredList),
            MaxHatredAttacker =
                case lists:keyfind(MaxHatredKey, 2, AttackerList) of
                    false ->
                        [];
                    Attacker ->
                        [Attacker]
                end,
            target_condition(L, MaxHatredAttacker ++ AttList, State);
        12002 ->%%气血值
            case Operation of
                ">" ->
                    F = fun({_k, Attacker}) -> trunc(Attacker#attacker.hp / Attacker#attacker.hp_lim * 100) > Value end;
                "<" ->
                    F = fun({_k, Attacker}) -> trunc(Attacker#attacker.hp / Attacker#attacker.hp_lim * 100) < Value end;
                "==" -> F = fun({_k, Attacker}) ->
                    trunc(Attacker#attacker.hp / Attacker#attacker.hp_lim * 100) == Value end;
                _ -> F = fun(_) -> false end
            end,
            AttList2 = lists:filter(F, AttackerList),
            target_condition(L, AttList2 ++ AttList, State);
        12003 ->%%最大气血
            F = fun({_k, Attacker}, MaxInfo) ->
                if
                    Attacker#attacker.hp > MaxInfo#attacker.hp ->
                        Attacker;
                    true ->
                        MaxInfo
                end
            end,
            MaxAttackInfo = lists:foldl(F, #attacker{hp = 0}, AttackerList),
            NewAttList = [MaxAttackInfo],
            target_condition(L, NewAttList ++ AttList, State);
        12004 ->%%最小气血
            F = fun({_k, Attacker}, MinInfo) ->
                if
                    Attacker#attacker.hp < MinInfo#attacker.hp ->
                        Attacker;
                    true ->
                        MinInfo
                end
            end,
            MinAttackInfo = lists:foldl(F, #attacker{hp = 1000000000}, AttackerList),
            NewAttList = [MinAttackInfo],
            target_condition(L, NewAttList ++ AttList, State);
        12005 ->%%战力值
            case Operation of
                ">" -> F = fun({_k, Attacker}) -> Attacker#attacker.cbp > Value end;
                "<" -> F = fun({_k, Attacker}) -> Attacker#attacker.cbp < Value end;
                "==" -> F = fun({_k, Attacker}) -> Attacker#attacker.cbp == Value end;
                _ -> F = fun(_) -> false end
            end,
            AttList2 = lists:filter(F, AttackerList),
            target_condition(L, AttList2 ++ AttList, State);
        12006 ->%%最高战力
            F = fun({_k, Attacker}, MaxInfo) ->
                if
                    Attacker#attacker.cbp > MaxInfo#attacker.cbp ->
                        Attacker;
                    true ->
                        MaxInfo
                end
            end,
            MaxAttackInfo = lists:foldl(F, #attacker{cbp = 0}, AttackerList),
            NewAttList = [MaxAttackInfo],
            target_condition(L, NewAttList ++ AttList, State);
        12007 ->%%最低战力
            F = fun({_k, Attacker}, MinInfo) ->
                if
                    Attacker#attacker.cbp < MinInfo#attacker.cbp ->
                        Attacker;
                    true ->
                        MinInfo
                end
            end,
            MinAttackInfo = lists:foldl(F, #attacker{cbp = 1000000000}, AttackerList),
            NewAttList = [MinAttackInfo],
            target_condition(L, NewAttList ++ AttList, State);
        12008 ->%%受击次数
            false;
        _ ->
            target_condition(L, AttList, State)
    end.

%%获取技能
%%玩家技能列表 [{skillid,lv,state}]
get_player_skill([], CanUseList, _CdList, _Now) ->
    CanUseList;
get_player_skill([SkillId | L], CanUseList, CdList, Now) ->
    NewCanUseList =
        case lists:keyfind(SkillId, 1, CdList) of
            false ->
                [SkillId | CanUseList];
            {SkillId, ExpireTime} ->
                if
                    ExpireTime > Now ->
                        CanUseList;
                    true ->
                        [SkillId | CanUseList]
                end
        end,
    get_player_skill(L, NewCanUseList, CdList, Now).
%%怪物技能列表[{skillid,[触发ai],[目标ai]}]
get_mon_skill([], CanUseList, _CdList, _Now) ->
    CanUseList;
get_mon_skill([{SkillId, TriggerCondition, TargetCondition} | L], CanUseList, CdList, Now) ->
    NewCanUseList =
        case lists:keyfind(SkillId, 1, CdList) of
            false ->
                [{SkillId, TriggerCondition, TargetCondition} | CanUseList];
            {SkillId, ExpireTime} ->
                if
                    ExpireTime > Now ->
                        CanUseList;
                    true ->
                        [{SkillId, TriggerCondition, TargetCondition} | CanUseList]
                end
        end,
    get_mon_skill(L, NewCanUseList, CdList, Now).

%% @走路怪物
get_path(OldX, OldY, Mid, Scene) ->
    case data_mon_ai:get_path(Mid) of
        [] -> {[], 0};
        {DestX, DestY, Time} -> {dest_path(OldX, OldY, DestX, DestY, Scene), Time};
        Other -> Other
    end.


%%事件列表触发
do_eff_list([], State, StateName) -> {State, StateName}.


%% 直线寻路 %% lib_mon_effect:dest_path(73, 124, 74, 107, 220).
dest_path(OldX, OldY, DestX, DestY, Scene) ->
    A = case DestX - OldX == 0 of
            true -> 0;
            false -> (DestY - OldY) / (DestX - OldX)
        end,
    B = DestY - A * DestX,
    DisX = abs(DestX - OldX),
    DisY = abs(DestY - OldY),
    Ref = if
              DisX > DisY -> x;
              true -> y
          end,
    Fx = fun(I, Result) ->
        X = case OldX < DestX of
                true -> OldX + I;
                false -> OldX - I
            end,
        Y = trunc(A * X + B),
        {ok, [{Scene, X, Y} | Result]}
    end,
    Fy = fun(I, Result) ->
        Y = case OldY < DestY of
                true -> OldY + I;
                false -> OldY - I
            end,
        X = case A == 0 of
                true -> OldX;
                false -> trunc((Y - B) / A)
            end,
        {ok, [{Scene, X, Y} | Result]}
    end,
    case Ref of
        x -> {ok, Path} = util:for(1, DisX, Fx, []),
            lists:reverse(Path);
        y -> {ok, Path} = util:for(1, DisY, Fy, []),
            lists:reverse(Path)
    end.