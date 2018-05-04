%%----------------------------------------------------
%% 雪山地牢api
%%
%% @author mobin
%%----------------------------------------------------
-module(jail_api).
-export([
        enter/1
        ,exit_jail/1
        ,exit_combat/1
        ,forward/1
        ,attack/1
        ,get_jail_role/1
        ,next_day/1
        ,gm_floor/2
        ,gm_boss/3
        ,gm_add/3
    ]).
-include("common.hrl").
-include("role.hrl").
-include("link.hrl").
-include("jail.hrl").
-include("jail_config.hrl").
-include("pos.hrl").

-define(max_floor, 45).

%% 请求进入
enter(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    JailRole = #jail_role{floor = Floor, life = Life, left_time = LeftTime, status = Status, bosses = Bosses, left_count = LeftCount} = get_jail_role(Rid),
    %%修正状态
    Status2 = case Status =:= ?lose andalso LeftCount > 0 of
        true ->
            put(jail_role, JailRole#jail_role{status = ?forward}),
            ?forward;
        _ ->
            Status
    end,

    sys_conn:pack_send(ConnPid, 14800, {Floor, Life, LeftTime, Status2, Bosses}),
    case LeftCount of
        0 ->
            %%没有次数了
            Role;
        _ ->
            enter_jail_map(Role, true)
    end.
    
exit_jail(Role = #role{link = #link{conn_pid = ConnPid}, pos = #pos{last = {LmapId, Lx, Ly}}}) ->
    case map:role_enter(LmapId, Lx, Ly, Role) of
        {ok, Role2} ->
            sys_conn:pack_send(ConnPid, 14801, {}),
            Role2#role{event = ?event_no};
        {false, _Reason} ->
            Role
    end.

exit_combat(Role) ->
    #jail_role{floor = Floor, status = Status} = get(jail_role),
    Role2 = case Status of
        ?lose ->
            exit_jail(Role);
        _ ->
            enter_jail_map(Role, false)
    end,
    {{Floor}, Role2}.

forward(_Role = #role{link = #link{conn_pid = ConnPid}}) ->
    JailRole = #jail_role{floor = Floor, status = Status} = get(jail_role),
    case Status =:= ?forward of
        true ->
            case Floor =< ?max_floor of
                true ->
                    Bosses = get_floor_bosses(Floor),
                    put(jail_role, JailRole#jail_role{status = ?gamble, bosses = Bosses}),
                    Bosses;
                false ->
                    sys_conn:pack_send(ConnPid, 14808, {}),
                    []
            end;
        false ->
            []
    end.
    
attack(_Role = #role{pid = RolePid, link = #link{conn_pid = ConnPid}}) ->
    JailRole = #jail_role{status = Status} = get(jail_role),
    case Status =:= ?prepare of
        true ->
            put(jail_role, JailRole#jail_role{status = ?attack}),
            jail_mgr:enter_combat_area(RolePid, ConnPid, JailRole);
        false ->
            ignore
    end.

%%必须在角色进程内判断
get_jail_role(Rid) ->
    Today = util:unixtime({today, util:unixtime()}),
    JailRole2 = case get(jail_role) of
        undefined ->
            case fetch_jail_role(Rid) of
                false ->
                    #jail_role{rid = Rid, life = ?init_life, left_time = ?init_left_time, last = util:unixtime()};
                JailRole ->
                    JailRole#jail_role{last = util:unixtime()}
            end;
        JailRole = #jail_role{last = Last} when Last >= Today ->
            JailRole#jail_role{last = util:unixtime()};
        #jail_role{anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_sleep = AntiSleep, anti_stone = AntiStone, best_floor = BestFloor} ->
            #jail_role{rid = Rid, life = ?init_life, left_time = ?init_left_time, last = util:unixtime(),
                anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_sleep = AntiSleep, 
                anti_stone = AntiStone, best_floor = BestFloor}
    end,
    put(jail_role, JailRole2),
    JailRole2.

next_day(Rid) ->
    JailRole = get_jail_role(Rid),
    put(jail_role, JailRole#jail_role{last = 0}).

gm_floor(Rid, Floor) ->
    JailRole = get_jail_role(Rid),
    put(jail_role, JailRole#jail_role{floor = Floor}).

gm_boss(Rid, IsClear, NpcBaseId) ->
    JailRole = #jail_role{bosses = Bosses} = get_jail_role(Rid),
    Bosses2 = case IsClear of
        1 ->
            [NpcBaseId];
        _ ->
            [NpcBaseId | Bosses]
    end,
    put(jail_role, JailRole#jail_role{bosses = Bosses2}).

gm_add(Rid, Life, LeftTime) ->
    JailRole = get_jail_role(Rid),
    put(jail_role, JailRole#jail_role{life = Life, left_time = LeftTime}).

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
enter_jail_map(Role = #role{pid = RolePid, id = {RoleId, SrvId}, link = #link{conn_pid = ConnPid},
        pos = Pos = #pos{map = MapId, map_pid = MapPid, x = X, y = Y}}, IsFromOutside) ->
    map:role_leave(MapPid, RolePid, RoleId, SrvId, X, Y), %% 离开上一个地图
    sys_conn:pack_send(ConnPid, 10110, {?jail_map_id, ?jail_x, ?jail_y}),
    %%从外面进来的要记住进入前的地图
    Pos2 = case IsFromOutside of
        true ->
            Pos#pos{last = {MapId, X, Y}};
        _ ->
            Pos
    end,
    Role#role{
        event = ?event_jail,
        pos = Pos2#pos{
            map = ?jail_map_id,
            x = ?jail_x, 
            y = ?jail_y
        } 
    }.

rand_bosses(0, _Bosses, _SumRand, Return) ->
    Return;
rand_bosses(Count, Bosses, SumRand, Return) ->
    RandValue = util:rand(1, SumRand),
    rand_bosses(Count - 1, Bosses, SumRand, [lists:nth(RandValue, Bosses) | Return]).

get_floor_bosses(Floor) ->
    Items = jail_data:floor_bosses(Floor),
    Rands = [Rand || {_, Rand} <- Items],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    Bosses = get_floor_bosses(RandValue, Items),
    lists:foldl(fun({Quality, Count}, Return) ->
                All = jail_data:bosses(Quality),
                Length = length(All),
                case Length > 0 of
                    true ->
                        rand_bosses(Count, All, Length, Return);
                    false ->
                        Return
                end
        end, [], Bosses).
get_floor_bosses(RandValue, [{Bosses, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Bosses;
get_floor_bosses(RandValue, [{_, Rand} | T]) ->
    get_floor_bosses(RandValue - Rand, T).

fetch_jail_role(Rid = {RoleId, SrvId}) ->
    Today = util:unixtime({today, util:unixtime()}),
    Sql = "select floor, status, life, left_time, bosses, last, left_count, anti_stun, anti_taunt, anti_sleep, anti_stone, best_floor from sys_jail where role_id = ~s and srv_id = ~s",
    case db:get_row(Sql, [RoleId, SrvId]) of
        {ok, [Floor, Status, Life, LeftTime, Bosses, Last, LeftCount, AntiStun, AntiTaunt, AntiSleep, AntiStone, BestFloor]} when Last >= Today ->
            case util:bitstring_to_term(Bosses) of
                {ok, BossesTerm} ->
                    #jail_role{rid = Rid, floor = Floor, status = Status, life = Life, left_time = LeftTime,
                        bosses = BossesTerm, left_count = LeftCount, anti_stun = AntiStun, 
                        anti_taunt = AntiTaunt, anti_sleep = AntiSleep, anti_stone = AntiStone, 
                        best_floor = BestFloor};
                _ ->
                    false
            end;
        {ok, [_, _, _, _, _, _, _, AntiStun, AntiTaunt, AntiSleep, AntiStone, BestFloor]} ->
            #jail_role{rid = Rid, anti_stun = AntiStun, anti_taunt = AntiTaunt, anti_sleep = AntiSleep,
                anti_stone = AntiStone, best_floor = BestFloor, life = ?init_life, left_time = ?init_left_time};
        {_, _} ->
            false
    end.
