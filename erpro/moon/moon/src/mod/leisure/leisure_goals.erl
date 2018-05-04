-module(leisure_goals).
%% --------------------------------------------------------------------
%% 休闲玩法评级相关逻辑
%% @author wangweibiao
%% --------------------------------------------------------------------

%% export
-export([
        deal/1   %% 统计达到的级别以及相应的星星数
    ]).

-include("common.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("leisure.hrl").

-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
deal(Dungeon = #dungeon{id = DungeonId, online_roles = DungeonRoles}) ->
    case leisure_goals_data:get(DungeonId) of
        undefined ->
            Dungeon;
        LeisureGoals ->
        	LeisureGoals1 = lists:reverse(lists:keysort(#leisure_goal.id, LeisureGoals)), %% 从高到低
            DungeonRoles2 = lists:map(fun(DungeonRole) -> calculate_star(DungeonRole, LeisureGoals1, DungeonId) end, DungeonRoles),
            Dungeon#dungeon{online_roles = DungeonRoles2}
    end.

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% LastGoals 表示达到的评级 如 S, D B (5, 4 ,3, 2, 1)
calculate_star(DungeonRole = #dungeon_role{goals = _LastGoals, star = _LastStars}, LeisureGoals, DungeonId) ->
	?DEBUG("--LastStars--~p~n~n~n", [_LastStars]),
	?DEBUG("--_LastGoals--~p~n~n~n", [_LastGoals]),
    {Npc_hp_left, Role_hp_left, Kill_npc} = %%返回的三个数都是整数
    	case get(combat2_goal_result) of 
    		undefined -> {0, 0, 0};
    		Data -> Data
    	end,
    
	?DEBUG("--Kill_npc--~p~n~n~n", [Kill_npc]),
    NGoals = check_goal(LeisureGoals, Npc_hp_left, Role_hp_left, Kill_npc),
    % case NGoals =< LastGoals of 
    % 	true ->
    % 		DungeonRole#dungeon_role{star = 0};
    % 	false ->
    % 		NStars = get_stars(DungeonId, NGoals),
    % 		case NStars =< LastStars of 
    % 			true ->
    % 				DungeonRole#dungeon_role{goals = NGoals};
    % 			false ->
    % 				DungeonRole#dungeon_role{star = NStars, goals = NGoals}
    % 		end
    % end.
	NStars = get_stars(DungeonId, NGoals),
	DungeonRole#dungeon_role{star = NStars, goals = NGoals}.

%%从条件列表中比较达到的一个条件
check_goal([], _, _, _) -> 0 ;
check_goal([#leisure_goal{id = Id, npc_hp_left = CNpc_hp_left, role_hp_left = CRole_hp_left, 
    	kill_npc = CKill_npc}|T], Npc_hp_left, Role_hp_left, Kill_npc) ->
		case Npc_hp_left =< CNpc_hp_left andalso Role_hp_left >= CRole_hp_left andalso Kill_npc >= CKill_npc of 
			true ->
				Id; %% Id表示评分等级
			false ->
				check_goal(T, Npc_hp_left, Role_hp_left, Kill_npc)
		end.

%%根据达到的等级计算总的星星数
get_stars(DungeonId, NGoals) ->
	CondStars = leisure_goals_data:get_stars(DungeonId), %%[{goal, star},{goal, star}...]
	Stars = [Star||{Goal, Star} <- CondStars, NGoals >= Goal],
	lists:sum(Stars).


