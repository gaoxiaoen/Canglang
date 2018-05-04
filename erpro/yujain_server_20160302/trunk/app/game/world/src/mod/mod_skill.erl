%%%-------------------------------------------------------------------
%%% @author jiangxiaowei@ijunhai.com
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 十月 2015 17:27
%%%-------------------------------------------------------------------
-module(mod_skill).

-include("common.hrl").

%% API
-export([handle/1]).
-export([init_skill/2]).

%% @doc 获取玩家技能
handle({Module,?ROLE_GET_SKILL,_DataRecord,RoleId,PId,_Line}) ->
    {ok, #r_role_skill{skill_list = SkillList}} = mod_role:get_role_skill(RoleId),
    SendSelf = #m_role_get_skill_toc{role_skill = SkillList},
    common_misc:unicast(PId,Module,?ROLE_GET_SKILL,SendSelf).

%% 初始化角色技能
init_skill(Category,RoleLevel) ->
    SkillIdList = cfg_skill:get_skill_list(Category),
    init_skill2(SkillIdList,RoleLevel,[]).

init_skill2([],_RoleLevel,ActorSkillList) ->
    ActorSkillList;
init_skill2([SkillId|SkillIdList],RoleLevel,ActorSkillList) ->
    [#r_skill_info{level=Level,min_level=MinLevel}] = cfg_skill:find(SkillId),
    case RoleLevel >= MinLevel of
        true ->
            init_skill2(SkillIdList,RoleLevel,[#p_actor_skill{skill_id = SkillId, level = Level} | ActorSkillList]);
        _ ->
            init_skill2(SkillIdList,RoleLevel,ActorSkillList)
    end.
    
    
    