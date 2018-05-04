%%----------------------------------------------------
%% @doc 新世界boss机制
%% 
%% @author yqhuang(QQ:19123767)
%% @end
%%----------------------------------------------------
-module(boss_unlock).

-behaviour(gen_server).

-export([
        start_link/0
        ,combat_over/2
        ,boss_list_info/0
        %% ,stop/1
        ,relive_boss/1
        ,check_combat_start/4
    ]
).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


-include("common.hrl").
-include("boss.hrl").
-include("combat.hrl").
-include("npc.hrl").
-include("gain.hrl").
-include("team.hrl").

%% 进程状态数据
-record(state, {
        boss_list = []      %% boss列表
        ,boss_group = []    %% 组列表
    }
).

%%----------------------------------------------------
%% API
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

%% 战斗结束
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

%% 复活
relive_boss(NpcBaseId) ->
    boss_unlock ! {relive_boss, NpcBaseId}.

%% 发起战斗 ok | {false, Reason}
check_combat_start(RoleId, SrvId, Npc, TeamPid) ->
    gen_server:call(?MODULE, {check_combat_start, RoleId, SrvId, Npc, TeamPid}).
%%----------------------------------------------------
%% gen_server
%%----------------------------------------------------
%% 初始化
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true),
    State = #state{},
    BossList = boss_data:get(all),
    NewState = init_boss(State, BossList),
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, NewState}.

handle_call({check_combat_start, _RoleId, _SrvId, #npc{base_id = NpcBaseId}, _TeamPid}, _From, State = #state{boss_list = BossList}) ->
    Now = util:unixtime(),
    Diff = 5,
    Reply = case lists:keyfind(NpcBaseId, #boss_unlock.npc_id, BossList) of
        false -> {false, ?L(<<"世界boss信息有误">>)};
        #boss_unlock{relive_time = ReliveTime} when (ReliveTime + Diff) > Now ->
            {false, util:fbin(?L(<<"BOSS刚刚重生元神尚未凝结完毕，~w秒后才可对其发起挑战。">>), [((ReliveTime + Diff) - Now)])};
        #boss_unlock{lev = _NpcLev} ->
            %% 策划要求去掉限制
            %% {MaxLev, Mname} = get_team_max_lev(TeamPid, RoleId, SrvId),
            %% case MaxLev >= (NpcLev + 30) of
            %%     true -> {false, util:fbin(?L(<<"您队伍中的~s等级过高，杀鸡焉用牛刀，此等小妖就交给其他历练中的小仙们降服吧。">>), [Mname])};
            %%     false -> ok
            %% end;
            ok;
        _ -> ok 
    end,
    {reply, Reply, State};

%% 获取boss信息列表
handle_call({boss_list_info}, _From, State = #state{boss_list = BossList, boss_group = GroupList}) ->
    Fun = fun(Boss = #boss_unlock{lev = NpcLev, status = Status}) ->
        NewStatus = case Status > 0 of
            true ->
                case lists:keyfind(NpcLev, #boss_unlock_group.lev, GroupList) of
                    #boss_unlock_group{kill_time = KillTime, interval = Interval} ->
                        Now = util:unixtime(),
                        case Now >= (KillTime + Interval) of
                            true -> 0; %% 活跃
                            false ->
                                (KillTime + Interval) - Now
                        end;
                    _ -> 0
                end;
            false -> 0
        end,
        Boss#boss_unlock{status = NewStatus}
    end,
    NewBossList = lists:map(Fun, BossList),
    OldBossList = convert_to_boss(NewBossList),
    {reply, OldBossList, State};

handle_call({combat_over, NpcBaseId, RoleNameList}, _From, State = #state{boss_list = BossList, boss_group = GroupList}) ->
    npc:stop(by_base_id, NpcBaseId),
    case lists:keyfind(NpcBaseId, #boss_unlock.npc_id, BossList) of
        Boss = #boss_unlock{status = Status, lev = NpcLev, npc_name = NpcName, team_list = TeamList, kill_time = BossKillTime} ->
            case lists:keyfind(NpcLev, #boss_unlock_group.lev, GroupList) of
                Group = #boss_unlock_group{interval = Interval, kill_time = GKillTime} ->
                    RoleNames = concat_name(RoleNameList),
                    Now = util:unixtime(),
                    {NewStatus, NewBossKillTime} = case Status of
                        0 ->
                            notice:send(53, util:fbin(?L(<<"妖魔伏诛！~s修为惊人，领先于众仙友率先降服了世界BOSS{npc, ~s, #f65e6a}，有望得到世界BOSS身上的宝藏!">>), [RoleNames, NpcName])),
                            erlang:send_after(181 * 1000, self(), {award_mail, NpcBaseId}),
                            {Interval, Now};
                        _ ->
                            case (BossKillTime + 180) > Now of
                                true -> notice:send(53, util:fbin(?L(<<"~s跟随众仙友一同降服了世界BOSS{npc, ~s, #f65e6a}，有望得到世界BOSS身上的宝藏!">>), [RoleNames, NpcName]));
                                false -> ignore
                            end,
                            {Interval + GKillTime - util:unixtime(), BossKillTime}
                    end,
                    NewGKillTime = case GKillTime =< 0 of
                        true -> 
                            erlang:send_after((Interval - 5) * 1000, self(), {warning, NpcLev}),
                            erlang:send_after(Interval * 1000, self(), {relive_lev, NpcLev}),
                            Now;
                        false -> 
                            GKillTime
                    end,
                    NewTeamList = case (NewBossKillTime + 180) > Now of
                        true -> 
                            [RoleNameList | TeamList];
                        false -> 
                            send_mail_evil(RoleNameList, NpcName),
                            TeamList
                    end,
                    role_group:pack_cast(world, 12801, {NpcBaseId, NewStatus}),
                    NewBoss = Boss#boss_unlock{kill_time = NewBossKillTime, relive_time = 0, status = NewStatus, team_list = NewTeamList},
                    NewGroup = Group#boss_unlock_group{kill_time = NewGKillTime, relive_time = 0},
                    NewBossList = lists:keyreplace(NpcBaseId, #boss_unlock.npc_id, BossList, NewBoss),
                    NewGroupList = lists:keyreplace(NpcLev, #boss_unlock_group.lev, GroupList, NewGroup),
                    {reply, ok, State#state{boss_list = NewBossList, boss_group = NewGroupList}};
                _ ->
                    ?ELOG("级别状态列表缺少世界boss信息NpcLev:~w", [NpcLev]),
                    {reply, ok, State}
            end;
        false ->
            ?DEBUG("没有打到世界boss信息:~w", [NpcBaseId]),
            {reply, ok, State}
    end;
    %% npc:stop(by_base_id, NpcBaseId),
    %% erlang:send_after(10 * 1000, self(), {relive_boss, NpcBaseId}),
    %% {noreply, State};

handle_call(_Request, _From, State) ->
    {noreply, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({warning, NpcLev}, State = #state{boss_list = BossList, boss_group = GroupList}) ->
    case lists:keyfind(NpcLev, #boss_unlock_group.lev, GroupList) of
        #boss_unlock_group{map_id = MapId} ->
            BossNameList = concat_boss_name(BossList, NpcLev),
            case length(BossNameList) > 0 of
                true -> notice:send(53, util:fbin(?L(<<"天生异象，世界boss~s即将在{map, ~w}降临，身上宝气冲天，似乎携带着灵器异宝。{open, 28, 我要降服, #00ff24}">>), [list_to_bitstring(BossNameList), MapId]));
                false -> ignore
            end;
        _ ->
            ?ELOG("世界bosss信息级别信息有误了:~w", [NpcLev])
    end,
    {noreply, State};

handle_info({relive_lev, NpcLev}, State = #state{boss_list = BossList, boss_group = GroupList}) ->
    case lists:keyfind(NpcLev, #boss_unlock_group.lev, GroupList) of
        Group = #boss_unlock_group{map_id = MapId} ->
            PosList = [Pos || #boss_unlock{lev = BossLev, status = 0, pos = Pos} <- BossList, BossLev =:= NpcLev],
            {NewBossList, BossNameList} = relive_boss(BossList, NpcLev, "", PosList),
            NewGroupList = case length(BossNameList) > 0 of
                true -> 
                    notice:send(53, util:fbin(?L(<<"天地异象降临{map, ~w}，原来是世界boss~s重现人间，身上宝气冲天，似乎挟带着灵器异宝。{open, 28, 我要降服, #00ff24}">>), [MapId, list_to_bitstring(BossNameList)])),
                    lists:keyreplace(NpcLev, #boss_unlock_group.lev, GroupList, Group#boss_unlock_group{kill_time = 0, relive_time = util:unixtime()});
                false -> GroupList 
            end,
            {noreply, State#state{boss_list = NewBossList, boss_group = NewGroupList}};
        false -> 
            ?ELOG("级别状态列表缺少世界boss信息NpcLev:~w", [NpcLev]),
            {noreply, State}
    end;

handle_info({relive_boss, NpcBaseId}, State) ->
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            {ok, #boss_base{map_id = MapId, pos_list = PosList}} = boss_data:get(NpcBaseId),
            %% {X, Y} = util:rand_list(PosList),
            {X, Y} = relive_pos([], PosList),
            case npc_mgr:create(NpcBaseId, MapId, X, Y) of
                {ok, _NpcBaseId} ->
                    ?INFO("手动复活世界boss成功MapId:~w, x:~w, y:~w", [MapId, X, Y]),
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

handle_info({award_mail, NpcBaseId}, State = #state{boss_list = BossList}) ->
    NewBossList = case lists:keyfind(NpcBaseId, #boss_unlock.npc_id, BossList) of
        false ->
            ?ERR("[boss]找不到世界boss状态信息"),
            BossList;
        #boss_unlock{team_list = []} -> BossList;
        Boss = #boss_unlock{team_list = TeamList, npc_name = NpcName} ->
            Length = length(TeamList),
            Total = round((1 + Length) * Length / 2),
            Rand = util:rand(1, Total),
            Team = select_team(TeamList, 1, Rand),
            %% ?DEBUG("==================Rand:~w, Total:~w, Team:~w, TeamList:~w", [Rand, Total, Team, TeamList]),
            {Sitems, Items} = drop:produce([NpcBaseId], 100),
            S = [SGain || {_, SGain} <- Sitems],   %% 高级货
            [I] = [[NGain || NGain <- L] || {_, L} <- Items],    %% 一般货
            RTeam = util:rand_list(Team),
            AllTeam = [RTeam] ++ (Team -- [RTeam]),
            NewTeam = do_assign_gains(AllTeam, S ++ I),
            Diff = TeamList -- [Team],
            send_mail_lucky(NewTeam, NpcName),
            send_mail_empty(Diff, Team, NpcName),
            NewList = lists:keyreplace(NpcBaseId, #boss_unlock.npc_id, BossList, Boss#boss_unlock{team_list = []}),
            NewList
    end,
    {noreply, State#state{boss_list = NewBossList}};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    ?ELOG("关闭世界boss进程Reason:~w", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
%% 初始化boss信息
init_boss(State = #state{boss_list = BossList, boss_group = GroupList}, [NpcBaseId | T]) ->
    {ok, #boss_base{npc_name = NpcName, npc_lev = NpcLev, map_id = MapId, map_name = MapName, interval = Interval, pos_list = PosList}} = boss_data:get(NpcBaseId),
    {X, Y} = relive_pos([], PosList),
    case npc_mgr:create(NpcBaseId, MapId, X, Y) of
        {ok, _NpcBaseId} ->
            %% Mref = case npc_mgr:lookup(by_base_id, NpcBaseId) of
            %%     [#npc{pid = Pid}] ->
            %%         erlang:monitor(process, Pid);
            %%     _ -> 
            %%         ?ERR("没有找到世界boss信息:~w", [NpcBaseId]),
            %%         undefined 
            %% end,
            NewInterval = merge_interval(Interval),
            Boss = #boss_unlock{map_id = MapId, map_name = MapName, npc_id = NpcBaseId, npc_name = NpcName, lev = NpcLev, relive_time = util:unixtime()},
            NewGroupList = case lists:keyfind(NpcLev, #boss_unlock_group.lev, GroupList) of
                false ->
                    Group = #boss_unlock_group{lev = NpcLev, map_id = MapId, map_name = MapName, interval = NewInterval, relive_time = util:unixtime()},
                    [Group | GroupList];
                Group2 ->
                    lists:keyreplace(NpcLev, #boss_unlock_group.lev, GroupList, Group2#boss_unlock_group{relive_time = util:unixtime()})
            end,
            init_boss(State#state{boss_list = [Boss | BossList], boss_group = NewGroupList}, T);
        _ ->
            ?ERR(util:fbin(<<"创建世界Boss出错了[NpcBaseId:~w]">>, [NpcBaseId])),
            init_boss(State, T)
    end;
init_boss(State, []) ->
    State.

%% 获取重生坐标
relive_pos(BossPos, PosList) ->
    Mul = PosList -- BossPos,
    case length(Mul) > 0 of
        true -> util:rand_list(Mul);
        false -> util:rand_list(PosList)
    end.

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
concat_name2([]) -> [];
concat_name2([Name | T]) ->
    "【" ++ util:to_list(Name) ++ "】" ++ concat_name2(T).

concat_boss_name([], _NpcLev) -> "";
concat_boss_name([#boss_unlock{npc_name = NpcName, lev = NpcLev, status = Status} | T], NpcLev) when Status > 0 ->
    lists:concat(["{npc, ", binary_to_list(NpcName), ", #f65e6a}", concat_boss_name(T, NpcLev)]);
concat_boss_name([_Boss | T], NpcLev) ->
    concat_boss_name(T, NpcLev).

%% 复活
relive_boss([], _NpcLev, BossNameList, _PosList) -> {[], BossNameList};
relive_boss([Boss = #boss_unlock{npc_id = NpcBaseId, lev = NpcLev, status = Status} | T], NpcLev, BossNameList, BossPos) when Status > 0 ->
    {ok, #boss_base{npc_name = NpcName, pos_list = PosList, map_id = MapId}} = boss_data:get(NpcBaseId),
    {X, Y} = relive_pos(BossPos, PosList),
    {BossList, NewBossNameList} = relive_boss(T, NpcLev, BossNameList, [{X, Y} | PosList]),
    case npc_mgr:lookup(by_base_id, NpcBaseId) of
        false ->
            case npc_mgr:create(NpcBaseId, MapId, X, Y) of
                {ok, _NpcBaseId} ->
                    role_group:pack_cast(world, 12801, {NpcBaseId, 0}),
                    %% BossPid = case npc_mgr:lookup(by_base_id, NpcBaseId) of
                    %%     [#npc{pid = Pid}] -> Pid;
                    %%     _ -> 
                    %%         ?ELOG("没有找到世界boss信息:~w", [NpcBaseId]),
                    %%         undefined
                    %% end,
                    %% erlang:send_after(10 * 1000, self(), {combat_start, NpcBaseId}),
                    NewBoss = Boss#boss_unlock{status = 0, pos = {X, Y}, relive_time = util:unixtime(), kill_time = 0,  team_list = []},
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

convert_to_boss([]) -> [];
convert_to_boss([#boss_unlock{npc_id = NpcId, npc_name = NpcName, lev = NpcLev, status = Status, map_id = MapId, map_name = MapName} | T]) ->
    [#boss{npc_id = NpcId, npc_name = NpcName, npc_lev = NpcLev, status = Status, map_id = MapId, map_name = MapName} | convert_to_boss(T)].

%% 选择队伍
select_team([], _Index, _Rand) -> [];
select_team([Team | _T], Index, Rand) when Index >= Rand -> Team;
select_team([Team | []], _Index, _Rand) -> Team;
select_team([_Team | T], Index, Rand) ->
    select_team(T, Index + Index + 1, Rand).

%% 分配物品
do_assign_gains(TeamList, Gains) ->
    case assign_gains(TeamList, Gains) of
        {NewTeamList, []} -> NewTeamList;
        {[], _} -> [];
        {NewTeamList, NewGains} -> do_assign_gains(NewTeamList, NewGains)
    end.
assign_gains([], Gains) -> {[], Gains};
assign_gains(TeamList, []) -> {TeamList, []};
assign_gains([{RoleId, SrvId, RoleName} | T], [Gain | GT]) ->
    {NewTeamList, NewGains} = assign_gains(T, GT),
    {[{RoleId, SrvId, RoleName, [Gain]} | NewTeamList], NewGains};
assign_gains([{RoleId, SrvId, RoleName, Gains} | T], [Gain | GT]) ->
    {NewTeamList, NewGains} = assign_gains(T, GT),
    {[{RoleId, SrvId, RoleName, [Gain | Gains]} | NewTeamList], NewGains}.
    
%% 发邮件
send_mail_lucky([], _BossName) -> ok;
send_mail_lucky([{RoleId, SrvId, RoleName, Gains} | T], BossName) ->
    case make_item(Gains, RoleId, SrvId, RoleName, BossName) of
        {false, Reason} ->
            ?ERR("世界boss掉落有误:~w", [Reason]);
        ItemList ->
            mail:send_system({RoleId, SrvId}, {?L(<<"世界BOSS奖励">>), util:fbin(?L(<<"恭喜！世界BOSS【~s】在被您英勇击败后，魔魂渐渐散去，宝物浮现，您幸运的收获了战利品！">>), [BossName]), [], ItemList})
    end,
    send_mail_lucky(T, BossName);
send_mail_lucky([{RoleId, SrvId, _RoleName} | T], BossName) ->
    mail:send_system({RoleId, SrvId}, {?L(<<"世界BOSS奖励">>), util:fbin(?L(<<"恭喜！世界BOSS【~s】在被您英勇击败后，魔魂渐渐散去，宝物浮现，您幸运的收获了战利品！">>), [BossName]), [], []}),
    send_mail_lucky(T, BossName).
send_mail_evil([], _BossName) -> ok;
send_mail_evil([{RoleId, SrvId, _RoleName} | T], BossName) ->
    mail:send_system({RoleId, SrvId}, {?L(<<"世界BOSS信件">>), util:fbin(?L(<<"很遗憾，您虽然艰苦击败了世界BOSS【~s】，但由于慢人一步，宝物已经被其他仙友抢先一步夺得。">>), [BossName]), [], []}),
    send_mail_evil(T, BossName).

send_mail_empty([], _Winner, _BossName) -> ok;
send_mail_empty([Team | T], Winner, BossName) ->
    NameList = [Name || {_RoleId, _SrvId, Name} <- Winner],
    BinNameList = concat_name2(NameList),
    do_send_mail_empty(Team, BinNameList, BossName),
    send_mail_empty(T, Winner, BossName).
do_send_mail_empty([], _BinNameList, _BossName) -> ok;
do_send_mail_empty([{RoleId, SrvId, _} | T], BinNameList, BossName) ->
    mail:send_system({RoleId, SrvId}, {?L(<<"世界BOSS邮件">>), util:fbin(?L(<<"很遗憾，世界BOSS【~s】在被您英勇击败后，魔魂渐渐散去，可惜BOSS身上的宝物似乎被~s抢先一步发现并拿走了！">>), [BossName, BinNameList]), [], []}),
    do_send_mail_empty(T, BinNameList, BossName).


make_item([], _RoleId, _SrvId, _RoleName, _BossName) -> [];
make_item([#gain{label = item, val =  [ItemBaseId, Bind, Num], misc = Misc} | T], RoleId, SrvId, RoleName, BossName) ->
    case item:make(ItemBaseId, Bind, Num) of
        false -> {false, util:fbin(?L(<<"创建物品出错了[ItemBaseId:~w, Num:~w]">>), [ItemBaseId, Num])};
        {ok, [Item]} ->
            case make_item(T, RoleId, SrvId, RoleName, BossName) of
                {false, Reason} -> {false, Reason};
                ItemList -> 
                    do_misc_notic(Misc, RoleId, SrvId, RoleName, BossName),
                    [Item | ItemList]
            end;
        {ok, _Items} -> {false, util:fbin(?L(<<"创建物品出现多堆叠问题[ItemBaseId:~w, Num:~w]">>), [ItemBaseId, Num])}
    end;
make_item([_Gain | T], RoleId, SrvId, RoleName, BossName) -> make_item(T, RoleId, SrvId, RoleName, BossName).

%% 公告
do_misc_notic([], _RoleId, _SrvId, _RoleName, _BossName) -> ok;
do_misc_notic([{drop_notice, {_NpcBaseId, ItemBaseId, Bind}} | T], RoleId, SrvId, RoleName, BossName) ->
    {ok, [Item]} = item:make(ItemBaseId, Bind, 1),
    ItemMsg = notice:item_to_msg(Item),
    notice:send(53, util:fbin(?L(<<"{role, ~w, ~s, ~s, #3ad6f0}在击杀世界BOSS{npc, ~s, #f65e6a}之后，竟幸运的夺得了BOSS身上的珍稀财宝~s!">>), [RoleId, SrvId, RoleName, BossName, ItemMsg])),
    do_misc_notic(T, RoleId, SrvId, RoleName, BossName);
do_misc_notic([_Cell | T], RoleId, SrvId, RoleName, BossName) ->
    do_misc_notic(T, RoleId, SrvId, RoleName, BossName).

%% 合过服的，世界boss重生时间缩短一半
merge_interval(Interval) ->
    case util:is_merge() of
        true -> round(Interval / 2);
        _ -> Interval
    end.

%% 队伍PID
%% get_team_max_lev(TeamPid, RoleId, SrvId) ->
%%     case is_pid(TeamPid) of
%%         true ->
%%             case team:get_team_info(TeamPid) of
%%                 {ok, #team{leader = Leader, member = MemberList}} ->
%%                     MemList = [MRid || #team_member{id = MRid, mode = 0} <- [Leader | MemberList]],
%%                     case lists:member({RoleId, SrvId}, MemList) of
%%                         true -> get_team_max_lev_men([Leader | MemberList]);
%%                         false -> {0, <<>>}
%%                     end;
%%                 _ -> {0, <<>>}
%%             end;
%%         false -> {0, <<>>}
%%     end.
%% get_team_max_lev_men([]) -> {0, <<>>};
%% get_team_max_lev_men([#team_member{lev = Lev, name = Name, mode = 0} | T]) ->
%%     {MLev, Mname} = get_team_max_lev_men(T),
%%     case MLev > Lev of
%%         true -> {MLev, Mname};
%%         false -> {Lev, Name}
%%     end;
%% get_team_max_lev_men([_Team | T]) ->
%%     get_team_max_lev_men(T).

