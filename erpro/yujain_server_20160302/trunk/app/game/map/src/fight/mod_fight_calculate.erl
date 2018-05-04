%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@ijunhai.com
%%% @copyright (C) 2015, <JunHai>
%%% @doc
%%% 战斗相关伤害计算
%%% @end
%%% Created : 14. 十月 2015 17:16
%%%-------------------------------------------------------------------
-module(mod_fight_calculate).

-include("common.hrl").

%% API
-export([hurt/7,
         reduce_hurt/1,
         is_unrivalled/1,
         is_virtual/1,
         hurt_anger/2, 
         attack/5, 
         check_seal/2]).

%% @doc 打出伤害 引入闪避暴击因素
-spec attack(Hurt, DoubleAttack, Hit, Tough, Miss) -> {HurtType, Hurt} when
    Hurt :: integer(), DoubleAttack :: integer(), Hit :: integer(), Tough :: integer(), Miss :: integer(),
    HurtType :: ?HURT_TYPE_NORMAL | ?HURT_TYPE_MISS | ?HURT_TYPE_DOUBLE_HIT, Hurt :: integer().
attack(Hurt, DoubleAttack, Hit, Tough, Miss) ->
    case check_hit(Hit, Miss) of
        true ->
            case check_double_attack(DoubleAttack, Tough) of
                true -> % 暴击
                    {?HURT_TYPE_DOUBLE_HIT, Hurt * 2};
                false ->
                    {?HURT_TYPE_NORMAL, Hurt}
            end;
        false ->
            {?HURT_TYPE_MISS, 0}
    end.


%% @doc
%% 暴击检查
%% 暴击几率=（攻方角色暴击—守方角色坚韧）/1000
%% 暴击几率＜0则必定不暴击
%% @end
-spec check_double_attack(ActorDoubleAttack, TargetTough) -> boolean() when
    ActorDoubleAttack :: integer(), TargetTough :: integer().
check_double_attack(ActorDoubleAttack, TargetTough) ->
    DoubleAttackRate = (ActorDoubleAttack - TargetTough) / 1000,
    DoubleAttackRate > 0 andalso common_tool:random(1, 10000) =< DoubleAttackRate * 10000.

%% @doc
%% 封印检查
%% 封印几率=（攻方技能封印+攻方角色封印—守方角色抗封）/1000
%% 封印几率＜0则必定封印失败
%% @end
-spec check_seal(ActorSeal, TargetAntiSeal) -> boolean() when
    ActorSeal :: integer(), TargetAntiSeal :: integer().
check_seal(ActorSeal, TargetAntiSeal) ->
    SealRate = (ActorSeal - TargetAntiSeal) / 1000,
    SealRate > 0 andalso common_tool:random(1, 10000) =< SealRate * 10000.

%% @doc
%% 命中检查
%% 命中率=（1000+攻方命中—守方闪避）/1000
%% 命中率＜0则必定不命中
%% @end
-spec check_hit(ActorHit, TargetMiss) -> boolean() when
    ActorHit :: integer(), TargetMiss :: integer().
check_hit(ActorHit, TargetMiss) ->
    HitRate = (1000 + ActorHit - TargetMiss) / 1000,
    HitRate > 0 andalso common_tool:random(1, 10000) =< HitRate * 10000.

%% @doc
%% 怒气计算
%% 受到伤害获得的愤怒值=受到伤害/生命上限×100
%% 怒气上线为150
%% @end
-spec hurt_anger(Hurt, MaxHp) -> Val when
    Hurt :: integer(), MaxHp :: integer(), Val :: integer().
hurt_anger(Hurt, MaxHp) ->
    AddAngerIndex = cfg_common:find(add_anger_index),
    %% 向上取整，默认最少是1
    common_tool:ceil(Hurt/MaxHp * AddAngerIndex).

%% @doc
%% 伤害=（技能系数×攻方攻击力+技能附加伤害—守方防御力）×通用伤害系数×[1+（攻方攻修等级—守方防修等级）/50]
%% 若伤害＜攻击力×保底系数，则伤害固定为攻击力×保底系数
%% 通用伤害系数暂定1.2，保底系数暂定0.1
%% 攻击力类型取决于技能类型，若为物理技能，则为物理攻击，防御力和修炼相同
%% 最终伤害结果需做上下10%的浮动，保底伤害不做浮动
%% @end
%% ReduceHurt 伤害减免值 0 | integer()
hurt(SkillCalcCoef, SkillAttack, Attack, AttackSkill, Defence, DefenceSkill,ReduceHurt) ->
    PreCalcHit = (SkillCalcCoef * Attack + SkillAttack - Defence) * 1.2 * (1 + (AttackSkill - DefenceSkill)/50) * (100 - ReduceHurt) / 100,
    LowHit = Attack * 0.1,
    case PreCalcHit < LowHit of
        true -> erlang:trunc(LowHit);
        false ->
            common_tool:random(erlang:trunc(PreCalcHit * 0.9), erlang:trunc(PreCalcHit * 1.1))
    end.

%% 当目标身上有伤害减免Buff时，计算出目标的伤害减免百分比
-spec
reduce_hurt(FightBuffList) -> ReduceHurt when
    FightBuffList :: [] | [#r_buff{}],
    ReduceHurt :: 0 | integer().
reduce_hurt([]) -> 
    0;
reduce_hurt(FightBuffList) -> 
    case lists:keyfind(?BUFF_EFFECT_REDUCE_HURT, #r_buff.type, FightBuffList) of
        false ->
            0;
        #r_buff{buff_id=BuffId,skill_level=SkillLevel} ->
            [#r_buff_info{a=A,b=B}] = cfg_buff:find(BuffId),
            erlang:trunc(A + SkillLevel / B)
    end.

%% 判断目标是否无敌
-spec
is_unrivalled(FightBuffList) -> true | false when
    FightBuffList :: [] | [#r_buff{}].
is_unrivalled(FightBuffList) ->
    case lists:keyfind(?BUFF_EFFECT_UNRIVALLED, #r_buff.type, FightBuffList) of
        false -> false;
        _ -> true
    end.

%% @doc 判断当前目标是否处理虚空状态
%% 即判断#r_map_actor.fight_buff中是否有#r_buff.type==?BUFF_EFFECT_VIRTUAL
-spec
is_virtual(FightBuff) -> true | false when
    FightBuff :: #r_map_actor{} | [] | [#r_buff{}].
is_virtual(#r_map_actor{fight_buff=FightBuffList}) ->
    is_virtual(FightBuffList);
is_virtual(FightBuffList) ->
    case lists:keyfind(?BUFF_EFFECT_VIRTUAL, #r_buff.type, FightBuffList) of
        false -> false;
        _ -> true
    end.
            
