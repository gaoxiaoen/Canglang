%% --------------------------------------------------------------------
%% 远征王军事件处理
%% @author mobin
%% --------------------------------------------------------------------
-module(dungeon_event_expedition).

-export([
        handle_event/3
    ]).

-include("common.hrl").
-include("map.hrl").
-include("npc.hrl").
-include("dungeon.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("hall.hrl").
%%

%%-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API Function
%% --------------------------------------------------------------------
%% 副本关闭
handle_event({dungeon_stoped}, _From, Dungeon = #dungeon{extra = _Extra}) ->
    Dungeon;

%% 玩家上线
handle_event({role_login, _DungeonRole = #dungeon_role{rid = _Rid, pid = _Pid, conn_pid = ConnPid}}, _From,
    %%包含了role_switch
    Dungeon = #dungeon{id = Id, extra = _Extra}) ->
    sys_conn:pack_send(ConnPid, 13500, {Id, []}),
    Dungeon;

%% 玩家掉线
handle_event({role_logout, #dungeon_role{rid = _Rid}}, _From, Dungeon = #dungeon{extra = _Extra}) ->
    Dungeon;

%% 玩家进入副本地图事件
handle_event({role_enter_map, {_, Pid}, _}, _From, Dungeon = #dungeon{combat_pid = CombatPid}) ->
    %%被队友拉入战斗
    case is_pid(CombatPid) andalso erlang:is_process_alive(CombatPid) of
        true ->
            role:apply(async, Pid, {combat, role_join, [CombatPid, group_atk]});
        _ ->
            ignore
    end,
    Dungeon;

%% @spec handle_events(Event, Dun) -> NewDun
%% Event = term()
%% Dun = NewDun = #dungeon{}
%% 处理副本引发的事件
%% 副本通关
handle_event({dungeon_clear}, _From, Dungeon = #dungeon{id = DungeonId}) ->
    Dungeon2 = #dungeon{online_roles = DungeonRoles} = dungeon_goals:deal(Dungeon),
    %%评分
    #dungeon_base{cards_id = _CardsId} = dungeon_data:get(DungeonId),
    lists:foreach(fun(DungeonRole) -> dungeon_type:send_score_and_rewards(DungeonRole, DungeonId) end, DungeonRoles),
    
    %%客户端延迟胜利界面5秒，副本评分界面4秒
    %%erlang:send_after(8000, self(), {event, self(), {dungeon_cards, CardsId}}),
    %%erlang:send_after(8100, self(), {event, self(), {room_end_combat}}),
    
    %%触发其它模块
    lists:foreach(fun(#dungeon_role{pid = RolePid}) -> role:apply(async, RolePid, {fun async_trigger/1, []}) end, DungeonRoles),
    Dungeon2;
   
%% 此模块不处理的提交给dungeon_event处理
handle_event(Event, From, Dungeon) ->
    dungeon_event:handle_event(Event, From, Dungeon).


async_trigger(Role) ->
    %%军团目标监听
    Role1 = role_listener:guild_multi_dun(Role, {}),
    Role2 = role_listener:special_event(Role1, {3005, 1}),  %% 触发日常
    Role3 = role_listener:special_event(Role2, {2005, 1}),
    {ok, Role3}.
