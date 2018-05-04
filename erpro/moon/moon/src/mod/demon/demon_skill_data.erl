%%---------------------------------------------
%% @author 
%% @end
%%---------------------------------------------

-module(demon_skill_data).
-export([
        common_skills/0
        ,common_skill_id/2
        ,common_skill/2
    ]).

-include("common.hrl").

common_skills() ->
    [800047, 800048, 800049, 800050, 800051].

common_skill_id(_AttackType, 118009) -> 800049;
common_skill_id(_AttackType, 118010) -> 800050;
common_skill_id(_AttackType, 118011) -> 800051;
common_skill_id(_AttackType, 118012) -> 800052;
common_skill_id(attack, _NpcBaseId) -> 800047; %% 默认的
common_skill_id(remote, _NpcBaseId) -> 800048.

common_skill(AtkType, NpcBaseId) ->
    combat_data_skill:get(common_skill_id(AtkType, NpcBaseId)).
