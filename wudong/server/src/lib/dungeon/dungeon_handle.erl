%%%-------------------------------------------------------------------
%%% @author fancy
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% 副本基础逻辑
%%% @end
%%% Created : 21. 九月 2015 下午5:08
%%%-------------------------------------------------------------------
-module(dungeon_handle).
-author("fancy").
-include("common.hrl").
-include("dungeon.hrl").
-include("task.hrl").
-include("scene.hrl").
-include("kindom_guard.hrl").
-include("guild.hrl").
%% API
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%检查进入
handle_call({check_enter, SceneId}, _From, State) ->
    case lists:keyfind(SceneId, 2, State#st_dungeon.scene_list) of
        false ->
            {reply, {false, ?T("副本场景不存在!")}, State};
        DunScene ->
            IsEnter =
                case DunScene#dungeon_scene.enable of
                    true ->
                        {true, State};
                    false ->
                        AllMonCount =
                            State#st_dungeon.need_kill_num - State#st_dungeon.cur_kill_num,
                        case AllMonCount =< 0 of
                            true ->
                                %%开启副本进入
                                {true, State};
                            false ->
                                false
                        end
                end,
            case IsEnter of
                {true, State3} ->
                    case State#st_dungeon.inited of
                        true ->
                            {reply, {true, DunScene#dungeon_scene.sid}, State3};
                        false ->
                            State4 = init_dungeon(DunScene, State),
                            {reply, {true, DunScene#dungeon_scene.sid}, State4}
                    end;
                false ->
                    {reply, {false, ?T("击杀所有怪物才可以进入下一层!")}, State}
            end

    end;


handle_call({is_finish}, _From, State) ->
    {reply, State#st_dungeon.is_pass == ?DUNGEON_PASS, State};

handle_call(get_kindom_dungeon_info, _From, State) ->
    KindomDun = State#st_dungeon.dun_kindom,
    Res = [KindomDun#dun_kindom.kill_floor, KindomDun#dun_kindom.cur_floor, State#st_dungeon.kill_list],
    {reply, Res, State};

handle_call(_msg, _From, State) ->
    {reply, ok, State}.


handle_cast(_Msg, State) ->
    {noreply, State}.


%%副本杀怪
handle_info({kill_mon, _Mid, ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ARENA ->
    NewState = dungeon_kill:arena_kill(State, ShadowKey),
    {noreply, NewState};
handle_info({kill_mon, _Mid, ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_FIGHT ->
    NewState = dungeon_kill:guild_fight_kill(State, ShadowKey),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GOD_WEAPON ->
    NewState = dungeon_kill:god_weapon_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MATERIAL ->
    NewState = dungeon_kill:material_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_DAILY ->
    NewState = dungeon_kill:daily_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EXP ->
    NewState = dungeon_kill:exp_kill(State, Mid),
    {noreply, NewState};

handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
    NewState = dungeon_kill:jiandao_kill(State, Mid),
    [self() ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- State#st_dungeon.player_list],
    {noreply, NewState};

handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_NORMAL ->
    NewState = dungeon_kill:normal_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_TOWER ->
    NewState = dungeon_kill:tower_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD ->
    NewState = dungeon_kill:kindom_kill(State, Mid, Extra),
    {noreply, NewState};

handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_DEMON ->
    NewState = dungeon_kill:demon_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_VIP ->
    NewState = dungeon_kill:vip_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_CHANGE_CAREER ->
    NewState = dungeon_kill:change_career_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_FUWEN_TOWER ->
    NewState = dungeon_kill:fuwen_tower_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MARRY ->
    NewState = dungeon_kill:dun_marry_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUARD ->
    NewState = dungeon_kill:guard_kill(State, Mid, Extra),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EQUIP ->
    NewState = dungeon_kill:equip_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_XIAN ->
    NewState = dungeon_kill:xian_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GODNESS ->
    NewState = dungeon_kill:godness_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELEMENT ->
    NewState = dungeon_kill:element_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, Mid, _ShadowKey, _Extra}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELITE_BOSS ->
    NewState = dungeon_kill:elite_boss_kill(State, Mid),
    {noreply, NewState};
handle_info({kill_mon, _Mid, _ShadowKey}, State) ->
    {noreply, State};


%%刷新下一轮
handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EXP ->
    Round = State#st_dungeon.round + 1,
    DunId = data_dungeon_exp_round:get_scene(Round),
    NewState =
        if Round > State#st_dungeon.max_round orelse DunId == [] ->
            util:cancel_ref([State#st_dungeon.close_timer]),
            Ref = erlang:send_after(1000, self(), dungeon_finish),
            State#st_dungeon{close_timer = Ref};
            true ->
                [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
                util:cancel_ref([State#st_dungeon.close_timer]),
                Now = util:unixtime(),
                %%场景判断
                Dungeon = data_dungeon:get(DunId),
                %%副本结束定时器
                Time = data_dungeon_exp:get_time(Round),
                Ref = erlang:send_after(Time * 1000, self(), dungeon_finish),
                MonList = data_dungeon_exp:get(Round),
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    mon_agent:create_mon_cast([Mid, DunId, X, Y, Self, 1, [{group, 1}]])
                end,
                if State#st_dungeon.dungeon_id == DunId ->
                    lists:foreach(F, MonList);
                    true ->
                        scene_init:priv_stop_scene(State#st_dungeon.dungeon_id, Self),
                        scene_init:priv_create_scene(DunId, Self),
                        lists:foreach(F, MonList),
                        [X, Y] =
                            case data_dungeon_exp:get_revive(Round) of
                                [] ->
                                    Scene = data_scene:get(DunId),
                                    [Scene#scene.x, Scene#scene.y];
                            %%经验副本每一波出生点有差异
                                Revive -> Revive
                            end,
                        dungeon:dungeon_record(Dungeon, State#st_dungeon.player_list, Now),
                        [spawn(fun() ->
                            util:sleep(1000),
                            P#dungeon_mb.pid ! {change_scene, Dungeon#dungeon.id, Self, X, Y, false} end) || P <- State#st_dungeon.player_list]
                end,
                State1 = State#st_dungeon{
                    dungeon_id = DunId,
                    mon = [{Round, MonList}],
                    round = Round,
                    begin_time = Now,
                    end_time = Now + Time,
                    close_timer = Ref,
                    need_kill_num = length(MonList),
                    cur_kill_num = 0
                },
                [Self ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- State#st_dungeon.player_list],
                dungeon_record:set_history(self(), State1#st_dungeon.end_time),
                State1
        end,
    {noreply, NewState};
handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_DEMON ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Round = State#st_dungeon.round + 1,
    BaseDemon = data_dungeon_demon:get(Round),
    NewState =
        case BaseDemon == [] of
            true ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                State#st_dungeon{close_timer = Ref};
            false ->
                #base_dun_demon{
                    mon_list = RoundMonList,
                    dun_id = NewDunId,
                    time = Time
                } = BaseDemon,
                Reduce =
                    case State#st_dungeon.player_list of
                        [] -> 0;
                        [Mb | _] ->
                            #dungeon_mb{
                                pkey = Pkey
                            } = Mb,
                            case guild_demon:get_dun_round_reduce(Pkey, Round) of
                                0 -> 0;
                                R -> R / 100
                            end
                    end,
                ReduceArg =
                    case Reduce > 0 of
                        true -> [{hp, 1 - Reduce}, {def, 1 - Reduce}, {att, 1 - Reduce}];
                        false -> []
                    end,
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    _R = mon_agent:create_mon_cast([Mid, NewDunId, X, Y, Self, 1, [{group, 1} | ReduceArg]])
                end,
                Now = util:unixtime(),
                if
                    State#st_dungeon.dungeon_id == NewDunId ->
                        lists:foreach(F, RoundMonList);
                    true ->
                        scene_init:priv_stop_scene(State#st_dungeon.dungeon_id, Self),
                        scene_init:priv_create_scene(NewDunId, Self),
                        lists:foreach(F, RoundMonList),
                        NewBaseScene = data_scene:get(NewDunId),
                        dungeon:dungeon_record(data_dungeon:get(NewDunId), State#st_dungeon.player_list, Now),
                        [P#dungeon_mb.pid ! {change_scene, NewDunId, self(), NewBaseScene#scene.x, NewBaseScene#scene.y, false} || P <- State#st_dungeon.player_list]
                end,
                %%副本结束定时器
                Ref = erlang:send_after(Time * 1000, self(), dungeon_finish),
                KillList = dungeon:calc_kill_list(RoundMonList),

                StDun = State#st_dungeon{
                    dungeon_id = NewDunId,
                    cur_kill_num = 0,
                    need_kill_num = length(RoundMonList),
                    round = Round,
                    kill_list = KillList,
                    close_timer = Ref,
                    dun_demon = State#st_dungeon.dun_demon#dun_demon{
                        reduce = round(Reduce * 100)
                    },
                    end_time = Now + Time
                },
                [self() ! {dungeon_target, Mb1#dungeon_mb.sid} || Mb1 <- StDun#st_dungeon.player_list],
                StDun
        end,
    {noreply, NewState};
handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GOD_WEAPON ->
    Round = State#st_dungeon.round + 1,
    NewState =
        case data_dungeon_god_weapon:get_mon(State#st_dungeon.dungeon_id, Round) of
            [] ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                State#st_dungeon{close_timer = Ref};
            MonList ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Now = util:unixtime(),
                %%副本结束定时器
                Time = data_dungeon_god_weapon:get_time(State#st_dungeon.dungeon_id, Round),
                Ref = erlang:send_after(Time * 1000, self(), dungeon_finish),
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Self, 1, [{group, 1}]])
                end,
                lists:foreach(F, MonList),
                KillList = dungeon:calc_kill_list(MonList),
                State1 = State#st_dungeon{
                    mon = [{Round, MonList}],
                    round = Round,
                    begin_time = Now,
                    end_time = Now + Time,
                    close_timer = Ref,
                    need_kill_num = length(MonList),
                    cur_kill_num = 0,
                    kill_list = KillList
                },

                [Self ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- State#st_dungeon.player_list],
                dungeon_record:set_history(self(), State1#st_dungeon.end_time),
                State1
        end,
    {noreply, NewState};

handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
    Round = State#st_dungeon.round + 1,
    NewState =
        case data_dun_jiandao_mon:get(State#st_dungeon.dungeon_id, Round) of
            [] ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                State#st_dungeon{close_timer = Ref};
            MonList ->
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Self, 1, [{group, 1}]])
                end,
                lists:foreach(F, MonList),
                KillList = dungeon:calc_kill_list(MonList),
                State1 = State#st_dungeon{
                    mon = [{Round, MonList}],
                    round = Round,
                    need_kill_num = length(MonList),
                    cur_kill_num = 0,
                    kill_list = KillList
                },
                [Self ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- State#st_dungeon.player_list],
                dungeon_record:set_history(self(), State1#st_dungeon.end_time),
                State1
        end,
    {noreply, NewState};

handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELEMENT ->
    Round = State#st_dungeon.round + 1,
    NewState =
        case data_dun_element_mon:get(State#st_dungeon.dungeon_id, Round) of
            [] ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                State#st_dungeon{close_timer = Ref};
            MonList ->
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Self, 1, [{group, 1}]])
                end,
                lists:foreach(F, MonList),
                KillList = dungeon:calc_kill_list(MonList),
                State1 = State#st_dungeon{
                    mon = [{Round, MonList}],
                    round = Round,
                    need_kill_num = length(MonList),
                    cur_kill_num = 0,
                    kill_list = KillList
                },
                dungeon_record:set_history(self(), State1#st_dungeon.end_time),
                State1
        end,
    {noreply, NewState};

handle_info({next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MARRY ->
    Round = State#st_dungeon.round + 1,
    NewState =
        case data_dungeon_marry:get_mon(Round) of
            [] ->
                ProblemId = util:list_rand(data_dungeon_marry_problem:get_all()),
                DunProblem = #dun_problem{id = ProblemId},
                dungeon_marry:notice_problem(DunProblem, State#st_dungeon.player_list),
                State#st_dungeon{answer = DunProblem};
            MonList ->
                ?DEBUG("Round:~p", [Round]),
                Self = self(),
                F = fun({Mid, X, Y}) ->
                    DunPlayerList = State#st_dungeon.player_list,
                    if
                        DunPlayerList /= [] ->
                            {Time, K1, K2} = data_dungeon_marry:get_k(Round),
                            Att = lists:sum(lists:map(fun(#dungeon_mb{att = Att}) -> Att end, DunPlayerList)),
                            MonHpLim = round(Time * K1 * K2 * Att),
                            mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Self, 1, [{group, 1}, {hp_lim, MonHpLim}, {hp, MonHpLim}]]);
                        true ->
                            mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Self, 1, [{group, 1}]])
                    end
                end,
                lists:foreach(F, MonList),
                KillList = dungeon:calc_kill_list(MonList),
                State1 = State#st_dungeon{
                    mon = [{Round, MonList}],
                    round = Round,
                    need_kill_num = length(MonList),
                    cur_kill_num = 0,
                    kill_list = KillList
                },
                dungeon_record:set_history(self(), State1#st_dungeon.end_time),
                State1
        end,
    {noreply, NewState};

handle_info({next_round}, State) ->
    Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
    Round = State#st_dungeon.round + 1,
    NewState =
        case lists:keyfind(Round, 1, Dungeon#dungeon.mon) of
            false ->
                util:cancel_ref([State#st_dungeon.close_timer]),
                Ref = erlang:send_after(1000, self(), dungeon_finish),
                State#st_dungeon{close_timer = Ref};
            {_Round, RoundMonList} ->
                F = fun({Mid, X, Y}) ->
                    _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, self(), 1, [{group, 1}]])
                end,
                lists:foreach(F, RoundMonList),
                StDun = State#st_dungeon{cur_kill_num = 0, need_kill_num = length(RoundMonList), round = Round},
                StDun
        end,
    {noreply, NewState};

handle_info({time_to_next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD ->
    ?DEBUG("time_to_next_round ~n"),
    util:cancel_ref([State#st_dungeon.next_round_timer, State#st_dungeon.dun_kindom#dun_kindom.mon_notice_ref]),
    Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
    KindomDun = State#st_dungeon.dun_kindom,
    Floor = KindomDun#dun_kindom.cur_floor + 1,
    MaxFloor = data_dungeon_kindom_guard:get_max_floor(),
    MonNum = mon_agent:get_scene_mon_num_by_kind(State#st_dungeon.dungeon_id, self(), 0),
    MaxMonNum = 40,
    ?DO_IF(Floor == 1, kindom_guard_proc:get_act_pid() ! buff_notice_before_fight),
    if
        Floor > MaxFloor ->
            {noreply, State#st_dungeon{next_round_timer = 0}};
        MonNum > MaxMonNum ->  %%怪物太多，不做刷新
            BaseGuard = data_dungeon_kindom_guard:get(Floor),
            #base_kindom_dun{
                round_time = NextRoundTime
            } = BaseGuard,
            Ref = erlang:send_after(NextRoundTime * 1000, self(), {time_to_next_round}),
            MonRef = ?IF_ELSE(NextRoundTime > 10, erlang:send_after((NextRoundTime - 10) * 1000, self(), {kindom_mon_notice_ref}), 0),
            RoundTime = util:unixtime() + NextRoundTime,
            StDun = State#st_dungeon{
                dun_kindom = KindomDun#dun_kindom{mon_notice_ref = MonRef},
                next_round_timer = Ref,
                round_time = RoundTime
            },
            self() ! {dungeon_target, 0},
            {noreply, StDun};
        true ->
            BaseGuard = data_dungeon_kindom_guard:get(Floor),
            #base_kindom_dun{
                mon_list = RoundMonList,
                round_time = NextRoundTime
            } = BaseGuard,
            Args = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD, [{type, ?ATTACK_TENDENCY_MON}, {group, 1}, {wave, Floor}, {world_lv_mon, 1}], []),
            Copy = self(),
            F = fun({Mid, X, Y}) ->
                timer:sleep(30),
                _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Copy, 1, Args])
            end,
            spawn(fun() -> lists:foreach(F, RoundMonList) end),
            Ref = erlang:send_after(NextRoundTime * 1000, self(), {time_to_next_round}),
            MonRef = ?IF_ELSE(NextRoundTime > 10, erlang:send_after((NextRoundTime - 10) * 1000, self(), {kindom_mon_notice_ref}), 0),
            RoundTime = util:unixtime() + NextRoundTime,
            KillList = dungeon:calc_kill_list(RoundMonList),
            StDun = State#st_dungeon{
                kill_list = State#st_dungeon.kill_list ++ [{Floor, KillList}],
                dun_kindom = KindomDun#dun_kindom{cur_floor = Floor, mon_notice_ref = MonRef},
                next_round_timer = Ref,
                round_time = RoundTime
            },
            self() ! {dungeon_target, 0},
            {noreply, StDun}
    end;

%%
%% handle_info({time_to_next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_CROSS_GUARD ->
%%     ?DEBUG("time_to_next_round ~n"),
%%     util:cancel_ref([State#st_dungeon.next_round_timer, State#st_dungeon.dun_cross_guard#dun_cross_guard.mon_notice_ref]),
%%     Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
%%     CrossGuardDun = State#st_dungeon.dun_cross_guard,
%%     Floor = CrossGuardDun#dun_cross_guard.cur_floor + 1,
%%     MaxFloor = data_dungeon_cross_guard_floor:get_max_floor(),
%%     MonNum = mon_agent:get_scene_mon_num_by_kind(State#st_dungeon.dungeon_id, self(), 0),
%%     MaxMonNum = 40,
%% %%     ?DO_IF(Floor == 1, kindom_guard_proc:get_act_pid() ! buff_notice_before_fight),
%%     if
%%         Floor > MaxFloor ->
%%             {noreply, State#st_dungeon{next_round_timer = 0}};
%%         MonNum > MaxMonNum ->  %%怪物太多，不做刷新
%%             BaseGuard = data_dungeon_cross_guard_floor:get(Floor),
%%             #base_cross_guard_dun{
%%                 round_time = NextRoundTime
%%             } = BaseGuard,
%%             Ref = erlang:send_after(NextRoundTime * 1000, self(), {time_to_next_round}),
%%             MonRef = ?IF_ELSE(NextRoundTime > 10, erlang:send_after((NextRoundTime - 10) * 1000, self(), {cross_guard_mon_notice_ref}), 0),
%%             RoundTime = util:unixtime() + NextRoundTime,
%%             StDun = State#st_dungeon{
%%                 dun_kindom = CrossGuardDun#dun_cross_guard{mon_notice_ref = MonRef},
%%                 next_round_timer = Ref,
%%                 round_time = RoundTime
%%             },
%%             self() ! {dungeon_target, 0},
%%             {noreply, StDun};
%%         true ->
%%             BaseGuard = data_dungeon_cross_guard_floor:get(Floor),
%%             #base_kindom_dun{
%%                 mon_list = RoundMonList,
%%                 round_time = NextRoundTime
%%             } = BaseGuard,
%%             Args = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_CROSS_GUARD, [{type, ?ATTACK_TENDENCY_MON}, {group, 1}, {wave, Floor}, {world_lv_mon, 1}], []),
%%             Copy = self(),
%%             F = fun({Mid, X, Y}) ->
%%                 timer:sleep(30),
%%                 _R = mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, Copy, 1, Args])
%%             end,
%%             spawn(fun() -> lists:foreach(F, RoundMonList) end),
%%             Ref = erlang:send_after(NextRoundTime * 1000, self(), {time_to_next_round}),
%%             MonRef = ?IF_ELSE(NextRoundTime > 10, erlang:send_after((NextRoundTime - 10) * 1000, self(), {cross_guard_mon_notice_ref}), 0),
%%             RoundTime = util:unixtime() + NextRoundTime,
%%             KillList = dungeon:calc_kill_list(RoundMonList),
%%             StDun = State#st_dungeon{
%%                 kill_list = State#st_dungeon.kill_list ++ [{Floor, KillList}],
%%                 dun_kindom = CrossGuardDun#dun_cross_guard{cur_floor = Floor, mon_notice_ref = MonRef},
%%                 next_round_timer = Ref,
%%                 round_time = RoundTime
%%             },
%%             self() ! {dungeon_target, 0},
%%             {noreply, StDun}
%%     end;

handle_info({time_to_next_round}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUARD ->
    ?DEBUG("time_to_next_round ~n"),
    util:cancel_ref([State#st_dungeon.next_round_timer]),
    Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
    GuardDun = State#st_dungeon.dun_guard,
    Floor = GuardDun#dun_guard.round + 1,
    MaxFloor = data_dungeon_guard:get_max_floor(),
    if
        Floor > MaxFloor ->
            {noreply, State#st_dungeon{next_round_timer = 0}};
        true ->
            RoundMonList = data_dungeon_guard:get_mon(Floor),
            Args = ?IF_ELSE(Dungeon#dungeon.type == ?DUNGEON_TYPE_GUARD, [{ai, 1}, {group, 1}, {wave, Floor}], []),
%%             F0 = fun() ->
%%                 F = fun({Mid, X, Y}) ->
%%                     util:sleep(500),
%%                     mon_agent:create_mon_cast([Mid, State#st_dungeon.dungeon_id, X, Y, self(), 1, Args])
%%                 end
%%             end,
%%             lists:foreach(F, RoundMonList),
            Did = self(),
            spawn(fun() -> dungeon_guard:create_mon(State, Args, RoundMonList, Did) end),
            Ref = erlang:send_after(Dungeon#dungeon.round_time * 1000, self(), {time_to_next_round}),
            RoundTime = util:unixtime() + Dungeon#dungeon.round_time,
            KillList = dungeon:calc_kill_list(RoundMonList),
            StDun = State#st_dungeon{
                kill_list = State#st_dungeon.kill_list ++ [{Floor, KillList}],
                dun_guard = GuardDun#dun_guard{round = Floor},
                next_round_timer = Ref,
                round_time = RoundTime
            },
            [erlang:send_after(10, self(), {dungeon_target, Mb#dungeon_mb.pid}) || Mb <- StDun#st_dungeon.player_list],
            [erlang:send_after(10, Mb#dungeon_mb.pid, {guard_notice, Floor}) || Mb <- StDun#st_dungeon.player_list],
            {noreply, StDun}
    end;

%%handle_info({try_again, Pid, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MATERIAL ->
%%    [monster:stop_broadcast(MonPid) || MonPid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
%%    util:cancel_ref([State#st_dungeon.close_timer]),
%%    Now = util:unixtime(),
%%    Dungeon = data_dungeon:get(State#st_dungeon.dungeon_id),
%%    %%副本结束定时器
%%    Ref = erlang:send_after(Dungeon#dungeon.time * 1000, self(), dungeon_finish),
%%    Round = 1,
%%    {NeedKill, KillList} = dungeon:create_mon_cast(Dungeon#dungeon.type, State#st_dungeon.dungeon_id, Round, State#st_dungeon.mon, 1),
%%    NewState = State#st_dungeon{
%%        round = Round,
%%        begin_time = Now,
%%        end_time = Now + Dungeon#dungeon.time,
%%        close_timer = Ref,
%%        need_kill_num = NeedKill,
%%        cur_kill_num = 0,
%%        kill_list = KillList,
%%        is_pass = 0,
%%        is_reward = 0,
%%        exp = 0,
%%        coin = 0,
%%        goods_list = []
%%    },
%%    Scene = data_scene:get(State#st_dungeon.dungeon_id),
%%    [X, Y] = ?IF_ELSE(Dungeon#dungeon.point == [], [Scene#scene.x, Scene#scene.y], Dungeon#dungeon.point),
%%    Pid ! {change_scene, Dungeon#dungeon.id, self(), X, Y, false},
%%    KillList1 = [[mon_util:get_mon_name(Mid), Cur, Need] || {Mid, Need, Cur} <- NewState#st_dungeon.kill_list],
%%    {ok, Bin} = pt_121:write(12171, {Dungeon#dungeon.time, KillList1}),
%%    server_send:send_to_sid(Sid, Bin),
%%    dungeon_record:set_history(self(), NewState#st_dungeon.end_time),
%%    {noreply, NewState};
handle_info({try_again, _, _}, State) ->
    {noreply, State};

%%获得经验
handle_info({exp, Exp}, State) ->
    NewState = State#st_dungeon{exp = State#st_dungeon.exp + Exp},
    {noreply, NewState};

%%获得银币
handle_info({coin, Coin}, State) ->
    NewState = State#st_dungeon{coin = State#st_dungeon.coin + Coin},
    {noreply, NewState};

%%获得物品
handle_info({goods, GoodsList}, State) ->
    NewState = State#st_dungeon{goods_list = State#st_dungeon.goods_list ++ GoodsList},
    {noreply, NewState};

handle_info(jiandao_dungeon_target, State) ->
    [self() ! {dungeon_target, DungeonPlayer#dungeon_mb.sid} || DungeonPlayer <- State#st_dungeon.player_list],
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MATERIAL ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    {ok, Bin} = pt_121:write(12171, {LeftTime, State#st_dungeon.first_pass}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};
handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GOD_WEAPON ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    PackKillList = [tuple_to_list(Item) || Item <- State#st_dungeon.kill_list],
    DunGodWeapon = State#st_dungeon.dun_god_weapon,
    Layer = data_dungeon_god_weapon:scene2layer(State#st_dungeon.dungeon_id),
    IsFirst =
        case dungeon_god_weapon:is_first_pass(Layer, State#st_dungeon.round, DunGodWeapon#dun_god_weapon.layer_h, DunGodWeapon#dun_god_weapon.round_h) of
            true -> 1;
            false -> 0
        end,
    {ok, Bin} = pt_121:write(12151, {LeftTime, State#st_dungeon.round, State#st_dungeon.max_round, IsFirst, PackKillList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
    #st_dungeon{
        round = Round,
        cur_kill_num = CurKillNum,
        need_kill_num = NeedKillNum,
        dun_jiandao = DunJiandao
    } = State,
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    Score = DunJiandao#dun_jiandao.score,
    {ok, Bin} = pt_133:write(13304, {Round, CurKillNum, NeedKillNum, LeftTime, Score}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EXP ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    case data_dungeon_exp_round:get_round(State#st_dungeon.dungeon_id) of
        [] ->
            MaxRound = State#st_dungeon.max_round;
        [_, MaxRound] -> ok
    end,
    {ok, Bin} = pt_121:write(12132, {LeftTime, State#st_dungeon.round, MaxRound, State#st_dungeon.exp}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};
handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_DAILY ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    {ok, Bin} = pt_121:write(12142, {LeftTime, State#st_dungeon.first_pass}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_VIP ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    KillList = [[mon_util:get_mon_name(Mid), Cur, Need] || {Mid, Need, Cur} <- State#st_dungeon.kill_list],
    {ok, Bin} = pt_121:write(12164, {LeftTime, KillList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_TOWER ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    Base = data_dungeon_tower:get(State#st_dungeon.dungeon_id),
    {ok, Bin} = pt_121:write(12123, {LeftTime, Base#base_dun_tower.layer}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};
handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD ->
    Now = util:unixtime(),
    #st_dungeon{
        dun_kindom = DunKindom,
        round_time = RoundTime,
        begin_time = StartTime
    } = State,
    NextRoundTime = max(0, RoundTime - Now),
    EndTime = ?KINDOM_GUARD_OPEN_TIME,
    LeaveTime = max(0, StartTime + EndTime - Now),
    #dun_kindom{
        cur_floor = CurFloor
    } = DunKindom,
    MaxFloor = data_dungeon_kindom_guard:get_max_floor(),
    GoodsList =
        case data_dungeon_kindom_guard:get(CurFloor) of
            [] -> [];
            Base -> [tuple_to_list(Info) || Info <- Base#base_kindom_dun.goods_list]
        end,
    BuffList1 =
        case ?CALL(kindom_guard_proc:get_act_pid(), get_buff_info) of
            [] -> [];
            BuffList -> BuffList
        end,
    {ok, Bin} = pt_122:write(12223, {CurFloor, MaxFloor, GoodsList, NextRoundTime, LeaveTime, BuffList1}),
    case Sid == 0 of
        true -> server_send:send_to_scene(State#st_dungeon.dungeon_id, self(), Bin);
        false -> server_send:send_to_sid(Sid, Bin)
    end,
    {noreply, State};
handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_DEMON ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    #st_dungeon{
        round = Round,
        max_round = MaxRound,
        exp = Exp,
        dun_demon = #dun_demon{
            pass_num = PassNumList,
            reduce = Reduce,
            add = Add
        },
        kill_list = KillList
    } = State,
    PassNum =
        case lists:keyfind(Round, 1, PassNumList) of
            false -> 0;
            {_, PassNum0} -> PassNum0
        end,
    BaseDemon = data_dungeon_demon:get(Round),
    #base_dun_demon{
        exp = RoundExp
    } = BaseDemon,
    MonList = [tuple_to_list(I) || I <- KillList],
    {ok, Bin} = pt_122:write(12230, {Round, MaxRound, PassNum, Reduce, LeftTime, Add, MonList, RoundExp, Exp}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_VIP ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    KillList = [[mon_util:get_mon_name(Mid), Cur, Need] || {Mid, Need, Cur} <- State#st_dungeon.kill_list],
    {ok, Bin} = pt_121:write(12164, {LeftTime, KillList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ARENA ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    F = fun(DunArena) ->
        [DunArena#dun_arena.pkey, DunArena#dun_arena.nickname, DunArena#dun_arena.career, DunArena#dun_arena.sex,
            DunArena#dun_arena.avatar, DunArena#dun_arena.hp_lim, DunArena#dun_arena.cbp]
    end,
    InfoList = lists:map(F, State#st_dungeon.dun_arena),

    {ok, Bin} = pt_230:write(23012, {LeftTime, InfoList}),
    server_send:send_to_sid(Sid, Bin),

    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_FIGHT ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    F = fun(DunArena) ->
        [DunArena#dun_arena.pkey, DunArena#dun_arena.nickname, DunArena#dun_arena.career, DunArena#dun_arena.sex,
            DunArena#dun_arena.avatar, DunArena#dun_arena.hp_lim, DunArena#dun_arena.cbp]
    end,
    InfoList = lists:map(F, State#st_dungeon.dun_arena),
    {ok, Bin} = pt_447:write(44706, {LeftTime, InfoList}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};

handle_info({dungeon_target, SendType}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUARD ->
    dungeon_guard:dungeon_target(State, SendType),
    {noreply, State};

handle_info({dungeon_target, Sid}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EQUIP ->
    Now = util:unixtime(),
    LeftTime = max(0, State#st_dungeon.end_time - Now),
    {ok, Bin} = pt_127:write(12702, {LeftTime}),
    server_send:send_to_sid(Sid, Bin),
    {noreply, State};
handle_info({dungeon_target, [_Sid, _Cmd]}, State) ->
    {noreply, State};

%%玩家离线处理
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ARENA ->
    F = fun(DunPlayer) ->
        if DunPlayer#dungeon_mb.type == ?DUN_MB_TYPE_SYS -> ok;
            true ->
                case player_util:get_player(DunPlayer#dungeon_mb.pkey) of
                    [] -> ok;
                    Player ->
                        dungeon_record:erase(DunPlayer#dungeon_mb.pkey),
                        reward(State, Player)
                end
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
%%清除场景怪物
    [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
    {stop, normal, State};
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_FUWEN_TOWER ->
    {stop, normal, State};
%%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_NORMAL ->
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GOD_WEAPON ->
    {stop, normal, State};
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUARD ->
    {stop, normal, State};
%% handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MARRY ->
%%     {stop, normal, State};
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_XIAN ->
    {stop, normal, State};
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GODNESS ->
    {stop, normal, State};
handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELEMENT ->
    {stop, normal, State};
%% handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELITE_BOSS ->
%%     {stop, normal, State};
%% %%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_NORMAL ->
%%    {stop, normal, State};
%%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MATERIAL ->
%%    {stop, normal, State};
%%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_TOWER ->
%%    {stop, normal, State};
%%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_EXP ->
%%    {stop, normal, State};
%%handle_info({logout, _Pkey}, State) when State#st_dungeon.type == ?DUNGEON_TYPE_DAILY ->
%%    {stop, normal, State};
handle_info({logout, _Pkey}, State) ->
    {noreply, State};


%%handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ARENA ->
%%    util:cancel_ref([State#st_dungeon.close_timer]),
%%    Ref = erlang:send_after(1000, self(), dungeon_finish),
%%    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_FUWEN_TOWER ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_TOWER ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_DEMON ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_MARRY ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_CHANGE_CAREER ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_XIAN ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_GODNESS ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) when State#st_dungeon.type == ?DUNGEON_TYPE_ELEMENT ->
    util:cancel_ref([State#st_dungeon.close_timer]),
    Ref = erlang:send_after(1000, self(), dungeon_finish),
    {noreply, State#st_dungeon{close_timer = Ref}};
handle_info(role_die, State) ->
    {noreply, State};

%%王城守卫,玩家进入副本
handle_info({enter_kindom_guard, Mb}, State) ->
    #st_dungeon{
        player_list = PlayerList
    } = State,
    NewPlayerList = [Mb | lists:keydelete(Mb#dungeon_mb.pkey, #dungeon_mb.pkey, PlayerList)],
    NewState = State#st_dungeon{
        player_list = NewPlayerList
    },
    List = [M#dungeon_mb.pkey || M <- NewPlayerList],
%%同步副本信息
    kindom_guard_proc:get_act_pid() ! {sync_dun_data, self(), List, State#st_dungeon.dun_kindom#dun_kindom.cur_floor, Mb#dungeon_mb.pid},
    {noreply, NewState};

%%登陆返回副本
handle_info({back, Pkey, Pid}, State) ->
    case lists:keyfind(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list) of
        false ->
            {noreply, State};
        DunPlayer ->
            NewDunPlayer = DunPlayer#dungeon_mb{pid = Pid},
            PlayerList = lists:keyreplace(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list, NewDunPlayer),
            {noreply, State#st_dungeon{player_list = PlayerList}}
    end;

%% 传出副本，不可重新进入
handle_info({quit, Player}, State) ->
    case lists:keyfind(Player#player.key, #dungeon_mb.pkey, State#st_dungeon.player_list) of
        false ->
            {noreply, State};
        DunPlayer ->
            sent_out(State#st_dungeon.dungeon_id, Player#player.pid, DunPlayer),
            reward(State, Player),
            dungeon_record:erase(Player#player.key),
            State2 = State#st_dungeon{player_list = lists:keydelete(Player#player.key, #dungeon_mb.pkey, State#st_dungeon.player_list)},
            dungeon_util:log_dungeon(DunPlayer#dungeon_mb.pkey, DunPlayer#dungeon_mb.nickname, State#st_dungeon.dungeon_id, State#st_dungeon.type, State#st_dungeon.is_pass, [], util:unixtime()),
            ?IF_ELSE(State#st_dungeon.is_pass == 1, drop_scene:dungeon_pickup(State#st_dungeon.dungeon_id, self(), Player#player.key), ok),
%%副本没人，则关闭副本
            if State2#st_dungeon.player_list == [] ->
                [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, self())],
                {stop, normal, State2};
                true ->
                    {noreply, State2}
            end
    end;

%% 传出副本，可以重进入
handle_info({out, Pkey}, State) ->
    case lists:keyfind(Pkey, #dungeon_mb.pkey, State#st_dungeon.player_list) of
        false ->
            {noreply, State};
        DunPlayer ->
            case player_util:get_player(Pkey) of
                [] -> ok;
                Player ->
                    sent_out(State#st_dungeon.dungeon_id, Player#player.pid, DunPlayer),
                    {noreply, State}
            end
    end;

handle_info(dungeon_finish, State) ->
    ?DEBUG("dungeon_finish", []),
    util:cancel_ref([State#st_dungeon.close_timer, State#st_dungeon.next_round_timer]),
    %%竞技场结算
    if
        State#st_dungeon.type == ?DUNGEON_TYPE_ARENA andalso State#st_dungeon.is_reward == 0 ->
            [DunArena1, DunArena2] = State#st_dungeon.dun_arena,
            arena_proc:get_server_pid() ! {arena_challenge_ret, DunArena1#dun_arena.pkey, DunArena1#dun_arena.nickname, DunArena2#dun_arena.pkey, DunArena2#dun_arena.nickname, State#st_dungeon.is_pass};
        true -> ok
    end,

    if
        State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_FIGHT andalso State#st_dungeon.is_reward == 0 ->
            [DunArena3, DunArena4] = State#st_dungeon.dun_arena,
            guild_fight_proc:get_server_pid() ! {guild_fight_challenge_ret, DunArena3#dun_arena.pkey, DunArena3#dun_arena.nickname, DunArena4#dun_arena.pkey, DunArena4#dun_arena.nickname, State#st_dungeon.is_pass};
        true -> ok
    end,

    if
        State#st_dungeon.type == ?DUNGEON_TYPE_JIANDAO ->
            #st_dungeon{player_list = [DunMb |_], dun_jiandao = DunJiandao, dungeon_id = DungeonId} = State,
            #dungeon_mb{pid = Pid} = DunMb,
            Pid ! {dun_jiandao_ret, DungeonId, DunJiandao#dun_jiandao.score, DunJiandao#dun_jiandao.mult},
            ok;
        true -> ok
    end,

    F = fun(DunPlayer) ->
        if DunPlayer#dungeon_mb.type == ?DUN_MB_TYPE_SYS ->
            ok;
            true ->
                case player_util:get_player(DunPlayer#dungeon_mb.pkey) of
                    [] -> ok;
                    Player ->
                        dungeon_record:erase(DunPlayer#dungeon_mb.pkey),
                        reward(State, Player),
                        ok
                end
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    %%清除场景怪物
    Self = self(),
    if
        State#st_dungeon.type == ?DUNGEON_TYPE_ARENA orelse State#st_dungeon.type == ?DUNGEON_TYPE_GUILD_FIGHT ->
            spawn(fun() ->
                util:sleep(3000),
                [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, Self)] end);
        true ->
            [monster:stop_broadcast(Pid) || Pid <- mon_agent:get_scene_mon_pids(State#st_dungeon.dungeon_id, Self)]
    end,

    CloseTime =
        if
%%            State#st_dungeon.type == ?DUNGEON_TYPE_ARENA -> 10;
            State#st_dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD -> 100;
            true -> 16 * 1000
        end,
    Ref = erlang:send_after(CloseTime, self(), {close_dungeon}),
    if
        State#st_dungeon.type == ?DUNGEON_TYPE_KINDOM_GUARD ->
            Copy = self(),
            kindom_guard_proc:get_act_pid() ! {dungeon_end, Copy};
        true -> skip
    end,
    {noreply, State#st_dungeon{is_reward = 1, close_timer = Ref}};


%%副本超时，关闭处理
handle_info({close_dungeon}, State) ->
    F = fun(DunPlayer) ->
        if DunPlayer#dungeon_mb.type == ?DUN_MB_TYPE_SYS ->
            ok;
            DunPlayer#dungeon_mb.type == ?DUN_MB_TYPE_NORMAL ->
                ?IF_ELSE(State#st_dungeon.is_pass == 1, drop_scene:dungeon_pickup(State#st_dungeon.dungeon_id, self(), DunPlayer#dungeon_mb.pkey), ok),
                case ets:lookup(?ETS_ONLINE, DunPlayer#dungeon_mb.pkey) of
                    [] ->
                        ok;
                    [Online] ->
                        sent_out(State#st_dungeon.dungeon_id, Online#ets_online.pid, DunPlayer)
                end;
            true -> skip
        end
    end,
    lists:foreach(F, State#st_dungeon.player_list),
    ?DEBUG("dungeon close ~p~n", [State#st_dungeon.dungeon_id]),
    {stop, normal, State};

%%王城守卫刷怪通知
handle_info({kindom_mon_notice_ref}, State) ->
    kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, self(), State#st_dungeon.dun_kindom#dun_kindom.cur_floor + 1, 10),
    {noreply, State};
%%王城守卫活动结束
handle_info({kindom_finish, KindomState}, State) ->
    util:cancel_ref([State#st_dungeon.close_timer, State#st_dungeon.dun_kindom#dun_kindom.mon_notice_ref, State#st_dungeon.next_round_timer]),
    kindom_guard:mon_refresh_notice(?SCENE_ID_KINDOM_GUARD_ID, self(), KindomState, 30),
%%清除攻击怪
    MonList = mon_agent:get_scene_mon_by_kind(?SCENE_ID_KINDOM_GUARD_ID, self(), ?MON_KIND_KINDOM_GUARD),
    [Mon#mon.pid ! clear_broadcast || Mon <- MonList],
    erlang:send_after(30 * 1000, self(), dungeon_finish),
    {noreply, State};


handle_info({dun_marry, get_dun_task_info, Sid, Lv}, State) ->
    dungeon_marry:send_to_client(Lv, Sid, State),
    {noreply, State};
handle_info({dun_marry, answer, Pkey, Id, Result}, State) ->
    NewState = dungeon_marry:answer_client(Pkey, Id, Result, State),
    util:cancel_ref([NewState#st_dungeon.close_timer]),
    Ref = erlang:send_after(20 * 1000, self(), dungeon_finish),
    {noreply, NewState#st_dungeon{close_timer = Ref}};

handle_info({dun_marry, collect_mon, MonId}, State) ->
    AllId = data_dungeon_marry_collect:get_all(),
    NewState =
        if
            length(State#st_dungeon.collect_list) > length(AllId) -> State;
            true -> State#st_dungeon{collect_list = [MonId | State#st_dungeon.collect_list]}
        end,
    F = fun(#dungeon_mb{sid = Sid, lv = Lv}) ->
        self() ! {dun_marry, get_dun_task_info, Sid, Lv}
    end,
    lists:map(F, State#st_dungeon.player_list),
    {noreply, NewState};
handle_info(notice_problem, State) ->
    ProblemId = util:list_rand(data_dungeon_marry_problem:get_all()),
    DunProblem = #dun_problem{id = ProblemId},
    dungeon_marry:notice_problem(DunProblem, State#st_dungeon.player_list),
    NewState = State#st_dungeon{answer = DunProblem},
    {noreply, NewState};

handle_info(tttt, State) ->
    io:format("##### ~p~n", [State#st_dungeon.dun_kindom#dun_kindom.kill_floor]),
    {noreply, State};

handle_info(_Msg, State) ->
    ?DEBUG("_Msg:~p", [_Msg]),
    {noreply, State}.

%%副本奖励处理
reward(StDun, Player) when StDun#st_dungeon.is_reward == 0 ->
    case StDun#st_dungeon.type of
        ?DUNGEON_TYPE_MATERIAL ->
            Player#player.pid ! {dungeon_material_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_GOD_WEAPON ->
            Player#player.pid ! {dungeon_god_weapon_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.round, StDun#st_dungeon.goods_list};
        ?DUNGEON_TYPE_VIP ->
            Player#player.pid ! {dungeon_vip_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_TOWER ->
            UseTime = util:unixtime() - StDun#st_dungeon.begin_time,
            Player#player.pid ! {dun_tower_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass, UseTime};
        ?DUNGEON_TYPE_EXP ->
            Player#player.pid ! {dungeon_exp_ret, StDun#st_dungeon.dungeon_id, max(StDun#st_dungeon.round, StDun#st_dungeon.dun_exp#dun_exp.round_min), StDun#st_dungeon.goods_list};
        ?DUNGEON_TYPE_DAILY ->
            Player#player.pid ! {dun_daily_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_GUILD_DEMON ->
            Player#player.pid ! {dungeon_guild_demon_ret, StDun#st_dungeon.is_pass, StDun#st_dungeon.goods_list ++ [{10108, StDun#st_dungeon.exp}], StDun#st_dungeon.round};
        ?DUNGEON_TYPE_FUWEN_TOWER ->
            Player#player.pid ! {dungeon_fuwen_tower_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_GUARD ->
            Player#player.pid ! {dun_guard_ret, StDun#st_dungeon.is_pass, StDun#st_dungeon.dun_guard#dun_guard.kill_floor, StDun#st_dungeon.goods_list};
        ?DUNGEON_TYPE_MARRY ->
            Player#player.pid ! {dungeon_marry_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass, StDun#st_dungeon.collect_list, StDun#st_dungeon.answer};
        ?DUNGEON_TYPE_CHANGE_CAREER ->
            Player#player.pid ! {dungeon_change_career_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_EQUIP ->
            Player#player.pid ! {dun_equip_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_XIAN ->
            Player#player.pid ! {dun_xian_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_GODNESS ->
            Player#player.pid ! {dun_godness_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_ELEMENT ->
            Player#player.pid ! {dun_element_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        ?DUNGEON_TYPE_ELITE_BOSS ->
            Player#player.pid ! {dun_elite_boss_ret, StDun#st_dungeon.dungeon_id, StDun#st_dungeon.is_pass};
        _ ->
            ok
    end,
    if StDun#st_dungeon.is_pass == 1 ->
        spawn(fun() ->
            BaseDun = data_dungeon:get(StDun#st_dungeon.dungeon_id),
            notice_sys:add_notice(dungeon_pass, [Player, BaseDun#dungeon.name, StDun#st_dungeon.dungeon_id]) end),
        ?DO_IF(StDun#st_dungeon.type /= ?DUNGEON_TYPE_EXP, task_event:task_event(?TASK_ACT_DUNGEON, {StDun#st_dungeon.dungeon_id, 1}, Player#player.pid));
        true -> skip
    end,
%%称号、7天目标等通关处理
    if
        StDun#st_dungeon.is_pass == 1 ->
            Player#player.pid ! {succeed_pass_dungeon, StDun#st_dungeon.type, [StDun#st_dungeon.dungeon_id]};
        true ->
            skip
    end,
    ok;
reward(_StDun, _Player) -> skip.

%%初始化处理
init_dungeon(_DunScene, State) ->
    State.

%%传出副本
sent_out(DunId, Pid, DunPlayer) ->
    DunCopy = self(),
    ?DEBUG("DunPlayer#dungeon_mb.copy:~p, DunPlayer#dungeon_mb.scene:~p, DunPlayer#dungeon_mb.x:~p, DunPlayer#dungeon_mb.y:~p",
        [DunPlayer#dungeon_mb.copy, DunPlayer#dungeon_mb.scene, DunPlayer#dungeon_mb.x, DunPlayer#dungeon_mb.y]),
    Pid ! {quit_dungeon_scene, DunId, DunCopy, DunPlayer#dungeon_mb.scene, DunPlayer#dungeon_mb.copy, DunPlayer#dungeon_mb.x, DunPlayer#dungeon_mb.y, 0}.


%%====================================kill mon end ========================================

