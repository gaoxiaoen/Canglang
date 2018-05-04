%%----------------------------------------------------
%% 雪山地牢管理进程
%%
%% @author mobin
%%----------------------------------------------------
-module(jail_mgr).
-behaviour(gen_server).

%% api funs
-export([
        start_link/0
        ,login/1
        ,combat_reconnect/3
        ,push_status/1
        ,role_logout/1
        ,enter_combat_area/3
        ,combat_over/5
    ]).

%% gen_server callback
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("common.hrl").
-include("jail.hrl").
-include("jail_config.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("attr.hrl").
-include("gain.hrl").
-include("npc.hrl").
-include("link.hrl").
-include("pos.hrl").
-include("unlock_lev.hrl").

-define(group_count, 3).
-define(npc_x, 1000).
-define(prepare_combat_time, 4 * 1000).    %% 等待进入战斗的时间
-define(clear_map_timer, 5 * 1000).    %% 清除地图的时间
-define(offline_award_id, 110001).

%% record
-record(state, {}).

%% --------------------------------------------------------------------
%% API functions
%% --------------------------------------------------------------------
%% @spec start_link() -> {ok,Pid} | ignore | {error,Error}
%% Starts the server
start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} ->
            {ok, Pid};
        Other ->
            Other
    end.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户上线处理
login(Role = #role{event = ?event_jail, id = Rid, link = #link{conn_pid = ConnPid}, pos = Pos}) ->
    push_status(Role),
    JailRole = #jail_role{floor = Floor, life = Life, left_time = LeftTime, status = Status, bosses = Bosses} = jail_api:get_jail_role(Rid),
    Status2 = case Status =:= ?attack of
        true ->
            put(jail_role, JailRole#jail_role{status = ?prepare}),
            ?prepare;
        false ->
            Status
    end,
    sys_conn:pack_send(ConnPid, 14800, {Floor, Life, LeftTime, Status2, Bosses}),
    Role#role{pos = Pos#pos{map = ?jail_map_id, x = ?jail_x, y = ?jail_y}};
login(Role) ->
    push_status(Role),
    Role.

combat_reconnect(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}, Life, LeftTime) ->
    push_status(Role),
    #jail_role{floor = Floor, bosses = Bosses} = jail_api:get_jail_role(Rid),
    sys_conn:pack_send(ConnPid, 14800, {Floor, Life, LeftTime, ?attack, Bosses}),
    Role.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户上线处理
push_status(#role{id = Rid, lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    UnlockLev = ?jail_unlock_lev,
    case Lev < UnlockLev of 
        true ->
            ignore;
        false ->
            #jail_role{left_count = LeftCount} = jail_api:get_jail_role(Rid),
            sys_conn:pack_send(ConnPid, 14810, {LeftCount})
    end.

%% @spec role_logout(Role) -> NewRole
%% Role = NewRole = #role{}
%% 用户掉线处理
role_logout(Role = #role{}) ->
    case get(jail_role) of
        undefined ->
            ok;
        JailRole ->
            ?MODULE ! {save_jail_role, JailRole}
    end,
    Role.

enter_combat_area(RolePid, ConnPid, JailRole) ->
    gen_server:cast(?MODULE, {enter_combat_area, RolePid, ConnPid, JailRole}).

combat_over(Rid, RolePid, Result, Life, LeftTime) ->
    gen_server:cast(?MODULE, {combat_over, Rid, RolePid, Result, Life, LeftTime}).

%% --------------------------------------------------------------------
%% gen_server callback functions
%% --------------------------------------------------------------------
%% @spec init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
init([]) ->
    ?INFO("[~w] 启动完成", [?MODULE]),
    {ok, #state{}}.

%% @spec: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.


%% @spec: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
handle_cast({enter_combat_area, RolePid, ConnPid, JailRole = #jail_role{rid = Rid, left_time = LeftTime, 
            bosses = Bosses}}, State) ->
    GroupCount = util:ceil(length(Bosses) / ?group_count),
    [Bosses2 | Args] = create_boss_group(Bosses, GroupCount, []),
    Args2 = [LeftTime | Args],

    case create_map(Bosses2) of
        {ok, MapPid, MapId, BossIds} ->
            %%标记地图已用
            add_to_matched_map(Rid, MapId, MapPid),

            %%进入地图
            role:apply(async, RolePid, {fun async_enter_combat_area/2, [MapId]}),

            ?DEBUG("[~w]准备在雪山地牢开始和[~w]战斗，参数[~w]", [Rid, Bosses, Args2]),
            erlang:send_after(?prepare_combat_time, self(), {start_combat, RolePid, JailRole, BossIds, Args2});
        _ ->
            sys_conn:pack_send(ConnPid, 14804, {?false})
    end,
    {noreply, State};

handle_cast({combat_over, Rid, RolePid, Result, Life, LeftTime}, State) ->
    ?DEBUG("[~w]在雪山地牢战斗结果[~w], 生命[~w]，剩余时间[~w]", [Rid, Result, Life, LeftTime]),
    role:apply(async, RolePid, {fun async_combat_over/4, [Result, Life, LeftTime]}),
    erlang:send_after(?clear_map_timer, self(), {clear_matched_map, Rid}),
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% @spec: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
handle_info({start_combat, RolePid, #jail_role{rid = Rid, life = Life, anti_stun = AntiStun, 
            anti_taunt = AntiTaunt, anti_sleep = AntiSleep, anti_stone = AntiStone}, BossIds, Args}, State) ->
    case role_to_fighters(Rid, RolePid) of
        false ->
            %%清理地图
            erlang:send_after(?clear_map_timer, self(), {clear_matched_map, Rid});
        CF = #converted_fighter{fighter = Fighter = #fighter{attr = Attr}} ->
            CF2 = CF#converted_fighter{fighter = Fighter#fighter{attr = Attr#attr{anti_stun = AntiStun + Attr#attr.anti_stun,
                        anti_taunt = AntiTaunt + Attr#attr.anti_taunt, anti_sleep = AntiSleep + Attr#attr.anti_sleep,
                        anti_stone = AntiStone + Attr#attr.anti_stone}, life = Life}},
            DfdList = npcs_to_fighters(BossIds, []),
            case combat:start(?combat_type_jail, [], [CF2], DfdList, Args) of
                {ok, _CombatPid} ->
                    ok;
                _Why ->
                    ?ERR("[~w]在雪山地牢发起战斗失败:~w", [Rid, _Why]),
                    erlang:send_after(?clear_map_timer, self(), {clear_matched_map, Rid})
            end
    end,
    {noreply, State};

handle_info({clear_matched_map, Rid}, State = #state{}) ->
    clear_matched_map(Rid),
    {noreply, State};

handle_info({save_jail_role, JailRole}, State = #state{}) ->
    save_jail_role(JailRole),
    {noreply, State};

handle_info(_Info, State) ->
    ?DEBUG("invalid info: ~w", [_Info]),
    {noreply, State}.

%% @spec: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
terminate(_Reason, _State) ->
    ok.

%% @spec: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
create_boss_group(_Bosses, 0, Return) ->
    lists:reverse(Return);
create_boss_group(Bosses, Count, Return) ->
    [{Race, RaceCount} | _] = get_sorted_race(Bosses),
    Group = lists:foldl(fun(NpcBaseId, Result) ->
            TargetRace = jail_data:race(NpcBaseId),
            case TargetRace =:= Race of
                true ->
                    [NpcBaseId | Result];
                false ->
                    Result
            end
        end, [], Bosses),
    %%上限
    Group2 = case RaceCount > ?group_count of
        true ->
            lists:sublist(Group, ?group_count);
        false ->
            Group
    end,
    NeedCount = ?group_count - length(Group2),
    Bosses2 = Bosses -- Group2,
    BossesLength = length(Bosses2),
    %%下限
    {Group3, Bosses3} = case BossesLength > 0 andalso NeedCount > 0 of
        true ->
            {L1, L2} = lists:split(erlang:min(BossesLength, NeedCount), Bosses2),
            {Group2 ++ L1, L2};
        false ->
            {Group2, Bosses2}
    end,
    create_boss_group(Bosses3, Count - 1, [Group3 | Return]).

get_sorted_race(Bosses) ->
    Races = lists:foldl(fun(NpcBaseId, Result) ->
            Race = jail_data:race(NpcBaseId),
            case lists:keyfind(Race, 1, Result) of
                false ->
                    [{Race, 1} | Result];
                {Race, Count} ->
                    lists:keyreplace(Race, 1, Result, {Race, Count + 1})
            end
        end, [], Bosses),
    SortFun = fun({_, Value1}, {_, Value2}) ->
            Value1 > Value2
    end,
    lists:sort(SortFun, Races).

async_enter_combat_area(Role = #role{name = _Name, link = #link{conn_pid = ConnPid}, pos = #pos{last = Last}}, MapId) ->
    Role5 = case map:role_enter(MapId, ?npc_x - 300, ?combat_upper_pos_y, Role) of
        {ok, Role2 = #role{pos = NewPos}} -> 
            ?DEBUG("[~s]进入雪山地牢区域成功", [_Name]),
            sys_conn:pack_send(ConnPid, 14804, {?true}),
            %%确保上一地图是进入前的地图
            Role2#role{pos = NewPos#pos{last = Last}};
        {false, _Why} -> 
            ?ERR("[~s]进入雪山地牢区域失败:~s", [_Name, _Why]),
            sys_conn:pack_send(ConnPid, 14804, {?false}),
            Role
    end,
    {ok, Role5}.

%%-----------------------------------------
%% 战斗相关
%%-----------------------------------------
role_to_fighters({RoleId, SrvId}, RolePid) ->
    case role_api:lookup(by_pid, RolePid, to_fighter) of
        {ok, _, #converted_fighter{fighter_ext = #fighter_ext_role{event = Event}}} when Event =/= ?event_jail ->
            ?ERR("[~w, ~s]的当前事件状态不正确[Event=~w]，无法加入竞技场战斗", [RoleId, SrvId, Event]),
            false;
        {ok, _, CF = #converted_fighter{}} ->
            CF;
        {error, not_found} -> %% 掉线
            ?INFO("[~w, ~s]掉线，查找不到了", [RoleId, SrvId]),
            false;
        _Err -> 
            ?ERR("查找并转换角色[~w, ~s]出错:~w", [RoleId, SrvId, _Err]),
            false
    end.

npcs_to_fighters([], Return) ->
    Return;
npcs_to_fighters([NpcId | T], Return) ->
    case npc_mgr:get_npc(<<>>, NpcId) of
        Npc = #npc{} ->
            {ok, F} = npc_convert:do(to_fighter, Npc),
            npcs_to_fighters(T, [F | Return]);
        _ ->
            npcs_to_fighters(T, Return)
    end.

async_combat_over(Role = #role{id = Rid, link = #link{conn_pid = ConnPid}}, Result, Life, LeftTime) ->
    JailRole = #jail_role{floor = Floor, left_count = LeftCount, best_floor = BestFloor} = get(jail_role),
    Role2 = case Result of
        ?combat_result_win ->
            {Items, Exp, Stone, AwardLife, AwardLeftTime} = jail_data:floor_rewards(Floor),
            Exp2 = Exp * util:rand(?exp_percent, 100) div 100,
            Stone2 = Stone * util:rand(?stone_percent, 100) div 100,
            Items2 = get_drop_items(Items, []),
            %%上限9条命，59:59秒
            AwardLife2 = case Life + AwardLife > 9 of
                true ->
                    9 - Life;
                false ->
                    AwardLife
            end,
            AwardLeftTime2 = case LeftTime + AwardLeftTime > 3599 of
                true ->
                    3599 - LeftTime;
                false ->
                    AwardLeftTime
            end,
            sys_conn:pack_send(ConnPid, 14809, {?true, LeftTime, AwardLife2, AwardLeftTime2, Exp2, Stone2, Items2}),

            JailRole2 = get_anti_attr(ConnPid, JailRole),
            BestFloor2 = case Floor > BestFloor of
                true ->
                    Floor;
                false ->
                    BestFloor
            end,
            put(jail_role, JailRole2#jail_role{floor = Floor + 1, status = ?forward, bosses = [],
                    life = Life + AwardLife2, left_time = LeftTime + AwardLeftTime2, best_floor = BestFloor2}),
            %%获得奖励
            Gains = get_gains(Exp2, Stone2, Items2),
            case role_gain:do(Gains, Role) of
                {ok, _Role} ->
                    _Role;
                _ ->
                    award:send(Rid, ?offline_award_id, Gains),
                    Role
            end;
        _ ->
            sys_conn:pack_send(ConnPid, 14809, {?false, 0, 0, 0, 0, 0, []}),
            LeftCount2 = LeftCount - 1,
            %%推送剩余次数
            sys_conn:pack_send(ConnPid, 14810, {LeftCount2}),
            put(jail_role, JailRole#jail_role{floor = 1, status = ?lose, life = ?init_life,
                    left_time = ?init_left_time, bosses = [], left_count = LeftCount2}),
            Role#role{event = ?event_no}
    end,
    {ok, Role2}.

get_drop_items([], Return) ->
    Return;
get_drop_items([{BaseId, Count, DropRate, BindRate} | T], Return) ->
    Value = util:rand(1, 1000),
    Return2 = case Value =< DropRate of
        true ->
            Value2 = util:rand(1, 1000),
            IsBind = case Value2 =< BindRate of
                true ->
                    1;
                false ->
                    0
            end,
            [{BaseId, Count, IsBind} | Return];
        false ->
            Return
    end,
    get_drop_items(T, Return2).

get_gains(Exp, Stone, Items) ->
    Gains = case Exp =:= 0 of
        true ->
            [];
        false ->
            [#gain{label = exp, val = Exp}]
    end,
    Gains1 = case Stone =:= 0 of
        true ->
            Gains;
        false ->
            [#gain{label = stone, val = Stone} | Gains]
    end,
    
    lists:foldl(fun({BaseId, Count, Bind}, Return) ->
                [#gain{label = item, val = [BaseId, Bind, Count]} | Return]
        end, Gains1, Items).

%%获得抗性加成
get_anti_attr(ConnPid, JailRole = #jail_role{floor = Floor, anti_stun = AntiStun, 
        anti_taunt = AntiTaunt, anti_sleep = AntiSleep, anti_stone = AntiStone}) ->
    if
        Floor =:= 10 andalso AntiSleep =:= 0 ->
            sys_conn:pack_send(ConnPid, 14813, {1}),
            JailRole#jail_role{anti_sleep = 200};
        Floor =:= 20 andalso AntiStone =:= 0 ->
            sys_conn:pack_send(ConnPid, 14813, {2}),
            JailRole#jail_role{anti_stone = 200};
        Floor =:= 30 andalso AntiTaunt =:= 0 ->
            sys_conn:pack_send(ConnPid, 14813, {3}),
            JailRole#jail_role{anti_taunt = 200};
        Floor =:= 40 andalso AntiStun =:= 0 ->
            sys_conn:pack_send(ConnPid, 14813, {4}),
            JailRole#jail_role{anti_stun = 200};
        true ->
            JailRole
    end.

%%-----------------------------------------
%% 地图相关
%%-----------------------------------------
create_map(Bosses) ->
    case map_mgr:create(?combat_map_id) of
        {false, Reason} ->
            ?ERR("创建雪山地牢战斗区域地图[MapBaseId=~w]失败: ~s", [?combat_map_id, Reason]),
            false;
        {ok, MapPid, MapId} ->
            Result = create_bosses(Bosses, 1, MapId, []),
            case Result of
                [_|_] ->
                    {ok, MapPid, MapId, Result};
                _ ->
                    %%创建失败
                    map:stop(MapPid),
                    false
            end
    end.

create_bosses([], _, _, Return) ->
    Return;
create_bosses([NpcBaseId | T], Index, MapId, Return) ->
    {ok, NpcBase} = npc_data:get(NpcBaseId),
    {X, Y} = get_enter_pos(Index),
    case npc_mgr:create(NpcBase, MapId, X, Y) of
        {ok, NpcId} -> 
            create_bosses(T, Index + 1, MapId, [NpcId | Return]);
        _Err ->
            ?ELOG("创建雪山地牢地图出错，无法建立地图NPC[NpcBaseId:~w, Reason:~w]", [NpcBaseId, _Err]),
            []
    end.

get_enter_pos(1) ->
    {?npc_x, ?combat_upper_pos_y};
get_enter_pos(2) ->
    {?npc_x + 110, ?combat_lower_pos_y};
get_enter_pos(3) ->
    {?npc_x + 220, ?combat_upper_pos_y};
get_enter_pos(_) ->
    get_enter_pos(1).

%% 记录匹配的地图信息，方便战斗结束时销毁地图进程
add_to_matched_map(Rid, MapId, MapPid) ->
    case get(matched_maps) of
        L = [_ | _] ->
            put(matched_maps, [{Rid, MapId, MapPid} | L]);
        _ ->
            put(matched_maps, [{Rid, MapId, MapPid}])
    end.

clear_matched_map(TargetRid) ->
    case get(matched_maps) of
        L = [_ | _] ->
            L2 = lists:filter(fun({Rid, _MapId, MapPid}) ->
                        case TargetRid =:= Rid of
                            true ->
                                map:stop(MapPid),
                                false;
                            false ->
                                true
                        end
                end, L),
            put(matched_maps, L2);
        _ ->
            ignore
    end.

save_jail_role(#jail_role{rid = {RoleId, SrvId}, floor = Floor, status = Status, life = Life, left_time = LeftTime,
        bosses = Bosses, last = Last, left_count = LeftCount, anti_stun = AntiStun, anti_taunt = AntiTaunt,
        anti_sleep = AntiSleep, anti_stone = AntiStone, best_floor = BestFloor}) ->
    Sql = "replace into sys_jail values(~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s)",
    case db:execute(Sql, [RoleId, SrvId, Floor, Status, Life, LeftTime, util:term_to_bitstring(Bosses),
                Last, LeftCount, AntiStun, AntiTaunt, AntiSleep, AntiStone, BestFloor]) of
        {error, Why} ->
            ?ERR("save_jail_role时发生异常: ~s", [Why]),
            false;
        {ok, _X} ->
            ok
    end.
