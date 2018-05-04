%%----------------------------------------------------
%% @doc 世界boss全局管理
%%
%% <pre>
%% 世界boss全局管理
%% </pre> 
%% @author mobin
%% @end
%%----------------------------------------------------
-module(super_boss_mgr).

-behaviour(gen_fsm).

-export([
        start_link/0,
        stop/0,
        enter_combat_area/2,
        exit_combat_area/1,
        login/1,
        logout/1,
        boss_die/0,
        combat_over/1,
        send_info/4,
        get_rank_data/2,
        get_summary_data/2,
        get_reward/3,
        get_all_boss_status/0,
        get_activity_status/1,
        push_activity_status/1,
        sort_num/1,
        gm_kill_boss/0,
        gm_clear_count/1,
        set_left_time/2,
        pause/0,
        print_left_time/0,
        idle/2,
        active/2,
        wait/2,
        ultimate/2
    ]
).

-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-include("common.hrl").
-include("boss.hrl").
-include("role.hrl").
-include("assets.hrl").
-include("pos.hrl").
-include("map.hrl").
-include("combat.hrl").
-include("npc.hrl").
-include("link.hrl").
-include("gain.hrl").
-include("item.hrl").
-include("boss_config.hrl").
-include("boss_lang.hrl").
-include("role_online.hrl").
-include("guild.hrl").
-include("rank.hrl").
-include("unlock_lev.hrl").

-define(active_end_time, {1, 0, 0}).
-define(ultimate_end_time, {2, 0, 0}).
-define(wait_timer, 30 * 60 * 1000).
-define(active_count_limit, 2).
-define(ultimate_count_limit, 3).

-define(sync_db_interval, 500). %% 每次写到db的间隔时间（毫秒）
-define(sync_db_count, 50).     %% 每次写到db的数量

-define(idle_status, 0).
-define(wait_status, 5).
-define(ultimate_status, 6).

-define(dets_file, "../var/super_boss.dets").

-record(state, {
        begin_time, 
        duration,
        count = 0,           %% boss个数
        taken = [],          %%是否已领奖励[Rid ..]
        is_always_idle = false
    }
).


%%------------------------------------------------------
%% 外部方法
%%------------------------------------------------------
%% @doc 启动超级世界boss管理进程
start_link()->
    gen_fsm:start_link({global, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_fsm:send_all_state_event({global, ?MODULE}, stop).


%% 进入战斗区域
enter_combat_area(Role, NpcBaseId) ->
    gen_fsm:send_event({global, ?MODULE}, {enter_combat_area, Role, NpcBaseId}),
    {ok}.

%% 退出战斗区域
exit_combat_area(_Role = #role{id = Rid, event_pid = SuperBossPid}) ->
    SuperBossPid ! {exit_combat_area, Rid},
    {ok};
%% 结束战斗后退出
exit_combat_area(Rid) ->
    case ets:lookup(super_boss_role, Rid) of
        %%超时会被删除
        [#super_boss_role{boss_pid = SuperBossPid}] when is_pid(SuperBossPid)->
            SuperBossPid ! {exit_combat_area, Rid};
        _ ->
            ignore
    end.

%% 登陆
login(Role = #role{event = ?event_super_boss, status = ?status_die, hp_max = HpMax}) ->
    login(Role#role{status = ?status_normal, hp = HpMax});
login(Role = #role{id = Rid, pid = Pid, event = ?event_super_boss, link = #link{conn_pid = ConnPid}, 
        pos = Pos = #pos{last = {LastMapId, LastX, LastY}}}) ->
    %%推送12860
    push_activity_status(Role),
    case ets:lookup(super_boss_role, Rid) of
        [#super_boss_role{boss_pid = SuperBossPid, enter_time = EnterTime, reward = Reward}] when is_pid(SuperBossPid)->
            SuperBossPid ! {login, Rid, Pid, ConnPid, EnterTime, Reward},
            Role#role{event_pid = SuperBossPid};
        _ ->
            Role#role{pos = Pos#pos{map = LastMapId, x = LastX, y = LastY}, event = ?event_no, event_pid = 0}
    end;
login(Role) ->
    %%推送12860
    push_activity_status(Role),
    Role.

%% 下线
logout(_Role) ->
    _Role.

%% boss死亡处理
boss_die() ->
    gen_fsm:send_event({global, ?MODULE}, {boss_die}).

%% 角色战斗结束处理
combat_over(#combat{loser = Loser}) ->
    RoleFighters = [F || F =#fighter{type = Type} <- Loser, Type =:= ?fighter_type_role],
    %%世界Boss每次战斗只可能有一个角色参战
    case RoleFighters of
        [F = #fighter{type = ?fighter_type_role, is_die = ?true, rid = RoleId, srv_id = SrvId}] ->
            case ets:lookup(super_boss_role, {RoleId, SrvId}) of
                [#super_boss_role{boss_pid = BossPid}] when is_pid(BossPid)->
                    BossPid ! {role_die, F};
                _ ->
                    ignore
            end;
        _ ->
            ignore
    end,
    ok.

send_info(NpcBaseId, KillCount, Reward, Ranks) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, {send_info, NpcBaseId, KillCount, Reward, Ranks}).

%% 获取排行数据
get_rank_data(PageIndex, ConnPid) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, {get_rank_data, PageIndex, ConnPid}).

get_summary_data(Rid, ConnPid) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, {get_summary_data, Rid, ConnPid}).

get_reward(Rid, RolePid, ConnPid) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, {get_reward, Rid, RolePid, ConnPid}).

get_all_boss_status() ->
    ets:tab2list(super_boss_status).

%% 获取世界boss活动状态
get_activity_status(#role{id = Rid, link = #link{conn_pid = ConnPid}}) ->
    gen_fsm:send_all_state_event({global, ?MODULE}, {get_activity_status, Rid, ConnPid}).

push_activity_status(#role{id = Rid, lev = Lev, link = #link{conn_pid = ConnPid}}) ->
    UnlockLev = ?boss_unlock_lev,
    case Lev < UnlockLev of 
        true ->
            ignore;
        false ->
            gen_fsm:send_all_state_event({global, ?MODULE}, {push_activity_status, Rid, ConnPid})
    end.

sort_num(Rid) ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, {sort_num, Rid}).

gm_kill_boss() ->
    SuperBosses = ets:tab2list(super_boss),
    lists:foreach(fun({_, BossPid}) ->
                BossPid ! gm_kill_boss
        end, SuperBosses).

gm_clear_count(Rid) ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, {gm_clear_count, Rid}).

%% 设置Timeout时间
set_left_time(LeftTime, BossCount) ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, {set_left_time, LeftTime, BossCount}).

%% 设置暂停活动直到重新开服 
pause() ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, pause).

%% 打印空闲时间 
print_left_time() ->
    gen_fsm:sync_send_all_state_event({global, ?MODULE}, print_left_time).

%%------------------------------------------------------
%% 状态机消息处理
%%------------------------------------------------------
init([]) ->
    ?INFO("[~w] 正在启动...", [?MODULE]),
    process_flag(trap_exit, true), %% 设置捕捉super_boss进程退出消息

    load_last_rank(),

    %%boss [{base_id pid} ...]
    ets:new(super_boss, [set, named_table, public, {keypos, 1}]),
    %%boss血量
    ets:new(super_boss_status, [set, named_table, public, {keypos, 1}]),

    ets:new(super_boss_role, [set, named_table, public, {keypos, #super_boss_role.rid}]),

    Now = util:unixtime(),
    %%全服奖励
    Taken = case filelib:is_file(?dets_file) of
        true ->
            dets:open_file(?MODULE, [{file, ?dets_file}]), 
            _Taken2 = case dets:lookup(?MODULE, taken) of
                [{taken, _Taken, LastTime}] ->
                    case util:is_same_day2(LastTime, Now) of
                        true ->
                            _Taken;
                        false ->
                            []
                    end;
                _ ->
                    []
            end,
            dets:close(?MODULE),
            file:delete(?dets_file),
            _Taken2;
        false ->
            []
    end,
    ?DEBUG("super_boss taken ~w", [Taken]),

    {StartHour, _} = ?start_time,
    Duration = case (util:unixtime({today, Now}) + StartHour * 3600) > Now of
        true -> 
            get_duration(get_start_time());
        false ->
            %%开服后15分钟开始活动
            15 * 60 * 1000
    end,
    ?INFO("[~w] 启动完成...", [?MODULE]),
    {ok, idle, #state{begin_time = erlang:now(), duration = Duration, taken = Taken}, Duration}.

handle_event({push_activity_status, Rid, ConnPid}, StateName, State = #state{count = Count, begin_time = BeginTime, duration = Duration}) ->
    Reply = case StateName of
        idle -> %% 活动未开始或已经结束
            {?idle_status, 0};
        active -> %% 活动已经开始
            {Count, get_left_count(Rid, active)};
        wait ->
            {?wait_status, (util:time_left(Duration, BeginTime) div 1000)};
        ultimate ->
            {?ultimate_status, get_left_count(Rid, ultimate)}
    end,
    sys_conn:pack_send(ConnPid, 12860, Reply),
    continue(StateName, State);

handle_event({get_activity_status, Rid, ConnPid}, StateName, State = #state{count = Count, 
        begin_time = BeginTime, duration = Duration, taken = Taken}) ->
    {Status, Left} = case StateName of
        idle -> %% 活动未开始或已经结束
            {?idle_status, 0};
        active -> %% 活动已经开始
            {Count, get_left_count(Rid, active)};
        wait ->
            {?wait_status, (util:time_left(Duration, BeginTime) div 1000)};
        ultimate ->
            {?ultimate_status, get_left_count(Rid, ultimate)}
    end,

    IsTaken = case get(last_summary) of
        undefined ->
            ?true;
        #super_boss_summary{killed_boss_count = KilledBossCount} ->
            %%杀龙数为0时没有奖励
            case (KilledBossCount =:= 0 orelse lists:member(Rid, Taken)) of
                true ->
                    ?true;
                false ->
                    ?false
            end
    end,
    sys_conn:pack_send(ConnPid, 12859, {Status, Left, IsTaken}),
    continue(StateName, State);

handle_event({get_rank_data, PageIndex, ConnPid}, StateName, State) ->
    [PageNum, Data] = case get(page) of
        {_Total, _PageNum} ->
            case get({page, PageIndex}) of
                undefined -> 
                    [_PageNum, []];
                L ->
                    [_PageNum, L]
            end;
        _ ->
            [1, []]
    end,
    sys_conn:pack_send(ConnPid, 12870, {PageNum, Data}),
    continue(StateName, State);

handle_event({get_summary_data, _Rid, ConnPid}, StateName, State) ->
    case get(last_summary) of
        undefined ->
            notice:alert(error, ConnPid, ?MSGID(<<"暂时没有相关内容">>));
        #super_boss_summary{boss_count = BossCount, killed_boss_count = KilledBossCount, kill_count = KillCount,
            reward_count = RewardCount} ->
            ProtoInfos = get(last_info),
            KillCount2 = util:floor(math:pow(KillCount, ?kill_count_index) * ?kill_count_factor),
            sys_conn:pack_send(ConnPid, 12871, {BossCount, KilledBossCount, KillCount2,
                    RewardCount, ProtoInfos})
    end,
    continue(StateName, State);

handle_event({get_reward, Rid, Pid, ConnPid}, StateName, State = #state{taken = Taken}) ->
    State2 = case get(last_summary) of
        undefined ->
            State;
        #super_boss_summary{killed_boss_count = KilledBossCount} ->
            case lists:member(Rid, Taken) of
                true ->
                    notice:alert(error, ConnPid, ?MSGID(<<"您已领取相关奖励，请期待明天的战况。">>)),
                    State;
                false ->
                    {Coin, Scale} = ?coin_and_scale,
                    role:apply(async, Pid, {fun async_get_reward/3, [Coin * KilledBossCount, Scale * KilledBossCount]}),
                    sys_conn:pack_send(ConnPid, 12872, {}),
                    State#state{taken = [Rid | Taken]}
            end
    end,
    continue(StateName, State2);

handle_event({send_info, NpcBaseId, NewKillCount, Reward, Ranks}, StateName, State) ->
    %%更新摘要
    Summary = #super_boss_summary{kill_count = KillCount, reward_count = RewardCount} = get(summary),
    put(summary, Summary#super_boss_summary{kill_count = KillCount + NewKillCount,
            reward_count = RewardCount + Reward}),

    %%更新排行榜
    save_rank_to_dict(Ranks),

    %%清理ETS
    ets:delete(super_boss, NpcBaseId),
    ets:delete(super_boss_status, NpcBaseId),
    continue(StateName, State);

handle_event(_Event, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效事件:~w", [StateName, _Event]),
    continue(StateName, State).

handle_sync_event({sort_num, Rid}, _From, StateName, State) ->
    Reply = case get(rank_index) of
        L when is_list(L) ->
            case lists:keyfind(Rid, 1, L) of
                {Rid, Index} ->
                    Index;
                _ ->
                    0
            end;
        _ ->
            0
    end,
    continue(Reply, StateName, State);

handle_sync_event({gm_clear_count, Rid}, _From, StateName, State) ->
    put(Rid, 0),
    continue(ok, StateName, State);

%% 设置Timeout时间
handle_sync_event({set_left_time, LeftTime, BossCount}, _From, StateName, State) ->
    Duration = LeftTime * 1000,
    case StateName of
        idle ->
            case get(last_summary) of
                undefined ->
                    put(last_summary, #super_boss_summary{next_count = BossCount});
                Summary ->
                    put(last_summary, Summary#super_boss_summary{next_count = BossCount})
            end;
        _ ->
            ignore
    end,
    ?INFO("世界boss [~w] 时间更新成功:~w", [StateName, Duration]),
    continue(ok, StateName, State#state{begin_time = erlang:now(), duration = Duration});

%% 设置暂停活动直到重新开服 
handle_sync_event(pause, _From, StateName, State) ->
    continue(ok, StateName, State#state{is_always_idle = true});

%% 打印Timeout时间 
handle_sync_event(print_left_time, _From, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    TimeOut = util:time_left(Duration, BeginTime),
    ?INFO("世界boss状态~w的Timeout时间:~w", [StateName, TimeOut / 1000 / 3600]),
    continue(ok, StateName, State);

handle_sync_event(_Event, _From, StateName, State) ->
    continue(ok, StateName, State).

handle_info(cast_anime, active, State) ->
    %%通知客户端播放动画
    role_group:pack_cast(world, 12861, {1}),

    AnimeCount = get(anime_count),
    AnimeCount2 = AnimeCount + 1,
    case AnimeCount2 =< length(?anime_time_list) of
        false ->
            ignore;
        true ->
            set_anime_timer(AnimeCount2)
    end,

    continue(active, State);

%%1. 子进程自我清理，保存Summary
%%2. 主进程保存Summary
%%3. 保存排行榜
%%4. 加载排行榜并发放奖励
handle_info({save_summary, Msg}, StateName, State) ->
    case ets:first(super_boss) of
        '$end_of_table' ->
            %%保存摘要
            role_group:pack_cast(world, 10932, {7, 1, Msg}),
            super_boss_dao:save_summary(get(summary)),
            self() ! {save_rank_to_db, get(ranks)};
        _ ->
            erlang:send_after(1000, self(), {save_summary, Msg})
    end,
    continue(StateName, State);

handle_info({save_rank_to_db, Ranks = [_ | _]}, StateName, State) ->
    N = min(length(Ranks), ?sync_db_count),
    {Ranks1, Ranks2} = lists:split(N, Ranks),
    save_rank_to_db(Ranks1),
    erlang:send_after(?sync_db_interval, self(), {save_rank_to_db, Ranks2}),
    continue(StateName, State);
handle_info({save_rank_to_db, []}, StateName, State) ->
    %%清除进程字典
    erase(),

    %%保护处理
    case ets:first(super_boss_role) of
        '$end_of_table' ->
            ignore;
        _ ->
            %%不可能发生的情况
            ?ERR("super_boss_role没有清理完，存在问题"),
            ets:delete_all_objects(super_boss_role)
    end,

    self() ! load_last_rank,
    continue(StateName, State);

%% 处理计算排行榜消息
handle_info(load_last_rank, StateName, State) ->
    Infos = load_last_rank(),
    ?DEBUG("排行榜得到刷新:~w", [StateName]),

    %% 延迟一会，发放奖励
    erlang:send_after(1000, self(), {send_reward, Infos}),
    continue(StateName, State#state{taken = []});

handle_info(ultimate_rumor, StateName, State) ->
    role_group:pack_cast(world, 10932, {7, 1, ?super_boss_wait}),
    continue(StateName, State);

handle_info({send_reward, Infos}, StateName, State) ->
    %%发放奖励
    {BestRewardId, LastRewardId} = ?rewards_id,
    lists:foreach(fun(#super_boss_info{best_rid = BestRid, last_rid = LastRid}) ->
                case BestRid of
                    {0, _} ->
                        ignore;
                    _ ->
                        award:send(BestRid, BestRewardId)
                end,
                case LastRid of
                    {0, _} ->
                        ignore;
                    _ ->
                        award:send(LastRid, LastRewardId)
                end
        end, Infos),
    continue(StateName, State);

handle_info(_Info, StateName, State) ->
    ?DEBUG("在[~w]状态下收到无效消息:~w", [StateName, _Info]),
    continue(StateName, State).

terminate(_Reason, StateName, _State = #state{taken = Taken}) ->
    ?DEBUG("super_boss_mgr close[~w] taken[~w]", [_Reason, Taken]),
    %%保存之前的全服奖励
    dets:open_file(?MODULE, [{file, ?dets_file}]), 
    dets:insert(?MODULE, {taken, Taken, util:unixtime()}),
    dets:close(?MODULE),

    case (StateName =:= active) orelse (StateName =:= ultimate) of
        true ->
            SuperBosses = ets:tab2list(super_boss),
            lists:foreach(fun({_, BossPid}) ->
                        case is_pid(BossPid) andalso erlang:is_process_alive(BossPid) of
                            true ->
                                gen_server:call(BossPid, {stop_directly});
                            _ ->
                                ignore
                        end
                end, SuperBosses);
        false ->
            ignore
    end,
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%----------------------------------------------------
%% 状态处理
%%----------------------------------------------------
%% 空闲时间
idle(timeout, State = #state{is_always_idle = true}) ->
    {next_state, idle, State};
idle(timeout, State) ->
    %%清除老数据
    ?INFO("世界boss活动开启前清除旧数据..."),
    clear_old_rank_data(),
    ?INFO("清除旧数据完毕"),

    NextCount = case get(last_summary) of
        undefined ->
            1;
        #super_boss_summary{next_count = _NextCount} ->
            _NextCount
    end,

    #super_boss_summary{id = SummaryId} = create_new_summary(NextCount),

    case create_super_boss(NextCount, SummaryId) of
        false ->
            lists:foreach(fun({_NpcBaseId, Pid}) ->
                        Pid ! stop
                end, ets:tab2list(super_boss)),
            ets:delete_all_objects(super_boss),

            Duration = get_duration(get_start_time()),
            continue(idle, State#state{begin_time = erlang:now(), duration = Duration});
        _ ->
            put(ranks, []),

            %%通知客户端播放动画
            role_group:pack_cast(world, 12861, {NextCount}),
            %%传闻
            Msg = util:fbin(?super_boss_start, [notice_color:get_color_item(5)]),
            role_group:pack_cast(world, 10932, {7, 1, Msg}),
            %%推送状态
            broadcast_12860(active, NextCount),

            set_anime_timer(1),

            Duration = get_tomorrow_duration(?active_end_time),
            continue(active, State#state{count = NextCount, begin_time = erlang:now(), duration = Duration})
    end;
idle(_Any, State) ->
    continue(idle, State).

active({enter_combat_area, Role = #role{id = Rid, pid = RolePid, link = #link{conn_pid = ConnPid}}, NpcBaseId}, State = #state{count = Count}) ->
    case add_enter_count(Rid, active) of
        true ->
            sys_conn:pack_send(ConnPid, 12860, {Count, get_left_count(Rid, active)}),
            case ets:lookup(super_boss, NpcBaseId) of
                [{_, BossPid}] when is_pid(BossPid) ->
                    %%触发其它模块
                    role:apply(async, RolePid, {fun async_trigger/1, []}),
                    
                    BossPid ! {enter_combat_area, to_super_boss_area_role(Role)};
                _ ->
                    ignore
            end;
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"已达到当天进入上限">>))
    end,
    continue(active, State);
active({boss_die}, State) ->
    %%更新被杀Boss数
    Summary = #super_boss_summary{boss_count = BossCount, killed_boss_count = KilledBossCount} = get(summary),
    KilledBossCount2 = KilledBossCount + 1,
    put(summary, Summary#super_boss_summary{killed_boss_count = KilledBossCount2}),

    %%清掉所有Boss
    case BossCount =:= KilledBossCount2 of
        true ->
            clear_all_super_boss(),
            erlang:send_after(5000, self(), ultimate_rumor),

            %%推送状态
            broadcast_12860(wait, 0),

            Duration2 = ?wait_timer,
            continue(wait, State#state{begin_time = erlang:now(), duration = Duration2});
        false ->
            continue(active, State)
    end;
active(timeout, State) ->
    stop_activity(active, ?super_boss_timeout),

    Duration = get_duration(get_start_time()),

    %%推送状态
    broadcast_12860(idle, 0),

    continue(idle, State#state{begin_time = erlang:now(), duration = Duration});
active(_Any, State) ->
    continue(active, State).

wait(timeout, State) ->
    Summary = #super_boss_summary{id = SummaryId, boss_count = BossCount} = get(summary),
    {NpcBaseId, MapBaseId} = ?ultimate_config,

    case super_boss:start_link(NpcBaseId, MapBaseId, SummaryId, ?true) of
        {ok, Pid} ->
            ?DEBUG("创建世界boss[NpcBaseId=~w]成功", [NpcBaseId]),
            put(summary, Summary#super_boss_summary{boss_count = BossCount + 1}),

            ets:insert(super_boss, {NpcBaseId, Pid}),
            role_group:pack_cast(world, 12861, {?ultimate_status}),

            %%传闻
            Msg = util:fbin(?super_boss_start, [notice_color:get_color_item(5)]),
            role_group:pack_cast(world, 10932, {7, 1, Msg}),

            %%推送状态
            broadcast_12860(ultimate, 0),

            Duration = get_tomorrow_duration(?ultimate_end_time),
            continue(ultimate, State#state{begin_time = erlang:now(), duration = Duration});
        _Err -> 
            ?ELOG("创建超级世界boss[NpcBaseId=~w]失败:~w", [NpcBaseId, _Err]),
            Duration = get_duration(get_start_time()),
            continue(idle, State#state{begin_time = erlang:now(), duration = Duration})
    end;
wait(_Any, State) ->
    continue(wait, State).

ultimate({enter_combat_area, Role = #role{id = Rid, pid = RolePid, link = #link{conn_pid = ConnPid}}, NpcBaseId}, State) ->
    case add_enter_count(Rid, ultimate) of
        true ->
            sys_conn:pack_send(ConnPid, 12860, {?ultimate_status, get_left_count(Rid, ultimate)}),
            case ets:lookup(super_boss, NpcBaseId) of
                [{_, BossPid}] when is_pid(BossPid) ->
                    %%触发其它模块
                    role:apply(async, RolePid, {fun async_trigger/1, []}),

                    BossPid ! {enter_combat_area, to_super_boss_area_role(Role)};
                _ ->
                    ignore
            end;
        false ->
            notice:alert(error, ConnPid, ?MSGID(<<"已达到当天进入上限">>))
    end,
    continue(ultimate, State);
ultimate(timeout, State) ->
    stop_activity(ultimate, ?super_boss_ultimate),

    %%推送状态
    broadcast_12860(idle, 0),

    Duration = get_duration(get_start_time()),
    continue(idle, State#state{begin_time = erlang:now(), duration = Duration});
ultimate(_Any, State) ->
    continue(ultimate, State).

%%------------------------------------------------------
%% 内部方法
%%------------------------------------------------------
continue(Reply, StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {reply, Reply, StateName, State, util:time_left(Duration, BeginTime)}.
continue(StateName, State = #state{begin_time = BeginTime, duration = Duration}) ->
    {next_state, StateName, State, util:time_left(Duration, BeginTime)}.

get_start_time() ->
    {Start, End} = ?start_time,
    {util:rand(Start, End - 1), util:rand(0, 59), util:rand(0, 59)}.

get_duration(_NextTime = {Hour, Min, Sec}) ->
    Now = util:unixtime(),
    Today = util:unixtime({today, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    Duration = case (Today + Time) > Now of
        true -> 
            Today + Time - Now;
        false ->
            Tomorrow = util:unixtime({tomorrow, Now}),
            Tomorrow + Time - Now
    end,
    Duration * 1000.

get_tomorrow_duration({Hour, Min, Sec}) ->
    Now = util:unixtime(),
    Tomorrow = util:unixtime({tomorrow, Now}),
    Time = Hour * 3600 + Min * 60 + Sec,
    Duration = Tomorrow + Time - Now,
    Duration * 1000.

async_trigger(Role) ->
    %%军团目标监听
    role_listener:guild_gc(Role, {}),

    Role1 = role_listener:special_event(Role, {2008, 1}),   %%任务触发
    Role2 = role_listener:special_event(Role1, {3002, 1}),  %% 触发日常
    %%勋章处理监听
    random_award:dragon_boss(Role2),
    log:log(log_activity_activeness, {<<"守城伐龙玩法">>, 5, Role2}),
    medal:join_activity(Role2, dragon_boss).

broadcast_12860(StateName, Count) ->
    lists:foreach(fun(#role_online{id = Rid, pid = Pid, lev = Lev}) ->
                UnlockLev = ?boss_unlock_lev,
                case Lev < UnlockLev of 
                    true ->
                        ignore;
                    false ->
                        Reply = case StateName of
                            idle -> %% 活动未开始或已经结束
                                {?idle_status, 0};
                            active -> %% 活动已经开始
                                {Count, get_left_count(Rid, active)};
                            wait ->
                                %%推送的倒计时是不准的,必须重新请求
                                {?wait_status, ?wait_timer div 1000};
                            ultimate ->
                                {?ultimate_status, get_left_count(Rid, ultimate)}
                        end,
                        role:pack_send(Pid, 12860, Reply)
                end
        end, ets:tab2list(role_online)).

create_super_boss(Count, SummaryId) ->
    create_super_boss(Count, SummaryId, super_boss_data:scenes()).
create_super_boss(Count, _, _Scenes) when Count =:= 0 ->
    ok;
create_super_boss(Count, SummaryId, Scenes) ->
    NpcBaseId = super_boss_data:boss(Count),

    RandValue = util:rand(1, length(Scenes)),
    MapBaseId = lists:nth(RandValue, Scenes),
    Scenes2 = lists:delete(MapBaseId, Scenes),

    case super_boss:start_link(NpcBaseId, MapBaseId, SummaryId, ?false) of
        {ok, Pid} ->
            ?DEBUG("创建超级世界boss[NpcBaseId=~w]成功", [NpcBaseId]),
            ets:insert(super_boss, {NpcBaseId, Pid}),
            create_super_boss(Count - 1, SummaryId, Scenes2); 
        _Err -> 
            ?ELOG("创建超级世界boss[NpcBaseId=~w]失败:~w", [NpcBaseId, _Err]),
            false
    end.

stop_activity(Status, Msg) ->
    %%计算下一次进攻Boss数
    Summary = #super_boss_summary{boss_count = BossCount} = get(summary),
    Odds = case Status of
        active ->
            super_boss_data:alive_odds(BossCount);
        ultimate ->
            super_boss_data:killed_odds(BossCount - 1)
    end,
    NextCount = get_next_count(Odds),
    put(summary, Summary#super_boss_summary{next_count = NextCount}),

    clear_all_super_boss(),
    erlang:send_after(2000, self(), {save_summary, Msg}).


get_enter_count_limit(Status) ->
    case Status of
        active ->
            ?active_count_limit;
        ultimate ->
            ?ultimate_count_limit
    end.

get_left_count(Rid, Status) ->
    EnterCount = case get(Rid) of
        undefined ->
            0;
        _EnterCount ->
            _EnterCount
    end,
    get_enter_count_limit(Status) - EnterCount.

add_enter_count(Rid, Status) ->
    Limit = get_enter_count_limit(Status),
    case get(Rid) of
        undefined ->
            put(Rid, 1),
            true;
        EnterCount when EnterCount < Limit ->
            put(Rid, EnterCount + 1),
            true;
        _ ->
            false
    end.

%% 保存成新概要，待活动结束后替代旧概要
create_new_summary(BossCount) ->
    Summary = #super_boss_summary{start_time = util:unixtime(), boss_count = BossCount},
    super_boss_dao:save_summary(Summary),
    NewSummary = super_boss_dao:load_last_summary(),
    put(summary, NewSummary),
    NewSummary.

save_rank_to_dict(Ranks) -> 
    NewRanks = case get(ranks) of
        undefined -> 
            save_rank_to_dict(Ranks, []);
        L -> 
            save_rank_to_dict(Ranks, L)
    end,
    put(ranks, NewRanks).
save_rank_to_dict([], NewRanks) ->
    NewRanks;
save_rank_to_dict([Rank = #super_boss_rank{rid = Rid, total_dmg = TotalDmg} | T], OldRanks) ->
    case lists:keyfind(Rid, #super_boss_rank.rid, OldRanks) of
        #super_boss_rank{total_dmg = OldTotalDmg} ->
            NewTotalDmg = OldTotalDmg + TotalDmg,
            NewRanks = lists:keyreplace(Rid, #super_boss_rank.rid, OldRanks, Rank#super_boss_rank{total_dmg = NewTotalDmg}),
            save_rank_to_dict(T, NewRanks);
        false ->
            save_rank_to_dict(T, [Rank | OldRanks])
    end.

%% 分批保存排行榜数据到db -> 剩下还没保存的数据 [#super_boss_rank{}]
save_rank_to_db(Ranks) ->
    lists:foreach(fun(Rank) ->
                super_boss_dao:save_rank(Rank)
        end, Ranks). 

clear_all_super_boss() ->
    SuperBosses = ets:tab2list(super_boss),
    lists:foreach(fun({_, BossPid}) ->
                BossPid ! timeout
        end, SuperBosses).
    
%% 清除旧数据
%% 超过10条时才需要清理
clear_old_rank_data() ->
    Off = 10,
    case get(last_summary) of
        #super_boss_summary{id = SummaryId} when SummaryId > Off ->
            DeleteId = SummaryId - Off,
            super_boss_dao:delete_old_summary(DeleteId),
            super_boss_dao:delete_old_info(DeleteId),
            super_boss_dao:delete_old_rank(DeleteId);
        _ -> 
            ignore
    end.

%% 读取上次的排行榜
load_last_rank() ->
    LastSummary = super_boss_dao:load_last_normal_summary(),
    put(last_summary, LastSummary),
    
    case LastSummary of
        undefined ->
            put(last_info, []),
            init_rank_index([]),
            init_page_data([], ?rank_row_count),
            [];
        #super_boss_summary{id = SummaryId} ->
            Infos = super_boss_dao:load_all_info(SummaryId),

            %% 初始化个人总伤害排行榜分页数据
            Ranks = super_boss_dao:load_all_rank(SummaryId, 300),
            ProtoInfos = get_proto_infos(Infos, Ranks, SummaryId),
            
            put(last_info, ProtoInfos),
            init_rank_index(Ranks),
            init_page_data(Ranks, ?rank_row_count),
            Infos
    end.

%%初始化个人排行位置
init_rank_index(Ranks) ->
    Return = init_rank_index(Ranks, 1, []),
    put(rank_index, Return).
init_rank_index([], _, Return) ->
    Return;
init_rank_index([#super_boss_rank{rid = Rid} | T], Index, Return) ->
    init_rank_index(T, Index + 1, [{Rid, Index} | Return]).

%% 初始化排行榜分页数据 -> {总数据量，页数}
init_page_data(Ranks, PageSize) ->
    Ranks1 = get_proto_ranks(Ranks),
    PageNum = init_page_data(Ranks1, [], PageSize, 0, 1),
    Total = length(Ranks1),
    put(page, {Total, PageNum}),
    {Total, PageNum}.
init_page_data([], PageData, _PageSize, _CurPageSize, CurPage) ->
    PageData1 = lists:reverse(PageData),
    put({page, CurPage}, PageData1),
    CurPage;
init_page_data([Rank | T], PageData, PageSize, CurPageSize, CurPage) when CurPageSize < PageSize ->
    init_page_data(T, [Rank | PageData], PageSize, CurPageSize + 1, CurPage);
init_page_data([Rank | T], PageData, PageSize, CurPageSize, CurPage) when CurPageSize =:= PageSize ->
    PageData1 = lists:reverse(PageData),
    put({page, CurPage}, PageData1),
    init_page_data([Rank | T], [], PageSize, 0, CurPage + 1).

get_proto_ranks(Ranks) ->
    get_proto_ranks(Ranks, []).
get_proto_ranks([], Return) ->
    lists:reverse(Return);
get_proto_ranks([#super_boss_rank{rid = {RoleId, SrvId}, total_dmg = TotalDmg, name = Name, guild_name = GuildName, career = Career} | T], Return) ->
    get_proto_ranks(T, [{SrvId, RoleId, Name, Career, GuildName, TotalDmg} | Return]).
    
get_proto_infos(Infos, Ranks, SummaryId) ->
    get_proto_infos(Infos, Ranks, SummaryId, []).
get_proto_infos([], _Ranks, _SummaryId, Return) ->
    Return;
get_proto_infos([#super_boss_info{npc_base_id = NpcBaseId, invaid_map_id = InvaidMapId, kill_count = KillCount,
        last_rid = LastRid, best_rid = BestRid} | T], Ranks, SummaryId, Return) ->
    RoleList = case LastRid of
        {0, _} ->
            [];
        _ ->
            [get_role_info(LastRid, Ranks, SummaryId)]
    end,
    RoleList2 = case BestRid of
        {0, _} ->
            RoleList;
        _ ->
            [get_role_info(BestRid, Ranks, SummaryId) | RoleList]
    end,

    KillCount2 = util:floor(math:pow(KillCount, ?kill_count_index) * ?kill_count_factor),
    get_proto_infos(T, Ranks, SummaryId, [{NpcBaseId, InvaidMapId, KillCount2, RoleList2} | Return]).

get_next_count(Odds) ->
    Rands = [Rand || {_, Rand} <- Odds],
    SumRand = lists:sum(Rands),

    RandValue = case SumRand > 0 of
        true -> util:rand(1, SumRand);
        false -> 1
    end,
    get_next_count(RandValue, Odds).
get_next_count(RandValue, [{Count, Rand} | T]) when RandValue =< Rand orelse T =:= [] ->
    Count;
get_next_count(RandValue, [{_, Rand} | T]) ->
    get_next_count(RandValue - Rand, T).

get_role_info(Rid, Ranks, SummaryId) ->
    case lists:keyfind(Rid, #super_boss_rank.rid, Ranks) of
        #super_boss_rank{name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks} ->
            {Name, Lev, Career, Sex, Looks};
        false ->
            case super_boss_dao:select_from_rank(SummaryId, Rid) of
                [Info|_] ->
                    #super_boss_rank{name = Name, lev = Lev, career = Career, sex = Sex, looks = Looks} = Info,
                    {Name, Lev, Career, Sex, Looks};
                _ -> 
                    {<<>>, 1, 2, 0, []}
            end
    end.

set_anime_timer(AnimeCount) ->
    put(anime_count, AnimeCount),
    {Start, End} = lists:nth(AnimeCount, ?anime_time_list),
    NextTime = {util:rand(Start, End - 1), util:rand(0, 59), util:rand(0, 59)},
    ?DEBUG("下一个世界Boss动画播放时间[~w]", [NextTime]),
    erlang:send_after(get_duration(NextTime), self(), cast_anime).

async_get_reward(Role = #role{assets = Assets = #assets{scale = Scale, coin = Coin}}, GainCoin, GainScale) ->
    Role1 = Role#role{assets = Assets#assets{scale = Scale + GainScale, coin = Coin + GainCoin}},
    role_api:push_assets(Role, Role1),
    log:log(log_coin, {<<"守城伐龙">>, <<"守城伐龙">>, Role, Role1}),
    {ok, Role1}.

%% 转换为战斗区域玩家
to_super_boss_area_role(#role{id = Rid, pid = Pid, link = #link{conn_pid = ConnPid}, name = Name,
        lev = Lev, sex = Sex, career = Career, looks = Looks, eqm = Eqm, guild = Guild}) ->
    GuildName = case Guild of
        #role_guild{name = GName} -> 
            GName;
        _ ->
            <<>>
    end,
    #super_boss_area_role{rid = Rid, pid = Pid, name = Name, conn_pid = ConnPid, lev = Lev, sex = Sex,
        career = Career, guild_name = GuildName, looks = Looks, eqm = Eqm}.
