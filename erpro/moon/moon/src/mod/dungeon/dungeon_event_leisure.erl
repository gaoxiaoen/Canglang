-module(dungeon_event_leisure).
-export([
	handle_event/3
	]).

-include("common.hrl").
-include("map.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("activity.hrl").
-include("assets.hrl").
-include("pos.hrl").
-include("item.hrl").
-include("combat.hrl").


%% 休闲玩法 触发评分，新需求是不管是否通关都要触发
handle_event({dun_clear_leisure, Result}, _From, Dungeon = #dungeon{extra = Extra}) ->
    erlang:send_after(10, self(), {event, self(), {dungeon_clear_leisure, Result}}),
    Dungeon#dungeon{extra = [{clear} | Extra]};

%% 休闲玩法 副本通关
handle_event({dungeon_clear_leisure, Result}, _From, Dungeon = #dungeon{id = DungeonId}) ->

    Dungeon2 = #dungeon{online_roles = DungeonRoles} = leisure_goals:deal(Dungeon), %% 计算达到的目标以及获得星星数
    %%评分
    ?DEBUG("--DungeonRoles---~p~n~n", [DungeonRoles]),
    lists:foreach(fun(DungeonRole) -> leisure:send_score_and_rewards(DungeonRole, DungeonId, Result) end, DungeonRoles), %%  发送评分获得奖励

    % case Result of
    %     ?combat_result_win ->    
            lists:foreach(fun(#dungeon_role{pid = Pid, star = Star, goals = Goals}) -> 
                        dungeon_api:clear_dungeon_leisure(Pid, DungeonId, Star, Goals, 1) 
                end, DungeonRoles), %% 开启困难副本，勋章监听军团目标，任务完成等逻辑处理
    %     _ -> ignore
    % end,

    Dungeon2;

%%休闲玩法：统计杀怪的数量
handle_event({leisure_kill_npc, NpcBaseId}, _From, Dungeon = #dungeon{kill_count = KillCount, online_roles = [#dungeon_role{pid = Pid}|_]}) ->
    NCount = KillCount + 1,
    case get(combat2_goal_result) of
        {NpcHp, RoleHp, Old} ->
            case NCount > Old of
                true ->
                    put(combat2_goal_result, {NpcHp, RoleHp, NCount});
                _ -> 
                    put(combat2_goal_result, {NpcHp, RoleHp, Old})
            end;
        _ -> ignore
    end,
    role:apply(async, Pid, {fun leisure_kill_npc_listener/2, [NpcBaseId]}),
    Dungeon#dungeon{kill_count  = NCount};

%% 容错处理
handle_event(Event, From, Dungeon) ->
    dungeon_event:handle_event(Event, From, Dungeon).

%%------------------------------------------------------------
%% Internal func
%%------------------------------------------------------------

%%休闲玩法杀怪任务监听，后面会一起移到独立文件
leisure_kill_npc_listener(Role, NpcBaseId)->
    NRole = role_listener:kill_npc(Role, NpcBaseId, 1),
    {ok, NRole}.
    
