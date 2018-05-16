%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 十一月 2017 11:54
%%%-------------------------------------------------------------------
-module(pet_buff).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("pet.hrl").
-include("pet_war.hrl").
-include("battle.hrl").
-include("skill.hrl").

%% API
-export([
    skill_add_buff/3,
    buff_to_effect/1,
    add_buff/3
]).

skill_add_buff(Bs, [], _SkillId) -> Bs;
skill_add_buff(Bs, [BuffId | BuffIdList], SkillId) ->
    case data_buff:get(BuffId) of
        [] -> skill_add_buff(Bs, BuffIdList, SkillId);
        #buff{} = BaseBuff ->
            AddBuff =
                #skillbuff{
                    buffid = BuffId,
                    skillid = SkillId,
                    type = BaseBuff#buff.type,
                    subtype = BaseBuff#buff.subtype
                },
            NewAer = Bs#bs{buff_list = [AddBuff|Bs#bs.buff_list]},
            skill_add_buff(NewAer, BuffIdList, SkillId)
    end.

buff_to_effect(Bs) ->
    buff_to_effect(Bs#bs{buff_list = []}, Bs#bs.buff_list).

buff_to_effect(Bs, []) -> Bs;
buff_to_effect(Bs, [Buff | BuffList]) ->
    #skillbuff{buffid = BuffId, skillid = SkillId} = Buff,
    case data_buff:get(BuffId) of
        [] -> buff_to_effect(Bs, BuffList);
        #buff{efflist = EffList} ->
            NewAer = pet_effect:add_effect(Bs, EffList, SkillId),
            buff_to_effect(NewAer, BuffList)
    end.

add_buff(BsList, BuffidList, SkillId) ->
    F = fun(Bs) -> do_add_buff(Bs, BuffidList, SkillId) end,
    lists:map(F, BsList).

do_add_buff(Bs, [], _SkillId) -> Bs;
do_add_buff(Bs, BuffidList, SkillId) ->
    Bs0 = skill_add_buff(Bs, BuffidList, SkillId),
    Bs1 = buff_to_effect(Bs0),
    pet_effect:active(Bs1).