%%----------------------------------------------------
%% @doc 悬赏Boss管理进程
%%
%% @author mobin
%% @end
%%----------------------------------------------------
-module(wanted_mgr).

-behaviour(gen_fsm).

%%外部方法
-export([
        start_link/0,
        get_status/1,
        get_info/2,
        login/1,
        login_enter/2,
        enter/4,
        steal/4,
        combat_start/1,
        combat_over_leave/1,
        exit/3,
        is_can_play/1,
        is_wanted_role/1,
        set_left_time/1,
        gm_next/0,
        gm_clear/0,
        print_left_time/0,
        get_wanted_gains/3
    ]
).

%%状态
-export([
        idle/2,
        pirate1/2,
        wait1/2,
        pirate2/2,
        wait2/2
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("combat.hrl").
-include("role.hrl").
-include("link.hrl").
-include("wanted.hrl").
-include("wanted_config.hrl").
-include("wanted_lang.hrl").
-include("role_online.hrl").
-include("gain.hrl").
-include("unlock_lev.hrl").

-record(state, {
        begin_time,
        duration,
        boss_count = 0,
        %%玩家海盗数量
        role_count = 0,
        killed_count = 0,
        need_count = 0
    }
).


%%------------------------------------------------------
%% 外部方法
%%------------------------------------------------------
start_link()->
    gen_fsm:start_link({local, ?MODULE}, ?MODULE, [], []).

get_status(ConnPid) ->
    gen_fsm:send_all_state_event(?MODULE, {get_status, ConnPid}).

get_info(Rid, ConnPid) ->
    gen_fsm:send_event(?MODULE, {get_info, Rid, ConnPid}).

%% 登陆
login(Role = #role{event = ?event_wanted, status = ?status_die, hp_max = HpMax}) ->
    login(Role#role{status = ?status_normal, hp = HpMax});
login(Role = #role{id = Rid, lev = Lev, event = ?event_wanted}) ->
    is_can_play(Role),
    case ets:lookup(wanted_scene_info, Rid) of
        [{_, _, 1}]->
            %%战斗完掉线
            ets:delete(wanted_scene_info, Rid),
            {Exp, Coin, Stone} = case wanted_data:rewards(Lev) of
                undefined ->
                    {0, 0, 0};
                Rewards ->
                    Rewards
            end,

            Gains = get_wanted_gains(Exp, Coin, Stone),
            Role3 = case role_gain:do(Gains, Role) of
                {ok, Role2} ->
                    log:log(log_coin, {<<"悬赏boss奖励">>, <<"悬赏boss奖励">>, Role, Role2}),
                    log:log(log_stone, {<<"悬赏boss奖励">>, <<"悬赏boss奖励">>, Role, Role2}),
                    Role2;
                _ ->
                    award:send(Rid, ?join_award_id, Gains),
                    Role
            end,
            Role3#role{event = ?event_no};
        [{_, _, 0}]->
            Role;
        _ ->
            Role#role{event = ?event_no}
    end;
login(Role) ->
    is_can_play(Role),
    Role.

login_enter(RolePid, Rid) ->
    case ets:lookup(wanted_scene_info, Rid) of
        [{_, Pid, _}] when is_pid(Pid) ->
            Pid ! {login_enter, RolePid};
        _ ->
            ignore
    end,
    ok.

enter(Id, Rid, RolePid, ConnPid) ->
    gen_fsm:send_event(?MODULE, {enter, Id, Rid, RolePid, ConnPid}).

steal(Id, Rid, ConnPid, RolePid) ->
    gen_fsm:send_event(?MODULE, {steal, Id, Rid, ConnPid, RolePid}).

combat_start(Role = #role{id = Rid}) ->
    case ets:lookup(wanted_scene_info, Rid) of
        [{_, Pid, 0}] when is_pid(Pid) ->
            Pid ! {combat_start, Role};
        _ ->
            ignore
    end.

combat_over_leave(RoleFighter = #fighter{rid = RoleId, srv_id = SrvId}) ->
    case ets:lookup(wanted_scene_info, {RoleId, SrvId}) of
        [{_, Pid, _}] when is_pid(Pid) ->
            ets:insert(wanted_scene_info, {{RoleId, SrvId}, Pid, 1}),
            Pid ! {combat_over_leave, RoleFighter};
        _ ->
            ignore
    end.

exit(Rid, RolePid, Lev) ->
    case ets:lookup(wanted_scene_info, Rid) of
        [{_, Pid, _}] when is_pid(Pid) ->
            Pid ! {exit, Rid, RolePid, Lev};
        _ ->
            ignore
    end.

is_can_play(#role{id = Rid, lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    UnlockLev = ?wanted_unlock_lev,
    case Lev < UnlockLev of 
        true ->
            ignore;
        false ->
            gen_fsm:send_all_state_event(?MODULE, {is_can_play, Rid, ConnPid})
    end.

is_wanted_role(Rid) ->
    WantedRoles = ets:tab2list(wanted_role),
    WantedRoles2 = [WantedRole || WantedRole = #wanted_role{rid = TargetRid} <- WantedRoles, TargetRid =:= Rid],
    case WantedRoles2 of
        [] ->
            false;
        _ ->
            true
    end.

%% 设置Timeout时间
set_left_time(LeftTime) ->
    gen_fsm:sync_send_all_state_event(?MODULE, {set_left_time, LeftTime}).

gm_next() ->
    gen_fsm:send_all_state_event(?MODULE, {gm_next}).

gm_clear() ->
    wanted_dao:delete_last_wanted(),
    wanted_dao:delete_old_wanted_npc().

%% 打印空闲时间 
print_left_time() ->
    gen_fsm:sync_send_all_state_event(?MODULE, print_left_time).

get_wanted_gains(Exp, Coin, Stone) ->
    Gains = case Exp =:= 0 of
        true ->
            [];
        false ->
            [#gain{label = exp, val = Exp}]
    end,
    Gains1 = case Coin =:= 0 of
        true ->
            Gains;
        false ->
            [#gain{label = coin, val = Coin} | Gains]
    end,
    case Stone =:= 0 of
        true ->
            Gains1;
        false ->
            [#gain{label = item, val = [?stone_base_id, 1, Stone]} | Gains1]
    end.

%%------------------------------------------------------
%% 状态机消息处理
%%------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true), 

    %%[{rid, pid, is_combat_over}]
    ets:new(wanted_scene_info, [set, named_table, public, {keypos, 1}]),
    %%[Id, ...]
    ets:new(wanted_role_action, [set, named_table, public, {keypos, 1}]),
    ets:new(wanted_npc, [set, named_table, public, {keypos, #wanted_npc.id}]),
    ets:new(wanted_role, [set, named_table, public, {keypos, #wanted_role.id}]),

    {StateName, State} = case is_in_pirate1(?start_time_list) of
        false ->
            {BossCount, KilledCount, NeedCount} = get_wanted_info(),
            Duration = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
            {idle, #state{begin_time = erlang:now(), duration = Duration, boss_count = BossCount,
                    killed_count = KilledCount, need_count = NeedCount}};
        LeftTime ->
            {_StateName, _State} = change_to_pirate1(#state{}),
            {_StateName, _State#state{duration = LeftTime * 1000}}
    end,
    #state{begin_time = BeginTime, duration = Duration2} = State,

    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, StateName, State, util:time_left(Duration2, BeginTime)}.

handle_event({get_status, ConnPid}, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    Reply = case StateName of
        pirate1 ->
            {1, get_left_second(BeginTime, Duration)};
        pirate2 ->
            {3, get_left_second(BeginTime, Duration)};
        idle ->
            {5, get_left_second(BeginTime, Duration)};
        wait1 ->
            {2, get_left_second(BeginTime, Duration)};
        wait2 ->
            AliveLeftTime = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
            {4, AliveLeftTime div 1000}
    end,
    sys_conn:pack_send(ConnPid, 15005, Reply),
    continue(StateName, State);

handle_event({is_can_play, Rid, ConnPid}, StateName, State = #state{boss_count = BossCount, role_count = RoleCount}) ->
    Result = case StateName of
        pirate1 ->
            case ets:lookup(wanted_role_action, Rid) of
                [{Rid, ActionList}] ->
                    length(ActionList) < BossCount;
                _ ->
                    true
            end;
        pirate2 ->
            %%排除自己是海盗
            RoleCount2 = case is_wanted_role(Rid) of
                true ->
                    RoleCount - 1;
                false ->
                    RoleCount
            end,
            case RoleCount2 > 0 of
                false ->
                    false;
                true ->
                    case ets:lookup(wanted_role_action, Rid) of
                        [{Rid, ActionList}] ->
                            length(ActionList) < RoleCount2;
                        _ ->
                            true
                    end
            end;
        idle ->
            false;
        wait1 ->
            false;
        wait2 ->
            false
    end,
    Reply = case Result of
        true ->
            {?true};
        false ->
            {?false}
    end,
    sys_conn:pack_send(ConnPid, 15006, Reply),
    continue(StateName, State);

handle_event({gm_next}, _StateName, State = #state{boss_count = BossCount}) ->
    wanted_dao:save_wanted({erlang:min(BossCount + 1, 5), 0}),
    {StateName, State2} = change_to_pirate1(State),
    continue(StateName, State2);

handle_event(_Event, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效事件:~w", [StateName, _Event]),
    continue(StateName, State).

%% 设置Timeout时间
handle_sync_event({set_left_time, LeftTime}, _From, StateName, State) ->
    Duration = LeftTime * 1000,
    ?INFO("悬赏boss [~w] 时间更新成功:~w", [StateName, Duration]),
    continue(ok, StateName, State#state{begin_time = erlang:now(), duration = Duration});

%% 打印Timeout时间 
handle_sync_event(print_left_time, _From, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    TimeOut = util:time_left(Duration, BeginTime),
    ?INFO("悬赏boss状态~w的Timeout时间:~w", [StateName, TimeOut / 1000 / 3600]),
    continue(ok, StateName, State);

handle_sync_event(_Event, _From, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效事件:~w", [StateName, _Event]),
    continue(ignore, StateName, State).

handle_info(create_wanted_role, StateName, State = #state{boss_count = BossCount, role_count = RoleCount}) ->
    create_wanted_role(BossCount, RoleCount),
    continue(StateName, State);

handle_info(save_db, StateName, State = #state{boss_count = BossCount, killed_count = KilledCount, need_count = NeedCount}) ->
    %%表明没有下一待开放的海盗
    case NeedCount =:= 0 of
        true ->
            ignore;
        false ->
            Wanted = case KilledCount =:= NeedCount of
                true ->
                    {BossCount + 1, 0};
                false ->
                    {BossCount, KilledCount}
            end,
            wanted_dao:save_wanted(Wanted)
    end,
    
    %%把上次所有npc海盗删除
    wanted_dao:delete_old_wanted_npc(),
    %%保存没被缉拿的NPC海盗，统计玩家海盗数
    RoleCount = lists:foldl(fun(WantedNpc = #wanted_npc{killed_count = NpcKilledCount}, Count) ->
                case NpcKilledCount =:= 0 of
                    true ->
                        wanted_dao:save_wanted_npc(WantedNpc),
                        Count;
                    false ->
                        Count + 1
                end
        end, 0, ets:tab2list(wanted_npc)),

    erlang:send_after(10000, self(), create_wanted_role),
    continue(StateName, State#state{role_count = RoleCount});

handle_info(add_kill_count, StateName, State = #state{killed_count = KilledCount, need_count = NeedCount}) ->
    KilledCount2 = erlang:min(NeedCount, KilledCount + 1),
    State2 = State#state{killed_count = KilledCount2},
    continue(StateName, State2);

handle_info(_Info, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效消息:~w", [StateName, _Info]),
    continue(StateName, State).

terminate(_Reason, _StateName, _State) ->
    ok.
    
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------
%% 空闲时间
idle({get_info, _Rid, ConnPid}, State = #state{boss_count = BossCount, killed_count = KilledCount,
        need_count = NeedCount, begin_time = BeginTime, duration = Duration}) ->
    % LeftTime = get_left_second(BeginTime, Duration),
    EndTime = get_end_second(BeginTime, Duration div 1000),
    sys_conn:pack_send(ConnPid, 15014, {BossCount, KilledCount, NeedCount, EndTime}),
    continue(idle, State);
idle(timeout, State) ->
    {StateName, State2} = change_to_pirate1(State),
    continue(StateName, State2);
idle(_Any, State) ->
    continue(idle, State).

%% NPC海盗时间
pirate1({get_info, Rid, ConnPid}, State = #state{boss_count = BossCount, killed_count = KilledCount,
        need_count = NeedCount, begin_time = BeginTime, duration = Duration}) ->
    % LeftTime = get_left_second(BeginTime, Duration),
    EndTime = get_end_second(BeginTime, Duration div 1000),
    WantedNpcs = get_wanted_npcs(BossCount),
    WantedNpcs2 = case ets:lookup(wanted_role_action, Rid) of
        [{Rid, ActionList}] ->
            steal_or_done(WantedNpcs, ActionList);
        _ ->
            WantedNpcs
    end,
    sys_conn:pack_send(ConnPid, 15010, {BossCount, KilledCount, NeedCount, EndTime, WantedNpcs2}),
    continue(pirate1, State);
pirate1({enter, Id, Rid, RolePid, _}, State) ->
    case get({wanted_npc, Id}) of
        Pid when is_pid(Pid) ->
            Pid ! {enter, Id, Rid, RolePid};
        _ ->
            ignore
    end,
    continue(pirate1, State);
pirate1({steal, Id, Rid, ConnPid, RolePid}, State) ->
    case get({wanted_npc, Id}) of
        Pid when is_pid(Pid) ->
            Pid ! {steal, Id, Rid, ConnPid, RolePid};
        _ ->
            ignore
    end,
    continue(pirate1, State);
pirate1(timeout, State = #state{boss_count = BossCount}) ->
    force_combat_over(),
    wanted_npc_timeout(BossCount),
    
    erlang:send_after(30000, self(), save_db),

    %%推送状态
    broadcast_15006(?false),
    State2 = State#state{begin_time = erlang:now(), duration = min_to_millisec(?wait1_timer)},
    continue(wait1, State2);
pirate1(_Any, State) ->
    continue(pirate1, State).

%% NPC海盗空档时间
wait1({get_info, _Rid, ConnPid}, State = #state{boss_count = BossCount, killed_count = KilledCount,
        need_count = NeedCount, begin_time = BeginTime, duration = Duration}) ->
    % LeftTime = get_left_second(BeginTime, Duration),
    EndTime = get_end_second(BeginTime, Duration div 1000),
    AliveLeftTime = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
    AliveLeftTime2 = AliveLeftTime div 1000,
    WantedNpcs = get_wanted_npcs(BossCount),
    sys_conn:pack_send(ConnPid, 15011, {BossCount, KilledCount, NeedCount, EndTime, AliveLeftTime2, WantedNpcs}),
    continue(wait1, State);
wait1(timeout, State) ->
    ets:delete_all_objects(wanted_role_action),
    State2 = State#state{begin_time = erlang:now(), duration = min_to_millisec(?pirate2_timer)},

    RoleNames = lists:map(fun(#wanted_role{rid = Rid, name = Name}) ->
                Binary = notice:get_role_msg(Name, Rid),
                binary_to_list(Binary)
        end, ets:tab2list(wanted_role)),
    case length(RoleNames) > 0 of
        true ->
            %%推送状态
            broadcast_15006(?true),
            %%传闻
            Msg = util:fbin(?wanted_role_start, [string:join(RoleNames, "、"), notice_color:get_color_item(5)]),
            role_group:pack_cast(world, 10932, {7, 1, Msg});
        false ->
            ignore
    end,
    continue(pirate2, State2);
wait1(_Any, State) ->
    continue(wait1, State).

%% 玩家海盗时间
pirate2({get_info, Rid, ConnPid}, State = #state{boss_count = BossCount, killed_count = KilledCount,
        need_count = NeedCount, begin_time = BeginTime, duration = Duration}) ->
    %LeftTime = get_left_second(BeginTime, Duration),
    EndTime = get_end_second(BeginTime, Duration div 1000),
    AliveLeftTime = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
    AliveLeftTime2 = AliveLeftTime div 1000,

    WantedRoles = get_wanted_roles(BossCount),
    WantedRoles2 = case ets:lookup(wanted_role_action, Rid) of
        [{Rid, ActionList}] ->
            steal_or_done2(WantedRoles, ActionList);
        _ ->
            WantedRoles
    end,
    sys_conn:pack_send(ConnPid, 15012, {BossCount, KilledCount, NeedCount, EndTime, AliveLeftTime2, WantedRoles2}),
    continue(pirate2, State);
pirate2({enter, Id, Rid, RolePid, ConnPid}, State) ->
    case get({wanted_role, Id}) of
        Pid when is_pid(Pid) ->
            Pid ! {enter, Id, Rid, RolePid, ConnPid};
        _ ->
            ignore
    end,
    continue(pirate2, State);
pirate2({steal, Id, Rid, ConnPid, RolePid}, State) ->
    case get({wanted_role, Id}) of
        Pid when is_pid(Pid) ->
            Pid ! {steal, Id, Rid, ConnPid, RolePid};
        _ ->
            ignore
    end,
    continue(pirate2, State);
pirate2(timeout, State = #state{boss_count = BossCount}) ->
    force_combat_over(),
    wanted_role_timeout(BossCount),

    %%wait2 的超时时间要先算end_time,再算start_time
    Duration = get_duration(?end_time),
    Duration2 = case Duration of
        0 ->
            %%标志下一阶段是空闲期
            put(is_final, false),
            get_start_duration(?start_time_list, lists:nth(1, ?start_time_list));
        _ ->
            put(is_final, true),
            Duration
    end,
    %%推送状态
    broadcast_15006(?false),

    State2 = State#state{begin_time = erlang:now(), duration = Duration2},
    continue(wait2, State2);
pirate2(_Any, State) ->
    continue(pirate2, State).

%% 玩家海盗空档时间
wait2({get_info, _Rid, ConnPid}, State = #state{boss_count = BossCount, killed_count = KilledCount,
        need_count = NeedCount, begin_time = BeginTime, duration = Duration}) ->
    %LeftTime = get_left_second(BeginTime, Duration),
    EndTime = get_end_second(BeginTime, Duration div 1000),
    AliveLeftTime = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
    AliveLeftTime2 = AliveLeftTime div 1000,
    WantedRoles = get_wanted_roles(BossCount),
    sys_conn:pack_send(ConnPid, 15013, {BossCount, KilledCount, NeedCount, EndTime, AliveLeftTime2, WantedRoles}),
    continue(wait2, State);
wait2(timeout, State) ->
    ets:delete_all_objects(wanted_role_action),
    case get(is_final) of
        true ->
            Duration = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
            State2 = State#state{begin_time = erlang:now(), duration = Duration},
            continue(idle, State2);
        _ ->
            {StateName, State2} = change_to_pirate1(State),
            continue(StateName, State2)
    end;
wait2(_Any, State) ->
    continue(wait2, State).

%%------------------------------------------------------
%% 内部方法
%%------------------------------------------------------
continue(Reply, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {reply, Reply, StateName, State, util:time_left(Duration, BeginTime)}.
continue(StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {next_state, StateName, State, util:time_left(Duration, BeginTime)}.

get_start_duration([], FirstTime) ->
    get_tomorrow_duration(FirstTime);
get_start_duration([H | T], FirstTime) ->
    case get_duration(H) of
        0 ->
            get_start_duration(T, FirstTime);
        Duration ->
            Duration
    end.

%%在时间点内则返回还剩下多少秒
is_in_pirate1([]) ->
    false;
is_in_pirate1([{Hour, Min, Sec} | T]) ->
    Now = util:unixtime(),

    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    EndTime = Today + Time + ?pirate1_timer * 60,
    case Now >= (Today + Time) andalso Now =< EndTime - 5 * 60 of
        true -> 
            EndTime - Now;
        false ->
            is_in_pirate1(T)
    end.

%%获取距离下一次活动的剩余时间，错过了则返回0
get_duration({Hour, Min, Sec}) ->
    Now = util:unixtime(),

    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    Duration = case (Today + Time) > Now of
        true -> 
            Today + Time - Now;
        false ->
            0
    end,
    Duration * 1000.

get_tomorrow_duration({Hour, Min, Sec}) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({tomorrow, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,

    Duration = Tomorrow + Time - Now,
    Duration * 1000.

get_left_second(BeginTime, Duration) ->
    LeftTime = util:time_left(Duration, BeginTime),
    LeftTime div 1000.

get_end_second(BeginTime, Duration) ->
    {_Date, Time} = calendar:now_to_local_time(BeginTime),
    calendar:time_to_seconds(Time) + Duration.

min_to_millisec(Minute) ->
    Minute * 60 * 1000.

broadcast_15006(Result) ->
    lists:foreach(fun(#role_online{pid = Pid, lev = Lev}) ->
                UnlockLev = ?wanted_unlock_lev,
                case Lev < UnlockLev of 
                    true ->
                        ignore;
                    false ->
                        role:pack_send(Pid, 15006, {Result})
                end
        end, ets:tab2list(role_online)).

load_new_wanted_npc(0, WantedNpcs) ->
    WantedNpcs;
load_new_wanted_npc(Count, WantedNpcs) ->
    case lists:keyfind(Count, #wanted_npc.id, WantedNpcs) of
        false ->
            case wanted_data:wanted_npc(Count) of
                undefined ->
                    load_new_wanted_npc(Count - 1, WantedNpcs);
                WantedNpc ->
                    load_new_wanted_npc(Count - 1, [WantedNpc | WantedNpcs])
            end;    
        _ ->
            load_new_wanted_npc(Count - 1, WantedNpcs)
    end.

steal_or_done(WantedNpcs, ActionList) ->
    steal_or_done(WantedNpcs, ActionList, []).
steal_or_done([], _, Return) ->
    lists:reverse(Return);
steal_or_done([WantedNpc = #wanted_npc{id = Id} | T], ActionList, Return) ->
    Status = case lists:member(Id, ActionList) of
        true ->
            ?done;
        false ->
            ?steal
    end,
    steal_or_done(T, ActionList, [WantedNpc#wanted_npc{status = Status} | Return]).

steal_or_done2(WantedRoles, ActionList) ->
    steal_or_done2(WantedRoles, ActionList, []).
steal_or_done2([], _, Return) ->
    lists:reverse(Return);
steal_or_done2([WantedRole = #wanted_role{id = Id} | T], ActionList, Return) ->
    Status = case lists:member(Id, ActionList) of
        true ->
            ?done;
        false ->
            ?steal
    end,
    steal_or_done2(T, ActionList, [WantedRole#wanted_role{status = Status} | Return]).

wanted_npc_timeout(0) ->
    ok;
wanted_npc_timeout(Count) ->
    case get({wanted_npc, Count}) of
        Pid when is_pid(Pid) ->
            erlang:send_after(4000, Pid, timeout);
        _ ->
            ignore
    end,
    wanted_npc_timeout(Count - 1).

wanted_role_timeout(0) ->
    ok;
wanted_role_timeout(Count) ->
    case get({wanted_role, Count}) of
        Pid when is_pid(Pid) ->
            erlang:send_after(4000, Pid, timeout);
        _ ->
            ignore
    end,
    wanted_role_timeout(Count - 1).

create_wanted_role(0, _) ->
    ok;
create_wanted_role(Count, RoleCount) ->
    case get({wanted_npc, Count}) of
        Pid when is_pid(Pid) ->
            case wanted_npc:create_wanted_role(Pid, RoleCount) of
                {ok, Pid2} ->
                    put({wanted_role, Count}, Pid2);
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end,
    create_wanted_role(Count - 1, RoleCount).

get_wanted_npcs(Count) ->
    get_wanted_npcs(Count, []). 
get_wanted_npcs(0, Return) ->
    Return;
get_wanted_npcs(Count, Return) ->
    [WantedNpc = #wanted_npc{origin_coin = OriginCoin, origin_stone = OriginStone,
            kill_count = KillCount}] = ets:lookup(wanted_npc, Count),
    #wanted_assets{coin_index = CoinIndex, coin_factor = CoinFactor,
        stone_index = StoneIndex, stone_factor = StoneFactor} = wanted_data:npc_assets(Count),

    %%修改客户端显示杀人数
    #wanted_npc{kill_count_index = KillCountIndex, kill_count_factor = KillCountFactor} = wanted_data:wanted_npc(Count),
    KillCount2 = util:floor(math:pow(KillCount, KillCountIndex) * KillCountFactor),

    WantedNpc2 = WantedNpc#wanted_npc{coin = OriginCoin + util:floor(math:pow(KillCount, CoinIndex) * CoinFactor),
        stone = OriginStone + util:floor(math:pow(KillCount, StoneIndex) * StoneFactor),
        kill_count = KillCount2},
    get_wanted_npcs(Count - 1, [WantedNpc2 | Return]).


get_wanted_roles(Count) ->
    get_wanted_roles(Count, []). 
get_wanted_roles(0, Return) ->
    Return;
get_wanted_roles(Count, Return) ->
    case ets:lookup(wanted_role, Count) of
        [WantedRole = #wanted_role{origin_coin = OriginCoin, origin_stone = OriginStone,
                kill_count = KillCount}] ->
            #wanted_assets{coin_index = CoinIndex, coin_factor = CoinFactor,
                stone_index = StoneIndex, stone_factor = StoneFactor} = wanted_data:role_assets(Count),

            %%修改客户端显示杀人数
            #wanted_role{kill_count_index = KillCountIndex, kill_count_factor = KillCountFactor} = wanted_data:wanted_role(Count),
            KillCount2 = util:floor(math:pow(KillCount, KillCountIndex) * KillCountFactor),

            WantedRole2 = WantedRole#wanted_role{coin = OriginCoin + util:floor(math:pow(KillCount, CoinIndex) * CoinFactor),
                stone = OriginStone + util:floor(math:pow(KillCount, StoneIndex) * StoneFactor),
                kill_count = KillCount2},
            get_wanted_roles(Count - 1, [WantedRole2 | Return]);
        _ ->
            get_wanted_roles(Count - 1, Return)
    end.

get_wanted_info() ->
    {BossCount, KilledCount} = wanted_dao:load_last_wanted(),
    NeedCounts = wanted_data:need_counts(),
    {KilledCount2, NeedCount} = case BossCount > length(NeedCounts) of
        true ->
            {0, 0};
        false ->
            {KilledCount, lists:nth(BossCount, NeedCounts)}
    end,
    {BossCount, KilledCount2, NeedCount}.
%    {10, 0, 0}.

force_combat_over() ->
    RoleScenes = ets:tab2list(wanted_scene_info),
    lists:foreach(fun({Rid, Pid, _}) ->
                case role_api:lookup(by_id, Rid, [#role.combat_pid, #role.pid, #role.lev]) of
                    {ok, _, [CombatPid, RolePid, Lev]} when is_pid(CombatPid) ->
                        CombatPid ! stop,
                        erlang:send_after(2000, Pid, {exit, Rid, RolePid, Lev});
                    %%在场景不战斗不出来
                    {ok, _, [_, RolePid, Lev]} ->
                        Pid ! {exit, Rid, RolePid, Lev};
                    %%掉线情况
                    _ -> 
                        ets:delete(wanted_scene_info, Rid)
                end
        end, RoleScenes).

create_wanted_npc(0, _BossCount) ->
    ok;
create_wanted_npc(Count, BossCount) ->
    case wanted_npc:start_link(Count, BossCount) of
        {ok, Pid} ->
            put({wanted_npc, Count}, Pid),
            create_wanted_npc(Count - 1, BossCount);
        _Err -> 
            ?ELOG("创建Npc海盗[Id=~w]失败:~w", [Count, _Err]),
            Count
    end.

%% 加载npc海盗
change_to_pirate1(State) ->
    %%清理
    ets:delete_all_objects(wanted_npc),
    ets:delete_all_objects(wanted_role),
    erase(),

    {BossCount, KilledCount, NeedCount} = get_wanted_info(),
    case create_wanted_npc(BossCount, BossCount) of
        ok ->
            WantedNpcs = wanted_dao:load_all_wanted_npc(),
            WantedNpcs2 = load_new_wanted_npc(BossCount, WantedNpcs),
            lists:foreach(fun(WantedNpc) -> ets:insert(wanted_npc, WantedNpc) end, WantedNpcs2),

            State2 = State#state{begin_time = erlang:now(), duration = min_to_millisec(?pirate1_timer),
                boss_count = BossCount, killed_count = KilledCount, need_count = NeedCount, role_count = 0},

            %%传闻
            Msg = util:fbin(?wanted_npc_start, [notice_color:get_color_item(5)]),
            role_group:pack_cast(world, 10932, {7, 1, Msg}),
            %%推送状态
            broadcast_15006(?true),

            {pirate1, State2};
        Count ->
            %%失败情况
            lists:foreach(fun(Id) ->
                        Pid = get({wanted_npc, Id}),
                        Pid ! stop
                end, lists:seq(Count + 1, BossCount)),

            Duration = get_start_duration(?start_time_list, lists:nth(1, ?start_time_list)),
            State2 = State#state{begin_time = erlang:now(), duration = Duration, boss_count = BossCount,
                killed_count = KilledCount, need_count = NeedCount, role_count = 0},
            {idle, State2}
    end.
