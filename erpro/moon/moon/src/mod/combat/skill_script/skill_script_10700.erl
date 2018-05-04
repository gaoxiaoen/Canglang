%%----------------------------------------------------
%%
%% 攻击时清除自身允许被清除的debuff，无视宝宝护主          
%%
%% args = [值1,值2]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10700).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{id = SkillId}, Self = #fighter{pid = Spid, power = Power}, Target) ->
    AbleLev = get_power_skill_lev(Power),
    TrueSkill = #c_skill{id = TrueSkillId, buff_self = BuffSelf} = case skill:get_power_skill(SkillId, AbleLev) of
        TSkill = #c_skill{} -> TSkill;
        _ -> Skill
    end,
    ?parent:attack(TrueSkill, Self, Target, #action_effect_func{can_pet_protect = false}),
    %% 筛选出那些可以驱散的BUFF
    {_, #fighter{buff_atk = TBuffAtk, buff_hit = TBuffHit, buff_round = TBuffRound}} = combat:f(by_pid, Spid),
    TBuffs = lists:filter(fun(#c_buff{dispel = Dispel}) -> Dispel =:= ?true end, TBuffAtk ++ TBuffHit ++ TBuffRound),
    %% ?DEBUG("驱散自己有害的BUFF:~w", [SBuffs]),
    lists:foreach(
        fun(BUFF) ->
                #c_buff{eff_type = EffType} = BUFF,
                case EffType of
                    debuff -> combat:buff_del(BUFF, Spid);
                    _ -> ignore
                end
        end, TBuffs),
    %% 给自己增加buff
    {_, Self1 = #fighter{}} = combat:f(by_pid, Spid),
    [combat_script_buff:do_add_buff(BuffS, Self1, Self1) || BuffS <-  BuffSelf],
    %% 天威值扣除效果
    CostPower = if
        TrueSkillId rem 10 =:= 0 ->
            -(4000 + 500 * 9);
        true ->
            -(4000 + 500 * (TrueSkillId rem 10 - 1))
    end,
    combat:update_fighter(Spid, [{power_changed, CostPower}]).

%% ------------------------------
%% 获取当前天威值能释放的技能
get_power_skill_lev(Power) ->
    Factor = (Power - 4000) div 500,
    1 + Factor.

