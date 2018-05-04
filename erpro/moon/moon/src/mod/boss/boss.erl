%%----------------------------------------------------
%% @doc 世界boss模块 
%%
%% <pre>
%% 世界boss模块 
%% </pre>
%% @author yqhuang(QQ:19123767)
%%----------------------------------------------------
-module(boss).

-behaviour(gen_server).

-export([
        start_link/0
        ,boss_list_info/0
        ,combat_over/2
        ,stop/1
        ,relive_boss/1
        ,check_combat_start/3
    ]
).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


-include("common.hrl").
-include("boss.hrl").
-include("combat.hrl").
-include("npc.hrl").

%% 进程状态数据
-record(boss_state, {
        list = []               %% 世界boss信息表#boss_base
        ,lev_state = []         %% 级别信息
    }
).

%%----------------------------------------------------
%% 对外接口
%%----------------------------------------------------

%% @spec start_link() ->
%% @doc
%% <pre>
%% 启动世界boss进程
%% </pre>
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% @spec boss_list_info() -> [#boss{}]
%% @doc
%% <pre>
%% 获取boss信息
%% </pre>
boss_list_info() ->
    gen_server:call(?MODULE, {boss_list_info}).

%% @spec combat_over(Winner, Loser) -> ok
%% @doc
%% <pre>
%% Winner = [#fighter{}] 胜方列表
%% Loser = [#fighter{}] 败方列表
%% </pre>
combat_over(Winner, Loser) ->
    case boss_is_loser(Loser) of
        {true, NpcBaseId, BossLev} ->
            ?DEBUG("世界boss模块调用"),
            friend:intimacy_kill_boss(Winner, Loser),
            rank_celebrity:listener(world_boss, Winner, BossLev),
            catch fire_kill_boss(Winner),
            RoleNameList = [{Rid, SrvId, Name}|| #fighter{rid = Rid, srv_id = SrvId, name = Name, type = Type} <- Winner, Type =:= ?fighter_type_role],
            gen_server:call(?MODULE, {combat_over, NpcBaseId, RoleNameList});
        false -> ok
    end.

%% 测试
stop(Type) ->
    gen_server:cast(?MODULE, {stop, Type}).

%% 复活
relive_boss(NpcBaseId) ->
    gen_server:cast(?MODULE, {relive_boss, NpcBaseId}).

%% 发起战斗 ok | {false, Reason}
check_combat_start(RoleId, SrvId, Npc) ->
    gen_server:call(?MODULE, {check_combat_start, RoleId, SrvId, Npc}).

%%----------------------------------------------------
%% 内部处理
%%----------------------------------------------------
%% 初始化
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = #boss_state{},
    BossList = boss_data:get(all),
    NewState = init_boss(State, BossList),
    erlang:send_after(3600 * 1000, self(), check_boss_status),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, NewState}.

%% 获取boss信息列表
handle_call({boss_list_info}, _From, State = #boss_state{list = BossList, lev_state = LevStateList}) ->
    Fun = fun(Boss = #boss{npc_lev = NpcLev, status = Status}) ->
        NewStatus = case Status > 0 of
            true ->
                case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
                    #boss_lev_state{kill_time = KillTime, interval = Interval} ->
                        Now = util:unixtime(),
                        case Now >= (KillTime + Interval) of
                            true ->
                                0; %% 活跃
                            false ->
                                (KillTime + Interval) - Now
                        end;
                    _ -> 0
                end;
            false ->
                0
        end,
    Boss#boss{status = NewStatus}
    end,
    NewBossList = lists:map(Fun, BossList),
    {reply, NewBossList, State};

%% 干掉boss
handle_call({combat_over, NpcBaseId, RoleNameList}, _From, State = #boss_state{list = BossList, lev_state = LevStateList}) ->
    case lists:keyfind(NpcBaseId, #boss.npc_id, BossList) of
        Boss = #boss{status = 0, npc_lev = NpcLev, npc_name = NpcName} ->
            case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
                LevState = #boss_lev_state{kill_time = KillTime, kill_num = KillNum, interval = Interval} ->
                    {NewStatus, NewKillTime} = case KillTime > 0 of
                        false -> %% 第一次杀死
                            erlang:send_after((Interval - 5) * 1000, self(), {warning, NpcLev}),
                            erlang:send_after(Interval * 1000, self(), {relive_lev, NpcLev}),
                            {Interval, util:unixtime()};
                        true -> 
                            {Interval + KillTime - util:unixtime(), KillTime}
                    end,
                    BinBossNames = concat_name(RoleNameList),
                    notice:send(53, util:fbin(?L(<<"不可一世的{npc, ~s, #f65e6a}居然被击败了，据说战胜它的正是修为惊人的~s">>), [NpcName, BinBossNames])),
                    role_group:pack_cast(world, 12801, {NpcBaseId, NewStatus}),
                    NewBoss = Boss#boss{kill_time = util:unixtime(), status = NewStatus, pos = {0, 0}},
                    NewBossList = lists:keyreplace(NpcBaseId, #boss.npc_id, BossList, NewBoss),
                    NewLevStateList = lists:keyreplace(NpcLev, #boss_lev_state.lev, LevStateList, LevState#boss_lev_state{kill_time = NewKillTime, kill_num = KillNum + 1}),
                    {reply, ok, State#boss_state{list = NewBossList, lev_state = NewLevStateList}};
                _ ->
                    ?ELOG("级别状态列表缺少世界boss信息NpcLev:~w", [NpcLev]),
                    {reply, ok, State}
            end;
        false ->
            ?DEBUG("没有打到世界boss信息:~w", [NpcBaseId]),
            {reply, ok, State};
        _Any ->
            ?ELOG("[世界boss]收到的combat_over信息有误，杀死了已死亡的boss[NpcBaseId:~w, RoleNameList:~w]", [NpcBaseId, RoleNameList]),
            {reply, ok, State}
    end;

handle_call({check_combat_start, RoleId, SrvId, #npc{id = NpcId, base_id = BaseId}}, _From, State = #boss_state{list = BossList}) ->
    Now = util:unixtime(),
    {Reply, NewState} = case lists:keyfind(BaseId, #boss.npc_id, BossList) of
        #boss{status = 0, randomer = {RoleId, SrvId}} -> %% 已经选中
            {ok, State};
        Boss = #boss{relive_time = ReliveTime, status = 0, killer = Killer} ->
            case Now > (ReliveTime + 10) of
                true -> {ok, State};
                false ->
                    Time = case (ReliveTime + 10) > Now of
                        true -> (ReliveTime + 10) - Now;
                        _ -> 1
                    end,
                    case Now >= (ReliveTime + 7) of
                        true ->
                            NewKiller = case lists:keyfind({RoleId, SrvId}, #boss.npc_id, Killer) of
                                false -> [{{RoleId, SrvId}, NpcId} | Killer];
                                _ -> Killer
                            end,
                            NewBossList = lists:keyreplace(BaseId, #boss.npc_id, BossList, Boss#boss{killer = NewKiller}),
                            {{false, util:fbin(?L(<<"BOSS刚刚重生元神尚未凝结完毕，~w秒后才可对其发起挑战。">>), [Time])}, State#boss_state{list = NewBossList}};
                        false ->
                            {{false, util:fbin(?L(<<"BOSS刚刚重生元神尚未凝结完毕，~w秒后才可对其发起挑战。">>), [Time])}, State}
                    end
            end;
        _ -> {{false, ?L(<<"Boss现在很忙">>)}, State}
    end,
    {reply, Reply, NewState};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast({stop, normal}, State) ->
    {stop, normal, State};
handle_cast({stop, _Type}, State) ->
    {stop, {from_test, ?L(<<"关闭世界boss进程">>)}, State};

%% 只是复活boss，不修改世界boss进程状态
handle_cast({relive_boss, NpcBaseId}, State) ->
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            {ok, #boss_base{map_id = MapId, pos_list = PosList}} = boss_data:get(NpcBaseId),
            {X, Y} = util:rand_list(PosList),
            case npc_mgr:create(NpcBaseId, MapId, X, Y) of
                {ok, _NpcBaseId} ->
                    ?INFO("手动复活世界boss成功"),
                    ok;
                _ ->
                    ?ELOG(util:fbin(<<"创建世界Boss出错了[NpcBaseId:~w]">>, [NpcBaseId])),
                    relive_error
            end;
        _Other -> 
            ?INFO("世界boss已经存在:~w", [_Other]),
            ignore 
    end,
    {noreply, State};

handle_cast(_Msg, State) ->
    {noreply, State}.

%% 复活
handle_info({relive_lev, NpcLev}, State = #boss_state{list = BossList, lev_state = LevStateList}) ->
    case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
        LevState = #boss_lev_state{map_id = MapId} ->
            PosList = [Pos || #boss{npc_lev = BossLev, status = Status, pos = Pos} <- BossList, BossLev =:= NpcLev, Status =:= 0],
            {NewBossList, BossNameList} = relive_boss(BossList, NpcLev, "", PosList),
            NewLevStateList = case length(BossNameList) > 0 of
                true -> 
                    notice:send(53, util:fbin(?L(<<"天地异象降临{map, ~w}，原来是世界boss~s重现人间，身上宝气冲天，似乎挟带着灵器异宝。">>), [MapId, list_to_bitstring(BossNameList)])),
                    lists:keyreplace(NpcLev, #boss_lev_state.lev, LevStateList, LevState#boss_lev_state{kill_time = 0, kill_num = 0});
                false -> LevStateList
            end,
            {noreply, State#boss_state{list = NewBossList, lev_state = NewLevStateList}};
        false -> 
            ?ELOG("级别状态列表缺少世界boss信息NpcLev:~w", [NpcLev]),
            {noreply, State}
    end;

handle_info({warning, NpcLev}, State = #boss_state{list = BossList, lev_state = LevStateList}) ->
    case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
        #boss_lev_state{map_id = MapId} ->
            BossNameList = concat_boss_name(BossList, NpcLev),
            case length(BossNameList) > 0 of
                true -> notice:send(53, util:fbin(?L(<<"天生异象，世界boss~s即将在{map, ~w}降临，身上宝气冲天，似乎携带着灵器异宝。">>), [list_to_bitstring(BossNameList), MapId]));
                false -> ignore
            end;
        _ ->
            ?ELOG("世界bosss信息级别信息有误了:~w", [NpcLev])
    end,
    {noreply, State};

handle_info({'EXIT', _Pid, normal}, State) ->
    {noreply, State};
handle_info({'EXIT', Pid, Why}, State = #boss_state{list = BossList, lev_state = LevStateList}) ->
    case lists:keyfind(Pid, #boss.pid, BossList) of
        Boss = #boss{npc_id = NpcBaseId, npc_lev = NpcLev} ->
            ?ELOG("有一个世界boss进程异常退出:~w ~w", [NpcBaseId, Why]),
            case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
                LevState = #boss_lev_state{kill_time = KillTime, kill_num = KillNum, interval = Interval} ->
                    {NewStatus, NewKillTime} = case KillTime > 0 of
                        false -> %% 第一次杀死
                            erlang:send_after((Interval - 10) * 1000, self(), {warning, NpcLev}),
                            erlang:send_after(Interval * 1000, self(), {relive_lev, NpcLev}),
                            {Interval, util:unixtime()};
                        true -> 
                            {Interval + KillTime - util:unixtime(), KillTime}
                    end,
                    NewBoss = Boss#boss{kill_time = util:unixtime(), status = NewStatus, pos = {0, 0}, killer = []},
                    NewBossList = lists:keyreplace(NpcBaseId, #boss.npc_id, BossList, NewBoss),
                    NewLevStateList = lists:keyreplace(NpcLev, #boss_lev_state.lev, LevStateList, LevState#boss_lev_state{kill_time = NewKillTime, kill_num = KillNum + 1}),
                    role_group:pack_cast(world, 12801, {NpcBaseId, NewStatus}),
                    {noreply, State#boss_state{list = NewBossList, lev_state = NewLevStateList}};
                _ ->
                    ?ELOG("世界bosss信息级别信息有误了:~w ~w", [NpcBaseId, NpcLev]),
                    {noreply, State}
            end;
        _ ->
            {noreply, State}
    end;

%% 检查是否存在boss没有复活
handle_info(check_boss_status, State = #boss_state{list = BossList}) ->
    msg_relive_boss(BossList),
    erlang:send_after(3600 * 1000, self(), check_boss_status),
    {noreply, State};

%% boss发起战斗
handle_info({combat_start, NpcBaseId}, State = #boss_state{list = BossList}) ->
    NewState = case lists:keyfind(NpcBaseId, #boss.npc_id, BossList) of
        Boss = #boss{status = 0, killer = Killer} when length(Killer) > 0 ->
            case util:rand_list(Killer) of
                {{RoleId, SrvId}, NpcId} ->
                    case global:whereis_name({role, RoleId, SrvId}) of
                        Pid when is_pid(Pid) ->
                            catch role:apply(async, Pid, {fun apply_combat_start/2, [{NpcId, NpcBaseId}]}),
                            NewBossList = lists:keyreplace(NpcBaseId, #boss.npc_id, BossList, Boss#boss{randomer = {RoleId, SrvId}}),
                            State#boss_state{list = NewBossList};
                        _ -> State 
                    end;
                _Any -> State
            end;
        _Other -> State
    end,
    {noreply, NewState};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    ?ELOG("关闭世界boss进程Reason:~w", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 启动时世界boss全部刷新
init_boss(State = #boss_state{list = BossList, lev_state = LevStateList}, [NpcBaseId | T]) ->
    {ok, #boss_base{npc_id = NpcBaseId, npc_lev = NpcLev, npc_name = NpcName, map_id = MapId, interval = Interval, map_name = MapName, pos_list = PosList}} = boss_data:get(NpcBaseId),
    BossPosList = [Pos || #boss{npc_lev = BossLev, pos = Pos} <- BossList, BossLev =:= NpcLev],
    {X, Y} = relive_pos(BossPosList, PosList),
    case npc_mgr:create(NpcBaseId, MapId, X, Y) of
        {ok, _NpcBaseId} ->
            BossPid = case npc_mgr:lookup(by_base_id, NpcBaseId) of
                [#npc{pid = Pid}] -> Pid;
                _ -> 
                    ?ELOG("没有找到世界boss信息:~w", [NpcBaseId]),
                    undefined
            end,
            NewLevStateList = case lists:keyfind(NpcLev, #boss_lev_state.lev, LevStateList) of
                false -> 
                    NewInterval = merge_interval(Interval),
                    [#boss_lev_state{lev = NpcLev, map_id = MapId, map_name = MapName, interval = NewInterval} | LevStateList];
                _ -> LevStateList
            end,
            erlang:send_after(10 * 1000, self(), {combat_start, NpcBaseId}),
            NewBossList = [#boss{npc_id = NpcBaseId, pid = BossPid, npc_name = NpcName, npc_lev = NpcLev, relive_time = util:unixtime(), kill_time = 0, status = 0, map_id = MapId, map_name = MapName, pos = {X, Y}, killer = [], randomer = {}} | BossList],
            NewState = State#boss_state{list = NewBossList, lev_state = NewLevStateList},
            init_boss(NewState, T);
        _ ->
            ?ELOG(util:fbin(<<"创建世界Boss出错了[NpcBaseId:~w]">>, [NpcBaseId])),
            init_boss(State, T)
    end;
init_boss(State, []) ->
    State.

%% 判断败是否有Boss
boss_is_loser([#fighter{type = ?fighter_type_npc, rid = NpcBaseId, is_die = IsDie} | T]) ->
    case boss_data:get(NpcBaseId) of
        {ok, #boss_base{npc_id = BossNpcBaseId, npc_lev = NpcLev}} ->
            case NpcBaseId =:= BossNpcBaseId andalso  IsDie =:= ?true of
                true ->
                    {true, NpcBaseId, NpcLev};
                false ->
                    boss_is_loser(T)
            end;
        {false, _Reason} ->
            boss_is_loser(T)
    end;
boss_is_loser([#fighter{type = ?fighter_type_role} | T]) ->
    boss_is_loser(T);
boss_is_loser([]) ->
    false.

%% 获取重生坐标
relive_pos(BossPos, PosList) ->
    Mul = PosList -- BossPos,
    case length(Mul) > 0 of
        true -> util:rand_list(Mul);
        false -> util:rand_list(PosList)
    end.

%% boss重生
relive_boss([], _NpcLev, BossNameList, _PosList) -> {[], BossNameList};
relive_boss([Boss = #boss{npc_id = NpcBaseId, npc_lev = NpcLev, status = Status} | T], NpcLev, BossNameList, BossPos) when Status > 0 ->
    {ok, #boss_base{npc_name = NpcName, pos_list = PosList, map_id = MapId}} = boss_data:get(NpcBaseId),
    {X, Y} = relive_pos(BossPos, PosList),
    {BossList, NewBossNameList} = relive_boss(T, NpcLev, BossNameList, [{X, Y} | PosList]),
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            case npc_mgr:create(NpcBaseId, MapId, X, Y) of
                {ok, _NpcBaseId} ->
                    role_group:pack_cast(world, 12801, {NpcBaseId, 0}),
                    BossPid = case npc_mgr:lookup(by_base_id, NpcBaseId) of
                        [#npc{pid = Pid}] -> Pid;
                        _ -> 
                            ?ELOG("没有找到世界boss信息:~w", [NpcBaseId]),
                            undefined
                    end,
                    erlang:send_after(10 * 1000, self(), {combat_start, NpcBaseId}),
                    NewBoss = Boss#boss{status = 0, pid = BossPid, pos = {X, Y}, relive_time = util:unixtime(), kill_time = 0,  killer = [], randomer = {}},
                    {[NewBoss| BossList], lists:concat(["{npc, ", binary_to_list(NpcName), ", #f65e6a}", NewBossNameList])};
                _Other ->
                    ?ELOG("创建世界boss出错了[NpcBaseId:~w, Reason:~w]", [NpcBaseId, _Other]),
                    {[Boss | BossList], NewBossNameList}
            end;
        _ ->
            {[Boss#boss{status = 0} | BossList], NewBossNameList}
    end;
relive_boss([Boss | T], NpcLev, BossNameList, PosList) ->
    {BossList, NewBossNameList} = relive_boss(T, NpcLev, BossNameList, PosList),
    {[Boss | BossList], NewBossNameList}.

msg_relive_boss([]) -> ok;
msg_relive_boss([#boss{npc_id = NpcBaseId, status = 0} | T]) ->
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            {ok, #boss_base{map_id = MapId, pos_list = PosList}} = boss_data:get(NpcBaseId),
            {X, Y} = util:rand_list(PosList),
            case npc_mgr:create(NpcBaseId, MapId, X, Y) of
                {ok, _NpcBaseId} ->
                    ?INFO("定时消息复活世界boss成功[~w]", [NpcBaseId]),
                    ok;
                _ ->
                    ?ELOG(util:fbin(<<"创建世界Boss出错了[NpcBaseId:~w]">>, [NpcBaseId])),
                    relive_error
            end;
        _ -> ignore
    end,
    msg_relive_boss(T);
msg_relive_boss([_Boss | T]) ->
    msg_relive_boss(T).

%% 进入战斗
apply_combat_start(Role, {NpcId, _NpcBaseId}) ->
    case combat_rpc:distance_check(Role, NpcId) of
        true ->
            case combat_rpc:team_check(Role) of
                true ->
                    case npc_mgr:lookup(by_id, NpcId) of
                        false -> false;
                        Npc ->
                            case combat_type:check(?combat_type_npc, Role, Npc) of
                                {true, NewCombatType} ->
                                    case npc:fight(Npc, Role, NewCombatType) of
                                        {false, _Reason} -> false;
                                        true -> ok
                                    end;
                                %% 兼容狂暴处理
                                {rob, NewCombatType, _} ->
                                    case npc:fight(Npc, Role, NewCombatType) of
                                        {false, _Reason} -> false;
                                        true -> ok
                                    end;
                                {true, NewCombatType, Referees} ->
                                    case npc:fight(Npc, Role, NewCombatType, Referees) of
                                        {false, _Reason} -> false;
                                        true ->  ok 
                                    end;
                                {false, _Reason} -> false 
                            end
                    end;
                false -> false 
            end;
        _ -> false
    end,
    {ok}.

%% boss名称
concat_boss_name([], _NpcLev) -> "";
concat_boss_name([#boss{npc_name = NpcName, npc_lev = NpcLev, status = Status} | T], NpcLev) when Status > 0 ->
    lists:concat(["{npc, ", binary_to_list(NpcName), ", #f65e6a}", concat_boss_name(T, NpcLev)]);
concat_boss_name([_Boss | T], NpcLev) ->
    concat_boss_name(T, NpcLev).

concat_name([{Rid, SrvId, Name}]) ->
    util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid, SrvId, Name]);
concat_name([{Rid1, SrvId1, Name1}, {Rid2, SrvId2, Name2}]) ->
    Rname1 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid1, SrvId1, Name1]),
    Rname2 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid2, SrvId2, Name2]),
    util:fbin(<<"~s~s">>, [Rname1, Rname2]);
concat_name([{Rid1, SrvId1, Name1}, {Rid2, SrvId2, Name2}, {Rid3, SrvId3, Name3} | _]) ->
    Rname1 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid1, SrvId1, Name1]),
    Rname2 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid2, SrvId2, Name2]),
    Rname3 = util:fbin(<<"{role, ~w, ~s, ~s, #3ad6f0}">>, [Rid3, SrvId3, Name3]),
    util:fbin(<<"~s~s~s">>, [Rname1, Rname2, Rname3]);
concat_name(Other) ->
    util:fbin(<<"~s">>, [Other]).

%% 合过服的，世界boss重生时间缩短一半
merge_interval(Interval) ->
    case util:is_merge() of
        true -> round(Interval / 2);
        _ -> Interval
    end.

%% 个人杀boss事件
fire_kill_boss([]) -> ok;
fire_kill_boss([#fighter{pid = Pid, type = ?fighter_type_role} | T]) ->
    catch role:apply(async, Pid, {fun apply_fire_kill_boss/1, []}),
    fire_kill_boss(T);
fire_kill_boss([_F | T]) ->
    fire_kill_boss(T).

apply_fire_kill_boss(Role) ->
    NewRole = role_listener:special_event(Role, {1044, finish}), %% 击杀任意一只世界boss
    {ok, NewRole}.


