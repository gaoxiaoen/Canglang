%%-------------------------------------------------------------------
%% File              :mod_monster_misc.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-23
%% @doc
%%     怪物通用模块
%% @end
%%-------------------------------------------------------------------


-module(mod_monster_misc).

-include("mgeem.hrl").

-export([calc_skill_consume_mp/2,
         calc_skill_consume_mp/3]).

%% 计算技能消耗的魔法值
%% SkillId 技能id
%% SkillLevel 技能等级
-spec
calc_skill_consume_mp(SkillId,SkillLevel) -> ConsumeMp when
    SkillId :: skill_id,
    SkillLevel :: skill_level,
    ConsumeMp :: integer.
calc_skill_consume_mp(SkillId,SkillLevel) ->
    case cfg_skill:find(SkillId) of
        [] ->
            0;
        [#r_skill_info{consume_mp = ConsumeMp, consume_mp_index = ConsumeMpIndex}] ->
            ConsumeMp + erlang:trunc(ConsumeMpIndex * SkillLevel)
    end.
calc_skill_consume_mp(_SkillId,SkillLevel,SkillInfo) ->
    #r_skill_info{consume_mp = ConsumeMp, consume_mp_index = ConsumeMpIndex} = SkillInfo,
    ConsumeMp + erlang:trunc(ConsumeMpIndex * SkillLevel).