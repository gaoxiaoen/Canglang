%%----------------------------------------------------
%%
%% 召唤怪物[ID1、ID2…]各一只 
%%
%% args = [ID1,ID2...]
%% @author qingxuan
%%----------------------------------------------------
-module(skill_script_10140).
-export([
    handle_active/3
]).
-include("common.hrl").
-include("attr.hrl").
-include("role.hrl").
-include("combat.hrl").
-include("skill.hrl").
-include("skill_script.hrl").

handle_active(Skill = #c_skill{args = Args}, Self, _Target) ->
    case Args of
        [_|_] ->
            AddNum = util:check_range(?combat_group_len - count_living_fighter(Self), 0, ?combat_group_len - 1),
            AddList = lists:sublist(Args, AddNum), 
            {L1, L2} = do_script_10140(AddList, Skill, Self, [], []),
            case L1 of
                [SubPlay|_] ->
                    combat:add_sub_play(SubPlay),
                    lists:foreach(fun(SummonSubPlay) -> combat:add_sub_play(SummonSubPlay) end, L2);
                _ -> ignore
            end;
        _ -> ignore
    end,
    ok;

handle_active(_Skill, _Self, _Target) ->
    ok.

%% -------------------------
do_script_10140([], _, _, L1, L2) -> {L1, L2};
do_script_10140([NpcBaseId|T], Skill, Self = #fighter{group = Sgroup}, L1, L2) ->
    combat:release_npc_pos(),
    case combat:add_fighter(npc, Sgroup, undefined, [NpcBaseId]) of
        {F, Fext} ->
            NL1 = [combat:gen_sub_play(attack, Self, Self, Skill, 0, 0, 0, 0, ?false, ?true, ?false)|L1],
            NL2 = [combat:gen_summon_sub_play(Self, F, Fext)|L2],
            do_script_10140(T, Skill, Self, NL1, NL2);
        _ -> do_script_10140(T, Skill, Self, L1, L2)
    end.

count_living_fighter(#fighter{type = _Type, group = Group}) ->
    length([ nil || F = #fighter{is_die = ?false} <- get(Group), F#fighter.type =/= ?fighter_type_pet ]).
