%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 一月 2015 上午11:20
%%%-------------------------------------------------------------------
-module(skill_load).
-author("fancy").

-include("skill.hrl").
%% API
-export([
    dbget_skill/1,
    dbup_player_skill/1

]).

dbget_skill(Pkey) ->
    SQL = io_lib:format("select skill_effect,skill_battle_list,skill_passive_list from player_skill where pkey = ~p", [Pkey]),
    db:get_row(SQL).


%%更新技能列表
dbup_player_skill(St) ->
    SQL = io_lib:format("replace into player_skill set pkey = ~p ,skill_effect=~p,skill_battle_list = '~s',skill_passive_list='~s'",
        [St#st_skill.pkey,
            St#st_skill.skill_effect,
            util:term_to_bitstring(St#st_skill.skill_battle_list),
            util:term_to_bitstring(St#st_skill.skill_passive_list)
        ]),
    db:execute(SQL).
