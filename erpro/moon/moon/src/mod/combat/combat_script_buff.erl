%%----------------------------------------------------
%% 战斗BUFF脚本配置
%% @author yeahoo2000@gmail.com
%%         yankai@jieyou.cn
%%----------------------------------------------------
-module(combat_script_buff).
-export([
        get/1,
        do_add_buff/3,
        convert_buff/1
    ]
).
-include("common.hrl").
-include("combat.hrl").
-include("attr.hrl").


%% @spec do_add_buff(Buff, Self, Target) -> true | false
%% Buff = #c_buff{}
%% Self = #fighter{}
%% Target = #fighter{}
%% @doc 给目标添加BUFF
do_add_buff(Buff = #c_buff{id = Id, hitrate = HitRate, is_hit = IsHit}, Self = #fighter{name = _Sname}, Target = #fighter{name = _Tname, attr = #attr{anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_silent = AntiSilent, anti_sleep = AntiSleep, anti_stone = AntiStone}}) ->
    ReallyHit = case IsHit of
        undefined ->
            is_hit(HitRate * 10);
        _ ->
            IsHit(Buff, Self, Target)
    end,
    case ReallyHit of
        true ->
            %% ?DEBUG("[~s]对[~s]施加Id=~w的BUFF成功", [_Sname, _Tname, _Id]),
            combat:buff_add(Buff, Self, Target),
            true;
        false -> 
            %% ?DEBUG("[~s]对[~s]施加Id=~w的BUFF失败", [_Sname, _Tname, _Id]),
            FailFun = fun(AntiVal)->
                if AntiVal >= 1000 -> %% 免疫
                        combat:buff_add_immune(Buff, Self, Target);
                    AntiVal > 0 -> %% 抵抗
                        combat:buff_add_resist(Buff, Self, Target);
                    true -> %% 打不中
                        combat:buff_add_fail(Buff, Self, Target)
                end
            end,
            if Id =:= 200050 orelse Id =:= 200051 -> % 睡眠
                    FailFun(AntiSleep); 
                Id =:= 200070 -> % 石化
                    FailFun(AntiStone);
                Id =:= 200060 -> % 沉默
                    FailFun(AntiSilent);
                Id =:= 200080 -> % 嘲讽
                    FailFun(AntiTaunt);
                Id =:= 200040 -> % 晕
                    FailFun(AntiStun);
                true ->
                    combat:buff_add_fail(Buff, Self, Target)   
            end,
            false
    end.



%% @spec convert_buff(BuffParamList) ->
%% BuffParamList = [number()]
%% @doc 转换BUFF
convert_buff(BuffParamList) ->
    do_convert_buff([], BuffParamList).

do_convert_buff(L, []) -> L;
do_convert_buff(L, [H|T]) ->
    {BuffId, [HitRate, Duration, Dispel | Args]} = H,
    case combat_script_buff:get(BuffId) of
        undefined -> 
            ?ERR("没有定义ID=~w的BUFF", [BuffId]),
            do_convert_buff(L, T);
        TmpBuff ->
            Buff = TmpBuff#c_buff{hitrate = HitRate, duration = Duration, dispel = Dispel, args = Args},
            do_convert_buff([Buff|L], T)
    end.

%% 缺省的命中判断
is_hit(HitRate) ->
    util:rand(1, 1000) =< HitRate.


%%------------------------------------------------------------------------
%% 良性BUFF
%%------------------------------------------------------------------------
%% 夫妻技能保护BUFF
get(100350 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _F = #fighter{id = Tid, pid = Tpid, partner = PartnerId, group = Group, name = _Tname}) ->
                case combat:f(by_rid, Group, PartnerId) of     
                    false -> skip;
                    _P = #fighter{name = _Pname, pid = Ppid} -> %% 施放者, 需要保护被施放者 
                        ?DEBUG("[~s]对[~s]进行保护,保护参数:~w",[_Pname, _Tname, BaseVal]),
                        combat:update_fighter(Tpid, [{protector_pid, {Ppid, BaseVal}}])
                end,
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
               round(BaseVal1 - BaseVal2) 
        end
    };

%% 回复类BUFF，回复固定的血量和魔法（药物用）
get(101000 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp, Mp]}, _Caster, F = #fighter{id = Tid, pid = Tpid}) ->
                HealHp = combat_util:calc_heal(F, Hp),
                combat:update_fighter(Tpid, [{hp_changed, HealHp}, {mp_changed, Mp}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = HealHp, 
                        target_mp = Mp, tips_args = [Hp, Mp]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp, Mp]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Hp, Mp]})
        end,
        compare = fun(#c_buff{args = [Hp1, Mp1]}, #c_buff{args = [Hp2, Mp2]}, _Caster1, _Caster2, _Target) ->
                (Hp1 + Mp1) - (Hp2 + Mp2)
        end
    };


%% 回复类BUFF，回复固定血量（药物用）
get(101010 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp]}, _Caster, F = #fighter{id = Tid, pid = Tpid}) ->
                HealHp = combat_util:calc_heal(F, Hp),
                combat:update_fighter(Tpid, [{hp_changed, HealHp}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = HealHp, tips_args = [Hp]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Hp]})
        end,
        compare = fun(#c_buff{args = [Hp1]}, #c_buff{args = [Hp2]}, _Caster1, _Caster2, _Target) ->
                Hp1 - Hp2
        end
    };

%% 回复类BUFF，回复固定血量（技能用）
get(101011 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp]}, _Caster, F = #fighter{id = Tid, pid = Tpid}) ->
                HealHp = combat_util:calc_heal(F, Hp),
                combat:update_fighter(Tpid, [{hp_changed, HealHp}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = HealHp, tips_args = [Hp]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Hp]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Hp]})
        end,
        compare = fun(#c_buff{args = [Hp1]}, #c_buff{args = [Hp2]}, _Caster1, _Caster2, _Target) ->
                Hp1 - Hp2
        end
    };

%% 无效果良性标记
%% 参数类型：[]
get(101340 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end
        ,eff_after = fun(_, _Caster, _) ->
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end,
        compare = fun(#c_buff{duration = Duration1}, #c_buff{duration = Duration2}, _Caster1, _Caster2, _Target) ->
                Duration1 - Duration2
        end
    };

%% 无效果良性标记
%% 参数类型：[]
get(101341 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end
        ,eff_after = fun(_, _Caster, _) ->
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end,
        compare = fun(#c_buff{duration = Duration1}, #c_buff{duration = Duration2}, _Caster1, _Caster2, _Target) ->
                Duration1 - Duration2
        end
    };

%% 无效果良性标记
%% 参数类型：[]
get(101342 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end
        ,eff_after = fun(_, _Caster, _) ->
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end,
        compare = fun(#c_buff{duration = Duration1}, #c_buff{duration = Duration2}, _Caster1, _Caster2, _Target) ->
                Duration1 - Duration2
        end
    };

%% 回复类BUFF，回复百分比血量（技能用）
get(102010 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [HpRate]}, _Caster, F = #fighter{id = Tid, pid = Tpid, hp_max = HpMax}) ->
                HealHp = round(HpMax * HpRate / 100),
                HealHp1 = combat_util:calc_heal(F, HealHp),
                combat:update_fighter(Tpid, [{hp_changed, HealHp1}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = HealHp1, tips_args = [HpRate]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [HpRate]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [HpRate]})
        end,
        compare = fun(#c_buff{args = [HpRate1]}, #c_buff{args = [HpRate2]}, _Caster1, _Caster2, _Target) ->
                HpRate1 - HpRate2
        end
    };

%% 回复类BUFF，回复固定魔法（药物用）
get(101020 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = buff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Mp]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{mp_changed, Mp}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_mp = Mp, tips_args = [Mp]})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Mp]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Mp]})
        end,
        compare = fun(#c_buff{args = [Mp1]}, #c_buff{args = [Mp2]}, _Caster1, _Caster2, _Target) ->
                Mp1 - Mp2
        end
    };

%% 提高命中率
%% 参数类型：[千分比]
get(101100 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = round(THitRate * (1 + Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = round(THitRate / (1 + Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };
get(101101 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101102 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101103 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101104 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };

%% 提高躲闪率
%% 参数类型：[固定值]
get(101110 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = round(Evasion * (1 + Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = round(Evasion / (1 + Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };
get(101111 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101112 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101113 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101114 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101115 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = Evasion - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };

%% 提升暴击率
%% 参数类型：[千分比]
get(101120 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate * (1 + Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate / (1 + Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };
get(101121 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101122 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101123 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101124 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = CritRate - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };

get(101125 = Id) ->
    Buff = ?MODULE:get(101120),
    Buff#c_buff{id = Id};

%% 提升暴击率(千分比加)
%% 参数类型：[千分比]
get(101126 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate * (1 + Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate / (1 + Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };

%% 提升坚韧
%% 参数类型：[固定值]
get(101130 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = round(Tenacity * (1 + Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = round(Tenacity / (1 + Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };
get(101131 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101132 = Id) ->
    #c_buff{
        id = Id,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101133 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101134 = Id) ->
    #c_buff{
        id = Id,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };
get(101135 = Id) ->
    #c_buff{
        id = Id,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = Tenacity - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        recalc_args = fun(#c_buff{args = [BaseVal]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100)]
        end
    };

%% 提升反击率
%% 参数类型：[固定值]
get(101220 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{anti_attack = AntiAtk}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{anti_attack = AntiAtk + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{anti_attack = AntiAtk}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{anti_attack = AntiAtk - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提升异常状态抗性
%% 参数类型：[固定值]
get(101230 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun + BaseVal,
                            anti_taunt = AntiTaunt + BaseVal,
                            anti_silent = AntiSilent + BaseVal,
                            anti_sleep = AntiSleep + BaseVal,
                            anti_stone = AntiStone + BaseVal
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun - BaseVal,
                            anti_taunt = AntiTaunt - BaseVal,
                            anti_silent = AntiSilent - BaseVal,
                            anti_sleep = AntiSleep - BaseVal,
                            anti_stone = AntiStone - BaseVal
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };
get(101231 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun + BaseVal,
                            anti_taunt = AntiTaunt + BaseVal,
                            anti_silent = AntiSilent + BaseVal,
                            anti_sleep = AntiSleep + BaseVal,
                            anti_stone = AntiStone + BaseVal
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun - BaseVal,
                            anti_taunt = AntiTaunt - BaseVal,
                            anti_silent = AntiSilent - BaseVal,
                            anti_sleep = AntiSleep - BaseVal,
                            anti_stone = AntiStone - BaseVal
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };
get(101232 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [StunVal, SilentVal, SleepVal, StoneVal, TauntVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun + StunVal,
                            anti_taunt = AntiTaunt + TauntVal,
                            anti_silent = AntiSilent + SilentVal,
                            anti_sleep = AntiSleep + SleepVal,
                            anti_stone = AntiStone + StoneVal
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [StunVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [StunVal, SilentVal, SleepVal, StoneVal, TauntVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun - StunVal,
                            anti_taunt = AntiTaunt - TauntVal,
                            anti_silent = AntiSilent - SilentVal,
                            anti_sleep = AntiSleep - SleepVal,
                            anti_stone = AntiStone - StoneVal
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [StunVal, _SilentVal, _SleepVal, _StoneVal, _TauntVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [StunVal]})
        end,
        compare = fun(#c_buff{args = [StunVal1, SilentVal1, SleepVal1, StoneVal1, TauntVal1]}, #c_buff{args = [StunVal2, SilentVal2, SleepVal2, StoneVal2, TauntVal2]}, _Caster1, _Caster2, _Target) ->
                Total1 = StunVal1 + SilentVal1 + SleepVal1 + StoneVal1 + TauntVal1,
                Total2 = StunVal2 + SilentVal2 + SleepVal2 + StoneVal2 + TauntVal2,
                Total1 - Total2
        end
    };

%% 提高治疗比例
%% 参数类型：[提高的百分比]
get(101270 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{heal_ratio_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{heal_ratio_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗伤害加深（破甲）
%% 参数类型：[提高的百分比]
get(101280 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_injure_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_injure_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗攻击降低
%% 参数类型：[提高的百分比]
get(101290 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_atk_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_atk_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗命中降低
%% 参数类型：[提高的百分比]
get(101300 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_hitrate_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_hitrate_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗躲闪降低
%% 参数类型：[提高的百分比]
get(101310 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_evasion_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_evasion_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗暴击降低
%% 参数类型：[提高的百分比]
get(101320 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_critrate_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_debuff_critrate_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高抵抗中毒
%% 参数类型：[提高的百分比]
get(101330 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_poison_changed, Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{anti_poison_changed, -Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 受到伤害减少
%% 参数类型：[基础值，精神转换系数]
get(103240 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end
    };
get(103241 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(103242 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(103243 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(103244 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(103245 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - LowerRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + LowerRate}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };

%% 受到近程攻击反弹目标伤害
get(101250 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Ratio]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Ratio]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        calc = fun(#c_buff{args = [Ratio]}, _Self, _Target, [DmgHp]) ->
                round(DmgHp * Ratio / 100)
        end
    };

%% 提升攻击力
%% 参数类型：[基础值,精神转换系数]
get(104140 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = if 
                    Js < 1700 -> round(BaseVal + Js * JsRate);
                    Js >= 1700 andalso Js < 10500 -> round(BaseVal + (1700 * JsRate) + (Js - 1700) * JsRate / 5);
                    true -> round(BaseVal + (1700 * JsRate) + (10500 - 1700) * JsRate / 5 + (Js - 10500) * JsRate /20)
                end,
                UpRate1 = case UpRate > 1050 of
                    true -> 1050;
                    false -> UpRate
                end,
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + UpRate1/1000)), dmg_max = round(DmgMax * (1 + UpRate1/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate1]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = if 
                    Js < 1700 -> round(BaseVal + Js * JsRate);
                    Js >= 1700 andalso Js < 10500 -> round(BaseVal + (1700 * JsRate) + (Js - 1700) * JsRate / 5);
                    true -> round(BaseVal + (1700 * JsRate) + (10500 - 1700) * JsRate / 5 + (Js - 10500) * JsRate /20)
                end,
                UpRate1 = case UpRate > 1050 of
                    true -> 1050;
                    false -> UpRate
                end,
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + UpRate1/1000)), dmg_max = round(DmgMax / (1 + UpRate1/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                UpRate = if 
                    Js < 1700 -> round(BaseVal + Js * JsRate);
                    Js >= 1700 andalso Js < 10500 -> round(BaseVal + (1700 * JsRate) + (Js - 1700) * JsRate / 5);
                    true -> round(BaseVal + (1700 * JsRate) + (10500 - 1700) * JsRate / 5 + (Js - 10500) * JsRate /20)
                end,
                UpRate1 = case UpRate > 1050 of
                    true -> 1050;
                    false -> UpRate
                end,
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate1]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRate1]}, #c_buff{args = [BaseVal2, JsRate2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                TmpUpRate1 = if 
                    Js1 < 1700 -> round(BaseVal1 + Js1 * JsRate1);
                    Js1 >= 1700 andalso Js1 < 10500 -> round(BaseVal1 + (1700 * JsRate1) + (Js1 - 1700) * JsRate1 / 5);
                    true -> round(BaseVal1 + (1700 * JsRate1) + (10500 - 1700) * JsRate1 / 5 + (Js1 - 10500) * JsRate1 /20)
                end,
                UpRate1 = case TmpUpRate1 > 1050 of
                    true -> 1050;
                    false -> TmpUpRate1
                end,
                TmpUpRate2 = if 
                    Js2 < 1700 -> round(BaseVal2 + Js2 * JsRate2);
                    Js2 >= 1700 andalso Js2 < 10500 -> round(BaseVal2 + (1700 * JsRate2) + (Js2 - 1700) * JsRate2 / 5);
                    true -> round(BaseVal2 + (1700 * JsRate2) + (10500 - 1700) * JsRate2 / 5 + (Js2 - 10500) * JsRate2 /20)
                end,
                UpRate2 = case TmpUpRate2 > 1050 of
                    true -> 1050;
                    false -> TmpUpRate2
                end,
                UpRate1 - UpRate2
        end
    };
get(104141 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + UpRate/1000)), dmg_max = round(DmgMax * (1 + UpRate/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + UpRate/1000)), dmg_max = round(DmgMax / (1 + UpRate/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(104142 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + UpRate/1000)), dmg_max = round(DmgMax * (1 + UpRate/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + UpRate/1000)), dmg_max = round(DmgMax / (1 + UpRate/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(104143 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + UpRate/1000)), dmg_max = round(DmgMax * (1 + UpRate/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + UpRate/1000)), dmg_max = round(DmgMax / (1 + UpRate/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };
get(104144 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + UpRate/1000)), dmg_max = round(DmgMax * (1 + UpRate/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + UpRate/1000)), dmg_max = round(DmgMax / (1 + UpRate/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, _Target = #fighter{id = Tid}) ->
                UpRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end,
        recalc_args = fun(#c_buff{args = [BaseVal, JsRate]}, #fighter{anger = Anger}, _Target) ->
                [round(BaseVal * ((Anger-?MAX_ANGER)/2+100)/100), JsRate]
        end
    };


%% 提高攻击力
%% 参数类型：[基础值]
get(102140 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 + BaseVal/1000)), dmg_max = round(DmgMax * (1 + BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 + BaseVal/1000)), dmg_max = round(DmgMax / (1 + BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高防御值
%% 参数类型：[基础值]
get(102150 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence * (1 + BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence / (1 + BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };
get(102151 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence * (1 + BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence / (1 + BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

get(102152 = Id) ->
    Buff = ?MODULE:get(102150),
    Buff#c_buff{id = Id};

%% 提高五行抗性
%% 参数类型：[基础值]
get(102160 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal * (1 + BaseVal/1000)),
                            resist_wood = round(ResistWood * (1 + BaseVal/1000)),
                            resist_water = round(ResistWater * (1 + BaseVal/1000)),
                            resist_fire = round(ResistFire * (1 + BaseVal/1000)),
                            resist_earth = round(ResisitEarth * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal / (1 + BaseVal/1000)),
                            resist_wood = round(ResistWood / (1 + BaseVal/1000)),
                            resist_water = round(ResistWater / (1 + BaseVal/1000)),
                            resist_fire = round(ResistFire / (1 + BaseVal/1000)),
                            resist_earth = round(ResisitEarth / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };
get(102161 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal * (1 + BaseVal/1000)),
                            resist_wood = round(ResistWood * (1 + BaseVal/1000)),
                            resist_water = round(ResistWater * (1 + BaseVal/1000)),
                            resist_fire = round(ResistFire * (1 + BaseVal/1000)),
                            resist_earth = round(ResisitEarth * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal / (1 + BaseVal/1000)),
                            resist_wood = round(ResistWood / (1 + BaseVal/1000)),
                            resist_water = round(ResistWater / (1 + BaseVal/1000)),
                            resist_fire = round(ResistFire / (1 + BaseVal/1000)),
                            resist_earth = round(ResisitEarth / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

get(102162 = Id) ->
    Buff = ?MODULE:get(102160),
    Buff#c_buff{id = Id};

%% 提高金抗性
%% 参数类型：[基础值]
get(102170 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_metal = ResistMetal}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_metal = ResistMetal}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高木抗性
%% 参数类型：[基础值]
get(102180 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_wood = ResistWood}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_wood = round(ResistWood * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_wood = ResistWood}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_wood = round(ResistWood / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高火抗性
%% 参数类型：[基础值]
get(102190 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_fire = ResistFire}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_fire = round(ResistFire * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_fire = ResistFire}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_fire = round(ResistFire / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高水抗性
%% 参数类型：[基础值]
get(102200 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_water = ResistWater}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_water = round(ResistWater * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_water = ResistWater}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_water = round(ResistWater / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高土抗性
%% 参数类型：[基础值]
get(102210 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_earth = ResistEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_earth = round(ResistEarth * (1 + BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_earth = ResistEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_earth = round(ResistEarth / (1 + BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高法伤
%% 参数类型：[基础值]
get(102360 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_magic = DmgMagic}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_magic = round(DmgMagic * (1 + BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_magic = DmgMagic}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_magic = round(DmgMagic / (1 + BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 提高精神
%% 参数类型：[基础值]
get(102370 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{js = Js}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{js = round(Js * (1 + BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{js = Js}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{js = round(Js / (1 + BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%%------------------------------------------------------------------------
%% 恶性BUFF
%%------------------------------------------------------------------------

%% 控制类BUFF,眩晕
get(200040 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_stun, ?true}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_stun, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_stun = EnhanceStun}}, _Target = #fighter{is_stun = IsStun, attr = #attr{anti_stun = AntiStun}}) ->
                case IsStun of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceStun - AntiStun))
                end
        end
    };

%% 控制类BUFF,睡眠
get(200050 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_sleep, ?true}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_sleep, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_sleep = EnhanceSleep}}, _Target = #fighter{is_sleep = IsSleep, attr = #attr{anti_sleep = AntiSleep}}) ->
                case IsSleep of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceSleep - AntiSleep))
                end
        end
    };

%% 控制类BUFF,沉默
get(200060 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_silent, ?true}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_silent, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_silent = EnhanceSilent}}, _Target = #fighter{is_silent = IsSilent, attr = #attr{anti_silent = AntiSilent}}) ->
                case IsSilent of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceSilent - AntiSilent))
                end
        end
    };

%% 控制类BUFF,石化
get(200070 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = Args}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                DmgReduceRatio = case Args of
                    [Val] -> Val;
                    _ -> 50
                end,
                combat:update_fighter(Tpid, [{is_stone, ?true}, {stone_dmg_reduce_ratio, DmgReduceRatio}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [DmgReduceRatio]})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_stone, ?false}, {stone_dmg_reduce_ratio, 50}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = Args}, _Caster, _Target = #fighter{id = Tid}) ->
                DmgReduceRatio = case Args of
                    [Val] -> Val;
                    _ -> 50
                end,
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [DmgReduceRatio]})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_stone = EnhanceStone}}, _Target = #fighter{is_stone = IsStone, attr = #attr{anti_stone = AntiStone}}) ->
                case IsStone of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceStone - AntiStone))
                end
        end
    };

%% 控制类BUFF,嘲讽
get(200080 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster = #fighter{pid = Cpid}, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_taunt, ?true}, {taunt_pid, Cpid}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_taunt, ?false}, {taunt_pid, undefined}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_taunt = EnhanceTaunt}}, _Target = #fighter{is_taunt = IsTaunt, attr = #attr{anti_taunt = AntiTaunt}}) ->
                case IsTaunt of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceTaunt - AntiTaunt))
                end
        end
    };

%% 控制类BUFF,封印(无法触发暴击和被动技能)
get(200090 = Id) ->
    #c_buff{
        id = Id
        ,type = atk_hit
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_nocrit, ?true}, {is_nopassive, ?true}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_nocrit, ?false}, {is_nopassive, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_seal = AntiSeal}}) ->
                is_hit(round(HitRate*10 - AntiSeal))
        end
    };

%% 持续耗魔
get(201020 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Dmg]}, _Caster, #fighter{id = Tid, pid = Tpid, is_die = IsDie}) ->
                combat:update_fighter(Tpid, [{mp_changed, -Dmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_mp = -Dmg, tips_args = [Dmg], 
                        is_target_die = IsDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Dmg]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Dmg]})
        end,
        compare = fun(#c_buff{args = [Dmg1]}, #c_buff{args = [Dmg2]}, _Caster1, _Caster2, _Target) ->
                Dmg1 - Dmg2
        end
    };

%% 持续伤害类BUFF
get(201030 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Dmg]}, _Caster, #fighter{id = Tid, pid = Tpid, hp = Hp}) ->
                IsTargetDie = combat_util:is_die(Hp - Dmg),
                combat:update_fighter(Tpid, [{hp_changed, -Dmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = -Dmg, tips_args = [Dmg], 
                        is_target_die = IsTargetDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Dmg]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Dmg]})
        end,
        compare = fun(#c_buff{args = [Dmg1]}, #c_buff{args = [Dmg2]}, _Caster1, _Caster2, _Target) ->
                Dmg1 - Dmg2
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_poison = AntiPoison}}) ->
                is_hit(round(HitRate*10 - AntiPoison))
        end
    };

%% 降低命中率
%% 参数类型：[降低的1000分比]
get(201100 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate =  round(THitRate * (1 - Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = round(THitRate / (1 - Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_hitrate = AntiDebuffHitrate}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffHitrate), 0, 100) * 10)
        end
    };

%% 降低命中率
%% 参数类型：[降低的1000分比]
get(201101 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = THitRate - round(Permile*THitRate/1000)}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [round(Permile)]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{hitrate = THitRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{hitrate = round(THitRate / (1 - Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [round(Permile)]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                Permile1 - Permile2
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_hitrate = AntiDebuffHitrate}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffHitrate), 0, 100) * 10)
        end
    };

%% 降低躲闪率
%% 参数类型：[降低的1000分比]
get(201110 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = round(Evasion * (1 - Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{evasion = Evasion}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{evasion = round(Evasion / (1 - Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_evasion = AntiDebuffEvasion}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffEvasion), 0, 100) * 10)
        end
    };

%% 降低暴击率
%% 参数类型：[降低的1000分比]
get(201120 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate * (1 - Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{critrate = CritRate}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{critrate = round(CritRate / (1 - Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_critrate = AntiDebuffCritrate}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffCritrate), 0, 100) * 10)
        end
    };

%% 降低坚韧
%% 参数类型：[基础值]
get(201130 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = round(Tenacity * (1 - Permile/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [Permile]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{tenacity = Tenacity}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{tenacity = round(Tenacity * (1 - Permile/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                round(Permile1 - Permile2)
        end
    };

%% 降低异常状态抗性
%% 参数类型：[提高的值]
get(201230 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun - BaseVal,
                            anti_taunt = AntiTaunt - BaseVal,
                            anti_silent = AntiSilent - BaseVal,
                            anti_sleep = AntiSleep - BaseVal,
                            anti_stone = AntiStone - BaseVal
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{
                        anti_stun = AntiStun,
                        anti_taunt = AntiTaunt,
                        anti_silent = AntiSilent,
                        anti_sleep = AntiSleep,
                        anti_stone = AntiStone
                    }}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            anti_stun = AntiStun + BaseVal,
                            anti_taunt = AntiTaunt + BaseVal,
                            anti_silent = AntiSilent + BaseVal,
                            anti_sleep = AntiSleep + BaseVal,
                            anti_stone = AntiStone + BaseVal
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 受到伤害加深(剑魂破甲专用)
%% 参数类型：[加深的值]
get(201240 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_injure = AntiDebuffInjure}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffInjure), 0, 100) * 10)
        end
    };

%% 受到伤害加深
%% 参数类型：[加深的值]
get(201241 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + BaseVal}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_injure = AntiDebuffInjure}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffInjure), 0, 100) * 10)
        end
    };

%% 降低治疗比例
%% 参数类型：[降低的百分比]
get(201270 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{heal_ratio_changed, -Val}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end
        ,eff_after = fun(#c_buff{args = [Val]}, _Caster, #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{heal_ratio_changed, Val}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Val]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Val]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 无效果恶性标记
%% 参数类型：[]
get(201340 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end
        ,eff_after = fun(_, _Caster, _) ->
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = []})
        end,
        compare = fun(#c_buff{duration = Duration1}, #c_buff{duration = Duration2}, _Caster1, _Caster2, _Target) ->
                Duration1 - Duration2
        end
    };

%% 降低攻击力
%% 参数类型：[降低的值]
get(202140 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 - BaseVal/1000)), dmg_max = round(DmgMax * (1 - BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 - BaseVal/1000)), dmg_max = round(DmgMax / (1 - BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_atk = AntiDebuffAtk}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffAtk), 0, 100) * 10)
        end
    };

%% 降低防御值
%% 参数类型：[降低的值]
get(202150 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence * (1 - BaseVal/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{defence = Defence}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{defence = round(Defence / (1 - BaseVal/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 降低五行抗性
%% 参数类型：[降低的值]
get(202160 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = debuff
        ,eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal * (1 - BaseVal/1000)),
                            resist_wood = round(ResistWood * (1 - BaseVal/1000)),
                            resist_water = round(ResistWater * (1 - BaseVal/1000)),
                            resist_fire = round(ResistFire * (1 - BaseVal/1000)),
                            resist_earth = round(ResisitEarth * (1 - BaseVal/1000))
                        }}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{resist_metal = ResistMetal, resist_wood = ResistWood,
                        resist_water = ResistWater, resist_fire = ResistFire, resist_earth = ResisitEarth}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{
                            resist_metal = round(ResistMetal / (1 - BaseVal/1000)),
                            resist_wood = round(ResistWood / (1 - BaseVal/1000)),
                            resist_water = round(ResistWater / (1 - BaseVal/1000)),
                            resist_fire = round(ResistFire / (1 - BaseVal/1000)),
                            resist_earth = round(ResisitEarth / (1 - BaseVal/1000))
                        }}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% 持续耗魔（百分比）
get(202020 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [MpRatio]}, _Caster, #fighter{id = Tid, pid = Tpid, mp_max = TmpMax, is_die = IsDie}) ->
                MpDmg = round(TmpMax * MpRatio / 100),
                combat:update_fighter(Tpid, [{mp_changed, -MpDmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_mp = -MpDmg, tips_args = [MpRatio], 
                        is_target_die = IsDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [MpRatio]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [MpRatio]})
        end,
        compare = fun(#c_buff{args = [MpRatio1]}, #c_buff{args = [MpRatio2]}, _Caster1, _Caster2, _Target) ->
                MpRatio1 - MpRatio2
        end
    };

%% 持续伤害类BUFF2
%% 10110		恶性	中毒，每回合损失[每次伤害血量+精神*精神转换系数]气血	[命中概率, 持续回合, 每次伤害血量，精神转换系数]
get(203030 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseDmg, JsRatio]}, _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, pid = Tpid}) ->
                Dmg0 = round(BaseDmg + Js * JsRatio),
                {_IsShield, Dmg, _ShieldReduce} = combat_script_skill:use_shield(Tpid, Dmg0),
                {RealDmg, NewHp} = combat_script_skill:undying_eff(Dmg, Target),
                IsTargetDie = combat_util:is_die(NewHp),
                combat:update_fighter(Tpid, [{hp_changed, -RealDmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = -Dmg, tips_args = [Dmg], 
                        is_target_die = IsTargetDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseDmg, JsRatio]}, _Caster = #fighter{attr = #attr{js = Js}}, 
                _Target = #fighter{id = Tid}) ->
                Dmg = round(BaseDmg + Js * JsRatio),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Dmg]})
        end,
        compare = fun(#c_buff{args = [BaseDmg1, JsRatio1]}, #c_buff{args = [BaseDmg2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                Dmg1 = round(BaseDmg1 + Js1 * JsRatio1),
                Dmg2 = round(BaseDmg2 + Js2 * JsRatio2),
                Dmg1 - Dmg2
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_poison = AntiPoison}}) ->
                is_hit(round(HitRate - AntiPoison/10) * 10)
        end
    };

%% 受到伤害加深
%% 参数类型：[基础值,精神转换系数]
get(203240 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                UpRate = round(BaseVal - Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio + UpRate}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{injure_ratio = InjureRatio}}) ->
                UpRate = round(BaseVal - Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{injure_ratio = InjureRatio - UpRate}}, Group),
                ok
        end,
        eff_refresh = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                _Target = #fighter{id = Tid}) ->
                UpRate = round(BaseVal - Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [UpRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                UpRate1 = round(BaseVal1 + Js1 * JsRatio1),
                UpRate2 = round(BaseVal2 + Js2 * JsRatio2),
                UpRate1 - UpRate2
        end
    };

%% 降低攻击力
%% 参数类型：[基础值,精神转换系数]
get(204140 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 - LowerRate/1000)), dmg_max = round(DmgMax * (1 - LowerRate/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, JsRate]}, 
                _Caster = #fighter{attr = #attr{js = Js}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 - LowerRate/1000)), dmg_max = round(DmgMax / (1 - LowerRate/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, JsRate]}, _Caster = #fighter{attr = #attr{js = Js}}, 
                _Target = #fighter{id = Tid}) ->
                LowerRate = round(BaseVal + Js * JsRate),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, JsRatio1]}, #c_buff{args = [BaseVal2, JsRatio2]}, #fighter{attr = #attr{js = Js1}}, #fighter{attr = #attr{js = Js2}}, _Target) ->
                LowerRate1 = round(BaseVal1 + Js1 * JsRatio1),
                LowerRate2 = round(BaseVal2 + Js2 * JsRatio2),
                LowerRate1 - LowerRate2
        end
    };


%% 降低攻击力
%% 参数类型：[基础值,防御转换系数]
get(208140 = Id) ->
    #c_buff{
        id = Id,
        type = atk,
        eff_type = debuff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, DefenceRatio]}, 
                _Caster = #fighter{attr = #attr{defence = Defence}}, 
                Target = #fighter{id = Tid, group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                LowerRate = if
                    Defence < 15000 -> round(BaseVal + Defence * DefenceRatio);
                    Defence >= 15000 andalso Defence < 45000 -> round(BaseVal + 15000 * DefenceRatio + (Defence - 15000) * DefenceRatio / 5);
                    true -> round(BaseVal + 15000 * DefenceRatio + 30000 * DefenceRatio / 5 + (Defence - 45000) * DefenceRatio / 10)
                end,
                LowerRate1 = case LowerRate > 750 of
                    true -> 750;
                    false -> LowerRate
                end,
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin * (1 - LowerRate1/1000)), dmg_max = round(DmgMax * (1 - LowerRate1/1000))}}, Group),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate1]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal, DefenceRatio]}, 
                _Caster = #fighter{attr = #attr{defence = Defence}}, 
                Target = #fighter{group = Group, attr = Tattr = #attr{dmg_min = DmgMin, dmg_max = DmgMax}}) ->
                LowerRate = if
                    Defence < 15000 -> round(BaseVal + Defence * DefenceRatio);
                    Defence >= 15000 andalso Defence < 45000 -> round(BaseVal + 15000 * DefenceRatio + (Defence - 15000) * DefenceRatio / 5);
                    true -> round(BaseVal + 15000 * DefenceRatio + 30000 * DefenceRatio / 5 + (Defence - 45000) * DefenceRatio / 10)
                end,
                LowerRate1 = case LowerRate > 750 of
                    true -> 750;
                    false -> LowerRate
                end,
                combat:u(Target#fighter{attr = Tattr#attr{dmg_min = round(DmgMin / (1 - LowerRate1/1000)), dmg_max = round(DmgMax / (1 - LowerRate1/1000))}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, DefenceRatio]}, _Caster = #fighter{attr = #attr{defence = Defence}}, 
                _Target = #fighter{id = Tid}) ->
                LowerRate = if
                    Defence < 15000 -> round(BaseVal + Defence * DefenceRatio);
                    Defence >= 15000 andalso Defence < 45000 -> round(BaseVal + 15000 * DefenceRatio + (Defence - 15000) * DefenceRatio / 5);
                    true -> round(BaseVal + 15000 * DefenceRatio + 30000 * DefenceRatio / 5 + (Defence - 45000) * DefenceRatio / 10)
                end,
                LowerRate1 = case LowerRate > 750 of
                    true -> 750;
                    false -> LowerRate
                end,
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [LowerRate1]})
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr_ext = #attr_ext{anti_debuff_atk = AntiDebuffAtk}}) ->
                is_hit(util:check_range(round(HitRate - AntiDebuffAtk), 0, 100) * 10)
        end,
        compare = fun(#c_buff{args = [BaseVal1, DefenceRatio1]}, #c_buff{args = [BaseVal2, DefenceRatio2]}, #fighter{attr = #attr{defence = Defence1}}, #fighter{attr = #attr{defence = Defence2}}, _Target) ->
                LowerRate1 = round(BaseVal1 + Defence1 * DefenceRatio1),
                LowerRate2 = round(BaseVal2 + Defence2 * DefenceRatio2),
                LowerRate1 - LowerRate2
        end
    };


%% 持续伤害类BUFF(暴击率相关)
get(209030 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, CritRatio]}, #fighter{attr = #attr{critrate = CritRate}}, Target = #fighter{id = Tid, pid = Tpid, hp = _Hp}) ->
                CritRate1 = case CritRate > 6000 of
                    true -> 6000 + (CritRate - 6000)/5;
                    false -> CritRate
                end,
                Dmg0 = round(BaseVal + CritRate1 * CritRatio),
                {_IsShield, Dmg, _ShieldReduce} = combat_script_skill:use_shield(Tpid, Dmg0),
                {RealDmg, NewHp} = combat_script_skill:undying_eff(Dmg, Target),
                IsTargetDie = combat_util:is_die(NewHp),
                combat:update_fighter(Tpid, [{hp_changed, -RealDmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = -Dmg, tips_args = [Dmg], 
                        is_target_die = IsTargetDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal, CritRatio]}, #fighter{attr = #attr{critrate = CritRate}}, #fighter{id = Tid}) ->
                CritRate1 = case CritRate > 6000 of
                    true -> 6000 + (CritRate - 6000)/5;
                    false -> CritRate
                end,
                Dmg = round(BaseVal + CritRate1 * CritRatio),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Dmg]})
        end,
        compare = fun(#c_buff{args = [BaseVal1, CritRatio1]}, #c_buff{args = [BaseVal2, CritRatio2]}, #fighter{attr = #attr{critrate = CritRate1}}, #fighter{attr = #attr{critrate = CritRate2}}, _Target) ->
                (BaseVal1 + CritRate1 * CritRatio1) - (BaseVal2 + CritRate2 * CritRatio2)
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_poison = AntiPoison}}) ->
                is_hit(round(HitRate*10 - AntiPoison))
        end
    };

%% ====== 新加 ======================

%% 控制类BUFF, 睡眠：无法行动，但是被攻击后解除睡眠。任何人攻击睡眠的单位增加[值]%额外伤害
get(200051 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [DmgRatio]}, _Caster, Target = #fighter{id = Tid, attr = Tattr, group = Tgroup}) ->
                %combat:update_fighter(Tpid, [{is_sleep, ?true}]),
                combat:u(Target#fighter{is_sleep = ?true, attr = Tattr#attr{injure_ratio = 100 + DmgRatio}}, Tgroup),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, Target = #fighter{attr = Tattr, group = Tgroup}) ->
                %combat:update_fighter(Tpid, [{is_sleep, ?false}]),
                combat:u(Target#fighter{is_sleep = ?false, attr = Tattr#attr{injure_ratio = 100}}, Tgroup),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster = #fighter{attr = #attr{enhance_sleep = EnhanceSleep}}, _Target = #fighter{is_sleep = IsSleep, attr = #attr{anti_sleep = AntiSleep}}) ->
                case IsSleep of
                    ?true -> false;
                    _ ->
                        is_hit(round(HitRate*10 + EnhanceSleep - AntiSleep))
                end
        end
        %eff_passive = fun(raise_dmg, {Dmg, IsHit}, _Buff = #c_buff{args = [Percent]}, _Caster, _Target) ->
        %        ?DEBUG("buff 伤害加深 ---"),
        %        {round(Dmg + Dmg * Percent / 100), IsHit}
        %    (Event, Args, _Buff, _Caster, _Target) ->
        %        Args
        %end
    };

% 201110		虚弱：降低[值]%格挡率	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 101230		免疫：无法被任何控制技控制	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 210370		中毒：承受持续[持续回合]回合的[暴击*暴击系数]伤害	
% [命中概率，持续回合, 是否驱散，暴击系数]
get(210370 = Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [CritC]}, _Caster = #fighter{attr = #attr{critrate = Critrate}}, 
                Target = #fighter{id = Tid, pid = Tpid}) ->
                Dmg0 = round(Critrate * CritC),
                {_IsShield, Dmg, _ShieldReduce} = combat_script_skill:use_shield(Tpid, Dmg0),
                {RealDmg, NewHp} = combat_script_skill:undying_eff(Dmg, Target),
                IsTargetDie = combat_util:is_die(NewHp),
                combat:update_fighter(Tpid, [{hp_changed, -RealDmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = -Dmg, tips_args = [Dmg], 
                        is_target_die = IsTargetDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [CritC]}, _Caster = #fighter{attr = #attr{critrate = Critrate}}, 
                _Target = #fighter{id = Tid}) ->
                Dmg = round(Critrate * CritC),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Dmg]})
        end,
        compare = fun(#c_buff{args = [CritC1]}, #c_buff{args = [CritC2]}, #fighter{attr = #attr{critrate = Critrate1}}, #fighter{attr = #attr{critrate = Critrate2}}, _Target) ->
                Dmg1 = round(Critrate1 * CritC1),
                Dmg2 = round(Critrate2 * CritC2),
                Dmg1 - Dmg2
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_poison = AntiPoison}}) ->
                is_hit(round(HitRate - AntiPoison/10) * 10)
        end
    };


% 201100		致盲：降低[值]%命中率	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 200060		沉默：无法使用技能	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 202140		恐惧：攻击下降[值]%	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 200080		嘲讽：强制攻击施法者	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 100380		濒死：持续回合中血量最少只会降低到1	
% [命中概率，持续回合, 是否驱散，值]
get(100380 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, #fighter{id = Tid, pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_undying, ?true}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end
        ,eff_after = fun(_Buff, _Caster, _Target = #fighter{pid = Tpid}) ->
                combat:update_fighter(Tpid, [{is_undying, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(_NewBuff, _OldBuff, _Caster1, _Caster2, _Target) ->
                0
        end
    };

% 101120		暴击增加：暴击提高[%e]%	
% [命中概率，持续回合, 是否驱散，值]
% 已定义

% 100390		嗜血：在回合内，攻击会有[几率]%几率恢复[值]%伤害的血量	
% [命中概率，持续回合, 是否驱散，几率，值]
get(100390 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        eff_passive = fun(restore_after_hit, Args = {DmgHp, RestoreHp}, 
                    _Buff = #c_buff{dispel = Dispel, duration = Duration, args = [Rate, Percent]}, 
                    _Caster = #fighter{id = Sid}, 
                    _Target = #fighter{} ) ->
                %%
                case util:rand(1, 1000) < Rate * 10 of
                    true ->
                        HealHp = round(DmgHp * Percent / 1000),
                        ?log("伤害~p 治疗量~p", [DmgHp, HealHp]),
                        %combat:update_fighter(Spid, [{hp_changed, HealHp}]),
                        combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Sid}),
                        {DmgHp, RestoreHp + HealHp};
                    _ ->
                        Args
                end;
            (_Event, Args, _Buff, _Caster, _Target) ->
                Args
        end,
        compare = fun(#c_buff{}, #c_buff{}, _Caster1, _Caster2, _Target) ->
                0
        end
    };

% 101400		屏障：加（攻击*+防御*+格挡*）数值上限的护盾，护盾可以抵消伤害，攻击护盾者会受到X%反弹伤害，被嘲讽攻击护盾者再增加攻击*+防御*的反弹伤害，护盾持续X回合或者吸收完最大值伤害后消失	
% [命中概率，持续回合, 是否驱散，值]
%get(101400 = Id) ->
%    #c_buff{
%        id = Id
%        ,type = hit
%        ,eff_type = buff
%        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [DmgC, DefC, EvaC, _FeedbackRate]}, 
%                    _Caster = #fighter{attr = #attr{dmg_min=DmgMin, dmg_max=DmgMax}}, 
%                    Target = #fighter{id = Tid}) ->
%                %% 
%                Shield = round((DmgMin + DmgMax) / 2 * DmgC + Defence * DefC + Evasion * EvaC),
%                put({buff, Id, shield}, Shield),
%                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
%        end,
%        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, _Caster, _Target) ->
%                erase({buff, Id, shield}),
%                ok
%        end,
%        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
%                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
%        end,
%        compare = fun(#c_buff{}, #c_buff{}, _Caster1, _Caster2, _Target) ->
%                0
%        end
%    };
get(101400 = Id) ->
    #c_buff{
        id = Id
        ,type = hit
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = Dispel, duration = Duration, args = [DmgC, DefC, EvaC, _FeedbackRate]}, 
                    _Caster = #fighter{attr = #attr{dmg_min=DmgMin, dmg_max=DmgMax, defence=Defence, evasion=Evasion}}, 
                    _Target = #fighter{id = Tid, pid = Tpid}) ->
                %% 
                Shield = round((DmgMin + DmgMax) / 2 * DmgC + Defence * DefC + Evasion * EvaC),
                combat:update_fighter(Tpid, [{shield, Shield}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        eff_after = fun(_Buff = #c_buff{}, _Caster, _Target = #fighter{pid=Tpid}) ->
                combat:update_fighter(Tpid, [{shield, 0}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(#c_buff{}, #c_buff{}, _Caster1, _Caster2, _Target) ->
                0
        end,
        eff_passive = fun(feedback_dmg, {Dmg, IsHit, 0}, 
                    _Buff = #c_buff{args = [DmgC, DefC, _EvaC, FeedbackRate]}, 
                    _Caster = #fighter{is_taunt=IsTaunt}, 
                    _Target = #fighter{attr = #attr{defence=Defence}} ) ->
                %%
                AddDmg = case IsTaunt of
                    ?true -> round(Dmg * DmgC + Defence * DefC);
                    ?false -> 0
                end, 
                Feedback = round(Dmg * FeedbackRate / 1000) + AddDmg,
                ?log("buff ~p 反弹 ~p ---", [Id, Feedback]),
                {Dmg, IsHit, Feedback};
            (_Event, Args, _Buff, _Caster, _Target) ->
                Args
        end
    };

%% 超暴击
get(100120 = Id) ->
    #c_buff{
        id = Id
        ,type = atk
        ,eff_type = buff
        ,eff_before = fun(#c_buff{dispel = _Dispel, duration = _Duration}, 
                    _Caster = #fighter{}, 
                    _Target = #fighter{id = _Tid, pid = Tpid}) ->
                %% 
                %combat:set_fighter_state(Tpid, {super_crit, ?true}),
                %%目前只有世界boss用到，暂时不用add_sub_play
                combat:update_fighter(Tpid, [{super_crit, ?true}])
                %%combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        eff_after = fun(_Buff = #c_buff{}, _Caster, _Target = #fighter{pid=Tpid}) ->
                %%combat:set_fighter_state(Tpid, {super_crit, ?false}),
                combat:update_fighter(Tpid, [{super_crit, ?false}]),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
        end,
        compare = fun(#c_buff{}, #c_buff{}, _Caster1, _Caster2, _Target) ->
                0
        end
    };

%% 圣光守护：获得这个buff时清除身上的负面buff，并且在持续X回合内不会受到负面buff影响（负面buff是ID开头为2的buff）
%% 参数类型：[]
%get(101239 = Id) ->
%    #c_buff{
%        id = Id,
%        type = hit,
%        eff_type = buff,
%        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration}, _Caster, 
%                    Target = #fighter{id = Tid, group = Group}) ->
%                combat:u(Target#fighter{anti_debuff=?true}, Group),
%                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
%        end,
%        eff_after = fun(_Buff = #c_buff{}, _Caster, 
%                Target = #fighter{group = Group}) ->
%                combat:u(Target#fighter{anti_debuff=?false}, Group),
%                ok
%        end,
%        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration}, _Caster, _Target = #fighter{id = Tid}) ->
%                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid})
%        end,
%        compare = fun(#c_buff{}, #c_buff{}, _Caster1, _Caster2, _Target) ->
%                0 
%        end
%    };

%% 增加中毒抵抗
%% 参数类型：[增加中毒抵抗值]
get(100121 = Id) ->
    #c_buff{
        id = Id,
        type = hit,
        eff_type = buff,
        eff_before = fun(_Buff = #c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{id = Tid, pid = Tpid, group = Group, attr = Tattr = #attr{anti_poison = AntiPoison}, buff_atk = BuffAtk, buff_hit = BuffHit, buff_round = BuffRound}) ->
                combat:u(Target#fighter{attr = Tattr#attr{anti_poison = AntiPoison + BaseVal}}, Group),
                case lists:keyfind(#c_buff.id, 210370, BuffAtk ++ BuffHit ++ BuffRound) of %% 清除毒buff
                    false -> ignore;         
                    PoisonBuff = #c_buff{} -> combat:buff_del(PoisonBuff, Tpid)
                end,
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        eff_after = fun(_Buff = #c_buff{args = [BaseVal]}, 
                _Caster, 
                Target = #fighter{group = Group, attr = Tattr = #attr{anti_poison = AntiPoison}}) ->
                combat:u(Target#fighter{attr = Tattr#attr{anti_poison = AntiPoison - BaseVal}}, Group),
                ok
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [BaseVal]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [BaseVal]})
        end,
        compare = fun(#c_buff{args = [BaseVal1]}, #c_buff{args = [BaseVal2]}, _Caster1, _Caster2, _Target) ->
                round(BaseVal1 - BaseVal2)
        end
    };

%% (剧毒)持续%伤害类BUFF
get(200031= Id) ->
    #c_buff{
        id = Id
        ,type = round
        ,eff_type = debuff
        ,eff = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, #fighter{id = Tid, pid = Tpid, hp = Hp, hp_max = HpMax}) ->
                Dmg = round(HpMax * Permile / 1000),
                IsTargetDie = combat_util:is_die(Hp - Dmg),
                combat:update_fighter(Tpid, [{hp_changed, -Dmg}]),
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, target_hp = -Dmg, tips_args = [Permile], 
                        is_target_die = IsTargetDie})
        end,
        eff_refresh = fun(#c_buff{dispel = Dispel, duration = Duration, args = [Permile]}, _Caster, _Target = #fighter{id = Tid}) ->
                combat:add_sub_play(#buff_play{buff_id = Id, dispel = Dispel, duration = Duration, target_id = Tid, tips_args = [Permile]})
        end,
        compare = fun(#c_buff{args = [Permile1]}, #c_buff{args = [Permile2]}, _Caster1, _Caster2, _Target) ->
                Permile1 - Permile2
        end,
        is_hit = fun(#c_buff{hitrate = HitRate}, _Caster, _Target = #fighter{attr = #attr{anti_poison = AntiPoison}}) ->
                is_hit(round(HitRate*10 - AntiPoison))
        end
    };


get(_) -> undefined.
