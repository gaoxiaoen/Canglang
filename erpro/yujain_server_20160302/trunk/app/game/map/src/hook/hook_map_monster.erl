%%-------------------------------------------------------------------
%% File              :hook_map_monster.erl
%% Author            :caochuncheng2002@gmail.com
%% Create Date       :2015-11-17
%% @doc
%%     Hook 怪物
%% @end
%%-------------------------------------------------------------------


-module(hook_map_monster).

-include("mgeem.hrl").

-export([monster_dead/5]).

%% 怪物死亡Hook
%% RoleId 击杀怪物玩家，如果KillerType == ?ACTOR_TYPE_MONSTER 即RoleId=0
%% TypeId 怪物类型Id 对应 #r_monster_info.type_id 即在cfg_monster.erl中配置
%% KillerId 击杀者Id
%% KillerType 击杀者类型
-spec
monster_dead(TypeId,MapId,RoleId,KillerId,KillerType) -> ok when
    TypeId :: integer,
    MapId :: integer,
    RoleId :: integer,
    KillerId :: integer,
    KillerType :: ?ACTOR_TYPE_ROLE | ?ACTOR_TYPE_PET | ?ACTOR_TYPE_MONSTER.
monster_dead(_TypeId,_MapId,_RoleId,_KillerId,_KillerType) ->
    
    ok.
