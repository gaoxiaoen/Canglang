%% --------------------------------------------------------------------
%% 副本目标相关逻辑
%% @author mobin
%% --------------------------------------------------------------------
-module(dungeon_goals).

%% export
-export([
        deal/1   %% 计算副本星星
    ]).

%% include
-include("common.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("gain.hrl").

%% macro

%% for test
-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
%%-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
deal(Dungeon = #dungeon{id = DungeonId, online_roles = DungeonRoles}) ->
    case dungeon_goals_data:get(DungeonId) of
        undefined ->
            Dungeon;
        DungeonGoals ->
            DungeonRoles2 = lists:map(fun(DungeonRole) -> calculate_star(DungeonRole, DungeonGoals, Dungeon) end, DungeonRoles),
            Dungeon#dungeon{online_roles = DungeonRoles2}
    end.

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------
calculate_star(DungeonRole = #dungeon_role{goals = LastGoals, name = _Name, total_hurt = _TotalHurt, has_demon = _HasDemon},
    DungeonGoals, Dungeon = #dungeon{combat_round = _CombatRound, kill_count = _KillCount}) ->
    ?DEBUG("dungeon_goals name[~s], goals[~w], round[~w], kill_count[~w], hurt[~w], demon[~w]",
        [_Name, LastGoals, _CombatRound, _KillCount, _TotalHurt, _HasDemon]),
    DungeonGoals2 = lists:filter(fun(#dungeon_goal{id = Id}) ->
                ((1 bsl Id) band LastGoals) =:= 0
        end, DungeonGoals),

    {TotalStar, Goals} = lists:foldl(fun(#dungeon_goal{id = Id, type = Type, args = Args, 
                    star = Star}, {_TotalStar, _Goals}) ->
                case check_goal(Type, Args, DungeonRole, Dungeon) of
                    true ->
                        {_TotalStar + Star, _Goals + (1 bsl Id)};
                    false ->
                        {_TotalStar, _Goals}
                end
        end, {0, 0}, DungeonGoals2),
    DungeonRole#dungeon_role{star = TotalStar, goals = Goals}.

check_goal(?goal_type_clear, _Args, _, _) ->
    true;
check_goal(?goal_type_round, Args, _, #dungeon{combat_round = CombatRound}) ->
    [Round] = Args,
    CombatRound =< Round;
check_goal(?goal_type_kill_count, Args, _, #dungeon{kill_count = KillCount}) ->
    [Limit] = Args,
    KillCount >= Limit;
check_goal(?goal_type_hurt, Args, #dungeon_role{total_hurt = TotalHurt}, _) ->
    [Hurt] = Args,
    TotalHurt =< Hurt;
check_goal(?goal_type_no_deamon, _Args, #dungeon_role{has_demon = HasDemon}, _) ->
    not HasDemon;
check_goal(?goal_type_top_harm, Args, #dungeon_role{top_harm = TopHarm}, _) ->
    [Limit] = Args,
    TopHarm >= Limit;
check_goal(_, _Args, _, _) ->
    false.
