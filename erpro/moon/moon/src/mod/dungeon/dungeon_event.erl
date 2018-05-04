%% --------------------------------------------------------------------
%% 副本事件处理
%% @author abu@jieyou.cn
%% --------------------------------------------------------------------
-module(dungeon_event).

-export([
        handle_event/3,
        get_event_handler/1
    ]).

-include("common.hrl").
-include("dungeon.hrl").
-include("dungeon_lang.hrl").
-include("role.hrl").
-include("gain.hrl").
-include("activity.hrl").
-include("assets.hrl").
-include("item.hrl").
-include("combat.hrl").

-define(debug_log(P), ?DEBUG("type=~w, value=~w", P)).
%%-define(debug_log(P), ok).

%% --------------------------------------------------------------------
%% API Function
%% --------------------------------------------------------------------

%% @spec get_event_handler(DunBaseId) -> atom()
%% 根据副本id获取 副本事件处理器
get_event_handler(DunBaseId) ->
    get_event_handler(by_base, dungeon_data:get(DunBaseId)).
get_event_handler(by_base, #dungeon_base{type = ?dungeon_type_expedition}) ->
    dungeon_event_expedition;
get_event_handler(by_base, #dungeon_base{type = ?dungeon_type_leisure}) ->
    dungeon_event_leisure;
get_event_handler(by_base, _) ->
    dungeon_event.


%% @spec handle_events(Event, Dun) -> NewDun
%% Event = term()
%% Dun = NewDun = #dungeon{}
%% 处理副本引发的事件

%% 副本启动
handle_event({dungeon_started}, _From, Dun) ->
    Dun;

%% 副本关闭
handle_event({dungeon_stoped}, _From, Dun) ->
    Dun;

%% 玩家进入副本
handle_event({role_enter, _DunRole}, _From, Dun) ->
    Dun;

%% 玩家退出副本
handle_event({role_leave, _DunRole}, _From, Dun) ->
    Dun;

%% 玩家掉线
handle_event({role_logout, _DunRole}, _From, Dun) ->
    Dun;

%% 玩家上线
handle_event({role_login, _DungeonRole = #dungeon_role{conn_pid = ConnPid}}, _From, Dungeon = #dungeon{id = Id,
        type = Type, combat_round = CombatRound}) ->
    Params = case Type of
        ?dungeon_type_time ->
            [CombatRound];
        _ ->
            []
    end,
    sys_conn:pack_send(ConnPid, 13500, {Id, Params}),
    Dungeon;

%% 玩家进入副本地图事件
handle_event({role_enter_map, _, _}, _From, Dun ) ->
    Dun;

handle_event({open_hide_box, ElementId, CastItems}, _From, Dungeon = #dungeon{id = DungeonId, type = Type,
    online_roles = DungeonRoles}) ->
    case Type =:= ?dungeon_type_hide of
        true ->
            %%隐藏副本
            MapId = dungeon_api:get_map_id(DungeonId),
            lists:foreach(fun(DungeonRole = #dungeon_role{rid = Rid, name = Name, pid = Pid}) ->
                        %%宝箱传闻
                        case length(CastItems) > 0 of 
                            true ->
                                %%传闻
                                CastItems2 = [{BaseId, Bind, Q} || #item{base_id = BaseId, bind = Bind, quantity = Q} <- CastItems],
                                erlang:send_after(3000, self(), {event, self(), {cast_item, Name, Rid, CastItems2}});
                            false ->
                                ignore
                        end,
                        role:apply(async, Pid, {fun async_update_hide/5, 
                                [MapId, ElementId, DungeonRole, DungeonId]})
                end, DungeonRoles);
        false ->
            ignore
    end,
    Dungeon;

handle_event({cast_item, Name, Rid, CastItems}, _From, Dungeon = #dungeon{id = DungeonId}) ->
    %%传闻
    RoleName = notice:get_role_msg(Name, Rid),
    DungeonName = notice:get_dungeon_msg(DungeonId),
    Msg = util:fbin(?hide_box_cast, [RoleName, DungeonName, notice:get_item_msg(CastItems)]),
    role_group:pack_cast(world, 10932, {7, 0, Msg}),
    Dungeon;

handle_event({dun_clear}, _From, Dungeon = #dungeon{extra = Extra}) ->
    erlang:send_after(10, self(), {event, self(), {dungeon_clear}}),
    Dungeon#dungeon{extra = [{clear} | Extra]};

%% 副本通关
handle_event({dungeon_clear}, _From, Dungeon = #dungeon{id = DungeonId, type = Type, extra = Extra}) ->
    Dungeon2 = #dungeon{online_roles = DungeonRoles} = dungeon_goals:deal(Dungeon),

    %%评分
    #dungeon_base{cards_id = CardsId} = dungeon_data:get(DungeonId),
    lists:foreach(fun(DungeonRole) -> dungeon_type:send_score_and_rewards(DungeonRole, DungeonId) end, DungeonRoles),

    %%预先加载翻牌Id
    Dungeon3 = case CardsId =/= 0 of
        true ->
            Dungeon2#dungeon{extra = [{cards_id, CardsId} | Extra]};
        false ->
            Dungeon2
    end,
    
    case Type =:= ?dungeon_type_hide of
        true ->
            ignore;
        false ->
            %% 记录星星数和通关次数
            clear_dungeon(DungeonId, DungeonRoles)
    end,
    Dungeon3;

%% 副本翻牌
handle_event({dungeon_cards, CardsId}, _From, Dungeon = #dungeon{id = DungeonId, online_roles = DungeonRoles, extra = Extra}) ->
    case dungeon_cards:start(CardsId, DungeonId, DungeonRoles) of
        {ok, Pid} ->
            Dungeon#dungeon{extra = [{cards_pid, Pid} | Extra]};
        _ ->
            Dungeon
    end;

%% 点选副本宝箱的卡牌
handle_event({choose_card, Rid, ConnPid, Pos}, _From, Dungeon = #dungeon{extra = Extra}) ->
    case lists:keyfind(cards_pid, 1, Extra) of
        false ->
            Dungeon;
        {cards_pid, Pid} ->
            dungeon_cards:choose(Pid, Rid, ConnPid, Pos),
            Dungeon
    end;

%% 副本内杀怪战斗，用于副本评分
handle_event({dungeon_score, Round, NpcBaseIds, ScoreData}, _From, 
    Dungeon = #dungeon{type = Type, args = Args, combat_round = CombatRound, kill_count = KillCount, online_roles = DungeonRoles}) ->
    CombatRound2 = CombatRound + Round,
    KillCount2 = KillCount + length(NpcBaseIds),
    DungeonRoles2 = lists:map(fun(DungeonRole = #dungeon_role{rid = Rid, top_harm = TopHarm,
                    total_hurt = TotalHurt, has_demon = HasDemon}) ->
                case lists:keyfind(Rid, 1, ScoreData) of
                    {Rid, {_, Top, Total, _HasDemon}} ->
                        TopHarm2 = case Top > TopHarm of 
                            true ->
                                Top;
                            false ->
                                TopHarm
                        end,
                        HasDemon2 = HasDemon or _HasDemon,
                        DungeonRole#dungeon_role{total_hurt = TotalHurt + Total, top_harm = TopHarm2, has_demon = HasDemon2};
                    _ ->
                        DungeonRole
                end
        end, DungeonRoles),
    Args2 = case Type of
        ?dungeon_type_time ->
            %%限时模式每打完一批减1
            [TotalRound, NpcCount] = Args,
            [TotalRound, NpcCount - 1];
        _ ->
            Args
    end,
    Dungeon#dungeon{args = Args2, combat_round = CombatRound2, kill_count = KillCount2, online_roles = DungeonRoles2};

%% 容错处理
handle_event(_Event, _From, _Dun) ->
    ?DEBUG("未处理副本事件: ~w", [_Event]),
    _Dun.

%% --------------------------------------------------------------------
%% 内部函数
%% --------------------------------------------------------------------
async_update_hide(Role = #role{dungeon_map = DungeonMap}, MapId, ElementId, DungeonRole, DungeonId) ->
    case lists:keyfind(MapId, 1, DungeonMap) of
        {MapId, Blue, Purple, BlueIsTaken, PurpleIsTaken, IsOpened} ->
            IsOpened2 = [ElementId | IsOpened],
            DungeonMap2 = lists:keyreplace(MapId, 1, DungeonMap, 
                {MapId, Blue, Purple, BlueIsTaken, PurpleIsTaken, IsOpened2}),
            Role2 = Role#role{dungeon_map = DungeonMap2},
            %%开完宝箱弹评分
            case length(IsOpened2) < 3 of
                true ->
                    {ok, Role2};
                false ->
                    DungeonRole2 = DungeonRole#dungeon_role{star = 3, goals = 14},
                    dungeon_type:async_send_score_and_rewards(Role2, DungeonRole2, DungeonId)
            end;
        _ ->
            {ok, Role}
    end.

%% 记录副本的通关次数和星星数
clear_dungeon(DungeonId, DungeonRoles) ->
    lists:foreach(fun(#dungeon_role{pid = Pid, star = Star, goals = Goals}) -> 
                dungeon_api:clear_dungeon(Pid, DungeonId, Star, Goals, 1) 
        end, DungeonRoles).
