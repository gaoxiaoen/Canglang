%%----------------------------------------------------
%%  帮会副本 (塔防进程)
%% @author shawn 
%%----------------------------------------------------

-module(guild_td).
-behaviour(gen_fsm).

-include("common.hrl").
-include("guild_td.hrl").
-include("guild.hrl").
-include("role.hrl").
-include("npc.hrl").
-include("pos.hrl").
-include("mail.hrl").
-include("attr.hrl").
-include("combat.hrl").
%%

-export([
        active/2 %%副本运行中
        ,idel/2 %%空闲状态
        ,pre_start/2 %% 副本准备开始中
        ,pre_stop/2 %% 副本清理中
    ]
).

-export([
        start/2
        ,login/2 %%副本里面上线
        ,enter/2 %%进入副本
        ,logout/2 %%副本里面下线
        ,leave/2 %%退出副本
        ,get_enter_point/1 %% 查询副本进入点
        ,get_guild_status/1 %% 查询战场信息
        ,get_role_point/1 %% 获取玩家积分列表
        ,pack_14907/2 %% 发送14907协议
        ,get_state/1
        ,combat/2
        ,pack_14909/2
    ]
).


-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(RESULT_COMPLETE, 2).
-define(RESULT_EMPTY_HP, 1).
-define(RESULT_TIME_OUT, 0).

%% 开启新的塔防
start(Guild, GuildBase) ->
    D = to_guild_td(Guild, GuildBase),
    case catch gen_fsm:start_link(?MODULE, [D], []) of
        {ok, TdPid} ->
            {ok, TdPid};
        _Err ->
            ?DEBUG("开启帮会副本异常:~w",[_Err]),
            {false, ?L(<<"开启帮会降魔除妖异常">>)}
    end.

%% ---对外接口------------

to_guild_td(#guild{pid = Pid, id = Id, name = Name, lev = Lev}, GuildBase) ->
    GuildBase#guild_td{guild_id = Id, guild_pid = Pid, guild_lev = Lev, guild_name = Name}.

to_login_role(#role{id = Id, pid = Pid, name = Name, lev = Lev, guild = #role_guild{position = Position}}) ->
    #role_td{id = Id, pid = Pid, name = Name, lev = Lev, position = Position}.

to_guild_role(#role{id = Id, pid = Pid, name = Name, lev = Lev, attr = #attr{fight_capacity = Fight}, guild = #role_guild{position = Position}}) ->
    #role_td{id = Id, pid = Pid, name = Name, lev = Lev, fight = Fight, position = Position}.

%% 获取副本进入点
get_enter_point(TdPid) ->
    gen_fsm:sync_send_all_state_event(TdPid, get_enter_point).

%% 获取战场信息
get_guild_status(TdPid) ->
    gen_fsm:sync_send_all_state_event(TdPid, get_guild_status).

%% 获取战场状态
get_state(TdPid) ->
    gen_fsm:sync_send_all_state_event(TdPid, get_state).

%% 创建副本相关地图
create_map() ->
    case map_mgr:create(?GUILD_TD_MAP_ID) of
        {false, Reason} ->
            ?ERR("帮会副本创建地图失败: ~s", [Reason]),
            false;
        {ok, MapPid, MapId} -> {MapPid, MapId} 
    end.

combat(combat_over, {Referees, Winner, Loser}) ->
    reappear_npc(Referees, Winner),
    L =[{Lrid, LsrvId, LIsDie, Lpid} || #fighter{pid = Lpid, rid = Lrid, srv_id = LsrvId, is_die = LIsDie, type = ?fighter_type_role} <- Loser],
    enter_map(get_pid_list(L, [])).

%% 发放奖励
send_mail(#guild_td{enter_role = EnterRole, td_lev = TdLev}) ->
    send_mail(EnterRole, TdLev).

send_mail([], _TdLev) -> ok;
send_mail([#role_td{kill_npc = 0, kill_boss = 0} | T], TdLev) ->
    send_mail(T, TdLev);
send_mail([Role = #role_td{id = Id, lev = Lev} | T], TdLev) ->
    {Msg, Award, Point} = to_msg(Role, TdLev),
    ItemList = to_items(guild_td_data:award(guild_td_data:get_award(Point, Lev)), []),
    case mail:send_system(Id,
            {?L(<<"帮会降妖奖励">>), Msg, Award, ItemList}) of
        ok -> ok;
        {false, _R} ->
            ?ERR("帮会副本奖励发送邮件失败:id:~p 原因:~p",[Id, _R]),
            false 
    end,
    campaign_listener:handle(guild_td_score, Role, Point),
    send_mail(T, TdLev).

to_msg(#role_td{lev = Lev, kill_npc = A, kill_boss = B}, TdLev) ->
    Point = 3 * A + 10 * B,
    Exp = erlang:round(guild_td_data:get_add(TdLev) * math:pow(Point, 0.8) * math:pow(Lev, 1.5)),
    Gpoint = Point,
    Msg = util:fbin(?L(<<"本次帮会降妖已经结束，通过大家同心协力，守卫至~w波妖魔的侵袭，您在本次副本中表现优异，获得~w积分。 折算成\n 经验:~w，帮贡:~w\n并为帮会带来~w帮会资金的收益！">>), [TdLev, Point, Exp, Gpoint, Gpoint]),
    {Msg, [{?mail_exp, Exp}, {?mail_guild_devote, Gpoint}], Point}.

to_items([], ItemList) -> ItemList;
to_items([{BaseId, Num} | T], ItemList) ->
    case item:make(BaseId, 1, Num) of
        false -> to_items(T, ItemList);
        {ok, Items} ->
            to_items(T, Items ++ ItemList)
    end.

%% 结束清理
clean(#guild_td{online_role = OnlineRole, map_pid = MapPid}) ->
    %% 终止所有战斗
    clean_combat(OnlineRole),
    %% 清理副本剩余NPC
    clean_npc(MapPid).

%% 清除剩余NPC离场
clean_npc(MapPid) ->
    ?DEBUG("清理剩余NPC离场"),
    MapPid ! {clear_npc}.

clean_combat([]) -> ok;
clean_combat([#role_td{pid = Rpid} | T]) ->
    case role_api:lookup(by_pid, Rpid, #role.combat_pid) of 
        {ok, _, ComPid} when is_pid(ComPid) ->
            ComPid ! stop,
            clean_combat(T);
        _ -> clean_combat(T)
    end.

clean_role(R, []) -> R;
clean_role(R, [R1 = #role_td{pid = Rpid} | T]) ->
    case is_pid(Rpid) of
        true ->
            role:apply(async, Rpid, {fun async_leave/4, [?GUILD_TD_EXIT_MAP_ID, ?GUILD_TD_EXIT_X, ?GUILD_TD_EXIT_Y]}),
            clean_role(R, T);
        false ->
            clean_role([R1 | R], T)
    end.


async_leave(Role, MapId, X, Y) ->
    case map:role_enter(MapId, X, Y, Role#role{event = ?event_no}) of
        {false, _Reason} -> {ok};
        {ok, NewRole} ->
            {ok, NewRole}
    end.

%%clean_role(R, [], _) -> R;
%%clean_role(R, [R1 = #role_td{pid = Rpid} | T], {_Mid, _X, _Y}) ->
%%    case is_pid(Rpid) of
%%        true -> 
%%            role:apply(async, Rpid, {fun async_leave/4, [Mid, X, Y]}),
%%            clean_role(R, T, {Mid, X, Y});
%%        false -> clean_role([R1 | R], T, {Mid, X, Y})
%%    end.

%%async_leave(Role, Mid, X, Y) -> 
%%    NewRole = Role#role{event = ?event_no},
%%    case guild_area:enter(normal, NewRole) of
%%        {ok, Nr} -> {ok, Nr};
%%        {ok} -> {ok, NewRole};
%%        {false, _} ->
%%            case map:role_enter(Mid, X, Y, NewRole) of
%%                {false, _Reason} ->
%%                    ?ELOG("角色退出副本进入洛水城失败:~w",[_Reason]),
%%                    {ok};
%%                {ok, NewRole2} -> {ok, NewRole2#role{event_pid = 0}}
%%            end;
%%        _Reason -> 
%%            ?ELOG("角色进入帮会领地失败:~w",[_Reason]),
%%            {ok}
%%    end.

%% 计算个人得分
calc_role_result([], _Type, OnlineRole, EnterRole, _StartLev) -> {OnlineRole, EnterRole};
calc_role_result([Id | T], 1, OnlineRole, EnterRole, StartLev) ->
    case lists:keyfind(Id, #role_td.id, EnterRole) of
        false -> calc_role_result(T, 1, OnlineRole, EnterRole, StartLev);
        TdRole = #role_td{kill_boss = KillBoss, kill_npc = KillNpc} ->
            NewEnter = lists:keyreplace(Id, #role_td.id, EnterRole, TdRole#role_td{kill_boss = KillBoss + 1}),
            Factor =  1,
            rank_celebrity:listener(guild_dungeon_score, Id, erlang:trunc((3 * KillNpc + (KillBoss + 1) * 10) * Factor)), %% 帮会副本降妖积分
            NewOnline = case lists:keyfind(Id, #role_td.id, OnlineRole) of
                false -> [TdRole#role_td{kill_boss = KillBoss + 1} | OnlineRole];
                _T -> lists:keyreplace(Id, #role_td.id, OnlineRole, TdRole#role_td{kill_boss = KillBoss + 1})
            end,
            calc_role_result(T, 1, NewOnline, NewEnter, StartLev)
    end;
calc_role_result([Id | T], 0, OnlineRole, EnterRole, StartLev) ->
    case lists:keyfind(Id, #role_td.id, EnterRole) of
        false -> calc_role_result(T, 0, OnlineRole, EnterRole, StartLev);
        TdRole = #role_td{kill_npc = KillNpc, kill_boss = KillBoss} ->
            NewEnter = lists:keyreplace(Id, #role_td.id, EnterRole, TdRole#role_td{kill_npc = KillNpc + 1}),
            Factor =  1,
            rank_celebrity:listener(guild_dungeon_score, Id, erlang:trunc((3 * (KillNpc + 1) + KillBoss * 10) * Factor)), %% 帮会副本降妖积分
            NewOnline = case lists:keyfind(Id, #role_td.id, OnlineRole) of
                false -> [TdRole#role_td{kill_npc = KillNpc + 1} | OnlineRole];
                _T -> lists:keyreplace(Id, #role_td.id, OnlineRole, TdRole#role_td{kill_npc = KillNpc + 1})
            end,
            calc_role_result(T, 0, NewOnline, NewEnter, StartLev)
    end.

%% 退出副本
leave(Pid, Role = #role{}) ->
    leave(Pid, to_guild_role(Role));
leave(Pid, GuildRole = #role_td{}) when is_pid(Pid) ->
    Pid ! {leave, GuildRole};
leave(_Pid, _GuildRole) ->
    ?ERR("角色退出帮会副本发生异常: ~w, ~w", [_Pid, _GuildRole]),
    ok.

%% 角色上线处理
login(TdPid, Role = #role{}) ->
    login(TdPid, to_login_role(Role));
login(TdPid, GuildRole = #role_td{}) when is_pid(TdPid) ->
    TdPid ! {login, GuildRole};
login(_TdPid, _Rid) ->
    ok.

%% 进入副本
enter(TdPid, Role = #role{}) ->
    do_enter(TdPid, to_guild_role(Role)).

do_enter(TdPid, GuildRole = #role_td{}) when is_pid(TdPid) ->
    TdPid ! {enter, GuildRole};
do_enter(_, _) -> ok.

%% 角色下线通知
logout(TdPid, Role = #role{}) ->
    do_logout(TdPid, to_guild_role(Role)).

do_logout(TdPid, GuildRole = #role_td{}) when is_pid(TdPid) ->
    TdPid ! {logout, GuildRole};
do_logout(_, _) ->
    ok.

enter_map([]) -> ok;
enter_map([Pid | T]) when is_pid(Pid) ->
    role:apply(async, Pid, {fun do_enter_map/1, []}),
    enter_map(T).

do_enter_map(Role = #role{pos = #pos{map = MapId}}) ->
    case map:role_enter(MapId, ?GUILD_TD_DEFAULT_X, ?GUILD_TD_DEFAULT_Y, Role#role{status = ?status_normal}) of
        {false, Reason} -> {false, Reason};
        {ok, Nr}-> {ok, Nr}
    end.

get_pid_list([], Pids) -> Pids;
get_pid_list([{_Rid, _SrvId, ?true, Pid} | T], Pids) ->
    get_pid_list(T, [Pid | Pids]);
get_pid_list([_ | T], Pids) -> get_pid_list(T, Pids).

%% ----服务器内部实现--------
init([Td]) ->
    ?DEBUG("创建帮会副本进程"),
    process_flag(trap_exit, true),
    case create_map() of
        false -> {stop, create_maps_failure};
        {MapPid, MapId} ->
            NewState = Td#guild_td{map_pid = MapPid, map_id = MapId, ts = now()},
            guild_td_mgr:guild_td_start(self(), MapId, NewState#guild_td.guild_id),
            self() ! {notice, 2},
            {ok, pre_start, NewState, ?GUILD_TD_TIME_PRE_START}
    end.

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%% 获取战场信息 
handle_sync_event(get_guild_status, _From, pre_start, State = #guild_td{ts = Ts}) -> 
    {reply, {?GUILD_TD_STATE_READY, State}, pre_start, State, util:time_left(?GUILD_TD_TIME_PRE_START, Ts)}; 
handle_sync_event(get_guild_status, _From, pre_stop, State = #guild_td{ts = Ts}) -> 
    {reply, {?GUILD_TD_STATE_READY, State}, pre_stop, State, util:time_left(?GUILD_TD_TIME_PRE_STOP, Ts)}; 
handle_sync_event(get_guild_status, _From, idel, State = #guild_td{ts = Ts}) -> 
    {reply, {?GUILD_TD_STATE_RUN, State}, idel, State, util:time_left(?GUILD_TD_TIME_IDEL, Ts)}; 
handle_sync_event(get_guild_status, _From, StateName, State) -> 
    {reply, {?GUILD_TD_STATE_RUN, State}, StateName, State}; 

%% 获取战场状态
handle_sync_event(get_state, _From, pre_start, State = #guild_td{ts = Ts}) -> 
    {reply, pre_start, pre_start, State, util:time_left(?GUILD_TD_TIME_PRE_START, Ts)}; 
handle_sync_event(get_state, _From, pre_stop, State = #guild_td{ts = Ts}) -> 
    {reply, pre_stop, pre_stop, State, util:time_left(?GUILD_TD_TIME_PRE_STOP, Ts)}; 
handle_sync_event(get_state, _From, idel, State = #guild_td{ts = Ts}) -> 
    {reply, idel, idel, State, util:time_left(?GUILD_TD_TIME_IDEL, Ts)}; 
handle_sync_event(get_state, _From, StateName, State) -> 
    {reply, StateName, StateName, State}; 

%% 准备期
handle_sync_event({get_enter_point}, _From, pre_start, State = #guild_td{ts = Ts, map_id = MapId}) -> 
    Reply = {MapId, ?GUILD_TD_DEFAULT_X, ?GUILD_TD_DEFAULT_Y}, 
    {reply, Reply, pre_start, State, util:time_left(?GUILD_TD_TIME_PRE_START, Ts)}; 
handle_sync_event({get_enter_point}, _From, pre_stop, State = #guild_td{ts = Ts, map_id = MapId}) -> 
    Reply = {MapId, ?GUILD_TD_DEFAULT_X, ?GUILD_TD_DEFAULT_Y}, 
    {reply, Reply, pre_stop, State, util:time_left(?GUILD_TD_TIME_PRE_STOP, Ts)}; 
handle_sync_event({get_enter_point}, _From, idel, State = #guild_td{ts = Ts, map_id = MapId}) -> 
    Reply = {MapId, ?GUILD_TD_DEFAULT_X, ?GUILD_TD_DEFAULT_Y}, 
    {reply, Reply, idel, State, util:time_left(?GUILD_TD_TIME_IDEL, Ts)}; 

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%% 预告
handle_info({notice, 0}, StateName, State = #guild_td{guild_pid = Pid}) ->
    guild:guild_chat(Pid, ?L(<<"帮会降妖将会在1分钟后开启，请全部帮会成员进入结界，准备进行降妖除魔！{handle, 10, 点击进入副本, FFFF66}">>)),
    continue(StateName, State);

handle_info({notice, Num}, StateName, State = #guild_td{guild_pid = Pid}) ->
    guild:guild_chat(Pid, util:fbin(?L(<<"帮会降妖将会在~w分钟后开启，请全部帮会成员进入结界，准备进行降妖除魔！{handle, 10, 点击进入副本, FFFF66}">>), [Num + 1])),
    erlang:send_after(60 * 1000, self(), {notice, Num - 1}), 
    continue(StateName, State);

%% 进入副本 
handle_info({enter, RoleTd = #role_td{id = Id, pid = Pid}}, StateName, State = #guild_td{online_role = OnlineRole, enter_role = EnterRole}) ->
    {NewOnlineRole, NewEnterRole} = case lists:keyfind(Id, #role_td.id, OnlineRole) of
        false ->
            case lists:keyfind(Id, #role_td.id, EnterRole) of
                false -> {[RoleTd | OnlineRole], [RoleTd | EnterRole]};
                Enter -> {[Enter#role_td{pid = Pid} | OnlineRole],
                        lists:keyreplace(Id, #role_td.id, EnterRole, Enter#role_td{pid = Pid})}
            end;
        R ->
            ?ELOG("角色帮会副本数据异常"),
            case lists:keyfind(Id, #role_td.id, EnterRole) of
                false -> 
                    {lists:keyreplace(Id, #role_td.id, OnlineRole, R#role_td{pid = Pid}),
                        [R#role_td{pid = Pid} | EnterRole]};
                Enter ->
                    {lists:keyreplace(Id, #role_td.id, OnlineRole, Enter#role_td{pid = Pid}),
                        lists:keyreplace(Id, #role_td.id, EnterRole, Enter#role_td{pid = Pid})}
            end
    end,
    pack_14904(NewOnlineRole, [Id], []),
    continue(StateName, State#guild_td{enter_role = NewEnterRole, online_role = NewOnlineRole});

%% 副本角色退出
handle_info({leave, #role_td{id = Id}}, StateName, State = #guild_td{online_role = OnlineRole}) ->
    NewOnlineRole = case lists:keyfind(Id, #role_td.id, OnlineRole) of
        false -> OnlineRole;
        _ -> lists:keydelete(Id, #role_td.id, OnlineRole)
    end,
    continue(StateName, State#guild_td{online_role = NewOnlineRole});

%% 副本里面角色上线
handle_info({login, RoleTd = #role_td{id = Id, pid = Pid}}, StateName, State = #guild_td{online_role = OnlineRole, enter_role = EnterRole}) ->
    {NewOnlineRole, NewEnterRole} = case lists:keyfind(Id, #role_td.id, OnlineRole) of
        false ->
            case lists:keyfind(Id, #role_td.id, EnterRole) of
                false -> {[RoleTd | OnlineRole], [RoleTd | EnterRole]};
                Enter -> {[Enter#role_td{pid = Pid} | OnlineRole],
                        lists:keyreplace(Id, #role_td.id, EnterRole, Enter#role_td{pid = Pid})}
            end;
        R ->
            case lists:keyfind(Id, #role_td.id, EnterRole) of
                false -> 
                    ?ELOG("角色帮会副本数据异常,没有找到进入记录"),
                    {lists:keyreplace(Id, #role_td.id, OnlineRole, R#role_td{pid = Pid}),
                        [R#role_td{pid = Pid} | EnterRole]};
                Enter ->
                    {lists:keyreplace(Id, #role_td.id, OnlineRole, Enter#role_td{pid = Pid}),
                        lists:keyreplace(Id, #role_td.id, EnterRole, Enter#role_td{pid = Pid})}
            end
    end,
    continue(StateName, State#guild_td{enter_role = NewEnterRole, online_role = NewOnlineRole});

%% 副本角色下线
handle_info({logout, #role_td{id = Id}}, StateName, State = #guild_td{online_role = OnlineRole}) ->
    NewOnlineRole = case lists:keyfind(Id, #role_td.id, OnlineRole) of
        false -> OnlineRole;
        _ -> lists:keydelete(Id, #role_td.id, OnlineRole)
    end,
    continue(StateName, State#guild_td{online_role = NewOnlineRole});

%% 杀怪结果更新
handle_info({result, _Type, _NpcBaseId, _RoleList},  pre_stop, State) ->
    ?DEBUG("   ----------- 杀死一只怪   "),
    continue(pre_stop, State);

%% 更新杀怪结果
handle_info({result, _Type, _NpcBaseId, _RoleList}, StateName, State = #guild_td{hp = Hp}) when Hp =< 0 ->
    ?DEBUG("  杀怪 ............."),
    continue(StateName, State);

handle_info({result, Type, _NpcBaseId, RoleList}, StateName, State = #guild_td{map_pid = MapPid, guild_id = GID, guild_pid = GuildPid, td_lev = Wave, online_role = OnlineRole, enter_role = EnterRole, all_kill_boss = AllBoss, all_kill_npc = AllNpc, surplus_npc = SurNpc, kill = Kill, hp = Hp, start_lev = StartLev}) ->
    ?DEBUG(" =====================   杀死一只怪 "),
    NewState = case Type of
        1 -> State#guild_td{all_kill_boss = AllBoss + 1, kill = Kill + 1, surplus_npc = SurNpc - 1};
        0 -> State#guild_td{all_kill_npc = AllNpc + 1, kill = Kill + 1, surplus_npc = SurNpc - 1}
    end,
    {NewOnline, NewEnter} = calc_role_result(RoleList, Type, OnlineRole, EnterRole, StartLev),
    Ns = NewState#guild_td{online_role = NewOnline, enter_role = NewEnter},
    pack_14904(NewEnter, RoleList, []),
    case Ns#guild_td.surplus_npc =< 0 of
        true ->
            case is_last_wave(Wave) of
                true ->
                    ?DEBUG(" ========= 通关结束  总杀怪 ~w, 副本血量 ~w", [AllBoss + AllNpc + 1,Hp]),
                    guild:guild_chat(GuildPid, util:fbin(?L(<<"通关结束,总击杀数为:~w, 结界血量:~w">>), [AllBoss + AllNpc + 1,Hp])),
                    pack_14905(OnlineRole, ?RESULT_COMPLETE, Ns),
                    erlang:send_after(3 * 1000, self(), {stop_guild_td_notify, GID}),
                    clean(Ns),
                    send_mail(Ns),
                    {next_state, pre_stop, Ns#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};
                false ->
                    ?DEBUG("=== 此波怪已被杀完，~w波准备到来 当前血量 ~w", [Wave + 1, Hp]),
                    guild:guild_chat(GuildPid, util:fbin(?L(<<"本波妖魔在帮会成员齐心协力的配合下已被清除，结界耐久值还剩余~w点，第~w波妖魔即将到来！{handle, 10, 进入副本, FFFF66}">>), [Hp, Wave + 1])),
                    map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"第~w波妖魔侵袭已成功被抵挡，第~w波妖魔已经来临。">>), [Wave, Wave + 1]), []}),
                    pack_14903(Ns#guild_td.online_role, Wave + 1, Ns#guild_td.hp, Ns#guild_td.end_time - util:unixtime()),   
                    {next_state, idel, Ns#guild_td{td_lev = Wave + 1, ts = now()}, ?GUILD_TD_TIME_IDEL}
            end;
        false ->
            pack_14903(Ns#guild_td.online_role, Wave, Ns#guild_td.hp, Ns#guild_td.end_time - util:unixtime()),   
            continue(StateName, Ns)
    end;

%% 遗漏怪物
handle_info({loss_npc, _Type, _NpcBaseId}, pre_stop, State) ->
    continue(pre_stop, State);

%% 遗漏怪物
handle_info({loss_npc, _Type, _NpcBaseId}, StateName, State = #guild_td{hp = Hp}) when Hp =< 0 ->
    continue(StateName, State);

%% 新的遗漏怪物
handle_info({loss_npc, _Type, NpcBaseId}, StateName, State = #guild_td{map_pid = MapPid, online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid, all_kill_boss = AllBoss, all_kill_npc = AllNpc, td_lev = Wave, surplus_npc = SurNpc, hp = Hp}) ->
    {_, Hurt} = guild_td_data:get_npc_conf(NpcBaseId),
    Hp1 = Hp - Hurt,
    SurNpc1 = SurNpc - 1,

    case Hp1 =< 0 of
        true -> %% 血量不足，军团副本结束了
            NewState = State#guild_td{surplus_npc = SurNpc - 1, hp = 0},
            ?DEBUG("副本血量为0， 怪物入侵了帮军领地，活动结束 "),
            guild:guild_chat(GuildPid, ?L(<<"很遗憾，结界的耐久值已降为0 ，怪物突破了结界侵入了帮会领地，你们防守失败了，活动结束。">>)),
            pack_14905(OnlineRole, ?RESULT_EMPTY_HP, NewState), 
            guild_td_api:stop_guild_td_notify(GID),
            clean(State),
            {next_state, pre_stop, NewState#guild_td{ts = now(), hp = 0}, ?GUILD_TD_TIME_PRE_STOP};
        false -> %% 还有血量
            case is_last_wave(Wave) of
                true -> %% 通关了
                    NewState = State#guild_td{surplus_npc = SurNpc1, hp = Hp1, ts = now()},
                    ?DEBUG("漏掉最后一只怪（且是最后一波），通关结束 总击杀为 ~w  血量 ~w", [AllBoss+AllNpc, Hp-1]),
                    guild:guild_chat(GuildPid, util:fbin(?L(<<"通关结束, 总击杀数为:~w, 剩余血量:~w">>), [AllBoss + AllNpc, Hp - 1])),
                    pack_14905(OnlineRole, ?RESULT_COMPLETE, NewState),
                    guild_td_api:stop_guild_td_notify(GID),
                    clean(State),
                    {next_state, pre_stop, NewState, ?GUILD_TD_TIME_PRE_STOP};
                false ->
                    case SurNpc1 > 0 of
                        true -> %% 同一波，没杀完怪
                            NewState = State#guild_td{surplus_npc = SurNpc1, hp = Hp1},
                            ?DEBUG(" ........  小怪爆炸，血量减少"),
                            pack_14903(OnlineRole, NewState#guild_td.td_lev, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
                            map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"结界被妖魔破坏，耐久值减少了1点。剩余~w点。">>), [Hp -1]), []}),
                            continue(StateName, NewState);
                        false -> %% 下一波准备到来
                            NewState = State#guild_td{hp = Hp1, surplus_npc = SurNpc1, td_lev = Wave + 1, ts = now()},
                            ?DEBUG("漏掉最后一只BOSS(不是最后一波)，通关结束 总击杀为 ~w  血量  ~w下一波准备到来", [AllBoss+AllNpc, Hp-1]),
                            guild:guild_chat(GuildPid, util:fbin(?L(<<"本波妖魔在帮会成员齐心协力的配合下已被清除，结界耐久值还剩余~w点，第~w波妖魔即将到来！{handle, 10, 进入副本, FFFF66}">>), [Hp -1, Wave + 1])),
                            map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"第~w波妖魔侵袭已成功被抵挡，第~w波妖魔已经来临。">>), [Wave, Wave + 1]), []}),
                            pack_14903(OnlineRole, Wave + 1, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
                            {next_state, idel, NewState, ?GUILD_TD_TIME_IDEL}

                    end
            end
    end;

%% 遗漏的不是最后一只怪,但是血量不足
handle_info({loss_npc, 0}, _StateName, State = #guild_td{online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid, surplus_npc = SurNpc, hp = 1, td_lev = _Wave}) when SurNpc > 1 ->
    NewState = State#guild_td{surplus_npc = SurNpc - 1, hp = 0},
    ?DEBUG("副本血量为0， 怪物入侵了帮军领地，活动结束 "),
    guild:guild_chat(GuildPid, ?L(<<"很遗憾，结界的耐久值已降为0 ，怪物突破了结界侵入了帮会领地，你们防守失败了，活动结束。">>)),
    pack_14905(OnlineRole, ?RESULT_EMPTY_HP, NewState), 
    guild_td_api:stop_guild_td_notify(GID),
    clean(State),
    {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};

handle_info({loss_npc, 1}, _StateName, State = #guild_td{online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid, surplus_npc = SurNpc, hp = Hp, td_lev = _Wave}) when SurNpc > 1 andalso Hp =< 3 ->
    NewState = State#guild_td{surplus_npc = SurNpc - 1, hp = 0}, 
    ?DEBUG("BOSS 入侵！！！！副本血量为0， 怪物入侵了帮军领地，活动结束 "),
    guild:guild_chat(GuildPid, ?L(<<"很遗憾，结界的耐久值已降为0 ，怪物突破了结界侵入了帮会领地，你们防守失败了，活动结束。">>)),
    pack_14905(OnlineRole, ?RESULT_EMPTY_HP, NewState), 
    guild_td_api:stop_guild_td_notify(GID),
    clean(State),
%%    send_mail(State#guild_td{td_lev = TdLev - 1}),
    {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};

%% 遗漏本波最后一只怪,
handle_info({loss_npc, 0}, _StateName, State = #guild_td{map_pid = MapPid, online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid, all_kill_boss = AllBoss, all_kill_npc = AllNpc, td_lev = Wave, surplus_npc = 1, hp = Hp}) when Hp > 1 ->
    NewState = State#guild_td{surplus_npc = 0, hp = Hp - 1}, 
    case is_last_wave(Wave) of
        true ->
            ?DEBUG(" 通关结束了 总击杀数为 ~w  剩余血量 ~w", [AllBoss + AllNpc, Hp-1]),
            guild:guild_chat(GuildPid, util:fbin(?L(<<"通关结束, 总击杀数为:~w, 剩余血量:~w">>), [AllBoss + AllNpc, Hp - 1])),
            pack_14905(OnlineRole, ?RESULT_COMPLETE, NewState),
            guild_td_api:stop_guild_td_notify(GID),
            clean(State),
            send_mail(State),
            {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};
        false -> 
            ?DEBUG("本波怪已被清除，血量还剩余~w点，第~w波怪即将到来！", [Hp -1, Wave + 1]),
            guild:guild_chat(GuildPid, util:fbin(?L(<<"本波妖魔在帮会成员齐心协力的配合下已被清除，结界耐久值还剩余~w点，第~w波妖魔即将到来！{handle, 10, 进入副本, FFFF66}">>), [Hp -1, Wave + 1])),
            map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"第~w波妖魔侵袭已成功被抵挡，第~w波妖魔已经来临。">>), [Wave, Wave + 1]), []}),
            pack_14903(OnlineRole, Wave + 1, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
            {next_state, idel, NewState#guild_td{td_lev = Wave + 1, ts = now()}, ?GUILD_TD_TIME_IDEL}
    end;

%% 遗漏本波最后一只BOSS, 需要3滴血以上
handle_info({loss_npc, 1}, _StateName, State = #guild_td{map_pid = MapPid, online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid, all_kill_boss = AllBoss, all_kill_npc = AllNpc, td_lev = Wave, surplus_npc = 1, hp = Hp}) when Hp > 3 ->
    NewState = State#guild_td{surplus_npc = 0, hp = Hp - 3}, 
    case is_last_wave(Wave) of
        true ->
            ?DEBUG("漏掉最后一只BOSS（且是最后一波），通关结束 总击杀为 ~w  血量 ~w", [AllBoss+AllNpc, Hp-1]),
            guild:guild_chat(GuildPid, util:fbin(?L(<<"通关结束, 总击杀数为:~w, 剩余血量:~w">>), [AllBoss + AllNpc, Hp - 1])),
            pack_14905(OnlineRole, ?RESULT_COMPLETE, NewState),
            guild_td_api:stop_guild_td_notify(GID),
            clean(State),
%%            send_mail(State),
            {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};
        false ->
            ?DEBUG("漏掉最后一只BOSS(不是最后一波)，通关结束 总击杀为 ~w  血量  ~w下一波准备到来", [AllBoss+AllNpc, Hp-1]),
            guild:guild_chat(GuildPid, util:fbin(?L(<<"本波妖魔在帮会成员齐心协力的配合下已被清除，结界耐久值还剩余~w点，第~w波妖魔即将到来！{handle, 10, 进入副本, FFFF66}">>), [Hp -1, Wave + 1])),
            map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"第~w波妖魔侵袭已成功被抵挡，第~w波妖魔已经来临。">>), [Wave, Wave + 1]), []}),
            pack_14903(OnlineRole, Wave + 1, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
            {next_state, idel, NewState#guild_td{td_lev = Wave + 1, ts = now()}, ?GUILD_TD_TIME_IDEL}
    end;

%% 遗漏最后一只怪, 且血量刚好为0
handle_info({loss_npc, 0}, _StateName, State = #guild_td{guild_pid = GuildPid, guild_id = GID, surplus_npc = 1, hp = 1, online_role = OnlineRole, td_lev = _Wave}) ->
    NewState = State#guild_td{surplus_npc = 0, hp = 0},
    ?DEBUG("最后一只小怪入侵，血量为0了，防守失败，活动结束"),
    guild:guild_chat(GuildPid, ?L(<<"很遗憾，结界的耐久值已降为0 ，怪物突破了结界侵入了帮会领地，你们防守失败了，活动结束。">>)),
    pack_14905(OnlineRole, ?RESULT_EMPTY_HP, NewState),
    guild_td_api:stop_guild_td_notify(GID),
    clean(State),
%%    send_mail(State#guild_td{td_lev = TdLev - 1}),
    {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};

%% 遗漏最后一只BOSS, 且血量刚好为0
handle_info({loss_npc, 1}, _StateName, State = #guild_td{td_lev = _Wave, guild_id = GID, guild_pid = GuildPid, surplus_npc = 1, hp = Hp, online_role = OnlineRole}) when Hp =< 3 ->
    ?DEBUG("111 最后一只BOSS，目前血量少于BOSS血量，防守失败，活动结束"),
    NewState = State#guild_td{surplus_npc = 0, hp = 0}, 
    guild:guild_chat(GuildPid, ?L(<<"很遗憾，结界的耐久值已降为0 ，怪物突破了结界侵入了帮会领地，你们防守失败了，活动结束。">>)),
    pack_14905(OnlineRole, ?RESULT_EMPTY_HP, NewState),
    guild_td_api:stop_guild_td_notify(GID),
    clean(State),
%%    send_mail(State#guild_td{td_lev = TdLev - 1}),
    {next_state, pre_stop, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};

%% 正常情况下怪物的遗漏
handle_info({loss_npc, 0}, StateName, State = #guild_td{map_pid = MapPid, surplus_npc = SurNpc, hp = Hp, online_role = OnlineRole}) ->
    NewState = State#guild_td{surplus_npc = SurNpc - 1, hp = Hp - 1},
    ?DEBUG(" ........  小怪爆炸，血量减少"),
    pack_14903(OnlineRole, NewState#guild_td.td_lev, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
    map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"结界被妖魔破坏，耐久值减少了1点。剩余~w点。">>), [Hp -1]), []}),
    continue(StateName, NewState);
%% BOSS遗漏
handle_info({loss_npc, 1}, StateName, State = #guild_td{map_pid = MapPid, surplus_npc = SurNpc, hp = Hp, online_role = OnlineRole}) ->
    NewState = State#guild_td{surplus_npc = SurNpc - 1, hp = Hp - 3},
    ?DEBUG("............. BOSS 爆炸, 血量减少"),
    pack_14903(OnlineRole, NewState#guild_td.td_lev, NewState#guild_td.hp, NewState#guild_td.end_time - util:unixtime()),   
    map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"结界被妖王破坏，耐久值减少了3点。剩余~w点。">>), [Hp - 3]), []}),
    continue(StateName, NewState);

%% 时间已到, 关闭副本
handle_info(keep_time_out, pre_stop, State) ->
    continue(pre_stop, State);

handle_info(keep_time_out, _StateName, State = #guild_td{online_role = OnlineRole, guild_id = GID, guild_pid = GuildPid}) ->
    ?DEBUG(" 时间到，防守失败，活动结束...."),
    guild:guild_chat(GuildPid, ?L(<<"很遗憾，时间到，你们防守失败了，活动结束。">>)),
    pack_14905(OnlineRole, ?RESULT_TIME_OUT, State),
    guild_td_api:stop_guild_td_notify(GID),
    clean(State),
    {next_state, pre_stop, State#guild_td{ts = now()}, ?GUILD_TD_TIME_PRE_STOP};

%% 创建NPC消息
handle_info({create_npc, _Time, [], _MapId}, StateName, State) ->
    continue(StateName, State);
handle_info({create_npc, Time, NpcList, MapId}, StateName, State) ->
    NewNpcList = create_npc(NpcList, MapId),
    case NewNpcList =:= [] of
        true -> continue(StateName, State);
        false -> 
            erlang:send_after(erlang:trunc(Time * 1000), self(), {create_npc, Time, NewNpcList, MapId}), 
            continue(StateName, State)
    end;

handle_info({stop_guild_td_notify, GID}, StateName, State) ->
    guild_td_api:stop_guild_td_notify(GID),
    continue(StateName, State);

%% 退出
handle_info(stop, _StateName, State) ->
    {stop, normal, State};

handle_info(_Info, StateName, State) ->
    continue(StateName, State).

terminate(normal, _StateName, State = #guild_td{online_role = OnlineRole, guild_id = Gid, td_lev = TdLev}) ->
    ?DEBUG("  正常结束军团副本  "),
    clean(State),
    clean_role([], OnlineRole),
    guild_td_mgr:guild_td_stop(self(), Gid, TdLev),
    ok;

%% 异常挂掉之后 奖励继续发放
terminate(_Reason, _StateName, State = #guild_td{online_role = OnlineRole, guild_id = Gid, td_lev = TdLev}) ->
    ?DEBUG("  异常挂掉了。。。。"),
    clean(State),
    clean_role([], OnlineRole),
    send_mail(State),
    guild_td_mgr:guild_td_stop(self(), Gid, TdLev),
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%% ---------创建NPC
create_npc([{NpcBaseId, Num, {X, Y}, PathNum} | T], MapId) ->
    create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum),
    T. 
    
create_one_npc(_NpcBaseId, 0, _X, _Y, _MapId, _PathNum) -> ok;
create_one_npc(NpcBaseId, Num, X, Y, MapId, PathNum) ->
    npc_mgr:create(NpcBaseId, MapId, X + util:rand(-100, 100), Y + util:rand(-60, 60), npc_path_data:get_td_path(PathNum)),
    create_one_npc(NpcBaseId, Num - 1, X, Y, MapId, PathNum).

%% 若npc胜利，npc重新显示
reappear_npc([{npc_pid, NpcPid}], Winner) when is_pid(NpcPid) ->
    case lists:keyfind(?fighter_type_npc, #fighter.type, Winner) of
        false ->
            skip;
        _ ->
            NpcPid ! {cast_fight_status, 0}
    end;
reappear_npc(_, _) -> false.

%% 运行状态
active(_Any, State) ->
    continue(active, State).

%% 空闲状态
idel(timeout, State = #guild_td{map_id = MapId, td_lev = TdLev}) ->
    {Summary, Time, _BossNum, NpcBaseIdList} = guild_td_data:get_lev(TdLev), 
    self() ! {create_npc, Time, NpcBaseIdList, MapId}, 
    ?DEBUG("   ------>> 创建NPC 列表  ~w", [NpcBaseIdList]),
    ?DEBUG("第~w波怪物开始创建",[TdLev]),
    NewState = State#guild_td{ts = now(), surplus_npc = Summary, summary_npc = Summary, kill = 0},
    {next_state, active, NewState};

idel(_Any, State) ->
    continue(idel, State).

%% 准备状态超时, 开启副本
pre_start(timeout, State = #guild_td{td_lev = Wave, hp = Hp, guild_pid = Pid, map_pid = MapPid, online_role = OnlineRole}) ->
    NewState = State#guild_td{ts = now(), end_time = util:unixtime() + ?GUILD_TD_KEEP_TIME div 1000},
    pack_14903(OnlineRole, Wave, Hp, ?GUILD_TD_KEEP_TIME div 1000), 
    guild:guild_chat(Pid, util:fbin(?L(<<"第~w波妖魔已经发动侵袭，请沿路前去击杀妖魔。{handle, 10, 点击进入副本, FFFF66}">>), [Wave])),
    map:pack_send_to_all(MapPid, 10931, {55, util:fbin(?L(<<"第~w波妖魔已经发动侵袭，请沿路前去击杀妖魔">>), [Wave]), []}),
    erlang:send_after(?GUILD_TD_KEEP_TIME, self(), keep_time_out), 
    {next_state, idel, NewState#guild_td{ts = now()}, ?GUILD_TD_TIME_IDEL};

pre_start(_Any, State) ->
    continue(pre_start, State).

%% 清理时间超时，关闭副本
pre_stop(timeout, State) ->
    {stop, normal, State};

pre_stop(_Any, State) ->
    continue(pre_stop, State).

%% ---------------------------------
%% 重新计算超时时间，继续某一状态
continue(active, State) ->
    {next_state, active, State};
continue(idel, State = #guild_td{ts = Ts}) ->
    {next_state, idel, State, util:time_left(?GUILD_TD_TIME_IDEL, Ts)};
continue(pre_start, State = #guild_td{ts = Ts}) ->
    {next_state, pre_start, State, util:time_left(?GUILD_TD_TIME_PRE_START, Ts)};
continue(pre_stop, State = #guild_td{ts = Ts}) ->
    {next_state, pre_stop, State, util:time_left(?GUILD_TD_TIME_PRE_STOP, Ts)}.

%% 获取玩家积分列表
get_role_point(RoleList) ->
    get_role_point(RoleList, []).
get_role_point([], List) -> List;
get_role_point([#role_td{id = {RoleId, _}, name = Name, kill_npc = A, kill_boss = B} | T], List) ->
    get_role_point(T, [{RoleId, Name, A * 3 + B * 10} | List]).

%% 是否是最后一波
is_last_wave(Wave) ->
    Lev = guild_td_data:wave2lev(Wave),
    {_, LastWave} = guild_td_data:get_td_conf(Lev),
    Wave =:= Lev * 10000 + LastWave.

%% -------------------------
%% 协议打包处理
%% -------------------------
%% 打包协议信息

pack_14903([], _Lev, _Hp, _Time) -> ok;
pack_14903([#role_td{pid = Pid} | T], Lev, Hp, Time) ->
    ?DEBUG("pack_14903 : ~w", [{Lev, Hp, Time}]),
    role:pack_send(Pid, 14903, {Lev, Hp, Time}),
    pack_14903(T, Lev, Hp, Time).

pack_14904(OnlineRole, [], RoleList) ->
    Info = get_role_point(RoleList),
    ?DEBUG("pack_14904 ~w", [Info]),
    do_pack_14904(OnlineRole, Info);
pack_14904(OnlineRole, [Id | T], RoleList) ->
    case lists:keyfind(Id, #role_td.id, OnlineRole) of
        false -> pack_14904(OnlineRole, T, RoleList);
        RoleTd -> pack_14904(OnlineRole, T, [RoleTd | RoleList])
    end.

do_pack_14904([], _Info) -> ok;
do_pack_14904([#role_td{pid = Pid} | T], Info) ->
    role:pack_send(Pid, 14904, {Info}),
    do_pack_14904(T, Info).

pack_14905([], _Value, _State) -> ok;
pack_14905([#role_td{pid = Pid} | T], Value, State = #guild_td{td_lev = Lev, hp = Hp, end_time = EndTime}) ->
    Time = EndTime - util:unixtime(),
    PushTime = case Time =< 0 of
        true -> 0;
        false -> Time
    end,
    ?DEBUG("pack_14905 ~w", [{Value, Lev, Hp, PushTime}]),
    role:pack_send(Pid, 14905, {Value, Lev, Hp, PushTime}),
    pack_14905(T, Value, State).

pack_14907([], _Flag) -> ok;
pack_14907([#guild_member{pid = Pid} | T], Flag) when is_pid(Pid) ->
    ?DEBUG("pack_14907 ~w", [Flag]),
    role:pack_send(Pid, 14907, {Flag}),
    pack_14907(T, Flag);
pack_14907([_ | T], Flag) -> pack_14907(T, Flag).

pack_14909(#role{pid = Pid}, Flag) ->
    role:pack_send(Pid, 14909, {Flag}).
