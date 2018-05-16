%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 一月 2015 上午11:32
%%%-------------------------------------------------------------------
-module(skill_init).
-author("fancy").
-include("common.hrl").
-include("server.hrl").
-include("skill.hrl").
%% API
-export([init/1, calc_skill_passive_attribute/1, get_skill_passive_attribute/0]).
-export([timer_update/0, logout/0]).
init(Player) ->
    StSkill =
        case player_util:is_new_role(Player) of
            true ->
                #st_skill{pkey = Player#player.key};
            false ->
                case skill_load:dbget_skill(Player#player.key) of
                    [] ->
                        #st_skill{pkey = Player#player.key};
                    [SkillEffect, SkillBattleList, SkillPassiveList] ->
                        SkillBattleList1 = util:bitstring_to_term(SkillBattleList),
                        SkillPassiveList1 = util:bitstring_to_term(SkillPassiveList),
                        Attribute = calc_skill_passive_attribute(SkillPassiveList1),
                        #st_skill{pkey = Player#player.key, skill_effect = SkillEffect, skill_battle_list = SkillBattleList1, skill_passive_list = SkillPassiveList1, attribute = Attribute}

                end
        end,
    lib_dict:put(?PROC_STATUS_SKILL, StSkill),
    Player#player{skill_effect = StSkill#st_skill.skill_effect, skill = [SkillId || {SkillId, _} <- StSkill#st_skill.skill_battle_list]}.

%%被动技能属性
calc_skill_passive_attribute(SkillPassiveList) ->
    F = fun(SkillId) ->
        case data_skill:get(SkillId) of
            [] -> [];
            Skill -> Skill#skill.attrs
        end
        end,
    AttrList = lists:flatmap(F, SkillPassiveList),
    attribute_util:make_attribute_by_key_val_list(AttrList).

get_skill_passive_attribute() ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    St#st_skill.attribute.



timer_update() ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    if St#st_skill.is_change == 1 ->
        lib_dict:put(?PROC_STATUS_SKILL, St#st_skill{is_change = 0}),
        skill_load:dbup_player_skill(St);
        true -> ok
    end.

logout() ->
    St = lib_dict:get(?PROC_STATUS_SKILL),
    if St#st_skill.is_change == 1 ->
        skill_load:dbup_player_skill(St);
        true -> ok
    end.



