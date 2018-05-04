%%----------------------------------------------------
%%
%% 被攻击并且格挡时，有[几率]%不格挡而是变为闪避（完全无视伤害与控制），并且给自己加buff 
%%
%% args = [几率]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_210170).
-export([
    handle_active/3
    ,handle_passive/5
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(_Skill, _Self, _Target) ->
    ignore.

%% 被动 
%% -> {HpDmg, DmgMp}
handle_passive(reduce_dmg, Args = {_DmgHp, DmgMp, IsHit, _IsMiss},
        #c_skill{id = SkillId, name = _SkillName, args = [Rate], buff_self = BuffSelf},
        Self = #fighter{id = _Sid, name = _Sname},
        Target = #fighter{id = Tid}) ->
    %%
    case IsHit of
        ?true ->
            Args;
        ?false ->
            case util:rand(1, 100) =< Rate of
                true ->
                    ?DEBUG("[~s]的被动技能[~s]触发", [_Sname, _SkillName]),
                    combat:add_to_show_passive_skills(Tid, SkillId, ?show_passive_skills_hit),
                    lists:foreach(fun(Buff) -> combat_script_buff:do_add_buff(Buff, Self, Target) end, BuffSelf),
                    {0, DmgMp, IsHit, ?true};
                false -> 
                    Args
            end
    end;
handle_passive(_State, Args, _Skill, _Self, _Target) ->
    Args.
