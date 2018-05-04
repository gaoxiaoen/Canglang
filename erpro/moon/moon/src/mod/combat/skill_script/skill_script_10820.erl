%%----------------------------------------------------
%%
%% %% 怒气技能：触发BUFF
%%
%% args = [HpRatio]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10820).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{buff_target = BuffTarget}, Self, Target) ->
    %%combat:add_to_show_passive_skills(SkillId, Sid, ?show_passive_skills_before),
    %% 对自己施加BUFF
    %%lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Self) end, BuffSelf).
    %% 重新计算参数
    NewBuffTarget = [Buff#c_buff{args = ?parent:anger_calc_buff_args(Buff, Self, Target)} || Buff <- BuffTarget],
    NewSkill = Skill#c_skill{buff_target=NewBuffTarget},
    ?parent:cast(NewSkill, Self, Target);
handle_active(_Skill, _Self, _Target) ->
    ok.


