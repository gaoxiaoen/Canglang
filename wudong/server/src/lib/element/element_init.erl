%%%-------------------------------------------------------------------
%%% @author li
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 三月 2018 11:53
%%%-------------------------------------------------------------------
-module(element_init).
-author("li").

-include("common.hrl").
-include("server.hrl").
-include("element.hrl").
-include("skill.hrl").

%% API
-export([
    init/1
]).

init(#player{key = Pkey} = Player) ->
    AllElement = element_load:load_element(Pkey),
    NewAllElement = lists:map(fun(Element) -> element_attr:cacl_element_attr(Element) end, AllElement),
    StElement =
        #st_element{
            element_list = NewAllElement,
            attr = element_attr:cacl_all_element_attr(NewAllElement)
        },
    lib_dict:put(?PROC_STATUS_ELEMENT, StElement),
    StJiandao = element_load:load_jiandao(Pkey),
    NStJiandao = element:update_jiandao(StJiandao),
    NewStJiandao = element_attr:cacl_jiandao_attr(NStJiandao),
    lib_dict:put(?PROC_STATUS_JIANDAO, NewStJiandao),
    WearElementRaceList = lists:flatmap(fun(#element{race = Race, pos = Pos, is_wear = IsWear}) -> ?IF_ELSE(IsWear == 1, [{Race, Pos}], []) end, NewAllElement),
    #base_jiandao_stage{skill_list = SkillList} = data_jiandao_upstage:get(NewStJiandao#st_jiandao.stage),
    JianDaoSkillList = lists:map(fun(SkillId) -> {SkillId, ?PASSIVE_SKILL_TYPE_JIANDAO} end, SkillList),
    Player#player{
        jiandao_stage = NewStJiandao#st_jiandao.stage,
        wear_element_list = WearElementRaceList,
        passive_skill = JianDaoSkillList ++ Player#player.passive_skill
    }.


