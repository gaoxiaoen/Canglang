%%----------------------------------------------------
%%
%% 复活
%%
%% args = [触发概率，复活后血量百分比，复活后蓝量百分比]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_700000).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = [_Rate, HpPercent, MpPercent]}, Self = #fighter{}, 
        Target = #fighter{id = _Tid, group = Tgroup, type = ?fighter_type_role, 
            hp = _Hp, hp_max = HpMax, mp = _Mp, mp_max = MpMax}) ->
    ?log("复活 ~p", [_Tid]),
    NewHp = round(HpMax * HpPercent / 100),
    NewMp = round(MpMax * MpPercent / 100),
    %combat:add_to_show_passive_skills(Tid, ?skill_relive, ?show_passive_skills_before),
    combat:u(Target#fighter{hp = NewHp, mp = NewMp, is_die = ?false}, Tgroup),
    combat:add_sub_play(combat:gen_sub_play(attack, Self, Target, Skill, 0, NewHp, NewMp, 0, ?false, ?true, ?false)),
    ok;

handle_active(Skill, Self, Target) ->
    ?ERR("参数错误"),
    ?parent:heal(Skill, Self, Target, 0).


